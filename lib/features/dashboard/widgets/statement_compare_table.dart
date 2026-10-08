import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/i18n/app_strings.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/ai_tooltip_button.dart';
import '../logic/ratio_format.dart';
import '../logic/statement_analysis.dart';

/// Which statement a table shows; decides the common-size base and the header rules.
enum StatementKind { income, balance, cashFlow }

const double _numericColWidth = 104;
const double _minAccountWidth = 150;

String _fmtAmount(double v) {
  final abs = v.abs().round().toString().replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (_) => ',',
      );
  return '${v < 0 ? '-' : ''}\$$abs';
}

/// "Compare with" selector plus the Variance / Common size toggles above the statement
/// tables (website d9314e8 + b3abe28). The selector appears from round 2 onwards.
class StatementCompareControls extends ConsumerWidget {
  final int currentRound;
  final int compareRound;
  final AnalysisShow show;
  final ValueChanged<int> onCompareChanged;
  final ValueChanged<AnalysisShow> onShowChanged;

  const StatementCompareControls({
    super.key,
    required this.currentRound,
    required this.compareRound,
    required this.show,
    required this.onCompareChanged,
    required this.onShowChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    final options = compareRoundOptions(currentRound);
    String label(int r) => r == 0 ? s.tr('Baseline', 'خط الأساس') : s.tr('Round $r', 'الجولة $r');
    return Wrap(
      spacing: 12,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (options.isNotEmpty)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(s.tr('Compare with', 'المقارنة مع'),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(width: 8),
              DropdownButton<int>(
                key: const ValueKey('compare-round'),
                value: options.contains(compareRound) ? compareRound : options.last,
                isDense: true,
                underline: const SizedBox.shrink(),
                style: TextStyle(fontSize: 12, color: AppColors.textPrimary(context)),
                items: [
                  for (final r in options) DropdownMenuItem(value: r, child: Text(label(r))),
                ],
                onChanged: (v) {
                  if (v != null) onCompareChanged(v);
                },
              ),
            ],
          ),
        _toggle(
          context,
          key: const ValueKey('toggle-variance'),
          label: s.tr('Variance', 'التباين'),
          value: show.variance,
          onChanged: (v) => onShowChanged(show.copyWith(variance: v)),
        ),
        _toggle(
          context,
          key: const ValueKey('toggle-common-size'),
          label: s.tr('Common size', 'القوائم النسبية'),
          value: show.commonSize,
          onChanged: (v) => onShowChanged(show.copyWith(commonSize: v)),
        ),
      ],
    );
  }

  Widget _toggle(BuildContext context,
      {required Key key,
      required String label,
      required bool value,
      required ValueChanged<bool> onChanged}) {
    return InkWell(
      key: key,
      borderRadius: BorderRadius.circular(6),
      onTap: () => onChanged(!value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 28,
            height: 28,
            child: Checkbox(
              value: value,
              visualDensity: VisualDensity.compact,
              onChanged: (v) => onChanged(v ?? false),
            ),
          ),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

/// A statement table with the round shown, the comparison period, and (optionally) the
/// Change / Change % and common-size columns. Every numeric column has the same width;
/// the Account column takes the remainder (website 1cc43d5). Scrolls sideways when the
/// columns do not fit.
class StatementCompareTable extends ConsumerWidget {
  final StatementKind kind;
  final StatementComparison comparison;
  final AnalysisShow show;

  const StatementCompareTable({
    super.key,
    required this.kind,
    required this.comparison,
    required this.show,
  });

  List<AnalysisRow> _rows(PeriodStatements p) => switch (kind) {
        StatementKind.income => p.income,
        StatementKind.balance => p.balance,
        StatementKind.cashFlow => p.cashFlow,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    final rows = _rows(comparison.current);
    final compareRows = _rows(comparison.compare);
    final isBalance = kind == StatementKind.balance;
    final currentBase = isBalance
        ? totalAssetsOf(comparison.current.balance)
        : salesOf(comparison.current.income);
    final compareBase = isBalance
        ? totalAssetsOf(comparison.compare.balance)
        : salesOf(comparison.compare.income);
    // The balance sheet header reads "% of Assets" so it fits on one line (1cc43d5).
    final baseLabel = isBalance ? s.tr('Assets', 'الأصول') : s.tr('Sales', 'المبيعات');
    String period(int r) => r == 0 ? s.tr('Baseline', 'خط الأساس') : s.tr('Round $r', 'الجولة $r');
    final currentLabel = period(comparison.currentRound);
    final compareLabel = period(comparison.compareRound);
    final vs = s.tr('vs $compareLabel', 'مقابل $compareLabel');

    final headers = <(String, String?)>[
      (currentLabel, null),
      (compareLabel, null),
      if (show.variance) ...[
        (s.tr('Change', 'التغيّر'), vs),
        (s.tr('Change %', 'التغيّر %'), vs),
      ],
      if (show.commonSize) ...[
        (s.tr('% of $baseLabel', '% من $baseLabel'), currentLabel),
        (s.tr('% of $baseLabel', '% من $baseLabel'), compareLabel),
      ],
    ];

    return LayoutBuilder(builder: (context, constraints) {
      final numericWidth = show.numericColumns * _numericColWidth;
      final accountWidth = math.max(_minAccountWidth, constraints.maxWidth - 32 - numericWidth);
      final tableWidth = accountWidth + numericWidth;
      final border = AppColors.borderColor(context).withValues(alpha: 0.2);

      Widget headerCell(String title, String? sub, {bool divider = false}) => Container(
            width: _numericColWidth,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              border: divider ? Border(left: BorderSide(color: border)) : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(title,
                    textAlign: TextAlign.end,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                if (sub != null)
                  Text(sub,
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 10, color: AppColors.textTertiary(context))),
              ],
            ),
          );

      Widget numCell(String? text, {Color? color, bool divider = false, bool bold = false}) =>
          Container(
            width: _numericColWidth,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              border: divider ? Border(left: BorderSide(color: border)) : null,
            ),
            child: Text(
              text ?? '',
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 11.5,
                fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
                color: color ?? AppColors.textPrimary(context),
              ),
            ),
          );

      final firstAnalysisIndex = 2;
      final commonSizeIndex = 2 + (show.variance ? 2 : 0);

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            width: tableWidth,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.cardColor(context).withValues(alpha: 0.5),
                    border: Border(bottom: BorderSide(color: border)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: accountWidth,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          child: Text(s.tr('Account', 'البند'),
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      for (var i = 0; i < headers.length; i++)
                        headerCell(headers[i].$1, headers[i].$2,
                            divider: (show.variance && i == firstAnalysisIndex) ||
                                (show.commonSize && i == commonSizeIndex)),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: rows.length,
                    itemBuilder: (context, index) {
                      final item = rows[index];
                      final other = matchByTitle(compareRows, item.title);
                      final current = item.number;
                      final compare = other?.number ?? 0;
                      final blank = kind == StatementKind.cashFlow
                          ? isCashFlowCaption(item)
                          : isSectionHeader(item);
                      final bold = item.isHeader || item.isMajor || item.isCalculation;
                      final cells = AnalysisCells.compute(
                        current: current,
                        compare: compare,
                        currentBase: currentBase,
                        compareBase: compareBase,
                        blank: blank,
                      );
                      final tone = cells.direction > 0
                          ? AppColors.secondaryLight
                          : cells.direction < 0
                              ? AppColors.dangerLight
                              : AppColors.textTertiary(context);
                      return Container(
                        decoration: BoxDecoration(
                          color: item.isMajor
                              ? AppColors.primaryLight.withValues(alpha: 0.05)
                              : null,
                          border: Border(bottom: BorderSide(color: border)),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: accountWidth,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                child: Text(
                                  item.title.trim(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            numCell(blank ? '' : _fmtAmount(current),
                                bold: bold,
                                color: current < 0 ? AppColors.dangerLight : null),
                            numCell(blank ? '' : _fmtAmount(compare),
                                color: compare < 0
                                    ? AppColors.dangerLight
                                    : AppColors.textSecondary(context)),
                            if (show.variance) ...[
                              numCell(cells.change, color: tone, divider: true),
                              numCell(cells.changePercent, color: tone),
                            ],
                            if (show.commonSize) ...[
                              numCell(cells.shareCurrent, divider: true),
                              numCell(cells.shareCompare,
                                  color: AppColors.textSecondary(context)),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

/// Key ratios for the round shown next to the comparison period, with the shared ratio
/// formatter (percent / multiple / one decimal, n/m where the engine voids the ratio).
class RatioCompareTable extends ConsumerWidget {
  final StatementComparison comparison;
  const RatioCompareTable({super.key, required this.comparison});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    final rows = comparison.current.ratios;
    String period(int r) => r == 0 ? s.tr('Baseline', 'خط الأساس') : s.tr('Round $r', 'الجولة $r');
    final border = AppColors.borderColor(context).withValues(alpha: 0.2);

    Widget value(String text, {Color? color, bool bold = false}) => SizedBox(
          width: 84,
          child: Text(text,
              textAlign: TextAlign.end,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 12,
                fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
                color: color ?? AppColors.textPrimary(context),
              )),
        );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.cardColor(context).withValues(alpha: 0.5),
              border: Border(bottom: BorderSide(color: border)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(s.tr('Ratio', 'النسبة'),
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                ),
                SizedBox(
                  width: 84,
                  child: Text(period(comparison.currentRound),
                      textAlign: TextAlign.end,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                ),
                SizedBox(
                  width: 84,
                  child: Text(period(comparison.compareRound),
                      textAlign: TextAlign.end,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 32),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: rows.length,
              itemBuilder: (context, i) {
                final r = rows[i];
                final other = matchByTitle(comparison.compare.ratios, r.title);
                final title = r.title.trim();
                final current = formatRatio(title, r.value);
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: border))),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(title,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: r.isHeader ? FontWeight.w600 : FontWeight.w400)),
                      ),
                      value(current,
                          bold: true,
                          color: (r.value ?? 0) < 0 ? AppColors.dangerLight : null),
                      value(formatRatio(title, other?.value),
                          color: AppColors.textSecondary(context)),
                      SizedBox(
                        width: 32,
                        child: r.isHeader
                            ? null
                            : AiTooltipButton(
                                term: title,
                                type: (r.type ?? '').toLowerCase().isEmpty
                                    ? null
                                    : r.type!.toLowerCase(),
                                value: current,
                              ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
