import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/financial_data.dart';
import 'repository_providers.dart';
import 'team_provider.dart';
import 'auth_provider.dart';
import 'self_paced_provider.dart';

/// Per-round financials for the current team, indexed by round
/// (0 = baseline, 1..3 = rounds). This is the "game-data binding" layer that
/// lets the standalone education calculators surface real multi-period trends
/// the way the website does. When no team/game data is available the calculators
/// keep working as sandboxes.
class GameMetricsState {
  /// Index 0..3. Null = that round has no data yet.
  final List<FinancialData?> rounds;
  final bool isLoading;
  final bool loaded;

  const GameMetricsState({
    this.rounds = const [null, null, null, null],
    this.isLoading = false,
    this.loaded = false,
  });

  bool get hasData => rounds.any((r) => r != null);

  /// Most recent round that has data (highest round index), or null.
  FinancialData? get latest {
    for (var i = rounds.length - 1; i >= 0; i--) {
      if (rounds[i] != null) return rounds[i];
    }
    return null;
  }

  static const roundLabels = ['Baseline', 'R1', 'R2', 'R3'];

  /// Extract a value per round via [selector]; null where the round is missing.
  List<double?> series(double? Function(FinancialData) selector) =>
      [for (final r in rounds) r == null ? null : selector(r)];

  GameMetricsState copyWith({List<FinancialData?>? rounds, bool? isLoading, bool? loaded}) =>
      GameMetricsState(
        rounds: rounds ?? this.rounds,
        isLoading: isLoading ?? this.isLoading,
        loaded: loaded ?? this.loaded,
      );
}

class GameMetricsNotifier extends StateNotifier<GameMetricsState> {
  final Ref ref;
  GameMetricsNotifier(this.ref) : super(const GameMetricsState());

  /// Resolve the team whose history we should plot. Team mode uses the selected
  /// team. Self-paced learners have no team — their history is computed from
  /// their OWN decisions via the per-learner endpoint (see [_isSelfPaced]).
  String? _resolveTeamId() {
    final team = ref.read(teamProvider).selectedTeam;
    if (team != null) return team.id;
    final auth = ref.read(authProvider);
    if (auth.user != null) return 'self'; // sentinel; not sent for self-paced
    return null;
  }

  bool get _isSelfPaced {
    final team = ref.read(teamProvider).selectedTeam;
    final auth = ref.read(authProvider);
    return team == null && auth.user != null;
  }

  Future<void> load({bool force = false}) async {
    if (state.isLoading) return;
    if (state.loaded && !force) return;
    final teamId = _resolveTeamId();
    if (teamId == null) {
      state = state.copyWith(loaded: true);
      return;
    }
    final selfPaced = _isSelfPaced;

    // Self-paced learners must only see rounds they've actually played; the
    // engine can project future rounds but the website hides them (eb0bf79).
    int maxRound = 3;
    if (selfPaced) {
      final sp = ref.read(selfPacedProvider);
      maxRound = sp.currentModule == 'complete'
          ? 3
          : (sp.currentRound - 1).clamp(0, 3);
    }

    state = state.copyWith(isLoading: true);
    final repo = ref.read(gameRepositoryProvider);
    final results = List<FinancialData?>.filled(4, null);
    await Future.wait([
      for (var r = 0; r < 4; r++)
        () async {
          if (r > maxRound) return; // unplayed future round — leave null
          try {
            results[r] = await repo.fetchFinancialData(teamId, round: r, selfPaced: selfPaced);
          } catch (_) {
            // Round not played / unavailable — leave null.
          }
        }(),
    ]);
    if (mounted) state = GameMetricsState(rounds: results, isLoading: false, loaded: true);
  }
}

final gameMetricsProvider =
    StateNotifierProvider<GameMetricsNotifier, GameMetricsState>((ref) => GameMetricsNotifier(ref));
