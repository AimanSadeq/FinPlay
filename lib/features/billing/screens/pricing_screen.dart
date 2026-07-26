import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/i18n/app_strings.dart';
import '../../../app/theme/app_colors.dart';
import '../../../data/models/billing_plan.dart';
import '../../../providers/repository_providers.dart';

/// Self-paced subscription plans (AED), fetched from /billing/plans — the same source that
/// charges the card, so the displayed price always matches what's billed. Picking a plan hands
/// off to the MamoPay hosted checkout (CheckoutScreen).
class PricingScreen extends ConsumerStatefulWidget {
  const PricingScreen({super.key});

  @override
  ConsumerState<PricingScreen> createState() => _PricingScreenState();
}

class _PricingScreenState extends ConsumerState<PricingScreen> {
  bool _loading = true;
  String? _error;
  bool _configured = false;
  List<BillingPlan> _plans = const [];
  String? _selected;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final res = await ref.read(billingRepositoryProvider).fetchPlans();
      if (!mounted) return;
      setState(() {
        _configured = res.configured;
        _plans = res.plans;
        _selected = res.plans.isNotEmpty ? res.plans.first.id : null;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() { _error = 'load'; _loading = false; });
    }
  }

  String _curLabel(String c, bool ar) => ar ? (c == 'AED' ? 'د.إ' : c) : c;

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [AppColors.darkBg, AppColors.darkSurface]
                : [const Color(0xFFF0F4FF), const Color(0xFFF5F0FF), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      onPressed: () => context.canPop() ? context.pop() : context.go('/home'),
                    ),
                    Expanded(
                      child: Text(
                        s.tr('Subscription', 'الاشتراك'),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _error != null
                        ? _errorView(s)
                        : !_configured
                            ? _notConfiguredView(s)
                            : _content(s),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _errorView(AppStrings s) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(s.tr('Could not load plans.', 'تعذّر تحميل الخطط.'),
                style: TextStyle(color: AppColors.textSecondary(context))),
            const SizedBox(height: 12),
            TextButton(onPressed: _load, child: Text(s.tr('Retry', 'إعادة المحاولة'))),
          ],
        ),
      );

  Widget _notConfiguredView(AppStrings s) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            s.tr('Payments are not available right now. Please try again later.',
                'المدفوعات غير متاحة حالياً. يرجى المحاولة لاحقاً.'),
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary(context)),
          ),
        ),
      );

  Widget _content(AppStrings s) {
    final ar = s.ar;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            s.tr('Self-Paced Learning', 'التعلّم الذاتي'),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary(context),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            s.tr('Full access to all modules, the simulation, AI tutor and your certificate.',
                'وصول كامل لجميع الوحدات والمحاكاة والمدرّس الذكي وشهادتك.'),
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary(context)),
          ),
          const SizedBox(height: 20),
          ..._plans.map((p) => _planCard(p, ar)),
          const SizedBox(height: 20),
          _ContinueButton(
            enabled: _selected != null,
            label: s.tr('Continue to payment', 'المتابعة للدفع'),
            onTap: () {
              if (_selected != null) context.push('/billing-checkout?plan=$_selected');
            },
          ),
          const SizedBox(height: 12),
          Text(
            s.tr('Secure payment via Mamo — mada, Visa/Mastercard & Apple Pay.',
                'دفع آمن عبر Mamo — مدى وفيزا/ماستركارد و Apple Pay.'),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: AppColors.textTertiary(context)),
          ),
        ],
      ),
    );
  }

  Widget _planCard(BillingPlan p, bool ar) {
    final selected = _selected == p.id;
    final accent = AppColors.purple;
    return GestureDetector(
      onTap: () => setState(() => _selected = p.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: selected
              ? accent.withValues(alpha: 0.07)
              : (Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkSurface.withValues(alpha: 0.5)
                  : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? accent : AppColors.textTertiary(context).withValues(alpha: 0.25),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: selected ? accent : AppColors.textTertiary(context)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ar ? p.labelAr : p.labelEn,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15, fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  if (p.isYearly)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        ar ? 'وفّر باختيار الخطة السنوية' : 'Best value — billed yearly',
                        style: TextStyle(fontSize: 12, color: AppColors.secondaryLight),
                      ),
                    ),
                ],
              ),
            ),
            Text(
              '${p.amountText} ${_curLabel(p.currency, ar)}',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  const _ContinueButton({required this.enabled, required this.label, required this.onTap});
  final bool enabled;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [AppColors.purple, AppColors.purpleLight]),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white,
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}
