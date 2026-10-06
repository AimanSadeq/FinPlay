import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finplay/core/network/api_client.dart';
import 'package:finplay/data/repositories/facilitator_repository.dart';
import 'package:finplay/data/repositories/game_repository.dart';

/// The Excel tiles and the facilitator Excel tab render the baseline (round 0)
/// financial statements. The website serves them from GET
/// /api/game/results/round, one statement per read, for "Team 1"; the old
/// /excel/baseline-financials path answers 404. These tests pin the reads the
/// app makes and the merged `{ incomeStatement, balanceSheet, cashFlow, ratios }`
/// payload the two screens consume.
void main() {
  late _ResultsServer server;

  setUp(() {
    server = _ResultsServer();
    ApiClient().dio.httpClientAdapter = server;
  });

  test('reads all four baseline statements from /game/results/round for Team 1', () async {
    final sheets = await GameRepository(ApiClient()).fetchBaselineStatements();

    expect(server.requests.length, 4);
    for (final req in server.requests) {
      expect(req.uri.path, endsWith('/game/results/round'));
      expect(req.uri.queryParameters['teamId'], 'Team 1');
      expect(req.uri.queryParameters['round'], '0');
    }
    expect(
      server.requests.map((r) => r.uri.queryParameters['statement']).toSet(),
      {'income', 'balance', 'cashflow', 'ratios'},
    );

    expect(sheets.keys.toSet(), {'incomeStatement', 'balanceSheet', 'cashFlow', 'ratios'});
    expect(sheets['incomeStatement']!.map((r) => r['title']), ['Sales', 'Net Income']);
    expect(sheets['incomeStatement']!.first['value'], 7000000);
    expect(sheets['balanceSheet']!.first['isHeader'], isTrue);
    expect(sheets['cashFlow']!.single['title'], 'Operating Cash Flow');
    expect(sheets['ratios']!.single['type'], 'Liquidity');
  });

  test('a route the server does not serve surfaces as an error, not empty sheets', () async {
    server.reply = (404, {'success': false, 'error': 'API route not found'});

    await expectLater(
      GameRepository(ApiClient()).fetchBaselineStatements(),
      throwsA(isA<Exception>()),
    );
  });

  test('the simulation baseline badge gets the statements as FinancialData', () async {
    final baseline = await GameRepository(ApiClient()).fetchBaselineFinancialData();

    expect(server.requests.length, 4);
    expect(baseline.teamId, GameRepository.baselineTeamId);
    expect(baseline.roundNum, 0);
    expect(baseline.incomeRows.map((r) => r.title), ['Sales', 'Net Income']);
    expect(baseline.balanceRows.first.isHeader, isTrue);
    expect(baseline.ratioRows.single.type, 'Liquidity');
    // KPI getters fall back to the statement rows, as the dashboard does.
    expect(baseline.revenue, 7000000);
    expect(baseline.netIncome, 420000);
    expect(baseline.incomeStatement, {'Sales': 7000000, 'Net Income': 420000});
  });

  test('the facilitator Excel tab reads the same statements', () async {
    final sheets = await FacilitatorRepository(ApiClient()).fetchExcelData();

    expect(server.requests.length, 4);
    expect(server.requests.every((r) => r.uri.path.endsWith('/game/results/round')), isTrue);
    expect(sheets['balanceSheet']!.map((r) => r['title']), ['ASSETS:', 'Cash and Cash Equivalents']);
  });
}

/// Answers GET /game/results/round the way server/routes.ts does: only the
/// `financials` key matching the `statement` query is filled, the rest are
/// empty lists. Records every request so a test can check what was asked.
class _ResultsServer implements HttpClientAdapter {
  final requests = <RequestOptions>[];
  (int, Map<String, dynamic>)? reply;

  static const _rows = {
    'incomeStatement': [
      {'title': 'Sales', 'value': 7000000, 'isHeader': false, 'isMajor': false, 'isCalculation': false},
      {'title': 'Net Income', 'value': 420000, 'isHeader': false, 'isMajor': false, 'isCalculation': true},
    ],
    'balanceSheet': [
      {'title': 'ASSETS:', 'value': 0, 'isHeader': true, 'isMajor': true, 'isCalculation': false},
      {'title': 'Cash and Cash Equivalents', 'value': 1500000, 'isHeader': false, 'isMajor': false, 'isCalculation': false},
    ],
    'cashFlow': [
      {'title': 'Operating Cash Flow', 'value': 610000, 'isHeader': false, 'isMajor': false, 'isCalculation': false},
    ],
    'ratios': [
      {'title': 'Current Ratio', 'value': 2.55, 'isHeader': false, 'isMajor': false, 'isCalculation': false, 'type': 'Liquidity'},
    ],
  };

  static const _byStatement = {
    'income': 'incomeStatement',
    'balance': 'balanceSheet',
    'cashflow': 'cashFlow',
    'ratios': 'ratios',
  };

  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    requests.add(options);
    final (status, body) = reply ?? _resultsFor(options);
    return ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  (int, Map<String, dynamic>) _resultsFor(RequestOptions options) {
    final statement = options.uri.queryParameters['statement'];
    final filled = _byStatement[statement] ?? 'incomeStatement';
    final financials = {
      for (final key in _rows.keys) key: key == filled ? _rows[key] : <Map<String, dynamic>>[],
    };
    return (
      200,
      {
        'round': 0,
        'team': options.uri.queryParameters['teamId'],
        'financials': financials,
        'kpis': <String, dynamic>{},
        'source': 'ts-engine $statement R0',
      }
    );
  }

  @override
  void close({bool force = false}) {}
}
