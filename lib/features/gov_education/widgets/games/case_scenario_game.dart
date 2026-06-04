import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../providers/locale_provider.dart';
import '../../screens/modules/case_scenario_data.dart';

/// Interactive Case Scenario Simulator — walks the learner through one or more
/// multi-step role-play decision cases, scoring each choice and reporting an
/// accuracy-based score out of 100. Ports the website's CaseScenarioSimulator.
class CaseScenarioGame extends ConsumerStatefulWidget {
  final List<CaseScenario> scenarios;
  final VoidCallback onComplete;
  final ValueChanged<int> onScoreUpdate;

  const CaseScenarioGame({
    super.key,
    required this.scenarios,
    required this.onComplete,
    required this.onScoreUpdate,
  });

  @override
  ConsumerState<CaseScenarioGame> createState() => _CaseScenarioGameState();
}

class _CaseScenarioGameState extends ConsumerState<CaseScenarioGame> {
  int _scenarioIndex = 0;
  int _stepIndex = 0;
  int _correct = 0;
  int _totalAnswered = 0;
  CaseOption? _selected;
  bool _finished = false;

  CaseScenario get _scenario => widget.scenarios[_scenarioIndex];
  CaseStep get _step => _scenario.steps[_stepIndex];

  int get _totalSteps =>
      widget.scenarios.fold(0, (sum, s) => sum + s.steps.length);

  int get _scoreOutOf100 =>
      _totalSteps == 0 ? 0 : ((_correct / _totalSteps) * 100).round();

  // Icon + color per step type; the label is localized in [_typeLabel].
  static const _typeMeta = {
    CaseStepType.analysis: (Icons.search_rounded, AppColors.info),
    CaseStepType.decision: (Icons.alt_route_rounded, AppColors.primaryLight),
    CaseStepType.recommendation: (Icons.recommend_rounded, AppColors.secondaryLight),
    CaseStepType.stakeholder: (Icons.groups_rounded, AppColors.accentLight),
  };

  String _typeLabel(CaseStepType type, bool ar) {
    switch (type) {
      case CaseStepType.analysis:
        return ar ? 'تحليل' : 'Analysis';
      case CaseStepType.decision:
        return ar ? 'قرار' : 'Decision';
      case CaseStepType.recommendation:
        return ar ? 'توصية' : 'Recommendation';
      case CaseStepType.stakeholder:
        return ar ? 'أصحاب المصلحة' : 'Stakeholder';
    }
  }

  void _choose(CaseOption option) {
    if (_selected != null) return;
    HapticFeedback.selectionClick();
    setState(() {
      _selected = option;
      _totalAnswered++;
      if (option.isCorrect) _correct++;
    });
    widget.onScoreUpdate(_scoreOutOf100);
  }

  void _next() {
    setState(() {
      _selected = null;
      if (_stepIndex < _scenario.steps.length - 1) {
        _stepIndex++;
      } else if (_scenarioIndex < widget.scenarios.length - 1) {
        _scenarioIndex++;
        _stepIndex = 0;
      } else {
        _finished = true;
      }
    });
    if (_finished) {
      HapticFeedback.heavyImpact();
      widget.onScoreUpdate(_scoreOutOf100);
      widget.onComplete();
    }
  }

  void _restart() {
    setState(() {
      _scenarioIndex = 0;
      _stepIndex = 0;
      _correct = 0;
      _totalAnswered = 0;
      _selected = null;
      _finished = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    if (_finished) return _buildResults(ar);

    final meta = _typeMeta[_step.type]!;
    final stepNo = _stepIndex + 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Scenario header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(_scenario.titleFor(ar),
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  Text(
                      ar
                          ? 'حالة ${_scenarioIndex + 1}/${widget.scenarios.length}'
                          : 'Case ${_scenarioIndex + 1}/${widget.scenarios.length}',
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
              const SizedBox(height: 4),
              Text(_scenario.roleFor(ar),
                  style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: AppColors.textSecondary(context))),
              const SizedBox(height: 8),
              Text(_scenario.overviewFor(ar),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.5)),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Step type chip
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: meta.$2.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(meta.$1, size: 14, color: meta.$2),
                  const SizedBox(width: 5),
                  Text(_typeLabel(_step.type, ar).toUpperCase(),
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: meta.$2, letterSpacing: 0.5)),
                ],
              ),
            ),
            const Spacer(),
            Text(
                ar
                    ? 'خطوة $stepNo/${_scenario.steps.length}'
                    : 'Step $stepNo/${_scenario.steps.length}',
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        const SizedBox(height: 12),

        Text(_step.promptFor(ar),
            style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700, height: 1.4)),
        const SizedBox(height: 14),

        // Options
        ..._step.options.map((o) => _buildOption(o, ar)),

        // Feedback + consequence
        if (_selected != null) ...[
          const SizedBox(height: 8),
          _buildFeedback(ar),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _next,
              child: Text(
                _stepIndex == _scenario.steps.length - 1 &&
                        _scenarioIndex == widget.scenarios.length - 1
                    ? (ar ? 'عرض النتائج' : 'View Results')
                    : (ar ? 'الخطوة التالية' : 'Next Step'),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildOption(CaseOption option, bool ar) {
    final answered = _selected != null;
    final isChosen = identical(option, _selected);
    Color border = AppColors.borderColor(context);
    Color bg = AppColors.cardColor(context);
    if (answered && option.isCorrect) {
      border = AppColors.secondaryLight;
      bg = AppColors.secondary.withValues(alpha: 0.08);
    } else if (answered && isChosen && !option.isCorrect) {
      border = AppColors.dangerLight;
      bg = AppColors.danger.withValues(alpha: 0.08);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: answered ? null : () => _choose(option),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: border, width: 1.4),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(option.textFor(ar),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.35)),
                ),
                if (answered && option.isCorrect)
                  const Icon(Icons.check_circle_rounded, color: AppColors.secondaryLight, size: 20)
                else if (answered && isChosen)
                  const Icon(Icons.cancel_rounded, color: AppColors.dangerLight, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeedback(bool ar) {
    final ok = _selected!.isCorrect;
    final c = ok ? AppColors.secondaryLight : AppColors.dangerLight;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: c.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(ok ? Icons.lightbulb_rounded : Icons.info_rounded, size: 16, color: c),
              const SizedBox(width: 6),
              Text(ok ? (ar ? 'اختيار موفّق' : 'Good call') : (ar ? 'أعد النظر' : 'Reconsider'),
                  style: TextStyle(fontWeight: FontWeight.w700, color: c, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 6),
          Text(_selected!.feedbackFor(ar),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.4)),
          if (_selected!.consequenceFor(ar) != null) ...[
            const SizedBox(height: 8),
            Text('→ ${_selected!.consequenceFor(ar)!}',
                style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: AppColors.textSecondary(context))),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 200.ms);
  }

  Widget _buildResults(bool ar) {
    final score = _scoreOutOf100;
    final great = score >= 80;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(great ? Icons.workspace_premium_rounded : Icons.fact_check_rounded,
            size: 48, color: great ? AppColors.accentLight : AppColors.primaryLight),
        const SizedBox(height: 12),
        Text(great ? (ar ? 'أداء متميّز!' : 'Outstanding Performance!') : (ar ? 'اكتملت الحالة' : 'Scenario Complete'),
            style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text('$score',
            style: GoogleFonts.jetBrainsMono(
                fontSize: 40,
                fontWeight: FontWeight.w800,
                color: great ? AppColors.accentLight : AppColors.primaryLight)),
        Text(ar ? 'من 100' : 'out of 100', style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 8),
        Text(
            ar
                ? '$_correct من $_totalAnswered قرارات صحيحة'
                : '$_correct of $_totalAnswered correct decisions',
            style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: _restart,
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: Text(ar ? 'حاول مجددًا' : 'Try Again'),
        ),
      ],
    ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9));
  }
}
