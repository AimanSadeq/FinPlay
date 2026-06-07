import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/scenario.dart';
import '../data/repositories/decision_repository.dart';
import 'repository_providers.dart';

class ScenarioState {
  final List<Scenario> scenarios;
  final Set<String> selectedScenarioIds;
  // User-edited dollar amounts (scenarioId -> amount). Overrides the backend
  // value so a team can set/change a decision's amount on the card, matching
  // the website's inline amount editor.
  final Map<String, double> userAmounts;
  final bool isLoading;
  final String? error;

  const ScenarioState({
    this.scenarios = const [],
    this.selectedScenarioIds = const {},
    this.userAmounts = const {},
    this.isLoading = false,
    this.error,
  });

  ScenarioState copyWith({
    List<Scenario>? scenarios,
    Set<String>? selectedScenarioIds,
    Map<String, double>? userAmounts,
    bool? isLoading,
    String? error,
  }) {
    return ScenarioState(
      scenarios: scenarios ?? this.scenarios,
      selectedScenarioIds: selectedScenarioIds ?? this.selectedScenarioIds,
      userAmounts: userAmounts ?? this.userAmounts,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  /// Effective amount for a scenario: a user edit overrides the backend value.
  double amountFor(Scenario s) => userAmounts[s.id] ?? s.amount ?? 0;

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
        userAmounts: <String, double>{}, // fresh round/module — drop stale edits
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

  /// Set a scenario's amount and auto-select / auto-deselect to match the
  /// website: a non-zero amount selects the scenario, a zero amount deselects it.
  void setAmount(String scenarioId, double amount) {
    final amounts = Map<String, double>.from(state.userAmounts);
    amounts[scenarioId] = amount;
    final ids = Set<String>.from(state.selectedScenarioIds);
    if (amount != 0) {
      ids.add(scenarioId);
    } else {
      ids.remove(scenarioId);
    }
    state = state.copyWith(userAmounts: amounts, selectedScenarioIds: ids);
  }

  /// Background write of an edited amount to the backend (corporate mode only).
  Future<void> persistAmount({
    required String teamId,
    required int round,
    required String module,
    required String scenarioId,
    required double amount,
  }) {
    return _repo.updateScenarioAmount(
      teamId: teamId,
      round: round,
      module: module,
      scenarioId: scenarioId,
      amount: amount,
    );
  }

  void clearSelection() {
    state = state.copyWith(selectedScenarioIds: {});
  }
}

final scenarioProvider =
    StateNotifierProvider<ScenarioNotifier, ScenarioState>((ref) {
  return ScenarioNotifier(ref.watch(decisionRepositoryProvider));
});
