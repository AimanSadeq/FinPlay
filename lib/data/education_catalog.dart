/// The education module catalog: the one list every module reference in the
/// app must agree with.
///
/// Mirrors `shared/education-catalog.ts` in the website repository, which is the
/// source of truth for the lineup. Keep the two in step when a module is added.
///
/// How to refer to a module anywhere in this app:
///  * by its full title, or
///  * by its permanent catalog id ([EducationCatalogEntry.num]) written as
///    "id 4", never by a bare "Module 4".
///
/// The id is permanent: it is what the facilitator's unlock list, cohort module
/// plans, the progress sync (`module<id>`) and the local progress keys
/// (`edu_progress_<id>`, `gov_module_<scope>_<id>_<activity>`) all store.
/// The hub card position is deliberately NOT the id: Sector Finance Comparison
/// is id 2 and sits ninth, id 8 is retired and id 13 is the game. Positions
/// shift whenever a cohort's module plan hides cards, so they are never used as
/// identifiers.
library;

enum EducationModuleKind { content, workshop, simulation }

class EducationCatalogEntry {
  /// Permanent identifier. Same value as `govModuleNum` throughout the app.
  final int num;
  final String titleEn;
  final String titleAr;

  /// Path on the website (https://finplay.viftraining.com).
  final String href;
  final EducationModuleKind kind;

  /// Scored and tracked, but not required for the certificate unless a cohort's
  /// plan names it.
  final bool optional;

  /// Route inside this app, or null when the module's content has not been
  /// ported yet and the card opens the "available on the website" screen.
  final String? appRoute;

  const EducationCatalogEntry({
    required this.num,
    required this.titleEn,
    required this.titleAr,
    required this.href,
    required this.kind,
    this.optional = false,
    this.appRoute,
  });

  bool get inApp => appRoute != null;
  bool get isContent => kind == EducationModuleKind.content;
  bool get isWorkshop => kind == EducationModuleKind.workshop;
  bool get isSimulation => kind == EducationModuleKind.simulation;

  /// Where the card opens: the in-app screen when the content is ported, else
  /// the web-module screen for this id.
  String get route => appRoute ?? '/education/web/$num';
}

/// Base URL of the website, used for modules that are only available there.
const String educationWebsiteBase = 'https://finplay.viftraining.com';

/// In the hub's display order, which is the order a learner works through them.
const List<EducationCatalogEntry> educationCatalog = [
  EducationCatalogEntry(
    num: 1,
    titleEn: 'Financial Management Primer',
    titleAr: 'تمهيد الإدارة المالية',
    href: '/education/fundamentals',
    kind: EducationModuleKind.content,
    appRoute: '/gov-education/module/1',
  ),
  EducationCatalogEntry(
    num: 3,
    titleEn: 'Understanding Financial Statements',
    titleAr: 'فهم القوائم المالية',
    href: '/education/financial-statements',
    kind: EducationModuleKind.content,
    appRoute: '/gov-education/module/3',
  ),
  EducationCatalogEntry(
    num: 4,
    titleEn: 'Analysis of Financial Statements',
    titleAr: 'تحليل القوائم المالية',
    href: '/education/financial-analysis',
    kind: EducationModuleKind.content,
    appRoute: '/gov-education/module/4',
  ),
  EducationCatalogEntry(
    num: 5,
    titleEn: 'Time Value of Money',
    titleAr: 'القيمة الزمنية للنقود',
    href: '/education/time-value-of-money',
    kind: EducationModuleKind.content,
  ),
  EducationCatalogEntry(
    num: 11,
    titleEn: 'Break-Even Analysis',
    titleAr: 'تحليل نقطة التعادل',
    href: '/education/break-even',
    kind: EducationModuleKind.workshop,
    appRoute: '/education/break-even',
  ),
  EducationCatalogEntry(
    num: 12,
    titleEn: 'Capital Budgeting & Investment',
    titleAr: 'موازنة رأس المال والاستثمار',
    href: '/education/capital-budgeting',
    kind: EducationModuleKind.workshop,
    appRoute: '/education/capital-budgeting',
  ),
  EducationCatalogEntry(
    num: 6,
    titleEn: 'Budgeting & Financial Planning',
    titleAr: 'الموازنة والتخطيط المالي',
    href: '/education/budgeting',
    kind: EducationModuleKind.content,
    appRoute: '/gov-education/module/6',
  ),
  EducationCatalogEntry(
    num: 7,
    titleEn: 'IFRS vs IPSAS Standards',
    titleAr: 'معايير IFRS مقابل IPSAS',
    href: '/education/reporting-standards',
    kind: EducationModuleKind.content,
    appRoute: '/gov-education/module/7',
  ),
  EducationCatalogEntry(
    num: 2,
    titleEn: 'Sector Finance Comparison',
    titleAr: 'مقارنة مالية القطاعات',
    href: '/education/sector-comparison',
    kind: EducationModuleKind.content,
    appRoute: '/gov-education/module/2',
  ),
  EducationCatalogEntry(
    num: 9,
    titleEn: 'Compliance & Internal Controls',
    titleAr: 'الامتثال والضوابط الداخلية',
    href: '/education/compliance',
    kind: EducationModuleKind.content,
    appRoute: '/gov-education/module/9',
  ),
  EducationCatalogEntry(
    num: 10,
    titleEn: 'Financial Auditing & Review',
    titleAr: 'المراجعة والتدقيق المالي',
    href: '/education/auditing',
    kind: EducationModuleKind.content,
    appRoute: '/gov-education/module/10',
  ),
  EducationCatalogEntry(
    num: 14,
    titleEn: 'Value Creation: ROIC, WACC and Economic Profit',
    titleAr:
        'خلق القيمة: العائد على رأس المال المستثمر والمتوسط المرجح لتكلفة رأس المال والربح الاقتصادي',
    href: '/education/value-creation',
    kind: EducationModuleKind.content,
  ),
  EducationCatalogEntry(
    num: 15,
    titleEn: 'Business Valuation: DCF, Multiples and Deal Value',
    titleAr: 'تقييم الشركات: التدفقات النقدية المخصومة والمضاعفات وقيمة الصفقة',
    href: '/education/business-valuation',
    kind: EducationModuleKind.content,
  ),
  EducationCatalogEntry(
    num: 16,
    titleEn: 'Capital Allocation for Executives',
    titleAr: 'تخصيص رأس المال للتنفيذيين',
    href: '/education/capital-allocation',
    kind: EducationModuleKind.content,
  ),
  EducationCatalogEntry(
    num: 17,
    titleEn: 'Financing, Dividends and the Cost of Capital',
    titleAr: 'التمويل وتوزيعات الأرباح وتكلفة رأس المال',
    href: '/education/financing-decisions',
    kind: EducationModuleKind.content,
  ),
  EducationCatalogEntry(
    num: 18,
    titleEn: 'Financial Risk Assessment',
    titleAr: 'تقييم المخاطر المالية',
    href: '/education/financial-risk',
    kind: EducationModuleKind.content,
    optional: true,
  ),
  EducationCatalogEntry(
    num: 13,
    titleEn: 'Finance Simulation Game',
    titleAr: 'لعبة المحاكاة المالية',
    href: '/simulation',
    kind: EducationModuleKind.simulation,
    appRoute: '/simulation',
  ),
];

/// Everything on the hub except the game: content modules plus workshop tools.
/// Copy that states the size of the curriculum reads this, never a typed number.
final int educationModuleCount =
    educationCatalog.where((m) => !m.isSimulation).length;

final int contentModuleCount =
    educationCatalog.where((m) => m.isContent).length;

/// Content modules whose slides and activities ship inside this app.
final List<EducationCatalogEntry> inAppContentModules =
    educationCatalog.where((m) => m.isContent && m.inApp).toList();

/// Content modules that are only available on the website so far.
final List<EducationCatalogEntry> webOnlyContentModules =
    educationCatalog.where((m) => m.isContent && !m.inApp).toList();

final Map<int, EducationCatalogEntry> _byNum = {
  for (final m in educationCatalog) m.num: m,
};

EducationCatalogEntry? catalogEntry(int num) => _byNum[num];

/// 1-based position of a module among the hub's cards (the game excluded), or
/// null for an unknown id. Display only: never store or compare positions.
int? educationHubPosition(int num) {
  final cards = educationCatalog.where((m) => !m.isSimulation).toList();
  final idx = cards.indexWhere((m) => m.num == num);
  return idx < 0 ? null : idx + 1;
}
