import 'package:flutter_test/flutter_test.dart';
import 'package:finplay/features/dashboard/logic/statement_analysis.dart';
import 'package:finplay/features/dashboard/logic/ratio_format.dart';

void main() {
  group('compare round', () {
    test('a chosen round must be earlier than the round shown, else the round before', () {
      expect(resolveCompareRound(3, null), 2);
      expect(resolveCompareRound(3, 0), 0);
      expect(resolveCompareRound(3, 1), 1);
      expect(resolveCompareRound(3, 3), 2);
      expect(resolveCompareRound(2, 5), 1);
      expect(resolveCompareRound(1, null), 0);
      expect(resolveCompareRound(1, -1), 0);
    });

    test('offers Baseline and every earlier round from round 2 onwards', () {
      expect(compareRoundOptions(1), isEmpty);
      expect(compareRoundOptions(2), [0, 1]);
      expect(compareRoundOptions(3), [0, 1, 2]);
    });
  });

  group('variance and common size', () {
    test('percent change is against the absolute comparison value; n/m on a zero base', () {
      expect(changePct(120, 100), closeTo(0.2, 1e-12));
      expect(changePct(-50, -100), closeTo(0.5, 1e-12));
      expect(changePct(-150, -100), closeTo(-0.5, 1e-12));
      expect(changePct(10, 0), isNull);
      expect(fmtAnalysisPct(null), 'n/m');
      expect(fmtAnalysisPct(double.infinity), 'n/m');
      expect(fmtAnalysisPct(0.123, signed: true), '+12.3%');
      expect(fmtAnalysisPct(-0.05, signed: true), '-5.0%');
      expect(fmtAnalysisPct(0.25), '25.0%');
    });

    test('signed currency', () {
      expect(fmtSignedCurrency(1200), '+\$1,200');
      expect(fmtSignedCurrency(-1234567.4), '-\$1,234,567');
      expect(fmtSignedCurrency(0), '\$0');
    });

    test('cells: blank on headers and when both periods are zero', () {
      final header = AnalysisCells.compute(
          current: 0, compare: 0, currentBase: 100, compareBase: 100, blank: true);
      expect(header.change, isNull);
      expect(header.shareCurrent, isNull);
      final zero = AnalysisCells.compute(
          current: 0, compare: 0, currentBase: 100, compareBase: 100, blank: false);
      expect(zero.change, isNull);
      expect(zero.changePercent, isNull);
      final line = AnalysisCells.compute(
          current: 30, compare: 0, currentBase: 200, compareBase: 100, blank: false);
      expect(line.change, '+\$30');
      expect(line.changePercent, 'n/m');
      expect(line.shareCurrent, '15.0%');
      expect(line.shareCompare, isNull);
      expect(line.direction, 1);
    });

    test('bases: Sales for income and cash flow, Total Assets (not current) for balance', () {
      const income = [
        AnalysisRow(title: 'Sales', value: 7000000),
        AnalysisRow(title: 'Gross Profit', value: 5250000),
      ];
      const balance = [
        AnalysisRow(title: ' Total Current Assets ', value: 100),
        AnalysisRow(title: ' Total Assets ', value: 900),
      ];
      expect(salesOf(income), 7000000);
      expect(totalAssetsOf(balance), 900);
      expect(isSectionHeader(const AnalysisRow(title: 'EQUITY:', value: 0)), isTrue);
      expect(isCashFlowCaption(const AnalysisRow(title: 'Operating Activities', value: 0)), isTrue);
    });
  });

  test('parses the dashboard-data response, keeping null ratio values', () {
    final res = {
      'data': {
        'currentRound': {
          'income': {
            'financials': {
              'incomeStatement': [
                {'title': 'Sales', 'value': 100, 'isMajor': false},
              ]
            }
          },
          'ratios': {
            'financials': {
              'ratios': [
                {'title': 'Return on Equity (ROE)', 'value': null, 'type': 'Profitability'},
              ]
            }
          },
        },
        'previousRound': {
          'income': {
            'financials': {
              'incomeStatement': [
                {'title': 'Sales', 'value': '80'},
              ]
            }
          },
        },
      }
    };
    final c = StatementComparison.fromResponse(res, 2, 0);
    expect(c.current.income.single.value, 100);
    expect(c.compare.income.single.value, 80);
    expect(c.current.ratios.single.value, isNull);
    expect(formatRatio(c.current.ratios.single.title, c.current.ratios.single.value), 'n/m');
  });

  group('ratio format (website ratio-format.ts)', () {
    test('kinds', () {
      expect(ratioKind('Net Profit Margin'), RatioKind.percent);
      expect(ratioKind('Debt to Equity Ratio'), RatioKind.percent);
      expect(ratioKind('Interest Coverage Ratio'), RatioKind.multiple);
      expect(ratioKind('Price to Earnings (P/E) Ratio'), RatioKind.multiple);
      expect(ratioKind('Current Ratio'), RatioKind.number);
    });
    test('values', () {
      expect(formatRatio('Return on Equity (ROE)', 0.2919), '29.2%');
      expect(formatRatio('Interest Coverage Ratio', 148.77), '148.8x');
      expect(formatRatio('Current Ratio', 1.7166), '1.7');
      expect(formatRatio('Inventory Turnover', 1196.768), '1,196.8');
      expect(formatRatio('Current Ratio', null), '-');
      expect(formatRatio('Price to Earnings (P/E) Ratio', null), 'n/m');
      expect(formatRatio('Current Ratio', '2.25'), '2.3');
    });
  });
}
