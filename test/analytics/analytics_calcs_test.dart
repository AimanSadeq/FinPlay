import 'package:flutter_test/flutter_test.dart';
import 'package:finplay/data/models/financial_data.dart';
import 'package:finplay/features/education/screens/dupont_screen.dart';
import 'package:finplay/features/education/screens/dividends_screen.dart';
import 'package:finplay/features/education/screens/working_capital_screen.dart';
import 'package:finplay/features/education/screens/credit_rating_screen.dart';
import 'package:finplay/features/education/screens/ratios_category_screen.dart';

void main() {
  group('Du Pont 5-way', () {
    test('the five factors reconcile with ROE', () {
      // Template baseline: Sales 7,000,000; EBIT 4,380,000; Zakat & Taxes 123,000;
      // Net Income 4,245,000.
      final f = DuPontFactors.compute(
        netIncome: 4245000,
        revenue: 7000000,
        totalAssets: 1215000,
        totalEquity: 615000,
        ebit: 4380000,
        zakatTaxes: 123000,
      );
      expect(f.ebt, 4368000);
      expect(f.taxBurden, closeTo(4245000 / 4368000, 1e-12));
      expect(f.interestBurden, closeTo(4368000 / 4380000, 1e-12));
      expect(f.ebitMargin, closeTo(4380000 / 7000000, 1e-12));
      expect(f.roeFromFiveFactors, closeTo(f.roe!, 1e-9));
      expect(f.roeFromFactors, closeTo(f.roe!, 1e-9));
      expect(duPontPct(f.taxBurden), '97.18%');
      expect(duPontTimes(f.assetTurnover), '5.76×');
    });

    test('a zero denominator voids the factor and the product', () {
      final f = DuPontFactors.compute(
          netIncome: 0, revenue: 100, totalAssets: 100, totalEquity: 50, ebit: 0, zakatTaxes: 0);
      expect(f.taxBurden, isNull);
      expect(f.interestBurden, isNull);
      expect(f.roeFromFiveFactors, isNull);
      expect(duPontPct(null), '-');
    });

    test('reads the statements with the website label matchers', () {
      final f = DuPontFactors.fromFinancials(FinancialData(
        teamId: 'Team 1',
        roundNum: 1,
        incomeRows: const [
          StatementRow(title: 'Sales', value: 1000),
          StatementRow(title: 'Operating Profit (EBITDA)', value: 300),
          StatementRow(title: 'Operating Profit (EBIT)', value: 250),
          StatementRow(title: 'Zakat & Taxes', value: 20),
          StatementRow(title: 'Net Income', value: 180),
        ],
        balanceRows: const [
          StatementRow(title: ' Total Assets ', value: 2000),
          StatementRow(title: " Total Shareholders' Equity ", value: 1000),
        ],
      ))!;
      expect(f.ebitMargin, closeTo(0.25, 1e-12));
      expect(f.interestBurden, closeTo(200 / 250, 1e-12));
      expect(f.roe, closeTo(0.18, 1e-12));
    });
  });

  group('Sustainable Growth Rate', () {
    test('SGR = retention × ROE; zero dividends means SGR = ROE', () {
      final m = DividendMetrics.compute(netIncome: 200, dividends: 60, totalEquity: 1000);
      expect(m.payout, closeTo(0.3, 1e-12));
      expect(m.retention, closeTo(0.7, 1e-12));
      expect(m.roe, closeTo(0.2, 1e-12));
      expect(m.sgr, closeTo(0.14, 1e-12));
      expect(m.classification, 'balanced');
      final none = DividendMetrics.compute(netIncome: 200, dividends: 0, totalEquity: 1000);
      expect(none.sgr, closeTo(none.roe!, 1e-12));
      expect(none.classification, 'reinvestment');
    });
    test('undefined without earnings or equity', () {
      expect(DividendMetrics.compute(netIncome: -5, dividends: 10, totalEquity: 100).payout, isNull);
      expect(DividendMetrics.compute(netIncome: -5, dividends: 10, totalEquity: 100).classification,
          'no-policy');
      expect(DividendMetrics.compute(netIncome: 5, dividends: 0, totalEquity: 0).sgr, isNull);
    });
    test('policy bands match the server', () {
      expect(DividendMetrics.classify(0.1), 'growth');
      expect(DividendMetrics.classify(0.2), 'balanced');
      expect(DividendMetrics.classify(0.4), 'mature');
      expect(DividendMetrics.classify(0.7), 'cash-return');
    });
  });

  group('working capital', () {
    test('turnovers and the days policy', () {
      final m = WorkingCapitalMetrics.fromPolicy(
        revenue: 730000,
        cogs: 365000,
        receivablesDays: 45,
        payablesDays: 50,
        inventory: 60000,
        currentAssets: 350000,
        currentLiabilities: 200000,
      );
      expect(m.dso, closeTo(45, 1e-9));
      expect(m.dpo, closeTo(50, 1e-9));
      expect(m.dio, closeTo(60, 1e-9));
      expect(m.ccc, closeTo(55, 1e-9));
      expect(m.wcTurnover, closeTo(730000 / 150000, 1e-12));
      expect(m.payablesTurnover, closeTo(365 / 50, 1e-9));
      expect(365 / m.payablesTurnover!, closeTo(m.dpo, 1e-9));
      expect(wcTurns(m.wcTurnover), '4.87×');
    });
    test('null turnovers on zero denominators', () {
      const m = WorkingCapitalMetrics(
          revenue: 1, cogs: 1, receivables: 0, inventory: 0, payables: 0,
          currentAssets: 5, currentLiabilities: 5);
      expect(m.wcTurnover, isNull);
      expect(m.payablesTurnover, isNull);
      expect(wcTurns(null), '—');
    });
  });

  group('credit rating scale (website RATING_SCALE)', () {
    test('worse of leverage and coverage binds', () {
      expect(CreditRatingScale.byLeverage(1.0), 0);
      expect(CreditRatingScale.byLeverage(3.0), 3);
      expect(CreditRatingScale.byLeverage(-1), 0);
      expect(CreditRatingScale.byCoverage(12), 0);
      expect(CreditRatingScale.byCoverage(4), 3);
      expect(CreditRatingScale.byCoverage(1.0), 6);
      expect(CreditRatingScale.rate(debt: 800, ebitda: 400, interest: 100), 3); // 2.0x / 4.0x
      expect(CreditRatingScale.rate(debt: 100, ebitda: 0, interest: 10), 6);
      expect(CreditRatingScale.rate(debt: 0, ebitda: 100, interest: 0), 0);
      expect(CreditRatingScale.spreads[3], 0.0175);
    });
  });

  test('ratio category values read as on the website', () {
    expect(formatCategoryRatio(null, 'Return on Equity (ROE)'), 'n/m');
    expect(formatCategoryRatio(0.123456, 'Net Profit Margin'), '12.35%');
    expect(formatCategoryRatio(3.857, 'Earnings per Share (EPS)'), 'SAR 3.86');
    expect(formatCategoryRatio(1.7166, 'Current Ratio'), '1.72');
  });
}
