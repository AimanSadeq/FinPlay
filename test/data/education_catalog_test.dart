import 'package:flutter_test/flutter_test.dart';
import 'package:finplay/data/education_catalog.dart';

void main() {
  group('education catalog', () {
    test('has 16 modules plus the simulation, in hub order', () {
      expect(educationCatalog.length, 17);
      expect(educationModuleCount, 16);
      expect(contentModuleCount, 14);
      expect(educationCatalog.last.isSimulation, isTrue);
      expect(educationCatalog.last.num, 13);
    });

    test('catalog ids are unique and never reuse the retired id 8', () {
      final nums = educationCatalog.map((m) => m.num).toList();
      expect(nums.toSet().length, nums.length);
      expect(nums, isNot(contains(8)));
    });

    test('card position is not the id', () {
      // Sector Finance Comparison is id 2 and sits ninth.
      expect(catalogEntry(2)!.titleEn, 'Sector Finance Comparison');
      expect(educationHubPosition(2), 9);
      expect(educationHubPosition(1), 1);
      expect(educationHubPosition(13), isNull);
    });

    test('in-app routes carry the catalog id, never the position', () {
      for (final m in inAppContentModules) {
        expect(m.appRoute, '/gov-education/module/${m.num}');
      }
      expect(inAppContentModules.map((m) => m.num), [1, 3, 4, 6, 7, 2, 9, 10]);
    });

    test('website-only modules open the web screen for their id', () {
      expect(webOnlyContentModules.map((m) => m.num), [5, 14, 15, 16, 17, 18]);
      for (final m in webOnlyContentModules) {
        expect(m.route, '/education/web/${m.num}');
      }
    });

    test('only Financial Risk Assessment is optional', () {
      final optional = educationCatalog.where((m) => m.optional).toList();
      expect(optional.length, 1);
      expect(optional.single.num, 18);
    });
  });
}
