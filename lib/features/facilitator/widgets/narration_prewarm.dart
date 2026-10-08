import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/i18n/app_strings.dart';
import '../../../app/theme/app_colors.dart';
import '../../../data/repositories/facilitator_repository.dart';
import '../../education/modules/education_module_data.dart';

/// One narration clip to prepare.
class NarrationJob {
  final String moduleId;
  final String sectionId;
  final String language;
  final String text;
  const NarrationJob(this.moduleId, this.sectionId, this.language, this.text);
}

/// Same threshold as the website's pre-warm: shorter slides are never narrated.
const int narrationMinSourceLength = 40;

String _field(Map<String, String> slide, String f, bool ar) {
  if (ar) {
    final v = slide['${f}Ar'];
    if (v != null && v.trim().isNotEmpty) return v;
  }
  return slide[f] ?? '';
}

/// The text the app's SlideNarrationBar sends for a slide (education_module_screen.dart):
/// title, content and key point in the UI language - each falling back to English, as
/// `_slideText` does - joined by blank lines.
String narrationTextForSlide(Map<String, String> slide, {required bool arabic}) => [
      _field(slide, 'title', arabic),
      _field(slide, 'content', arabic),
      _field(slide, 'keyPoint', arabic),
    ].where((t) => t.isNotEmpty).join('\n\n');

/// The exact POST /narration/prepare request the Learn slide player makes for slide
/// [index] of module [moduleId] in the given UI language: `moduleId` is the catalog id,
/// `sectionId` the website section id (`slide['id']`, slide index as fallback),
/// `language` 'ar' or 'en'. The cache key is (moduleId, sectionId, language, text), so
/// pre-warming must reproduce all four exactly.
NarrationJob slideNarrationRequest(int moduleId, int index, Map<String, String> slide, {required bool arabic}) =>
    NarrationJob(
      '$moduleId',
      slide['id'] ?? '$index',
      arabic ? 'ar' : 'en',
      narrationTextForSlide(slide, arabic: arabic),
    );

/// Every clip the in-app Learn slides can request, in both languages when
/// [includeArabic] (the website pre-warm also does en + ar). An Arabic-UI request for a
/// slide with no Arabic still sends the English text under language 'ar' - a different
/// cache row the player will hit - so it is warmed too. Returns the jobs and how many
/// slide-language pairs were too short to narrate.
({List<NarrationJob> jobs, int skipped}) enumerateNarrationJobs(
  Map<int, EducationModuleContent> modules, {
  required bool includeArabic,
}) {
  final jobs = <NarrationJob>[];
  var skipped = 0;
  for (final entry in modules.entries) {
    final slides = entry.value.slides;
    for (var i = 0; i < slides.length; i++) {
      for (final ar in [false, if (includeArabic) true]) {
        final job = slideNarrationRequest(entry.key, i, slides[i], arabic: ar);
        if (job.text.length < narrationMinSourceLength) {
          skipped++;
          continue;
        }
        jobs.add(job);
      }
    }
  }
  return (jobs: jobs, skipped: skipped);
}

/// AI narration library pre-warm (website NarrationPrewarm.tsx, 77a7016): generates the
/// narration for every in-app Learn slide before a session, so no learner waits on first
/// play. Cached slides return instantly at no cost; re-running only generates slides whose
/// text changed.
class NarrationPrewarm extends ConsumerStatefulWidget {
  final FacilitatorRepository repo;
  const NarrationPrewarm({super.key, required this.repo});

  @override
  ConsumerState<NarrationPrewarm> createState() => _NarrationPrewarmState();
}

class _NarrationPrewarmState extends ConsumerState<NarrationPrewarm> {
  static const _concurrency = 3;
  bool _includeArabic = true;
  bool _running = false;
  bool _finished = false;
  bool _cancel = false;
  String? _configError;
  int _done = 0, _cached = 0, _generated = 0, _failed = 0;
  bool _started = false;
  final List<String> _failures = [];

  Future<void> _run(List<NarrationJob> jobs) async {
    setState(() {
      _running = true;
      _finished = false;
      _cancel = false;
      _configError = null;
      _failures.clear();
      _done = _cached = _generated = _failed = 0;
      _started = true;
    });
    var cursor = 0;
    Future<void> worker() async {
      while (!_cancel) {
        final index = cursor++;
        if (index >= jobs.length) return;
        final job = jobs[index];
        try {
          final cached = await widget.repo.prepareNarration(
              moduleId: job.moduleId, sectionId: job.sectionId, language: job.language, text: job.text);
          cached ? _cached++ : _generated++;
        } catch (e) {
          final message = e.toString();
          // A missing key fails every job the same way: stop with one clear banner.
          if (RegExp('OPENAI_API_KEY|unavailable|503', caseSensitive: false).hasMatch(message)) {
            _configError = message;
            _cancel = true;
            return;
          }
          _failed++;
          _failures.add('${job.moduleId}/${job.sectionId}: $message');
        }
        _done++;
        if (mounted) setState(() {});
      }
    }

    await Future.wait(List.generate(_concurrency, (_) => worker()));
    if (mounted) {
      setState(() {
        _running = false;
        _finished = !_cancel;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final scope = enumerateNarrationJobs(educationModuleContents, includeArabic: _includeArabic);
    final jobs = scope.jobs;
    final pct = jobs.isEmpty ? 0.0 : _done / jobs.length;
    final small = TextStyle(fontSize: 11, color: AppColors.textTertiary(context));

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.secondaryLight.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.secondaryLight.withValues(alpha: 0.3)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.volume_up_rounded, size: 18, color: AppColors.secondaryLight),
          const SizedBox(width: 6),
          Expanded(
            child: Text(s.tr('AI narration library (pre-warm)', 'مكتبة التعليق الصوتي بالذكاء الاصطناعي (تجهيز مسبق)'),
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          ),
        ]),
        const SizedBox(height: 4),
        Text(
          s.tr(
            'Generate the voice-over for every in-app Learn slide now, so learners never wait on first play. Slides already in the library are verified instantly at no cost — re-running only generates slides whose text changed.',
            'أنشئ التعليق الصوتي لكل شرائح "تعلّم" الآن، حتى لا ينتظر المتعلّمون عند التشغيل الأول. الشرائح الموجودة في المكتبة يُتحقّق منها فورًا دون تكلفة — وإعادة التشغيل لا تُنشئ إلا الشرائح التي تغيّر نصها.',
          ),
          style: small,
        ),
        SwitchListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          value: _includeArabic,
          onChanged: _running ? null : (v) => setState(() => _includeArabic = v),
          title: Text(s.tr('Include Arabic narration', 'تضمين التعليق الصوتي العربي'), style: const TextStyle(fontSize: 12)),
          subtitle: Text(s.tr('Warms what Arabic-interface learners request; a slide without Arabic sends its English text, as the player does',
              'يجهّز ما يطلبه متعلّمو الواجهة العربية؛ والشريحة غير المترجمة تُرسل نصها الإنجليزي كما يفعل المشغّل'),
              style: small),
        ),
        Text(
          s.tr(
            'Scope: ${jobs.length} narration clips across ${educationModuleContents.length} in-app modules'
                '${scope.skipped > 0 ? ' (${scope.skipped} slide-language pairs skipped: not narratable yet)' : ''}. New clips cost roughly \$0.02–0.05 each in OpenAI usage, one time.',
            'النطاق: ${jobs.length} مقطعًا صوتيًا عبر ${educationModuleContents.length} وحدات داخل التطبيق'
                '${scope.skipped > 0 ? ' (تُخطّي ${scope.skipped} من أزواج الشريحة واللغة: غير قابلة للتعليق بعد)' : ''}. تكلّف المقاطع الجديدة نحو 0.02–0.05 دولار لكل منها من استخدام OpenAI، مرة واحدة.',
          ),
          style: small,
        ),
        if (_configError != null)
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.danger.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              s.tr(
                'Narration service is not configured on the server ($_configError). Set OPENAI_API_KEY in the deployment environment, then run the pre-warm again.',
                'خدمة التعليق الصوتي غير مُعدّة على الخادم ($_configError). عيّن OPENAI_API_KEY في بيئة النشر ثم أعد التجهيز المسبق.',
              ),
              style: const TextStyle(fontSize: 11, color: AppColors.dangerLight),
            ),
          ),
        if (_started) ...[
          const SizedBox(height: 8),
          LinearProgressIndicator(value: pct, minHeight: 6, color: AppColors.secondaryLight),
          const SizedBox(height: 4),
          Wrap(spacing: 10, children: [
            Text(s.tr('$_done/${jobs.length} checked', '$_done/${jobs.length} تم فحصها'), style: small),
            Text(s.tr('$_cached already cached', '$_cached محفوظة مسبقًا'),
                style: const TextStyle(fontSize: 11, color: AppColors.secondaryLight)),
            Text(s.tr('$_generated newly generated', '$_generated أُنشئت حديثًا'),
                style: const TextStyle(fontSize: 11, color: AppColors.primaryLight)),
            if (_failed > 0)
              Text(s.tr('$_failed failed', '$_failed أخفقت'), style: const TextStyle(fontSize: 11, color: AppColors.dangerLight)),
          ]),
        ],
        if (_finished && _configError == null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              _failed == 0
                  ? s.tr('Narration library complete — every slide now plays instantly.',
                      'اكتملت مكتبة التعليق الصوتي — كل شريحة تعمل الآن فورًا.')
                  : s.tr('Finished with $_failed failure(s) — re-run to retry just the failed slides.',
                      'انتهى مع $_failed إخفاق — أعد التشغيل لإعادة محاولة الشرائح المخفقة فقط.'),
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.secondaryLight),
            ),
          ),
        if (_failures.isNotEmpty)
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: Text(s.tr('${_failures.length} failed clip(s)', '${_failures.length} مقاطع أخفقت'),
                style: const TextStyle(fontSize: 12, color: AppColors.dangerLight)),
            children: [
              for (final f in _failures.take(10)) Text(f, style: small),
              if (_failures.length > 10) Text(s.tr('… and ${_failures.length - 10} more', '… و${_failures.length - 10} أخرى'), style: small),
            ],
          ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: _running
              ? OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.dangerLight),
                  onPressed: () => setState(() => _cancel = true),
                  icon: const Icon(Icons.stop_rounded, size: 16),
                  label: Text(s.tr('Stop (progress is kept — cached clips stay cached)',
                      'إيقاف (يُحفظ التقدّم — تبقى المقاطع المحفوظة)')),
                )
              : FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: AppColors.secondary),
                  onPressed: jobs.isEmpty ? null : () => _run(jobs),
                  child: Text(_started
                      ? s.tr('Run again (verifies cache, generates only what changed)',
                          'تشغيل مجددًا (يتحقّق من المحفوظ ويُنشئ ما تغيّر فقط)')
                      : s.tr('Generate narration library (${jobs.length} clips)',
                          'إنشاء مكتبة التعليق الصوتي (${jobs.length} مقطعًا)')),
                ),
        ),
      ]),
    );
  }
}
