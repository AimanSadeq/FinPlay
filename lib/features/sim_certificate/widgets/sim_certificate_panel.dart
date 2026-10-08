import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/i18n/app_strings.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../achievements/providers/achievements_providers.dart';
import '../data/sim_certificate_models.dart';
import '../providers/sim_certificate_provider.dart';

/// Shareable simulation certificate ("FinPlay Business Simulation") — port of the website's
/// components/CertificatePanel.tsx.
///
/// States (all decided by the SERVER via GET /certificate/simulation/mine):
///   issued     → certificate card + Add to LinkedIn / Copy verification link / View verification page
///   eligible   → "Claim your certificate" (corporate: /simulation/claim, self-paced: /claim-self-paced)
///   locked     → round progress
///   signed out → renders nothing
///
/// Eligibility is never computed on the device: corporate = team reached Round 3 with locked
/// Round-3 decisions; self-paced = learner's currentModule === 'complete'.
///
/// Arabic: the website panel is English-only; the Arabic here is the app's own.
class SimCertificatePanel extends ConsumerStatefulWidget {
  const SimCertificatePanel({super.key});

  @override
  ConsumerState<SimCertificatePanel> createState() => _SimCertificatePanelState();
}

class _SimCertificatePanelState extends ConsumerState<SimCertificatePanel> {
  bool _claiming = false;
  String? _claimError;
  bool _justClaimed = false;
  bool _copied = false;
  SimCertificate? _claimed; // seeds the card immediately after a claim

  static const _linkedInBlue = Color(0xFF0A66C2);
  static const _amber900 = Color(0xFF78350F);
  static const _amber800 = Color(0xFF92400E);
  static const _amber700 = Color(0xFFB45309);

  Future<void> _claim(AppStrings s) async {
    setState(() {
      _claiming = true;
      _claimError = null;
    });
    final session = await ref.read(gamificationSessionProvider.future);
    final result = await ref.read(simCertificateRepositoryProvider).claim(session);
    if (!mounted) return;
    setState(() {
      _claiming = false;
      if (result.ok) {
        _justClaimed = true;
        _claimed = result.certificate;
      } else if (result.subscriptionRequired) {
        // Informational only — no price or purchase UI in the iOS app.
        _claimError = s.tr('Your access has ended. Renew on the website to collect your certificate.',
            'انتهت صلاحية وصولك. جدّد اشتراكك من الموقع للحصول على شهادتك.');
      } else if (result.unauthorized) {
        _claimError = s.tr('Your session has ended. Sign in again to claim your certificate.',
            'انتهت جلستك. سجّل الدخول مرة أخرى للمطالبة بشهادتك.');
      } else if (result.revoked) {
        _claimError = s.tr('This certificate has been revoked.', 'تم إلغاء هذه الشهادة.');
      } else {
        _claimError = s.ar
            ? 'تعذّر إصدار الشهادة. يرجى المحاولة مرة أخرى.'
            : (result.error ?? 'Could not claim the certificate. Please try again.');
      }
    });
    if (result.ok) ref.invalidate(simCertificateStatusProvider);
  }

  Future<void> _open(Uri uri, AppStrings s) async {
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.tr('Could not open the link', 'تعذّر فتح الرابط'))),
      );
    }
  }

  Future<void> _copy(String url) async {
    await Clipboard.setData(ClipboardData(text: url));
    if (!mounted) return;
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final async = ref.watch(simCertificateStatusProvider);
    final status = async.valueOrNull;

    // Signed out (no token, or the server rejected it) → render nothing, like the website.
    if (status != null && status.state == SimCertState.signedOut && _claimed == null) {
      return const SizedBox.shrink();
    }

    final cert = status?.certificate ?? _claimed;
    Widget body;
    if (async.isLoading && status == null && cert == null) {
      body = Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(children: [
          const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
          const SizedBox(width: 10),
          Text(s.tr('Checking your certificate…', 'جارٍ التحقق من شهادتك…'),
              style: TextStyle(fontSize: 13, color: AppColors.textTertiary(context))),
        ]),
      );
    } else if (cert != null) {
      body = _issued(context, s, cert);
    } else if (status?.state == SimCertState.error) {
      body = Row(children: [
        const Icon(Icons.error_outline, color: AppColors.danger, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(s.tr('Could not load your certificate.', 'تعذّر تحميل شهادتك.'),
              style: const TextStyle(fontSize: 13)),
        ),
        TextButton(
          onPressed: () => ref.invalidate(simCertificateStatusProvider),
          child: Text(s.tr('Retry', 'إعادة المحاولة')),
        ),
      ]);
    } else if (status?.eligible == true) {
      body = _eligible(context, s);
    } else {
      body = _locked(context, s, status ?? const SimCertificateStatus());
    }

    return GlassCard(
      padding: const EdgeInsets.all(16),
      borderColor: AppColors.secondary.withValues(alpha: 0.35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.verified_user_rounded, color: AppColors.secondary, size: 20),
            const SizedBox(width: 8),
            Text(s.tr('Certificate', 'الشهادة'),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 4),
          Text(
            s.tr(
              'Complete the full 3-round simulation to earn a shareable, publicly verifiable certificate issued by VIFM.',
              'أكمل المحاكاة كاملة بجولاتها الثلاث لتحصل على شهادة صادرة عن VIFM قابلة للمشاركة ويمكن لأي شخص التحقق منها.',
            ),
            style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context)),
          ),
          const SizedBox(height: 12),
          body,
        ],
      ),
    );
  }

  Widget _medallion(double size) => Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: [Color(0xFFFBBF24), Color(0xFFD97706)]),
          boxShadow: [BoxShadow(color: Color(0x33000000), blurRadius: 4, offset: Offset(0, 2))],
        ),
        child: Icon(Icons.workspace_premium_rounded, color: Colors.white, size: size * 0.5),
      );

  Widget _issued(BuildContext context, AppStrings s, SimCertificate cert) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFCD34D), width: 2),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFBEB), Color(0xFFFEFCE8), Colors.white],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_justClaimed)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.secondarySurface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.secondaryLight.withValues(alpha: 0.4)),
              ),
              child: Row(children: [
                const Icon(Icons.check_circle_rounded, size: 16, color: AppColors.secondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    s.tr('Congratulations — your certificate has been issued!', 'تهانينا — تم إصدار شهادتك!'),
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.secondaryDark),
                  ),
                ),
              ]),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _medallion(52),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.tr('CERTIFICATE OF COMPLETION', 'شهادة إتمام'),
                      style: const TextStyle(
                          fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.w700, color: _amber700),
                    ),
                    const SizedBox(height: 2),
                    Text(cert.programName,
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: _amber900)),
                    const SizedBox(height: 4),
                    Text.rich(TextSpan(
                      style: const TextStyle(fontSize: 13, color: _amber800),
                      children: [
                        TextSpan(text: s.tr('Awarded to ', 'تُمنح إلى ')),
                        TextSpan(text: cert.learnerName, style: const TextStyle(fontWeight: FontWeight.w700)),
                      ],
                    )),
                    const SizedBox(height: 4),
                    Text(
                      'Virginia Institute of Finance & Management'
                      '${cert.issuedAt != null ? ' · ${formatCertificateDate(cert.issuedAt!, s.ar)}' : ''}',
                      style: const TextStyle(fontSize: 11, color: _amber700),
                    ),
                    const SizedBox(height: 2),
                    SelectableText(cert.verificationCode,
                        style: GoogleFonts.jetBrainsMono(fontSize: 11, color: _amber700)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                style: FilledButton.styleFrom(backgroundColor: _linkedInBlue, foregroundColor: Colors.white),
                onPressed: () => _open(cert.linkedInAddToProfileUrl, s),
                icon: const Icon(Icons.add_box_rounded, size: 18),
                label: Text(s.tr('Add to LinkedIn', 'أضف إلى LinkedIn')),
              ),
              if (cert.verifyUrl.isNotEmpty)
                OutlinedButton.icon(
                  onPressed: () => _copy(cert.verifyUrl),
                  icon: Icon(_copied ? Icons.check_circle_rounded : Icons.copy_rounded,
                      size: 18, color: _copied ? AppColors.secondary : null),
                  label: Text(_copied
                      ? s.tr('Copied!', 'تم النسخ!')
                      : s.tr('Copy verification link', 'نسخ رابط التحقق')),
                ),
              if (cert.verifyUrl.isNotEmpty)
                OutlinedButton.icon(
                  onPressed: () => _open(Uri.parse(cert.verifyUrl), s),
                  icon: const Icon(Icons.open_in_new_rounded, size: 18),
                  label: Text(s.tr('View verification page', 'عرض صفحة التحقق')),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _eligible(BuildContext context, AppStrings s) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0x80FFFBEB),
        border: Border.all(color: const Color(0xFFFCD34D), width: 1.5),
      ),
      child: Column(
        children: [
          _medallion(46),
          const SizedBox(height: 10),
          Text(s.tr('You completed the simulation!', 'لقد أكملت المحاكاة!'),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(
            s.tr(
              'Claim your FinPlay Business Simulation certificate — verifiable by anyone, shareable on LinkedIn.',
              'احصل على شهادة FinPlay Business Simulation — يمكن لأي شخص التحقق منها، وقابلة للمشاركة على LinkedIn.',
            ),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary(context)),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: AppColors.accent, foregroundColor: Colors.white),
            onPressed: _claiming ? null : () => _claim(s),
            icon: _claiming
                ? const SizedBox(
                    width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.workspace_premium_rounded, size: 18),
            label: Text(_claiming
                ? s.tr('Claiming…', 'جارٍ الإصدار…')
                : s.tr('Claim your certificate', 'احصل على شهادتك')),
          ),
          if (_claimError != null) ...[
            const SizedBox(height: 8),
            Text(_claimError!,
                textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: AppColors.danger)),
          ],
        ],
      ),
    );
  }

  Widget _locked(BuildContext context, AppStrings s, SimCertificateStatus st) {
    final total = st.totalRounds;
    final current = st.currentRound > total ? total : st.currentRound;
    final progress = st.currentRound > 0
        ? s.tr('Current progress: Round $current of $total.', 'التقدّم الحالي: الجولة $current من $total.')
        : s.tr('Start the simulation to make progress.', 'ابدأ المحاكاة لتحرز تقدّمًا.');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.cardColor(context),
        border: Border.all(color: AppColors.borderColor(context)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.withValues(alpha: 0.2)),
            child: Icon(Icons.lock_rounded, color: Colors.grey.shade500, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.tr('Complete all $total rounds to earn your certificate',
                      'أكمل الجولات الـ$total كلها لتحصل على شهادتك'),
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 3),
                Text(
                  '$progress ${s.tr('Once every round is confirmed, your shareable VIFM certificate unlocks here.', 'بمجرد تأكيد كل الجولات، تُفتح هنا شهادتك من VIFM القابلة للمشاركة.')}',
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
