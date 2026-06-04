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
          'Current Assets / Current Liabilities',
          'Healthy ≈ 1.5–3.0; below 1.0 signals stress',
          'صحية ≈ 1.5–3.0؛ أقل من 1.0 يشير إلى ضغط'),
      _RatioInfo('Quick Ratio', 'النسبة السريعة',
          '(Current Assets − Inventory) / Current Liabilities',
          '≥ 1.0 is comfortable', '≥ 1.0 مريحة'),
      _RatioInfo('Cash Ratio', 'النسبة النقدية',
          'Cash & Equivalents / Current Liabilities',
          'Most conservative; 0.5+ is strong',
          'الأكثر تحفظًا؛ 0.5+ قوية'),
      _RatioInfo('Working Capital', 'رأس المال العامل',
          'Current Assets − Current Liabilities',
          'Positive = short-term cushion', 'موجب = وسادة قصيرة الأجل'),
      _RatioInfo('Operating Cash Flow Ratio', 'نسبة التدفق النقدي التشغيلي',
          'Operating Cash Flow / Current Liabilities',
          '> 1.0 means operations cover obligations',
          '> 1.0 تعني أن العمليات تغطي الالتزامات'),
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
          'COGS / Average Inventory',
          'Higher = inventory sells faster', 'الأعلى = بيع المخزون أسرع'),
      _RatioInfo('Days Sales Outstanding', 'متوسط فترة التحصيل',
          'Accounts Receivable / Revenue × 365',
          'Lower = faster collection', 'الأقل = تحصيل أسرع'),
      _RatioInfo('Days Payable Outstanding', 'متوسط فترة السداد',
          'Accounts Payable / COGS × 365',
          'Higher preserves cash (within terms)',
          'الأعلى يحافظ على النقد (ضمن الشروط)'),
      _RatioInfo('Asset Turnover', 'معدل دوران الأصول',
          'Revenue / Total Assets',
          'Higher = assets generate more sales',
          'الأعلى = الأصول تولّد مبيعات أكثر'),
      _RatioInfo('Receivables Turnover', 'معدل دوران الذمم المدينة',
          'Revenue / Average Receivables',
          'Higher = efficient credit collection',
          'الأعلى = تحصيل ائتماني فعّال'),
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
      _RatioInfo('Gross Margin', 'هامش الربح الإجمالي',
          'Gross Profit / Revenue',
          'Higher = stronger pricing/cost control',
          'الأعلى = تسعير/تحكم في التكاليف أقوى'),
      _RatioInfo('Operating Margin', 'هامش الربح التشغيلي',
          'Operating Income / Revenue',
          'Core operating profitability', 'الربحية التشغيلية الأساسية'),
      _RatioInfo('Net Profit Margin', 'هامش صافي الربح',
          'Net Income / Revenue',
          'Bottom-line profit per \$ of sales',
          'صافي الربح لكل دولار مبيعات'),
      _RatioInfo('Return on Assets (ROA)', 'العائد على الأصول (ROA)',
          'Net Income / Total Assets',
          'Profit generated per \$ of assets',
          'الربح المتولّد لكل دولار أصول'),
      _RatioInfo('Return on Equity (ROE)', 'العائد على حقوق الملكية (ROE)',
          'Net Income / Total Equity',
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
      _RatioInfo('Debt-to-Equity', 'الدين إلى حقوق الملكية',
          'Total Debt / Total Equity',
          'Lower = less financial risk', 'الأقل = مخاطر مالية أقل'),
      _RatioInfo('Debt Ratio', 'نسبة الدين',
          'Total Debt / Total Assets',
          'Share of assets financed by debt',
          'حصة الأصول المموّلة بالدين'),
      _RatioInfo('Interest Coverage', 'تغطية الفائدة',
          'EBIT / Interest Expense',
          '≥ 3–4× is comfortable', '≥ 3–4× مريحة'),
      _RatioInfo('Equity Multiplier', 'مضاعف حقوق الملكية',
          'Total Assets / Total Equity',
          'Leverage amplifier', 'مضخّم الرافعة المالية'),
      _RatioInfo('Debt Service Coverage', 'تغطية خدمة الدين',
          'Operating Income / Total Debt Service',
          '> 1.25× preferred by lenders', '> 1.25× يفضّلها المُقرضون'),
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
      _RatioInfo('Price / Earnings (P/E)', 'السعر إلى الأرباح (P/E)',
          'Share Price / EPS',
          'Growth expectation vs earnings', 'توقع النمو مقابل الأرباح'),
      _RatioInfo('Price / Book (P/B)', 'السعر إلى القيمة الدفترية (P/B)',
          'Market Cap / Book Value',
          'Value vs accounting net worth',
          'القيمة مقابل صافي القيمة المحاسبية'),
      _RatioInfo('EV / EBITDA', 'قيمة المنشأة إلى EBITDA',
          'Enterprise Value / EBITDA',
          'Capital-structure-neutral valuation',
          'تقييم محايد لهيكل رأس المال'),
      _RatioInfo('Dividend Yield', 'عائد التوزيعات',
          'Dividend per Share / Share Price',
          'Cash return to shareholders', 'العائد النقدي للمساهمين'),
      _RatioInfo('Earnings Yield', 'عائد الأرباح',
          'EPS / Share Price',
          'Inverse of P/E', 'عكس مكرر الربحية P/E'),
    ],
  ),
];

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
                        child: _RatioCard(ratio: r, color: cat.color, categoryKey: cat.key),
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
  const _RatioCard({required this.ratio, required this.color, required this.categoryKey});

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
              // Structured AI explanation (definition/formula/benchmarks/impact/risk).
              AiTooltipButton(term: ratio.name, type: categoryKey, color: color),
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
