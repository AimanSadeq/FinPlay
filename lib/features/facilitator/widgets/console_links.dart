/// Links the facilitator console builds for things that open outside the app (website
/// TeamJoinCodes, CourseSlidesDownload, FinancialStatementsAdmin). Pure, so they can be
/// unit tested.
library;

import '../../../core/utils/constants.dart';
import '../../../data/education_catalog.dart';

/// The site origin for an API base URL ("https://x.com/api" -> "https://x.com").
String siteOrigin(String apiBaseUrl) => apiBaseUrl
    .replaceFirst(RegExp('${RegExp.escape(AppConstants.apiPrefix)}/*\$'), '')
    .replaceAll(RegExp(r'/+$'), '');

/// Website teamJoinUrl: the lobby with the team (and the cohort code) preset, so a
/// delegate who scans it types only their name.
String teamJoinUrl(String origin, String teamId, String? accessCode) {
  final q = <String, String>{'team': teamId, if (accessCode != null && accessCode.isNotEmpty) 'code': accessCode};
  return '$origin/lobby?${Uri(queryParameters: q).query}';
}

/// Website displayTeamName: "Riyadh (Team 1)" reads as "Team 1 - Riyadh" on a card.
String displayTeamName(String? name, String id) {
  if (name == null || name.isEmpty) return id;
  final m = RegExp(r'^(.+)\s*\(Team\s+(\d+)\)$', caseSensitive: false).firstMatch(name);
  return m == null ? name : 'Team ${m.group(2)} - ${m.group(1)!.trim()}';
}

/// One downloadable slide deck: website deck id, the catalog id it belongs to (for the
/// title in both languages) and its slide count (website CourseSlidesDownload DECKS).
class SlideDeck {
  final String id;
  final int catalogNum;
  final int slides;
  const SlideDeck(this.id, this.catalogNum, this.slides);

  EducationCatalogEntry? get entry => catalogEntry(catalogNum);
}

const List<SlideDeck> courseSlideDecks = [
  SlideDeck('module1', 1, 25),
  SlideDeck('module3', 3, 19),
  SlideDeck('module4', 4, 16),
  SlideDeck('tvm', 5, 27),
  SlideDeck('break-even', 11, 15),
  SlideDeck('capital-budgeting', 12, 14),
  SlideDeck('module6', 6, 14),
  SlideDeck('module7', 7, 14),
  SlideDeck('module2', 2, 14),
  SlideDeck('module9', 9, 14),
  SlideDeck('module10', 10, 14),
  SlideDeck('module14', 14, 14),
  SlideDeck('module15', 15, 15),
  SlideDeck('module16', 16, 13),
  SlideDeck('module17', 17, 14),
  SlideDeck('module18', 18, 15),
];

int get courseSlideTotal => courseSlideDecks.fold(0, (n, d) => n + d.slides);

/// The print-ready page for a deck ('all' = the whole curriculum).
String courseSlidesUrl(String origin, String deckId, String lang) => '$origin/education/print/$deckId?lang=$lang';

/// Where an uploaded annual report is served from (website SlideDownloadBar).
String financialStatementUrl(String origin, String filename) =>
    '$origin/uploads/financial-statements/${Uri.encodeComponent(filename)}';

/// The capital-budgeting scenarios whose results the facilitator reveals (website
/// capitalBudgetingScenarios): (id, English title, Arabic title, difficulty).
const List<(String, String, String, String)> capitalBudgetingScenarios = [
  ('restaurant-kitchen-riyadh', 'Restaurant Kitchen Equipment - Riyadh', 'معدات مطبخ مطعم - الرياض', 'beginner'),
  ('coffee-expansion-dubai', 'Coffee Shop Expansion - Dubai', 'توسعة المقهى - دبي', 'beginner'),
  ('delivery-fleet-jeddah', 'Delivery Fleet Purchase - Jeddah', 'شراء أسطول توصيل - جدة', 'beginner'),
  ('gym-equipment-abudhabi', 'Gym Equipment Options - Abu Dhabi', 'خيارات معدات الصالة الرياضية - أبوظبي', 'intermediate'),
  ('retail-expansion-muscat', 'Retail Store Expansion - Muscat', 'توسعة متجر التجزئة - مسقط', 'intermediate'),
  ('hotel-renovation-doha', 'Hotel Renovation - Doha', 'تجديد الفندق - الدوحة', 'intermediate'),
];
