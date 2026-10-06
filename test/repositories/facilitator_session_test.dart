import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finplay/core/network/api_client.dart';
import 'package:finplay/data/repositories/facilitator_repository.dart';

/// A facilitator who signed in through the home "Admin Access" dialog holds
/// the session on the ApiClient (x-facilitator-password header). The
/// facilitator panel reuses it instead of asking for the password again, so
/// the repository must serve the body-password routes (reset-game, shocks
/// clear-all, education reset) from that stored session too.
void main() {
  late _Server server;

  setUp(() {
    server = _Server();
    ApiClient().dio.httpClientAdapter = server;
    ApiClient().clearFacilitatorPassword();
  });

  tearDown(() => ApiClient().clearFacilitatorPassword());

  test('the client reports the stored facilitator password', () {
    final api = ApiClient();
    expect(api.hasFacilitatorPassword, isFalse);
    expect(api.facilitatorPassword, isNull);

    api.setFacilitatorPassword('pw-123');
    expect(api.hasFacilitatorPassword, isTrue);
    expect(api.facilitatorPassword, 'pw-123');

    api.clearFacilitatorPassword();
    expect(api.hasFacilitatorPassword, isFalse);
  });

  test('body-password routes use the session stored by the home dialog', () async {
    ApiClient().setFacilitatorPassword('pw-123'); // what authProvider.loginFacilitator does
    final repo = FacilitatorRepository(ApiClient()); // no repo.login() here

    expect(await repo.resetGame(), isTrue);
    expect(await repo.clearAllShocks(), isTrue);
    expect(await repo.clearEducationProgress(), isTrue);

    expect(server.requests, hasLength(3));
    for (final req in server.requests) {
      expect((req.data as Map)['password'], 'pw-123', reason: req.uri.path);
      expect(req.headers['x-facilitator-password'], 'pw-123');
    }
  });

  test('a password given to repo.login() still wins', () async {
    ApiClient().setFacilitatorPassword('older');
    final repo = FacilitatorRepository(ApiClient());
    await repo.login('newer');
    server.requests.clear();

    await repo.resetGame();

    expect((server.requests.single.data as Map)['password'], 'newer');
  });
}

class _Server implements HttpClientAdapter {
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    requests.add(options);
    return ResponseBody.fromString(
      jsonEncode({'success': true}),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
