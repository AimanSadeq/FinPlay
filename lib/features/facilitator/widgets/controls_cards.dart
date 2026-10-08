import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../app/i18n/app_strings.dart';
import '../../../app/theme/app_colors.dart';
import '../../../data/repositories/facilitator_repository.dart';
import '../../../providers/repository_providers.dart';
import '../../../shared/widgets/glass_card.dart';
import 'console_links.dart';

void _snack(BuildContext context, String msg, {bool error = false}) {
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(msg), backgroundColor: error ? AppColors.danger : AppColors.secondary));
}

String _msg(Object e) => e is FacilitatorActionException ? e.message : e.toString();

/// One QR code per team (website TeamJoinCodes): scanning carries the cohort code and the
/// team in the link, so a delegate types only their name.
class TeamJoinCodesCard extends ConsumerStatefulWidget {
  final FacilitatorRepository repo;
  final String? accessCode;
  const TeamJoinCodesCard({super.key, required this.repo, this.accessCode});

  @override
  ConsumerState<TeamJoinCodesCard> createState() => _TeamJoinCodesCardState();
}

class _TeamJoinCodesCardState extends ConsumerState<TeamJoinCodesCard> {
  List<Map<String, dynamic>> _teams = [];

  @override
  void initState() {
    super.initState();
    widget.repo.fetchTeamsRaw().then((t) {
      if (mounted) setState(() => _teams = t);
    }).catchError((_) {});
  }

  void _show(AppStrings s, String title, String url) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, textAlign: TextAlign.center),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(12),
            child: QrImageView(data: url, size: 240),
          ),
          const SizedBox(height: 8),
          SelectableText(url, style: const TextStyle(fontSize: 11)),
        ]),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: url));
              Navigator.pop(ctx);
              _snack(context, s.tr('Link copied', 'تم نسخ الرابط'));
            },
            child: Text(s.tr('Copy link', 'نسخ الرابط')),
          ),
          FilledButton(onPressed: () => Navigator.pop(ctx), child: Text(s.tr('Close', 'إغلاق'))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final origin = siteOrigin(ref.read(apiClientProvider).baseUrl);
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.qr_code_2_rounded, size: 20, color: AppColors.primaryLight),
          const SizedBox(width: 8),
          Expanded(child: Text(s.tr('Team join codes', 'رموز انضمام الفرق'), style: Theme.of(context).textTheme.titleSmall)),
          TextButton.icon(
            onPressed: _teams.isEmpty
                ? null
                : () {
                    final text = [
                      s.tr('FinPlay - scan to join your team', 'FinPlay - امسح للانضمام إلى فريقك'),
                      widget.accessCode == null || widget.accessCode!.isEmpty
                          ? s.tr('No cohort access code set.', 'لم يُحدَّد رمز دخول للمجموعة.')
                          : s.tr('Cohort access code: ${widget.accessCode}', 'رمز دخول المجموعة: ${widget.accessCode}'),
                      for (final t in _teams)
                        '${displayTeamName(t['name']?.toString(), t['id'].toString())}: ${teamJoinUrl(origin, t['id'].toString(), widget.accessCode)}',
                    ].join('\n');
                    Clipboard.setData(ClipboardData(text: text));
                    _snack(context, s.tr('All team links copied', 'تم نسخ روابط كل الفرق'));
                  },
            icon: const Icon(Icons.copy_all_rounded, size: 16),
            label: Text(s.tr('Copy all', 'نسخ الكل'), style: const TextStyle(fontSize: 12)),
          ),
        ]),
        Text(s.tr('Delegates scan their team\'s code, then type their name. Nothing else to enter.',
            'يمسح المشاركون رمز فريقهم ثم يكتبون أسماءهم فقط. لا شيء آخر لإدخاله.'),
            style: TextStyle(fontSize: 11, color: AppColors.textTertiary(context))),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final t in _teams)
            Builder(builder: (_) {
              final name = displayTeamName(t['name']?.toString(), t['id'].toString());
              final url = teamJoinUrl(origin, t['id'].toString(), widget.accessCode);
              return InkWell(
                onTap: () => _show(s, name, url),
                child: Container(
                  width: 96,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.borderColor(context)),
                  ),
                  child: Column(children: [
                    Container(color: Colors.white, child: QrImageView(data: url, size: 80, padding: const EdgeInsets.all(4))),
                    const SizedBox(height: 4),
                    Text(name, maxLines: 2, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10)),
                  ]),
                ),
              );
            }),
        ]),
      ]),
    );
  }
}

/// Case-study template picker (website "Case Studies and Scenarios"): assign a company
/// profile with budget constraints to every team, or deactivate it.
class CaseStudyPickerCard extends ConsumerStatefulWidget {
  final FacilitatorRepository repo;

  /// Called after a change so the constraints editor re-reads the new template.
  final VoidCallback? onChanged;
  const CaseStudyPickerCard({super.key, required this.repo, this.onChanged});

  @override
  ConsumerState<CaseStudyPickerCard> createState() => _CaseStudyPickerCardState();
}

class _CaseStudyPickerCardState extends ConsumerState<CaseStudyPickerCard> {
  List<Map<String, dynamic>> _templates = [];
  String? _activeId;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final res = await widget.repo.fetchCaseStudyTemplates();
    if (!mounted) return;
    setState(() {
      _templates = (res['templates'] as List<dynamic>? ?? []).whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
      _activeId = res['activeCaseStudyId']?.toString();
    });
  }

  Future<void> _set(AppStrings s, String? id) async {
    setState(() => _busy = true);
    try {
      final res = await widget.repo.setCaseStudy(id);
      if (!mounted) return;
      _snack(context,
          '${res['activeCaseStudyId'] != null ? s.tr('Case Study Activated', 'فُعّلت دراسة الحالة') : s.tr('Case Study Deactivated', 'أُلغيت دراسة الحالة')}: ${res['message'] ?? ''}');
      await _load();
      widget.onChanged?.call();
    } catch (e) {
      if (mounted) _snack(context, '${s.tr('Could not set case study', 'تعذّر تعيين دراسة الحالة')}: ${_msg(e)}', error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _name(AppStrings s, Map<String, dynamic> t) {
    final n = t['name'];
    if (n is Map) return s.tr('${n['en'] ?? ''}', '${n['ar'] ?? n['en'] ?? ''}');
    return '${n ?? t['id']}';
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final active = _templates.where((t) => t['id'] == _activeId).firstOrNull;
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.business_center_rounded, color: AppColors.primaryLight, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(s.tr('Case Study', 'دراسة الحالة'), style: Theme.of(context).textTheme.titleMedium)),
        ]),
        Text(s.tr('Assign a company profile with budget constraints to teams', 'عيّن ملف شركة بقيود ميزانية للفرق'),
            style: TextStyle(fontSize: 11, color: AppColors.textTertiary(context))),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: (_activeId != null ? AppColors.primaryLight : Colors.grey).withValues(alpha: 0.12),
          ),
          child: Text(
            _activeId == null
                ? s.tr('No Case Study Active', 'لا توجد دراسة حالة نشطة')
                : active == null
                    ? _activeId!
                    : '${active['icon'] ?? ''} ${_name(s, active)}',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(spacing: 6, runSpacing: 6, children: [
          for (final t in _templates)
            ChoiceChip(
              selected: t['id'] == _activeId,
              label: Text('${t['icon'] ?? ''} ${_name(s, t)}', style: const TextStyle(fontSize: 12)),
              onSelected: _busy ? null : (_) => _set(s, t['id'] == _activeId ? null : t['id'].toString()),
            ),
        ]),
        if (_activeId != null) ...[
          const SizedBox(height: 8),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.dangerLight),
            onPressed: _busy ? null : () => _set(s, null),
            icon: const Icon(Icons.block_rounded, size: 16),
            label: Text(s.tr('Deactivate Case Study', 'إلغاء دراسة الحالة')),
          ),
        ],
      ]),
    );
  }
}

/// Scenario Results Control (website): reveal or hide each capital-budgeting scenario's
/// NPV/IRR answers, one at a time or all at once.
class ScenarioResultsCard extends ConsumerStatefulWidget {
  final FacilitatorRepository repo;
  const ScenarioResultsCard({super.key, required this.repo});

  @override
  ConsumerState<ScenarioResultsCard> createState() => _ScenarioResultsCardState();
}

class _ScenarioResultsCardState extends ConsumerState<ScenarioResultsCard> {
  Set<String> _unlocked = {};
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final st = await widget.repo.getState();
      final list = st['capitalBudgetingResultsUnlocked'];
      if (mounted) setState(() => _unlocked = {if (list is List) ...list.map((e) => e.toString())});
    } catch (_) {}
  }

  Future<void> _toggle(AppStrings s, String id, bool unlock) async {
    setState(() => _busy = true);
    try {
      final now = await widget.repo.toggleScenarioResults(id, unlock);
      if (!mounted) return;
      setState(() => _unlocked = now.toSet());
      _snack(context, unlock
          ? s.tr('👁️ Results Revealed: scenario results now visible to learners', '👁️ كُشفت النتائج: أصبحت نتائج السيناريو مرئية للمتعلّمين')
          : s.tr('🙈 Results Hidden: scenario results hidden from learners', '🙈 أُخفيت النتائج: نتائج السيناريو مخفية عن المتعلّمين'));
    } catch (e) {
      if (mounted) _snack(context, '${s.tr('Toggle Failed', 'تعذّر التبديل')}: ${_msg(e)}', error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _all(AppStrings s, bool unlock) async {
    setState(() => _busy = true);
    try {
      await widget.repo.setScenarioResultsVisible(unlock);
      await _load();
      if (mounted) {
        _snack(context, unlock
            ? s.tr('👁️ All Results Revealed', '👁️ كُشفت كل النتائج')
            : s.tr('🙈 All Results Hidden', '🙈 أُخفيت كل النتائج'));
      }
    } catch (e) {
      if (mounted) _snack(context, _msg(e), error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    Widget group(String difficulty, String label, Color color) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
          const SizedBox(height: 4),
          Wrap(spacing: 6, runSpacing: 6, children: [
            for (final sc in capitalBudgetingScenarios.where((x) => x.$4 == difficulty))
              FilterChip(
                selected: _unlocked.contains(sc.$1),
                selectedColor: color.withValues(alpha: 0.2),
                showCheckmark: false,
                tooltip: s.tr(sc.$2, sc.$3),
                label: Text('${_unlocked.contains(sc.$1) ? '👁️' : '🙈'} ${s.tr(sc.$2, sc.$3).split(' - ').first}',
                    style: const TextStyle(fontSize: 12)),
                onSelected: _busy ? null : (v) => _toggle(s, sc.$1, v),
              ),
          ]),
        ]);
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text('📊 ${s.tr('Scenario Results Control', 'التحكّم في نتائج السيناريوهات')}', style: Theme.of(context).textTheme.titleMedium)),
          TextButton(onPressed: _busy ? null : () => _all(s, true), child: Text(s.tr('👁️ Show All', '👁️ إظهار الكل'), style: const TextStyle(fontSize: 12))),
          TextButton(onPressed: _busy ? null : () => _all(s, false), child: Text(s.tr('🙈 Hide All', '🙈 إخفاء الكل'), style: const TextStyle(fontSize: 12))),
        ]),
        group('beginner', s.tr('Beginner', 'مبتدئ'), AppColors.secondaryLight),
        const SizedBox(height: 8),
        group('intermediate', s.tr('Intermediate', 'متوسط'), AppColors.accentLight),
        const SizedBox(height: 6),
        Text(s.tr('Control which scenario results learners can see', 'تحكّم في نتائج السيناريوهات التي يراها المتعلّمون'),
            style: TextStyle(fontSize: 11, color: AppColors.textTertiary(context))),
      ]),
    );
  }
}

/// Email diagnostics (POST /facilitator/test-email): checks the Outlook/Graph setup used for
/// the self-paced verification codes without registering a learner. The website exposes
/// this route on the server only; the app gives it a button.
class TestEmailCard extends ConsumerStatefulWidget {
  final FacilitatorRepository repo;
  const TestEmailCard({super.key, required this.repo});

  @override
  ConsumerState<TestEmailCard> createState() => _TestEmailCardState();
}

class _TestEmailCardState extends ConsumerState<TestEmailCard> {
  final _to = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _to.dispose();
    super.dispose();
  }

  Future<void> _send(AppStrings s) async {
    final to = _to.text.trim();
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(to)) {
      _snack(context, s.tr('A valid recipient email is required.', 'يلزم بريد إلكتروني صالح للمستلم.'), error: true);
      return;
    }
    setState(() => _busy = true);
    try {
      final msg = await widget.repo.sendTestEmail(to);
      if (mounted) _snack(context, s.tr(msg, 'أُرسلت رسالة الاختبار إلى $to'));
    } catch (e) {
      if (mounted) _snack(context, '${s.tr('Test email failed', 'تعذّر إرسال رسالة الاختبار')}: ${_msg(e)}', error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.mark_email_read_rounded, color: AppColors.info, size: 20),
          const SizedBox(width: 8),
          Text(s.tr('Test email', 'رسالة اختبار'), style: Theme.of(context).textTheme.titleMedium),
        ]),
        Text(
          s.tr('Sends a test email so the email setup used for sign-up verification codes can be checked end to end.',
              'يرسل رسالة اختبار للتحقّق من إعداد البريد المستخدم لرموز التحقّق عند التسجيل من البداية إلى النهاية.'),
          style: TextStyle(fontSize: 11, color: AppColors.textTertiary(context)),
        ),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(
            child: TextField(
              controller: _to,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(isDense: true, labelText: s.tr('Recipient email', 'بريد المستلم')),
            ),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: _busy ? null : () => _send(s),
            child: Text(_busy ? s.tr('Sending…', 'جارٍ الإرسال…') : s.tr('Send', 'إرسال')),
          ),
        ]),
      ]),
    );
  }
}
