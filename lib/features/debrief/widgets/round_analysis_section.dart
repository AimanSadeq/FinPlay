import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/i18n/app_strings.dart';
import '../../../app/theme/app_colors.dart';
import 'debrief_coach_card.dart';
import 'decision_waterfall_card.dart';

/// "Round Analysis - How Your Decisions Shaped Round N": the collapsible panel on the
/// results dashboard holding the decision-impact waterfall and the AI debrief coach.
/// Closed by default, as on the website, so the counterfactual engine runs only on demand.
class RoundAnalysisSection extends ConsumerStatefulWidget {
  final String teamId;
  final int round;
  final bool selfPaced;

  const RoundAnalysisSection({
    super.key,
    required this.teamId,
    required this.round,
    this.selfPaced = false,
  });

  @override
  ConsumerState<RoundAnalysisSection> createState() => _RoundAnalysisSectionState();
}

class _RoundAnalysisSectionState extends ConsumerState<RoundAnalysisSection> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    const indigo = Color(0xFF4F46E5);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: indigo.withValues(alpha: 0.35), width: 1.5),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => setState(() => _open = !_open),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: indigo.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.bar_chart_rounded, color: indigo, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      s.tr('Round Analysis - How Your Decisions Shaped Round ${widget.round}',
                          'تحليل الجولة - كيف شكّلت قراراتك الجولة ${widget.round}'),
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                    ),
                  ),
                  Text(_open ? s.tr('Hide', 'إخفاء') : s.tr('Show', 'عرض'),
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary(context))),
                  AnimatedRotation(
                    turns: _open ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.expand_more_rounded, size: 20),
                  ),
                ],
              ),
            ),
          ),
          if (_open)
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  DecisionWaterfallCard(
                      teamId: widget.teamId, round: widget.round, selfPaced: widget.selfPaced),
                  const SizedBox(height: 12),
                  DebriefCoachCard(
                      teamId: widget.teamId, round: widget.round, selfPaced: widget.selfPaced),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
