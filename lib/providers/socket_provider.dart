import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/network/socket_service.dart';
import '../core/utils/constants.dart';
import 'repository_providers.dart';
import 'game_state_provider.dart';
import 'simulation_access_provider.dart';
import 'team_provider.dart';

/// One `team:module_advanced` push: the team leader moved the team on, or the facilitator
/// parked every team on a round's results (nextModule == 'dashboard'). Server payload:
/// { teamId, previousModule, nextModule, roundNum } (team-progression.ts, facilitator.ts).
class TeamModuleAdvance {
  final String teamId;
  final String? previousModule;
  final String nextModule;
  final int? roundNum;
  final DateTime receivedAt;

  TeamModuleAdvance({
    required this.teamId,
    this.previousModule,
    required this.nextModule,
    this.roundNum,
    DateTime? receivedAt,
  }) : receivedAt = receivedAt ?? DateTime.now();

  /// 'dashboard' means the round is over for this team: it belongs on the results screen.
  bool get toDashboard => nextModule == 'dashboard';

  static TeamModuleAdvance? fromJson(dynamic data) {
    if (data is! Map) return null;
    final next = data['nextModule']?.toString();
    if (next == null || next.isEmpty) return null;
    return TeamModuleAdvance(
      teamId: data['teamId']?.toString() ?? '',
      previousModule: data['previousModule']?.toString(),
      nextModule: next,
      roundNum: (data['roundNum'] as num?)?.toInt(),
    );
  }
}

/// Manages Socket.IO connection lifecycle and event routing
class SocketManager {
  final SocketService _socket;
  final Ref _ref;
  final List<StreamSubscription> _subscriptions = [];

  SocketManager(this._socket, this._ref);

  void connect({String? teamId}) {
    // Cancel old listeners before reconnecting
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
    // Same host as the REST client: the server picks the cohort from the handshake Host,
    // so a cohort subdomain selected at runtime must reach the socket too.
    final apiBase = _ref.read(apiClientProvider).baseUrl;
    final origin = apiBase.endsWith(AppConstants.apiPrefix)
        ? apiBase.substring(0, apiBase.length - AppConstants.apiPrefix.length)
        : apiBase;
    _socket.connect(teamId: teamId, origin: origin);
    _setupListeners();
  }

  static Map<String, dynamic>? _asMap(dynamic data) =>
      data is Map ? Map<String, dynamic>.from(data) : null;

  void _setMemberCount(dynamic data) {
    final count = (_asMap(data)?['memberCount'] as num?)?.toInt();
    if (count != null) _ref.read(teamMemberCountProvider.notifier).state = count;
  }

  void _listen(String event, void Function(dynamic data) handler) {
    _subscriptions.add(_socket.on<dynamic>(event).listen(handler));
  }

  // Only events the server really emits are handled (see SocketService.serverEvents).
  // Payloads are the route's object plus a `timestamp` added by broadcastToTeam/ToAll.
  void _setupListeners() {
    // shock:triggered { shock } — to the cohort, or to one team's room. Market shocks are
    // a corporate-mode mechanic: the server zeroes every shock row when it computes a
    // self-paced learner's financials, so they are not surfaced there (website parity).
    _listen('shock:triggered', (data) {
      final shock = _asMap(_asMap(data)?['shock']);
      if (shock == null || _ref.read(teamProvider).selectedTeam == null) return;
      final id = (shock['id'] ?? shock['shockId'])?.toString();
      final current = _ref.read(activeShocksProvider);
      if (id != null &&
          current.any((s) => (s['id'] ?? s['shockId'])?.toString() == id)) {
        return;
      }
      _ref.read(activeShocksProvider.notifier).state = [...current, shock];
    });

    // Presence: team:joined (to me), team:member_joined / team:member_left (to the room),
    // each carrying { memberCount }.
    _listen('team:joined', _setMemberCount);
    _listen('team:member_joined', _setMemberCount);
    _listen('team:member_left', _setMemberCount);

    // decision:updated is relayed for every teammate's amount edit as well as for the
    // server's own confirm ({ decisions: { confirmed: true } }) and unlock
    // ({ decisions: { unlocked: true } }) broadcasts. Only the latter two change anything
    // the round state carries, so only they refetch it (no refetch per keystroke).
    _listen('decision:updated', (data) {
      final decisions = _asMap(_asMap(data)?['decisions']);
      if (decisions == null) return;
      if (decisions['confirmed'] == true || decisions['unlocked'] == true) {
        _ref.read(gameStateProvider.notifier).fetchGameState();
      }
    });

    // Facilitator reset the game: refresh round state and teams, drop stale shocks.
    _listen('facilitator:game_reset', (_) {
      _ref.read(gameStateProvider.notifier).fetchGameState();
      _ref.read(activeShocksProvider.notifier).state = [];
      _ref.read(teamProvider.notifier).fetchTeams();
    });

    // facilitator:simulation_access { open } — the corporate simulation gate.
    _listen('facilitator:simulation_access', (data) {
      final open = _asMap(data)?['open'];
      if (open is bool) _ref.read(simulationAccessProvider.notifier).state = open;
    });

    // Team module advanced: follow the team to its next module (website 82b7b96), or to
    // the results dashboard when nextModule is 'dashboard' (Operating confirmed by the
    // leader, or the facilitator parked every team on results, website 5fcc4ee). The
    // simulation screen listens to [teamModuleAdvanceProvider] and moves the tab/route.
    _subscriptions.add(
      _socket.on<dynamic>('team:module_advanced').listen((data) {
        _ref.read(gameStateProvider.notifier).fetchGameState();
        final advance = TeamModuleAdvance.fromJson(data);
        if (advance == null) return;
        final team = _ref.read(teamProvider).selectedTeam;
        if (team == null) return;
        if (advance.teamId.isNotEmpty && advance.teamId != team.id) return;
        // Keep the cached team in step so screens reading team.currentModule agree.
        // 'dashboard' is a destination, not a decision module: the cached module stays as
        // it was (team.currentModule feeds the simulation's tab/progress index).
        if (!advance.toDashboard) {
          _ref.read(teamProvider.notifier).updateTeamFromSocket(team
              .copyWith(
                currentModule: advance.nextModule,
                currentRound: advance.roundNum,
              )
              .toJson());
        }
        _ref.read(teamModuleAdvanceProvider.notifier).state = advance;
      }),
    );

    // Facilitator moved/locked modules for everyone: refresh the round state.
    _subscriptions.add(
      _socket.on<dynamic>('facilitator:module_changed').listen((_) {
        _ref.read(gameStateProvider.notifier).fetchGameState();
      }),
    );
    _subscriptions.add(
      _socket.on<dynamic>('round:updated').listen((_) {
        _ref.read(gameStateProvider.notifier).fetchGameState();
      }),
    );

    // Corporate simulation gate flipped by the facilitator (or closed by a
    // game reset): the waiting screen clears or the simulation locks at once,
    // ahead of the next poll.
    _subscriptions.add(
      _socket.on<dynamic>('facilitator:simulation_access').listen((data) {
        if (data is Map) {
          _ref
              .read(simulationAccessProvider.notifier)
              .applySocket(Map<String, dynamic>.from(data));
        }
      }),
    );
  }

  void joinTeam(String teamId, {String? playerName}) =>
      _socket.joinTeam(teamId, playerName: playerName);

  /// Team room currently joined (or to be joined on connect), if any.
  String? get joinedTeamId => _socket.teamId;

  /// Whether a socket exists, connected or still handshaking/reconnecting.
  bool get hasSocket => _socket.hasSocket;
  void leaveTeam(String teamId) => _socket.leaveTeam(teamId);

  /// Listen to a raw socket event by name
  Stream<dynamic> onEvent(String event) => _socket.on<dynamic>(event);

  void sendDecision(Map<String, dynamic> decision) =>
      _socket.sendDecision(decision);

  void selectScenario(Map<String, dynamic> scenario) =>
      _socket.selectScenario(scenario);

  bool get isConnected => _socket.isConnected;

  Stream<bool> get connectionStatus => _socket.on<bool>('connection_status');

  void dispose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
    _socket.disconnect();
  }
}

final socketManagerProvider = Provider<SocketManager>((ref) {
  final socket = ref.watch(socketServiceProvider);
  final manager = SocketManager(socket, ref);
  ref.onDispose(() => manager.dispose());
  return manager;
});

/// Corporate simulation gate as last pushed by `facilitator:simulation_access { open }`
/// (null until a push arrives this session; the REST source of truth is
/// GET ApiEndpoints.facilitatorSimulationAccess).
final simulationAccessProvider = StateProvider<bool?>((ref) => null);

/// Latest `team:module_advanced` push for the selected team (null until one arrives).
final teamModuleAdvanceProvider = StateProvider<TeamModuleAdvance?>((ref) => null);

// Active shocks list (pushed via socket)
final activeShocksProvider = StateProvider<List<Map<String, dynamic>>>((ref) => []);

// Game countdown seconds, driven by the /timer/status poller (timer_provider.dart); the
// server never pushes the game timer over the socket.
final timerSecondsProvider = StateProvider<int?>((ref) => null);

// Connection status stream
final connectionStatusProvider = StreamProvider<bool>((ref) {
  final manager = ref.watch(socketManagerProvider);
  return manager.connectionStatus;
});

// Team member count (updated via presence-update socket event)
final teamMemberCountProvider = StateProvider<int>((ref) => 0);
