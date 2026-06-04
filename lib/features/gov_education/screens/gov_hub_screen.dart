import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/i18n/app_strings.dart';
import '../../../providers/repository_providers.dart';
import '../../../shared/widgets/glass_card.dart';

class GovHubScreen extends ConsumerStatefulWidget {
  const GovHubScreen({super.key});

  @override
  ConsumerState<GovHubScreen> createState() => _GovHubScreenState();
}

class _GovHubScreenState extends ConsumerState<GovHubScreen>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic>? _progress;
  List<Map<String, dynamic>> _leaderboard = [];
  bool _loadingData = true;
  late AnimationController _pulseController;

  // Matches website education hub exactly
  static const _modules = [
    _GovModule(1, 'Financial Management Primer', 'The Three Pillars of Finance', Icons.school_rounded),
    _GovModule(2, 'Understanding Financial Statements', 'Accounting cycle & core statements', Icons.receipt_long_rounded),
    _GovModule(3, 'Analysis of Financial Statements', 'Ratios, trends & DuPont framework', Icons.analytics_rounded),
    _GovModule(4, 'Break-Even Analysis', 'Fixed costs, variable costs & contribution margin', Icons.adjust_rounded, route: '/education/break-even'),
    _GovModule(5, 'Capital Budgeting & Investment', 'NPV, IRR & payback period', Icons.trending_up_rounded, route: '/education/capital-budgeting'),
    _GovModule(6, 'Budgeting & Financial Planning', 'Budget types, approaches & processes', Icons.account_balance_wallet_rounded),
    _GovModule(7, 'IFRS vs IPSAS Standards', 'Where they align and diverge', Icons.description_rounded),
    _GovModule(8, 'Sector Finance Comparison', 'Compare 12 dimensions across sectors', Icons.compare_rounded),
    _GovModule(9, 'Compliance & Internal Controls', 'Controls, fraud prevention & regulation', Icons.security_rounded),
    _GovModule(10, 'Financial Auditing & Review', 'Audit processes, standards & trends', Icons.fact_check_rounded),
    _GovModule(11, 'Elements of Finance', 'Core building blocks of finance', Icons.account_tree_rounded),
    _GovModule(12, 'Government Financial Decisions', 'Public-sector decision making', Icons.gavel_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _loadData();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final repo = ref.read(educationRepositoryProvider);
      final progress = await repo.fetchGovProgress(1);
      final leaderboard = await repo.fetchGovLeaderboard();
      if (mounted) {
        setState(() {
          _progress = progress;
          _leaderboard = leaderboard;
          _loadingData = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingData = false);
    }
  }

  int get _completedCount {
    final modules = _progress?['completedModules'] as List?;
    return modules?.length ?? 0;
  }

  int get _totalScore => (_progress?['totalScore'] as num?)?.toInt() ?? 0;

  int get _level => (_completedCount / 2).floor() + 1;

  bool _isModuleCompleted(int moduleId) {
    final modules = _progress?['completedModules'] as List?;
    return modules?.contains(moduleId) == true;
  }

  int _currentModuleId() {
    for (int i = 1; i <= 10; i++) {
      if (!_isModuleCompleted(i)) return i;
    }
    return 10;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final s = ref.watch(stringsProvider);
    final currentModuleId = _currentModuleId();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [AppColors.darkBg, AppColors.darkSurface]
                : [const Color(0xFFF5F3FF), const Color(0xFFF0EAFF), Colors.white],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // ── Styled Header ──
              SliverToBoxAdapter(child: _buildHeader(context)),

              // ── Progress Card ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: _buildProgressCard(context, isDark),
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.08),
              ),

              // ── Section label ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                  child: Text(
                    s.tr('YOUR JOURNEY', 'رحلتك'),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: AppColors.purpleLight.withValues(alpha: 0.7),
                    ),
                  ),
                ).animate().fadeIn(delay: 300.ms),
              ),

              // ── Loading Shimmer ──
              if (_loadingData && _progress == null)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildShimmerItem(context, isDark, index),
                      childCount: 5,
                    ),
                  ),
                ),

              // ── Module List with Timeline ──
              if (!_loadingData || _progress != null)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final module = _modules[index];
                        final isCompleted = _isModuleCompleted(module.number);
                        final isCurrent = module.number == currentModuleId;
                        final isLocked = module.number > currentModuleId && !isCompleted;

                        return _buildModuleItem(
                          context, module, isCompleted, isCurrent, isLocked,
                          index, isDark,
                        );
                      },
                      childCount: _modules.length,
                    ),
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  HEADER
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    final s = ref.watch(stringsProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.purple.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary(context)),
              onPressed: () => context.pop(),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.purple, AppColors.purpleLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.purple.withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.account_balance_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 10),
          Text(
            s.tr('Module Hub', 'مركز الوحدات'),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary(context),
            ),
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: AppColors.accentLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.leaderboard_rounded, color: AppColors.accentLight),
              onPressed: () => _showLeaderboard(context),
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.1);
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  PROGRESS CARD
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildProgressCard(BuildContext context, bool isDark) {
    final s = ref.watch(stringsProvider);
    final progressValue = _modules.isEmpty ? 0.0 : _completedCount / _modules.length;

    return GlassCard(
      padding: const EdgeInsets.all(20),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? [
                AppColors.purple.withValues(alpha: 0.25),
                AppColors.purple.withValues(alpha: 0.08),
              ]
            : [
                AppColors.purpleSurface,
                AppColors.purple.withValues(alpha: 0.08),
              ],
      ),
      borderColor: AppColors.purple.withValues(alpha: 0.3),
      child: Row(
        children: [
          // Circular progress with glow
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.purple.withValues(alpha: 0.3),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 68,
                  height: 68,
                  child: CircularProgressIndicator(
                    value: progressValue,
                    strokeWidth: 7,
                    strokeCap: StrokeCap.round,
                    backgroundColor: isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : AppColors.purple.withValues(alpha: 0.12),
                    color: AppColors.purple,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$_completedCount',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: AppColors.purple,
                      ),
                    ),
                    Text(
                      '/${_modules.length}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textTertiary(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      s.tr('Your Progress', 'تقدّمك'),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    const Spacer(),
                    // Level badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.purple, AppColors.purpleLight],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.purple.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        s.tr('Level $_level', 'المستوى $_level'),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // Linear progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progressValue,
                    minHeight: 6,
                    backgroundColor: isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : AppColors.purple.withValues(alpha: 0.1),
                    color: AppColors.purple,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      s.tr('$_completedCount of ${_modules.length} modules completed', 'اكتملت $_completedCount من ${_modules.length} وحدات'),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary(context),
                          ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.accentLight.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, size: 14, color: AppColors.accentLight),
                          const SizedBox(width: 3),
                          Text(
                            '$_totalScore',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 12,
                              color: AppColors.accentLight,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  SHIMMER LOADING ITEM
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildShimmerItem(BuildContext context, bool isDark, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline column placeholder
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : AppColors.purple.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GlassCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.06)
                          : const Color(0xFFEDE9FE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 80,
                          height: 10,
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.06)
                                : const Color(0xFFEDE9FE),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 140,
                          height: 12,
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.04)
                                : const Color(0xFFF3F0FF),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: 100,
                          height: 10,
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.03)
                                : const Color(0xFFF5F3FF),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    )
        .animate(onPlay: (c) => c.repeat())
        .shimmer(
          duration: 1200.ms,
          delay: (index * 100).ms,
          color: isDark
              ? Colors.white.withValues(alpha: 0.04)
              : AppColors.purple.withValues(alpha: 0.06),
        );
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  MODULE ITEM with Timeline
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildModuleItem(
    BuildContext context,
    _GovModule module,
    bool isCompleted,
    bool isCurrent,
    bool isLocked,
    int index,
    bool isDark,
  ) {
    final isLast = index == _modules.length - 1;

    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Timeline column ──
            SizedBox(
              width: 40,
              child: Column(
                children: [
                  // Numbered badge
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: isCompleted
                          ? const LinearGradient(
                              colors: [AppColors.secondary, AppColors.secondaryLight],
                            )
                          : isCurrent
                              ? const LinearGradient(
                                  colors: [AppColors.purple, AppColors.purpleLight],
                                )
                              : null,
                      color: (!isCompleted && !isCurrent)
                          ? (isDark
                              ? Colors.white.withValues(alpha: 0.08)
                              : const Color(0xFFE2E0EA))
                          : null,
                      boxShadow: isCurrent
                          ? [
                              BoxShadow(
                                color: AppColors.purple.withValues(alpha: 0.4),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ]
                          : isCompleted
                              ? [
                                  BoxShadow(
                                    color: AppColors.secondary.withValues(alpha: 0.3),
                                    blurRadius: 6,
                                  ),
                                ]
                              : null,
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                          : Text(
                              '${module.number}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: isCurrent
                                    ? Colors.white
                                    : AppColors.textTertiary(context),
                              ),
                            ),
                    ),
                  ),
                  // Connecting line
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2.5,
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: isCompleted
                                ? [
                                    AppColors.secondaryLight.withValues(alpha: 0.5),
                                    _isModuleCompleted(module.number + 1)
                                        ? AppColors.secondaryLight.withValues(alpha: 0.5)
                                        : AppColors.purple.withValues(alpha: 0.3),
                                  ]
                                : [
                                    AppColors.purple.withValues(alpha: isCurrent ? 0.3 : 0.1),
                                    AppColors.purple.withValues(alpha: 0.1),
                                  ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // ── Card content ──
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: isCurrent
                    ? AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          final glowOpacity = 0.15 + (_pulseController.value * 0.2);
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.purple.withValues(alpha: glowOpacity),
                                  blurRadius: 12,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: child,
                          );
                        },
                        child: _buildModuleCard(
                          context, module, isCompleted, isCurrent, isLocked, isDark,
                        ),
                      )
                    : _buildModuleCard(
                        context, module, isCompleted, isCurrent, isLocked, isDark,
                      ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (300 + 80 * index).ms).slideX(begin: 0.05);
  }

  Widget _buildModuleCard(
    BuildContext context,
    _GovModule module,
    bool isCompleted,
    bool isCurrent,
    bool isLocked,
    bool isDark,
  ) {
    final s = ref.watch(stringsProvider);
    return GlassCard(
      onTap: !isLocked
          ? () {
              HapticFeedback.lightImpact();
              context.push(module.route ?? '/gov-education/module/${module.number}');
            }
          : null,
      borderColor: isCurrent
          ? AppColors.purple.withValues(alpha: 0.6)
          : isCompleted
              ? AppColors.secondaryLight.withValues(alpha: 0.3)
              : null,
      gradient: isCurrent
          ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      AppColors.purple.withValues(alpha: 0.15),
                      AppColors.purple.withValues(alpha: 0.05),
                    ]
                  : [
                      AppColors.purpleSurface,
                      Colors.white.withValues(alpha: 0.9),
                    ],
            )
          : null,
      padding: const EdgeInsets.all(16),
      child: Opacity(
        opacity: isLocked ? 0.5 : 1.0,
        child: Row(
          children: [
            // Icon with checkmark overlay for completed
            Stack(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppColors.secondary.withValues(alpha: 0.15)
                        : isCurrent
                            ? AppColors.purple.withValues(alpha: 0.15)
                            : AppColors.cardColor(context),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    module.icon,
                    color: isCompleted
                        ? AppColors.secondaryLight
                        : isCurrent
                            ? AppColors.purpleLight
                            : AppColors.textTertiary(context),
                    size: 22,
                  ),
                ),
                if (isCompleted)
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: AppColors.secondaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 10,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.tr('Module ${module.number}', 'الوحدة ${module.number}'),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isCompleted
                              ? AppColors.secondaryLight
                              : isCurrent
                                  ? AppColors.purpleLight
                                  : AppColors.textTertiary(context),
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    module.title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    module.subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textTertiary(context),
                          fontSize: 12,
                        ),
                  ),
                ],
              ),
            ),
            if (isCompleted)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  s.tr('Done', 'مكتمل'),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondaryLight,
                  ),
                ),
              )
            else if (isCurrent)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.purple, AppColors.purpleLight],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.purple.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  s.tr('Start', 'ابدأ'),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              )
            else
              Icon(Icons.lock_outline, color: AppColors.textTertiary(context), size: 20),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  LEADERBOARD BOTTOM SHEET
  // ─────────────────────────────────────────────────────────────────────────
  void _showLeaderboard(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.textTertiary(context).withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Title row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.accent, AppColors.accentLight],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.leaderboard_rounded, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                Text(
                  s.tr('Leaderboard', 'لوحة المتصدّرين'),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_leaderboard.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(Icons.emoji_events_outlined,
                          size: 40, color: AppColors.textTertiary(context)),
                      const SizedBox(height: 8),
                      Text(s.tr('No scores yet', 'لا توجد نتائج بعد'),
                          style: TextStyle(color: AppColors.textTertiary(context))),
                    ],
                  ),
                ),
              )
            else
              ..._leaderboard.take(10).toList().asMap().entries.map((entry) {
                final item = entry.value;
                final rank = entry.key;
                final isTop3 = rank < 3;

                // Top 3 gradient colors
                final topColors = [
                  [const Color(0xFFFFD700), const Color(0xFFFFA000)], // Gold
                  [const Color(0xFFC0C0C0), const Color(0xFF9E9E9E)], // Silver
                  [const Color(0xFFCD7F32), const Color(0xFFA0522D)], // Bronze
                ];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: isTop3
                          ? topColors[rank][0].withValues(alpha: 0.08)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: isTop3
                          ? Border.all(
                              color: topColors[rank][0].withValues(alpha: 0.2),
                            )
                          : null,
                    ),
                    child: Row(
                      children: [
                        // Rank badge
                        if (isTop3)
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: topColors[rank],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: topColors[rank][0].withValues(alpha: 0.3),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                '${rank + 1}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        else
                          SizedBox(
                            width: 30,
                            child: Center(
                              child: Text(
                                '#${rank + 1}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textTertiary(context),
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item['teamName'] as String? ?? s.tr('Team ${item['teamId']}', 'الفريق ${item['teamId']}'),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: isTop3 ? FontWeight.w700 : FontWeight.w600,
                              color: AppColors.textPrimary(context),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.accentLight.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star_rounded,
                                  size: 13, color: AppColors.accentLight),
                              const SizedBox(width: 3),
                              Text(
                                '${item['score'] ?? 0}',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.accentLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _GovModule {
  final int number;
  final String title;
  final String subtitle;
  final IconData icon;
  final String? route;

  const _GovModule(this.number, this.title, this.subtitle, this.icon, {this.route});
}
