import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/i18n/app_strings.dart';
import '../../../app/theme/app_colors.dart';
import '../../../data/repositories/facilitator_repository.dart';
import '../../../providers/repository_providers.dart';
import '../../../shared/widgets/glass_card.dart';
import 'console_links.dart';

Future<void> _openExternal(String url) async {
  final uri = Uri.tryParse(url);
  if (uri != null) await launchUrl(uri, mode: LaunchMode.externalApplication);
}

/// Course Slides (PDF) - website CourseSlidesDownload: opens the server's print-ready deck
/// pages in the browser, where "Save as PDF" produces the handout.
class CourseSlidesCard extends ConsumerStatefulWidget {
  const CourseSlidesCard({super.key});

  @override
  ConsumerState<CourseSlidesCard> createState() => _CourseSlidesCardState();
}

class _CourseSlidesCardState extends ConsumerState<CourseSlidesCard> {
  String _lang = 'en';

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final origin = siteOrigin(ref.read(apiClientProvider).baseUrl);
    final small = TextStyle(fontSize: 11, color: AppColors.textTertiary(context));
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.picture_as_pdf_rounded, color: AppColors.info),
          const SizedBox(width: 8),
          Text(s.tr('Course Slides (PDF)', 'شرائح الدورة (PDF)'), style: Theme.of(context).textTheme.titleMedium),
        ]),
        const SizedBox(height: 4),
        Text(
          s.tr('Produces the slides as a print-ready document. Choose Save as PDF in the print dialog that opens, then hand the file to Ops to attach to the joining-instructions email. The slides are generated from the live course, so a download is always current.',
              'يُخرج الشرائح كمستند جاهز للطباعة. اختر "حفظ بصيغة PDF" في نافذة الطباعة التي تُفتح، ثم سلّم الملف لفريق العمليات لإرفاقه ببريد تعليمات الانضمام. تُولَّد الشرائح من الدورة الحية، فالتنزيل محدَّث دائمًا.'),
          style: small,
        ),
        const SizedBox(height: 8),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'en', label: Text('English')),
            ButtonSegment(value: 'ar', label: Text('العربية')),
          ],
          selected: {_lang},
          showSelectedIcon: false,
          onSelectionChanged: (v) => setState(() => _lang = v.first),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => _openExternal(courseSlidesUrl(origin, 'all', _lang)),
            icon: const Icon(Icons.download_rounded, size: 18),
            label: Text(s.tr(
                'Download ALL slides as one PDF (${courseSlideDecks.length} modules · $courseSlideTotal slides)',
                'تنزيل كل الشرائح في ملف PDF واحد (${courseSlideDecks.length} وحدة · $courseSlideTotal شريحة)')),
          ),
        ),
        Text(s.tr('A document this size takes a few seconds to lay out before the print dialog appears.',
            'يستغرق مستند بهذا الحجم بضع ثوانٍ للتنسيق قبل ظهور نافذة الطباعة.'), style: small),
        ExpansionTile(
          tilePadding: EdgeInsets.zero,
          title: Text(s.tr('Download a single module instead', 'تنزيل وحدة واحدة بدلًا من ذلك'), style: const TextStyle(fontSize: 13)),
          children: [
            for (final d in courseSlideDecks)
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.description_outlined, size: 18),
                title: Text(d.entry == null ? d.id : s.tr(d.entry!.titleEn, d.entry!.titleAr), style: const TextStyle(fontSize: 13)),
                trailing: Text(s.tr('${d.slides} slides', '${d.slides} شريحة'), style: small),
                onTap: () => _openExternal(courseSlidesUrl(origin, d.id, _lang)),
              ),
          ],
        ),
      ]),
    );
  }
}

/// Annual Report Downloads - website FinancialStatementsAdmin. Lists the uploaded annual
/// reports learners download during the Sector Finance Comparison slides, opens them, and
/// removes them. Uploading needs a file picker, which the app does not ship.
class FinancialStatementsCard extends ConsumerStatefulWidget {
  final FacilitatorRepository repo;
  const FinancialStatementsCard({super.key, required this.repo});

  @override
  ConsumerState<FinancialStatementsCard> createState() => _FinancialStatementsCardState();
}

class _FinancialStatementsCardState extends ConsumerState<FinancialStatementsCard> {
  List<Map<String, dynamic>> _files = [];
  bool _loading = true;
  String? _deleting;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final f = await widget.repo.fetchFinancialStatements();
      if (mounted) setState(() { _files = f; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _delete(AppStrings s, Map<String, dynamic> f) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(s.tr('Remove "${f['label']}"?', 'إزالة "${f['label']}"؟')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(s.tr('Cancel', 'إلغاء'))),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(s.tr('Remove', 'إزالة')),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    setState(() => _deleting = f['id'].toString());
    try {
      await widget.repo.deleteFinancialStatement(f['id'].toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(s.tr('Deleted: ${f['label']} removed', 'حُذف: أُزيل ${f['label']}')), backgroundColor: AppColors.secondary));
      }
      await _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('${s.tr('Delete failed', 'تعذّر الحذف')}: ${e is FacilitatorActionException ? e.message : e}'),
            backgroundColor: AppColors.danger));
      }
    } finally {
      if (mounted) setState(() => _deleting = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final origin = siteOrigin(ref.read(apiClientProvider).baseUrl);
    final small = TextStyle(fontSize: 11, color: AppColors.textTertiary(context));
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.folder_open_rounded, color: AppColors.secondaryLight),
          const SizedBox(width: 8),
          Expanded(child: Text(s.tr('Annual Report Downloads', 'تنزيلات التقارير السنوية'), style: Theme.of(context).textTheme.titleMedium)),
          Text('${_files.length} / 5', style: small),
        ]),
        const SizedBox(height: 4),
        Text(
          s.tr('Annual reports (PDF) from publicly listed companies that learners download during the Sector Finance Comparison slides. Up to 5 files. Uploading is done from the website facilitator panel.',
              'تقارير سنوية (PDF) لشركات مدرجة ينزّلها المتعلّمون أثناء شرائح مقارنة مالية القطاعات. حتى 5 ملفات. يتم الرفع من لوحة الميسّر على الموقع.'),
          style: small,
        ),
        const SizedBox(height: 8),
        if (_loading)
          const LinearProgressIndicator(minHeight: 2)
        else if (_files.isEmpty)
          Text(s.tr('No files uploaded yet.', 'لم تُرفع ملفات بعد.'), style: small)
        else
          for (final f in _files)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.picture_as_pdf_outlined, size: 20),
              title: Text('${f['label']}', style: const TextStyle(fontSize: 13)),
              subtitle: Text('${f['filename']}', style: small),
              onTap: () => _openExternal(financialStatementUrl(origin, '${f['filename']}')),
              trailing: _deleting == f['id'].toString()
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : IconButton(
                      tooltip: s.tr('Remove', 'إزالة'),
                      icon: const Icon(Icons.delete_outline_rounded, color: AppColors.dangerLight, size: 20),
                      onPressed: () => _delete(s, f),
                    ),
            ),
      ]),
    );
  }
}
