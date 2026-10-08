import 'dart:math' as math;
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
  final double maxLeverage; // Debt/EBITDA must be at or below this
  final double minCoverage; // Interest coverage must be at/above this
  final int spreadBps; // credit spread over risk-free
  final bool investmentGrade;
  final Color color;
  const _RatingBand(this.letter, this.maxLeverage, this.minCoverage,
      this.spreadBps, this.investmentGrade, this.color);
}

// The website's RATING_SCALE (server/routes/credit-rating.ts, mirrored in wacc.ts).
const _bands = <_RatingBand>[
  _RatingBand('AAA', 1.0, 12.0, 50, true, AppColors.secondary),
  _RatingBand('AA', 1.5, 9.5, 75, true, AppColors.secondaryLight),
  _RatingBand('A', 2.0, 7.0, 125, true, AppColors.primaryLight),
  _RatingBand('BBB', 3.0, 4.0, 175, true, AppColors.info),
  _RatingBand('BB', 4.0, 2.5, 350, false, AppColors.accentLight),
  _RatingBand('B', 5.5, 1.5, 500, false, AppColors.warning),
  _RatingBand('CCC/C', double.infinity, 0.0, 800, false, AppColors.dangerLight),
];

/// Synthetic rating as the website assigns it: each metric picks the best band it
/// qualifies for (Debt/EBITDA at or below the band's maximum; coverage at or above its
/// minimum) and the worse of the two binds. Index 0 = AAA … 6 = CCC/C.
class CreditRatingScale {
  CreditRatingScale._();

  static const letters = ['AAA', 'AA', 'A', 'BBB', 'BB', 'B', 'CCC/C'];
  static const spreads = [0.005, 0.0075, 0.0125, 0.0175, 0.035, 0.05, 0.08];

  /// Debt/EBITDA band. Negative leverage (net cash) rates best; unbounded leverage
  /// (debt with no EBITDA) rates worst.
  static int byLeverage(double debtToEbitda) {
    if (debtToEbitda.isNaN || debtToEbitda == double.infinity) return 6;
    if (debtToEbitda < 0) return 0;
    for (var i = 0; i < _bands.length; i++) {
      if (debtToEbitda <= _bands[i].maxLeverage) return i;
    }
    return _bands.length - 1;
  }

  /// Coverage band. Unbounded coverage (EBITDA with no interest to pay) rates best. (The
  /// website's rateByCoverage maps a non-finite coverage to the worst band; that reads a
  /// debt-free firm as distressed, so the app does not copy it.)
  static int byCoverage(double coverage) {
    if (coverage.isNaN) return 6;
    if (coverage == double.infinity) return 0;
    for (var i = 0; i < _bands.length; i++) {
      if (coverage >= _bands[i].minCoverage) return i;
    }
    return _bands.length - 1;
  }

  /// Worse of the two.
  static int rate({required double debt, required double ebitda, required double interest}) {
    final leverage = ebitda > 0 ? debt / ebitda : (debt > 0 ? double.infinity : 0.0);
    final coverage = interest > 0 ? ebitda / interest : (ebitda > 0 ? double.infinity : 0.0);
    return math.max(byLeverage(leverage), byCoverage(coverage));
  }
}

class _CreditRatingScreenState extends ConsumerState<CreditRatingScreen> {
  int _tab = 0;

  double _debt = 800000;
  double _ebitda = 350000;
  double _interest = 90000;
  double _riskFree = 4; // %

  double get _leverage =>
      _ebitda > 0 ? _debt / _ebitda : (_debt > 0 ? double.infinity : 0);
  double get _coverage =>
      _interest > 0 ? _ebitda / _interest : (_ebitda > 0 ? double.infinity : 0);

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

  int get _byLeverage => CreditRatingScale.byLeverage(_leverage);
  int get _byCoverage => CreditRatingScale.byCoverage(_coverage);

  /// Worse of the two metrics binds (website bindingIndex).
  int get _bandIndex => math.max(_byLeverage, _byCoverage);

  _RatingBand get _band => _bands[_bandIndex];

  /// Which metric is binding: leverage when it gives the worse (or equal) band.
  bool get _leverageBinding => _byLeverage >= _byCoverage;

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
                                ? '${s.tr('Lev', 'رافعة')} ≤ ${b.maxLeverage.toStringAsFixed(1)}× · ${s.tr('Cov', 'تغطية')} ≥ ${b.minCoverage.toStringAsFixed(1)}×'
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
