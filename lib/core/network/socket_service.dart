import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../utils/constants.dart';

class SocketService {
  io.Socket? _socket;
  final _eventControllers = <String, StreamController<dynamic>>{};
  bool _isConnected = false;

  // The team room this client belongs to. Socket.IO rooms do not survive a reconnect, so
  // the join is replayed on every 'connect' (the website's TeamSyncContext does the same).
  String? _teamId;
  String? _playerName;

  bool get isConnected => _isConnected;

  // Origin the current socket was opened with, so a repeat connect() for the same host
  // keeps the live (or still-handshaking) socket instead of tearing it down.
  String? _socketOrigin;

  /// Every event the server actually emits to clients (server/services/socketService.ts and
  /// the routes' socketService.broadcastToTeam / broadcastToAll calls). Each is forwarded to
  /// [on] streams under the same name.
  static const serverEvents = <String>[
    // Team room (socketService.ts)
    'team:joined',
    'team:member_joined',
    'team:member_left',
    'decision:updated',
    'scenario:selected',
    'activity:synced',
    'round:updated',
    // Routes
    'team:module_advanced',
    'team:roles_updated',
    'facilitator:action',
    'facilitator:module_changed',
    'facilitator:game_reset',
    'facilitator:simulation_access',
    'facilitator:team_leader_changed',
    'facilitator:team_leaders_cleared',
    'facilitator:member_moved',
    'facilitator:member_removed',
    'facilitator:timer_settings',
    'facilitator:timer_start',
    'facilitator:timer_stop',
    'facilitator:timer_reset',
    'shock:triggered',
    'shock:forecast',
    'shock:forecast_resolved',
    'earnings_call:stage',
    'earnings_call:questions',
    'recommendations:updated',
    'hedge:purchased',
    'hedge:consumed',
  ];

  /// Open (or keep) the socket. [origin] is the API host without the /api prefix; the server
  /// resolves the cohort from the handshake Host, so it must match the cohort subdomain the
  /// REST client uses. Defaults to [AppConstants.baseUrl].
  void connect({String? teamId, String? origin}) {
    final target = origin ?? AppConstants.baseUrl;
    if (_socket != null) {
      // Same host: keep the existing socket while it is connected or still (re)connecting.
      // The team is joined by an event, not the handshake (the server only reads the Host),
      // so a different team does not need a new socket.
      if (_socketOrigin == target && (_socket!.connected || _socket!.active)) return;
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
      _isConnected = false;
    }
    _socketOrigin = target;

    _socket = io.io(target, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'reconnection': true,
      'reconnectionDelay': AppConstants.socketReconnectDelay.inMilliseconds,
      'reconnectionAttempts': 10,
      'forceNew': true,
      if (teamId != null) 'query': {'teamId': teamId},
    });

    _socket!.onConnect((_) {
      _isConnected = true;
      _emit('connection_status', true);
      // Rooms do not survive a reconnect: (re)join here, and only here.
      final team = _teamId;
      if (team != null) _emitTeamJoin(team);
    });

    _socket!.onDisconnect((_) {
      _isConnected = false;
      _emit('connection_status', false);
    });

<<<<<<< Updated upstream
    // Game events
    _socket!.on('game-state-update', (data) => _emit('game-state-update', data));
    _socket!.on('team-update', (data) => _emit('team-update', data));
    _socket!.on('decision-sync', (data) => _emit('decision-sync', data));
    _socket!.on('scenario-selected', (data) => _emit('scenario-selected', data));
    _socket!.on('shock-triggered', (data) => _emit('shock-triggered', data));
    _socket!.on('timer-update', (data) => _emit('timer-update', data));
    _socket!.on('module-locked', (data) => _emit('module-locked', data));
    _socket!.on('round-advanced', (data) => _emit('round-advanced', data));
    _socket!.on('cache-cleared', (data) => _emit('cache-cleared', data));
    _socket!.on('presence-update', (data) => _emit('presence-update', data));
    _socket!.on('facilitator:action', (data) => _emit('facilitator:action', data));
    // Corporate simulation gate: { open } whenever the facilitator flips the
    // switch (and { open:false } on a game reset).
    _socket!.on('facilitator:simulation_access',
        (data) => _emit('facilitator:simulation_access', data));
    _socket!.on('decision:updated', (data) => _emit('decision:updated', data));
    _socket!.on('team:module_advanced', (data) => _emit('team:module_advanced', data));
    _socket!.on('team:joined', (data) => _emit('team:joined', data));
    _socket!.on('team:member_joined', (data) => _emit('team:member_joined', data));
    _socket!.on('team:member_left', (data) => _emit('team:member_left', data));
=======
    for (final event in serverEvents) {
      _socket!.on(event, (data) => _emit(event, data));
    }
>>>>>>> Stashed changes
  }

  /// Team room this client has joined (replayed on reconnect), if any.
  String? get teamId => _teamId;

  void disconnect() {
    _teamId = null;
    _socketOrigin = null;
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _isConnected = false;
    for (final controller in _eventControllers.values) {
      controller.close();
    }
    _eventControllers.clear();
  }

  void emit(String event, dynamic data) {
    _socket?.emit(event, data);
  }

  Stream<T> on<T>(String event) {
    _eventControllers[event] ??= StreamController<dynamic>.broadcast();
    return _eventControllers[event]!.stream.cast<T>();
  }

  void _emit(String event, dynamic data) {
    if (_eventControllers.containsKey(event)) {
      _eventControllers[event]!.add(data);
    }
  }

  // Event names and payloads match server/services/socketService.ts:
  //   team:join       { teamId, playerId?, playerName? }
  //   team:leave      { teamId }
  //   decision:update { teamId, roundNum, module, decisions, updatedBy? }
  //   scenario:select { teamId, roundNum, module, scenarioId, scenarioTitle, selectedBy? }
  // The server relays the last two to the rest of the team room as decision:updated /
  // scenario:selected.

  /// Record the team room to be in. The join itself is sent from the connect handler, so
  /// it goes out once per (re)connection; it is only sent here when the socket is already
  /// connected (no further connect event will come).
  void joinTeam(String teamId, {String? playerName}) {
    final changed = _teamId != teamId;
    _teamId = teamId;
    if (playerName != null && playerName.isNotEmpty) _playerName = playerName;
    if (_socket?.connected == true && (changed || playerName != null)) _emitTeamJoin(teamId);
  }

  /// Whether a socket exists (connected or still connecting).
  bool get hasSocket => _socket != null;

  void _emitTeamJoin(String teamId) {
    _socket?.emit('team:join', {
      'teamId': teamId,
      if (_playerName != null) 'playerName': _playerName,
    });
  }

  void leaveTeam(String teamId) {
    _socket?.emit('team:leave', {'teamId': teamId});
    if (_teamId == teamId) _teamId = null;
  }

  /// Broadcast a decision change to teammates. Accepts the app's loose map
  /// ({teamId, round|roundNum, module, decisions?, scenarioId?, amount?}) and sends the
  /// server's shape; a bare scenario amount is wrapped as decisions: {scenarioId: amount}.
  void sendDecision(Map<String, dynamic> decision) {
    final teamId = decision['teamId'] ?? _teamId;
    if (teamId == null) return;
    Map<String, dynamic> decisions;
    if (decision['decisions'] is Map) {
      decisions = Map<String, dynamic>.from(decision['decisions'] as Map);
    } else if (decision['scenarioId'] != null) {
      decisions = {decision['scenarioId'].toString(): decision['amount']};
    } else {
      decisions = {};
    }
    _socket?.emit('decision:update', {
      'teamId': teamId,
      'roundNum': decision['roundNum'] ?? decision['round'],
      'module': decision['module'],
      'decisions': decisions,
      if (_playerName != null) 'updatedBy': _playerName,
    });
  }

  /// Broadcast a scenario selection: {teamId, round|roundNum, module, scenarioId, scenarioTitle}.
  void selectScenario(Map<String, dynamic> scenario) {
    final teamId = scenario['teamId'] ?? _teamId;
    if (teamId == null) return;
    _socket?.emit('scenario:select', {
      'teamId': teamId,
      'roundNum': scenario['roundNum'] ?? scenario['round'],
      'module': scenario['module'],
      'scenarioId': scenario['scenarioId'],
      'scenarioTitle': scenario['scenarioTitle'] ?? '',
      if (_playerName != null) 'selectedBy': _playerName,
    });
  }
}

final socketServiceProvider = Provider<SocketService>((ref) {
  final service = SocketService();
  ref.onDispose(() => service.disconnect());
  return service;
});
