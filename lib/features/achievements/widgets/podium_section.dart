import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/i18n/app_strings.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/glass_card.dart';
import '../data/badge_models.dart';
import '../providers/achievements_providers.dart';

/// Multi-dimension podium (Profitability / Resilience / Most Improved) for a round, from
/// GET /badges/podium?round=N. Corporate only. Port of the podium card in the website's
/// pages/achievements.tsx. Pass [initialRound] (the current game round).
class PodiumSection extends ConsumerStatefulWidget {
  final int initialRound;
  const PodiumSection({super.key, required this.initialRound});

  @override
  ConsumerState<PodiumSection> createState() => _PodiumSectionState();
}

class _PodiumSectionState extends ConsumerState<PodiumSection> {
  int? _selected;

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final round = _selected ?? widget.initialRound.clamp(1, 3);
    final async = ref.watch(podiumProvider(round));

    return GlassCard(
      padding: const EdgeInsets.all(16),
      borderColor: const Color(0xFFEAB308).withValues(alpha: 0.45),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.emoji_events_rounded, color: Color(0xFFEAB308), size: 20),
              const SizedBox(width: 8),
              Text(s.tr('Podium', 'منصة التتويج'),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              const Spacer(),
              Text('${s.tr('Round', 'الجولة')}:',
                  style: TextStyle(fontSize: 11, color: AppColors.textTertiary(context))),
              const SizedBox(width: 4),
              for (final r in [1, 2, 3])
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 4),
                  child: ChoiceChip(
                    label: Text('$r'),
                    selected: round == r,
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onSelected: (_) => setState(() => _selected = r),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            s.tr("Three ways to win — computed live from every team's financial statements.",
                'ثلاث طرق للفوز — تُحسب مباشرة من القوائم المالية لكل فريق.'),
            style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context)),
          ),
          const SizedBox(height: 12),
          async.when(
            loading: () => _note(context, s.tr('Computing podium…', 'جارٍ حساب منصة التتويج…')),
            error: (_, _) => _note(context, s.tr('Podium data is not available yet.', 'بيانات منصة التتويج غير متاحة بعد.')),
            data: (dims) {
              if (dims.isEmpty) {
                return _note(context, s.tr('Podium data is not available yet.', 'بيانات منصة التتويج غير متاحة بعد.'));
              }
              return Column(
                children: [
                  for (final d in dims) _DimensionCard(dim: d, s: s),
                  if (round == 1) _mostImprovedPlaceholder(context, s),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _note(BuildContext context, String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(text, style: TextStyle(fontSize: 13, color: AppColors.textTertiary(context))),
      );

  Widget _mostImprovedPlaceholder(BuildContext context, AppStrings s) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderColor(context)),
          color: AppColors.cardColor(context).withValues(alpha: 0.5),
        ),
        child: Column(children: [
          Text('📈 ${s.tr('Most Improved', 'الأكثر تحسنًا')}',
              style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textTertiary(context))),
          const SizedBox(height: 4),
          Text(
            s.tr('Available from Round 2 — measured as the Net Income gain versus the prior round.',
                'متاح من الجولة 2 — يُقاس بزيادة صافي الدخل مقارنة بالجولة السابقة.'),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context)),
          ),
        ]),
      );
}

class _DimensionCard extends StatelessWidget {
  final PodiumDimension dim;
  final AppStrings s;
  const _DimensionCard({required this.dim, required this.s});

  @override
  Widget build(BuildContext context) {
    final mono = GoogleFonts.jetBrainsMono(fontSize: 12, fontWeight: FontWeight.w700);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor(context)),
        color: AppColors.surfaceColor(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${dim.icon} ${dim.localizedLabel(s.ar)}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(dim.localizedDescription(s.ar),
              style: TextStyle(fontSize: 11, color: AppColors.textTertiary(context))),
          const SizedBox(height: 10),
          if (dim.winner == null)
            Text(s.tr('No data for this round yet.', 'لا توجد بيانات لهذه الجولة بعد.'),
                style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context)))
          else ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFEFCE8),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFEF08A)),
              ),
              child: Row(children: [
                Expanded(
                  child: Text('🥇 ${dim.winner!.teamId}',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF111827))),
                ),
                Text(dim.formatValue(dim.winner!.value), style: mono.copyWith(color: const Color(0xFFA16207))),
              ]),
            ),
            for (final (i, e) in dim.runnersUp.indexed)
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 6, 10, 0),
                child: Row(children: [
                  Expanded(
                    child: Text('${i == 0 ? '🥈' : i == 1 ? '🥉' : '·'} ${e.teamId}',
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary(context))),
                  ),
                  Text(dim.formatValue(e.value),
                      style: mono.copyWith(fontWeight: FontWeight.w500, color: AppColors.textSecondary(context))),
                ]),
              ),
          ],
        ],
      ),
    );
  }
}
