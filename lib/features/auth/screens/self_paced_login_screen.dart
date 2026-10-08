
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/i18n/app_strings.dart';
import '../../../app/theme/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/repository_providers.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/services/education_progress_sync.dart';
import '../../../core/utils/constants.dart';
import '../../../data/models/user.dart';
import '../../../providers/self_paced_provider.dart';
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
  // Verified self-paced registration profile (website parity).
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _titleController = TextEditingController();
  final _companyController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _codeController = TextEditingController(); // 6-digit email verification code
  final _voucherController = TextEditingController();
  bool _isRegister = false;
  bool _obscurePassword = true;
  // Two-step sign-up: false = enter details / "Send Verification Code",
  // true = code emailed, show code field / "Verify & Create Account".
  bool _codeSent = false;
  bool _voucherRequired = false; // self-paced sign-up gated behind an access code
  bool _voucherChecking = false;
  bool? _voucherValid; // null = unchecked, true = applied, false = invalid
  String? _voucherCheckedCode;
  String? _voucherReason; // server's reason for an invalid code
  int? _voucherAccessDays; // access period a valid code grants
  bool _demoLoading = false;
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

  /// Pre-validate the typed access code and show applied/invalid feedback.
  Future<void> _validateVoucher(String raw) async {
    final code = raw.trim();
    if (code.length < 4) {
      if (mounted) {
        setState(() {
          _voucherValid = null;
          _voucherCheckedCode = null;
          _voucherReason = null;
          _voucherAccessDays = null;
        });
      }
      return;
    }
    if (code == _voucherCheckedCode) return; // already checked this exact code
    setState(() { _voucherChecking = true; });
    final res = await ref.read(authRepositoryProvider).validateVoucher(code);
    if (!mounted) return;
    // Ignore a stale result if the user kept typing.
    if (_voucherController.text.trim() != code) return;
    setState(() {
      _voucherChecking = false;
      _voucherValid = res.valid;
      _voucherReason = res.reason;
      _voucherAccessDays = res.accessDays;
      _voucherCheckedCode = code;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _titleController.dispose();
    _companyController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _codeController.dispose();
    _voucherController.dispose();
    _bgController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = ref.read(authProvider.notifier);

    if (_isRegister) {
      // Step 1: details entered but no code yet — email the verification code.
      if (!_codeSent) {
        final sent = await auth.requestVerification(_emailController.text.trim());
        if (sent && mounted) setState(() => _codeSent = true);
        return;
      }
      // Step 2: create the account with the emailed code.
      final voucher = _voucherController.text.trim();
      final success = await auth.registerSelfPaced(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        title: _titleController.text.trim(),
        company: _companyController.text.trim(),
        phone: _phoneController.text.trim(),
        city: _cityController.text.trim(),
        verificationCode: _codeController.text.trim(),
        voucherCode: voucher.isEmpty ? null : voucher,
      );
      if (success && mounted) _goOnward();
      return;
    }

    final success = await auth.loginSelfPaced(
      _emailController.text.trim(),
      _passwordController.text,
    );
    if (success && mounted) _goOnward();
  }

  /// Opened with ?return=1 (e.g. from an assessment whose session expired):
  /// pop back so the caller's screen — and its unsaved answers — survive.
  /// Otherwise land on the self-paced home.
  void _goOnward() {
    final returnHere = GoRouterState.of(context).uri.queryParameters['return'] == '1';
    if (returnHere && context.canPop()) {
      context.pop();
    } else {
      context.go('/self-paced-progress');
    }
  }

  /// Re-request a fresh verification code (server enforces a 60s cooldown and
  /// surfaces a message via auth state.error if you ask too soon).
  Future<void> _resendCode() async {
    await ref.read(authProvider.notifier).requestVerification(_emailController.text.trim());
  }

<<<<<<< Updated upstream
  /// One-tap demo: POST /self-paced/demo-login, which provisions the demo
  /// learner server-side and signs it in (website parity). The demo account
  /// has no usable password, so a password login can never reach it.
  Future<void> _tryDemo() async {
    setState(() => _isRegister = false);
    _passwordController.clear();

    final auth = ref.read(authProvider.notifier);
    final success = await auth.loginDemo();
    if (success && mounted) {
=======
  /// One-tap demo (website parity, f7c1901): the server owns the demo learner.
  /// POST /self-paced/demo-login takes no body, provisions the account on
  /// first use and signs it in; the session is then stored like a normal login.
  /// (The old demo@viftraining.com / demo@2026 pair was a client-side-only gate
  /// on the website, never a real account.)
  Future<void> _tryDemo() async {
    setState(() {
      _isRegister = false;
      _demoLoading = true;
    });
    ref.read(authProvider.notifier).clearError();
    var ok = false;
    try {
      final res = await ref.read(authRepositoryProvider).demoLogin();
      ok = await _storeDemoSession(res);
    } catch (_) {
      ok = false;
    }
    if (!mounted) return;
    setState(() => _demoLoading = false);
    if (ok) {
>>>>>>> Stashed changes
      context.go('/self-paced-progress');
    } else {
      final s = ref.read(stringsProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.tr('Demo unavailable — please try again or register', 'العرض التجريبي غير متاح — يرجى المحاولة مرة أخرى أو التسجيل'))),
      );
    }
  }

  /// Adopt the demo session through AuthNotifier, then pull the learner's
  /// saved progress like a login does.
  Future<bool> _storeDemoSession(Map<String, dynamic> res) async {
    final token = res['token'];
    final userJson = res['user'];
    if (res['success'] != true || token is! String || token.isEmpty || userJson is! Map) {
      return false;
    }
    final user = SelfPacedUser.fromJson(Map<String, dynamic>.from(userJson));
    await ref.read(authProvider.notifier).adoptSession(token, user);
    // Entitlement + game progress from /me, and the education modules.
    ref.read(selfPacedProvider.notifier).fetchProgress();
    if (user.email.isNotEmpty) {
      EducationProgressSync(ref.read(apiClientProvider))
          .hydrate(teamName: user.email, scope: 'sp');
    }
    return true;
  }

  /// "includes 1 year(s) / 90 days of full access" (website wording).
  String? _accessPeriodText(AppStrings s) {
    final days = _voucherAccessDays;
    if (days == null || days <= 0) return null;
    if (days >= 365) {
      final years = (days / 365).round();
      return s.tr('includes $years year(s) of full access',
          'يتضمن $years ${years == 1 ? 'سنة' : 'سنوات'} من الوصول الكامل');
    }
    return s.tr('includes $days days of full access',
        'يتضمن $days يومًا من الوصول الكامل');
  }

  Future<void> _openLegal(String path) async {
    await launchUrl(Uri.parse('${AppConstants.baseUrl}$path'),
        mode: LaunchMode.externalApplication);
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
                        ? s.tr('Register to start your self-paced learning journey',
                            'سجّل لتبدأ رحلة التعلّم الذاتي')
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
                          // Access Code — always offered on sign-up (website
                          // 6bdfb46): a code carries a client's prepaid access
                          // period whether or not the facilitator made codes
                          // mandatory. Required only when sign-up is gated.
                          if (_isRegister) ...[
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEF2FF), // indigo-50
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFC7D2FE)), // indigo-200
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    controller: _voucherController,
                                    textCapitalization: TextCapitalization.characters,
                                    style: GoogleFonts.jetBrainsMono(
                                        fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: 1.2),
                                    onChanged: _validateVoucher,
                                    decoration: InputDecoration(
                                      labelText: _voucherRequired
                                          ? s.tr('Access Code', 'رمز الدخول')
                                          : s.tr('Access Code (if you have one)',
                                              'رمز الدخول (إن وُجد)'),
                                      prefixIcon: const Icon(Icons.vpn_key_rounded, size: 20),
                                      suffixIcon: _voucherChecking
                                          ? const Padding(
                                              padding: EdgeInsets.all(12),
                                              child: SizedBox(
                                                  width: 16, height: 16,
                                                  child: CircularProgressIndicator(strokeWidth: 2)),
                                            )
                                          : _voucherValid == true
                                              ? const Icon(Icons.check_circle_rounded,
                                                  color: AppColors.secondary, size: 20)
                                              : _voucherValid == false
                                                  ? const Icon(Icons.error_rounded,
                                                      color: AppColors.danger, size: 20)
                                                  : null,
                                      hintText: s.tr('Enter your access code', 'أدخل رمز الدخول'),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                      filled: true,
                                      fillColor: isDark ? AppColors.darkSurface : Colors.white,
                                    ),
                                    validator: (v) => _voucherRequired &&
                                            (v == null || v.trim().isEmpty)
                                        ? s.tr('Access code required', 'رمز الدخول مطلوب')
                                        : null,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    _voucherValid == true
                                        ? (_accessPeriodText(s) == null
                                            ? s.tr('✓ Access code applied.', '✓ تم تطبيق رمز الدخول.')
                                            : s.tr('✓ Access code applied - ${_accessPeriodText(s)}.',
                                                '✓ تم تطبيق رمز الدخول - ${_accessPeriodText(s)}.'))
                                        : _voucherValid == false
                                            ? s.tr(
                                                "This access code isn't valid${_voucherReason != null ? ' ($_voucherReason)' : ''}. Please check with your facilitator.",
                                                'رمز الدخول هذا غير صالح${_voucherReason != null ? ' ($_voucherReason)' : ''}. يرجى التحقق مع الميسّر.')
                                            : _voucherRequired
                                                ? s.tr('A valid access code is required to create an account.',
                                                    'مطلوب رمز دخول صالح لإنشاء حساب.')
                                                : s.tr('Enter the code from your training provider to unlock your access period.',
                                                    'أدخل الرمز الذي زوّدك به مقدّم التدريب لتفعيل فترة وصولك.'),
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: _voucherValid == true
                                            ? AppColors.secondary
                                            : _voucherValid == false
                                                ? AppColors.danger
                                                : AppColors.textTertiary(context)),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          if (_isRegister) ...[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _buildField(
                                    controller: _firstNameController,
                                    label: s.tr('First Name', 'الاسم الأول'),
                                    icon: Icons.badge_rounded,
                                    validator: (v) => v?.trim().isEmpty == true
                                        ? s.tr('Required', 'مطلوب')
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildField(
                                    controller: _lastNameController,
                                    label: s.tr('Last Name', 'اسم العائلة'),
                                    icon: Icons.badge_outlined,
                                    validator: (v) => v?.trim().isEmpty == true
                                        ? s.tr('Required', 'مطلوب')
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],

                          _buildField(
                            controller: _emailController,
                            label: s.tr('Email', 'البريد الإلكتروني'),
                            icon: Icons.email_rounded,
                            keyboardType: TextInputType.emailAddress,
                            // Changing the email after a code was sent invalidates
                            // it — a new address needs a fresh code (website parity).
                            onChanged: _isRegister && _codeSent
                                ? (_) {
                                    setState(() {
                                      _codeSent = false;
                                      _codeController.clear();
                                    });
                                  }
                                : null,
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
                            hint: _isRegister
                                ? s.tr('Create a password (min 6 characters)',
                                    'أنشئ كلمة مرور (6 أحرف على الأقل)')
                                : null,
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
                              controller: _titleController,
                              label: s.tr('Job Title', 'المسمى الوظيفي'),
                              icon: Icons.work_rounded,
                              validator: (v) => v?.trim().isEmpty == true
                                  ? s.tr('Title required', 'المسمى الوظيفي مطلوب')
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            _buildField(
                              controller: _companyController,
                              label: s.tr('Company', 'الشركة'),
                              icon: Icons.business_rounded,
                              validator: (v) => v?.trim().isEmpty == true
                                  ? s.tr('Company required', 'الشركة مطلوبة')
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            _buildField(
                              controller: _phoneController,
                              label: s.tr('Phone', 'الهاتف'),
                              icon: Icons.phone_rounded,
                              keyboardType: TextInputType.phone,
                              validator: (v) => (v == null || v.trim().length < 5)
                                  ? s.tr('A valid phone number is required',
                                      'مطلوب رقم هاتف صالح')
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            _buildField(
                              controller: _cityController,
                              label: s.tr('City', 'المدينة'),
                              icon: Icons.location_city_rounded,
                              validator: (v) => v?.trim().isEmpty == true
                                  ? s.tr('City required', 'المدينة مطلوبة')
                                  : null,
                            ),
                            // Recovery path: _codeSent is in-memory, so a learner
                            // who received the email but relaunched the app would
                            // otherwise have no way back to the code field.
                            if (!_codeSent) ...[
                              const SizedBox(height: 12),
                              Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: TextButton(
                                  onPressed: authState.status == AuthStatus.loading
                                      ? null
                                      : () => setState(() => _codeSent = true),
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(0, 0),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    s.tr('Already received a verification code? Enter it here',
                                        'استلمت رمز التحقق بالفعل؟ أدخله هنا'),
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: _blue600,
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                              ),
                            ],
                            // Step 2: verification code field + resend, shown once
                            // the 6-digit code has been emailed.
                            if (_codeSent) ...[
                              const SizedBox(height: 16),
                              _buildField(
                                controller: _codeController,
                                label: s.tr('Verification Code', 'رمز التحقق'),
                                icon: Icons.mark_email_read_rounded,
                                keyboardType: TextInputType.number,
                                validator: (v) => v?.trim().isEmpty == true
                                    ? s.tr('Enter the 6-digit code', 'أدخل الرمز المكوّن من 6 أرقام')
                                    : null,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      s.tr(
                                        'Code sent to ${_emailController.text.trim()}. It expires in 15 minutes.',
                                        'تم إرسال الرمز إلى ${_emailController.text.trim()}. تنتهي صلاحيته خلال 15 دقيقة.',
                                      ),
                                      style: TextStyle(
                                          fontSize: 11, color: AppColors.textTertiary(context)),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: authState.status == AuthStatus.loading
                                        ? null
                                        : _resendCode,
                                    child: Text(s.tr('Resend', 'إعادة إرسال'),
                                        style: const TextStyle(
                                            color: _blue600, fontWeight: FontWeight.w600)),
                                  ),
                                ],
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

                          // Submit — label reflects the two-step sign-up flow.
                          GradientButton(
                            text: !_isRegister
                                ? s.tr('Sign In', 'تسجيل الدخول')
                                : (_codeSent
                                    ? s.tr('Verify & Create Account', 'تحقّق وأنشئ الحساب')
                                    : s.tr('Send Verification Code', 'إرسال رمز التحقق')),
                            icon: !_isRegister
                                ? Icons.login_rounded
                                : (_codeSent ? Icons.person_add_rounded : Icons.send_rounded),
                            isLoading: authState.status == AuthStatus.loading,
                            width: double.infinity,
                            gradient: const LinearGradient(colors: [_blue600, _blue700]),
                            onPressed: _submit,
                          ),

                          // Registration is the moment the agreement is formed, so
                          // the terms are named here (website 1b9d367). Register
                          // mode only: signing in again is not a fresh acceptance.
                          if (_isRegister) ...[
                            const SizedBox(height: 10),
                            _buildTermsNotice(s),
                          ],

                          const SizedBox(height: 12),

                          // Try Demo — one-tap login with the public demo account.
                          OutlinedButton.icon(
                            onPressed: authState.status == AuthStatus.loading || _demoLoading
                                ? null
                                : _tryDemo,
                            icon: _demoLoading
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2))
                                : const Icon(Icons.sports_esports_rounded, size: 18),
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
                      // Reset the verification step when switching modes.
                      _codeSent = false;
                      _codeController.clear();
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

  Widget _buildTermsNotice(AppStrings s) {
    final base = TextStyle(fontSize: 11, height: 1.5, color: AppColors.textTertiary(context));
    final link = base.copyWith(
        decoration: TextDecoration.underline, color: AppColors.textSecondary(context));
    Widget linkText(String label, String path) => GestureDetector(
          onTap: () => _openLegal(path),
          child: Text(label, style: link),
        );
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(s.tr('By creating an account you agree to our ', 'بإنشاء حساب فإنك توافق على '),
            style: base),
        linkText(s.tr('Terms of Service', 'شروط الخدمة'), '/terms'),
        Text(s.tr(' and ', ' و'), style: base),
        linkText(s.tr('Privacy Policy', 'سياسة الخصوصية'), '/privacy'),
        Text('.', style: base),
      ],
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscure = false,
    Widget? suffix,
    String? hint,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      validator: validator,
      onChanged: onChanged,
      style: TextStyle(fontSize: 15, color: AppColors.textPrimary(context)),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
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
