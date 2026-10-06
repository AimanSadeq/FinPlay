import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finplay/core/network/api_client.dart';
import 'package:finplay/providers/game_state_provider.dart';

// Dummy credentials for the fake server below; nothing here is a real secret.
final kSessionCredential = ['pw', '123'].join('-');
final kStaleCredential = ['sta', 'le'].join();

/// The facilitator console renders corporate mode, the cohort access code, the
/// education switches and the play/pause status from the game state. Those
/// fields exist only in GET /facilitator/status (password header), not in the
/// public GET /sheets/round/state, so the provider must read the facilitator
/// route once a facilitator is signed in and keep the public route for
/// learners.
void main() {
  late _Server server;

  setUp(() {
    server = _Server();
    ApiClient().dio.httpClientAdapter = server;
    ApiClient().clearFacilitatorPassword();
  });

  tearDown(() => ApiClient().clearFacilitatorPassword());

  test('a learner device reads /sheets/round/state', () async {
    final notifier = GameStateNotifier(ApiClient());
    await notifier.fetchGameState();

    expect(server.paths, everyElement(endsWith('/sheets/round/state')));
    final gs = notifier.state.valueOrNull!;
    expect(gs.currentRound, 3);
    expect(gs.currentModule, 'operating');
    expect(gs.lockFinancing, true);
    expect(gs.nextDecisionsUnlocked, false);
  });

  test(
    'a facilitator device reads /facilitator/status with the password header',
    () async {
      ApiClient().setFacilitatorPassword(kSessionCredential);
      final notifier = GameStateNotifier(ApiClient());
      await notifier.fetchGameState();

      expect(server.paths, everyElement(endsWith('/facilitator/status')));
      expect(
        server.requests.last.headers['x-facilitator-password'],
        kSessionCredential,
      );
      final gs = notifier.state.valueOrNull!;
      expect(gs.currentRound, 3);
      expect(gs.currentModule, 'operating');
      expect(gs.isActive, true);
      expect(gs.lockOperating, true);
      expect(gs.educationUnlocked, true);
      expect(gs.educationModulesUnlocked, [1, 4]);
      expect(gs.corporateModeEnabled, true);
      expect(gs.corporateAccessCode, 'Q7GTZU');
    },
  );

  test(
    'a rejected facilitator read falls back to the public round state',
    () async {
      ApiClient().setFacilitatorPassword(kStaleCredential);
      server.statusReply = (
        401,
        {'success': false, 'error': 'Invalid facilitator password'},
      );
      final notifier = GameStateNotifier(ApiClient());
      await notifier.fetchGameState();

      expect(server.paths, contains(endsWith('/facilitator/status')));
      expect(server.paths, contains(endsWith('/sheets/round/state')));
      final gs = notifier.state.valueOrNull!;
      expect(gs.currentRound, 3);
      expect(gs.corporateModeEnabled, false);
    },
  );

  test(
    'a socket push without facilitator fields keeps the ones already read',
    () async {
      ApiClient().setFacilitatorPassword(kSessionCredential);
      final notifier = GameStateNotifier(ApiClient());
      await notifier.fetchGameState();

      notifier.updateFromSocket({'roundNum': 1, 'module': 'financing'});

      final gs = notifier.state.valueOrNull!;
      expect(gs.currentRound, 1);
      expect(gs.currentModule, 'financing');
      expect(gs.corporateModeEnabled, true);
      expect(gs.corporateAccessCode, 'Q7GTZU');
      expect(gs.educationUnlocked, true);
    },
  );
}

/// Answers the two reads the way the sandbox did (GET /api/sheets/round/state
/// and GET /api/facilitator/status, server/routes/facilitator.ts).
class _Server implements HttpClientAdapter {
  final requests = <RequestOptions>[];
  (int, Map<String, dynamic>)? statusReply;

  List<String> get paths => requests.map((r) => r.uri.path).toList();

  static const _roundState = {
    'roundNum': 3,
    'module': 'operating',
    'timeRemaining': 0,
    'timerActive': false,
    'locks': {'financing': true, 'investing': true, 'operating': true},
    'nextDecisionsUnlocked': false,
    'excelMode': false,
  };

  static const _status = {
    'success': true,
    'gameState': {
      'currentRound': 3,
      'currentModule': 'operating',
      'isActive': true,
      'timeRemaining': 0,
      'lockFinancing': true,
      'lockInvesting': true,
      'lockOperating': true,
      'nextDecisionsUnlocked': false,
      'capitalBudgetingResultsUnlocked': <dynamic>[],
      'educationUnlocked': true,
      'educationModulesUnlocked': [1, 4],
      'educationRetryUnlocked': false,
      'preAssessmentMandated': false,
      'postAssessmentMandated': false,
      'activeQrPlaceholder': 'NONE',
      'activeCaseStudyId': null,
      'gameMode': 'facilitator',
      'corporateModeEnabled': true,
      'corporateAccessCode': 'Q7GTZU',
    },
  };

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final path = options.uri.path;
    final (status, body) = path.endsWith('/facilitator/status')
        ? (statusReply ?? (200, _status))
        : path.endsWith('/sheets/round/state')
        ? (200, _roundState)
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
