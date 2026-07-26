import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/i18n/app_strings.dart';
import '../../../app/theme/app_colors.dart';
import '../../../providers/self_paced_provider.dart';

/// Reflects self-paced access state on-screen. iOS is web-only billing, so this NEVER shows a
/// price, a "Subscribe" button, or a purchase link (App Store policy). It only informs:
///   • on trial  → a countdown ("N days left in your free trial")
///   • lapsed     → an "access ended, manage on the website" notice
///   • otherwise  → nothing (active subscription / student / comp / enforcement off)
///
/// Website parity: mirrors the web trial banner + paywall, minus any purchase UI.
class EntitlementBanner extends ConsumerWidget {
  const EntitlementBanner({super.key});

  static const String _manageDomain = 'finplay.viftraining.com';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ent = ref.watch(selfPacedProvider).entitlement;
    final s = ref.watch(stringsProvider);

    if (ent.isLapsed) {
      return _AccessEndedCard(strings: s, domain: _manageDomain);
    }
    if (ent.isTrial && ent.enforced) {
      return _TrialCountdownCard(strings: s, days: ent.daysRemaining, domain: _manageDomain);
    }
    return const SizedBox.shrink();
  }
}

class _TrialCountdownCard extends StatelessWidget {
  const _TrialCountdownCard({required this.strings, required this.days, required this.domain});
  final AppStrings strings;
  final int days;
  final String domain;

  @override
  Widget build(BuildContext context) {
    // Urgency colour: red at ≤1 day, amber otherwise.
    final urgent = days <= 1;
    final accent = urgent ? const Color(0xFFDC2626) : const Color(0xFFD97706);
    final bg = urgent ? const Color(0xFFDC2626) : const Color(0xFFD97706);

    final headline = days <= 0
        ? strings.tr('Your free trial has ended', 'انتهت تجربتك المجانية')
        : days == 1
            ? strings.tr('1 day left in your free trial', 'يتبقى يوم واحد من تجربتك المجانية')
            : strings.tr('$days days left in your free trial', 'يتبقى $days يوماً من تجربتك المجانية');

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Icon(urgent ? Icons.timer_outlined : Icons.access_time_rounded, color: accent, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  headline,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  strings.tr(
                    'Keep full access — manage your plan at $domain',
                    'حافظ على وصولك الكامل — أدر اشتراكك على $domain',
                  ),
                  style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AccessEndedCard extends StatelessWidget {
  const _AccessEndedCard({required this.strings, required this.domain});
  final AppStrings strings;
  final String domain;

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFDC2626);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.lock_outline_rounded, color: accent, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.tr('Your access has ended', 'انتهى وصولك'),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  strings.tr(
                    'To continue learning, manage your subscription at $domain',
                    'لمواصلة التعلّم، أدر اشتراكك على $domain',
                  ),
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary(context)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Full-screen "access ended" gate — shown in place of paid content (simulation / dashboard)
/// when the backend returns 402 SUBSCRIPTION_REQUIRED. No purchase UI (App Store policy).
class AccessEndedView extends ConsumerWidget {
  const AccessEndedView({super.key, this.onBack});
  final VoidCallback? onBack;

  static const String _manageDomain = 'finplay.viftraining.com';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    const accent = Color(0xFFDC2626);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.lock_outline_rounded, color: accent, size: 36),
            ),
            const SizedBox(height: 20),
            Text(
              s.tr('Your access has ended', 'انتهى وصولك'),
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary(context),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              s.tr(
                'Your free trial or subscription is no longer active. To continue learning, manage your plan on our website:',
                'لم تعد تجربتك المجانية أو اشتراكك نشطاً. لمواصلة التعلّم، أدر خطتك على موقعنا:',
              ),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary(context), height: 1.5),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.textPrimary(context).withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _manageDomain,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary(context),
                ),
              ),
            ),
            if (onBack != null) ...[
              const SizedBox(height: 24),
              TextButton.icon(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_rounded, size: 18),
                label: Text(s.tr('Go back', 'رجوع')),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
