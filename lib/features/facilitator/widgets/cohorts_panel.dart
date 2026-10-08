import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/i18n/app_strings.dart';
import '../../../app/theme/app_colors.dart';
import '../../../data/repositories/facilitator_repository.dart';
import '../../../providers/game_state_provider.dart';
import '../../../providers/repository_providers.dart';
import '../../../providers/team_provider.dart';
import '../../../shared/widgets/glass_card.dart';
import '../cohort_module_plan.dart';
import 'cohort_module_plan_editor.dart';

/// Normalizes a typed subdomain the way the website's create form previews it.
String normalizeCohortSubdomain(String raw) =>
    raw.toLowerCase().replaceAll(RegExp(r'[^a-z0-9-]'), '');

/// Cohorts: run multiple isolated groups at once (website CohortsPanel.tsx). Each cohort is
/// its own game on its own subdomain. Create, rename, enrol in the DBA study, choose the
/// module plan, set the certificate title, delete (guarded), and - app only - switch this
/// device's API host to a cohort.
class CohortsPanel extends ConsumerStatefulWidget {
  final FacilitatorRepository repo;
  const CohortsPanel({super.key, required this.repo});

  @override
  ConsumerState<CohortsPanel> createState() => _CohortsPanelState();
}

class _CohortsPanelState extends ConsumerState<CohortsPanel> {
  List<Map<String, dynamic>> _cohorts = [];
  String _baseDomain = 'finplay.viftraining.com';
  bool _loading = true;
  String? _loadError;
  bool _busy = false;

  // Create form
  final _displayName = TextEditingController();
  final _subdomain = TextEditingController();
  bool _research = false;

  // Main environment research flag (settable only from the main site itself).
  Map<String, dynamic> _researchConfig = {};

  // Which row has which editor open.
  String? _editingId;
  final _editName = TextEditingController();
  String? _certEditingId;
  final _certDraft = TextEditingController();
  String? _planningId;
  String? _deletingId;
  final _deleteConfirm = TextEditingController();
  ({Map<String, int> counts, bool hasParticipantData})? _summary;
  bool _summaryLoading = false;

  @override
  void initState() {
    super.initState();
    _subdomain.addListener(() => setState(() {}));
    _displayName.addListener(() => setState(() {}));
    _deleteConfirm.addListener(() => setState(() {}));
    _load();
  }

  @override
  void dispose() {
    _displayName.dispose();
    _subdomain.dispose();
    _editName.dispose();
    _certDraft.dispose();
    _deleteConfirm.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final reg = await widget.repo.fetchCohortRegistry();
      final rc = await widget.repo.fetchResearchConfig();
      if (!mounted) return;
      setState(() {
        _cohorts = reg.cohorts;
        _baseDomain = reg.baseDomain;
        _researchConfig = rc;
        _loading = false;
        _loadError = null;
      });
    } catch (e) {
      if (mounted) setState(() { _loading = false; _loadError = e.toString(); });
    }
  }

  void _toast(String msg, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: error ? AppColors.danger : AppColors.secondary,
    ));
  }

  String _err(Object e, String fallback) => e is FacilitatorActionException ? e.message : fallback;

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _busy = true);
    try {
      await action();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _create(AppStrings s) => _run(() async {
        final sub = normalizeCohortSubdomain(_subdomain.text);
        final name = _displayName.text.trim();
        if (sub.isEmpty || name.isEmpty) return;
        final res = await widget.repo.createCohort(sub, name, research: _research);
        if (!mounted) return;
        if (res['success'] == true && res['cohort'] is Map) {
          final c = res['cohort'] as Map;
          _toast('${s.tr('Cohort created', 'تم إنشاء المجموعة')}: ${c['displayName']} → ${c['url']}');
          _subdomain.clear();
          _displayName.clear();
          setState(() => _research = false);
          await _load();
        } else {
          _toast('${s.tr('Could not create cohort', 'تعذّر إنشاء المجموعة')}: ${res['error'] ?? ''}',
              error: true);
        }
      });

  Future<void> _patch(AppStrings s, String id, Map<String, dynamic> changes,
          String Function(Map<String, dynamic>) ok, String failTitle) =>
      _run(() async {
        try {
          final c = await widget.repo.updateCohort(id, changes);
          _toast(ok(c));
          await _load();
        } catch (e) {
          _toast('$failTitle: ${_err(e, s.tr('Unknown error', 'خطأ غير معروف'))}', error: true);
        }
      });

  Future<void> _rename(AppStrings s, String id) async {
    final name = _editName.text.trim();
    if (name.isEmpty) return;
    await _patch(s, id, {'displayName': name},
        (c) => '${s.tr('Cohort renamed', 'تمت إعادة تسمية المجموعة')}: ${c['displayName'] ?? name}',
        s.tr('Could not rename cohort', 'تعذّرت إعادة تسمية المجموعة'));
    if (mounted) setState(() => _editingId = null);
  }

  Future<void> _setResearch(AppStrings s, Map<String, dynamic> c, bool next) => _patch(
        s,
        c['id'].toString(),
        {'research': next},
        (saved) {
          final name = saved['displayName'] ?? c['displayName'];
          return saved['research'] == true
              ? s.tr('Enrolled in the DBA study - $name: consent + research instruments on, course assessments off.',
                  'سُجّلت في دراسة الدكتوراه - $name: الموافقة وأدوات البحث مفعّلة، وتقييمات الدورة متوقّفة.')
              : s.tr('Runs commercially - $name: normal course, including the pre and post assessments.',
                  'تعمل تجاريًا - $name: دورة عادية تشمل التقييمين القبلي والبعدي.');
        },
        s.tr('Could not change enrolment', 'تعذّر تغيير التسجيل'),
      );

  Future<void> _saveCert(AppStrings s, Map<String, dynamic> c) async {
    final draft = _certDraft.text.trim();
    await _patch(
      s,
      c['id'].toString(),
      {'certificateProgramName': draft.isEmpty ? null : draft},
      (saved) {
        final name = saved['displayName'] ?? c['displayName'];
        final title = saved['certificateProgramName'];
        return title != null
            ? s.tr('Certificate title saved: learners in $name are certified in "$title".',
                'تم حفظ عنوان الشهادة: يُمنح متعلّمو $name شهادة في "$title".')
            : s.tr('Certificate title saved: $name is back to the default title.',
                'تم حفظ عنوان الشهادة: عادت $name إلى العنوان الافتراضي.');
      },
      s.tr('Could not set the certificate title', 'تعذّر تعيين عنوان الشهادة'),
    );
    if (mounted) setState(() => _certEditingId = null);
  }

  Future<void> _setMainResearch(AppStrings s, bool next) => _run(() async {
        try {
          final enabled = await widget.repo.setResearchMode(next);
          _toast(enabled
              ? s.tr('Main environment enrolled: corporate participants on the main site now complete consent + research instruments.',
                  'سُجّلت البيئة الرئيسية: يُكمل مشاركو الشركات على الموقع الرئيسي الآن الموافقة وأدوات البحث.')
              : s.tr('Main environment runs commercially: the normal course, including the pre and post assessments.',
                  'البيئة الرئيسية تعمل تجاريًا: الدورة العادية بما فيها التقييمان القبلي والبعدي.'));
          await _load();
        } catch (e) {
          _toast('${s.tr('Could not change enrolment', 'تعذّر تغيير التسجيل')}: ${_err(e, '')}', error: true);
        }
      });

  Future<void> _armDelete(Map<String, dynamic> c) async {
    final id = c['id'].toString();
    setState(() {
      _editingId = null;
      _planningId = null;
      _certEditingId = null;
      _deletingId = id;
      _deleteConfirm.clear();
      _summary = null;
      _summaryLoading = true;
    });
    try {
      final sum = await widget.repo.fetchCohortDataSummary(id);
      if (mounted && _deletingId == id) setState(() => _summary = sum);
    } catch (_) {
      // The confirmation still works without the summary.
    } finally {
      if (mounted && _deletingId == id) setState(() => _summaryLoading = false);
    }
  }

  Future<void> _delete(AppStrings s, Map<String, dynamic> c) => _run(() async {
        try {
          final d = await widget.repo.deleteCohort(c['id'].toString(), _deleteConfirm.text.trim());
          if (!mounted) return;
          _toast(s.tr('Cohort deleted: ${d['displayName']} (${d['subdomain']}) is gone.',
              'حُذفت المجموعة: ${d['displayName']} (${d['subdomain']}) لم تعد موجودة.'));
          setState(() => _deletingId = null);
          await _load();
        } catch (e) {
          _toast('${s.tr('Could not delete cohort', 'تعذّر حذف المجموعة')}: ${_err(e, '')}', error: true);
        }
      });

  /// App only: point this device's API at a cohort's host.
  Future<void> _switchHost(AppStrings s, String url) async {
    ref.read(apiClientProvider).setBaseHost(url);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cohort_base_url', url);
    if (!mounted) return;
    ref.read(gameStateProvider.notifier).fetchGameState();
    ref.read(teamProvider.notifier).fetchTeams();
    _toast(s.tr('Switched to $url', 'تم التبديل إلى $url'));
    await _load();
  }

  Future<void> _copy(AppStrings s, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    _toast(s.tr('Link copied', 'تم نسخ الرابط'));
  }

  Future<void> _open(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Widget _chip(String label, Color color, IconData icon) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 3),
          Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    if (_loading) return const Center(child: CircularProgressIndicator());
    final currentHost = ref.read(apiClientProvider).baseUrl;
    final small = TextStyle(fontSize: 11, color: AppColors.textTertiary(context));
    final normalized = normalizeCohortSubdomain(_subdomain.text);

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(s.tr('Cohorts - run multiple groups at once', 'المجموعات - تشغيل عدة مجموعات في آنٍ واحد'),
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            s.tr(
              'Each cohort is a fully isolated game on its own web address, so two groups can play on the same day without their results mixing. Create one below, then share its link with that group. The main site ($_baseDomain) remains the default game. The group name can be renamed at any time; the web address cannot, so check it before you create.',
              'كل مجموعة لعبة معزولة تمامًا على عنوان ويب خاص بها، فيمكن لمجموعتين اللعب في اليوم نفسه دون اختلاط نتائجهما. أنشئ مجموعة أدناه ثم شارك رابطها مع أفرادها. يبقى الموقع الرئيسي ($_baseDomain) هو اللعبة الافتراضية. يمكن تغيير اسم المجموعة في أي وقت، أما عنوان الويب فلا، فتحقّق منه قبل الإنشاء.',
            ),
            style: small,
          ),
          const SizedBox(height: 12),

          // Current API host (app only).
          GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(children: [
              const Icon(Icons.dns_rounded, size: 18, color: AppColors.primaryLight),
              const SizedBox(width: 10),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(s.tr('This device is connected to', 'هذا الجهاز متصل بـ'), style: small),
                  Text(currentHost, style: GoogleFonts.jetBrainsMono(fontSize: 12)),
                ]),
              ),
            ]),
          ),
          const SizedBox(height: 12),

          // Create
          GlassCard(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(s.tr('Create cohort', 'إنشاء مجموعة'), style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              TextField(
                controller: _displayName,
                decoration: InputDecoration(
                  labelText: s.tr('Group name', 'اسم المجموعة'),
                  hintText: s.tr('e.g. May Executive Cohort', 'مثال: مجموعة التنفيذيين - مايو'),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _subdomain,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: s.tr('Subdomain', 'النطاق الفرعي'),
                  hintText: 'groupa',
                  isDense: true,
                  helperText: normalized.isEmpty ? null : '$normalized.$_baseDomain',
                ),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _research,
                onChanged: (v) => setState(() => _research = v),
                activeThumbColor: AppColors.purple,
                secondary: const Icon(Icons.science_rounded, color: AppColors.purple),
                title: Text(s.tr('Part of the DBA research study', 'جزء من دراسة الدكتوراه (DBA)'),
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                subtitle: Text(
                  s.tr(
                    'On: participants complete the ethics-approved consent and the research instruments, and the course\'s own pre and post assessments and course survey do not run. Off: a normal commercial delivery with everything included.',
                    'مفعّل: يُكمل المشاركون الموافقة المعتمدة أخلاقيًا وأدوات البحث، ولا يُجرى التقييمان القبلي والبعدي ولا استبيان الدورة. متوقّف: تقديم تجاري عادي يشمل كل شيء.',
                  ),
                  style: small,
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: (_busy || normalized.isEmpty || _displayName.text.trim().isEmpty)
                      ? null
                      : () => _create(s),
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: Text(s.tr('Create', 'إنشاء')),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 16),

          if (_loadError != null)
            Text(
              s.tr('Could not load cohorts - make sure you\'re signed in as facilitator.',
                  'تعذّر تحميل المجموعات - تأكّد من تسجيل الدخول كميسّر.'),
              style: const TextStyle(color: AppColors.dangerLight, fontSize: 13),
            )
          else ...[
            _mainEnvRow(s, small),
            const SizedBox(height: 8),
            if (_cohorts.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  s.tr('No cohorts yet. Create one above to run a separate, isolated group.',
                      'لا توجد مجموعات بعد. أنشئ واحدة أعلاه لتشغيل مجموعة منفصلة ومعزولة.'),
                  style: small,
                ),
              ),
            ..._cohorts.map((c) => _cohortRow(s, c, small, currentHost)),
          ],
        ],
      ),
    );
  }

  Widget _mainEnvRow(AppStrings s, TextStyle small) {
    final enabled = _researchConfig['enabled'] == true;
    final cohort = _researchConfig['cohort'];
    final onMainSite = cohort is Map && cohort['isCohort'] == false;
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Wrap(spacing: 6, runSpacing: 4, crossAxisAlignment: WrapCrossAlignment.center, children: [
              Text(s.tr('Main environment', 'البيئة الرئيسية'),
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              if (enabled) _chip(s.tr('DBA study', 'دراسة الدكتوراه'), AppColors.purple, Icons.science_rounded),
            ]),
            Text(
              onMainSite
                  ? s.tr('This panel is open on the main site, so this switch is live.',
                      'هذه اللوحة مفتوحة على الموقع الرئيسي، لذا هذا المفتاح فعّال.')
                  : s.tr('Open the facilitator panel on the main site to change this.',
                      'افتح لوحة الميسّر على الموقع الرئيسي لتغيير هذا.'),
              style: small,
            ),
          ]),
        ),
        Tooltip(
          message: enabled
              ? s.tr('Part of the DBA study - course assessments and survey are off',
                  'ضمن دراسة الدكتوراه - تقييمات الدورة والاستبيان متوقّفة')
              : s.tr('Commercial delivery - course assessments and survey are on',
                  'تقديم تجاري - تقييمات الدورة والاستبيان مفعّلة'),
          child: Switch(
            value: enabled,
            activeThumbColor: AppColors.purple,
            onChanged: (!onMainSite || _busy) ? null : (v) => _setMainResearch(s, v),
          ),
        ),
      ]),
    );
  }

  Widget _cohortRow(AppStrings s, Map<String, dynamic> c, TextStyle small, String currentHost) {
    final id = c['id'].toString();
    final name = (c['displayName'] ?? c['subdomain'] ?? '').toString();
    final sub = (c['subdomain'] ?? '').toString();
    final url = (c['url'] ?? '').toString();
    final research = c['research'] == true;
    final lobbyOpen = c['lobbyOpen'] == true;
    final plan = readPlan(c['educationModuleNums']);
    final certName = c['certificateProgramName']?.toString();
    final panelUrl = '${url.replaceAll(RegExp(r'/+$'), '')}/facilitator';
    final isCurrent = url.isNotEmpty && currentHost.startsWith(url.replaceAll(RegExp(r'/+$'), ''));

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlassCard(
        padding: EdgeInsets.zero,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 8, 6),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (_editingId == id)
                Row(children: [
                  Expanded(
                    child: TextField(
                      controller: _editName,
                      autofocus: true,
                      decoration: InputDecoration(isDense: true, labelText: s.tr('Rename $name', 'إعادة تسمية $name')),
                      onSubmitted: (_) => _rename(s, id),
                    ),
                  ),
                  IconButton(
                    tooltip: s.tr('Save name', 'حفظ الاسم'),
                    onPressed: (_busy || _editName.text.trim().isEmpty) ? null : () => _rename(s, id),
                    icon: const Icon(Icons.check_rounded, color: AppColors.secondaryLight),
                  ),
                  IconButton(
                    tooltip: s.tr('Cancel', 'إلغاء'),
                    onPressed: _busy ? null : () => setState(() => _editingId = null),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ])
              else
                Wrap(spacing: 6, runSpacing: 4, crossAxisAlignment: WrapCrossAlignment.center, children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  if (research) _chip(s.tr('DBA study', 'دراسة الدكتوراه'), AppColors.purple, Icons.science_rounded),
                  Tooltip(
                    message: lobbyOpen
                        ? s.tr('Teams can sign in on this address', 'يمكن للفرق تسجيل الدخول على هذا العنوان')
                        : s.tr('Teams see "waiting for administrator" until a facilitator signs in on THIS address',
                            'ترى الفرق "بانتظار المسؤول" حتى يسجّل ميسّر الدخول على هذا العنوان تحديدًا'),
                    child: lobbyOpen
                        ? _chip(s.tr('Lobby open', 'الردهة مفتوحة'), AppColors.secondaryLight, Icons.check_rounded)
                        : _chip(s.tr('Lobby closed', 'الردهة مغلقة'), AppColors.accentLight, Icons.lock_rounded),
                  ),
                  if (c['isActive'] == false)
                    _chip(s.tr('Inactive', 'غير نشطة'), AppColors.textTertiary(context), Icons.pause_rounded),
                ]),
              const SizedBox(height: 2),
              GestureDetector(
                onTap: url.isEmpty ? null : () => _open(url),
                child: Text(url, style: GoogleFonts.jetBrainsMono(fontSize: 11, color: AppColors.primaryLight)),
              ),
              // The lobby opens only when a facilitator signs in on the cohort's own address.
              GestureDetector(
                onTap: url.isEmpty ? null : () => _open(panelUrl),
                child: Text(
                  lobbyOpen
                      ? s.tr('Open its panel ↗', 'افتح لوحتها ↗')
                      : s.tr('Sign in here to open the lobby ↗', 'سجّل الدخول هنا لفتح الردهة ↗'),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: lobbyOpen ? FontWeight.normal : FontWeight.w600,
                    color: lobbyOpen ? AppColors.textTertiary(context) : AppColors.accentLight,
                  ),
                ),
              ),
              if (_editingId != id) ...[
                const SizedBox(height: 4),
                Wrap(spacing: 2, crossAxisAlignment: WrapCrossAlignment.center, children: [
                  Tooltip(
                    message: research
                        ? s.tr('Part of the DBA study - course assessments and survey are off',
                            'ضمن دراسة الدكتوراه - تقييمات الدورة والاستبيان متوقّفة')
                        : s.tr('Commercial delivery - course assessments and survey are on',
                            'تقديم تجاري - تقييمات الدورة والاستبيان مفعّلة'),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.science_rounded, size: 16,
                          color: research ? AppColors.purple : AppColors.textTertiary(context)),
                      Switch(
                        value: research,
                        activeThumbColor: AppColors.purple,
                        onChanged: _busy ? null : (v) => _setResearch(s, c, v),
                      ),
                    ]),
                  ),
                  TextButton.icon(
                    onPressed: () => setState(() {
                      _deletingId = null;
                      _certEditingId = null;
                      _planningId = _planningId == id ? null : id;
                    }),
                    icon: Icon(Icons.menu_book_rounded, size: 16,
                        color: plan != null ? AppColors.primaryLight : null),
                    label: Text(
                      plan != null
                          ? '${plan.length}/${educationCatalogNums.length}'
                          : s.tr('Modules', 'الوحدات'),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  IconButton(
                    tooltip: s.tr('Set what this engagement\'s certificate is called', 'تحديد عنوان شهادة هذا البرنامج'),
                    onPressed: () => setState(() {
                      _deletingId = null;
                      _planningId = null;
                      _certDraft.text = certName ?? '';
                      _certEditingId = _certEditingId == id ? null : id;
                    }),
                    icon: Icon(Icons.school_rounded, size: 18,
                        color: certName != null ? AppColors.secondaryLight : null),
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    tooltip: s.tr('Rename group', 'إعادة تسمية المجموعة'),
                    onPressed: () => setState(() {
                      _deletingId = null;
                      _editingId = id;
                      _editName.text = name;
                    }),
                    icon: const Icon(Icons.edit_rounded, size: 18),
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    tooltip: s.tr('Copy link', 'نسخ الرابط'),
                    onPressed: url.isEmpty ? null : () => _copy(s, url),
                    icon: const Icon(Icons.copy_rounded, size: 18),
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    tooltip: isCurrent
                        ? s.tr('This device is on this cohort', 'هذا الجهاز على هذه المجموعة')
                        : s.tr('Connect this device to this cohort', 'ربط هذا الجهاز بهذه المجموعة'),
                    onPressed: (_busy || url.isEmpty || isCurrent) ? null : () => _switchHost(s, url),
                    icon: Icon(isCurrent ? Icons.link_rounded : Icons.swap_horiz_rounded, size: 18),
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    tooltip: s.tr('Delete group', 'حذف المجموعة'),
                    onPressed: _busy ? null : () => _armDelete(c),
                    icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.dangerLight),
                    visualDensity: VisualDensity.compact,
                  ),
                ]),
              ],
            ]),
          ),
          if (_certEditingId == id) _certEditor(s, c, name, small),
          if (_planningId == id)
            CohortModulePlanEditor(
              key: ValueKey('plan-$id'),
              repo: widget.repo,
              cohortId: id,
              cohortName: name,
              plan: plan,
              onClose: () => setState(() => _planningId = null),
              onSaved: () {
                setState(() => _planningId = null);
                _load();
              },
            ),
          if (_deletingId == id) _deletePanel(s, c, name, sub),
        ]),
      ),
    );
  }

  Widget _certEditor(AppStrings s, Map<String, dynamic> c, String name, TextStyle small) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.secondaryLight.withValues(alpha: 0.06),
          border: Border(top: BorderSide(color: AppColors.borderColor(context))),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(s.tr('Certificate title for $name', 'عنوان الشهادة لـ $name'),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(
            s.tr(
              'What a learner\'s certificate says they completed. Leave empty for the default, "Finance for Non-Finance". Certificates already issued keep the title they were awarded under.',
              'ما تذكره شهادة المتعلّم أنه أتمّه. اتركه فارغًا للعنوان الافتراضي "Finance for Non-Finance" (المالية لغير الماليين). تحتفظ الشهادات الصادرة سابقًا بالعنوان الذي مُنحت به.',
            ),
            style: small,
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _certDraft,
            maxLength: 120,
            decoration: InputDecoration(
              isDense: true,
              hintText: s.tr('e.g. Executive Corporate Finance', 'مثال: Executive Corporate Finance'),
            ),
          ),
          Row(children: [
            FilledButton.icon(
              onPressed: _busy ? null : () => _saveCert(s, c),
              icon: const Icon(Icons.check_rounded, size: 16),
              label: Text(s.tr('Save', 'حفظ')),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: _busy ? null : () => setState(() => _certEditingId = null),
              child: Text(s.tr('Cancel', 'إلغاء')),
            ),
          ]),
        ]),
      );

  Widget _deletePanel(AppStrings s, Map<String, dynamic> c, String name, String sub) {
    final sum = _summary;
    const red = AppColors.dangerLight;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.danger.withValues(alpha: 0.07),
        border: Border(top: BorderSide(color: AppColors.borderColor(context))),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.warning_amber_rounded, size: 18, color: red),
          const SizedBox(width: 8),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(s.tr('This permanently deletes $name and everything in it.', 'سيؤدي هذا إلى حذف $name وكل ما فيها نهائيًا.'),
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: red)),
              const SizedBox(height: 2),
              Text(
                s.tr(
                  'The group\'s database schema is dropped. Their decisions, financial statements, consent records and questionnaire responses go with it. There is no undo and no backup is taken.',
                  'تُحذف قاعدة بيانات المجموعة بالكامل، ومعها قراراتهم وقوائمهم المالية وسجلات الموافقة وإجابات الاستبيانات. لا يمكن التراجع ولا تُؤخذ نسخة احتياطية.',
                ),
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 4),
              if (_summaryLoading)
                Text(s.tr('Checking what this cohort holds…', 'جارٍ التحقّق ممّا تحتويه هذه المجموعة…'),
                    style: const TextStyle(fontSize: 12, color: red))
              else if (sum != null && sum.hasParticipantData)
                Text(
                  '${s.tr('This cohort has already been used', 'سبق استخدام هذه المجموعة')}: '
                  '${sum.counts.entries.map((e) => '${e.value} ${e.key.replaceAll('_', ' ')}').join(', ')}.',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: red),
                )
              else if (sum != null)
                Text(s.tr('No participant data recorded yet in this cohort.', 'لا توجد بيانات مشاركين مسجّلة في هذه المجموعة بعد.'),
                    style: const TextStyle(fontSize: 12)),
            ]),
          ),
        ]),
        const SizedBox(height: 8),
        Text(s.tr('Type $sub to confirm', 'اكتب $sub للتأكيد'),
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        TextField(
          controller: _deleteConfirm,
          autocorrect: false,
          decoration: InputDecoration(isDense: true, hintText: sub),
        ),
        const SizedBox(height: 8),
        Wrap(spacing: 8, children: [
          FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: (_busy || _deleteConfirm.text.trim() != sub) ? null : () => _delete(s, c),
            icon: const Icon(Icons.delete_forever_rounded, size: 16),
            label: Text(s.tr('Delete permanently', 'حذف نهائي')),
          ),
          OutlinedButton(
            onPressed: _busy ? null : () => setState(() => _deletingId = null),
            child: Text(s.tr('Cancel', 'إلغاء')),
          ),
        ]),
      ]),
    );
  }
}
