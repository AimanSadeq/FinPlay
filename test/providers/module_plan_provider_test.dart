import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finplay/core/network/api_client.dart';
import 'package:finplay/core/network/api_endpoints.dart';
import 'package:finplay/core/utils/simulation_access.dart';
import 'package:finplay/data/module_plan.dart';
import 'package:finplay/data/repositories/education_repository.dart';
import 'package:finplay/providers/module_plan_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('the endpoint is the website\'s module-plan route', () {
    expect(ApiEndpoints.educationModulePlan, '/education/module-plan');
  });

  group('EducationRepository.fetchModulePlan', () {
    late _PlanServer server;
    late EducationRepository repo;

    setUp(() {
      server = _PlanServer();
      ApiClient().dio.httpClientAdapter = server;
      repo = EducationRepository(ApiClient());
    });

    test('reads the ordered plan and its optional modules', () async {
      server.body = {
        'success': true,
        'moduleNums': [19, 1, 18],
        'optionalModuleNums': [18],
        'course': {
          'slug': 'core',
          'title': {'en': 'Core', 'ar': 'Core'},
        },
        'catalog': [1, 18, 19],
        'addons': <Object>[],
      };
      final plan = await repo.fetchModulePlan();
      expect(server.paths, ['/education/module-plan']);
      expect(plan.hubModuleNums, [19, 1, 18]);
      expect(plan.isOptional(18), isTrue);
    });

    test('moduleNums null (the main site today) is the fallback', () async {
      server.body = {
        'success': true,
        'moduleNums': null,
        'optionalModuleNums': <int>[],
        'course': null,
        'catalog': <int>[],
        'addons': <Object>[],
      };
      expect(await repo.fetchModulePlan(), ModulePlan.fallback);
    });

    test('a missing route throws, so the caller keeps what it has', () async {
      server.status = 404;
      server.body = {'success': false, 'error': 'API route not found'};
      await expectLater(repo.fetchModulePlan(), throwsException);
    });
  });

  group('ModulePlanNotifier', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    test('starts on the fallback and applies the server plan', () async {
      final repo = _FakeRepo()..next = () async => ModulePlan.of([20, 1], optional: [20]);
      final n = ModulePlanNotifier(repo, () => 'https://a.example/api');
      expect(n.state, ModulePlan.fallback);
      await n.refresh();
      expect(n.state.hubModuleNums, [20, 1]);
      expect(n.state.isOptional(20), isTrue);
    });

    test('a failed call with nothing cached keeps the fallback (no library modules)', () async {
      final repo = _FakeRepo()..next = () async => throw Exception('offline');
      final n = ModulePlanNotifier(repo, () => 'https://a.example/api');
      await n.refresh();
      expect(n.state, ModulePlan.fallback);
      expect(n.state.hubModuleNums, isNot(contains(19)));
    });

    test('a slow call times out to the current plan instead of blocking', () async {
      final never = Completer<ModulePlan>();
      final repo = _FakeRepo()..next = () => never.future;
      final n = ModulePlanNotifier(repo, () => 'https://a.example/api',
          timeout: const Duration(milliseconds: 20));
      await n.refresh();
      expect(n.state, ModulePlan.fallback);
    });

    test('the plan is cached per host and restored on the next start', () async {
      final repo = _FakeRepo()..next = () async => ModulePlan.of([21, 3]);
      final first = ModulePlanNotifier(repo, () => 'https://a.example/api');
      await first.refresh();

      // Next launch, offline: the cached plan for this host applies.
      repo.next = () async => throw Exception('offline');
      final second = ModulePlanNotifier(repo, () => 'https://a.example/api');
      await second.refresh();
      expect(second.state.hubModuleNums, [21, 3]);

      // Another host (another cohort) never reads that plan.
      final other = ModulePlanNotifier(repo, () => 'https://b.example/api');
      await other.refresh();
      expect(other.state, ModulePlan.fallback);
    });

    test('a server answer of no plan replaces a cached plan', () async {
      final repo = _FakeRepo()..next = () async => ModulePlan.of([21, 3]);
      final n = ModulePlanNotifier(repo, () => 'https://a.example/api');
      await n.refresh();
      repo.next = () async => ModulePlan.fallback;
      await n.refresh();
      expect(n.state, ModulePlan.fallback);
    });

    test('switching host after a failure drops the previous host\'s plan', () async {
      var host = 'https://a.example/api';
      final repo = _FakeRepo()..next = () async => ModulePlan.of([21, 3]);
      final n = ModulePlanNotifier(repo, () => host);
      await n.refresh();
      host = 'https://b.example/api';
      repo.next = () async => throw Exception('offline');
      await n.refresh();
      expect(n.state, ModulePlan.fallback);
    });
  });

  group('learnCompleteForScope follows the plan', () {
    test('only the required in-app modules of the plan gate it', () async {
      SharedPreferences.setMockInitialValues({'edu_module_3_1_learn': true});
      final prefs = await SharedPreferences.getInstance();
      // Default: every in-app content module, so one is not enough.
      expect(learnCompleteForScope(prefs, '3'), isFalse);
      // A plan of id 1, an optional id 3 and website-only modules.
      final plan = ModulePlan.of([1, 3, 19, 20], optional: [3]);
      expect(learnCompleteForScope(prefs, '3', plan: plan), isTrue);
    });
  });
}

class _FakeRepo extends EducationRepository {
  _FakeRepo() : super(ApiClient());

  late Future<ModulePlan> Function() next;

  @override
  Future<ModulePlan> fetchModulePlan() => next();
}

class _PlanServer implements HttpClientAdapter {
  Map<String, dynamic> body = const {};
  int status = 200;
  final List<String> paths = [];

  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    paths.add(options.path);
    return ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
