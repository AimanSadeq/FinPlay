import 'package:flutter_test/flutter_test.dart';
import 'package:finplay/features/achievements/data/badge_models.dart';
import 'package:finplay/features/achievements/data/gamification_session.dart';
import 'package:finplay/features/achievements/data/performance_index_models.dart';

void main() {
  group('GamificationSession.resolve (website achievements.tsx rule)', () {
    test('self-paced token and no team → self-paced, bearer is the session token', () {
      final s = GamificationSession.resolve(selfPacedToken: 'sp');
      expect(s.mode, GamificationMode.selfPaced);
      expect(s.bearer, 'sp');
    });

    test('a stored teamId wins over a self-paced token → corporate with team-member bearer', () {
      final s = GamificationSession.resolve(teamId: 'Team 2', teamMemberToken: 'tm', selfPacedToken: 'sp');
      expect(s.mode, GamificationMode.corporate);
      expect(s.teamId, 'Team 2');
      expect(s.bearer, 'tm');
    });

    test('corporate without a minted token has no bearer (certificate panel hides)', () {
      final s = GamificationSession.resolve(teamId: 'Team 1');
      expect(s.isCorporate, isTrue);
      expect(s.bearer, isNull);
    });

    test('nothing stored (or blanks) → none', () {
      expect(GamificationSession.resolve().mode, GamificationMode.none);
      expect(GamificationSession.resolve(teamId: ' ', selfPacedToken: '').mode, GamificationMode.none);
    });
  });

  group('badges', () {
    final earnedBody = {
      'success': true,
      'data': {
        'teamId': 'Team 1',
        'badges': [
          {'id': 'profit-pioneer', 'name': 'Profit Pioneer', 'nameAr': 'رائد الربحية', 'description': 'd', 'icon': '🚀', 'roundNum': 2, 'earnedAt': '2026-08-01T10:00:00Z', 'metadata': {'value': 5}},
          {'id': 'profit-pioneer', 'name': 'Profit Pioneer', 'nameAr': 'رائد الربحية', 'description': 'd', 'icon': '🚀', 'roundNum': 1, 'earnedAt': '2026-07-01T10:00:00Z'},
          {'id': 'steady-hand', 'name': 'Steady Hand', 'nameAr': 'اليد الثابتة', 'description': 'd2', 'icon': '🎯', 'roundNum': 1, 'earnedAt': '2026-07-01T10:00:00Z'},
        ],
      },
    };

    test('parses earned rows and de-duplicates to the earliest round', () {
      final earned = parseEarned(earnedBody);
      expect(earned, hasLength(3));
      final unique = uniqueEarliest(earned);
      expect(unique.map((b) => b.id), ['profit-pioneer', 'steady-hand']);
      expect(unique.first.roundNum, 1);
      expect(earnedRoundFor(earned, 'profit-pioneer'), 1);
      expect(earnedRoundFor(earned, 'leverage-tamer'), isNull);
    });

    test('catalog uses server nameAr and the app Arabic description fallback', () {
      final cat = parseCatalog({
        'success': true,
        'data': {
          'badges': [
            {'id': 'liquidity-guardian', 'name': 'Liquidity Guardian', 'nameAr': 'حارس السيولة', 'description': 'Kept the Current Ratio…', 'icon': '🛡️'},
          ],
        },
      });
      expect(cat.single.localizedName(true), 'حارس السيولة');
      expect(cat.single.localizedDescription(true), kBadgeDescriptionsAr['liquidity-guardian']);
      expect(cat.single.localizedDescription(false), 'Kept the Current Ratio…');
    });

    test('every catalog id the server ships has an Arabic description', () {
      const serverIds = [
        'liquidity-guardian', 'leverage-tamer', 'profit-pioneer', 'balanced-books', 'growth-investor',
        'cost-surgeon', 'capital-raiser', 'comeback-kid', 'steady-hand',
      ];
      for (final id in serverIds) {
        expect(kBadgeDescriptionsAr[id], isNotNull, reason: id);
      }
    });

    test('malformed bodies parse to empty lists', () {
      expect(parseEarned(null), isEmpty);
      expect(parseCatalog({'success': false}), isEmpty);
      expect(parsePodium({'data': {'dimensions': 'x'}}), isEmpty);
    });

    test('podium parses winner/runners-up and formats like the website', () {
      final dims = parsePodium({
        'success': true,
        'data': {
          'round': 2,
          'dimensions': [
            {'dimension': 'profitability', 'label': 'Profitability', 'description': 'x', 'winner': {'teamId': 'Team 3', 'value': 1250000}, 'value': 1250000, 'runnersUp': [{'teamId': 'Team 1', 'value': -4200}]},
            {'dimension': 'resilience', 'label': 'Resilience', 'description': 'y', 'winner': null, 'value': null, 'runnersUp': []},
          ],
        },
      });
      expect(dims, hasLength(2));
      expect(dims.first.winner!.teamId, 'Team 3');
      expect(dims.first.formatValue(dims.first.winner!.value), r'$1.3M');
      expect(dims.first.formatValue(dims.first.runnersUp.single.value), r'-$4.2K');
      expect(dims[1].winner, isNull);
      expect(dims[1].formatValue(1.234), '1.23');
      expect(dims[1].localizedLabel(true), 'المرونة');
    });

    test('evaluation summary parses newlyEarned', () {
      final e = BadgeEvaluation.fromResponse({
        'success': true,
        'data': {'round': 2, 'throttled': true, 'newlyEarned': [{'teamId': 'Team 1', 'badgeId': 'comeback-kid', 'roundNum': 2}]},
      });
      expect(e.round, 2);
      expect(e.throttled, isTrue);
      expect(e.newlyEarned.single.badgeId, 'comeback-kid');
    });
  });

  group('Performance Index leaderboard (/leaderboard/live)', () {
    final body = {
      'leaderboard': [
        {
          'teamId': 'Team 4', 'teamName': 'Dubai (Team 4)', 'displayName': 'Dubai', 'score': 0, 'hasPlayed': false,
          'metrics': {'netIncome': 0, 'revenue': 0, 'totalAssets': 0, 'totalEquity': 0, 'roe': 0, 'assetTurnover': 0},
          'cashFlow': {'isCashRich': false}, 'index': null, 'round': 1, 'scoredRound': 0, 'rank': 2, 'rankChange': 0,
        },
        {
          'teamId': 'Team 1', 'teamName': 'Riyadh (Team 1)', 'displayName': 'Riyadh', 'score': 63.5, 'hasPlayed': true,
          'metrics': {'netIncome': 120000, 'revenue': 900000, 'roe': 12.3},
          'cashFlow': {'isCashRich': true},
          'index': {
            'score': 63.5, 'uncapped': 63.5,
            'pillars': [
              {'key': 'profitability', 'label': {'en': 'Profitability', 'ar': 'الربحية'}, 'points': 18, 'max': 30, 'metrics': [
                {'key': 'roe', 'label': {'en': 'Return on equity', 'ar': 'العائد على حقوق الملكية'}, 'value': 0.123, 'display': '12.3%', 'points': 9, 'max': 15, 'note': {'en': 'Equity is negative', 'ar': 'حقوق الملكية سالبة'}},
              ]},
            ],
            'flags': {'distress': false, 'idleCash': false, 'negativeEquity': false, 'goingConcern': true},
          },
          'round': 2, 'scoredRound': 1, 'rank': 1, 'rankChange': 2,
        },
      ],
      'round': 2,
      'lastUpdated': '2026-10-05T10:00:00.000Z',
      'totalTeams': 2,
    };

    test('parses index, pillars, flags, scoredRound and hasPlayed; sorts by score', () {
      final lb = IndexLeaderboard.fromJson(body);
      expect(lb.round, 2);
      expect(lb.totalTeams, 2);
      final top = lb.rows.first;
      expect(top.teamId, 'Team 1');
      expect(top.hasPlayed, isTrue);
      expect(top.scoredRound, 1);
      expect(top.rankChange, 2);
      expect(top.isCashRich, isTrue);
      expect(top.index!.pillars.single.label.of(true), 'الربحية');
      expect(top.index!.pillars.single.fraction, closeTo(0.6, 1e-9));
      expect(top.index!.pillars.single.metrics.single.note!.of(false), 'Equity is negative');
      expect(top.index!.flags.goingConcern, isTrue);

      final idle = lb.rows.last;
      expect(idle.hasPlayed, isFalse);
      expect(idle.index, isNull);
      expect(idle.scoredRound, 0);
    });

    test('hasPlayed falls back to presence of an index on older servers', () {
      final row = IndexLeaderboardRow.fromJson({'teamId': 'Team 2', 'score': 10, 'index': {'score': 10, 'uncapped': 10, 'pillars': [], 'flags': {}}});
      expect(row.hasPlayed, isTrue);
      expect(IndexLeaderboardRow.fromJson({'teamId': 'Team 3', 'score': 0}).hasPlayed, isFalse);
    });

    test('formats scores like JS number printing', () {
      expect(formatIndexScore(63.5), '63.5');
      expect(formatIndexScore(64), '64');
      expect(formatIndexScore(40.04), '40');
    });
  });
}
