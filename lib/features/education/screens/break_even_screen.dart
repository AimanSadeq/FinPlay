import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/app_colors.dart';
import '../../../providers/repository_providers.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../app/i18n/app_strings.dart';

// ──────────────────────────────────────────────────────────────────────────────
// Data models
// ──────────────────────────────────────────────────────────────────────────────

class _LearnSlide {
  final String title;
  final IconData icon;
  final String description;
  final List<String> formulas;
  final Color color;

  const _LearnSlide({
    required this.title,
    required this.icon,
    required this.description,
    this.formulas = const [],
    required this.color,
  });
}

class _PracticeScenario {
  final String title;
  final String city;
  final String currency;
  final String difficulty;
  final Color difficultyColor;
  final String description;
  final List<_CostItem> variableCosts;
  final double pricePerUnit;
  final double totalVariableCost;
  final double fixedCosts;
  final String fixedCostsBreakdown;
  final double bep;
  final String bepLabel;
  final String bepDetail;
  final bool isMultiProduct;
  final List<_ProductMix>? products;
  final double? weightedCM;

  const _PracticeScenario({
    required this.title,
    required this.city,
    required this.currency,
    required this.difficulty,
    required this.difficultyColor,
    required this.description,
    this.variableCosts = const [],
    this.pricePerUnit = 0,
    this.totalVariableCost = 0,
    required this.fixedCosts,
    this.fixedCostsBreakdown = '',
    required this.bep,
    required this.bepLabel,
    this.bepDetail = '',
    this.isMultiProduct = false,
    this.products,
    this.weightedCM,
  });
}

class _CostItem {
  final String name;
  final double cost;
  const _CostItem(this.name, this.cost);
}

class _ProductMix {
  final String name;
  final double price;
  final double cm;
  final double mixPercent;
  const _ProductMix(this.name, this.price, this.cm, this.mixPercent);
}

// ──────────────────────────────────────────────────────────────────────────────
// Static data
// ──────────────────────────────────────────────────────────────────────────────

List<_LearnSlide> _buildSlides(AppStrings s) => <_LearnSlide>[
  _LearnSlide(
    title: s.tr('What is Break-Even Analysis?', 'ما هو تحليل نقطة التعادل؟'),
    icon: Icons.balance_rounded,
    color: AppColors.primaryLight,
    description: s.tr(
        'The point where total revenue equals total costs. No profit, no loss. Essential for business planning and pricing decisions.',
        'النقطة التي يتساوى عندها إجمالي الإيرادات مع إجمالي التكاليف. لا ربح ولا خسارة. أساسية لتخطيط الأعمال وقرارات التسعير.'),
    formulas: const ['Revenue = Total Costs', 'Profit = 0'],
  ),
  _LearnSlide(
    title: s.tr('Understanding Fixed Costs', 'فهم التكاليف الثابتة'),
    icon: Icons.lock_rounded,
    color: const Color(0xFFEF4444),
    description: s.tr(
        'Costs that remain constant regardless of production: rent, salaries, insurance, depreciation. Must be paid whether you sell 0 or 10,000 units.',
        'تكاليف تبقى ثابتة بغض النظر عن حجم الإنتاج: الإيجار والرواتب والتأمين والإهلاك. يجب دفعها سواء بعت صفر وحدة أو 10,000 وحدة.'),
    formulas: const ['Examples: Rent, Salaries, Insurance', 'Fixed Costs stay the same at any volume'],
  ),
  _LearnSlide(
    title: s.tr('Understanding Variable Costs', 'فهم التكاليف المتغيرة'),
    icon: Icons.show_chart_rounded,
    color: const Color(0xFFF59E0B),
    description: s.tr(
        'Costs that change proportionally with production: raw materials, direct labor, commissions, packaging. Increase as you produce more.',
        'تكاليف تتغير بتناسب مع الإنتاج: المواد الخام والعمالة المباشرة والعمولات والتغليف. تزداد كلما أنتجت أكثر.'),
    formulas: const ['Total VC = VC per Unit × Quantity', 'More production → Higher variable costs'],
  ),
  _LearnSlide(
    title: s.tr('Contribution Margin', 'هامش المساهمة'),
    icon: Icons.pie_chart_rounded,
    color: AppColors.secondaryLight,
    description: s.tr(
        'The amount each unit sale contributes toward covering fixed costs. A higher CM means each sale gets you closer to break-even faster.',
        'المبلغ الذي تساهم به كل وحدة مباعة في تغطية التكاليف الثابتة. كلما ارتفع هامش المساهمة اقتربت كل عملية بيع من نقطة التعادل أسرع.'),
    formulas: const [
      'CM = Selling Price − Variable Cost per Unit',
      'CM Ratio = CM / Price',
    ],
  ),
  _LearnSlide(
    title: s.tr('Calculating Break-Even Point', 'حساب نقطة التعادل'),
    icon: Icons.calculate_rounded,
    color: const Color(0xFF8B5CF6),
    description: s.tr(
        'The core formulas for determining exactly how many units you need to sell, or how much revenue you need, to cover all costs.',
        'المعادلات الأساسية لتحديد عدد الوحدات التي تحتاج لبيعها بالضبط، أو حجم الإيراد المطلوب، لتغطية جميع التكاليف.'),
    formulas: const [
      'BEP (units) = Fixed Costs / CM',
      'BEP (revenue) = Fixed Costs / CM Ratio',
      'Target Profit: (FC + Target) / CM',
    ],
  ),
  _LearnSlide(
    title: s.tr('The Break-Even Chart', 'مخطط نقطة التعادل'),
    icon: Icons.auto_graph_rounded,
    color: const Color(0xFF06B6D4),
    description: s.tr(
        'Visual CVP diagram showing revenue line, total cost line, and fixed cost line. The intersection is your break-even point. Area above = profit zone, below = loss zone.',
        'مخطط بياني للعلاقة بين التكلفة والحجم والربح يُظهر خط الإيرادات وخط إجمالي التكاليف وخط التكاليف الثابتة. نقطة التقاطع هي نقطة التعادل. المنطقة فوقها = منطقة ربح، وتحتها = منطقة خسارة.'),
    formulas: const ['Revenue Line: y = Price × x', 'Total Cost Line: y = FC + (VC × x)'],
  ),
  _LearnSlide(
    title: s.tr('Margin of Safety', 'هامش الأمان'),
    icon: Icons.shield_rounded,
    color: const Color(0xFF10B981),
    description: s.tr(
        'Shows how much sales can decline before reaching break-even. A higher margin of safety means lower risk for the business.',
        'يوضح مقدار الانخفاض الممكن في المبيعات قبل الوصول إلى نقطة التعادل. كلما ارتفع هامش الأمان انخفضت مخاطر المنشأة.'),
    formulas: const [
      'MOS = (Actual − BEP) / Actual × 100%',
      'Higher MOS = Lower Risk',
    ],
  ),
  _LearnSlide(
    title: s.tr('Multi-Product Break-Even', 'نقطة التعادل متعددة المنتجات'),
    icon: Icons.category_rounded,
    color: const Color(0xFFEC4899),
    description: s.tr(
        'When selling multiple products, calculate a weighted average contribution margin using each product\'s sales mix percentage.',
        'عند بيع منتجات متعددة، احسب متوسطًا مرجحًا لهامش المساهمة باستخدام نسبة مزيج مبيعات كل منتج.'),
    formulas: const [
      'Weighted CM = Σ(CM × Sales Mix %)',
      'BEP = Fixed Costs / Weighted Avg CM',
    ],
  ),
  _LearnSlide(
    title: s.tr('Sensitivity Analysis', 'تحليل الحساسية'),
    icon: Icons.tune_rounded,
    color: const Color(0xFFF97316),
    description: s.tr(
        'What-if scenarios: How does BEP change with ±10% price change? ±20% fixed cost change? Helps identify which variables have the most impact on profitability.',
        'سيناريوهات افتراضية: كيف تتغير نقطة التعادل مع تغير السعر بنسبة ±10%؟ أو تغير التكاليف الثابتة بنسبة ±20%؟ يساعد على تحديد المتغيرات الأكثر تأثيرًا على الربحية.'),
    formulas: const [
      'Test: Price ±10%, FC ±20%, VC ±15%',
      'Identify most sensitive variable',
    ],
  ),
  _LearnSlide(
    title: s.tr('Key Takeaways', 'أبرز النقاط'),
    icon: Icons.emoji_events_rounded,
    color: const Color(0xFFD97706),
    description: s.tr(
        'BEP is a critical planning tool. Lower fixed costs or raise contribution margin to lower BEP. Monitor margin of safety. Use sensitivity analysis for risk assessment.',
        'نقطة التعادل أداة تخطيط أساسية. خفّض التكاليف الثابتة أو ارفع هامش المساهمة لخفض نقطة التعادل. راقب هامش الأمان. استخدم تحليل الحساسية لتقييم المخاطر.'),
    formulas: const [
      '↓ Fixed Costs → ↓ BEP',
      '↑ CM → ↓ BEP',
      'Always monitor Margin of Safety',
    ],
  ),
];

List<_PracticeScenario> _buildPracticeScenarios(AppStrings s) => <_PracticeScenario>[
  _PracticeScenario(
    title: s.tr('Coffee Shop', 'مقهى'),
    city: 'Dubai',
    currency: 'AED',
    difficulty: s.tr('Beginner', 'مبتدئ'),
    difficultyColor: AppColors.secondaryLight,
    description: s.tr('A specialty coffee shop in Dubai Marina selling premium lattes.',
        'مقهى متخصص في دبي مارينا يبيع اللاتيه الفاخر.'),
    pricePerUnit: 22,
    totalVariableCost: 7,
    variableCosts: [
      _CostItem(s.tr('Beans', 'البُن'), 3),
      _CostItem(s.tr('Milk', 'الحليب'), 2),
      _CostItem(s.tr('Cup', 'الكوب'), 1),
      _CostItem(s.tr('Sugar', 'السكر'), 0.5),
      _CostItem(s.tr('Napkin', 'المناديل'), 0.5),
    ],
    fixedCosts: 33000,
    fixedCostsBreakdown: s.tr('Rent, staff, equipment lease, utilities',
        'الإيجار، والموظفون، وإيجار المعدات، والمرافق'),
    bep: 2200,
    bepLabel: s.tr('2,200 cups/month', '2,200 كوب/شهر'),
    bepDetail: s.tr('≈ 74 cups/day', '≈ 74 كوب/يوم'),
  ),
  _PracticeScenario(
    title: s.tr('Car Wash', 'مغسلة سيارات'),
    city: 'Riyadh',
    currency: 'SAR',
    difficulty: s.tr('Beginner', 'مبتدئ'),
    difficultyColor: AppColors.secondaryLight,
    description: s.tr('A full-service car wash facility near King Fahd Road.',
        'مغسلة سيارات متكاملة الخدمات قرب طريق الملك فهد.'),
    pricePerUnit: 40,
    totalVariableCost: 12,
    variableCosts: [
      _CostItem(s.tr('Water', 'الماء'), 5),
      _CostItem(s.tr('Shampoo', 'الشامبو'), 3),
      _CostItem(s.tr('Wax', 'الشمع'), 2.5),
      _CostItem(s.tr('Towels', 'المناشف'), 1.5),
    ],
    fixedCosts: 30000,
    fixedCostsBreakdown: s.tr('Rent, equipment, staff wages',
        'الإيجار، والمعدات، وأجور الموظفين'),
    bep: 1072,
    bepLabel: s.tr('1,072 washes/month', '1,072 غسلة/شهر'),
    bepDetail: s.tr('≈ 36 washes/day', '≈ 36 غسلة/يوم'),
  ),
  _PracticeScenario(
    title: s.tr('Food Truck', 'عربة طعام'),
    city: 'Jeddah',
    currency: 'SAR',
    difficulty: s.tr('Beginner', 'مبتدئ'),
    difficultyColor: AppColors.secondaryLight,
    description: s.tr('A shawarma food truck operating along the Jeddah Corniche.',
        'عربة شاورما تعمل على كورنيش جدة.'),
    pricePerUnit: 25,
    totalVariableCost: 10,
    variableCosts: [
      _CostItem(s.tr('Chicken', 'الدجاج'), 4),
      _CostItem(s.tr('Bread', 'الخبز'), 1.5),
      _CostItem(s.tr('Vegetables', 'الخضار'), 2),
      _CostItem(s.tr('Sauces', 'الصلصات'), 1),
      _CostItem(s.tr('Packaging', 'التغليف'), 1.5),
    ],
    fixedCosts: 17000,
    fixedCostsBreakdown: s.tr('Truck lease, permit, driver salary',
        'إيجار العربة، والتصريح، وراتب السائق'),
    bep: 1134,
    bepLabel: s.tr('1,134 wraps/month', '1,134 لفافة/شهر'),
    bepDetail: s.tr('≈ 46 wraps/day', '≈ 46 لفافة/يوم'),
  ),
  _PracticeScenario(
    title: s.tr('Beauty Salon', 'صالون تجميل'),
    city: 'Abu Dhabi',
    currency: 'AED',
    difficulty: s.tr('Intermediate', 'متوسط'),
    difficultyColor: AppColors.accentLight,
    description: s.tr('A multi-service beauty salon on Al Maryah Island.',
        'صالون تجميل متعدد الخدمات في جزيرة الماريّة.'),
    isMultiProduct: true,
    products: [
      _ProductMix(s.tr('Haircut', 'قص الشعر'), 150, 120, 50),
      _ProductMix(s.tr('Makeup', 'المكياج'), 250, 180, 30),
      _ProductMix(s.tr('Mani/Pedi', 'عناية الأظافر'), 120, 95, 20),
    ],
    fixedCosts: 50000,
    fixedCostsBreakdown: s.tr('Rent 25k, Stylists 14k, Reception 6k, Utilities 3k, Insurance 2k',
        'الإيجار 25 ألفًا، المصففون 14 ألفًا، الاستقبال 6 آلاف، المرافق 3 آلاف، التأمين ألفان'),
    weightedCM: 133,
    bep: 376,
    bepLabel: s.tr('376 services/month', '376 خدمة/شهر'),
    bepDetail: s.tr('≈ 13 services/day', '≈ 13 خدمة/يوم'),
  ),
  _PracticeScenario(
    title: s.tr('Gym', 'نادٍ رياضي'),
    city: 'Jeddah',
    currency: 'SAR',
    difficulty: s.tr('Intermediate', 'متوسط'),
    difficultyColor: AppColors.accentLight,
    description: s.tr('A fitness center with tiered membership plans.',
        'مركز لياقة بدنية بخطط عضوية متدرّجة.'),
    isMultiProduct: true,
    products: [
      _ProductMix(s.tr('Basic', 'أساسي'), 200, 160, 60),
      _ProductMix(s.tr('Premium', 'مميّز'), 350, 270, 30),
      _ProductMix(s.tr('VIP', 'كبار الأعضاء'), 600, 400, 10),
    ],
    fixedCosts: 100000,
    fixedCostsBreakdown: s.tr('Rent, equipment, trainers, utilities',
        'الإيجار، والمعدات، والمدربون، والمرافق'),
    weightedCM: 217,
    bep: 461,
    bepLabel: s.tr('461 members', '461 عضوًا'),
    bepDetail: '',
  ),
  _PracticeScenario(
    title: s.tr('Grocery Store', 'بقالة'),
    city: 'Muscat',
    currency: 'OMR',
    difficulty: s.tr('Intermediate', 'متوسط'),
    difficultyColor: AppColors.accentLight,
    description: s.tr('A neighborhood grocery store with mixed product categories.',
        'بقالة حي بفئات منتجات متنوعة.'),
    isMultiProduct: true,
    products: [
      _ProductMix(s.tr('Fresh Produce', 'منتجات طازجة'), 2.00, 0.60, 40),
      _ProductMix(s.tr('Packaged', 'سلع معلّبة'), 3.50, 0.70, 45),
      _ProductMix(s.tr('Beverages', 'مشروبات'), 1.50, 0.45, 15),
    ],
    fixedCosts: 3250,
    fixedCostsBreakdown: s.tr('Rent, refrigeration, staff, license',
        'الإيجار، والتبريد، والموظفون، والترخيص'),
    weightedCM: 0.6225,
    bep: 5221,
    bepLabel: s.tr('5,221 units/month', '5,221 وحدة/شهر'),
    bepDetail: s.tr('≈ 174 units/day', '≈ 174 وحدة/يوم'),
  ),
  _PracticeScenario(
    title: s.tr('Event Management', 'إدارة الفعاليات'),
    city: 'Doha',
    currency: 'QAR',
    difficulty: s.tr('Advanced', 'متقدّم'),
    difficultyColor: AppColors.dangerLight,
    description: s.tr(
        'A premier event management company handling corporate events, weddings, and private parties.',
        'شركة رائدة في إدارة الفعاليات تتولّى الفعاليات المؤسسية والأعراس والحفلات الخاصة.'),
    isMultiProduct: true,
    products: [
      _ProductMix(s.tr('Corporate', 'فعاليات مؤسسية'), 75000, 30000, 30.8),
      _ProductMix(s.tr('Weddings', 'أعراس'), 120000, 40000, 23.1),
      _ProductMix(s.tr('Parties', 'حفلات'), 25000, 13000, 46.1),
    ],
    fixedCosts: 552000,
    fixedCostsBreakdown: s.tr('Office, full-time staff, equipment, insurance (annual)',
        'المكتب، والموظفون بدوام كامل، والمعدات، والتأمين (سنويًا)'),
    weightedCM: 24473,
    bep: 23,
    bepLabel: s.tr('23 events/year', '23 فعالية/سنة'),
    bepDetail: s.tr('≈ 2 events/month', '≈ 2 فعالية/شهر'),
  ),
];

// ──────────────────────────────────────────────────────────────────────────────
// Main Screen
// ──────────────────────────────────────────────────────────────────────────────

class BreakEvenScreen extends ConsumerStatefulWidget {
  const BreakEvenScreen({super.key});

  @override
  ConsumerState<BreakEvenScreen> createState() => _BreakEvenScreenState();
}

class _BreakEvenScreenState extends ConsumerState<BreakEvenScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTab = 0;

  // Calculator state
  double _fixedCosts = 50000;
  double _pricePerUnit = 25;
  double _variableCostPerUnit = 15;
  // Expected sales volume (units). 0 = auto (1.5× break-even). Drives Margin of
  // Safety and Degree of Operating Leverage.
  double _expectedUnitsRaw = 0;

  // Sensitivity sliders (-50 to +50 %)
  double _priceAdj = 0;
  double _variableCostAdj = 0;
  double _fixedCostAdj = 0;

  // Learn tab page
  int _currentSlide = 0;
  final PageController _pageController = PageController();

  // Practice tab expanded states
  final Set<int> _expandedScenarios = {};

  // API scenarios
  List<Map<String, dynamic>> _excelScenarios = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _selectedTab = _tabController.index);
      }
    });
    _loadScenarios();
  }

  Future<void> _loadScenarios() async {
    try {
      final repo = ref.read(educationRepositoryProvider);
      final scenarios = await repo.fetchBreakEvenScenarios();
      if (mounted) setState(() => _excelScenarios = scenarios);
    } catch (_) {}
  }

  void _applyScenario(Map<String, dynamic> scenario) {
    setState(() {
      _fixedCosts = (scenario['fixedCosts'] as num?)?.toDouble() ?? _fixedCosts;
      _pricePerUnit = (scenario['pricePerUnit'] as num?)?.toDouble() ?? _pricePerUnit;
      _variableCostPerUnit =
          (scenario['variableCostPerUnit'] as num?)?.toDouble() ?? _variableCostPerUnit;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  // ── Calculator helpers ──
  double get _contributionMargin => _pricePerUnit - _variableCostPerUnit;
  double get _breakEvenUnits =>
      _contributionMargin > 0 ? _fixedCosts / _contributionMargin : 0;
  double get _breakEvenRevenue => _breakEvenUnits * _pricePerUnit;
  /// Expected operating volume — defaults to 50% above break-even when the user
  /// has not set an explicit figure.
  double get _effectiveUnits =>
      _expectedUnitsRaw > 0 ? _expectedUnitsRaw : _breakEvenUnits * 1.5;

  double get _marginOfSafety => _effectiveUnits > 0
      ? ((_effectiveUnits - _breakEvenUnits) / _effectiveUnits) * 100
      : 0;

  // Degree of Operating Leverage at the expected volume:
  //   DOL = Total Contribution Margin / EBIT
  // Measures how sensitive operating profit is to a change in sales.
  double get _totalContribution => _effectiveUnits * _contributionMargin;
  double get _ebit => _totalContribution - _fixedCosts;
  double get _dol => _ebit.abs() > 0.0001 ? _totalContribution / _ebit : 0;

  // Adjusted values for sensitivity
  double get _adjPrice => _pricePerUnit * (1 + _priceAdj / 100);
  double get _adjVC => _variableCostPerUnit * (1 + _variableCostAdj / 100);
  double get _adjFC => _fixedCosts * (1 + _fixedCostAdj / 100);
  double get _adjCM => _adjPrice - _adjVC;
  double get _adjBEP => _adjCM > 0 ? _adjFC / _adjCM : 0;
  double get _bepChange =>
      _breakEvenUnits > 0 ? ((_adjBEP - _breakEvenUnits) / _breakEvenUnits) * 100 : 0;

  // ──────────────────────────────────────────────────────────────────────────
  // Build
  // ──────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient(context)),
        child: SafeArea(
          child: Column(
            children: [
              // ── Header ──
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      onPressed: () => context.pop(),
                    ),
                    Expanded(
                      child: Text(
                        ref.watch(stringsProvider).tr('Break-Even Analysis', 'تحليل نقطة التعادل'),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary(context),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ).animate().fadeIn(),

              const SizedBox(height: 12),

              // ── Custom segmented tab bar ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildSegmentedTabs(),
              ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),

              const SizedBox(height: 8),

              // ── Tab body ──
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildLearnTab(),
                    _buildCalculatorTab(),
                    _buildPracticeTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Segmented Tabs
  // ──────────────────────────────────────────────────────────────────────────

  // Website-matching tab colors
  static const _activeBlue = Color(0xFF0B5ED7);
  static const _activeBorderBlue = Color(0xFF0D6EFD);
  static const _inactiveText = Color(0xFF131B2B);

  Widget _buildSegmentedTabs() {
    final s = ref.watch(stringsProvider);
    final tabs = [
      (Icons.school_rounded, s.tr('Learn', 'تعلّم')),
      (Icons.calculate_rounded, s.tr('Calculator', 'الحاسبة')),
      (Icons.help_outline_rounded, s.tr('Practice', 'تدريب')),
    ];
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : const Color(0xFFE5E5E5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final selected = _selectedTab == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => _tabController.animateTo(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: selected
                      ? (isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white)
                      : Colors.transparent,
                  border: selected
                      ? Border(bottom: BorderSide(color: _activeBorderBlue, width: 2))
                      : null,
                  boxShadow: selected
                      ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 2)]
                      : null,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(tabs[i].$1,
                        size: 20,
                        color: selected
                            ? _activeBlue
                            : (isDark ? AppColors.darkTextSecondary : _inactiveText)),
                    const SizedBox(height: 2),
                    Text(
                      tabs[i].$2,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: selected
                            ? _activeBlue
                            : (isDark ? AppColors.darkTextSecondary : _inactiveText),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // LEARN TAB
  // ──────────────────────────────────────────────────────────────────────────

  Widget _buildLearnTab() {
    final s = ref.watch(stringsProvider);
    final slides = _buildSlides(s);
    return Column(
      children: [
        // Page counter
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_currentSlide + 1} / ${slides.length}',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 13,
                  color: AppColors.textTertiary(context),
                ),
              ),
              Text(
                s.tr('Swipe to navigate', 'اسحب للتنقل'),
                style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context)),
              ),
            ],
          ),
        ),

        // PageView
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: slides.length,
            onPageChanged: (i) => setState(() => _currentSlide = i),
            itemBuilder: (context, i) => _buildSlideCard(slides[i], i),
          ),
        ),

        // Dot indicators + nav buttons
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              // Previous
              _NavCircleButton(
                icon: Icons.arrow_back_rounded,
                enabled: _currentSlide > 0,
                onTap: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOut,
                  );
                },
              ),
              const SizedBox(width: 8),
              // Dots
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(slides.length, (i) {
                        final active = i == _currentSlide;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: active ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: active
                                ? slides[_currentSlide].color
                                : AppColors.borderColor(context),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Next
              _NavCircleButton(
                icon: Icons.arrow_forward_rounded,
                enabled: _currentSlide < slides.length - 1,
                onTap: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSlideCard(_LearnSlide slide, int index) {
    final s = ref.watch(stringsProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: GlassCard(
        borderColor: slide.color.withValues(alpha: 0.3),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon + slide number
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: slide.color.withValues(alpha: 0.15),
                  ),
                  child: Icon(slide.icon, color: slide.color, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${s.tr('Section', 'القسم')} ${index + 1}',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 11,
                          color: slide.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        slide.title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Description
            Text(
              slide.description,
              style: TextStyle(
                fontSize: 15,
                height: 1.6,
                color: AppColors.textSecondary(context),
              ),
            ),

            if (slide.formulas.isNotEmpty) ...[
              const SizedBox(height: 20),
              // Formula box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: slide.color.withValues(alpha: 0.08),
                  border: Border.all(color: slide.color.withValues(alpha: 0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.functions_rounded, size: 16, color: slide.color),
                        const SizedBox(width: 6),
                        Text(
                          'Key Formulas',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: slide.color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...slide.formulas.map((f) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            f,
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 13,
                              color: AppColors.textPrimary(context),
                              height: 1.5,
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ],

            const Spacer(),

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (index + 1) / _buildSlides(s).length,
                minHeight: 4,
                backgroundColor: AppColors.borderColor(context),
                valueColor: AlwaysStoppedAnimation(slide.color),
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.05),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // CALCULATOR TAB
  // ──────────────────────────────────────────────────────────────────────────

  Widget _buildCalculatorTab() {
    return CustomScrollView(
      slivers: [
        // API scenario selector
        if (_excelScenarios.isNotEmpty)
          SliverToBoxAdapter(
            child: SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                itemCount: _excelScenarios.length,
                itemBuilder: (context, index) {
                  final s = _excelScenarios[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GlassCard(
                      onTap: () => _applyScenario(s),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s['name'] as String? ?? 'Scenario ${index + 1}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryLight,
                            ),
                          ),
                          Text(
                            s['description'] as String? ?? '',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textTertiary(context),
                            ),
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ).animate().fadeIn(delay: 100.ms),
          ),

        // Calculator sliders
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calculate_rounded,
                          color: AppColors.primaryLight, size: 20),
                      const SizedBox(width: 8),
                      Text('Calculator',
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 18, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _SliderInput(
                    label: 'Fixed Costs',
                    value: _fixedCosts,
                    min: 1000,
                    max: 500000,
                    prefix: 'SAR ',
                    onChanged: (v) => setState(() => _fixedCosts = v),
                  ),
                  _SliderInput(
                    label: 'Price per Unit',
                    value: _pricePerUnit,
                    min: 1,
                    max: 200,
                    prefix: 'SAR ',
                    onChanged: (v) => setState(() => _pricePerUnit = v),
                  ),
                  _SliderInput(
                    label: 'Variable Cost / Unit',
                    value: _variableCostPerUnit,
                    min: 0,
                    max: 150,
                    prefix: 'SAR ',
                    onChanged: (v) => setState(() => _variableCostPerUnit = v),
                  ),
                  _SliderInput(
                    label: 'Expected Sales (units)',
                    // Surface the auto value so the slider has a sensible start;
                    // clamp to stay within the slider's range as BEP shifts.
                    value: _effectiveUnits
                        .clamp(0, (_breakEvenUnits * 4).clamp(100, 1000000))
                        .toDouble(),
                    min: 0,
                    max: (_breakEvenUnits * 4).clamp(100, 1000000).toDouble(),
                    prefix: '',
                    onChanged: (v) => setState(() => _expectedUnitsRaw = v),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms),
          ),
        ),

        // Result cards
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                _ResultCard('Break-Even Units', _breakEvenUnits.toStringAsFixed(0),
                    Icons.flag_rounded, AppColors.primaryLight),
                _ResultCard(
                    'Break-Even Revenue',
                    'SAR ${_breakEvenRevenue.toStringAsFixed(0)}',
                    Icons.attach_money_rounded,
                    AppColors.secondaryLight),
                _ResultCard(
                    'Contribution Margin',
                    'SAR ${_contributionMargin.toStringAsFixed(2)}',
                    Icons.trending_up_rounded,
                    AppColors.accentLight),
                _ResultCard('Margin of Safety', '${_marginOfSafety.toStringAsFixed(1)}%',
                    Icons.shield_rounded, const Color(0xFF06B6D4)),
                _ResultCard(
                    'Operating Leverage (DOL)',
                    _ebit <= 0 ? '—' : '${_dol.toStringAsFixed(2)}×',
                    Icons.bolt_rounded,
                    AppColors.purple),
              ],
            ).animate().fadeIn(delay: 400.ms),
          ),
        ),

        // Chart
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Break-Even Chart',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 20),
                  SizedBox(height: 250, child: _buildChart()),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _Legend('Revenue', AppColors.secondaryLight),
                      const SizedBox(width: 16),
                      _Legend('Total Cost', AppColors.dangerLight),
                      const SizedBox(width: 16),
                      _Legend('Fixed Cost', AppColors.accentLight),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 600.ms),
          ),
        ),

        // ── Sensitivity Analysis ──
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: GlassCard(
              borderColor: const Color(0xFFF97316).withValues(alpha: 0.3),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.tune_rounded, color: Color(0xFFF97316), size: 20),
                      const SizedBox(width: 8),
                      Text('Sensitivity Analysis',
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 18, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Adjust percentages to see how changes impact break-even',
                    style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context)),
                  ),
                  const SizedBox(height: 16),
                  _SensitivitySlider(
                    label: 'Price',
                    value: _priceAdj,
                    color: AppColors.secondaryLight,
                    onChanged: (v) => setState(() => _priceAdj = v),
                  ),
                  _SensitivitySlider(
                    label: 'Variable Cost',
                    value: _variableCostAdj,
                    color: AppColors.dangerLight,
                    onChanged: (v) => setState(() => _variableCostAdj = v),
                  ),
                  _SensitivitySlider(
                    label: 'Fixed Cost',
                    value: _fixedCostAdj,
                    color: AppColors.accentLight,
                    onChanged: (v) => setState(() => _fixedCostAdj = v),
                  ),
                  const SizedBox(height: 12),
                  // Impact summary
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: (_bepChange <= 0
                              ? AppColors.secondaryLight
                              : AppColors.dangerLight)
                          .withValues(alpha: 0.08),
                      border: Border.all(
                        color: (_bepChange <= 0
                                ? AppColors.secondaryLight
                                : AppColors.dangerLight)
                            .withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Original BEP',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textTertiary(context))),
                              Text(
                                '${_breakEvenUnits.toStringAsFixed(0)} units',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_rounded,
                            size: 20, color: AppColors.textTertiary(context)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Adjusted BEP',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textTertiary(context))),
                              Text(
                                '${_adjBEP.toStringAsFixed(0)} units',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: _bepChange <= 0
                                      ? AppColors.secondaryLight
                                      : AppColors.dangerLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: (_bepChange <= 0
                                    ? AppColors.secondaryLight
                                    : AppColors.dangerLight)
                                .withValues(alpha: 0.15),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _bepChange <= 0
                                    ? Icons.arrow_downward_rounded
                                    : Icons.arrow_upward_rounded,
                                size: 14,
                                color: _bepChange <= 0
                                    ? AppColors.secondaryLight
                                    : AppColors.dangerLight,
                              ),
                              Text(
                                '${_bepChange.abs().toStringAsFixed(1)}%',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: _bepChange <= 0
                                      ? AppColors.secondaryLight
                                      : AppColors.dangerLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (_priceAdj != 0 || _variableCostAdj != 0 || _fixedCostAdj != 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () => setState(() {
                            _priceAdj = 0;
                            _variableCostAdj = 0;
                            _fixedCostAdj = 0;
                          }),
                          icon: const Icon(Icons.refresh_rounded, size: 16),
                          label: const Text('Reset'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.textTertiary(context),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ).animate().fadeIn(delay: 800.ms),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }

  Widget _buildChart() {
    final maxUnits = _breakEvenUnits * 2;
    if (maxUnits <= 0) {
      return Center(
        child: Text(
          'Adjust values to see chart\n(Price must exceed Variable Cost)',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textTertiary(context)),
        ),
      );
    }
    return LineChart(LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (v) => FlLine(
          color: AppColors.borderColor(context).withValues(alpha: 0.3),
          strokeWidth: 1,
        ),
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 50,
            getTitlesWidget: (v, _) => Text(
              'SAR ${(v / 1000).toInt()}k',
              style: TextStyle(fontSize: 10, color: AppColors.textTertiary(context)),
            ),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (v, _) => Text(
              '${v.toInt()}',
              style: TextStyle(fontSize: 10, color: AppColors.textTertiary(context)),
            ),
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        // Total cost line
        LineChartBarData(
          spots: List.generate(11, (i) {
            final u = i * (maxUnits / 10);
            return FlSpot(u, _fixedCosts + u * _variableCostPerUnit);
          }),
          isCurved: false,
          color: AppColors.dangerLight,
          barWidth: 2,
          dotData: const FlDotData(show: false),
        ),
        // Revenue line
        LineChartBarData(
          spots: List.generate(11, (i) {
            final u = i * (maxUnits / 10);
            return FlSpot(u, u * _pricePerUnit);
          }),
          isCurved: false,
          color: AppColors.secondaryLight,
          barWidth: 2,
          dotData: const FlDotData(show: false),
        ),
        // Fixed cost line
        LineChartBarData(
          spots: List.generate(11, (i) {
            final u = i * (maxUnits / 10);
            return FlSpot(u, _fixedCosts);
          }),
          isCurved: false,
          color: AppColors.accentLight,
          barWidth: 1,
          dashArray: [4, 4],
          dotData: const FlDotData(show: false),
        ),
      ],
    ));
  }

  // ──────────────────────────────────────────────────────────────────────────
  // PRACTICE TAB
  // ──────────────────────────────────────────────────────────────────────────

  Widget _buildPracticeTab() {
    final str = ref.watch(stringsProvider);
    final scenarios = _buildPracticeScenarios(str);
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: scenarios.length,
      itemBuilder: (context, i) {
        final s = scenarios[i];
        final expanded = _expandedScenarios.contains(i);
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GlassCard(
            borderColor: expanded
                ? s.difficultyColor.withValues(alpha: 0.4)
                : null,
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                // Header (always visible)
                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => setState(() {
                    if (expanded) {
                      _expandedScenarios.remove(i);
                    } else {
                      _expandedScenarios.add(i);
                    }
                  }),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Number circle
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: s.difficultyColor.withValues(alpha: 0.15),
                          ),
                          child: Center(
                            child: Text(
                              '${i + 1}',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: s.difficultyColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${s.title} - ${s.city}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary(context),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                s.description,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textTertiary(context),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Difficulty badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: s.difficultyColor.withValues(alpha: 0.15),
                          ),
                          child: Text(
                            s.difficulty,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: s.difficultyColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        AnimatedRotation(
                          turns: expanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 250),
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppColors.textTertiary(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Expanded content
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: _buildScenarioDetails(s),
                  crossFadeState: expanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                ),
              ],
            ),
          ).animate().fadeIn(delay: (80 * i).ms).slideY(begin: 0.05),
        );
      },
    );
  }

  Widget _buildScenarioDetails(_PracticeScenario s) {
    final str = ref.watch(stringsProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: AppColors.borderColor(context), height: 1),
          const SizedBox(height: 14),

          // Multi-product table or single product info
          if (s.isMultiProduct && s.products != null) ...[
            _sectionLabel(str.tr('Product Mix', 'مزيج المنتجات'), Icons.category_rounded),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.cardColor(context).withValues(alpha: 0.5),
              ),
              child: Column(
                children: [
                  // Header row
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 3,
                            child: Text(str.tr('Service', 'الخدمة'),
                                style: _tableHeaderStyle(context))),
                        Expanded(
                            flex: 2,
                            child: Text(str.tr('Price', 'السعر'),
                                style: _tableHeaderStyle(context),
                                textAlign: TextAlign.right)),
                        Expanded(
                            flex: 2,
                            child: Text(str.tr('CM', 'هامش المساهمة'),
                                style: _tableHeaderStyle(context),
                                textAlign: TextAlign.right)),
                        Expanded(
                            flex: 2,
                            child: Text(str.tr('Mix', 'المزيج'),
                                style: _tableHeaderStyle(context),
                                textAlign: TextAlign.right)),
                      ],
                    ),
                  ),
                  ...s.products!.map((p) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color:
                                  AppColors.borderColor(context).withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 3,
                                child: Text(p.name,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textPrimary(context)))),
                            Expanded(
                              flex: 2,
                              child: Text(
                                _fmtNum(p.price, s.currency),
                                style: GoogleFonts.jetBrainsMono(
                                    fontSize: 11,
                                    color: AppColors.textSecondary(context)),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                _fmtNum(p.cm, s.currency),
                                style: GoogleFonts.jetBrainsMono(
                                    fontSize: 11,
                                    color: AppColors.secondaryLight),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                '${p.mixPercent}%',
                                style: GoogleFonts.jetBrainsMono(
                                    fontSize: 11,
                                    color: AppColors.textSecondary(context)),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (s.weightedCM != null)
              _formulaRow(
                  str.tr('Weighted CM', 'هامش المساهمة المرجّح'),
                  '${s.currency} ${_fmtDouble(s.weightedCM!)}'),
          ] else ...[
            _sectionLabel(str.tr('Cost Breakdown', 'تفصيل التكاليف'), Icons.receipt_long_rounded),
            const SizedBox(height: 8),
            // Price
            _infoRow(str.tr('Selling Price', 'سعر البيع'), '${s.currency} ${_fmtDouble(s.pricePerUnit)}',
                AppColors.primaryLight),
            const SizedBox(height: 6),
            // Variable costs
            ...s.variableCosts.map((c) => _infoRow(
                  '  ${c.name}',
                  '${s.currency} ${_fmtDouble(c.cost)}',
                  AppColors.textTertiary(context),
                )),
            const SizedBox(height: 4),
            _infoRow(str.tr('Total Variable Cost', 'إجمالي التكلفة المتغيرة'),
                '${s.currency} ${_fmtDouble(s.totalVariableCost)}', AppColors.dangerLight),
            const SizedBox(height: 4),
            _formulaRow(str.tr('Contribution Margin', 'هامش المساهمة'),
                '${s.currency} ${_fmtDouble(s.pricePerUnit - s.totalVariableCost)}'),
          ],

          const SizedBox(height: 12),

          // Fixed costs
          _sectionLabel(str.tr('Fixed Costs', 'التكاليف الثابتة'), Icons.lock_rounded),
          const SizedBox(height: 6),
          _infoRow(str.tr('Monthly Fixed Costs', 'التكاليف الثابتة الشهرية'),
              '${s.currency} ${_fmtDouble(s.fixedCosts)}', AppColors.dangerLight),
          if (s.fixedCostsBreakdown.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                s.fixedCostsBreakdown,
                style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textTertiary(context),
                    fontStyle: FontStyle.italic),
              ),
            ),

          const SizedBox(height: 14),

          // Solution box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  s.difficultyColor.withValues(alpha: 0.1),
                  s.difficultyColor.withValues(alpha: 0.05),
                ],
              ),
              border: Border.all(color: s.difficultyColor.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle_rounded,
                        size: 16, color: s.difficultyColor),
                    const SizedBox(width: 6),
                    Text(
                      str.tr('Solution', 'الحل'),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: s.difficultyColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  str.tr('Break-Even Point:', 'نقطة التعادل:'),
                  style: TextStyle(
                      fontSize: 12, color: AppColors.textSecondary(context)),
                ),
                const SizedBox(height: 4),
                Text(
                  s.bepLabel,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: s.difficultyColor,
                  ),
                ),
                if (s.bepDetail.isNotEmpty)
                  Text(
                    s.bepDetail,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 13,
                      color: AppColors.textTertiary(context),
                    ),
                  ),
              ],
            ),
          ),

          // "Try in Calculator" button for single-product scenarios
          if (!s.isMultiProduct)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _fixedCosts = s.fixedCosts;
                      _pricePerUnit = s.pricePerUnit;
                      _variableCostPerUnit = s.totalVariableCost;
                      _priceAdj = 0;
                      _variableCostAdj = 0;
                      _fixedCostAdj = 0;
                    });
                    _tabController.animateTo(1);
                  },
                  icon: const Icon(Icons.calculate_rounded, size: 16),
                  label: Text(str.tr('Try in Calculator', 'جرّب في الحاسبة')),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryLight,
                    side: BorderSide(
                        color: AppColors.primaryLight.withValues(alpha: 0.4)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Helpers ──

  Widget _sectionLabel(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textTertiary(context)),
        const SizedBox(width: 6),
        Text(
          text,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary(context),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary(context))),
        Text(value,
            style: GoogleFonts.jetBrainsMono(
                fontSize: 12, fontWeight: FontWeight.w600, color: valueColor)),
      ],
    );
  }

  Widget _formulaRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.secondaryLight.withValues(alpha: 0.08),
        border:
            Border.all(color: AppColors.secondaryLight.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryLight)),
          Text(value,
              style: GoogleFonts.jetBrainsMono(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondaryLight)),
        ],
      ),
    );
  }

  TextStyle _tableHeaderStyle(BuildContext context) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 10,
      fontWeight: FontWeight.w700,
      color: AppColors.textTertiary(context),
      letterSpacing: 0.5,
    );
  }

  String _fmtNum(double n, String currency) {
    if (n >= 1000) {
      return n.toStringAsFixed(0);
    }
    return n.toStringAsFixed(n == n.roundToDouble() ? 0 : 2);
  }

  String _fmtDouble(double n) {
    if (n >= 1000) return n.toStringAsFixed(0);
    if (n == n.roundToDouble()) return n.toStringAsFixed(0);
    // Show up to 4 decimal places if needed (for small numbers like OMR)
    final s = n.toStringAsFixed(4);
    // Trim trailing zeros
    return s.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Reusable private widgets
// ──────────────────────────────────────────────────────────────────────────────

class _NavCircleButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _NavCircleButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: enabled
              ? AppColors.primaryLight.withValues(alpha: 0.15)
              : AppColors.borderColor(context).withValues(alpha: 0.3),
        ),
        child: Icon(
          icon,
          size: 20,
          color: enabled ? AppColors.primaryLight : AppColors.textTertiary(context),
        ),
      ),
    );
  }
}

class _SliderInput extends StatelessWidget {
  final String label;
  final double value;
  final double min, max;
  final String prefix;
  final ValueChanged<double> onChanged;

  const _SliderInput({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.prefix,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            const Spacer(),
            Text(
              '$prefix${value.toStringAsFixed(0)}',
              style: GoogleFonts.jetBrainsMono(
                  fontSize: 14, color: AppColors.primaryLight),
            ),
          ]),
          Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            activeColor: AppColors.primaryLight,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _SensitivitySlider extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final ValueChanged<double> onChanged;

  const _SensitivitySlider({
    required this.label,
    required this.value,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final sign = value >= 0 ? '+' : '';
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            ),
            const SizedBox(width: 8),
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: color.withValues(alpha: 0.12),
              ),
              child: Text(
                '$sign${value.toStringAsFixed(0)}%',
                style: GoogleFonts.jetBrainsMono(
                    fontSize: 13, fontWeight: FontWeight.w600, color: color),
              ),
            ),
          ]),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: color,
              inactiveTrackColor: color.withValues(alpha: 0.15),
              thumbColor: color,
              overlayColor: color.withValues(alpha: 0.1),
              trackHeight: 3,
            ),
            child: Slider(
              value: value,
              min: -50,
              max: 50,
              divisions: 100,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final String title, value;
  final IconData icon;
  final Color color;

  const _ResultCard(this.title, this.value, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderColor: color.withValues(alpha: 0.3),
      padding: const EdgeInsets.all(14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.jetBrainsMono(
                fontSize: 18, fontWeight: FontWeight.w700, color: color),
          ),
          const SizedBox(height: 4),
          Text(title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final String label;
  final Color color;
  const _Legend(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 3, color: color),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(fontSize: 11, color: AppColors.textSecondary(context))),
      ],
    );
  }
}
