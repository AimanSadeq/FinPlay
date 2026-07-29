import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/theme/app_colors.dart';
import '../../../data/models/certificate.dart';
import '../../../providers/locale_provider.dart';
import '../../../providers/repository_providers.dart';
import '../../../shared/widgets/glass_card.dart';

/// Completion certificate — awarded automatically once every learning module is done.
///
/// The app is read-only here: the server issues the certificate on the first eligible request, so
/// there is no "generate" button to press. The printable artifact is a server-rendered HTML page,
/// which is opened in the browser rather than reproduced natively — that keeps a single source of
/// truth for the certificate's appearance and means it can never disagree with what an employer
/// sees on the public verification page.
class CertificateScreen extends ConsumerStatefulWidget {
  const CertificateScreen({super.key});

  @override
  ConsumerState<CertificateScreen> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends ConsumerState<CertificateScreen> {
  late Future<CertificateStatus> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _future = ref.read(certificateRepositoryProvider).fetch();
  }

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the certificate')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = ref.watch(isArabicProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'الشهادة' : 'Certificate'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: isArabic ? 'تحديث' : 'Refresh',
            onPressed: () => setState(_load),
          ),
        ],
      ),
      body: FutureBuilder<CertificateStatus>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final s = snap.data ?? const CertificateStatus(error: 'No response');

          return RefreshIndicator(
            onRefresh: () async => setState(_load),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [_body(s, isArabic)],
            ),
          );
        },
      ),
    );
  }

  Widget _body(CertificateStatus s, bool isArabic) {
    if (s.subscriptionRequired) return _lapsed(isArabic);
    if (s.sessionExpired) return _signedOut(isArabic);
    if (s.error != null) return _message(Icons.error_outline, AppColors.danger, s.error!);
    if (s.revoked) {
      return _message(
        Icons.gpp_bad_outlined,
        AppColors.danger,
        isArabic
            ? 'تم إلغاء هذه الشهادة ولم تعد صالحة.'
            : 'This certificate has been revoked and is no longer valid.',
      );
    }
    if (!s.eligible) return _inProgress(s, isArabic);
    final cert = s.certificate;
    if (cert == null) {
      return _message(
        Icons.hourglass_empty,
        AppColors.warning,
        isArabic ? 'الشهادة قيد الإصدار.' : 'Your certificate is being issued.',
      );
    }
    return _awarded(cert, isArabic);
  }

  /// Not finished yet — show how much is left rather than an empty state, so the screen is
  /// useful before the certificate exists.
  Widget _inProgress(CertificateStatus s, bool isArabic) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.workspace_premium_outlined, color: AppColors.primary, size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  isArabic ? 'أكمل جميع الوحدات' : 'Complete every module',
                  style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: s.progress,
              minHeight: 10,
              backgroundColor: AppColors.primarySurface,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            isArabic
                ? 'أكملت ${s.completed} من ${s.total} وحدة'
                : '${s.completed} of ${s.total} modules complete',
            style: GoogleFonts.inter(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 6),
          Text(
            isArabic
                ? 'تصدر شهادتك تلقائياً بمجرد إكمال جميع الوحدات.'
                : 'Your certificate is issued automatically once all modules are complete.',
            style: GoogleFonts.inter(fontSize: 13, color: Colors.black45),
          ),
        ],
      ),
    );
  }

  Widget _awarded(Certificate cert, bool isArabic) {
    final issued = cert.issuedAt;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GlassCard(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              const Icon(Icons.workspace_premium, color: AppColors.accent, size: 46),
              const SizedBox(height: 12),
              Text(
                isArabic ? 'تهانينا!' : 'Congratulations',
                style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(
                cert.learnerName,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                cert.programName,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 14, color: Colors.black54),
              ),
              if (issued != null) ...[
                const SizedBox(height: 8),
                Text(
                  '${isArabic ? 'تاريخ الإصدار' : 'Issued'}: '
                  '${issued.day.toString().padLeft(2, '0')}/'
                  '${issued.month.toString().padLeft(2, '0')}/${issued.year}',
                  style: GoogleFonts.inter(fontSize: 13, color: Colors.black45),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),

        // The verification code is the part an employer actually uses, so make it copyable
        // rather than something the learner has to transcribe from a screenshot.
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isArabic ? 'رمز التحقق' : 'Verification code',
                style: GoogleFonts.inter(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: SelectableText(
                      cert.verificationCode,
                      style: GoogleFonts.robotoMono(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy_rounded),
                    tooltip: isArabic ? 'نسخ' : 'Copy',
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: cert.verificationCode));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(isArabic ? 'تم النسخ' : 'Copied')),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        FilledButton.icon(
          onPressed: () => _open(cert.viewUrl),
          icon: const Icon(Icons.open_in_new),
          label: Text(isArabic ? 'عرض الشهادة' : 'View certificate'),
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            backgroundColor: AppColors.primary,
          ),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: () => _open(cert.verifyUrl),
          icon: const Icon(Icons.verified_outlined),
          label: Text(isArabic ? 'صفحة التحقق' : 'Public verification page'),
          style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
        ),
      ],
    );
  }

  /// Signed out or session expired (7-day sessions, so this is routine). Offers the way back in
  /// rather than reporting the server's raw "Not authenticated" and leaving the learner stuck.
  Widget _signedOut(bool isArabic) {
    return GlassCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        children: [
          const Icon(Icons.person_off_outlined, color: AppColors.warning, size: 40),
          const SizedBox(height: 12),
          Text(
            isArabic
                ? 'انتهت جلستك. سجّل الدخول مرة أخرى لعرض شهادتك.'
                : 'Your session has ended. Sign in again to view your certificate.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 15, height: 1.4),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => context.go('/self-paced-login'),
            icon: const Icon(Icons.login),
            label: Text(isArabic ? 'تسجيل الدخول' : 'Sign in'),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              backgroundColor: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  /// Access lapsed. Informational only — no price and no purchase button, per App Store policy
  /// for this screen; subscriptions are managed on the website.
  Widget _lapsed(bool isArabic) {
    return _message(
      Icons.lock_outline,
      AppColors.warning,
      isArabic
          ? 'انتهت صلاحية وصولك. جدّد اشتراكك من الموقع للحصول على شهادتك.'
          : 'Your access has ended. Renew on the website to collect your certificate.',
    );
  }

  Widget _message(IconData icon, Color color, String text) {
    return GlassCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        children: [
          Icon(icon, color: color, size: 40),
          const SizedBox(height: 12),
          Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 15, height: 1.4),
          ),
        ],
      ),
    );
  }
}
