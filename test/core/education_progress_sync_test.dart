import 'package:flutter_test/flutter_test.dart';
import 'package:finplay/core/network/api_endpoints.dart';
import 'package:finplay/core/services/education_progress_sync.dart';

/// Contract tests for the cross-device education progress sync. The score table
/// and module list here MUST stay in step with MODULE_MAX_SCORES in the website's
/// server/routes/education-modules.ts — the server clamps to those numbers and
/// both clients derive their completion % from them.
void main() {
  group('EducationProgressSync contract', () {
    test('saved/sync endpoints carry the teamName placeholder', () {
      expect(ApiEndpoints.educationProgressSaved,
          '/education/progress/{teamName}/saved');
      expect(ApiEndpoints.educationProgressSync,
          '/education/progress/{teamName}/sync');
    });

    test('a self-paced email is URL-encoded into the path', () {
      final path = ApiEndpoints.educationProgressSaved
          .replaceFirst('{teamName}', Uri.encodeComponent('a.b+c@example.com'));
      expect(path, '/education/progress/a.b%2Bc%40example.com/saved');
    });

    test('a corporate team name is URL-encoded into the path', () {
      final path = ApiEndpoints.educationProgressSync
          .replaceFirst('{teamName}', Uri.encodeComponent('Team 1'));
      expect(path, '/education/progress/Team%201/sync');
    });

    test('content modules match the website lineup (5 and 8 excluded)', () {
      expect(EducationProgressSync.contentModules, [1, 2, 3, 4, 6, 7, 9, 10]);
    });

    test('max scores match the server table', () {
      expect(EducationProgressSync.moduleMaxScores, {
        1: 225,
        2: 400,
        3: 375,
        4: 375,
        6: 400,
        7: 375,
        9: 400,
        10: 400,
      });
    });

    test('every content module has a max score', () {
      for (final m in EducationProgressSync.contentModules) {
        expect(EducationProgressSync.moduleMaxScores[m], isNotNull,
            reason: 'module $m has no max score');
      }
    });

    test('pass threshold matches the server (70%)', () {
      expect(EducationProgressSync.passThreshold, 0.7);
    });

    test('tracked activities match the module screen tabs', () {
      expect(EducationProgressSync.activities, ['learn', 'game', 'quiz', 'sim']);
    });
  });
}
