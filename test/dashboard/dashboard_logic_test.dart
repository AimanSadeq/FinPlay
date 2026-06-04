import 'package:flutter_test/flutter_test.dart';
import 'package:finplay/data/models/financial_data.dart';
import 'package:finplay/providers/financial_provider.dart';

void main() {
  group('FinancialState', () {
    test('has correct defaults', () {
      const state = FinancialState();
      expect(state.teamFinancials, isNull);
      expect(state.allTeamFinancials, isEmpty);
      expect(state.leaderboard, isEmpty);
      expect(state.previousLeaderboard, isEmpty);
      expect(state.selectedRound, 0);
      expect(state.isLoading, false);
      expect(state.error, isNull);
    });

    test('copyWith preserves existing values', () {
      const original = FinancialState(
        selectedRound: 2,
        isLoading: true,
      );
      final copied = original.copyWith(isLoading: false);
      expect(copied.selectedRound, 2);
      expect(copied.isLoading, false);
    });

    test('copyWith sets error to null explicitly', () {
      final state = const FinancialState(error: 'some error');
      final cleared = state.copyWith(error: null);
      expect(cleared.error, isNull);
    });

    test('copyWith sets teamFinancials', () {
      const data = FinancialData(
        teamId: 'Team 1', roundNum: 1, revenue: 500000,
      );
      const state = FinancialState();
      final updated = state.copyWith(teamFinancials: data);
      expect(updated.teamFinancials?.teamId, 'Team 1');
      expect(updated.teamFinancials?.revenue, 500000);
    });

    test('copyWith sets leaderboard', () {
      final leaderboard = [
        const LeaderboardEntry(teamId: 'Team 1', teamName: 'T1', score: 100),
        const LeaderboardEntry(teamId: 'Team 2', teamName: 'T2', score: 80),
      ];
      const state = FinancialState();
      final updated = state.copyWith(leaderboard: leaderboard);
      expect(updated.leaderboard.length, 2);
      expect(updated.leaderboard[0].score, 100);
    });
  });

  group('Dashboard leaderboard sorting', () {
    test('sorts teams by score descending', () {
      final leaderboard = [
        const LeaderboardEntry(teamId: 'Team 3', teamName: 'T3', score: 60),
        const LeaderboardEntry(teamId: 'Team 1', teamName: 'T1', score: 100),
        const LeaderboardEntry(teamId: 'Team 2', teamName: 'T2', score: 80),
      ];
      final sorted = List<LeaderboardEntry>.from(leaderboard);
      sorted.sort((a, b) => b.score.compareTo(a.score));

      expect(sorted[0].teamId, 'Team 1');
      expect(sorted[1].teamId, 'Team 2');
      expect(sorted[2].teamId, 'Team 3');
    });

    test('handles tied scores', () {
      final leaderboard = [
        const LeaderboardEntry(teamId: 'Team 1', teamName: 'T1', score: 80),
        const LeaderboardEntry(teamId: 'Team 2', teamName: 'T2', score: 80),
      ];
      final sorted = List<LeaderboardEntry>.from(leaderboard);
      sorted.sort((a, b) => b.score.compareTo(a.score));
      expect(sorted.length, 2);
      // Both have same score — order is stable
    });

    test('handles empty leaderboard', () {
      final leaderboard = <LeaderboardEntry>[];
      final sorted = List<LeaderboardEntry>.from(leaderboard);
      sorted.sort((a, b) => b.score.compareTo(a.score));
      expect(sorted, isEmpty);
    });

    test('handles single team', () {
      final leaderboard = [
        const LeaderboardEntry(teamId: 'Team 1', teamName: 'T1', score: 100),
      ];
      final sorted = List<LeaderboardEntry>.from(leaderboard);
      sorted.sort((a, b) => b.score.compareTo(a.score));
      expect(sorted.length, 1);
      expect(sorted[0].score, 100);
    });
  });

  group('Dashboard score lookup', () {
    // Mirrors _findScore logic from dashboard_screen.dart
    double findScore(List<LeaderboardEntry> leaderboard, String teamId) {
      if (leaderboard.isEmpty) return 0;
      final entry = leaderboard.where((e) => e.teamId == teamId).firstOrNull;
      return entry?.score ?? 0;
    }

    int findRank(List<LeaderboardEntry> leaderboard, String? teamId) {
      if (teamId == null || leaderboard.isEmpty) return 0;
      final entry = leaderboard.where((e) => e.teamId == teamId).firstOrNull;
      return entry?.rank ?? 0;
    }

    final leaderboard = [
      const LeaderboardEntry(teamId: 'Team 1', teamName: 'T1', score: 100, rank: 1),
      const LeaderboardEntry(teamId: 'Team 2', teamName: 'T2', score: 80, rank: 2),
      const LeaderboardEntry(teamId: 'Team 3', teamName: 'T3', score: 60, rank: 3),
    ];

    test('finds correct score for existing team', () {
      expect(findScore(leaderboard, 'Team 2'), 80);
    });

    test('returns 0 for non-existent team', () {
      expect(findScore(leaderboard, 'Team 9'), 0);
    });

    test('returns 0 for empty leaderboard', () {
      expect(findScore([], 'Team 1'), 0);
    });

    test('finds correct rank for existing team', () {
      expect(findRank(leaderboard, 'Team 1'), 1);
      expect(findRank(leaderboard, 'Team 3'), 3);
    });

    test('returns 0 for null teamId', () {
      expect(findRank(leaderboard, null), 0);
    });

    test('returns 0 for non-existent team rank', () {
      expect(findRank(leaderboard, 'Team 9'), 0);
    });
  });

  group('Dashboard KPI extraction', () {
    test('extracts KPIs from financial data', () {
      const data = FinancialData(
        teamId: 'Team 1',
        roundNum: 1,
        revenue: 500000,
        netIncome: 125000,
        totalAssets: 1000000,
        operatingCashFlow: 150000,
      );
      expect(data.revenue, 500000);
      expect(data.netIncome, 125000);
      expect(data.totalAssets, 1000000);
      expect(data.operatingCashFlow, 150000);
    });

    test('returns 0 for missing KPIs', () {
      const data = FinancialData(teamId: 'T1', roundNum: 1);
      expect(data.revenue, 0);
      expect(data.netIncome, 0);
      expect(data.totalAssets, 0);
      expect(data.operatingCashFlow, 0);
    });
  });

  group('Dashboard round selection', () {
    test('round 0 means latest/current', () {
      // This mirrors the dashboard logic: selectedRound=0 means use active round
      const selectedRound = 0;
      const activeRound = 2;
      final effectiveRound = selectedRound > 0 ? selectedRound : activeRound;
      expect(effectiveRound, 2);
    });

    test('explicit round overrides active round', () {
      const selectedRound = 1;
      const activeRound = 3;
      final effectiveRound = selectedRound > 0 ? selectedRound : activeRound;
      expect(effectiveRound, 1);
    });
  });

  group('Dashboard financial statement rendering', () {
    test('income statement uses incomeRows when available', () {
      const data = FinancialData(
        teamId: 'T1',
        roundNum: 1,
        incomeRows: [
          StatementRow(title: 'Revenue', value: 500000, isHeader: true),
          StatementRow(title: 'COGS', value: -200000),
          StatementRow(title: 'Net Income', value: 125000, isMajor: true),
        ],
        revenue: 500000,
        netIncome: 125000,
      );
      expect(data.incomeRows.length, 3);
      expect(data.incomeRows[0].isHeader, true);
      expect(data.incomeRows[2].isMajor, true);
    });

    test('falls back to KPI values when no rows', () {
      const data = FinancialData(
        teamId: 'T1',
        roundNum: 1,
        revenue: 500000,
        netIncome: 125000,
      );
      expect(data.incomeRows, isEmpty);
      // Dashboard falls back to revenue/netIncome fields
      expect(data.revenue, 500000);
      expect(data.netIncome, 125000);
    });

    test('balance sheet rows with validation', () {
      const data = FinancialData(
        teamId: 'T1',
        roundNum: 1,
        balanceRows: [
          StatementRow(title: 'Total Assets', value: 1000000, isMajor: true),
          StatementRow(title: 'Total Liabilities', value: 600000, isMajor: true),
          StatementRow(title: 'Total Equity', value: 400000, isMajor: true),
        ],
        totalAssets: 1000000,
        totalLiabilities: 600000,
        totalEquity: 400000,
      );
      // Balance validation: assets = liabilities + equity
      final isBalanced = (data.totalAssets - (data.totalLiabilities + data.totalEquity)).abs() < 1;
      expect(isBalanced, true);
    });

    test('ratio rows include type classification', () {
      const data = FinancialData(
        teamId: 'T1',
        roundNum: 1,
        ratioRows: [
          StatementRow(title: 'Current Ratio', value: 1.5, type: 'Liquidity'),
          StatementRow(title: 'Profit Margin', value: 0.25, type: 'Profitability'),
          StatementRow(title: 'Asset Turnover', value: 0.5, type: 'Efficiency'),
          StatementRow(title: 'Debt/Equity', value: 1.5, type: 'Solvency'),
        ],
      );
      expect(data.ratioRows.length, 4);
      expect(data.ratioRows[0].type, 'Liquidity');
      expect(data.ratioRows[1].type, 'Profitability');
    });
  });

  group('Dashboard leaderboard display', () {
    test('team color index extracted from teamId', () {
      // Mirrors dashboard logic for team color
      String teamId = 'Team 3';
      final teamIdx = int.tryParse(teamId.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1;
      expect(teamIdx, 3);
      expect((teamIdx - 1).clamp(0, 6), 2); // color index
    });

    test('team color index defaults for non-numeric teamId', () {
      String teamId = 'Alpha';
      final teamIdx = int.tryParse(teamId.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1;
      // No digits → empty string → tryParse returns null → defaults to 1
      expect(teamIdx, 1);
    });

    test('displayName preferred over teamName', () {
      const entry = LeaderboardEntry(
        teamId: 'Team 1',
        teamName: 'Riyadh (Team 1)',
        displayName: 'Riyadh',
        score: 100,
      );
      final name = entry.displayName.isNotEmpty ? entry.displayName : entry.teamName;
      expect(name, 'Riyadh');
    });

    test('falls back to teamName when displayName empty', () {
      const entry = LeaderboardEntry(
        teamId: 'Team 1',
        teamName: 'Riyadh (Team 1)',
        score: 100,
      );
      final name = entry.displayName.isNotEmpty ? entry.displayName : entry.teamName;
      expect(name, 'Riyadh (Team 1)');
    });

    test('money formatting', () {
      // Mirrors _fmtMoney from _LiveLeaderboard
      String fmtMoney(double v) {
        final abs = v.abs();
        final sign = v < 0 ? '-' : '';
        if (abs >= 1000000) return '$sign\$${(abs / 1000000).toStringAsFixed(1)}M';
        if (abs >= 1000) return '$sign\$${(abs / 1000).toStringAsFixed(1)}k';
        return '$sign\$${abs.toStringAsFixed(0)}';
      }

      expect(fmtMoney(1500000), '\$1.5M');
      expect(fmtMoney(125000), '\$125.0k');
      expect(fmtMoney(500), '\$500');
      expect(fmtMoney(-50000), '-\$50.0k');
      expect(fmtMoney(0), '\$0');
      expect(fmtMoney(-1200000), '-\$1.2M');
    });
  });

  group('Dashboard data merging (lazy tab loading)', () {
    test('merging adds balance data to existing income data', () {
      const income = FinancialData(
        teamId: 'Team 1',
        roundNum: 1,
        incomeRows: [StatementRow(title: 'Revenue', value: 500000)],
        revenue: 500000,
      );
      const balance = FinancialData(
        teamId: 'Team 1',
        roundNum: 1,
        balanceRows: [StatementRow(title: 'Total Assets', value: 1000000)],
        totalAssets: 1000000,
      );

      final merged = income.mergeWith(balance);
      expect(merged.incomeRows.length, 1);
      expect(merged.balanceRows.length, 1);
      expect(merged.revenue, 500000);
      expect(merged.totalAssets, 1000000);
    });

    test('sequential merging accumulates all statements', () {
      var data = const FinancialData(teamId: 'T1', roundNum: 1);

      data = data.mergeWith(const FinancialData(
        teamId: 'T1', roundNum: 1,
        incomeRows: [StatementRow(title: 'Revenue', value: 500000)],
        revenue: 500000,
      ));
      data = data.mergeWith(const FinancialData(
        teamId: 'T1', roundNum: 1,
        balanceRows: [StatementRow(title: 'Assets', value: 1000000)],
        totalAssets: 1000000,
      ));
      data = data.mergeWith(const FinancialData(
        teamId: 'T1', roundNum: 1,
        cashFlowRows: [StatementRow(title: 'Operating CF', value: 150000)],
        operatingCashFlow: 150000,
      ));

      expect(data.incomeRows.length, 1);
      expect(data.balanceRows.length, 1);
      expect(data.cashFlowRows.length, 1);
      expect(data.revenue, 500000);
      expect(data.totalAssets, 1000000);
      expect(data.operatingCashFlow, 150000);
    });
  });

  group('Dashboard ratio analysis', () {
    test('ROE calculation', () {
      const data = FinancialData(
        teamId: 'T1', roundNum: 1,
        netIncome: 45000, totalEquity: 400000, totalAssets: 1000000,
      );
      final equity = data.totalEquity > 0 ? data.totalEquity : data.totalAssets * 0.45;
      final roe = equity > 0 ? (data.netIncome / equity) * 100 : 0.0;
      expect(roe, closeTo(11.25, 0.01));
    });

    test('profit margin calculation', () {
      const data = FinancialData(
        teamId: 'T1', roundNum: 1, netIncome: 50000, revenue: 200000,
      );
      final pm = data.revenue > 0 ? (data.netIncome / data.revenue) * 100 : 0.0;
      expect(pm, closeTo(25.0, 0.01));
    });

    test('asset turnover calculation', () {
      const data = FinancialData(
        teamId: 'T1', roundNum: 1, revenue: 500000, totalAssets: 1000000,
      );
      final at = data.totalAssets > 0 ? data.revenue / data.totalAssets : 0.0;
      expect(at, closeTo(0.5, 0.01));
    });

    test('debt-to-equity calculation', () {
      const data = FinancialData(
        teamId: 'T1', roundNum: 1,
        totalLiabilities: 600000, totalEquity: 400000, totalAssets: 1000000,
      );
      final liab = data.totalLiabilities > 0 ? data.totalLiabilities : data.totalAssets * 0.55;
      final equity = data.totalEquity > 0 ? data.totalEquity : data.totalAssets * 0.45;
      final de = equity > 0 ? liab / equity : 0.0;
      expect(de, closeTo(1.5, 0.01));
    });

    test('ROE fallback when equity is 0', () {
      const data = FinancialData(
        teamId: 'T1', roundNum: 1,
        netIncome: 50000, totalEquity: 0, totalAssets: 1000000,
      );
      // Falls back to 45% of totalAssets
      final equity = data.totalEquity > 0 ? data.totalEquity : data.totalAssets * 0.45;
      final roe = equity > 0 ? (data.netIncome / equity) * 100 : 0.0;
      expect(roe, closeTo(11.11, 0.1));
    });
  });
}
