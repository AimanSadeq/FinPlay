import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/network/api_client.dart';
import '../core/network/api_endpoints.dart';
import '../data/models/game_state.dart';
import 'repository_providers.dart';

class GameStateNotifier extends StateNotifier<AsyncValue<GameState>> {
  final ApiClient _api;

  GameStateNotifier(this._api) : super(const AsyncValue.loading()) {
    fetchGameState();
  }

  /// Reads the game state. On a facilitator device (password header attached)
  /// the source is GET /facilitator/status, whose `gameState` carries isActive,
  /// the education gates and the corporate mode fields the console renders;
  /// the public GET /sheets/round/state has none of them and is the fallback
  /// for learners (and for a facilitator read the server rejects, say after
  /// the password was rotated). Both payloads fill the round, module, lock and
  /// nextDecisionsUnlocked fields the learner screens read.
  Future<void> fetchGameState() async {
    try {
      final current = state.valueOrNull;
      if (_api.hasFacilitatorPassword) {
        final status = await _api.get(ApiEndpoints.facilitatorStatus);
        final gameState = status['gameState'];
        if (!apiFailed(status) && status['success'] == true && gameState is Map) {
          state = AsyncValue.data(
            GameState.fromJson(Map<String, dynamic>.from(gameState), base: current),
          );
          return;
        }
      }
      // Round state directly: {roundNum, module, timeRemaining, locks: {...}}
      // (no {success, data} wrapper).
      final response = await _api.get(ApiEndpoints.roundState);
      state = AsyncValue.data(GameState.fromJson(response, base: current));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void updateFromSocket(Map<String, dynamic> data) {
    state = AsyncValue.data(GameState.fromJson(data, base: state.valueOrNull));
  }
}

final gameStateProvider =
    StateNotifierProvider<GameStateNotifier, AsyncValue<GameState>>((ref) {
  return GameStateNotifier(ref.watch(apiClientProvider));
});
