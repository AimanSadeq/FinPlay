import 'package:dio/dio.dart';
import 'package:finplay/core/network/api_client.dart';
import 'package:finplay/data/repositories/facilitator_repository.dart';
import 'package:flutter_test/flutter_test.dart';

/// Answers every request locally and records what was sent, so the repository's paths,
/// methods and bodies can be checked against the website server's routes.
class _Fake extends Interceptor {
  final List<RequestOptions> sent = [];
  Map<String, dynamic> Function(RequestOptions o) reply = (_) => {'success': true};
  int status = 200;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    sent.add(options);
    final body = reply(options);
    if (status >= 400) {
      handler.reject(DioException(
        requestOptions: options,
        response: Response(requestOptions: options, statusCode: status, data: body),
        type: DioExceptionType.badResponse,
      ));
      return;
    }
    handler.resolve(Response(requestOptions: options, statusCode: status, data: body));
  }
}

void main() {
  late _Fake fake;
  late FacilitatorRepository repo;

  setUp(() {
    final api = ApiClient();
    api.dio.interceptors.removeWhere((i) => i is _Fake);
    fake = _Fake();
    api.dio.interceptors.add(fake);
    api.setFacilitatorPassword('pw');
    repo = FacilitatorRepository(api);
  });

  tearDown(() => ApiClient().dio.interceptors.removeWhere((i) => i is _Fake));

  test('create cohort sends the research flag', () async {
    await repo.createCohort('groupa', 'Group A', research: true);
    expect(fake.sent.single.method, 'POST');
    expect(fake.sent.single.path, '/facilitator/cohorts');
    expect(fake.sent.single.data, {'subdomain': 'groupa', 'displayName': 'Group A', 'research': true});
  });

  test('rename / plan / certificate go through PATCH /facilitator/cohorts/:id', () async {
    fake.reply = (_) => {
          'success': true,
          'cohort': {'id': 'c1', 'displayName': 'New'}
        };
    final c = await repo.updateCohort('c1', {'educationModuleNums': null, 'certificateProgramName': 'Exec'});
    expect(c['displayName'], 'New');
    expect(fake.sent.single.method, 'PATCH');
    expect(fake.sent.single.path, '/facilitator/cohorts/c1');
    expect(fake.sent.single.data, {'educationModuleNums': null, 'certificateProgramName': 'Exec'});
  });

  test('a refused PATCH surfaces the server message', () async {
    fake.status = 404;
    fake.reply = (_) => {'success': false, 'error': 'Cohort not found.'};
    expect(
      () => repo.updateCohort('nope', {'displayName': 'x'}),
      throwsA(isA<FacilitatorActionException>().having((e) => e.message, 'message', 'Cohort not found.')),
    );
  });

  test('delete sends the typed subdomain as confirm in a DELETE body', () async {
    fake.reply = (_) => {
          'success': true,
          'deleted': {'subdomain': 'groupa', 'displayName': 'Group A'}
        };
    final d = await repo.deleteCohort('c1', 'groupa');
    expect(d['subdomain'], 'groupa');
    expect(fake.sent.single.method, 'DELETE');
    expect(fake.sent.single.path, '/facilitator/cohorts/c1');
    expect(fake.sent.single.data, {'confirm': 'groupa'});
  });

  test('data summary and module progress read the cohort sub-routes', () async {
    fake.reply = (o) => o.path.endsWith('data-summary')
        ? {
            'success': true,
            'counts': {'decisions': 4},
            'hasParticipantData': true
          }
        : {
            'success': true,
            'counts': {'module1': 2}
          };
    final sum = await repo.fetchCohortDataSummary('c1');
    expect(sum.hasParticipantData, isTrue);
    expect(sum.counts, {'decisions': 4});
    expect(await repo.fetchCohortModuleProgress('c1'), {'module1': 2});
    expect(fake.sent.map((o) => o.path), ['/facilitator/cohorts/c1/data-summary', '/facilitator/cohorts/c1/module-progress']);
  });

  test('master voucher: generate, custom, clear', () async {
    fake.reply = (o) => {'success': true, 'code': (o.data is Map && o.data['clear'] == true) ? null : 'ABCDEF'};
    expect(await repo.setMasterVoucher(), 'ABCDEF');
    expect(await repo.setMasterVoucher(code: ' MYCODE1 '), 'ABCDEF');
    expect(await repo.setMasterVoucher(clear: true), isNull);
    expect(fake.sent.map((o) => o.path).toSet(), {'/vouchers/master'});
    expect(fake.sent.map((o) => o.data).toList(), [
      <String, dynamic>{},
      {'code': 'MYCODE1'},
      {'clear': true},
    ]);
  });

  test('insights send the password and round in the body', () async {
    fake.reply = (_) => {'success': true, 'round': 2, 'insights': []};
    await repo.fetchInsights(2);
    expect(fake.sent.single.path, '/insights');
    expect(fake.sent.single.data, {'password': 'pw', 'round': 2});
  });

  test('forecasts: publish, resolve, insured count', () async {
    fake.reply = (o) => o.path.startsWith('/hedges')
        ? {
            'success': true,
            'count': 2,
            'teamIds': ['Team 1', 'Team 3']
          }
        : {'success': true, 'forecast': {}};
    await repo.publishForecast(roundNum: 2, headline: ' Rates up ', severityHint: 'high');
    await repo.resolveForecast('f1');
    final ins = await repo.fetchForecastInsurance('f1');
    expect(ins.count, 2);
    expect(fake.sent[0].path, '/shocks/forecast');
    expect(fake.sent[0].data, {'password': 'pw', 'headline': 'Rates up', 'roundNum': 2, 'severityHint': 'high'});
    expect(fake.sent[1].path, '/shocks/forecast/f1/resolve');
    expect(fake.sent[2].path, '/hedges/forecast/f1');
  });

  test('wizard writes hit the website routes', () async {
    await repo.setGameMode('self-paced');
    await repo.clearTeamLeaders();
    await repo.startGameWithTimer(15);
    await repo.saveTimerOverlaySeconds(300);
    await repo.setResearchMode(false);
    expect(fake.sent.map((o) => o.path), [
      '/facilitator/toggle-game-mode',
      '/facilitator/clear-team-leaders',
      '/facilitator/start-game',
      '/facilitator/timer-overlay/settings',
      '/research/mode',
    ]);
    expect(fake.sent[0].data, {'mode': 'self-paced'});
    expect((fake.sent[2].data as Map)['timerMinutes'], 15);
    expect(fake.sent[4].data, {'enabled': false});
  });
}
