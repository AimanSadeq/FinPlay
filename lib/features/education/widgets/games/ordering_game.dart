import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/theme/app_colors.dart';

class OrderingGame extends StatefulWidget {
  final String instruction;
  final List<String> correctOrder;
  final VoidCallback onComplete;
  final ValueChanged<int> onScoreUpdate;

  const OrderingGame({
    super.key,
    required this.instruction,
    required this.correctOrder,
    required this.onComplete,
    required this.onScoreUpdate,
  });

  @override
  State<OrderingGame> createState() => _OrderingGameState();
}

class _OrderingGameState extends State<OrderingGame> {
  late List<String> _currentOrder;
  bool _showResult = false;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _currentOrder = List.from(widget.correctOrder)..shuffle();
  }

  void _onReorder(int oldIndex, int newIndex) {
    HapticFeedback.lightImpact();
    setState(() {
      if (newIndex > oldIndex) newIndex--;
      final item = _currentOrder.removeAt(oldIndex);
      _currentOrder.insert(newIndex, item);
    });
  }

  void _checkOrder() {
    HapticFeedback.mediumImpact();
    int correctCount = 0;
    for (int i = 0; i < _currentOrder.length; i++) {
      if (_currentOrder[i] == widget.correctOrder[i]) {
        correctCount++;
      }
    }

    // Website formula: Math.round((correct / total) × maxScore)
    // Default maxScore for ordering games is 50
    final score = (correctCount / widget.correctOrder.length * 50).round();

    setState(() {
      _showResult = true;
      _score = score;
      widget.onScoreUpdate(_score);
    });

    if (correctCount == widget.correctOrder.length) {
      widget.onComplete();
    }
  }

  void _retry() {
    setState(() {
      _showResult = false;
      _currentOrder.shuffle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.instruction, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 16),

        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _currentOrder.length,
          onReorder: _onReorder,
          proxyDecorator: (child, index, animation) {
            return Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: AppColors.primaryLight.withValues(alpha: 0.3), blurRadius: 12)],
                ),
                child: child,
              ),
            );
          },
          itemBuilder: (context, index) {
            final item = _currentOrder[index];
            final isCorrect = _showResult && item == widget.correctOrder[index];
            final isWrong = _showResult && item != widget.correctOrder[index];

            return Container(
              key: ValueKey(item),
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
                    width: 28, height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCorrect
                          ? AppColors.secondary.withValues(alpha: 0.2)
                          : isWrong
                              ? AppColors.danger.withValues(alpha: 0.2)
                              : AppColors.cardColor(context),
                    ),
                    child: Center(child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 13,
                        color: isCorrect ? AppColors.secondaryLight
                            : isWrong ? AppColors.dangerLight : AppColors.textTertiary(context),
                      ),
                    )),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(item, style: Theme.of(context).textTheme.bodyMedium)),
                  if (_showResult)
                    Icon(isCorrect ? Icons.check_circle : Icons.cancel,
                      color: isCorrect ? AppColors.secondaryLight : AppColors.dangerLight, size: 20)
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
              child: const Text('Check Order'),
            ),
          )
        else if (_score < 50)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _retry,
              child: const Text('Try Again'),
            ),
          ),
      ],
    );
  }
}
