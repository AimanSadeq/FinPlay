import 'package:flutter_test/flutter_test.dart';
import 'package:finplay/data/models/game_state.dart';

void main() {
  group('GameState', () {
    group('fromJson - nested locks format', () {
      test('parses round state with nested locks', () {
        final json = {
          'roundNum': 2,
          'module': 'investing',
          'isActive': true,
          'timeRemaining': 300,
          'locks': {
            'financing': true,
            'investing': false,
            'operating': false,
          },
        };

        final gs = GameState.fromJson(json);

        expect(gs.currentRound, 2);
        expect(gs.currentModule, 'investing');
        expect(gs.isActive, true);
        expect(gs.timeRemaining, 300);
        expect(gs.lockFinancing, true);
        expect(gs.lockInvesting, false);
        expect(gs.lockOperating, false);
      });
    });

    group('fromJson - flat format', () {
      test('parses flat format correctly', () {
        final json = {
          'currentRound': 3,
          'currentModule': 'operating',
          'lockFinancing': true,
          'lockInvesting': true,
          'lockOperating': false,
        };

        final gs = GameState.fromJson(json);

        expect(gs.currentRound, 3);
        expect(gs.currentModule, 'operating');
        expect(gs.lockFinancing, true);
        expect(gs.lockInvesting, true);
        expect(gs.lockOperating, false);
      });
    });

    group('fromJson - defaults', () {
      test('applies defaults for empty JSON', () {
        final gs = GameState.fromJson({});

        expect(gs.currentRound, 1);
        expect(gs.currentModule, 'financing');
        expect(gs.isActive, true);
        expect(gs.timeRemaining, isNull);
        expect(gs.lockFinancing, false);
        expect(gs.lockInvesting, false);
        expect(gs.lockOperating, false);
        expect(gs.nextDecisionsUnlocked, false);
        expect(gs.breakEvenUnlocked, false);
        expect(gs.capitalBudgetingUnlocked, false);
        expect(gs.govEducationUnlocked, false);
        expect(gs.govEducationModulesUnlocked, isEmpty);
        expect(gs.gameMode, 'facilitator');
        expect(gs.corporateModeEnabled, false);
      });
    });

    group('fromJson - feature flags', () {
      test('parses all feature flags', () {
        final json = {
          'roundNum': 1,
          'module': 'financing',
          'nextDecisionsUnlocked': true,
          'breakEvenUnlocked': true,
          'capitalBudgetingUnlocked': true,
          'govEducationUnlocked': true,
          'govEducationModulesUnlocked': [1, 2, 3, 5],
          'educationRetryUnlocked': true,
          'siteAccessEnabled': true,
          'gameMode': 'self-paced',
          'corporateModeEnabled': true,
        };

        final gs = GameState.fromJson(json);

        expect(gs.nextDecisionsUnlocked, true);
        expect(gs.breakEvenUnlocked, true);
        expect(gs.capitalBudgetingUnlocked, true);
        expect(gs.govEducationUnlocked, true);
        expect(gs.govEducationModulesUnlocked, [1, 2, 3, 5]);
        expect(gs.educationRetryUnlocked, true);
        expect(gs.siteAccessEnabled, true);
        expect(gs.gameMode, 'self-paced');
        expect(gs.corporateModeEnabled, true);
      });
    });

    group('isModuleLocked', () {
      test('returns lockFinancing when module is financing', () {
        const gs = GameState(
          currentModule: 'financing',
          lockFinancing: true,
          lockInvesting: false,
          lockOperating: false,
        );
        expect(gs.isModuleLocked, true);
      });

      test('returns lockInvesting when module is investing', () {
        const gs = GameState(
          currentModule: 'investing',
          lockFinancing: false,
          lockInvesting: true,
          lockOperating: false,
        );
        expect(gs.isModuleLocked, true);
      });

      test('returns lockOperating when module is operating', () {
        const gs = GameState(
          currentModule: 'operating',
          lockFinancing: false,
          lockInvesting: false,
          lockOperating: true,
        );
        expect(gs.isModuleLocked, true);
      });

      test('returns false when module is not locked', () {
        const gs = GameState(
          currentModule: 'financing',
          lockFinancing: false,
        );
        expect(gs.isModuleLocked, false);
      });

      test('returns false for unknown module', () {
        const gs = GameState(
          currentModule: 'unknown',
          lockFinancing: true,
          lockInvesting: true,
          lockOperating: true,
        );
        expect(gs.isModuleLocked, false);
      });
    });

    group('toJson', () {
      test('serializes core fields', () {
        const gs = GameState(
          currentRound: 2,
          currentModule: 'investing',
          isActive: true,
          timeRemaining: 120,
          lockFinancing: true,
          lockInvesting: false,
          lockOperating: false,
        );

        final json = gs.toJson();

        expect(json['currentRound'], 2);
        expect(json['currentModule'], 'investing');
        expect(json['isActive'], true);
        expect(json['timeRemaining'], 120);
        expect(json['lockFinancing'], true);
        expect(json['lockInvesting'], false);
        expect(json['lockOperating'], false);
      });
    });

    group('constructor defaults', () {
      test('uses sensible defaults', () {
        const gs = GameState();

        expect(gs.currentRound, 1);
        expect(gs.currentModule, 'financing');
        expect(gs.isActive, false);
        expect(gs.lockFinancing, false);
        expect(gs.lockInvesting, false);
        expect(gs.lockOperating, false);
      });
    });
  });
}
