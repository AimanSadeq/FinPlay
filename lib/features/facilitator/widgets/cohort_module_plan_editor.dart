import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/i18n/app_strings.dart';
import '../../../app/theme/app_colors.dart';
import '../../../data/education_catalog.dart';
import '../../../data/repositories/facilitator_repository.dart';
import '../cohort_module_plan.dart';

/// Choose which education modules one client engagement includes (website
/// CohortModulePlanEditor.tsx). Modules left out disappear from that cohort's hub, drop out
/// of its progression and stop counting toward completion and the certificate.
class CohortModulePlanEditor extends ConsumerStatefulWidget {
  final FacilitatorRepository repo;
  final String cohortId;
  final String cohortName;

  /// The stored plan; null means the whole catalog.
  final List<int>? plan;
  final VoidCallback onClose;
  final VoidCallback onSaved;

  const CohortModulePlanEditor({
    super.key,
    required this.repo,
    required this.cohortId,
    required this.cohortName,
    required this.plan,
    required this.onClose,
    required this.onSaved,
  });

  @override
  ConsumerState<CohortModulePlanEditor> createState() => _CohortModulePlanEditorState();
}

class _CohortModulePlanEditorState extends ConsumerState<CohortModulePlanEditor> {
  late Set<int> _selected = initialPlanSelection(widget.plan);
  Map<String, int> _progress = {};
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    widget.repo.fetchCohortModuleProgress(widget.cohortId).then((p) {
      if (mounted) setState(() => _progress = p);
    });
  }

  String _kindLabel(AppStrings s, EducationModuleKind kind) => switch (kind) {
        EducationModuleKind.content => s.tr('Curriculum module', 'وحدة من المنهج'),
        EducationModuleKind.workshop => s.tr('Workshop tool', 'أداة ورشة عمل'),
        EducationModuleKind.simulation => s.tr('Simulation game', 'لعبة المحاكاة'),
      };

  Future<void> _save() async {
    final s = ref.read(stringsProvider);
    setState(() => _saving = true);
    try {
      await widget.repo.updateCohort(widget.cohortId, {'educationModuleNums': planToSave(_selected)});
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${s.tr('Module plan saved', 'تم حفظ خطة الوحدات')}: ${widget.cohortName}'),
        backgroundColor: AppColors.secondary,
      ));
      widget.onSaved();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e is FacilitatorActionException
            ? e.message
            : s.tr('Could not save the module plan', 'تعذّر حفظ خطة الوحدات')),
        backgroundColor: AppColors.danger,
      ));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final total = educationCatalogNums.length;
    final isAll = _selected.length == total;
    final nothing = _selected.isEmpty;
    final losing = modulesLosingWork(_selected, _progress);
    final small = TextStyle(fontSize: 11, color: AppColors.textTertiary(context));

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.05),
        border: Border(top: BorderSide(color: AppColors.borderColor(context))),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(s.tr('Module plan for ${widget.cohortName}', 'خطة الوحدات لـ ${widget.cohortName}'),
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 2),
              Text(
                s.tr(
                  'Delegates on this address see only the modules ticked here. Everything else is hidden from their hub and excluded from their completion and certificate.',
                  'لا يرى المشاركون على هذا العنوان إلا الوحدات المحدّدة هنا. أما البقية فتُخفى من صفحتهم وتُستثنى من نسبة الإكمال ومن الشهادة.',
                ),
                style: small,
              ),
            ]),
          ),
          IconButton(
            tooltip: s.tr('Close', 'إغلاق'),
            onPressed: widget.onClose,
            icon: const Icon(Icons.close_rounded, size: 18),
            visualDensity: VisualDensity.compact,
          ),
        ]),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 4, crossAxisAlignment: WrapCrossAlignment.center, children: [
          OutlinedButton(
            onPressed: isAll ? null : () => setState(() => _selected = educationCatalogNums.toSet()),
            child: Text(s.tr('Select all', 'تحديد الكل'), style: const TextStyle(fontSize: 12)),
          ),
          OutlinedButton(
            onPressed: () => setState(() => _selected = <int>{}),
            child: Text(s.tr('Clear', 'مسح'), style: const TextStyle(fontSize: 12)),
          ),
          Text(
            isAll
                ? s.tr('All modules (new modules appear automatically)',
                    'كل الوحدات (تظهر الوحدات الجديدة تلقائيًا)')
                : s.tr('${_selected.length} selected', '${_selected.length} محدّدة'),
            style: small,
          ),
        ]),
        const SizedBox(height: 6),
        ...educationCatalog.map((m) {
          final on = _selected.contains(m.num);
          final teams = _progress[catalogProgressId(m.num) ?? ''] ?? 0;
          return CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            value: on,
            onChanged: (_) => setState(() {
              on ? _selected.remove(m.num) : _selected.add(m.num);
            }),
            title: Text(s.tr(m.titleEn, m.titleAr),
                maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13)),
            subtitle: Text(
              '${_kindLabel(s, m.kind)} · ${s.tr('id ${m.num}', 'المعرّف ${m.num}')}'
              '${m.optional ? s.tr(' · optional', ' · اختيارية') : ''}'
              '${teams > 0 ? s.tr(' · $teams team${teams == 1 ? '' : 's'} have work here', ' · لدى $teams من الفرق عمل هنا') : ''}',
              style: small,
            ),
          );
        }),
        if (losing.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 6),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.accentLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.accentLight.withValues(alpha: 0.4)),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.warning_amber_rounded, size: 16, color: AppColors.accentLight),
              const SizedBox(width: 8),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    losing.length == 1
                        ? s.tr('A module teams have already worked in will be hidden:',
                            'ستُخفى وحدة سبق أن عملت عليها الفرق:')
                        : s.tr('${losing.length} modules teams have already worked in will be hidden:',
                            'ستُخفى ${losing.length} وحدات سبق أن عملت عليها الفرق:'),
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  Text(losing.map((m) => s.tr(m.titleEn, m.titleAr)).join(s.tr(', ', '، ')),
                      style: const TextStyle(fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(
                    s.tr(
                      'Nothing is deleted. Their scores and badges stay, and putting the module back restores each team\'s place. But it disappears from their hub straight away, so tell the room if they are mid-session.',
                      'لا يُحذف شيء. تبقى الدرجات والشارات، وإعادة الوحدة تُرجع كل فريق إلى موضعه. لكنها تختفي من صفحتهم فورًا، فأبلغ القاعة إن كانوا في منتصف الجلسة.',
                    ),
                    style: const TextStyle(fontSize: 12),
                  ),
                ]),
              ),
            ]),
          ),
        if (nothing)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              s.tr('Nothing selected saves as "all modules" - a hub with no modules in it is never what someone meant.',
                  'عدم تحديد أي وحدة يُحفظ على أنه "كل الوحدات"، فصفحة بلا وحدات ليست ما يقصده أحد.'),
              style: small,
            ),
          ),
        const SizedBox(height: 8),
        Row(children: [
          FilledButton.icon(
            onPressed: _saving ? null : _save,
            icon: _saving
                ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.check_rounded, size: 16),
            label: Text(s.tr('Save plan', 'حفظ الخطة')),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: _saving ? null : widget.onClose,
            child: Text(s.tr('Cancel', 'إلغاء')),
          ),
        ]),
      ]),
    );
  }
}
