import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../providers/locale_provider.dart';
import '../../modules/education_module_data.dart';

/// Numeric calculation practice (website CalculatorExercise): each problem
/// shows its given figures and asks for one or more answers, checked within a
/// tolerance. Final score: round(correctInputs / totalInputs × [maxScore]).
class CalculatorExercise extends ConsumerStatefulWidget {
  final Bi instruction;
  final List<CalcProblem> problems;
  final int maxScore;
  final VoidCallback onComplete;
  final ValueChanged<int> onScoreUpdate;

  const CalculatorExercise({
    super.key,
    required this.instruction,
    required this.problems,
    this.maxScore = 50,
    required this.onComplete,
    required this.onScoreUpdate,
  });

  static int scoreFor(int correct, int totalInputs, int maxScore) =>
      totalInputs == 0 ? 0 : (correct / totalInputs * maxScore).round();

  @override
  ConsumerState<CalculatorExercise> createState() => _CalculatorExerciseState();
}

class _CalculatorExerciseState extends ConsumerState<CalculatorExercise> {
  int _index = 0;
  bool _showHints = false;
  bool _finished = false;
  late List<Map<String, TextEditingController>> _controllers;
  late List<Map<String, bool>?> _feedback; // null until submitted

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    _controllers = [
      for (final p in widget.problems)
        {for (final f in p.fields.where((f) => f.isAnswerable)) f.id: TextEditingController()}
    ];
    _feedback = List.filled(widget.problems.length, null);
    _index = 0;
    _finished = false;
    _showHints = false;
  }

  @override
  void dispose() {
    for (final m in _controllers) {
      for (final c in m.values) {
        c.dispose();
      }
    }
    super.dispose();
  }

  int get _totalInputs =>
      widget.problems.fold(0, (t, p) => t + p.fields.where((f) => f.isAnswerable).length);

  int get _totalCorrect => _feedback.fold(
      0, (t, fb) => t + (fb == null ? 0 : fb.values.where((v) => v).length));

  void _submit() {
    HapticFeedback.mediumImpact();
    final p = widget.problems[_index];
    setState(() {
      _feedback[_index] = {
        for (final f in p.fields.where((f) => f.isAnswerable))
          f.id: f.check(_controllers[_index][f.id]!.text),
      };
    });
  }

  void _next() {
    if (_index < widget.problems.length - 1) {
      setState(() {
        _index++;
        _showHints = false;
      });
      return;
    }
    final score = CalculatorExercise.scoreFor(_totalCorrect, _totalInputs, widget.maxScore);
    setState(() => _finished = true);
    widget.onScoreUpdate(score);
    widget.onComplete();
  }

  void _restart() {
    for (final m in _controllers) {
      for (final c in m.values) {
        c.dispose();
      }
    }
    setState(_init);
  }

  String _fmt(double v) {
    if (v == v.roundToDouble()) {
      final s = v.toInt().toString();
      return s.replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},');
    }
    return v.toString();
  }

  String _withUnit(double v, String unit) {
    if (unit.isEmpty) return _fmt(v);
    if (unit == '%') return '${_fmt(v)}%';
    if (unit.length <= 2) return '$unit${_fmt(v)}';
    return '${_fmt(v)} $unit';
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    String t(String en, String a) => ar ? a : en;
    if (widget.problems.isEmpty) return const SizedBox.shrink();

    if (_finished) {
      final score = CalculatorExercise.scoreFor(_totalCorrect, _totalInputs, widget.maxScore);
      return Column(
        children: [
          const Icon(Icons.calculate_rounded, color: AppColors.secondaryLight, size: 44),
          const SizedBox(height: 10),
          Text('$score / ${widget.maxScore}',
              style: GoogleFonts.jetBrainsMono(
                  fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.secondaryLight)),
          const SizedBox(height: 4),
          Text(t('$_totalCorrect of $_totalInputs answers correct',
              '$_totalCorrect من $_totalInputs إجابات صحيحة')),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _restart,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: Text(t('Try Again', 'حاول مجددًا')),
          ),
        ],
      );
    }

    final p = widget.problems[_index];
    final fb = _feedback[_index];
    final submitted = fb != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_index == 0 && widget.instruction.of(ar).isNotEmpty) ...[
          Text(widget.instruction.of(ar), style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 10),
        ],
        Row(
          children: [
            Text(
                t('Problem ${_index + 1}/${widget.problems.length}',
                    'المسألة ${_index + 1}/${widget.problems.length}'),
                style: Theme.of(context).textTheme.bodySmall),
            const Spacer(),
            TextButton.icon(
              onPressed: () => setState(() => _showHints = !_showHints),
              icon: Icon(_showHints ? Icons.visibility_off_rounded : Icons.lightbulb_outline,
                  size: 16),
              label: Text(_showHints ? t('Hide hints', 'إخفاء التلميحات') : t('Show hints', 'إظهار التلميحات')),
            ),
          ],
        ),
        Text(p.title.of(ar), style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 6),
        Text(p.scenario.of(ar),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5)),
        const SizedBox(height: 14),
        ...p.fields.map((f) {
          if (!f.isAnswerable) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(child: Text(f.label.of(ar), style: Theme.of(context).textTheme.bodySmall)),
                  Text(_withUnit(f.value ?? 0, f.unit),
                      textDirection: TextDirection.ltr,
                      style: GoogleFonts.jetBrainsMono(fontSize: 13, fontWeight: FontWeight.w600)),
                ],
              ),
            );
          }
          final ok = fb?[f.id];
          final hint = f.hint.of(ar);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(f.label.of(ar),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                if (_showHints && f.formula.isNotEmpty)
                  Text(f.formula,
                      textDirection: TextDirection.ltr,
                      style: const TextStyle(fontSize: 11, color: AppColors.accentLight)),
                if (_showHints && hint.isNotEmpty)
                  Text(hint,
                      style: const TextStyle(
                          fontSize: 11, fontStyle: FontStyle.italic, color: AppColors.accentLight)),
                const SizedBox(height: 6),
                TextField(
                  controller: _controllers[_index][f.id],
                  enabled: !submitted,
                  textDirection: TextDirection.ltr,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true, signed: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[-0-9.,]'))],
                  decoration: InputDecoration(
                    isDense: true,
                    border: const OutlineInputBorder(),
                    suffixText: f.unit.isEmpty ? null : f.unit,
                    suffixIcon: ok == null
                        ? null
                        : Icon(ok ? Icons.check_circle : Icons.cancel,
                            color: ok ? AppColors.secondaryLight : AppColors.dangerLight),
                  ),
                ),
                if (ok == false && f.correctAnswer != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                        t('Correct answer: ${_withUnit(f.correctAnswer!, f.unit)}',
                            'الإجابة الصحيحة: ${_withUnit(f.correctAnswer!, f.unit)}'),
                        style: const TextStyle(fontSize: 12, color: AppColors.dangerLight)),
                  ),
              ],
            ),
          );
        }),
        if (submitted && p.explanation.of(ar).isNotEmpty)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.primary.withValues(alpha: 0.05),
              border: Border.all(color: AppColors.primaryLight.withValues(alpha: 0.2)),
            ),
            child: Text(p.explanation.of(ar),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.4)),
          ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: submitted ? _next : _submit,
            child: Text(!submitted
                ? t('Check Answer', 'تحقق من الإجابة')
                : _index < widget.problems.length - 1
                    ? t('Next Problem', 'المسألة التالية')
                    : t('Finish', 'إنهاء')),
          ),
        ),
      ],
    );
  }
}
