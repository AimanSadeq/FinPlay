import 'package:finplay/features/knowledge/data/financial_term.dart';
import 'package:finplay/features/knowledge/data/financial_terms_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Financial terms directory (generated from the website)', () {
    test('has the website\'s 176 terms, de-duplicated by id', () {
      expect(financialTerms.length, 176);
      expect(financialTerms.map((t) => t.id).toSet().length, 176);
      expect(financialTerms.where((t) => t.id == 'eps'), hasLength(1));
    });

    test('every term carries Arabic', () {
      for (final t in financialTerms) {
        expect(t.arabicTerm, isNotEmpty, reason: t.id);
        expect(t.arabicDefinition, isNotEmpty, reason: t.id);
        expect(arabicTermCategories[t.category], isNotNull, reason: t.category);
        if (t.tips.isNotEmpty) expect(t.tipsAr, isNotEmpty, reason: t.id);
      }
    });

    test('language switching falls back like the website', () {
      final t = financialTerms.firstWhere((t) => t.id == 'accounts-receivable');
      expect(t.formulaIn(false), t.formula);
      expect(t.formulaIn(true), t.formulaAr);
      expect(t.formulaIsArabic(true), isTrue);
      expect(t.termIn(true), t.arabicTerm);
      expect(termCategoryLabel(t.category, true), arabicTermCategories[t.category]);
    });

    test('search matches English and Arabic', () {
      final bs = financialTerms.firstWhere((t) => t.id == 'balance-sheet');
      expect(termMatches(bs, 'balance'), isTrue);
      expect(termMatches(bs, 'الميزانية'), isTrue);
      expect(termMatches(bs, 'zzz'), isFalse);
      expect(termMatches(bs, ''), isTrue);
    });

    test('deep-link name matching', () {
      expect(findTermByName('Balance Sheet')?.id, 'balance-sheet');
      expect(findTermByName('balance sheet')?.id, 'balance-sheet');
      expect(findTermByName('no such term qq'), isNull);
    });
  });
}
