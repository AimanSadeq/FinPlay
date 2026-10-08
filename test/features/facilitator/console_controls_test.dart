import 'package:dio/dio.dart';
import 'package:finplay/app/i18n/app_strings.dart';
import 'package:finplay/core/network/api_client.dart';
import 'package:finplay/data/repositories/facilitator_repository.dart';
import 'package:finplay/features/earnings_call/earnings_call_admin_api.dart';
import 'package:finplay/features/facilitator/widgets/admin_panels.dart';
import 'package:finplay/features/facilitator/widgets/console_links.dart';
import 'package:flutter_test/flutter_test.dart';

class _Fake extends Interceptor {
  final List<RequestOptions> sent = [];
  dynamic Function(RequestOptions o) reply = (_) => {'success': true};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    sent.add(options);
    handler.resolve(Response(requestOptions: options, statusCode: 200, data: reply(options)));
  }
}

void main() {
  const en = AppStrings(false);

  group('console links (website TeamJoinCodes / CourseSlidesDownload)', () {
    test('site origin drops the API prefix', () {
      expect(siteOrigin('https://elm.finplay.viftraining.com/api'), 'https://elm.finplay.viftraining.com');
      expect(siteOrigin('https://x.com/api/'), 'https://x.com');
    });

    test('team join link presets the team and code', () {
      final url = Uri.parse(teamJoinUrl('https://x.com', 'Team 1', 'ABC123'));
      expect(url.path, '/lobby');
      expect(url.queryParameters, {'team': 'Team 1', 'code': 'ABC123'});
      expect(Uri.parse(teamJoinUrl('https://x.com', 'Team 2', null)).queryParameters, {'team': 'Team 2'});
    });

    test('team names read like the printed cards', () {
      expect(displayTeamName('Riyadh (Team 1)', 'Team 1'), 'Team 1 - Riyadh');
      expect(displayTeamName(null, 'Team 3'), 'Team 3');
      expect(displayTeamName('Falcons', 'Team 4'), 'Falcons');
    });

    test('slide decks match the website list and the catalog', () {
      expect(courseSlideDecks.length, 16);
      expect(courseSlideTotal, 257);
      expect(courseSlideDecks.every((d) => d.entry != null), isTrue);
      expect(courseSlidesUrl('https://x.com', 'all', 'ar'), 'https://x.com/education/print/all?lang=ar');
      expect(financialStatementUrl('https://x.com', 'a b.pdf'), 'https://x.com/uploads/financial-statements/a%20b.pdf');
    });

    test('scenario list matches the six capital-budgeting scenarios', () {
      expect(capitalBudgetingScenarios.map((x) => x.$1), [
        'restaurant-kitchen-riyadh',
        'coffee-expansion-dubai',
        'delivery-fleet-jeddah',
        'gym-equipment-abudhabi',
        'retail-expansion-muscat',
        'hotel-renovation-doha',
      ]);
    });
  });

  group('admin panels', () {
    test('activity actor label falls back like the website', () {
      expect(activityActorLabel({'actorName': 'Sara', 'actorEmail': 'x@y'}), 'Sara');
      expect(activityActorLabel({'teamId': 'Team 2'}), 'Team 2');
      expect(activityActorLabel({'actorType': 'facilitator'}), 'Facilitator');
    });

    test('member access window follows the website rules', () {
      final now = DateTime.utc(2026, 10, 5);
      expect(memberWindowLabel(en, {'accessState': 'comp', 'trialEndsAt': '2020-01-01'}, now: now), 'never expires');
      expect(memberWindowLabel(en, {'accessState': 'student', 'studentEmailDomain': 'uni.edu'}, now: now), 'uni.edu · never expires');
      expect(memberWindowLabel(en, {'accessState': 'trial', 'trialEndsAt': '2026-10-08T00:00:00Z'}, now: now), 'trial ends in 3d');
      expect(memberWindowLabel(en, {'accessState': 'lapsed', 'hasEverPaid': true, 'subscriptionExpiresAt': '2026-10-01T00:00:00Z'}, now: now),
          'expired 4d ago');
      expect(memberAccessLabel(en, 'subscription'), 'Paid');
    });
  });

  group('earnings call admin', () {
    test('photo data URLs sniff the image type and cap the size', () {
      expect(photoDataUrl([0xFF, 0xD8, 0xFF, 0xE0, 1]), startsWith('data:image/jpeg;base64,'));
      expect(photoDataUrl([1, 2, 3], contentType: 'image/png; charset=x'), startsWith('data:image/png;base64,'));
      expect(photoDataUrl([1, 2, 3]), isNull);
      expect(photoDataUrl(List.filled(earningsCallMaxPhotoBytes + 1, 0xFF), contentType: 'image/jpeg'), isNull);
    });

    test('video progress counts each question status', () {
      final v = videoProgress({
        'questions': [
          {'videoStatus': 'done'},
          {'videoStatus': 'processing'},
          {'videoStatus': 'error'},
          {},
        ]
      });
      expect((v.done, v.processing, v.failed), (1, 1, 1));
    });
  });

  group('contracts', () {
    late _Fake fake;
    setUp(() {
      final api = ApiClient();
      api.dio.interceptors.removeWhere((i) => i is _Fake);
      fake = _Fake();
      api.dio.interceptors.add(fake);
      api.setFacilitatorPassword('pw');
    });
    tearDown(() => ApiClient().dio.interceptors.removeWhere((i) => i is _Fake));

    test('facilitator console routes', () async {
      final repo = FacilitatorRepository(ApiClient());
      fake.reply = (o) => switch (o.path) {
            '/facilitator/activity-log' => {'success': true, 'configured': true, 'events': []},
            '/self-paced/admin/members' => {'success': true, 'members': []},
            '/facilitator/toggle-scenario-results' => {'success': true, 'capitalBudgetingResultsUnlocked': ['a']},
            '/teams' => [
                {'id': 'Team 10'},
                {'id': 'Team 2'}
              ],
            '/dashboard-data' => {
                'data': {
                  'currentRound': {'round': 1},
                  'previousRound': {'round': 0}
                }
              },
            _ => {'success': true},
          };
      await repo.fetchActivityLog(category: 'auth', search: 'sara');
      await repo.fetchSelfPacedMembers();
      await repo.setMemberPlan('a@b.c', 'demo');
      await repo.deleteFinancialStatement('f1');
      await repo.setCaseStudy(null);
      expect(await repo.toggleScenarioResults('a', true), ['a']);
      await repo.sendTestEmail('a@b.c');
      expect((await repo.fetchTeamsRaw()).map((t) => t['id']), ['Team 2', 'Team 10']);
      expect(await repo.fetchTeamRoundData('Team 1', 0), {'round': 0});
      expect(fake.sent.map((o) => o.path), [
        '/facilitator/activity-log',
        '/self-paced/admin/members',
        '/self-paced/admin/members/set-plan',
        '/facilitator/financial-statements/delete',
        '/facilitator/set-case-study',
        '/facilitator/toggle-scenario-results',
        '/facilitator/test-email',
        '/teams',
        '/dashboard-data',
      ]);
      expect(fake.sent[0].data, {'password': 'pw', 'category': 'auth', 'search': 'sara', 'limit': 300});
      expect(fake.sent[2].data, {'password': 'pw', 'email': 'a@b.c', 'plan': 'demo'});
      expect(fake.sent[3].data, {'password': 'pw', 'category': 'annualReport', 'fileId': 'f1'});
      expect((fake.sent[4].data as Map)['caseStudyId'], isNull);
      expect((fake.sent[5].data as Map)['scenarioId'], 'a');
      expect((fake.sent[6].data as Map)['to'], 'a@b.c');
      expect(fake.sent[8].queryParameters, {'teamId': 'Team 1', 'currentRound': 1, 'previousRound': 0});
    });

    test('earnings call persona and video routes', () async {
      final api = EarningsCallAdminApi(ApiClient());
      fake.reply = (o) => o.path == '/earnings-call/videos/status'
          ? {'success': true, 'data': []}
          : {'success': true, 'data': []};
      await api.personas();
      await api.addPersona(name: 'N', title: 'T', provider: 'did', voiceId: 'en-US-GuyNeural', photoDataUrl: 'data:image/png;base64,AA==');
      await api.deletePersona('p1');
      await api.renderVideos('Team 1');
      await api.videoStatus();
      expect(fake.sent.map((o) => '${o.method} ${o.path}'), [
        'GET /earnings-call/personas',
        'POST /earnings-call/personas',
        'DELETE /earnings-call/personas/p1',
        'POST /earnings-call/questions/Team%201/videos',
        'GET /earnings-call/videos/status',
      ]);
      expect((fake.sent[1].data as Map).containsKey('heygenAvatarId'), isFalse);
    });

    test('paid or non-idempotent calls are never auto-retried', () async {
      final repo = FacilitatorRepository(ApiClient());
      final ec = EarningsCallAdminApi(ApiClient());
      fake.reply = (o) => {'success': true, 'ready': true, 'created': [], 'data': []};
      await ec.renderVideos('Team 1');
      await ec.generateQuestions('Team 1');
      await ec.addPersona(name: 'N', title: 'T', provider: 'did', voiceId: 'v', photoDataUrl: 'data:image/png;base64,AA==');
      await ec.deletePersona('p1');
      await repo.prepareNarration(moduleId: '1', sectionId: 's', language: 'en', text: 'x' * 40);
      await repo.fetchInsights(1);
      await repo.createCohort('a', 'A');
      await repo.deleteCohort('c1', 'a');
      await repo.createVouchers(count: 2);
      await repo.setMasterVoucher();
      await repo.triggerShock('s1', round: 1);
      await repo.publishForecast(roundNum: 2, headline: 'h');
      await repo.sendTestEmail('a@b.c');
      await repo.resetGameArchived('pw');
      await repo.clearTeamLeaders();
      await repo.clearAllShocksReverting();
      await repo.startGameWithTimer(20);
      for (final o in fake.sent) {
        expect(o.extra[noRetryExtra], isTrue, reason: '${o.method} ${o.path}');
      }
      expect(fake.sent.length, 17);
    });
  });
}
