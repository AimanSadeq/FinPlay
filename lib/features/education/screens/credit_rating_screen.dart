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

/// Synthetic Credit Rating derived from leverage (Debt/EBITDA) and
/// interest coverage (EBITDA/Interest). Rating = worst-of the two metrics.
class CreditRatingScreen extends ConsumerStatefulWidget {
  const CreditRatingScreen({super.key});

  @override
  ConsumerState<CreditRatingScreen> createState() =>
      _CreditRatingScreenState();
}

class _RatingBand {
  final String letter;
  final double maxLeverage; // Debt/EBITDA must be below this
  final double minCoverage; // Interest coverage must be at/above this
  final int spreadBps; // credit spread over risk-free
  final bool investmentGrade;
  final Color color;
  const _RatingBand(this.letter, this.maxLeverage, this.minCoverage,
      this.spreadBps, this.investmentGrade, this.color);
}

const _bands = <_RatingBand>[
  _RatingBand('AAA', 1.0, 8.5, 60, true, AppColors.secondary),
  _RatingBand('AA', 1.5, 7.0, 80, true, AppColors.secondaryLight),
  _RatingBand('A', 2.0, 5.5, 110, true, AppColors.primaryLight),
  _RatingBand('BBB', 3.0, 4.0, 160, true, AppColors.info),
  _RatingBand('BB', 4.0, 3.0, 300, false, AppColors.accentLight),
  _RatingBand('B', 5.5, 2.0, 500, false, AppColors.warning),
  _RatingBand('CCC/C', double.infinity, 0.0, 900, false, AppColors.dangerLight),
];

class _CreditRatingScreenState extends ConsumerState<CreditRatingScreen> {
  int _tab = 0;

  double _debt = 800000;
  double _ebitda = 350000;
  double _interest = 90000;
  double _riskFree = 4; // %

  double get _leverage => _ebitda > 0 ? _debt / _ebitda : double.infinity;
  double get _coverage => _interest > 0 ? _ebitda / _interest : double.infinity;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gameMetricsProvider.notifier).load();
    });
  }

  /// Debt-to-Equity per game round — the leverage driver behind the rating.
  List<double?> _leverageSeries(GameMetricsState m) => m.series(
      (fd) => fd.totalEquity != 0 ? fd.totalLiabilities / fd.totalEquity : null);

  /// Worst-of: find the first (best) band the company qualifies for on BOTH
  /// metrics. The binding metric is the one dragging the rating down.
  int get _bandIndex {
    for (int i = 0; i < _bands.length; i++) {
      final b = _bands[i];
      if (_leverage < b.maxLeverage && _coverage >= b.minCoverage) {
        return i;
      }
    }
    return _bands.length - 1;
  }

  _RatingBand get _band => _bands[_bandIndex];

  /// Which metric is binding (worse): leverage or coverage.
  bool get _leverageBinding {
    // The band would be better if leverage allowed it; compare how far each
    // metric falls. Find best band each metric alone would allow.
    int byLev = _bands.length - 1, byCov = _bands.length - 1;
    for (int i = 0; i < _bands.length; i++) {
      if (_leverage < _bands[i].maxLeverage) {
        byLev = i;
        break;
      }
    }
    for (int i = 0; i < _bands.length; i++) {
      if (_coverage >= _bands[i].minCoverage) {
        byCov = i;
        break;
      }
    }
    return byLev >= byCov; // leverage gives the worse (higher index) band
  }

  double get _impliedCostOfDebt => _riskFree + _band.spreadBps / 100.0;

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    return ModuleScaffold(
      title: s.tr('Credit Rating', 'التصنيف الائتماني'),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentTabBar(
              activeTab: _tab,
              tabs: [
                (icon: Icons.school_rounded, label: s.tr('Learn', 'تعلّم')),
                (icon: Icons.workspace_premium_rounded, label: s.tr('Rating', 'التصنيف')),
              ],
              onChanged: (i) => setState(() => _tab = i),
            ),
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 12),
          Expanded(
            child: AnimatedSwitcher(
              duration: 300.ms,
              child: _tab == 0 ? _buildLearn() : _buildRating(),
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
          icon: Icons.workspace_premium_rounded,
          title: s.tr('What is a credit rating?', 'ما هو التصنيف الائتماني؟'),
          body: s.tr(
              'A credit rating is an opinion on how likely a borrower is to repay '
              'its debt. Higher ratings (AAA–BBB are investment grade) mean lower '
              'risk and cheaper borrowing; speculative grades (BB and below) pay '
              'wider spreads.',
              'التصنيف الائتماني هو رأي حول مدى احتمال سداد المقترض لدينه. التصنيفات '
              'الأعلى (AAA–BBB تُعد درجة استثمارية) تعني مخاطر أقل واقتراضًا أرخص؛ '
              'أما الدرجات المضاربية (BB وما دونها) فتدفع هوامش أوسع.'),
          color: AppColors.primaryLight,
        ),
        const SizedBox(height: 12),
        ConceptCard(
          icon: Icons.account_balance_rounded,
          title: s.tr('Leverage — Debt / EBITDA', 'الرافعة — الدين / EBITDA'),
          body: s.tr(
              'How many years of earnings it would take to repay all debt. Lower '
              'leverage supports a higher rating.',
              'عدد سنوات الأرباح اللازمة لسداد كامل الدين. الرافعة الأقل تدعم تصنيفًا أعلى.'),
          formula: 'Leverage = Total Debt / EBITDA',
          color: AppColors.purple,
        ),
        const SizedBox(height: 12),
        ConceptCard(
          icon: Icons.shield_rounded,
          title: s.tr('Interest Coverage', 'تغطية الفائدة'),
          body: s.tr(
              'How comfortably earnings cover interest payments. Higher coverage '
              'supports a higher rating.',
              'مدى تغطية الأرباح لمدفوعات الفائدة بشكل مريح. التغطية الأعلى تدعم تصنيفًا أعلى.'),
          formula: 'Coverage = EBITDA / Interest Expense',
          color: AppColors.secondaryLight,
        ),
        const SizedBox(height: 12),
        // Rating ladder
        GlassCard(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.tr('Rating Ladder', 'سُلّم التصنيف'),
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              ..._bands.map((b) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: b.color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(b.letter,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.jetBrainsMono(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: b.color)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            b.maxLeverage.isFinite
                                ? '${s.tr('Lev', 'رافعة')} < ${b.maxLeverage.toStringAsFixed(1)}× · ${s.tr('Cov', 'تغطية')} ≥ ${b.minCoverage.toStringAsFixed(1)}×'
                                : s.tr('High leverage or weak coverage', 'رافعة عالية أو تغطية ضعيفة'),
                            style: TextStyle(
                                fontSize: 11.5,
                                color: AppColors.textSecondary(context)),
                          ),
                        ),
                        Text('+${b.spreadBps}bps',
                            style: GoogleFonts.jetBrainsMono(
                                fontSize: 11,
                                color: AppColors.textTertiary(context))),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRating() {
    final s = ref.watch(stringsProvider);
    final b = _band;
    return ListView(
      key: const ValueKey('rating'),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      children: [
        Consumer(builder: (context, ref, _) {
          final s = ref.watch(stringsProvider);
          final m = ref.watch(gameMetricsProvider);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TrendLineChart(
              title: s.tr('Trend — All Periods', 'الاتجاه — جميع الفترات'),
              subtitle: s.tr('Leverage (Debt/Equity) driving the rating, across rounds',
                  'الرافعة (الدين/حقوق الملكية) المحرّكة للتصنيف، عبر الجولات'),
              values: _leverageSeries(m),
              labels: GameMetricsState.roundLabels,
              color: AppColors.accentLight,
              format: (v) => v.toStringAsFixed(2),
            ),
          );
        }),
        GlassCard(
          borderColor: b.color.withValues(alpha: 0.5),
          backgroundColor: b.color.withValues(alpha: 0.06),
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(b.letter,
                  style: GoogleFonts.jetBrainsMono(
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      color: b.color)),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: b.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  b.investmentGrade
                      ? s.tr('Investment Grade', 'درجة استثمارية')
                      : s.tr('Speculative Grade', 'درجة مضاربية'),
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: b.color),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '${s.tr('Implied cost of debt ≈', 'تكلفة الدين الضمنية ≈')} ${_impliedCostOfDebt.toStringAsFixed(2)}%  '
                '(Rf ${_riskFree.toStringAsFixed(1)}% + ${b.spreadBps}bps)',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: 12),

        Row(
          children: [
            Text(s.tr('Coverage & Leverage', 'التغطية والرافعة'),
                style: Theme.of(context).textTheme.titleSmall),
            const AiTooltipButton(term: 'Interest Coverage', type: 'solvency'),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: MetricCard(
                title: 'Debt / EBITDA',
                value: _leverage.isFinite
                    ? '${_leverage.toStringAsFixed(2)}×'
                    : '∞',
                caption: _leverageBinding
                    ? s.tr('Binding metric', 'المقياس الملزِم')
                    : s.tr('Leverage', 'الرافعة'),
                icon: Icons.account_balance_rounded,
                color: AppColors.purple,
                highlight: _leverageBinding,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MetricCard(
                title: s.tr('Interest Coverage', 'تغطية الفائدة'),
                value: _coverage.isFinite
                    ? '${_coverage.toStringAsFixed(2)}×'
                    : '∞',
                caption: !_leverageBinding
                    ? s.tr('Binding metric', 'المقياس الملزِم')
                    : s.tr('Coverage', 'التغطية'),
                icon: Icons.shield_rounded,
                color: AppColors.secondaryLight,
                highlight: !_leverageBinding,
              ),
            ),
          ],
        ).animate().fadeIn(delay: 250.ms),
        const SizedBox(height: 14),

        GlassCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.tr('Inputs', 'المدخلات'), style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              SliderRow(
                label: s.tr('Total Debt', 'إجمالي الدين'),
                value: _debt,
                min: 0,
                max: 3000000,
                prefix: 'SAR ',
                divisions: 60,
                onChanged: (v) => setState(() => _debt = v),
              ),
              SliderRow(
                label: 'EBITDA',
                value: _ebitda,
                min: 10000,
                max: 1500000,
                prefix: 'SAR ',
                divisions: 60,
                onChanged: (v) => setState(() => _ebitda = v),
              ),
              SliderRow(
                label: s.tr('Interest Expense', 'مصروف الفائدة'),
                value: _interest,
                min: 1000,
                max: 500000,
                prefix: 'SAR ',
                divisions: 50,
                onChanged: (v) => setState(() => _interest = v),
              ),
              SliderRow(
                label: s.tr('Risk-Free Rate', 'المعدل الخالي من المخاطر'),
                value: _riskFree,
                min: 0,
                max: 12,
                suffix: '%',
                divisions: 48,
                decimals: 1,
                onChanged: (v) => setState(() => _riskFree = v),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 350.ms),
      ],
    );
  }
}
