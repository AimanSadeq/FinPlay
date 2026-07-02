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
import '../../../core/utils/constants.dart';
import '../widgets/pdf_report_button.dart';
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

  @override
  void initState() {
    super.initState();
    _stmtTabController = TabController(length: 4, vsync: this);
    _stmtTabController.addListener(_onTabChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
      ref.read(gameMetricsProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _stmtTabController.removeListener(_onTabChanged);
    _stmtTabController.dispose();
    super.dispose();
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
  (String?, bool) _cardMetric(String route, FinancialData? fd) {
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
        return (de == null ? null : 'D/E ${de.toStringAsFixed(2)}', de != null && de > 3.0);
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

  Widget _buildAnalyticsCards() {
    final fd = ref.watch(gameMetricsProvider).latest;
    final s = ref.watch(stringsProvider);
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
            children: _analyticsItems.map((it) {
              final (title, subtitle, icon, color, route) = it;
              final (value, breached) = _cardMetric(route, fd);
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
    final raw = _selectedRound > 0 ? _selectedRound : _activeRound;
    final round = raw < 1 ? 1 : (raw > 3 ? 3 : raw);
    final uri = Uri.parse(
      '${AppConstants.baseUrl}${AppConstants.apiPrefix}/reports/round-report/$teamId/$round',
    );
    bool ok = false;
    try {
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
                          ),
                  ),
                ),

                // Live Leaderboard (after hero score card)
                _LiveLeaderboard(
                  financials: financials,
                  onRetry: () => ref.read(financialProvider.notifier).fetchLeaderboard(),
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
                        children: [
                          _IncomeStatement(data: data),
                          _BalanceSheet(data: data), // Feature 3: includes validation
                          _CashFlowStatement(data: data),
                          _RatiosView(data: data),
                        ],
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
                SliverToBoxAdapter(child: _buildAnalyticsCards()),

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

  const _HeroScoreCard({required this.score, required this.rank, this.isScoreLoading = false, required this.teamName, required this.teamColor});

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
                if (isScoreLoading && score == 0)
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
                const SizedBox(height: 2),
                Text(s.tr('Total Score', 'النتيجة الإجمالية'), style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          if (rank > 0)
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

// ============================================================
// Live Leaderboard (receives data from parent to avoid nested ConsumerWidget)
// ============================================================
class _LiveLeaderboard extends StatelessWidget {
  final FinancialState financials;
  final VoidCallback? onRetry;
  const _LiveLeaderboard({required this.financials, this.onRetry});

  String _fmtMoney(double v) {
    final abs = v.abs();
    final sign = v < 0 ? '-' : '';
    if (abs >= 1000000) return '$sign\$${(abs / 1000000).toStringAsFixed(1)}M';
    if (abs >= 1000) return '$sign\$${(abs / 1000).toStringAsFixed(1)}k';
    return '$sign\$${abs.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    // Use current leaderboard, or fall back to previous while loading
    final leaderboard = financials.leaderboard.isNotEmpty
        ? financials.leaderboard
        : financials.previousLeaderboard;

    // Sort by score descending
    final sorted = List<LeaderboardEntry>.from(leaderboard);
    sorted.sort((a, b) => b.score.compareTo(a.score));

    final roundLabel = sorted.isNotEmpty ? 'R${sorted.first.roundNum}' : '';

    return SliverToBoxAdapter(
      child: Consumer(builder: (context, ref, _) {
        final s = ref.watch(stringsProvider);
        return Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: GlassCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.leaderboard_rounded, size: 18, color: AppColors.accentLight),
                  const SizedBox(width: 8),
                  Text(s.tr('Live Leaderboard', 'لوحة الصدارة المباشرة'), style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                  const Spacer(),
                  if (roundLabel.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(roundLabel, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primaryLight)),
                    ),
                  const SizedBox(width: 6),
                  Container(
                    width: 8, height: 8,
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.secondaryLight),
                  ),
                  const SizedBox(width: 4),
                  Text(s.tr('Live', 'مباشر'), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.secondaryLight)),
                ],
              ),
              const SizedBox(height: 10),
              if (sorted.isEmpty && financials.leaderboardFailed)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Text(s.tr('Failed to load', 'فشل التحميل'), style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context))),
                        const SizedBox(height: 6),
                        TextButton.icon(
                          onPressed: onRetry,
                          icon: const Icon(Icons.refresh, size: 16),
                          label: Text(s.tr('Retry', 'إعادة المحاولة'), style: const TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                )
              else if (sorted.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
                )
              else ...[
                // Header row
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      const SizedBox(width: 30),
                      Expanded(flex: 3, child: Text(s.tr('Team', 'الفريق'), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textTertiary(context)))),
                      SizedBox(width: 46, child: Text(s.tr('Score', 'النتيجة'), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textTertiary(context)), textAlign: TextAlign.center)),
                      const SizedBox(width: 6),
                      SizedBox(width: 30, child: Icon(Icons.local_fire_department_rounded, size: 12, color: AppColors.textTertiary(context))),
                      SizedBox(width: 50, child: Text(s.tr('ROE', 'العائد'), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textTertiary(context)), textAlign: TextAlign.right)),
                      SizedBox(width: 60, child: Text(s.tr('Net Inc.', 'صافي الدخل'), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textTertiary(context)), textAlign: TextAlign.right)),
                    ],
                  ),
                ),
                Divider(height: 1, color: AppColors.borderColor(context).withValues(alpha: 0.2)),
                const SizedBox(height: 4),
                for (final entry in sorted.asMap().entries) _buildTeamRow(context, entry.key, entry.value),
                const SizedBox(height: 4),
                Divider(height: 1, color: AppColors.borderColor(context).withValues(alpha: 0.2)),
                const SizedBox(height: 4),
                Text(
                  s.tr('${sorted.length} teams • 30s refresh', '${sorted.length} فرق • تحديث كل 30 ثانية'),
                  style: TextStyle(fontSize: 10, color: AppColors.textTertiary(context)),
                ),
              ],
            ],
          ),
        ),
      );
      }),
    );
  }

  Widget _buildTeamRow(BuildContext context, int index, LeaderboardEntry item) {
    final name = item.displayName.isNotEmpty ? item.displayName : item.teamName;
    final teamIdx = int.tryParse(item.teamId.replaceAll(RegExp(r'[^0-9]'), '')) ?? (index + 1);
    final color = AppColors.teamColor((teamIdx - 1).clamp(0, 6));

    IconData? rankIcon;
    if (index == 0) {
      rankIcon = Icons.emoji_events_rounded;
    } else if (index == 1) {
      rankIcon = Icons.workspace_premium_rounded;
    } else if (index == 2) {
      rankIcon = Icons.military_tech_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: index == 0 ? AppColors.accentLight.withValues(alpha: 0.06) : null,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: rankIcon != null
                ? Icon(rankIcon, size: 16, color: index == 0 ? Colors.amber : index == 1 ? Colors.grey.shade400 : Colors.brown.shade300)
                : Text('#${index + 1}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textTertiary(context))),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(width: 6, height: 6, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
                const SizedBox(width: 6),
                Flexible(child: Text(name, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textPrimary(context)), overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
          SizedBox(
            width: 46,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                item.score.toStringAsFixed(1),
                style: GoogleFonts.jetBrainsMono(fontSize: 11, fontWeight: FontWeight.w600, color: color),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 30,
            child: item.isCashRich
                ? const Icon(Icons.check_box_rounded, size: 14, color: AppColors.secondaryLight)
                : const Icon(Icons.close_rounded, size: 14, color: AppColors.dangerLight),
          ),
          SizedBox(
            width: 50,
            child: Text(
              '${item.roe.toStringAsFixed(1)}%',
              style: GoogleFonts.jetBrainsMono(fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.textSecondary(context)),
              textAlign: TextAlign.right,
            ),
          ),
          SizedBox(
            width: 60,
            child: Text(
              _fmtMoney(item.netIncome),
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: item.netIncome >= 0 ? AppColors.secondaryLight : AppColors.dangerLight,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// KPI Chip
// ============================================================
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
        // Ratios are displayed as percentages or multiples
        final isPercent = r.title.contains('Margin') || r.title.contains('Return') || r.title.contains('Ratio');
        return _StmtRow(r.title, r.value * (isPercent ? 100 : 1), color,
            suffix: isPercent ? '%' : 'x', bold: r.isHeader,
            aiType: r.isHeader ? null : _inferRatioType(r.title));
      }).toList());
    }
    // Fallback
    final equity = data.totalEquity > 0 ? data.totalEquity : data.totalAssets * 0.45;
    final roe = equity > 0 ? (data.netIncome / equity) * 100 : 0.0;
    return Consumer(builder: (context, ref, _) {
      final s = ref.watch(stringsProvider);
      return _StatementList(rows: [
        _StmtRow(s.tr('Return on Equity', 'العائد على حقوق الملكية'), roe, roe >= 0 ? AppColors.secondaryLight : AppColors.dangerLight, suffix: '%', aiType: 'profitability'),
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

    // Compute ratios for all teams
    final ratioData = <_RatioRow>[];

    // ROE
    final roeValues = allTeamFinancials.map((d) {
      final equity = d.totalEquity > 0 ? d.totalEquity : d.totalAssets * 0.45;
      return equity > 0 ? (d.netIncome / equity) * 100 : 0.0;
    }).toList();
    ratioData.add(_RatioRow('ROE', roeValues, '%'));

    // Profit Margin
    final pmValues = allTeamFinancials.map((d) {
      return d.revenue > 0 ? (d.netIncome / d.revenue) * 100 : 0.0;
    }).toList();
    ratioData.add(_RatioRow('Profit Margin', pmValues, '%'));

    // Asset Turnover
    final atValues = allTeamFinancials.map((d) {
      return d.totalAssets > 0 ? d.revenue / d.totalAssets : 0.0;
    }).toList();
    ratioData.add(_RatioRow('Asset Turnover', atValues, 'x'));

    // Current Ratio
    final crValues = allTeamFinancials.map((d) {
      final cr = d.ratios?['currentRatio'];
      if (cr is num) return cr.toDouble();
      return 1.8;
    }).toList();
    ratioData.add(_RatioRow('Current Ratio', crValues, 'x'));

    // Debt-to-Equity
    final deValues = allTeamFinancials.map((d) {
      final liab = d.totalLiabilities > 0 ? d.totalLiabilities : d.totalAssets * 0.55;
      final equity = d.totalEquity > 0 ? d.totalEquity : d.totalAssets * 0.45;
      return equity > 0 ? liab / equity : 0.0;
    }).toList();
    ratioData.add(_RatioRow('Debt/Equity', deValues, 'x'));

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
                int bestIdx = 0;
                for (int i = 1; i < ratio.values.length; i++) {
                  if (isLowerBetter) {
                    if (ratio.values[i] < ratio.values[bestIdx]) bestIdx = i;
                  } else {
                    if (ratio.values[i] > ratio.values[bestIdx]) bestIdx = i;
                  }
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
                            '${ratio.values[i].toStringAsFixed(1)}${ratio.suffix}',
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
  final List<double> values;
  final String suffix;
  _RatioRow(this.label, this.values, this.suffix);
}

// ============================================================
// Features 4 & 5: Leaderboard Entry with Rank Change + Expandable Metrics
// ============================================================
class _LeaderboardEntryTile extends StatefulWidget {
  final LeaderboardEntry entry;
  final int index;
  final bool isMe;
  final int selectedRound;
  final List<LeaderboardEntry> previousLeaderboard;

  const _LeaderboardEntryTile({
    required this.entry,
    required this.index,
    required this.isMe,
    required this.selectedRound,
    required this.previousLeaderboard,
  });

  @override
  State<_LeaderboardEntryTile> createState() => _LeaderboardEntryTileState();
}

class _LeaderboardEntryTileState extends State<_LeaderboardEntryTile> {
  bool _expanded = false;

  int? _previousRank() {
    if (widget.previousLeaderboard.isEmpty) return null;
    final prev = widget.previousLeaderboard
        .where((e) => e.teamId == widget.entry.teamId)
        .firstOrNull;
    if (prev == null) return null;
    // Find rank by position in sorted list
    final idx = widget.previousLeaderboard.indexOf(prev);
    return prev.rank > 0 ? prev.rank : idx + 1;
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.entry;
    final medals = ['\u{1F947}', '\u{1F948}', '\u{1F949}']; // gold, silver, bronze
    final currentRank = widget.index + 1;
    final prevRank = _previousRank();

    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: widget.isMe ? AppColors.primary.withValues(alpha: 0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: widget.isMe ? Border.all(color: AppColors.primary.withValues(alpha: 0.2)) : null,
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Rank
                SizedBox(
                  width: 28,
                  child: widget.index < 3
                      ? Text(medals[widget.index], style: const TextStyle(fontSize: 18))
                      : Text('#$currentRank', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textTertiary(context))),
                ),
                const SizedBox(width: 4),

                // Feature 4: Rank change indicator
                SizedBox(
                  width: 36,
                  child: _buildRankChange(context, currentRank, prevRank),
                ),
                const SizedBox(width: 4),

                // Team avatar
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.teamColor(widget.index % 7).withValues(alpha: 0.2),
                  child: Text(item.teamName.split(' ').first, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.teamColor(widget.index % 7))),
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(item.teamName, style: Theme.of(context).textTheme.titleSmall)),
                AnimatedCounter(
                  value: item.score,
                  style: GoogleFonts.jetBrainsMono(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.accentLight),
                ),
                const SizedBox(width: 4),
                Icon(
                  _expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                  size: 18,
                  color: AppColors.textTertiary(context),
                ),
              ],
            ),

            // Feature 5: Expandable metrics
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: _buildExpandedMetrics(context, item),
              crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 200),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRankChange(BuildContext context, int currentRank, int? prevRank) {
    // Round 1 or no previous data
    if (widget.selectedRound <= 1 && widget.previousLeaderboard.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
        decoration: BoxDecoration(
          color: AppColors.info.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          'NEW',
          style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: AppColors.info),
        ),
      );
    }

    if (prevRank == null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
        decoration: BoxDecoration(
          color: AppColors.info.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          'NEW',
          style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: AppColors.info),
        ),
      );
    }

    final diff = prevRank - currentRank; // positive = improved
    if (diff == 0) {
      return Text(
        '--',
        style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context)),
        textAlign: TextAlign.center,
      );
    }

    final improved = diff > 0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          improved ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
          size: 12,
          color: improved ? AppColors.secondaryLight : AppColors.dangerLight,
        ),
        Text(
          '${diff.abs()}',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: improved ? AppColors.secondaryLight : AppColors.dangerLight,
          ),
        ),
      ],
    );
  }

  Widget _buildExpandedMetrics(BuildContext context, LeaderboardEntry item) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 32),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          _metricChip(context, 'Net Income', '\$${_fmtVal(item.netIncome)}', AppColors.primaryLight),
          _metricChip(context, 'Revenue', '\$${_fmtVal(item.revenue)}', AppColors.secondaryLight),
          _metricChip(context, 'Assets', '\$${_fmtVal(item.totalAssets)}', AppColors.accentLight),
          _metricChip(context, 'ROE', '${item.roe.toStringAsFixed(1)}%', item.roe >= 0 ? AppColors.secondaryLight : AppColors.dangerLight),
          _metricChip(context, 'Asset Turn.', '${item.assetTurnover.toStringAsFixed(2)}x', AppColors.info),
        ],
      ),
    );
  }

  Widget _metricChip(BuildContext context, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(fontSize: 9, color: AppColors.textTertiary(context), fontWeight: FontWeight.w500)),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.jetBrainsMono(fontSize: 11, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }

  String _fmtVal(double value) {
    final abs = value.abs();
    final sign = value < 0 ? '-' : '';
    if (abs >= 1000000) return '$sign${(abs / 1000000).toStringAsFixed(1)}M';
    if (abs >= 1000) return '$sign${(abs / 1000).toStringAsFixed(1)}k';
    return '$sign${abs.toStringAsFixed(0)}';
  }
}

// ============================================================
// Statement list helper
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
  final String? suffix;

  /// When non-null, an AI tooltip button is shown for this row (ratio rows).
  /// Holds the inferred ratio category ('liquidity'/'solvency'/etc.).
  final String? aiType;

  _StmtRow(this.label, this.value, this.color,
      {this.bold = false, this.suffix, this.aiType});
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
                  row.suffix != null
                      ? '${row.value.toStringAsFixed(1)}${row.suffix}'
                      : '\$${_formatValue(row.value)}',
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
                    type: row.aiType,
                    value: row.suffix != null
                        ? '${row.value.toStringAsFixed(1)}${row.suffix}'
                        : row.value.toStringAsFixed(2),
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

  String _formatValue(double value) {
    final abs = value.abs();
    final sign = value < 0 ? '-' : '';
    if (abs >= 1000000) return '$sign${(abs / 1000000).toStringAsFixed(1)}M';
    if (abs >= 1000) return '$sign${(abs / 1000).toStringAsFixed(1)}k';
    return '$sign${abs.toStringAsFixed(0)}';
  }
}
