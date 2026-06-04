import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/i18n/app_strings.dart';
import '../../../app/theme/app_colors.dart';
import '../../../providers/repository_providers.dart';
import '../../../shared/widgets/gradient_button.dart';

class SiteAccessScreen extends ConsumerStatefulWidget {
  const SiteAccessScreen({super.key});

  @override
  ConsumerState<SiteAccessScreen> createState() => _SiteAccessScreenState();
}

class _SiteAccessScreenState extends ConsumerState<SiteAccessScreen>
    with SingleTickerProviderStateMixin {
  final _codeController = TextEditingController();
  final _focusNode = FocusNode();
  bool _loading = false;
  String? _error;
  bool _isFocused = false;

  late AnimationController _bgAnimController;
  late Animation<double> _bgAnimation;

  @override
  void initState() {
    super.initState();
    _bgAnimController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);
    _bgAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bgAnimController, curve: Curves.easeInOut),
    );
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _bgAnimController.dispose();
    _codeController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _validateAccess() async {
    final s = ref.read(stringsProvider);
    if (_codeController.text.trim().isEmpty) {
      setState(() => _error = s.tr('Please enter an access code', 'يرجى إدخال رمز الدخول'));
      return;
    }

    HapticFeedback.mediumImpact();

    setState(() { _loading = true; _error = null; });
    try {
      final repo = ref.read(authRepositoryProvider);
      final valid = await repo.validateSiteAccess(_codeController.text.trim());
      if (valid && mounted) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('site_access_verified', true);
        if (!mounted) return;
        context.go('/program');
      } else {
        setState(() => _error = s.tr('Invalid access code', 'رمز دخول غير صالح'));
      }
    } catch (e) {
      setState(() => _error = s.tr('Could not verify code', 'تعذّر التحقق من الرمز'));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final s = ref.watch(stringsProvider);

    return Scaffold(
      body: AnimatedBuilder(
        animation: _bgAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(
                  -1.0 + _bgAnimation.value * 0.5,
                  -1.0,
                ),
                end: Alignment(
                  1.0 - _bgAnimation.value * 0.5,
                  1.0,
                ),
                colors: isDark
                    ? [
                        AppColors.darkBg,
                        Color.lerp(AppColors.darkSurface, AppColors.purple.withValues(alpha: 0.15), _bgAnimation.value)!,
                        AppColors.darkBg,
                      ]
                    : [
                        AppColors.lightBg,
                        Color.lerp(Colors.white, AppColors.purpleSurface, _bgAnimation.value)!,
                        AppColors.lightBg,
                      ],
              ),
            ),
            child: child,
          );
        },
        child: SafeArea(
          child: Stack(
            children: [
              // Decorative background orbs
              ..._buildBackgroundOrbs(isDark),

              // Main content
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Shield / security visual
                      _buildShieldIcon(isDark)
                          .animate()
                          .fadeIn(duration: 600.ms)
                          .scale(
                            begin: const Offset(0.3, 0.3),
                            end: const Offset(1.0, 1.0),
                            curve: Curves.elasticOut,
                            duration: 800.ms,
                          ),

                      const SizedBox(height: 12),

                      // Glowing key icon
                      _buildGlowingKeyIcon(isDark)
                          .animate()
                          .fadeIn(delay: 200.ms, duration: 500.ms)
                          .slideY(begin: -0.3, end: 0, delay: 200.ms, duration: 500.ms, curve: Curves.easeOut),

                      const SizedBox(height: 24),

                      // Title
                      Text(
                        s.tr('Site Access', 'الوصول إلى الموقع'),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary(context),
                          letterSpacing: -0.5,
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 400.ms, duration: 500.ms)
                          .slideY(begin: 0.3, end: 0, delay: 400.ms, duration: 500.ms, curve: Curves.easeOut),

                      const SizedBox(height: 8),

                      // Subtitle
                      Text(
                        s.tr('Enter the access code provided by your facilitator', 'أدخل رمز الدخول الذي قدّمه الميسّر'),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary(context),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      )
                          .animate()
                          .fadeIn(delay: 550.ms, duration: 500.ms)
                          .slideY(begin: 0.3, end: 0, delay: 550.ms, duration: 500.ms, curve: Curves.easeOut),

                      const SizedBox(height: 36),

                      // Premium form card
                      _buildFormCard(isDark)
                          .animate()
                          .fadeIn(delay: 700.ms, duration: 600.ms)
                          .slideY(begin: 0.2, end: 0, delay: 700.ms, duration: 600.ms, curve: Curves.easeOut),

                      const SizedBox(height: 20),

                      // Back button
                      TextButton.icon(
                        onPressed: () => context.pop(),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.textSecondary(context),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        icon: const Icon(Icons.arrow_back_rounded, size: 18),
                        label: Text(
                          s.tr('Back', 'رجوع'),
                          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w500),
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 900.ms, duration: 400.ms),
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

  /// Decorative background orbs for depth
  List<Widget> _buildBackgroundOrbs(bool isDark) {
    return [
      Positioned(
        top: -60,
        right: -40,
        child: AnimatedBuilder(
          animation: _bgAnimation,
          builder: (context, _) => Transform.translate(
            offset: Offset(
              math.sin(_bgAnimation.value * math.pi) * 20,
              math.cos(_bgAnimation.value * math.pi) * 15,
            ),
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.purple.withValues(alpha: isDark ? 0.12 : 0.08),
                    AppColors.purple.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      Positioned(
        bottom: -80,
        left: -60,
        child: AnimatedBuilder(
          animation: _bgAnimation,
          builder: (context, _) => Transform.translate(
            offset: Offset(
              math.cos(_bgAnimation.value * math.pi) * 15,
              math.sin(_bgAnimation.value * math.pi) * 20,
            ),
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primaryLight.withValues(alpha: isDark ? 0.1 : 0.06),
                    AppColors.primaryLight.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ];
  }

  /// Decorative shield visual element
  Widget _buildShieldIcon(bool isDark) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.purple.withValues(alpha: isDark ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.shield_outlined,
        color: AppColors.purple.withValues(alpha: 0.6),
        size: 24,
      ),
    );
  }

  /// Glowing key icon with animated box shadow
  Widget _buildGlowingKeyIcon(bool isDark) {
    return AnimatedBuilder(
      animation: _bgAnimation,
      builder: (context, child) {
        final glowOpacity = 0.25 + (_bgAnimation.value * 0.2);
        final glowRadius = 20.0 + (_bgAnimation.value * 12.0);
        return Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.purple, AppColors.primaryLight],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: AppColors.purple.withValues(alpha: glowOpacity),
                blurRadius: glowRadius,
                spreadRadius: 2,
              ),
              BoxShadow(
                color: AppColors.primaryLight.withValues(alpha: glowOpacity * 0.5),
                blurRadius: glowRadius * 1.5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: child,
        );
      },
      child: const Icon(Icons.vpn_key_rounded, color: Colors.white, size: 38),
    );
  }

  /// Premium styled form card
  Widget _buildFormCard(bool isDark) {
    final s = ref.watch(stringsProvider);
    return Container(
      constraints: const BoxConstraints(maxWidth: 420),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurface.withValues(alpha: 0.8)
            : Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? AppColors.purple.withValues(alpha: 0.2)
              : AppColors.purpleLight.withValues(alpha: 0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.purple.withValues(alpha: isDark ? 0.08 : 0.06),
            blurRadius: 30,
            offset: const Offset(0, 10),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: (isDark ? Colors.black : Colors.grey).withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          // Security badge label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.purple.withValues(alpha: isDark ? 0.15 : 0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_user_outlined,
                  size: 14,
                  color: AppColors.purple,
                ),
                const SizedBox(width: 6),
                Text(
                  s.tr('SECURE ENTRY', 'دخول آمن'),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.purple,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Premium text input
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkCard.withValues(alpha: 0.6)
                  : AppColors.lightCard.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _isFocused
                    ? AppColors.purple.withValues(alpha: 0.7)
                    : (isDark ? AppColors.darkBorder : AppColors.lightBorder).withValues(alpha: 0.5),
                width: _isFocused ? 2 : 1.2,
              ),
              boxShadow: _isFocused
                  ? [
                      BoxShadow(
                        color: AppColors.purple.withValues(alpha: 0.12),
                        blurRadius: 12,
                        spreadRadius: 0,
                      ),
                    ]
                  : [],
            ),
            child: TextFormField(
              controller: _codeController,
              focusNode: _focusNode,
              textAlign: TextAlign.center,
              enabled: !_loading,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 24,
                letterSpacing: 8,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary(context),
              ),
              decoration: InputDecoration(
                hintText: s.tr('ACCESS CODE', 'رمز الدخول'),
                hintStyle: GoogleFonts.plusJakartaSans(
                  letterSpacing: 4,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textTertiary(context),
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Icon(
                    Icons.lock_outline_rounded,
                    color: _isFocused ? AppColors.purple : AppColors.textTertiary(context),
                    size: 22,
                  ),
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              ),
              onFieldSubmitted: (_) => _validateAccess(),
            ),
          ),

          // Error display
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline_rounded, color: AppColors.dangerLight, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    _error!,
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.dangerLight,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms).shakeX(hz: 3, amount: 4, duration: 400.ms),

          const SizedBox(height: 24),

          // Submit button
          GradientButton(
            text: s.tr('Verify Access', 'تأكيد الدخول'),
            icon: Icons.arrow_forward_rounded,
            width: double.infinity,
            isLoading: _loading,
            gradient: const LinearGradient(
              colors: [AppColors.purple, AppColors.primaryLight],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            onPressed: _validateAccess,
          ),
        ],
      ),
    );
  }
}
