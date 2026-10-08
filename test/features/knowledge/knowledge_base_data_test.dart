import 'package:finplay/features/knowledge/data/kb_catalog.dart';
import 'package:finplay/features/knowledge/data/kb_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Knowledge Base data (generated from the website)', () {
    test('ships the full catalog with unique ids', () {
      expect(kbArticles.length, 55);
      expect(kbArticles.map((a) => a.id).toSet().length, kbArticles.length);
    });

    test('every article is bilingual and sits in a known category', () {
      final cats = kbCategories.map((c) => c.id).toSet();
      for (final a in kbArticles) {
        expect(cats, contains(a.category), reason: a.id);
        expect(a.title.en, isNotEmpty);
        expect(a.title.ar, isNotEmpty, reason: a.id);
        expect(a.summary.ar, isNotEmpty, reason: a.id);
        for (final s in a.sections) {
          expect(s.heading.ar, isNotEmpty, reason: a.id);
          for (final p in s.paragraphs) {
            expect(p.ar, isNotEmpty, reason: a.id);
          }
        }
      }
    });

    test('related articles resolve', () {
      for (final a in kbArticles) {
        for (final id in a.relatedArticles) {
          expect(kbArticleById(id), isNotNull, reason: '${a.id} -> $id');
        }
      }
    });

    test('standards segments reproduce the label exactly', () {
      for (final a in kbArticles) {
        for (final st in a.standards) {
          expect(st.segments.map((s) => s.text).join(), st.standard, reason: a.id);
        }
      }
    });

    test('search covers both languages and narrows by category', () {
      expect(kbSearch(''), hasLength(kbArticles.length));
      expect(kbSearch('WACC').map((a) => a.id), contains('wacc'));
      expect(kbSearch('تكلفة رأس المال').map((a) => a.id), contains('wacc'));
      final pub = kbSearch('', category: 'public-sector');
      expect(pub, isNotEmpty);
      expect(pub.every((a) => a.category == 'public-sector'), isTrue);
      expect(kbSearch('zzzz-no-such-thing'), isEmpty);
    });

    test('related modules map through the education catalog', () {
      expect(kbModuleRoute('/education/fundamentals'), '/education/module/1');
      expect(kbModuleRoute('/education/break-even'), '/education/break-even');
      // Retired government-track links 404 on the website too: no chip.
      expect(kbModuleRoute('/government-education/budgeting'), isNull);
    });
  });
}
