import 'package:flutter_test/flutter_test.dart';
import 'package:finplay/data/education_catalog.dart';

/// Under the Arabic locale the eight in-app modules open the website's
/// translated module through the web-module screen, as the website-only
/// modules always do. The English locale keeps the in-app screens.
void main() {
  group('moduleDestinationFor', () {
    test('English opens the eight in-app modules in the app', () {
      for (final m in inAppContentModules) {
        expect(moduleDestinationFor(m.num, arabic: false), ModuleDestination.inApp);
        expect(moduleRouteFor(m.num, arabic: false), m.appRoute);
      }
    });

    test('Arabic opens the eight in-app modules on the website', () {
      expect(inAppContentModules.length, 8);
      for (final m in inAppContentModules) {
        expect(moduleDestinationFor(m.num, arabic: true), ModuleDestination.web);
      }
    });

    test('website-only modules open on the website in either locale', () {
      for (final m in webOnlyContentModules) {
        for (final arabic in [false, true]) {
          expect(moduleDestinationFor(m.num, arabic: arabic), ModuleDestination.web);
          expect(moduleRouteFor(m.num, arabic: arabic), m.route);
        }
      }
    });

    test('workshop tools and the game keep their in-app screens in Arabic', () {
      final others = educationCatalog.where((m) => !m.isContent);
      expect(others, isNotEmpty);
      for (final m in others) {
        expect(moduleDestinationFor(m.num, arabic: true), ModuleDestination.inApp);
        expect(moduleRouteFor(m.num, arabic: true), m.appRoute);
      }
    });

    test('an unknown id goes to the web-module screen', () {
      expect(moduleDestinationFor(8, arabic: false), ModuleDestination.web);
      expect(moduleRouteFor(8, arabic: false), '/education/web/8');
    });
  });

  group('web routes use catalog ids', () {
    test('every Arabic web route carries the catalog id, never the hub position', () {
      for (final m in inAppContentModules) {
        expect(moduleRouteFor(m.num, arabic: true), '/education/web/${m.num}');
      }
      // Sector Finance Comparison is id 2 and sits ninth on the hub;
      // Compliance & Internal Controls is id 9 and sits tenth.
      expect(educationHubPosition(2), 9);
      expect(moduleRouteFor(2, arabic: true), '/education/web/2');
      expect(educationHubPosition(9), 10);
      expect(moduleRouteFor(9, arabic: true), '/education/web/9');
    });
  });
}
