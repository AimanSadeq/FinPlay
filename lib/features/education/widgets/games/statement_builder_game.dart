import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../providers/locale_provider.dart';
import '../../modules/education_module_data.dart';

/// Place-every-item-then-check builder (website FinancialStatementBuilder /
/// StatementItemBuilder / SectorScenarioBuilder). Score on check:
/// round(correct / items × [maxScore]); checking completes the activity and the
/// learner may try again to improve.
class StatementBuilderGame extends ConsumerStatefulWidget {
  final VoidCallback onComplete;
  final ValueChanged<int> onScoreUpdate;
  final List<ClassCategory> categories;
  final List<ClassItem> items;
  final int maxScore;

  const StatementBuilderGame({
    super.key,
    required this.onComplete,
    required this.onScoreUpdate,
    required this.categories,
    required this.items,
    this.maxScore = 100,
  });

  static int scoreFor(int correct, int total, int maxScore) =>
      total == 0 ? 0 : (correct / total * maxScore).round();

  @override
  ConsumerState<StatementBuilderGame> createState() => _StatementBuilderGameState();
}

class _FinancialItem {
  final ClassItem item;
  String? placedCategory;
  bool get isPlaced => placedCategory != null;
  bool get isCorrect => placedCategory == item.category;

  _FinancialItem(this.item);
}

class _StatementBuilderGameState extends ConsumerState<StatementBuilderGame> {
  late List<_FinancialItem> _items;
  late List<ClassCategory> _categories;
  late Map<String, Color> _categoryColors;
  late Map<String, IconData> _categoryIcons;
  bool _submitted = false;
  int _score = 0;
  bool _ar = false;

  static const _colorPalette = [
    Color(0xFF3B82F6),
    Color(0xFF10B981),
    Color(0xFFF59E0B),
    Color(0xFFEF4444),
    Color(0xFF8B5CF6),
    Color(0xFF06B6D4),
    Color(0xFFEC4899),
    Color(0xFFF97316),
    Color(0xFF14B8A6),
    Color(0xFF6366F1),
  ];

  static const _iconPalette = [
    Icons.trending_up_rounded,
    Icons.account_balance_rounded,
    Icons.water_drop_rounded,
    Icons.pie_chart_rounded,
    Icons.category_rounded,
    Icons.layers_rounded,
    Icons.receipt_long_rounded,
    Icons.savings_rounded,
    Icons.bar_chart_rounded,
    Icons.assessment_rounded,
  ];

  @override
  void initState() {
    super.initState();
    _categories = widget.categories;
    _categoryColors = {
      for (int i = 0; i < _categories.length; i++)
        _categories[i].id: _colorPalette[i % _colorPalette.length],
    };
    _categoryIcons = {
      for (int i = 0; i < _categories.length; i++)
        _categories[i].id: _iconPalette[i % _iconPalette.length],
    };
    _items = widget.items.map(_FinancialItem.new).toList()..shuffle();
  }

  void _placeItem(_FinancialItem item, String category) {
    if (_submitted) return;
    HapticFeedback.lightImpact();
    setState(() {
      item.placedCategory = category;
    });
  }

  void _removeItem(_FinancialItem item) {
    if (_submitted) return;
    HapticFeedback.lightImpact();
    setState(() {
      item.placedCategory = null;
    });
  }

  void _submit() {
    if (_items.any((item) => !item.isPlaced)) return;
    HapticFeedback.heavyImpact();

    final correct = _items.where((item) => item.isCorrect).length;
    final score = StatementBuilderGame.scoreFor(correct, _items.length, widget.maxScore);

    setState(() {
      _submitted = true;
      _score = score;
    });

    widget.onScoreUpdate(score);
    widget.onComplete();
  }

  void _reset() {
    HapticFeedback.mediumImpact();
    setState(() {
      _submitted = false;
      _score = 0;
      for (final item in _items) {
        item.placedCategory = null;
      }
      _items.shuffle();
    });
  }

  String _t(String en, String ar) => _ar ? ar : en;

  @override
  Widget build(BuildContext context) {
    _ar = ref.watch(isArabicProvider);
    final pct = widget.maxScore == 0 ? 0 : _score * 100 ~/ widget.maxScore;
    final unplaced = _items.where((item) => !item.isPlaced).toList();
    final allPlaced = _items.every((item) => item.isPlaced);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Instructions
        Text(
          _t('Drag each item to its category, or tap it to choose. Check when all are placed.',
              'اسحب كل عنصر إلى فئته، أو انقر عليه للاختيار. تحقق عند وضع جميع العناصر.'),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 16),

        // Unplaced items
        if (unplaced.isNotEmpty) ...[
          Text(_t('Items to classify (${unplaced.length}):', 'عناصر للتصنيف (${unplaced.length}):'), style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: unplaced.map((item) => _buildDraggableChip(item)).toList(),
          ),
          const SizedBox(height: 20),
        ],

        // Drop targets (categories)
        ...(_categories.map((category) => _buildCategoryTarget(category))),

        const SizedBox(height: 16),

        // Submit / Reset
        if (!_submitted && allPlaced)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.check_rounded, size: 18),
              label: Text(_t('Check Answers', 'تحقق من الإجابات')),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),

        if (_submitted) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: pct >= 80
                  ? AppColors.secondary.withValues(alpha: 0.1)
                  : pct >= 60
                      ? AppColors.accentLight.withValues(alpha: 0.1)
                      : Colors.red.withValues(alpha: 0.1),
              border: Border.all(
                color: pct >= 80
                    ? AppColors.secondaryLight.withValues(alpha: 0.3)
                    : pct >= 60
                        ? AppColors.accentLight.withValues(alpha: 0.3)
                        : Colors.red.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                Text(
                  _t('Score: $_score / ${widget.maxScore}', 'النتيجة: $_score / ${widget.maxScore}'),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: pct >= 80
                        ? AppColors.secondaryLight
                        : pct >= 60
                            ? AppColors.accentLight
                            : Colors.red,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _t('${_items.where((i) => i.isCorrect).length} of ${_items.length} correct', '${_items.where((i) => i.isCorrect).length} من ${_items.length} صحيحة'),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.refresh_rounded, size: 16),
                  label: Text(_t('Try Again', 'حاول مجددًا')),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDraggableChip(_FinancialItem item) {
    return Draggable<_FinancialItem>(
      data: item,
      feedback: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(item.item.name.of(_ar), style: const TextStyle(color: Colors.white, fontSize: 13)),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: Chip(
          label: Text(item.item.name.of(_ar), style: const TextStyle(fontSize: 12)),
        ),
      ),
      child: ActionChip(
        label: Text(item.item.name.of(_ar), style: const TextStyle(fontSize: 12, color: AppColors.primaryDark)),
        backgroundColor: AppColors.primary.withValues(alpha: 0.12),
        side: BorderSide(color: AppColors.primary.withValues(alpha: 0.3)),
        onPressed: () => _showCategoryPicker(item),
      ),
    );
  }

  void _showCategoryPicker(_FinancialItem item) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: _ar ? TextDirection.rtl : TextDirection.ltr,
        child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_t('Place "${item.item.name.of(_ar)}" in:', 'ضع "${item.item.name.of(_ar)}" في:'),
                  style: Theme.of(ctx).textTheme.titleMedium),
              if (item.item.hint.of(_ar).isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(item.item.hint.of(_ar), style: Theme.of(ctx).textTheme.bodySmall),
              ],
              const SizedBox(height: 12),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: _categories.map((cat) => ListTile(
                    leading: Icon(_categoryIcons[cat.id], color: _categoryColors[cat.id]),
                    title: Text(cat.name.of(_ar)),
                    subtitle: cat.description.of(_ar).isEmpty ? null : Text(cat.description.of(_ar)),
                    onTap: () {
                      _placeItem(item, cat.id);
                      Navigator.pop(ctx);
                    },
                  )).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildCategoryTarget(ClassCategory cat) {
    final category = cat.id;
    final placedItems = _items.where((item) => item.placedCategory == category).toList();
    final color = _categoryColors[category]!;
    final icon = _categoryIcons[category]!;

    return DragTarget<_FinancialItem>(
      onWillAcceptWithDetails: (_) => !_submitted,
      onAcceptWithDetails: (details) => _placeItem(details.data, category),
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isHovering
                ? color.withValues(alpha: 0.15)
                : color.withValues(alpha: 0.05),
            border: Border.all(
              color: isHovering ? color : color.withValues(alpha: 0.3),
              width: isHovering ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 18, color: color),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(cat.name.of(_ar), style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: color,
                    )),
                  ),
                ],
              ),
              if (placedItems.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: placedItems.map((item) {
                    Color chipColor = color;
                    IconData? statusIcon;
                    if (_submitted) {
                      chipColor = item.isCorrect ? Colors.green : Colors.red;
                      statusIcon = item.isCorrect ? Icons.check_circle : Icons.cancel;
                    }
                    return InputChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(child: Text(item.item.name.of(_ar), style: TextStyle(fontSize: 12, color: chipColor))),
                          if (statusIcon != null) ...[
                            const SizedBox(width: 4),
                            Icon(statusIcon, size: 14, color: chipColor),
                          ],
                        ],
                      ),
                      backgroundColor: chipColor.withValues(alpha: 0.08),
                      side: BorderSide(color: chipColor.withValues(alpha: 0.3)),
                      deleteIcon: _submitted ? null : const Icon(Icons.close, size: 14),
                      onDeleted: _submitted ? null : () => _removeItem(item),
                      onPressed: () {},
                    );
                  }).toList(),
                ),
              ] else
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    _t('Drop items here', 'أفلت العناصر هنا'),
                    style: TextStyle(fontSize: 12, color: color.withValues(alpha: 0.5)),
                  ),
                ),
            ],
          ),
        ).animate().fadeIn(duration: 200.ms);
      },
    );
  }
}
