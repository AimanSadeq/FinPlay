import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/i18n/app_strings.dart';
import '../../../app/theme/app_colors.dart';
import '../../../providers/repository_providers.dart';
import '../../../shared/widgets/gradient_button.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  bool _loading = false;
  bool _sent = false;
  String? _error;
  late AnimationController _bgController;

  static const _purple1 = AppColors.purple;
  static const _purple2 = AppColors.purpleLight;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _bgController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final s = ref.read(stringsProvider);
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      setState(() => _error = s.tr('Please enter a valid email', 'يرجى إدخال بريد إلكتروني صالح'));
      return;
    }

    setState(() { _loading = true; _error = null; });
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.forgotPassword(email);
      if (mounted) setState(() { _sent = true; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = s.tr('Could not send reset email', 'تعذّر إرسال بريد إعادة التعيين'); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final s = ref.watch(stringsProvider);

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
                        Color.lerp(AppColors.darkBg, const Color(0xFF2E1065), _bgController.value * 0.4)!,
                        AppColors.darkBg,
                        Color.lerp(AppColors.darkSurface, const Color(0xFF1E1B4B), _bgController.value * 0.3)!,
                      ]
                    : [
                        Color.lerp(const Color(0xFFF5F3FF), const Color(0xFFEDE9FE), _bgController.value)!,
                        Colors.white,
                        Color.lerp(Colors.white, const Color(0xFFF3E8FF), _bgController.value * 0.5)!,
                      ],
              ),
            ),
            child: child,
          );
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Back button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      onPressed: () => context.pop(),
                    ),
                  ).animate().fadeIn(duration: 300.ms),

                  const SizedBox(height: 12),

                  // Logo icon with glow
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [_purple1, _purple2]),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: _purple1.withValues(alpha: 0.35),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(
                      _sent ? Icons.mark_email_read_rounded : Icons.lock_reset_rounded,
                      color: Colors.white,
                      size: 34,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .scale(begin: const Offset(0.5, 0.5), curve: Curves.elasticOut, duration: 700.ms),

                  const SizedBox(height: 20),

                  // Title
                  Text(
                    _sent ? s.tr('Email Sent!', 'تم إرسال البريد!') : s.tr('Forgot Password', 'نسيت كلمة المرور'),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary(context),
                    ),
                  ).animate().fadeIn(delay: 150.ms),

                  const SizedBox(height: 4),

                  // Subtitle
                  Text(
                    _sent
                        ? s.tr('Check your email for a password reset link', 'تحقق من بريدك الإلكتروني للحصول على رابط إعادة تعيين كلمة المرور')
                        : s.tr('Enter your email to receive a reset link', 'أدخل بريدك الإلكتروني لتلقي رابط إعادة التعيين'),
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textTertiary(context),
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 250.ms),

                  const SizedBox(height: 32),

                  // Form / Success Card
                  if (!_sent)
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurface.withValues(alpha: 0.7)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder.withValues(alpha: 0.3) : const Color(0xFFE9D5FF),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildField(
                            controller: _emailController,
                            label: s.tr('Email', 'البريد الإلكتروني'),
                            icon: Icons.email_rounded,
                            keyboardType: TextInputType.emailAddress,
                            onSubmitted: (_) => _submit(),
                          ),

                          // Error message
                          if (_error != null)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(top: 16),
                              decoration: BoxDecoration(
                                color: AppColors.dangerLight.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.dangerLight.withValues(alpha: 0.3)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.error_outline_rounded, color: AppColors.dangerLight, size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _error!,
                                      style: const TextStyle(color: AppColors.dangerLight, fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          const SizedBox(height: 24),

                          GradientButton(
                            text: s.tr('Send Reset Link', 'إرسال رابط إعادة التعيين'),
                            icon: Icons.send_rounded,
                            width: double.infinity,
                            isLoading: _loading,
                            gradient: const LinearGradient(colors: [_purple1, _purple2]),
                            onPressed: _submit,
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 350.ms, duration: 500.ms).slideY(begin: 0.08)
                  else
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurface.withValues(alpha: 0.7)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder.withValues(alpha: 0.3) : const Color(0xFFE9D5FF),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppColors.secondary.withValues(alpha: 0.2), AppColors.secondaryLight.withValues(alpha: 0.1)],
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.check_circle_rounded, color: AppColors.secondaryLight, size: 32),
                          ).animate().scale(begin: const Offset(0, 0), curve: Curves.elasticOut, duration: 600.ms),
                          const SizedBox(height: 16),
                          Text(
                            s.tr('A reset link has been sent to', 'تم إرسال رابط إعادة التعيين إلى'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textTertiary(context),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _emailController.text.trim(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary(context),
                            ),
                          ),
                          const SizedBox(height: 24),
                          GradientButton(
                            text: s.tr('Back to Login', 'العودة لتسجيل الدخول'),
                            icon: Icons.arrow_back_rounded,
                            width: double.infinity,
                            gradient: const LinearGradient(colors: [_purple1, _purple2]),
                            onPressed: () => context.pop(),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 350.ms, duration: 500.ms).slideY(begin: 0.08),

                  const SizedBox(height: 20),

                  // Back to login link
                  if (!_sent)
                    TextButton(
                      onPressed: () => context.pop(),
                      child: Text.rich(
                        TextSpan(
                          text: s.tr('Remember your password? ', 'تتذكر كلمة المرور؟ '),
                          style: TextStyle(color: AppColors.textTertiary(context), fontSize: 14),
                          children: [
                            TextSpan(
                              text: s.tr('Sign In', 'تسجيل الدخول'),
                              style: const TextStyle(color: _purple1, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: 500.ms),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    void Function(String)? onSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      onFieldSubmitted: onSubmitted,
      style: TextStyle(fontSize: 15, color: AppColors.textPrimary(context)),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkCard.withValues(alpha: 0.5)
            : const Color(0xFFF5F3FF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: const Color(0xFFE9D5FF).withValues(alpha: 0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkBorder.withValues(alpha: 0.3)
                : const Color(0xFFE9D5FF),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _purple1, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
