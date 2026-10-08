import 'package:flutter_test/flutter_test.dart';
import 'package:finplay/core/services/education_progress_sync.dart';
import 'package:finplay/features/education/modules/education_module_data.dart';

/// The eight in-app modules are generated from the website's bilingual content.
/// These tests pin the port: every learner-facing string has Arabic, activity
/// ids/maxima match the website, and module maxima match the server table.
void main() {
  final modules = educationModuleContents.values.toList();

  bool hasAr(String? s) => s != null && s.trim().isNotEmpty;
  void expectBi(Bi b, String where, {bool allowEmpty = false}) {
    if (allowEmpty && b.en.trim().isEmpty) return;
    expect(b.en.trim(), isNotEmpty, reason: '$where: empty English');
    expect(hasAr(b.ar), isTrue, reason: '$where: missing Arabic');
  }

  test('the eight in-app modules are keyed by catalog id', () {
    expect(educationModuleContents.keys.toList(), [1, 3, 4, 6, 7, 2, 9, 10]);
    for (final e in educationModuleContents.entries) {
      expect(e.value.id, e.key);
      expect(hasAr(e.value.titleAr), isTrue, reason: 'module ${e.key} title');
    }
  });

  group('slides', () {
    for (final m in modules) {
      test('module ${m.id}: every slide has a web section id and Arabic', () {
        expect(m.slides, isNotEmpty);
        final ids = <String>{};
        for (final s in m.slides) {
          final id = s['id'] ?? '';
          expect(id, startsWith('section-'), reason: 'module ${m.id} slide id');
          expect(ids.add(id), isTrue, reason: 'duplicate slide id $id');
          for (final f in ['title', 'content']) {
            expect(hasAr(s[f]), isTrue, reason: '${m.id}/$id $f');
            expect(hasAr(s['${f}Ar']), isTrue, reason: '${m.id}/$id ${f}Ar');
          }
          if (hasAr(s['keyPoint'])) {
            expect(hasAr(s['keyPointAr']), isTrue, reason: '${m.id}/$id keyPointAr');
          }
          if (hasAr(s['highlight'])) {
            expect(hasAr(s['highlightAr']), isTrue, reason: '${m.id}/$id highlightAr');
          }
        }
        expect(m.sectionIds.length, m.slides.length);
      });
    }
  });

  test('every key term has Arabic', () {
    for (final m in modules) {
      for (final t in m.keyTerms ?? const <Map<String, String>>[]) {
        expect(hasAr(t['term']), isTrue);
        expect(hasAr(t['termAr']), isTrue, reason: '${m.id}: ${t['term']}');
        if (hasAr(t['def'])) expect(hasAr(t['defAr']), isTrue, reason: '${m.id}: ${t['term']}');
      }
    }
  });

  group('activities', () {
    for (final m in modules) {
      test('module ${m.id}: bilingual, well-formed activities', () {
        final ids = <String>{};
        for (final a in m.activities) {
          final w = 'module ${m.id}/${a.id}';
          expect(ids.add(a.id), isTrue, reason: 'duplicate activity id $w');
          expect(a.maxScore, greaterThan(0), reason: w);
          expectBi(a.title, '$w title');
          expectBi(a.description, '$w description');
          switch (a.kind) {
            case ActivityKind.quiz:
              expect(a.questions, isNotEmpty, reason: w);
              for (final q in a.questions) {
                expectBi(q.question, '$w ${q.id}');
                expect(q.options.length, greaterThanOrEqualTo(2), reason: '$w ${q.id}');
                expect(q.correctIndex, inInclusiveRange(0, q.options.length - 1),
                    reason: '$w ${q.id}');
                for (final o in q.options) {
                  expectBi(o, '$w ${q.id} option');
                }
                expectBi(q.explanation, '$w ${q.id} explanation', allowEmpty: true);
              }
            case ActivityKind.memoryMatch:
              expect(a.pairs, isNotEmpty, reason: w);
              for (final p in a.pairs) {
                expect(hasAr(p.term) && hasAr(p.match), isTrue, reason: '$w ${p.id}');
              }
            case ActivityKind.classification:
            case ActivityKind.statementBuilder:
              expect(a.categories.length, greaterThanOrEqualTo(2), reason: w);
              final cats = {for (final c in a.categories) c.id};
              for (final c in a.categories) {
                expectBi(c.name, '$w category ${c.id}');
              }
              expect(a.items, isNotEmpty, reason: w);
              for (final i in a.items) {
                expectBi(i.name, '$w item ${i.id}');
                expect(cats, contains(i.category), reason: '$w item ${i.id}');
                expectBi(i.hint, '$w hint ${i.id}', allowEmpty: true);
              }
            case ActivityKind.ordering:
              expectBi(a.instruction, '$w instruction');
              expect(a.steps.length, greaterThanOrEqualTo(3), reason: w);
              for (final st in a.steps) {
                expectBi(st.name, '$w step ${st.id}');
                expectBi(st.description, '$w step ${st.id} description', allowEmpty: true);
              }
            case ActivityKind.calculator:
              expect(a.problems, isNotEmpty, reason: w);
              for (final p in a.problems) {
                expectBi(p.title, '$w ${p.id}');
                expectBi(p.scenario, '$w ${p.id} scenario');
                final answerable = p.fields.where((f) => f.isAnswerable);
                expect(answerable, isNotEmpty, reason: '$w ${p.id}');
                for (final f in answerable) {
                  expect(f.correctAnswer, isNotNull, reason: '$w ${p.id}/${f.id}');
                  expect(f.check('${f.correctAnswer}'), isTrue, reason: '$w ${p.id}/${f.id}');
                }
              }
            case ActivityKind.caseScenario:
              expect(a.scenarios, isNotEmpty, reason: w);
              for (final sc in a.scenarios) {
                expectBi(sc.title, '$w ${sc.id}');
                expectBi(sc.role, '$w ${sc.id} role');
                expectBi(sc.overview, '$w ${sc.id} overview');
                for (final st in sc.steps) {
                  expectBi(st.question, '$w ${sc.id}/${st.id}');
                  expect(st.options.where((o) => o.isCorrect), isNotEmpty,
                      reason: '$w ${sc.id}/${st.id} has no correct option');
                  for (final o in st.options) {
                    expectBi(o.text, '$w ${sc.id}/${st.id} option');
                    expectBi(o.feedback, '$w ${sc.id}/${st.id} feedback');
                  }
                }
              }
          }
        }
      });
    }
  });

  group('max-score contract', () {
    test('activity maxima sum to the server MODULE_MAX_SCORES', () {
      for (final m in modules) {
        expect(m.maxScore, EducationProgressSync.moduleMaxScores[m.id],
            reason: 'module ${m.id}');
      }
    });

    test('activity ids and maxima are the website\'s', () {
      String sig(EducationModuleContent m) =>
          m.activities.map((a) => '${a.tab.name}:${a.id}:${a.maxScore}').join(' ');
      expect(sig(educationModuleContents[1]!),
          'practice:quiz:75 games:memoryMatch:50 sim:statementBuilder:100');
      expect(sig(educationModuleContents[2]!),
          'practice:quiz:50 games:memoryMatch:50 games:classification:75 sim:scenarioBuilder:100');
      expect(sig(educationModuleContents[3]!),
          'practice:quiz:75 games:classification:75 games:memoryMatch:50 sim:statementBuilder:100');
      expect(sig(educationModuleContents[4]!),
          'practice:quiz:50 practice:quiz3:50 games:memoryMatch:50 games:ratioClassification:75 sim:financialAnalysisSimulator:100');
      expect(sig(educationModuleContents[6]!),
          'practice:quiz:50 practice:varianceCalculator:50 games:memoryMatch:50 games:budgetCycleSequencer:50 sim:budgetSimulator:100');
      expect(sig(educationModuleContents[7]!),
          'practice:quiz:50 games:memoryMatch:50 games:standardsClassification:75 sim:ifrsIpsasCaseStudies:100');
      expect(sig(educationModuleContents[9]!),
          'practice:quiz:50 games:memoryMatch:50 games:complianceClassification:75 games:complianceOrdering:25 sim:internalControlsSimulator:100');
      expect(sig(educationModuleContents[10]!),
          'practice:quiz:50 games:memoryMatch:50 games:auditProcessSequencer:50 games:auditClassification:50 sim:auditPlanningWorkshop:100');
    });

    test('every tab of every module has at least one activity', () {
      for (final m in modules) {
        for (final t in ActivityTab.values) {
          expect(m.activitiesIn(t), isNotEmpty, reason: 'module ${m.id} ${t.name}');
        }
      }
    });
  });

  test('module 4 quiz 3 carries the four added questions (24 in all)', () {
    final q3 = educationModuleContents[4]!.activities.firstWhere((a) => a.id == 'quiz3');
    expect(q3.questions.length, 24);
  });

  test('modules 9 and 10 activities carry no government framing (web ff339aa)', () {
    final re = RegExp(r'\b(government|ministry|ministries)\b', caseSensitive: false);
    for (final id in [9, 10]) {
      for (final a in educationModuleContents[id]!.activities) {
        final texts = <String>[
          a.title.en,
          a.description.en,
          a.instruction.en,
          for (final q in a.questions) ...[q.question.en, ...q.options.map((o) => o.en), q.explanation.en],
          for (final i in a.items) i.name.en,
          for (final s in a.steps) ...[s.name.en, s.description.en],
          for (final p in a.pairs) p.term,
          for (final sc in a.scenarios) ...[
            sc.title.en,
            sc.overview.en,
            sc.role.en,
            for (final st in sc.steps) ...[
              st.question.en,
              st.description.en,
              for (final o in st.options) ...[o.text.en, o.feedback.en]
            ]
          ],
        ];
        for (final t in texts) {
          expect(re.hasMatch(t), isFalse, reason: 'module $id/${a.id}: "$t"');
        }
      }
    }
  });

  test('no "Complete the Learn section" leftovers in module content', () {
    for (final m in modules) {
      for (final s in m.slides) {
        expect(s['content']!.contains('Complete the Learn section'), isFalse);
      }
    }
  });
}
