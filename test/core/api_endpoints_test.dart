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
          ApiEndpoints.sheetsLeaderboard,
          ApiEndpoints.selfPacedRegister,
          ApiEndpoints.selfPacedLogin,
          ApiEndpoints.selfPacedLogout,
          ApiEndpoints.selfPacedMe,
          ApiEndpoints.educationStatus,
          ApiEndpoints.facilitatorAuth,
          ApiEndpoints.facilitatorVerifyCorporateCode,
          ApiEndpoints.facilitatorStartGame,
          ApiEndpoints.facilitatorPauseGame,
          ApiEndpoints.facilitatorResetGame,
          ApiEndpoints.shocksPredefined,
          ApiEndpoints.shocksTrigger,
          ApiEndpoints.shocksActive,
          ApiEndpoints.teamProgressionAdvance,
          ApiEndpoints.facilitatorTeamOverview,
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
          ApiEndpoints.teamProgressionAdvance,
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
        expect(ApiEndpoints.selfPacedMe, '/self-paced/me');
        expect(ApiEndpoints.selfPacedForgotPassword, '/self-paced/forgot-password');
        expect(ApiEndpoints.selfPacedResetPassword, '/self-paced/reset-password');
      });

      test('progress endpoints use correct prefix', () {
        expect(ApiEndpoints.selfPacedProgressDecisions, '/self-paced/progress/decisions');
        expect(ApiEndpoints.selfPacedCompleteModule, '/self-paced/progress/complete-module');
        expect(ApiEndpoints.selfPacedProgressScenarios, '/self-paced/progress/scenarios');
        expect(ApiEndpoints.selfPacedProgressDecision, '/self-paced/progress/decision');
        expect(ApiEndpoints.selfPacedProgressReset, '/self-paced/progress/reset');
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
          ApiEndpoints.facilitatorTeamOverview,
          ApiEndpoints.facilitatorToggleCorporateMode,
          ApiEndpoints.facilitatorSimulationAccess,
          ApiEndpoints.facilitatorTimerOverlayStart,
          ApiEndpoints.facilitatorTimerOverlayStop,
          ApiEndpoints.facilitatorUnlockAllScenarioResults,
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

      test('confirm endpoint exists', () {
        expect(ApiEndpoints.decisionConfirm, '/decisions/confirm');
      });
    });

    group('routes the website server actually serves', () {
      // Paths from server/routes/*.ts in the website repository. Each of these
      // replaced a dead path the app used to call (Deep Audit 3, mobile-contract).
      test('simulation and facilitator routes', () {
        expect(ApiEndpoints.teamProgressionAdvance, '/team-progression/advance');
        expect(ApiEndpoints.facilitatorTeamOverview, '/facilitator/team-overview');
        expect(ApiEndpoints.facilitatorToggleCorporateMode, '/facilitator/toggle-corporate-mode');
        expect(ApiEndpoints.facilitatorStartGame, '/facilitator/start-game');
        expect(ApiEndpoints.facilitatorPauseGame, '/facilitator/pause-game');
        expect(ApiEndpoints.facilitatorContinueGame, '/facilitator/continue-game');
        expect(ApiEndpoints.facilitatorResetGame, '/facilitator/reset-game');
        expect(ApiEndpoints.facilitatorTimerOverlayStart, '/facilitator/timer-overlay/start');
        expect(ApiEndpoints.facilitatorTimerOverlayStop, '/facilitator/timer-overlay/stop');
        expect(ApiEndpoints.facilitatorUnlockAllScenarioResults,
            '/facilitator/unlock-all-scenario-results');
        expect(ApiEndpoints.facilitatorSimulationAccess, '/facilitator/simulation-access');
        expect(ApiEndpoints.educationAdminReset, '/education/admin/reset-all');
        expect(ApiEndpoints.shocksClearAll, '/shocks/clear-all');
        expect(ApiEndpoints.healthConnection, '/health/connection');
        expect(ApiEndpoints.scenarioTooltip, '/scenarios/tooltip');
      });

      test('financial statements come from the results route the website reads', () {
        // server/routes.ts registers /api/game/results/round; the website's
        // BaselineFinancialStatements reads it at round 0. The old
        // /excel/baseline-financials path is not served.
        expect(ApiEndpoints.resultsRound, '/game/results/round');
      });
    });

    group('education endpoints', () {
      test('education endpoints use correct prefix', () {
        expect(ApiEndpoints.educationStatus, '/education/status');
        expect(ApiEndpoints.educationModulesStatus, '/education-modules/status');
        expect(ApiEndpoints.educationProgressSaved,
            '/education/progress/{teamName}/saved');
        expect(ApiEndpoints.educationProgressSync,
            '/education/progress/{teamName}/sync');
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
          ApiEndpoints.facilitatorTeamOverview,
        };
        // A Set removes duplicates, so length should stay the same
        expect(endpoints.length, 12);
      });
    });
  });
}
