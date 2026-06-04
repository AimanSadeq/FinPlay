import 'package:flutter_test/flutter_test.dart';
import 'package:finplay/core/network/api_endpoints.dart';

void main() {
  group('ApiEndpoints', () {
    group('endpoint format', () {
      test('all endpoints start with /', () {
        final endpoints = [
          ApiEndpoints.health,
          ApiEndpoints.teams,
          ApiEndpoints.teamById,
          ApiEndpoints.sessionInit,
          ApiEndpoints.roundState,
          ApiEndpoints.decisions,
          ApiEndpoints.decisionConfirm,
          ApiEndpoints.decisionFinancing,
          ApiEndpoints.decisionInvesting,
          ApiEndpoints.decisionOperating,
          ApiEndpoints.scenarios,
          ApiEndpoints.resultsRound,
          ApiEndpoints.sheetsKpis,
          ApiEndpoints.sheetsLeaderboard,
          ApiEndpoints.sheetsBaseline,
          ApiEndpoints.selfPacedRegister,
          ApiEndpoints.selfPacedLogin,
          ApiEndpoints.selfPacedLogout,
          ApiEndpoints.selfPacedProfile,
          ApiEndpoints.selfPacedProgress,
          ApiEndpoints.govEducationStatus,
          ApiEndpoints.govEducationQuiz,
          ApiEndpoints.govEducationLeaderboard,
          ApiEndpoints.facilitatorAuth,
          ApiEndpoints.facilitatorStartGame,
          ApiEndpoints.facilitatorPauseGame,
          ApiEndpoints.facilitatorResetGame,
          ApiEndpoints.shocksPredefined,
          ApiEndpoints.shocksTrigger,
          ApiEndpoints.shocksActive,
          ApiEndpoints.siteAccessCheck,
          ApiEndpoints.siteAccessVerify,
          ApiEndpoints.timerStatus,
          ApiEndpoints.reportExport,
        ];

        for (final endpoint in endpoints) {
          expect(endpoint.startsWith('/'), true,
              reason: 'Endpoint "$endpoint" must start with /');
        }
      });

      test('no endpoints have trailing slashes', () {
        final endpoints = [
          ApiEndpoints.health,
          ApiEndpoints.teams,
          ApiEndpoints.decisions,
          ApiEndpoints.selfPacedLogin,
          ApiEndpoints.facilitatorAuth,
          ApiEndpoints.shocksActive,
          ApiEndpoints.siteAccessCheck,
        ];

        for (final endpoint in endpoints) {
          expect(endpoint.endsWith('/'), false,
              reason: 'Endpoint "$endpoint" must not end with /');
        }
      });
    });

    group('self-paced endpoints', () {
      test('auth endpoints use correct prefix', () {
        expect(ApiEndpoints.selfPacedRegister, '/self-paced/register');
        expect(ApiEndpoints.selfPacedLogin, '/self-paced/login');
        expect(ApiEndpoints.selfPacedLogout, '/self-paced/logout');
        expect(ApiEndpoints.selfPacedProfile, '/self-paced/profile');
        expect(ApiEndpoints.selfPacedPasswordReset, '/self-paced/password-reset');
      });

      test('progress endpoints use correct prefix', () {
        expect(ApiEndpoints.selfPacedProgress, '/self-paced/progress');
        expect(ApiEndpoints.selfPacedProgressDecisions, '/self-paced/progress/decisions');
        expect(ApiEndpoints.selfPacedCompleteModule, '/self-paced/progress/complete-module');
        expect(ApiEndpoints.selfPacedProgressScenarios, '/self-paced/progress/scenarios');
        expect(ApiEndpoints.selfPacedProgressDecision, '/self-paced/progress/decision');
        expect(ApiEndpoints.selfPacedProgressReset, '/self-paced/progress/reset');
        expect(ApiEndpoints.selfPacedProgressEducation, '/self-paced/progress/education');
        expect(ApiEndpoints.selfPacedProgressEducationComplete, '/self-paced/progress/education/complete');
      });
    });

    group('facilitator endpoints', () {
      test('all facilitator endpoints use correct prefix', () {
        final facilEndpoints = [
          ApiEndpoints.facilitatorLobbyStatus,
          ApiEndpoints.facilitatorAuth,
          ApiEndpoints.facilitatorStartGame,
          ApiEndpoints.facilitatorPauseGame,
          ApiEndpoints.facilitatorContinueGame,
          ApiEndpoints.facilitatorResetGame,
          ApiEndpoints.facilitatorForceRound,
          ApiEndpoints.facilitatorForceModule,
          ApiEndpoints.facilitatorStartTimer,
          ApiEndpoints.facilitatorEndTimer,
          ApiEndpoints.facilitatorAllDecisions,
          ApiEndpoints.facilitatorTeamFreshStart,
        ];

        for (final ep in facilEndpoints) {
          expect(ep.startsWith('/facilitator/'), true,
              reason: 'Facilitator endpoint "$ep" must start with /facilitator/');
        }
      });
    });

    group('decision endpoints', () {
      test('module-specific endpoints exist', () {
        expect(ApiEndpoints.decisionFinancing, '/decision/financing');
        expect(ApiEndpoints.decisionInvesting, '/decision/investing');
        expect(ApiEndpoints.decisionOperating, '/decision/operating');
      });

      test('confirm and validate endpoints exist', () {
        expect(ApiEndpoints.decisionConfirm, '/decisions/confirm');
        expect(ApiEndpoints.decisionValidate, '/decisions/repair');
      });
    });

    group('gov education endpoints', () {
      test('all gov education endpoints use correct prefix', () {
        expect(ApiEndpoints.govEducationStatus, '/gov-education/status');
        expect(ApiEndpoints.govEducationTeams, '/gov-education/teams');
        expect(ApiEndpoints.govEducationProgress, '/gov-education/progress');
        expect(ApiEndpoints.govEducationQuiz, '/gov-education/quiz');
        expect(ApiEndpoints.govEducationLeaderboard, '/gov-education/leaderboard');
      });
    });

    group('no duplicate values', () {
      test('key endpoints are unique', () {
        final endpoints = {
          ApiEndpoints.health,
          ApiEndpoints.teams,
          ApiEndpoints.decisions,
          ApiEndpoints.decisionFinancing,
          ApiEndpoints.decisionInvesting,
          ApiEndpoints.decisionOperating,
          ApiEndpoints.selfPacedLogin,
          ApiEndpoints.selfPacedRegister,
          ApiEndpoints.facilitatorAuth,
          ApiEndpoints.roundState,
          ApiEndpoints.sheetsLeaderboard,
          ApiEndpoints.siteAccessCheck,
        };
        // A Set removes duplicates, so length should stay the same
        expect(endpoints.length, 12);
      });
    });
  });
}
