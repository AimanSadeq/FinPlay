import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../knowledge/data/financial_terms_data.dart' show financialTerms;
import '../../term_trainer/screens/term_trainer_screen.dart' show showDailyPractice;
import '../../../app/theme/app_colors.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/services/education_progress_sync.dart';
import '../../../providers/socket_provider.dart';
import '../../../providers/repository_providers.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/team_provider.dart';
import '../../../providers/self_paced_provider.dart';
import '../../../providers/simulation_access_provider.dart';
import '../../../providers/module_plan_provider.dart';
import '../../../app/i18n/app_strings.dart';
import '../../../data/education_catalog.dart';
import '../../../data/module_plan.dart';
import '../../self_paced/widgets/entitlement_banner.dart';
import '../../auth/providers/self_paced_plan_provider.dart';
import '../education_gating.dart';

// ---------------------------------------------------------------------------
// Data model for each education module
// ---------------------------------------------------------------------------
class _EduModule {
  final String descEn;
  final String descAr;
  final IconData icon;
  final String categoryEn;
  final String categoryAr;
  final String difficulty; // beginner | intermediate | advanced
  final List<String> topicsEn;
  final List<String> topicsAr;
  final String route;
  final int catalogId; // permanent catalog id (education_catalog.dart); 13 = simulation

  const _EduModule({
    required this.descEn,
    required this.descAr,
    required this.icon,
    required this.categoryEn,
    required this.categoryAr,
    required this.difficulty,
    required this.topicsEn,
    required this.topicsAr,
    required this.route,
    required this.catalogId,
  });

  /// Titles come from the catalog so a card can never drift from the lineup
  /// (and the website) in either language.
  EducationCatalogEntry get _entry => catalogEntry(catalogId)!;
  String get titleEn => _entry.titleEn;
  String get titleAr => _entry.titleAr;
}

// ---------------------------------------------------------------------------
// The card for every education module, in catalog order, mirroring
// lib/data/education_catalog.dart (and the website's shared/education-catalog.ts).
// The hub draws the cards the module plan names, in the plan's order
// (see _modulesFor); the game has its own banner. `route` goes to the in-app
// screen for the eight ported modules, and to the web-module screen for the
// rest; a card opens moduleRouteFor(catalogId), which also sends the eight to
// the website under the Arabic locale. `catalogId` is the permanent catalog id.
// A module is named by its title alone: no card shows a module number.
// ---------------------------------------------------------------------------
const _modules = <_EduModule>[
  _EduModule(
    descEn:
        'The Three Pillars of Finance: Financing, Investing, Operating — covering Debt & Equity, Capital Structure, WACC, NPV & IRR, and Cash Flow Management.',
    descAr:
        'الركائز الثلاث للمالية: التمويل والاستثمار والتشغيل — الديون وحقوق الملكية، هيكل رأس المال، وإدارة التدفق النقدي.',
    icon: Icons.account_balance_rounded,
    categoryEn: 'FOUNDATION',
    categoryAr: 'الأساس',
    difficulty: 'beginner',
    topicsEn: ['Three Pillars', 'Debt & Equity', 'NPV & IRR'],
    topicsAr: ['الركائز الثلاث', 'الديون وحقوق الملكية', 'NPV و IRR'],
    route: '/education/module/1',
    catalogId: 1,
  ),
  _EduModule(
    descEn:
        'From the Accounting Cycle through Income Statement, Balance Sheet, Cash Flow Statement, and Auditing & Oversight.',
    descAr:
        'من الدورة المحاسبية عبر قائمة الدخل والميزانية العمومية وقائمة التدفقات النقدية والتدقيق.',
    icon: Icons.receipt_long_rounded,
    categoryEn: 'OUTPUTS',
    categoryAr: 'المخرجات',
    difficulty: 'intermediate',
    topicsEn: ['Income Statement', 'Balance Sheet', 'Cash Flow'],
    topicsAr: ['قائمة الدخل', 'الميزانية العمومية', 'التدفقات النقدية'],
    route: '/education/module/3',
    catalogId: 3,
  ),
  _EduModule(
    descEn:
        'Master horizontal, vertical, and trend analysis. Five ratio categories and DuPont Analysis.',
    descAr:
        'أتقن التحليل الأفقي والرأسي وتحليل الاتجاهات. خمس فئات من النسب وتحليل دوبونت.',
    icon: Icons.analytics_rounded,
    categoryEn: 'ANALYSIS',
    categoryAr: 'التحليل',
    difficulty: 'intermediate',
    topicsEn: ['Ratio Analysis', 'DuPont Framework', 'Trend Analysis'],
    topicsAr: ['تحليل النسب', 'إطار دوبونت', 'تحليل الاتجاهات'],
    route: '/education/module/4',
    catalogId: 4,
  ),
  _EduModule(
    descEn:
        'Compounding and discounting, annuities and perpetuities, effective rates, loan amortization, and the bridge from present value to NPV.',
    descAr:
        'التركيب والخصم، الدفعات السنوية والدائمة، المعدلات الفعلية، إطفاء القروض، والانتقال من القيمة الحالية إلى صافي القيمة الحالية.',
    icon: Icons.schedule_rounded,
    categoryEn: 'ANALYSIS',
    categoryAr: 'التحليل',
    difficulty: 'intermediate',
    topicsEn: ['Present & Future Value', 'Annuities', 'Effective Rates'],
    topicsAr: ['القيمة الحالية والمستقبلية', 'الدفعات السنوية', 'المعدلات الفعلية'],
    route: '/education/web/5',
    catalogId: 5,
  ),
  _EduModule(
    descEn:
        'Learn how to calculate the point where your business covers all costs and starts making profit.',
    descAr:
        'تعلم كيفية حساب النقطة التي يغطي فيها عملك جميع التكاليف ويبدأ في تحقيق الربح.',
    icon: Icons.show_chart_rounded,
    categoryEn: 'ANALYSIS',
    categoryAr: 'التحليل',
    difficulty: 'beginner',
    topicsEn: ['Fixed Costs', 'Variable Costs', 'Contribution Margin'],
    topicsAr: ['التكاليف الثابتة', 'التكاليف المتغيرة', 'هامش المساهمة'],
    route: '/education/break-even',
    catalogId: 11,
  ),
  _EduModule(
    descEn:
        'Master investment analysis techniques including NPV, IRR, and Payback Period for evaluating capital projects.',
    descAr:
        'أتقن تقنيات تحليل الاستثمار بما في ذلك صافي القيمة الحالية ومعدل العائد الداخلي وفترة الاسترداد.',
    icon: Icons.trending_up_rounded,
    categoryEn: 'INVESTMENT',
    categoryAr: 'الاستثمار',
    difficulty: 'intermediate',
    topicsEn: ['Time Value of Money', 'NPV', 'IRR'],
    topicsAr: ['القيمة الزمنية للنقود', 'صافي القيمة الحالية', 'معدل العائد الداخلي'],
    route: '/education/capital-budgeting',
    catalogId: 12,
  ),
  _EduModule(
    descEn:
        '8 budget types, 9 approaches (ZBB, rolling, flexible, MTEF), the 6-stage government process, and a 10-dimension comparison.',
    descAr:
        '8 أنواع موازنات، 9 مناهج، العملية الحكومية من 6 مراحل، ومقارنة من 10 أبعاد.',
    icon: Icons.account_balance_wallet_rounded,
    categoryEn: 'OPERATIONS',
    categoryAr: 'العمليات',
    difficulty: 'intermediate',
    topicsEn: ['8 Budget Types', '9 Approaches', 'Gov Process'],
    topicsAr: ['8 أنواع موازنات', '9 مناهج', 'العملية الحكومية'],
    route: '/education/module/6',
    catalogId: 6,
  ),
  _EduModule(
    descEn:
        'Compare IFRS and IPSAS: alignment in measurement, recognition, presentation, and public-sector divergences.',
    descAr:
        'قارن IFRS و IPSAS: التوافق في القياس والاعتراف والعرض واختلافات القطاع العام.',
    icon: Icons.public_rounded,
    categoryEn: 'STANDARDS',
    categoryAr: 'المعايير',
    difficulty: 'advanced',
    topicsEn: ['Similarities', 'Differences', 'Public Sector'],
    topicsAr: ['أوجه التشابه', 'الاختلافات', 'القطاع العام'],
    route: '/education/module/7',
    catalogId: 7,
  ),
  _EduModule(
    descEn:
        'Compare 12 dimensions across government and private sectors: objectives, revenue, accountability, IPSAS vs IFRS, and more.',
    descAr:
        'قارن 12 بعداً عبر القطاعين الحكومي والخاص: الأهداف، الإيرادات، المساءلة وأكثر.',
    icon: Icons.compare_rounded,
    categoryEn: 'CONTEXT',
    categoryAr: 'السياق',
    difficulty: 'beginner',
    topicsEn: ['Sector Objectives', 'IPSAS vs IFRS', 'Accountability'],
    topicsAr: ['أهداف القطاعات', 'IPSAS مقابل IFRS', 'المساءلة'],
    route: '/education/module/2',
    catalogId: 2,
  ),
  _EduModule(
    descEn:
        'COSO framework, fraud prevention, procurement compliance, ethics, whistleblower protection, and Saudi regulations.',
    descAr:
        'إطار COSO، منع الاحتيال، امتثال المشتريات، الأخلاقيات، وحماية المبلغين واللوائح السعودية.',
    icon: Icons.security_rounded,
    categoryEn: 'CONTROLS',
    categoryAr: 'الضوابط',
    difficulty: 'intermediate',
    topicsEn: ['COSO Framework', 'Fraud Prevention', 'Saudi Regulations'],
    topicsAr: ['إطار COSO', 'منع الاحتيال', 'اللوائح السعودية'],
    route: '/education/module/9',
    catalogId: 9,
  ),
  _EduModule(
    descEn:
        '5 audit types, risk-based auditing, IT analytics, audit quality standards, and emerging trends.',
    descAr:
        '5 أنواع تدقيق، التدقيق القائم على المخاطر، تحليلات تقنية المعلومات ومعايير الجودة.',
    icon: Icons.fact_check_rounded,
    categoryEn: 'OVERSIGHT',
    categoryAr: 'الرقابة',
    difficulty: 'advanced',
    topicsEn: ['5 Audit Types', 'Risk-Based Auditing', 'IT Analytics'],
    topicsAr: ['5 أنواع تدقيق', 'التدقيق القائم على المخاطر', 'تحليلات IT'],
    route: '/education/module/10',
    catalogId: 10,
  ),
  _EduModule(
<<<<<<< Updated upstream
=======
    number: 12,
    titleEn: 'Value Creation: ROIC, WACC and Economic Profit',
    titleAr: 'خلق القيمة: العائد على رأس المال المستثمر والمتوسط المرجح لتكلفة رأس المال والربح الاقتصادي',
>>>>>>> Stashed changes
    descEn:
        'Learn what actually creates value: invested capital, NOPAT, the ROIC minus WACC spread, economic profit, and the value drivers behind them.',
    descAr:
        'تعلم ما يخلق القيمة فعلياً: رأس المال المستثمر، وصافي الربح التشغيلي بعد الضريبة، والفرق بين العائد على رأس المال المستثمر وتكلفة رأس المال، والربح الاقتصادي، ومحركات القيمة.',
    icon: Icons.diamond_rounded,
    categoryEn: 'VALUE',
    categoryAr: 'القيمة',
    difficulty: 'intermediate',
    topicsEn: ['ROIC vs WACC', 'Economic Profit', 'Value Drivers'],
    topicsAr: ['العائد مقابل تكلفة رأس المال', 'الربح الاقتصادي', 'محركات القيمة'],
    route: '/education/web/14',
    catalogId: 14,
  ),
  _EduModule(
    descEn:
        'Build and challenge a valuation: free cash flow, terminal value, enterprise versus equity value, trading multiples, precedent transactions and deal pricing.',
    descAr:
        'ابنِ التقييم وتحدَّ افتراضاته: التدفق النقدي الحر، والقيمة النهائية، وقيمة المنشأة مقابل قيمة حقوق الملكية، ومضاعفات السوق، والصفقات السابقة، وتسعير الصفقة.',
    icon: Icons.account_balance_rounded,
    categoryEn: 'VALUE',
    categoryAr: 'القيمة',
    difficulty: 'advanced',
    topicsEn: ['DCF & Terminal Value', 'Trading Multiples', 'Deal Value'],
    topicsAr: ['التدفقات المخصومة والقيمة النهائية', 'مضاعفات السوق', 'قيمة الصفقة'],
    route: '/education/web/15',
    catalogId: 15,
  ),
  _EduModule(
    descEn:
        'Turn appraisal into a process: hurdle rates, ranking competing projects under a budget, stage gates, sensitivity analysis and honest post-investment review.',
    descAr:
        'حوّل التقييم إلى عملية إدارية: معدلات العائد المطلوبة، وترتيب المشاريع المتنافسة ضمن الميزانية، وبوابات الاعتماد، وتحليل الحساسية، والمراجعة اللاحقة للاستثمار.',
    icon: Icons.balance_rounded,
    categoryEn: 'INVESTMENT',
    categoryAr: 'الاستثمار',
    difficulty: 'intermediate',
    topicsEn: ['Hurdle Rates', 'Project Ranking', 'Stage Gates'],
    topicsAr: ['معدلات العائد المطلوبة', 'ترتيب المشاريع', 'بوابات الاعتماد'],
    route: '/education/web/16',
    catalogId: 16,
  ),
  _EduModule(
    descEn:
        'Price the money: cost of debt, credit ratings and covenants, CAPM and the cost of equity, a full WACC build, capital structure, dilution and dividend policy.',
    descAr:
        'سعّر الأموال: تكلفة الدين، والتصنيفات الائتمانية والتعهدات، ونموذج تسعير الأصول الرأسمالية وتكلفة حقوق الملكية، وبناء المتوسط المرجح لتكلفة رأس المال، وهيكل رأس المال، والتخفيف، وسياسة التوزيعات.',
    icon: Icons.payments_rounded,
    categoryEn: 'FINANCING',
    categoryAr: 'التمويل',
    difficulty: 'advanced',
    topicsEn: ['Cost of Debt & Equity', 'Capital Structure', 'Dividend Policy'],
    topicsAr: ['تكلفة الدين وحقوق الملكية', 'هيكل رأس المال', 'سياسة التوزيعات'],
    route: '/education/web/17',
    catalogId: 17,
  ),
  _EduModule(
    descEn:
        'Read the risks behind the numbers: credit, market and liquidity risk, leverage and covenant headroom, early warning signs, the Altman Z-score, and sensitivity, scenario and reverse stress tests.',
    descAr:
        'اقرأ المخاطر الكامنة وراء الأرقام: مخاطر الائتمان والسوق والسيولة، والرافعة المالية وهامش التعهدات، وإشارات الإنذار المبكر، ونموذج ألتمان، واختبارات الحساسية والسيناريوهات والضغط العكسي.',
    icon: Icons.gpp_maybe_rounded,
    categoryEn: 'RISK',
    categoryAr: 'المخاطر',
    difficulty: 'advanced',
    topicsEn: ['Credit, Market & Liquidity', 'Warning Signs', 'Stress Testing'],
    topicsAr: ['الائتمان والسوق والسيولة', 'إشارات الإنذار', 'اختبار الضغط'],
    route: '/education/web/18',
    catalogId: 18,
  ),
  // Library modules: on the hub only when the program's plan names them.
  _EduModule(
    descEn:
        'Align the budget with the strategy: cascade each objective through value drivers, KPIs, targets and initiatives to named budget lines, protect strategic spending, and review performance against the strategy.',
    descAr:
        'منهج عملي لمواءمة الموازنة مع الأهداف الاستراتيجية: تسلسل كل هدف عبر محركات القيمة ومؤشرات الأداء الرئيسية والمستهدفات والمبادرات وصولا إلى بنود موازنة محددة، وحماية الإنفاق الاستراتيجي، ومراجعة الأداء في ضوء الاستراتيجية.',
    icon: Icons.account_tree_rounded,
    categoryEn: 'PLANNING',
    categoryAr: 'التخطيط',
    difficulty: 'intermediate',
    topicsEn: ['Value Drivers & KPIs', 'Strategic Spending', 'Performance Review'],
    topicsAr: ['محركات القيمة والمؤشرات', 'الإنفاق الاستراتيجي', 'مراجعة الأداء'],
    route: '/education/web/19',
    catalogId: 19,
  ),
  _EduModule(
    descEn:
        'Keep plans current with a rolling forecast and judge performance fairly with a flexible budget: static, flexible and sales-volume variances, and when Beyond Budgeting fits.',
    descAr:
        'حافظ على حداثة الخطط بالتنبؤ المتجدد وقيّم الأداء بإنصاف بالموازنة المرنة: انحرافات الموازنة الثابتة والمرنة وحجم المبيعات، ومتى يناسب نموذج ما بعد الموازنة.',
    icon: Icons.autorenew_rounded,
    categoryEn: 'PLANNING',
    categoryAr: 'التخطيط',
    difficulty: 'intermediate',
    topicsEn: ['Rolling Forecasts', 'Flexible Budgets', 'Variance Analysis'],
    topicsAr: ['التنبؤ المتجدد', 'الموازنة المرنة', 'تحليل الانحرافات'],
    route: '/education/web/20',
    catalogId: 20,
  ),
  _EduModule(
    descEn:
        'Build forecasts that inform decisions: judgemental and statistical methods, regression on a driver, percent-of-sales statements, driver-based rolling forecasts, the 13-week cash forecast, and accuracy and bias.',
    descAr:
        'كيف نبني تنبؤات تخدم القرار: الأساليب التقديرية والإحصائية، والانحدار على مسبب، والقوائم المالية بطريقة النسبة المئوية من المبيعات، والتنبؤ المتجدد القائم على المسببات، وتنبؤ الثلاثة عشر أسبوعاً النقدي، وقياس الدقة والانحياز.',
    icon: Icons.insights_rounded,
    categoryEn: 'PLANNING',
    categoryAr: 'التخطيط',
    difficulty: 'intermediate',
    topicsEn: ['Forecasting Methods', '13-Week Cash Forecast', 'Accuracy & Bias'],
    topicsAr: ['أساليب التنبؤ', 'التنبؤ النقدي لثلاثة عشر أسبوعاً', 'الدقة والانحياز'],
    route: '/education/web/21',
    catalogId: 21,
  ),
  _EduModule(
    descEn:
        'Structure financial reports for the board, committees and lenders: answer first, a one-page executive summary, a well-ordered board pack, a few balanced KPIs and a recommendation that asks for a decision.',
    descAr:
        'كيف تبني التقارير المالية لمجلس الإدارة واللجان والمقرضين: الإجابة أولا، وملخص تنفيذي في صفحة واحدة، وحزمة تقارير مرتبة للمجلس، ومؤشرات أداء رئيسية قليلة ومتوازنة، وتوصية تطلب قرارا.',
    icon: Icons.co_present_rounded,
    categoryEn: 'REPORTING',
    categoryAr: 'التقارير',
    difficulty: 'intermediate',
    topicsEn: ['Executive Summary', 'Board Pack', 'Management Commentary'],
    topicsAr: ['الملخص التنفيذي', 'حزمة تقارير المجلس', 'تعليق الإدارة'],
    route: '/education/web/22',
    catalogId: 22,
  ),
];

<<<<<<< Updated upstream
/// Catalog ids of the hub cards in display order. Exposed so a test can pin the
/// registry to the catalog's non-simulation entries.
@visibleForTesting
List<int> get educationHubCardIds => _modules.map((m) => m.catalogId).toList();

final Map<int, _EduModule> _moduleById = {
  for (final m in _modules) m.catalogId: m,
};

/// The hub's cards under [plan]: exactly the plan's modules, in its order.
/// With no server plan that is the default core set (no library modules).
List<_EduModule> _modulesFor(ModulePlan plan) => [
      for (final n in plan.hubModuleNums)
        if (_moduleById[n] != null) _moduleById[n]!,
    ];

/// Catalog ids of the cards the hub draws under [plan], in display order.
@visibleForTesting
List<int> educationHubCardIdsFor(ModulePlan plan) =>
    _modulesFor(plan).map((m) => m.catalogId).toList();

/// Workshop tools have no Learn section and web-only modules keep theirs on the
/// website, so neither can gate the in-app progression chain or the sim gate.
bool _isToolOrWebOnly(_EduModule m) {
  final entry = catalogEntry(m.catalogId);
  return entry == null || !entry.isContent || !entry.inApp;
=======
/// A content module whose lessons are only on the website cannot be finished
/// in the app, so it never holds the in-app chain or the simulation back.
/// (Workshop tools DO gate now: opening one is what moves the chain past it.)
bool _isWebOnlyContent(int catalogId) {
  final entry = catalogEntry(catalogId);
  return entry != null && entry.isContent && !entry.inApp;
>>>>>>> Stashed changes
}

/// Pref key the module screen writes when a module's Learn section is done.
String _learnKey(String scope, int catalogId) => 'edu_module_${scope}_${catalogId}_learn';

// ---------------------------------------------------------------------------
// Main Screen
// ---------------------------------------------------------------------------
class EducationHubScreen extends ConsumerStatefulWidget {
  const EducationHubScreen({super.key});

  @override
  ConsumerState<EducationHubScreen> createState() => _EducationHubScreenState();
}

class _EducationHubScreenState extends ConsumerState<EducationHubScreen> {
  // Local progress tracking per module (key = "edu_progress_<catalogId>")
  final Map<int, int> _moduleProgress = {}; // catalogId -> completion %
  final Map<int, bool> _modulePassed = {};

  // From GET /education-modules/status (facilitator controls, corporate only):
  // the per-module force-open list, and the global Education switch — null
  // until it has answered, so nothing is locked on unknown state.
  List<int> _forceUnlocked = [];
  bool? _educationUnlocked;
  // GET /facilitator/simulation-access: the facilitator opened the game.
  bool _simAccessOpen = false;
  // GET /education/module-plan: this cohort's modules, null = the whole catalog.
  // Fails open (null) on any error.
  List<int>? _modulePlan;
  // Per-module Learn / workshop-visit flags, read from prefs for this learner's
  // progress scope ('sp' for self-paced, else the corporate team id).
  final Map<int, bool> _learnDone = {};
  final Set<int> _toolsVisited = {};
  Timer? _statusPollTimer;
<<<<<<< Updated upstream
=======
  Timer? _simAccessPollTimer;

  /// Module the learner last read a slide in, for the resume card.
  EducationCatalogEntry? _resumeEntry;
>>>>>>> Stashed changes

  bool get _isSelfPaced {
    final auth = ref.read(authProvider);
    return auth.user != null && !auth.isFacilitator;
  }

<<<<<<< Updated upstream
  /// The module plan in force: the cached or fallback plan straight away, the
  /// server's once it answers. Never awaited, so the hub never waits on it.
  ModulePlan get _plan => ref.read(modulePlanProvider);

  /// The cards this hub draws, in order.
  List<_EduModule> get _visible => _modulesFor(_plan);
=======
  bool get _isFacilitator => ref.read(authProvider).isFacilitator;

  /// The plan narrows cohort (corporate) hubs only: a self-paced member is an
  /// individual subscriber, so their hub is always the whole catalog (website).
  List<int>? get _effectivePlan => _isSelfPaced ? null : _modulePlan;

  /// Hub cards in this engagement, in hub order (simulation banner excluded).
  List<_EduModule> get _displayedModules =>
      _modules.where((m) => isModuleInPlan(m.catalogId, _effectivePlan)).toList();

  Set<int> get _progressive => progressiveUnlocked(
        displayed: _displayedModules.map((m) => m.catalogId).toList(),
        learnDone: (id) => _learnDone[id] ?? false,
        toolVisited: _toolsVisited.contains,
        passThrough: _isWebOnlyContent,
        plan: _effectivePlan,
      );

  /// The facilitator's global Education lock — the authoritative OFF switch for
  /// a corporate room (never for self-paced learners or the facilitator).
  bool get _educationGloballyLocked =>
      !_isSelfPaced && !_isFacilitator && _educationUnlocked == false;
>>>>>>> Stashed changes

  @override
  void initState() {
    super.initState();
    _loadProgress();
    _syncProgress();
<<<<<<< Updated upstream
    // A new plan changes the cards, the progression chain and the sim gate.
    ref.listenManual<ModulePlan>(modulePlanProvider, (prev, next) {
      if (prev != next && mounted) _loadProgress();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(modulePlanProvider.notifier).refresh();
      _checkMandatedAssessment();
    });
    if (_isSelfPaced) {
      // Self-paced: progressive unlock. Each module opens once the previous
      // module's Learn section is complete (website parity). _loadProgress
      // computes the set; seed the first module + tools so something is open.
      final visible = _visible;
      _selfPacedUnlocked = {
        if (visible.isNotEmpty) visible.first.catalogId,
        for (final m in visible)
          if (_isToolOrWebOnly(m)) m.catalogId,
      };
=======
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkMandatedAssessment());
    if (_isSelfPaced) {
>>>>>>> Stashed changes
      // Refresh entitlement (trial countdown / lapsed state) from /me so the
      // access banner reflects live billing state. /me is not gated, so this is
      // safe even for a lapsed learner. Fail-quiet — never blocks the hub.
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => ref.read(selfPacedProvider.notifier).fetchProgress(),
      );
    } else {
      _fetchModulePlan();
      _fetchEducationStatus();
      _statusPollTimer = Timer.periodic(
        const Duration(seconds: 5),
        (_) => _fetchEducationStatus(),
      );
      // The facilitator can open the game mid-session (website polls every 15s).
      _fetchSimulationAccess();
      _simAccessPollTimer = Timer.periodic(
        const Duration(seconds: 15),
        (_) => _fetchSimulationAccess(),
      );
    }
  }

  bool _assessmentPromptShown = false;

  /// Mirrors the website's AssessmentPrompt: if the facilitator has mandated a
  /// pre/post assessment the learner hasn't completed, surface it. When the
  /// assessment is mandated the dialog cannot be dismissed without taking it.
  Future<void> _checkMandatedAssessment() async {
    if (_assessmentPromptShown) return;
    for (final kind in const ['pre', 'post']) {
      try {
        final res = await ref
            .read(apiClientProvider)
            .get(ApiEndpoints.assessmentStatus, params: {'kind': kind});
        final mandated = res['mandated'] == true;
        final completed = res['completed'] == true;
        if (mandated && !completed && mounted) {
          _assessmentPromptShown = true;
          final s = ref.read(stringsProvider);
          final go = await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => AlertDialog(
              title: Text(kind == 'pre'
                  ? s.tr('Pre-Course Assessment Required', 'تقييم ما قبل الدورة مطلوب')
                  : s.tr('Post-Course Assessment Required', 'تقييم ما بعد الدورة مطلوب')),
              content: Text(s.tr(
                  'Your facilitator has asked you to complete this assessment before continuing.',
                  'طلب منك الميسّر إكمال هذا التقييم قبل المتابعة.')),
              actions: [
                FilledButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: Text(s.tr('Take Assessment', 'ابدأ التقييم')),
                ),
              ],
            ),
          );
          if (go == true && mounted) context.push('/assessment/$kind');
          return;
        }
      } catch (_) {
        // Status unavailable — no prompt.
      }
    }
  }

  @override
  void dispose() {
    _statusPollTimer?.cancel();
    _simAccessPollTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchEducationStatus() async {
    // The corporate simulation gate rides the same poll (the website refetches
    // it on an interval too), so the Sim banner opens when the facilitator does.
    ref.read(simulationAccessProvider.notifier).refresh();
    try {
      final api = ref.read(apiClientProvider);
      final res = await api.get(ApiEndpoints.educationModulesStatus);
      final modules = (res['educationModulesUnlocked'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ?? [];
      final globalOn = res['educationUnlocked'];
      if (mounted) {
        setState(() {
          _forceUnlocked = modules;
          if (globalOn is bool) _educationUnlocked = globalOn;
        });
      }
    } catch (_) {
      // Keep existing state on error
    }
  }

  Future<void> _fetchSimulationAccess() async {
    try {
      final res = await ref.read(apiClientProvider).get(ApiEndpoints.facilitatorSimulationAccess);
      if (mounted) setState(() => _simAccessOpen = res['open'] == true);
    } catch (_) {
      // Keep existing state on error
    }
  }

  /// The cohort's module plan. Fails open: any error leaves the whole catalog.
  Future<void> _fetchModulePlan() async {
    try {
      final res = await ref.read(apiClientProvider).get(ApiEndpoints.educationModulePlan);
      final plan = parseModulePlan(res);
      if (mounted) setState(() => _modulePlan = plan);
    } catch (_) {
      // Fail open — keep the whole catalog.
    }
  }

  /// A workshop tool counts as done once opened (website markToolVisited); the
  /// chain moves past it only after that, one tile at a time.
  Future<void> _markToolVisited(int catalogId) async {
    if (!(catalogEntry(catalogId)?.isWorkshop ?? false)) return;
    if (_toolsVisited.contains(catalogId)) return;
    final prefs = await SharedPreferences.getInstance();
    final scope = _isSelfPaced ? 'sp' : (prefs.getInt('edu_team_id') ?? 1).toString();
    await prefs.setBool(toolVisitedPrefKey(scope, catalogId), true);
    if (mounted) setState(() => _toolsVisited.add(catalogId));
  }

  /// Who this device's education progress belongs to on the server. Self-paced
  /// learners are keyed by email; corporate teams by "Team N", and only when
  /// this device actually signed in to a team, so a stray visitor never pulls a
  /// team's data down (website parity).
  Future<({String teamName, String scope})?> _progressIdentity() async {
    if (_isSelfPaced) {
      final email = ref.read(authProvider).user?.email ?? '';
      return email.isEmpty ? null : (teamName: email, scope: 'sp');
    }
    final prefs = await SharedPreferences.getInstance();
    final teamId = prefs.getInt('edu_team_id');
    if (teamId == null) return null;
    return (teamName: 'Team $teamId', scope: '$teamId');
  }

  /// Pull the saved progress from the database and push anything newer back, so
  /// work follows the learner across devices and between the website and the app.
  Future<void> _syncProgress() async {
    final id = await _progressIdentity();
    if (id == null) return;
    final changed = await ref
        .read(educationProgressSyncProvider)
        .sync(teamName: id.teamName, scope: id.scope);
    if (changed && mounted) await _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
<<<<<<< Updated upstream
    if (!mounted) return;
    final visible = _visible;
    final updated = <int, int>{};
    final passed = <int, bool>{};
    for (final m in visible) {
=======
    // Same scope the module screen writes: 'sp' for self-paced learners, else
    // the corporate team id.
    final scope = _isSelfPaced ? 'sp' : (prefs.getInt('edu_team_id') ?? 1).toString();
    final updated = <int, int>{};
    final passed = <int, bool>{};
    final learn = <int, bool>{};
    final visited = <int>{};
    for (final m in _modules) {
>>>>>>> Stashed changes
      updated[m.catalogId] =
          prefs.getInt('edu_progress_${m.catalogId}') ?? 0;
      passed[m.catalogId] =
          prefs.getBool('edu_passed_${m.catalogId}') ?? false;
<<<<<<< Updated upstream
    }
    // Recompute self-paced progressive unlocks from per-module Learn completion.
    final unlocked = <int>{};
    if (_isSelfPaced) {
      bool gateOpen = true; // the next content module is unlocked while open
      for (final m in visible) {
        final isTool = _isToolOrWebOnly(m); // no in-app Learn to gate on
        if (gateOpen || isTool) unlocked.add(m.catalogId);
        if (!isTool) {
          // Self-paced learners use the 'sp' progress scope (see edu_module_screen).
          final learnDone = prefs.getBool('edu_module_sp_${m.catalogId}_learn') ?? false;
          gateOpen = gateOpen && learnDone; // close the chain until this Learn is done
        }
=======
      learn[m.catalogId] = prefs.getBool(_learnKey(scope, m.catalogId)) ?? false;
      if (prefs.getBool(toolVisitedPrefKey(scope, m.catalogId)) ?? false) {
        visited.add(m.catalogId);
>>>>>>> Stashed changes
      }
    }
    // One-time migration: a learner already past the workshop tools (progress
    // from before visit-tracking, or restored on a new device) must not find
    // the chain re-locked behind them. Infer the visits and persist them.
    bool hasProgress(int id) =>
        (learn[id] ?? false) ||
        (updated[id] ?? 0) > 0 ||
        const ['game', 'quiz', 'sim']
            .any((a) => prefs.getBool('edu_module_${scope}_${id}_$a') ?? false);
    final inferred = inferToolsVisited(
      hubOrder: _modules.map((m) => m.catalogId).toList(),
      visited: visited,
      hasProgress: hasProgress,
    );
    for (final id in inferred.difference(visited)) {
      await prefs.setBool(toolVisitedPrefKey(scope, id), true);
    }
    visited
      ..clear()
      ..addAll(inferred);
    // "Continue where you left off" (website a2da32f). Runs after the hub's
    // progress sync, so a position saved on another device is already merged.
    final resume = await LearnResumeStore.lastResume(scope);
    final resumeId = resume?.catalogId;
    if (mounted) {
      setState(() {
<<<<<<< Updated upstream
        // Replaced, not merged, so a module the plan no longer shows stops
        // counting toward the totals.
        _moduleProgress
          ..clear()
          ..addAll(updated);
        _modulePassed
          ..clear()
          ..addAll(passed);
        if (_isSelfPaced) {
          _selfPacedUnlocked = unlocked;
          // gateOpen is still true only if every content module's Learn is done.
          _selfPacedSimUnlocked = _selfPacedSimGate(prefs);
        }
=======
        _resumeEntry = resumeId == null ? null : catalogEntry(resumeId);
        _moduleProgress.addAll(updated);
        _modulePassed.addAll(passed);
        _learnDone
          ..clear()
          ..addAll(learn);
        _toolsVisited
          ..clear()
          ..addAll(visited);
>>>>>>> Stashed changes
      });
    }
  }

<<<<<<< Updated upstream
  /// The game opens once every in-app content module the plan requires has
  /// its Learn section done; an optional module never holds it back.
  bool _selfPacedSimGate(SharedPreferences prefs) {
    for (final n in _plan.requiredInAppContentNums) {
      if (!(prefs.getBool('edu_module_sp_${n}_learn') ?? false)) return false;
    }
    return true;
=======
  /// "X of N complete" counts every displayed card — content modules AND the
  /// workshop tools, optional modules included, the game excluded (website).
  bool _isCardFinished(_EduModule m) {
    final entry = catalogEntry(m.catalogId);
    if (entry != null && entry.isWorkshop) return _toolsVisited.contains(m.catalogId);
    return _modulePassed[m.catalogId] ?? false;
>>>>>>> Stashed changes
  }

  int get _completedCount => _displayedModules.where(_isCardFinished).length;

  int get _totalCount => _displayedModules.length;

  int get _overallPercent {
<<<<<<< Updated upstream
    if (_moduleProgress.isEmpty) return 0;
    final total = _moduleProgress.values.fold<int>(0, (a, b) => a + b);
    final contentCount = _visible
=======
    final content = _displayedModules
>>>>>>> Stashed changes
        .where((m) => catalogEntry(m.catalogId)?.isContent ?? false)
        .toList();
    if (content.isEmpty) return 0;
    final total = content.fold<int>(0, (a, m) => a + (_moduleProgress[m.catalogId] ?? 0));
    return (total / content.length).round();
  }

  // 1 badge per passed content module.
  int get _badgeCount => _displayedModules
      .where((m) => (catalogEntry(m.catalogId)?.isContent ?? false) &&
          (_modulePassed[m.catalogId] ?? false))
      .length;

  /// Website isModuleUnlocked(): self-paced progressive (demo accounts see all,
  /// the simulation is open from the start); corporate progressive plus the
  /// facilitator's force-open list, under the global Education lock.
  bool _isUnlocked(int catalogId, {Set<int>? progressive}) {
    return isHubModuleUnlocked(
      catalogId,
      isSelfPaced: _isSelfPaced,
      progressive: progressive ?? _progressive,
      isDemoAccount: ref.read(isDemoAccountProvider),
      isFacilitator: _isFacilitator,
      simAccessOpen: _simAccessOpen,
      educationGloballyLocked: _educationGloballyLocked,
      forceUnlocked: _forceUnlocked,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Live facilitator Open/Close push (socket 'facilitator:simulation_access'); the
    // poll stays as the fallback.
    ref.listen<bool?>(simulationAccessProvider, (_, open) {
      if (open != null && open != _simAccessOpen) setState(() => _simAccessOpen = open);
    });
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final auth = ref.watch(authProvider);
    final teamState = ref.watch(teamProvider);
    final plan = ref.watch(modulePlanProvider);
    final modules = _modulesFor(plan);

<<<<<<< Updated upstream
    // The game (13) opens for a corporate room when the facilitator's
    // simulation switch is on, or on a facilitator's own device (website hub:
    // `progressiveUnlocked.has(13) || simAccessOpen || isFacilitatorSession`).
    final simGateOpen = ref.watch(simulationAccessProvider).valueOrNull == true;
    final unlockedModules =
        (simGateOpen || auth.isFacilitator) && !_unlockedModules.contains(13)
            ? [..._unlockedModules, 13]
            : _unlockedModules;
=======
    // Rebuild when /me reports a demo plan (every earned lock lifts).
    ref.watch(isDemoAccountProvider);
    final displayed = _displayedModules;
    final progressive = _progressive;
    // One unlock answer per card for this frame; 13 is the simulation.
    final unlocked = <int>{
      for (final m in displayed)
        if (_isUnlocked(m.catalogId, progressive: progressive)) m.catalogId,
      if (_isUnlocked(simulationCatalogId, progressive: progressive))
        simulationCatalogId,
    };
>>>>>>> Stashed changes

    final isSelfPaced =
        auth.user != null && !auth.isFacilitator && teamState.selectedTeam == null;
    final teamName = isSelfPaced
        ? (auth.user?.displayName ?? ref.watch(stringsProvider).tr('Self-Paced', 'التعلّم الذاتي'))
        : (teamState.selectedTeam?.name ?? '');

    // Lapsed self-paced learner (trial ended, no subscription, enforcement on): block the paid
    // modules and show an informational gate. Website parity (web redirects to /checkout); here
    // we point to the website to manage the plan — no in-app purchase UI (App Store policy).
    final entitlement = ref.watch(selfPacedProvider).entitlement;
    if (isSelfPaced && entitlement.isLapsed) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? [AppColors.darkBg, AppColors.darkSurface]
                  : [const Color(0xFFF0F4FF), const Color(0xFFF5F0FF), Colors.white],
            ),
          ),
          child: SafeArea(
            child: AccessEndedView(onBack: () => Navigator.of(context).maybePop()),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [AppColors.darkBg, AppColors.darkSurface]
                : [const Color(0xFFF0F4FF), const Color(0xFFF5F0FF), Colors.white],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Header ──
              SliverToBoxAdapter(
                child: _buildHeader(context, isSelfPaced,
                    simUnlocked: unlocked.contains(simulationCatalogId)),
              ),

              // ── Access banner (self-paced only): trial countdown / access-ended notice.
              //    Informational only — no purchase UI (web-only billing). ──
              if (isSelfPaced)
                const SliverToBoxAdapter(child: EntitlementBanner()),

              // ── Progress Section ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: _buildProgressCard(
                    context,
                    teamName: teamName,
<<<<<<< Updated upstream
                    unlockedModules: unlockedModules,
                    modules: modules,
=======
                    displayed: displayed,
                    unlocked: unlocked,
>>>>>>> Stashed changes
                  ),
                ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
              ),

              // ── Continue where you left off ──
              if (_resumeEntry != null && unlocked.contains(_resumeEntry!.num))
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: _buildResumeCard(context, _resumeEntry!),
                  ),
                ),

              // ── Module Cards Grid ──
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.58,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
<<<<<<< Updated upstream
                      final m = modules[index];
                      final isLocked = !_isUnlocked(m.catalogId, unlockedModules);
=======
                      final m = displayed[index];
                      final isLocked = !unlocked.contains(m.catalogId);
>>>>>>> Stashed changes
                      final completion = _moduleProgress[m.catalogId] ?? 0;
                      final passed = _modulePassed[m.catalogId] ?? false;
                      return _ModuleCard(
                        module: m,
                        isOptional: plan.isOptional(m.catalogId),
                        isLocked: isLocked,
                        completionPercent: completion,
                        isPassed: passed,
                        ar: ref.watch(stringsProvider).ar,
                        // Under the facilitator's global lock the reason is the
                        // facilitator; otherwise the learner's own progression.
                        lockedByFacilitator: _educationGloballyLocked,
                        // Refresh progressive unlocks when returning from a
<<<<<<< Updated upstream
                        // module, and push the new work to the server (this
                        // also pulls in work done on the website's module).
                        onTap: () => context
                            .push(moduleRouteFor(m.catalogId,
                                arabic: ref.read(stringsProvider).ar))
                            .then((_) {
                          if (mounted) {
                            _loadProgress();
                            _syncProgress();
                          }
                        }),
=======
                        // module, and push the new work to the server.
                        onTap: () {
                          _markToolVisited(m.catalogId);
                          context.push(m.route).then((_) {
                            if (mounted) {
                              _loadProgress();
                              _syncProgress();
                            }
                          });
                        },
>>>>>>> Stashed changes
                      ).animate().fadeIn(
                            delay: (300 + 60 * index).ms,
                            duration: 350.ms,
                          );
                    },
<<<<<<< Updated upstream
                    childCount: modules.length,
=======
                    childCount: displayed.length,
>>>>>>> Stashed changes
                  ),
                ),
              ),

              // ── Simulation Banner ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                  child: _buildSimulationBanner(
                    context,
                    isUnlocked: unlocked.contains(simulationCatalogId),
                    isSelfPaced: isSelfPaced,
                  ),
                ).animate().fadeIn(delay: 800.ms, duration: 400.ms),
              ),

              // ── Glossary & Certificate ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: _buildExtraButtons(context),
                ).animate().fadeIn(delay: 900.ms, duration: 400.ms),
              ),

              // ── Advanced Finance Tools ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                  child: _buildAdvancedTools(context),
                ).animate().fadeIn(delay: 950.ms, duration: 400.ms),
              ),

              // ── Assessment ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: _buildAssessment(context),
                ).animate().fadeIn(delay: 980.ms, duration: 400.ms),
              ),

              // ── Learning Path ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
                  child: _buildLearningPath(context),
                ).animate().fadeIn(delay: 1000.ms, duration: 400.ms),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Header — redesigned for corporate mode (no admin btn)
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildHeader(
    BuildContext context,
    bool isSelfPaced, {
    required bool simUnlocked,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final s = ref.watch(stringsProvider);
    final teamState = ref.watch(teamProvider);
    final team = teamState.selectedTeam;
    final teamColor = team != null
        ? (Color(int.parse('FF${(team.color ?? '#3B82F6').replaceFirst('#', '')}', radix: 16)))
        : AppColors.primaryLight;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      padding: const EdgeInsets.fromLTRB(4, 6, 8, 6),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurface.withValues(alpha: 0.8)
            : Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppColors.darkBorder.withValues(alpha: 0.2)
              : teamColor.withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: teamColor.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, size: 20),
            onPressed: () => context.pop(),
            visualDensity: VisualDensity.compact,
          ),

          // Title area
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        teamColor.withValues(alpha: 0.15),
                        teamColor.withValues(alpha: 0.08),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.school_rounded,
                      color: teamColor, size: 16),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      children: [
                        TextSpan(
                          text: 'Fin',
                          style: TextStyle(color: const Color(0xFF5793D6)),
                        ),
                        TextSpan(
                          text: 'Play',
                          style: TextStyle(color: const Color(0xFF243C76)),
                        ),
                        TextSpan(
                          text: s.tr(' Education', ' للتعليم'),
                          style: TextStyle(
                            color: AppColors.textPrimary(context),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Nav — Home + Simulation only (no admin)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _NavPill(
                icon: Icons.home_rounded,
                label: s.tr('Home', 'الرئيسية'),
                color: AppColors.primaryLight,
                // Self-paced learners go back to their progress landing, not the
                // corporate home (parity with where login dropped them).
                onTap: () => context.go(isSelfPaced ? '/self-paced-progress' : '/home'),
              ),
              const SizedBox(width: 6),
              _NavPill(
                icon: simUnlocked
                    ? Icons.play_arrow_rounded
                    : Icons.lock_rounded,
                label: s.tr('Sim', 'المحاكاة'),
                color: simUnlocked
                    ? AppColors.secondaryLight
                    : AppColors.lightTextTertiary,
                onTap: simUnlocked
                    ? () => context.push('/simulation')
                    : null,
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.1);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Progress Card
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildProgressCard(
    BuildContext context, {
    required String teamName,
<<<<<<< Updated upstream
    required List<int> unlockedModules,
    required List<_EduModule> modules,
=======
    required List<_EduModule> displayed,
    required Set<int> unlocked,
>>>>>>> Stashed changes
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final s = ref.watch(stringsProvider);
    final team = ref.watch(teamProvider).selectedTeam;
    final teamColor = team != null
        ? Color(int.parse('FF${(team.color ?? '#3B82F6').replaceFirst('#', '')}', radix: 16))
        : AppColors.primaryLight;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [AppColors.darkSurface, AppColors.darkCard]
              : [
                  teamColor.withValues(alpha: 0.06),
                  const Color(0xFFEEF2FF),
                  const Color(0xFFF5F0FF),
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppColors.darkBorder.withValues(alpha: 0.3)
              : teamColor.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: teamColor.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top row: Team + Title + Stats
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
            child: Column(
              children: [
                // Team badge + progress title
                Row(
                  children: [
                    // Team color dot + name
                    if (teamName.isNotEmpty) ...[
                      // Single-line truncating pill (website parity): a
                      // self-paced learner's full "First Last" name goes here,
                      // and must never overflow the header row.
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: teamColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: teamColor.withValues(alpha: 0.25)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: teamColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  teamName,
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: teamColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.school_rounded,
                          color: AppColors.primaryLight, size: 18),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        s.tr('Your Progress', 'تقدّمك'),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : const Color(0xFF1E3A8A),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Stats row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ProgressStat(
                      value: '$_completedCount',
<<<<<<< Updated upstream
                      sub: '/${modules.length}',
=======
                      sub: '/$_totalCount',
>>>>>>> Stashed changes
                      label: s.tr('Complete', 'مكتمل'),
                      color: AppColors.primaryLight,
                    ),
                    _VerticalDivider(),
                    _ProgressStat(
                      value: '$_badgeCount',
                      label: s.tr('Badges', 'الأوسمة'),
                      color: AppColors.accentLight,
                      icon: Icons.emoji_events_rounded,
                    ),
                    _VerticalDivider(),
                    _ProgressStat(
                      value: '$_overallPercent%',
                      label: s.tr('Overall', 'الإجمالي'),
                      color: const Color(0xFF6366F1),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Module progress grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.tr('MODULE PROGRESS', 'تقدّم الوحدات'),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    color: AppColors.textTertiary(context),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
<<<<<<< Updated upstream
                  children: List.generate(modules.length, (i) {
                    final m = modules[i];
                    final isUnlocked =
                        _isUnlocked(m.catalogId, unlockedModules);
=======
                  children: List.generate(displayed.length, (i) {
                    final m = displayed[i];
                    final isUnlocked = unlocked.contains(m.catalogId);
>>>>>>> Stashed changes
                    final completion =
                        _moduleProgress[m.catalogId] ?? 0;
                    final passed = _modulePassed[m.catalogId] ?? false;

                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
<<<<<<< Updated upstream
                          right: i < modules.length - 1 ? 4 : 0,
=======
                          right: i < displayed.length - 1 ? 4 : 0,
>>>>>>> Stashed changes
                        ),
                        child: Column(
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: !isUnlocked
                                      ? (isDark
                                          ? AppColors.darkCard
                                          : const Color(0xFFF1F5F9))
                                      : passed
                                          ? AppColors.secondaryLight
                                          : completion > 0
                                              ? const Color(0xFFFEF3C7)
                                              : (isDark
                                                  ? AppColors.darkSurface
                                                  : Colors.white),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: !isUnlocked
                                        ? (isDark
                                            ? AppColors.darkBorder
                                                .withValues(alpha: 0.3)
                                            : const Color(0xFFE2E8F0))
                                        : passed
                                            ? AppColors.secondaryLight
                                            : completion > 0
                                                ? const Color(0xFFFCD34D)
                                                : (isDark
                                                    ? AppColors.darkBorder
                                                        .withValues(alpha: 0.3)
                                                    : const Color(0xFFE2E8F0)),
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: passed
                                      ? const Icon(Icons.check_rounded,
                                          color: Colors.white, size: 16)
                                      : !isUnlocked
                                          ? Icon(Icons.lock_rounded,
                                              size: 12,
                                              color: AppColors.textTertiary(
                                                  context))
                                          // The module's icon, not a
                                          // number: modules are named by
                                          // title, which the tooltip gives.
                                          : Tooltip(
                                              message: s.ar
                                                  ? m.titleAr
                                                  : m.titleEn,
                                              child: Icon(
                                                m.icon,
                                                size: 12,
                                                color: completion > 0
                                                    ? const Color(0xFFB45309)
                                                    : AppColors.textSecondary(
                                                        context),
                                              ),
                                            ),
                                ),
                              ),
                            ),
                            if (completion > 0 &&
                                completion < 100 &&
                                isUnlocked) ...[
                              const SizedBox(height: 3),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(2),
                                child: SizedBox(
                                  height: 3,
                                  child: LinearProgressIndicator(
                                    value: completion / 100,
                                    backgroundColor: isDark
                                        ? AppColors.darkCard
                                        : const Color(0xFFE2E8F0),
                                    color: const Color(0xFFF59E0B),
                                  ),
                                ),
                              ),
                            ] else
                              const SizedBox(height: 6),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          // Legend
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _LegendDot(
                    color: AppColors.secondaryLight, label: s.tr('Complete', 'مكتمل')),
                const SizedBox(width: 16),
                _LegendDot(
                    color: const Color(0xFFFEF3C7),
                    borderColor: const Color(0xFFFCD34D),
                    label: s.tr('In Progress', 'قيد التقدّم')),
                const SizedBox(width: 16),
                _LegendDot(
                    color: const Color(0xFFF1F5F9),
                    borderColor: const Color(0xFFE2E8F0),
                    label: s.tr('Locked', 'مقفل')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Simulation Banner
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildSimulationBanner(BuildContext context,
      {required bool isUnlocked, required bool isSelfPaced}) {
    final s = ref.watch(stringsProvider);
    return GestureDetector(
      onTap: isUnlocked
          ? () {
              HapticFeedback.lightImpact();
              context.push('/simulation');
            }
          : null,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isUnlocked
                ? [const Color(0xFF2563EB), const Color(0xFF4338CA)]
                : [const Color(0xFF9CA3AF), const Color(0xFF6B7280)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: (isUnlocked
                      ? const Color(0xFF2563EB)
                      : const Color(0xFF9CA3AF))
                  .withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                isUnlocked ? Icons.play_arrow_rounded : Icons.lock_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.tr('Finance Simulation Game', 'لعبة المحاكاة المالية'),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    s.tr('Apply what you learned across 3 rounds of strategic decisions',
                        'طبّق ما تعلّمته عبر 3 جولات من القرارات الاستراتيجية'),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _SimBadge(s.tr('Financing', 'التمويل')),
                      _SimBadge(s.tr('Investing', 'الاستثمار')),
                      _SimBadge(s.tr('Operating', 'التشغيل')),
                    ],
                  ),
                ],
              ),
            ),
            if (isUnlocked)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  s.tr('Enter', 'ادخل'),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2563EB),
                  ),
                ),
              )
            else
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_rounded,
                      size: 14,
                      color: Colors.white.withValues(alpha: 0.7)),
                  const SizedBox(width: 4),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 110),
                    child: Text(
                      // Corporate: earned by finishing the modules, or opened by
                      // the facilitator. (Self-paced learners are never locked.)
                      isSelfPaced
                          ? s.tr('Locked', 'مقفل')
                          : s.tr('Complete all modules to unlock',
                              'أكمل جميع الوحدات لفتح المحاكاة'),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildResumeCard(BuildContext context, EducationCatalogEntry entry) {
    final s = ref.watch(stringsProvider);
    return _ExtraButton(
      icon: Icons.play_circle_fill_rounded,
      label: s.tr('Continue where you left off', 'تابع من حيث توقفت'),
      sublabel: s.tr(entry.titleEn, entry.titleAr),
      color: AppColors.primaryLight,
      // The module and deck screens reopen at the saved slide themselves.
      onTap: () => context.push(entry.route),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Daily Practice, Glossary, Knowledge Base & Certificate
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildExtraButtons(BuildContext context) {
    final s = ref.watch(stringsProvider);
    return Column(
      children: [
        _ExtraButton(
          icon: Icons.local_fire_department_rounded,
          label: s.tr('Daily Practice', 'التدريب اليومي'),
          sublabel: s.tr('Term Trainer', 'مدرب المصطلحات'),
          color: AppColors.warning,
          onTap: () => showDailyPractice(context),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ExtraButton(
                icon: Icons.menu_book_rounded,
                label: s.tr('Glossary', 'المصطلحات'),
                sublabel: s.tr('${financialTerms.length} terms', '${financialTerms.length} مصطلحًا'),
                color: AppColors.accentLight,
                onTap: () => context.push('/education/glossary'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ExtraButton(
                icon: Icons.auto_stories_rounded,
                label: s.tr('Knowledge Base', 'قاعدة المعرفة'),
                sublabel: s.tr('Articles & standards', 'مقالات ومعايير'),
                color: AppColors.primaryLight,
                onTap: () => context.push('/knowledge'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Certificate — full width. The screen itself handles every state (progress while
        // incomplete, the award once earned, revoked, or access-lapsed), so it is always
        // reachable rather than appearing only after completion. A learner who finished the
        // work previously had no way to collect it on iOS at all.
        _ExtraButton(
          icon: Icons.workspace_premium_rounded,
          label: s.tr('Certificate', 'الشهادة'),
          sublabel: s.tr('Your completion award', 'شهادة إتمام البرنامج'),
          color: AppColors.secondaryLight,
          onTap: () => context.push('/education/certificate'),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Advanced Finance Tools
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildAdvancedTools(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final tools = <({IconData icon, String label, Color color, String route})>[
      (icon: Icons.percent_rounded, label: s.tr('WACC', 'تكلفة رأس المال'), color: AppColors.primaryLight, route: '/education/wacc'),
      (icon: Icons.analytics_rounded, label: s.tr('DuPont', 'دوبونت'), color: AppColors.secondaryLight, route: '/education/dupont'),
      (icon: Icons.timelapse_rounded, label: s.tr('Working Capital', 'رأس المال العامل'), color: AppColors.accentLight, route: '/education/working-capital'),
      (icon: Icons.workspace_premium_rounded, label: s.tr('Credit Rating', 'التصنيف الائتماني'), color: AppColors.info, route: '/education/credit-rating'),
      (icon: Icons.gavel_rounded, label: s.tr('Covenants', 'التعهدات'), color: AppColors.dangerLight, route: '/education/covenants'),
      (icon: Icons.pie_chart_rounded, label: s.tr('Cap Table', 'جدول الملكية'), color: AppColors.purple, route: '/education/cap-table'),
      (icon: Icons.payments_rounded, label: s.tr('Dividends', 'التوزيعات'), color: AppColors.warning, route: '/education/dividends'),
      (icon: Icons.bar_chart_rounded, label: s.tr('Ratios', 'النسب'), color: AppColors.primaryDark, route: '/education/ratios'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              s.tr('Advanced Finance Tools', 'أدوات مالية متقدمة'),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary(context),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.purple.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(s.tr('OPTIONAL', 'اختياري'),
                  style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: AppColors.purple)),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          s.tr('Interactive calculators for the realism modules',
              'حاسبات تفاعلية لوحدات الواقعية'),
          style: TextStyle(fontSize: 11, color: AppColors.textTertiary(context)),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.82,
          children: tools
              .map((t) => _ToolTile(
                    icon: t.icon,
                    label: t.label,
                    color: t.color,
                    onTap: () => context.push(t.route),
                  ))
              .toList(),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Assessment
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildAssessment(BuildContext context) {
    final s = ref.watch(stringsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          s.tr('Assessment', 'التقييم'),
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary(context),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ExtraButton(
                icon: Icons.quiz_rounded,
                label: s.tr('Pre-Course Test', 'اختبار ما قبل الدورة'),
                sublabel: s.tr('Baseline check', 'فحص الأساس'),
                color: AppColors.primaryLight,
                onTap: () => context.push('/assessment/pre'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ExtraButton(
                icon: Icons.fact_check_rounded,
                label: s.tr('Post-Course Test', 'اختبار ما بعد الدورة'),
                sublabel: s.tr('Measure progress', 'قياس التقدّم'),
                color: AppColors.secondaryLight,
                onTap: () => context.push('/assessment/post'),
              ),
            ),
          ],
        ),
<<<<<<< Updated upstream
        // No research tile: FinPlay does not collect the DBA study's data.
        // The website removed the consent and instrument flow; study
        // instruments are answered on a separate anonymous platform.
=======
>>>>>>> Stashed changes
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Learning Path
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildLearningPath(BuildContext context) {
    final s = ref.watch(stringsProvider);
    return Column(
      children: [
        Text(
          s.tr('Suggested Learning Path', 'مسار التعلّم المقترح'),
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary(context),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          s.tr('Start with foundational modules then progress to advanced topics',
              'ابدأ بالوحدات الأساسية ثم تقدّم إلى المواضيع المتقدمة'),
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textTertiary(context),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Stages only: no module number ranges (modules are named by title).
            _PathBadge(s.tr('Foundations', 'الأساسيات'), AppColors.secondaryLight,
                AppColors.secondarySurface),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Icon(Icons.arrow_forward_rounded,
                  size: 14, color: AppColors.textTertiary(context)),
            ),
            _PathBadge(s.tr('Analysis', 'التحليل'), AppColors.primaryLight,
                AppColors.primarySurface),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Icon(Icons.arrow_forward_rounded,
                  size: 14, color: AppColors.textTertiary(context)),
            ),
            _PathBadge(
                s.tr('Advanced', 'المتقدّم'),
                const Color(0xFF7C3AED),
                const Color(0xFFEDE9FE)),
          ],
        ),
      ],
    );
  }
}

// ===========================================================================
// Sub-widgets
// ===========================================================================

// ---------------------------------------------------------------------------
// Module Card (matches website design)
// ---------------------------------------------------------------------------
class _ModuleCard extends StatefulWidget {
  final _EduModule module;

  /// Marked optional by the module plan: shown and scored, not required.
  final bool isOptional;
  final bool isLocked;
  final int completionPercent;
  final bool isPassed;
  final bool ar;
  final bool lockedByFacilitator;
  final VoidCallback? onTap;

  const _ModuleCard({
    required this.module,
    this.isOptional = false,
    required this.isLocked,
    required this.completionPercent,
    required this.isPassed,
    required this.ar,
    this.lockedByFacilitator = false,
    this.onTap,
  });

  @override
  State<_ModuleCard> createState() => _ModuleCardState();
}

class _ModuleCardState extends State<_ModuleCard> {
  bool _pressed = false;

  Color get _diffColor {
    switch (widget.module.difficulty) {
      case 'beginner':
        return const Color(0xFF16A34A); // green-600
      case 'intermediate':
        return const Color(0xFF1E40AF); // blue-800 (matches website)
      case 'advanced':
        return const Color(0xFF6B21A8); // purple-800 (matches website)
      default:
        return const Color(0xFF1E40AF);
    }
  }

  Color get _diffBg {
    switch (widget.module.difficulty) {
      case 'beginner':
        return const Color(0xFFDCFCE7); // green-100
      case 'intermediate':
        return const Color(0xFFDBEAFE); // blue-100 (matches website)
      case 'advanced':
        return const Color(0xFFF3E8FF); // purple-100 (matches website)
      default:
        return const Color(0xFFDBEAFE);
    }
  }

  /// The category, with the optional mark when the plan makes the module
  /// optional.
  String get _categoryLabel {
    final m = widget.module;
    final category = widget.ar ? m.categoryAr : m.categoryEn;
    if (!widget.isOptional) return category;
    return widget.ar ? '$category · اختيارية' : '$category · OPTIONAL';
  }

  String get _diffLabel {
    final ar = widget.ar;
    switch (widget.module.difficulty) {
      case 'beginner':
        return ar ? 'مبتدئ' : 'Beginner';
      case 'intermediate':
        return ar ? 'متوسط' : 'Intermediate';
      case 'advanced':
        return ar ? 'متقدّم' : 'Advanced';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final m = widget.module;
    final progressFraction = widget.completionPercent / 100.0;

    return GestureDetector(
      onTapDown: widget.isLocked ? null : (_) => setState(() => _pressed = true),
      onTapUp: widget.isLocked
          ? null
          : (_) {
              setState(() => _pressed = false);
              HapticFeedback.lightImpact();
              if (widget.onTap != null) {
                widget.onTap!();
              } else {
                context.push(moduleRouteFor(m.catalogId, arabic: widget.ar));
              }
            },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _pressed
                  ? _diffColor.withValues(alpha: 0.5)
                  : (isDark
                      ? AppColors.darkBorder.withValues(alpha: 0.3)
                      : const Color(0xFFE2E8F0)),
              width: _pressed ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _pressed
                    ? _diffColor.withValues(alpha: 0.12)
                    : Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
                blurRadius: _pressed ? 12 : 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Card content
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category tag + Difficulty badge row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.accentSurface,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _categoryLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                                color: AppColors.accentDark,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        // Difficulty badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: _diffBg,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: _diffColor.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            _diffLabel,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: _diffColor,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Icon row
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: widget.isPassed
                                ? AppColors.secondarySurface
                                : AppColors.primarySurface,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            m.icon,
                            size: 22,
                            color: widget.isPassed
                                ? AppColors.secondaryLight
                                : AppColors.primaryLight,
                          ),
                        ),
                        const Spacer(),
                        // Status badge (no module number: modules are named
                        // by title) with completion checkmark
                        SizedBox(
                          width: 32,
                          height: 32,
                          child: Stack(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: widget.isPassed
                                      ? AppColors.secondaryLight
                                      : AppColors.primaryLight,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: (widget.isPassed
                                              ? AppColors.secondaryLight
                                              : AppColors.primaryLight)
                                          .withValues(alpha: 0.3),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Icon(
                                    widget.isPassed
                                        ? Icons.emoji_events_rounded
                                        : Icons.play_arrow_rounded,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              // Green checkmark overlay when passed
                              if (widget.isPassed)
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF16A34A),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isDark
                                            ? AppColors.darkSurface
                                            : Colors.white,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.check_rounded,
                                      color: Colors.white,
                                      size: 10,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Title
                    Text(
                      widget.ar ? m.titleAr : m.titleEn,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary(context),
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // Description
                    Text(
                      widget.ar ? m.descAr : m.descEn,
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.3,
                        color: AppColors.textSecondary(context),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 6),

                    // Topics preview — outline badges (matches website)
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: (widget.ar ? m.topicsAr : m.topicsEn).take(3).map(
                        (t) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.darkBorder.withValues(alpha: 0.4)
                                  : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Text(
                            t,
                            style: TextStyle(
                              fontSize: 9,
                              color: AppColors.textTertiary(context),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ).toList(),
                    ),

                    const Spacer(),

                    // Progress bar — always visible as track
                    Row(
                      children: [
                        Text(
                          widget.completionPercent > 0
                              ? (widget.ar ? 'التقدّم' : 'Progress')
                              : (widget.ar ? 'لم يبدأ' : 'Not started'),
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.textTertiary(context),
                          ),
                        ),
                        const Spacer(),
                        if (widget.completionPercent > 0)
                          Text(
                            '${widget.completionPercent}%',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: widget.isPassed
                                  ? const Color(0xFF16A34A)
                                  : AppColors.primaryLight,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: SizedBox(
                        height: 4,
                        child: LinearProgressIndicator(
                          value: progressFraction,
                          backgroundColor: isDark
                              ? AppColors.darkCard
                              : const Color(0xFFE2E8F0),
                          color: widget.isPassed
                              ? const Color(0xFF16A34A) // green when passed
                              : progressFraction > 0
                                  ? const Color(0xFF2563EB) // blue when in-progress (matches website)
                                  : Colors.transparent,
                        ),
                      ),
                    ),

                    // Locked text
                    if (widget.isLocked) ...[
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lock_rounded,
                              size: 11,
                              color: AppColors.textTertiary(context)),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              widget.lockedByFacilitator
                                  ? (widget.ar ? 'مقفل من قبل الميسّر' : 'Locked by facilitator')
                                  : (widget.ar
                                      ? 'أكمل الوحدة السابقة لفتحها'
                                      : 'Complete the previous module to unlock'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.textTertiary(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Semi-transparent dark lock overlay
              if (widget.isLocked)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: (isDark
                              ? Colors.black
                              : const Color(0xFF1E293B))
                          .withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkCard
                              : Colors.white.withValues(alpha: 0.92),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Icon(Icons.lock_rounded,
                            size: 22,
                            color: AppColors.textTertiary(context)),
                      ),
                    ),
                  ),
                ),

              // Bottom progress bar — thin colored strip at very bottom
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  child: SizedBox(
                    height: 4,
                    child: LinearProgressIndicator(
                      value: progressFraction,
                      backgroundColor: Colors.transparent,
                      color: widget.isPassed
                          ? const Color(0xFF16A34A) // green when passed
                          : progressFraction > 0
                              ? const Color(0xFF2563EB) // blue when in-progress
                              : Colors.transparent,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Small helper widgets
// ---------------------------------------------------------------------------

class _NavPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _NavPill({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        opacity: onTap != null ? 1.0 : 0.45,
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isDark
                ? color.withValues(alpha: 0.15)
                : color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressStat extends StatelessWidget {
  final String value;
  final String? sub;
  final String label;
  final Color color;
  final IconData? icon;

  const _ProgressStat({
    required this.value,
    this.sub,
    required this.label,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              if (sub != null)
                Text(
                  sub!,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textTertiary(context),
                  ),
                ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 10, color: AppColors.textTertiary(context)),
                const SizedBox(width: 2),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textTertiary(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 28,
      color: const Color(0xFFBFDBFE),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final Color? borderColor;
  final String label;

  const _LegendDot({
    required this.color,
    this.borderColor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
            border: borderColor != null
                ? Border.all(color: borderColor!, width: 1)
                : null,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: AppColors.textTertiary(context),
          ),
        ),
      ],
    );
  }
}

class _SimBadge extends StatelessWidget {
  final String label;
  const _SimBadge(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _ExtraButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final Color color;
  final VoidCallback onTap;

  const _ExtraButton({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark
                ? AppColors.darkBorder.withValues(alpha: 0.3)
                : color.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.1 : 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  Text(
                    sublabel,
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.textTertiary(context),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: AppColors.textTertiary(context)),
          ],
        ),
      ),
    );
  }
}

class _ToolTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ToolTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark
                ? AppColors.darkBorder.withValues(alpha: 0.3)
                : color.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9.5,
                height: 1.15,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PathBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color bg;

  const _PathBadge(this.label, this.color, this.bg);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
