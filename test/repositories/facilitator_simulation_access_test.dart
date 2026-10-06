import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finplay/core/network/api_client.dart';
import 'package:finplay/data/repositories/facilitator_repository.dart';

/// The corporate simulation gate is read from GET /facilitator/simulation-access
/// (`{ success, open }`), the public route the website's home page and hub
/// poll on every learner device. The read needs no facilitator password, and
/// a route that does not answer with the switch reads as unknown, not closed.
void main() {
  late _Server server;

  setUp(() {
    server = _Server();
    ApiClient().dio.httpClientAdapter = server;
    ApiClient().clearFacilitatorPassword();
  });

  test('reads the switch from GET /facilitator/simulation-access without a password', () async {
    server.reply = (200, {'success': true, 'open': false});
    final open = await FacilitatorRepository(ApiClient()).fetchSimulationAccess();

    expect(open, isFalse);
    final req = server.requests.single;
    expect(req.method, 'GET');
    expect(req.uri.path, endsWith('/facilitator/simulation-access'));
    expect(req.headers.containsKey('x-facilitator-password'), isFalse);
  });

  test('an open switch reads true', () async {
    server.reply = (200, {'success': true, 'open': true});
    expect(await FacilitatorRepository(ApiClient()).fetchSimulationAccess(), isTrue);
  });

  test('a dead route reads as unknown so an outage never locks a room out', () async {
    server.reply = (404, {'success': false, 'error': 'API route not found'});
    expect(await FacilitatorRepository(ApiClient()).fetchSimulationAccess(), isNull);
  });
}

class _Server implements HttpClientAdapter {
  final requests = <RequestOptions>[];
  (int, Map<String, dynamic>) reply = (200, {'success': true, 'open': true});

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromString(
      jsonEncode(reply.$2),
      reply.$1,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
