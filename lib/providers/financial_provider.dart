import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/financial_data.dart';
import '../data/repositories/game_repository.dart';
import 'repository_providers.dart';

class FinancialState {
  final FinancialData? teamFinancials;
  final List<FinancialData> allTeamFinancials;
  final List<LeaderboardEntry> leaderboard;
  final List<LeaderboardEntry> previousLeaderboard;
  final int selectedRound;
  final bool isLoading;
  final bool leaderboardFailed;
  final String? error;

  const FinancialState({
    this.teamFinancials,
    this.allTeamFinancials = const [],
    this.leaderboard = const [],
    this.previousLeaderboard = const [],
    this.selectedRound = 0,
    this.isLoading = false,
    this.leaderboardFailed = false,
    this.error,
  });

  FinancialState copyWith({
    FinancialData? teamFinancials,
    List<FinancialData>? allTeamFinancials,
    List<LeaderboardEntry>? leaderboard,
    List<LeaderboardEntry>? previousLeaderboard,
    int? selectedRound,
    bool? isLoading,
    bool? leaderboardFailed,
    String? error,
  }) {
    return FinancialState(
      teamFinancials: teamFinancials ?? this.teamFinancials,
      allTeamFinancials: allTeamFinancials ?? this.allTeamFinancials,
      leaderboard: leaderboard ?? this.leaderboard,
      previousLeaderboard: previousLeaderboard ?? this.previousLeaderboard,
      selectedRound: selectedRound ?? this.selectedRound,
      isLoading: isLoading ?? this.isLoading,
      leaderboardFailed: leaderboardFailed ?? this.leaderboardFailed,
      error: error,
    );
  }
}

class FinancialNotifier extends StateNotifier<FinancialState> {
  final GameRepository _repo;

  FinancialNotifier(this._repo) : super(const FinancialState());

  Future<void> fetchTeamFinancials(String teamId, {int? round, bool selfPaced = false}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = await _repo.fetchFinancialData(teamId, round: round, selfPaced: selfPaced);
      state = state.copyWith(teamFinancials: data, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Fetch a single statement type and merge into existing data
  Future<void> fetchStatement(String teamId, String statement, {int? round}) async {
    try {
      final data = await _repo.fetchSingleStatement(teamId, statement, round: round);
      final current = state.teamFinancials;
      if (current != null) {
        state = state.copyWith(teamFinancials: current.mergeWith(data));
      } else {
        state = state.copyWith(teamFinancials: data);
      }
    } catch (e) {
      // Silently fail for lazy-loaded tabs
    }
  }

  Future<void> fetchLeaderboard({int? round}) async {
    state = state.copyWith(leaderboardFailed: false);
    try {
      final data = await _repo.fetchLeaderboard(round: round);
      if (mounted) state = state.copyWith(leaderboard: data);
    } catch (e) {
      if (mounted) state = state.copyWith(leaderboardFailed: true);
    }
  }

  Future<void> fetchAllTeamFinancials({int? round}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = await _repo.fetchFinancialData('Team 1', round: round);
      // Use leaderboard for comparison; store single team as placeholder
      state = state.copyWith(allTeamFinancials: [data], isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Fast initial load: fetch dashboard + leaderboard in true parallel.
  /// For self-paced learners the dashboard is per-learner and there is no team
  /// leaderboard, so the leaderboard fetch is skipped.
  Future<void> refreshAll(String teamId, {int? round, bool selfPaced = false}) async {
    // ignore: avoid_print
    print('[FinancialProvider] refreshAll called: teamId=$teamId, round=$round, selfPaced=$selfPaced');
    // Keep previous leaderboard visible while loading new data
    state = state.copyWith(
      isLoading: true,
      leaderboardFailed: false,
      selectedRound: round ?? 0,
      previousLeaderboard: state.leaderboard,
    );

    // Launch both requests simultaneously
    final dashboardFuture = _repo.fetchDashboardData(teamId, round: round, selfPaced: selfPaced);
    final leaderboardFuture = selfPaced
        ? null
        : _repo.fetchLeaderboard(round: round).timeout(const Duration(seconds: 15));

    // Dashboard data arrives first (1 API call) → unblock the UI
    try {
      final data = await dashboardFuture;
      // ignore: avoid_print
      print('[FinancialProvider] dashboard loaded: revenue=${data.revenue}');
      if (mounted) state = state.copyWith(teamFinancials: data, isLoading: false);
    } catch (e) {
      // ignore: avoid_print
      print('[FinancialProvider] dashboard error: $e');
      if (mounted) state = state.copyWith(isLoading: false, error: e.toString());
    }

    if (leaderboardFuture == null) return;
    // Leaderboard arrives later (calculates scores for all teams) → update when ready
    try {
      final lb = await leaderboardFuture;
      // ignore: avoid_print
      print('[FinancialProvider] leaderboard loaded: ${lb.length} teams');
      if (mounted) state = state.copyWith(leaderboard: lb);
    } catch (e) {
      // ignore: avoid_print
      print('[FinancialProvider] leaderboard error: $e');
      // Timeout or network error — mark as failed so UI shows retry
      if (mounted) state = state.copyWith(leaderboardFailed: true);
    }
  }
}

final financialProvider =
    StateNotifierProvider<FinancialNotifier, FinancialState>((ref) {
  return FinancialNotifier(ref.watch(gameRepositoryProvider));
});
