import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../utils/constants.dart';

class SocketService {
  io.Socket? _socket;
  final _eventControllers = <String, StreamController<dynamic>>{};
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  void connect({String? teamId}) {
    // If already connected, disconnect first to allow reconnection with new params
    if (_socket != null) {
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
    }

    _socket = io.io(AppConstants.baseUrl, <String, dynamic>{
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
    });

    _socket!.onDisconnect((_) {
      _isConnected = false;
      _emit('connection_status', false);
    });

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
    _socket!.on('decision:updated', (data) => _emit('decision:updated', data));
    _socket!.on('team:module_advanced', (data) => _emit('team:module_advanced', data));
    _socket!.on('team:joined', (data) => _emit('team:joined', data));
    _socket!.on('team:member_joined', (data) => _emit('team:member_joined', data));
    _socket!.on('team:member_left', (data) => _emit('team:member_left', data));
  }

  void disconnect() {
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

  void joinTeam(String teamId) {
    _socket?.emit('join-team', {'teamId': teamId});
  }

  void leaveTeam(String teamId) {
    _socket?.emit('leave-team', {'teamId': teamId});
  }

  void sendDecision(Map<String, dynamic> decision) {
    _socket?.emit('submit-decision', decision);
  }

  void selectScenario(Map<String, dynamic> scenario) {
    _socket?.emit('select-scenario', scenario);
  }
}

final socketServiceProvider = Provider<SocketService>((ref) {
  final service = SocketService();
  ref.onDispose(() => service.disconnect());
  return service;
});
