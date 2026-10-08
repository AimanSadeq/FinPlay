import '../data/debrief_models.dart';

/// Bar kinds of the decision-impact waterfall (website DecisionWaterfall.tsx).
enum WaterfallKind { start, pos, neg, residual, end }

/// One bar: [base] is where the visible segment starts, [value] its (absolute) height,
/// [signed] the actual delta (or the level, for the start and end anchors).
class WaterfallBar {
  final String name; // truncated axis label
  final String fullTitle;
  final String? module;
  final WaterfallKind kind;
  final double base;
  final double value;
  final double signed;
  final double? amount;

  const WaterfallBar({
    required this.name,
    required this.fullTitle,
    this.module,
    required this.kind,
    required this.base,
    required this.value,
    required this.signed,
    this.amount,
  });

  double get top => base + value;
  bool get isAnchor => kind == WaterfallKind.start || kind == WaterfallKind.end;
}

const _moduleOrder = {'financing': 0, 'investing': 1, 'operating': 2};

String truncateLabel(String text, [int max = 16]) =>
    text.length > max ? '${text.substring(0, max - 1)}…' : text;

/// Start anchor, every decision (financing → investing → operating, then by scenario id),
/// an "Other effects" bar when the unattributed residual is at least 0.5, and the end anchor.
/// Labels are passed in so the caller can localize them.
List<WaterfallBar> buildWaterfallBars(
  WaterfallData data, {
  String startName = 'Start',
  String startTitle = 'Net Income before this round’s decisions',
  String otherName = 'Other effects',
  String otherTitle = 'Decision interactions and market effects (unattributed)',
  String? endName,
  String? endTitle,
}) {
  final bars = <WaterfallBar>[
    WaterfallBar(
      name: startName,
      fullTitle: startTitle,
      kind: WaterfallKind.start,
      base: data.start < 0 ? data.start : 0,
      value: data.start.abs(),
      signed: data.start,
    ),
  ];

  final items = [...data.items]..sort((a, b) {
      final m = (_moduleOrder[a.module] ?? 9) - (_moduleOrder[b.module] ?? 9);
      if (m != 0) return m;
      final ai = num.tryParse(a.scenarioId) ?? double.nan;
      final bi = num.tryParse(b.scenarioId) ?? double.nan;
      if (ai.isNaN || bi.isNaN) return 0;
      return ai.compareTo(bi);
    });

  var level = data.start;
  for (final item in items) {
    final next = level + item.contribution;
    bars.add(WaterfallBar(
      name: truncateLabel(item.title),
      fullTitle: item.title,
      module: item.module,
      kind: item.contribution >= 0 ? WaterfallKind.pos : WaterfallKind.neg,
      base: level < next ? level : next,
      value: item.contribution.abs(),
      signed: item.contribution,
      amount: item.amount,
    ));
    level = next;
  }

  if (data.residual.abs() >= 0.5) {
    final next = level + data.residual;
    bars.add(WaterfallBar(
      name: otherName,
      fullTitle: otherTitle,
      kind: WaterfallKind.residual,
      base: level < next ? level : next,
      value: data.residual.abs(),
      signed: data.residual,
    ));
  }

  bars.add(WaterfallBar(
    name: endName ?? 'End R${data.round}',
    fullTitle: endTitle ?? 'Round ${data.round} Net Income (actual)',
    kind: WaterfallKind.end,
    base: data.end < 0 ? data.end : 0,
    value: data.end.abs(),
    signed: data.end,
  ));
  return bars;
}

/// `$1.2M`, `-$45K`, `$900`.
String formatCompact(double value) {
  final abs = value.abs();
  final sign = value < 0 ? '-' : '';
  if (abs >= 1000000) return '$sign\$${(abs / 1000000).toStringAsFixed(1)}M';
  if (abs >= 1000) return '$sign\$${(abs / 1000).toStringAsFixed(0)}K';
  return '$sign\$${abs.toStringAsFixed(0)}';
}

/// `+$12K` / `-$3K`.
String formatSignedCompact(double value) =>
    value >= 0 ? '+${formatCompact(value)}' : formatCompact(value);

/// Whole dollars with separators: `$1,234,567`, `-$5`.
String formatExact(double value) {
  final abs = value.abs().round().toString().replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (_) => ',',
      );
  return '${value < 0 ? '-' : ''}\$$abs';
}
