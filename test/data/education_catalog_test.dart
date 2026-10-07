import 'package:flutter_test/flutter_test.dart';
import 'package:finplay/data/education_catalog.dart';

void main() {
  group('education catalog', () {
    test('counts are derived from the catalog, with the game last', () {
      final nonGame = educationCatalog.where((m) => !m.isSimulation);
      expect(educationModuleCount, nonGame.length);
      expect(contentModuleCount, nonGame.where((m) => m.isContent).length);
      expect(educationCatalog.where((m) => m.isSimulation).length, 1);
      expect(educationCatalog.last.isSimulation, isTrue);
      expect(educationCatalog.last.num, 13);
      // Today's lineup: 16 core modules, the four library modules, the game.
      expect(educationCatalog.length, 21);
      expect(educationModuleCount, 20);
      expect(contentModuleCount, 18);
    });

    test('lineup matches the website catalog order', () {
      expect(educationCatalog.map((m) => m.num),
          [1, 3, 4, 5, 11, 12, 6, 7, 2, 9, 10, 14, 15, 16, 17, 18, 19, 20, 21, 22, 13]);
    });

    test('the library modules follow Financial Risk Assessment, before the game', () {
      final nums = educationCatalog.map((m) => m.num).toList();
      final risk = nums.indexOf(18);
      expect(nums.sublist(risk + 1), [19, 20, 21, 22, 13]);
      const expected = {
        19: ('From Strategy to Budget', 'من الاستراتيجية إلى الموازنة',
            '/education/strategy-to-budget'),
        20: ('Rolling and Flexible Budgets', 'الموازنات المتجددة والمرنة',
            '/education/rolling-flexible-budgets'),
        21: ('Forecasting Methods', 'أساليب التنبؤ', '/education/forecasting-methods'),
        22: ('Reporting to Senior Stakeholders', 'رفع التقارير إلى كبار أصحاب القرار',
            '/education/reporting-stakeholders'),
      };
      expected.forEach((id, e) {
        final m = catalogEntry(id)!;
        expect(m.titleEn, e.$1, reason: 'id $id');
        expect(m.titleAr, e.$2, reason: 'id $id');
        expect(m.href, e.$3, reason: 'id $id');
        expect(m.isContent, isTrue, reason: 'id $id');
        expect(m.optional, isFalse, reason: 'id $id');
        expect(m.inApp, isFalse, reason: 'id $id is website-only');
        expect(m.route, '/education/web/$id');
      });
    });

    test('only the library modules are outside the default core set', () {
      expect(
        educationCatalog.where((m) => !m.inDefaultCore).map((m) => m.num),
        [19, 20, 21, 22],
      );
      // The default core set is today's sixteen modules in today's hub order.
      expect(defaultCoreModuleNums,
          [1, 3, 4, 5, 11, 12, 6, 7, 2, 9, 10, 14, 15, 16, 17, 18]);
    });

    test('hrefs are unique', () {
      final hrefs = educationCatalog.map((m) => m.href).toList();
      expect(hrefs.toSet().length, hrefs.length);
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
        expect(m.appRoute, '/education/module/${m.num}');
      }
      expect(inAppContentModules.map((m) => m.num), [1, 3, 4, 6, 7, 2, 9, 10]);
    });

    test('website-only modules open the web screen for their id', () {
      expect(webOnlyContentModules.map((m) => m.num),
          [5, 14, 15, 16, 17, 18, 19, 20, 21, 22]);
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
