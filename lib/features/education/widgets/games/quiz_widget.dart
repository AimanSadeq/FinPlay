import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_colors.dart';

class QuizWidget extends StatefulWidget {
  final List<Map<String, dynamic>> questions; // [{question, options: [], correctIndex}]
  final VoidCallback onComplete;
  final ValueChanged<int> onScoreUpdate;

  const QuizWidget({
    super.key,
    required this.questions,
    required this.onComplete,
    required this.onScoreUpdate,
  });

  @override
  State<QuizWidget> createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {
  int _currentIndex = 0;
  int? _selectedOption;
  bool _answered = false;
  int _score = 0;
  int _correctCount = 0;

  void _selectOption(int index) {
    if (_answered) return;
    HapticFeedback.lightImpact();

    final isCorrect = index == widget.questions[_currentIndex]['correctIndex'];

    setState(() {
      _selectedOption = index;
      _answered = true;
      if (isCorrect) {
        _correctCount++;
      }
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
      // Website formula: Math.round((correctCount / questions.length) × 50)
      _score = (_correctCount / widget.questions.length * 50).round();
      widget.onScoreUpdate(_score);
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[_currentIndex];
    final options = question['options'] as List;
    final correctIndex = question['correctIndex'] as int;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress bar
        Row(
          children: [
            Text('Question ${_currentIndex + 1}/${widget.questions.length}',
              style: Theme.of(context).textTheme.bodySmall),
            const Spacer(),
            Text('$_correctCount correct',
              style: const TextStyle(color: AppColors.secondaryLight, fontWeight: FontWeight.w600, fontSize: 13)),
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

        // Question
        Text(
          question['question'] as String,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(height: 1.4),
        ),
        const SizedBox(height: 16),

        // Options
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
                      width: 28, height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: showCorrect
                            ? AppColors.secondary.withValues(alpha: 0.3)
                            : showWrong
                                ? AppColors.danger.withValues(alpha: 0.3)
                                : AppColors.cardColor(context),
                      ),
                      child: Center(child: Text(
                        String.fromCharCode(65 + i),
                        style: GoogleFonts.jetBrainsMono(fontSize: 13, fontWeight: FontWeight.w600,
                          color: showCorrect ? AppColors.secondaryLight
                              : showWrong ? AppColors.dangerLight
                              : AppColors.textTertiary(context)),
                      )),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(options[i] as String, style: Theme.of(context).textTheme.bodyMedium)),
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
          if (question['explanation'] != null)
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
                  Expanded(child: Text(question['explanation'] as String,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.4))),
                ],
              ),
            ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _nextQuestion,
              child: Text(_currentIndex < widget.questions.length - 1 ? 'Next Question' : 'Finish Quiz'),
            ),
          ),
        ],
      ],
    );
  }
}
