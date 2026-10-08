import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/auth_provider.dart';
import '../../../providers/repository_providers.dart';
import '../../../providers/team_provider.dart';
import '../data/badge_models.dart';
import '../data/badges_repository.dart';
import '../data/gamification_session.dart';

final gamificationHttpProvider = Provider<GamificationHttp>(
  (ref) => GamificationHttp(ref.watch(apiClientProvider)),
);

final badgesRepositoryProvider = Provider<BadgesRepository>(
  (ref) => BadgesRepository(ref.watch(gamificationHttpProvider)),
);

/// Current mode + tokens, re-resolved whenever the self-paced session or the selected
/// corporate team changes.
final gamificationSessionProvider = FutureProvider<GamificationSession>((ref) async {
  ref.watch(authProvider.select((a) => a.token));
  ref.watch(authProvider.select((a) => a.user?.id));
  ref.watch(teamProvider.select((t) => t.selectedTeam?.id));
  return GamificationSession.load();
});

/// Static badge catalog (changes only with a server deploy). Auto-disposed so a failed
/// fetch is not cached for the session: the next visit (or a retry) fetches again.
final badgeCatalogProvider = FutureProvider.autoDispose<List<CatalogBadge>>((ref) {
  return ref.watch(badgesRepositoryProvider).catalog();
});

/// Badges earned by the current player: the corporate team's, or the signed-in learner's.
final myBadgesProvider = FutureProvider.autoDispose<List<EarnedBadge>>((ref) async {
  final session = await ref.watch(gamificationSessionProvider.future);
  final repo = ref.watch(badgesRepositoryProvider);
  switch (session.mode) {
    case GamificationMode.corporate:
      return repo.teamBadges(session.teamId!);
    case GamificationMode.selfPaced:
      return repo.learnerBadges(session.selfPacedToken!);
    case GamificationMode.none:
      return const [];
  }
});

/// Any team's badges (leaderboard rows). Open endpoint.
final teamBadgesProvider =
    FutureProvider.autoDispose.family<List<EarnedBadge>, String>((ref, teamId) {
  return ref.watch(badgesRepositoryProvider).teamBadges(teamId);
});

/// Podium for a round (corporate only — a self-paced learner has no peer group).
final podiumProvider =
    FutureProvider.autoDispose.family<List<PodiumDimension>, int>((ref, round) {
  return ref.watch(badgesRepositoryProvider).podium(round);
});

/// The player's current round (corporate: global game round; self-paced: own progress)
/// plus the learner's display name. Drives the default podium round and the evaluate ping.
final achievementsContextProvider =
    FutureProvider.autoDispose<({int round, String? displayName})>((ref) async {
  final session = await ref.watch(gamificationSessionProvider.future);
  final repo = ref.watch(badgesRepositoryProvider);
  try {
    if (session.isSelfPaced) return await repo.learnerProgress(session.selfPacedToken!);
    if (session.isCorporate) return (round: await repo.corporateRound(), displayName: null);
  } catch (_) {/* fall through */}
  return (round: 1, displayName: null);
});

/// Fire-and-forget badge evaluation, then refresh badge data — what the website does once
/// when the Achievements page mounts. Call it from wherever a round may just have been
/// completed (e.g. after confirming the final module); it is idempotent and throttled
/// server-side, so extra calls are cheap.
Future<BadgeEvaluation?> evaluateBadges(WidgetRef ref, {int? round}) async {
  try {
    final session = await ref.read(gamificationSessionProvider.future);
    if (session.mode == GamificationMode.none) return null;
    final repo = ref.read(badgesRepositoryProvider);
    final r = round ?? (await ref.read(achievementsContextProvider.future)).round;
    final result = session.isSelfPaced
        ? await repo.evaluateLearner(session.selfPacedToken!, r)
        : await repo.evaluateCorporate(r);
    ref.invalidate(myBadgesProvider);
    if (session.isCorporate) {
      ref.invalidate(podiumProvider);
      ref.invalidate(teamBadgesProvider);
    }
    return result;
  } catch (_) {
    return null; // page still renders previously earned badges
  }
}
