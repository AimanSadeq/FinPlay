import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/i18n/app_strings.dart';
import '../../../providers/repository_providers.dart';
import '../../../providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _meshController;
  late AnimationController _entryController;
  late AnimationController _pulseController;
  late AnimationController _floatController;

  // Entry sequence animations
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _titleSlide;
  late Animation<double> _titleOpacity;
  late Animation<double> _subtitleOpacity;
  late Animation<double> _loadingOpacity;
  late Animation<double> _brandingOpacity;
  late Animation<double> _iconsOpacity;

  @override
  void initState() {
    super.initState();

    // Slow mesh gradient rotation
    _meshController = AnimationController(
      duration: const Duration(seconds: 12),
      vsync: this,
    )..repeat();

    // Pulse for the logo glow
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    // Float for decorative icons
    _floatController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);

    // Entry sequence (staggered reveals)
    _entryController = AnimationController(
      duration: const Duration(milliseconds: 2400),
      vsync: this,
    );

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.35, curve: Curves.elasticOut),
      ),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.2, curve: Curves.easeOut),
      ),
    );
    _titleSlide = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.2, 0.45, curve: Curves.easeOutCubic),
      ),
    );
    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.2, 0.4, curve: Curves.easeOut),
      ),
    );
    _subtitleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.35, 0.55, curve: Curves.easeOut),
      ),
    );
    _iconsOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.4, 0.65, curve: Curves.easeOut),
      ),
    );
    _loadingOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.55, 0.75, curve: Curves.easeOut),
      ),
    );
    _brandingOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.65, 0.85, curve: Curves.easeOut),
      ),
    );

    _entryController.forward();

    // Navigate after splash
    Future.delayed(const Duration(milliseconds: 3000), _navigateOnward);
  }

  /// Honour the facilitator's global site-access gate (matches the website,
  /// which polls /site-access/status and blocks the app behind an access code).
  Future<void> _navigateOnward() async {
    if (!mounted) return;
    // 1) Honour the site-access gate first.
    try {
      final prefs = await SharedPreferences.getInstance();
      final alreadyVerified = prefs.getBool('site_access_verified') ?? false;
      if (!alreadyVerified) {
        final gated = await ref.read(authRepositoryProvider).isSiteAccessEnabled();
        if (gated) {
          if (mounted) context.go('/site-access');
          return;
        }
      }
    } catch (_) {
      // Fall through to the normal flow if the check fails.
    }
    // 2) Restore a saved self-paced session so the user stays signed in.
    try {
      final restored = await ref.read(authProvider.notifier).restoreSession();
      if (restored && mounted) {
        context.go('/self-paced-progress');
        return;
      }
    } catch (_) {/* not signed in — continue */}
    if (mounted) context.go('/mode-selector');
  }

  @override
  void dispose() {
    _meshController.dispose();
    _entryController.dispose();
    _pulseController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([_meshController, _entryController, _pulseController, _floatController]),
        builder: (context, _) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // ── Layer 1: Animated mesh gradient background ──
              _MeshBackground(
                isDark: isDark,
                progress: _meshController.value,
                size: size,
              ),

              // ── Layer 2: Floating finance icons ──
              Opacity(
                opacity: _iconsOpacity.value,
                child: _FloatingIcons(
                  isDark: isDark,
                  floatProgress: _floatController.value,
                  size: size,
                ),
              ),

              // ── Layer 3: Geometric accent lines ──
              Opacity(
                opacity: _subtitleOpacity.value * 0.4,
                child: _GeometricAccents(isDark: isDark, size: size),
              ),

              // ── Layer 4: Center content ──
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo with animated glow
                    Transform.scale(
                      scale: _logoScale.value,
                      child: Opacity(
                        opacity: _logoOpacity.value,
                        child: _AnimatedLogo(
                          isDark: isDark,
                          pulseValue: _pulseController.value,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // FinPlay title
                    Transform.translate(
                      offset: Offset(0, _titleSlide.value),
                      child: Opacity(
                        opacity: _titleOpacity.value,
                        child: _FinPlayTitle(isDark: isDark),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Subtitle with typing cursor effect
                    Opacity(
                      opacity: _subtitleOpacity.value,
                      child: _Subtitle(isDark: isDark),
                    ),

                    const SizedBox(height: 32),

                    // Feature pills
                    Opacity(
                      opacity: _iconsOpacity.value,
                      child: _FeaturePills(isDark: isDark),
                    ),

                    const SizedBox(height: 36),

                    // Custom loading animation
                    Opacity(
                      opacity: _loadingOpacity.value,
                      child: _WaveLoader(
                        isDark: isDark,
                        progress: _meshController.value,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Layer 5: Bottom branding ──
              Positioned(
                bottom: 36,
                left: 24,
                right: 24,
                child: Opacity(
                  opacity: _brandingOpacity.value,
                  child: _BottomBranding(isDark: isDark),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Mesh Gradient Background
// ═══════════════════════════════════════════════════════════════
class _MeshBackground extends StatelessWidget {
  final bool isDark;
  final double progress;
  final Size size;

  const _MeshBackground({
    required this.isDark,
    required this.progress,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final angle = progress * 2 * pi;

    return CustomPaint(
      size: size,
      painter: _MeshPainter(
        isDark: isDark,
        angle: angle,
      ),
    );
  }
}

class _MeshPainter extends CustomPainter {
  final bool isDark;
  final double angle;

  _MeshPainter({required this.isDark, required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    // Base fill — matches website: from-slate-50 via-blue-50 to-emerald-50
    // slate-50=#F8FAFC, blue-50=#EFF6FF, emerald-50=#ECFDF5
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? const [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF0F172A)]
              : const [Color(0xFFF8FAFC), Color(0xFFEFF6FF), Color(0xFFECFDF5)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    // Orb 1 - Blue (top-right) — website: rgba(59,130,246,0.2)
    final orb1X = size.width * 0.8 + cos(angle) * size.width * 0.12;
    final orb1Y = size.height * 0.2 + sin(angle) * size.height * 0.08;
    canvas.drawCircle(
      Offset(orb1X, orb1Y),
      size.width * 0.45,
      Paint()
        ..shader = RadialGradient(
          colors: isDark
              ? [const Color(0xFF1E40AF).withValues(alpha: 0.25), Colors.transparent]
              : [const Color(0xFF3B82F6).withValues(alpha: 0.20), Colors.transparent],
        ).createShader(Rect.fromCircle(center: Offset(orb1X, orb1Y), radius: size.width * 0.45)),
    );

    // Orb 2 - Emerald (bottom-left) — website: rgba(16,185,129,0.2)
    final orb2X = size.width * 0.2 + cos(angle + pi) * size.width * 0.1;
    final orb2Y = size.height * 0.8 + sin(angle + pi) * size.height * 0.06;
    canvas.drawCircle(
      Offset(orb2X, orb2Y),
      size.width * 0.5,
      Paint()
        ..shader = RadialGradient(
          colors: isDark
              ? [const Color(0xFF059669).withValues(alpha: 0.2), Colors.transparent]
              : [const Color(0xFF10B981).withValues(alpha: 0.20), Colors.transparent],
        ).createShader(Rect.fromCircle(center: Offset(orb2X, orb2Y), radius: size.width * 0.5)),
    );

    // Orb 3 - Indigo (center) — website: rgba(99,102,241,0.1)
    final orb3X = size.width * 0.5 + sin(angle * 0.7) * size.width * 0.08;
    final orb3Y = size.height * 0.5 + cos(angle * 0.7) * size.height * 0.05;
    canvas.drawCircle(
      Offset(orb3X, orb3Y),
      size.width * 0.35,
      Paint()
        ..shader = RadialGradient(
          colors: isDark
              ? [const Color(0xFF4338CA).withValues(alpha: 0.12), Colors.transparent]
              : [const Color(0xFF6366F1).withValues(alpha: 0.10), Colors.transparent],
        ).createShader(Rect.fromCircle(center: Offset(orb3X, orb3Y), radius: size.width * 0.35)),
    );
  }

  @override
  bool shouldRepaint(covariant _MeshPainter oldDelegate) => oldDelegate.angle != angle;
}

// ═══════════════════════════════════════════════════════════════
// Floating Finance Icons
// ═══════════════════════════════════════════════════════════════
class _FloatingIcons extends StatelessWidget {
  final bool isDark;
  final double floatProgress;
  final Size size;

  const _FloatingIcons({
    required this.isDark,
    required this.floatProgress,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final icons = [
      (Icons.account_balance_rounded, 0.12, 0.18, -8.0, 6.0),
      (Icons.bar_chart_rounded, 0.85, 0.15, 5.0, -10.0),
      (Icons.pie_chart_rounded, 0.08, 0.72, 10.0, 4.0),
      (Icons.show_chart_rounded, 0.88, 0.68, -6.0, -8.0),
      (Icons.currency_exchange_rounded, 0.5, 0.08, 7.0, 12.0),
      (Icons.savings_rounded, 0.15, 0.45, -12.0, -5.0),
      (Icons.receipt_long_rounded, 0.82, 0.42, 9.0, 7.0),
      (Icons.assessment_rounded, 0.45, 0.85, -4.0, -11.0),
    ];

    return Stack(
      children: icons.map((item) {
        final (icon, xFrac, yFrac, dxRange, dyRange) = item;
        final dx = dxRange * sin(floatProgress * pi);
        final dy = dyRange * cos(floatProgress * pi);

        return Positioned(
          left: size.width * xFrac + dx,
          top: size.height * yFrac + dy,
          child: Icon(
            icon,
            size: 22,
            color: (isDark ? Colors.white : const Color(0xFF5793D6))
                .withValues(alpha: isDark ? 0.06 : 0.08),
          ),
        );
      }).toList(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Geometric Accent Lines
// ═══════════════════════════════════════════════════════════════
class _GeometricAccents extends StatelessWidget {
  final bool isDark;
  final Size size;

  const _GeometricAccents({required this.isDark, required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: size,
      painter: _AccentPainter(isDark: isDark),
    );
  }
}

class _AccentPainter extends CustomPainter {
  final bool isDark;
  _AccentPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? Colors.white : const Color(0xFF94A3B8))
          .withValues(alpha: isDark ? 0.03 : 0.05)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Diagonal grid lines
    for (var i = -2; i < 8; i++) {
      final start = Offset(size.width * (i / 6), 0);
      final end = Offset(size.width * (i / 6) + size.height * 0.3, size.height);
      canvas.drawLine(start, end, paint);
    }

    // Horizontal accent
    canvas.drawLine(
      Offset(size.width * 0.1, size.height * 0.3),
      Offset(size.width * 0.9, size.height * 0.3),
      paint..color = (isDark ? Colors.white : const Color(0xFF94A3B8))
          .withValues(alpha: isDark ? 0.02 : 0.04),
    );
    canvas.drawLine(
      Offset(size.width * 0.1, size.height * 0.7),
      Offset(size.width * 0.9, size.height * 0.7),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ═══════════════════════════════════════════════════════════════
// Animated Logo
// ═══════════════════════════════════════════════════════════════
class _AnimatedLogo extends StatelessWidget {
  final bool isDark;
  final double pulseValue;

  const _AnimatedLogo({required this.isDark, required this.pulseValue});

  @override
  Widget build(BuildContext context) {
    final glowRadius = 24.0 + pulseValue * 12.0;
    final glowAlpha = 0.3 + pulseValue * 0.15;

    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withValues(alpha: glowAlpha),
            blurRadius: glowRadius,
            spreadRadius: 4,
          ),
          BoxShadow(
            color: const Color(0xFF4F46E5).withValues(alpha: glowAlpha * 0.5),
            blurRadius: glowRadius * 1.5,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Image.asset(
          'assets/icons/app_icon.png',
          width: 110,
          height: 110,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// FinPlay Title
// ═══════════════════════════════════════════════════════════════
class _FinPlayTitle extends StatelessWidget {
  final bool isDark;
  const _FinPlayTitle({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          'Fin',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 48,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF5793D6),
            letterSpacing: -1.5,
            height: 1.0,
          ),
        ),
        Text(
          'Play',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 48,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : const Color(0xFF243C76),
            letterSpacing: -1.5,
            height: 1.0,
          ),
        ),
        // Registered mark
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Text(
            '\u00AE',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF243C76).withValues(alpha: 0.6),
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Subtitle
// ═══════════════════════════════════════════════════════════════
class _Subtitle extends StatelessWidget {
  final bool isDark;
  const _Subtitle({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Consumer(builder: (context, ref, _) {
          final s = ref.watch(stringsProvider);
          return Text(
            s.tr('Interactive Finance Simulation', 'محاكاة مالية تفاعلية'),
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.6)
                  : const Color(0xFF374151), // gray-700
              letterSpacing: 0.5,
            ),
          );
        }),
        const SizedBox(height: 4),
        Text(
          'VIFM Finance Academy',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isDark
                ? Colors.white.withValues(alpha: 0.35)
                : const Color(0xFF6B7280), // gray-500
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Feature Pills
// ═══════════════════════════════════════════════════════════════
class _FeaturePills extends StatelessWidget {
  final bool isDark;
  const _FeaturePills({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final pills = [
      (Icons.school_rounded, 'Learn'),
      (Icons.sports_esports_rounded, 'Play'),
      (Icons.emoji_events_rounded, 'Compete'),
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: pills.asMap().entries.map((entry) {
        final (icon, label) = entry.value;
        final isLast = entry.key == pills.length - 1;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : const Color(0xFF5793D6).withValues(alpha: 0.08),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : const Color(0xFF5793D6).withValues(alpha: 0.15),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 14,
                    color: isDark
                        ? const Color(0xFF93C5FD) // blue-300
                        : const Color(0xFF5793D6),
                  ),
                  const SizedBox(width: 5),
                  Consumer(builder: (context, ref, _) {
                    final s = ref.watch(stringsProvider);
                    final translated = label == 'Learn'
                        ? s.tr('Learn', 'تعلّم')
                        : label == 'Play'
                            ? s.tr('Play', 'العب')
                            : label == 'Compete'
                                ? s.tr('Compete', 'تنافس')
                                : label;
                    return Text(
                      translated,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.7)
                            : const Color(0xFF374151), // gray-700
                      ),
                    );
                  }),
                ],
              ),
            ),
            if (!isLast) const SizedBox(width: 8),
          ],
        );
      }).toList(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Wave Loader
// ═══════════════════════════════════════════════════════════════
class _WaveLoader extends StatelessWidget {
  final bool isDark;
  final double progress;

  const _WaveLoader({required this.isDark, required this.progress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (i) {
          // Each dot has a phase offset
          final phase = (progress * 2 * pi) + (i * pi / 2);
          final scale = 0.5 + 0.5 * ((sin(phase) + 1) / 2);
          final alpha = 0.3 + 0.7 * scale;

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color.lerp(
                const Color(0xFF3B82F6),
                const Color(0xFF4F46E5),
                i / 3,
              )!.withValues(alpha: alpha),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3B82F6).withValues(alpha: alpha * 0.4),
                  blurRadius: 6 * scale,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Bottom Branding
// ═══════════════════════════════════════════════════════════════
class _BottomBranding extends StatelessWidget {
  final bool isDark;
  const _BottomBranding({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Divider line
        Container(
          width: 40,
          height: 1,
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                (isDark ? Colors.white : const Color(0xFF94A3B8))
                    .withValues(alpha: 0.3),
                Colors.transparent,
              ],
            ),
          ),
        ),
        Text(
          'Virginia Institute of Finance & Management',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: isDark
                ? Colors.white.withValues(alpha: 0.3)
                : const Color(0xFF94A3B8),
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}
