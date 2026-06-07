import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/i18n/app_strings.dart';
import '../../../app/theme/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/repository_providers.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../shared/widgets/gradient_button.dart';

class SelfPacedLoginScreen extends ConsumerStatefulWidget {
  const SelfPacedLoginScreen({super.key});

  @override
  ConsumerState<SelfPacedLoginScreen> createState() => _SelfPacedLoginScreenState();
}

class _SelfPacedLoginScreenState extends ConsumerState<SelfPacedLoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _teamNameController = TextEditingController();
  final _voucherController = TextEditingController();
  bool _isRegister = false;
  bool _obscurePassword = true;
  bool _voucherRequired = false; // self-paced sign-up gated behind an access code
  late AnimationController _bgController;

  // Blue theme matching website (bg-blue-600, from-blue-50, to-indigo-100)
  static const _blue600 = Color(0xFF2563EB);
  static const _blue700 = Color(0xFF1D4ED8);
  static const _blue50 = Color(0xFFEFF6FF);
  static const _indigo100 = Color(0xFFE0E7FF);
  static const _blue100 = Color(0xFFDBEAFE);

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);
    _checkVoucherGating();
  }

  /// If self-paced sign-up is gated behind an access code, show the code field
  /// and default new visitors to the Register view (website parity).
  Future<void> _checkVoucherGating() async {
    final required = await ref.read(facilitatorRepositoryProvider).fetchVoucherGating();
    if (mounted && required) {
      setState(() {
        _voucherRequired = true;
        _isRegister = true;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _teamNameController.dispose();
    _voucherController.dispose();
    _bgController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = ref.read(authProvider.notifier);
    bool success;

    if (_isRegister) {
      final teamName = _teamNameController.text.trim();
      final voucher = _voucherController.text.trim();
      success = await auth.registerSelfPaced(
        _emailController.text.trim(),
        _passwordController.text,
        _nameController.text.trim(),
        teamName: teamName.isEmpty ? null : teamName,
        voucherCode: voucher.isEmpty ? null : voucher,
      );
    } else {
      success = await auth.loginSelfPaced(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }

    if (success && mounted) {
      context.go('/self-paced-progress');
    }
  }

  /// One-tap demo, matching the website's demo-mode.js exactly: try to log in
  /// the demo user, and if that fails (account doesn't exist yet), register it,
  /// then continue. Credentials: demo@viftraining.com / demo@2026.
  Future<void> _tryDemo() async {
    const demoEmail = 'demo@viftraining.com';
    const demoPassword = 'demo@2026';
    setState(() => _isRegister = false);
    _emailController.text = demoEmail;
    _passwordController.text = demoPassword;

    final auth = ref.read(authProvider.notifier);
    var success = await auth.loginSelfPaced(demoEmail, demoPassword);
    if (!success) {
      // Login failed — register the demo user (web does the same). The register
      // flow logs the user in on success.
      success = await auth.registerSelfPaced(
        demoEmail,
        demoPassword,
        'Demo User',
        teamName: 'Demo Team',
      );
      // If register failed because the account already exists (i.e. the earlier
      // login was a transient miss), try logging in once more.
      if (!success) {
        success = await auth.loginSelfPaced(demoEmail, demoPassword);
      }
    }
    if (success && mounted) {
      context.go('/self-paced-progress');
    } else if (mounted) {
      final s = ref.read(stringsProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.tr('Demo unavailable — please try again or register', 'العرض التجريبي غير متاح — يرجى المحاولة مرة أخرى أو التسجيل'))),
      );
    }
  }

  Future<void> _showRequestDemo() async {
    final name = TextEditingController();
    final email = TextEditingController();
    final company = TextEditingController();
    final phone = TextEditingController();
    final message = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool sending = false;
    String? note;
    final s = ref.read(stringsProvider);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E293B) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.tr('Request a Demo', 'اطلب عرضًا تجريبيًا'),
                    style: Theme.of(ctx).textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(s.tr('We will get back to you shortly.', 'سنتواصل معك قريبًا.'),
                    style: Theme.of(ctx).textTheme.bodySmall),
                const SizedBox(height: 16),
                _demoField(name, s.tr('Full name', 'الاسم الكامل'), required: true),
                _demoField(email, s.tr('Work email', 'بريد العمل الإلكتروني'),
                    required: true, keyboard: TextInputType.emailAddress),
                _demoField(company, s.tr('Company', 'الشركة')),
                _demoField(phone, s.tr('Phone', 'الهاتف'), keyboard: TextInputType.phone),
                _demoField(message, s.tr('Message', 'الرسالة'), maxLines: 3),
                if (note != null) ...[
                  const SizedBox(height: 8),
                  Text(note!, style: const TextStyle(color: _blue600, fontSize: 13)),
                ],
                const SizedBox(height: 16),
                GradientButton(
                  text: s.tr('Send Request', 'إرسال الطلب'),
                  icon: Icons.send_rounded,
                  isLoading: sending,
                  width: double.infinity,
                  gradient: const LinearGradient(colors: [_blue600, _blue700]),
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;
                    setSheet(() => sending = true);
                    try {
                      await ref.read(apiClientProvider).post(
                        ApiEndpoints.demoRequest,
                        data: {
                          'name': name.text.trim(),
                          'email': email.text.trim(),
                          'company': company.text.trim(),
                          'phone': phone.text.trim(),
                          'message': message.text.trim(),
                        },
                      );
                      if (ctx.mounted) Navigator.pop(ctx);
                    } catch (_) {
                      setSheet(() {
                        sending = false;
                        note = s.tr('Could not send right now — please email us directly.', 'تعذّر الإرسال الآن — يرجى مراسلتنا عبر البريد مباشرة.');
                      });
                    }
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _demoField(TextEditingController c, String label,
      {bool required = false, int maxLines = 1, TextInputType? keyboard}) {
    final s = ref.read(stringsProvider);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        maxLines: maxLines,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: required ? '$label *' : label,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
        validator: required
            ? (v) => (v == null || v.trim().isEmpty) ? s.tr('Required', 'مطلوب') : null
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final s = ref.watch(stringsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                        Color.lerp(AppColors.darkBg, const Color(0xFF1E3A5F), _bgController.value * 0.4)!,
                        AppColors.darkBg,
                        Color.lerp(AppColors.darkSurface, const Color(0xFF1E2A4A), _bgController.value * 0.3)!,
                      ]
                    : [
                        Color.lerp(_blue50, _indigo100, _bgController.value)!,
                        Colors.white,
                        Color.lerp(Colors.white, _blue100, _bgController.value * 0.5)!,
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
                  // Top nav
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      onPressed: () => context.pop(),
                    ),
                  ).animate().fadeIn(duration: 300.ms),

                  const SizedBox(height: 12),

                  // Logo – solid blue circle like website
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: _blue600,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _blue600.withValues(alpha: 0.35),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(
                      _isRegister ? Icons.person_add_rounded : Icons.login_rounded,
                      color: Colors.white,
                      size: 34,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .scale(begin: const Offset(0.5, 0.5), curve: Curves.elasticOut, duration: 700.ms),

                  const SizedBox(height: 20),

                  Text(
                    _isRegister ? s.tr('Create Account', 'إنشاء حساب') : s.tr('Welcome Back', 'مرحبًا بعودتك'),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary(context),
                    ),
                  ).animate().fadeIn(delay: 150.ms),

                  const SizedBox(height: 4),

                  Text(
                    _isRegister
                        ? s.tr('Start your finance learning journey', 'ابدأ رحلتك في تعلّم المالية')
                        : s.tr('Sign in to continue your progress', 'سجّل الدخول لمتابعة تقدّمك'),
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textTertiary(context),
                    ),
                  ).animate().fadeIn(delay: 250.ms),

                  const SizedBox(height: 32),

                  // Form Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurface.withValues(alpha: 0.7)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder.withValues(alpha: 0.3) : const Color(0xFFBFDBFE),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          if (_isRegister) ...[
                            _buildField(
                              controller: _nameController,
                              label: s.tr('Display Name', 'الاسم الظاهر'),
                              icon: Icons.badge_rounded,
                              validator: (v) => v?.isEmpty == true ? s.tr('Name required', 'الاسم مطلوب') : null,
                            ),
                            const SizedBox(height: 16),
                          ],

                          _buildField(
                            controller: _emailController,
                            label: s.tr('Email', 'البريد الإلكتروني'),
                            icon: Icons.email_rounded,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v?.isEmpty == true) return s.tr('Email required', 'البريد الإلكتروني مطلوب');
                              if (!v!.contains('@')) return s.tr('Invalid email', 'بريد إلكتروني غير صالح');
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          _buildField(
                            controller: _passwordController,
                            label: s.tr('Password', 'كلمة المرور'),
                            icon: Icons.lock_rounded,
                            obscure: _obscurePassword,
                            suffix: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                                size: 20,
                                color: AppColors.textTertiary(context),
                              ),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                            validator: (v) {
                              if (v?.isEmpty == true) return s.tr('Password required', 'كلمة المرور مطلوبة');
                              if (v!.length < 6) return s.tr('Min 6 characters', '6 أحرف على الأقل');
                              return null;
                            },
                          ),

                          if (_isRegister) ...[
                            const SizedBox(height: 16),
                            _buildField(
                              controller: _teamNameController,
                              label: s.tr('Team Name (Optional)', 'اسم الفريق (اختياري)'),
                              icon: Icons.group_rounded,
                            ),
                            if (_voucherRequired) ...[
                              const SizedBox(height: 16),
                              _buildField(
                                controller: _voucherController,
                                label: s.tr('Access Code *', 'رمز الدخول *'),
                                icon: Icons.vpn_key_rounded,
                                validator: (v) => (v == null || v.trim().isEmpty)
                                    ? s.tr('Access code required', 'رمز الدخول مطلوب')
                                    : null,
                              ),
                            ],
                          ],

                          const SizedBox(height: 24),

                          // Error message
                          if (authState.error != null)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(bottom: 16),
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
                                      authState.error!,
                                      style: const TextStyle(color: AppColors.dangerLight, fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          // Submit
                          GradientButton(
                            text: _isRegister ? s.tr('Create Account', 'إنشاء حساب') : s.tr('Sign In', 'تسجيل الدخول'),
                            icon: _isRegister ? Icons.person_add_rounded : Icons.login_rounded,
                            isLoading: authState.status == AuthStatus.loading,
                            width: double.infinity,
                            gradient: const LinearGradient(colors: [_blue600, _blue700]),
                            onPressed: _submit,
                          ),

                          const SizedBox(height: 12),

                          // Try Demo — one-tap login with the public demo account.
                          OutlinedButton.icon(
                            onPressed: authState.status == AuthStatus.loading ? null : _tryDemo,
                            icon: const Icon(Icons.sports_esports_rounded, size: 18),
                            label: Text(s.tr('Try Demo', 'تجربة العرض التوضيحي')),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                              foregroundColor: AppColors.secondaryLight,
                              side: BorderSide(color: AppColors.secondaryLight.withValues(alpha: 0.5)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: 350.ms, duration: 500.ms).slideY(begin: 0.08),

                  const SizedBox(height: 20),

                  // Toggle + Forgot
                  TextButton(
                    onPressed: () => setState(() {
                      _isRegister = !_isRegister;
                      ref.read(authProvider.notifier).clearError();
                    }),
                    child: Text.rich(
                      TextSpan(
                        text: _isRegister ? s.tr('Already have an account? ', 'لديك حساب بالفعل؟ ') : s.tr("Don't have an account? ", 'ليس لديك حساب؟ '),
                        style: TextStyle(color: AppColors.textTertiary(context), fontSize: 14),
                        children: [
                          TextSpan(
                            text: _isRegister ? s.tr('Sign In', 'تسجيل الدخول') : s.tr('Register', 'إنشاء حساب'),
                            style: const TextStyle(color: _blue600, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: 500.ms),

                  TextButton(
                    onPressed: _showRequestDemo,
                    child: Text(
                      s.tr('Request a Demo', 'اطلب عرضًا تجريبيًا'),
                      style: TextStyle(fontSize: 13, color: AppColors.textTertiary(context)),
                    ),
                  ),

                  if (!_isRegister)
                    TextButton(
                      onPressed: () => context.push('/forgot-password'),
                      child: Text(
                        s.tr('Forgot Password?', 'نسيت كلمة المرور؟'),
                        style: TextStyle(fontSize: 13, color: AppColors.textTertiary(context)),
                      ),
                    ).animate().fadeIn(delay: 550.ms),

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
    bool obscure = false,
    Widget? suffix,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      validator: validator,
      style: TextStyle(fontSize: 15, color: AppColors.textPrimary(context)),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        suffixIcon: suffix,
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkCard.withValues(alpha: 0.5)
            : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: const Color(0xFFBFDBFE).withValues(alpha: 0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkBorder.withValues(alpha: 0.3)
                : const Color(0xFFE2E8F0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _blue600, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
