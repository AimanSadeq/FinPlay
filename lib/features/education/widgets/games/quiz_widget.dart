import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../providers/locale_provider.dart';
import '../../modules/education_module_data.dart';

/// Multiple-choice quiz (website QuizComponent). Renders Arabic when the app
/// language is Arabic, falling back to English per field. Score on finish:
/// round(correct / questions × [maxScore]).
class QuizWidget extends ConsumerStatefulWidget {
  final List<QuizQuestion> questions;
  final int maxScore;
  final VoidCallback onComplete;
  final ValueChanged<int> onScoreUpdate;

  const QuizWidget({
    super.key,
    required this.questions,
    this.maxScore = 50,
    required this.onComplete,
    required this.onScoreUpdate,
  });

  /// Website formula: Math.round((correctCount / questions.length) * maxScore).
  static int scoreFor(int correct, int total, int maxScore) =>
      total == 0 ? 0 : (correct / total * maxScore).round();

  @override
  ConsumerState<QuizWidget> createState() => _QuizWidgetState();
}

class _QuizWidgetState extends ConsumerState<QuizWidget> {
  int _currentIndex = 0;
  int? _selectedOption;
  bool _answered = false;
  int _correctCount = 0;
  bool _finished = false;

  void _selectOption(int index) {
    if (_answered) return;
    HapticFeedback.lightImpact();
    final isCorrect = index == widget.questions[_currentIndex].correctIndex;
    setState(() {
      _selectedOption = index;
      _answered = true;
      if (isCorrect) _correctCount++;
    });
  }

  void _nextQuestion() {
    if (_currentIndex < widget.questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOption = null;
        _answered = false;
      });
    } else {
      final score =
          QuizWidget.scoreFor(_correctCount, widget.questions.length, widget.maxScore);
      setState(() => _finished = true);
      widget.onScoreUpdate(score);
      widget.onComplete();
    }
  }

  void _restart() {
    setState(() {
      _currentIndex = 0;
      _selectedOption = null;
      _answered = false;
      _correctCount = 0;
      _finished = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    String t(String en, String a) => ar ? a : en;
    if (widget.questions.isEmpty) return const SizedBox.shrink();

    if (_finished) {
      final score =
          QuizWidget.scoreFor(_correctCount, widget.questions.length, widget.maxScore);
      return Column(
        children: [
          const Icon(Icons.verified_rounded, color: AppColors.secondaryLight, size: 44),
          const SizedBox(height: 10),
          Text('$score / ${widget.maxScore}',
              style: GoogleFonts.jetBrainsMono(
                  fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.secondaryLight)),
          const SizedBox(height: 4),
          Text(
              t('$_correctCount of ${widget.questions.length} correct',
                  '$_correctCount من ${widget.questions.length} إجابات صحيحة'),
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _restart,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: Text(t('Try Again', 'حاول مجددًا')),
          ),
        ],
      ).animate().fadeIn();
    }

    final question = widget.questions[_currentIndex];
    final options = question.options;
    final correctIndex = question.correctIndex;
    final explanation = question.explanation.of(ar);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
                t('Question ${_currentIndex + 1}/${widget.questions.length}',
                    'السؤال ${_currentIndex + 1}/${widget.questions.length}'),
                style: Theme.of(context).textTheme.bodySmall),
            const Spacer(),
            Text(t('$_correctCount correct', '$_correctCount صحيحة'),
                style: const TextStyle(
                    color: AppColors.secondaryLight, fontWeight: FontWeight.w600, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (_currentIndex + 1) / widget.questions.length,
            backgroundColor: AppColors.cardColor(context),
            valueColor: const AlwaysStoppedAnimation(AppColors.primaryLight),
            minHeight: 4,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          question.question.of(ar),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(height: 1.4),
        ),
        const SizedBox(height: 16),
        ...List.generate(options.length, (i) {
          final isSelected = _selectedOption == i;
          final isCorrect = i == correctIndex;
          final showCorrect = _answered && isCorrect;
          final showWrong = _answered && isSelected && !isCorrect;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GestureDetector(
              onTap: () => _selectOption(i),
              child: AnimatedContainer(
                duration: 300.ms,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: showCorrect
                      ? AppColors.secondary.withValues(alpha: 0.15)
                      : showWrong
                          ? AppColors.danger.withValues(alpha: 0.1)
                          : isSelected
                              ? AppColors.primary.withValues(alpha: 0.1)
                              : AppColors.cardColor(context).withValues(alpha: 0.5),
                  border: Border.all(
                    color: showCorrect
                        ? AppColors.secondaryLight.withValues(alpha: 0.5)
                        : showWrong
                            ? AppColors.dangerLight.withValues(alpha: 0.4)
                            : isSelected
                                ? AppColors.primaryLight.withValues(alpha: 0.5)
                                : AppColors.borderColor(context),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: showCorrect
                            ? AppColors.secondary.withValues(alpha: 0.3)
                            : showWrong
                                ? AppColors.danger.withValues(alpha: 0.3)
                                : AppColors.cardColor(context),
                      ),
                      child: Center(
                          child: Text(
                        String.fromCharCode(65 + i),
                        style: GoogleFonts.jetBrainsMono(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: showCorrect
                                ? AppColors.secondaryLight
                                : showWrong
                                    ? AppColors.dangerLight
                                    : AppColors.textTertiary(context)),
                      )),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Text(options[i].of(ar),
                            style: Theme.of(context).textTheme.bodyMedium)),
                    if (showCorrect)
                      const Icon(Icons.check_circle, color: AppColors.secondaryLight, size: 20)
                    else if (showWrong)
                      const Icon(Icons.cancel, color: AppColors.dangerLight, size: 20),
                  ],
                ),
              ),
            ),
          );
        }),
        if (_answered) ...[
          const SizedBox(height: 8),
          if (explanation.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.primary.withValues(alpha: 0.05),
                border: Border.all(color: AppColors.primaryLight.withValues(alpha: 0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb_outline, color: AppColors.accentLight, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                      child: Text(explanation,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.4))),
                ],
              ),
            ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _nextQuestion,
              child: Text(_currentIndex < widget.questions.length - 1
                  ? t('Next Question', 'السؤال التالي')
                  : t('Finish Quiz', 'إنهاء الاختبار')),
            ),
          ),
        ],
      ],
    );
  }
}
