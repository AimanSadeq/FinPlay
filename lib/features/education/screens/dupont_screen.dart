import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/glass_card.dart';
import '../widgets/module_kit.dart';
import '../../../providers/game_metrics_provider.dart';
import '../../../shared/widgets/trend_line_chart.dart';
import '../../../shared/widgets/ai_tooltip_button.dart';
import '../../../app/i18n/app_strings.dart';
import '../../../data/models/financial_data.dart';
import '../../dashboard/logic/statement_lookup.dart';

/// Du Pont factors, computed as the website's server/routes/du-pont.ts does (e9dbb49).
///
/// 3-way:  ROE = Net Margin × Asset Turnover × Equity Multiplier
/// 5-way:  ROE = Tax Burden × Interest Burden × EBIT Margin × Asset Turnover × Financial
///         Leverage, with EBT = Net Income + Zakat & Taxes (taxes are stored positive),
///         Tax Burden = NI / EBT, Interest Burden = EBT / EBIT, EBIT Margin = EBIT / Sales.
/// A factor whose denominator is zero is null ("-").
class DuPontFactors {
  final double? netMargin;
  final double? assetTurnover;
  final double? equityMultiplier;
  final double? roe;
  final double? roeFromFactors;
  final double? roa;
  final double? taxBurden;
  final double? interestBurden;
  final double? ebitMargin;
  final double? roeFromFiveFactors;
  final double ebt;

  const DuPontFactors._({
    required this.netMargin,
    required this.assetTurnover,
    required this.equityMultiplier,
    required this.roe,
    required this.roeFromFactors,
    required this.roa,
    required this.taxBurden,
    required this.interestBurden,
    required this.ebitMargin,
    required this.roeFromFiveFactors,
    required this.ebt,
  });

  static double? _div(double n, double d) =>
      (!n.isFinite || !d.isFinite || d == 0) ? null : n / d;

  factory DuPontFactors.compute({
    required double netIncome,
    required double revenue,
    required double totalAssets,
    required double totalEquity,
    required double ebit,
    required double zakatTaxes,
  }) {
    final ebt = netIncome + zakatTaxes;
    final netMargin = _div(netIncome, revenue);
    final assetTurnover = _div(revenue, totalAssets);
    final equityMultiplier = _div(totalAssets, totalEquity);
    final taxBurden = _div(netIncome, ebt);
    final interestBurden = _div(ebt, ebit);
    final ebitMargin = _div(ebit, revenue);
    return DuPontFactors._(
      netMargin: netMargin,
      assetTurnover: assetTurnover,
      equityMultiplier: equityMultiplier,
      roe: _div(netIncome, totalEquity),
      roeFromFactors: netMargin != null && assetTurnover != null && equityMultiplier != null
          ? netMargin * assetTurnover * equityMultiplier
          : null,
      roa: _div(netIncome, totalAssets),
      taxBurden: taxBurden,
      interestBurden: interestBurden,
      ebitMargin: ebitMargin,
      roeFromFiveFactors: taxBurden != null &&
              interestBurden != null &&
              ebitMargin != null &&
              assetTurnover != null &&
              equityMultiplier != null
          ? taxBurden * interestBurden * ebitMargin * assetTurnover * equityMultiplier
          : null,
      ebt: ebt,
    );
  }

  /// From one round's statements, with the website's label matchers.
  static DuPontFactors? fromFinancials(FinancialData d) {
    double v(List<StatementRow> rows, List<String> m) => matchStatementValue(rows, m);
    final ni = v(d.incomeRows, const ['net income', 'net profit', 'profit for the period', 'net earnings']);
    final rev = v(d.incomeRows,
        const ['total revenue', 'net revenue', 'revenue', 'total sales', 'net sales', 'sales']);
    final ebit = v(d.incomeRows,
        const ['operating profit (ebit)', 'operating profit', 'ebit', 'operating income']);
    final tax = v(d.incomeRows,
        const ['zakat & taxes', 'zakat and taxes', 'zakat', 'income tax expense', 'tax expense']);
    final ta = v(d.balanceRows, const ['total assets']);
    final te = v(d.balanceRows, const [
      'total equity',
      'shareholders equity',
      "shareholder's equity",
      "shareholders' equity",
      'total shareholders equity',
      'equity',
    ]);
    if (d.incomeRows.isEmpty || d.balanceRows.isEmpty) return null;
    return DuPontFactors.compute(
      netIncome: ni != 0 ? ni : d.netIncome,
      revenue: rev != 0 ? rev : d.revenue,
      totalAssets: ta != 0 ? ta : d.totalAssets,
      totalEquity: te != 0 ? te : d.totalEquity,
      ebit: ebit,
      zakatTaxes: tax,
    );
  }
}

/// `12.34%` / `-` (website du-pont.tsx pct).
String duPontPct(double? n) => n == null ? '-' : '${(n * 100).toStringAsFixed(2)}%';

/// `1.23×` / `-` (website du-pont.tsx xTimes).
String duPontTimes(double? n) => n == null ? '-' : '${n.toStringAsFixed(2)}×';

/// DuPont ROE decomposition.
/// ROE = Net Margin × Asset Turnover × Equity Multiplier
///     = (NI/Rev) × (Rev/Assets) × (Assets/Equity)
class DuPontScreen extends ConsumerStatefulWidget {
  const DuPontScreen({super.key});

  @override
  ConsumerState<DuPontScreen> createState() => _DuPontScreenState();
}

class _DuPontScreenState extends ConsumerState<DuPontScreen> {
  int _tab = 0;

  double _netIncome = 120000;
  double _revenue = 1000000;
  double _assets = 1500000;
  double _equity = 800000;
  // Extended 5-way inputs: EBIT and Zakat & Taxes (EBT = Net Income + Zakat & Taxes).
  double _ebit = 170000;
  double _zakatTaxes = 20000;

  DuPontFactors get _f => DuPontFactors.compute(
        netIncome: _netIncome,
        revenue: _revenue,
        totalAssets: _assets,
        totalEquity: _equity,
        ebit: _ebit,
        zakatTaxes: _zakatTaxes,
      );

  double get _netMargin => _f.netMargin ?? 0; // fraction
  double get _assetTurnover => _f.assetTurnover ?? 0; // ratio
  double get _equityMultiplier => _f.equityMultiplier ?? 0; // ratio
  double get _roe => _netMargin * _assetTurnover * _equityMultiplier;
  double get _roa => _netMargin * _assetTurnover;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gameMetricsProvider.notifier).load();
    });
  }

  /// ROE (%) per game round from that round's net income and equity.
  List<double?> _roeSeries(GameMetricsState m) => m.series(
      (fd) => fd.totalEquity != 0 ? (fd.netIncome / fd.totalEquity) * 100 : null);

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    return ModuleScaffold(
      title: s.tr('DuPont Analysis', 'تحليل دوبونت'),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentTabBar(
              activeTab: _tab,
              tabs: [
                (icon: Icons.school_rounded, label: s.tr('Learn', 'تعلّم')),
                (icon: Icons.analytics_rounded, label: s.tr('Calculator', 'الحاسبة')),
              ],
              onChanged: (i) => setState(() => _tab = i),
            ),
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 12),
          Expanded(
            child: AnimatedSwitcher(
              duration: 300.ms,
              child: _tab == 0 ? _buildLearn() : _buildCalc(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLearn() {
    final s = ref.watch(stringsProvider);
    return ListView(
      key: const ValueKey('learn'),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      children: [
        ConceptCard(
          icon: Icons.analytics_rounded,
          title: s.tr('The DuPont Identity', 'متطابقة دوبونت'),
          body: s.tr(
              'DuPont analysis breaks Return on Equity into three drivers so you '
              'can see WHY ROE is high or low — is it profitability, efficiency, '
              'or leverage? Two firms with the same ROE can get there very '
              'differently.',
              'يفكّك تحليل دوبونت العائد على حقوق الملكية إلى ثلاثة محركات حتى ترى '
              'لماذا يكون العائد مرتفعًا أو منخفضًا — هل هو الربحية أم الكفاءة أم '
              'الرافعة المالية؟ يمكن لشركتين بنفس العائد أن تصلا إليه بطرق مختلفة تمامًا.'),
          formula: 'ROE = Net Margin × Asset Turnover × Equity Multiplier',
          color: AppColors.primaryLight,
        ),
        const SizedBox(height: 12),
        ConceptCard(
          icon: Icons.savings_rounded,
          title: s.tr('Net Profit Margin', 'هامش صافي الربح'),
          body: s.tr(
              'How many cents of profit per dollar of sales (Net Income / Revenue). '
              'Measures profitability and pricing power.',
              'كم سنتًا من الربح مقابل كل دولار من المبيعات (صافي الدخل / الإيرادات). '
              'يقيس الربحية وقوة التسعير.'),
          formula: 'Net Margin = Net Income / Revenue',
          color: AppColors.primaryLight,
        ),
        const SizedBox(height: 12),
        ConceptCard(
          icon: Icons.speed_rounded,
          title: s.tr('Asset Turnover', 'معدل دوران الأصول'),
          body: s.tr(
              'How many revenue dollars each dollar of assets generates '
              '(Revenue / Total Assets). Measures operating efficiency.',
              'كم دولارًا من الإيرادات يولّده كل دولار من الأصول '
              '(الإيرادات / إجمالي الأصول). يقيس الكفاءة التشغيلية.'),
          formula: 'Asset Turnover = Revenue / Total Assets',
          color: AppColors.accentLight,
        ),
        const SizedBox(height: 12),
        ConceptCard(
          icon: Icons.account_balance_rounded,
          title: s.tr('Equity Multiplier', 'مضاعف حقوق الملكية'),
          body: s.tr(
              'How much each dollar of equity is amplified by debt '
              '(Total Assets / Total Equity). Higher = more leverage and more risk.',
              'مدى تضخيم كل دولار من حقوق الملكية بفعل الدين '
              '(إجمالي الأصول / إجمالي حقوق الملكية). الأعلى = رافعة أكبر ومخاطر أكبر.'),
          formula: 'Equity Multiplier = Total Assets / Total Equity',
          color: AppColors.purple,
        ),
        const SizedBox(height: 12),
        ConceptCard(
          icon: Icons.pie_chart_rounded,
          title: s.tr('Extended 5-Way Decomposition', 'التحليل الخماسي الموسّع'),
          body: s.tr(
              'Splits Net Margin into its tax, financing, and operating layers: ROE = Tax Burden '
              '× Interest Burden × EBIT Margin × Asset Turnover × Financial Leverage. Financing '
              'decisions show up in the interest burden, and shocks in the tax burden.',
              'يقسّم هامش صافي الربح إلى طبقاته الضريبية والتمويلية والتشغيلية: العائد على حقوق '
              'الملكية = العبء الضريبي × عبء الفائدة × هامش الربح قبل الفوائد والضرائب × معدل دوران '
              'الأصول × الرافعة المالية. تظهر قرارات التمويل في عبء الفائدة، والصدمات في العبء الضريبي.'),
          formula: 'ROE = (NI/EBT) × (EBT/EBIT) × (EBIT/Sales) × (Sales/TA) × (TA/TE)',
          color: AppColors.secondaryLight,
        ),
        const SizedBox(height: 12),
        ConceptCard(
          icon: Icons.center_focus_strong_rounded,
          title: s.tr('ROA strips out leverage', 'العائد على الأصول يستبعد الرافعة'),
          body: s.tr(
              'Return on Assets (Net Margin × Asset Turnover) shows pure operating '
              'efficiency before any leverage effect. If ROE is high only because '
              'of a large equity multiplier, the business is leaning on debt.',
              'العائد على الأصول (هامش صافي الربح × معدل دوران الأصول) يُظهر الكفاءة '
              'التشغيلية الصافية قبل أي أثر للرافعة. وإذا كان العائد على حقوق الملكية '
              'مرتفعًا بسبب مضاعف حقوق ملكية كبير فقط، فإن الشركة تعتمد على الدين.'),
          color: AppColors.secondaryLight,
        ),
      ],
    );
  }

  Widget _buildCalc() {
    final s = ref.watch(stringsProvider);
    final strong = _roe >= 0.15;
    final ok = _roe >= 0.10;
    return ListView(
      key: const ValueKey('calc'),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      children: [
        Consumer(builder: (context, ref, _) {
          final s = ref.watch(stringsProvider);
          final m = ref.watch(gameMetricsProvider);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TrendLineChart(
              title: s.tr('Trend — All Periods', 'الاتجاه — جميع الفترات'),
              subtitle: s.tr('ROE across game rounds', 'العائد على حقوق الملكية عبر جولات اللعبة'),
              values: _roeSeries(m),
              labels: GameMetricsState.roundLabels,
              color: AppColors.secondaryLight,
              format: (v) => '${v.toStringAsFixed(1)}%',
            ),
          );
        }),
        GlassCard(
          borderColor: AppColors.secondaryLight.withValues(alpha: 0.4),
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Icon(Icons.trending_up_rounded,
                  color: AppColors.secondaryLight, size: 30),
              const SizedBox(height: 8),
              Text('${(_roe * 100).toStringAsFixed(2)}%',
                  style: GoogleFonts.jetBrainsMono(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      color: AppColors.secondaryLight)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(s.tr('Return on Equity', 'العائد على حقوق الملكية'),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                  const AiTooltipButton(
                      term: 'Return on Equity', type: 'profitability'),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: (strong
                          ? AppColors.secondary
                          : ok
                              ? AppColors.accent
                              : AppColors.danger)
                      .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  strong
                      ? s.tr('Strong', 'قوي')
                      : ok
                          ? s.tr('Acceptable', 'مقبول')
                          : s.tr('Weak', 'ضعيف'),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: strong
                        ? AppColors.secondaryLight
                        : ok
                            ? AppColors.accentLight
                            : AppColors.dangerLight,
                  ),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: 8),

        // ROE = a × b × c strip
        GlassCard(
          padding: const EdgeInsets.all(14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _factor('${(_netMargin * 100).toStringAsFixed(1)}%', s.tr('Margin', 'الهامش'),
                  AppColors.primaryLight),
              _times(),
              _factor('${_assetTurnover.toStringAsFixed(2)}×', s.tr('Turnover', 'الدوران'),
                  AppColors.accentLight),
              _times(),
              _factor('${_equityMultiplier.toStringAsFixed(2)}×', s.tr('Leverage', 'الرافعة'),
                  AppColors.purple),
            ],
          ),
        ).animate().fadeIn(delay: 250.ms),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: MetricCard(
                title: s.tr('Net Profit Margin', 'هامش صافي الربح'),
                value: '${(_netMargin * 100).toStringAsFixed(2)}%',
                caption: s.tr('Profit per \$ of sales', 'الربح لكل دولار مبيعات'),
                icon: Icons.savings_rounded,
                color: AppColors.primaryLight,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MetricCard(
                title: s.tr('Asset Turnover', 'معدل دوران الأصول'),
                value: '${_assetTurnover.toStringAsFixed(2)}×',
                caption: s.tr('Revenue per \$ of assets', 'الإيرادات لكل دولار أصول'),
                icon: Icons.speed_rounded,
                color: AppColors.accentLight,
              ),
            ),
          ],
        ).animate().fadeIn(delay: 300.ms),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: MetricCard(
                title: s.tr('Equity Multiplier', 'مضاعف حقوق الملكية'),
                value: '${_equityMultiplier.toStringAsFixed(2)}×',
                caption: s.tr('Leverage amplifier', 'مضخّم الرافعة المالية'),
                icon: Icons.account_balance_rounded,
                color: AppColors.purple,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MetricCard(
                title: s.tr('ROA', 'العائد على الأصول'),
                value: '${(_roa * 100).toStringAsFixed(2)}%',
                caption: s.tr('Leverage-free return', 'عائد خالٍ من الرافعة'),
                icon: Icons.center_focus_strong_rounded,
                color: AppColors.secondaryLight,
              ),
            ),
          ],
        ).animate().fadeIn(delay: 350.ms),
        const SizedBox(height: 14),

        // Extended 5-way decomposition (website e9dbb49).
        _fiveWaySection(context, s, _f),
        const SizedBox(height: 14),

        // The same identity on the team's latest played round, when there is game data.
        Consumer(builder: (context, ref, _) {
          final latest = ref.watch(gameMetricsProvider).latest;
          final f = latest == null ? null : DuPontFactors.fromFinancials(latest);
          if (f == null) return const SizedBox.shrink();
          final label = latest!.roundNum == 0
              ? s.tr('Baseline', 'خط الأساس')
              : s.tr('Round ${latest.roundNum}', 'الجولة ${latest.roundNum}');
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: GlassCard(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.tr('Your results — $label', 'نتائجك — $label'),
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  _identityStrip(context, s, f),
                ],
              ),
            ),
          );
        }),

        GlassCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.tr('Inputs', 'المدخلات'), style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              SliderRow(
                label: s.tr('Net Income', 'صافي الدخل'),
                value: _netIncome,
                min: -200000,
                max: 600000,
                prefix: '\$',
                divisions: 40,
                onChanged: (v) => setState(() => _netIncome = v),
              ),
              SliderRow(
                label: s.tr('Revenue', 'الإيرادات'),
                value: _revenue,
                min: 100000,
                max: 3000000,
                prefix: '\$',
                divisions: 58,
                onChanged: (v) => setState(() => _revenue = v),
              ),
              SliderRow(
                label: s.tr('Total Assets', 'إجمالي الأصول'),
                value: _assets,
                min: 100000,
                max: 4000000,
                prefix: '\$',
                divisions: 39,
                onChanged: (v) => setState(() => _assets = v),
              ),
              SliderRow(
                label: s.tr('Total Equity', 'إجمالي حقوق الملكية'),
                value: _equity,
                min: 50000,
                max: 3000000,
                prefix: '\$',
                divisions: 59,
                onChanged: (v) => setState(() => _equity = v),
              ),
              SliderRow(
                label: s.tr('Operating Profit (EBIT)', 'الربح التشغيلي (EBIT)'),
                value: _ebit,
                min: -200000,
                max: 800000,
                prefix: '\$',
                divisions: 50,
                onChanged: (v) => setState(() => _ebit = v),
              ),
              SliderRow(
                label: s.tr('Zakat & Taxes', 'الزكاة والضرائب'),
                value: _zakatTaxes,
                min: 0,
                max: 200000,
                prefix: '\$',
                divisions: 40,
                onChanged: (v) => setState(() => _zakatTaxes = v),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 400.ms),
      ],
    );
  }

  Widget _fiveWaySection(BuildContext context, AppStrings s, DuPontFactors f) {
    Widget card(String title, String tag, String value, String formula, String note, Color color) =>
        GlassCard(
          borderColor: color.withValues(alpha: 0.3),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(title,
                        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(tag,
                        style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600, color: color)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(value,
                  style: GoogleFonts.jetBrainsMono(
                      fontSize: 18, fontWeight: FontWeight.w800, color: color)),
              Text(formula,
                  style: GoogleFonts.jetBrainsMono(
                      fontSize: 10, color: AppColors.textTertiary(context))),
              const SizedBox(height: 4),
              Text(note,
                  style: TextStyle(fontSize: 11, height: 1.35, color: AppColors.textSecondary(context))),
            ],
          ),
        );

    final cards = [
      card(
          s.tr('Tax Burden', 'العبء الضريبي'),
          s.tr('Tax', 'الضريبة'),
          duPontPct(f.taxBurden),
          'Net Income / EBT',
          s.tr('What survives taxes: the share of pre-tax profit kept after zakat & taxes.',
              'ما يتبقى بعد الضرائب: حصة الربح قبل الضريبة المحتفظ بها بعد الزكاة والضرائب.'),
          AppColors.secondaryLight),
      card(
          s.tr('Interest Burden', 'عبء الفائدة'),
          s.tr('Financing', 'التمويل'),
          duPontPct(f.interestBurden),
          'EBT / EBIT',
          s.tr(
              'What financing costs take before tax: the share of EBIT left after interest. 100% means no interest drag.',
              'ما تأخذه تكاليف التمويل قبل الضريبة: حصة الربح قبل الفوائد والضرائب المتبقية بعد الفائدة. 100% تعني عدم وجود عبء فائدة.'),
          AppColors.dangerLight),
      card(
          s.tr('EBIT Margin', 'هامش الربح قبل الفوائد والضرائب'),
          s.tr('Operations', 'العمليات'),
          duPontPct(f.ebitMargin),
          'EBIT / Sales',
          s.tr('Operating profit per dollar of sales, before financing costs and taxes.',
              'الربح التشغيلي لكل دولار من المبيعات، قبل تكاليف التمويل والضرائب.'),
          AppColors.info),
      card(
          s.tr('Asset Turnover', 'معدل دوران الأصول'),
          s.tr('Efficiency', 'الكفاءة'),
          duPontTimes(f.assetTurnover),
          'Sales / Total Assets',
          s.tr('How many revenue dollars each dollar of assets generates.',
              'كم دولارًا من الإيرادات يولّده كل دولار من الأصول.'),
          AppColors.accentLight),
      card(
          s.tr('Financial Leverage', 'الرافعة المالية'),
          s.tr('Leverage', 'الرافعة'),
          duPontTimes(f.equityMultiplier),
          'Total Assets / Total Equity',
          s.tr('How much each dollar of equity is amplified by debt. Higher = more leverage.',
              'مدى تضخيم كل دولار من حقوق الملكية بفعل الدين. الأعلى = رافعة أكبر.'),
          AppColors.purple),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlassCard(
          borderColor: AppColors.secondaryLight.withValues(alpha: 0.35),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.pie_chart_rounded, size: 18, color: AppColors.secondaryLight),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(s.tr('Extended 5-Way Decomposition', 'التحليل الخماسي الموسّع'),
                        style: Theme.of(context).textTheme.titleSmall),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                s.tr(
                    'Splits Net Margin into its tax, financing, and operating layers: ROE = Tax Burden × Interest Burden × EBIT Margin × Asset Turnover × Financial Leverage.',
                    'يقسّم هامش صافي الربح إلى طبقاته الضريبية والتمويلية والتشغيلية: العائد على حقوق الملكية = العبء الضريبي × عبء الفائدة × هامش الربح قبل الفوائد والضرائب × معدل دوران الأصول × الرافعة المالية.'),
                style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary(context)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        LayoutBuilder(builder: (context, c) {
          final w = (c.maxWidth - 10) / 2;
          return Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [for (final card in cards) SizedBox(width: w, child: card)],
          );
        }),
        const SizedBox(height: 10),
        GlassCard(padding: const EdgeInsets.all(14), child: _identityStrip(context, s, f)),
      ],
    );
  }

  /// `ROE = tax × interest × EBIT margin × turnover × leverage`, with the reconciliation
  /// line under it (website five-way-identity / five-way-product).
  Widget _identityStrip(BuildContext context, AppStrings s, DuPontFactors f) {
    TextSpan part(String text, Color color, {bool bold = false}) => TextSpan(
        text: text,
        style: GoogleFonts.jetBrainsMono(
            fontSize: 13, fontWeight: bold ? FontWeight.w800 : FontWeight.w600, color: color));
    final op = TextSpan(
        text: ' × ', style: TextStyle(fontSize: 13, color: AppColors.textTertiary(context)));
    return Column(
      children: [
        Text.rich(
          TextSpan(children: [
            part(duPontPct(f.roe), AppColors.primaryLight, bold: true),
            TextSpan(
                text: ' = ', style: TextStyle(fontSize: 13, color: AppColors.textTertiary(context))),
            part(duPontPct(f.taxBurden), AppColors.secondaryLight),
            op,
            part(duPontPct(f.interestBurden), AppColors.dangerLight),
            op,
            part(duPontPct(f.ebitMargin), AppColors.info),
            op,
            part(duPontTimes(f.assetTurnover), AppColors.accentLight),
            op,
            part(duPontTimes(f.equityMultiplier), AppColors.purple),
          ]),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          s.tr('ROE = Tax Burden × Interest Burden × EBIT Margin × Asset Turnover × Financial Leverage',
              'العائد على حقوق الملكية = العبء الضريبي × عبء الفائدة × هامش الربح قبل الفوائد والضرائب × معدل دوران الأصول × الرافعة المالية'),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10.5, color: AppColors.textTertiary(context)),
        ),
        const SizedBox(height: 2),
        Text(
          s.tr(
              'Product of the five factors: ${duPontPct(f.roeFromFiveFactors)} — reconciles with ROE ${duPontPct(f.roe)}',
              'حاصل ضرب العوامل الخمسة: ${duPontPct(f.roeFromFiveFactors)} — يتطابق مع العائد على حقوق الملكية ${duPontPct(f.roe)}'),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10.5, color: AppColors.textTertiary(context)),
        ),
      ],
    );
  }

  Widget _factor(String value, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value,
            style: GoogleFonts.jetBrainsMono(
                fontSize: 16, fontWeight: FontWeight.w800, color: color)),
        const SizedBox(height: 2),
        Text(label,
            style: TextStyle(
                fontSize: 10, color: AppColors.textTertiary(context))),
      ],
    );
  }

  Widget _times() => Text('×',
      style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w300,
          color: AppColors.textTertiary(context)));
}
