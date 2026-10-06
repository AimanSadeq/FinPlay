import 'package:flutter_test/flutter_test.dart';
import 'package:finplay/data/education_catalog.dart';
import 'package:finplay/features/education/screens/web_module_screen.dart';

/// The website opens a module in Arabic when its link carries `lang=ar`. Every
/// module link the app opens in the browser comes from websiteModuleUrl: the
/// eight in-app modules routed there under Arabic and the six website-only
/// modules.
void main() {
  final browserModules = [...inAppContentModules, ...webOnlyContentModules];

  test('covers the eight in-app and six website-only modules', () {
    expect(browserModules.length, 14);
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
}
