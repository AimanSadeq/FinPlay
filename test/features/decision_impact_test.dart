import 'dart:convert';
import 'dart:io';

import 'package:finplay/features/simulation/impact/decision_impact.dart';
import 'package:flutter_test/flutter_test.dart';

/// The Dart port of the website's shared/decision-impact.ts against describeImpact() outputs
/// produced by the TypeScript itself (tool/generators/gen_impact.mts writes the fixture alongside
/// decision_impact_rules.g.dart).
void main() {
  final fixture = jsonDecode(File('test/fixtures/decision_impact_golden.json').readAsStringSync())
      as Map<String, dynamic>;
  final rateSets = (fixture['rateSets'] as Map<String, dynamic>).map(
    (k, v) => MapEntry(k, ModelRates.fromJson(v as Map<String, dynamic>)),
  );
  final cases = (fixture['cases'] as List).cast<Map<String, dynamic>>();

  test('fixture covers every module, both signs and both languages', () {
    expect(cases.length, greaterThan(300));
    expect(cases.where((c) => c['lang'] == 'ar').length, greaterThan(100));
  });

  test('describeImpact matches the TypeScript for every golden case', () {
    var checked = 0;
    for (final c in cases) {
      final got = describeImpact(
        c['module'] as String,
        c['row'] as int,
        (c['amount'] as num).toDouble(),
        rates: rateSets[c['rates']]!,
        lang: c['lang'] == 'ar' ? ImpactLang.ar : ImpactLang.en,
      );
      final expected = c['expected'] as Map<String, dynamic>?;
      final label = '${c['module']} row ${c['row']} amount ${c['amount']} ${c['lang']} ${c['rates']}';
      if (expected == null) {
        expect(got, isNull, reason: label);
        continue;
      }
      expect(got, isNotNull, reason: label);
      expect(got!.heading, expected['heading'], reason: label);
      expect(got.meaning, expected['meaning'], reason: label);
      final lines = (expected['lines'] as List).cast<Map<String, dynamic>>();
      expect(got.lines.map((l) => l.statement).toList(),
          lines.map((l) => l['statement']).toList(), reason: label);
      for (var i = 0; i < lines.length; i++) {
        expect(got.lines[i].text, lines[i]['text'], reason: '$label line $i');
      }
      checked++;
    }
    expect(checked, greaterThan(250));
  });

  test('spot checks against the web rules', () {
    final loan = describeImpact('financing', 1, 1000000)!;
    expect(loan.lines.first.text, 'Long-term bank loan up SAR 1,000,000; cash up SAR 1,000,000');
    expect(loan.lines[1].text,
        'Interest expense rises by about SAR 70,000 a year from this year (7%); tax shield SAR 14,000');
    expect(loan.lines[2].text, 'inflow of SAR 1,000,000 under financing activities');

    final retained = describeImpact('financing', 6, -500000, lang: ImpactLang.ar)!;
    expect(retained.lines[2].text, 'لا حركة نقدية: تحويل داخل حقوق الملكية');

    expect(describeImpact('operating', 3, 0), isNull);
    expect(describeImpact('operating', 12, -100), isNull);
    expect(hasImpactRule('investing', 8), isTrue);
    expect(hasImpactRule('investing', 10), isFalse);
  });

  test('rates overlay keeps template values for unknown or missing keys', () {
    final r = ModelRates.fromJson({'interestExpenseRate': 0.09, 'bogus': 3, 'taxRate': 'x'});
    expect(r.interestExpenseRate, 0.09);
    expect(r.taxRate, 0.2);
    expect(fmtSar(1234567.5, ImpactLang.en), 'SAR 1,234,568');
    expect(fmtSar(-999, ImpactLang.ar), '999 ريال');
  });
}
