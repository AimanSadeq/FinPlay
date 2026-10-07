import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/i18n/app_strings.dart';
import '../../../app/theme/app_colors.dart';
import '../../../data/education_catalog.dart';
import '../../../providers/module_plan_provider.dart';
import '../../../shared/widgets/glass_card.dart';

/// The website page for catalog module [catalogId], opened in the browser. The
/// website reads `lang=ar` on any page, so under the Arabic locale the link
/// carries it and the module opens translated; under English it carries no
/// language parameter. Null for an unknown id. This is the one place the
/// module's website URL is composed.
String? websiteModuleUrl(int catalogId, {required bool arabic}) {
  final entry = catalogEntry(catalogId);
  if (entry == null) return null;
  final uri = Uri.parse('$educationWebsiteBase${entry.href}');
  if (!arabic) return uri.toString();
  return uri.replace(queryParameters: {...uri.queryParameters, 'lang': 'ar'}).toString();
}

/// Shown for a catalog module whose slides and activities have not been ported
/// to the app yet. It names the module exactly as the website does and opens it
/// there, so the app never hides part of the curriculum or mislabels it.
class WebModuleScreen extends ConsumerWidget {
  final int moduleNum;
  const WebModuleScreen({super.key, required this.moduleNum});

  Future<void> _open(BuildContext context, String url) async {
    final ok = await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(url)),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    final entry = catalogEntry(moduleNum);
    // Position and optional mark follow the module plan the hub draws from.
    final plan = ref.watch(modulePlanProvider);
    final position = plan.hubPosition(moduleNum);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text(s.tr('Education Module', 'الوحدة التعليمية')),
      ),
      body: entry == null
          ? Center(child: Text(s.tr('Unknown module', 'وحدة غير معروفة')))
          : SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  GlassCard(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (position != null)
                            Text(
                              s.tr('Module $position', 'الوحدة $position'),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textTertiary(context),
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          const SizedBox(height: 6),
                          Text(
                            s.tr(entry.titleEn, entry.titleAr),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          if (plan.isOptional(moduleNum)) ...[
                            const SizedBox(height: 6),
                            Text(
                              s.tr(
                                'Optional: counted when your program includes it.',
                                'اختيارية: تُحتسب عندما يشملها برنامجك.',
                              ),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                          const SizedBox(height: 16),
                          Text(
                            s.tr(
                              'This module opens on the FinPlay website in your browser. Sign in on the website with the same account you use in this app so your progress there syncs to the app.',
                              'تُفتح هذه الوحدة على موقع FinPlay في المتصفح. سجّل الدخول على الموقع بالحساب نفسه الذي تستخدمه في هذا التطبيق ليتزامن تقدمك هناك مع التطبيق.',
                            ),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: () =>
                                  _open(context, websiteModuleUrl(moduleNum, arabic: s.ar)!),
                              icon: const Icon(Icons.open_in_new_rounded),
                              label: Text(s.tr('Open on the website', 'افتح على الموقع')),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
