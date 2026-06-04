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

/// Debt Covenants monitor — leverage (Debt/EBITDA ≤ max) and interest
/// coverage (EBITDA/Interest ≥ min). Shows breach status and headroom.
class CovenantsScreen extends ConsumerStatefulWidget {
  const CovenantsScreen({super.key});

  @override
  ConsumerState<CovenantsScreen> createState() => _CovenantsScreenState();
}

class _CovenantsScreenState extends ConsumerState<CovenantsScreen> {
  int _tab = 0;

  double _debt = 800000;
  double _ebitda = 350000;
  double _interest = 90000;

  // Facilitator-set thresholds (defaults match the website breach banner)
  double _maxLeverage = 3.0;
  double _minCoverage = 4.0;

  double get _leverage => _ebitda > 0 ? _debt / _ebitda : double.infinity;
  double get _coverage => _interest > 0 ? _ebitda / _interest : double.infinity;

  bool get _leverageBreached => _leverage > _maxLeverage;
  bool get _coverageBreached => _coverage < _minCoverage;
  bool get _anyBreached => _leverageBreached || _coverageBreached;

  // Positive headroom = safe buffer (%)
  double get _leverageHeadroom =>
      _maxLeverage > 0 ? (_maxLeverage - _leverage) / _maxLeverage * 100 : 0;
  double get _coverageHeadroom =>
      _minCoverage > 0 ? (_coverage - _minCoverage) / _minCoverage * 100 : 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gameMetricsProvider.notifier).load();
    });
  }

  /// Debt-to-Equity per game round (a covenant-relevant leverage measure).
  List<double?> _leverageSeries(GameMetricsState m) => m.series(
      (fd) => fd.totalEquity != 0 ? fd.totalLiabilities / fd.totalEquity : null);

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    return ModuleScaffold(
      title: s.tr('Debt Covenants', 'تعهدات الدين'),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentTabBar(
              activeTab: _tab,
              tabs: [
                (icon: Icons.school_rounded, label: s.tr('Learn', 'تعلّم')),
                (icon: Icons.gavel_rounded, label: s.tr('Monitor', 'المراقبة')),
              ],
              onChanged: (i) => setState(() => _tab = i),
            ),
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 12),
          Expanded(
            child: AnimatedSwitcher(
              duration: 300.ms,
              child: _tab == 0 ? _buildLearn() : _buildMonitor(),
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
          icon: Icons.gavel_rounded,
          title: s.tr('What are debt covenants?', 'ما هي تعهدات الدين؟'),
          body: s.tr(
              'Covenants are promises in a loan agreement. Maintenance covenants '
              'require the borrower to keep key ratios within agreed limits each '
              'period. Breaching one can trigger lender notification, penalty fees, '
              'higher interest, or even immediate repayment.',
              'التعهدات هي وعود ضمن اتفاقية القرض. تُلزم تعهدات الحفاظ المقترضَ بإبقاء '
              'النسب الرئيسية ضمن الحدود المتفق عليها في كل فترة. وقد يؤدي الإخلال بأحدها '
              'إلى إخطار المُقرض، أو غرامات، أو فائدة أعلى، أو حتى السداد الفوري.'),
          color: AppColors.primaryLight,
        ),
        const SizedBox(height: 12),
        ConceptCard(
          icon: Icons.account_balance_rounded,
          title: s.tr('Leverage covenant', 'تعهد الرافعة المالية'),
          body: s.tr(
              'Caps how much debt you can carry relative to earnings. Stay at or '
              'below the maximum Debt / EBITDA.',
              'يحدّ من مقدار الدين الذي يمكنك تحمّله مقارنةً بالأرباح. ابقَ عند الحد '
              'الأقصى للدين / EBITDA أو دونه.'),
          formula: 'Debt / EBITDA ≤ max',
          color: AppColors.purple,
        ),
        const SizedBox(height: 12),
        ConceptCard(
          icon: Icons.shield_rounded,
          title: s.tr('Coverage covenant', 'تعهد التغطية'),
          body: s.tr(
              'Requires earnings to comfortably cover interest. Stay at or above '
              'the minimum interest coverage.',
              'يتطلب أن تغطي الأرباح الفائدة بشكل مريح. ابقَ عند الحد الأدنى لتغطية '
              'الفائدة أو فوقه.'),
          formula: 'EBITDA / Interest ≥ min',
          color: AppColors.secondaryLight,
        ),
        const SizedBox(height: 12),
        ConceptCard(
          icon: Icons.warning_amber_rounded,
          title: s.tr('Headroom', 'الهامش الآمن'),
          body: s.tr(
              'Headroom is how far a ratio sits from its limit. Positive headroom '
              'is a safety buffer; negative headroom means the covenant is '
              'breached. Watch the binding (closest) covenant carefully.',
              'الهامش الآمن هو مدى بُعد النسبة عن حدّها. الهامش الموجب هو وسادة أمان؛ '
              'والهامش السالب يعني أن التعهد قد خُولف. راقب التعهد الأقرب (الملزِم) بعناية.'),
          color: AppColors.accentLight,
        ),
      ],
    );
  }

  Widget _buildMonitor() {
    final s = ref.watch(stringsProvider);
    return ListView(
      key: const ValueKey('monitor'),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      children: [
        Consumer(builder: (context, ref, _) {
          final s = ref.watch(stringsProvider);
          final m = ref.watch(gameMetricsProvider);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TrendLineChart(
              title: s.tr('Trend vs Thresholds', 'الاتجاه مقابل الحدود'),
              subtitle: s.tr('Debt-to-Equity across game rounds', 'الدين إلى حقوق الملكية عبر جولات اللعبة'),
              values: _leverageSeries(m),
              labels: GameMetricsState.roundLabels,
              color: AppColors.dangerLight,
              format: (v) => v.toStringAsFixed(2),
            ),
          );
        }),
        VerdictBanner(
          title: _anyBreached
              ? s.tr('Covenant Breached', 'تم الإخلال بالتعهد')
              : s.tr('Compliant', 'ملتزم'),
          subtitle: _anyBreached
              ? s.tr('One or more covenants are breached — lender action may follow.',
                  'تم الإخلال بتعهد واحد أو أكثر — قد يتبع ذلك إجراء من المُقرض.')
              : s.tr('All covenants are within their agreed limits.',
                  'جميع التعهدات ضمن حدودها المتفق عليها.'),
          icon: _anyBreached
              ? Icons.error_rounded
              : Icons.check_circle_rounded,
          color:
              _anyBreached ? AppColors.dangerLight : AppColors.secondaryLight,
        ).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: 14),

        Row(
          children: [
            Text(s.tr('Covenants', 'التعهدات'),
                style: Theme.of(context).textTheme.titleSmall),
            const AiTooltipButton(term: 'Debt to EBITDA', type: 'solvency'),
          ],
        ),
        const SizedBox(height: 4),
        _covenantCard(
          title: s.tr('Leverage — Debt / EBITDA', 'الرافعة — الدين / EBITDA'),
          actual: _leverage,
          requirement: '${s.tr('Must be ≤', 'يجب أن يكون ≤')} ${_maxLeverage.toStringAsFixed(1)}×',
          breached: _leverageBreached,
          headroom: _leverageHeadroom,
          color: AppColors.purple,
        ).animate().fadeIn(delay: 250.ms),
        const SizedBox(height: 10),
        _covenantCard(
          title: s.tr('Coverage — EBITDA / Interest', 'التغطية — EBITDA / الفائدة'),
          actual: _coverage,
          requirement: '${s.tr('Must be ≥', 'يجب أن يكون ≥')} ${_minCoverage.toStringAsFixed(1)}×',
          breached: _coverageBreached,
          headroom: _coverageHeadroom,
          color: AppColors.secondaryLight,
        ).animate().fadeIn(delay: 300.ms),
        const SizedBox(height: 14),

        GlassCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.tr('Financials', 'البيانات المالية'),
                  style: Theme.of(context).textTheme.titleLarge),
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
              const Divider(height: 28),
              Text(s.tr('Covenant Thresholds', 'حدود التعهدات'),
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              SliderRow(
                label: s.tr('Max Debt / EBITDA', 'الحد الأقصى للدين / EBITDA'),
                value: _maxLeverage,
                min: 1,
                max: 8,
                suffix: '×',
                divisions: 70,
                decimals: 1,
                onChanged: (v) => setState(() => _maxLeverage = v),
              ),
              SliderRow(
                label: s.tr('Min Interest Coverage', 'الحد الأدنى لتغطية الفائدة'),
                value: _minCoverage,
                min: 1,
                max: 10,
                suffix: '×',
                divisions: 90,
                decimals: 1,
                onChanged: (v) => setState(() => _minCoverage = v),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 350.ms),
      ],
    );
  }

  Widget _covenantCard({
    required String title,
    required double actual,
    required String requirement,
    required bool breached,
    required double headroom,
    required Color color,
  }) {
    final s = ref.watch(stringsProvider);
    final statusColor =
        breached ? AppColors.dangerLight : AppColors.secondaryLight;
    return GlassCard(
      borderColor: statusColor.withValues(alpha: 0.35),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary(context))),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(breached ? s.tr('BREACHED', 'مُخالَف') : s.tr('OK', 'سليم'),
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: statusColor)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(actual.isFinite ? '${actual.toStringAsFixed(2)}×' : '∞',
                  style: GoogleFonts.jetBrainsMono(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: color)),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(requirement,
                    style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textTertiary(context))),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${headroom >= 0 ? s.tr('Headroom', 'الهامش الآمن') : s.tr('Over limit', 'تجاوز الحد')}: '
            '${headroom.abs().toStringAsFixed(1)}%',
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: statusColor),
          ),
        ],
      ),
    );
  }
}
