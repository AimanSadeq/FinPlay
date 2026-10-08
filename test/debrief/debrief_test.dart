import 'package:flutter_test/flutter_test.dart';
import 'package:finplay/features/debrief/data/debrief_models.dart';
import 'package:finplay/features/debrief/logic/waterfall_rows.dart';

void main() {
  final data = WaterfallData.fromJson({
    'success': true,
    'round': 2,
    'start': 1000,
    'end': 1150,
    'residual': 30,
    'items': [
      {'scenarioId': '12', 'module': 'operating', 'title': 'Launch a new product line', 'amount': 500, 'contribution': -80},
      {'scenarioId': '3', 'module': 'financing', 'title': 'Bank loan', 'amount': 1000, 'contribution': 200},
    ],
  });

  test('waterfall bars: start, financing → operating, residual, end', () {
    final bars = buildWaterfallBars(data);
    expect(bars.map((b) => b.kind).toList(), [
      WaterfallKind.start,
      WaterfallKind.pos,
      WaterfallKind.neg,
      WaterfallKind.residual,
      WaterfallKind.end,
    ]);
    expect(bars[1].fullTitle, 'Bank loan');
    expect(bars[1].base, 1000);
    expect(bars[1].top, 1200);
    expect(bars[2].base, 1120);
    expect(bars[2].value, 80);
    expect(bars[2].name, 'Launch a new pr…');
    expect(bars[3].base, 1120);
    expect(bars[3].top, 1150);
    expect(bars.last.name, 'End R2');
    expect(bars.last.value, 1150);
  });

  test('a residual under 0.5 is not drawn; negative anchors float below zero', () {
    final bars = buildWaterfallBars(WaterfallData.fromJson(
        {'round': 1, 'start': -100, 'end': -60, 'residual': 0.2, 'items': [
          {'scenarioId': '1', 'module': 'investing', 'title': 'X', 'amount': 1, 'contribution': 40}
        ]}));
    expect(bars.length, 3);
    expect(bars.first.base, -100);
    expect(bars.first.value, 100);
  });

  test('compact formats', () {
    expect(formatCompact(1250000), '\$1.3M');
    expect(formatCompact(-45000), '-\$45K');
    expect(formatSignedCompact(12000), '+\$12K');
    expect(formatExact(-1234567), '-\$1,234,567');
  });

  test('coach result: ok, not configured, failure', () {
    final ok = CoachResult.fromJson({
      'success': true,
      'language': 'ar',
      'cached': true,
      'debrief': {
        'summary': 'S',
        'drivers': ['a', 'b'],
        'questions': ['q1', 'q2', 'q3']
      },
    });
    expect(ok.status, CoachStatus.ok);
    expect(ok.language, 'ar');
    expect(ok.cached, isTrue);
    expect(ok.debrief!.questions.length, 3);
    expect(CoachResult.fromJson({'success': false, 'error': 'AI provider not configured'}).status,
        CoachStatus.notConfigured);
    expect(CoachResult.fromJson({'success': false, 'error': 'Failed to generate debrief'}).status,
        CoachStatus.failed);
  });
}
