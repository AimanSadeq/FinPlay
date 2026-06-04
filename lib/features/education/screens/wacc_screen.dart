import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/glass_card.dart';
import '../widgets/module_kit.dart';
import '../../../providers/game_metrics_provider.dart';
import '../../../shared/widgets/trend_line_chart.dart';
import '../../../app/i18n/app_strings.dart';

/// WACC — Weighted Average Cost of Capital.
/// WACC = (E/V)·Re + (D/V)·Rd·(1−T)
/// Self-contained calculator mirroring the website's WACC tracker.
class WaccScreen extends ConsumerStatefulWidget {
  const WaccScreen({super.key});

  @override
  ConsumerState<WaccScreen> createState() => _WaccScreenState();
}

class _WaccScreenState extends ConsumerState<WaccScreen> {
  int _tab = 1;

  // Capital structure (in currency units, e.g. thousands)
  double _equity = 600000;
  double _debt = 400000;

  // Costs / assumptions (percent)
  double _costEquity = 12; // Re (used when CAPM inputs are collapsed)
  double _costDebt = 6; // Rd (manual)
  double _taxRate = 15; // Tc

  // CAPM breakdown: Re = Rf + ERP. Off by default (single Re slider).
  bool _useRfErp = false;
  double _riskFree = 4; // Rf
  double _erp = 8; // Equity risk premium (Rf + ERP = 12 = default Re)

  // Use a credit-rating-implied cost of debt (derived from leverage) instead of
  // the manual Rd slider, mirroring the website's rating linkage.
  bool _useRatingImpliedRd = false;

  double get _value => _equity + _debt;
  double get _equityWeight => _value > 0 ? _equity / _value : 0;
  double get _debtWeight => _value > 0 ? _debt / _value : 0;

  /// Cost of equity — from Rf + ERP when the CAPM breakdown is enabled.
  double get _re => _useRfErp ? _riskFree + _erp : _costEquity;

  /// Rating-implied pre-tax cost of debt: a base spread over the risk-free rate
  /// that widens as the firm takes on more leverage (D/V).
  double get _ratingImpliedRd => _riskFree + 1.5 + _debtWeight * 6;
  double get _rd => _useRatingImpliedRd ? _ratingImpliedRd : _costDebt;

  double get _afterTaxRd => _rd * (1 - _taxRate / 100);
  double get _equityContribution => _equityWeight * _re;
  double get _debtContribution => _debtWeight * _afterTaxRd;
  double get _wacc => _equityContribution + _debtContribution;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gameMetricsProvider.notifier).load();
    });
  }

  /// WACC for each game round, computed from that round's capital structure
  /// (equity vs total liabilities) and the current cost assumptions.
  List<double?> _waccSeries(GameMetricsState m) => m.series((fd) {
        final e = fd.totalEquity;
        final d = fd.totalLiabilities;
        final v = e + d;
        if (v <= 0) return null;
        return (e / v) * _re + (d / v) * _afterTaxRd;
      });

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    return ModuleScaffold(
      title: s.tr('WACC', 'المتوسط المرجح لتكلفة رأس المال'),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentTabBar(
              activeTab: _tab,
              tabs: [
                (icon: Icons.school_rounded, label: s.tr('Learn', 'تعلّم')),
                (icon: Icons.calculate_rounded, label: s.tr('Calculator', 'الحاسبة')),
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
          icon: Icons.percent_rounded,
          title: s.tr('What is WACC?', 'ما هو المتوسط المرجح لتكلفة رأس المال؟'),
          body: s.tr(
              'The Weighted Average Cost of Capital is the blended rate a company '
              'pays to finance its assets — combining the cost of equity and the '
              'after-tax cost of debt, each weighted by its share of total capital. '
              'It is the minimum return a company must earn to satisfy all its '
              'capital providers.',
              'المتوسط المرجح لتكلفة رأس المال هو المعدل المختلط الذي تدفعه الشركة '
              'لتمويل أصولها — يجمع بين تكلفة حقوق الملكية وتكلفة الدين بعد الضريبة، '
              'مرجَّحًا كلٌّ منهما بحصته من إجمالي رأس المال. وهو الحد الأدنى من العائد '
              'الذي يجب أن تحققه الشركة لإرضاء جميع مزوّدي رأس المال.'),
          formula: 'WACC = (E/V)·Re + (D/V)·Rd·(1−T)',
          color: AppColors.primaryLight,
        ),
        const SizedBox(height: 12),
        ConceptCard(
          icon: Icons.trending_up_rounded,
          title: s.tr('Cost of Equity (Re)', 'تكلفة حقوق الملكية (Re)'),
          body: s.tr(
              'What shareholders expect for the risk they take. A common estimate '
              'is the risk-free rate plus an equity risk premium (Re = Rf + ERP). '
              'Equity is more expensive than debt because shareholders are paid last.',
              'ما يتوقعه المساهمون مقابل المخاطر التي يتحملونها. أحد التقديرات الشائعة '
              'هو المعدل الخالي من المخاطر مضافًا إليه علاوة مخاطر حقوق الملكية (Re = Rf + ERP). '
              'حقوق الملكية أغلى من الدين لأن المساهمين يُدفع لهم آخرًا.'),
          color: AppColors.secondaryLight,
        ),
        const SizedBox(height: 12),
        ConceptCard(
          icon: Icons.account_balance_rounded,
          title: s.tr('After-Tax Cost of Debt', 'تكلفة الدين بعد الضريبة'),
          body: s.tr(
              'Interest is tax-deductible, so the real cost of debt is reduced by '
              'the tax shield: Rd × (1 − T). This is why moderate leverage can lower '
              'a company’s overall cost of capital.',
              'الفائدة قابلة للخصم الضريبي، لذا تنخفض التكلفة الفعلية للدين بفعل '
              'الدرع الضريبي: Rd × (1 − T). لهذا السبب يمكن للرافعة المالية المعتدلة '
              'أن تخفض التكلفة الإجمالية لرأس مال الشركة.'),
          formula: 'After-tax Rd = Rd × (1 − T)',
          color: AppColors.accentLight,
        ),
        const SizedBox(height: 12),
        ConceptCard(
          icon: Icons.balance_rounded,
          title: s.tr('Why it matters', 'لماذا يهم'),
          body: s.tr(
              'WACC is the hurdle rate for investment decisions — projects should '
              'earn more than WACC to create value. Too little debt wastes the tax '
              'shield; too much debt raises risk and pushes both Re and Rd up.',
              'يُعد المتوسط المرجح لتكلفة رأس المال المعدل الأدنى المقبول لقرارات الاستثمار — '
              'فالمشاريع يجب أن تحقق عائدًا أعلى منه لخلق القيمة. فالدين القليل جدًا يهدر الدرع '
              'الضريبي؛ والدين المفرط يرفع المخاطر ويدفع كلًّا من Re و Rd إلى الأعلى.'),
          color: AppColors.purple,
        ),
      ],
    );
  }

  Widget _buildCalc() {
    final s = ref.watch(stringsProvider);
    final good = _wacc < 8;
    return ListView(
      key: const ValueKey('calc'),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      children: [
        // Hero WACC
        GlassCard(
          borderColor: AppColors.primaryLight.withValues(alpha: 0.4),
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Icon(Icons.percent_rounded,
                  color: AppColors.primaryLight, size: 30),
              const SizedBox(height: 8),
              Text('${_wacc.toStringAsFixed(2)}%',
                  style: GoogleFonts.jetBrainsMono(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryLight)),
              Text(s.tr('Weighted Average Cost of Capital', 'المتوسط المرجح لتكلفة رأس المال'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: (good ? AppColors.secondary : AppColors.accent)
                      .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  good
                      ? s.tr('Efficient capital structure', 'هيكل رأس مال كفؤ')
                      : s.tr('Room to optimise', 'مجال للتحسين'),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: good
                        ? AppColors.secondaryLight
                        : AppColors.accentLight,
                  ),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: 12),

        // Multi-period WACC trend bound to the team's game data.
        Consumer(builder: (context, ref, _) {
          final s = ref.watch(stringsProvider);
          final m = ref.watch(gameMetricsProvider);
          return TrendLineChart(
            title: s.tr('Trend — All Periods', 'الاتجاه — جميع الفترات'),
            subtitle: s.tr('WACC across game rounds', 'المتوسط المرجح عبر جولات اللعبة'),
            values: _waccSeries(m),
            labels: GameMetricsState.roundLabels,
            color: AppColors.primaryLight,
            format: (v) => '${v.toStringAsFixed(1)}%',
          );
        }),
        const SizedBox(height: 12),

        // Contributions
        Row(
          children: [
            Expanded(
              child: MetricCard(
                title: s.tr('Equity Contribution', 'مساهمة حقوق الملكية'),
                value: '${_equityContribution.toStringAsFixed(2)}%',
                caption: '(E/V)·Re',
                icon: Icons.groups_rounded,
                color: AppColors.primaryLight,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MetricCard(
                title: s.tr('Debt Contribution', 'مساهمة الدين'),
                value: '${_debtContribution.toStringAsFixed(2)}%',
                caption: '(D/V)·Rd·(1−T)',
                icon: Icons.account_balance_rounded,
                color: AppColors.purple,
              ),
            ),
          ],
        ).animate().fadeIn(delay: 250.ms),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: MetricCard(
                title: s.tr('After-Tax Cost of Debt', 'تكلفة الدين بعد الضريبة'),
                value: '${_afterTaxRd.toStringAsFixed(2)}%',
                icon: Icons.savings_rounded,
                color: AppColors.accentLight,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MetricCard(
                title: s.tr('Equity Weight', 'وزن حقوق الملكية'),
                value: '${(_equityWeight * 100).toStringAsFixed(0)}%',
                caption: '${s.tr('Debt', 'الدين')} ${(_debtWeight * 100).toStringAsFixed(0)}%',
                icon: Icons.pie_chart_rounded,
                color: AppColors.secondaryLight,
              ),
            ),
          ],
        ).animate().fadeIn(delay: 300.ms),
        const SizedBox(height: 14),

        // Capital structure pie
        GlassCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.tr('Capital Structure', 'هيكل رأس المال'),
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              SizedBox(
                height: 160,
                child: PieChart(PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: [
                    PieChartSectionData(
                      value: _equity,
                      color: AppColors.primaryLight,
                      title: '${(_equityWeight * 100).toStringAsFixed(0)}%',
                      radius: 50,
                      titleStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    PieChartSectionData(
                      value: _debt,
                      color: AppColors.purple,
                      title: '${(_debtWeight * 100).toStringAsFixed(0)}%',
                      radius: 50,
                      titleStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                  ],
                )),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _legend(s.tr('Equity', 'حقوق الملكية'), AppColors.primaryLight),
                  const SizedBox(width: 20),
                  _legend(s.tr('Debt', 'الدين'), AppColors.purple),
                ],
              ),
            ],
          ),
        ).animate().fadeIn(delay: 350.ms),
        const SizedBox(height: 14),

        // Inputs
        GlassCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.tr('Inputs', 'المدخلات'), style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              SliderRow(
                label: s.tr('Total Equity (E)', 'إجمالي حقوق الملكية (E)'),
                value: _equity,
                min: 0,
                max: 2000000,
                prefix: 'SAR ',
                divisions: 40,
                onChanged: (v) => setState(() => _equity = v),
              ),
              SliderRow(
                label: s.tr('Total Debt (D)', 'إجمالي الدين (D)'),
                value: _debt,
                min: 0,
                max: 2000000,
                prefix: 'SAR ',
                divisions: 40,
                onChanged: (v) => setState(() => _debt = v),
              ),
              // Cost of equity — single Re, or the CAPM breakdown Rf + ERP.
              _toggleRow(
                s.tr('Cost of equity from Rf + ERP', 'تكلفة حقوق الملكية من Rf + ERP'),
                _useRfErp,
                (v) => setState(() => _useRfErp = v),
              ),
              if (_useRfErp) ...[
                SliderRow(
                  label: s.tr('Risk-free rate (Rf)', 'المعدل الخالي من المخاطر (Rf)'),
                  value: _riskFree,
                  min: 0,
                  max: 12,
                  suffix: '%',
                  divisions: 48,
                  decimals: 1,
                  onChanged: (v) => setState(() => _riskFree = v),
                ),
                SliderRow(
                  label: s.tr('Equity risk premium (ERP)', 'علاوة مخاطر حقوق الملكية (ERP)'),
                  value: _erp,
                  min: 0,
                  max: 16,
                  suffix: '%',
                  divisions: 64,
                  decimals: 1,
                  onChanged: (v) => setState(() => _erp = v),
                ),
                _derivedRow(s.tr('Cost of Equity (Re = Rf + ERP)', 'تكلفة حقوق الملكية (Re = Rf + ERP)'), '${_re.toStringAsFixed(1)}%'),
              ] else
                SliderRow(
                  label: s.tr('Cost of Equity (Re)', 'تكلفة حقوق الملكية (Re)'),
                  value: _costEquity,
                  min: 4,
                  max: 25,
                  suffix: '%',
                  divisions: 42,
                  decimals: 1,
                  onChanged: (v) => setState(() => _costEquity = v),
                ),

              // Cost of debt — manual, or rating-implied from leverage.
              _toggleRow(
                s.tr('Use credit-rating-implied cost of debt', 'استخدم تكلفة الدين المستنتجة من التصنيف الائتماني'),
                _useRatingImpliedRd,
                (v) => setState(() => _useRatingImpliedRd = v),
              ),
              if (_useRatingImpliedRd)
                _derivedRow(s.tr('Rd (rating-implied from leverage)', 'Rd (مستنتجة من التصنيف بناءً على الرافعة)'), '${_rd.toStringAsFixed(1)}%')
              else
                SliderRow(
                  label: s.tr('Cost of Debt (Rd)', 'تكلفة الدين (Rd)'),
                  value: _costDebt,
                  min: 1,
                  max: 20,
                  suffix: '%',
                  divisions: 38,
                  decimals: 1,
                  onChanged: (v) => setState(() => _costDebt = v),
                ),
              SliderRow(
                label: s.tr('Tax Rate (T)', 'معدل الضريبة (T)'),
                value: _taxRate,
                min: 0,
                max: 50,
                suffix: '%',
                divisions: 50,
                onChanged: (v) => setState(() => _taxRate = v),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 400.ms),
      ],
    );
  }

  Widget _toggleRow(String label, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary(context))),
          ),
          Switch.adaptive(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _derivedRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: TextStyle(
                    fontSize: 13, color: AppColors.textSecondary(context))),
          ),
          Text(value,
              style: GoogleFonts.jetBrainsMono(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryLight)),
        ],
      ),
    );
  }

  Widget _legend(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 6),
        Text(label,
            style: TextStyle(
                fontSize: 12, color: AppColors.textSecondary(context))),
      ],
    );
  }
}
