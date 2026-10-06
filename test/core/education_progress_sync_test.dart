import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finplay/core/network/api_client.dart';
import 'package:finplay/core/network/api_endpoints.dart';
import 'package:finplay/core/services/education_progress_sync.dart';
import 'package:finplay/core/services/education_storage_migration.dart';

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

  group('EducationProgressSync with provisional (remapped) ids', () {
    late _FakeServer server;
    late EducationProgressSync sync;

    setUp(() {
      server = _FakeServer();
      ApiClient().dio.httpClientAdapter = server;
      sync = EducationProgressSync(ApiClient());
    });

    test('provisional ids are never pushed, even when local is ahead', () async {
      SharedPreferences.setMockInitialValues({
        'edu_progress_1': 50, // genuine in-app work: pushed
        'edu_progress_4': 100, // remapped from a synced id 3 record: held back
        'edu_module_1_4_quiz': true,
        EducationStorageMigration.provisionalKey: ['4'],
      });
      server.saved = {}; // server has nothing yet

      await sync.sync(teamName: 'Team 1', scope: '1');

      expect(server.pushed, isNotNull);
      final modules = server.pushed!['modules'] as Map;
      expect(modules.keys, ['module1']);
      expect(modules.containsKey('module4'), isFalse);
      // Still provisional: the server had no record to confirm or correct it.
      final prefs = await SharedPreferences.getInstance();
      expect(await EducationStorageMigration.provisionalIds(prefs), {4});
      expect(prefs.getInt('edu_progress_4'), 100); // local left as is
    });

    test('a server record for a provisional id overwrites local and clears the flag',
        () async {
      SharedPreferences.setMockInitialValues({
        'edu_progress_4': 100, // phantom completion from the remap
        'edu_passed_4': true,
        'edu_module_1_4_quiz': true,
        'edu_module_1_4_learn': true,
        EducationStorageMigration.provisionalKey: ['3', '4'],
      });
      // Analysis of Financial Statements (id 4, max 325) is really at 65 = 20%.
      server.saved = {
        'module4': {'moduleScore': 65, 'completed': false, 'activityData': {}},
      };

      await sync.sync(teamName: 'Team 1', scope: '1');

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('edu_progress_4'), 20);
      expect(prefs.getBool('edu_passed_4'), isFalse);
      expect(prefs.getBool('edu_module_1_4_quiz'), isFalse);
      expect(prefs.getBool('edu_module_1_4_learn'), isFalse);
      // id 4 confirmed by the server; id 3 had no record and stays provisional.
      expect(await EducationStorageMigration.provisionalIds(prefs), {3});
      // Nothing was ahead of the server afterwards, so nothing was pushed.
      expect(server.pushed, isNull);
    });

    test('a non-provisional id keeps the normal rule: local wins when ahead',
        () async {
      SharedPreferences.setMockInitialValues({
        'edu_progress_4': 100,
        'edu_passed_4': true,
      });
      server.saved = {
        'module4': {'moduleScore': 65, 'completed': false, 'activityData': {}},
      };

      await sync.sync(teamName: 'Team 1', scope: '1');

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('edu_progress_4'), 100);
      final modules = server.pushed!['modules'] as Map;
      expect(modules.containsKey('module4'), isTrue);
    });

    test('an in-app write clears the flag so the module is pushed again', () async {
      SharedPreferences.setMockInitialValues({
        'edu_progress_4': 100,
        EducationStorageMigration.provisionalKey: ['4'],
      });
      final prefs = await SharedPreferences.getInstance();
      // EducationModuleScreen._syncHubProgress calls this on every completion
      // or score write for the module the learner is working on.
      await EducationStorageMigration.clearProvisional(prefs, 4);
      server.saved = {};

      await sync.sync(teamName: 'Team 1', scope: '1');

      final modules = server.pushed!['modules'] as Map;
      expect(modules.containsKey('module4'), isTrue);
    });
  });
}

/// Stands in for the website server behind ApiClient's Dio: answers the saved
/// GET with [saved] and records the body of the sync POST in [pushed].
class _FakeServer implements HttpClientAdapter {
  Map<String, dynamic>? saved;
  Map<String, dynamic>? pushed;

  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    final path = options.path;
    if (options.method == 'GET' && path.endsWith('/saved')) {
      return _json({
        'success': true,
        'data': {'modules': saved ?? {}},
      });
    }
    if (options.method == 'POST' && path.endsWith('/sync')) {
      final data = options.data;
      pushed = data is String
          ? Map<String, dynamic>.from(jsonDecode(data) as Map)
          : Map<String, dynamic>.from(data as Map);
      return _json({'success': true});
    }
    return ResponseBody.fromString(
      jsonEncode({'success': false, 'error': 'API route not found'}),
      404,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  ResponseBody _json(Map<String, dynamic> body) => ResponseBody.fromString(
        jsonEncode(body),
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );

  @override
  void close({bool force = false}) {}
}
