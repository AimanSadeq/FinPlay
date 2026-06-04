import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/i18n/app_strings.dart';
import '../../../app/theme/app_colors.dart';
import '../../../providers/auth_provider.dart';

class SelfPacedProgressScreen extends ConsumerStatefulWidget {
  const SelfPacedProgressScreen({super.key});

  @override
  ConsumerState<SelfPacedProgressScreen> createState() =>
      _SelfPacedProgressScreenState();
}

class _SelfPacedProgressScreenState
    extends ConsumerState<SelfPacedProgressScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _bgController;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      duration: const Duration(seconds: 14),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  String get _greeting {
    final s = ref.read(stringsProvider);
    final hour = DateTime.now().hour;
    if (hour < 12) return s.tr('Good Morning', 'صباح الخير');
    if (hour < 17) return s.tr('Good Afternoon', 'مساء الخير');
    return s.tr('Good Evening', 'مساء الخير');
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final s = ref.watch(stringsProvider);
    final user = auth.user;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final displayName = user?.displayName ?? s.tr('Learner', 'متعلّم');
    final initials =
        displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U';

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
                        Color.lerp(
                            const Color(0xFFF8FAFC),
                            const Color(0xFFEDE9FE),
                            _bgController.value * 0.2)!,
                        const Color(0xFFF0F7FF),
                        Color.lerp(
                            const Color(0xFFF8FAFC),
                            const Color(0xFFD1FAE5),
                            _bgController.value * 0.1)!,
                      ],
              ),
            ),
            child: child,
          );
        },
        child: SafeArea(
          child: Column(
            children: [
              // ── Header ──
              _buildHeader(context, isDark),

              // ── Main Content ──
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                  child: Column(
                    children: [
                      // Hero with welcome
                      _buildHero(context, isDark, displayName, initials),
                      const SizedBox(height: 24),

                      // Action Cards
                      _ActionCard(
                        title: s.tr('Start Learning', 'ابدأ التعلّم'),
                        subtitle:
                            s.tr('10 interactive finance education modules', '10 وحدات تعليمية مالية تفاعلية'),
                        icon: Icons.school_rounded,
                        accentColor: const Color(0xFF10B981),
                        gradient: const [
                          Color(0xFF10B981),
                          Color(0xFF059669)
                        ],
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          context.push('/education');
                        },
                      )
                          .animate()
                          .fadeIn(delay: 300.ms, duration: 500.ms)
                          .slideX(begin: -0.06),

                      const SizedBox(height: 12),

                      _ActionCard(
                        title: s.tr('Enter Simulation', 'ادخل المحاكاة'),
                        subtitle:
                            s.tr('Strategic finance game with real IFRS statements', 'لعبة مالية استراتيجية بقوائم مالية حقيقية وفق معايير IFRS'),
                        icon: Icons.play_circle_rounded,
                        accentColor: const Color(0xFFF59E0B),
                        gradient: const [
                          Color(0xFFF59E0B),
                          Color(0xFFEA580C)
                        ],
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          context.push('/simulation');
                        },
                      )
                          .animate()
                          .fadeIn(delay: 420.ms, duration: 500.ms)
                          .slideX(begin: -0.06),

                      const SizedBox(height: 24),

                      // Quick Links
                      _buildQuickLinks(context, isDark),

                      const SizedBox(height: 20),

                      // Tagline
                      Text(
                        s.tr('Interactive gamification platform — learning modules, quizzes, games, simulations & real-world examples.', 'منصة تعلّم تفاعلية قائمة على الألعاب — وحدات تعليمية واختبارات وألعاب ومحاكاة وأمثلة من الواقع.'),
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

  // ─── Header ───
  Widget _buildHeader(BuildContext context, bool isDark) {
    final user = ref.watch(authProvider).user;
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
                  s.tr('Finance for Non-Finance', 'المالية لغير المتخصصين'),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textTertiary(context),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (user != null)
                  Text(
                    user.displayName.isNotEmpty
                        ? user.displayName
                        : s.tr('Self-Paced', 'التعلّم الذاتي'),
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryLight,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          // Logout
          IconButton(
            icon: Icon(Icons.logout_rounded,
                size: 20, color: AppColors.textSecondary(context)),
            tooltip: s.tr('Logout', 'تسجيل الخروج'),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              context.go('/mode-selector');
            },
            visualDensity: VisualDensity.compact,
          ),
          // FinPlay logo
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : const Color(0xFFF0F4FF),
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

  // ─── Hero with welcome ───
  Widget _buildHero(
      BuildContext context, bool isDark, String displayName, String initials) {
    final s = ref.watch(stringsProvider);
    return Column(
      children: [
        // Avatar with gradient
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
          child: Center(
            child: Text(
              initials,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 400.ms)
            .scale(
              begin: const Offset(0.7, 0.7),
              curve: Curves.elasticOut,
              duration: 600.ms,
            ),

        const SizedBox(height: 12),

        // Greeting
        Text(
          '$_greeting,',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textTertiary(context),
            letterSpacing: 0.2,
          ),
        ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

        const SizedBox(height: 2),

        // User name
        Text(
          displayName,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary(context),
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

        const SizedBox(height: 4),

        // FinPlay subtitle
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Fin',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF5793D6),
              ),
            ),
            Text(
              'Play',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF243C76),
              ),
            ),
            const SizedBox(width: 4),
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                s.tr('Self-Paced', 'التعلّم الذاتي'),
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryLight,
                ),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

        const SizedBox(height: 2),

        Text(
          s.tr('Interactive Finance Simulation', 'محاكاة مالية تفاعلية'),
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textTertiary(context),
            letterSpacing: 0.3,
          ),
        ).animate().fadeIn(delay: 250.ms, duration: 400.ms),
      ],
    );
  }

  // ─── Quick Links ───
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
// Action Card — same style as corporate home
// ═══════════════════════════════════════════════
class _ActionCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.gradient,
    required this.onTap,
  });

  @override
  State<_ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<_ActionCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _pressed
                  ? widget.accentColor.withValues(alpha: 0.5)
                  : (isDark
                      ? AppColors.darkBorder.withValues(alpha: 0.3)
                      : const Color(0xFFE2E8F0)),
              width: _pressed ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _pressed
                    ? widget.accentColor.withValues(alpha: 0.15)
                    : Colors.black
                        .withValues(alpha: isDark ? 0.12 : 0.04),
                blurRadius: _pressed ? 16 : 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // Gradient icon
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: widget.gradient,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color:
                          widget.accentColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child:
                    Icon(widget.icon, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 14),

              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary(context),
                      ),
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

              // Arrow
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color:
                      widget.accentColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 18,
                  color: widget.accentColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════
// Quick Link chip — same as corporate home
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
