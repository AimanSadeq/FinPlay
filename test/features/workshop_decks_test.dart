import 'package:flutter_test/flutter_test.dart';
import 'package:finplay/features/education/screens/break_even_screen.dart';
import 'package:finplay/features/education/screens/capital_budgeting_screen.dart';

/// The two workshop decks are verbatim ports of the website's
/// break-even-slides-content.ts and capital-budgeting-slides-content.ts. The
/// section ids are what the resume position stores, so they must match the web.
void main() {
  const beIds = [
    'section-be-overview', 'section-be-1', 'section-be-2', 'section-be-3',
    'section-be-4', 'section-be-5', 'section-be-6', 'section-be-7',
    'section-be-8', 'section-be-9', 'section-be-assumptions',
    'section-be-cvp-assumptions', 'section-be-10', 'section-be-frameworks',
    'section-be-framework-bodies',
  ];
  const cbIds = [
    'section-cb-overview', 'section-cb-1', 'section-cb-2', 'section-cb-3',
    'section-cb-4', 'section-cb-5', 'section-cb-6', 'section-cb-arr',
    'section-cb-7', 'section-cb-8', 'section-cb-9', 'section-cb-10',
    'section-cb-frameworks', 'section-cb-framework-bodies',
  ];

  test('Break-Even deck: 15 web slides, bilingual, web ids', () {
    expect(breakEvenSlides.length, 15);
    expect(breakEvenSlides.map((s) => s.id).toList(), beIds);
    for (var i = 0; i < breakEvenSlides.length; i++) {
      final s = breakEvenSlides[i];
      expect(s.number, 'BE.${i + 1}');
      expect(s.titleAr.trim(), isNotEmpty, reason: s.id);
      expect(s.contentAr, isNotEmpty, reason: s.id);
      expect(s.contentAr.every((p) => p.trim().isNotEmpty), isTrue, reason: s.id);
      expect(s.contentAr.length, s.content.length, reason: s.id);
      expect(s.keyPointsAr.length, s.keyPoints.length, reason: s.id);
    }
    final titles = breakEvenSlides.map((s) => s.title).join('|');
    expect(titles, contains('Operating Leverage'));
    expect(titles, contains('CVP Assumptions'));
    expect(titles, contains('International Frameworks'));
  });

  test('Capital Budgeting deck: 14 web slides, bilingual, web ids', () {
    expect(capitalBudgetingSlides.length, 14);
    expect(capitalBudgetingSlides.map((s) => s.id).toList(), cbIds);
    for (var i = 0; i < capitalBudgetingSlides.length; i++) {
      final s = capitalBudgetingSlides[i];
      expect(s.number, 'CB.${i + 1}');
      expect(s.titleAr.trim(), isNotEmpty, reason: s.id);
      expect(s.contentAr.every((p) => p.trim().isNotEmpty), isTrue, reason: s.id);
      expect(s.contentAr.length, s.content.length, reason: s.id);
    }
    final titles = capitalBudgetingSlides.map((s) => s.title).join('|');
    expect(titles, contains('Accounting Rate of Return'));
    expect(titles, contains('International Frameworks'));
  });

  test('localized getters fall back to English when Arabic is empty', () {
    const s = BreakEvenSlide(
        id: 'x', number: 'BE.0', title: 'T', titleAr: '', content: ['c'], contentAr: []);
    expect(s.titleFor(true), 'T');
    expect(s.contentFor(true), ['c']);
    expect(breakEvenSlides.first.titleFor(true), breakEvenSlides.first.titleAr);
  });
}
