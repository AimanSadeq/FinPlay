import 'dart:io';

import 'package:finplay/app/i18n/app_strings.dart';
import 'package:finplay/features/education/modules/education_module_data.dart';
import 'package:finplay/features/facilitator/cohort_module_plan.dart';
import 'package:finplay/features/facilitator/delivery_checklist_data.dart';
import 'package:finplay/features/facilitator/setup_wizard_logic.dart';
import 'package:finplay/features/facilitator/widgets/cohorts_panel.dart';
import 'package:finplay/features/facilitator/widgets/delivery_checklist.dart';
import 'package:finplay/features/facilitator/widgets/insights_panel.dart';
import 'package:finplay/features/facilitator/widgets/market_forecasts_card.dart';
import 'package:finplay/features/facilitator/widgets/master_voucher_card.dart';
import 'package:finplay/features/facilitator/widgets/narration_prewarm.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const en = AppStrings(false);
  const ar = AppStrings(true);

  group('cohort module plan (website CohortModulePlanEditor)', () {
    test('catalog ids cover the whole catalog, including optional id 18', () {
      expect(educationCatalogNums, contains(18));
      expect(educationCatalogNums.toSet().length, educationCatalogNums.length);
    });

    test('progress ids mirror shared/education-catalog.ts', () {
      expect(catalogProgressId(1), 'module1');
      expect(catalogProgressId(5), 'tvm');
      expect(catalogProgressId(18), 'module18');
      expect(catalogProgressId(11), isNull); // workshop tool
      expect(catalogProgressId(12), isNull);
      expect(catalogProgressId(13), isNull); // the game
      expect(catalogProgressId(99), isNull);
    });

    test('normalize keeps real ids in catalog order; empty is the whole catalog', () {
      expect(normalizeModulePlan([18, 1, 999, 3]), [1, 3, 18]);
      expect(normalizeModulePlan([999]), isNull);
      expect(normalizeModulePlan(null), isNull);
    });

    test('saving all or nothing stores null; a subset stores the ids', () {
      expect(planToSave(educationCatalogNums.toSet()), isNull);
      expect(planToSave(<int>{}), isNull);
      expect(planToSave({14, 1}), [1, 14]);
      expect(initialPlanSelection(null), educationCatalogNums.toSet());
      expect(initialPlanSelection([1, 3]), {1, 3});
    });

    test('warns only about hidden modules that teams have worked in', () {
      final losing = modulesLosingWork({1}, {'module1': 2, 'module3': 1, 'tvm': 0});
      expect(losing.map((m) => m.num), [3]);
    });

    test('reads the API plan', () {
      expect(readPlan(null), isNull);
      expect(readPlan([]), isNull);
      expect(readPlan([1, 2.0]), [1, 2]);
    });

    test('subdomain preview normalizes like the website', () {
      expect(normalizeCohortSubdomain('Group A_1!'), 'groupa1');
      expect(normalizeCohortSubdomain('may-2026'), 'may-2026');
    });
  });

  group('delivery checklist (website DeliveryChecklist)', () {
    test('both variants exist with the website item counts', () {
      expect(checklistItemCount(ChecklistVariant.corporate), 24);
      expect(checklistItemCount(ChecklistVariant.dba), 28);
    });

    test('every id is unique across both lists', () {
      final ids = [
        for (final v in ChecklistVariant.values)
          for (final sec in checklistSections(v)) ...sec.items.map((i) => i.id),
      ];
      expect(ids.length, greaterThan(30));
      expect(ids.toSet().length, ids.length);
    });

    test('ticks are stored under separate keys, as on the website', () {
      expect(checklistStorageKey[ChecklistVariant.corporate], 'facilitatorDeliveryChecklist.v1');
      expect(checklistStorageKey[ChecklistVariant.dba], 'facilitatorDeliveryChecklist.dba.v1');
    });

    test('every string has an Arabic version', () {
      for (final v in ChecklistVariant.values) {
        for (final sec in checklistSections(v)) {
          expect(sec.headingAr, isNotEmpty);
          expect(sec.timingAr, isNotEmpty);
          for (final it in sec.items) {
            expect(it.titleAr, isNotEmpty, reason: it.id);
            expect(it.detailAr, isNotEmpty, reason: it.id);
            expect(it.detailAr, isNot(it.detailEn), reason: it.id);
          }
        }
        for (final r in checklistRules(v)) {
          expect(r.$2, isNotEmpty);
        }
      }
    });

    test('the DBA list never tells anyone to run the course assessments', () {
      final text = dbaSections.expand((s) => s.items).map((i) => '${i.titleEn} ${i.detailEn}').join(' ');
      expect(text, isNot(contains('Mandate the pre-assessment')));
      expect(text, contains('Change COHORT'));
      expect(text.toLowerCase(), contains('until it is, consent cannot be collected'));
    });

    test('the text copy carries the tick state', () {
      final out = checklistAsText(en, ChecklistVariant.corporate, {'d1'});
      expect(out, contains('☑ Open the Session Setup Wizard'));
      expect(out, contains('☐ Provision a cohort for this group'));
      expect(out, contains('1/24'));
      expect(checklistAsText(ar, ChecklistVariant.dba, {}), contains('القواعد الذهبية'));
    });
  });

  group('setup wizard logic', () {
    test('state round-trips and an older layout keeps only the timer', () {
      final w = const WizardState().withConfirmed(2, true).copyWith(activeStep: 4, cohortChoice: 'elm', timerMinutes: 15);
      final back = WizardState.fromJsonString(w.toJsonString());
      expect(back.activeStep, 4);
      expect(back.isConfirmed(2), isTrue);
      expect(back.cohortChoice, 'elm');
      expect(back.timerMinutes, 15);
      final old = WizardState.fromJsonString('{"version":2,"activeStep":7,"timerMinutes":12,"confirmed":{"2":true}}');
      expect(old.activeStep, 1);
      expect(old.isConfirmed(2), isFalse);
      expect(old.timerMinutes, 12);
      expect(WizardState.fromJsonString('garbage').timerMinutes, 20);
    });

    test('system checks read /health and /health/connection', () {
      final ok = systemChecks({
        'status': 'ok',
        'services': {'database': {'status': 'healthy'}},
      }, {'mode': 'online'});
      expect(ok.api && ok.db && ok.engine, isTrue);
      expect(systemChecks({}, {}).api, isFalse);
      // Cache-only degradation (503 'degraded', database healthy) is still up.
      final cacheOnly = systemChecks({
        'status': 'degraded',
        'services': {'database': {'status': 'healthy'}, 'cache': {'status': 'unhealthy'}},
      }, {'mode': 'online'});
      expect(cacheOnly.api && cacheOnly.db, isTrue);
      final dbDown = systemChecks({
        'status': 'degraded',
        'services': {'database': {'status': 'unhealthy'}},
      }, {'mode': 'online'});
      expect(dbDown.api || dbDown.db, isFalse);
    });

    test('fresh start is clean only when every check passes', () {
      final clean = FreshStartChecks.from(
        roundState: {'roundNum': 1, 'module': 'financing'},
        teams: [
          {'totalDecisions': 0, 'currentRound': 1},
        ],
        activeShocks: {'count': 0, 'shocks': []},
        forecastCount: 0,
        teamLeaders: {'success': true, 'leaders': {}},
      );
      expect(clean.allClean, isTrue);
      final dirty = FreshStartChecks.from(
        roundState: {'roundNum': 2, 'module': 'investing'},
        teams: [
          {'totalDecisions': 3, 'currentRound': 2},
        ],
        activeShocks: {'count': 1},
        forecastCount: 2,
        teamLeaders: {'leaders': {'Team 1': 'Sara'}},
      );
      expect(dirty.allClean, isFalse);
      expect(dirty.decisionCount, 3);
      expect(dirty.leaderCount, 1);
      // Unread data never counts as clean.
      expect(
        FreshStartChecks.from(roundState: {}, teams: null, activeShocks: {}, forecastCount: null, teamLeaders: {}).allClean,
        isFalse,
      );
    });

    test('model integrity needs 12 base rows, non-zero sales growth and the defaults', () {
      List<Map<String, dynamic>> rows(double growth) => [
            for (var r = 2; r <= 13; r++)
              {
                'round': 1,
                'excelRow': r,
                'paramKey': switch (r) { 2 => 'salesGrowth', 3 => 'taxRate', 4 => 'interestExpenseRate', _ => 'p$r' },
                'value': switch (r) { 2 => '$growth', 3 => '0.2', 4 => 0.07, _ => 1 },
              },
            {'round': 2, 'excelRow': 2, 'paramKey': 'salesGrowth', 'value': 0},
          ];
      expect(ModelIntegrity.from(rows(0.1)).ok, isTrue);
      final off = ModelIntegrity.from(rows(0.15));
      expect(off.ok, isFalse);
      expect(off.mismatches.map((m) => m.$1), ['salesGrowth']);
      expect(ModelIntegrity.from(rows(0)).nonDegenerate, isFalse);
      expect(ModelIntegrity.from([]).baseRowsPresent, isFalse);
    });

    test('run-of-show is condition-aware', () {
      final base = wizardRunOfShow(lobbyUrl: 'https://x/lobby', memberRecommendations: false, preAssessmentMandated: false);
      expect(base.map((r) => r.$1), isNot(contains('member-recommendations')));
      expect(base.map((r) => r.$1), isNot(contains('pre-assessment')));
      final full = wizardRunOfShow(lobbyUrl: 'https://x/lobby', memberRecommendations: true, preAssessmentMandated: true);
      expect(full.length, base.length + 2);
      expect(full.first.$2, contains('https://x/lobby'));
    });

    test('lobby URL points at the chosen cohort', () {
      expect(wizardLobbyUrl('https://elm.finplay.viftraining.com/', 'https://main'), 'https://elm.finplay.viftraining.com/lobby');
      expect(wizardLobbyUrl('elm.example.com', 'https://main'), 'https://elm.example.com/lobby');
      expect(wizardLobbyUrl(null, 'https://main/'), 'https://main/lobby');
    });

    test('subdomain rule matches the website', () {
      expect(wizardSubdomainRe.hasMatch('june-cohort'), isTrue);
      expect(wizardSubdomainRe.hasMatch('-bad'), isFalse);
      expect(wizardSubdomainRe.hasMatch('Bad'), isFalse);
    });

    test('step 6 offers the member-recommendations flag', () {
      expect(wizardRealismModules.map((m) => m.$1), contains('memberRecommendationsEnabled'));
      expect(wizardRatioModules.length, 5);
    });
  });

  group('insights, vouchers, forecasts, narration', () {
    test('insights group by severity in the website order', () {
      FacilitatorInsight i(String id, String sev) =>
          FacilitatorInsight.fromJson({'id': id, 'severity': sev, 'teams': ['Team 1']});
      final g = groupInsights([i('a', 'info'), i('b', 'critical'), i('c', 'info')]);
      expect(g.map((e) => e.$1), ['critical', 'info']);
      expect(g.last.$2.length, 2);
      expect(FacilitatorInsight.fromJson({'severity': 'weird'}).severity, 'info');
      expect(clampInsightRound(0), 1);
      expect(clampInsightRound(3), 3);
      expect(clampInsightRound(null), 1);
    });

    test('master voucher button label follows the website', () {
      expect(masterVoucherActionLabel(en, hasCode: false, hasInput: false), 'Generate master voucher');
      expect(masterVoucherActionLabel(en, hasCode: true, hasInput: false), 'Rotate (generate new)');
      expect(masterVoucherActionLabel(en, hasCode: false, hasInput: true), 'Set custom code');
      expect(masterVoucherActionLabel(en, hasCode: true, hasInput: true), 'Replace with custom code');
    });

    test('forecast pre-fill and severity follow the website', () {
      expect(defaultForecastHeadline({'name': 'Rate Hike', 'forecastHeadline': 'Rates up?'}), 'Rates up?');
      expect(defaultForecastHeadline({'name': 'Rate Hike'}),
          'Market watchers see early signs pointing toward: Rate Hike');
      expect(forecastSeverityFor('critical'), 'high');
      expect(forecastSeverityFor('medium'), 'medium');
    });

    test('narration jobs match what the slide player sends', () {
      final first = educationModuleContents.entries.first;
      final slide = first.value.slides.first;
      final enJob = slideNarrationRequest(first.key, 0, slide, arabic: false);
      expect(enJob.moduleId, '${first.key}');
      expect(enJob.sectionId, slide['id'] ?? '0');
      expect(enJob.language, 'en');
      expect(
        enJob.text,
        [slide['title'], slide['content'], slide['keyPoint']].whereType<String>().where((t) => t.isNotEmpty).join('\n\n'),
      );
      final arJob = slideNarrationRequest(first.key, 0, slide, arabic: true);
      expect(arJob.language, 'ar');
      expect(arJob.sectionId, enJob.sectionId);
      // Arabic falls back field by field to English, as the player's _slideText does.
      expect(slideNarrationRequest(7, 3, {'title': 'T', 'content': 'C', 'contentAr': 'ع'}, arabic: true).text, 'T\n\nع');
      expect(slideNarrationRequest(7, 3, {'title': 'T'}, arabic: false).sectionId, '3');

      final en = enumerateNarrationJobs(educationModuleContents, includeArabic: false).jobs;
      final both = enumerateNarrationJobs(educationModuleContents, includeArabic: true).jobs;
      expect(en.every((j) => j.language == 'en' && j.text.length >= narrationMinSourceLength), isTrue);
      expect(both.where((j) => j.language == 'ar'), isNotEmpty);
      // Every website section id is used, so the cache rows are the player's.
      final ids = {for (final m in educationModuleContents.values) ...m.sectionIds};
      expect(en.every((j) => ids.contains(j.sectionId)), isTrue);
    });

    test('the slide player still builds its request the way the pre-warm assumes', () {
      // Pins the pre-warm to the player: if this fails, update slideNarrationRequest.
      final src = File('lib/features/education/modules/education_module_screen.dart').readAsStringSync();
      final call = src.substring(src.indexOf('SlideNarrationBar('));
      final body = call.substring(0, call.indexOf('const SizedBox'));
      expect(body, contains('moduleId: _module.id,'));
      expect(body, contains("sectionId: slide['id'] ?? '\$idx',"));
      expect(body, contains("language: s.ar ? 'ar' : 'en',"));
      expect(body.replaceAll(RegExp(r'\s+'), ' '),
          contains("text: [ _slideText(slide, 'title'), _slideText(slide, 'content'), keyPoint, ].where((t) => t.isNotEmpty).join('\\n\\n'),"));
      expect(src, contains("final keyPoint = _slideText(slide, 'keyPoint');"));
      final bar = File('lib/features/education/widgets/slide_narration_bar.dart').readAsStringSync();
      expect(bar, contains("'moduleId': widget.moduleId.toString(),"));
      expect(bar, contains("'sectionId': widget.sectionId,"));
      expect(bar, contains("'language': widget.language,"));
      expect(bar, contains("'text': widget.text,"));
      // Only the module Learn tab narrates in the app; the workshop decks do not.
      final callers = Directory('lib')
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart') && !f.path.endsWith('slide_narration_bar.dart'))
          .where((f) => f.readAsStringSync().contains('SlideNarrationBar('))
          .map((f) => f.path.split('/').last)
          .toList();
      expect(callers, ['education_module_screen.dart']);
    });
  });
}
