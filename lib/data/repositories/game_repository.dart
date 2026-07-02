import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/services/cache_service.dart';
import '../models/game_state.dart';
import '../models/team.dart';
import '../models/financial_data.dart';

class GameRepository {
  final ApiClient _api;
  final CacheService _cache = CacheService();

  GameRepository(this._api);

  Future<GameState> fetchGameState() async {
    final cached = await _cache.get('game_state', maxAge: const Duration(seconds: 30));
    if (cached != null) {
      return GameState.fromJson(cached);
    }

    // API returns: {roundNum, module, timeRemaining, locks: {financing, investing, operating}}
    final response = await _api.get(ApiEndpoints.roundState);
    await _cache.set('game_state', response);
    return GameState.fromJson(response);
  }

  Future<List<Team>> fetchTeams() async {
    final cached = await _cache.get('teams', maxAge: const Duration(minutes: 2));
    if (cached != null && cached['list'] is List) {
      return (cached['list'] as List)
          .map((e) => Team.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    // API returns raw array: [{id: "Team 1", name: "Riyadh (Team 1)", ...}]
    final list = await _api.getList(ApiEndpoints.teams);
    await _cache.set('teams', {'list': list});
    return list.map((e) => Team.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Fetch ALL financial data in one batch call (like website's /dashboard-data).
  /// When [selfPaced] is true, hits the per-learner endpoint (scoped to the
  /// learner's OWN decisions, shock-isolated) which returns the same shape; the
  /// learner is identified by the auth bearer, so teamId is not sent.
  Future<FinancialData> fetchDashboardData(String teamId,
      {int? round, bool selfPaced = false}) async {
    final effectiveRound = round ?? 1;
    final cacheKey = selfPaced
        ? 'sp_dashboard_r$effectiveRound'
        : 'dashboard_${teamId}_r$effectiveRound';
    final cached = await _cache.get(cacheKey, maxAge: const Duration(minutes: 2));
    if (cached != null && cached.containsKey('data')) {
      return _parseDashboardResponse(cached, teamId, effectiveRound);
    }

    final response = selfPaced
        ? await _api.get(ApiEndpoints.selfPacedProgressDashboardData, params: {
            'currentRound': effectiveRound,
            'previousRound': effectiveRound > 1 ? effectiveRound - 1 : 0,
          })
        : await _api.get(ApiEndpoints.dashboardData, params: {
            'teamId': teamId,
            'currentRound': effectiveRound,
            'previousRound': effectiveRound > 1 ? effectiveRound - 1 : 0,
          });
    await _cache.set(cacheKey, response);
    return _parseDashboardResponse(response, teamId, effectiveRound);
  }

  FinancialData _parseDashboardResponse(Map<String, dynamic> response, String teamId, int round) {
    final data = response['data'] as Map<String, dynamic>? ?? {};
    final currentRound = data['currentRound'] as Map<String, dynamic>? ?? {};

    // Each sub-key (income, balance, cashflow, ratios) has same format as /sheets/results/round
    var merged = FinancialData(teamId: teamId, roundNum: round);
    for (final key in ['income', 'balance', 'cashflow', 'ratios']) {
      final stmtData = currentRound[key] as Map<String, dynamic>?;
      if (stmtData != null && stmtData.isNotEmpty) {
        merged = merged.mergeWith(FinancialData.fromSheetResponse(stmtData));
      }
    }
    return merged;
  }

  /// Fetch a single statement type (1 API call) — used for lazy tab loading
  Future<FinancialData> fetchSingleStatement(String teamId, String statement, {int? round}) async {
    final effectiveRound = round ?? 1;
    final cacheKey = 'stmt_${teamId}_${statement}_r$effectiveRound';
    final cached = await _cache.get(cacheKey, maxAge: const Duration(minutes: 2));
    if (cached != null) {
      return FinancialData.fromSheetResponse(cached);
    }

    final response = await _api.get(ApiEndpoints.resultsRound, params: {
      'teamId': teamId, 'round': effectiveRound, 'statement': statement,
    });
    await _cache.set(cacheKey, response);
    return FinancialData.fromSheetResponse(response);
  }

  /// Fetch all 4 statement types in parallel (use for full refresh)
  Future<FinancialData> fetchFinancialData(String teamId,
      {int? round, bool selfPaced = false}) async {
    // Use the batch endpoint for speed
    return fetchDashboardData(teamId, round: round, selfPaced: selfPaced);
  }

  Future<List<LeaderboardEntry>> fetchLeaderboard({int? round}) async {
    final cacheKey = 'leaderboard${round != null ? '_r$round' : ''}';
    final cached = await _cache.get(cacheKey, maxAge: const Duration(seconds: 30));
    if (cached != null && cached['list'] is List) {
      return (cached['list'] as List)
          .map((e) => LeaderboardEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    // /leaderboard/live returns {leaderboard: [...], round, totalTeams}
    final params = <String, dynamic>{};
    if (round != null) params['round'] = round;
    final response = await _api.get(ApiEndpoints.leaderboardDay, params: params);
    final list = response['leaderboard'] as List<dynamic>? ?? [];
    await _cache.set(cacheKey, {'list': list});
    return list.map((e) => LeaderboardEntry.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Map<String, dynamic>> checkHealth() async {
    return _api.get(ApiEndpoints.health);
  }

  Future<Map<String, dynamic>> checkExcelConnection() async {
    return _api.get(ApiEndpoints.excelConnectionStatus);
  }

  Future<void> clearCache() async {
    await _cache.clearAll();
    await _api.get(ApiEndpoints.cacheClear);
  }
}
