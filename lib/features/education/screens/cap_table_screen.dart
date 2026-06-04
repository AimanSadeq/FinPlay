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

/// Cap Table & Dilution. Founders start with 1,000,000 shares. Each funding
/// round issues new shares = investment / price, where price = pre-money /
/// shares outstanding before the round.
class CapTableScreen extends ConsumerStatefulWidget {
  const CapTableScreen({super.key});

  @override
  ConsumerState<CapTableScreen> createState() => _CapTableScreenState();
}

class _Round {
  bool enabled;
  double preMoney;
  double investment;
  _Round(this.enabled, this.preMoney, this.investment);
}

class _Holder {
  final String name;
  final double shares;
  final Color color;
  _Holder(this.name, this.shares, this.color);
}

class _CapTableScreenState extends ConsumerState<CapTableScreen> {
  int _tab = 0;

  static const double _founderShares = 1000000;
  static const _seriesColors = [
    AppColors.primaryLight, // Founders
    AppColors.secondaryLight, // Series A
    AppColors.accentLight, // Series B
    AppColors.purple, // Series C
  ];
  static const _seriesNames = ['Series A', 'Series B', 'Series C'];

  final List<_Round> _rounds = [
    _Round(true, 4000000, 1000000),
    _Round(false, 12000000, 3000000),
    _Round(false, 30000000, 8000000),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gameMetricsProvider.notifier).load();
    });
  }

  /// Equity value per game round — a proxy for ownership value over time.
  List<double?> _equitySeries(GameMetricsState m) =>
      m.series((fd) => fd.totalEquity);

  /// Build the cap table by replaying the funding rounds.
  ({List<_Holder> holders, double price, double postMoney, double totalShares})
      _compute(AppStrings s) {
    final holders = <_Holder>[
      _Holder(s.tr('Founders', 'المؤسسون'), _founderShares, _seriesColors[0]),
    ];
    double sharesOut = _founderShares;
    double price = 0;
    double postMoney = _founderShares > 0 ? 4000000 / _founderShares : 0;

    for (int i = 0; i < _rounds.length; i++) {
      final r = _rounds[i];
      if (!r.enabled) continue;
      final p = sharesOut > 0 ? r.preMoney / sharesOut : 0;
      final newShares = p > 0 ? r.investment / p : 0.0;
      holders.add(_Holder(_seriesNames[i], newShares.toDouble(),
          _seriesColors[i + 1]));
      sharesOut += newShares;
      price = p.toDouble();
      postMoney = r.preMoney + r.investment;
    }
    if (price == 0) price = postMoney / sharesOut;
    return (
      holders: holders,
      price: price,
      postMoney: postMoney,
      totalShares: sharesOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    return ModuleScaffold(
      title: s.tr('Cap Table', 'جدول الملكية'),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentTabBar(
              activeTab: _tab,
              tabs: [
                (icon: Icons.school_rounded, label: s.tr('Learn', 'تعلّم')),
                (icon: Icons.pie_chart_rounded, label: s.tr('Cap Table', 'جدول الملكية')),
              ],
              onChanged: (i) => setState(() => _tab = i),
            ),
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 12),
          Expanded(
            child: AnimatedSwitcher(
              duration: 300.ms,
              child: _tab == 0 ? _buildLearn() : _buildTable(),
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
          icon: Icons.pie_chart_rounded,
          title: s.tr('What is a cap table?', 'ما هو جدول الملكية؟'),
          body: s.tr(
              'A capitalization table lists who owns the company and how much. '
              'It starts with the founders and changes every time new shares are '
              'issued to raise capital.',
              'جدول الملكية (الرسملة) يوضّح من يملك الشركة وبأي نسبة. يبدأ بالمؤسسين '
              'ويتغيّر كلما أُصدرت أسهم جديدة لجمع رأس المال.'),
          color: AppColors.primaryLight,
        ),
        const SizedBox(height: 12),
        ConceptCard(
          icon: Icons.call_split_rounded,
          title: s.tr('Dilution', 'التخفيف (التمييع)'),
          body: s.tr(
              'When new shares are issued to investors, existing owners hold a '
              'smaller slice of a (hopefully) bigger pie. Founder ownership % falls '
              'even though the number of founder shares stays the same.',
              'عند إصدار أسهم جديدة للمستثمرين، يحتفظ المالكون الحاليون بحصة أصغر من '
              'كعكة أكبر (كما يؤمَل). تنخفض نسبة ملكية المؤسسين رغم بقاء عدد أسهمهم كما هو.'),
          formula: 'Ownership % = Your Shares / Total Shares',
          color: AppColors.accentLight,
        ),
        const SizedBox(height: 12),
        ConceptCard(
          icon: Icons.sell_rounded,
          title: s.tr('Share price & new shares', 'سعر السهم والأسهم الجديدة'),
          body: s.tr(
              'Each round prices shares from the pre-money valuation. The capital '
              'raised buys newly issued shares at that price.',
              'تُسعَّر الأسهم في كل جولة من التقييم قبل الاستثمار. ورأس المال المُجمَّع '
              'يشتري أسهمًا مُصدَرة حديثًا بذلك السعر.'),
          formula:
              'Price = Pre-money / Shares\nNew shares = Investment / Price',
          color: AppColors.secondaryLight,
        ),
        const SizedBox(height: 12),
        ConceptCard(
          icon: Icons.trending_up_rounded,
          title: s.tr('Post-money valuation', 'التقييم بعد الاستثمار'),
          body: s.tr(
              'Post-money = Pre-money + Investment. A rising share price across '
              'rounds (an "up round") rewards everyone; a down round dilutes '
              'founders heavily.',
              'التقييم بعد الاستثمار = التقييم قبل الاستثمار + الاستثمار. ارتفاع سعر '
              'السهم عبر الجولات («جولة صاعدة») يكافئ الجميع؛ بينما الجولة الهابطة '
              'تُخفّف حصة المؤسسين بشدة.'),
          color: AppColors.purple,
        ),
      ],
    );
  }

  Widget _buildTable() {
    final s = ref.watch(stringsProvider);
    final c = _compute(s);
    final founderPct = c.holders.first.shares / c.totalShares * 100;

    return ListView(
      key: const ValueKey('table'),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      children: [
        Consumer(builder: (context, ref, _) {
          final s = ref.watch(stringsProvider);
          final m = ref.watch(gameMetricsProvider);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TrendLineChart(
              title: s.tr('Ownership Over Time', 'الملكية عبر الزمن'),
              subtitle: s.tr('Equity value across game rounds', 'قيمة حقوق الملكية عبر جولات اللعبة'),
              values: _equitySeries(m),
              labels: GameMetricsState.roundLabels,
              color: AppColors.primaryLight,
              format: (v) => v.abs() >= 1000 ? '${(v / 1000).toStringAsFixed(0)}k' : v.toStringAsFixed(0),
            ),
          );
        }),
        Row(
          children: [
            Expanded(
              child: MetricCard(
                title: s.tr('Founder Ownership', 'ملكية المؤسسين'),
                value: '${founderPct.toStringAsFixed(1)}%',
                caption: s.tr('After all enabled rounds', 'بعد جميع الجولات المُفعّلة'),
                icon: Icons.flag_rounded,
                color: AppColors.purple,
                highlight: true,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MetricCard(
                title: s.tr('Share Price', 'سعر السهم'),
                value: 'SAR ${c.price.toStringAsFixed(2)}',
                caption: '${(c.price / 4.0).toStringAsFixed(1)}× ${s.tr('baseline', 'الأساس')}',
                icon: Icons.sell_rounded,
                color: AppColors.accentLight,
              ),
            ),
          ],
        ).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: MetricCard(
                title: s.tr('Post-Money', 'بعد الاستثمار'),
                value: fmtMoney(c.postMoney),
                icon: Icons.trending_up_rounded,
                color: AppColors.secondaryLight,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MetricCard(
                title: s.tr('Total Shares', 'إجمالي الأسهم'),
                value: '${(c.totalShares / 1000000).toStringAsFixed(2)}M',
                icon: Icons.confirmation_number_rounded,
                color: AppColors.primaryLight,
              ),
            ),
          ],
        ).animate().fadeIn(delay: 250.ms),
        const SizedBox(height: 14),

        // Ownership pie
        GlassCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.tr('Ownership', 'الملكية'), style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              SizedBox(
                height: 170,
                child: PieChart(PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 38,
                  sections: c.holders.map((h) {
                    final pct = h.shares / c.totalShares * 100;
                    return PieChartSectionData(
                      value: h.shares,
                      color: h.color,
                      radius: 52,
                      title: '${pct.toStringAsFixed(0)}%',
                      titleStyle: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    );
                  }).toList(),
                )),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 14,
                runSpacing: 6,
                alignment: WrapAlignment.center,
                children: c.holders
                    .map((h) => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                                width: 11,
                                height: 11,
                                decoration: BoxDecoration(
                                    color: h.color,
                                    borderRadius: BorderRadius.circular(3))),
                            const SizedBox(width: 5),
                            Text(h.name,
                                style: TextStyle(
                                    fontSize: 11,
                                    color:
                                        AppColors.textSecondary(context))),
                          ],
                        ))
                    .toList(),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 300.ms),
        const SizedBox(height: 14),

        // Holder table
        GlassCard(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              ...c.holders.map((h) {
                final pct = h.shares / c.totalShares * 100;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              color: h.color,
                              borderRadius: BorderRadius.circular(3))),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(h.name,
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary(context))),
                      ),
                      Text('${(h.shares / 1000).toStringAsFixed(0)}k ${s.tr('sh', 'سهم')}',
                          style: GoogleFonts.jetBrainsMono(
                              fontSize: 11,
                              color: AppColors.textTertiary(context))),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 48,
                        child: Text('${pct.toStringAsFixed(1)}%',
                            textAlign: TextAlign.right,
                            style: GoogleFonts.jetBrainsMono(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: h.color)),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ).animate().fadeIn(delay: 350.ms),
        const SizedBox(height: 14),

        // Funding rounds controls
        GlassCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.tr('Funding Rounds', 'جولات التمويل'),
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              ...List.generate(_rounds.length, (i) {
                final r = _rounds[i];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(_seriesNames[i],
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: _seriesColors[i + 1])),
                        const Spacer(),
                        Switch(
                          value: r.enabled,
                          activeTrackColor: _seriesColors[i + 1],
                          onChanged: (v) => setState(() => r.enabled = v),
                        ),
                      ],
                    ),
                    if (r.enabled) ...[
                      SliderRow(
                        label: s.tr('Pre-money valuation', 'التقييم قبل الاستثمار'),
                        value: r.preMoney,
                        min: 1000000,
                        max: 50000000,
                        prefix: 'SAR ',
                        divisions: 49,
                        onChanged: (v) => setState(() => r.preMoney = v),
                      ),
                      SliderRow(
                        label: s.tr('Investment raised', 'الاستثمار المُجمَّع'),
                        value: r.investment,
                        min: 250000,
                        max: 15000000,
                        prefix: 'SAR ',
                        divisions: 59,
                        onChanged: (v) => setState(() => r.investment = v),
                      ),
                    ],
                    if (i < _rounds.length - 1) const Divider(height: 20),
                  ],
                );
              }),
            ],
          ),
        ).animate().fadeIn(delay: 400.ms),
      ],
    );
  }
}
