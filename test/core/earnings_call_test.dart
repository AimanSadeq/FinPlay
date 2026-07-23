import 'package:flutter_test/flutter_test.dart';
import 'package:finplay/core/network/api_endpoints.dart';
import 'package:finplay/data/repositories/earnings_call_repository.dart';

/// Contract tests for the Earnings Call API surface. The server rejects any
/// teamId outside LEGACY_TEAMS and scopes every route under /earnings-call, so
/// these paths and the team list must stay in step with
/// server/routes/earnings-call.ts on the website.
void main() {
  group('EarningsCall endpoints', () {
    test('stage machine endpoints', () {
      expect(ApiEndpoints.earningsCallStatus, '/earnings-call/status');
      expect(ApiEndpoints.earningsCallStage, '/earnings-call/stage');
    });

    test('team payload path is built with an encoded team id', () {
      expect(
        '${ApiEndpoints.earningsCallTeam}/${Uri.encodeComponent('Team 1')}',
        '/earnings-call/team/Team%201',
      );
    });

    test('released questions path is built with an encoded team id', () {
      expect(
        '${ApiEndpoints.earningsCallQuestions}/${Uri.encodeComponent('Team 7')}',
        '/earnings-call/questions/Team%207',
      );
    });

    test('answer + per-question feedback paths', () {
      expect(ApiEndpoints.earningsCallAnswer, '/earnings-call/answer');
      expect(
        '${ApiEndpoints.earningsCallAnswer}/${Uri.encodeComponent('Team 2')}/0/feedback',
        '/earnings-call/answer/Team%202/0/feedback',
      );
    });

    test('generate + release paths', () {
      expect(
        '${ApiEndpoints.earningsCallQuestions}/${Uri.encodeComponent('Team 3')}/generate',
        '/earnings-call/questions/Team%203/generate',
      );
      expect(
        '${ApiEndpoints.earningsCallQuestions}/abc-123/release',
        '/earnings-call/questions/abc-123/release',
      );
    });

    test('peer rating + facilitator rubric endpoints', () {
      expect(ApiEndpoints.earningsCallFeedback, '/earnings-call/feedback');
      expect(ApiEndpoints.earningsCallFeedbackSummary, '/earnings-call/feedback/summary');
      expect(ApiEndpoints.earningsCallFacilitatorScore, '/earnings-call/facilitator-score');
      expect(ApiEndpoints.earningsCallFacilitatorScores, '/earnings-call/facilitator-scores');
    });

    test('participating teams match the server allow-list', () {
      expect(EarningsCallRepository.teams, [
        'Team 1',
        'Team 2',
        'Team 3',
        'Team 4',
        'Team 5',
        'Team 6',
        'Team 7',
      ]);
    });
  });
}
