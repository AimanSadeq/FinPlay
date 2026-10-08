/// Variance and common-size analysis for the results statement tables, ported from the
/// website's dashboard (d9314e8 "Compare with" selector, b3abe28 variance and common-size
/// columns, 1cc43d5 equal-width numeric columns).
///
/// Variance: change and percent change of the round shown against the comparison period.
/// Common size: each line as a percent of a base (Sales on the income statement and the
/// cash flow, Total Assets on the balance sheet) for both periods, so structure can be
/// compared independently of scale. Percent change against a zero base reads "n/m".
library;

/// One statement line as the dashboard-data endpoint returns it. [value] stays null where
/// the server sent null (ratio rows whose denominator is zero or negative read "n/m").
class AnalysisRow {
  final String title;
  final double? value;
  final bool isHeader;
  final bool isMajor;
  final bool isCalculation;
  final String? type;

  const AnalysisRow({
    required this.title,
    this.value,
    this.isHeader = false,
    this.isMajor = false,
    this.isCalculation = false,
    this.type,
  });

  double get number => value ?? 0;

  factory AnalysisRow.fromJson(Map<String, dynamic> json) {
    final raw = json['value'];
    double? v;
    if (raw is num) {
      v = raw.toDouble();
    } else if (raw is String && raw.isNotEmpty && raw != 'NaN') {
      v = double.tryParse(raw);
    }
    return AnalysisRow(
      title: json['title']?.toString() ?? '',
      value: v,
      isHeader: json['isHeader'] == true,
      isMajor: json['isMajor'] == true,
      isCalculation: json['isCalculation'] == true,
      type: json['type']?.toString(),
    );
  }
}

/// The four statements of one period.
class PeriodStatements {
  final List<AnalysisRow> income;
  final List<AnalysisRow> balance;
  final List<AnalysisRow> cashFlow;
  final List<AnalysisRow> ratios;

  const PeriodStatements({
    this.income = const [],
    this.balance = const [],
    this.cashFlow = const [],
    this.ratios = const [],
  });

  bool get isEmpty => income.isEmpty && balance.isEmpty && cashFlow.isEmpty && ratios.isEmpty;

  /// Parses one period block of GET /dashboard-data: `{income, balance, cashflow, ratios}`,
  /// each `{financials: {incomeStatement|balanceSheet|cashFlow|ratios: [...]}}`.
  factory PeriodStatements.fromDashboardBlock(Map<String, dynamic>? block) {
    if (block == null) return const PeriodStatements();
    List<AnalysisRow> rows(String key, String listKey) {
      final stmt = block[key];
      if (stmt is! Map) return const [];
      final fin = stmt['financials'];
      if (fin is! Map) return const [];
      final list = fin[listKey];
      if (list is! List) return const [];
      return [
        for (final e in list)
          if (e is Map) AnalysisRow.fromJson(Map<String, dynamic>.from(e)),
      ];
    }

    return PeriodStatements(
      income: rows('income', 'incomeStatement'),
      balance: rows('balance', 'balanceSheet'),
      cashFlow: rows('cashflow', 'cashFlow'),
      ratios: rows('ratios', 'ratios'),
    );
  }
}

/// The round shown and the comparison period, as the dashboard-data endpoint returns them.
class StatementComparison {
  final int currentRound;
  final int compareRound;
  final PeriodStatements current;
  final PeriodStatements compare;

  const StatementComparison({
    required this.currentRound,
    required this.compareRound,
    required this.current,
    required this.compare,
  });

  factory StatementComparison.fromResponse(
      Map<String, dynamic> response, int currentRound, int compareRound) {
    final data = response['data'];
    final map = data is Map ? Map<String, dynamic>.from(data) : const <String, dynamic>{};
    Map<String, dynamic>? block(String k) =>
        map[k] is Map ? Map<String, dynamic>.from(map[k] as Map) : null;
    return StatementComparison(
      currentRound: currentRound,
      compareRound: compareRound,
      current: PeriodStatements.fromDashboardBlock(block('currentRound')),
      compare: PeriodStatements.fromDashboardBlock(block('previousRound')),
    );
  }
}

/// Which analysis columns are on (both by default, as on the website).
class AnalysisShow {
  final bool variance;
  final bool commonSize;
  const AnalysisShow({this.variance = true, this.commonSize = true});

  AnalysisShow copyWith({bool? variance, bool? commonSize}) => AnalysisShow(
        variance: variance ?? this.variance,
        commonSize: commonSize ?? this.commonSize,
      );

  /// Numeric columns in a statement table: the two periods plus the analyses shown.
  int get numericColumns => 2 + (variance ? 2 : 0) + (commonSize ? 2 : 0);
}

/// A chosen comparison round must be earlier than the round shown; otherwise the round
/// before it (baseline for round 1). Mirrors the web's
/// `compareRound !== null && compareRound >= 0 && compareRound < currentRound`.
int resolveCompareRound(int currentRound, int? chosen) {
  if (chosen != null && chosen >= 0 && chosen < currentRound) return chosen;
  return currentRound > 1 ? currentRound - 1 : 0;
}

/// The "Compare with" options: Baseline and every earlier round. The selector only
/// appears from round 2 onwards (round 1 can only compare with the baseline).
List<int> compareRoundOptions(int currentRound) =>
    currentRound >= 2 ? List<int>.generate(currentRound, (i) => i) : const [];

/// Percent change against the absolute comparison value; null (n/m) on a zero base.
double? changePct(double current, double compare) =>
    compare == 0 ? null : (current - compare) / compare.abs();

/// Share of a common-size base; null (n/m) on a zero base.
double? commonSizeShare(double value, double base) => base == 0 ? null : value / base;

/// `12.3%`, `+12.3%` when [signed] and positive, `n/m` for null or non-finite.
String fmtAnalysisPct(double? v, {bool signed = false}) {
  if (v == null || !v.isFinite) return 'n/m';
  final s = '${(v * 100).toStringAsFixed(1)}%';
  return signed && v > 0 ? '+$s' : s;
}

/// Whole-dollar amount with thousands separators and an explicit sign: `+$1,200`, `-$300`.
String fmtSignedCurrency(double v) {
  final abs = v.abs().round().toString().replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (_) => ',',
      );
  final body = '\$$abs';
  if (v < 0) return '-$body';
  if (v > 0) return '+$body';
  return body;
}

double _findValue(List<AnalysisRow> rows, bool Function(String title) pick) {
  for (final r in rows) {
    if (pick(r.title.trim().toLowerCase())) return r.number;
  }
  return 0;
}

bool _isSales(String t) => t == 'sales' || t == 'revenue' || t == 'net sales';
bool _isTotalAssets(String t) => t.contains('total assets') && !t.contains('current');

/// Common-size base for the income statement and the cash flow.
double salesOf(List<AnalysisRow> income) => _findValue(income, _isSales);

/// Common-size base for the balance sheet.
double totalAssetsOf(List<AnalysisRow> balance) => _findValue(balance, _isTotalAssets);

/// Section header rows ("Operating Activities:" with no value) carry no analysis.
bool isSectionHeader(AnalysisRow row) => row.title.contains(':') && (row.value ?? 0) == 0;

/// Cash-flow "... Activities" captions with a zero value are headers too.
bool isCashFlowCaption(AnalysisRow row) =>
    isSectionHeader(row) ||
    ((row.value ?? 0) == 0 && row.title.toLowerCase().contains('activities'));

/// The comparison row matched by title, as on the website (`baseline.title === item.title`).
AnalysisRow? matchByTitle(List<AnalysisRow> rows, String title) {
  for (final r in rows) {
    if (r.title == title) return r;
  }
  return null;
}

/// The four analysis cells of one statement line (null fields are blank cells).
class AnalysisCells {
  final String? change;
  final String? changePercent;
  final String? shareCurrent;
  final String? shareCompare;

  /// +1 when the line went up, -1 down, 0 unchanged (drives the cell tone).
  final int direction;

  const AnalysisCells({
    this.change,
    this.changePercent,
    this.shareCurrent,
    this.shareCompare,
    this.direction = 0,
  });

  /// Mirrors the website's AnalysisCells: variance cells are blank on header rows and when
  /// both periods are zero; a common-size cell is blank on header rows and when its own
  /// value is zero.
  factory AnalysisCells.compute({
    required double current,
    required double compare,
    required double currentBase,
    required double compareBase,
    required bool blank,
  }) {
    final change = current - compare;
    final bothZero = current == 0 && compare == 0;
    return AnalysisCells(
      change: blank || bothZero ? null : fmtSignedCurrency(change),
      changePercent:
          blank || bothZero ? null : fmtAnalysisPct(changePct(current, compare), signed: true),
      shareCurrent:
          blank || current == 0 ? null : fmtAnalysisPct(commonSizeShare(current, currentBase)),
      shareCompare:
          blank || compare == 0 ? null : fmtAnalysisPct(commonSizeShare(compare, compareBase)),
      direction: change > 0 ? 1 : (change < 0 ? -1 : 0),
    );
  }
}

/// Period label used in column headers.
String periodLabel(int round, {String baseline = 'Baseline', String roundWord = 'Round'}) =>
    round == 0 ? baseline : '$roundWord $round';
