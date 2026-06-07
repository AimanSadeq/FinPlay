import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../data/models/decision.dart';
import '../../../data/models/financial_data.dart';
import '../../../providers/financial_provider.dart';
import '../../../providers/repository_providers.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../app/i18n/app_strings.dart';

// ---------------------------------------------------------------------------
// Provider: fetch all-team decisions for a given round
// ---------------------------------------------------------------------------
final _allTeamDecisionsProvider = FutureProvider.family<List<Decision>, int>(
  (ref, round) async {
    final api = ref.watch(apiClientProvider);
    // Try facilitator endpoint first (returns grouped data)
    try {
      final response = await api.get(ApiEndpoints.facilitatorAllDecisions);
      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];
        final decisions = <Decision>[];
        if (data is Map<String, dynamic>) {
          for (final entry in data.entries) {
            if (entry.value is List) {
              for (final d in entry.value as List) {
                if (d is Map<String, dynamic>) {
                  final dec = Decision.fromJson(d);
                  if (dec.roundNum == round) decisions.add(dec);
                }
              }
            } else if (entry.value is Map<String, dynamic>) {
              // Might be keyed by module
              for (final modEntry
                  in (entry.value as Map<String, dynamic>).entries) {
                if (modEntry.value is Map<String, dynamic>) {
                  final d = Decision.fromJson(modEntry.value);
                  if (d.roundNum == round) decisions.add(d);
                }
              }
            }
          }
        }
        if (decisions.isNotEmpty) return decisions;
      }
    } catch (_) {
      // Facilitator endpoint may not be accessible; fall back.
    }

    // Fallback: fetch per team (Team 1..Team 7)
    final decisions = <Decision>[];
    for (int i = 1; i <= 7; i++) {
      try {
        final list = await api.getList(
          ApiEndpoints.decisions,
          params: {'teamId': 'Team $i', 'round': round},
        );
        for (final d in list) {
          if (d is Map<String, dynamic>) {
            decisions.add(Decision.fromJson(d));
          }
        }
      } catch (_) {}
    }
    return decisions;
  },
);

// ============================================================================
// SCREEN
// ============================================================================
class TeamComparisonScreen extends ConsumerStatefulWidget {
  const TeamComparisonScreen({super.key});

  @override
  ConsumerState<TeamComparisonScreen> createState() =>
      _TeamComparisonScreenState();
}

class _TeamComparisonScreenState extends ConsumerState<TeamComparisonScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedRound = 1;
  bool _showInsights = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _fetchData() {
    ref
        .read(financialProvider.notifier)
        .fetchAllTeamFinancials(round: _selectedRound);
  }

  void _onRoundChanged(int round) {
    if (round == _selectedRound) return;
    setState(() => _selectedRound = round);
    ref
        .read(financialProvider.notifier)
        .fetchAllTeamFinancials(round: _selectedRound);
  }

  @override
  Widget build(BuildContext context) {
    final financials = ref.watch(financialProvider);

    return Scaffold(
      body: Container(
        decoration:
            BoxDecoration(gradient: AppColors.backgroundGradient(context)),
        child: SafeArea(
          child: Column(
            children: [
              // --- Custom Header ---
              _buildHeader(context),
              // --- Round Selector ---
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: _RoundSelector(
                  selectedRound: _selectedRound,
                  onChanged: _onRoundChanged,
                ),
              ),
              // --- Tab Bar ---
              _buildTabBar(context),
              // --- Insights Card ---
              if (_showInsights)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: _buildInsightsCard(context),
                ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.1, end: 0),
              // --- Content ---
              Expanded(
                child: financials.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          _MetricsTab(teams: financials.allTeamFinancials),
                          _DecisionsTab(
                            round: _selectedRound,
                            teamCount: financials.allTeamFinancials.length,
                          ),
                          _RatiosTab(teams: financials.allTeamFinancials),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final s = ref.watch(stringsProvider);
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 12),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.analytics_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.tr('Team Comparison', 'مقارنة الفرق'),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  s.tr('Cross-team analytics & insights', 'تحليلات ورؤى عبر الفرق'),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.75),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0);
  }

  Widget _buildTabBar(BuildContext context) {
    final s = ref.watch(stringsProvider);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.cardColor(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderColor(context)),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.25),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textSecondary(context),
        labelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.bar_chart_rounded, size: 16),
                const SizedBox(width: 6),
                Text(s.tr('Metrics', 'المؤشرات')),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.tune_rounded, size: 16),
                const SizedBox(width: 6),
                Text(s.tr('Decisions', 'القرارات')),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.pie_chart_rounded, size: 16),
                const SizedBox(width: 6),
                Text(s.tr('Ratios', 'النسب')),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 300.ms);
  }

  Widget _buildInsightsCard(BuildContext context) {
    final s = ref.watch(stringsProvider);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          colors: [
            AppColors.info.withValues(alpha: 0.06),
            AppColors.primary.withValues(alpha: 0.04),
          ],
        ),
        border: Border.all(
          color: AppColors.info.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gradient accent bar on the left
          Container(
            width: 4,
            height: 64,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.info, AppColors.primaryLight],
              ),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.lightbulb_rounded,
                      size: 18,
                      color: AppColors.info,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      s.tr(
                          'Compare team performance across key financial metrics. Use the tabs to analyze decisions, ratios, and trends.',
                          'قارن أداء الفرق عبر المؤشرات المالية الرئيسية. استخدم التبويبات لتحليل القرارات والنسب والاتجاهات.'),
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        color: AppColors.textSecondary(context),
                        height: 1.45,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => setState(() => _showInsights = false),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.close_rounded,
                          size: 16,
                          color: AppColors.textTertiary(context),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// ROUND SELECTOR
// ============================================================================
class _RoundSelector extends StatefulWidget {
  final int selectedRound;
  final ValueChanged<int> onChanged;

  const _RoundSelector({required this.selectedRound, required this.onChanged});

  @override
  State<_RoundSelector> createState() => _RoundSelectorState();
}

class _RoundSelectorState extends State<_RoundSelector> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final s = ref.watch(stringsProvider);
      return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final round = i + 1;
        final selected = round == widget.selectedRound;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: AnimatedScale(
            scale: selected ? 1.05 : 1.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            child: GestureDetector(
              onTap: () => widget.onChanged(round),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  gradient: selected ? AppColors.primaryGradient : null,
                  color: selected ? null : Colors.transparent,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: selected
                        ? Colors.transparent
                        : AppColors.borderColor(context),
                    width: 1.5,
                  ),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (selected)
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Icon(
                          Icons.play_circle_filled_rounded,
                          size: 14,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    Text(
                      s.tr('Round $round', 'الجولة $round'),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: selected
                            ? Colors.white
                            : AppColors.textPrimary(context),
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    ).animate().fadeIn(delay: 50.ms, duration: 300.ms);
    });
  }
}

// ============================================================================
// TAB 1 -- METRICS
// ============================================================================
class _MetricsTab extends StatelessWidget {
  final List<FinancialData> teams;

  const _MetricsTab({required this.teams});

  static const _metricIcons = [
    Icons.trending_up_rounded,
    Icons.account_balance_wallet_rounded,
    Icons.domain_rounded,
    Icons.emoji_events_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final s = ref.watch(stringsProvider);
      return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _ComparisonCard(
          title: s.tr('Revenue', 'الإيرادات'),
          icon: _metricIcons[0],
          teams: teams,
          getValue: (d) => d.revenue,
          prefix: '\$',
        ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.05, end: 0),
        const SizedBox(height: 14),
        _ComparisonCard(
          title: s.tr('Net Income', 'صافي الدخل'),
          icon: _metricIcons[1],
          teams: teams,
          getValue: (d) => d.netIncome,
          prefix: '\$',
        ).animate().fadeIn(delay: 350.ms).slideX(begin: 0.05, end: 0),
        const SizedBox(height: 14),
        _ComparisonCard(
          title: s.tr('Total Assets', 'إجمالي الأصول'),
          icon: _metricIcons[2],
          teams: teams,
          getValue: (d) => d.totalAssets,
          prefix: '\$',
        ).animate().fadeIn(delay: 500.ms).slideX(begin: 0.05, end: 0),
        const SizedBox(height: 14),
        _ComparisonCard(
          title: s.tr('Total Score', 'النتيجة الإجمالية'),
          icon: _metricIcons[3],
          teams: teams,
          getValue: (d) => d.totalScore,
        ).animate().fadeIn(delay: 650.ms).slideX(begin: 0.05, end: 0),
        const SizedBox(height: 24),
        // Full all-teams financial statements table (metric rows × team columns),
        // matching the website's RoundFinancialTable.
        _AllTeamsFinancialTable(teams: teams),
        const SizedBox(height: 24),
      ],
    );
    });
  }
}

// ============================================================================
// All-teams financial statements table (IS / BS / CF), best-performer highlighted
// ============================================================================
class _AllTeamsFinancialTable extends StatelessWidget {
  final List<FinancialData> teams;
  const _AllTeamsFinancialTable({required this.teams});

  // Metrics where a LOWER value is better (liabilities, negative cash flows).
  static bool _lowerIsBetter(String title) {
    final t = title.toLowerCase();
    return t.contains('liabilit') ||
        t.contains('investing activities') ||
        t.contains('financing activities');
  }

  static String _fmt(double v) {
    final sign = v < 0 ? '-' : '';
    final a = v.abs();
    if (a >= 1000000) return '$sign\$${(a / 1000000).toStringAsFixed(1)}M';
    if (a >= 1000) return '$sign\$${(a / 1000).toStringAsFixed(0)}K';
    return '$sign\$${a.toStringAsFixed(0)}';
  }

  List<StatementRow> _rowsFor(FinancialData d, String type) => switch (type) {
        'income' => d.incomeRows,
        'balance' => d.balanceRows,
        _ => d.cashFlowRows,
      };

  double? _lookup(FinancialData d, String type, String title) {
    final rows = _rowsFor(d, type);
    final lower = title.trim().toLowerCase();
    for (final r in rows) {
      if (r.title.trim().toLowerCase() == lower) return r.value;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final s = ProviderScope.containerOf(context, listen: false).read(stringsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _section(context, s.tr('Income Statement', 'قائمة الدخل'), 'income', AppColors.primaryLight),
        const SizedBox(height: 16),
        _section(context, s.tr('Balance Sheet', 'الميزانية العمومية'), 'balance', AppColors.secondaryLight),
        const SizedBox(height: 16),
        _section(context, s.tr('Cash Flow', 'التدفق النقدي'), 'cashflow', AppColors.accentLight),
      ],
    );
  }

  Widget _section(BuildContext context, String title, String type, Color accent) {
    // Canonical row order = the team with the most rows for this statement.
    FinancialData? canonical;
    int best = -1;
    for (final d in teams) {
      final n = _rowsFor(d, type).length;
      if (n > best) { best = n; canonical = d; }
    }
    final labels = <String>[
      for (final r in (canonical == null ? <StatementRow>[] : _rowsFor(canonical, type)))
        if (r.title.trim().isNotEmpty) r.title.trim(),
    ];
    if (labels.isEmpty) {
      return const SizedBox.shrink();
    }

    final columns = <DataColumn>[
      const DataColumn(label: Text('')),
      for (final d in teams) DataColumn(label: Text(d.teamId)),
    ];

    final rows = <DataRow>[];
    for (final label in labels) {
      // Find best performer index for this row.
      final values = teams.map((d) => _lookup(d, type, label)).toList();
      final lowerBetter = _lowerIsBetter(label);
      int bestIdx = -1;
      double bestVal = lowerBetter ? double.infinity : -double.infinity;
      for (var i = 0; i < values.length; i++) {
        final v = values[i];
        if (v == null || v == 0) continue;
        if (lowerBetter ? v < bestVal : v > bestVal) { bestVal = v; bestIdx = i; }
      }
      rows.add(DataRow(cells: [
        DataCell(Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
        for (var i = 0; i < teams.length; i++)
          DataCell(Text(
            values[i] == null ? '—' : _fmt(values[i]!),
            style: GoogleFonts.jetBrainsMono(
              fontSize: 12,
              fontWeight: i == bestIdx ? FontWeight.w800 : FontWeight.w500,
              color: i == bestIdx ? accent : AppColors.textSecondary(context),
            ),
          )),
      ]));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Container(width: 4, height: 18, decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 8),
          Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: _StyledDataTable(columns: columns, rows: rows),
        ),
      ],
    );
  }
}

// ============================================================================
// TAB 2 -- DECISIONS
// ============================================================================
class _DecisionsTab extends ConsumerStatefulWidget {
  final int round;
  final int teamCount;

  const _DecisionsTab({required this.round, required this.teamCount});

  @override
  ConsumerState<_DecisionsTab> createState() => _DecisionsTabState();
}

class _DecisionsTabState extends ConsumerState<_DecisionsTab>
    with SingleTickerProviderStateMixin {
  late TabController _moduleTabController;

  static const _modules = ['financing', 'investing', 'operating'];
  static const _moduleIcons = [
    Icons.account_balance_rounded,
    Icons.show_chart_rounded,
    Icons.settings_rounded,
  ];

  @override
  void initState() {
    super.initState();
    _moduleTabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _moduleTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final decisionsAsync = ref.watch(_allTeamDecisionsProvider(widget.round));
    final s = ref.watch(stringsProvider);
    final moduleLabels = [
      s.tr('Financing', 'التمويل'),
      s.tr('Investing', 'الاستثمار'),
      s.tr('Operating', 'التشغيل'),
    ];

    return Column(
      children: [
        // Module sub-tabs
        Container(
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.cardColor(context),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderColor(context)),
          ),
          child: TabBar(
            controller: _moduleTabController,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            indicator: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(9),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            labelColor: Colors.white,
            unselectedLabelColor: AppColors.textSecondary(context),
            labelStyle: GoogleFonts.plusJakartaSans(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
            tabs: List.generate(3, (i) => Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(_moduleIcons[i], size: 14),
                  const SizedBox(width: 5),
                  Text(moduleLabels[i]),
                ],
              ),
            )),
          ),
        ),

        const SizedBox(height: 8),

        // Content
        Expanded(
          child: decisionsAsync.when(
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.info_outline,
                        size: 48, color: AppColors.textTertiary(context)),
                    const SizedBox(height: 12),
                    Text(
                      s.tr('Could not load decisions', 'تعذّر تحميل القرارات'),
                      style: TextStyle(color: AppColors.textSecondary(context)),
                    ),
                  ],
                ),
              ),
            ),
            data: (decisions) {
              if (decisions.isEmpty) {
                return Center(
                  child: Text(
                    s.tr('No decisions submitted for Round ${widget.round}',
                        'لم تُقدَّم أي قرارات للجولة ${widget.round}'),
                    style:
                        TextStyle(color: AppColors.textTertiary(context)),
                  ),
                );
              }
              return Column(
                children: [
                  _ParticipationSummary(
                    decisions: decisions,
                    teamCount: widget.teamCount.clamp(1, 7),
                    s: s,
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _moduleTabController,
                      children: _modules
                          .map((m) => _ModuleDecisionsList(
                                module: m,
                                decisions: decisions
                                    .where((d) =>
                                        d.module.toLowerCase() == m)
                                    .toList(),
                                teamCount: widget.teamCount.clamp(1, 7),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Participation summary: how many distinct (team, module) decisions carry at
// least one non-zero numeric value. Surfaces engagement at a glance.
// ---------------------------------------------------------------------------
class _ParticipationSummary extends StatelessWidget {
  final List<Decision> decisions;
  final int teamCount;
  final AppStrings s;

  const _ParticipationSummary({
    required this.decisions,
    required this.teamCount,
    required this.s,
  });

  bool _hasNonZeroValue(Decision d) {
    for (final v in d.decisionData.values) {
      double? n;
      if (v is num) {
        n = v.toDouble();
      } else if (v is String) {
        n = double.tryParse(v);
      }
      if (n != null && n != 0) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // Count active modules per team (1..teamCount).
    final activeByTeam = <int, int>{};
    final teamsSeen = <int>{};
    for (final d in decisions) {
      final match = RegExp(r'(\d+)').firstMatch(d.teamId);
      final tNum = match != null ? int.tryParse(match.group(1)!) : null;
      if (tNum == null) continue;
      teamsSeen.add(tNum);
      if (_hasNonZeroValue(d)) {
        activeByTeam[tNum] = (activeByTeam[tNum] ?? 0) + 1;
      }
    }

    if (teamsSeen.isEmpty) return const SizedBox.shrink();

    final participatingTeams =
        activeByTeam.values.where((c) => c > 0).length;
    final totalActiveDecisions =
        activeByTeam.values.fold<int>(0, (a, b) => a + b);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Icon(Icons.groups_rounded, size: 18, color: AppColors.primaryLight),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              s.tr(
                '$participatingTeams of $teamCount teams active · $totalActiveDecisions decisions with non-zero inputs',
                '$participatingTeams من $teamCount فرق نشطة · $totalActiveDecisions قرارات بمدخلات غير صفرية',
              ),
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary(context),
              ),
            ),
          ),
          // Per-team activity dots.
          Wrap(
            spacing: 4,
            children: List.generate(teamCount, (i) {
              final active = (activeByTeam[i + 1] ?? 0) > 0;
              return Tooltip(
                message: s.tr(
                  'T${i + 1}: ${activeByTeam[i + 1] ?? 0} active',
                  'ف${i + 1}: ${activeByTeam[i + 1] ?? 0} نشط',
                ),
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: active
                        ? AppColors.teamColor(i)
                        : AppColors.textTertiary(context)
                            .withValues(alpha: 0.25),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Single module decision list (table-like)
// ---------------------------------------------------------------------------
class _ModuleDecisionsList extends StatelessWidget {
  final String module;
  final List<Decision> decisions;
  final int teamCount;

  const _ModuleDecisionsList({
    required this.module,
    required this.decisions,
    required this.teamCount,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final s = ref.watch(stringsProvider);
      return _buildContent(context, s);
    });
  }

  Widget _buildContent(BuildContext context, AppStrings s) {
    if (decisions.isEmpty) {
      return Center(
        child: Text(
          s.tr('No ${module[0].toUpperCase()}${module.substring(1)} decisions yet',
              'لا توجد قرارات ${module[0].toUpperCase()}${module.substring(1)} بعد'),
          style: TextStyle(color: AppColors.textTertiary(context)),
        ),
      );
    }

    // Collect all unique keys across decision data
    final allKeys = <String>{};
    for (final d in decisions) {
      allKeys.addAll(d.decisionData.keys);
    }
    // Remove non-numeric / metadata keys
    allKeys.removeWhere((k) =>
        k == 'strategy' ||
        k == 'riskLevel' ||
        k == 'pricingStrategy' ||
        k == 'qualityLevel');

    final sortedKeys = allKeys.toList()..sort();
    final effectiveTeamCount = teamCount > 0 ? teamCount : 7;

    // Build a map: teamIndex -> Decision
    final teamDecisionMap = <int, Decision>{};
    for (final d in decisions) {
      final tNum = _teamIndex(d.teamId);
      if (tNum != null) teamDecisionMap[tNum] = d;
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Scrollable table
        GlassCard(
          padding: const EdgeInsets.all(4),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: _StyledDataTable(
              columns: [
                DataColumn(label: Text(s.tr('Metric', 'المؤشر'))),
                for (int i = 0; i < effectiveTeamCount; i++)
                  DataColumn(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.teamColor(i),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'T${i + 1}',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w700,
                            color: AppColors.teamColor(i),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
              rows: sortedKeys.asMap().entries.map((entry) {
                final idx = entry.key;
                final key = entry.value;
                // Gather values for min/max highlighting
                final rowValues = <int, double>{};
                for (int i = 0; i < effectiveTeamCount; i++) {
                  final dec = teamDecisionMap[i + 1];
                  if (dec != null && dec.decisionData.containsKey(key)) {
                    final v = _toDouble(dec.decisionData[key]);
                    if (v != null) rowValues[i] = v;
                  }
                }
                final maxVal = rowValues.isEmpty
                    ? null
                    : rowValues.values.reduce((a, b) => a > b ? a : b);
                final minVal = rowValues.isEmpty
                    ? null
                    : rowValues.values.reduce((a, b) => a < b ? a : b);

                return DataRow(
                  color: WidgetStateProperty.resolveWith<Color?>((states) {
                    if (idx.isOdd) {
                      return AppColors.cardColor(context).withValues(alpha: 0.5);
                    }
                    return null;
                  }),
                  cells: [
                    DataCell(Text(
                      _humanizeKey(key),
                      style: GoogleFonts.inter(
                          fontSize: 12, fontWeight: FontWeight.w500),
                    )),
                    for (int i = 0; i < effectiveTeamCount; i++)
                      DataCell(_buildDecisionCell(
                        context,
                        teamIndex: i,
                        decision: teamDecisionMap[i + 1],
                        key: key,
                        maxVal: maxVal,
                        minVal: minVal,
                      )),
                  ],
                );
              }).toList(),
            ),
          ),
        ).animate().fadeIn(duration: 400.ms),
      ],
    );
  }

  Widget _buildDecisionCell(
    BuildContext context, {
    required int teamIndex,
    required Decision? decision,
    required String key,
    required double? maxVal,
    required double? minVal,
  }) {
    if (decision == null || !decision.decisionData.containsKey(key)) {
      return Text('-',
          style: TextStyle(color: AppColors.textTertiary(context)));
    }

    final raw = decision.decisionData[key];
    final numVal = _toDouble(raw);
    if (numVal == null) {
      return Text(
        raw.toString(),
        style: GoogleFonts.jetBrainsMono(
          fontSize: 12,
          color: AppColors.teamColor(teamIndex),
        ),
      );
    }

    final isMax = maxVal != null && numVal == maxVal && maxVal != minVal;
    final isMin = minVal != null && numVal == minVal && maxVal != minVal;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isMax
            ? AppColors.secondarySurface.withValues(alpha: 0.6)
            : isMin
                ? AppColors.dangerSurface.withValues(alpha: 0.6)
                : null,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        _formatDecisionValue(numVal),
        style: GoogleFonts.jetBrainsMono(
          fontSize: 12,
          fontWeight: (isMax || isMin) ? FontWeight.w700 : FontWeight.w400,
          color: isMax
              ? AppColors.secondary
              : isMin
                  ? AppColors.danger
                  : AppColors.teamColor(teamIndex),
        ),
      ),
    );
  }

  int? _teamIndex(String teamId) {
    // "Team 1" -> 1
    final match = RegExp(r'(\d+)').firstMatch(teamId);
    if (match != null) return int.tryParse(match.group(1)!);
    return null;
  }

  double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    if (v is String) {
      if (v == 'NaN' || v.isEmpty) return null;
      return double.tryParse(v);
    }
    return null;
  }

  String _formatDecisionValue(double v) {
    if (v.abs() >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v.abs() >= 1000) return '${(v / 1000).toStringAsFixed(0)}K';
    if (v == v.roundToDouble()) return v.toStringAsFixed(0);
    return v.toStringAsFixed(1);
  }

  String _humanizeKey(String key) {
    // camelCase -> Title Case
    final spaced = key.replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
      (m) => '${m.group(1)} ${m.group(2)}',
    );
    return spaced[0].toUpperCase() + spaced.substring(1);
  }
}

// ============================================================================
// TAB 3 -- RATIOS
// ============================================================================
class _RatiosTab extends StatelessWidget {
  final List<FinancialData> teams;

  const _RatiosTab({required this.teams});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final s = ref.watch(stringsProvider);
      return _buildContent(context, s);
    });
  }

  Widget _buildContent(BuildContext context, AppStrings s) {
    if (teams.isEmpty) {
      return Center(
        child: Text(s.tr('No data available', 'لا توجد بيانات متاحة'),
            style: TextStyle(color: AppColors.textTertiary(context))),
      );
    }

    final ratioRows = _buildRatioRows(s);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        GlassCard(
          padding: const EdgeInsets.all(4),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: _StyledDataTable(
              columns: [
                DataColumn(label: Text(s.tr('Ratio', 'النسبة'))),
                for (int i = 0; i < teams.length; i++)
                  DataColumn(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.teamColor(i),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'T${i + 1}',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w700,
                            color: AppColors.teamColor(i),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
              rows: ratioRows
                  .asMap()
                  .entries
                  .map((entry) =>
                      _buildRatioRow(context, entry.value, entry.key))
                  .toList(),
            ),
          ),
        ).animate().fadeIn(duration: 400.ms),
        const SizedBox(height: 12),
        // Legend
        GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _legendDot(AppColors.secondarySurface, AppColors.secondary, s.tr('Best', 'الأفضل')),
              const SizedBox(width: 24),
              _legendDot(AppColors.dangerSurface, AppColors.danger, s.tr('Worst', 'الأسوأ')),
            ],
          ),
        ).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _legendDot(Color bgColor, Color dotColor, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: dotColor.withValues(alpha: 0.3)),
          ),
          child: Center(
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: dotColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  List<_RatioRowData> _buildRatioRows(AppStrings s) {
    return [
      _RatioRowData(
        name: s.tr('Current Ratio', 'نسبة التداول'),
        format: 'x',
        higherIsBetter: true,
        values: teams.map((t) => _ratioVal(t, 'currentRatio')).toList(),
      ),
      _RatioRowData(
        name: s.tr('Debt-to-Equity', 'الدين إلى حقوق الملكية'),
        format: 'x',
        higherIsBetter: false,
        values: teams.map((t) => _ratioVal(t, 'debtToEquity')).toList(),
      ),
      _RatioRowData(
        name: s.tr('ROE', 'العائد على حقوق الملكية'),
        format: '%',
        higherIsBetter: true,
        values: teams.map((t) => _ratioVal(t, 'roe')).toList(),
      ),
      _RatioRowData(
        name: s.tr('Profit Margin', 'هامش الربح'),
        format: '%',
        higherIsBetter: true,
        values: teams.map((t) => _ratioVal(t, 'profitMargin')).toList(),
      ),
      _RatioRowData(
        name: s.tr('Asset Turnover', 'معدل دوران الأصول'),
        format: 'x',
        higherIsBetter: true,
        values: teams.map((t) => _ratioVal(t, 'assetTurnover')).toList(),
      ),
      // ---- DuPont decomposition: ROE = NPM x Asset Turnover x Equity Mult.
      _RatioRowData(
        name: s.tr('— DuPont —', '— ديبونت —'),
        format: 'x',
        higherIsBetter: true,
        values: List<double?>.filled(teams.length, null),
        isSectionHeader: true,
      ),
      _RatioRowData(
        name: s.tr('Net Profit Margin', 'هامش صافي الربح'),
        format: '%',
        higherIsBetter: true,
        values: teams.map(_dupontNpm).toList(),
      ),
      _RatioRowData(
        name: s.tr('Asset Turnover (DuPont)', 'دوران الأصول (ديبونت)'),
        format: 'x',
        higherIsBetter: true,
        values: teams.map(_dupontAssetTurnover).toList(),
      ),
      _RatioRowData(
        name: s.tr('Equity Multiplier', 'مضاعف حقوق الملكية'),
        format: 'x',
        higherIsBetter: true,
        values: teams.map(_dupontEquityMultiplier).toList(),
      ),
      _RatioRowData(
        name: s.tr('ROE (DuPont)', 'العائد على حقوق الملكية (ديبونت)'),
        format: '%',
        higherIsBetter: true,
        values: teams.map(_dupontRoe).toList(),
      ),
    ];
  }

  // ---- DuPont component calculations (defensive against zero/missing data).
  double? _dupontNpm(FinancialData t) {
    if (t.revenue == 0) return null;
    return (t.netIncome / t.revenue) * 100;
  }

  double? _dupontAssetTurnover(FinancialData t) {
    if (t.totalAssets == 0) return null;
    return t.revenue / t.totalAssets;
  }

  double? _dupontEquityMultiplier(FinancialData t) {
    if (t.totalEquity == 0) return null;
    return t.totalAssets / t.totalEquity;
  }

  /// ROE via the DuPont identity (NPM x Asset Turnover x Equity Multiplier),
  /// expressed as a percentage. Null if any component is unavailable.
  double? _dupontRoe(FinancialData t) {
    final npm = _dupontNpm(t);
    final at = _dupontAssetTurnover(t);
    final em = _dupontEquityMultiplier(t);
    if (npm == null || at == null || em == null) return null;
    return (npm / 100) * at * em * 100;
  }

  double? _ratioVal(FinancialData t, String key) {
    // Try from ratios map first
    if (t.ratios != null && t.ratios!.containsKey(key)) {
      final v = t.ratios![key];
      if (v is num) return v.toDouble();
      if (v is String) {
        if (v == 'NaN' || v.isEmpty) return null;
        return double.tryParse(v);
      }
    }
    // Compute fallback for some common ratios
    switch (key) {
      case 'currentRatio':
        final ca = _numFromMap(t.balanceSheet, 'currentAssets');
        final cl = _numFromMap(t.balanceSheet, 'currentLiabilities');
        if (cl != null && cl != 0 && ca != null) return ca / cl;
        return null;
      case 'debtToEquity':
        if (t.totalEquity != 0) return t.totalLiabilities / t.totalEquity;
        return null;
      case 'roe':
        if (t.totalEquity != 0) return (t.netIncome / t.totalEquity) * 100;
        return null;
      case 'profitMargin':
        if (t.revenue != 0) return (t.netIncome / t.revenue) * 100;
        return null;
      case 'assetTurnover':
        if (t.totalAssets != 0) return t.revenue / t.totalAssets;
        return null;
    }
    return null;
  }

  double? _numFromMap(Map<String, dynamic>? map, String key) {
    if (map == null || !map.containsKey(key)) return null;
    final v = map[key];
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }

  DataRow _buildRatioRow(BuildContext context, _RatioRowData row, int rowIndex) {
    // Section header rows (e.g. the DuPont divider) just render a label.
    if (row.isSectionHeader) {
      return DataRow(
        cells: [
          DataCell(Text(
            row.name,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryLight,
              letterSpacing: 0.3,
            ),
          )),
          for (int i = 0; i < row.values.length; i++)
            const DataCell(SizedBox.shrink()),
        ],
      );
    }
    // Find best and worst indices (ignoring nulls)
    int? bestIdx;
    int? worstIdx;
    for (int i = 0; i < row.values.length; i++) {
      final v = row.values[i];
      if (v == null) continue;
      if (bestIdx == null) {
        bestIdx = i;
        worstIdx = i;
      } else {
        final bestV = row.values[bestIdx]!;
        final worstV = row.values[worstIdx!]!;
        if (row.higherIsBetter) {
          if (v > bestV) bestIdx = i;
          if (v < worstV) worstIdx = i;
        } else {
          if (v < bestV) bestIdx = i;
          if (v > worstV) worstIdx = i;
        }
      }
    }
    // Don't highlight if all values are the same
    if (bestIdx == worstIdx) {
      bestIdx = null;
      worstIdx = null;
    }

    return DataRow(
      color: WidgetStateProperty.resolveWith<Color?>((states) {
        if (rowIndex.isOdd) {
          return AppColors.cardColor(context).withValues(alpha: 0.5);
        }
        return null;
      }),
      cells: [
        DataCell(Text(
          row.name,
          style:
              GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
        )),
        for (int i = 0; i < row.values.length; i++)
          DataCell(_buildRatioCell(context, row.values[i], row.format,
              i: i, bestIdx: bestIdx, worstIdx: worstIdx)),
      ],
    );
  }

  Widget _buildRatioCell(
    BuildContext context,
    double? value,
    String format, {
    required int i,
    int? bestIdx,
    int? worstIdx,
  }) {
    if (value == null || value.isNaN || value.isInfinite) {
      return Text('-',
          style: TextStyle(color: AppColors.textTertiary(context)));
    }

    final isBest = bestIdx == i;
    final isWorst = worstIdx == i;

    String formatted;
    if (format == '%') {
      formatted = '${value.toStringAsFixed(1)}%';
    } else {
      formatted = '${value.toStringAsFixed(2)}x';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isBest
            ? AppColors.secondarySurface.withValues(alpha: 0.6)
            : isWorst
                ? AppColors.dangerSurface.withValues(alpha: 0.6)
                : null,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        formatted,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 12,
          fontWeight: (isBest || isWorst) ? FontWeight.w700 : FontWeight.w400,
          color: isBest
              ? AppColors.secondary
              : isWorst
                  ? AppColors.danger
                  : AppColors.teamColor(i),
        ),
      ),
    );
  }
}

class _RatioRowData {
  final String name;
  final String format; // '%' or 'x'
  final bool higherIsBetter;
  final List<double?> values;
  final bool isSectionHeader;

  const _RatioRowData({
    required this.name,
    required this.format,
    required this.higherIsBetter,
    required this.values,
    this.isSectionHeader = false,
  });
}

// ============================================================================
// COMPARISON CARD (upgraded with custom bars, icons, team color dots)
// ============================================================================
class _ComparisonCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<FinancialData> teams;
  final double Function(FinancialData) getValue;
  final String? prefix;

  const _ComparisonCard({
    required this.title,
    required this.icon,
    required this.teams,
    required this.getValue,
    this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final s = ref.watch(stringsProvider);
      return _buildContent(context, s);
    });
  }

  Widget _buildContent(BuildContext context, AppStrings s) {
    final maxVal = teams.isEmpty
        ? 1.0
        : teams
            .map((t) => getValue(t).abs())
            .fold<double>(0, (a, b) => a > b ? a : b);

    // Find the leading team index
    int? leadingIdx;
    if (teams.isNotEmpty) {
      double leadingVal = double.negativeInfinity;
      for (int i = 0; i < teams.length; i++) {
        final v = getValue(teams[i]);
        if (v > leadingVal) {
          leadingVal = v;
          leadingIdx = i;
        }
      }
    }

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with icon and metric name
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.12),
                      AppColors.primaryLight.withValues(alpha: 0.06),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: AppColors.primaryLight,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary(context),
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              if (leadingIdx != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.teamColor(leadingIdx)
                        .withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.emoji_events_rounded,
                        size: 12,
                        color: AppColors.teamColor(leadingIdx),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'T${leadingIdx + 1}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.teamColor(leadingIdx),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          // Divider
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.borderColor(context),
                  AppColors.borderColor(context).withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          if (teams.isEmpty)
            Text(s.tr('No data', 'لا توجد بيانات'),
                style: TextStyle(color: AppColors.textTertiary(context)))
          else
            ...teams.asMap().entries.map((entry) {
              final val = getValue(entry.value);
              final pct =
                  maxVal > 0 ? (val.abs() / maxVal).clamp(0.0, 1.0) : 0.0;
              final color = AppColors.teamColor(entry.key);
              final isLeader = entry.key == leadingIdx;

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Team color dot
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: color.withValues(alpha: 0.4),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          s.tr('Team ${entry.key + 1}', 'الفريق ${entry.key + 1}'),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight:
                                isLeader ? FontWeight.w700 : FontWeight.w500,
                            color: AppColors.textPrimary(context),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${prefix ?? ''}${_formatNum(val)}',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 13,
                            fontWeight:
                                isLeader ? FontWeight.w700 : FontWeight.w400,
                            color: val < 0
                                ? AppColors.dangerLight
                                : isLeader
                                    ? color
                                    : AppColors.textPrimary(context),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Custom animated bar
                    Container(
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppColors.cardColor(context),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: pct),
                          duration: Duration(
                              milliseconds: 600 + (entry.key * 100)),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, _) {
                            return FractionallySizedBox(
                              widthFactor: value,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      color,
                                      color.withValues(alpha: 0.7),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: isLeader
                                      ? [
                                          BoxShadow(
                                            color: color.withValues(
                                                alpha: 0.35),
                                            blurRadius: 6,
                                            offset:
                                                const Offset(0, 2),
                                          ),
                                        ]
                                      : null,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  String _formatNum(double val) {
    if (val.abs() >= 1000000) {
      return '${(val / 1000000).toStringAsFixed(1)}M';
    }
    if (val.abs() >= 1000) return '${(val / 1000).toStringAsFixed(0)}K';
    return val.toStringAsFixed(0);
  }
}

// ============================================================================
// STYLED DATA TABLE (shared between Decisions & Ratios tabs)
// ============================================================================
class _StyledDataTable extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;

  const _StyledDataTable({
    required this.columns,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return DataTable(
      headingRowHeight: 48,
      dataRowMinHeight: 42,
      dataRowMaxHeight: 50,
      columnSpacing: 16,
      horizontalMargin: 12,
      headingRowColor: WidgetStateProperty.resolveWith<Color?>(
        (_) => AppColors.primary.withValues(alpha: 0.06),
      ),
      headingTextStyle: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary(context),
      ),
      dividerThickness: 0.5,
      columns: columns,
      rows: rows,
    );
  }
}
