import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../app/i18n/app_strings.dart';
import '../../../app/theme/app_colors.dart';
import '../../../providers/repository_providers.dart';
import '../../../providers/self_paced_provider.dart';

/// Hosted MamoPay checkout for a self-paced plan.
///
/// Flow: POST /billing/checkout → load Mamo's payment_url in a WebView → the page redirects to
/// the site return URL (…/checkout?return=1) on completion → we intercept it, then POST
/// /billing/verify (confirms with Mamo and grants) and refresh entitlement. No card data touches
/// the app; Mamo's page handles it.
class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key, required this.planId});
  final String planId;

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

enum _Phase { creating, paying, verifying, done, failed, error }

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  _Phase _phase = _Phase.creating;
  String? _error;
  WebViewController? _web;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    try {
      final res = await ref.read(billingRepositoryProvider).createCheckout(widget.planId);
      if (!res.success || res.paymentUrl == null) {
        _fail(res.error);
        return;
      }
      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onNavigationRequest: (request) {
              final url = request.url;
              // Mamo redirects back to the site's return page when the payment resolves.
              if (url.contains('/checkout') && url.contains('return=1')) {
                if (url.contains('failed=1')) {
                  _onFailed();
                } else {
                  _onReturned();
                }
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(res.paymentUrl!));
      if (!mounted) return;
      setState(() { _web = controller; _phase = _Phase.paying; });
    } catch (_) {
      _fail(null);
    }
  }

  void _fail(String? error) {
    if (!mounted) return;
    setState(() { _phase = _Phase.error; _error = error; });
  }

  void _onFailed() {
    if (!mounted) return;
    setState(() => _phase = _Phase.failed);
  }

  // Confirm + grant. Verify directly first (no webhook needed), then poll status briefly.
  Future<void> _onReturned() async {
    if (!mounted || _phase == _Phase.verifying || _phase == _Phase.done) return;
    setState(() => _phase = _Phase.verifying);
    final repo = ref.read(billingRepositoryProvider);
    bool active(ent) => ent != null && ent.active && ent.reason == 'subscription';
    try {
      final ent = await repo.verify();
      if (active(ent)) return _succeed();
    } catch (_) {/* fall through to polling */}

    for (var i = 0; i < 6; i++) {
      await Future.delayed(const Duration(milliseconds: 2000));
      if (!mounted) return;
      try {
        final ent = await repo.status();
        if (active(ent)) return _succeed();
      } catch (_) {/* keep polling */}
    }
    // Paid but not yet reflected — tell the user it will activate shortly.
    if (mounted) setState(() { _phase = _Phase.error; _error = 'pending'; });
  }

  Future<void> _succeed() async {
    // Refresh the self-paced entitlement so the hub unlocks immediately.
    await ref.read(selfPacedProvider.notifier).fetchProgress();
    if (mounted) setState(() => _phase = _Phase.done);
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.canPop() ? context.pop() : context.go('/home'),
        ),
        title: Text(
          s.tr('Checkout', 'الدفع'),
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary(context),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [AppColors.darkBg, AppColors.darkSurface]
                : [const Color(0xFFF0F4FF), Colors.white],
          ),
        ),
        child: SafeArea(child: _body(s)),
      ),
    );
  }

  Widget _body(AppStrings s) {
    switch (_phase) {
      case _Phase.paying:
        return _web != null ? WebViewWidget(controller: _web!) : _spinner(s.tr('Loading…', 'جارٍ التحميل…'));
      case _Phase.creating:
        return _spinner(s.tr('Starting secure checkout…', 'جارٍ بدء الدفع الآمن…'));
      case _Phase.verifying:
        return _spinner(s.tr('Confirming your payment…', 'جارٍ تأكيد الدفع…'));
      case _Phase.done:
        return _result(
          icon: Icons.check_circle_rounded,
          color: AppColors.secondaryLight,
          title: s.tr('Your subscription is active!', 'تم تفعيل اشتراكك!'),
          body: s.tr('You now have full access.', 'لديك الآن وصول كامل.'),
          cta: s.tr('Start learning', 'ابدأ التعلّم'),
          onCta: () => context.go('/home'),
        );
      case _Phase.failed:
        return _result(
          icon: Icons.cancel_rounded,
          color: const Color(0xFFDC2626),
          title: s.tr('Payment not completed', 'لم تكتمل عملية الدفع'),
          body: s.tr('You were not charged. You can try again.', 'لم يتم خصم أي مبلغ. يمكنك المحاولة مرة أخرى.'),
          cta: s.tr('Back', 'رجوع'),
          onCta: () => context.canPop() ? context.pop() : context.go('/home'),
        );
      case _Phase.error:
        return _result(
          icon: Icons.info_outline_rounded,
          color: const Color(0xFFD97706),
          title: _error == 'pending'
              ? s.tr('Almost there', 'اقتربنا')
              : s.tr('Something went wrong', 'حدث خطأ ما'),
          body: _error == 'pending'
              ? s.tr('If your payment went through, access activates within a few minutes.',
                  'إذا تم الدفع، فسيُفعّل وصولك خلال دقائق.')
              : s.tr('Could not start checkout. Please try again.',
                  'تعذّر بدء الدفع. يرجى المحاولة مرة أخرى.'),
          cta: s.tr('Back', 'رجوع'),
          onCta: () => context.canPop() ? context.pop() : context.go('/home'),
        );
    }
  }

  Widget _spinner(String label) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(label, style: TextStyle(color: AppColors.textSecondary(context))),
          ],
        ),
      );

  Widget _result({
    required IconData icon,
    required Color color,
    required String title,
    required String body,
    required String cta,
    required VoidCallback onCta,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 64),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary(context),
              ),
            ),
            const SizedBox(height: 8),
            Text(body, textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary(context))),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onCta,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.purple,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(cta),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
