import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';

class SelfPacedRepository {
  final ApiClient _api;

  SelfPacedRepository(this._api);

  /// GET /self-paced/me — fetch current user progress
  Future<Map<String, dynamic>> fetchMe() async {
    return _api.get(ApiEndpoints.selfPacedMe);
  }

  /// GET /self-paced/progress/scenarios?module=X&round=Y
  /// Backend returns { scenarios: [...], source: 'excel'|'fallback' }
  Future<List<dynamic>> fetchScenarios({
    required String module,
    required int round,
  }) async {
    try {
      final response = await _api.get(
        ApiEndpoints.selfPacedProgressScenarios,
        params: {'module': module, 'round': round.toString()},
      );
      // Backend returns { scenarios: [...], source: 'excel'|'fallback' }
      final scenarios = response['scenarios'];
      if (scenarios is List && scenarios.isNotEmpty) {
        return scenarios;
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  /// POST /self-paced/progress/decision
  /// Website sends: { roundNum, module, scenarioId, decisionData: { selected, amount, timestamp } }
  Future<Map<String, dynamic>> saveDecision({
    required int round,
    required String module,
    required String scenarioId,
    required Map<String, dynamic> data,
  }) async {
    return _api.post(ApiEndpoints.selfPacedProgressDecision, data: {
      'roundNum': round,
      'module': module,
      'scenarioId': scenarioId,
      'decisionData': {
        'selected': true,
        'amount': data['amount'] ?? 0,
        'timestamp': DateTime.now().toIso8601String(),
      },
    });
  }

  /// POST /self-paced/progress/complete-module
  Future<Map<String, dynamic>> completeModule() async {
    return _api.post(ApiEndpoints.selfPacedCompleteModule);
  }

  /// GET /self-paced/progress/decisions/{round}/{module}
  /// Backend returns { success: true, decisions: [...] }
  Future<List<dynamic>> fetchDecisions({
    required int round,
    required String module,
  }) async {
    try {
      final response = await _api.get(
        '${ApiEndpoints.selfPacedProgressDecisions}/$round/$module',
      );
      final decisions = response['decisions'];
      if (decisions is List) return decisions;
      return [];
    } catch (_) {
      return [];
    }
  }

  /// GET /self-paced/progress/decisions?roundNum=X
  /// Backend returns { success: true, decisions: { financing: [...], investing: [...], operating: [...] } }
  /// Each entry: { scenarioId, title, amount }
  Future<Map<String, List<Map<String, dynamic>>>> fetchGroupedDecisions({
    required int round,
  }) async {
    try {
      final response = await _api.get(
        ApiEndpoints.selfPacedProgressDecisions,
        params: {'roundNum': round.toString()},
      );
      final decisions = response['decisions'];
      if (decisions is Map) {
        final result = <String, List<Map<String, dynamic>>>{};
        for (final entry in decisions.entries) {
          final key = entry.key.toString();
          final list = entry.value;
          if (list is List) {
            result[key] = list
                .map((d) => d is Map<String, dynamic>
                    ? d
                    : Map<String, dynamic>.from(d as Map))
                .toList();
          }
        }
        return result;
      }
      return {};
    } catch (_) {
      return {};
    }
  }

  /// POST /self-paced/progress/reset
  Future<Map<String, dynamic>> resetProgress() async {
    return _api.post(ApiEndpoints.selfPacedProgressReset);
  }
}
