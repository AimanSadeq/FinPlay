import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../providers/repository_providers.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/team_provider.dart';
import '../../../app/i18n/app_strings.dart';

// ---------------------------------------------------------------------------
// Data model for each education module
// ---------------------------------------------------------------------------
class _EduModule {
  final int number; // display number 1..10
  final String titleEn;
  final String titleAr;
  final String descEn;
  final String descAr;
  final IconData icon;
  final String categoryEn;
  final String categoryAr;
  final String difficulty; // beginner | intermediate | advanced
  final List<String> topicsEn;
  final List<String> topicsAr;
  final String route;
  final int govModuleNum; // facilitator unlock ID (1-12, 13=simulation)

  const _EduModule({
    required this.number,
    required this.titleEn,
    required this.titleAr,
    required this.descEn,
    required this.descAr,
    required this.icon,
    required this.categoryEn,
    required this.categoryAr,
    required this.difficulty,
    required this.topicsEn,
    required this.topicsAr,
    required this.route,
    required this.govModuleNum,
  });
}

// ---------------------------------------------------------------------------
// The 10 education modules (matching website) + simulation banner
// ---------------------------------------------------------------------------
const _modules = <_EduModule>[
  _EduModule(
    number: 1,
    titleEn: 'Financial Management Primer',
    titleAr: 'تمهيد الإدارة المالية',
    descEn:
        'The Three Pillars of Finance: Financing, Investing, Operating — covering Debt & Equity, Capital Structure, WACC, NPV & IRR, and Cash Flow Management.',
    descAr:
        'الركائز الثلاث للمالية: التمويل والاستثمار والتشغيل — الديون وحقوق الملكية، هيكل رأس المال، وإدارة التدفق النقدي.',
    icon: Icons.account_balance_rounded,
    categoryEn: 'FOUNDATION',
    categoryAr: 'الأساس',
    difficulty: 'beginner',
    topicsEn: ['Three Pillars', 'Debt & Equity', 'NPV & IRR'],
    topicsAr: ['الركائز الثلاث', 'الديون وحقوق الملكية', 'NPV و IRR'],
    route: '/gov-education/module/1',
    govModuleNum: 1,
  ),
  _EduModule(
    number: 2,
    titleEn: 'Understanding Financial Statements',
    titleAr: 'فهم القوائم المالية',
    descEn:
        'From the Accounting Cycle through Income Statement, Balance Sheet, Cash Flow Statement, and Auditing & Oversight.',
    descAr:
        'من الدورة المحاسبية عبر قائمة الدخل والميزانية العمومية وقائمة التدفقات النقدية والتدقيق.',
    icon: Icons.receipt_long_rounded,
    categoryEn: 'OUTPUTS',
    categoryAr: 'المخرجات',
    difficulty: 'intermediate',
    topicsEn: ['Income Statement', 'Balance Sheet', 'Cash Flow'],
    topicsAr: ['قائمة الدخل', 'الميزانية العمومية', 'التدفقات النقدية'],
    route: '/gov-education/module/2',
    govModuleNum: 3,
  ),
  _EduModule(
    number: 3,
    titleEn: 'Analysis of Financial Statements',
    titleAr: 'تحليل القوائم المالية',
    descEn:
        'Master horizontal, vertical, and trend analysis. Five ratio categories and DuPont Analysis.',
    descAr:
        'أتقن التحليل الأفقي والرأسي وتحليل الاتجاهات. خمس فئات من النسب وتحليل دوبونت.',
    icon: Icons.analytics_rounded,
    categoryEn: 'ANALYSIS',
    categoryAr: 'التحليل',
    difficulty: 'intermediate',
    topicsEn: ['Ratio Analysis', 'DuPont Framework', 'Trend Analysis'],
    topicsAr: ['تحليل النسب', 'إطار دوبونت', 'تحليل الاتجاهات'],
    route: '/gov-education/module/3',
    govModuleNum: 4,
  ),
  _EduModule(
    number: 4,
    titleEn: 'Break-Even Analysis',
    titleAr: 'تحليل نقطة التعادل',
    descEn:
        'Learn how to calculate the point where your business covers all costs and starts making profit.',
    descAr:
        'تعلم كيفية حساب النقطة التي يغطي فيها عملك جميع التكاليف ويبدأ في تحقيق الربح.',
    icon: Icons.show_chart_rounded,
    categoryEn: 'ANALYSIS',
    categoryAr: 'التحليل',
    difficulty: 'beginner',
    topicsEn: ['Fixed Costs', 'Variable Costs', 'Contribution Margin'],
    topicsAr: ['التكاليف الثابتة', 'التكاليف المتغيرة', 'هامش المساهمة'],
    route: '/education/break-even',
    govModuleNum: 11,
  ),
  _EduModule(
    number: 5,
    titleEn: 'Capital Budgeting & Investment',
    titleAr: 'موازنة رأس المال والاستثمار',
    descEn:
        'Master investment analysis techniques including NPV, IRR, and Payback Period for evaluating capital projects.',
    descAr:
        'أتقن تقنيات تحليل الاستثمار بما في ذلك صافي القيمة الحالية ومعدل العائد الداخلي وفترة الاسترداد.',
    icon: Icons.trending_up_rounded,
    categoryEn: 'INVESTMENT',
    categoryAr: 'الاستثمار',
    difficulty: 'intermediate',
    topicsEn: ['Time Value of Money', 'NPV', 'IRR'],
    topicsAr: ['القيمة الزمنية للمال', 'صافي القيمة الحالية', 'معدل العائد الداخلي'],
    route: '/education/capital-budgeting',
    govModuleNum: 12,
  ),
  _EduModule(
    number: 6,
    titleEn: 'Budgeting & Financial Planning',
    titleAr: 'الموازنة والتخطيط المالي',
    descEn:
        '8 budget types, 9 approaches (ZBB, rolling, flexible, MTEF), the 6-stage government process, and a 10-dimension comparison.',
    descAr:
        '8 أنواع موازنات، 9 مناهج، العملية الحكومية من 6 مراحل، ومقارنة من 10 أبعاد.',
    icon: Icons.account_balance_wallet_rounded,
    categoryEn: 'OPERATIONS',
    categoryAr: 'العمليات',
    difficulty: 'intermediate',
    topicsEn: ['8 Budget Types', '9 Approaches', 'Gov Process'],
    topicsAr: ['8 أنواع موازنات', '9 مناهج', 'العملية الحكومية'],
    route: '/gov-education/module/6',
    govModuleNum: 6,
  ),
  _EduModule(
    number: 7,
    titleEn: 'IFRS vs IPSAS Standards',
    titleAr: 'معايير IFRS مقابل IPSAS',
    descEn:
        'Compare IFRS and IPSAS: alignment in measurement, recognition, presentation, and public-sector divergences.',
    descAr:
        'قارن IFRS و IPSAS: التوافق في القياس والاعتراف والعرض واختلافات القطاع العام.',
    icon: Icons.public_rounded,
    categoryEn: 'STANDARDS',
    categoryAr: 'المعايير',
    difficulty: 'advanced',
    topicsEn: ['Similarities', 'Differences', 'Public Sector'],
    topicsAr: ['أوجه التشابه', 'الاختلافات', 'القطاع العام'],
    route: '/gov-education/module/7',
    govModuleNum: 7,
  ),
  _EduModule(
    number: 8,
    titleEn: 'Sector Finance Comparison',
    titleAr: 'مقارنة مالية القطاعات',
    descEn:
        'Compare 12 dimensions across government and private sectors: objectives, revenue, accountability, IPSAS vs IFRS, and more.',
    descAr:
        'قارن 12 بعداً عبر القطاعين الحكومي والخاص: الأهداف، الإيرادات، المساءلة وأكثر.',
    icon: Icons.compare_rounded,
    categoryEn: 'CONTEXT',
    categoryAr: 'السياق',
    difficulty: 'beginner',
    topicsEn: ['Sector Objectives', 'IPSAS vs IFRS', 'Accountability'],
    topicsAr: ['أهداف القطاعات', 'IPSAS مقابل IFRS', 'المساءلة'],
    route: '/gov-education/module/8',
    govModuleNum: 2,
  ),
  _EduModule(
    number: 9,
    titleEn: 'Compliance & Internal Controls',
    titleAr: 'الامتثال والضوابط الداخلية',
    descEn:
        'COSO framework, fraud prevention, procurement compliance, ethics, whistleblower protection, and Saudi regulations.',
    descAr:
        'إطار COSO، منع الاحتيال، امتثال المشتريات، الأخلاقيات، وحماية المبلغين واللوائح السعودية.',
    icon: Icons.security_rounded,
    categoryEn: 'CONTROLS',
    categoryAr: 'الضوابط',
    difficulty: 'intermediate',
    topicsEn: ['COSO Framework', 'Fraud Prevention', 'Saudi Regulations'],
    topicsAr: ['إطار COSO', 'منع الاحتيال', 'اللوائح السعودية'],
    route: '/gov-education/module/9',
    govModuleNum: 9,
  ),
  _EduModule(
    number: 10,
    titleEn: 'Financial Auditing & Review',
    titleAr: 'المراجعة والتدقيق المالي',
    descEn:
        '5 audit types, risk-based auditing, IT analytics, audit quality standards, and emerging trends.',
    descAr:
        '5 أنواع تدقيق، التدقيق القائم على المخاطر، تحليلات تقنية المعلومات ومعايير الجودة.',
    icon: Icons.fact_check_rounded,
    categoryEn: 'OVERSIGHT',
    categoryAr: 'الرقابة',
    difficulty: 'advanced',
    topicsEn: ['5 Audit Types', 'Risk-Based Auditing', 'IT Analytics'],
    topicsAr: ['5 أنواع تدقيق', 'التدقيق القائم على المخاطر', 'تحليلات IT'],
    route: '/gov-education/module/10',
    govModuleNum: 10,
  ),
];

// ---------------------------------------------------------------------------
// Main Screen
// ---------------------------------------------------------------------------
class EducationHubScreen extends ConsumerStatefulWidget {
  const EducationHubScreen({super.key});

  @override
  ConsumerState<EducationHubScreen> createState() => _EducationHubScreenState();
}

class _EducationHubScreenState extends ConsumerState<EducationHubScreen> {
  // Local progress tracking per module (key = "edu_progress_<govModuleNum>")
  final Map<int, int> _moduleProgress = {}; // govModuleNum -> completion %
  final Map<int, bool> _modulePassed = {};

  // Unlocked modules fetched from /gov-education/status (like web app)
  List<int> _unlockedModules = [];
  // Self-paced progressive-unlock set (govModuleNum values currently accessible).
  Set<int> _selfPacedUnlocked = {};
  // Self-paced simulation unlocks once every content module's Learn is complete.
  bool _selfPacedSimUnlocked = false;
  Timer? _statusPollTimer;

  bool get _isSelfPaced {
    final auth = ref.read(authProvider);
    return auth.user != null && !auth.isFacilitator;
  }

  @override
  void initState() {
    super.initState();
    _loadProgress();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkMandatedAssessment());
    if (_isSelfPaced) {
      // Self-paced: progressive unlock — each module opens once the previous
      // module's Learn section is complete (website parity). _loadProgress
      // computes the set; seed the first module + tools so something is open.
      _selfPacedUnlocked = {_modules.first.govModuleNum, 11, 12};
    } else {
      _fetchEducationStatus();
      _statusPollTimer = Timer.periodic(
        const Duration(seconds: 5),
        (_) => _fetchEducationStatus(),
      );
    }
  }

  bool _assessmentPromptShown = false;

  /// Mirrors the website's AssessmentPrompt: if the facilitator has mandated a
  /// pre/post assessment the learner hasn't completed, surface it. When the
  /// assessment is mandated the dialog cannot be dismissed without taking it.
  Future<void> _checkMandatedAssessment() async {
    if (_assessmentPromptShown) return;
    for (final kind in const ['pre', 'post']) {
      try {
        final res = await ref
            .read(apiClientProvider)
            .get(ApiEndpoints.assessmentStatus, params: {'kind': kind});
        final mandated = res['mandated'] == true;
        final completed = res['completed'] == true;
        if (mandated && !completed && mounted) {
          _assessmentPromptShown = true;
          final s = ref.read(stringsProvider);
          final go = await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => AlertDialog(
              title: Text(kind == 'pre'
                  ? s.tr('Pre-Course Assessment Required', 'تقييم ما قبل الدورة مطلوب')
                  : s.tr('Post-Course Assessment Required', 'تقييم ما بعد الدورة مطلوب')),
              content: Text(s.tr(
                  'Your facilitator has asked you to complete this assessment before continuing.',
                  'طلب منك الميسّر إكمال هذا التقييم قبل المتابعة.')),
              actions: [
                FilledButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: Text(s.tr('Take Assessment', 'ابدأ التقييم')),
                ),
              ],
            ),
          );
          if (go == true && mounted) context.push('/assessment/$kind');
          return;
        }
      } catch (_) {
        // Status unavailable — no prompt.
      }
    }
  }

  @override
  void dispose() {
    _statusPollTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchEducationStatus() async {
    try {
      final api = ref.read(apiClientProvider);
      final res = await api.get(ApiEndpoints.govEducationStatus);
      final modules = (res['govEducationModulesUnlocked'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ?? [];
      if (mounted) setState(() => _unlockedModules = modules);
    } catch (_) {
      // Keep existing state on error
    }
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final updated = <int, int>{};
    final passed = <int, bool>{};
    for (final m in _modules) {
      updated[m.govModuleNum] =
          prefs.getInt('edu_progress_${m.govModuleNum}') ?? 0;
      passed[m.govModuleNum] =
          prefs.getBool('edu_passed_${m.govModuleNum}') ?? false;
    }
    // Recompute self-paced progressive unlocks from per-module Learn completion.
    final unlocked = <int>{};
    if (_isSelfPaced) {
      bool gateOpen = true; // the next content module is unlocked while open
      for (final m in _modules) {
        final isTool = m.govModuleNum == 11 || m.govModuleNum == 12; // calculators, no Learn
        if (gateOpen || isTool) unlocked.add(m.govModuleNum);
        if (!isTool) {
          // Self-paced learners use the 'sp' progress scope (see gov_module_screen).
          final learnDone = prefs.getBool('gov_module_sp_${m.govModuleNum}_learn') ?? false;
          gateOpen = gateOpen && learnDone; // close the chain until this Learn is done
        }
      }
    }
    if (mounted) {
      setState(() {
        _moduleProgress.addAll(updated);
        _modulePassed.addAll(passed);
        if (_isSelfPaced) {
          _selfPacedUnlocked = unlocked;
          // gateOpen is still true only if every content module's Learn is done.
          _selfPacedSimUnlocked = _selfPacedSimGate(prefs);
        }
      });
    }
  }

  bool _selfPacedSimGate(SharedPreferences prefs) {
    for (final m in _modules) {
      final isTool = m.govModuleNum == 11 || m.govModuleNum == 12;
      if (isTool) continue;
      if (!(prefs.getBool('gov_module_sp_${m.govModuleNum}_learn') ?? false)) return false;
    }
    return true;
  }

  int get _completedCount =>
      _modulePassed.values.where((v) => v).length;

  int get _overallPercent {
    if (_moduleProgress.isEmpty) return 0;
    final total = _moduleProgress.values.fold<int>(0, (a, b) => a + b);
    return (total / _modules.length).round();
  }

  int get _badgeCount => _completedCount; // 1 badge per completed module

  // Whether a module is unlocked (facilitator list, or progressive for self-paced)
  bool _isUnlocked(int govModuleNum, List<int> unlocked) {
    final auth = ref.read(authProvider);
    if (auth.user != null && !auth.isFacilitator) {
      return _selfPacedUnlocked.contains(govModuleNum);
    }
    return unlocked.contains(govModuleNum);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final auth = ref.watch(authProvider);
    final teamState = ref.watch(teamProvider);

    final unlockedModules = _unlockedModules;

    final isSelfPaced =
        auth.user != null && !auth.isFacilitator && teamState.selectedTeam == null;
    final teamName = isSelfPaced
        ? (auth.user?.displayName ?? ref.watch(stringsProvider).tr('Self-Paced', 'التعلّم الذاتي'))
        : (teamState.selectedTeam?.name ?? '');

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [AppColors.darkBg, AppColors.darkSurface]
                : [const Color(0xFFF0F4FF), const Color(0xFFF5F0FF), Colors.white],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Header ──
              SliverToBoxAdapter(
                child: _buildHeader(context, isSelfPaced, unlockedModules),
              ),

              // ── Progress Section ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: _buildProgressCard(
                    context,
                    teamName: teamName,
                    unlockedModules: unlockedModules,
                  ),
                ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
              ),

              // ── Module Cards Grid ──
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.58,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final m = _modules[index];
                      final isLocked = !_isUnlocked(m.govModuleNum, unlockedModules);
                      final completion = _moduleProgress[m.govModuleNum] ?? 0;
                      final passed = _modulePassed[m.govModuleNum] ?? false;
                      return _ModuleCard(
                        module: m,
                        isLocked: isLocked,
                        completionPercent: completion,
                        isPassed: passed,
                        ar: ref.watch(stringsProvider).ar,
                        // Refresh progressive unlocks when returning from a module.
                        onTap: () => context.push(m.route).then((_) {
                          if (mounted) _loadProgress();
                        }),
                      ).animate().fadeIn(
                            delay: (300 + 60 * index).ms,
                            duration: 350.ms,
                          );
                    },
                    childCount: _modules.length,
                  ),
                ),
              ),

              // ── Simulation Banner ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                  child: _buildSimulationBanner(
                    context,
                    isUnlocked: isSelfPaced
                        ? _selfPacedSimUnlocked
                        : unlockedModules.contains(13),
                  ),
                ).animate().fadeIn(delay: 800.ms, duration: 400.ms),
              ),

              // ── Glossary & Excel buttons ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: _buildExtraButtons(context),
                ).animate().fadeIn(delay: 900.ms, duration: 400.ms),
              ),

              // ── Advanced Finance Tools ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                  child: _buildAdvancedTools(context),
                ).animate().fadeIn(delay: 950.ms, duration: 400.ms),
              ),

              // ── Assessment & Research ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: _buildAssessmentResearch(context),
                ).animate().fadeIn(delay: 980.ms, duration: 400.ms),
              ),

              // ── Learning Path ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
                  child: _buildLearningPath(context),
                ).animate().fadeIn(delay: 1000.ms, duration: 400.ms),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Header — redesigned for corporate mode (no admin btn)
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildHeader(
    BuildContext context,
    bool isSelfPaced,
    List<int> unlockedModules,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final s = ref.watch(stringsProvider);
    final teamState = ref.watch(teamProvider);
    final team = teamState.selectedTeam;
    final teamColor = team != null
        ? (Color(int.parse('FF${(team.color ?? '#3B82F6').replaceFirst('#', '')}', radix: 16)))
        : AppColors.primaryLight;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      padding: const EdgeInsets.fromLTRB(4, 6, 8, 6),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurface.withValues(alpha: 0.8)
            : Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppColors.darkBorder.withValues(alpha: 0.2)
              : teamColor.withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: teamColor.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, size: 20),
            onPressed: () => context.pop(),
            visualDensity: VisualDensity.compact,
          ),

          // Title area
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        teamColor.withValues(alpha: 0.15),
                        teamColor.withValues(alpha: 0.08),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.school_rounded,
                      color: teamColor, size: 16),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      children: [
                        TextSpan(
                          text: 'Fin',
                          style: TextStyle(color: const Color(0xFF5793D6)),
                        ),
                        TextSpan(
                          text: 'Play',
                          style: TextStyle(color: const Color(0xFF243C76)),
                        ),
                        TextSpan(
                          text: s.tr(' Education', ' للتعليم'),
                          style: TextStyle(
                            color: AppColors.textPrimary(context),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Nav — Home + Simulation only (no admin)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _NavPill(
                icon: Icons.home_rounded,
                label: s.tr('Home', 'الرئيسية'),
                color: AppColors.primaryLight,
                // Self-paced learners go back to their progress landing, not the
                // corporate home (parity with where login dropped them).
                onTap: () => context.go(isSelfPaced ? '/self-paced-progress' : '/home'),
              ),
              const SizedBox(width: 6),
              _NavPill(
                icon: unlockedModules.contains(13)
                    ? Icons.play_arrow_rounded
                    : Icons.lock_rounded,
                label: s.tr('Sim', 'المحاكاة'),
                color: unlockedModules.contains(13)
                    ? AppColors.secondaryLight
                    : AppColors.lightTextTertiary,
                onTap: unlockedModules.contains(13)
                    ? () => context.push('/simulation')
                    : null,
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.1);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Progress Card
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildProgressCard(
    BuildContext context, {
    required String teamName,
    required List<int> unlockedModules,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final s = ref.watch(stringsProvider);
    final team = ref.watch(teamProvider).selectedTeam;
    final teamColor = team != null
        ? Color(int.parse('FF${(team.color ?? '#3B82F6').replaceFirst('#', '')}', radix: 16))
        : AppColors.primaryLight;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [AppColors.darkSurface, AppColors.darkCard]
              : [
                  teamColor.withValues(alpha: 0.06),
                  const Color(0xFFEEF2FF),
                  const Color(0xFFF5F0FF),
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppColors.darkBorder.withValues(alpha: 0.3)
              : teamColor.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: teamColor.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top row: Team + Title + Stats
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
            child: Column(
              children: [
                // Team badge + progress title
                Row(
                  children: [
                    // Team color dot + name
                    if (teamName.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: teamColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: teamColor.withValues(alpha: 0.25)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: teamColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              teamName,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: teamColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.school_rounded,
                          color: AppColors.primaryLight, size: 18),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        s.tr('Your Progress', 'تقدّمك'),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : const Color(0xFF1E3A8A),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Stats row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ProgressStat(
                      value: '$_completedCount',
                      sub: '/10',
                      label: s.tr('Complete', 'مكتمل'),
                      color: AppColors.primaryLight,
                    ),
                    _VerticalDivider(),
                    _ProgressStat(
                      value: '$_badgeCount',
                      label: s.tr('Badges', 'الأوسمة'),
                      color: AppColors.accentLight,
                      icon: Icons.emoji_events_rounded,
                    ),
                    _VerticalDivider(),
                    _ProgressStat(
                      value: '$_overallPercent%',
                      label: s.tr('Overall', 'الإجمالي'),
                      color: const Color(0xFF6366F1),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Module progress grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.tr('MODULE PROGRESS', 'تقدّم الوحدات'),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    color: AppColors.textTertiary(context),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(_modules.length, (i) {
                    final m = _modules[i];
                    final isUnlocked =
                        _isUnlocked(m.govModuleNum, unlockedModules);
                    final completion =
                        _moduleProgress[m.govModuleNum] ?? 0;
                    final passed = _modulePassed[m.govModuleNum] ?? false;

                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: i < _modules.length - 1 ? 4 : 0,
                        ),
                        child: Column(
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: !isUnlocked
                                      ? (isDark
                                          ? AppColors.darkCard
                                          : const Color(0xFFF1F5F9))
                                      : passed
                                          ? AppColors.secondaryLight
                                          : completion > 0
                                              ? const Color(0xFFFEF3C7)
                                              : (isDark
                                                  ? AppColors.darkSurface
                                                  : Colors.white),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: !isUnlocked
                                        ? (isDark
                                            ? AppColors.darkBorder
                                                .withValues(alpha: 0.3)
                                            : const Color(0xFFE2E8F0))
                                        : passed
                                            ? AppColors.secondaryLight
                                            : completion > 0
                                                ? const Color(0xFFFCD34D)
                                                : (isDark
                                                    ? AppColors.darkBorder
                                                        .withValues(alpha: 0.3)
                                                    : const Color(0xFFE2E8F0)),
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: passed
                                      ? const Icon(Icons.check_rounded,
                                          color: Colors.white, size: 16)
                                      : !isUnlocked
                                          ? Icon(Icons.lock_rounded,
                                              size: 12,
                                              color: AppColors.textTertiary(
                                                  context))
                                          : Text(
                                              '${i + 1}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: completion > 0
                                                    ? const Color(0xFFB45309)
                                                    : AppColors.textSecondary(
                                                        context),
                                              ),
                                            ),
                                ),
                              ),
                            ),
                            if (completion > 0 &&
                                completion < 100 &&
                                isUnlocked) ...[
                              const SizedBox(height: 3),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(2),
                                child: SizedBox(
                                  height: 3,
                                  child: LinearProgressIndicator(
                                    value: completion / 100,
                                    backgroundColor: isDark
                                        ? AppColors.darkCard
                                        : const Color(0xFFE2E8F0),
                                    color: const Color(0xFFF59E0B),
                                  ),
                                ),
                              ),
                            ] else
                              const SizedBox(height: 6),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          // Legend
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _LegendDot(
                    color: AppColors.secondaryLight, label: s.tr('Complete', 'مكتمل')),
                const SizedBox(width: 16),
                _LegendDot(
                    color: const Color(0xFFFEF3C7),
                    borderColor: const Color(0xFFFCD34D),
                    label: s.tr('In Progress', 'قيد التقدّم')),
                const SizedBox(width: 16),
                _LegendDot(
                    color: const Color(0xFFF1F5F9),
                    borderColor: const Color(0xFFE2E8F0),
                    label: s.tr('Locked', 'مقفل')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Simulation Banner
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildSimulationBanner(BuildContext context,
      {required bool isUnlocked}) {
    final s = ref.watch(stringsProvider);
    return GestureDetector(
      onTap: isUnlocked
          ? () {
              HapticFeedback.lightImpact();
              context.push('/simulation');
            }
          : null,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isUnlocked
                ? [const Color(0xFF2563EB), const Color(0xFF4338CA)]
                : [const Color(0xFF9CA3AF), const Color(0xFF6B7280)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: (isUnlocked
                      ? const Color(0xFF2563EB)
                      : const Color(0xFF9CA3AF))
                  .withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                isUnlocked ? Icons.play_arrow_rounded : Icons.lock_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.tr('Finance Simulation Game', 'لعبة المحاكاة المالية'),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    s.tr('Apply what you learned across 3 rounds of strategic decisions',
                        'طبّق ما تعلّمته عبر 3 جولات من القرارات الاستراتيجية'),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _SimBadge(s.tr('Financing', 'التمويل')),
                      _SimBadge(s.tr('Investing', 'الاستثمار')),
                      _SimBadge(s.tr('Operating', 'التشغيل')),
                    ],
                  ),
                ],
              ),
            ),
            if (isUnlocked)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  s.tr('Enter', 'ادخل'),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2563EB),
                  ),
                ),
              )
            else
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_rounded,
                      size: 14,
                      color: Colors.white.withValues(alpha: 0.7)),
                  const SizedBox(width: 4),
                  Text(
                    s.tr('Locked', 'مقفل'),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Glossary & Excel buttons
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildExtraButtons(BuildContext context) {
    final s = ref.watch(stringsProvider);
    return Row(
      children: [
        Expanded(
          child: _ExtraButton(
            icon: Icons.menu_book_rounded,
            label: s.tr('Financial Glossary', 'القاموس المالي'),
            sublabel: s.tr('180+ terms', 'أكثر من 180 مصطلحًا'),
            color: AppColors.accentLight,
            onTap: () => context.push('/education/glossary'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ExtraButton(
            icon: Icons.table_chart_rounded,
            label: s.tr('Excel Data', 'بيانات إكسل'),
            sublabel: s.tr('IFRS Statements', 'قوائم IFRS'),
            color: AppColors.dangerLight,
            onTap: () => context.push('/education/excel'),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Advanced Finance Tools
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildAdvancedTools(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final tools = <({IconData icon, String label, Color color, String route})>[
      (icon: Icons.percent_rounded, label: s.tr('WACC', 'تكلفة رأس المال'), color: AppColors.primaryLight, route: '/education/wacc'),
      (icon: Icons.analytics_rounded, label: s.tr('DuPont', 'دوبونت'), color: AppColors.secondaryLight, route: '/education/dupont'),
      (icon: Icons.timelapse_rounded, label: s.tr('Working Capital', 'رأس المال العامل'), color: AppColors.accentLight, route: '/education/working-capital'),
      (icon: Icons.workspace_premium_rounded, label: s.tr('Credit Rating', 'التصنيف الائتماني'), color: AppColors.info, route: '/education/credit-rating'),
      (icon: Icons.gavel_rounded, label: s.tr('Covenants', 'التعهدات'), color: AppColors.dangerLight, route: '/education/covenants'),
      (icon: Icons.pie_chart_rounded, label: s.tr('Cap Table', 'جدول الملكية'), color: AppColors.purple, route: '/education/cap-table'),
      (icon: Icons.payments_rounded, label: s.tr('Dividends', 'التوزيعات'), color: AppColors.warning, route: '/education/dividends'),
      (icon: Icons.bar_chart_rounded, label: s.tr('Ratios', 'النسب'), color: AppColors.primaryDark, route: '/education/ratios'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              s.tr('Advanced Finance Tools', 'أدوات مالية متقدمة'),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary(context),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.purple.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(s.tr('OPTIONAL', 'اختياري'),
                  style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: AppColors.purple)),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          s.tr('Interactive calculators for the realism modules',
              'حاسبات تفاعلية لوحدات الواقعية'),
          style: TextStyle(fontSize: 11, color: AppColors.textTertiary(context)),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.82,
          children: tools
              .map((t) => _ToolTile(
                    icon: t.icon,
                    label: t.label,
                    color: t.color,
                    onTap: () => context.push(t.route),
                  ))
              .toList(),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Assessment & Research
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildAssessmentResearch(BuildContext context) {
    final s = ref.watch(stringsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          s.tr('Assessment & Research', 'التقييم والبحث'),
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary(context),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ExtraButton(
                icon: Icons.quiz_rounded,
                label: s.tr('Pre-Course Test', 'اختبار ما قبل الدورة'),
                sublabel: s.tr('Baseline check', 'فحص الأساس'),
                color: AppColors.primaryLight,
                onTap: () => context.push('/assessment/pre'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ExtraButton(
                icon: Icons.fact_check_rounded,
                label: s.tr('Post-Course Test', 'اختبار ما بعد الدورة'),
                sublabel: s.tr('Measure progress', 'قياس التقدّم'),
                color: AppColors.secondaryLight,
                onTap: () => context.push('/assessment/post'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _ExtraButton(
          icon: Icons.science_rounded,
          label: s.tr('Research Participation', 'المشاركة في البحث'),
          sublabel: s.tr('Consent & questionnaires (voluntary)',
              'الموافقة والاستبيانات (اختياري)'),
          color: AppColors.purple,
          onTap: () => context.push('/research'),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Learning Path
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildLearningPath(BuildContext context) {
    final s = ref.watch(stringsProvider);
    return Column(
      children: [
        Text(
          s.tr('Suggested Learning Path', 'مسار التعلّم المقترح'),
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary(context),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          s.tr('Start with foundational modules then progress to advanced topics',
              'ابدأ بالوحدات الأساسية ثم تقدّم إلى المواضيع المتقدمة'),
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textTertiary(context),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _PathBadge(s.tr('Foundations (1-3)', 'الأساسيات (1-3)'), AppColors.secondaryLight,
                AppColors.secondarySurface),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Icon(Icons.arrow_forward_rounded,
                  size: 14, color: AppColors.textTertiary(context)),
            ),
            _PathBadge(s.tr('Analysis (4-6)', 'التحليل (4-6)'), AppColors.primaryLight,
                AppColors.primarySurface),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Icon(Icons.arrow_forward_rounded,
                  size: 14, color: AppColors.textTertiary(context)),
            ),
            _PathBadge(s.tr('Advanced (7-10)', 'المتقدّم (7-10)'), const Color(0xFF7C3AED),
                const Color(0xFFEDE9FE)),
          ],
        ),
      ],
    );
  }
}

// ===========================================================================
// Sub-widgets
// ===========================================================================

// ---------------------------------------------------------------------------
// Module Card (matches website design)
// ---------------------------------------------------------------------------
class _ModuleCard extends StatefulWidget {
  final _EduModule module;
  final bool isLocked;
  final int completionPercent;
  final bool isPassed;
  final bool ar;
  final VoidCallback? onTap;

  const _ModuleCard({
    required this.module,
    required this.isLocked,
    required this.completionPercent,
    required this.isPassed,
    required this.ar,
    this.onTap,
  });

  @override
  State<_ModuleCard> createState() => _ModuleCardState();
}

class _ModuleCardState extends State<_ModuleCard> {
  bool _pressed = false;

  Color get _diffColor {
    switch (widget.module.difficulty) {
      case 'beginner':
        return const Color(0xFF16A34A); // green-600
      case 'intermediate':
        return const Color(0xFF1E40AF); // blue-800 (matches website)
      case 'advanced':
        return const Color(0xFF6B21A8); // purple-800 (matches website)
      default:
        return const Color(0xFF1E40AF);
    }
  }

  Color get _diffBg {
    switch (widget.module.difficulty) {
      case 'beginner':
        return const Color(0xFFDCFCE7); // green-100
      case 'intermediate':
        return const Color(0xFFDBEAFE); // blue-100 (matches website)
      case 'advanced':
        return const Color(0xFFF3E8FF); // purple-100 (matches website)
      default:
        return const Color(0xFFDBEAFE);
    }
  }

  String get _diffLabel {
    final ar = widget.ar;
    switch (widget.module.difficulty) {
      case 'beginner':
        return ar ? 'مبتدئ' : 'Beginner';
      case 'intermediate':
        return ar ? 'متوسط' : 'Intermediate';
      case 'advanced':
        return ar ? 'متقدّم' : 'Advanced';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final m = widget.module;
    final progressFraction = widget.completionPercent / 100.0;

    return GestureDetector(
      onTapDown: widget.isLocked ? null : (_) => setState(() => _pressed = true),
      onTapUp: widget.isLocked
          ? null
          : (_) {
              setState(() => _pressed = false);
              HapticFeedback.lightImpact();
              if (widget.onTap != null) {
                widget.onTap!();
              } else {
                context.push(m.route);
              }
            },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _pressed
                  ? _diffColor.withValues(alpha: 0.5)
                  : (isDark
                      ? AppColors.darkBorder.withValues(alpha: 0.3)
                      : const Color(0xFFE2E8F0)),
              width: _pressed ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _pressed
                    ? _diffColor.withValues(alpha: 0.12)
                    : Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
                blurRadius: _pressed ? 12 : 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Card content
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category tag + Difficulty badge row
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.accentSurface,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            widget.ar ? m.categoryAr : m.categoryEn,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                              color: AppColors.accentDark,
                            ),
                          ),
                        ),
                        const Spacer(),
                        // Difficulty badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: _diffBg,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: _diffColor.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            _diffLabel,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: _diffColor,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Icon row
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: widget.isPassed
                                ? AppColors.secondarySurface
                                : AppColors.primarySurface,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            m.icon,
                            size: 22,
                            color: widget.isPassed
                                ? AppColors.secondaryLight
                                : AppColors.primaryLight,
                          ),
                        ),
                        const Spacer(),
                        // Module number badge with completion checkmark
                        SizedBox(
                          width: 32,
                          height: 32,
                          child: Stack(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: widget.isPassed
                                      ? AppColors.secondaryLight
                                      : AppColors.primaryLight,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: (widget.isPassed
                                              ? AppColors.secondaryLight
                                              : AppColors.primaryLight)
                                          .withValues(alpha: 0.3),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    '${m.number}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              // Green checkmark overlay when passed
                              if (widget.isPassed)
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF16A34A),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isDark
                                            ? AppColors.darkSurface
                                            : Colors.white,
                                        width: 1.5,
                                      ),
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
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Title
                    Text(
                      widget.ar ? m.titleAr : m.titleEn,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary(context),
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // Description
                    Text(
                      widget.ar ? m.descAr : m.descEn,
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.3,
                        color: AppColors.textSecondary(context),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 6),

                    // Topics preview — outline badges (matches website)
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: (widget.ar ? m.topicsAr : m.topicsEn).take(3).map(
                        (t) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.darkBorder.withValues(alpha: 0.4)
                                  : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Text(
                            t,
                            style: TextStyle(
                              fontSize: 9,
                              color: AppColors.textTertiary(context),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ).toList(),
                    ),

                    const Spacer(),

                    // Progress bar — always visible as track
                    Row(
                      children: [
                        Text(
                          widget.completionPercent > 0
                              ? (widget.ar ? 'التقدّم' : 'Progress')
                              : (widget.ar ? 'لم يبدأ' : 'Not started'),
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.textTertiary(context),
                          ),
                        ),
                        const Spacer(),
                        if (widget.completionPercent > 0)
                          Text(
                            '${widget.completionPercent}%',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: widget.isPassed
                                  ? const Color(0xFF16A34A)
                                  : AppColors.primaryLight,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: SizedBox(
                        height: 4,
                        child: LinearProgressIndicator(
                          value: progressFraction,
                          backgroundColor: isDark
                              ? AppColors.darkCard
                              : const Color(0xFFE2E8F0),
                          color: widget.isPassed
                              ? const Color(0xFF16A34A) // green when passed
                              : progressFraction > 0
                                  ? const Color(0xFF2563EB) // blue when in-progress (matches website)
                                  : Colors.transparent,
                        ),
                      ),
                    ),

                    // Locked text
                    if (widget.isLocked) ...[
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lock_rounded,
                              size: 11,
                              color: AppColors.textTertiary(context)),
                          const SizedBox(width: 4),
                          Text(
                            widget.ar ? 'مقفل من قبل الميسّر' : 'Locked by facilitator',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textTertiary(context),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Semi-transparent dark lock overlay
              if (widget.isLocked)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: (isDark
                              ? Colors.black
                              : const Color(0xFF1E293B))
                          .withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkCard
                              : Colors.white.withValues(alpha: 0.92),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Icon(Icons.lock_rounded,
                            size: 22,
                            color: AppColors.textTertiary(context)),
                      ),
                    ),
                  ),
                ),

              // Bottom progress bar — thin colored strip at very bottom
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  child: SizedBox(
                    height: 4,
                    child: LinearProgressIndicator(
                      value: progressFraction,
                      backgroundColor: Colors.transparent,
                      color: widget.isPassed
                          ? const Color(0xFF16A34A) // green when passed
                          : progressFraction > 0
                              ? const Color(0xFF2563EB) // blue when in-progress
                              : Colors.transparent,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Small helper widgets
// ---------------------------------------------------------------------------

class _NavPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _NavPill({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        opacity: onTap != null ? 1.0 : 0.45,
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isDark
                ? color.withValues(alpha: 0.15)
                : color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressStat extends StatelessWidget {
  final String value;
  final String? sub;
  final String label;
  final Color color;
  final IconData? icon;

  const _ProgressStat({
    required this.value,
    this.sub,
    required this.label,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              if (sub != null)
                Text(
                  sub!,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textTertiary(context),
                  ),
                ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 10, color: AppColors.textTertiary(context)),
                const SizedBox(width: 2),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
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

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 28,
      color: const Color(0xFFBFDBFE),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final Color? borderColor;
  final String label;

  const _LegendDot({
    required this.color,
    this.borderColor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
            border: borderColor != null
                ? Border.all(color: borderColor!, width: 1)
                : null,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: AppColors.textTertiary(context),
          ),
        ),
      ],
    );
  }
}

class _SimBadge extends StatelessWidget {
  final String label;
  const _SimBadge(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _ExtraButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final Color color;
  final VoidCallback onTap;

  const _ExtraButton({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark
                ? AppColors.darkBorder.withValues(alpha: 0.3)
                : color.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.1 : 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  Text(
                    sublabel,
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.textTertiary(context),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: AppColors.textTertiary(context)),
          ],
        ),
      ),
    );
  }
}

class _ToolTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ToolTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark
                ? AppColors.darkBorder.withValues(alpha: 0.3)
                : color.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9.5,
                height: 1.15,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PathBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color bg;

  const _PathBadge(this.label, this.color, this.bg);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
