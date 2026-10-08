import 'gamification_session.dart';
import 'badge_models.dart';

/// Endpoint paths for the badge API (relative to the ApiClient's `/api` base).
///
/// Kept local to this feature because api_endpoints.dart is owned elsewhere; they can be
/// moved there verbatim.
class BadgeEndpoints {
  BadgeEndpoints._();
  static const String catalog = '/badges/catalog';
  static const String podium = '/badges/podium'; // ?round=1..3
  static const String evaluate = '/badges/evaluate'; // corporate, open
  static String team(String teamId) => '/badges/team/${Uri.encodeComponent(teamId)}';
  static const String selfPacedEvaluate = '/badges/self-paced/evaluate'; // Bearer
  static const String selfPacedMine = '/badges/self-paced/mine'; // Bearer
  static const String roundState = '/game/round/state';
  static const String selfPacedProgressCurrent = '/self-paced/progress/current'; // Bearer
}

class BadgesRepository {
  final GamificationHttp _http;
  BadgesRepository(this._http);

  static int clampRound(int r) => r < 1 ? 1 : (r > 3 ? 3 : r);

  Future<List<CatalogBadge>> catalog() async =>
      parseCatalog(await _http.get(BadgeEndpoints.catalog));

  /// Corporate team badges (open endpoint, no auth — same as the website).
  Future<List<EarnedBadge>> teamBadges(String teamId) async =>
      parseEarned(await _http.get(BadgeEndpoints.team(teamId)));

  /// The signed-in learner's badges; userId comes from the token server-side.
  Future<List<EarnedBadge>> learnerBadges(String token) async =>
      parseEarned(await _http.get(BadgeEndpoints.selfPacedMine, bearer: token));

  Future<List<PodiumDimension>> podium(int round) async => parsePodium(
      await _http.get(BadgeEndpoints.podium, query: {'round': clampRound(round)}));

  /// Corporate: the global round from /game/round/state (roundNum), clamped 1..3.
  Future<int> corporateRound() async {
    final r = await _http.get(BadgeEndpoints.roundState);
    final n = r['roundNum'];
    return clampRound(n is num ? n.toInt() : 1);
  }

  /// Self-paced: progress.currentRound (+ displayName) from /self-paced/progress/current.
  Future<({int round, String? displayName})> learnerProgress(String token) async {
    final r = await _http.get(BadgeEndpoints.selfPacedProgressCurrent, bearer: token);
    final p = r['progress'];
    if (p is! Map) return (round: 1, displayName: null);
    final n = p['currentRound'];
    return (
      round: clampRound(n is num ? n.toInt() : 1),
      displayName: p['displayName']?.toString(),
    );
  }

  /// Ping evaluation. The round is only a throttle-key hint: the server derives the
  /// eligible (COMPLETED) rounds itself, is idempotent and throttles to one real run per
  /// round per 30s. Body: { round }.
  Future<BadgeEvaluation> evaluateCorporate(int round) async => BadgeEvaluation.fromResponse(
      await _http.post(BadgeEndpoints.evaluate, data: {'round': clampRound(round)}));

  Future<BadgeEvaluation> evaluateLearner(String token, int round) async =>
      BadgeEvaluation.fromResponse(await _http.post(BadgeEndpoints.selfPacedEvaluate,
          bearer: token, data: {'round': clampRound(round)}));
}
