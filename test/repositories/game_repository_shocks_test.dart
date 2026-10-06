import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finplay/core/network/api_client.dart';
import 'package:finplay/data/repositories/game_repository.dart';

/// The simulation screen's initial shock load. The server serves a team's
/// shocks at GET /shocks/active?teamId and GET /shocks/unacknowledged/{teamId}
/// (server/routes/shocks.ts); the bare /shocks/unacknowledged path answers 404.
/// Both reply { success, shocks:[...] } with the copy nested under
/// `definition`, which the shock banner does not read, so rows are flattened.
void main() {
  late _Server server;

  setUp(() {
    server = _Server();
    ApiClient().dio.httpClientAdapter = server;
  });

  test('reads the two team-scoped routes', () async {
    await GameRepository(ApiClient()).fetchTeamShocks('Team 7');

    expect(server.requests, hasLength(2));
    final active = server.requests.singleWhere((r) => r.uri.path.endsWith('/shocks/active'));
    expect(active.uri.queryParameters['teamId'], 'Team 7');
    final paths = server.requests.map((r) => r.uri.path).toList();
    expect(paths, contains(endsWith('/shocks/unacknowledged/Team%207')));
    expect(paths, isNot(contains(endsWith('/shocks/unacknowledged'))));
  });

  test('merges both lists by id and lifts the definition copy to the top level', () async {
    final shocks = await GameRepository(ApiClient()).fetchTeamShocks('Team 7');

    expect(shocks.map((s) => s['id']), ['shock-2-1791269021311', 'shock-3-1791269099000']);
    final first = shocks.first;
    expect(first['name'], 'Key customer bankruptcy');
    expect(first['description'], startsWith('Your largest customer'));
    expect(first['severity'], 'high');
    expect(first['nameAr'], isNotEmpty);
    expect(first['definition'], isA<Map>());
    expect(first['shockId'], 'custom-2-1791269021311');
  });

  test('a failed read contributes nothing instead of throwing', () async {
    server.unacknowledgedReply = (404, {'success': false, 'error': 'API route not found'});

    final shocks = await GameRepository(ApiClient()).fetchTeamShocks('Team 7');

    expect(shocks.map((s) => s['id']), ['shock-2-1791269021311']);
  });

  test('flattenShock keeps top-level copy a socket push already carries', () {
    final row = GameRepository.flattenShock({
      'id': 'x',
      'name': 'Pushed name',
      'definition': {'name': 'Definition name', 'severity': 'low'},
    });
    expect(row['name'], 'Pushed name');
    expect(row['severity'], 'low');
  });
}

/// Trimmed from a sandbox GET /api/shocks/active?teamId=Team%201 response.
class _Server implements HttpClientAdapter {
  final requests = <RequestOptions>[];
  (int, Map<String, dynamic>)? unacknowledgedReply;

  static const _active = {
    'id': 'shock-2-1791269021311',
    'shockId': 'custom-2-1791269021311',
    'definition': {
      'name': 'Key customer bankruptcy',
      'nameAr': 'إفلاس عميل رئيسي',
      'description': 'Your largest customer has filed for bankruptcy; receivables of 1.2m are at risk.',
      'descriptionAr': 'تقدم أكبر عملائك بطلب إفلاس',
      'category': 'market',
      'severity': 'high',
      'icon': 'alert',
      'id': 'custom-2-1791269021311',
    },
    'triggeredAt': '2026-10-06T08:03:41.311Z',
    'triggeredBy': 'facilitator',
    'target': 'all',
    'round': 1,
    'module': 'financing',
    'isActive': true,
    'acknowledgedBy': <String>[],
  };

  static const _unacknowledged = {
    'id': 'shock-3-1791269099000',
    'shockId': 'supply-chain-disruption',
    'definition': {
      'name': 'Supply chain disruption',
      'description': 'A key supplier halts deliveries for six weeks.',
      'severity': 'medium',
    },
    'target': 'Team 7',
    'isActive': true,
  };

  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    requests.add(options);
    final path = options.uri.path;
    final (int status, Map<String, dynamic> body) = path.endsWith('/shocks/active')
        ? (200, {'success': true, 'shocks': [_active], 'count': 1})
        : path.contains('/shocks/unacknowledged/')
            ? (unacknowledgedReply ??
                (200, {'success': true, 'teamId': 'Team 7', 'shocks': [_active, _unacknowledged], 'count': 2}))
            : (404, {'success': false, 'error': 'API route not found'});
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
