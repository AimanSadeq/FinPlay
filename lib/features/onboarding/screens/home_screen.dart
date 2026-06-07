import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/i18n/app_strings.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../providers/repository_providers.dart';
import '../../../providers/team_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../core/services/cache_service.dart';
import '../../../shared/widgets/team_leader_gate.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _bgController;
  String? _clientName;
  String? _appTitle;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      duration: const Duration(seconds: 14),
      vsync: this,
    )..repeat(reverse: true);

    // Check reset epoch to detect game resets
    _checkResetEpoch();
    // Fetch client name + dynamic app title
    _fetchClientName();
    _fetchAppTitle();
  }

  Future<void> _fetchClientName() async {
    try {
      final api = ref.read(apiClientProvider);
      final response = await api.get('/client-name');
      final name = response['clientName']?.toString() ?? response['name']?.toString();
      if (name != null && name.isNotEmpty && mounted) {
        setState(() => _clientName = name);
      }
    } catch (_) {
      // Non-critical — leave null
    }
  }

  /// Dynamic course title from the Excel control sheet (EN B6 / AR B7), matching
  /// the website's /api/app-title.
  Future<void> _fetchAppTitle() async {
    try {
      final api = ref.read(apiClientProvider);
      final res = await api.get('/app-title');
      final isAr = ref.read(stringsProvider).ar;
      final title = (isAr
              ? (res['titleAr'] ?? res['ar'] ?? res['title'])
              : (res['title'] ?? res['en'] ?? res['titleEn']))
          ?.toString();
      if (title != null && title.isNotEmpty && mounted) {
        setState(() => _appTitle = title);
      }
    } catch (_) {
      // Non-critical — fall back to client name / static title
    }
  }

  void _showAdminDialog() {
    final s = ref.read(stringsProvider);
    final passwordController = TextEditingController();
    String? errorText;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.admin_panel_settings_rounded,
                      color: Colors.red.shade600, size: 24),
                  const SizedBox(width: 8),
                  Text(s.tr('Admin Access', 'دخول المسؤول')),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: s.tr('Password', 'كلمة المرور'),
                      errorText: errorText,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock_rounded),
                    ),
                    onSubmitted: (_) async {
                      final password = passwordController.text.trim();
                      if (password.isEmpty) return;
                      try {
                        final success = await ref
                            .read(authProvider.notifier)
                            .loginFacilitator(password);
                        if (success && context.mounted) {
                          Navigator.of(dialogContext).pop();
                          context.go('/facilitator');
                        } else {
                          setDialogState(() => errorText = s.tr('Invalid password', 'كلمة مرور غير صحيحة'));
                        }
                      } catch (_) {
                        setDialogState(
                            () => errorText = s.tr('Authentication failed', 'فشل التحقق من الهوية'));
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(s.tr('Cancel', 'إلغاء')),
                ),
                FilledButton(
                  onPressed: () async {
                    final password = passwordController.text.trim();
                    if (password.isEmpty) return;
                    try {
                      final success = await ref
                          .read(authProvider.notifier)
                          .loginFacilitator(password);
                      if (success && context.mounted) {
                        Navigator.of(dialogContext).pop();
                        context.go('/facilitator');
                      } else {
                        setDialogState(() => errorText = 'Invalid password');
                      }
                    } catch (_) {
                      setDialogState(
                          () => errorText = 'Authentication failed');
                    }
                  },
                  child: Text(s.tr('Login', 'تسجيل الدخول')),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Checks if the game was reset since the team signed in.
  /// If epoch changed, clear all cached data and stale sessions.
  Future<void> _checkResetEpoch() async {
    try {
      final api = ref.read(apiClientProvider);
      final response = await api.get(ApiEndpoints.facilitatorResetEpoch);
      final serverEpoch = response['epoch']?.toString() ?? response['resetEpoch']?.toString();
      if (serverEpoch == null) return;

      final prefs = await SharedPreferences.getInstance();
      final localEpoch = prefs.getString('reset_epoch');

      if (localEpoch != null && localEpoch != serverEpoch) {
        // Game was reset — clear all cached data
        await CacheService().clearAll();
        await prefs.clear();
        await prefs.setString('reset_epoch', serverEpoch);

        // Deselect team
        ref.read(teamProvider.notifier).clearTeam();

        if (mounted) {
          final s = ref.read(stringsProvider);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(s.tr('Game was reset. Session cleared.', 'تمت إعادة ضبط اللعبة. تم مسح الجلسة.')),
              backgroundColor: AppColors.accent,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
          context.go('/mode-selector');
        }
      } else {
        // Store epoch on first visit
        await prefs.setString('reset_epoch', serverEpoch);
      }
    } catch (_) {
      // Silently fail — reset epoch check is non-critical
    }
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  /// Enter [route], but in corporate mode require the team to designate a leader
  /// first (parity with the website's TeamLeaderGate). Self-paced proceeds directly.
  Future<void> _enterWithLeaderGate(String route) async {
    final proceed = await showTeamLeaderGate(context, ref);
    if (proceed && mounted) context.push(route);
  }

  /// Prompt an un-registered corporate user to join a team first (parity with the
  /// website's locked Education/Simulation cards).
  void _promptJoinFirst() {
    final s = ref.read(stringsProvider);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.groups_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(s.tr('Register / join a team first to unlock this.',
                'سجّل / انضم إلى فريق أولاً لفتح هذا.'))),
          ],
        ),
        backgroundColor: const Color(0xFFF59E0B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: s.tr('Join Team', 'انضم إلى فريق'),
          textColor: Colors.white,
          onPressed: () => context.push('/lobby'),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final s = ref.watch(stringsProvider);
    final screenH = MediaQuery.of(context).size.height;
    final authState = ref.watch(authProvider);
    final teamState = ref.watch(teamProvider);
    final isSelfPaced = authState.user != null &&
        !authState.isFacilitator &&
        teamState.selectedTeam == null;
    // Registered = has joined a team (corporate) or logged in self-paced. The
    // Education & Simulation cards stay locked until then (parity with website).
    final isRegistered = isSelfPaced || teamState.selectedTeam != null;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _bgController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        Color.lerp(AppColors.darkBg, const Color(0xFF1E1B4B),
                            _bgController.value * 0.25)!,
                        AppColors.darkBg,
                        Color.lerp(AppColors.darkBg, const Color(0xFF0C4A6E),
                            _bgController.value * 0.15)!,
                      ]
                    : [
                        Color.lerp(const Color(0xFFF8FAFC),
                            const Color(0xFFEDE9FE), _bgController.value * 0.2)!,
                        const Color(0xFFF0F7FF),
                        Color.lerp(const Color(0xFFF8FAFC),
                            const Color(0xFFD1FAE5), _bgController.value * 0.1)!,
                      ],
              ),
            ),
            child: child,
          );
        },
        child: SafeArea(
          child: Column(
            children: [
              // ── Compact Header ──
              _buildHeader(context, isDark, isSelfPaced),

              // ── Main Content ──
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                  child: Column(
                    children: [
                      // Branding hero
                      _buildHero(context, isDark, screenH),
                      const SizedBox(height: 24),

                      // Join a Team card — hidden for self-paced users
                      if (!isSelfPaced) ...[
                        _ActionCard(
                          title: s.tr('Join a Team', 'انضم إلى فريق'),
                          subtitle: s.tr('Form your team for the finance challenge', 'كوّن فريقك لخوض التحدي المالي'),
                          icon: Icons.groups_rounded,
                          accentColor: const Color(0xFF3B82F6),
                          gradient: const [Color(0xFF3B82F6), Color(0xFF4F46E5)],
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            context.push('/lobby');
                          },
                        ).animate().fadeIn(delay: 300.ms, duration: 500.ms).slideX(begin: -0.06),

                        const SizedBox(height: 12),
                      ],

                      _ActionCard(
                        title: s.tr('Start Learning', 'ابدأ التعلّم'),
                        subtitle: s.tr('10 interactive finance education modules', '10 وحدات تعليمية مالية تفاعلية'),
                        icon: Icons.school_rounded,
                        accentColor: const Color(0xFF10B981),
                        gradient: const [Color(0xFF10B981), Color(0xFF059669)],
                        isLocked: !isRegistered,
                        lockedBadge: s.tr('LOCKED', 'مقفل'),
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          if (!isRegistered) {
                            _promptJoinFirst();
                            return;
                          }
                          _enterWithLeaderGate('/education');
                        },
                      ).animate().fadeIn(delay: 420.ms, duration: 500.ms).slideX(begin: -0.06),

                      const SizedBox(height: 12),

                      _ActionCard(
                        title: s.tr('Enter Simulation', 'ادخل المحاكاة'),
                        subtitle: isSelfPaced
                            ? s.tr('Continue your self-paced simulation', 'تابع محاكاتك في وضع التعلّم الذاتي')
                            : teamState.selectedTeam != null
                                ? s.tr('Playing as ', 'تلعب باسم ') + teamState.selectedTeam!.name
                                : s.tr('Select a team first in the lobby', 'اختر فريقًا أولاً في الردهة'),
                        icon: Icons.play_circle_rounded,
                        accentColor: const Color(0xFFF59E0B),
                        gradient: const [Color(0xFFF59E0B), Color(0xFFEA580C)],
                        isLocked: !isRegistered,
                        lockedBadge: s.tr('LOCKED', 'مقفل'),
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          // Corporate mode: must join a team first.
                          if (!isRegistered) {
                            _promptJoinFirst();
                            return;
                          }
                          _enterWithLeaderGate('/simulation');
                        },
                      ).animate().fadeIn(delay: 540.ms, duration: 500.ms).slideX(begin: -0.06),

                      const SizedBox(height: 24),

                      // Quick links row
                      _buildQuickLinks(context, isDark),

                      const SizedBox(height: 20),

                      // Tagline
                      Text(
                        s.tr('Interactive gamification platform — learning modules, quizzes, games, simulations & team competition.', 'منصة تعلّم تفاعلية قائمة على الألعاب — وحدات تعليمية واختبارات وألعاب ومحاكاة ومنافسة جماعية.'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.5,
                          color: AppColors.textTertiary(context),
                        ),
                      ).animate().fadeIn(delay: 700.ms),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Header with admin + logout buttons ───
  Widget _buildHeader(BuildContext context, bool isDark, bool isSelfPaced) {
    final s = ref.watch(stringsProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurface.withValues(alpha: 0.85)
            : Colors.white.withValues(alpha: 0.92),
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? AppColors.darkBorder.withValues(alpha: 0.25)
                : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, size: 20),
            onPressed: () => context.go('/mode-selector'),
            visualDensity: VisualDensity.compact,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _appTitle ?? _clientName ?? s.tr('Finance for Non-Finance', 'المالية لغير المتخصصين'),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textTertiary(context),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                // Team/player info line (like web header)
                Builder(
                  builder: (context) {
                    final teamState = ref.watch(teamProvider);
                    final authState = ref.watch(authProvider);
                    final team = teamState.selectedTeam;
                    final user = authState.user;
                    String? subtitle;
                    if (team != null) {
                      subtitle = team.name;
                    } else if (user != null) {
                      subtitle = user.displayName.isNotEmpty ? user.displayName : s.tr('Self-Paced', 'التعلّم الذاتي');
                    }
                    if (subtitle == null) return const SizedBox.shrink();
                    return Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: team != null
                            ? AppColors.teamColor(team.teamNumber - 1)
                            : AppColors.accentLight,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
              ],
            ),
          ),
          // Logout button for self-paced users
          if (isSelfPaced)
            IconButton(
              icon: Icon(Icons.logout_rounded,
                  size: 20, color: AppColors.textSecondary(context)),
              tooltip: s.tr('Logout', 'تسجيل الخروج'),
              onPressed: () async {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) context.go('/mode-selector');
              },
              visualDensity: VisualDensity.compact,
            ),
          // Admin button
          IconButton(
            icon: Icon(Icons.admin_panel_settings_rounded,
                size: 20, color: Colors.red.shade600),
            tooltip: s.tr('Admin', 'المسؤول'),
            onPressed: _showAdminDialog,
            visualDensity: VisualDensity.compact,
          ),
          // FinPlay logo (right side)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkCard
                  : const Color(0xFFF0F4FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Fin',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF5793D6),
                  ),
                ),
                Text(
                  'Play',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF243C76),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 250.ms);
  }

  // ─── Hero branding ───
  Widget _buildHero(BuildContext context, bool isDark, double screenH) {
    final s = ref.watch(stringsProvider);
    return Column(
      children: [
        // Icon
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF3B82F6), Color(0xFF4F46E5)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(Icons.trending_up_rounded,
              color: Colors.white, size: 32),
        )
            .animate()
            .fadeIn(duration: 400.ms)
            .scale(
                begin: const Offset(0.7, 0.7),
                curve: Curves.elasticOut,
                duration: 600.ms),

        const SizedBox(height: 12),

        // FinPlay text
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Fin',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF5793D6),
              ),
            ),
            Text(
              'Play',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF243C76),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 120.ms, duration: 400.ms),

        const SizedBox(height: 2),

        Text(
          s.tr('Interactive Finance Simulation', 'محاكاة مالية تفاعلية'),
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textTertiary(context),
            letterSpacing: 0.3,
          ),
        ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
      ],
    );
  }

  // ─── Quick links row ───
  Widget _buildQuickLinks(BuildContext context, bool isDark) {
    final s = ref.watch(stringsProvider);
    return Row(
      children: [
        Expanded(
          child: _QuickLink(
            icon: Icons.menu_book_rounded,
            label: s.tr('Glossary', 'المسرد'),
            color: AppColors.accentLight,
            onTap: () => context.push('/education/glossary'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _QuickLink(
            icon: Icons.table_chart_rounded,
            label: s.tr('Excel Data', 'بيانات Excel'),
            color: AppColors.dangerLight,
            onTap: () => context.push('/education/excel'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _QuickLink(
            icon: Icons.leaderboard_rounded,
            label: s.tr('Dashboard', 'لوحة التحكم'),
            color: AppColors.primaryLight,
            onTap: () => context.push('/dashboard'),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 650.ms, duration: 400.ms);
  }
}

// ═══════════════════════════════════════════════
// Action Card — compact horizontal layout
// ═══════════════════════════════════════════════
class _ActionCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final List<Color> gradient;
  final VoidCallback onTap;
  final bool isLocked;
  final String? lockedBadge;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.gradient,
    required this.onTap,
    this.isLocked = false,
    this.lockedBadge,
  });

  @override
  State<_ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<_ActionCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locked = widget.isLocked;
    final accent = locked ? const Color(0xFF9CA3AF) : widget.accentColor;
    final iconColors = locked
        ? const [Color(0xFFD1D5DB), Color(0xFF9CA3AF)]
        : widget.gradient;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Opacity(
          opacity: locked ? 0.6 : 1.0,
          child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _pressed
                  ? accent.withValues(alpha: 0.5)
                  : (isDark
                      ? AppColors.darkBorder.withValues(alpha: 0.3)
                      : const Color(0xFFE2E8F0)),
              width: _pressed ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _pressed
                    ? accent.withValues(alpha: 0.15)
                    : Colors.black.withValues(alpha: isDark ? 0.12 : 0.04),
                blurRadius: _pressed ? 16 : 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // Gradient icon circle
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: iconColors,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(locked ? Icons.lock_rounded : widget.icon, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 14),

              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            widget.title,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary(context),
                            ),
                          ),
                        ),
                        if (locked && widget.lockedBadge != null) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF9CA3AF).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              widget.lockedBadge!,
                              style: const TextStyle(
                                fontSize: 9, fontWeight: FontWeight.w800,
                                color: Color(0xFF6B7280), letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary(context),
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Arrow / lock
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  locked ? Icons.lock_outline_rounded : Icons.arrow_forward_rounded,
                  size: 18,
                  color: accent,
                ),
              ),
            ],
          ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════
// Quick Link chip
// ═══════════════════════════════════════════════
class _QuickLink extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickLink({
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
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark
                ? AppColors.darkBorder.withValues(alpha: 0.3)
                : color.withValues(alpha: 0.18),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(height: 6),
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
    );
  }
}
