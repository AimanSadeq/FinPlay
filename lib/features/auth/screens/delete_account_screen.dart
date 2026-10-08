import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/i18n/app_strings.dart';
import '../../../app/theme/app_colors.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../providers/auth_provider.dart';
import '../providers/self_paced_plan_provider.dart';

/// In-app account deletion for self-paced learners (Apple guideline 5.1.1(v)).
///
/// Explains what is deleted, asks for the password, then a second confirmation.
/// POST /self-paced/delete-account; on success the session is cleared and the
/// learner lands on the mode selector.
class DeleteAccountScreen extends ConsumerStatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  ConsumerState<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends ConsumerState<DeleteAccountScreen> {
  final _passwordController = TextEditingController();
  bool _obscure = true;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _leave() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/self-paced-progress');
    }
  }

  Future<void> _submit() async {
    final s = ref.read(stringsProvider);
    final password = _passwordController.text;
    if (password.isEmpty) {
      setState(() => _error =
          s.tr('Enter your password to continue.', 'أدخل كلمة المرور للمتابعة.'));
      return;
    }
    setState(() => _error = null);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(s.tr('Delete your account?', 'هل تريد حذف حسابك؟')),
        content: Text(s.tr(
          'This permanently deletes your account and everything in it. This cannot be undone.',
          'سيؤدي هذا إلى حذف حسابك وكل ما فيه نهائيًا، ولا يمكن التراجع عن ذلك.',
        )),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(s.tr('Cancel', 'إلغاء')),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(s.tr('Delete permanently', 'حذف نهائي')),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _busy = true);
    final result = await ref.read(authProvider.notifier).deleteAccount(password);
    if (!mounted) return;

    switch (result.status) {
      case DeleteAccountStatus.success:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(s.tr('Your account has been deleted', 'تم حذف حسابك')),
        ));
        context.go('/mode-selector');
        return;
      case DeleteAccountStatus.notSignedIn:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(s.tr(
            'Your session has expired. Sign in again to delete your account.',
            'انتهت صلاحية جلستك. سجّل الدخول مرة أخرى لحذف حسابك.',
          )),
        ));
        context.go('/self-paced-login');
        return;
      case DeleteAccountStatus.wrongPassword:
        _error = s.tr('Incorrect password. Please try again.',
            'كلمة المرور غير صحيحة. يرجى المحاولة مرة أخرى.');
      case DeleteAccountStatus.demoAccount:
        _error = s.tr(
          'The shared demo account cannot be deleted.',
          'لا يمكن حذف الحساب التجريبي المشترك.',
        );
      case DeleteAccountStatus.rateLimited:
        _error = s.tr(
          'Too many attempts. Please wait a few minutes and try again.',
          'محاولات كثيرة جدًا. يرجى الانتظار بضع دقائق ثم المحاولة مرة أخرى.',
        );
      case DeleteAccountStatus.error:
        _error = s.tr(
          'We could not delete your account right now. Please try again later.',
          'تعذّر حذف حسابك الآن. يرجى المحاولة مرة أخرى لاحقًا.',
        );
    }
    setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final auth = ref.watch(authProvider);
    final user = auth.user;
    final signedIn = user != null && !auth.isFacilitator;
    // The shared Try Demo learner is provisioned on plan 'comp', so it is matched by
    // email too (the server answers 403 DEMO_ACCOUNT for it either way).
    final isDemo = signedIn &&
        (ref.watch(isDemoAccountProvider) ||
            user.plan == 'demo' ||
            user.email.toLowerCase() == 'demo-player@vifm.com');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: _busy ? null : _leave,
        ),
        title: Text(
          s.tr('Delete account', 'حذف الحساب'),
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                if (!signedIn)
                  _notice(
                    context,
                    Icons.lock_outline_rounded,
                    s.tr('Sign in to your personal account to delete it.',
                        'سجّل الدخول إلى حسابك الشخصي لتتمكن من حذفه.'),
                  )
                else if (isDemo)
                  _notice(
                    context,
                    Icons.info_outline_rounded,
                    s.tr(
                      'You are using the shared demo account, which cannot be deleted. '
                          'It stores nothing personal about you. To delete a personal account, '
                          'sign in to it and open this page again.',
                      'أنت تستخدم الحساب التجريبي المشترك، ولا يمكن حذفه، '
                          'ولا يحتفظ بأي بيانات شخصية عنك. لحذف حساب شخصي، '
                          'سجّل الدخول إليه ثم افتح هذه الصفحة مرة أخرى.',
                    ),
                  )
                else
                  ..._form(context, s, user.email),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _notice(BuildContext context, IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardColor(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderColor(context)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primaryLight),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text,
                style: TextStyle(
                    fontSize: 14, height: 1.5, color: AppColors.textPrimary(context))),
          ),
        ],
      ),
    );
  }

  List<Widget> _form(BuildContext context, AppStrings s, String email) {
    final bodyStyle =
        TextStyle(fontSize: 14, height: 1.5, color: AppColors.textSecondary(context));
    Widget bullet(String text) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(top: 7),
              child: Container(
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                    color: AppColors.danger, shape: BoxShape.circle),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(text, style: bodyStyle)),
          ]),
        );

    return [
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.danger.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.danger.withValues(alpha: 0.35)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Icon(Icons.warning_amber_rounded, color: AppColors.danger),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  s.tr('This cannot be undone', 'لا يمكن التراجع عن هذا الإجراء'),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.danger,
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 12),
            Text(
              s.tr('Deleting the account $email permanently removes:',
                  'سيؤدي حذف الحساب $email إلى إزالة ما يلي نهائيًا:'),
              style: bodyStyle.copyWith(color: AppColors.textPrimary(context)),
            ),
            const SizedBox(height: 8),
            bullet(s.tr('Your account and profile', 'حسابك وملفك الشخصي')),
            bullet(s.tr('Your learning progress', 'تقدّمك في التعلّم')),
            bullet(s.tr('Your simulation decisions and results',
                'قراراتك ونتائجك في المحاكاة')),
            bullet(s.tr('Your badges and achievements', 'شاراتك وإنجازاتك')),
            bullet(s.tr(
                'Your certificates. They will no longer verify.',
                'شهاداتك، ولن يعود بالإمكان التحقق من صحتها.')),
            const SizedBox(height: 8),
            Text(
              s.tr(
                'If you have an active subscription, it ends when your account is deleted. '
                    'Payment records are kept in anonymized form for legal and accounting reasons.',
                'إذا كان لديك اشتراك فعّال، فسينتهي عند حذف حسابك. '
                    'نحتفظ بسجلات الدفع بصيغة مجهولة الهوية لأسباب قانونية ومحاسبية.',
              ),
              style: bodyStyle,
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      Text(
        s.tr('Enter your password to confirm', 'أدخل كلمة المرور للتأكيد'),
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary(context),
        ),
      ),
      const SizedBox(height: 8),
      TextField(
        controller: _passwordController,
        obscureText: _obscure,
        enabled: !_busy,
        autofillHints: const [AutofillHints.password],
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _busy ? null : _submit(),
        onChanged: (_) {
          if (_error != null) setState(() => _error = null);
        },
        decoration: InputDecoration(
          labelText: s.tr('Password', 'كلمة المرور'),
          prefixIcon: const Icon(Icons.lock_rounded),
          errorText: _error,
          errorMaxLines: 3,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: IconButton(
            icon: Icon(_obscure ? Icons.visibility_rounded : Icons.visibility_off_rounded),
            tooltip: _obscure
                ? s.tr('Show password', 'إظهار كلمة المرور')
                : s.tr('Hide password', 'إخفاء كلمة المرور'),
            onPressed: () => setState(() => _obscure = !_obscure),
          ),
        ),
      ),
      const SizedBox(height: 20),
      SizedBox(
        height: 50,
        child: FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.danger,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: _busy ? null : _submit,
          icon: _busy
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Icon(Icons.delete_forever_rounded),
          label: Text(
            s.tr('Delete my account', 'حذف حسابي'),
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ),
      const SizedBox(height: 12),
      TextButton(
        onPressed: _busy ? null : _leave,
        child: Text(s.tr('Keep my account', 'الاحتفاظ بحسابي')),
      ),
    ];
  }
}
