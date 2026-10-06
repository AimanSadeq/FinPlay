import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finplay/core/network/api_client.dart';
import 'package:finplay/core/network/api_endpoints.dart';
import 'package:finplay/data/models/user.dart';
import 'package:finplay/data/repositories/auth_repository.dart';

/// "Try Demo" must call POST /self-paced/demo-login (server/routes/self-paced-auth.ts),
/// which provisions demo-player@vifm.com and returns { success, token, user,
/// entitlement }. The demo row carries an unguessable password, so a password
/// login against /self-paced/login can never sign the demo in.
void main() {
  late _Server server;

  setUp(() {
    server = _Server();
    ApiClient().dio.httpClientAdapter = server;
  });

  test('the demo route is the server-owned demo login, not the password login', () {
    expect(ApiEndpoints.selfPacedDemoLogin, '/self-paced/demo-login');
    expect(ApiEndpoints.selfPacedDemoLogin, isNot(ApiEndpoints.selfPacedLogin));
  });

  test('posts to /self-paced/demo-login with no credentials', () async {
    final res = await AuthRepository(ApiClient()).demoLogin();

    final req = server.requests.single;
    expect(req.method, 'POST');
    expect(req.uri.path, endsWith('/self-paced/demo-login'));
    expect(req.uri.path, isNot(endsWith('/self-paced/login')));
    expect(req.data, isNull);

    expect(res['success'], isTrue);
    expect(res['token'], 'demo-session-token');
    final user = SelfPacedUser.fromJson(Map<String, dynamic>.from(res['user'] as Map));
    expect(user.email, 'demo-player@vifm.com');
    expect(user.displayName, 'Demo Player');
    expect(user.currentRound, 1);
    expect(user.currentModule, 'financing');
  });

  test('a rejected demo login is reported, not treated as signed in', () async {
    server.reply = (403, {'success': false, 'error': 'Demo disabled'});

    final res = await AuthRepository(ApiClient()).demoLogin();

    expect(res['success'], isFalse);
    expect(res[httpStatusKey], 403);
    expect(res['token'], isNull);
  });
}

/// Answers POST /self-paced/demo-login the way the server does.
class _Server implements HttpClientAdapter {
  final requests = <RequestOptions>[];
  (int, Map<String, dynamic>)? reply;

  static const _demo = {
    'success': true,
    'token': 'demo-session-token',
    'user': {
      'id': 42,
      'email': 'demo-player@vifm.com',
      'displayName': 'Demo Player',
      'firstName': 'Demo',
      'lastName': 'Player',
      'currentRound': 1,
      'currentModule': 'financing',
    },
    'entitlement': {'plan': 'comp', 'active': true},
  };

  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    requests.add(options);
    final (status, body) = reply ??
        (options.uri.path.endsWith('/self-paced/demo-login')
            ? (200, _demo)
            : (404, {'success': false, 'error': 'API route not found'}));
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
