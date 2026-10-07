import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../module_plan.dart';

class EducationRepository {
  final ApiClient _api;

  EducationRepository(this._api);

  /// The module plan in force for this host (GET /education/module-plan).
  /// Throws when the request fails or the route is missing, so the caller can
  /// keep what it already has; a server answer of `moduleNums: null` is a real
  /// answer and comes back as [ModulePlan.fallback].
  Future<ModulePlan> fetchModulePlan() async {
    final response = await _api.get(ApiEndpoints.educationModulePlan);
    if (apiFailed(response)) {
      throw Exception(response['error'] ?? 'Failed to fetch the module plan');
    }
    return ModulePlan.fromJson(response);
  }

  Future<List<Map<String, dynamic>>> fetchBreakEvenScenarios() async {
    final response = await _api.get(ApiEndpoints.breakEvenScenarios);
    if (response['success'] == true) {
      return (response['data'] as List<dynamic>).cast<Map<String, dynamic>>();
    }
    throw Exception(response['error'] ?? 'Failed to fetch break-even scenarios');
  }

  /// Bilingual AI explanation of a simulation scenario from
  /// GET /scenarios/tooltip/{scenarioId}?title=. The server returns the
  /// content object directly ({title, definition, whyItMatters, ...}, each
  /// {en, ar}); a 503 means the AI service could not answer.
  Future<Map<String, dynamic>> fetchScenarioTooltip({
    required String scenarioId,
    required String title,
  }) async {
    final response = await _api.get(
      '${ApiEndpoints.scenarioTooltip}/${Uri.encodeComponent(scenarioId)}',
      params: {'title': title},
    );
    if (apiFailed(response) || response['definition'] == null) {
      throw Exception(response['error'] ?? 'Failed to fetch scenario explanation');
    }
    return response;
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
}
