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

  Future<void> fetchGameState() async {
    try {
      final response = await _api.get(ApiEndpoints.roundState);
      // API returns round state directly: {roundNum, module, timeRemaining, locks: {...}}
      // Parse it directly (no {success, data} wrapper)
      final gs = GameState.fromJson(response);
      // ignore: avoid_print
      print('[DEBUG] gameState: nextDecisionsUnlocked=${gs.nextDecisionsUnlocked} raw=${response['nextDecisionsUnlocked']}');
      state = AsyncValue.data(gs);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void updateFromSocket(Map<String, dynamic> data) {
    state = AsyncValue.data(GameState.fromJson(data));
  }
}

final gameStateProvider =
    StateNotifierProvider<GameStateNotifier, AsyncValue<GameState>>((ref) {
  return GameStateNotifier(ref.watch(apiClientProvider));
});
