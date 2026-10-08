/// One formatter for every ratio the engine reports, ported from the website's
/// client/src/lib/ratio-format.ts (3b6e645), so the same ratio never reads two ways.
///
///   percentages -> one decimal and a % sign (margins, returns, capital-structure ratios)
///   multiples   -> one decimal and an x (interest coverage, P/E, market to book, P/S, P/CF)
///   everything else (liquidity, turnover, days, EPS) -> one decimal
///
/// This also stops a current ratio under 5 from being shown as a percentage.
library;

enum RatioKind { percent, multiple, number }

const _percentKeys = [
  'margin',
  'return on',
  'roa',
  'roe',
  'debt to equity',
  'debt ratio',
  'equity ratio',
  'debt to capital',
  'growth',
];

const _multipleKeys = [
  'interest coverage',
  'price to earnings',
  'p/e',
  'market to book',
  'price to sales',
  'p/s',
  'price to cash flow',
  'p/cf',
];

/// Ratios the engine voids (null) when their denominator is zero or negative: equity-based
/// ratios on negative equity, P/E on a loss, P/CF on negative operating cash flow.
const _notMeaningfulKeys = [
  'return on equity',
  'roe',
  'debt to equity',
  'equity ratio',
  'debt to capital',
  'market to book',
  'return on total capital',
  'price to earnings',
  'p/e',
  'price to cash flow',
  'p/cf',
];

RatioKind ratioKind(String name) {
  final n = name.toLowerCase();
  if (_percentKeys.any(n.contains)) return RatioKind.percent;
  if (_multipleKeys.any(n.contains)) return RatioKind.multiple;
  return RatioKind.number;
}

String _oneDecimalGrouped(double v) {
  final fixed = v.abs().toStringAsFixed(1);
  final parts = fixed.split('.');
  final whole = parts[0].replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');
  return '${v < 0 && fixed != '0.0' ? '-' : ''}$whole.${parts[1]}';
}

/// [raw] may be a number, a numeric string, or null (null reads "n/m" for ratios the
/// engine voids, "-" otherwise).
String formatRatio(String name, Object? raw) {
  if (raw == null || raw == '') {
    final n = name.toLowerCase();
    return _notMeaningfulKeys.any(n.contains) ? 'n/m' : '-';
  }
  final double? value = raw is num ? raw.toDouble() : double.tryParse(raw.toString());
  if (value == null || !value.isFinite) return raw.toString();
  switch (ratioKind(name)) {
    case RatioKind.percent:
      return '${(value * 100).toStringAsFixed(1)}%';
    case RatioKind.multiple:
      return '${value.toStringAsFixed(1)}x';
    case RatioKind.number:
      return _oneDecimalGrouped(value);
  }
}
