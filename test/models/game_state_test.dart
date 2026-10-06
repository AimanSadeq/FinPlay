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
        expect(gs.gameMode, 'facilitator');
        expect(gs.corporateModeEnabled, false);
        expect(gs.corporateAccessCode, isNull);
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
          'educationRetryUnlocked': true,
          'siteAccessEnabled': true,
          'gameMode': 'self-paced',
          'corporateModeEnabled': true,
          'corporateAccessCode': 'X7K2M9',
        };

        final gs = GameState.fromJson(json);

        expect(gs.nextDecisionsUnlocked, true);
        expect(gs.breakEvenUnlocked, true);
        expect(gs.capitalBudgetingUnlocked, true);
        expect(gs.educationRetryUnlocked, true);
        expect(gs.siteAccessEnabled, true);
        expect(gs.gameMode, 'self-paced');
        expect(gs.corporateModeEnabled, true);
        expect(gs.corporateAccessCode, 'X7K2M9');
      });
    });

    group('fromJson - GET /facilitator/status gameState', () {
      // Copied from a sandbox response of GET /api/facilitator/status with the
      // x-facilitator-password header (server/routes/facilitator.ts). This is
      // the payload the facilitator console reads; /sheets/round/state lacks
      // isActive, the education gates and the corporate fields.
      const fixture = {
        'success': true,
        'gameState': {
          'currentRound': 3,
          'currentModule': 'operating',
          'isActive': true,
          'timeRemaining': 0,
          'lockFinancing': true,
          'lockInvesting': true,
          'lockOperating': true,
          'nextDecisionsUnlocked': false,
          'capitalBudgetingResultsUnlocked': <dynamic>[],
          'educationUnlocked': true,
          'educationModulesUnlocked': <dynamic>[],
          'preAssessmentMandated': false,
          'postAssessmentMandated': false,
          'qrPlaceholders': {
            'infoSheet': {'url': '', 'label': ''},
            'courseSurvey': {'url': '', 'label': ''},
            'preAssessment': {'url': '', 'label': ''},
            'postAssessment': {'url': '', 'label': ''},
            'companyLinkedin': {'url': '', 'label': ''},
            'consultantLinkedin': {'url': '', 'label': ''},
          },
          'activeQrPlaceholder': 'NONE',
          'activeCaseStudyId': null,
          'gameMode': 'facilitator',
          'corporateModeEnabled': true,
          'corporateAccessCode': 'Q7GTZU',
          'workingCapitalEnabled': false,
          'duPontEnabled': false,
          'waccEnabled': false,
          'creditRatingEnabled': false,
          'debtCovenantsEnabled': false,
          'capTableEnabled': false,
          'dividendPolicyEnabled': false,
        },
      };

      test('parses the facilitator fields the console renders', () {
        final gs = GameState.fromJson(
            Map<String, dynamic>.from(fixture['gameState'] as Map));

        expect(gs.currentRound, 3);
        expect(gs.currentModule, 'operating');
        expect(gs.isActive, true);
        expect(gs.timeRemaining, 0);
        expect(gs.lockFinancing, true);
        expect(gs.lockInvesting, true);
        expect(gs.lockOperating, true);
        expect(gs.nextDecisionsUnlocked, false);
        expect(gs.educationUnlocked, true);
        expect(gs.educationModulesUnlocked, isEmpty);
        expect(gs.educationRetryUnlocked, false);
        expect(gs.preAssessmentMandated, false);
        expect(gs.postAssessmentMandated, false);
        expect(gs.activeQrPlaceholder, 'NONE');
        expect(gs.activeCaseStudyId, isNull);
        expect(gs.gameMode, 'facilitator');
        expect(gs.corporateModeEnabled, true);
        expect(gs.corporateAccessCode, 'Q7GTZU');
      });

      test('parses per-module education unlocks and a paused game', () {
        final json = Map<String, dynamic>.from(fixture['gameState'] as Map)
          ..['isActive'] = false
          ..['educationModulesUnlocked'] = [1, 3, 9]
          ..['educationRetryUnlocked'] = true;

        final gs = GameState.fromJson(json);

        expect(gs.isActive, false);
        expect(gs.educationModulesUnlocked, [1, 3, 9]);
        expect(gs.educationRetryUnlocked, true);
      });

      test('corporate mode off clears the access code', () {
        final json = Map<String, dynamic>.from(fixture['gameState'] as Map)
          ..['corporateModeEnabled'] = false
          ..['corporateAccessCode'] = null;

        final gs = GameState.fromJson(json);

        expect(gs.corporateModeEnabled, false);
        expect(gs.corporateAccessCode, isNull);
      });
    });

    group('fromJson - base (partial payload merge)', () {
      test('a round-state payload keeps the facilitator fields of the base', () {
        final base = GameState.fromJson(const {
          'currentRound': 1,
          'currentModule': 'financing',
          'isActive': true,
          'educationUnlocked': true,
          'educationModulesUnlocked': [1, 2],
          'corporateModeEnabled': true,
          'corporateAccessCode': 'Q7GTZU',
        });
        final roundState = {
          'roundNum': 2,
          'module': 'investing',
          'timeRemaining': 0,
          'timerActive': false,
          'locks': {'financing': true, 'investing': false, 'operating': false},
          'nextDecisionsUnlocked': true,
          'excelMode': false,
        };

        final gs = GameState.fromJson(roundState, base: base);

        expect(gs.currentRound, 2);
        expect(gs.currentModule, 'investing');
        expect(gs.lockFinancing, true);
        expect(gs.nextDecisionsUnlocked, true);
        expect(gs.isActive, true);
        expect(gs.educationUnlocked, true);
        expect(gs.educationModulesUnlocked, [1, 2]);
        expect(gs.corporateModeEnabled, true);
        expect(gs.corporateAccessCode, 'Q7GTZU');
      });

      test('an explicit null access code overrides the base', () {
        const base = GameState(corporateModeEnabled: true, corporateAccessCode: 'ABC123');
        final gs = GameState.fromJson(
            {'corporateModeEnabled': false, 'corporateAccessCode': null}, base: base);
        expect(gs.corporateModeEnabled, false);
        expect(gs.corporateAccessCode, isNull);
      });

      test('without base the defaults are unchanged', () {
        final gs = GameState.fromJson({'roundNum': 1});
        expect(gs.isActive, true);
        expect(gs.corporateModeEnabled, false);
        expect(gs.educationUnlocked, false);
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
