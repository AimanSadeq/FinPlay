import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';

class EducationRepository {
  final ApiClient _api;

  EducationRepository(this._api);

  Future<List<Map<String, dynamic>>> fetchBreakEvenScenarios() async {
    final response = await _api.get(ApiEndpoints.breakEvenScenarios);
    if (response['success'] == true) {
      return (response['data'] as List<dynamic>).cast<Map<String, dynamic>>();
    }
    throw Exception(response['error'] ?? 'Failed to fetch break-even scenarios');
  }

  Future<Map<String, dynamic>> fetchAiTooltip({
    required String term,
    String? language,
  }) async {
    final response = await _api.post(ApiEndpoints.aiTooltip, data: {
      'term': term,
      'language': ?language,
    });
    if (response['success'] == true) {
      return response['data'] as Map<String, dynamic>;
    }
    throw Exception(response['error'] ?? 'Failed to fetch tooltip');
  }

  /// Simple in-memory cache for structured ratio tooltips, keyed by
  /// title|value|type, mirroring the website's client-side tooltip cache so we
  /// don't re-hit the (slow, AI-generated) endpoint for the same ratio.
  static final Map<String, Map<String, dynamic>> _ratioTooltipCache = {};

  /// Structured AI explanation for a financial ratio. Returns the rich object
  /// (definition, formula, interpretation, benchmarks, businessImpact,
  /// industryContext, actionableInsights, relatedRatios, advantages,
  /// disadvantages, riskLevel) from [ApiEndpoints.ratiosTooltip].
  Future<Map<String, dynamic>> fetchRatioTooltip({
    required String title,
    String? value,
    String? type,
  }) async {
    final cacheKey = '$title|${value ?? ''}|${type ?? ''}';
    final cached = _ratioTooltipCache[cacheKey];
    if (cached != null) return cached;

    final response = await _api.get(ApiEndpoints.ratiosTooltip, params: {
      'title': title,
      'value': ?value,
      'type': ?type,
    });
    // This endpoint returns the object directly (no success/data envelope).
    if (response['definition'] != null || response['title'] != null) {
      _ratioTooltipCache[cacheKey] = response;
      return response;
    }
    if (response['success'] == true && response['data'] is Map) {
      final data = (response['data'] as Map).cast<String, dynamic>();
      _ratioTooltipCache[cacheKey] = data;
      return data;
    }
    throw Exception(response['error'] ?? 'Failed to fetch ratio tooltip');
  }

  // Government Education
  Future<List<Map<String, dynamic>>> fetchGovTeams() async {
    final response = await _api.get(ApiEndpoints.govEducationTeams);
    if (response['success'] == true) {
      return (response['data'] as List<dynamic>).cast<Map<String, dynamic>>();
    }
    throw Exception(response['error'] ?? 'Failed to fetch gov teams');
  }

  Future<Map<String, dynamic>> fetchGovProgress(int teamId) async {
    final response = await _api.get(
      '${ApiEndpoints.govEducationProgress}/$teamId',
    );
    if (response['success'] == true) {
      return response['data'] as Map<String, dynamic>;
    }
    throw Exception(response['error'] ?? 'Failed to fetch gov progress');
  }

  Future<Map<String, dynamic>> submitQuiz({
    required int teamId,
    required int moduleId,
    required List<Map<String, dynamic>> answers,
    int? score,
    int? total,
  }) async {
    final response = await _api.post(ApiEndpoints.govEducationQuiz, data: {
      'teamId': teamId,
      'moduleId': moduleId,
      'answers': answers,
      'score': ?score,
      'total': ?total,
    });
    if (response['success'] == true) {
      return response['data'] as Map<String, dynamic>;
    }
    throw Exception(response['error'] ?? 'Failed to submit quiz');
  }

  Future<List<Map<String, dynamic>>> fetchGovLeaderboard() async {
    final response = await _api.get(ApiEndpoints.govEducationLeaderboard);
    if (response['success'] == true) {
      return (response['data'] as List<dynamic>).cast<Map<String, dynamic>>();
    }
    throw Exception(response['error'] ?? 'Failed to fetch gov leaderboard');
  }
}
