import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/network/api_endpoints.dart';
import 'repository_providers.dart';
import 'socket_provider.dart';

/// Polls `GET /timer/status` and drives [timerSecondsProvider].
///
/// The backend does NOT broadcast the game timer over Socket.IO — the website
/// learns the countdown purely by polling `/api/timer/status` (fields
/// `isActive` + `timeRemaining`). This poller mirrors that: it re-syncs every
/// few seconds and ticks down locally each second for a smooth countdown.
class _TimerPoller {
  final Ref _ref;
  Timer? _pollTimer;
  Timer? _tickTimer;

  _TimerPoller(this._ref) {
    _poll();
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) => _poll());
    _tickTimer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  Future<void> _poll() async {
    try {
      final api = _ref.read(apiClientProvider);
      final r = await api.get(ApiEndpoints.timerStatus);
      final isActive = r['isActive'] == true;
      final remaining = (r['timeRemaining'] as num?)?.toInt();
      _ref.read(timerSecondsProvider.notifier).state =
          (isActive && remaining != null && remaining > 0) ? remaining : null;
    } catch (_) {
      // Keep the last value on transient errors.
    }
  }

  void _tick() {
    final current = _ref.read(timerSecondsProvider);
    if (current != null && current > 0) {
      _ref.read(timerSecondsProvider.notifier).state = current - 1;
    }
  }

  void dispose() {
    _pollTimer?.cancel();
    _tickTimer?.cancel();
  }
}

/// Watch this provider to keep the timer poll alive (e.g. from a widget that is
/// always mounted such as [GlobalTimerOverlay]).
final timerPollProvider = Provider<void>((ref) {
  final poller = _TimerPoller(ref);
  ref.onDispose(poller.dispose);
});
