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

/// Working-capital metrics as the website computes them (working-capital.tsx, 1fb94ba,
/// 20c170e):
///   DSO = AR / Revenue × 365     DIO = Inventory / COGS × 365     DPO = AP / COGS × 365
///   CCC = DSO + DIO − DPO
///   Working Capital Turnover = Sales / (Current Assets − Current Liabilities)
///   Payables Turnover        = COGS / Accounts Payable  (DPO = 365 ÷ payables turnover)
/// Turnovers are null where their denominator is zero.
///
/// In the simulation model the balance sheet derives AR from Receivables Days and AP from
/// Payables Days, so DSO and DPO come back as those assumptions every round: they are fixed
/// policy assumptions, not outcomes, and the cycle moves with inventory days.
class WorkingCapitalMetrics {
  final double revenue;
  final double cogs;
  final double receivables;
  final double inventory;
  final double payables;
  final double currentAssets;
  final double currentLiabilities;

  const WorkingCapitalMetrics({
    required this.revenue,
    required this.cogs,
    required this.receivables,
    required this.inventory,
    required this.payables,
    required this.currentAssets,
    required this.currentLiabilities,
  });

  /// The model's mechanics: AR and AP follow from the days assumptions.
  factory WorkingCapitalMetrics.fromPolicy({
    required double revenue,
    required double cogs,
    required double receivablesDays,
    required double payablesDays,
    required double inventory,
    required double currentAssets,
    required double currentLiabilities,
  }) =>
      WorkingCapitalMetrics(
        revenue: revenue,
        cogs: cogs,
        receivables: revenue * receivablesDays / 365,
        inventory: inventory,
        payables: cogs * payablesDays / 365,
        currentAssets: currentAssets,
        currentLiabilities: currentLiabilities,
      );

  double get dso => revenue > 0 ? receivables / revenue * 365 : 0;
  double get dio => cogs > 0 ? inventory / cogs * 365 : 0;
  double get dpo => cogs > 0 ? payables / cogs * 365 : 0;
  double get ccc => dso + dio - dpo;
  double get workingCapital => currentAssets - currentLiabilities;
  double get currentRatio => currentLiabilities > 0 ? currentAssets / currentLiabilities : 0;

  double? get wcTurnover {
    final wc = workingCapital;
    return wc != 0 ? revenue / wc : null;
  }

  double? get payablesTurnover => payables != 0 ? cogs / payables : null;
}

/// `2.50×` / `—` (website working-capital.tsx turns).
String wcTurns(double? n) => n == null ? '—' : '${n.toStringAsFixed(2)}×';

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
  // Receivables Days and Payables Days are policy assumptions in the model; AR and AP
  // follow from them (website 20c170e).
  double _receivablesDays = 45;
  double _inventory = 90000;
  double _payablesDays = 50;
  double _currentAssets = 350000;
  double _currentLiabilities = 200000;

  WorkingCapitalMetrics get _m => WorkingCapitalMetrics.fromPolicy(
        revenue: _revenue,
        cogs: _cogs,
        receivablesDays: _receivablesDays,
        payablesDays: _payablesDays,
        inventory: _inventory,
        currentAssets: _currentAssets,
        currentLiabilities: _currentLiabilities,
      );

  double get _dso => _m.dso;
  double get _dio => _m.dio;
  double get _dpo => _m.dpo;
  double get _ccc => _m.ccc;
  double get _workingCapital => _m.workingCapital;
  double get _currentRatio => _m.currentRatio;

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
              'cash faster. In this simulation it is a fixed policy assumption: '
              'Receivables Days, set in the model.',
              'المدة التي يستغرقها العملاء للسداد. الأقل أفضل — تحصّل النقد بسرعة أكبر. '
              'في هذه المحاكاة هي افتراض سياسة ثابت: أيام التحصيل المحددة في النموذج.'),
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
              'cash longer (without damaging supplier relationships). In this '
              'simulation it is a fixed policy assumption: Payables Days, set in the model.',
              'المدة التي تستغرقها لسداد الموردين. الأعلى أفضل — تحتفظ بالنقد لفترة أطول '
              '(دون الإضرار بعلاقات الموردين). في هذه المحاكاة هي افتراض سياسة ثابت: '
              'أيام السداد المحددة في النموذج.'),
          formula: 'DPO = Accounts Payable / COGS × 365',
          color: AppColors.purple,
        ),
        const SizedBox(height: 12),
        ConceptCard(
          icon: Icons.autorenew_rounded,
          title: s.tr('Turnovers', 'معدلات الدوران'),
          body: s.tr(
              'Working Capital Turnover: how many riyals of sales each riyal of working capital '
              'generates - higher means leaner funding of operations. Payables Turnover: how many '
              'times a year payables are settled - the counterpart of DPO (DPO = 365 ÷ payables turnover).',
              'معدل دوران رأس المال العامل: كم ريالًا من المبيعات يولّده كل ريال من رأس المال العامل - '
              'الأعلى يعني تمويلًا أكثر كفاءة للعمليات. معدل دوران الذمم الدائنة: عدد مرات سداد الذمم '
              'الدائنة في السنة - وهو مقابل متوسط فترة السداد (DPO = 365 ÷ معدل دوران الذمم الدائنة).'),
          formula: 'WCT = Sales / (CA − CL)\nPT = COGS / AP',
          color: AppColors.info,
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
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            s.tr(
                'The DSO and DPO lines are flat by design: both are policy assumptions set in the model rather than results of your decisions. Watch DIO and the cash conversion cycle, which respond to what you do with inventory.',
                'خطّا DSO وDPO ثابتان عمدًا: كلاهما افتراض سياسة محدد في النموذج وليس نتيجة لقراراتك. راقب DIO ودورة التحويل النقدي، فهما يستجيبان لما تفعله بالمخزون.'),
            style: TextStyle(fontSize: 11, color: AppColors.textTertiary(context)),
          ),
        ),
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
              const SizedBox(height: 8),
              Text(
                s.tr('DSO and DPO are fixed policy assumptions, so the cycle moves with inventory days.',
                    'متوسطا فترتي التحصيل والسداد افتراضا سياسة ثابتان، لذا تتحرك الدورة مع أيام المخزون.'),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary(context)),
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
                caption: s.tr('Receivables Days, set in the model', 'أيام التحصيل، محددة في النموذج'),
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
                caption: s.tr('Payables Days, set in the model', 'أيام السداد، محددة في النموذج'),
                icon: Icons.call_made_rounded,
                color: AppColors.purple,
              ),
            ),
          ],
        ).animate().fadeIn(delay: 250.ms),
        const SizedBox(height: 6),
        // DSO and DPO are policy assumptions, not outcomes (website 20c170e).
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.textTertiary(context).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.textTertiary(context).withValues(alpha: 0.3)),
              ),
              child: Text(s.tr('Fixed policy assumption', 'افتراض سياسة ثابت'),
                  style: TextStyle(
                      fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textSecondary(context))),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                s.tr('DSO and DPO: set in the Model Editor, not driven by decisions.',
                    'DSO وDPO: محددان في محرر النموذج، ولا تحركهما القرارات.'),
                style: TextStyle(fontSize: 11, color: AppColors.textTertiary(context)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Turnovers (website 1fb94ba).
        Row(
          children: [
            Expanded(
              child: MetricCard(
                title: s.tr('WCT — Working Capital Turnover', 'WCT — دوران رأس المال العامل'),
                value: wcTurns(_m.wcTurnover),
                caption: 'Sales / (CA − CL)',
                icon: Icons.autorenew_rounded,
                color: AppColors.info,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MetricCard(
                title: s.tr('PT — Payables Turnover', 'PT — دوران الذمم الدائنة'),
                value: wcTurns(_m.payablesTurnover),
                caption: 'COGS / AP',
                icon: Icons.sync_alt_rounded,
                color: AppColors.purpleLight,
              ),
            ),
          ],
        ).animate().fadeIn(delay: 275.ms),
        const SizedBox(height: 4),
        Text(
          s.tr(
              'WCT: how many riyals of sales each riyal of working capital generates - higher means leaner funding of operations. PT: how many times a year payables are settled - the counterpart of DPO (DPO = 365 ÷ payables turnover).',
              'WCT: كم ريالًا من المبيعات يولّده كل ريال من رأس المال العامل - الأعلى يعني تمويلًا أكثر كفاءة للعمليات. PT: عدد مرات سداد الذمم الدائنة في السنة - مقابل DPO (DPO = 365 ÷ معدل دوران الذمم الدائنة).'),
          style: TextStyle(fontSize: 11, color: AppColors.textTertiary(context)),
        ),
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
                label: s.tr('Receivables Days (policy)', 'أيام التحصيل (سياسة)'),
                value: _receivablesDays,
                min: 0,
                max: 180,
                suffix: ' d',
                divisions: 36,
                onChanged: (v) => setState(() => _receivablesDays = v),
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
                label: s.tr('Payables Days (policy)', 'أيام السداد (سياسة)'),
                value: _payablesDays,
                min: 0,
                max: 180,
                suffix: ' d',
                divisions: 36,
                onChanged: (v) => setState(() => _payablesDays = v),
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
