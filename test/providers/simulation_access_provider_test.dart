import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finplay/core/network/api_client.dart';
import 'package:finplay/data/repositories/facilitator_repository.dart';
import 'package:finplay/providers/simulation_access_provider.dart';

/// The simulation screen watches this notifier: loading until the first read,
/// then the facilitator's switch, updated by the 15 s poll and by the
/// `facilitator:simulation_access` socket push.
void main() {
  late _Server server;

  setUp(() {
    server = _Server();
    ApiClient().dio.httpClientAdapter = server;
  });

  test('starts loading and takes the switch from the first read', () async {
    server.reply = (200, {'success': true, 'open': false});
    final notifier = SimulationAccessNotifier(FacilitatorRepository(ApiClient()));
    expect(notifier.state.isLoading, isTrue);

    await notifier.refresh();
    expect(notifier.state.valueOrNull, isFalse);
    expect(notifier.state.isLoading, isFalse);
  });

  test('a socket push from the facilitator panel opens the gate at once', () async {
    final notifier = SimulationAccessNotifier(FacilitatorRepository(ApiClient()));
    notifier.applySocket({'open': true});
    expect(notifier.state.valueOrNull, isTrue);

    notifier.applySocket({'open': false});
    expect(notifier.state.valueOrNull, isFalse);

    // A payload without the flag is ignored.
    notifier.applySocket({'foo': 'bar'});
    expect(notifier.state.valueOrNull, isFalse);
  });

  test('a failed read becomes an error, which the gate treats as open', () async {
    server.fail = true;
    final notifier = SimulationAccessNotifier(FacilitatorRepository(ApiClient()));
    await notifier.refresh();
    expect(notifier.state.hasError, isTrue);
    expect(notifier.state.valueOrNull, isNull);
  });
}

class _Server implements HttpClientAdapter {
  (int, Map<String, dynamic>) reply = (200, {'success': true, 'open': true});
  bool fail = false;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (fail) {
      throw DioException.connectionError(
        requestOptions: options,
        reason: 'offline',
      );
    }
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
