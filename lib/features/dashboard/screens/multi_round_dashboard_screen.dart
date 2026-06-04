import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/app_colors.dart';
import '../../../data/models/financial_data.dart';
import '../../../providers/team_provider.dart';
import '../../../providers/repository_providers.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/animated_counter.dart';
import '../../../shared/widgets/shimmer_loading.dart';
import '../../../app/i18n/app_strings.dart';

// ---------------------------------------------------------------------------
// Providers for multi-round data
// ---------------------------------------------------------------------------

/// Fetches financial data for the selected team across rounds 1-3.
final multiRoundFinancialsProvider =
    FutureProvider.family<List<FinancialData>, String>((ref, teamId) async {
  final repo = ref.watch(gameRepositoryProvider);
  final results = await Future.wait([
    repo.fetchFinancialData(teamId, round: 1),
    repo.fetchFinancialData(teamId, round: 2),
    repo.fetchFinancialData(teamId, round: 3),
  ]);
  return results;
});

/// Fetches leaderboard data for rounds 1-3.
final multiRoundLeaderboardProvider =
    FutureProvider<List<List<LeaderboardEntry>>>((ref) async {
  final repo = ref.watch(gameRepositoryProvider);
  final results = await Future.wait([
    repo.fetchLeaderboard(round: 1),
    repo.fetchLeaderboard(round: 2),
    repo.fetchLeaderboard(round: 3),
  ]);
  return results;
});

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class MultiRoundDashboardScreen extends ConsumerWidget {
  const MultiRoundDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamState = ref.watch(teamProvider);
    final team = teamState.selectedTeam;
    final s = ref.watch(stringsProvider);

    if (team == null) {
      return Scaffold(
        body: Container(
          decoration:
              BoxDecoration(gradient: AppColors.backgroundGradient(context)),
          child: Center(child: Text(s.tr('No team selected', 'لم يتم اختيار فريق'))),
        ),
      );
    }

    final financialsAsync = ref.watch(multiRoundFinancialsProvider(team.id));
    final leaderboardAsync = ref.watch(multiRoundLeaderboardProvider);

    return Scaffold(
      body: Container(
        decoration:
            BoxDecoration(gradient: AppColors.backgroundGradient(context)),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(multiRoundFinancialsProvider(team.id));
              ref.invalidate(multiRoundLeaderboardProvider);
            },
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                // ── Header ──────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_rounded),
                          onPressed: () => context.pop(),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            s.tr('Performance Trends', 'اتجاهات الأداء'),
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 300.ms),
                ),

                // ── Team badge + rank ───────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: _TeamHeaderCard(
                      team: team,
                      leaderboardAsync: leaderboardAsync,
                    ),
                  ),
                ),

                // ── Content body ────────────────────────────────────────
                financialsAsync.when(
                  loading: () => const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          ShimmerCard(height: 160),
                          SizedBox(height: 12),
                          ShimmerCard(height: 160),
                        ],
                      ),
                    ),
                  ),
                  error: (e, _) => SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Center(
                        child: Column(
                          children: [
                            const Icon(Icons.error_outline,
                                color: AppColors.dangerLight, size: 48),
                            const SizedBox(height: 12),
                            Text(s.tr('Failed to load data', 'فشل تحميل البيانات'),
                                style: TextStyle(
                                    color: AppColors.textSecondary(context))),
                            const SizedBox(height: 4),
                            Text(e.toString(),
                                style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textTertiary(context))),
                          ],
                        ),
                      ),
                    ),
                  ),
                  data: (rounds) {
                    return SliverList(
                      delegate: SliverChildListDelegate([
                        // Section 2 – Key Metrics Trend Cards
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                          child: Text(s.tr('Key Metrics', 'المؤشرات الرئيسية'),
                              style:
                                  Theme.of(context).textTheme.titleLarge),
                        ),
                        _MetricTrendGrid(rounds: rounds),

                        // Section 3 – Consolidated Financial Summary
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                          child: Text(s.tr('Financial Summary by Round', 'ملخص مالي حسب الجولة'),
                              style:
                                  Theme.of(context).textTheme.titleLarge),
                        ),
                        _ConsolidatedSummary(rounds: rounds),

                        // Section 4 – Cross-Round Leaderboard
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                          child: Text(s.tr('Rank Progression', 'تطوّر الترتيب'),
                              style:
                                  Theme.of(context).textTheme.titleLarge),
                        ),
                        leaderboardAsync.when(
                          loading: () => const Padding(
                            padding: EdgeInsets.all(16),
                            child: ShimmerCard(height: 100),
                          ),
                          error: (e, s) => const SizedBox.shrink(),
                          data: (lb) => _CrossRoundLeaderboard(
                            leaderboardRounds: lb,
                            teamId: team.id,
                          ),
                        ),

                        // Section 5 – Performance Badges
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                          child: Text(s.tr('Performance Badges', 'أوسمة الأداء'),
                              style:
                                  Theme.of(context).textTheme.titleLarge),
                        ),
                        leaderboardAsync.when(
                          loading: () => const Padding(
                            padding: EdgeInsets.all(16),
                            child: ShimmerCard(height: 60),
                          ),
                          error: (e, s) => const SizedBox.shrink(),
                          data: (lb) => _PerformanceBadges(
                            rounds: rounds,
                            leaderboardRounds: lb,
                            teamId: team.id,
                          ),
                        ),

                        const SizedBox(height: 32),
                      ]),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Team Header Card
// ---------------------------------------------------------------------------

class _TeamHeaderCard extends StatelessWidget {
  final dynamic team; // Team model
  final AsyncValue<List<List<LeaderboardEntry>>> leaderboardAsync;

  const _TeamHeaderCard({required this.team, required this.leaderboardAsync});

  @override
  Widget build(BuildContext context) {
    final teamColor = AppColors.teamColor(team.teamNumber - 1);
    // Compute cumulative rank from latest leaderboard
    int overallRank = 0;
    leaderboardAsync.whenData((lb) {
      // Use the last non-empty leaderboard for overall rank
      for (int i = lb.length - 1; i >= 0; i--) {
        final entry =
            lb[i].where((e) => e.teamId == team.id).firstOrNull;
        if (entry != null && entry.rank > 0) {
          overallRank = entry.rank;
          break;
        }
      }
    });

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            teamColor.withValues(alpha: 0.85),
            teamColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: teamColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        team.name as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Consumer(builder: (context, ref, _) {
                  final s = ref.watch(stringsProvider);
                  return Text(
                    s.tr('3-Round Performance Overview', 'نظرة عامة على أداء 3 جولات'),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12,
                    ),
                  );
                }),
              ],
            ),
          ),
          if (overallRank > 0)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.emoji_events_rounded,
                      color: Colors.amber, size: 24),
                  const SizedBox(height: 2),
                  Text('#$overallRank',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16)),
                ],
              ),
            ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1);
  }
}

// ---------------------------------------------------------------------------
// Section 2 – Key Metrics Trend Grid
// ---------------------------------------------------------------------------

class _MetricTrendGrid extends StatelessWidget {
  final List<FinancialData> rounds;

  const _MetricTrendGrid({required this.rounds});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final s = ref.watch(stringsProvider);
      return _buildContent(context, s);
    });
  }

  Widget _buildContent(BuildContext context, AppStrings s) {
    final metrics = [
      _MetricDef(s.tr('Revenue', 'الإيرادات'), Icons.attach_money_rounded,
          AppColors.secondaryLight, (d) => d.revenue),
      _MetricDef(s.tr('Net Income', 'صافي الدخل'), Icons.trending_up_rounded,
          AppColors.primaryLight, (d) => d.netIncome),
      _MetricDef(s.tr('Total Assets', 'إجمالي الأصول'), Icons.pie_chart_rounded,
          AppColors.accentLight, (d) => d.totalAssets),
      _MetricDef(s.tr('Total Equity', 'إجمالي حقوق الملكية'), Icons.account_balance_rounded,
          const Color(0xFF8B5CF6), (d) => d.totalEquity),
      _MetricDef(s.tr('Op. Cash Flow', 'التدفق النقدي التشغيلي'), Icons.water_drop_rounded,
          const Color(0xFF06B6D4), (d) => d.operatingCashFlow),
      _MetricDef(s.tr('Score', 'النتيجة'), Icons.star_rounded, const Color(0xFFF59E0B),
          (d) => d.totalScore, isScore: true),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemCount: metrics.length,
        itemBuilder: (context, index) {
          final m = metrics[index];
          return _MetricTrendCard(
            metric: m,
            rounds: rounds,
          ).animate().fadeIn(delay: (300 + 80 * index).ms).slideY(begin: 0.05);
        },
      ),
    );
  }
}

class _MetricDef {
  final String name;
  final IconData icon;
  final Color color;
  final double Function(FinancialData) extractor;
  final bool isScore;

  const _MetricDef(this.name, this.icon, this.color, this.extractor,
      {this.isScore = false});
}

class _MetricTrendCard extends StatelessWidget {
  final _MetricDef metric;
  final List<FinancialData> rounds;

  const _MetricTrendCard({required this.metric, required this.rounds});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final s = ref.watch(stringsProvider);
      return _buildContent(context, s);
    });
  }

  Widget _buildContent(BuildContext context, AppStrings s) {
    final values = rounds.map((r) => metric.extractor(r)).toList();
    final current = values.isNotEmpty ? values.last : 0.0;
    final first = values.isNotEmpty ? values.first : 0.0;
    final pctChange =
        first != 0 ? ((current - first) / first.abs()) * 100 : 0.0;
    final isUp = pctChange >= 0;

    // Find best round index
    int bestIdx = 0;
    double bestVal = values.isNotEmpty ? values[0] : 0;
    for (int i = 1; i < values.length; i++) {
      if (values[i] > bestVal) {
        bestVal = values[i];
        bestIdx = i;
      }
    }

    return GlassCard(
      padding: const EdgeInsets.all(14),
      borderColor: metric.color.withValues(alpha: 0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              Icon(metric.icon, color: metric.color, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(metric.name,
                    style: TextStyle(
                        fontSize: 11,
                        color: metric.color,
                        fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Sparkline
          Expanded(
            child: _Sparkline(
              values: values,
              color: metric.color,
              bestIndex: bestIdx,
            ),
          ),
          const SizedBox(height: 8),

          // Current value
          AnimatedCounter(
            value: current,
            prefix: metric.isScore ? '' : '\$',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: current < 0
                  ? AppColors.dangerLight
                  : AppColors.textPrimary(context),
            ),
          ),

          // Trend indicator
          const SizedBox(height: 2),
          Row(
            children: [
              Icon(
                isUp ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                size: 12,
                color: isUp ? AppColors.secondaryLight : AppColors.dangerLight,
              ),
              const SizedBox(width: 2),
              Text(
                '${pctChange.abs().toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color:
                      isUp ? AppColors.secondaryLight : AppColors.dangerLight,
                ),
              ),
              const Spacer(),
              Text(
                s.tr('Best: R${bestIdx + 1}', 'الأفضل: ج${bestIdx + 1}'),
                style: TextStyle(
                  fontSize: 9,
                  color: AppColors.textTertiary(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sparkline using fl_chart
// ---------------------------------------------------------------------------

class _Sparkline extends StatelessWidget {
  final List<double> values;
  final Color color;
  final int bestIndex;

  const _Sparkline(
      {required this.values, required this.color, required this.bestIndex});

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) return const SizedBox.shrink();

    final spots = values
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();

    final minY = values.reduce((a, b) => a < b ? a : b);
    final maxY = values.reduce((a, b) => a > b ? a : b);
    final padding = (maxY - minY) * 0.15;

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 18,
              interval: 1,
              getTitlesWidget: (v, _) => Text(
                'R${v.toInt() + 1}',
                style: TextStyle(
                    fontSize: 9, color: AppColors.textTertiary(context)),
              ),
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minY: minY - padding,
        maxY: maxY + padding,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: color,
            barWidth: 2.5,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, pct, bar, index) {
                if (index == bestIndex) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: color,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                }
                return FlDotCirclePainter(
                  radius: 3,
                  color: color.withValues(alpha: 0.7),
                  strokeWidth: 0,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: color.withValues(alpha: 0.1),
            ),
          ),
        ],
        lineTouchData: const LineTouchData(enabled: false),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section 3 – Consolidated Financial Summary (expandable per round)
// ---------------------------------------------------------------------------

class _ConsolidatedSummary extends StatelessWidget {
  final List<FinancialData> rounds;

  const _ConsolidatedSummary({required this.rounds});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: List.generate(rounds.length, (i) {
          final rd = rounds[i];
          final prev = i > 0 ? rounds[i - 1] : null;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _RoundExpansionTile(
              roundIndex: i,
              data: rd,
              prev: prev,
            ),
          ).animate().fadeIn(delay: (400 + 100 * i).ms);
        }),
      ),
    );
  }
}

class _RoundExpansionTile extends StatelessWidget {
  final int roundIndex;
  final FinancialData data;
  final FinancialData? prev;

  const _RoundExpansionTile(
      {required this.roundIndex, required this.data, this.prev});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final s = ref.watch(stringsProvider);
      return _buildContent(context, s);
    });
  }

  Widget _buildContent(BuildContext context, AppStrings s) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassCard(
      padding: EdgeInsets.zero,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding:
              const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          leading: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _roundColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                'R${roundIndex + 1}',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: _roundColor,
                    fontSize: 13),
              ),
            ),
          ),
          title: Text(s.tr('Round ${roundIndex + 1}', 'الجولة ${roundIndex + 1}'),
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          subtitle: Text(
            s.tr('Score: ', 'النتيجة: ') + data.totalScore.toStringAsFixed(0),
            style: TextStyle(
                fontSize: 12, color: AppColors.textTertiary(context)),
          ),
          children: [
            // Mini Income Statement
            _SectionLabel(s.tr('Income Statement', 'قائمة الدخل'), isDark),
            _SummaryRow(s.tr('Revenue', 'الإيرادات'), data.revenue, prev?.revenue, context),
            _SummaryRow(
                s.tr('Net Income', 'صافي الدخل'), data.netIncome, prev?.netIncome, context),
            const SizedBox(height: 10),
            // Mini Balance Sheet
            _SectionLabel(s.tr('Balance Sheet', 'الميزانية العمومية'), isDark),
            _SummaryRow(
                s.tr('Total Assets', 'إجمالي الأصول'), data.totalAssets, prev?.totalAssets, context),
            _SummaryRow(
                s.tr('Total Equity', 'إجمالي حقوق الملكية'), data.totalEquity, prev?.totalEquity, context),
            const SizedBox(height: 10),
            // Mini Cash Flow
            _SectionLabel(s.tr('Cash Flow', 'التدفق النقدي'), isDark),
            _SummaryRow(s.tr('Operating CF', 'التدفق النقدي التشغيلي'), data.operatingCashFlow,
                prev?.operatingCashFlow, context),
          ],
        ),
      ),
    );
  }

  Color get _roundColor {
    const colors = [AppColors.primaryLight, AppColors.secondaryLight, AppColors.accentLight];
    return colors[roundIndex % colors.length];
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  final bool isDark;
  const _SectionLabel(this.text, this.isDark);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 2),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final double value;
  final double? prevValue;
  final BuildContext ctx;

  const _SummaryRow(this.label, this.value, this.prevValue, this.ctx);

  @override
  Widget build(BuildContext context) {
    final diff = prevValue != null ? value - prevValue! : null;
    final improved = diff != null && diff > 0;
    final declined = diff != null && diff < 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          if (diff != null)
            Container(
              width: 3,
              height: 16,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: improved
                    ? AppColors.secondaryLight
                    : declined
                        ? AppColors.dangerLight
                        : AppColors.textTertiary(ctx),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          if (diff == null) const SizedBox(width: 11),
          Expanded(
            child: Text(label,
                style: const TextStyle(fontSize: 12)),
          ),
          Text(
            _formatValue(value),
            style: GoogleFonts.jetBrainsMono(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: improved
                  ? AppColors.secondaryLight
                  : declined
                      ? AppColors.dangerLight
                      : AppColors.textPrimary(ctx),
            ),
          ),
          if (diff != null) ...[
            const SizedBox(width: 6),
            Icon(
              improved ? Icons.arrow_upward_rounded : declined ? Icons.arrow_downward_rounded : Icons.remove_rounded,
              size: 12,
              color: improved
                  ? AppColors.secondaryLight
                  : declined
                      ? AppColors.dangerLight
                      : AppColors.textTertiary(ctx),
            ),
          ],
        ],
      ),
    );
  }

  static String _formatValue(double value) {
    final abs = value.abs();
    final sign = value < 0 ? '-' : '';
    if (abs >= 1000000) return '$sign\$${(abs / 1000000).toStringAsFixed(1)}M';
    if (abs >= 1000) return '$sign\$${(abs / 1000).toStringAsFixed(1)}k';
    return '$sign\$${abs.toStringAsFixed(0)}';
  }
}

// ---------------------------------------------------------------------------
// Section 4 – Cross-Round Leaderboard
// ---------------------------------------------------------------------------

class _CrossRoundLeaderboard extends StatelessWidget {
  final List<List<LeaderboardEntry>> leaderboardRounds;
  final String teamId;

  const _CrossRoundLeaderboard(
      {required this.leaderboardRounds, required this.teamId});

  @override
  Widget build(BuildContext context) {
    // Get ranks for each round
    final ranks = leaderboardRounds.map((lb) {
      final entry = lb.where((e) => e.teamId == teamId).firstOrNull;
      return entry?.rank ?? 0;
    }).toList();

    // Overall cumulative = average rank (simple approach) or latest rank
    final validRanks = ranks.where((r) => r > 0).toList();
    final cumulative = validRanks.isNotEmpty
        ? (validRanks.reduce((a, b) => a + b) / validRanks.length)
            .round()
        : 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Round rank boxes
            Row(
              children: List.generate(3, (i) {
                final rank = ranks.length > i ? ranks[i] : 0;
                final prevRank = i > 0 && ranks.length > i - 1 ? ranks[i - 1] : null;
                return Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (i > 0 && prevRank != null && rank > 0)
                        _RankChangeArrow(from: prevRank, to: rank),
                      _RankBox(round: i + 1, rank: rank),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            // Overall
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.military_tech_rounded,
                      color: AppColors.accentLight, size: 20),
                  const SizedBox(width: 8),
                  Consumer(builder: (context, ref, _) {
                    final s = ref.watch(stringsProvider);
                    return Text(
                      s.tr('Overall Rank: ', 'الترتيب العام: '),
                      style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary(context)),
                    );
                  }),
                  Text(
                    cumulative > 0 ? '#$cumulative' : '--',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate().fadeIn(delay: 600.ms),
    );
  }
}

class _RankBox extends StatelessWidget {
  final int round;
  final int rank;

  const _RankBox({required this.round, required this.rank});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('R$round',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textTertiary(context))),
        const SizedBox(height: 4),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: rank > 0
                ? AppColors.primaryLight.withValues(alpha: 0.1)
                : AppColors.cardColor(context),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: rank > 0
                  ? AppColors.primaryLight.withValues(alpha: 0.3)
                  : AppColors.borderColor(context),
            ),
          ),
          child: Center(
            child: Text(
              rank > 0 ? '#$rank' : '--',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: rank > 0
                    ? AppColors.primaryLight
                    : AppColors.textTertiary(context),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RankChangeArrow extends StatelessWidget {
  final int from;
  final int to;

  const _RankChangeArrow({required this.from, required this.to});

  @override
  Widget build(BuildContext context) {
    // Lower rank number = better
    final improved = to < from;
    final same = to == from;

    return Padding(
      padding: const EdgeInsets.only(top: 16, right: 4),
      child: Icon(
        same
            ? Icons.horizontal_rule_rounded
            : improved
                ? Icons.trending_up_rounded
                : Icons.trending_down_rounded,
        size: 18,
        color: same
            ? AppColors.textTertiary(context)
            : improved
                ? AppColors.secondaryLight
                : AppColors.dangerLight,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section 5 – Performance Badges
// ---------------------------------------------------------------------------

class _PerformanceBadges extends StatelessWidget {
  final List<FinancialData> rounds;
  final List<List<LeaderboardEntry>> leaderboardRounds;
  final String teamId;

  const _PerformanceBadges({
    required this.rounds,
    required this.leaderboardRounds,
    required this.teamId,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final s = ref.watch(stringsProvider);
      return _buildContent(context, s);
    });
  }

  Widget _buildContent(BuildContext context, AppStrings s) {
    final badges = _computeBadges(s);

    if (badges.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GlassCard(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Text(
              s.tr('Complete more rounds to earn badges!',
                  'أكمل مزيدًا من الجولات لكسب الأوسمة!'),
              style: TextStyle(
                  color: AppColors.textTertiary(context), fontSize: 13),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: badges
              .asMap()
              .entries
              .map((e) => _BadgeChip(badge: e.value)
                  .animate()
                  .fadeIn(delay: (700 + 100 * e.key).ms)
                  .scale(begin: const Offset(0.8, 0.8)))
              .toList(),
        ),
      ).animate().fadeIn(delay: 700.ms),
    );
  }

  List<_Badge> _computeBadges(AppStrings s) {
    final badges = <_Badge>[];

    // Rank data
    final ranks = leaderboardRounds.map((lb) {
      final entry = lb.where((e) => e.teamId == teamId).firstOrNull;
      return entry?.rank ?? 0;
    }).toList();

    final validRanks = ranks.where((r) => r > 0).toList();

    // Most Improved: biggest positive rank change (lower number = better)
    if (validRanks.length >= 2) {
      int maxImprovement = 0;
      for (int i = 1; i < validRanks.length; i++) {
        final improvement = validRanks[i - 1] - validRanks[i];
        if (improvement > maxImprovement) maxImprovement = improvement;
      }
      if (maxImprovement > 0) {
        badges.add(_Badge(
          s.tr('Most Improved', 'الأكثر تحسّنًا'),
          Icons.rocket_launch_rounded,
          AppColors.secondaryLight,
        ));
      }
    }

    // Consistent Performer: same rank across all valid rounds
    if (validRanks.length >= 2 && validRanks.toSet().length == 1) {
      badges.add(_Badge(
        s.tr('Consistent Performer', 'أداء ثابت'),
        Icons.balance_rounded,
        AppColors.primaryLight,
      ));
    }

    // Revenue Leader: highest revenue in any round across all teams
    for (int i = 0; i < leaderboardRounds.length && i < rounds.length; i++) {
      final lb = leaderboardRounds[i];
      if (lb.isEmpty) continue;
      // Check if this team has the highest revenue among all entries
      final myRevenue = rounds[i].revenue;
      // Use leaderboard entries for comparison since we don't have all
      // team financials per round. Approximate: if our team's revenue is
      // positive and our rank is 1, we consider it revenue leader.
      final myEntry = lb.where((e) => e.teamId == teamId).firstOrNull;
      if (myEntry != null && myEntry.rank == 1 && myRevenue > 0) {
        badges.add(_Badge(
          s.tr('Revenue Leader', 'متصدّر الإيرادات'),
          Icons.attach_money_rounded,
          AppColors.accentLight,
        ));
        break;
      }
    }

    // Profit Champion: highest net income in any round
    for (int i = 0; i < leaderboardRounds.length && i < rounds.length; i++) {
      final lb = leaderboardRounds[i];
      if (lb.isEmpty) continue;
      final myNI = rounds[i].netIncome;
      // If this team has the highest netIncome among leaderboard
      final allNI = lb.map((e) => e.netIncome).toList();
      if (allNI.isNotEmpty && myNI >= allNI.reduce((a, b) => a > b ? a : b) && myNI > 0) {
        badges.add(_Badge(
          s.tr('Profit Champion', 'بطل الأرباح'),
          Icons.workspace_premium_rounded,
          const Color(0xFFEC4899),
        ));
        break;
      }
    }

    return badges;
  }
}

class _Badge {
  final String label;
  final IconData icon;
  final Color color;

  const _Badge(this.label, this.icon, this.color);
}

class _BadgeChip extends StatelessWidget {
  final _Badge badge;

  const _BadgeChip({required this.badge});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: badge.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badge.color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(badge.icon, size: 16, color: badge.color),
          const SizedBox(width: 6),
          Text(
            badge.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: badge.color,
            ),
          ),
        ],
      ),
    );
  }
}
