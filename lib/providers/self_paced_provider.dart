import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/self_paced_repository.dart';
import '../data/models/user.dart';
import 'repository_providers.dart' show selfPacedRepositoryProvider;

class SelfPacedState {
  final int currentRound;
  final String currentModule;
  final bool isLoading;
  final bool isGameComplete;
  final Map<String, List<Map<String, dynamic>>> decisions;
  final String? error;

  const SelfPacedState({
    this.currentRound = 1,
    this.currentModule = 'financing',
    this.isLoading = false,
    this.isGameComplete = false,
    this.decisions = const {},
    this.error,
  });

  SelfPacedState copyWith({
    int? currentRound,
    String? currentModule,
    bool? isLoading,
    bool? isGameComplete,
    Map<String, List<Map<String, dynamic>>>? decisions,
    String? error,
  }) {
    return SelfPacedState(
      currentRound: currentRound ?? this.currentRound,
      currentModule: currentModule ?? this.currentModule,
      isLoading: isLoading ?? this.isLoading,
      isGameComplete: isGameComplete ?? this.isGameComplete,
      decisions: decisions ?? this.decisions,
      error: error,
    );
  }
}

class SelfPacedNotifier extends StateNotifier<SelfPacedState> {
  final SelfPacedRepository _repo;

  SelfPacedNotifier(this._repo) : super(const SelfPacedState());

  /// Fetch progress from /self-paced/me, then load decisions for completed
  /// modules so the round progress boxes can show decision details.
  Future<void> fetchProgress() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _repo.fetchMe();
      final userData = response['user'] as Map<String, dynamic>? ?? response;
      final round = userData['currentRound'] as int? ?? 1;
      final module = userData['currentModule'] as String? ?? 'financing';
      final complete = round >= 3 && module == 'complete';

      state = state.copyWith(
        currentRound: round,
        currentModule: module,
        isLoading: false,
        isGameComplete: complete,
      );

      // Load all decisions for this round so progress boxes show details
      await _loadRoundDecisions(round);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Fetch all decisions for a round using the grouped endpoint.
  Future<void> _loadRoundDecisions(int round) async {
    try {
      final grouped = await _repo.fetchGroupedDecisions(round: round);
      if (grouped.isNotEmpty) {
        final updated = Map<String, List<Map<String, dynamic>>>.from(state.decisions);
        for (final entry in grouped.entries) {
          if (entry.value.isNotEmpty) {
            updated[entry.key] = entry.value;
          }
        }
        state = state.copyWith(decisions: updated);
      }
    } catch (_) {
      // Non-critical
    }
  }

  /// Update state from an existing SelfPacedUser (e.g. from auth)
  void updateFromUser(SelfPacedUser user) {
    final complete = user.currentRound >= 3 && user.currentModule == 'complete';
    state = state.copyWith(
      currentRound: user.currentRound,
      currentModule: user.currentModule,
      isGameComplete: complete,
    );
  }

  /// Complete the current module and return the backend's response.
  /// The response includes { success, progress: { currentRound, currentModule } }.
  /// Does NOT update UI state — caller uses advanceToNextModule() for that.
  Future<Map<String, dynamic>> completeModule() async {
    try {
      return await _repo.completeModule();
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  /// Advance the UI using the progress data returned by completeModule().
  /// This avoids a second API call and eliminates race conditions.
  void advanceToNextModule(int newRound, String newModule) {
    final complete = newRound >= 3 && newModule == 'complete';

    // If round changed, clear decisions (new round = fresh progress boxes)
    final newDecisions = newRound != state.currentRound
        ? <String, List<Map<String, dynamic>>>{}
        : Map<String, List<Map<String, dynamic>>>.from(state.decisions);

    state = state.copyWith(
      currentRound: newRound,
      currentModule: newModule,
      isGameComplete: complete,
      decisions: newDecisions,
    );

    // Load decisions for the new round in background (for progress box display)
    _loadRoundDecisions(newRound);
  }

  /// Reset all progress back to round 1 / financing
  Future<bool> resetProgress() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _repo.resetProgress();
      if (response['success'] == true) {
        state = const SelfPacedState(
          currentRound: 1,
          currentModule: 'financing',
        );
        return true;
      }
      state = state.copyWith(
        isLoading: false,
        error: response['error']?.toString() ?? 'Failed to reset progress',
      );
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// Store decisions locally for display
  void setDecisions(String module, List<Map<String, dynamic>> moduleDecisions) {
    final updated = Map<String, List<Map<String, dynamic>>>.from(state.decisions);
    updated[module] = moduleDecisions;
    state = state.copyWith(decisions: updated);
  }
}

final selfPacedProvider =
    StateNotifierProvider<SelfPacedNotifier, SelfPacedState>((ref) {
  return SelfPacedNotifier(ref.watch(selfPacedRepositoryProvider));
});
