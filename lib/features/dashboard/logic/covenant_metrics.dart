import '../../../data/models/financial_data.dart';
import 'statement_lookup.dart';

/// Debt / EBITDA and interest coverage of one round, derived the way the website's
/// covenants route does (server/routes/covenants.ts):
///   debt     = short-term debt + non-current liabilities, else total − current
///              liabilities, else total liabilities
///   EBITDA   = "Operating Profit (EBITDA)", else EBIT + |D&A|
///   coverage = EBITDA / |interest expense|
/// Null where a ratio is unbounded (EBITDA ≤ 0 with debt; no interest with EBITDA > 0).
class CovenantMetrics {
  final double debt;
  final double ebitda;
  final double interestExpense;

  const CovenantMetrics({required this.debt, required this.ebitda, required this.interestExpense});

  double? get debtToEbitda =>
      ebitda > 0 ? debt / ebitda : (debt > 0 ? null : 0);

  double? get interestCoverage =>
      interestExpense > 0 ? ebitda / interestExpense : (ebitda > 0 ? null : 0);

  /// Leverage covenant: breached above the maximum, or when unbounded.
  bool leverageBreached(double maxDebtToEbitda) {
    final v = debtToEbitda;
    return v == null ? true : v > maxDebtToEbitda;
  }

  /// Coverage covenant: breached below the minimum; when unbounded, only when there is
  /// interest to cover and no EBITDA.
  bool coverageBreached(double minInterestCoverage) {
    final v = interestCoverage;
    return v == null ? (interestExpense > 0 && ebitda <= 0) : v < minInterestCoverage;
  }

  static double _row(List<StatementRow> rows, List<String> matchers) =>
      matchStatementValue(rows, matchers);

  factory CovenantMetrics.fromFinancials(FinancialData d) {
    final ltd = _row(d.balanceRows, const [
      'long-term debt',
      'long term debt',
      'long-term borrowings',
      'long term borrowings',
      'long-term loans',
      'long-term loan',
      'non-current borrowings',
      'non-current liabilities',
    ]);
    final std = _row(d.balanceRows, const [
      'short-term debt',
      'short term debt',
      'short-term borrowings',
      'short term borrowings',
      'short-term loans',
      'short-term loan',
      'current portion of long-term debt',
    ]);
    final tl = d.totalLiabilities != 0
        ? d.totalLiabilities
        : _row(d.balanceRows, const ['total liabilities']);
    final cl = _row(d.balanceRows, const ['total current liabilities', 'current liabilities']);
    double debt;
    if (ltd + std > 0) {
      debt = ltd + std;
    } else if (tl > 0 && tl - cl > 0) {
      debt = tl - cl;
    } else {
      debt = tl;
    }
    var ebitda = _row(d.incomeRows,
        const ['operating profit (ebitda)', 'ebitda', 'operating income', 'operating profit']);
    if (ebitda == 0) {
      final ebit = _row(d.incomeRows, const ['operating profit (ebit)', 'ebit']);
      final dna = _row(d.incomeRows, const [
        'depreciation & amortization',
        'depreciation and amortization',
        'depreciation',
        'd&a',
      ]);
      if (ebit != 0) ebitda = ebit + dna.abs();
    }
    final interest = _row(d.incomeRows,
            const ['interest expense', 'finance cost', 'finance costs', 'interest paid'])
        .abs();
    return CovenantMetrics(debt: debt, ebitda: ebitda, interestExpense: interest);
  }
}
