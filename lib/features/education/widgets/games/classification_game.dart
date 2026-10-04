import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/app_colors.dart';

class ClassificationGame extends StatefulWidget {
  final List<String> categories;
  final List<Map<String, String>> items; // [{name, category}]
  final VoidCallback onComplete;
  final ValueChanged<int> onScoreUpdate;

  const ClassificationGame({
    super.key,
    required this.categories,
    required this.items,
    required this.onComplete,
    required this.onScoreUpdate,
  });

  @override
  State<ClassificationGame> createState() => _ClassificationGameState();
}

class _ClassificationGameState extends State<ClassificationGame> {
  final Map<String, List<String>> _classified = {};
  late List<Map<String, String>> _remainingItems;
  int _score = 0;
  int _correct = 0;

  @override
  void initState() {
    super.initState();
    for (final cat in widget.categories) {
      _classified[cat] = [];
    }
    _remainingItems = List.from(widget.items)..shuffle();
  }

  void _onItemDropped(String itemName, String targetCategory) {
    final item = widget.items.firstWhere((i) => i['name'] == itemName);
    final isCorrect = item['category'] == targetCategory;

    HapticFeedback.mediumImpact();

    setState(() {
      _remainingItems.removeWhere((i) => i['name'] == itemName);
      _classified[targetCategory]!.add(itemName);

      if (isCorrect) {
        _correct++;
      }

      if (_remainingItems.isEmpty) {
        // Website formula: Math.round((correct / total) × 75)
        _score = (_correct / widget.items.length * 75).round();
        widget.onScoreUpdate(_score);
        widget.onComplete();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Remaining: ${_remainingItems.length}',
              style: Theme.of(context).textTheme.bodyMedium),
            const Spacer(),
            Text('$_correct/${widget.items.length} correct',
              style: TextStyle(color: _correct > 0 ? AppColors.secondaryLight : AppColors.textTertiary(context),
                fontWeight: FontWeight.w600, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 12),

        // Draggable items
        if (_remainingItems.isNotEmpty)
          Wrap(
            spacing: 8, runSpacing: 8,
            children: _remainingItems.map((item) {
              return Draggable<String>(
                data: item['name']!,
                feedback: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(item['name']!, style: const TextStyle(color: Colors.white, fontSize: 13)),
                  ),
                ),
                childWhenDragging: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.cardColor(context).withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.borderColor(context)),
                  ),
                  child: Text(item['name']!, style: TextStyle(color: AppColors.textTertiary(context), fontSize: 13)),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.cardColor(context),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.primaryLight.withValues(alpha: 0.3)),
                  ),
                  child: Text(item['name']!, style: const TextStyle(color: AppColors.primaryLight, fontSize: 13)),
                ),
              );
            }).toList(),
          ),

        const SizedBox(height: 16),

        // Drop targets
        ...widget.categories.map((category) {
          final categoryColors = [
            AppColors.primaryLight,
            AppColors.secondaryLight,
            AppColors.accentLight,
            const Color(0xFF06B6D4),
            const Color(0xFFA78BFA),
          ];
          final colorIndex = widget.categories.indexOf(category) % categoryColors.length;
          final color = categoryColors[colorIndex];

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: DragTarget<String>(
              onAcceptWithDetails: (details) => _onItemDropped(details.data, category),
              builder: (context, candidateData, rejectedData) {
                final isHovering = candidateData.isNotEmpty;
                return AnimatedContainer(
                  duration: 200.ms,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: isHovering
                        ? color.withValues(alpha: 0.1)
                        : AppColors.cardColor(context).withValues(alpha: 0.5),
                    border: Border.all(
                      color: isHovering ? color.withValues(alpha: 0.5) : AppColors.borderColor(context),
                      width: isHovering ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8, height: 8,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
                          ),
                          const SizedBox(width: 8),
                          Text(category, style: TextStyle(
                            fontWeight: FontWeight.w600, color: color, fontSize: 14)),
                        ],
                      ),
                      if (_classified[category]!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6, runSpacing: 6,
                          children: _classified[category]!.map((name) {
                            final isCorrect = widget.items.firstWhere((i) => i['name'] == name)['category'] == category;
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: (isCorrect ? AppColors.secondary : AppColors.danger).withValues(alpha: 0.15),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(isCorrect ? Icons.check : Icons.close, size: 12,
                                    color: isCorrect ? AppColors.secondaryLight : AppColors.dangerLight),
                                  const SizedBox(width: 4),
                                  Text(name, style: TextStyle(fontSize: 11,
                                    color: isCorrect ? AppColors.secondaryLight : AppColors.dangerLight)),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          );
        }),
      ],
    );
  }
}
