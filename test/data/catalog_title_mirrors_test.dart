import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:finplay/data/education_catalog.dart';
import 'package:finplay/features/education/screens/education_hub_screen.dart';

/// Mirror of the website's tests/unit/catalog-title-mirrors.test.ts: every
/// Arabic module title in the app comes from the catalog, and none of the
/// wordings the website retired survives anywhere under lib/.
void main() {
  group('catalog title mirrors', () {
    const retiredArabicWordings = [
      'التدقيق المالي والمراجعة', // id 10: catalog is 'المراجعة والتدقيق المالي'
      'تقييم الأعمال:', // id 15: catalog is 'تقييم الشركات: ...'
      'القيمة الزمنية للمال', // id 5: catalog is 'القيمة الزمنية للنقود'
      'مقارنة المالية بين القطاعات', // id 2: catalog is 'مقارنة مالية القطاعات'
      'وتكلفة رأس المال والربح الاقتصادي', // id 14: '...والمتوسط المرجح لتكلفة...'
    ];

    test('no retired Arabic wording appears under lib/', () {
      final hits = <String>[];
      final files = Directory('lib')
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'));
      for (final file in files) {
        final lines = file.readAsLinesSync();
        for (var i = 0; i < lines.length; i++) {
          for (final wording in retiredArabicWordings) {
            if (lines[i].contains(wording)) {
              hits.add('${file.path}:${i + 1}: $wording');
            }
          }
        }
      }
      expect(hits, isEmpty, reason: hits.join('\n'));
    });

    test('the catalog itself carries none of the retired wordings', () {
      for (final m in educationCatalog) {
        for (final wording in retiredArabicWordings) {
          expect(m.titleAr.contains(wording), isFalse,
              reason: 'id ${m.num} still reads "$wording"');
        }
      }
    });

    test('hub cards are exactly the catalog non-simulation ids in catalog order', () {
      final expected = educationCatalog
          .where((m) => !m.isSimulation)
          .map((m) => m.num)
          .toList();
      expect(educationHubCardIds, expected);
      // Titles are derived from catalogEntry(id), so each card resolves.
      for (final id in educationHubCardIds) {
        expect(catalogEntry(id), isNotNull, reason: 'card id $id not in catalog');
      }
    });

    test('the ids 10 and 14 read the catalog wording in Arabic', () {
      expect(catalogEntry(10)!.titleAr, 'المراجعة والتدقيق المالي');
      expect(catalogEntry(14)!.titleAr,
          'خلق القيمة: العائد على رأس المال المستثمر والمتوسط المرجح لتكلفة رأس المال والربح الاقتصادي');
    });
  });
}
