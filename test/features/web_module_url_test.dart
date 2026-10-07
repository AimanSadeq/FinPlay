import 'package:flutter_test/flutter_test.dart';
import 'package:finplay/data/education_catalog.dart';
import 'package:finplay/features/education/screens/web_module_screen.dart';

/// The website opens a module in Arabic when its link carries `lang=ar`. Every
/// module link the app opens in the browser comes from websiteModuleUrl: the
/// eight in-app modules routed there under Arabic and the website-only
/// modules, the four library modules among them.
void main() {
  final browserModules = [...inAppContentModules, ...webOnlyContentModules];

  test('covers the eight in-app and every website-only module', () {
    expect(inAppContentModules.length, 8);
    expect(browserModules.length, contentModuleCount);
    expect(browserModules.map((m) => m.num), containsAll([19, 20, 21, 22]));
  });

  test('under Arabic every module link carries lang=ar', () {
    for (final m in browserModules) {
      final uri = Uri.parse(websiteModuleUrl(m.num, arabic: true)!);
      expect(uri.queryParameters['lang'], 'ar', reason: 'catalog id ${m.num}');
      expect(uri.path, m.href);
    }
  });

  test('under English no module link carries a language parameter', () {
    for (final m in browserModules) {
      final url = websiteModuleUrl(m.num, arabic: false)!;
      expect(Uri.parse(url).queryParameters, isEmpty, reason: 'catalog id ${m.num}');
      expect(url, '$educationWebsiteBase${m.href}');
    }
  });

  test('the link is the page of the module named by its catalog id', () {
    // Sector Finance Comparison is id 2 and sits ninth on the hub.
    expect(
      websiteModuleUrl(2, arabic: true),
      '$educationWebsiteBase${catalogEntry(2)!.href}?lang=ar',
    );
    // Compliance & Internal Controls is id 9 and sits tenth.
    expect(
      websiteModuleUrl(9, arabic: false),
      '$educationWebsiteBase${catalogEntry(9)!.href}',
    );
    expect(websiteModuleUrl(8, arabic: true), isNull);
  });

  test('the library modules open their website page, in Arabic with lang=ar', () {
    const hrefs = {
      19: '/education/strategy-to-budget',
      20: '/education/rolling-flexible-budgets',
      21: '/education/forecasting-methods',
      22: '/education/reporting-stakeholders',
    };
    hrefs.forEach((id, href) {
      // The card opens the web-module screen for the id in either locale.
      for (final arabic in [false, true]) {
        expect(moduleDestinationFor(id, arabic: arabic), ModuleDestination.web);
        expect(moduleRouteFor(id, arabic: arabic), '/education/web/$id');
      }
      expect(websiteModuleUrl(id, arabic: true), '$educationWebsiteBase$href?lang=ar');
      expect(websiteModuleUrl(id, arabic: false), '$educationWebsiteBase$href');
    });
  });
}
