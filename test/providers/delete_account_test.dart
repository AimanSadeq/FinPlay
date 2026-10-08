import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:finplay/core/network/api_client.dart';
import 'package:finplay/core/network/api_endpoints.dart';
import 'package:finplay/core/utils/constants.dart';
import 'package:finplay/data/repositories/auth_repository.dart';
import 'package:finplay/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Answers every request with a canned status + JSON body and records what was
/// sent, so the real ApiClient (with its interceptors) runs end to end.
class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.status, this.body);

  final int status;
  final Object? body;
  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream,
      Future<void>? cancelFuture) async {
    requests.add(options);
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

const _email = 'learner@example.com';

Map<String, Object> _signedInPrefs() => {
      AppConstants.selfPacedTokenKey: 'tok-123',
      'self_paced_user': jsonEncode({'email': _email, 'displayName': 'Learner'}),
      // Self-paced (scope 'sp') learner data
      'edu_module_sp_3_learn': true,
      'edu_module_sp_3_act_q1_score': 4,
      'edu_resume_sp_module3': '{"sectionId":"section-3-1","at":"2026-01-01T00:00:00Z"}',
      'edu_tool_visited_sp_11': true,
      'edu_progress_3': 40,
      'edu_passed_3': false,
      'edu_badges_3': <String>['b1'],
      'assessment_pre_score': 7,
      'self_paced_plan_$_email': 'self_paced',
      // Corporate / device-level prefs that must survive
      'edu_module_7_3_learn': true,
      'edu_team_id': 7,
      AppConstants.localeKey: 'ar',
      AppConstants.themeKey: 'dark',
      AppConstants.corporateAccessCodeKey: 'CORP1',
      AppConstants.teamMemberTokenKey: 'member-tok',
      'cohort_base_url': 'https://groupa.example.com',
      'edu_storage_version': 2,
    };

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DeleteAccountResult.fromResponse', () {
    test('200 success', () {
      expect(DeleteAccountResult.fromResponse(200, {'success': true}).status,
          DeleteAccountStatus.success);
    });
    test('200 without success:true is an error (e.g. SPA fallback HTML)', () {
      expect(DeleteAccountResult.fromResponse(200, '<html>').status,
          DeleteAccountStatus.error);
    });
    test('401 INVALID_PASSWORD -> wrongPassword', () {
      expect(
          DeleteAccountResult.fromResponse(
                  401, {'success': false, 'code': 'INVALID_PASSWORD'})
              .status,
          DeleteAccountStatus.wrongPassword);
    });
    test('401 without code -> notSignedIn', () {
      expect(
          DeleteAccountResult.fromResponse(401, {'error': 'Not authenticated'}).status,
          DeleteAccountStatus.notSignedIn);
    });
    test('403 DEMO_ACCOUNT -> demoAccount', () {
      expect(DeleteAccountResult.fromResponse(403, {'code': 'DEMO_ACCOUNT'}).status,
          DeleteAccountStatus.demoAccount);
    });
    test('429 -> rateLimited', () {
      expect(DeleteAccountResult.fromResponse(429, {'error': 'slow down'}).status,
          DeleteAccountStatus.rateLimited);
    });
    test('400 / 500 -> error with server message', () {
      final r400 = DeleteAccountResult.fromResponse(400, {'error': 'Password is required'});
      expect(r400.status, DeleteAccountStatus.error);
      expect(r400.message, 'Password is required');
      expect(DeleteAccountResult.fromResponse(500, {'error': 'boom'}).status,
          DeleteAccountStatus.error);
    });
  });

  group('AuthRepository.deleteAccount over the real ApiClient', () {
    late ApiClient api;
    late HttpClientAdapter original;
    var unauthorizedFired = 0;

    setUp(() {
      api = ApiClient();
      original = api.dio.httpClientAdapter;
      api.setAuthToken('tok-123');
      unauthorizedFired = 0;
      api.onUnauthorized = () => unauthorizedFired++;
    });

    tearDown(() {
      api.dio.httpClientAdapter = original;
      api.clearAuthToken();
      api.onUnauthorized = null;
    });

    Future<(DeleteAccountResult, _FakeAdapter)> run(int status, Object? body) async {
      final fake = _FakeAdapter(status, body);
      api.dio.httpClientAdapter = fake;
      final r = await AuthRepository(api).deleteAccount('secret');
      return (r, fake);
    }

    test('posts the password with the bearer to the contract path', () async {
      final (r, fake) = await run(200, {'success': true});
      expect(r.status, DeleteAccountStatus.success);
      expect(fake.requests, hasLength(1));
      final req = fake.requests.single;
      expect(req.method, 'POST');
      expect(req.path, ApiEndpoints.selfPacedDeleteAccount);
      expect(ApiEndpoints.selfPacedDeleteAccount, '/self-paced/delete-account');
      expect(req.data, {'password': 'secret'});
      expect(req.headers['Authorization'], 'Bearer tok-123');
    });

    test('wrong password maps to wrongPassword and does NOT fire the sign-out handler',
        () async {
      final (r, _) = await run(401, {'success': false, 'code': 'INVALID_PASSWORD'});
      expect(r.status, DeleteAccountStatus.wrongPassword);
      expect(unauthorizedFired, 0);
    });

    test('other authenticated 401s still fire the sign-out handler', () async {
      api.dio.httpClientAdapter = _FakeAdapter(401, {'error': 'Not authenticated'});
      await api.get(ApiEndpoints.selfPacedMe);
      expect(unauthorizedFired, 1);
    });

    test('403 demo, 429, 400 map correctly', () async {
      expect((await run(403, {'code': 'DEMO_ACCOUNT'})).$1.status,
          DeleteAccountStatus.demoAccount);
      expect((await run(429, {'error': 'Too many'})).$1.status,
          DeleteAccountStatus.rateLimited);
      expect((await run(400, {'error': 'Password is required'})).$1.status,
          DeleteAccountStatus.error);
    });

    test('500 is an error and is not auto-retried', () async {
      final (r, fake) = await run(500, {'error': 'boom'});
      expect(r.status, DeleteAccountStatus.error);
      expect(fake.requests, hasLength(1));
    });
  });

  group('AuthNotifier.deleteAccount', () {
    late ApiClient api;
    late HttpClientAdapter original;
    late ProviderContainer container;

    Future<AuthNotifier> signedIn(int status, Object? body) async {
      SharedPreferences.setMockInitialValues(_signedInPrefs());
      api = ApiClient();
      original = api.dio.httpClientAdapter;
      api.dio.httpClientAdapter = _FakeAdapter(status, body);
      container = ProviderContainer();
      final notifier = container.read(authProvider.notifier);
      expect(await notifier.restoreSession(), isTrue);
      return notifier;
    }

    tearDown(() {
      api.dio.httpClientAdapter = original;
      api.clearAuthToken();
      container.dispose();
    });

    test('success clears the session and this learner\'s local data only', () async {
      final notifier = await signedIn(200, {'success': true});
      final r = await notifier.deleteAccount('secret');
      expect(r.status, DeleteAccountStatus.success);

      final state = container.read(authProvider);
      expect(state.status, AuthStatus.unauthenticated);
      expect(state.user, isNull);
      expect(state.token, isNull);
      expect(api.dio.options.headers.containsKey('Authorization'), isFalse);

      final prefs = await SharedPreferences.getInstance();
      for (final gone in [
        AppConstants.selfPacedTokenKey,
        'self_paced_user',
        'edu_module_sp_3_learn',
        'edu_module_sp_3_act_q1_score',
        'edu_resume_sp_module3',
        'edu_tool_visited_sp_11',
        'edu_progress_3',
        'edu_passed_3',
        'edu_badges_3',
        'assessment_pre_score',
        'self_paced_plan_$_email',
      ]) {
        expect(prefs.containsKey(gone), isFalse, reason: '$gone should be cleared');
      }
      for (final kept in [
        'edu_module_7_3_learn',
        'edu_team_id',
        AppConstants.localeKey,
        AppConstants.themeKey,
        AppConstants.corporateAccessCodeKey,
        AppConstants.teamMemberTokenKey,
        'cohort_base_url',
        'edu_storage_version',
      ]) {
        expect(prefs.containsKey(kept), isTrue, reason: '$kept should be kept');
      }
    });

    test('wrong password keeps the learner signed in with all data', () async {
      final notifier = await signedIn(401, {'success': false, 'code': 'INVALID_PASSWORD'});
      final r = await notifier.deleteAccount('nope');
      expect(r.status, DeleteAccountStatus.wrongPassword);

      final state = container.read(authProvider);
      expect(state.status, AuthStatus.authenticated);
      expect(state.user?.email, _email);
      expect(api.dio.options.headers['Authorization'], 'Bearer tok-123');
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(AppConstants.selfPacedTokenKey), 'tok-123');
      expect(prefs.getBool('edu_module_sp_3_learn'), isTrue);
    });

    test('demo account, rate limit and server error keep the session', () async {
      for (final (status, body, expected) in [
        (403, {'code': 'DEMO_ACCOUNT'}, DeleteAccountStatus.demoAccount),
        (429, {'error': 'Too many'}, DeleteAccountStatus.rateLimited),
        (500, {'error': 'boom'}, DeleteAccountStatus.error),
      ]) {
        final notifier = await signedIn(status, body);
        final r = await notifier.deleteAccount('secret');
        expect(r.status, expected);
        expect(container.read(authProvider).status, AuthStatus.authenticated);
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString(AppConstants.selfPacedTokenKey), 'tok-123');
        api.dio.httpClientAdapter = original;
        container.dispose();
        container = ProviderContainer();
      }
    });

    test('a 401 without INVALID_PASSWORD (expired session) signs out locally', () async {
      final notifier = await signedIn(401, {'success': false, 'error': 'Not authenticated'});
      final r = await notifier.deleteAccount('secret');
      expect(r.status, DeleteAccountStatus.notSignedIn);
      expect(container.read(authProvider).status, AuthStatus.unauthenticated);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.containsKey(AppConstants.selfPacedTokenKey), isFalse);
      // Not a deletion: per-learner progress stays on the device.
      expect(prefs.getBool('edu_module_sp_3_learn'), isTrue);
    });

    test('empty password never reaches the server', () async {
      final notifier = await signedIn(200, {'success': true});
      final fake = api.dio.httpClientAdapter as _FakeAdapter;
      final r = await notifier.deleteAccount('');
      expect(r.status, DeleteAccountStatus.wrongPassword);
      expect(fake.requests, isEmpty);
      expect(container.read(authProvider).status, AuthStatus.authenticated);
    });
  });
}
