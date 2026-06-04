import 'package:flutter_test/flutter_test.dart';
import 'package:finplay/data/models/financial_data.dart';

void main() {
  group('StatementRow', () {
    test('constructs with defaults', () {
      const row = StatementRow(title: 'Revenue');
      expect(row.title, 'Revenue');
      expect(row.value, 0);
      expect(row.isHeader, false);
      expect(row.isMajor, false);
      expect(row.isCalculation, false);
      expect(row.type, isNull);
    });

    test('fromJson parses all fields', () {
      final row = StatementRow.fromJson({
        'title': 'Net Income',
        'value': 125000.0,
        'isHeader': true,
        'isMajor': true,
        'isCalculation': true,
        'type': 'Profitability',
      });
      expect(row.title, 'Net Income');
      expect(row.value, 125000.0);
      expect(row.isHeader, true);
      expect(row.isMajor, true);
      expect(row.isCalculation, true);
      expect(row.type, 'Profitability');
    });

    test('fromJson handles NaN string', () {
      final row = StatementRow.fromJson({'title': 'X', 'value': 'NaN'});
      expect(row.value, 0);
    });

    test('fromJson handles empty string value', () {
      final row = StatementRow.fromJson({'title': 'X', 'value': ''});
      expect(row.value, 0);
    });

    test('fromJson handles numeric string value', () {
      final row = StatementRow.fromJson({'title': 'X', 'value': '42.5'});
      expect(row.value, 42.5);
    });

    test('fromJson handles int value', () {
      final row = StatementRow.fromJson({'title': 'X', 'value': 100});
      expect(row.value, 100.0);
    });

    test('fromJson handles null value', () {
      final row = StatementRow.fromJson({'title': 'X', 'value': null});
      expect(row.value, 0);
    });

    test('fromJson handles missing fields', () {
      final row = StatementRow.fromJson({});
      expect(row.title, '');
      expect(row.value, 0);
      expect(row.isHeader, false);
    });
  });

  group('FinancialData', () {
    group('constructor', () {
      test('has correct defaults', () {
        const data = FinancialData(teamId: 'Team 1', roundNum: 1);
        expect(data.teamId, 'Team 1');
        expect(data.roundNum, 1);
        expect(data.incomeRows, isEmpty);
        expect(data.balanceRows, isEmpty);
        expect(data.cashFlowRows, isEmpty);
        expect(data.ratioRows, isEmpty);
        expect(data.revenue, 0);
        expect(data.netIncome, 0);
        expect(data.totalAssets, 0);
        expect(data.totalLiabilities, 0);
        expect(data.totalEquity, 0);
        expect(data.operatingCashFlow, 0);
        expect(data.totalScore, 0);
        expect(data.source, isNull);
      });
    });

    group('backward-compatible getters', () {
      test('incomeStatement returns null when empty', () {
        const data = FinancialData(teamId: 'T1', roundNum: 1);
        expect(data.incomeStatement, isNull);
      });

      test('incomeStatement returns map from rows', () {
        const data = FinancialData(
          teamId: 'T1',
          roundNum: 1,
          incomeRows: [
            StatementRow(title: 'Revenue', value: 500000),
            StatementRow(title: 'Net Income', value: 125000),
          ],
        );
        expect(data.incomeStatement, {'Revenue': 500000.0, 'Net Income': 125000.0});
      });

      test('balanceSheet returns null when empty', () {
        const data = FinancialData(teamId: 'T1', roundNum: 1);
        expect(data.balanceSheet, isNull);
      });

      test('balanceSheet returns map from rows', () {
        const data = FinancialData(
          teamId: 'T1',
          roundNum: 1,
          balanceRows: [
            StatementRow(title: 'Total Assets', value: 1000000),
          ],
        );
        expect(data.balanceSheet, {'Total Assets': 1000000.0});
      });

      test('cashFlow returns null when empty', () {
        const data = FinancialData(teamId: 'T1', roundNum: 1);
        expect(data.cashFlow, isNull);
      });

      test('ratios returns null when empty', () {
        const data = FinancialData(teamId: 'T1', roundNum: 1);
        expect(data.ratios, isNull);
      });
    });

    group('fromSheetResponse', () {
      test('parses full API response', () {
        final json = {
          'team': 'Team 1',
          'round': 2,
          'source': 'excel',
          'financials': {
            'incomeStatement': [
              {'title': 'Revenue', 'value': 500000, 'isHeader': true},
              {'title': 'COGS', 'value': -200000},
            ],
            'balanceSheet': [
              {'title': 'Total Assets', 'value': 1000000, 'isMajor': true},
            ],
            'cashFlow': [
              {'title': 'Operating CF', 'value': 150000},
            ],
            'ratios': [
              {'title': 'Current Ratio', 'value': 1.5, 'type': 'Liquidity'},
            ],
          },
          'kpis': {
            '_rawValues': {
              'revenue': 500000,
              'netIncome': 125000,
              'totalAssets': 1000000,
              'totalLiabilities': 600000,
              'totalEquity': 400000,
            },
            'operatingCashFlowRatio': 150000,
          },
        };

        final data = FinancialData.fromSheetResponse(json);
        expect(data.teamId, 'Team 1');
        expect(data.roundNum, 2);
        expect(data.source, 'excel');
        expect(data.incomeRows.length, 2);
        expect(data.incomeRows[0].title, 'Revenue');
        expect(data.incomeRows[0].isHeader, true);
        expect(data.balanceRows.length, 1);
        expect(data.cashFlowRows.length, 1);
        expect(data.ratioRows.length, 1);
        expect(data.ratioRows[0].type, 'Liquidity');
        expect(data.revenue, 500000);
        expect(data.netIncome, 125000);
        expect(data.totalAssets, 1000000);
        expect(data.totalLiabilities, 600000);
        expect(data.totalEquity, 400000);
        expect(data.operatingCashFlow, 150000);
      });

      test('handles empty response', () {
        final data = FinancialData.fromSheetResponse({});
        expect(data.teamId, '');
        expect(data.roundNum, 1);
        expect(data.incomeRows, isEmpty);
        expect(data.revenue, 0);
      });

      test('falls back to kpis when _rawValues missing', () {
        final data = FinancialData.fromSheetResponse({
          'kpis': {
            'revenue': 300000,
            'netIncome': 50000,
          },
        });
        expect(data.revenue, 300000);
        expect(data.netIncome, 50000);
      });

      test('extracts KPIs from statement rows when kpis missing (dashboard-data format)', () {
        // This is the format returned by /api/dashboard-data
        final data = FinancialData.fromSheetResponse({
          'team': 'Team 1',
          'round': 1,
          'financials': {
            'incomeStatement': [
              {'title': 'Sales', 'value': 8893434.4},
              {'title': 'Cost of Sales', 'value': 3846410.378},
              {'title': 'Net Income', 'value': 35469419.19, 'isCalculation': true},
            ],
            'balanceSheet': [
              {'title': 'Total Assets', 'value': 5000000.0},
              {'title': 'Total Liabilities', 'value': 3000000.0},
              {'title': "Total Shareholders' Equity", 'value': 2000000.0},
            ],
            'cashFlow': [
              {'title': 'Operating Cash Flow', 'value': 150000.0},
            ],
            'ratios': [],
          },
        });

        expect(data.revenue, closeTo(8893434.4, 0.1));
        expect(data.netIncome, closeTo(35469419.19, 0.1));
        expect(data.totalAssets, closeTo(5000000.0, 0.1));
        expect(data.totalLiabilities, closeTo(3000000.0, 0.1));
        expect(data.totalEquity, closeTo(2000000.0, 0.1));
        expect(data.operatingCashFlow, closeTo(150000.0, 0.1));
      });

      test('handles NaN values in kpis', () {
        final data = FinancialData.fromSheetResponse({
          'kpis': {
            '_rawValues': {'revenue': 'NaN', 'netIncome': ''},
          },
        });
        expect(data.revenue, 0);
        expect(data.netIncome, 0);
      });
    });

    group('fromJson (legacy)', () {
      test('parses legacy format', () {
        final data = FinancialData.fromJson({
          'teamId': 'Team 1',
          'roundNum': 2,
          'totalScore': 850.0,
        });
        expect(data.teamId, 'Team 1');
        expect(data.roundNum, 2);
        expect(data.totalScore, 850.0);
      });

      test('delegates to fromSheetResponse when financials present', () {
        final data = FinancialData.fromJson({
          'financials': {
            'incomeStatement': [
              {'title': 'Revenue', 'value': 500000},
            ],
          },
        });
        expect(data.incomeRows.length, 1);
      });

      test('applies defaults for empty json', () {
        final data = FinancialData.fromJson({});
        expect(data.teamId, '');
        expect(data.roundNum, 1);
        expect(data.totalScore, 0);
      });

      test('converts teamId to string', () {
        final data = FinancialData.fromJson({'teamId': 3, 'roundNum': 1});
        expect(data.teamId, '3');
      });
    });

    group('mergeWith', () {
      test('merges two data objects', () {
        const a = FinancialData(
          teamId: 'Team 1',
          roundNum: 2,
          revenue: 500000,
          incomeRows: [StatementRow(title: 'Revenue', value: 500000)],
        );
        const b = FinancialData(
          teamId: 'Team 1',
          roundNum: 2,
          netIncome: 125000,
          balanceRows: [StatementRow(title: 'Total Assets', value: 1000000)],
        );

        final merged = a.mergeWith(b);
        expect(merged.teamId, 'Team 1');
        expect(merged.revenue, 500000);
        expect(merged.netIncome, 125000);
        expect(merged.incomeRows.length, 1);
        expect(merged.balanceRows.length, 1);
      });

      test('first value wins when both non-zero', () {
        const a = FinancialData(teamId: 'T1', roundNum: 1, revenue: 100);
        const b = FinancialData(teamId: 'T2', roundNum: 2, revenue: 200);
        final merged = a.mergeWith(b);
        expect(merged.teamId, 'T1');
        expect(merged.roundNum, 1);
        expect(merged.revenue, 100);
      });

      test('falls back to other when first is zero/empty', () {
        const a = FinancialData(teamId: '', roundNum: 0, revenue: 0);
        const b = FinancialData(teamId: 'T2', roundNum: 2, revenue: 200);
        final merged = a.mergeWith(b);
        expect(merged.teamId, 'T2');
        expect(merged.roundNum, 2);
        expect(merged.revenue, 200);
      });
    });
  });

  group('LeaderboardEntry', () {
    group('fromJson', () {
      test('parses new /leaderboard/live format with nested metrics', () {
        final json = {
          'teamId': 'Team 1',
          'teamName': 'Riyadh (Team 1)',
          'displayName': 'Riyadh',
          'round': 2,
          'score': 850.5,
          'rank': 1,
          'metrics': {
            'netIncome': 125000.0,
            'revenue': 500000.0,
            'totalAssets': 1000000.0,
            'totalEquity': 400000.0,
            'roe': 31.25,
          },
          'cashFlow': {
            'isCashRich': true,
            'operating': 150000.0,
            'investing': -50000.0,
            'financing': -30000.0,
          },
          'badges': ['Revenue Leader'],
        };

        final entry = LeaderboardEntry.fromJson(json);
        expect(entry.teamId, 'Team 1');
        expect(entry.teamName, 'Riyadh (Team 1)');
        expect(entry.displayName, 'Riyadh');
        expect(entry.roundNum, 2);
        expect(entry.score, 850.5);
        expect(entry.rank, 1);
        expect(entry.netIncome, 125000.0);
        expect(entry.revenue, 500000.0);
        expect(entry.totalAssets, 1000000.0);
        expect(entry.totalEquity, 400000.0);
        expect(entry.roeValue, 31.25);
        expect(entry.roe, 31.25);
        expect(entry.isCashRich, true);
        expect(entry.operatingCF, 150000.0);
        expect(entry.investingCF, -50000.0);
        expect(entry.financingCF, -30000.0);
        expect(entry.cashFlowValue, closeTo(70000.0, 0.01));
        expect(entry.badges, ['Revenue Leader']);
      });

      test('parses flat/legacy format', () {
        final json = {
          'teamId': 'Team 1',
          'teamName': 'Riyadh (Team 1)',
          'roundNum': 2,
          'score': 850.5,
          'rank': 1,
          'netIncome': 125000.0,
          'revenue': 500000.0,
          'totalAssets': 1000000.0,
        };

        final entry = LeaderboardEntry.fromJson(json);
        expect(entry.teamId, 'Team 1');
        expect(entry.roundNum, 2);
        expect(entry.netIncome, 125000.0);
        expect(entry.revenue, 500000.0);
      });

      test('generates teamName from teamId when missing', () {
        final entry = LeaderboardEntry.fromJson({
          'teamId': 'Team 3',
          'score': 100,
        });
        expect(entry.teamName, 'Team Team 3');
      });

      test('applies defaults for missing fields', () {
        final entry = LeaderboardEntry.fromJson({
          'teamId': 'Team 1',
          'teamName': 'Test',
          'score': 0,
        });
        expect(entry.rank, 0);
        expect(entry.netIncome, 0);
        expect(entry.revenue, 0);
        expect(entry.totalAssets, 0);
        expect(entry.isCashRich, false);
        expect(entry.badges, isEmpty);
      });
    });

    group('_parseDouble (via fromJson)', () {
      test('handles null value', () {
        final entry = LeaderboardEntry.fromJson({
          'teamId': 'T1', 'teamName': 'Test', 'score': null,
        });
        expect(entry.score, 0);
      });

      test('handles int value', () {
        final entry = LeaderboardEntry.fromJson({
          'teamId': 'T1', 'teamName': 'Test', 'score': 100,
        });
        expect(entry.score, 100.0);
      });

      test('handles double value', () {
        final entry = LeaderboardEntry.fromJson({
          'teamId': 'T1', 'teamName': 'Test', 'score': 99.5,
        });
        expect(entry.score, 99.5);
      });

      test('handles "NaN" string', () {
        final entry = LeaderboardEntry.fromJson({
          'teamId': 'T1', 'teamName': 'Test', 'score': 100,
          'metrics': {'netIncome': 'NaN'},
        });
        expect(entry.netIncome, 0);
      });

      test('handles empty string', () {
        final entry = LeaderboardEntry.fromJson({
          'teamId': 'T1', 'teamName': 'Test', 'score': 100,
          'metrics': {'revenue': ''},
        });
        expect(entry.revenue, 0);
      });

      test('handles numeric string', () {
        final entry = LeaderboardEntry.fromJson({
          'teamId': 'T1', 'teamName': 'Test', 'score': '750.5',
        });
        expect(entry.score, 750.5);
      });

      test('handles non-parseable string', () {
        final entry = LeaderboardEntry.fromJson({
          'teamId': 'T1', 'teamName': 'Test', 'score': 'abc',
        });
        expect(entry.score, 0);
      });
    });

    group('computed ratios', () {
      test('roe returns roeValue directly', () {
        const entry = LeaderboardEntry(
          teamId: 'T1', teamName: 'Test', score: 100, roeValue: 15.5,
        );
        expect(entry.roe, 15.5);
      });

      test('profitMargin is correct', () {
        const entry = LeaderboardEntry(
          teamId: 'T1', teamName: 'Test', score: 100,
          netIncome: 50000, revenue: 200000,
        );
        expect(entry.profitMargin, closeTo(25.0, 0.01));
      });

      test('assetTurnover is correct', () {
        const entry = LeaderboardEntry(
          teamId: 'T1', teamName: 'Test', score: 100,
          revenue: 500000, totalAssets: 1000000,
        );
        expect(entry.assetTurnover, closeTo(0.5, 0.01));
      });

      test('returns 0 for profitMargin when revenue is 0', () {
        const entry = LeaderboardEntry(
          teamId: 'T1', teamName: 'Test', score: 100,
          netIncome: 50000, revenue: 0,
        );
        expect(entry.profitMargin, 0);
      });

      test('returns 0 for assetTurnover when totalAssets is 0', () {
        const entry = LeaderboardEntry(
          teamId: 'T1', teamName: 'Test', score: 100,
          revenue: 500000, totalAssets: 0,
        );
        expect(entry.assetTurnover, 0);
      });

      test('handles negative netIncome in ratios', () {
        const entry = LeaderboardEntry(
          teamId: 'T1', teamName: 'Test', score: 100,
          netIncome: -50000, revenue: 200000,
        );
        expect(entry.profitMargin, closeTo(-25.0, 0.01));
      });

      test('cashFlowValue sums all flows', () {
        const entry = LeaderboardEntry(
          teamId: 'T1', teamName: 'Test', score: 100,
          operatingCF: 150000, investingCF: -50000, financingCF: -30000,
        );
        expect(entry.cashFlowValue, closeTo(70000.0, 0.01));
      });
    });
  });
}
