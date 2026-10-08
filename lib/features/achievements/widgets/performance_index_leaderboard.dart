import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/i18n/app_strings.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/glass_card.dart';
import '../data/badge_models.dart' show formatMoneyShort;
import '../data/performance_index_models.dart';
import '../providers/achievements_providers.dart';
import '../providers/performance_index_provider.dart';
import 'badge_shelf.dart';

/// Live leaderboard ranked on the FinPlay Performance Index (0–100) — port of the website's
/// components/LiveLeaderboard.tsx after d19723d. Self-contained: fetches /leaderboard/live
/// itself and re-polls every [refreshInterval]. Tap a team's index to see the five pillars
/// (Profitability 30 · Cash 20 · Financial health 25 · Efficiency 10 · Growth 15) and their
/// metrics. Each row carries the team's badge shelf, as on the website.
///
/// It is a plain box widget; inside a CustomScrollView wrap it in SliverToBoxAdapter.
class PerformanceIndexLeaderboard extends ConsumerStatefulWidget {
  /// Highlights this team's row (e.g. the player's own team).
  final String? highlightTeamId;
  final Duration refreshInterval;
  final bool showBadges;

  const PerformanceIndexLeaderboard({
    super.key,
    this.highlightTeamId,
    this.refreshInterval = const Duration(seconds: 30),
    this.showBadges = true,
  });

  @override
  ConsumerState<PerformanceIndexLeaderboard> createState() => _PerformanceIndexLeaderboardState();
}

class _PerformanceIndexLeaderboardState extends ConsumerState<PerformanceIndexLeaderboard> {
  Timer? _timer;
  String? _open; // teamId whose breakdown is expanded

  @override
  void initState() {
    super.initState();
    var ticks = 0;
    _timer = Timer.periodic(widget.refreshInterval, (_) {
      if (!mounted) return;
      // Stand down while another route covers this one (as MarketWireSection does).
      if (!(ModalRoute.of(context)?.isCurrent ?? true)) return;
      ref.invalidate(indexLeaderboardProvider);
      // Badge shelves refresh at half the rate (website BadgeShelf polls every 60s).
      if (widget.showBadges && (++ticks).isEven) ref.invalidate(teamBadgesProvider);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final async = ref.watch(indexLeaderboardProvider);
    final data = async.valueOrNull;
    final secs = widget.refreshInterval.inSeconds;

    Widget header = Row(
      children: [
        const Icon(Icons.leaderboard_rounded, size: 18, color: AppColors.accentLight),
        const SizedBox(width: 8),
        Expanded(
          child: Text(s.tr('Live Leaderboard', 'قائمة المتصدرين المباشرة'),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
        ),
        if (data != null) _pill(s.ar ? 'ج${data.round}' : 'R${data.round}', AppColors.primaryLight),
        const SizedBox(width: 6),
        Container(width: 8, height: 8, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.secondaryLight)),
        const SizedBox(width: 4),
        Text(s.tr('Live', 'مباشر'),
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.secondaryLight)),
      ],
    );

    Widget body;
    if (data == null && async.isLoading) {
      body = Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
          const SizedBox(height: 8),
          Text(s.tr('Updating rankings...', 'جاري تحديث التصنيفات...'),
              style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context))),
        ]),
      );
    } else if (data == null) {
      body = Center(
        child: Column(children: [
          Text(s.tr('Error loading rankings', 'خطأ في تحميل التصنيفات'),
              style: const TextStyle(fontSize: 12, color: AppColors.dangerLight)),
          TextButton.icon(
            onPressed: () => ref.invalidate(indexLeaderboardProvider),
            icon: const Icon(Icons.refresh, size: 16),
            label: Text(s.tr('Retry', 'إعادة المحاولة'), style: const TextStyle(fontSize: 12)),
          ),
        ]),
      );
    } else {
      final th = TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textTertiary(context));
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(children: [
              const SizedBox(width: 28),
              Expanded(child: Text(s.tr('Team', 'الفريق'), style: th)),
              SizedBox(width: 54, child: Text(s.tr('Index / 100', 'المؤشر / 100'), style: th, textAlign: TextAlign.center)),
              SizedBox(width: 26, child: Tooltip(message: s.tr('Cash Rich', 'شركة غنية نقداً'), child: const Text('💰', textAlign: TextAlign.center, style: TextStyle(fontSize: 11)))),
              SizedBox(width: 44, child: Text(s.tr('ROE', 'العائد'), style: th, textAlign: TextAlign.end)),
              SizedBox(width: 54, child: Text(s.tr('Net Income', 'صافي الدخل'), style: th, textAlign: TextAlign.end, maxLines: 1, overflow: TextOverflow.ellipsis)),
              SizedBox(width: 26, child: Text(s.tr('Trend', 'الاتجاه'), style: th, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.clip)),
            ]),
          ),
          Divider(height: 1, color: AppColors.borderColor(context).withValues(alpha: 0.3)),
          const SizedBox(height: 4),
          for (final (i, row) in data.rows.indexed) _row(context, s, i, row),
          const SizedBox(height: 4),
          Divider(height: 1, color: AppColors.borderColor(context).withValues(alpha: 0.3)),
          const SizedBox(height: 4),
          Text(
            s.ar ? '${data.totalTeams} فرق • تحديث كل $secsث' : '${data.totalTeams} teams • ${secs}s refresh',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: AppColors.textTertiary(context)),
          ),
        ],
      );
    }

    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [header, const SizedBox(height: 10), body]),
    );
  }

  Widget _pill(String text, Color c) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(color: c.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
        child: Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: c)),
      );

  Widget _row(BuildContext context, AppStrings s, int i, IndexLeaderboardRow r) {
    final rank = i + 1;
    final teamNum = int.tryParse(r.teamId.replaceAll(RegExp(r'[^0-9]'), '')) ?? rank;
    final color = AppColors.teamColor((teamNum - 1).clamp(0, 6));
    final mine = widget.highlightTeamId != null && widget.highlightTeamId == r.teamId;
    final open = _open == r.teamId && r.index != null;
    final mono = GoogleFonts.jetBrainsMono(fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.textSecondary(context));

    final Color? bg = switch (rank) {
      1 => const Color(0xFFFEFCE8),
      2 => const Color(0xFFF9FAFB),
      3 => const Color(0xFFFFF7ED),
      _ => null,
    };
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget rankWidget = switch (rank) {
      1 => const Icon(Icons.emoji_events_rounded, size: 16, color: Colors.amber),
      2 => Icon(Icons.workspace_premium_rounded, size: 16, color: Colors.grey.shade400),
      3 => Icon(Icons.military_tech_rounded, size: 16, color: Colors.brown.shade300),
      _ => Text('#$rank', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textTertiary(context))),
    };

    final scoreChip = GestureDetector(
      onTap: r.index == null ? null : () => setState(() => _open = open ? null : r.teamId),
      child: Tooltip(
        message: r.hasPlayed
            ? s.tr('Tap for the index breakdown', 'اضغط لعرض تفاصيل المؤشر')
            // NOT FROM THE WEBSITE (it just shows 0): explains a zero for an idle team.
            : s.tr('No confirmed decisions yet', 'لا توجد قرارات مؤكدة بعد'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(4)),
          child: Text(
            r.hasPlayed
                ? '${formatIndexScore(r.score)}'
                    '${r.index?.flags.distress == true ? ' ⚠' : ''}'
                    '${r.index?.flags.goingConcern == true ? ' ⛔' : ''}'
                : '—',
            textAlign: TextAlign.center,
            maxLines: 1,
            style: GoogleFonts.jetBrainsMono(fontSize: 11, fontWeight: FontWeight.w700, color: r.hasPlayed ? color : AppColors.textTertiary(context)),
          ),
        ),
      ),
    );

    final trend = r.rankChange > 0
        ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.trending_up_rounded, size: 13, color: AppColors.secondaryLight),
            Text('${r.rankChange}', style: const TextStyle(fontSize: 9, color: AppColors.secondary)),
          ])
        : r.rankChange < 0
            ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.trending_down_rounded, size: 13, color: AppColors.dangerLight),
                Text('${r.rankChange.abs()}', style: const TextStyle(fontSize: 9, color: AppColors.danger)),
              ])
            : Icon(Icons.remove_rounded, size: 13, color: AppColors.textTertiary(context));

    return Container(
      margin: const EdgeInsets.only(bottom: 3),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      decoration: BoxDecoration(
        color: isDark ? (bg != null ? Colors.white.withValues(alpha: 0.04) : null) : bg,
        borderRadius: BorderRadius.circular(6),
        border: mine ? Border.all(color: color.withValues(alpha: 0.7), width: 1.2) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [
            SizedBox(width: 28, child: Center(child: rankWidget)),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(width: 6, height: 6, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(r.displayName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, fontWeight: mine ? FontWeight.w800 : FontWeight.w600, color: AppColors.textPrimary(context))),
                  ),
                ]),
                if (widget.showBadges)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: BadgeShelf.team(r.teamId, size: BadgeShelfSize.sm, maxVisible: 5),
                  ),
              ]),
            ),
            SizedBox(width: 54, child: scoreChip),
            SizedBox(
              width: 26,
              child: Center(
                child: r.isCashRich
                    ? const Icon(Icons.check_circle_rounded, size: 14, color: AppColors.secondaryLight)
                    : Icon(Icons.cancel_outlined, size: 14, color: AppColors.textTertiary(context)),
              ),
            ),
            SizedBox(width: 44, child: Text('${r.roe.toStringAsFixed(1)}%', style: mono, textAlign: TextAlign.end)),
            SizedBox(
              width: 54,
              child: Text(formatMoneyShort(r.netIncome),
                  textAlign: TextAlign.end,
                  style: mono.copyWith(color: r.netIncome >= 0 ? AppColors.secondary : AppColors.dangerLight)),
            ),
            SizedBox(width: 26, child: trend),
          ]),
          if (open) IndexBreakdown(row: r),
        ],
      ),
    );
  }
}

/// The expandable pillar breakdown under a leaderboard row (website index-breakdown panel).
/// Public so the dashboard hero card can reuse it for the player's own team.
class IndexBreakdown extends ConsumerWidget {
  final IndexLeaderboardRow row;
  const IndexBreakdown({super.key, required this.row});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    final idx = row.index;
    if (idx == null) return const SizedBox.shrink();
    final base = TextStyle(fontSize: 11, color: AppColors.textSecondary(context));
    final strong = TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textPrimary(context));

    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor(context),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.borderColor(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(TextSpan(style: strong, children: [
            TextSpan(text: '${s.tr('FinPlay Performance Index', 'مؤشر أداء FinPlay')} ${formatIndexScore(idx.score)} / 100'),
            if (row.scoredRound > 0)
              TextSpan(
                text: '  ${s.ar ? 'الجولة ${row.scoredRound}' : 'Round ${row.scoredRound}'}',
                style: base.copyWith(fontWeight: FontWeight.w400),
              ),
          ])),
          if (idx.flags.goingConcern)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                s.tr('going concern: equity must be restored before borrowing or distributing',
                    'استمرارية: يجب استعادة حقوق الملكية قبل الاقتراض أو التوزيع'),
                style: base.copyWith(color: AppColors.danger),
              ),
            ),
          if (idx.flags.distress)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                s.ar
                    ? 'النقد سالب: الحد الأقصى ${formatIndexScore(idx.score)}'
                    : 'cash below zero: capped at 40 (uncapped ${formatIndexScore(idx.uncapped)})',
                style: base.copyWith(color: AppColors.dangerLight),
              ),
            ),
          const SizedBox(height: 6),
          for (final p in idx.pillars) ...[
            Row(children: [
              Expanded(child: Text(p.label.of(s.ar), style: strong)),
              Text('${formatPoints(p.points)} / ${formatPoints(p.max)}', style: strong),
            ]),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: p.fraction,
                  minHeight: 3,
                  backgroundColor: AppColors.borderColor(context).withValues(alpha: 0.4),
                  valueColor: const AlwaysStoppedAnimation(AppColors.primaryLight),
                ),
              ),
            ),
            for (final m in p.metrics)
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(
                    child: Text(
                      '${m.label.of(s.ar)}: ${m.display}${m.note != null ? ' (${m.note!.of(s.ar)})' : ''}',
                      style: base,
                    ),
                  ),
                  Text('${formatPoints(m.points)} / ${formatPoints(m.max)}', style: base),
                ]),
              ),
            const SizedBox(height: 6),
          ],
        ],
      ),
    );
  }
}
