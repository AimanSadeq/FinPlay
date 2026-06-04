import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/app_colors.dart';

class StatementBuilderGame extends StatefulWidget {
  final VoidCallback onComplete;
  final ValueChanged<int> onScoreUpdate;
  final List<String>? categories;
  final List<Map<String, String>>? items;

  const StatementBuilderGame({
    super.key,
    required this.onComplete,
    required this.onScoreUpdate,
    this.categories,
    this.items,
  });

  @override
  State<StatementBuilderGame> createState() => _StatementBuilderGameState();
}

class _FinancialItem {
  final String name;
  final String correctCategory;
  String? placedCategory;
  bool get isPlaced => placedCategory != null;
  bool get isCorrect => placedCategory == correctCategory;

  _FinancialItem({required this.name, required this.correctCategory});
}

class _StatementBuilderGameState extends State<StatementBuilderGame> {
  late List<_FinancialItem> _items;
  late List<String> _categories;
  late Map<String, Color> _categoryColors;
  late Map<String, IconData> _categoryIcons;
  bool _submitted = false;
  int _score = 0;

  static const _defaultCategories = [
    'Income Statement',
    'Balance Sheet',
    'Cash Flow Statement',
  ];

  static const _defaultItems = [
    {'name': 'Revenue', 'category': 'Income Statement'},
    {'name': 'Cost of Goods Sold', 'category': 'Income Statement'},
    {'name': 'Operating Expenses', 'category': 'Income Statement'},
    {'name': 'Net Income', 'category': 'Income Statement'},
    {'name': 'Total Assets', 'category': 'Balance Sheet'},
    {'name': 'Total Liabilities', 'category': 'Balance Sheet'},
    {'name': 'Shareholders\' Equity', 'category': 'Balance Sheet'},
    {'name': 'Accounts Receivable', 'category': 'Balance Sheet'},
    {'name': 'Operating Cash Flow', 'category': 'Cash Flow Statement'},
    {'name': 'Capital Expenditure', 'category': 'Cash Flow Statement'},
    {'name': 'Debt Repayment', 'category': 'Cash Flow Statement'},
    {'name': 'Dividends Paid', 'category': 'Cash Flow Statement'},
  ];

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
    _categories = widget.categories ?? _defaultCategories;
    final itemData = widget.items ?? _defaultItems;

    _categoryColors = {
      for (int i = 0; i < _categories.length; i++)
        _categories[i]: _colorPalette[i % _colorPalette.length],
    };
    _categoryIcons = {
      for (int i = 0; i < _categories.length; i++)
        _categories[i]: _iconPalette[i % _iconPalette.length],
    };

    _items = itemData
        .map((item) => _FinancialItem(
              name: item['name']!,
              correctCategory: item['category']!,
            ))
        .toList()
      ..shuffle();
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
    final score = ((correct / _items.length) * 100).round();

    setState(() {
      _submitted = true;
      _score = score;
    });

    widget.onScoreUpdate(score);
    if (correct >= _items.length * 0.6) {
      widget.onComplete();
    }
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

  @override
  Widget build(BuildContext context) {
    final unplaced = _items.where((item) => !item.isPlaced).toList();
    final allPlaced = _items.every((item) => item.isPlaced);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Instructions
        Text(
          'Classify each financial item into the correct statement.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 16),

        // Unplaced items
        if (unplaced.isNotEmpty) ...[
          Text('Items to classify:', style: Theme.of(context).textTheme.labelLarge),
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
              label: const Text('Check Answers'),
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
              color: _score >= 80
                  ? AppColors.secondary.withValues(alpha: 0.1)
                  : _score >= 60
                      ? AppColors.accentLight.withValues(alpha: 0.1)
                      : Colors.red.withValues(alpha: 0.1),
              border: Border.all(
                color: _score >= 80
                    ? AppColors.secondaryLight.withValues(alpha: 0.3)
                    : _score >= 60
                        ? AppColors.accentLight.withValues(alpha: 0.3)
                        : Colors.red.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Score: $_score / 100',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _score >= 80
                        ? AppColors.secondaryLight
                        : _score >= 60
                            ? AppColors.accentLight
                            : Colors.red,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_items.where((i) => i.isCorrect).length} of ${_items.length} correct',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.refresh_rounded, size: 16),
                  label: const Text('Try Again'),
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
          child: Text(item.name, style: const TextStyle(color: Colors.white, fontSize: 13)),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: Chip(
          label: Text(item.name, style: const TextStyle(fontSize: 12)),
        ),
      ),
      child: ActionChip(
        label: Text(item.name, style: const TextStyle(fontSize: 12, color: AppColors.primaryDark)),
        backgroundColor: AppColors.primary.withValues(alpha: 0.12),
        side: BorderSide(color: AppColors.primary.withValues(alpha: 0.3)),
        onPressed: () => _showCategoryPicker(item),
      ),
    );
  }

  void _showCategoryPicker(_FinancialItem item) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Place "${item.name}" in:', style: Theme.of(ctx).textTheme.titleMedium),
              const SizedBox(height: 12),
              ..._categories.map((cat) => ListTile(
                leading: Icon(_categoryIcons[cat], color: _categoryColors[cat]),
                title: Text(cat),
                onTap: () {
                  _placeItem(item, cat);
                  Navigator.pop(ctx);
                },
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTarget(String category) {
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
                  Text(category, style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: color,
                  )),
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
                          Text(item.name, style: TextStyle(fontSize: 12, color: chipColor)),
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
                    'Drop items here',
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
