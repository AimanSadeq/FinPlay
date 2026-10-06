import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finplay/core/network/api_client.dart';
import 'package:finplay/data/repositories/facilitator_repository.dart';

/// GET /facilitator/all-decisions (server/routes.ts) answers the decision
/// matrix bare: { financing: { [team]: { [round]: [rows] } }, investing,
/// operating } with no success/data wrapper. The Round Details tab and the
/// decisions export must parse that, and still fail on a 500 or a dead route.
void main() {
  late _Server server;

  setUp(() {
    server = _Server();
    ApiClient().dio.httpClientAdapter = server;
  });

  test('parses the bare module matrix the server sends', () async {
    final res = await FacilitatorRepository(ApiClient()).getAllDecisions();

    expect(server.requests.single.uri.path, endsWith('/facilitator/all-decisions'));
    expect(res.keys.toSet(), {'financing', 'investing', 'operating'});
    final team1 = res['financing']['Team 1'] as Map;
    expect(team1.keys, ['1', '2']);
    final r1 = team1['1'] as List;
    expect(r1.length, 2);
    expect(r1.first, {
      'scenarioId': 1,
      'title': 'Bank Term Loan',
      'amount': 5000000,
      'confirmed': true,
    });
    expect(res['operating'], isEmpty);
  });

  test('pivots the matrix by team for the Round Details cards', () async {
    final res = await FacilitatorRepository(ApiClient()).getAllDecisions();
    final byTeam = FacilitatorRepository.decisionsByTeam(res);

    expect(byTeam.keys.toSet(), {'Team 1', 'Team 7'});
    expect(byTeam['Team 1']!.keys.toSet(), {'financing', 'investing'});
    expect(byTeam['Team 1']!['financing']!.keys, ['1', '2']);
    expect(byTeam['Team 1']!['investing']!['1']!.single['title'], 'Equipment Purchase');
    expect(byTeam['Team 1']!['investing']!['1']!.single['amount'], -3000000);
    expect(byTeam['Team 7']!.keys, ['financing']);
    expect(byTeam['Team 7']!['financing']!['1']!.single['confirmed'], isFalse);
    expect(byTeam.containsKey('Team 2'), isFalse);
  });

  test('an empty matrix (no decisions yet) is not an error', () async {
    server.reply = (200, {'financing': {}, 'investing': {}, 'operating': {}});

    final res = await FacilitatorRepository(ApiClient()).getAllDecisions();

    expect(res, {'financing': {}, 'investing': {}, 'operating': {}});
    expect(FacilitatorRepository.decisionsByTeam(res), isEmpty);
  });

  test('a server failure surfaces as an error', () async {
    server.reply = (500, {'error': 'Failed to fetch all decisions'});

    await expectLater(
      FacilitatorRepository(ApiClient()).getAllDecisions(),
      throwsA(isA<Exception>()),
    );
  });

  test('a dead route surfaces as an error', () async {
    server.reply = (404, {'success': false, 'error': 'API route not found'});

    await expectLater(
      FacilitatorRepository(ApiClient()).getAllDecisions(),
      throwsA(isA<Exception>()),
    );
  });
}

/// Trimmed from a sandbox GET /api/facilitator/all-decisions response.
class _Server implements HttpClientAdapter {
  final requests = <RequestOptions>[];
  (int, Map<String, dynamic>)? reply;

  static const _matrix = {
    'financing': {
      'Team 7': {
        '1': [
          {'scenarioId': 1, 'title': 'Bank Term Loan', 'amount': 500000, 'confirmed': false},
        ],
      },
      'Team 1': {
        '1': [
          {'scenarioId': 1, 'title': 'Bank Term Loan', 'amount': 5000000, 'confirmed': true},
          {'scenarioId': 2, 'title': 'Equity Investment', 'amount': 2000000, 'confirmed': true},
        ],
        '2': [
          {'scenarioId': 1, 'title': 'Bank Term Loan', 'amount': 5000000, 'confirmed': true},
        ],
      },
    },
    'investing': {
      'Team 1': {
        '1': [
          {'scenarioId': 1, 'title': 'Equipment Purchase', 'amount': -3000000, 'confirmed': true},
        ],
      },
    },
    'operating': <String, dynamic>{},
  };

  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    requests.add(options);
    final (status, body) = reply ?? (200, _matrix);
    // Retries on 5xx would add requests; the client retries up to twice.
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
