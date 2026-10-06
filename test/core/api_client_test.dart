import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finplay/core/network/api_client.dart';

/// ApiClient turns a 4xx into a returned map instead of throwing. Every verb
/// must stamp the HTTP status onto that map, and a route the server no longer
/// serves (404 {success:false, error:'API route not found'}) must read as a
/// failure, so no caller can mistake a dead route for success.
void main() {
  late _StatusServer server;

  setUp(() {
    server = _StatusServer();
    ApiClient().dio.httpClientAdapter = server;
  });

  const notFound = {'success': false, 'error': 'API route not found'};

  test('post stamps the status onto a preserved 404 body', () async {
    server.reply = (404, notFound);
    final res = await ApiClient().post('/facilitator/game-control', data: {'action': 'play'});
    expect(res['success'], isFalse);
    expect(res['error'], 'API route not found');
    expect(res[httpStatusKey], 404);
    expect(apiFailed(res), isTrue);
  });

  test('get, put, patch and delete stamp the status the same way', () async {
    server.reply = (404, notFound);
    final api = ApiClient();
    for (final res in [
      await api.get('/x'),
      await api.put('/x', data: {}),
      await api.patch('/x', data: {}),
      await api.delete('/x'),
    ]) {
      expect(res[httpStatusKey], 404);
      expect(apiFailed(res), isTrue);
    }
  });

  test('a 403 with no success flag still reads as failed', () async {
    // team-progression/advance answers 403 {error, message} without `success`.
    server.reply = (403, {'error': 'Advancement locked', 'message': 'Please wait'});
    final res = await ApiClient().post('/team-progression/advance/Team%201');
    expect(res['success'], isNull);
    expect(res[httpStatusKey], 403);
    expect(apiFailed(res), isTrue);
  });

  test('a 200 success body is returned untouched and is not failed', () async {
    server.reply = (200, {'success': true, 'nextModule': 'investing'});
    final res = await ApiClient().post('/team-progression/advance/Team%201');
    expect(res, {'success': true, 'nextModule': 'investing'});
    expect(apiFailed(res), isFalse);
  });

  test('post keeps the friendly 401 message for a bodyless auth failure', () async {
    server.reply = (401, null);
    final res = await ApiClient().post('/self-paced/login', data: {});
    expect(res['error'], 'Invalid email or password');
    expect(res[httpStatusKey], 401);
  });
}

class _StatusServer implements HttpClientAdapter {
  (int, Map<String, dynamic>?) reply = (200, {'success': true});

  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    final (status, body) = reply;
    return ResponseBody.fromString(
      body == null ? '' : jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [
          body == null ? 'text/plain' : Headers.jsonContentType
        ],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
