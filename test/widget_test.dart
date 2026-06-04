import 'package:flutter_test/flutter_test.dart';
import 'package:finplay/data/models/user.dart';
import 'package:finplay/data/models/team.dart';
import 'package:finplay/data/models/game_state.dart';
import 'package:finplay/data/models/decision.dart';
import 'package:finplay/data/models/financial_data.dart';
import 'package:finplay/core/network/api_endpoints.dart';
import 'package:finplay/app/theme/app_colors.dart';

/// Smoke test: verify all critical imports and classes are accessible.
void main() {
  test('All core models can be instantiated', () {
    const user = SelfPacedUser(email: 'test@test.com', displayName: 'Test');
    expect(user.email, 'test@test.com');

    const team = Team(id: 'Team 1', name: 'Alpha');
    expect(team.teamNumber, 1);

    const gs = GameState(currentRound: 1, currentModule: 'financing');
    expect(gs.isModuleLocked, false);

    const decision = Decision(
      teamId: 'Team 1',
      roundNum: 1,
      module: 'financing',
      decisionData: {},
    );
    expect(decision.module, 'financing');

    const fd = FinancialData(teamId: 'Team 1', roundNum: 1);
    expect(fd.revenue, 0);
  });

  test('API endpoints are properly defined', () {
    expect(ApiEndpoints.health, '/health');
    expect(ApiEndpoints.selfPacedLogin, startsWith('/self-paced'));
    expect(ApiEndpoints.facilitatorAuth, startsWith('/facilitator'));
  });

  test('AppColors are accessible', () {
    expect(AppColors.primary, isNotNull);
    expect(AppColors.purple, isNotNull);
    expect(AppColors.teamColor(0), AppColors.team1);
  });
}
