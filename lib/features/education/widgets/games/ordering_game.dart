import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../providers/locale_provider.dart';
import '../../modules/education_module_data.dart';

/// Put-the-steps-in-order game (website OrderingGame). [steps] are given in
/// their correct order and shuffled for play. Checking scores
/// round(correctPositions / steps × [maxScore]) and completes the activity
/// (website parity); the learner may retry to improve.
class OrderingGame extends ConsumerStatefulWidget {
  final Bi instruction;
  final List<OrderStep> steps;
  final int maxScore;
  final VoidCallback onComplete;
  final ValueChanged<int> onScoreUpdate;

  const OrderingGame({
    super.key,
    required this.instruction,
    required this.steps,
    this.maxScore = 50,
    required this.onComplete,
    required this.onScoreUpdate,
  });

  static int scoreFor(int correct, int total, int maxScore) =>
      total == 0 ? 0 : (correct / total * maxScore).round();

  @override
  ConsumerState<OrderingGame> createState() => _OrderingGameState();
}

class _OrderingGameState extends ConsumerState<OrderingGame> {
  late List<OrderStep> _currentOrder;
  bool _showResult = false;
  bool _showHints = false;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _currentOrder = List.of(widget.steps)..shuffle();
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (_showResult) return;
    HapticFeedback.lightImpact();
    setState(() {
      if (newIndex > oldIndex) newIndex--;
      final item = _currentOrder.removeAt(oldIndex);
      _currentOrder.insert(newIndex, item);
    });
  }

  void _checkOrder() {
    HapticFeedback.mediumImpact();
    var correctCount = 0;
    for (var i = 0; i < _currentOrder.length; i++) {
      if (_currentOrder[i].id == widget.steps[i].id) correctCount++;
    }
    final score = OrderingGame.scoreFor(correctCount, widget.steps.length, widget.maxScore);
    setState(() {
      _showResult = true;
      _score = score;
    });
    widget.onScoreUpdate(score);
    widget.onComplete();
  }

  void _retry() {
    setState(() {
      _showResult = false;
      _currentOrder.shuffle();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    String t(String en, String a) => ar ? a : en;
    final hasHints = widget.steps.any((s) => s.hint.of(ar).isNotEmpty);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.instruction.of(ar), style: Theme.of(context).textTheme.bodyMedium),
        if (hasHints && !_showResult)
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: () => setState(() => _showHints = !_showHints),
              icon: Icon(_showHints ? Icons.visibility_off_rounded : Icons.lightbulb_outline,
                  size: 16),
              label: Text(_showHints ? t('Hide hints', 'إخفاء التلميحات') : t('Show hints', 'إظهار التلميحات')),
            ),
          ),
        const SizedBox(height: 8),
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: !_showResult,
          itemCount: _currentOrder.length,
          onReorder: _onReorder,
          proxyDecorator: (child, index, animation) => Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: AppColors.primaryLight.withValues(alpha: 0.3), blurRadius: 12)
                ],
              ),
              child: child,
            ),
          ),
          itemBuilder: (context, index) {
            final item = _currentOrder[index];
            final isCorrect = _showResult && item.id == widget.steps[index].id;
            final isWrong = _showResult && !isCorrect;
            final desc = item.description.of(ar);
            final hint = item.hint.of(ar);
            return Container(
              key: ValueKey(item.id),
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: isCorrect
                    ? AppColors.secondary.withValues(alpha: 0.15)
                    : isWrong
                        ? AppColors.danger.withValues(alpha: 0.1)
                        : AppColors.cardColor(context),
                border: Border.all(
                  color: isCorrect
                      ? AppColors.secondaryLight.withValues(alpha: 0.5)
                      : isWrong
                          ? AppColors.dangerLight.withValues(alpha: 0.3)
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
                      color: isCorrect
                          ? AppColors.secondary.withValues(alpha: 0.2)
                          : isWrong
                              ? AppColors.danger.withValues(alpha: 0.2)
                              : AppColors.cardColor(context),
                    ),
                    child: Center(
                      child: Text('${index + 1}',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: isCorrect
                                ? AppColors.secondaryLight
                                : isWrong
                                    ? AppColors.dangerLight
                                    : AppColors.textTertiary(context),
                          )),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name.of(ar),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600)),
                        if (desc.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(desc, style: Theme.of(context).textTheme.bodySmall),
                        ],
                        if (_showHints && hint.isNotEmpty && !_showResult) ...[
                          const SizedBox(height: 4),
                          Text(hint,
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontStyle: FontStyle.italic,
                                  color: AppColors.accentLight)),
                        ],
                        if (isWrong) ...[
                          const SizedBox(height: 4),
                          Text(
                              t('Correct position: ${widget.steps.indexWhere((s) => s.id == item.id) + 1}',
                                  'الموضع الصحيح: ${widget.steps.indexWhere((s) => s.id == item.id) + 1}'),
                              style: const TextStyle(fontSize: 11, color: AppColors.dangerLight)),
                        ],
                      ],
                    ),
                  ),
                  if (_showResult)
                    Icon(isCorrect ? Icons.check_circle : Icons.cancel,
                        color: isCorrect ? AppColors.secondaryLight : AppColors.dangerLight,
                        size: 20)
                  else
                    Icon(Icons.drag_handle, color: AppColors.textTertiary(context), size: 20),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        if (!_showResult)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _checkOrder,
              child: Text(t('Check Order', 'تحقق من الترتيب')),
            ),
          )
        else
          Row(
            children: [
              Text(t('Score: $_score / ${widget.maxScore}', 'النتيجة: $_score / ${widget.maxScore}'),
                  style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.secondaryLight)),
              const Spacer(),
              if (_score < widget.maxScore)
                OutlinedButton(
                  onPressed: _retry,
                  child: Text(t('Try Again', 'حاول مجددًا')),
                ),
            ],
          ),
      ],
    );
  }
}
