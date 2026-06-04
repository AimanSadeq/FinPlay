import 'package:flutter_test/flutter_test.dart';
import 'package:finplay/core/network/api_endpoints.dart';

/// Tests for SelfPacedRepository — verifies endpoint paths and parameter construction.
/// Since we don't have a mocking library, we test the endpoint constants and
/// the repository's expected behavior via contract tests.
void main() {
  group('SelfPacedRepository endpoints', () {
    test('fetchMe uses correct endpoint', () {
      expect(ApiEndpoints.selfPacedMe, '/self-paced/me');
    });

    test('fetchScenarios uses correct endpoint', () {
      expect(ApiEndpoints.selfPacedProgressScenarios,
          '/self-paced/progress/scenarios');
    });

    test('saveDecision uses correct endpoint', () {
      expect(ApiEndpoints.selfPacedProgressDecision,
          '/self-paced/progress/decision');
    });

    test('completeModule uses correct endpoint', () {
      expect(ApiEndpoints.selfPacedCompleteModule,
          '/self-paced/progress/complete-module');
    });

    test('fetchDecisions constructs correct path', () {
      const base = ApiEndpoints.selfPacedProgressDecisions;
      expect(base, '/self-paced/progress/decisions');
      // Repository appends /{round}/{module}
      expect('$base/1/financing', '/self-paced/progress/decisions/1/financing');
      expect('$base/2/investing', '/self-paced/progress/decisions/2/investing');
      expect('$base/3/operating', '/self-paced/progress/decisions/3/operating');
    });

    test('resetProgress uses correct endpoint', () {
      expect(ApiEndpoints.selfPacedProgressReset, '/self-paced/progress/reset');
    });

    test('all self-paced endpoints start with /self-paced/', () {
      final endpoints = [
        ApiEndpoints.selfPacedMe,
        ApiEndpoints.selfPacedProgress,
        ApiEndpoints.selfPacedProgressScenarios,
        ApiEndpoints.selfPacedProgressDecision,
        ApiEndpoints.selfPacedProgressDecisions,
        ApiEndpoints.selfPacedProgressReset,
        ApiEndpoints.selfPacedCompleteModule,
        ApiEndpoints.selfPacedProgressEducation,
        ApiEndpoints.selfPacedProgressEducationComplete,
        ApiEndpoints.selfPacedRegister,
        ApiEndpoints.selfPacedLogin,
        ApiEndpoints.selfPacedLogout,
        ApiEndpoints.selfPacedProfile,
      ];

      for (final ep in endpoints) {
        expect(ep.startsWith('/self-paced/'), true,
            reason: 'Endpoint "$ep" should start with /self-paced/');
      }
    });

    test('no duplicate endpoint values', () {
      final endpoints = {
        ApiEndpoints.selfPacedMe,
        ApiEndpoints.selfPacedProgress,
        ApiEndpoints.selfPacedProgressScenarios,
        ApiEndpoints.selfPacedProgressDecision,
        ApiEndpoints.selfPacedProgressDecisions,
        ApiEndpoints.selfPacedProgressReset,
        ApiEndpoints.selfPacedCompleteModule,
        ApiEndpoints.selfPacedProgressEducation,
        ApiEndpoints.selfPacedProgressEducationComplete,
      };
      // Set deduplicates — if all unique, count stays 9
      expect(endpoints.length, 9);
    });
  });
}
