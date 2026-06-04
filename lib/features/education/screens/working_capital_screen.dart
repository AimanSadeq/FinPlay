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

/// Working Capital — DSO, DPO, DIO and the Cash Conversion Cycle.
/// DSO = AR/Revenue×365 · DIO = Inv/COGS×365 · DPO = AP/COGS×365
/// CCC = DSO + DIO − DPO
class WorkingCapitalScreen extends ConsumerStatefulWidget {
  const WorkingCapitalScreen({super.key});

  @override
  ConsumerState<WorkingCapitalScreen> createState() =>
      _WorkingCapitalScreenState();
}

class _WorkingCapitalScreenState extends ConsumerState<WorkingCapitalScreen> {
  int _tab = 0;

  double _revenue = 1000000;
  double _cogs = 600000;
  double _receivables = 120000;
  double _inventory = 90000;
  double _payables = 80000;
  double _currentAssets = 350000;
  double _currentLiabilities = 200000;

  double get _dso => _revenue > 0 ? _receivables / _revenue * 365 : 0;
  double get _dio => _cogs > 0 ? _inventory / _cogs * 365 : 0;
  double get _dpo => _cogs > 0 ? _payables / _cogs * 365 : 0;
  double get _ccc => _dso + _dio - _dpo;
  double get _workingCapital => _currentAssets - _currentLiabilities;
  double get _currentRatio =>
      _currentLiabilities > 0 ? _currentAssets / _currentLiabilities : 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gameMetricsProvider.notifier).load();
    });
  }

  /// Current ratio per game round (from each round's ratios), if reported.
  List<double?> _currentRatioSeries(GameMetricsState m) => m.series((fd) {
        for (final r in fd.ratioRows) {
          if (r.title.toLowerCase().contains('current ratio')) return r.value;
        }
        return null;
      });

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    return ModuleScaffold(
      title: s.tr('Working Capital', 'رأس المال العامل'),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentTabBar(
              activeTab: _tab,
              tabs: [
                (icon: Icons.school_rounded, label: s.tr('Learn', 'تعلّم')),
                (icon: Icons.timelapse_rounded, label: s.tr('Calculator', 'الحاسبة')),
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
          icon: Icons.timelapse_rounded,
          title: s.tr('The Cash Conversion Cycle', 'دورة التحويل النقدي'),
          body: s.tr(
              'The CCC measures how many days cash is tied up in operations — from '
              'paying suppliers, through holding inventory, to collecting from '
              'customers. A shorter cycle frees up cash. Lower is better.',
              'تقيس دورة التحويل النقدي عدد الأيام التي يبقى فيها النقد محتجزًا في العمليات — '
              'من سداد الموردين، مرورًا بالاحتفاظ بالمخزون، وصولًا إلى التحصيل من العملاء. '
              'الدورة الأقصر تحرّر النقد. الأقل أفضل.'),
          formula: 'CCC = DSO + DIO − DPO',
          color: AppColors.secondaryLight,
        ),
        const SizedBox(height: 12),
        ConceptCard(
          icon: Icons.call_received_rounded,
          title: s.tr('DSO — Days Sales Outstanding', 'DSO — متوسط فترة التحصيل'),
          body: s.tr(
              'How long customers take to pay you. Lower is better — you collect '
              'cash faster.',
              'المدة التي يستغرقها العملاء للسداد. الأقل أفضل — تحصّل النقد بسرعة أكبر.'),
          formula: 'DSO = Accounts Receivable / Revenue × 365',
          color: AppColors.primaryLight,
        ),
        const SizedBox(height: 12),
        ConceptCard(
          icon: Icons.inventory_2_rounded,
          title: s.tr('DIO — Days Inventory Outstanding', 'DIO — متوسط فترة بقاء المخزون'),
          body: s.tr(
              'How long inventory sits before it is sold. Lower is better — less '
              'cash locked in stock.',
              'المدة التي يبقى فيها المخزون قبل بيعه. الأقل أفضل — نقد أقل محتجز في المخزون.'),
          formula: 'DIO = Inventory / COGS × 365',
          color: AppColors.accentLight,
        ),
        const SizedBox(height: 12),
        ConceptCard(
          icon: Icons.call_made_rounded,
          title: s.tr('DPO — Days Payable Outstanding', 'DPO — متوسط فترة السداد'),
          body: s.tr(
              'How long you take to pay suppliers. Higher is better — you preserve '
              'cash longer (without damaging supplier relationships).',
              'المدة التي تستغرقها لسداد الموردين. الأعلى أفضل — تحتفظ بالنقد لفترة أطول '
              '(دون الإضرار بعلاقات الموردين).'),
          formula: 'DPO = Accounts Payable / COGS × 365',
          color: AppColors.purple,
        ),
        const SizedBox(height: 12),
        ConceptCard(
          icon: Icons.water_drop_rounded,
          title: s.tr('Liquidity check', 'فحص السيولة'),
          body: s.tr(
              'Working Capital = Current Assets − Current Liabilities. The Current '
              'Ratio above 1.0 means short-term assets fully cover short-term '
              'obligations; below 1.0 may signal liquidity stress.',
              'رأس المال العامل = الأصول المتداولة − الخصوم المتداولة. النسبة المتداولة '
              'فوق 1.0 تعني أن الأصول قصيرة الأجل تغطي الالتزامات قصيرة الأجل بالكامل؛ '
              'وأقل من 1.0 قد يشير إلى ضغط على السيولة.'),
          color: AppColors.info,
        ),
      ],
    );
  }

  Widget _buildCalc() {
    final s = ref.watch(stringsProvider);
    // CCC bands: <30 healthy, 30–60 normal, >60 stress
    final Color cccColor = _ccc < 30
        ? AppColors.secondaryLight
        : _ccc <= 60
            ? AppColors.accentLight
            : AppColors.dangerLight;
    final String cccVerdict = _ccc < 30
        ? s.tr('Healthy — cash moves quickly', 'صحية — النقد يتحرك بسرعة')
        : _ccc <= 60
            ? s.tr('Normal operating cycle', 'دورة تشغيلية طبيعية')
            : s.tr('Working-capital stress', 'ضغط على رأس المال العامل');

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
              subtitle: s.tr('Current ratio across game rounds', 'النسبة المتداولة عبر جولات اللعبة'),
              values: _currentRatioSeries(m),
              labels: GameMetricsState.roundLabels,
              color: const Color(0xFF06B6D4),
              format: (v) => v.toStringAsFixed(2),
            ),
          );
        }),
        // CCC hero
        GlassCard(
          borderColor: cccColor.withValues(alpha: 0.5),
          backgroundColor: cccColor.withValues(alpha: 0.06),
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(Icons.timelapse_rounded, color: cccColor, size: 30),
              const SizedBox(height: 8),
              Text('${_ccc.toStringAsFixed(1)} ${s.tr('days', 'يوم')}',
                  style: GoogleFonts.jetBrainsMono(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: cccColor)),
              Text(s.tr('Cash Conversion Cycle', 'دورة التحويل النقدي'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: cccColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(cccVerdict,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: cccColor)),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: MetricCard(
                title: 'DSO',
                value: '${_dso.toStringAsFixed(1)}d',
                caption: s.tr('Collect — lower better', 'التحصيل — الأقل أفضل'),
                icon: Icons.call_received_rounded,
                color: AppColors.primaryLight,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: MetricCard(
                title: 'DIO',
                value: '${_dio.toStringAsFixed(1)}d',
                caption: s.tr('Inventory — lower better', 'المخزون — الأقل أفضل'),
                icon: Icons.inventory_2_rounded,
                color: AppColors.accentLight,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: MetricCard(
                title: 'DPO',
                value: '${_dpo.toStringAsFixed(1)}d',
                caption: s.tr('Pay — higher better', 'السداد — الأعلى أفضل'),
                icon: Icons.call_made_rounded,
                color: AppColors.purple,
              ),
            ),
          ],
        ).animate().fadeIn(delay: 250.ms),
        const SizedBox(height: 10),

        Row(
          children: [
            Text(s.tr('Liquidity', 'السيولة'),
                style: Theme.of(context).textTheme.titleSmall),
            const AiTooltipButton(term: 'Current Ratio', type: 'liquidity'),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: MetricCard(
                title: s.tr('Working Capital', 'رأس المال العامل'),
                value: fmtMoney(_workingCapital),
                caption: 'CA − CL',
                icon: Icons.account_balance_wallet_rounded,
                color: AppColors.secondaryLight,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MetricCard(
                title: s.tr('Current Ratio', 'النسبة المتداولة'),
                value: _currentRatio.toStringAsFixed(2),
                caption: _currentRatio >= 1.0
                    ? s.tr('Covers obligations', 'تغطي الالتزامات')
                    : s.tr('Liquidity stress', 'ضغط على السيولة'),
                icon: Icons.water_drop_rounded,
                color: _currentRatio >= 1.0
                    ? AppColors.info
                    : AppColors.dangerLight,
              ),
            ),
          ],
        ).animate().fadeIn(delay: 300.ms),
        const SizedBox(height: 14),

        GlassCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.tr('Inputs', 'المدخلات'), style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              SliderRow(
                label: s.tr('Revenue', 'الإيرادات'),
                value: _revenue,
                min: 100000,
                max: 3000000,
                prefix: 'SAR ',
                divisions: 58,
                onChanged: (v) => setState(() => _revenue = v),
              ),
              SliderRow(
                label: s.tr('COGS', 'تكلفة المبيعات'),
                value: _cogs,
                min: 50000,
                max: 2500000,
                prefix: 'SAR ',
                divisions: 49,
                onChanged: (v) => setState(() => _cogs = v),
              ),
              SliderRow(
                label: s.tr('Accounts Receivable', 'الذمم المدينة'),
                value: _receivables,
                min: 0,
                max: 600000,
                prefix: 'SAR ',
                divisions: 60,
                onChanged: (v) => setState(() => _receivables = v),
              ),
              SliderRow(
                label: s.tr('Inventory', 'المخزون'),
                value: _inventory,
                min: 0,
                max: 600000,
                prefix: 'SAR ',
                divisions: 60,
                onChanged: (v) => setState(() => _inventory = v),
              ),
              SliderRow(
                label: s.tr('Accounts Payable', 'الذمم الدائنة'),
                value: _payables,
                min: 0,
                max: 600000,
                prefix: 'SAR ',
                divisions: 60,
                onChanged: (v) => setState(() => _payables = v),
              ),
              const Divider(height: 28),
              SliderRow(
                label: s.tr('Current Assets', 'الأصول المتداولة'),
                value: _currentAssets,
                min: 0,
                max: 1500000,
                prefix: 'SAR ',
                divisions: 60,
                onChanged: (v) => setState(() => _currentAssets = v),
              ),
              SliderRow(
                label: s.tr('Current Liabilities', 'الخصوم المتداولة'),
                value: _currentLiabilities,
                min: 0,
                max: 1500000,
                prefix: 'SAR ',
                divisions: 60,
                onChanged: (v) => setState(() => _currentLiabilities = v),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 400.ms),
      ],
    );
  }
}
