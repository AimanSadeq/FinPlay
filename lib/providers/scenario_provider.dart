import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/scenario.dart';
import '../data/repositories/decision_repository.dart';
import 'repository_providers.dart';

class ScenarioState {
  final List<Scenario> scenarios;
  final Set<String> selectedScenarioIds;
  final bool isLoading;
  final String? error;

  const ScenarioState({
    this.scenarios = const [],
    this.selectedScenarioIds = const {},
    this.isLoading = false,
    this.error,
  });

  ScenarioState copyWith({
    List<Scenario>? scenarios,
    Set<String>? selectedScenarioIds,
    bool? isLoading,
    String? error,
  }) {
    return ScenarioState(
      scenarios: scenarios ?? this.scenarios,
      selectedScenarioIds: selectedScenarioIds ?? this.selectedScenarioIds,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  List<Scenario> get selectedScenarios =>
      scenarios.where((s) => selectedScenarioIds.contains(s.id)).toList();
}

class ScenarioNotifier extends StateNotifier<ScenarioState> {
  final DecisionRepository _repo;

  ScenarioNotifier(this._repo) : super(const ScenarioState());

  Future<void> fetchScenarios({
    required String module,
    int? round,
    String? teamId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final scenarios = await _repo.fetchScenarios(
        module: module,
        round: round,
        teamId: teamId,
      );
      // Auto-select scenarios with non-zero amounts (like website behavior)
      final autoSelected = scenarios
          .where((s) => s.amount != null && s.amount != 0)
          .map((s) => s.id)
          .toSet();
      state = state.copyWith(
        scenarios: scenarios,
        selectedScenarioIds: autoSelected,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void toggleScenario(String scenarioId) {
    final ids = Set<String>.from(state.selectedScenarioIds);
    if (ids.contains(scenarioId)) {
      ids.remove(scenarioId);
    } else {
      ids.add(scenarioId);
    }
    state = state.copyWith(selectedScenarioIds: ids);
  }

  void clearSelection() {
    state = state.copyWith(selectedScenarioIds: {});
  }
}

final scenarioProvider =
    StateNotifierProvider<ScenarioNotifier, ScenarioState>((ref) {
  return ScenarioNotifier(ref.watch(decisionRepositoryProvider));
});
