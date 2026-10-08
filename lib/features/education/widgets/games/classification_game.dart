import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../providers/locale_provider.dart';
import '../../modules/education_module_data.dart';

/// Sort-into-categories game (website *ClassificationGame components). Items
/// are dragged, or tapped and assigned, to a category; each placement is final
/// and marked right or wrong. Score: round(correct / items × [maxScore]).
class ClassificationGame extends ConsumerStatefulWidget {
  final List<ClassCategory> categories;
  final List<ClassItem> items;
  final int maxScore;
  final VoidCallback onComplete;
  final ValueChanged<int> onScoreUpdate;

  const ClassificationGame({
    super.key,
    required this.categories,
    required this.items,
    this.maxScore = 75,
    required this.onComplete,
    required this.onScoreUpdate,
  });

  static int scoreFor(int correct, int total, int maxScore) =>
      total == 0 ? 0 : (correct / total * maxScore).round();

  @override
  ConsumerState<ClassificationGame> createState() => _ClassificationGameState();
}

class _ClassificationGameState extends ConsumerState<ClassificationGame> {
  final Map<String, List<String>> _classified = {}; // categoryId -> itemIds
  late List<ClassItem> _remaining;
  int _correct = 0;
  bool _done = false;

  static const _categoryColors = [
    AppColors.primaryLight,
    AppColors.secondaryLight,
    AppColors.accentLight,
    Color(0xFF06B6D4),
    Color(0xFFA78BFA),
    Color(0xFFEC4899),
    Color(0xFFF97316),
  ];

  @override
  void initState() {
    super.initState();
    _reset();
  }

  void _reset() {
    _classified
      ..clear()
      ..addAll({for (final c in widget.categories) c.id: <String>[]});
    _remaining = List.of(widget.items)..shuffle();
    _correct = 0;
    _done = false;
  }

  ClassItem _item(String id) => widget.items.firstWhere((i) => i.id == id);

  void _place(String itemId, String categoryId) {
    if (_done || !_remaining.any((i) => i.id == itemId)) return;
    final isCorrect = _item(itemId).category == categoryId;
    HapticFeedback.mediumImpact();
    setState(() {
      _remaining.removeWhere((i) => i.id == itemId);
      _classified[categoryId]!.add(itemId);
      if (isCorrect) _correct++;
      if (_remaining.isEmpty) _done = true;
    });
    if (_done) {
      widget.onScoreUpdate(
          ClassificationGame.scoreFor(_correct, widget.items.length, widget.maxScore));
      widget.onComplete();
    }
  }

  void _pickCategory(ClassItem item, bool ar) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: ar ? TextDirection.rtl : TextDirection.ltr,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name.of(ar), style: Theme.of(ctx).textTheme.titleMedium),
                if (item.hint.of(ar).isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(item.hint.of(ar), style: Theme.of(ctx).textTheme.bodySmall),
                ],
                const SizedBox(height: 12),
                ...widget.categories.asMap().entries.map((e) => ListTile(
                      leading: Icon(Icons.circle,
                          size: 12, color: _categoryColors[e.key % _categoryColors.length]),
                      title: Text(e.value.name.of(ar)),
                      subtitle: e.value.description.of(ar).isEmpty
                          ? null
                          : Text(e.value.description.of(ar)),
                      onTap: () {
                        Navigator.pop(ctx);
                        _place(item.id, e.value.id);
                      },
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    String t(String en, String a) => ar ? a : en;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(t('Remaining: ${_remaining.length}', 'المتبقي: ${_remaining.length}'),
                style: Theme.of(context).textTheme.bodyMedium),
            const Spacer(),
            Text(t('$_correct/${widget.items.length} correct', '$_correct/${widget.items.length} صحيحة'),
                style: TextStyle(
                    color: _correct > 0 ? AppColors.secondaryLight : AppColors.textTertiary(context),
                    fontWeight: FontWeight.w600,
                    fontSize: 13)),
          ],
        ),
        const SizedBox(height: 6),
        Text(t('Drag an item onto its category, or tap it to choose.',
                'اسحب العنصر إلى فئته، أو انقر عليه للاختيار.'),
            style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 12),
        if (_remaining.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _remaining.map((item) {
              final label = item.name.of(ar);
              return Draggable<String>(
                data: item.id,
                feedback: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)),
                  ),
                ),
                childWhenDragging: Opacity(
                  opacity: 0.3,
                  child: _chip(label, AppColors.textTertiary(context)),
                ),
                child: GestureDetector(
                  onTap: () => _pickCategory(item, ar),
                  child: _chip(label, AppColors.primaryLight),
                ),
              );
            }).toList(),
          ),
        if (_done) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                  t('Score: ${ClassificationGame.scoreFor(_correct, widget.items.length, widget.maxScore)} / ${widget.maxScore}',
                      'النتيجة: ${ClassificationGame.scoreFor(_correct, widget.items.length, widget.maxScore)} / ${widget.maxScore}'),
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, color: AppColors.secondaryLight)),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: () => setState(_reset),
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: Text(t('Play Again', 'العب مرة أخرى')),
              ),
            ],
          ),
        ],
        const SizedBox(height: 16),
        ...widget.categories.asMap().entries.map((entry) {
          final category = entry.value;
          final color = _categoryColors[entry.key % _categoryColors.length];
          final placed = _classified[category.id] ?? const <String>[];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: DragTarget<String>(
              onAcceptWithDetails: (details) => _place(details.data, category.id),
              builder: (context, candidateData, rejectedData) {
                final isHovering = candidateData.isNotEmpty;
                return AnimatedContainer(
                  duration: 200.ms,
                  width: double.infinity,
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
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(category.name.of(ar),
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, color: color, fontSize: 14)),
                          ),
                        ],
                      ),
                      if (category.description.of(ar).isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(category.description.of(ar),
                              style: Theme.of(context).textTheme.bodySmall),
                        ),
                      if (placed.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: placed.map((id) {
                            final item = _item(id);
                            final ok = item.category == category.id;
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: (ok ? AppColors.secondary : AppColors.danger)
                                    .withValues(alpha: 0.15),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(ok ? Icons.check : Icons.close,
                                      size: 12,
                                      color: ok ? AppColors.secondaryLight : AppColors.dangerLight),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(item.name.of(ar),
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: ok
                                                ? AppColors.secondaryLight
                                                : AppColors.dangerLight)),
                                  ),
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

  Widget _chip(String label, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.cardColor(context),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Text(label, style: TextStyle(color: color, fontSize: 13)),
      );
}
