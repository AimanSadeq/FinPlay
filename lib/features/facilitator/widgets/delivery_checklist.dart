import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/i18n/app_strings.dart';
import '../../../app/theme/app_colors.dart';
import '../../../data/repositories/facilitator_repository.dart';
import '../../../shared/widgets/glass_card.dart';
import '../delivery_checklist_data.dart';

/// Plain-text rendering of the checklist with its current ticks. The app has no print
/// pipeline, so this stands in for the website's Print button (copy, then paste/print).
String checklistAsText(AppStrings s, ChecklistVariant v, Set<String> checked) {
  final b = StringBuffer();
  final total = checklistItemCount(v);
  b.writeln(v == ChecklistVariant.dba
      ? s.tr('FinPlay DBA Research Delivery Checklist', 'قائمة تقديم FinPlay - مجموعة بحث الدكتوراه')
      : s.tr('FinPlay Corporate Delivery Checklist', 'قائمة تقديم FinPlay - جلسة الشركات'));
  b.writeln(s.tr('VIFM · ${checked.length}/$total completed', 'VIFM · ${checked.length}/$total مكتمل'));
  for (final sec in checklistSections(v)) {
    b.writeln();
    b.writeln('${s.tr(sec.headingEn, sec.headingAr)} (${s.tr(sec.timingEn, sec.timingAr)})');
    for (final it in sec.items) {
      b.writeln('${checked.contains(it.id) ? '☑' : '☐'} ${s.tr(it.titleEn, it.titleAr)}');
      b.writeln('   ${s.tr(it.detailEn, it.detailAr)}');
    }
  }
  b.writeln();
  b.writeln(s.tr('Golden rules:', 'القواعد الذهبية:'));
  for (final r in checklistRules(v)) {
    b.writeln('• ${s.tr(r.$1, r.$2)}');
  }
  return b.toString();
}

/// Facilitator Delivery Checklist (website DeliveryChecklist.tsx): the corporate
/// run-of-show and the DBA research variant as tickable lists. Defaults to the variant
/// this cohort needs (GET /research/config) until the facilitator picks one; ticks are
/// stored per variant on this device.
class DeliveryChecklist extends ConsumerStatefulWidget {
  final FacilitatorRepository repo;

  /// Opens the Session Setup Wizard (the first item points there).
  final VoidCallback? onOpenWizard;
  const DeliveryChecklist({super.key, required this.repo, this.onOpenWizard});

  @override
  ConsumerState<DeliveryChecklist> createState() => _DeliveryChecklistState();
}

class _DeliveryChecklistState extends ConsumerState<DeliveryChecklist> {
  ChecklistVariant _variant = ChecklistVariant.corporate;
  bool _pinned = false;
  bool? _researchEnabled;
  Set<String> _checked = {};

  @override
  void initState() {
    super.initState();
    _loadTicks();
    widget.repo.fetchResearchConfig().then((rc) {
      if (!mounted || rc.isEmpty) return;
      final enabled = rc['enabled'] == true;
      setState(() => _researchEnabled = enabled);
      if (!_pinned) _setVariant(enabled ? ChecklistVariant.dba : ChecklistVariant.corporate);
    });
  }

  Future<void> _loadTicks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(checklistStorageKey[_variant]!) ?? const [];
      if (mounted) setState(() => _checked = list.toSet());
    } catch (_) {
      // Storage unavailable: the checklist still works for this session.
    }
  }

  Future<void> _saveTicks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(checklistStorageKey[_variant]!, _checked.toList());
    } catch (_) {}
  }

  void _setVariant(ChecklistVariant v) {
    if (v == _variant) return;
    setState(() { _variant = v; _checked = {}; });
    _loadTicks();
  }

  void _toggle(String id) {
    setState(() => _checked.contains(id) ? _checked.remove(id) : _checked.add(id));
    _saveTicks();
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final dba = _variant == ChecklistVariant.dba;
    final total = checklistItemCount(_variant);
    final done = _checked.length;
    final small = TextStyle(fontSize: 11, color: AppColors.textTertiary(context));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        GlassCard(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Icon(dba ? Icons.science_rounded : Icons.checklist_rounded,
                  color: dba ? AppColors.purple : AppColors.primaryLight),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  dba
                      ? s.tr('Delivery Checklist - DBA Research Cohort', 'قائمة التقديم - مجموعة بحث الدكتوراه')
                      : s.tr('Delivery Checklist - Corporate Session', 'قائمة التقديم - جلسة الشركات'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ]),
            const SizedBox(height: 10),
            Wrap(spacing: 8, runSpacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: [
              SegmentedButton<ChecklistVariant>(
                segments: [
                  ButtonSegment(
                      value: ChecklistVariant.corporate,
                      icon: const Icon(Icons.work_outline_rounded, size: 16),
                      label: Text(s.tr('Corporate', 'الشركات'))),
                  ButtonSegment(
                      value: ChecklistVariant.dba,
                      icon: const Icon(Icons.science_outlined, size: 16),
                      label: Text(s.tr('DBA study', 'دراسة الدكتوراه'))),
                ],
                selected: {_variant},
                showSelectedIcon: false,
                onSelectionChanged: (sel) {
                  _pinned = true;
                  _setVariant(sel.first);
                },
              ),
              OutlinedButton.icon(
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: checklistAsText(s, _variant, _checked)));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(s.tr('Checklist copied - paste it anywhere to print',
                            'تم نسخ القائمة - الصقها في أي مكان لطباعتها'))));
                  }
                },
                icon: const Icon(Icons.copy_all_rounded, size: 16),
                label: Text(s.tr('Copy for printing', 'نسخ للطباعة')),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  setState(() => _checked = {});
                  _saveTicks();
                },
                icon: const Icon(Icons.restart_alt_rounded, size: 16),
                label: Text(s.tr('Reset', 'إعادة ضبط')),
              ),
              if (widget.onOpenWizard != null)
                OutlinedButton.icon(
                  onPressed: widget.onOpenWizard,
                  icon: const Icon(Icons.flag_rounded, size: 16, color: AppColors.purple),
                  label: Text(s.tr('Session Setup Wizard', 'معالج إعداد الجلسة')),
                ),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(value: total > 0 ? done / total : 0, minHeight: 8),
                ),
              ),
              const SizedBox(width: 10),
              Text('$done/$total', style: const TextStyle(fontWeight: FontWeight.w600)),
            ]),
            const SizedBox(height: 6),
            Text(
              (dba
                      ? s.tr(
                          'The run-of-show for a cohort enrolled in the DBA study. The course assessments and the course survey do not run here; the study collects its own instruments anonymously on a separate platform. For the simulation itself, switch to Corporate. Progress is saved separately per list.',
                          'تسلسل الجلسة لمجموعة مسجّلة في دراسة الدكتوراه. لا تُجرى هنا تقييمات الدورة ولا استبيانها؛ فالدراسة تجمع أدواتها الخاصة دون أسماء على منصة منفصلة. للمحاكاة نفسها، انتقل إلى عرض الشركات. يُحفظ التقدّم لكل قائمة على حدة.')
                      : s.tr(
                          'The run-of-show for a corporate session, as a tickable list. Progress is saved on this device; Reset clears it for the next delivery. The full narrative guide lives in docs/FACILITATOR_MANUAL.md.',
                          'تسلسل جلسة الشركات كقائمة قابلة للتأشير. يُحفظ التقدّم على هذا الجهاز؛ وإعادة الضبط تمسحه للتقديم التالي. الدليل السردي الكامل موجود في docs/FACILITATOR_MANUAL.md.')) +
                  (_researchEnabled == null
                      ? ''
                      : _researchEnabled!
                          ? s.tr(' This cohort IS enrolled in the DBA study.', ' هذه المجموعة مسجّلة في دراسة الدكتوراه.')
                          : s.tr(' This cohort is a commercial delivery.', ' هذه المجموعة تقديم تجاري.')),
              style: small,
            ),
            if (s.ar) ...[
              const SizedBox(height: 4),
              Text('الترجمة العربية لهذه القائمة أُعدّت للتطبيق؛ النسخة المرجعية على الموقع بالإنجليزية.', style: small),
            ],
          ]),
        ),
        const SizedBox(height: 12),
        for (final sec in checklistSections(_variant)) ...[
          _section(s, sec),
          const SizedBox(height: 12),
        ],
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.accentLight.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.accentLight.withValues(alpha: 0.35)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(s.tr('Golden rules', 'القواعد الذهبية'),
                style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.accentLight)),
            const SizedBox(height: 6),
            for (final r in checklistRules(_variant))
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text('• ${s.tr(r.$1, r.$2)}', style: const TextStyle(fontSize: 13)),
              ),
          ]),
        ),
      ],
    );
  }

  Widget _section(AppStrings s, ChecklistSection sec) {
    final secDone = sec.items.where((it) => _checked.contains(it.id)).length;
    return GlassCard(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 6),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(children: [
            Expanded(
              child: Text(s.tr(sec.headingEn, sec.headingAr),
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            ),
            Text('${s.tr(sec.timingEn, sec.timingAr)} · $secDone/${sec.items.length}',
                style: TextStyle(fontSize: 11, color: AppColors.textTertiary(context))),
          ]),
        ),
        const SizedBox(height: 4),
        for (final it in sec.items)
          CheckboxListTile(
            value: _checked.contains(it.id),
            onChanged: (_) => _toggle(it.id),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: const EdgeInsets.symmetric(horizontal: 4),
            title: Text(
              s.tr(it.titleEn, it.titleAr),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                decoration: _checked.contains(it.id) ? TextDecoration.lineThrough : null,
                color: _checked.contains(it.id) ? AppColors.secondaryLight : null,
              ),
            ),
            subtitle: Text(s.tr(it.detailEn, it.detailAr),
                style: TextStyle(fontSize: 12, height: 1.4, color: AppColors.textSecondary(context))),
          ),
      ]),
    );
  }
}
