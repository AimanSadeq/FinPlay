import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
<<<<<<< Updated upstream
import 'package:finplay/core/network/api_client.dart';
import 'package:finplay/core/network/api_endpoints.dart';
import 'package:finplay/core/services/education_progress_sync.dart';
import 'package:finplay/core/services/education_storage_migration.dart';
=======
import 'package:finplay/core/network/api_endpoints.dart';
import 'package:finplay/core/services/education_progress_sync.dart';
import 'package:finplay/features/education/modules/education_module_data.dart';
>>>>>>> Stashed changes

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
          [1, 3, 4, 5, 6, 7, 2, 9, 10, 14, 15, 16, 17, 18, 19, 20, 21, 22]);
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
        19: 300,
        20: 300,
        21: 300,
        22: 300,
      });
    });

    test('every restored module has a max score', () {
      for (final m in EducationProgressSync.restoredModules) {
        expect(EducationProgressSync.maxScoreFor(m), greaterThan(0),
            reason: 'module $m has no max score');
      }
    });

    test('a module the server table lacks uses the server default (325)', () {
      // moduleMaxScore() in server/services/educationProgressMerge.ts.
      expect(EducationProgressSync.defaultModuleMaxScore, 325);
      expect(EducationProgressSync.moduleMaxScores.containsKey(99), isFalse);
      expect(EducationProgressSync.maxScoreFor(99), 325);
      expect(EducationProgressSync.maxScoreFor(5), 400);
      // The library modules carry the Financial Risk Assessment set: 300.
      for (final m in [19, 20, 21, 22]) {
        expect(EducationProgressSync.maxScoreFor(m), 300);
      }
    });

    test('pass threshold matches the server (70%)', () {
      expect(EducationProgressSync.passThreshold, 0.7);
    });

    test('tracked activities match the module screen tabs', () {
      expect(EducationProgressSync.activities, ['learn', 'game', 'quiz', 'sim']);
    });
  });

<<<<<<< Updated upstream
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
=======
  group('push payload', () {
    ModuleActivity act(int module, String id) =>
        educationModuleContents[module]!.activities.firstWhere((a) => a.id == id);

    test('keeps the server __resume when local has none, and every web activity', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      await ModuleProgressStore.record(prefs, 'sp', 4, act(4, 'quiz'), 40);
      final server = {
        'module4': {
          'moduleScore': 20,
          'badges': ['m4_complete'],
          'activityData': {
            'quiz': {'score': 20, 'maxScore': 50, 'completed': true},
            'quiz3': {'score': 30, 'maxScore': 50, 'completed': true},
            '__meta': {'score': 0, 'maxScore': 0, 'completed': true},
            '__resume': {
              'score': 0,
              'maxScore': 0,
              'completed': false,
              'sectionId': 'section-4-7',
              'at': '2026-10-01T10:00:00.000Z',
            },
          },
        },
        'module14': {'moduleScore': 120, 'badges': [], 'activityData': {'quiz1': {'score': 50}}},
      };
      final body = (await EducationProgressSync.buildPushPayload(prefs,
          scope: 'sp', serverModules: server))!;
      final m4 = body['modules']['module4'] as Map;
      final ad = m4['activityData'] as Map;
      expect(ad['__resume']['sectionId'], 'section-4-7');
      expect(ad['__meta']['completed'], isTrue);
      expect(ad['quiz']['score'], 40); // local best wins
      expect(ad['quiz3']['score'], 30); // website activity kept
      expect(m4['totalScore'], 70);
      // A website-only module is echoed so the team total stays whole.
      expect((body['modules'] as Map).containsKey('module14'), isTrue);
      expect(body['modules']['module14']['totalScore'], 120);
    });

    test('a newer local resume replaces the server one (self-paced)', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      await LearnResumeStore.save('sp', 'module3', 'section-3-9',
          at: DateTime.utc(2026, 10, 2));
      final server = {
        'module3': {
          'moduleScore': 0,
          'activityData': {
            '__resume': {'sectionId': 'section-3-1', 'at': '2026-10-01T00:00:00.000Z'},
          },
        },
      };
      final body = (await EducationProgressSync.buildPushPayload(prefs,
          scope: 'sp', serverModules: server))!;
      final r = body['modules']['module3']['activityData']['__resume'] as Map;
      expect(r['sectionId'], 'section-3-9');
      expect(r['at'], '2026-10-02T00:00:00.000Z');
    });

    test('workshop decks sync their resume position', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      await LearnResumeStore.save('sp', 'break-even', 'section-be-4');
      final body = (await EducationProgressSync.buildPushPayload(prefs,
          scope: 'sp', serverModules: const {}))!;
      expect(body['modules']['break-even']['activityData']['__resume']['sectionId'],
          'section-be-4');
    });

    test('corporate teams never push a resume position', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      await LearnResumeStore.save('3', 'module1', 'section-1-4');
      final body = await EducationProgressSync.buildPushPayload(prefs,
          scope: '3', serverModules: const {});
      expect(body, isNull);
    });

    test('nothing ahead of the server means no POST', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final body = await EducationProgressSync.buildPushPayload(prefs,
          scope: 'sp',
          serverModules: {
            'module1': {
              'moduleScore': 75,
              'activityData': {'quiz': {'score': 75, 'completed': true}},
            },
          });
      expect(body, isNull);
    });

    test('legacy per-tab ids from older app builds are dropped', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      await ModuleProgressStore.record(prefs, 'sp', 1, act(1, 'memoryMatch'), 50);
      final body = (await EducationProgressSync.buildPushPayload(prefs, scope: 'sp', serverModules: {
        'module1': {
          'moduleScore': 50,
          'activityData': {
            'game': {'score': 50, 'maxScore': 0, 'completed': true},
            'sim': {'score': 0, 'maxScore': 0, 'completed': false},
          },
        },
      }))!;
      final ad = body['modules']['module1']['activityData'] as Map;
      expect(ad.containsKey('game'), isFalse);
      expect(ad.containsKey('sim'), isFalse);
      expect(ad['memoryMatch']['score'], 50);
    });
  });

  group('server to local', () {
    test('restores website activities, Learn and the newest resume', () async {
      SharedPreferences.setMockInitialValues({});
      await LearnResumeStore.save('sp', 'module4', 'section-4-2',
          at: DateTime.utc(2026, 9, 1));
      final changed = await EducationProgressSync.applyServerToLocal({
        'module4': {
          'moduleScore': 250,
          'completed': true,
          'activityData': {
            'quiz': {'score': 50, 'maxScore': 50, 'completed': true},
            'quiz3': {'score': 50, 'maxScore': 50, 'completed': true},
            'memoryMatch': {'score': 50, 'maxScore': 50, 'completed': true},
            'financialAnalysisSimulator': {'score': 100, 'maxScore': 100, 'completed': true},
            '__meta': {'completed': true},
            '__resume': {'sectionId': 'section-4-15', 'at': '2026-10-01T00:00:00.000Z'},
          },
        },
      }, scope: 'sp');
      expect(changed, isTrue);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('edu_module_sp_4_learn'), isTrue);
      expect(prefs.getInt('edu_module_sp_4_act_quiz3_score'), 50);
      expect(prefs.getBool('edu_module_sp_4_quiz'), isTrue); // both practice quizzes done
      expect(prefs.getBool('edu_module_sp_4_game'), isFalse); // ratio game not played
      expect(prefs.getInt('edu_progress_4'), 77); // 250 / 325
      expect(prefs.getBool('edu_passed_4'), isTrue);
      expect((await LearnResumeStore.get('sp', 'module4'))!.sectionId, 'section-4-15');
    });

    test('an older server resume never overwrites a newer local one', () async {
      SharedPreferences.setMockInitialValues({});
      await LearnResumeStore.save('sp', 'module1', 'section-1-9',
          at: DateTime.utc(2026, 10, 3));
      await EducationProgressSync.applyServerToLocal({
        'module1': {
          'moduleScore': 0,
          'activityData': {
            '__resume': {'sectionId': 'section-1-2', 'at': '2026-10-01T00:00:00.000Z'},
          },
        },
      }, scope: 'sp');
      expect((await LearnResumeStore.get('sp', 'module1'))!.sectionId, 'section-1-9');
    });

    test('legacy per-tab progress migrates onto website activities', () async {
      SharedPreferences.setMockInitialValues({
        'edu_module_sp_9_quiz': true,
        'edu_module_sp_9_quizScore': 40,
        'edu_module_sp_9_gamesDone': ['ordering'],
        'edu_module_sp_9_gameScore_ordering': 50,
        'edu_module_sp_9_sim': true,
        'edu_module_sp_9_simScore': 80,
      });
      final prefs = await SharedPreferences.getInstance();
      final m9 = educationModuleContents[9]!;
      expect(await ModuleProgressStore.migrateLegacy(prefs, 'sp', m9), isTrue);
      expect(prefs.getInt('edu_module_sp_9_act_quiz_score'), 40);
      expect(prefs.getInt('edu_module_sp_9_act_complianceOrdering_score'), 25); // 50/50 of 25
      expect(prefs.getInt('edu_module_sp_9_act_internalControlsSimulator_score'), 80);
      // Runs once.
      expect(await ModuleProgressStore.migrateLegacy(prefs, 'sp', m9), isFalse);
    });
  });

  group('learn resume', () {
    test('lastResume picks the most recent module or deck', () async {
      SharedPreferences.setMockInitialValues({});
      await LearnResumeStore.save('sp', 'module3', 'section-3-2', at: DateTime.utc(2026, 1, 1));
      await LearnResumeStore.save('sp', 'capital-budgeting', 'section-cb-5',
          at: DateTime.utc(2026, 2, 1));
      await LearnResumeStore.save('2', 'module9', 'section-9-1', at: DateTime.utc(2026, 3, 1));
      final r = (await LearnResumeStore.lastResume('sp'))!;
      expect(r.moduleKey, 'capital-budgeting');
      expect(r.catalogId, 12);
      expect(r.sectionId, 'section-cb-5');
    });

    test('indexIn falls back to the first slide for a removed section', () {
      expect(LearnResumeStore.indexIn(['a', 'b', 'c'], 'c'), 2);
      expect(LearnResumeStore.indexIn(['a', 'b'], 'gone'), 0);
      expect(LearnResumeStore.indexIn(['a'], null), 0);
    });

    test('module keys round-trip to catalog ids', () {
      for (final id in [1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12, 14]) {
        expect(LearnResumeStore.catalogIdFor(LearnResumeStore.moduleKeyFor(id)), id);
      }
    });
  });

  group('push identity (hub _progressIdentity rule)', () {
    test('facilitators never push', () {
      expect(
          EducationProgressSync.progressIdentity(
              isFacilitator: true, isSelfPaced: false, email: 'f@x.com', teamId: 3),
          isNull);
    });

    test('a corporate device without a joined team never falls back to Team 1', () {
      expect(
          EducationProgressSync.progressIdentity(
              isFacilitator: false, isSelfPaced: false, teamId: null),
          isNull);
      final id = EducationProgressSync.progressIdentity(
          isFacilitator: false, isSelfPaced: false, teamId: 4)!;
      expect(id.teamName, 'Team 4');
      expect(id.scope, '4');
    });

    test('self-paced pushes as the email, never without one', () {
      expect(
          EducationProgressSync.progressIdentity(
              isFacilitator: false, isSelfPaced: true, email: ''),
          isNull);
      final id = EducationProgressSync.progressIdentity(
          isFacilitator: false, isSelfPaced: true, email: 'a@b.com', teamId: 2)!;
      expect(id.teamName, 'a@b.com');
      expect(id.scope, 'sp');
    });
  });

  test('a local recompute never drops below the last server percentage', () async {
    SharedPreferences.setMockInitialValues({});
    // Server credits 260/325 (80%) on module 4 but only via a legacy record the
    // app cannot attribute to activities.
    await EducationProgressSync.applyServerToLocal({
      'module4': {
        'moduleScore': 260,
        'activityData': {
          'game': {'score': 160, 'maxScore': 0, 'completed': true},
          'quiz': {'score': 50, 'maxScore': 50, 'completed': true},
        },
      },
    }, scope: 'sp');
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getInt('edu_progress_4'), 80);
    // Later local work (e.g. Learn completed offline) recomputes without a floor arg.
    await ModuleProgressStore.recompute(prefs, 'sp', educationModuleContents[4]!);
    expect(prefs.getInt('edu_progress_4'), 80);
    expect(prefs.getBool('edu_passed_4'), isTrue);
  });
>>>>>>> Stashed changes
}
