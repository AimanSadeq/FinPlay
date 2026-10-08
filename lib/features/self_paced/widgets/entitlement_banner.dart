import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/i18n/app_strings.dart';
import '../../../app/theme/app_colors.dart';
import '../../../data/models/entitlement.dart';
import '../../../providers/self_paced_provider.dart';
import '../../auth/providers/self_paced_plan_provider.dart';

/// Someone who had prepaid (voucher) or paid (self_paced) access never had a
/// "free trial" to end, so their lapsed notice speaks of the access period
/// (website home.tsx, d7b7752).
bool hadPaidAccess(String? plan) => plan == 'voucher' || plan == 'self_paced';

/// Prepaid (voucher) access is dated too, but its learners are reminded only in
/// the last two weeks — not on every visit of a year-long grant (website).
bool isVoucherEnding(Entitlement ent, String? plan) =>
    ent.reason == 'subscription' &&
    plan == 'voucher' &&
    ent.accessUntil != null &&
    ent.daysRemaining <= 14;

/// Reflects self-paced access state and offers to subscribe (in-app MamoPay checkout):
///   • on trial  → a countdown ("N days left") + a Subscribe button
///   • voucher in its last 14 days → "Your access ends in N days" + Subscribe
///   • lapsed     → an "access ended" notice + a Subscribe button (worded for the
///                  access period, not the free trial, when the learner had paid
///                  or prepaid access)
///   • otherwise  → nothing (active subscription / student / comp / enforcement off)
class EntitlementBanner extends ConsumerWidget {
  const EntitlementBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ent = ref.watch(selfPacedProvider).entitlement;
    final plan = ref.watch(selfPacedPlanProvider);
    final s = ref.watch(stringsProvider);

    if (ent.isLapsed) {
      return _AccessEndedCard(strings: s, paidAccess: hadPaidAccess(plan));
    }
    if (ent.isTrial && ent.enforced) {
      return _TrialCountdownCard(strings: s, days: ent.daysRemaining);
    }
    if (ent.enforced && isVoucherEnding(ent, plan)) {
      return _TrialCountdownCard(strings: s, days: ent.daysRemaining, voucher: true);
    }
    return const SizedBox.shrink();
  }
}

class _TrialCountdownCard extends StatelessWidget {
  const _TrialCountdownCard({required this.strings, required this.days, this.voucher = false});
  final AppStrings strings;
  final int days;
  final bool voucher; // prepaid access ending, not a free trial

  @override
  Widget build(BuildContext context) {
    final urgent = days <= 1;
    final accent = urgent ? const Color(0xFFDC2626) : const Color(0xFFD97706);

    final headline = voucher
        // Website wording: "Your access ends in N day(s). Subscribe to keep full access."
        ? strings.tr('Your access ends in $days day${days == 1 ? '' : 's'}.',
            'تنتهي فترة وصولك خلال $days ${days == 1 ? 'يوم' : 'أيام'}.')
        : days <= 0
        ? strings.tr('Your free trial has ended', 'انتهت تجربتك المجانية')
        : days == 1
            ? strings.tr('1 day left in your free trial', 'يتبقى يوم واحد من تجربتك المجانية')
            : strings.tr('$days days left in your free trial', 'يتبقى $days يوماً من تجربتك المجانية');

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
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
                  voucher
                      ? strings.tr('Subscribe to keep full access.', 'اشترك للاحتفاظ بالوصول الكامل.')
                      : strings.tr('Subscribe to keep full access', 'اشترك للحفاظ على وصولك الكامل'),
                  style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _SubscribePill(strings: strings, color: accent),
        ],
      ),
    );
  }
}

class _AccessEndedCard extends StatelessWidget {
  const _AccessEndedCard({required this.strings, required this.paidAccess});
  final AppStrings strings;
  final bool paidAccess;

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
                // Website wording (home.tsx): the access period for a learner who
                // had prepaid or paid access, the free trial otherwise.
                Text(
                  paidAccess
                      ? strings.tr('Your access period has ended', 'انتهت فترة وصولك')
                      : strings.tr('Your free trial has ended', 'انتهت تجربتك المجانية'),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  strings.tr('Subscribe to keep learning.', 'اشترك لمواصلة التعلّم.'),
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary(context)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _SubscribePill(strings: strings, color: accent),
        ],
      ),
    );
  }
}

class _SubscribePill extends StatelessWidget {
  const _SubscribePill({required this.strings, required this.color});
  final AppStrings strings;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/pricing'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
        child: Text(
          strings.tr('Subscribe', 'اشترك'),
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white,
          ),
        ),
      ),
    );
  }
}

/// Full-screen "access ended" gate — shown in place of paid content when the backend returns
/// 402 SUBSCRIPTION_REQUIRED. Offers the in-app subscription checkout.
class AccessEndedView extends ConsumerWidget {
  const AccessEndedView({super.key, this.onBack});
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    final paidAccess = hadPaidAccess(ref.watch(selfPacedPlanProvider));
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
              paidAccess
                  ? s.tr('Your access period has ended - subscribe to keep learning.',
                      'انتهت فترة وصولك - اشترك لمواصلة التعلّم.')
                  : s.tr('Your free trial has ended - subscribe to keep learning.',
                      'انتهت تجربتك المجانية - اشترك لمواصلة التعلّم.'),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary(context), height: 1.5),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => context.push('/pricing'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.purple,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(s.tr('View plans & subscribe', 'عرض الخطط والاشتراك')),
              ),
            ),
            if (onBack != null) ...[
              const SizedBox(height: 10),
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
