import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../models/decision.dart';
import '../models/scenario.dart';

class DecisionRepository {
  final ApiClient _api;

  DecisionRepository(this._api);

  Future<List<Scenario>> fetchScenarios({
    required String module,
    int? round,
    String? teamId,
  }) async {
    try {
      // Corporate mode: use team-amounts endpoint (returns team-specific amounts)
      // Self-paced: use generic scenarios endpoint
      if (teamId != null) {
        final response = await _api.get(
          '${ApiEndpoints.scenarios}/team-amounts/${Uri.encodeComponent(teamId)}',
          params: <String, dynamic>{
            'module': module,
            'round': round,
          },
        );
        final list = response['scenarios'] as List<dynamic>? ?? [];
        return list.map((e) => Scenario.fromJson(e as Map<String, dynamic>)).toList();
      }

      // Self-paced: use generic scenarios endpoint
      final response = await _api.get(ApiEndpoints.scenarios, params: <String, dynamic>{
        'module': module,
        'round': round,
      });
      // API returns {module, round, scenarios: [...], scenarioMode}
      final list = response['scenarios'] as List<dynamic>? ?? [];
      return list.map((e) => Scenario.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> validateDecision({
    required String teamId,
    required int round,
    required String module,
    required Map<String, dynamic> decisionData,
  }) async {
    final response = await _api.post(ApiEndpoints.decisionValidate, data: {
      'teamId': teamId,
      'roundNum': round,
      'module': module,
      'decisionData': decisionData,
    });
    return response;
  }

  Future<Map<String, dynamic>> confirmDecision({
    required String teamId,
    required int round,
    required String module,
    required Map<String, dynamic> decisionData,
    List<String>? scenarioIds,
    List<Map<String, dynamic>>? decisions,
  }) async {
    // Backend expects: { teamId, module, round, decisions: [{scenarioId, amount}, ...] }
    final response = await _api.post(ApiEndpoints.decisionConfirm, data: {
      'teamId': teamId,
      'round': round,
      'module': module,
      'decisions': decisions ?? [],
      'decisionData': decisionData,
      'scenarioIds': ?scenarioIds,
    });
    return response;
  }

  Future<List<Decision>> fetchTeamDecisions(String teamId, {int? round}) async {
    final params = <String, dynamic>{'teamId': teamId};
    if (round != null) params['roundNum'] = round;
    try {
      final list = await _api.getList(ApiEndpoints.decisions, params: params);
      final decisions = list.map((e) => Decision.fromJson(e as Map<String, dynamic>)).toList();
      // ignore: avoid_print
      print('[DEBUG] fetchTeamDecisions: got ${decisions.length} decisions, '
          'locked=${decisions.where((d) => d.isLocked).map((d) => d.module).toList()}');
      return decisions;
    } catch (e) {
      // ignore: avoid_print
      print('[DEBUG] fetchTeamDecisions error: $e');
      return [];
    }
  }
}
