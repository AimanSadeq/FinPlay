import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/i18n/app_strings.dart';
import '../../../app/theme/app_colors.dart';
import '../../../providers/team_provider.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../sim_certificate/providers/sim_certificate_provider.dart';
import '../../sim_certificate/widgets/sim_certificate_panel.dart';
import '../data/badge_models.dart';
import '../data/gamification_session.dart';
import '../providers/achievements_providers.dart';
import '../widgets/badge_shelf.dart';
import '../widgets/podium_section.dart';

/// Achievements — port of the website's pages/achievements.tsx (route /achievements).
///
///   1. Your Badges     earned concept badges (team's or learner's)
///   2. Badge Catalog   every badge; locked ones show the unlock hint
///   3. Certificate     the shareable simulation certificate (both modes)
///   4. Podium          corporate only — a self-paced learner has no peer group
///
/// On open it pings badge evaluation once (the server evaluates COMPLETED rounds only,
/// idempotent + throttled) and then refreshes, exactly like the website.
///
/// Arabic: the website page is English-only; the Arabic strings here are the app's own,
/// except badge names (server `nameAr`).
class AchievementsScreen extends ConsumerStatefulWidget {
  const AchievementsScreen({super.key});

  @override
  ConsumerState<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends ConsumerState<AchievementsScreen> {
  bool _evaluated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _evaluateOnce());
  }

  Future<void> _evaluateOnce() async {
    if (_evaluated) return;
    _evaluated = true;
    await evaluateBadges(ref);
  }

  Future<void> _refresh() async {
    await evaluateBadges(ref);
    ref.invalidate(badgeCatalogProvider);
    ref.invalidate(simCertificateStatusProvider);
    ref.invalidate(achievementsContextProvider);
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final sessionAsync = ref.watch(gamificationSessionProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.military_tech_rounded, color: AppColors.accentLight),
          const SizedBox(width: 8),
          Text(s.tr('Achievements', 'الإنجازات')),
        ]),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: s.tr('Back to Dashboard', 'العودة إلى لوحة المعلومات'),
          onPressed: () => context.canPop() ? context.pop() : context.go('/dashboard'),
        ),
      ),
      body: sessionAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => _noSession(context, s),
        data: (session) {
          if (session.mode == GamificationMode.none) return _noSession(context, s);
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              children: [
                _yourBadges(context, s, session),
                const SizedBox(height: 16),
                _catalog(context, s),
                const SizedBox(height: 16),
                const SimCertificatePanel(),
                if (session.isCorporate) ...[
                  const SizedBox(height: 16),
                  PodiumSection(
                    initialRound: ref.watch(achievementsContextProvider).valueOrNull?.round ?? 1,
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _noSession(BuildContext context, AppStrings s) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.military_tech_outlined, size: 48, color: AppColors.textTertiary(context)),
            const SizedBox(height: 12),
            Text(
              s.tr('Join a team or sign in to start collecting badges.',
                  'انضم إلى فريق أو سجّل الدخول لتبدأ في جمع الشارات.'),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go('/mode-selector'),
              child: Text(s.tr('Get started', 'ابدأ')),
            ),
          ]),
        ),
      );

  Widget _sectionTitle(BuildContext context, IconData icon, Color color, String text, {Widget? trailing}) => Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          ),
          ?trailing,
        ],
      );

  Widget _yourBadges(BuildContext context, AppStrings s, GamificationSession session) {
    final badgesAsync = ref.watch(myBadgesProvider);
    final catalog = ref.watch(badgeCatalogProvider).valueOrNull ?? const <CatalogBadge>[];
    final who = session.isSelfPaced
        ? (ref.watch(achievementsContextProvider).valueOrNull?.displayName ??
            s.tr('Self-Paced Learner', 'متعلّم ذاتي'))
        : (ref.watch(teamProvider).selectedTeam?.name ?? session.teamId ?? '');

    final earned = badgesAsync.valueOrNull ?? const <EarnedBadge>[];
    final earnedIds = earned.map((b) => b.id).toSet();
    final earnedCatalog = catalog.where((b) => earnedIds.contains(b.id)).toList();

    Widget body;
    if (badgesAsync.isLoading && earned.isEmpty) {
      body = _muted(context, s.tr('Loading badges…', 'جارٍ تحميل الشارات…'));
    } else if (earned.isEmpty) {
      body = _muted(
        context,
        s.tr(
          'No badges earned yet. Confirm decisions and manage your financials to start collecting — every badge below explains how to unlock it.',
          'لم تحصل على أي شارة بعد. أكّد قراراتك وأدِر قوائمك المالية لتبدأ في جمعها — كل شارة أدناه توضح كيفية فتحها.',
        ),
      );
    } else {
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BadgeShelfStrip(badges: earned, size: BadgeShelfSize.lg),
          const SizedBox(height: 12),
          for (final b in earnedCatalog)
            _badgeTile(context, s, b, earned: true, round: earnedRoundFor(earned, b.id)),
        ],
      );
    }

    return GlassCard(
      padding: const EdgeInsets.all(16),
      borderColor: AppColors.accentLight.withValues(alpha: 0.45),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            context,
            Icons.military_tech_rounded,
            AppColors.accentLight,
            s.tr('Your Badges', 'شاراتك'),
            trailing: who.isEmpty
                ? null
                : Container(
                    constraints: const BoxConstraints(maxWidth: 160),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.cardColor(context),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(who,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                  ),
          ),
          const SizedBox(height: 12),
          body,
        ],
      ),
    );
  }

  Widget _catalog(BuildContext context, AppStrings s) {
    final catalogAsync = ref.watch(badgeCatalogProvider);
    final earnedIds = (ref.watch(myBadgesProvider).valueOrNull ?? const <EarnedBadge>[]).map((b) => b.id).toSet();
    final catalog = catalogAsync.valueOrNull ?? const <CatalogBadge>[];

    return GlassCard(
      padding: const EdgeInsets.all(16),
      borderColor: AppColors.primaryLight.withValues(alpha: 0.45),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(context, Icons.lock_rounded, AppColors.primaryLight, s.tr('Badge Catalog', 'دليل الشارات')),
          const SizedBox(height: 4),
          Text(
            s.tr('Every badge names a financial concept. Locked badges show how to unlock them.',
                'كل شارة تحمل اسم مفهوم مالي. الشارات المقفلة توضح كيفية فتحها.'),
            style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context)),
          ),
          const SizedBox(height: 12),
          if (catalog.isEmpty)
            catalogAsync.hasError
                ? Row(children: [
                    Expanded(child: _muted(context, s.tr('Could not load the catalog.', 'تعذّر تحميل دليل الشارات.'))),
                    TextButton(
                      onPressed: () => ref.invalidate(badgeCatalogProvider),
                      child: Text(s.tr('Retry', 'إعادة المحاولة')),
                    ),
                  ])
                : _muted(context, s.tr('Loading catalog…', 'جارٍ تحميل الدليل…'))
          else
            for (final b in catalog) _badgeTile(context, s, b, earned: earnedIds.contains(b.id), catalogMode: true),
        ],
      ),
    );
  }

  Widget _muted(BuildContext context, String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(text, style: TextStyle(fontSize: 13, color: AppColors.textTertiary(context))),
      );

  Widget _badgeTile(BuildContext context, AppStrings s, CatalogBadge b,
      {required bool earned, int? round, bool catalogMode = false}) {
    final locked = catalogMode && !earned;
    final desc = b.localizedDescription(s.ar);
    final tile = Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: locked
            ? AppColors.cardColor(context)
            : (catalogMode ? AppColors.surfaceColor(context) : const Color(0xFFFFFBEB)),
        border: Border.all(
          color: locked ? AppColors.borderColor(context) : const Color(0xFFFDE68A),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(b.icon, style: const TextStyle(fontSize: 28, height: 1.1)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6,
                  children: [
                    Text(b.localizedName(s.ar),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: catalogMode ? null : const Color(0xFF111827),
                        )),
                    if (locked) Icon(Icons.lock_rounded, size: 12, color: Colors.grey.shade500),
                    if (round != null)
                      Text(s.tr('Earned in Round $round', 'حُصلت في الجولة $round'),
                          style: const TextStyle(fontSize: 11, color: AppColors.accentDark)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  locked ? '${s.tr('Unlock hint', 'تلميح الفتح')}: $desc' : desc,
                  style: TextStyle(
                    fontSize: 12,
                    color: catalogMode ? AppColors.textSecondary(context) : const Color(0xFF4B5563),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    if (!locked) return tile;
    // Website: grayscale + 70% opacity for locked badges.
    return Opacity(
      opacity: 0.7,
      child: ColorFiltered(
        colorFilter: const ColorFilter.matrix(<double>[
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0, 0, 0, 1, 0,
        ]),
        child: tile,
      ),
    );
  }
}
