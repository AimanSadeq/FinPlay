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

  double get _netMargin => _revenue > 0 ? _netIncome / _revenue : 0; // fraction
  double get _assetTurnover => _assets > 0 ? _revenue / _assets : 0; // ratio
  double get _equityMultiplier => _equity > 0 ? _assets / _equity : 0; // ratio
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
            ],
          ),
        ).animate().fadeIn(delay: 400.ms),
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
