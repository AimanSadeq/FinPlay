import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/theme/app_colors.dart';
import '../../../data/models/financial_data.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/team_provider.dart';
import '../../../providers/financial_provider.dart';
import '../../../providers/game_state_provider.dart';
import '../../../providers/self_paced_provider.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../providers/game_metrics_provider.dart';
import '../../../shared/widgets/animated_counter.dart';
import '../../../shared/widgets/shimmer_loading.dart';
import '../../../shared/widgets/header_timer.dart';
import '../../../shared/widgets/active_shocks_display.dart';
import '../../../core/network/api_client.dart' show httpStatusKey;
import '../../../core/network/api_endpoints.dart';
import '../../../data/repositories/self_paced_repository.dart' show isSubscriptionRequiredError;
import '../../../providers/repository_providers.dart';
import '../../self_paced/widgets/entitlement_banner.dart' show AccessEndedView;
import '../widgets/pdf_report_button.dart';
import '../widgets/round_report_link.dart';
import '../widgets/statement_compare_table.dart';
import '../logic/statement_analysis.dart';
import '../logic/ratio_format.dart';
import '../logic/covenant_metrics.dart';
import '../providers/statement_compare_provider.dart';
import '../providers/realism_flags_provider.dart';
import '../../debrief/widgets/round_analysis_section.dart';
import '../../achievements/widgets/performance_index_leaderboard.dart';
import '../../../app/i18n/app_strings.dart';
import '../../../shared/widgets/ai_tooltip_button.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _stmtTabController;
  int _selectedRound = 0; // 0 = current/latest

  final Set<int> _loadedTabs = {0}; // Track which tabs have been loaded

  // "Compare with" choice for the statement tables: null = the round before the one shown
  // (website d9314e8). Variance and common-size columns, both on by default (b3abe28).
  int? _compareRound;
  AnalysisShow _analysisShow = const AnalysisShow();

  // Corporate teams follow the facilitator out of the results page (website e79f66c,
  // 1224147). A team lands here when its round is over; when the facilitator opens the
  // next round the team's stored module flips from 'dashboard' to 'financing' (or, for a
  // team that arrived from the operating screen, the round number goes up). Without this
  // the team sat on the results page with no way back to its decisions.
  static const _decisionModules = ['financing', 'investing', 'operating'];
  Timer? _roundOpenPollTimer;
  String? _openModule;
  int? _openRound;
  bool _openHasConfirmed = false;
  ({String module, int round})? _lastSeenProgression;
  bool _leavingForDecisions = false;

  @override
  void initState() {
    super.initState();
    _stmtTabController = TabController(length: 4, vsync: this);
    _stmtTabController.addListener(_onTabChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
      ref.read(gameMetricsProvider.notifier).load();
      _pollTeamProgression();
      _roundOpenPollTimer =
          Timer.periodic(const Duration(seconds: 5), (_) => _pollTeamProgression());
    });
  }

  @override
  void dispose() {
    _roundOpenPollTimer?.cancel();
    _stmtTabController.removeListener(_onTabChanged);
    _stmtTabController.dispose();
    super.dispose();
  }

  /// GET /team-progression/status/{teamId} every 5s while a corporate team is on results.
  Future<void> _pollTeamProgression() async {
    final team = ref.read(teamProvider).selectedTeam;
    if (!mounted || team == null || _leavingForDecisions) return;
    try {
      final res = await ref.read(apiClientProvider).get(
            '${ApiEndpoints.teamProgression}/${Uri.encodeComponent(team.id)}',
          );
      if (!mounted || res[httpStatusKey] != null) return;
      final module = res['currentModule']?.toString();
      final round = (res['currentRound'] as num?)?.toInt() ?? 0;
      if (module == null) return;
      final prev = _lastSeenProgression;
      _lastSeenProgression = (module: module, round: round);
      setState(() {
        _openModule = module;
        _openRound = round;
        _openHasConfirmed = res['hasConfirmedDecisions'] == true;
      });
      if (prev == null || !_decisionModules.contains(module)) return;
      // Two ways the facilitator reopens decisions for a team parked here: the module was
      // 'dashboard' and becomes a decision module, or the round number goes up.
      if (prev.module == 'dashboard' || round > prev.round) _goToDecisions();
    } catch (_) {/* keep polling */}
  }

  /// A team that confirmed its operating decisions is done with the round: its module
  /// still reads 'operating', but there is nothing left to decide.
  bool get _decisionsOpen {
    final module = _openModule;
    if (module == null || !_decisionModules.contains(module)) return false;
    return !(module == 'operating' && _openHasConfirmed);
  }

  void _goToDecisions() {
    if (!mounted || _leavingForDecisions) return;
    final team = ref.read(teamProvider).selectedTeam;
    final module = _openModule;
    // Seed the cached team so the simulation does not start from a stale module.
    if (team != null && module != null && _decisionModules.contains(module)) {
      ref.read(teamProvider.notifier).updateTeamFromSocket(team
          .copyWith(currentModule: module, currentRound: _openRound)
          .toJson());
    }
    _leavingForDecisions = true;
    ref.read(gameStateProvider.notifier).fetchGameState();
    context.go('/simulation');
  }

  Widget _buildRoundOpenCta(BuildContext context, AppStrings s) {
    final round = _openRound ?? 1;
    final module = _openModule ?? 'financing';
    final moduleLabel = switch (module) {
      'investing' => s.tr('investing', 'الاستثمار'),
      'operating' => s.tr('operating', 'التشغيل'),
      _ => s.tr('financing', 'التمويل'),
    };
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: GlassCard(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              const Icon(Icons.lock_open_rounded, color: AppColors.secondary, size: 26),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  s.tr('Round $round $moduleLabel is open', 'قرارات $moduleLabel للجولة $round مفتوحة'),
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: _goToDecisions,
                icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                label: Text(s.tr('Go to decisions', 'الذهاب إلى القرارات')),
                style: FilledButton.styleFrom(backgroundColor: AppColors.secondary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTabChanged() {
    if (_stmtTabController.indexIsChanging) return;
    final tabIndex = _stmtTabController.index;
    if (_loadedTabs.contains(tabIndex)) return;
    _loadedTabs.add(tabIndex);
    // Lazy-load the statement for this tab
    final team = ref.read(teamProvider).selectedTeam;
    // Self-paced learners have no per-statement endpoint; the per-learner batch
    // dashboard already populated all four statements, so skip lazy loading.
    if (team == null) return;
    final round = _selectedRound > 0 ? _selectedRound : _activeRound;
    const statements = ['income', 'balance', 'cashflow', 'ratios'];
    ref.read(financialProvider.notifier).fetchStatement(team.id, statements[tabIndex], round: round);
  }

  static const _analyticsItems = <(String, String, IconData, Color, String)>[
    ('Cap Table', 'Ownership & dilution', Icons.pie_chart_rounded, AppColors.primaryLight, '/education/cap-table'),
    ('Debt Covenants', 'Maintenance & breaches', Icons.gavel_rounded, AppColors.dangerLight, '/education/covenants'),
    ('Credit Rating', 'Rating & spread', Icons.star_rounded, AppColors.accentLight, '/education/credit-rating'),
    ('Dividend Policy', 'Payout & retention', Icons.payments_rounded, AppColors.secondaryLight, '/education/dividends'),
    ('DuPont', 'ROE decomposition', Icons.account_tree_rounded, AppColors.purple, '/education/dupont'),
    ('WACC', 'Cost of capital', Icons.percent_rounded, AppColors.info, '/education/wacc'),
    ('Working Capital', 'Liquidity & CCC', Icons.water_drop_rounded, Color(0xFF06B6D4), '/education/working-capital'),
    ('Ratios', 'All ratio categories', Icons.insights_rounded, AppColors.primaryLight, '/ratios/liquidity'),
  ];

  /// Live latest-round value for a card (null when no game data). Returns the
  /// display value and, for covenants, whether the leverage covenant is breached.
  (String?, bool) _cardMetric(String route, FinancialData? fd, RealismFlags flags) {
    if (fd == null) return (null, false);
    double? currentRatio() {
      for (final r in fd.ratioRows) {
        if (r.title.toLowerCase().contains('current ratio')) return r.value;
      }
      return null;
    }
    String k(double v) => v.abs() >= 1000 ? '${(v / 1000).toStringAsFixed(0)}k' : v.toStringAsFixed(0);
    final de = fd.totalEquity != 0 ? fd.totalLiabilities / fd.totalEquity : null;
    switch (route) {
      case '/education/cap-table':
        return ('Equity ${k(fd.totalEquity)}', false);
      case '/education/covenants':
        // Debt/EBITDA against the facilitator's leverage covenant (default max 4.0x),
        // derived as the website's covenants route does.
        final cov = CovenantMetrics.fromFinancials(fd);
        final dte = cov.debtToEbitda;
        final breached = cov.leverageBreached(flags.maxDebtToEbitda) ||
            cov.coverageBreached(flags.minInterestCoverage);
        return ('Debt/EBITDA ${dte == null ? 'n/m' : '${dte.toStringAsFixed(2)}x'}', breached);
      case '/education/credit-rating':
        return (de == null ? null : 'Lev ${de.toStringAsFixed(2)}', false);
      case '/education/dividends':
        return ('NI ${k(fd.netIncome)}', false);
      case '/education/dupont':
        return (fd.totalEquity != 0 ? 'ROE ${(fd.netIncome / fd.totalEquity * 100).toStringAsFixed(1)}%' : null, false);
      case '/education/working-capital':
        final cr = currentRatio();
        return (cr == null ? null : 'CR ${cr.toStringAsFixed(2)}', false);
      default:
        return (null, false);
    }
  }

  /// Which realism flag gates each analytics card (website RealismModulesRow).
  static const _cardFlags = {
    '/education/cap-table': 'capTableEnabled',
    '/education/covenants': 'debtCovenantsEnabled',
    '/education/credit-rating': 'creditRatingEnabled',
    '/education/dividends': 'dividendPolicyEnabled',
    '/education/dupont': 'duPontEnabled',
    '/education/wacc': 'waccEnabled',
    '/education/working-capital': 'workingCapitalEnabled',
  };

  Widget _buildAnalyticsCards({required bool selfPaced}) {
    final fd = ref.watch(gameMetricsProvider).latest;
    final s = ref.watch(stringsProvider);
    // A corporate team sees only the modules the facilitator enabled; a self-paced learner
    // has no facilitator and sees them all (website use-realism-flag.ts ALL_ON).
    final flags = selfPaced
        ? RealismFlags.allOn
        : ref.watch(corporateRealismFlagsProvider).valueOrNull;
    if (flags == null) return const SizedBox.shrink();
    final items = [
      for (final it in _analyticsItems)
        if (it.$5 == '/ratios/liquidity'
            ? flags.anyRatios
            : flags.isOn(_cardFlags[it.$5] ?? ''))
          it.$5 == '/ratios/liquidity'
              ? (it.$1, it.$2, it.$3, it.$4, flags.firstRatiosRoute ?? it.$5)
              : it,
    ];
    if (items.isEmpty) return const SizedBox.shrink();
    String trTitle(String en) => switch (en) {
          'Cap Table' => s.tr('Cap Table', 'جدول الملكية'),
          'Debt Covenants' => s.tr('Debt Covenants', 'تعهدات الدين'),
          'Credit Rating' => s.tr('Credit Rating', 'التصنيف الائتماني'),
          'Dividend Policy' => s.tr('Dividend Policy', 'سياسة التوزيعات'),
          'DuPont' => s.tr('DuPont', 'ديبون'),
          'WACC' => s.tr('WACC', 'متوسط تكلفة رأس المال'),
          'Working Capital' => s.tr('Working Capital', 'رأس المال العامل'),
          'Ratios' => s.tr('Ratios', 'النسب'),
          _ => en,
        };
    String trSubtitle(String en) => switch (en) {
          'Ownership & dilution' => s.tr('Ownership & dilution', 'الملكية والتخفيف'),
          'Maintenance & breaches' => s.tr('Maintenance & breaches', 'الالتزام والمخالفات'),
          'Rating & spread' => s.tr('Rating & spread', 'التصنيف والفارق'),
          'Payout & retention' => s.tr('Payout & retention', 'التوزيع والاحتجاز'),
          'ROE decomposition' => s.tr('ROE decomposition', 'تحليل العائد على حقوق الملكية'),
          'Cost of capital' => s.tr('Cost of capital', 'تكلفة رأس المال'),
          'Liquidity & CCC' => s.tr('Liquidity & CCC', 'السيولة ودورة التحويل النقدي'),
          'All ratio categories' => s.tr('All ratio categories', 'جميع فئات النسب'),
          _ => en,
        };
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.analytics_rounded, size: 18, color: AppColors.primaryLight),
              const SizedBox(width: 8),
              Text(s.tr('Advanced Analytics', 'تحليلات متقدمة'), style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.9,
            children: items.map((it) {
              final (title, subtitle, icon, color, route) = it;
              final (value, breached) = _cardMetric(route, fd, flags);
              return GlassCard(
                onTap: () => context.push(route),
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Icon(icon, size: 16, color: color),
                        ),
                        const Spacer(),
                        if (breached)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.danger.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('BREACH',
                                style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: AppColors.dangerLight)),
                          )
                        else
                          Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.textTertiary(context)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(trTitle(title), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                    Text(value ?? trSubtitle(subtitle),
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: value != null ? FontWeight.w700 : FontWeight.normal,
                            color: value != null ? color : AppColors.textTertiary(context)),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _loadData() {
    final team = ref.read(teamProvider).selectedTeam;
    final auth = ref.read(authProvider);
    // Use selected round, or fall back to active game round
    final round = _selectedRound > 0 ? _selectedRound : _activeRound;
    ref.invalidate(statementCompareProvider);
    if (team != null) {
      ref.read(financialProvider.notifier).refreshAll(team.id, round: round);
    } else if (auth.user != null && !auth.isFacilitator) {
      _loadSelfPacedData();
    } else {
      ref.read(financialProvider.notifier).fetchLeaderboard(round: round);
    }
  }

  /// Self-paced: per-learner dashboard computed from the learner's OWN decisions
  /// (shock-isolated). The displayed round is the latest COMPLETED round
  /// (currentRound-1), matching the website's spDisplayRound.
  Future<void> _loadSelfPacedData() async {
    await ref.read(selfPacedProvider.notifier).fetchProgress();
    if (!mounted) return;
    final round = _selectedRound > 0 ? _selectedRound : _activeRound;
    if (round <= 0) return; // no completed rounds yet — nothing to display
    ref.read(financialProvider.notifier).refreshAll('self', round: round, selfPaced: true);
  }

  void _onRoundSelected(int round) {
    if (round == _selectedRound) return;
    setState(() {
      _selectedRound = round;
      _loadedTabs.clear();
      _loadedTabs.add(0); // Income is always loaded with initial data
    });
    _loadData();
  }

  /// Self-paced mid-game "Continue to Round N" CTA. The round ends on the
  /// dashboard (results review) before proceeding to the next round (5e0c6f4).
  Widget _buildSelfPacedContinueCta(BuildContext context, AppStrings s) {
    final sp = ref.watch(selfPacedProvider);
    final isComplete = sp.currentRound >= 3 && sp.currentModule == 'complete';
    final displayRound = _activeRound; // latest completed round
    if (isComplete || displayRound <= 0) return const SliverToBoxAdapter(child: SizedBox.shrink());
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: GlassCard(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              const Icon(Icons.flag_circle_rounded, color: AppColors.secondary, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.tr('Round $displayRound results are in',
                          'نتائج الجولة $displayRound جاهزة'),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      s.tr('Review your statements & analytics below, then continue.',
                          'راجع قوائمك وتحليلاتك أدناه، ثم تابع.'),
                      style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: () => context.go('/simulation'),
                icon: const Icon(Icons.trending_up_rounded, size: 16),
                label: Text(s.tr('Continue to Round ${sp.currentRound}',
                    'متابعة إلى الجولة ${sp.currentRound}')),
                style: FilledButton.styleFrom(backgroundColor: AppColors.secondary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int get _activeRound {
    // Self-paced: the active round to DISPLAY is the latest completed round
    // (currentRound-1), or 3 when the game is complete — website's spDisplayRound.
    final team = ref.read(teamProvider).selectedTeam;
    final auth = ref.read(authProvider);
    if (team == null && auth.user != null && !auth.isFacilitator) {
      final sp = ref.read(selfPacedProvider);
      final complete = sp.currentRound >= 3 && sp.currentModule == 'complete';
      return complete ? 3 : (sp.currentRound - 1).clamp(0, 3);
    }
    final gs = ref.read(gameStateProvider);
    return gs.whenOrNull(data: (g) => g.currentRound) ?? 1;
  }

  Future<void> _exportCsv(BuildContext context) async {
    final financials = ref.read(financialProvider);
    final data = financials.teamFinancials;
    final s = ref.read(stringsProvider);
    if (data == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.tr('No financial data to export', 'لا توجد بيانات مالية للتصدير')), backgroundColor: AppColors.accent),
      );
      return;
    }

    final buffer = StringBuffer();
    buffer.writeln('Financial Statement Export');
    buffer.writeln('Round: ${_selectedRound > 0 ? _selectedRound : "Current"}');
    buffer.writeln('');

    // Income Statement
    if (data.incomeStatement?.isNotEmpty == true) {
      buffer.writeln('--- Income Statement ---');
      for (final entry in data.incomeStatement!.entries) {
        buffer.writeln('${entry.key},${entry.value}');
      }
      buffer.writeln('');
    }

    // Balance Sheet
    if (data.balanceSheet?.isNotEmpty == true) {
      buffer.writeln('--- Balance Sheet ---');
      for (final entry in data.balanceSheet!.entries) {
        buffer.writeln('${entry.key},${entry.value}');
      }
      buffer.writeln('');
    }

    // Cash Flow
    if (data.cashFlow?.isNotEmpty == true) {
      buffer.writeln('--- Cash Flow Statement ---');
      for (final entry in data.cashFlow!.entries) {
        buffer.writeln('${entry.key},${entry.value}');
      }
    }

    await Clipboard.setData(ClipboardData(text: buffer.toString()));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(s.tr('Financial data copied to clipboard', 'تم نسخ البيانات المالية إلى الحافظة')),
          backgroundColor: AppColors.secondary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  /// Opens the print-ready round report (HTML) in the browser, where it can be
  /// saved as PDF. Mirrors the website's window.open of the same endpoint.
  Future<void> _openRoundReport(BuildContext context, String teamId) async {
    final s = ref.read(stringsProvider);
    final round = _selectedRound > 0 ? _selectedRound : _activeRound;
    bool ok = false;
    try {
      // Carries the team-member token as ?token= (website 1cfce67); rounds clamp to 1–3.
      final uri = await buildRoundReportUri(ref.read(apiClientProvider), teamId, round);
      ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      ok = false;
    }
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(s.tr('Could not open report', 'تعذّر فتح التقرير')),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final teamState = ref.watch(teamProvider);
    final financials = ref.watch(financialProvider);
    final team = teamState.selectedTeam;
    final authState = ref.watch(authProvider);
    final isSelfPaced = authState.user != null && !authState.isFacilitator && team == null;
    final data = financials.teamFinancials;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final s = ref.watch(stringsProvider);

    // Statement comparison: the round shown against the chosen earlier period, fetched in
    // one dashboard-data call (website d9314e8). Rounds 1..3 only; baseline has no compare.
    final displayRound = _selectedRound > 0 ? _selectedRound : _activeRound;
    final compareRound = resolveCompareRound(displayRound, _compareRound);
    final StatementComparison? comparison = (data != null &&
            displayRound >= 1 &&
            displayRound <= 3 &&
            (isSelfPaced || team != null))
        ? ref
            .watch(statementCompareProvider((
              selfPaced: isSelfPaced,
              teamId: team?.id ?? '',
              round: displayRound,
              compare: compareRound,
            )))
            .valueOrNull
        : null;
    final hasComparison = comparison != null && !comparison.current.isEmpty;

    // Lapsed self-paced learner: /self-paced/progress/dashboard-data answers 402
    // SUBSCRIPTION_REQUIRED. Show the access-ended notice instead of empty statements.
    if (isSelfPaced &&
        (isSubscriptionRequiredError(financials.error) ||
            ref.watch(selfPacedProvider).entitlement.isLapsed)) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(gradient: AppColors.backgroundGradient(context)),
          child: SafeArea(
            child: AccessEndedView(
              onBack: () => context.canPop() ? context.pop() : context.go('/self-paced-progress'),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient(context)),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async => _loadData(),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                    child: Row(
                      children: [
                        IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () {
                          if (Navigator.of(context).canPop()) {
                            context.pop();
                          } else {
                            context.go('/');
                          }
                        }),
                        if (!isSelfPaced) ...[
                          const SizedBox(width: 4),
                          const HeaderTimer(),
                        ],
                        const Spacer(),
                        Text(s.tr('Dashboard', 'لوحة المعلومات'), style: Theme.of(context).textTheme.headlineMedium),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.download_rounded, size: 20),
                          onPressed: () => _exportCsv(context),
                          tooltip: s.tr('Export CSV', 'تصدير CSV'),
                          visualDensity: VisualDensity.compact,
                        ),
                        IconButton(
                          icon: const Icon(Icons.map_rounded),
                          tooltip: s.tr('Game Map', 'خريطة اللعبة'),
                          onPressed: () => context.push('/game-map'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.compare_arrows_rounded),
                          tooltip: s.tr('Compare Teams', 'مقارنة الفرق'),
                          onPressed: () => context.push('/team-comparison'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.insights_rounded),
                          tooltip: s.tr('Multi-Round Trends', 'اتجاهات متعددة الجولات'),
                          onPressed: () => context.push('/multi-round-dashboard'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.military_tech_rounded),
                          tooltip: s.tr('Achievements', 'الإنجازات'),
                          onPressed: () => context.push('/achievements'),
                        ),
                        if (team != null)
                          IconButton(
                            icon: const Icon(Icons.picture_as_pdf_rounded, size: 20),
                            tooltip: s.tr('Download Report', 'تنزيل التقرير'),
                            onPressed: () => _openRoundReport(context, team.id),
                          ),
                      ],
                    ),
                  ),
                ),

                // Self-paced: the round ends here on the dashboard. Once results
                // are in, this proceeds to the next round (website parity).
                if (isSelfPaced) _buildSelfPacedContinueCta(context, s),

                // Corporate: the facilitator has opened (or reopened) decisions.
                if (!isSelfPaced && team != null && _decisionsOpen)
                  _buildRoundOpenCta(context, s),

                // Feature 1: Round Selector
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                    child: _RoundSelector(
                      selectedRound: _selectedRound,
                      activeRound: _activeRound,
                      onRoundSelected: _onRoundSelected,
                    ),
                  ),
                ),

                // Active Shocks (corporate mode only)
                if (!isSelfPaced)
                  const SliverToBoxAdapter(
                    child: ActiveShocksDisplay(),
                  ),

                // Hero Score Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: financials.isLoading && data == null
                        ? const ShimmerCard(height: 140)
                        : _HeroScoreCard(
                            score: _findScore(
                              financials.leaderboard.isNotEmpty ? financials.leaderboard : financials.previousLeaderboard,
                              team?.id ?? (isSelfPaced ? 'Team 1' : ''),
                            ),
                            rank: _findRank(
                              financials.leaderboard.isNotEmpty ? financials.leaderboard : financials.previousLeaderboard,
                              team?.id,
                            ),
                            isScoreLoading: financials.leaderboard.isEmpty && financials.previousLeaderboard.isEmpty && !financials.leaderboardFailed,
                            teamName: isSelfPaced
                                ? (authState.user?.displayName ?? s.tr('Self-Paced', 'التعلّم الذاتي'))
                                : (team?.name ?? s.tr('Your Team', 'فريقك')),
                            teamColor: team != null ? AppColors.teamColor(team.teamNumber - 1) : AppColors.primaryLight,
                            showScore: !isSelfPaced,
                          ),
                  ),
                ),

                // Performance-index leaderboard (corporate only).
                if (!isSelfPaced)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: PerformanceIndexLeaderboard(highlightTeamId: team?.id),
                    ),
                  ),

                // KPI Row
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                    child: financials.isLoading && data == null
                        ? Row(children: List.generate(4, (_) => const Expanded(child: Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: ShimmerCard(height: 72)))))
                        : SizedBox(
                            height: 94,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              children: [
                                _KpiChip(label: s.tr('Revenue', 'الإيرادات'), value: data?.revenue ?? 0, color: AppColors.secondaryLight, icon: Icons.attach_money_rounded),
                                _KpiChip(label: s.tr('Net Income', 'صافي الدخل'), value: data?.netIncome ?? 0, color: AppColors.primaryLight, icon: Icons.trending_up_rounded),
                                _KpiChip(label: s.tr('Assets', 'الأصول'), value: data?.totalAssets ?? 0, color: AppColors.accentLight, icon: Icons.pie_chart_rounded),
                                _KpiChip(label: s.tr('Cash Flow', 'التدفق النقدي'), value: data?.operatingCashFlow ?? 0, color: const Color(0xFF06B6D4), icon: Icons.water_drop_rounded),
                              ].asMap().entries.map((e) => Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: e.value,
                              )).toList(),
                            ),
                          ),
                  ),
                ),

                // Financial Statements Section
                if (data != null) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(s.tr('Financial Statements', 'القوائم المالية'), style: Theme.of(context).textTheme.titleLarge),
                          ),
                          _StatementChecks(data: data, s: s),
                        ],
                      ),
                    ),
                  ),

                  if (displayRound >= 1 && displayRound <= 3)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                        child: StatementCompareControls(
                          currentRound: displayRound,
                          compareRound: compareRound,
                          show: _analysisShow,
                          onCompareChanged: (r) => setState(() => _compareRound = r),
                          onShowChanged: (v) => setState(() => _analysisShow = v),
                        ),
                      ),
                    ),

                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardColor(context).withValues(alpha: 0.4) : AppColors.lightCard,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TabBar(
                        controller: _stmtTabController,
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        dividerHeight: 0,
                        labelColor: Colors.white,
                        unselectedLabelColor: isDark ? AppColors.textTertiary(context) : AppColors.lightTextTertiary,
                        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        unselectedLabelStyle: const TextStyle(fontSize: 12),
                        tabs: [
                          Tab(text: s.tr('Income', 'الدخل')),
                          Tab(text: s.tr('Balance', 'الميزانية')),
                          Tab(text: s.tr('Cash Flow', 'التدفق النقدي')),
                          Tab(text: s.tr('Ratios', 'النسب')),
                        ],
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 420, // Taller to fit real Excel data rows
                      child: TabBarView(
                        controller: _stmtTabController,
                        children: hasComparison
                            ? [
                                StatementCompareTable(
                                    kind: StatementKind.income,
                                    comparison: comparison,
                                    show: _analysisShow),
                                StatementCompareTable(
                                    kind: StatementKind.balance,
                                    comparison: comparison,
                                    show: _analysisShow),
                                StatementCompareTable(
                                    kind: StatementKind.cashFlow,
                                    comparison: comparison,
                                    show: _analysisShow),
                                RatioCompareTable(comparison: comparison),
                              ]
                            : [
                                _IncomeStatement(data: data),
                                _BalanceSheet(data: data), // Feature 3: includes validation
                                _CashFlowStatement(data: data),
                                _RatiosView(data: data),
                              ],
                      ),
                    ),
                  ),

                  // Round Analysis: decision impact waterfall + AI debrief coach.
                  if (displayRound >= 1 && displayRound <= 3 && (isSelfPaced || team != null))
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                        child: RoundAnalysisSection(
                          key: ValueKey('round-analysis-$displayRound'),
                          teamId: team?.id ?? '',
                          round: displayRound,
                          selfPaced: isSelfPaced,
                        ),
                      ),
                    ),
                ],

                // Feature 2: All-Teams Ratio Analysis
                if (financials.allTeamFinancials.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: _TeamRatiosTable(
                        allTeamFinancials: financials.allTeamFinancials,
                      ),
                    ),
                  ),

                // Advanced analytics — quick access to the per-team analysis
                // tools the website surfaces as dashboard cards.
                SliverToBoxAdapter(child: _buildAnalyticsCards(selfPaced: isSelfPaced)),

                // Revenue Chart
                if (financials.allTeamFinancials.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: GlassCard(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.bar_chart_rounded, size: 18, color: AppColors.primaryLight),
                                const SizedBox(width: 8),
                                Text(s.tr('Team Revenue', 'إيرادات الفرق'), style: Theme.of(context).textTheme.titleMedium),
                              ],
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 180,
                              child: BarChart(
                                BarChartData(
                                  gridData: FlGridData(
                                    show: true, drawVerticalLine: false,
                                    getDrawingHorizontalLine: (v) => FlLine(
                                      color: AppColors.borderColor(context).withValues(alpha: 0.2), strokeWidth: 1,
                                    ),
                                  ),
                                  titlesData: FlTitlesData(
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true, reservedSize: 50,
                                        getTitlesWidget: (v, _) => Text('\$${(v / 1000).toInt()}k', style: TextStyle(fontSize: 10, color: AppColors.textTertiary(context))),
                                      ),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (v, _) => Padding(
                                          padding: const EdgeInsets.only(top: 8),
                                          child: Text('T${v.toInt() + 1}', style: TextStyle(fontSize: 11, color: AppColors.textSecondary(context))),
                                        ),
                                      ),
                                    ),
                                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  ),
                                  borderData: FlBorderData(show: false),
                                  barGroups: financials.allTeamFinancials.asMap().entries.map((entry) {
                                    return BarChartGroupData(
                                      x: entry.key,
                                      barRods: [
                                        BarChartRodData(
                                          toY: entry.value.revenue,
                                          color: AppColors.teamColor(entry.key),
                                          width: 16,
                                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // PDF Report
                if (team != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: PdfReportButton(
                        teamId: team.id,
                        teamName: team.name,
                        round: _selectedRound > 0 ? _selectedRound : _activeRound,
                      ),
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int _findRank(List<LeaderboardEntry> leaderboard, String? teamId) {
    if (teamId == null || leaderboard.isEmpty) return 0;
    final entry = leaderboard.where((e) => e.teamId == teamId).firstOrNull;
    return entry?.rank ?? 0;
  }

  double _findScore(List<LeaderboardEntry> leaderboard, String teamId) {
    if (leaderboard.isEmpty) return 0;
    final entry = leaderboard.where((e) => e.teamId == teamId).firstOrNull;
    return entry?.score ?? 0;
  }
}

// ============================================================
// Feature 1: Round Selector
// ============================================================
class _RoundSelector extends StatelessWidget {
  final int selectedRound;
  final int activeRound;
  final ValueChanged<int> onRoundSelected;

  const _RoundSelector({
    required this.selectedRound,
    required this.activeRound,
    required this.onRoundSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final s = ref.watch(stringsProvider);
      return Row(
      children: [
        Icon(Icons.replay_rounded, size: 16, color: AppColors.textSecondary(context)),
        const SizedBox(width: 8),
        Text(s.tr('Round:', 'الجولة:'), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary(context))),
        const SizedBox(width: 8),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _roundChip(context, 0, s.tr('Latest', 'الأحدث')),
                for (int r = 1; r <= 3; r++)
                  _roundChip(context, r, 'R$r'),
              ],
            ),
          ),
        ),
      ],
    );
    });
  }

  Widget _roundChip(BuildContext context, int round, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = selectedRound == round;
    final isActive = round == activeRound;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => onRoundSelected(round),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary
                  : isDark
                      ? AppColors.darkCard.withValues(alpha: 0.6)
                      : AppColors.lightCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : isActive
                        ? AppColors.secondaryLight.withValues(alpha: 0.5)
                        : AppColors.borderColor(context).withValues(alpha: 0.3),
                width: isActive && !isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.textPrimary(context),
                  ),
                ),
                if (isActive && round > 0) ...[
                  const SizedBox(width: 4),
                  Container(
                    width: 6, height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.secondaryLight,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// Hero Score Card
// ============================================================
class _HeroScoreCard extends StatelessWidget {
  final double score;
  final int rank;
  final bool isScoreLoading;
  final String teamName;
  final Color teamColor;

  /// Self-paced learners have no team score: the website's self-paced dashboard shows
  /// none, and the corporate 'Team 1' row is not theirs.
  final bool showScore;

  const _HeroScoreCard({required this.score, required this.rank, this.isScoreLoading = false, required this.teamName, required this.teamColor, this.showScore = true});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final s = ref.watch(stringsProvider);
      return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [teamColor.withValues(alpha: 0.85), teamColor],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: teamColor.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(teamName, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
                const SizedBox(height: 4),
                if (!showScore)
                  Text(s.tr('Your results', 'نتائجك'),
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800))
                else if (isScoreLoading && score == 0)
                  Row(
                    children: [
                      const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white70)),
                      const SizedBox(width: 8),
                      Text(s.tr('Loading...', 'جارٍ التحميل...'), style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 20, fontWeight: FontWeight.w600)),
                    ],
                  )
                else
                  AnimatedCounter(
                    value: score,
                    style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w800),
                  ),
                if (showScore) ...[
                  const SizedBox(height: 2),
                  Text(s.tr('Index / 100', 'المؤشر / 100'), style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ],
            ),
          ),
          if (showScore && rank > 0)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.emoji_events_rounded, color: Colors.amber, size: 24),
                  const SizedBox(height: 2),
                  Text('#$rank', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                ],
              ),
            ),
        ],
      ),
    );
    });
  }
}

class _KpiChip extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final IconData icon;

  const _KpiChip({required this.label, required this.value, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      borderColor: color.withValues(alpha: 0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 14),
              const SizedBox(width: 4),
              Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 4),
          AnimatedCounter(
            value: value,
            prefix: '\$',
            style: GoogleFonts.jetBrainsMono(fontSize: 14, fontWeight: FontWeight.w700, color: value < 0 ? AppColors.dangerLight : color),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// Financial Statement Views
// ============================================================
class _IncomeStatement extends StatelessWidget {
  final FinancialData data;
  const _IncomeStatement({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.incomeRows.isNotEmpty) {
      return _StatementList(rows: data.incomeRows.map((r) {
        final color = r.isHeader || r.isMajor
            ? AppColors.primaryLight
            : r.value < 0 ? AppColors.dangerLight : AppColors.secondaryLight;
        return _StmtRow(r.title, r.value, color, bold: r.isHeader || r.isMajor || r.isCalculation);
      }).toList());
    }
    // Fallback
    return Consumer(builder: (context, ref, _) {
      final s = ref.watch(stringsProvider);
      return _StatementList(rows: [
        _StmtRow(s.tr('Revenue', 'الإيرادات'), data.revenue, AppColors.secondaryLight),
        _StmtRow(s.tr('Net Income', 'صافي الدخل'), data.netIncome, data.netIncome >= 0 ? AppColors.secondaryLight : AppColors.dangerLight, bold: true),
      ]);
    });
  }
}

// Feature 3: Balance Sheet with real Excel data
class _BalanceSheet extends StatelessWidget {
  final FinancialData data;
  const _BalanceSheet({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.balanceRows.isNotEmpty) {
      return _StatementList(rows: data.balanceRows.map((r) {
        final color = r.isHeader || r.isMajor
            ? AppColors.primaryLight
            : r.value < 0 ? AppColors.dangerLight : AppColors.secondaryLight;
        return _StmtRow(r.title, r.value, color, bold: r.isHeader || r.isMajor || r.isCalculation);
      }).toList());
    }
    // Fallback
    return Consumer(builder: (context, ref, _) {
      final s = ref.watch(stringsProvider);
      return _StatementList(rows: [
        _StmtRow(s.tr('Total Assets', 'إجمالي الأصول'), data.totalAssets, AppColors.primaryLight, bold: true),
        _StmtRow(s.tr('Total Liabilities', 'إجمالي الخصوم'), data.totalLiabilities, AppColors.accentLight, bold: true),
        _StmtRow(s.tr('Total Equity', 'إجمالي حقوق الملكية'), data.totalEquity, AppColors.secondaryLight, bold: true),
      ]);
    });
  }
}

class _CashFlowStatement extends StatelessWidget {
  final FinancialData data;
  const _CashFlowStatement({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.cashFlowRows.isNotEmpty) {
      return _StatementList(rows: data.cashFlowRows.map((r) {
        final color = r.isHeader || r.isMajor
            ? AppColors.primaryLight
            : r.value < 0 ? AppColors.dangerLight : AppColors.secondaryLight;
        return _StmtRow(r.title, r.value, color, bold: r.isHeader || r.isMajor || r.isCalculation);
      }).toList());
    }
    return Consumer(builder: (context, ref, _) {
      final s = ref.watch(stringsProvider);
      return _StatementList(rows: [
        _StmtRow(s.tr('Operating Cash Flow', 'التدفق النقدي التشغيلي'), data.operatingCashFlow, data.operatingCashFlow >= 0 ? AppColors.secondaryLight : AppColors.dangerLight),
      ]);
    });
  }
}

class _RatiosView extends StatelessWidget {
  final FinancialData data;
  const _RatiosView({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.ratioRows.isNotEmpty) {
      return _StatementList(rows: data.ratioRows.map((r) {
        Color color;
        final type = r.type ?? '';
        switch (type) {
          case 'Liquidity': color = AppColors.info; break;
          case 'Efficiency': color = AppColors.accentLight; break;
          case 'Profitability': color = r.value >= 0 ? AppColors.secondaryLight : AppColors.dangerLight; break;
          case 'Solvency': color = AppColors.primaryLight; break;
          case 'Market': color = const Color(0xFF8B5CF6); break;
          default: color = AppColors.primaryLight;
        }
        // One ratio formatter shared with the comparison table (website 3b6e645):
        // percentages, multiples with an x, everything else to one decimal.
        return _StmtRow(r.title.trim(), r.value, color,
            display: formatRatio(r.title.trim(), r.rawValue), bold: r.isHeader,
            aiType: r.isHeader ? null : _inferRatioType(r.title));
      }).toList());
    }
    // Fallback: ROE from the statements; n/m on zero or negative equity, as the engine does.
    final double? roe = data.totalEquity > 0 ? data.netIncome / data.totalEquity : null;
    return Consumer(builder: (context, ref, _) {
      final s = ref.watch(stringsProvider);
      return _StatementList(rows: [
        _StmtRow(s.tr('Return on Equity', 'العائد على حقوق الملكية'), roe ?? 0,
            (roe ?? 0) >= 0 ? AppColors.secondaryLight : AppColors.dangerLight,
            display: formatRatio('Return on Equity', roe), aiType: 'profitability'),
      ]);
    });
  }
}

// ============================================================
// Feature 2: All-Teams Ratio Analysis Table
// ============================================================
class _TeamRatiosTable extends StatelessWidget {
  final List<FinancialData> allTeamFinancials;

  const _TeamRatiosTable({required this.allTeamFinancials});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final s = ref.watch(stringsProvider);
      return _buildContent(context, s);
    });
  }

  Widget _buildContent(BuildContext context, AppStrings s) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final teamCount = allTeamFinancials.length;
    String trRatio(String label) => switch (label) {
          'ROE' => s.tr('ROE', 'العائد على حقوق الملكية'),
          'Profit Margin' => s.tr('Profit Margin', 'هامش الربح'),
          'Asset Turnover' => s.tr('Asset Turnover', 'معدل دوران الأصول'),
          'Current Ratio' => s.tr('Current Ratio', 'نسبة التداول'),
          'Debt/Equity' => s.tr('Debt/Equity', 'الدين/حقوق الملكية'),
          _ => label,
        };

    // Compute ratios for all teams. Prefer the engine's own ratio rows; otherwise derive
    // from the statements. Nothing is invented: a ratio that cannot be computed reads "-"
    // (or "n/m" where the engine voids it), never a placeholder value.
    double? engineRatio(FinancialData d, bool Function(String t) pick) {
      for (final r in d.ratioRows) {
        if (pick(r.title.trim().toLowerCase())) return r.value;
      }
      return null;
    }

    final ratioData = <_RatioRow>[
      _RatioRow(
          'ROE',
          'Return on Equity (ROE)',
          allTeamFinancials
              .map((d) =>
                  engineRatio(d, (t) => t.contains('return on equity')) ??
                  (d.totalEquity > 0 ? d.netIncome / d.totalEquity : null))
              .toList()),
      _RatioRow(
          'Profit Margin',
          'Net Profit Margin',
          allTeamFinancials
              .map((d) =>
                  engineRatio(d, (t) => t.contains('net profit margin')) ??
                  (d.revenue != 0 ? d.netIncome / d.revenue : null))
              .toList()),
      _RatioRow(
          'Asset Turnover',
          'Total Asset Turnover',
          allTeamFinancials
              .map((d) =>
                  engineRatio(d, (t) => t.contains('asset turnover')) ??
                  (d.totalAssets != 0 ? d.revenue / d.totalAssets : null))
              .toList()),
      _RatioRow(
          'Current Ratio',
          'Current Ratio',
          allTeamFinancials.map((d) {
            final engine = engineRatio(d, (t) => t.contains('current ratio'));
            if (engine != null) return engine;
            final cr = d.ratios?['currentRatio'];
            return cr is num ? cr.toDouble() : null;
          }).toList()),
      _RatioRow(
          'Debt/Equity',
          'Debt to Equity Ratio',
          allTeamFinancials
              .map((d) =>
                  engineRatio(d, (t) => t.contains('debt to equity')) ??
                  (d.totalEquity > 0 ? d.totalLiabilities / d.totalEquity : null))
              .toList()),
    ];

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.analytics_rounded, size: 18, color: AppColors.accentLight),
              const SizedBox(width: 8),
              Text(s.tr('Ratio Analysis - All Teams', 'تحليل النسب - جميع الفرق'), style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: DataTable(
              headingRowHeight: 36,
              dataRowMinHeight: 32,
              dataRowMaxHeight: 36,
              columnSpacing: 12,
              horizontalMargin: 8,
              headingTextStyle: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary(context),
              ),
              columns: [
                DataColumn(label: Text(s.tr('Ratio', 'النسبة'))),
                for (int i = 0; i < teamCount; i++)
                  DataColumn(
                    label: Text(
                      'T${i + 1}',
                      style: TextStyle(color: AppColors.teamColor(i)),
                    ),
                  ),
              ],
              rows: ratioData.map((ratio) {
                // Find best performer index
                final isLowerBetter = ratio.label == 'Debt/Equity';
                int bestIdx = -1;
                for (int i = 0; i < ratio.values.length; i++) {
                  final v = ratio.values[i];
                  if (v == null) continue;
                  final best = bestIdx < 0 ? null : ratio.values[bestIdx];
                  if (best == null || (isLowerBetter ? v < best : v > best)) bestIdx = i;
                }

                return DataRow(
                  cells: [
                    DataCell(Text(
                      trRatio(ratio.label),
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textPrimary(context)),
                    )),
                    for (int i = 0; i < ratio.values.length; i++)
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: i == bestIdx
                                ? AppColors.secondaryLight.withValues(alpha: isDark ? 0.2 : 0.12)
                                : null,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            formatRatio(ratio.formatName, ratio.values[i]),
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 11,
                              fontWeight: i == bestIdx ? FontWeight.w700 : FontWeight.w400,
                              color: i == bestIdx
                                  ? AppColors.secondaryLight
                                  : AppColors.textSecondary(context),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _RatioRow {
  final String label;

  /// The engine's ratio name, which decides the format (percent / multiple / number).
  final String formatName;
  final List<double?> values;
  _RatioRow(this.label, this.formatName, this.values);
}

// ============================================================
// Statement checks, rows and list
// ============================================================

/// Balance-sheet "Balanced?" check plus a cash-flow vs balance-sheet
/// "Cash reconciled?" check, rendered as small chips. Defensive: if the
/// underlying values can't be found, the relevant chip is omitted.
class _StatementChecks extends StatelessWidget {
  final FinancialData data;
  final AppStrings s;
  const _StatementChecks({required this.data, required this.s});

  /// Closing cash from the cash-flow statement: prefer a row whose title
  /// contains 'cash' AND ('end'/'closing'), else the last cash-related row.
  double? _closingCashFromCashFlow() {
    if (data.cashFlowRows.isEmpty) return null;
    StatementRow? endRow;
    StatementRow? lastCashRow;
    for (final r in data.cashFlowRows) {
      final t = r.title.toLowerCase();
      if (!t.contains('cash')) continue;
      lastCashRow = r;
      if (t.contains('end') || t.contains('closing')) endRow = r;
    }
    final picked = endRow ?? lastCashRow;
    return picked?.value;
  }

  /// Cash on the balance sheet: a row whose title contains 'cash'
  /// (preferring a non-aggregate "cash" line over "cash & equivalents" totals
  /// is unnecessary — first match is fine).
  double? _cashFromBalance() {
    if (data.balanceRows.isEmpty) return null;
    for (final r in data.balanceRows) {
      final t = r.title.toLowerCase();
      if (t.contains('cash')) return r.value;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[];

    // Balanced check (only when we actually have balance-sheet figures).
    if (data.totalAssets != 0 || data.totalLiabilities != 0 || data.totalEquity != 0) {
      final diff = (data.totalAssets - (data.totalLiabilities + data.totalEquity)).abs();
      final tol = (data.totalAssets.abs() * 0.001).clamp(1.0, double.infinity);
      final balanced = diff < tol;
      chips.add(_chip(
        ok: balanced,
        okLabel: s.tr('Balanced', 'متوازن'),
        badLabel: s.tr('Not balanced', 'غير متوازن'),
      ));
    }

    // Cash reconciliation check.
    final cfCash = _closingCashFromCashFlow();
    final bsCash = _cashFromBalance();
    if (cfCash != null && bsCash != null) {
      final diff = (cfCash - bsCash).abs();
      final tol = (bsCash.abs() * 0.01).clamp(1.0, double.infinity);
      final reconciled = diff < tol;
      chips.add(_chip(
        ok: reconciled,
        okLabel: s.tr('Cash reconciled', 'النقد متطابق'),
        badLabel: s.tr('Cash mismatch', 'النقد غير متطابق'),
      ));
    }

    if (chips.isEmpty) return const SizedBox.shrink();
    return Wrap(spacing: 6, runSpacing: 4, children: chips);
  }

  Widget _chip({required bool ok, required String okLabel, required String badLabel}) {
    final color = ok ? AppColors.secondaryLight : AppColors.accentLight;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ok ? Icons.check_circle : Icons.warning_amber_rounded, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            ok ? okLabel : badLabel,
            style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _StmtRow {
  final String label;
  final double value;
  final Color color;
  final bool bold;

  /// When non-null, an AI tooltip button is shown for this row (ratio rows).
  /// Holds the inferred ratio category ('liquidity'/'solvency'/etc.).
  final String? aiType;

  /// Preformatted value text (ratio rows); amounts are formatted as currency otherwise.
  final String? display;

  _StmtRow(this.label, this.value, this.color,
      {this.bold = false, this.aiType, this.display});
}

/// Infers a loose ratio category from a ratio title (matches the website's
/// tooltip categories). Returns null for non-ratio lines.
String _inferRatioType(String title) {
  final t = title.toLowerCase();
  if (t.contains('current') || t.contains('quick') || t.contains('cash')) {
    return 'liquidity';
  }
  if (t.contains('debt') || t.contains('equity') || t.contains('coverage')) {
    return 'solvency';
  }
  if (t.contains('margin') ||
      t.contains('return') ||
      t.contains('roe') ||
      t.contains('roa')) {
    return 'profitability';
  }
  if (t.contains('turnover') || t.contains('days')) return 'efficiency';
  return 'liquidity';
}

class _StatementList extends StatelessWidget {
  final List<_StmtRow> rows;
  const _StatementList({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: rows.asMap().entries.map((e) {
          final row = e.value;
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            decoration: BoxDecoration(
              border: e.key < rows.length - 1
                  ? Border(bottom: BorderSide(color: AppColors.borderColor(context).withValues(alpha: 0.15)))
                  : null,
            ),
            child: Row(
              children: [
                Container(width: 3, height: 16, decoration: BoxDecoration(color: row.color, borderRadius: BorderRadius.circular(2))),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    row.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: row.bold ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
                Text(
                  row.display ?? _formatValue(row.value),
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 13,
                    fontWeight: row.bold ? FontWeight.w700 : FontWeight.w500,
                    color: row.value < 0 ? AppColors.dangerLight : row.color,
                  ),
                ),
                if (row.aiType != null) ...[
                  const SizedBox(width: 8),
                  AiTooltipButton(
                    term: row.label,
<<<<<<< Updated upstream
                    type: row.aiType!,
                    value: row.suffix != null
                        ? '${row.value.toStringAsFixed(1)}${row.suffix}'
                        : row.value.toStringAsFixed(2),
=======
                    type: row.aiType,
                    value: row.display ?? row.value.toStringAsFixed(2),
>>>>>>> Stashed changes
                    color: row.color,
                  ),
                ],
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Negative amounts carry their sign ahead of the currency: -$120.0k, not $-120.0k
  /// (website 3b6e645).
  String _formatValue(double value) {
    final abs = value.abs();
    final sign = value < 0 ? '-' : '';
    if (abs >= 1000000) return '$sign\$${(abs / 1000000).toStringAsFixed(1)}M';
    if (abs >= 1000) return '$sign\$${(abs / 1000).toStringAsFixed(1)}k';
    return '$sign\$${abs.toStringAsFixed(0)}';
  }
}
