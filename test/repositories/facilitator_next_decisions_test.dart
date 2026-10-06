import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finplay/core/network/api_client.dart';
import 'package:finplay/core/network/api_endpoints.dart';
import 'package:finplay/data/repositories/facilitator_repository.dart';

/// The facilitator's "Next Decisions" control must use the facilitator route
/// the website uses (POST /facilitator/toggle-next-decisions {unlock}) with the
/// stored facilitator password, not the team-member route /decisions/unlock
/// (requireTeamMember, 401 for a facilitator). The server replies
/// { success, message, nextDecisionsUnlocked, nextDecisionsUnlockedFor }.
void main() {
  late _Server server;

  setUp(() {
    server = _Server();
    ApiClient().dio.httpClientAdapter = server;
  });

  tearDown(() => ApiClient().clearFacilitatorPassword());

  test('the endpoint is the facilitator route, not the team-member one', () {
    expect(ApiEndpoints.facilitatorToggleNextDecisions, '/facilitator/toggle-next-decisions');
    expect(ApiEndpoints.decisionsUnlock, '/decisions/unlock');
    expect(ApiEndpoints.facilitatorToggleNextDecisions, isNot(ApiEndpoints.decisionsUnlock));
  });

  test('unlock posts {unlock:true} with the facilitator password header', () async {
    final repo = FacilitatorRepository(ApiClient());
    await repo.login('pw-123');
    server.requests.clear();

    final res = await repo.toggleNextDecisions(true);

    final req = server.requests.single;
    expect(req.method, 'POST');
    expect(req.uri.path, endsWith('/facilitator/toggle-next-decisions'));
    expect(req.uri.path, isNot(contains('/decisions/unlock')));
    expect(req.headers['x-facilitator-password'], 'pw-123');
    expect(req.data, {'unlock': true});
    expect(res['success'], isTrue);
    expect(res['nextDecisionsUnlocked'], isTrue);
    expect(res['nextDecisionsUnlockedFor'], 'financing');
  });

  test('lock posts {unlock:false} and reports the locked state', () async {
    final res = await FacilitatorRepository(ApiClient()).toggleNextDecisions(false);

    expect(server.requests.single.data, {'unlock': false});
    expect(res['success'], isTrue);
    expect(res['nextDecisionsUnlocked'], isFalse);
    expect(res['nextDecisionsUnlockedFor'], isNull);
  });

  test('a 401 is reported as a failure, not swallowed', () async {
    server.reply = (401, {'success': false, 'error': 'Invalid facilitator password'});

    final res = await FacilitatorRepository(ApiClient()).toggleNextDecisions(true);

    expect(res['success'], isFalse);
    expect(res[httpStatusKey], 401);
    expect(res['error'], 'Invalid facilitator password');
  });

  test('a 400 {error} with no success flag is still a failure', () async {
    server.reply = (400, {'error': 'unlock parameter must be boolean'});

    final res = await FacilitatorRepository(ApiClient()).toggleNextDecisions(true);

    expect(res['success'], isFalse);
    expect(res[httpStatusKey], 400);
  });
}

/// Answers /facilitator/authenticate and /facilitator/toggle-next-decisions
/// the way server/routes/facilitator.ts does; records every request.
class _Server implements HttpClientAdapter {
  final requests = <RequestOptions>[];
  (int, Map<String, dynamic>)? reply;

  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    requests.add(options);
    final (status, body) = reply ?? _replyFor(options);
    return ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  (int, Map<String, dynamic>) _replyFor(RequestOptions options) {
    if (options.uri.path.endsWith('/facilitator/authenticate')) {
      return (200, {'success': true, 'isAdmin': false});
    }
    if (options.uri.path.endsWith('/facilitator/toggle-next-decisions')) {
      final unlock = (options.data as Map)['unlock'] == true;
      return (
        200,
        {
          'success': true,
          'message': 'Next decisions ${unlock ? 'unlocked' : 'locked'}',
          'nextDecisionsUnlocked': unlock,
          'nextDecisionsUnlockedFor': unlock ? 'financing' : null,
        }
      );
    }
    return (404, {'success': false, 'error': 'API route not found'});
  }

  @override
  void close({bool force = false}) {}
}
