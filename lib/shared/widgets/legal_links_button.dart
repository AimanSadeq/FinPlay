import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/i18n/app_strings.dart';
import '../../app/theme/app_colors.dart';
import '../../core/utils/constants.dart';

/// Header button that opens the website's legal pages (website 1b9d367:
/// /privacy, /terms, /academic-license). Apple expects the privacy policy to be
/// reachable from inside the app, not only at sign-up.
class LegalLinksButton extends ConsumerWidget {
  const LegalLinksButton({super.key});

  static const _pages = [
    ('/privacy', 'Privacy Policy', 'سياسة الخصوصية', Icons.privacy_tip_outlined),
    ('/terms', 'Terms of Service', 'شروط الخدمة', Icons.gavel_rounded),
    ('/academic-license', 'Academic License', 'الترخيص الأكاديمي', Icons.school_outlined),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    return PopupMenuButton<String>(
      icon: Icon(Icons.info_outline_rounded, size: 20, color: AppColors.textSecondary(context)),
      tooltip: s.tr('Legal', 'المعلومات القانونية'),
      onSelected: (path) => launchUrl(
        Uri.parse('${AppConstants.baseUrl}$path'),
        mode: LaunchMode.externalApplication,
      ),
      itemBuilder: (_) => [
        for (final p in _pages)
          PopupMenuItem(
            value: p.$1,
            child: Row(children: [
              Icon(p.$4, size: 18),
              const SizedBox(width: 10),
              Text(s.tr(p.$2, p.$3)),
            ]),
          ),
      ],
    );
  }
}
