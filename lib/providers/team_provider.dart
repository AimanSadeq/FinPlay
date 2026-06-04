import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/network/api_client.dart';
import '../core/network/api_endpoints.dart';
import '../core/utils/constants.dart';
import '../data/models/team.dart';
import 'repository_providers.dart';

class TeamState {
  final List<Team> teams;
  final Team? selectedTeam;
  final bool isLoading;
  final String? error;

  const TeamState({
    this.teams = const [],
    this.selectedTeam,
    this.isLoading = false,
    this.error,
  });

  TeamState copyWith({
    List<Team>? teams,
    Team? selectedTeam,
    bool clearSelectedTeam = false,
    bool? isLoading,
    String? error,
  }) {
    return TeamState(
      teams: teams ?? this.teams,
      selectedTeam: clearSelectedTeam ? null : (selectedTeam ?? this.selectedTeam),
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class TeamNotifier extends StateNotifier<TeamState> {
  final ApiClient _api;

  TeamNotifier(this._api) : super(const TeamState()) {
    _loadSavedTeam();
  }

  Future<void> _loadSavedTeam() async {
    final prefs = await SharedPreferences.getInstance();
    final teamId = prefs.getString(AppConstants.teamIdKey);
    if (teamId != null) {
      await fetchTeams();
      final team = state.teams.where((t) => t.id == teamId).firstOrNull;
      if (team != null) {
        state = state.copyWith(selectedTeam: team);
      }
    }
  }

  Future<void> fetchTeams() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // API returns raw array: [{id: "Team 1", name: "Riyadh (Team 1)", ...}]
      final list = await _api.getList(ApiEndpoints.teams);
      final teams = list
          .map((e) => Team.fromJson(e as Map<String, dynamic>))
          .toList();
      state = state.copyWith(teams: teams, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> selectTeam(Team team) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.teamIdKey, team.id);
    state = state.copyWith(selectedTeam: team);
  }

  Future<void> clearTeam() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.teamIdKey);
    state = state.copyWith(clearSelectedTeam: true);
  }

  void updateTeamFromSocket(Map<String, dynamic> data) {
    final updatedTeam = Team.fromJson(data);
    final teams = state.teams.map((t) =>
      t.id == updatedTeam.id ? updatedTeam : t
    ).toList();
    state = state.copyWith(
      teams: teams,
      selectedTeam: state.selectedTeam?.id == updatedTeam.id
          ? updatedTeam : state.selectedTeam,
    );
  }
}

final teamProvider = StateNotifierProvider<TeamNotifier, TeamState>((ref) {
  return TeamNotifier(ref.watch(apiClientProvider));
});
