import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/ai_tooltip_button.dart';
import '../../../shared/widgets/trend_line_chart.dart';
import '../widgets/module_kit.dart';
import '../../../providers/game_metrics_provider.dart';
import '../../../app/i18n/app_strings.dart';

/// Financial Ratios reference, organised by the five standard categories:
/// Liquidity, Efficiency, Profitability, Solvency, Market.
class RatiosCategoryScreen extends ConsumerStatefulWidget {
  /// Optional deep-link category (liquidity/efficiency/profitability/solvency/market).
  final String? category;
  const RatiosCategoryScreen({super.key, this.category});

  @override
  ConsumerState<RatiosCategoryScreen> createState() =>
      _RatiosCategoryScreenState();
}

class _RatioInfo {
  final String name;
  final String nameAr;
  final String formula;
  final String benchmark;
  final String benchmarkAr;
  const _RatioInfo(this.name, this.nameAr, this.formula, this.benchmark,
      this.benchmarkAr);
}

class _RatioCategory {
  final String key;
  final String label;
  final String labelAr;
  final String question;
  final String questionAr;
  final IconData icon;
  final Color color;
  final List<_RatioInfo> ratios;
  const _RatioCategory(this.key, this.label, this.labelAr, this.question,
      this.questionAr, this.icon, this.color, this.ratios);
}

// The 18 key ratios the simulation's engine reports (template rows 113-130), grouped by the
// category the template assigns them — the same set the website's /ratios/:category pages
// show. Formulas are the template's own (e.g. operating margin and interest coverage use
// Operating Profit (EBITDA); turnovers use period-end balances).
const _categories = <_RatioCategory>[
  _RatioCategory(
    'liquidity',
    'Liquidity',
    'السيولة',
    'Can the company pay its short-term obligations?',
    'هل تستطيع الشركة سداد التزاماتها قصيرة الأجل؟',
    Icons.water_drop_rounded,
    AppColors.primaryLight,
    [
      _RatioInfo('Current Ratio', 'النسبة المتداولة',
          'Total Current Assets / Total Current Liabilities',
          'Healthy ≈ 1.5–3.0; below 1.0 signals stress',
          'صحية ≈ 1.5–3.0؛ أقل من 1.0 يشير إلى ضغط'),
      _RatioInfo('Quick Ratio', 'النسبة السريعة',
          '(Total Current Assets − Inventory) / Total Current Liabilities',
          '≥ 1.0 is comfortable', '≥ 1.0 مريحة'),
      _RatioInfo('Cash Ratio', 'النسبة النقدية',
          'Cash and Cash Equivalents / Total Current Liabilities',
          'Most conservative; 0.5+ is strong',
          'الأكثر تحفظًا؛ 0.5+ قوية'),
    ],
  ),
  _RatioCategory(
    'efficiency',
    'Efficiency',
    'الكفاءة',
    'How well does the company use its assets?',
    'ما مدى كفاءة الشركة في استخدام أصولها؟',
    Icons.speed_rounded,
    AppColors.secondaryLight,
    [
      _RatioInfo('Inventory Turnover', 'معدل دوران المخزون',
          'Cost of Sales / Inventory',
          'Higher = inventory sells faster', 'الأعلى = بيع المخزون أسرع'),
      _RatioInfo('Receivables Turnover', 'معدل دوران الذمم المدينة',
          'Sales / Accounts Receivable',
          'Higher = efficient credit collection',
          'الأعلى = تحصيل ائتماني فعّال'),
      _RatioInfo('Total Asset Turnover', 'معدل دوران إجمالي الأصول',
          'Sales / Total Assets',
          'Higher = assets generate more sales',
          'الأعلى = الأصول تولّد مبيعات أكثر'),
    ],
  ),
  _RatioCategory(
    'profitability',
    'Profitability',
    'الربحية',
    'How much profit does the company generate?',
    'ما مقدار الربح الذي تحققه الشركة؟',
    Icons.trending_up_rounded,
    AppColors.accentLight,
    [
      _RatioInfo('Gross Profit Margin', 'هامش الربح الإجمالي',
          'Gross Profit / Sales',
          'Higher = stronger pricing/cost control',
          'الأعلى = تسعير/تحكم في التكاليف أقوى'),
      _RatioInfo('Operating Profit Margin', 'هامش الربح التشغيلي',
          'Operating Profit (EBITDA) / Sales',
          'Core operating profitability', 'الربحية التشغيلية الأساسية'),
      _RatioInfo('Net Profit Margin', 'هامش صافي الربح',
          'Net Income / Sales',
          'Bottom-line profit per \$ of sales',
          'صافي الربح لكل دولار مبيعات'),
      _RatioInfo('Return on Assets (ROA)', 'العائد على الأصول (ROA)',
          'Net Income / Total Assets',
          'Profit generated per \$ of assets',
          'الربح المتولّد لكل دولار أصول'),
      _RatioInfo('Return on Equity (ROE)', 'العائد على حقوق الملكية (ROE)',
          "Net Income / Total Shareholders' Equity",
          '15%+ generally considered strong',
          '15%+ تُعد قوية عمومًا'),
    ],
  ),
  _RatioCategory(
    'solvency',
    'Solvency',
    'الملاءة',
    'Can the company meet its long-term obligations?',
    'هل تستطيع الشركة الوفاء بالتزاماتها طويلة الأجل؟',
    Icons.balance_rounded,
    AppColors.purple,
    [
      _RatioInfo('Debt to Equity Ratio', 'نسبة الدين إلى حقوق الملكية',
          "Total Liabilities / Total Shareholders' Equity",
          'Lower = less financial risk', 'الأقل = مخاطر مالية أقل'),
      _RatioInfo('Debt Ratio', 'نسبة الدين',
          'Total Liabilities / Total Assets',
          'Share of assets financed by debt',
          'حصة الأصول المموّلة بالدين'),
      _RatioInfo('Equity Ratio', 'نسبة حقوق الملكية',
          "Total Shareholders' Equity / Total Assets",
          'Share of assets financed by owners',
          'حصة الأصول المموّلة من الملاك'),
      _RatioInfo('Interest Coverage Ratio', 'نسبة تغطية الفائدة',
          'Operating Profit (EBITDA) / Interest Expense',
          '≥ 3–4× is comfortable', '≥ 3–4× مريحة'),
    ],
  ),
  _RatioCategory(
    'market',
    'Market',
    'السوق',
    'How does the market price the company?',
    'كيف يسعّر السوق الشركة؟',
    Icons.show_chart_rounded,
    AppColors.warning,
    [
      _RatioInfo('Earnings per Share (EPS)', 'ربحية السهم (EPS)',
          'Net Income / Shares Outstanding\n(Shares = Common Stock / Par Value)',
          'Profit attributable to each share',
          'الربح العائد لكل سهم'),
      _RatioInfo('Price to Earnings (P/E) Ratio', 'مكرر الربحية (P/E)',
          'Share Price / EPS',
          'Growth expectation vs earnings', 'توقع النمو مقابل الأرباح'),
      _RatioInfo('Market to Book Ratio', 'نسبة القيمة السوقية إلى الدفترية',
          "(Share Price × Shares Outstanding) / Total Shareholders' Equity",
          'Value vs accounting net worth',
          'القيمة مقابل صافي القيمة المحاسبية'),
    ],
  ),
];

/// A ratio value as the website's ratios-category page shows it: n/m for a ratio the
/// engine voids, percent to two decimals for margins and returns, EPS in SAR, everything
/// else to two decimals.
String formatCategoryRatio(double? value, String title) {
  if (value == null) return 'n/m';
  final t = title.toLowerCase();
  if (t.contains('margin') || t.contains('roa') || t.contains('roe') || t.contains('return on')) {
    return '${(value * 100).toStringAsFixed(2)}%';
  }
  if (t.contains('eps') || t.contains('earnings per share')) {
    return 'SAR ${value.toStringAsFixed(2)}';
  }
  return value.toStringAsFixed(2);
}

class _RatiosCategoryScreenState extends ConsumerState<RatiosCategoryScreen> {
  late int _active;

  @override
  void initState() {
    super.initState();
    final idx = _categories.indexWhere((c) => c.key == widget.category);
    _active = idx >= 0 ? idx : 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gameMetricsProvider.notifier).load();
    });
  }

  /// A representative ratio per category, plotted across game rounds:
  /// liquidity → current ratio (from reported ratios); profitability → ROE;
  /// otherwise Debt-to-Equity.
  List<double?> _series(String categoryKey, GameMetricsState m) =>
      m.series((fd) {
        if (categoryKey == 'liquidity') {
          for (final r in fd.ratioRows) {
            if (r.title.toLowerCase().contains('current ratio')) return r.value;
          }
          return null;
        } else if (categoryKey == 'profitability') {
          return fd.totalEquity != 0
              ? fd.netIncome / fd.totalEquity * 100
              : null;
        }
        return fd.totalEquity != 0
            ? fd.totalLiabilities / fd.totalEquity
            : null;
      });

  ({String subtitle, String subtitleAr, String Function(double) format})
      _trendMeta(String categoryKey) {
    if (categoryKey == 'liquidity') {
      return (
        subtitle: 'Current ratio across game rounds',
        subtitleAr: 'النسبة المتداولة عبر جولات اللعبة',
        format: (v) => v.toStringAsFixed(2),
      );
    } else if (categoryKey == 'profitability') {
      return (
        subtitle: 'ROE across game rounds',
        subtitleAr: 'العائد على حقوق الملكية عبر جولات اللعبة',
        format: (v) => '${v.toStringAsFixed(1)}%',
      );
    }
    return (
      subtitle: 'Debt-to-Equity across game rounds',
      subtitleAr: 'الدين إلى حقوق الملكية عبر جولات اللعبة',
      format: (v) => v.toStringAsFixed(2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final cat = _categories[_active];
    return ModuleScaffold(
      title: s.tr('Financial Ratios', 'النسب المالية'),
      child: Column(
        children: [
          // Category chips
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final c = _categories[i];
                final active = i == _active;
                return GestureDetector(
                  onTap: () => setState(() => _active = i),
                  child: AnimatedContainer(
                    duration: 200.ms,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: active
                          ? c.color.withValues(alpha: 0.15)
                          : AppColors.cardColor(context),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: active
                              ? c.color.withValues(alpha: 0.5)
                              : AppColors.borderColor(context)),
                    ),
                    child: Row(
                      children: [
                        Icon(c.icon,
                            size: 15,
                            color: active
                                ? c.color
                                : AppColors.textTertiary(context)),
                        const SizedBox(width: 6),
                        Text(s.tr(c.label, c.labelAr),
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: active
                                    ? c.color
                                    : AppColors.textSecondary(context))),
                      ],
                    ),
                  ),
                );
              },
            ),
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 12),
          Expanded(
            child: AnimatedSwitcher(
              duration: 300.ms,
              child: ListView(
                key: ValueKey(cat.key),
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                children: [
                  Consumer(builder: (context, ref, _) {
                    final s = ref.watch(stringsProvider);
                    final m = ref.watch(gameMetricsProvider);
                    final meta = _trendMeta(cat.key);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TrendLineChart(
                        title: s.tr('Trend — All Periods', 'الاتجاه — جميع الفترات'),
                        subtitle: s.tr(meta.subtitle, meta.subtitleAr),
                        values: _series(cat.key, m),
                        labels: GameMetricsState.roundLabels,
                        color: cat.color,
                        format: meta.format,
                      ),
                    );
                  }),
                  VerdictBanner(
                    title: s.tr('${cat.label} Ratios', 'نسب ${cat.labelAr}'),
                    subtitle: s.tr(cat.question, cat.questionAr),
                    icon: cat.icon,
                    color: cat.color,
                  ),
                  const SizedBox(height: 12),
                  ...cat.ratios.map((r) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Consumer(builder: (context, ref, _) {
                          final latest = ref.watch(gameMetricsProvider).latest;
                          String? value;
                          if (latest != null) {
                            for (final row in latest.ratioRows) {
                              if (row.title.trim().toLowerCase() == r.name.toLowerCase()) {
                                value = formatCategoryRatio(row.value, r.name);
                                break;
                              }
                            }
                          }
                          return _RatioCard(
                              ratio: r, color: cat.color, categoryKey: cat.key, latestValue: value);
                        }),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RatioCard extends StatelessWidget {
  final _RatioInfo ratio;
  final Color color;
  final String categoryKey;

  /// The team's (or learner's) value in the latest played round, when there is game data.
  final String? latestValue;
  const _RatioCard(
      {required this.ratio, required this.color, required this.categoryKey, this.latestValue});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Consumer(builder: (context, ref, _) {
                  final s = ref.watch(stringsProvider);
                  return SectionLabel(
                      label: s.tr(ratio.name, ratio.nameAr).toUpperCase(),
                      color: color);
                }),
              ),
              if (latestValue != null)
                Text(latestValue!,
                    style: GoogleFonts.jetBrainsMono(
                        fontSize: 14, fontWeight: FontWeight.w800, color: color)),
              // Structured AI explanation (definition/formula/benchmarks/impact/risk).
              AiTooltipButton(term: ratio.name, type: categoryKey, color: color, value: latestValue),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withValues(alpha: 0.18)),
            ),
            child: Text(ratio.formula,
                style: GoogleFonts.jetBrainsMono(
                    fontSize: 12.5,
                    height: 1.5,
                    color: AppColors.textPrimary(context))),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.insights_rounded,
                  size: 14, color: AppColors.textTertiary(context)),
              const SizedBox(width: 6),
              Expanded(
                child: Consumer(builder: (context, ref, _) {
                  final s = ref.watch(stringsProvider);
                  return Text(s.tr(ratio.benchmark, ratio.benchmarkAr),
                      style: TextStyle(
                          fontSize: 12,
                          height: 1.4,
                          color: AppColors.textSecondary(context)));
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
