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

    test('pushed modules are the in-app content modules, by catalog id', () {
      // Hub order of the eight ported modules. Ids, never card positions:
      // Sector Finance Comparison is id 2 and sits ninth.
      expect(EducationProgressSync.contentModules, [1, 3, 4, 6, 7, 2, 9, 10]);
    });

    test('restored modules cover every scored content module in the catalog', () {
      expect(EducationProgressSync.restoredModules,
          [1, 3, 4, 5, 6, 7, 2, 9, 10, 14, 15, 16, 17, 18]);
    });

    test('max scores match the server table', () {
      // MODULE_MAX_SCORES in server/routes/education-modules.ts.
      expect(EducationProgressSync.moduleMaxScores, {
        1: 225,
        2: 275,
        3: 300,
        4: 325,
        5: 400,
        6: 300,
        7: 275,
        9: 300,
        10: 300,
        14: 300,
        15: 300,
        16: 300,
        17: 300,
        18: 300,
      });
    });

    test('every restored module has a max score', () {
      for (final m in EducationProgressSync.restoredModules) {
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
