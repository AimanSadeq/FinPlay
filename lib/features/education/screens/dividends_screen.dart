import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/glass_card.dart';
import '../widgets/module_kit.dart';
import '../../../providers/game_metrics_provider.dart';
import '../../../shared/widgets/trend_line_chart.dart';
import '../../../app/i18n/app_strings.dart';

/// Dividend Policy — payout ratio, retention rate and policy classification.
class DividendsScreen extends ConsumerStatefulWidget {
  const DividendsScreen({super.key});

  @override
  ConsumerState<DividendsScreen> createState() => _DividendsScreenState();
}

class _Policy {
  final String label;
  final String description;
  final Color color;
  const _Policy(this.label, this.description, this.color);
}

class _DividendsScreenState extends ConsumerState<DividendsScreen> {
  int _tab = 0;

  double _netIncome = 200000;
  double _dividends = 60000;

  double get _payout =>
      _netIncome > 0 ? (_dividends / _netIncome).clamp(0, 2) : 0;
  double get _retention => 1 - _payout;
  double get _retainedEarnings => _netIncome - _dividends;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gameMetricsProvider.notifier).load();
    });
  }

  /// Net income per game round — the basis for dividend capacity.
  List<double?> _netIncomeSeries(GameMetricsState m) =>
      m.series((fd) => fd.netIncome);

  _Policy _policyOf(AppStrings s) {
    if (_dividends <= 0) {
      return _Policy(s.tr('No Dividend', 'بدون توزيعات'),
          s.tr('All earnings reinvested — no cash returned to shareholders.',
              'إعادة استثمار كل الأرباح — لا نقد يُعاد إلى المساهمين.'),
          AppColors.darkTextSecondary);
    }
    final p = _payout;
    if (p <= 0.10) {
      return _Policy(s.tr('Reinvestment', 'إعادة الاستثمار'),
          s.tr('Almost all earnings retained to fund growth.',
              'الاحتفاظ بمعظم الأرباح تقريبًا لتمويل النمو.'),
          AppColors.primaryLight);
    } else if (p <= 0.30) {
      return _Policy(s.tr('Growth', 'النمو'),
          s.tr('Modest payout; most earnings reinvested for expansion.',
              'توزيع متواضع؛ إعادة استثمار معظم الأرباح للتوسّع.'),
          AppColors.secondaryLight);
    } else if (p <= 0.50) {
      return _Policy(s.tr('Balanced', 'متوازن'),
          s.tr('A balance between rewarding shareholders and reinvesting.',
              'توازن بين مكافأة المساهمين وإعادة الاستثمار.'),
          AppColors.info);
    } else if (p <= 0.70) {
      return _Policy(s.tr('Mature', 'ناضج'),
          s.tr('Majority of earnings paid out — typical of stable, mature firms.',
              'توزيع غالبية الأرباح — نموذجي للشركات الناضجة المستقرة.'),
          AppColors.accentLight);
    } else {
      return _Policy(s.tr('Cash-Return', 'إعادة النقد'),
          s.tr('Returning most or all earnings — limited reinvestment.',
              'إعادة معظم الأرباح أو كلها — إعادة استثمار محدودة.'),
          AppColors.warning);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    return ModuleScaffold(
      title: s.tr('Dividend Policy', 'سياسة التوزيعات'),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentTabBar(
              activeTab: _tab,
              tabs: [
                (icon: Icons.school_rounded, label: s.tr('Learn', 'تعلّم')),
                (icon: Icons.payments_rounded, label: s.tr('Policy', 'السياسة')),
              ],
              onChanged: (i) => setState(() => _tab = i),
            ),
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 12),
          Expanded(
            child: AnimatedSwitcher(
              duration: 300.ms,
              child: _tab == 0 ? _buildLearn() : _buildPolicy(),
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
          icon: Icons.payments_rounded,
          title: s.tr('Payout vs reinvest', 'التوزيع مقابل إعادة الاستثمار'),
          body: s.tr(
              'After earning a profit, a company chooses how much to pay out as '
              'dividends and how much to retain and reinvest. This split is its '
              'dividend policy.',
              'بعد تحقيق الربح، تختار الشركة كم تدفع كتوزيعات وكم تحتفظ به وتعيد '
              'استثماره. هذا التقسيم هو سياسة التوزيعات الخاصة بها.'),
          color: AppColors.primaryLight,
        ),
        const SizedBox(height: 12),
        ConceptCard(
          icon: Icons.percent_rounded,
          title: s.tr('Payout & retention', 'نسبة التوزيع والاحتجاز'),
          body: s.tr(
              'The payout ratio is the share of earnings returned to shareholders. '
              'Retention is what stays in the business to fund growth.',
              'نسبة التوزيع هي حصة الأرباح المُعادة إلى المساهمين. والاحتجاز هو ما يبقى '
              'في الشركة لتمويل النمو.'),
          formula:
              'Payout = Dividends / Net Income\nRetention = 1 − Payout',
          color: AppColors.secondaryLight,
        ),
        const SizedBox(height: 12),
        ConceptCard(
          icon: Icons.savings_rounded,
          title: s.tr('Retained earnings', 'الأرباح المحتجزة'),
          body: s.tr(
              'Earnings kept in the company add to equity and can fund future '
              'investment without raising new capital.',
              'الأرباح المُبقاة في الشركة تُضاف إلى حقوق الملكية ويمكن أن تموّل الاستثمار '
              'المستقبلي دون جمع رأس مال جديد.'),
          formula: 'Retained Earnings = Net Income − Dividends',
          color: AppColors.accentLight,
        ),
        const SizedBox(height: 12),
        ConceptCard(
          icon: Icons.timeline_rounded,
          title: s.tr('What policy signals', 'ماذا تشير إليه السياسة'),
          body: s.tr(
              'Young, fast-growing firms reinvest (low payout). Mature, stable '
              'firms return more cash (high payout). A sudden cut can worry the '
              'market; a steady, sustainable payout builds confidence.',
              'الشركات الشابة السريعة النمو تعيد الاستثمار (توزيع منخفض). أما الناضجة '
              'المستقرة فتعيد نقدًا أكبر (توزيع مرتفع). والخفض المفاجئ قد يقلق السوق؛ '
              'بينما التوزيع المنتظم المستدام يبني الثقة.'),
          color: AppColors.purple,
        ),
      ],
    );
  }

  Widget _buildPolicy() {
    final s = ref.watch(stringsProvider);
    final policy = _policyOf(s);
    return ListView(
      key: const ValueKey('policy'),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      children: [
        Consumer(builder: (context, ref, _) {
          final s = ref.watch(stringsProvider);
          final m = ref.watch(gameMetricsProvider);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TrendLineChart(
              title: s.tr('Net Income — Trend', 'صافي الدخل — الاتجاه'),
              subtitle: s.tr('Earnings available for dividends, across rounds',
                  'الأرباح المتاحة للتوزيعات، عبر الجولات'),
              values: _netIncomeSeries(m),
              labels: GameMetricsState.roundLabels,
              color: AppColors.secondaryLight,
              format: (v) => v.abs() >= 1000 ? '${(v / 1000).toStringAsFixed(0)}k' : v.toStringAsFixed(0),
            ),
          );
        }),
        VerdictBanner(
          title: '${policy.label} ${s.tr('Policy', 'سياسة')}',
          subtitle: policy.description,
          icon: Icons.payments_rounded,
          color: policy.color,
        ).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(
              child: MetricCard(
                title: s.tr('Payout Ratio', 'نسبة التوزيع'),
                value: '${(_payout * 100).toStringAsFixed(1)}%',
                caption: s.tr('Returned to shareholders', 'تُعاد إلى المساهمين'),
                icon: Icons.call_made_rounded,
                color: policy.color,
                highlight: true,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MetricCard(
                title: s.tr('Retention Rate', 'معدل الاحتجاز'),
                value: '${(_retention * 100).toStringAsFixed(1)}%',
                caption: s.tr('Reinvested in business', 'يُعاد استثماره في الشركة'),
                icon: Icons.savings_rounded,
                color: AppColors.primaryLight,
              ),
            ),
          ],
        ).animate().fadeIn(delay: 250.ms),
        const SizedBox(height: 14),

        // Split donut
        GlassCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.tr('Earnings Split', 'تقسيم الأرباح'),
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              SizedBox(
                height: 160,
                child: PieChart(PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: [
                    PieChartSectionData(
                      value: _dividends.clamp(0, double.infinity),
                      color: policy.color,
                      radius: 50,
                      title: '${(_payout * 100).toStringAsFixed(0)}%',
                      titleStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    PieChartSectionData(
                      value: _retainedEarnings.clamp(0, double.infinity),
                      color: AppColors.primaryLight,
                      radius: 50,
                      title: '${(_retention * 100).toStringAsFixed(0)}%',
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
                  _legend(s.tr('Dividends', 'التوزيعات'), policy.color),
                  const SizedBox(width: 20),
                  _legend(s.tr('Retained', 'المحتجزة'), AppColors.primaryLight),
                ],
              ),
            ],
          ),
        ).animate().fadeIn(delay: 300.ms),
        const SizedBox(height: 14),

        // Components
        Row(
          children: [
            Expanded(
              child: MetricCard(
                title: s.tr('Net Income', 'صافي الدخل'),
                value: fmtMoney(_netIncome),
                icon: Icons.trending_up_rounded,
                color: AppColors.secondaryLight,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: MetricCard(
                title: s.tr('Dividends', 'التوزيعات'),
                value: fmtMoney(_dividends),
                icon: Icons.call_made_rounded,
                color: policy.color,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: MetricCard(
                title: s.tr('Retained', 'المحتجزة'),
                value: fmtMoney(_retainedEarnings),
                icon: Icons.savings_rounded,
                color: AppColors.primaryLight,
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
                min: 0,
                max: 1000000,
                prefix: 'SAR ',
                divisions: 100,
                onChanged: (v) => setState(() {
                  _netIncome = v;
                  if (_dividends > _netIncome) _dividends = _netIncome;
                }),
              ),
              SliderRow(
                label: s.tr('Dividends Paid', 'التوزيعات المدفوعة'),
                value: _dividends,
                min: 0,
                max: _netIncome <= 0 ? 1 : _netIncome,
                prefix: 'SAR ',
                divisions: 100,
                onChanged: (v) => setState(() => _dividends = v),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 400.ms),
      ],
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
