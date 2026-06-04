import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/decision.dart';
import '../data/repositories/decision_repository.dart';
import 'repository_providers.dart';

class DecisionState {
  final Map<String, dynamic> currentDecision;
  final List<Decision> teamDecisions;
  final Map<String, dynamic>? validationResult;
  final bool isSubmitting;
  final bool isValidating;
  final String? error;
  final String? successMessage;

  const DecisionState({
    this.currentDecision = const {},
    this.teamDecisions = const [],
    this.validationResult,
    this.isSubmitting = false,
    this.isValidating = false,
    this.error,
    this.successMessage,
  });

  DecisionState copyWith({
    Map<String, dynamic>? currentDecision,
    List<Decision>? teamDecisions,
    Map<String, dynamic>? validationResult,
    bool? isSubmitting,
    bool? isValidating,
    String? error,
    String? successMessage,
  }) {
    return DecisionState(
      currentDecision: currentDecision ?? this.currentDecision,
      teamDecisions: teamDecisions ?? this.teamDecisions,
      validationResult: validationResult ?? this.validationResult,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isValidating: isValidating ?? this.isValidating,
      error: error,
      successMessage: successMessage,
    );
  }
}

class DecisionNotifier extends StateNotifier<DecisionState> {
  final DecisionRepository _repo;

  DecisionNotifier(this._repo) : super(const DecisionState());

  void updateField(String key, dynamic value) {
    final updated = Map<String, dynamic>.from(state.currentDecision);
    updated[key] = value;
    state = state.copyWith(currentDecision: updated);
  }

  void setDecisionData(Map<String, dynamic> data) {
    state = state.copyWith(currentDecision: data);
  }

  Future<bool> validateDecision({
    required String teamId,
    required int round,
    required String module,
  }) async {
    state = state.copyWith(isValidating: true, error: null);
    try {
      final result = await _repo.validateDecision(
        teamId: teamId,
        round: round,
        module: module,
        decisionData: state.currentDecision,
      );
      state = state.copyWith(
        validationResult: result,
        isValidating: false,
      );
      return result['success'] == true;
    } catch (e) {
      state = state.copyWith(isValidating: false, error: e.toString());
      return false;
    }
  }

  Future<bool> confirmDecision({
    required String teamId,
    required int round,
    required String module,
    List<String>? scenarioIds,
    List<Map<String, dynamic>>? decisions,
  }) async {
    state = state.copyWith(isSubmitting: true, error: null);
    try {
      await _repo.confirmDecision(
        teamId: teamId,
        round: round,
        module: module,
        decisionData: state.currentDecision,
        scenarioIds: scenarioIds,
        decisions: decisions,
      );
      state = state.copyWith(
        isSubmitting: false,
        successMessage: 'Decision confirmed successfully',
      );
      return true;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.toString());
      return false;
    }
  }

  Future<void> fetchTeamDecisions(String teamId, {int? round}) async {
    try {
      final decisions = await _repo.fetchTeamDecisions(teamId, round: round);
      state = state.copyWith(teamDecisions: decisions);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null, successMessage: null);
  }

  void reset() {
    state = const DecisionState();
  }
}

final decisionProvider =
    StateNotifierProvider<DecisionNotifier, DecisionState>((ref) {
  return DecisionNotifier(ref.watch(decisionRepositoryProvider));
});
