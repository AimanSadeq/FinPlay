import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/widgets/app_settings_button.dart';
import '../../../app/i18n/app_strings.dart';
import '../../../app/theme/app_colors.dart';
import '../../../providers/repository_providers.dart';
import '../../../core/network/api_endpoints.dart';

class ModeSelectorScreen extends ConsumerStatefulWidget {
  const ModeSelectorScreen({super.key});

  @override
  ConsumerState<ModeSelectorScreen> createState() => _ModeSelectorScreenState();
}

class _ModeSelectorScreenState extends ConsumerState<ModeSelectorScreen>
    with TickerProviderStateMixin {
  late AnimationController _bgController;
  late AnimationController _entryController;

  late Animation<double> _heroOpacity;
  late Animation<Offset> _heroSlide;
  late Animation<double> _card1Scale;
  late Animation<double> _card1Opacity;
  late Animation<double> _card2Scale;
  late Animation<double> _card2Opacity;
  late Animation<double> _footerOpacity;

  bool _corporateEnabled = true;
  bool _checkingCorporate = true;

  // Page controller for swipeable cards
  late PageController _pageController;
  double _currentPage = 0;

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _entryController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );

    _heroOpacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: const Interval(0.0, 0.3, curve: Curves.easeOut)),
    );
    _heroSlide = Tween(begin: const Offset(0, -30), end: Offset.zero).animate(
      CurvedAnimation(parent: _entryController, curve: const Interval(0.0, 0.35, curve: Curves.easeOutCubic)),
    );
    _card1Opacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: const Interval(0.25, 0.55, curve: Curves.easeOut)),
    );
    _card1Scale = Tween(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: const Interval(0.25, 0.6, curve: Curves.easeOutBack)),
    );
    _card2Opacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: const Interval(0.4, 0.7, curve: Curves.easeOut)),
    );
    _card2Scale = Tween(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: const Interval(0.4, 0.75, curve: Curves.easeOutBack)),
    );
    _footerOpacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: const Interval(0.7, 0.9, curve: Curves.easeOut)),
    );

    _pageController = PageController(viewportFraction: 0.85);
    _pageController.addListener(() {
      setState(() => _currentPage = _pageController.page ?? 0);
    });

    _entryController.forward();
    _checkCorporateMode();
  }

  @override
  void dispose() {
    _bgController.dispose();
    _entryController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _checkCorporateMode() async {
    try {
      final api = ref.read(apiClientProvider);
      final res = await api.get(ApiEndpoints.facilitatorGameMode);
      if (mounted) {
        setState(() {
          _corporateEnabled = res['corporateModeEnabled'] == true;
          _checkingCorporate = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _checkingCorporate = false);
    }
  }

  void _showLockedSheet() {
    final s = ref.read(stringsProvider);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Icon(Icons.lock_outline_rounded, size: 48, color: Color(0xFF9CA3AF)),
              const SizedBox(height: 12),
              Text(s.workshopNotAvailable, style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(
                s.workshopLockedBody,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF6B7280), height: 1.5),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    context.push('/self-paced-login');
                  },
                  icon: const Icon(Icons.person_rounded, size: 18),
                  label: Text(s.trySelfPacedInstead, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final isSmallScreen = screenHeight < 700;

    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([_bgController, _entryController]),
        builder: (context, _) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // Animated background
              CustomPaint(
                size: screenSize,
                painter: _SkyPainter(isDark: isDark, t: _bgController.value),
              ),

              // Content
              SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: isSmallScreen ? 16 : 32),

                    // Hero section
                    Transform.translate(
                      offset: _heroSlide.value,
                      child: Opacity(
                        opacity: _heroOpacity.value,
                        child: _HeroSection(isDark: isDark, isSmall: isSmallScreen),
                      ),
                    ),

                    // Info banner when corporate is disabled
                    if (!_checkingCorporate && !_corporateEnabled)
                      Opacity(
                        opacity: _card1Opacity.value,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF78350F).withValues(alpha: 0.3)
                                  : const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDark
                                    ? const Color(0xFFF59E0B).withValues(alpha: 0.3)
                                    : const Color(0xFFFCD34D),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline_rounded, size: 18,
                                    color: isDark ? const Color(0xFFFBBF24) : const Color(0xFF92400E)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    s.tr('Corporate Mode is only available when enabled by the administrator.', 'وضع الشركات متاح فقط عند تفعيله من قبل المسؤول.'),
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: isDark ? const Color(0xFFFDE68A) : const Color(0xFF92400E),
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    SizedBox(height: isSmallScreen ? 20 : 32),

                    // Cards area - swipeable
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        clipBehavior: Clip.none,
                        children: [
                          // Self-Paced Card
                          Opacity(
                            opacity: _card1Opacity.value,
                            child: Transform.scale(
                              scale: _card1Scale.value,
                              child: _ModeCard(
                                title: s.tr('Self-Paced', 'التعلّم الذاتي'),
                                tagline: s.tr('Your Journey, Your Speed', 'رحلتك، بالسرعة التي تناسبك'),
                                icon: Icons.rocket_launch_rounded,
                                gradient: const [Color(0xFF3B82F6), Color(0xFF1D4ED8), Color(0xFF1E40AF)],
                                accentColor: const Color(0xFF3B82F6),
                                badge: s.tr('ALWAYS OPEN', 'متاح دائماً'),
                                badgeColor: const Color(0xFF10B981),
                                features: [
                                  (_FeatureIcon.person, s.tr('Personal account login', 'تسجيل دخول بحساب شخصي')),
                                  (_FeatureIcon.speed, s.tr('Learn at your own pace', 'تعلّم بالسرعة التي تناسبك')),
                                  (_FeatureIcon.quiz, s.tr('Interactive exercises', 'تمارين تفاعلية')),
                                  (_FeatureIcon.chart, s.tr('Track your progress', 'تتبّع تقدّمك')),
                                ],
                                ctaLabel: s.tr('Start Learning', 'ابدأ التعلّم'),
                                isLocked: false,
                                isDark: isDark,
                                parallaxOffset: _currentPage,
                                cardIndex: 0,
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  context.push('/self-paced-login');
                                },
                              ),
                            ),
                          ),

                          // Corporate Card
                          Opacity(
                            opacity: _card2Opacity.value,
                            child: Transform.scale(
                              scale: _card2Scale.value,
                              child: _ModeCard(
                                title: s.tr('Corporate', 'الشركات'),
                                tagline: s.tr('Team Power, Real Impact', 'قوة الفريق، أثر حقيقي'),
                                icon: Icons.hub_rounded,
                                gradient: const [Color(0xFF8B5CF6), Color(0xFF7C3AED), Color(0xFF6D28D9)],
                                accentColor: const Color(0xFF8B5CF6),
                                badge: _checkingCorporate
                                    ? null
                                    : _corporateEnabled ? null : s.tr('LOCKED', 'مقفل'),
                                badgeColor: const Color(0xFF6B7280),
                                features: [
                                  (_FeatureIcon.team, s.tr('Join with access code', 'انضم برمز الدخول')),
                                  (_FeatureIcon.live, s.tr('Live simulation', 'محاكاة مباشرة')),
                                  (_FeatureIcon.compete, s.tr('Real-time competition', 'منافسة فورية')),
                                  (_FeatureIcon.collab, s.tr('Team decisions', 'قرارات جماعية')),
                                ],
                                ctaLabel: _corporateEnabled ? s.tr('Join Workshop', 'انضم لورشة العمل') : s.tr('Not Available', 'غير متاح'),
                                isLocked: !_corporateEnabled,
                                isDark: isDark,
                                parallaxOffset: _currentPage,
                                cardIndex: 1,
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  if (_corporateEnabled) {
                                    context.push('/home');
                                  } else {
                                    _showLockedSheet();
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Page indicator dots
                    Opacity(
                      opacity: _footerOpacity.value,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(2, (i) {
                            final isActive = (_currentPage - i).abs() < 0.5;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: isActive ? 24 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: isActive
                                    ? (i == 0 ? const Color(0xFF3B82F6) : const Color(0xFF8B5CF6))
                                    : (isDark ? Colors.white.withValues(alpha: 0.2) : const Color(0xFFD1D5DB)),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),

                    // Footer
                    Opacity(
                      opacity: _footerOpacity.value,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: isSmallScreen ? 12 : 16,
                          bottom: isSmallScreen ? 8 : 16,
                        ),
                        child: _Footer(isDark: isDark),
                      ),
                    ),
                  ],
                ),
              ),

              // Language + theme toggles (top-right, on top) — matches the web header.
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                right: 16,
                child: const AppSettingsButton(),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Sky Painter — deep gradient with floating orbs
// ═══════════════════════════════════════════════════════════════
class _SkyPainter extends CustomPainter {
  final bool isDark;
  final double t;
  _SkyPainter({required this.isDark, required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    final a = t * 2 * pi;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? const [Color(0xFF0B1120), Color(0xFF111827), Color(0xFF0B1120)]
              : const [Color(0xFFF0F5FF), Color(0xFFF8FAFC), Color(0xFFFAF5FF)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    _drawOrb(canvas, size,
      cx: 0.8 + cos(a) * 0.06, cy: 0.1 + sin(a) * 0.03, r: 0.5,
      color: isDark ? const Color(0xFF1E40AF) : const Color(0xFF3B82F6),
      alpha: isDark ? 0.12 : 0.12,
    );

    _drawOrb(canvas, size,
      cx: 0.2 + cos(a + pi * 0.7) * 0.05, cy: 0.85 + sin(a + pi * 0.7) * 0.02, r: 0.45,
      color: isDark ? const Color(0xFF7C3AED) : const Color(0xFF8B5CF6),
      alpha: isDark ? 0.10 : 0.08,
    );

    _drawOrb(canvas, size,
      cx: 0.5 + sin(a * 0.5) * 0.04, cy: 0.45 + cos(a * 0.5) * 0.02, r: 0.25,
      color: isDark ? const Color(0xFF0EA5E9) : const Color(0xFF06B6D4),
      alpha: isDark ? 0.06 : 0.05,
    );
  }

  void _drawOrb(Canvas canvas, Size size, {
    required double cx, required double cy, required double r,
    required Color color, required double alpha,
  }) {
    final center = Offset(size.width * cx, size.height * cy);
    final radius = size.width * r;
    canvas.drawCircle(
      center, radius,
      Paint()..shader = RadialGradient(
        colors: [color.withValues(alpha: alpha), Colors.transparent],
      ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );
  }

  @override
  bool shouldRepaint(covariant _SkyPainter old) => old.t != t;
}

// ═══════════════════════════════════════════════════════════════
// Hero Section
// ═══════════════════════════════════════════════════════════════
class _HeroSection extends StatelessWidget {
  final bool isDark;
  final bool isSmall;
  const _HeroSection({required this.isDark, this.isSmall = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // FinPlay Logo
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text('Fin', style: GoogleFonts.plusJakartaSans(
              fontSize: isSmall ? 28 : 32, fontWeight: FontWeight.w800, color: const Color(0xFF5793D6),
            )),
            Text('Play', style: GoogleFonts.plusJakartaSans(
              fontSize: isSmall ? 28 : 32, fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF243C76),
            )),
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Text('\u00AE', style: GoogleFonts.plusJakartaSans(
                fontSize: 11, fontWeight: FontWeight.w600,
                color: const Color(0xFF243C76).withValues(alpha: 0.5),
              )),
            ),
          ],
        ),

        SizedBox(height: isSmall ? 8 : 14),

        Consumer(builder: (context, ref, _) {
          final s = ref.watch(stringsProvider);
          return Column(
            children: [
              Text(
                s.choosePath,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: isSmall ? 22 : 26,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF111827),
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                s.choosePathSubtitle,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: isDark ? Colors.white.withValues(alpha: 0.5) : const Color(0xFF6B7280),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          );
        }),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Feature Icon enum
// ═══════════════════════════════════════════════════════════════
enum _FeatureIcon { person, speed, quiz, chart, team, live, compete, collab }

IconData _featureIconData(_FeatureIcon f) {
  switch (f) {
    case _FeatureIcon.person: return Icons.person_rounded;
    case _FeatureIcon.speed: return Icons.speed_rounded;
    case _FeatureIcon.quiz: return Icons.quiz_rounded;
    case _FeatureIcon.chart: return Icons.show_chart_rounded;
    case _FeatureIcon.team: return Icons.group_rounded;
    case _FeatureIcon.live: return Icons.cell_tower_rounded;
    case _FeatureIcon.compete: return Icons.emoji_events_rounded;
    case _FeatureIcon.collab: return Icons.handshake_rounded;
  }
}

// ═══════════════════════════════════════════════════════════════
// Mode Card — full visual card with gradient header
// ═══════════════════════════════════════════════════════════════
class _ModeCard extends StatefulWidget {
  final String title;
  final String tagline;
  final IconData icon;
  final List<Color> gradient;
  final Color accentColor;
  final String? badge;
  final Color badgeColor;
  final List<(_FeatureIcon, String)> features;
  final String ctaLabel;
  final bool isLocked;
  final bool isDark;
  final double parallaxOffset;
  final int cardIndex;
  final VoidCallback onTap;

  const _ModeCard({
    required this.title,
    required this.tagline,
    required this.icon,
    required this.gradient,
    required this.accentColor,
    this.badge,
    required this.badgeColor,
    required this.features,
    required this.ctaLabel,
    required this.isLocked,
    required this.isDark,
    required this.parallaxOffset,
    required this.cardIndex,
    required this.onTap,
  });

  @override
  State<_ModeCard> createState() => _ModeCardState();
}

class _ModeCardState extends State<_ModeCard> with SingleTickerProviderStateMixin {
  bool _pressed = false;
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardBg = widget.isDark
        ? const Color(0xFF1E293B).withValues(alpha: 0.8)
        : Colors.white.withValues(alpha: 0.92);

    // Parallax effect on the icon
    final parallax = (widget.parallaxOffset - widget.cardIndex) * 30;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) { setState(() => _pressed = false); widget.onTap(); },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: _pressed
                  ? widget.accentColor.withValues(alpha: 0.5)
                  : (widget.isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : widget.accentColor.withValues(alpha: 0.1)),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.accentColor.withValues(alpha: _pressed ? 0.2 : 0.08),
                blurRadius: _pressed ? 40 : 20,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(27),
            child: Column(
              children: [
                // ── Gradient header with icon ──
                Expanded(
                  flex: 5,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Gradient background
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: widget.isLocked
                                ? const [Color(0xFFD1D5DB), Color(0xFF9CA3AF)]
                                : widget.gradient,
                          ),
                        ),
                      ),

                      // Decorative circles
                      Positioned(
                        top: -20,
                        right: -20 + parallax,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -30,
                        left: -10 + parallax * 0.5,
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.06),
                          ),
                        ),
                      ),

                      // Shimmer effect
                      if (!widget.isLocked)
                        AnimatedBuilder(
                          animation: _shimmerController,
                          builder: (context, _) {
                            return Positioned(
                              left: -100 + (_shimmerController.value * 500),
                              top: 0,
                              bottom: 0,
                              child: Transform.rotate(
                                angle: -0.3,
                                child: Container(
                                  width: 60,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.white.withValues(alpha: 0.0),
                                        Colors.white.withValues(alpha: 0.06),
                                        Colors.white.withValues(alpha: 0.0),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                      // Center icon
                      Center(
                        child: Transform.translate(
                          offset: Offset(parallax * 0.5, 0),
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Icon(
                              widget.isLocked ? Icons.lock_rounded : widget.icon,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                      ),

                      // Badge
                      if (widget.badge != null)
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: widget.badgeColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: widget.badgeColor.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              widget.badge!,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // ── Content section ──
                Expanded(
                  flex: 7,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title & tagline
                        Text(
                          widget.title,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: widget.isDark ? Colors.white : const Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.tagline,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: widget.isLocked
                                ? const Color(0xFF9CA3AF)
                                : widget.accentColor,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Features grid (2x2)
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (int row = 0; row < 2; row++)
                                Padding(
                                  padding: EdgeInsets.only(bottom: row == 0 ? 10 : 0),
                                  child: Row(
                                    children: [
                                      for (int col = 0; col < 2; col++) ...[
                                        if (col > 0) const SizedBox(width: 10),
                                        Expanded(
                                          child: _FeaturePill(
                                            icon: widget.features[row * 2 + col].$1,
                                            label: widget.features[row * 2 + col].$2,
                                            accentColor: widget.accentColor,
                                            isLocked: widget.isLocked,
                                            isDark: widget.isDark,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // CTA button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: widget.isLocked
                                  ? const LinearGradient(colors: [Color(0xFFD1D5DB), Color(0xFF9CA3AF)])
                                  : LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: widget.gradient,
                                    ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: widget.isLocked ? null : [
                                BoxShadow(
                                  color: widget.accentColor.withValues(alpha: 0.35),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (widget.isLocked)
                                    const Padding(
                                      padding: EdgeInsets.only(right: 8),
                                      child: Icon(Icons.lock_rounded, size: 16, color: Colors.white),
                                    ),
                                  Text(
                                    widget.ctaLabel,
                                    style: GoogleFonts.inter(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  if (!widget.isLocked)
                                    const Padding(
                                      padding: EdgeInsets.only(left: 8),
                                      child: Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.white),
                                    ),
                                ],
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
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Feature Pill — compact feature display
// ═══════════════════════════════════════════════════════════════
class _FeaturePill extends StatelessWidget {
  final _FeatureIcon icon;
  final String label;
  final Color accentColor;
  final bool isLocked;
  final bool isDark;

  const _FeaturePill({
    required this.icon,
    required this.label,
    required this.accentColor,
    required this.isLocked,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final color = isLocked ? const Color(0xFF9CA3AF) : accentColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: isDark
            ? color.withValues(alpha: 0.08)
            : color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.15 : 0.1),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _featureIconData(icon),
            size: 16,
            color: color.withValues(alpha: 0.8),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : const Color(0xFF4B5563),
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Footer
// ═══════════════════════════════════════════════════════════════
class _Footer extends StatelessWidget {
  final bool isDark;
  const _Footer({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40, height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.transparent,
              (isDark ? Colors.white : const Color(0xFF94A3B8)).withValues(alpha: 0.25),
              Colors.transparent,
            ]),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'VIFM Finance Academy',
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white.withValues(alpha: 0.25) : const Color(0xFF9CA3AF),
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }
}
