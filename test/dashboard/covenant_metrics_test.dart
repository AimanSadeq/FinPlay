import 'package:flutter_test/flutter_test.dart';
import 'package:finplay/data/models/financial_data.dart';
import 'package:finplay/features/dashboard/logic/covenant_metrics.dart';
import 'package:finplay/features/dashboard/providers/realism_flags_provider.dart';

void main() {
  test('debt = short-term debt + non-current liabilities; EBITDA from the EBITDA line', () {
    final fd = FinancialData(
      teamId: 'Team 1',
      roundNum: 1,
      incomeRows: const [
        StatementRow(title: 'Operating Profit (EBITDA)', value: 1000),
        StatementRow(title: 'Operating Profit (EBIT)', value: 900),
        StatementRow(title: 'Interest Income', value: 50),
        StatementRow(title: 'Interest Expense', value: 200),
      ],
      balanceRows: const [
        StatementRow(title: ' Short-Term Debt ', value: 500),
        StatementRow(title: ' Total Current Liabilities ', value: 800),
        StatementRow(title: 'Total Non-Current Liabilities', value: 2500),
        StatementRow(title: ' Total Liabilities ', value: 3300),
      ],
    );
    final m = CovenantMetrics.fromFinancials(fd);
    expect(m.debt, 3000);
    expect(m.ebitda, 1000);
    expect(m.interestExpense, 200);
    expect(m.debtToEbitda, 3.0);
    expect(m.interestCoverage, 5.0);
    expect(m.leverageBreached(4.0), isFalse);
    expect(m.leverageBreached(2.5), isTrue);
    expect(m.coverageBreached(2.0), isFalse);
  });

  test('unbounded ratios follow covenants.ts', () {
    const noEbitda = CovenantMetrics(debt: 100, ebitda: 0, interestExpense: 10);
    expect(noEbitda.debtToEbitda, isNull);
    expect(noEbitda.leverageBreached(4), isTrue);
    expect(noEbitda.coverageBreached(2), isTrue);
    const noInterest = CovenantMetrics(debt: 0, ebitda: 100, interestExpense: 0);
    expect(noInterest.debtToEbitda, 0);
    expect(noInterest.interestCoverage, isNull);
    expect(noInterest.coverageBreached(2), isFalse);
  });

  test('realism flags: server thresholds and the first enabled ratio category', () {
    final f = RealismFlags.fromJson({
      'duPontEnabled': true,
      'ratiosLiquidityEnabled': false,
      'ratiosSolvencyEnabled': true,
      'covenantThresholds': {'maxDebtToEbitda': 3.5, 'minInterestCoverage': 2.5},
    });
    expect(f.isOn('duPontEnabled'), isTrue);
    expect(f.isOn('waccEnabled'), isFalse);
    expect(f.anyRatios, isTrue);
    expect(f.firstRatiosRoute, '/ratios/solvency');
    expect(f.maxDebtToEbitda, 3.5);
    expect(const RealismFlags().maxDebtToEbitda, 4.0);
    expect(RealismFlags.allOn.firstRatiosRoute, '/ratios/liquidity');
  });
}
