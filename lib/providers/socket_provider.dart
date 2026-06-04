import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/network/socket_service.dart';
import 'game_state_provider.dart';
import 'team_provider.dart';

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
    _socket.connect(teamId: teamId);
    _setupListeners();
  }

  void _setupListeners() {
    // Game state updates from facilitator
    _subscriptions.add(
      _socket.on<dynamic>('game-state-update').listen((data) {
        if (data is Map<String, dynamic>) {
          _ref.read(gameStateProvider.notifier).updateFromSocket(data);
        }
      }),
    );

    // Team updates
    _subscriptions.add(
      _socket.on<dynamic>('team-update').listen((data) {
        if (data is Map<String, dynamic>) {
          _ref.read(teamProvider.notifier).updateTeamFromSocket(data);
        }
      }),
    );

    // Shock triggered notification
    _subscriptions.add(
      _socket.on<dynamic>('shock-triggered').listen((data) {
        if (data is Map<String, dynamic>) {
          _ref.read(activeShocksProvider.notifier).state = [
            ..._ref.read(activeShocksProvider),
            data,
          ];
        }
      }),
    );

    // Timer updates
    _subscriptions.add(
      _socket.on<dynamic>('timer-update').listen((data) {
        if (data is Map<String, dynamic>) {
          final seconds = data['seconds'] as int?;
          if (seconds != null) {
            _ref.read(timerSecondsProvider.notifier).state = seconds;
          }
        }
      }),
    );

    // Module locked
    _subscriptions.add(
      _socket.on<dynamic>('module-locked').listen((data) {
        _ref.read(gameStateProvider.notifier).fetchGameState();
      }),
    );

    // Round advanced
    _subscriptions.add(
      _socket.on<dynamic>('round-advanced').listen((data) {
        _ref.read(gameStateProvider.notifier).fetchGameState();
      }),
    );

    // Cache cleared - refresh data
    _subscriptions.add(
      _socket.on<dynamic>('cache-cleared').listen((data) {
        _ref.read(gameStateProvider.notifier).fetchGameState();
      }),
    );

    // Presence updates (team member count)
    _subscriptions.add(
      _socket.on<dynamic>('presence-update').listen((data) {
        if (data is Map<String, dynamic>) {
          final count = data['memberCount'] as int? ?? data['count'] as int?;
          if (count != null) {
            _ref.read(teamMemberCountProvider.notifier).state = count;
          }
        }
      }),
    );

    // Team joined - get initial member count (like website's team:joined)
    _subscriptions.add(
      _socket.on<dynamic>('team:joined').listen((data) {
        if (data is Map<String, dynamic>) {
          final count = data['memberCount'] as int?;
          if (count != null) {
            _ref.read(teamMemberCountProvider.notifier).state = count;
          }
        }
      }),
    );

    // Team member joined/left - update count
    _subscriptions.add(
      _socket.on<dynamic>('team:member_joined').listen((data) {
        if (data is Map<String, dynamic>) {
          final count = data['memberCount'] as int?;
          if (count != null) {
            _ref.read(teamMemberCountProvider.notifier).state = count;
          }
        }
      }),
    );

    _subscriptions.add(
      _socket.on<dynamic>('team:member_left').listen((data) {
        if (data is Map<String, dynamic>) {
          final count = data['memberCount'] as int?;
          if (count != null) {
            _ref.read(teamMemberCountProvider.notifier).state = count;
          }
        }
      }),
    );

    // Decision updated (from unlock/lock actions)
    _subscriptions.add(
      _socket.on<dynamic>('decision:updated').listen((data) {
        _ref.read(gameStateProvider.notifier).fetchGameState();
      }),
    );

    // Team module advanced
    _subscriptions.add(
      _socket.on<dynamic>('team:module_advanced').listen((data) {
        _ref.read(gameStateProvider.notifier).fetchGameState();
      }),
    );
  }

  void joinTeam(String teamId) => _socket.joinTeam(teamId);
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

// Active shocks list (pushed via socket)
final activeShocksProvider = StateProvider<List<Map<String, dynamic>>>((ref) => []);

// Timer seconds (updated via socket)
final timerSecondsProvider = StateProvider<int?>((ref) => null);

// Connection status stream
final connectionStatusProvider = StreamProvider<bool>((ref) {
  final manager = ref.watch(socketManagerProvider);
  return manager.connectionStatus;
});

// Team member count (updated via presence-update socket event)
final teamMemberCountProvider = StateProvider<int>((ref) => 0);
