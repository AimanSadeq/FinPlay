import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../features/debrief/data/self_paced_bearer.dart';
import '../../core/network/api_endpoints.dart';
import '../models/decision.dart';
import '../models/scenario.dart';

// Endpoints used only here (kept local; not in ApiEndpoints).
const String _modelRates = '/model/rates';
const String _modelOpeningBalances = '/model/opening-balances';
const String _previewImpact = '/preview/impact';
const String _previewSelfPacedImpact = '/preview/self-paced-impact';

/// Opening reserves / retained earnings for a team's round: what the Use Reserves and Use
/// Retained Earnings cards may draw on (GET /api/model/opening-balances).
class OpeningBalances {
  final double reserves;
  final double retainedEarnings;
  const OpeningBalances({required this.reserves, required this.retainedEarnings});
}

/// Net income / cash / D-E figures of a live pro-forma preview.
class PreviewMetrics {
  final double netIncome;
  final double cash;
  final double totalAssets;
  final double totalEquity;
  final double debtToEquity;

  const PreviewMetrics({
    required this.netIncome,
    required this.cash,
    required this.totalAssets,
    required this.totalEquity,
    required this.debtToEquity,
  });

  static double _n(dynamic v) => v is num ? v.toDouble() : (double.tryParse('$v') ?? 0);

  factory PreviewMetrics.fromJson(Map<String, dynamic> j) => PreviewMetrics(
        netIncome: _n(j['netIncome']),
        cash: _n(j['cash']),
        totalAssets: _n(j['totalAssets']),
        totalEquity: _n(j['totalEquity']),
        debtToEquity: _n(j['debtToEquity']),
      );

  double operator [](String key) {
    switch (key) {
      case 'netIncome':
        return netIncome;
      case 'cash':
        return cash;
      case 'totalAssets':
        return totalAssets;
      case 'totalEquity':
        return totalEquity;
      case 'debtToEquity':
        return debtToEquity;
    }
    return 0;
  }
}

/// POST /api/preview/impact (or /self-paced-impact) response:
/// `{ success, roundNum, current, projected, deltas }`.
class PreviewResult {
  final int roundNum;
  final PreviewMetrics current;
  final PreviewMetrics projected;
  final PreviewMetrics deltas;
  const PreviewResult({
    required this.roundNum,
    required this.current,
    required this.projected,
    required this.deltas,
  });

  /// Null unless the body is a well-formed success (the web hides the bar otherwise).
  static PreviewResult? tryParse(Map<String, dynamic> j) {
    if (j['success'] != true) return null;
    final c = j['current'], p = j['projected'], d = j['deltas'];
    if (c is! Map || p is! Map || d is! Map) return null;
    return PreviewResult(
      roundNum: (j['roundNum'] as num?)?.toInt() ?? 1,
      current: PreviewMetrics.fromJson(Map<String, dynamic>.from(c)),
      projected: PreviewMetrics.fromJson(Map<String, dynamic>.from(p)),
      deltas: PreviewMetrics.fromJson(Map<String, dynamic>.from(d)),
    );
  }
}

class DecisionRepository {
  final ApiClient _api;

  DecisionRepository(this._api);

  /// GET /api/model/rates?round=N -> { success, round, rates: {...} } (public). The raw
  /// `rates` map, or null on any failure (callers fall back to the template rates).
  Future<Map<String, dynamic>?> fetchModelRates(int round) async {
    try {
      final res = await _api.get(_modelRates, params: {'round': round});
      final rates = res['rates'];
      return rates is Map ? Map<String, dynamic>.from(rates) : null;
    } catch (_) {
      return null;
    }
  }

  /// GET /api/model/opening-balances?teamId=Team N&round=N (public, corporate teams only).
  Future<OpeningBalances?> fetchOpeningBalances(String teamId, int round) async {
    try {
      final res = await _api.get(_modelOpeningBalances, params: {'teamId': teamId, 'round': round});
      if (res['success'] != true) return null;
      double n(dynamic v) => v is num ? v.toDouble() : (double.tryParse('$v') ?? 0);
      return OpeningBalances(
        reserves: n(res['reserves']),
        retainedEarnings: n(res['retainedEarnings']),
      );
    } catch (_) {
      return null;
    }
  }

  /// Live pro-forma preview of the panel's pending set (scenarioId -> amount).
  /// Corporate: POST /api/preview/impact { teamId, module, roundNum, decisions } (public).
  /// Self-paced: POST /api/preview/self-paced-impact { module, roundNum, decisions } with the
  /// learner's stored bearer sent explicitly (ApiClient's shared header may hold a corporate
  /// team token); a 401 here only hides the bar, it never signs the learner out.
  /// Null on any failure: the bar hides itself.
  Future<PreviewResult?> previewImpact({
    String? teamId,
    required String module,
    required int roundNum,
    required Map<String, double> pending,
    bool selfPaced = false,
  }) async {
    final ids = pending.keys.toList()..sort();
    final decisions = [
      for (final id in ids) {'scenarioId': id, 'amount': pending[id]},
    ];
    try {
      if (selfPaced) {
        final bearer = await readSelfPacedBearer();
        if (bearer == null) return null;
        final res = await _api.dio.post(
          _previewSelfPacedImpact,
          data: {'module': module, 'roundNum': roundNum, 'decisions': decisions},
          options: Options(
            headers: {'Authorization': 'Bearer $bearer'},
            extra: {skipUnauthorizedHandlerExtra: true, noRetryExtra: true},
          ),
        );
        final body = res.data;
        return body is Map ? PreviewResult.tryParse(Map<String, dynamic>.from(body)) : null;
      }
      final res = await _api.post(_previewImpact, data: {
        'teamId': teamId,
        'module': module,
        'roundNum': roundNum,
        'decisions': decisions,
      });
      return PreviewResult.tryParse(res);
    } catch (_) {
      return null;
    }
  }

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

<<<<<<< Updated upstream
  /// Edited amounts are not posted one by one: the website keeps them locally
  /// and they travel with the decision confirmation below.
=======
  /// Persist typed-but-unconfirmed amounts so a reload cannot discard them, and so the
  /// facilitator's Round Details shows the module in progress (website bdcb696).
  /// POST /decisions/draft { teamId, module, round, decisions: [{scenarioId, amount}] }.
  /// The server answers 409 ALREADY_CONFIRMED once the module is locked; that, like any
  /// other failure, is ignored — confirm still sends the authoritative amounts.
  Future<bool> saveDraft({
    required String teamId,
    required int round,
    required String module,
    required List<Map<String, dynamic>> decisions,
  }) async {
    try {
      final res = await _api.post(ApiEndpoints.decisionsDraft, data: {
        'teamId': teamId,
        'module': module,
        'round': round,
        'decisions': decisions,
      });
      return res['success'] == true;
    } catch (_) {
      return false;
    }
  }

  /// The server's failure message for a /decisions/confirm response, or null when the
  /// confirm succeeded. ApiClient.post hands 4xx bodies back instead of throwing, and the
  /// route's refusals carry no `success` key ({ message } / { code, message } for
  /// MODULE_EMPTY, ROUND_MISMATCH, GOING_CONCERN, the reserves/retained-earnings cap, the
  /// team-leader gate; { success:false, error } for the token gate). Only a real confirm
  /// answers { success: true }.
  static String? confirmFailureMessage(Map<String, dynamic> response) {
    if (response['success'] == true) return null;
    final msg = response['message'] ?? response['error'];
    if (msg is String && msg.trim().isNotEmpty) return msg;
    return 'Could not confirm decisions';
  }

>>>>>>> Stashed changes
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
