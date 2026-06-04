import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/i18n/app_strings.dart';
import '../../../app/theme/app_colors.dart';
import '../../../providers/repository_providers.dart';
import '../../../shared/widgets/gradient_button.dart';

/// Reset password using the token from the email link (/reset-password?token=…).
class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String? token;
  const ResetPasswordScreen({super.key, this.token});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _loading = false;
  bool _done = false;
  bool _invalidToken = false;
  String? _error;

  static const _purple1 = AppColors.purple;
  static const _purple2 = AppColors.purpleLight;

  @override
  void initState() {
    super.initState();
    _invalidToken = (widget.token == null || widget.token!.trim().isEmpty);
  }

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final s = ref.read(stringsProvider);
    final pw = _password.text;
    final cf = _confirm.text;
    if (pw.length < 6) {
      setState(() => _error = s.tr('Password must be at least 6 characters', 'يجب أن تتكوّن كلمة المرور من 6 أحرف على الأقل'));
      return;
    }
    if (pw != cf) {
      setState(() => _error = s.tr('Passwords do not match', 'كلمتا المرور غير متطابقتين'));
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final repo = ref.read(authRepositoryProvider);
      final res = await repo.resetPassword(token: widget.token!, password: pw);
      if (!mounted) return;
      if (res['success'] == true) {
        setState(() {
          _done = true;
          _loading = false;
        });
      } else {
        final err = (res['error'] ?? '').toString().toLowerCase();
        setState(() {
          _loading = false;
          if (err.contains('expired') || err.contains('invalid')) {
            _invalidToken = true;
          } else {
            _error = s.tr('Could not reset password. Please try again.', 'تعذّر إعادة تعيين كلمة المرور. يرجى المحاولة مرة أخرى.');
          }
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = s.tr('Network error. Please try again.', 'خطأ في الشبكة. يرجى المحاولة مرة أخرى.');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final s = ref.watch(stringsProvider);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF1E1B4B), AppColors.darkBg, AppColors.darkSurface]
                : [const Color(0xFFF5F3FF), Colors.white, const Color(0xFFF3E8FF)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      gradient:
                          const LinearGradient(colors: [_purple1, _purple2]),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: _purple1.withValues(alpha: 0.35),
                            blurRadius: 24,
                            offset: const Offset(0, 8)),
                      ],
                    ),
                    child: Icon(
                      _done
                          ? Icons.check_circle_rounded
                          : _invalidToken
                              ? Icons.link_off_rounded
                              : Icons.lock_reset_rounded,
                      color: Colors.white,
                      size: 34,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .scale(
                          begin: const Offset(0.5, 0.5),
                          curve: Curves.elasticOut,
                          duration: 700.ms),
                  const SizedBox(height: 20),
                  Text(
                    _done
                        ? s.tr('Password Reset Complete', 'تمت إعادة تعيين كلمة المرور')
                        : _invalidToken
                            ? s.tr('Invalid or Expired Link', 'رابط غير صالح أو منتهي الصلاحية')
                            : s.tr('Set a New Password', 'تعيين كلمة مرور جديدة'),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary(context)),
                  ).animate().fadeIn(delay: 150.ms),
                  const SizedBox(height: 6),
                  Text(
                    _done
                        ? s.tr('You can now sign in with your new password.', 'يمكنك الآن تسجيل الدخول بكلمة المرور الجديدة.')
                        : _invalidToken
                            ? s.tr('This reset link is no longer valid. Request a new one.', 'لم يعد رابط إعادة التعيين صالحًا. اطلب رابطًا جديدًا.')
                            : s.tr('Choose a strong password you have not used before.', 'اختر كلمة مرور قوية لم تستخدمها من قبل.'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14, color: AppColors.textTertiary(context)),
                  ).animate().fadeIn(delay: 250.ms),
                  const SizedBox(height: 28),
                  _card(isDark, child: _content()),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _content() {
    final s = ref.watch(stringsProvider);
    if (_done) {
      return GradientButton(
        text: s.tr('Sign In with New Password', 'تسجيل الدخول بكلمة المرور الجديدة'),
        icon: Icons.login_rounded,
        width: double.infinity,
        gradient: const LinearGradient(colors: [_purple1, _purple2]),
        onPressed: () => context.go('/self-paced-login'),
      );
    }
    if (_invalidToken) {
      return Column(
        children: [
          GradientButton(
            text: s.tr('Request New Link', 'طلب رابط جديد'),
            icon: Icons.mail_outline_rounded,
            width: double.infinity,
            gradient: const LinearGradient(colors: [_purple1, _purple2]),
            onPressed: () => context.go('/forgot-password'),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => context.go('/self-paced-login'),
            child: Text(s.tr('Back to Sign In', 'العودة لتسجيل الدخول'),
                style: const TextStyle(color: _purple1)),
          ),
        ],
      );
    }
    return Column(
      children: [
        _field(_password, s.tr('New password', 'كلمة المرور الجديدة'), Icons.lock_rounded),
        const SizedBox(height: 14),
        _field(_confirm, s.tr('Confirm password', 'تأكيد كلمة المرور'), Icons.lock_outline_rounded),
        if (_error != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
              color: AppColors.dangerLight.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(color: AppColors.dangerLight.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline_rounded,
                    color: AppColors.dangerLight, size: 18),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(_error!,
                        style: const TextStyle(
                            color: AppColors.dangerLight, fontSize: 13))),
              ],
            ),
          ),
        const SizedBox(height: 24),
        GradientButton(
          text: s.tr('Reset Password', 'إعادة تعيين كلمة المرور'),
          icon: Icons.check_rounded,
          width: double.infinity,
          isLoading: _loading,
          gradient: const LinearGradient(colors: [_purple1, _purple2]),
          onPressed: _submit,
        ),
      ],
    );
  }

  Widget _card(bool isDark, {required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurface.withValues(alpha: 0.7)
            : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: isDark
                ? AppColors.darkBorder.withValues(alpha: 0.3)
                : const Color(0xFFE9D5FF)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
              blurRadius: 20,
              offset: const Offset(0, 6)),
        ],
      ),
      child: child,
    ).animate().fadeIn(delay: 350.ms, duration: 500.ms).slideY(begin: 0.08);
  }

  Widget _field(
      TextEditingController controller, String label, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextField(
      controller: controller,
      obscureText: true,
      style: TextStyle(fontSize: 15, color: AppColors.textPrimary(context)),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        filled: true,
        fillColor: isDark
            ? AppColors.darkCard.withValues(alpha: 0.5)
            : const Color(0xFFF5F3FF),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: isDark
                  ? AppColors.darkBorder.withValues(alpha: 0.3)
                  : const Color(0xFFE9D5FF)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _purple1, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
