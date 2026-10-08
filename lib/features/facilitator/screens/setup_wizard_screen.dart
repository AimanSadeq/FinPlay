import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/i18n/app_strings.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/utils/constants.dart';
import '../../../data/education_catalog.dart';
import '../../../data/repositories/facilitator_repository.dart';
import '../../../providers/repository_providers.dart';
import '../../../shared/widgets/glass_card.dart';
import '../poll_visibility.dart';
import '../setup_wizard_logic.dart';
import '../widgets/narration_prewarm.dart';

/// Facilitator Session Setup Wizard (website /facilitator/setup): a ten-step pre-flight
/// that verifies every requirement before a session - system health, cohort, mode and
/// branding, fresh start (destructive), model integrity, modules, assessments, timer, a
/// session checklist, and a final Ready step with Start game. Opened from the facilitator
/// panel, so the facilitator password is already on the API client.
class SetupWizardScreen extends ConsumerStatefulWidget {
  const SetupWizardScreen({super.key});

  static Future<void> open(BuildContext context) =>
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SetupWizardScreen()));

  @override
  ConsumerState<SetupWizardScreen> createState() => _SetupWizardScreenState();
}

class _SetupWizardScreenState extends ConsumerState<SetupWizardScreen> {
  WizardState _w = const WizardState();
  Set<String> _ticks = {};
  String? _lastArchiveBatchId;
  Timer? _poll;
  bool _loaded = false;
  bool _busy = false;
  bool _freshRunning = false;

  // Live data
  Map<String, dynamic> _health = {}, _conn = {}, _status = {}, _roundState = {}, _activeShocks = {};
  Map<String, dynamic> _leaders = {}, _assumptions = {}, _branding = {}, _realism = {}, _education = {};
  Map<String, dynamic> _assessPre = {}, _assessPost = {}, _timerOverlay = {};
  List<Map<String, dynamic>>? _teams;
  int? _forecastCount;
  List<Map<String, dynamic>> _cohorts = [];

  // Form drafts
  final _subdomain = TextEditingController();
  final _cohortName = TextEditingController();
  Map<String, dynamic>? _provisioned;
  TextEditingController? _brandTitle, _brandClient;
  TextEditingController? _covDte, _covCov;
  TextEditingController? _overlaySeconds;
  late final TextEditingController _timerMinutes = TextEditingController();

  FacilitatorRepository get _repo => ref.read(facilitatorRepositoryProvider);

  @override
  void initState() {
    super.initState();
    _subdomain.addListener(() => setState(() {}));
    _cohortName.addListener(() => setState(() {}));
    _restore();
    _refresh();
    _poll = Timer.periodic(const Duration(seconds: 10), (_) {
      // Paused while another screen is on top of the wizard.
      if (isPollVisible(this)) _refresh();
    });
  }

  @override
  void dispose() {
    _poll?.cancel();
    for (final c in [_subdomain, _cohortName, _brandTitle, _brandClient, _covDte, _covCov, _overlaySeconds, _timerMinutes]) {
      c?.dispose();
    }
    super.dispose();
  }

  Future<void> _restore() async {
    try {
      final p = await SharedPreferences.getInstance();
      final w = WizardState.fromJsonString(p.getString(wizardStorageKey));
      final ticks = p.getStringList(sessionChecklistKey) ?? const [];
      if (!mounted) return;
      setState(() {
        _w = w;
        _ticks = ticks.toSet();
        _lastArchiveBatchId = p.getString(lastArchiveKey);
        _timerMinutes.text = '${w.timerMinutes}';
      });
    } catch (_) {
      _timerMinutes.text = '${_w.timerMinutes}';
    }
  }

  void _setW(WizardState w) {
    setState(() => _w = w);
    SharedPreferences.getInstance().then((p) => p.setString(wizardStorageKey, w.toJsonString())).ignore();
  }

  void _setTicks(Set<String> t) {
    setState(() => _ticks = t);
    SharedPreferences.getInstance().then((p) => p.setStringList(sessionChecklistKey, t.toList())).ignore();
  }

  /// One read of everything at a time: the 10 s poll, a manual re-check and the re-read
  /// after an action share this. A request while one is running queues a single re-read
  /// (so an action's result is never missed) instead of starting a second batch.
  bool _refreshing = false;
  bool _refreshQueued = false;

  Future<void> _refresh() async {
    if (_refreshing) {
      _refreshQueued = true;
      return;
    }
    _refreshing = true;
    try {
      do {
        _refreshQueued = false;
        await _readAll();
      } while (_refreshQueued && mounted);
    } finally {
      _refreshing = false;
    }
  }

  Future<void> _readAll() async {
    final r = _repo;
    final results = await Future.wait<dynamic>([
      r.fetchHealth(),
      r.fetchConnection(),
      r.fetchStatusWithCohort().catchError((_) => <String, dynamic>{}),
      r.fetchRoundState(),
      r.getTeamOverview().then<List<Map<String, dynamic>>?>((v) => v).catchError((_) => null),
      r.fetchActiveShocksRaw(),
      r.fetchForecasts().then<int?>((v) => v.length).catchError((_) => null),
      r.fetchTeamLeaders(),
      r.fetchModelAssumptions(),
      r.fetchBranding(),
      r.fetchRealismStatus(),
      r.fetchEducationStatus(),
      r.fetchAssessmentStatus('pre'),
      r.fetchAssessmentStatus('post'),
      r.fetchCohortRegistry().then((v) => v.cohorts).catchError((_) => <Map<String, dynamic>>[]),
      r.fetchTimerOverlay(),
    ]);
    if (!mounted) return;
    setState(() {
      _health = results[0];
      _conn = results[1];
      _status = results[2];
      _roundState = results[3];
      _teams = results[4];
      _activeShocks = results[5];
      _forecastCount = results[6];
      _leaders = results[7];
      _assumptions = results[8];
      _branding = results[9];
      _realism = results[10];
      _education = results[11];
      _assessPre = results[12];
      _assessPost = results[13];
      _cohorts = results[14];
      _timerOverlay = results[15];
      _loaded = true;
    });
  }

  void _toast(String msg, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: error ? AppColors.danger : AppColors.secondary));
  }

  /// Runs a write, toasts the outcome and re-reads everything (website runAction).
  Future<void> _act(Future<void> Function() fn, String successTitle) async {
    final s = ref.read(stringsProvider);
    setState(() => _busy = true);
    try {
      await fn();
      _toast(successTitle);
    } catch (e) {
      _toast('${s.tr('Action failed', 'تعذّر تنفيذ الإجراء')}: ${e is FacilitatorActionException ? e.message : e}',
          error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
      await _refresh();
    }
  }

  // ── Derived state ──
  Map<String, dynamic> get _gs => _status['gameState'] is Map ? Map<String, dynamic>.from(_status['gameState']) : {};
  Map<String, dynamic>? get _activeCohort =>
      _status['cohort'] is Map ? Map<String, dynamic>.from(_status['cohort']) : null;

  ({bool api, bool db, bool engine}) get _sys => systemChecks(_health, _conn);
  StepStatus get _step1 => !_loaded ? StepStatus.pending : (_sys.api && _sys.db && _sys.engine ? StepStatus.green : StepStatus.amber);
  FreshStartChecks get _fresh => FreshStartChecks.from(
        roundState: _roundState,
        teams: _teams,
        activeShocks: _activeShocks,
        forecastCount: _forecastCount,
        teamLeaders: _leaders,
      );
  StepStatus get _step4 => !_loaded ? StepStatus.pending : (_fresh.allClean ? StepStatus.green : StepStatus.amber);
  ModelIntegrity get _model => ModelIntegrity.from(_assumptions['assumptions'] as List<dynamic>? ?? const []);
  StepStatus get _step5 => !_loaded ? StepStatus.pending : (_model.ok ? StepStatus.green : StepStatus.amber);
  bool get _readyGate => _step1 == StepStatus.green && _step4 == StepStatus.green && _step5 == StepStatus.green;

  List<StepStatus> get _statuses {
    StepStatus conf(int n) => _w.isConfirmed(n) ? StepStatus.green : StepStatus.pending;
    return [
      _step1,
      conf(2),
      conf(3),
      _step4,
      _step5,
      conf(6),
      conf(7),
      conf(8),
      !_loaded ? StepStatus.pending : (_readyGate ? StepStatus.green : StepStatus.amber),
      _readyGate ? StepStatus.green : StepStatus.pending,
    ];
  }

  Map<String, dynamic>? get _chosenCohort {
    final c = _w.cohortChoice;
    if (c.isEmpty || c == 'main') return null;
    for (final x in _cohorts) {
      if (x['subdomain'] == c) return x;
    }
    return null;
  }

  String get _apiOrigin =>
      ref.read(apiClientProvider).baseUrl.replaceFirst(RegExp('${RegExp.escape(AppConstants.apiPrefix)}/*\$'), '');

  String get _lobbyUrl => wizardLobbyUrl(_chosenCohort?['url']?.toString(), _apiOrigin);

  String _activeCohortLabel(AppStrings s) {
    final a = _activeCohort;
    return a == null ? s.tr('checking…', 'جارٍ التحقّق…') : '${a['displayName']} (${a['host']})';
  }

  String _cohortValue(AppStrings s) {
    final choice = _w.cohortChoice;
    if (choice == 'main') return s.tr('Main environment', 'البيئة الرئيسية');
    final c = _chosenCohort;
    if (c != null) return '${c['displayName']} — ${c['url']}';
    if (choice.isNotEmpty) return s.tr('Cohort "$choice"', 'المجموعة "$choice"');
    return s.tr('Not selected yet (step 2)', 'لم تُختر بعد (الخطوة 2)');
  }

  bool get _cohortMismatch {
    final a = _activeCohort;
    if (a == null || _w.cohortChoice.isEmpty) return false;
    return _w.cohortChoice == 'main' ? a['isMain'] != true : _w.cohortChoice != a['subdomain'];
  }

  List<String> _stepTitles(AppStrings s) => [
        s.tr('System check', 'فحص النظام'),
        s.tr('Cohort', 'المجموعة'),
        s.tr('Session mode & branding', 'وضع الجلسة والهوية'),
        s.tr('Fresh start', 'بداية جديدة'),
        s.tr('Financial model integrity', 'سلامة النموذج المالي'),
        s.tr('Modules & features', 'الوحدات والميزات'),
        s.tr('Assessments', 'التقييمات'),
        s.tr('Timer', 'المؤقّت'),
        s.tr('Checklist', 'القائمة'),
        s.tr('Ready', 'جاهز'),
      ];

  static const _stepIcons = [
    Icons.monitor_heart_rounded,
    Icons.public_rounded,
    Icons.settings_rounded,
    Icons.delete_sweep_rounded,
    Icons.account_balance_rounded,
    Icons.account_balance_wallet_rounded,
    Icons.fact_check_rounded,
    Icons.timer_rounded,
    Icons.checklist_rounded,
    Icons.rocket_launch_rounded,
  ];

  Widget _statusIcon(StepStatus st, {double size = 18}) => switch (st) {
        StepStatus.green => Icon(Icons.check_circle_rounded, size: size, color: AppColors.secondaryLight),
        StepStatus.amber => Icon(Icons.error_rounded, size: size, color: AppColors.accentLight),
        StepStatus.pending => Icon(Icons.radio_button_unchecked_rounded, size: size, color: Colors.grey),
      };

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final titles = _stepTitles(s);
    final statuses = _statuses;
    final step = _w.activeStep.clamp(1, wizardStepCount);

    return Scaffold(
      appBar: AppBar(
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(s.tr('Session Setup Wizard', 'معالج إعداد الجلسة'), style: const TextStyle(fontSize: 17)),
          Text(s.tr('Pre-flight checklist - verify every requirement before the session starts',
                  'قائمة فحص مسبق - تحقّق من كل متطلب قبل بدء الجلسة'),
              style: TextStyle(fontSize: 11, color: AppColors.textTertiary(context))),
        ]),
        actions: [
          IconButton(
            tooltip: s.tr('Re-check', 'إعادة الفحص'),
            onPressed: _refresh,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient(context)),
        child: Column(children: [
          // Step rail
          SizedBox(
            height: 56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: wizardStepCount,
              separatorBuilder: (_, _) => const SizedBox(width: 6),
              itemBuilder: (_, i) {
                final active = step == i + 1;
                return ChoiceChip(
                  selected: active,
                  showCheckmark: false,
                  avatar: _statusIcon(statuses[i], size: 16),
                  label: Text('${i + 1}. ${titles[i]}', style: const TextStyle(fontSize: 12)),
                  onSelected: (_) => _setW(_w.copyWith(activeStep: i + 1)),
                );
              },
            ),
          ),
          Expanded(
            child: !_loaded
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                    children: [
                      GlassCard(
                        padding: const EdgeInsets.all(16),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            _statusIcon(statuses[step - 1]),
                            const SizedBox(width: 8),
                            Icon(_stepIcons[step - 1], size: 18, color: AppColors.primaryLight),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(s.tr('Step $step: ${titles[step - 1]}', 'الخطوة $step: ${titles[step - 1]}'),
                                  style: Theme.of(context).textTheme.titleMedium),
                            ),
                            if (step == 4)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppColors.dangerLight),
                                ),
                                child: Text(s.tr('Destructive', 'إجراء مدمّر'),
                                    style: const TextStyle(fontSize: 10, color: AppColors.dangerLight)),
                              ),
                          ]),
                          const SizedBox(height: 12),
                          _stepBody(s, step),
                        ]),
                      ),
                    ],
                  ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Row(children: [
                OutlinedButton.icon(
                  onPressed: step <= 1 ? null : () => _setW(_w.copyWith(activeStep: step - 1)),
                  icon: const Icon(Icons.arrow_back_rounded, size: 16),
                  label: Text(s.tr('Back', 'رجوع')),
                ),
                const Spacer(),
                Text(s.tr('Step $step of $wizardStepCount', 'الخطوة $step من $wizardStepCount'),
                    style: TextStyle(fontSize: 11, color: AppColors.textTertiary(context))),
                const Spacer(),
                FilledButton.icon(
                  onPressed: step >= wizardStepCount ? null : () => _setW(_w.copyWith(activeStep: step + 1)),
                  icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                  label: Text(s.tr('Next', 'التالي')),
                ),
              ]),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _stepBody(AppStrings s, int step) => switch (step) {
        1 => _systemStep(s),
        2 => _cohortStep(s),
        3 => _modeStep(s),
        4 => _freshStep(s),
        5 => _modelStep(s),
        6 => _modulesStep(s),
        7 => _assessStep(s),
        8 => _timerStep(s),
        9 => _checklistStep(s),
        _ => _readyStep(s),
      };

  // ── Shared pieces ──
  TextStyle _small(BuildContext c) => TextStyle(fontSize: 11, color: AppColors.textTertiary(c));

  Widget _box(Widget child, {Color? tint}) => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: (tint ?? AppColors.textTertiary(context)).withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: (tint ?? AppColors.borderColor(context)).withValues(alpha: tint == null ? 1 : 0.4)),
        ),
        child: child,
      );

  Widget _checkRow(AppStrings s, {required bool ok, required String label, String? detail}) => _box(Row(children: [
        Icon(ok ? Icons.check_circle_rounded : Icons.error_rounded,
            size: 18, color: ok ? AppColors.secondaryLight : AppColors.accentLight),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            if (detail != null) Text(detail, style: _small(context)),
          ]),
        ),
        Text(ok ? s.tr('OK', 'سليم') : s.tr('Attention', 'انتباه'),
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: ok ? AppColors.secondaryLight : AppColors.accentLight)),
      ]));

  Widget _confirm(AppStrings s, int step, String label) {
    final done = _w.isConfirmed(step);
    return _box(
      Row(children: [
        Expanded(
          child: Text(
            done
                ? s.tr('Confirmed for this session.', 'تم التأكيد لهذه الجلسة.')
                : s.tr('Confirm once the settings above look right for this session.',
                    'أكّد بعد أن تبدو الإعدادات أعلاه مناسبة لهذه الجلسة.'),
            style: const TextStyle(fontSize: 12),
          ),
        ),
        done
            ? OutlinedButton(
                onPressed: () => _setW(_w.withConfirmed(step, false)),
                child: Text(s.tr('Undo confirm', 'تراجع عن التأكيد')))
            : FilledButton.icon(
                onPressed: () => _setW(_w.withConfirmed(step, true)),
                icon: const Icon(Icons.check_circle_rounded, size: 16),
                label: Text(label),
              ),
      ]),
      tint: AppColors.primaryLight,
    );
  }

  Widget _switchRow(String title, String subtitle, bool value, ValueChanged<bool>? onChanged) => _box(Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            Text(subtitle, style: _small(context)),
          ]),
        ),
        Switch(value: value, onChanged: _busy ? null : onChanged),
      ]));

  // ── Step 1 ──
  Widget _systemStep(AppStrings s) {
    final sys = _sys;
    final dbStatus = (_health['services'] is Map && _health['services']['database'] is Map)
        ? _health['services']['database']['status']
        : null;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        s.tr('Read-only checks. Everything here must be green before the session - these re-run automatically every few seconds.',
            'فحوص للقراءة فقط. يجب أن يكون كل ما هنا أخضر قبل الجلسة - وتُعاد تلقائيًا كل بضع ثوانٍ.'),
        style: _small(context),
      ),
      const SizedBox(height: 8),
      _checkRow(s,
          ok: sys.api,
          label: s.tr('API health', 'سلامة واجهة البرمجة'),
          detail: _health.isEmpty
              ? 'GET /api/health'
              : 'status: ${_health['status']} · env: ${_health['config'] is Map ? _health['config']['env'] ?? '?' : '?'}'),
      _checkRow(s,
          ok: sys.db,
          label: s.tr('Database (PostgreSQL)', 'قاعدة البيانات (PostgreSQL)'),
          detail: _health.isEmpty ? null : 'status: ${dbStatus ?? 'unknown'}'),
      _checkRow(s,
          ok: sys.engine,
          label: s.tr('Financial Engine', 'المحرّك المالي'),
          detail: _conn.isEmpty ? 'GET /api/health/connection' : 'mode: ${_conn['mode']} · ${_conn['message'] ?? ''}'),
      _box(Row(children: [
        const Icon(Icons.radio_button_unchecked_rounded, size: 18, color: Colors.grey),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(s.tr('AI debrief coach', 'مدرّب النقاش بالذكاء الاصطناعي'),
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            Text(
              s.tr('Optional feature - no live status endpoint. Requires OPENAI_API_KEY or ANTHROPIC_API_KEY on the server; the debrief coach degrades gracefully when unavailable.',
                  'ميزة اختيارية - لا توجد نقطة حالة مباشرة. تتطلّب OPENAI_API_KEY أو ANTHROPIC_API_KEY على الخادم؛ ويتراجع مدرّب النقاش بسلاسة عند عدم توفّرها.'),
              style: _small(context),
            ),
          ]),
        ),
        Text(s.tr('Optional', 'اختياري'), style: _small(context)),
      ])),
    ]);
  }

  // ── Step 2 ──
  void _chooseCohort(AppStrings s, String choice) {
    _setW(_w.copyWith(cohortChoice: choice, confirmed: {..._w.confirmed, '2': true}));
    _toast(choice == 'main'
        ? s.tr('Continuing on main: this session will run on the main database schema.',
            'المتابعة على الرئيسية: ستعمل هذه الجلسة على قاعدة البيانات الرئيسية.')
        : s.tr('Cohort "$choice" selected: run the session on that cohort subdomain - its data is isolated from main.',
            'اختيرت المجموعة "$choice": شغّل الجلسة على نطاقها الفرعي - بياناتها معزولة عن الرئيسية.'));
  }

  Future<void> _provision(AppStrings s) async {
    setState(() => _busy = true);
    try {
      final res = await _repo.createCohort(_subdomain.text, _cohortName.text.trim());
      if (res['success'] != true) throw FacilitatorActionException((res['error'] ?? 'Request failed').toString());
      if (!mounted) return;
      setState(() => _provisioned = res['cohort'] is Map ? Map<String, dynamic>.from(res['cohort']) : null);
      _subdomain.clear();
      _cohortName.clear();
      _toast('${s.tr('Cohort provisioned', 'تم إنشاء المجموعة')}: ${_provisioned?['url'] ?? ''}');
    } catch (e) {
      _toast('${s.tr('Cohort provisioning failed', 'تعذّر إنشاء المجموعة')}: ${e is FacilitatorActionException ? e.message : e}',
          error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
      await _refresh();
    }
  }

  Widget _cohortStep(AppStrings s) {
    final subValid = wizardSubdomainRe.hasMatch(_subdomain.text);
    final nameValid = _cohortName.text.trim().isNotEmpty;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _box(
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            s.tr('Each cohort is an isolated database schema served from its own subdomain. Running every real session in its own cohort means one session\'s reset can never touch another cohort\'s data - recommended for research permanence.',
                'كل مجموعة قاعدة بيانات معزولة تُخدَم من نطاق فرعي خاص بها. تشغيل كل جلسة حقيقية في مجموعتها يعني أن إعادة ضبط جلسة لا يمكن أبدًا أن تمسّ بيانات مجموعة أخرى - وهو موصى به لديمومة بيانات البحث.'),
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            s.tr('This step is informational: pick (or provision) the cohort you will run on, then open that cohort\'s URL to run the session there. The wizard itself stays connected to the schema it was opened on.',
                'هذه الخطوة للمعلومات: اختر (أو أنشئ) المجموعة التي ستعمل عليها، ثم افتح رابطها لتشغيل الجلسة هناك. يبقى المعالج نفسه متصلًا بقاعدة البيانات التي فُتح عليها.'),
            style: _small(context),
          ),
        ]),
        tint: AppColors.primaryLight,
      ),
      Text(s.tr('Existing cohorts', 'المجموعات الحالية'), style: const TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: 6),
      if (_cohorts.isEmpty)
        _box(Text(s.tr('No cohorts provisioned yet - everything currently runs on the main schema.',
            'لم تُنشأ مجموعات بعد - كل شيء يعمل حاليًا على القاعدة الرئيسية.'), style: _small(context)))
      else
        ..._cohorts.map((c) {
          final sub = c['subdomain'].toString();
          final chosen = _w.cohortChoice == sub;
          return _box(
            Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('${c['displayName']}  ·  ${c['isActive'] == false ? s.tr('inactive', 'غير نشطة') : s.tr('active', 'نشطة')}',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  Text('$sub · ${c['url']}', style: GoogleFonts.jetBrainsMono(fontSize: 10)),
                  Text(
                    c['research'] == true
                        ? s.tr('DBA study cohort', 'مجموعة دراسة الدكتوراه')
                        : s.tr('Commercial delivery · enrol it in the Cohorts panel if this is a research cohort',
                            'تقديم تجاري · سجّلها من لوحة المجموعات إن كانت مجموعة بحث'),
                    style: TextStyle(fontSize: 11, color: c['research'] == true ? AppColors.purple : AppColors.textTertiary(context)),
                  ),
                ]),
              ),
              chosen
                  ? FilledButton.icon(
                      onPressed: null,
                      icon: const Icon(Icons.check_circle_rounded, size: 14),
                      label: Text(s.tr('Session cohort', 'مجموعة الجلسة'), style: const TextStyle(fontSize: 11)))
                  : OutlinedButton(
                      onPressed: () => _chooseCohort(s, sub),
                      child: Text(s.tr('Use this cohort', 'استخدم هذه المجموعة'), style: const TextStyle(fontSize: 11))),
            ]),
            tint: chosen ? AppColors.primaryLight : null,
          );
        }),
      const SizedBox(height: 6),
      _box(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(s.tr('Provision new cohort', 'إنشاء مجموعة جديدة'), style: const TextStyle(fontWeight: FontWeight.w600)),
        TextField(
          controller: _subdomain,
          autocorrect: false,
          onChanged: (v) {
            final lower = v.toLowerCase();
            if (lower != v) {
              _subdomain.value = _subdomain.value.copyWith(text: lower);
            }
          },
          decoration: InputDecoration(
            isDense: true,
            labelText: s.tr('Subdomain (lowercase letters, digits, hyphens)', 'النطاق الفرعي (أحرف صغيرة وأرقام وشرطات)'),
            hintText: 'june-cohort',
            errorText: _subdomain.text.isNotEmpty && !subValid
                ? s.tr('Use 1-40 lowercase letters, digits or hyphens (no leading/trailing hyphen).',
                    'استخدم من 1 إلى 40 حرفًا صغيرًا أو رقمًا أو شرطة (دون شرطة في البداية أو النهاية).')
                : null,
            errorMaxLines: 2,
          ),
        ),
        TextField(
          controller: _cohortName,
          decoration: InputDecoration(
              isDense: true, labelText: s.tr('Display name', 'الاسم المعروض'), hintText: 'June 2026 Workshop'),
        ),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: (_busy || !subValid || !nameValid) ? null : () => _provision(s),
          child: Text(_busy ? s.tr('Provisioning…', 'جارٍ الإنشاء…') : s.tr('Provision new cohort', 'إنشاء مجموعة جديدة')),
        ),
        if (_provisioned != null) ...[
          const SizedBox(height: 8),
          Text(s.tr('Cohort "${_provisioned!['displayName']}" is ready', 'المجموعة "${_provisioned!['displayName']}" جاهزة'),
              style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.secondaryLight)),
          Row(children: [
            Expanded(child: SelectableText('${_provisioned!['url']}', style: GoogleFonts.jetBrainsMono(fontSize: 12))),
            IconButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: '${_provisioned!['url']}'));
                _toast(s.tr('Cohort URL copied', 'تم نسخ رابط المجموعة'));
              },
              icon: const Icon(Icons.copy_rounded, size: 16),
            ),
          ]),
        ],
      ])),
      _box(
        Row(children: [
          Expanded(
            child: Text(
              _w.isConfirmed(2)
                  ? (_w.cohortChoice == 'main'
                      ? s.tr('Confirmed: continue on the main schema.', 'تم التأكيد: المتابعة على القاعدة الرئيسية.')
                      : s.tr('Confirmed: run this session on cohort "${_w.cohortChoice}".',
                          'تم التأكيد: شغّل هذه الجلسة على المجموعة "${_w.cohortChoice}".'))
                  : s.tr('Choose a cohort above, or continue on the main schema.',
                      'اختر مجموعة أعلاه، أو تابع على القاعدة الرئيسية.'),
              style: const TextStyle(fontSize: 12),
            ),
          ),
          _w.isConfirmed(2)
              ? OutlinedButton(
                  onPressed: () => _setW(_w.copyWith(cohortChoice: '', confirmed: {..._w.confirmed, '2': false})),
                  child: Text(s.tr('Undo confirm', 'تراجع عن التأكيد')))
              : OutlinedButton.icon(
                  onPressed: () => _chooseCohort(s, 'main'),
                  icon: const Icon(Icons.check_circle_rounded, size: 16),
                  label: Text(s.tr('Continue on main', 'المتابعة على الرئيسية'))),
        ]),
        tint: AppColors.primaryLight,
      ),
    ]);
  }

  // ── Step 3 ──
  Widget _modeStep(AppStrings s) {
    final gs = _gs;
    final mode = (gs['gameMode'] ?? 'facilitator').toString();
    final branding = _branding['branding'] is Map ? Map<String, dynamic>.from(_branding['branding']) : {};
    _brandTitle ??= TextEditingController(text: (branding['titleEn'] ?? '').toString());
    _brandClient ??= TextEditingController(text: (branding['clientName'] ?? '').toString());
    final corp = gs['corporateModeEnabled'] == true;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _box(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(s.tr('Game mode', 'وضع اللعبة'), style: const TextStyle(fontWeight: FontWeight.w600)),
        Text(s.tr('current: $mode', 'الحالي: $mode'), style: _small(context)),
        const SizedBox(height: 6),
        Wrap(spacing: 8, children: [
          OutlinedButton(
            onPressed: (_busy || mode == 'facilitator')
                ? null
                : () => _act(() => _repo.setGameMode('facilitator'),
                    s.tr('Game mode set to Facilitator', 'ضُبط وضع اللعبة على الميسّر')),
            child: Text(s.tr('Facilitator mode', 'وضع الميسّر')),
          ),
          OutlinedButton(
            onPressed: (_busy || mode == 'self-paced')
                ? null
                : () => _act(() => _repo.setGameMode('self-paced'),
                    s.tr('Game mode set to Self-Paced', 'ضُبط وضع اللعبة على التعلّم الذاتي')),
            child: Text(s.tr('Self-paced mode', 'وضع التعلّم الذاتي')),
          ),
        ]),
      ])),
      _switchRow(
        s.tr('Corporate mode', 'وضع الشركات'),
        corp
            ? s.tr('Enabled${gs['corporateAccessCode'] != null ? ' - access code: ${gs['corporateAccessCode']}' : ''}',
                'مفعّل${gs['corporateAccessCode'] != null ? ' - رمز الدخول: ${gs['corporateAccessCode']}' : ''}')
            : s.tr('Disabled - only Self-Paced mode is available to users', 'متوقّف - يتاح للمستخدمين وضع التعلّم الذاتي فقط'),
        corp,
        (v) => _act(() async { await _repo.toggleCorporateMode(v); },
            v ? s.tr('Corporate mode enabled', 'فُعّل وضع الشركات') : s.tr('Corporate mode disabled', 'أُوقف وضع الشركات')),
      ),
      _box(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(s.tr('Branding', 'الهوية'), style: const TextStyle(fontWeight: FontWeight.w600)),
        TextField(
            controller: _brandTitle,
            decoration: InputDecoration(isDense: true, labelText: s.tr('App title (English)', 'عنوان التطبيق (بالإنجليزية)'), hintText: 'FinPlay')),
        TextField(
            controller: _brandClient,
            decoration: InputDecoration(
                isDense: true, labelText: s.tr('Client name', 'اسم العميل'), hintText: s.tr('Client / cohort name', 'اسم العميل / المجموعة'))),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: _busy
              ? null
              : () => _act(() => _repo.saveBranding({'titleEn': _brandTitle!.text, 'clientName': _brandClient!.text}),
                  s.tr('Branding saved', 'تم حفظ الهوية')),
          child: Text(s.tr('Save branding', 'حفظ الهوية')),
        ),
      ])),
      _confirm(s, 3, s.tr('Looks right', 'يبدو صحيحًا')),
    ]);
  }

  // ── Step 4 ──
  List<(String, String, List<String>, Future<Map<String, dynamic>?> Function(String adminPw))> _freshActions(AppStrings s) => [
        (
          'reset-game',
          s.tr('Reset game', 'إعادة ضبط اللعبة'),
          [
            s.tr('All team decisions for all rounds (archived to the research archive first)',
                'كل قرارات الفرق لكل الجولات (تُؤرشف أولًا في أرشيف البحث)'),
            s.tr('Game state back to Round 1 · Financing (all module locks cleared)',
                'حالة اللعبة تعود إلى الجولة 1 · التمويل (تُزال كل أقفال الوحدات)'),
            s.tr('All team sign-ins and team leaders', 'كل تسجيلات دخول الفرق وقادتها'),
            s.tr('Corporate education progress for Team 1-7', 'تقدّم التعليم المؤسسي للفرق 1-7'),
            s.tr('Lobby closed until teams rejoin', 'تُغلق الردهة حتى تنضمّ الفرق مجددًا'),
          ],
          (pw) => _repo.resetGameArchived(pw),
        ),
        (
          'clear-leaders',
          s.tr('Clear team leaders', 'مسح قادة الفرق'),
          [s.tr('All team-leader assignments (members become view-only until a new leader is set)',
              'كل تعيينات قادة الفرق (يصبح الأعضاء للعرض فقط حتى يُعيَّن قائد جديد)')],
          (_) async { await _repo.clearTeamLeaders(); return null; },
        ),
        (
          'clear-shocks',
          s.tr('Clear applied shocks', 'مسح الصدمات المطبّقة'),
          [
            s.tr('All active/applied market shocks', 'كل صدمات السوق النشطة/المطبّقة'),
            s.tr('Model assumptions restored to template baselines', 'تُعاد افتراضات النموذج إلى قيم القالب الأساسية'),
          ],
          (_) async { await _repo.clearAllShocksReverting(); return null; },
        ),
        (
          'resolve-forecasts',
          s.tr('Resolve active forecasts', 'تسوية التوقّعات النشطة'),
          [s.tr('All unresolved market-wire forecasts (removed from the ticker)', 'كل توقّعات شريط السوق غير المسوّاة (تُزال من الشريط)')],
          (_) async {
            final open = await _repo.fetchForecasts();
            for (final f in open) {
              await _repo.resolveForecast(f['id'].toString());
            }
            return {'message': '${open.length} forecast(s) resolved'};
          },
        ),
      ];

  Future<void> _confirmFresh(AppStrings s, String actionId) async {
    final actions = _freshActions(s);
    final chosen = actionId == 'all' ? actions : actions.where((a) => a.$1 == actionId).toList();
    final wipes = chosen.expand((a) => a.$3).toList();
    final needsAdmin = chosen.any((a) => a.$1 == 'reset-game');
    final pwC = TextEditingController(text: ref.read(apiClientProvider).dio.options.headers['x-facilitator-password']?.toString() ?? '');
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(actionId == 'all' ? s.tr('Run full fresh start', 'تشغيل بداية جديدة كاملة') : chosen.first.$2),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(s.tr('Wipes ${_activeCohortLabel(s)}:', 'سيُمسح من ${_activeCohortLabel(s)}:'),
                style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.dangerLight)),
            const SizedBox(height: 6),
            for (final w in wipes) Text('• $w', style: const TextStyle(fontSize: 12)),
            if (needsAdmin) ...[
              const SizedBox(height: 10),
              TextField(
                controller: pwC,
                obscureText: true,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: s.tr('Admin password', 'كلمة مرور المسؤول'),
                  helperText: s.tr('Destructive resets require the admin password.', 'تتطلّب عمليات إعادة الضبط المدمّرة كلمة مرور المسؤول.'),
                ),
              ),
            ],
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(s.tr('Cancel', 'إلغاء'))),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(s.tr('Run', 'تشغيل')),
          ),
        ],
      ),
    );
    final adminPw = pwC.text;
    pwC.dispose();
    if (ok != true || !mounted) return;
    setState(() => _freshRunning = true);
    try {
      for (final a in chosen) {
        final res = await a.$4(adminPw);
        final batch = res?['archiveBatchId'];
        if (batch != null) {
          _lastArchiveBatchId = batch.toString();
          SharedPreferences.getInstance().then((p) => p.setString(lastArchiveKey, batch.toString())).ignore();
        }
        _toast(batch != null
            ? s.tr('${a.$2} - done: ${res?['archivedDecisions'] ?? 0} decision(s) moved to the research archive - batch $batch',
                '${a.$2} - تم: نُقل ${res?['archivedDecisions'] ?? 0} قرار إلى أرشيف البحث - الدفعة $batch')
            : s.tr('${a.$2} - done', '${a.$2} - تم'));
      }
    } catch (e) {
      final msg = e is FacilitatorActionException ? e.message : e.toString();
      _toast(
        RegExp('invalid password', caseSensitive: false).hasMatch(msg)
            ? s.tr('Fresh start failed: Invalid admin password. Destructive resets require the admin password.',
                'فشلت البداية الجديدة: كلمة مرور المسؤول غير صحيحة. تتطلّب عمليات إعادة الضبط المدمّرة كلمة مرور المسؤول.')
            : '${s.tr('Fresh start failed', 'فشلت البداية الجديدة')}: $msg',
        error: true,
      );
    } finally {
      if (mounted) setState(() => _freshRunning = false);
      await _refresh();
    }
  }

  Widget _freshStep(AppStrings s) {
    final f = _fresh;
    final a = _activeCohort;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _box(
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(s.tr('EVERYTHING ON THIS STEP WIPES', 'كل ما في هذه الخطوة يمسح'), style: _small(context)),
          Text(_activeCohortLabel(s), style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.dangerLight)),
          Text(
            s.tr('Database schema ${a?['schema'] ?? '…'}. The target is the address this device is connected to, not the cohort picked in step 2. To wipe a different cohort, connect to its own address and run Fresh Start there.',
                'قاعدة البيانات ${a?['schema'] ?? '…'}. الهدف هو العنوان المتصل به هذا الجهاز، لا المجموعة المختارة في الخطوة 2. لمسح مجموعة أخرى، اتصل بعنوانها وشغّل البداية الجديدة هناك.'),
            style: _small(context),
          ),
        ]),
        tint: AppColors.dangerLight,
      ),
      if (_cohortMismatch)
        _box(
          Text(
            s.tr('Wrong address for this session. You chose ${_cohortValue(s)} in step 2, but this device is on ${_activeCohortLabel(s)}. Running Fresh Start here wipes ${_activeCohortLabel(s)} and leaves your session cohort untouched.',
                'عنوان خاطئ لهذه الجلسة. اخترت ${_cohortValue(s)} في الخطوة 2، لكن هذا الجهاز على ${_activeCohortLabel(s)}. تشغيل البداية الجديدة هنا يمسح ${_activeCohortLabel(s)} ويترك مجموعة جلستك دون تغيير.'),
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          tint: AppColors.accentLight,
        ),
      _box(
        Text(
          s.tr('Destructive. These actions wipe last session\'s data so this session starts clean. Each button shows exactly what it deletes before running.',
              'إجراء مدمّر. تمسح هذه الإجراءات بيانات الجلسة السابقة لتبدأ هذه الجلسة نظيفة. يعرض كل زر بالضبط ما سيحذفه قبل التشغيل.'),
          style: const TextStyle(fontSize: 12),
        ),
        tint: AppColors.dangerLight,
      ),
      _box(
        Text(
          s.tr('Data is archived before deletion - decisions are moved to the research archive, never destroyed.',
              'تُؤرشف البيانات قبل الحذف - تُنقل القرارات إلى أرشيف البحث ولا تُتلف أبدًا.'),
          style: const TextStyle(fontSize: 12),
        ),
        tint: AppColors.secondaryLight,
      ),
      for (final act in _freshActions(s))
        _box(Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(act.$2, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              Text(act.$3.first, style: _small(context), maxLines: 2, overflow: TextOverflow.ellipsis),
            ]),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.dangerLight),
            onPressed: _freshRunning ? null : () => _confirmFresh(s, act.$1),
            child: Text(s.tr('Run', 'تشغيل')),
          ),
        ])),
      SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
          onPressed: _freshRunning ? null : () => _confirmFresh(s, 'all'),
          icon: const Icon(Icons.delete_sweep_rounded, size: 16),
          label: Text(_freshRunning
              ? s.tr('Running fresh start…', 'جارٍ تشغيل البداية الجديدة…')
              : s.tr('Run full fresh start', 'تشغيل بداية جديدة كاملة')),
        ),
      ),
      const SizedBox(height: 12),
      Text(s.tr('Verification', 'التحقّق'), style: const TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: 6),
      _checkRow(s,
          ok: f.round,
          label: s.tr('Round state = Round 1 · Financing', 'حالة الجولة = الجولة 1 · التمويل'),
          detail: _roundState.isEmpty
              ? null
              : s.tr('currently Round ${_roundState['roundNum']} · ${_roundState['module']}',
                  'حاليًا الجولة ${_roundState['roundNum']} · ${_roundState['module']}')),
      _checkRow(s,
          ok: f.decisions && f.teamRounds,
          label: s.tr('Zero confirmed decisions, all teams at Round 1', 'صفر قرارات مؤكّدة، وكل الفرق في الجولة 1'),
          detail: _teams == null
              ? null
              : s.tr('${f.teamCount} team(s), ${f.decisionCount} decision(s) on record',
                  '${f.teamCount} فريق، ${f.decisionCount} قرار مسجّل')),
      _checkRow(s,
          ok: f.shocks,
          label: s.tr('Zero active shocks', 'صفر صدمات نشطة'),
          detail: s.tr('${f.shockCount} active shock(s)', '${f.shockCount} صدمة نشطة')),
      _checkRow(s,
          ok: f.forecasts,
          label: s.tr('Zero open forecasts', 'صفر توقّعات مفتوحة'),
          detail: s.tr('${f.forecastCount} open forecast(s)', '${f.forecastCount} توقّع مفتوح')),
      _checkRow(s,
          ok: f.leaders,
          label: s.tr('Zero team leaders assigned', 'صفر قادة فرق معيّنين'),
          detail: s.tr('${f.leaderCount} leader(s) assigned', '${f.leaderCount} قائد معيّن')),
    ]);
  }

  // ── Step 5 ──
  Widget _modelStep(AppStrings s) {
    final m = _model;
    String fmt(double? v) => v == null ? '—' : (v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(4).replaceAll(RegExp(r'0+$'), ''));
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        s.tr('Base model parameters (assumption rows 2-13, Round 1). These drive every IFRS statement the engine computes.',
            'معاملات النموذج الأساسية (صفوف الافتراضات 2-13، الجولة 1). تقود كل قائمة وفق IFRS يحسبها المحرّك.'),
        style: _small(context),
      ),
      const SizedBox(height: 8),
      if (!m.baseRowsPresent || !m.nonDegenerate)
        _box(
          Text(
            '${s.tr('Model problem:', 'مشكلة في النموذج:')} '
            '${!m.baseRowsPresent ? s.tr('only ${m.baseRows.length} of 12 base parameter rows found. ', 'وُجد ${m.baseRows.length} فقط من 12 صفًا للمعاملات الأساسية. ') : ''}'
            '${!m.nonDegenerate ? s.tr('Sales Growth is 0 or missing - statements will be degenerate. ', 'نمو المبيعات صفر أو مفقود - ستكون القوائم بلا معنى. ') : ''}'
            '${s.tr('Fix this in the Model Editor before running the session.', 'أصلح ذلك في محرّر النموذج قبل تشغيل الجلسة.')}',
            style: const TextStyle(fontSize: 12, color: AppColors.dangerLight),
          ),
          tint: AppColors.dangerLight,
        )
      else if (m.mismatches.isNotEmpty)
        _box(
          Text(
            s.tr('Warning: parameters differ from the standard defaults (${m.mismatches.map((x) => x.$2).join(', ')}). If this is not intentional, restore them in the Model Editor.',
                'تحذير: تختلف المعاملات عن القيم الافتراضية القياسية (${m.mismatches.map((x) => x.$3).join('، ')}). إن لم يكن ذلك مقصودًا، فأعدها في محرّر النموذج.'),
            style: const TextStyle(fontSize: 12),
          ),
          tint: AppColors.accentLight,
        ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 32,
          dataRowMinHeight: 30,
          dataRowMaxHeight: 40,
          columnSpacing: 16,
          columns: [
            DataColumn(label: Text(s.tr('Row', 'الصف'))),
            DataColumn(label: Text(s.tr('Parameter', 'المعامل'))),
            DataColumn(numeric: true, label: Text(s.tr('Value', 'القيمة'))),
            DataColumn(numeric: true, label: Text(s.tr('Expected', 'المتوقّع'))),
          ],
          rows: [
            for (final r in m.baseRows)
              () {
                final exp = expectedModelParams.where((p) => p.$1 == r['paramKey']).firstOrNull;
                final v = double.tryParse('${r['value']}');
                final matches = exp == null || (v != null && (v - exp.$4).abs() <= 1e-9);
                return DataRow(
                  color: WidgetStatePropertyAll(matches ? null : AppColors.accentLight.withValues(alpha: 0.12)),
                  cells: [
                    DataCell(Text('${r['excelRow']}')),
                    DataCell(Text('${r['label'] ?? r['paramKey']}', style: const TextStyle(fontSize: 12))),
                    DataCell(Text(fmt(v), style: GoogleFonts.jetBrainsMono(fontSize: 12))),
                    DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
                      Text(exp == null ? '—' : '${exp.$4}', style: _small(context)),
                      if (exp != null)
                        Icon(matches ? Icons.check_circle_rounded : Icons.error_rounded,
                            size: 12, color: matches ? AppColors.secondaryLight : AppColors.accentLight),
                    ])),
                  ],
                );
              }(),
          ],
        ),
      ),
      const SizedBox(height: 8),
      Text(
        s.tr('Edit the model from the Model Editor in the facilitator panel (Settings).',
            'عدّل النموذج من محرّر النموذج في لوحة الميسّر (الإعدادات).'),
        style: _small(context),
      ),
    ]);
  }

  // ── Step 6 ──
  Widget _modulesStep(AppStrings s) {
    final realism = _realism;
    final edu = _education;
    final unlockedCount = (edu['educationModulesUnlocked'] as List<dynamic>? ?? []).length;
    // Website FORCE_UNLOCKABLE_MODULE_NUMS: every catalog module except the game.
    final forceUnlockable = educationCatalog.where((m) => !m.isSimulation).length;
    final capUnlocked = (_gs['capitalBudgetingResultsUnlocked'] as List<dynamic>? ?? []).isNotEmpty;
    final cov = realism['covenantThresholds'] is Map ? Map<String, dynamic>.from(realism['covenantThresholds']) : {};
    _covDte ??= TextEditingController(text: '${cov['maxDebtToEbitda'] ?? 4.0}');
    _covCov ??= TextEditingController(text: '${cov['minInterestCoverage'] ?? 2.0}');

    Widget flagRow((String, String, String, String, String) m) => _switchRow(
          s.tr(m.$2, m.$3),
          s.tr(m.$4, m.$5),
          realism[m.$1] == true,
          (v) => _act(() async {
            final ok = await _repo.toggleRealism(m.$1, v);
            if (!ok) throw FacilitatorActionException(s.tr('Request failed', 'تعذّر الطلب'));
          }, '${m.$1} ${v ? s.tr('enabled', 'مفعّل') : s.tr('disabled', 'متوقّف')}'),
        );

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(s.tr('Finance realism modules', 'وحدات الواقعية المالية'), style: const TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: 6),
      ...wizardRealismModules.map(flagRow),
      const SizedBox(height: 6),
      Text(s.tr('Ratio analytics', 'تحليلات النسب'), style: const TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: 6),
      ...wizardRatioModules.map(flagRow),
      if (realism['debtCovenantsEnabled'] == true)
        _box(
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(s.tr('Covenant thresholds (defaults 4.0 / 2.0)', 'حدود التعهّدات (الافتراضي 4.0 / 2.0)'),
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            Row(children: [
              Expanded(
                child: TextField(
                  controller: _covDte,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(isDense: true, labelText: s.tr('Max Debt / EBITDA', 'الحد الأقصى للدين / EBITDA')),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _covCov,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(isDense: true, labelText: s.tr('Min Interest Coverage', 'الحد الأدنى لتغطية الفائدة')),
                ),
              ),
            ]),
            const SizedBox(height: 6),
            OutlinedButton(
              onPressed: _busy
                  ? null
                  : () {
                      final dte = double.tryParse(_covDte!.text);
                      final cv = double.tryParse(_covCov!.text);
                      if (dte == null || dte <= 0) {
                        _toast(s.tr('Invalid Debt/EBITDA threshold: must be a positive number.',
                            'حد الدين/EBITDA غير صالح: يجب أن يكون رقمًا موجبًا.'), error: true);
                        return;
                      }
                      if (cv == null || cv < 0) {
                        _toast(s.tr('Invalid Interest Coverage threshold: must be a non-negative number.',
                            'حد تغطية الفائدة غير صالح: يجب ألا يكون سالبًا.'), error: true);
                        return;
                      }
                      _act(() => _repo.saveCovenantThresholds(dte, cv),
                          s.tr('Covenant thresholds saved', 'تم حفظ حدود التعهّدات'));
                    },
              child: Text(s.tr('Save thresholds', 'حفظ الحدود')),
            ),
          ]),
          tint: AppColors.warning,
        ),
      const SizedBox(height: 6),
      Text(s.tr('Education unlocks', 'فتح التعليم'), style: const TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: 6),
      _switchRow(
        s.tr('Education modules access', 'الوصول إلى وحدات التعليم'),
        s.tr('Master unlock for the education portal (incl. Break-Even access for teams)',
            'الفتح الرئيسي لبوابة التعليم (بما فيها وصول الفرق إلى نقطة التعادل)'),
        edu['educationUnlocked'] == true,
        (v) => _act(() async { await _repo.toggleEducation(v); },
            v ? s.tr('Education modules unlocked', 'فُتحت وحدات التعليم') : s.tr('Education modules locked', 'أُقفلت وحدات التعليم')),
      ),
      _switchRow(
        s.tr('All $forceUnlockable individual education modules', 'كل وحدات التعليم الفردية ($forceUnlockable)'),
        s.tr('$unlockedCount of $forceUnlockable currently unlocked', '$unlockedCount من $forceUnlockable مفتوحة حاليًا'),
        unlockedCount >= forceUnlockable,
        (v) => _act(() async { await _repo.toggleAllEducationModules(v); },
            v ? s.tr('All modules unlocked', 'فُتحت كل الوحدات') : s.tr('All modules locked', 'أُقفلت كل الوحدات')),
      ),
      _switchRow(
        s.tr('Capital Budgeting scenario results', 'نتائج سيناريوهات موازنة رأس المال'),
        s.tr('Reveal NPV/IRR answer results to learners', 'كشف نتائج صافي القيمة الحالية/معدل العائد الداخلي للمتعلّمين'),
        capUnlocked,
        (v) => _act(() => _repo.setScenarioResultsVisible(v),
            v ? s.tr('Scenario results revealed', 'كُشفت نتائج السيناريوهات') : s.tr('Scenario results hidden', 'أُخفيت نتائج السيناريوهات')),
      ),
      _switchRow(
        s.tr('Activity retry', 'إعادة محاولة الأنشطة'),
        s.tr('Allow students to retry education activities', 'السماح للمتعلّمين بإعادة محاولة أنشطة التعليم'),
        edu['educationRetryUnlocked'] == true,
        (v) => _act(() async { await _repo.toggleEducationRetry(v); },
            v ? s.tr('Retry unlocked', 'فُتحت إعادة المحاولة') : s.tr('Retry locked', 'أُقفلت إعادة المحاولة')),
      ),
      const SizedBox(height: 6),
      Text(s.tr('Slide narration', 'التعليق الصوتي للشرائح'), style: const TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: 6),
      NarrationPrewarm(repo: _repo),
      const SizedBox(height: 8),
      _confirm(s, 6, s.tr('Confirm selection', 'تأكيد الاختيار')),
    ]);
  }

  // ── Step 7 ──
  Widget _assessStep(AppStrings s) {
    Widget row(String kind, Map<String, dynamic> st) {
      final mandated = st['mandated'] == true;
      return _switchRow(
        kind == 'pre' ? s.tr('Pre-course assessment', 'تقييم ما قبل الدورة') : s.tr('Post-course assessment', 'تقييم ما بعد الدورة'),
        mandated
            ? s.tr('Mandated - participants cannot skip it', 'إلزامي - لا يمكن للمشاركين تخطّيه')
            : s.tr('Optional - participants may skip it', 'اختياري - يمكن للمشاركين تخطّيه'),
        mandated,
        (v) => _act(() async { await _repo.setAssessmentMandate(kind, v); },
            kind == 'pre'
                ? (v ? s.tr('Pre-course assessment mandated', 'أصبح تقييم ما قبل الدورة إلزاميًا') : s.tr('Pre-course assessment made optional', 'أصبح تقييم ما قبل الدورة اختياريًا'))
                : (v ? s.tr('Post-course assessment mandated', 'أصبح تقييم ما بعد الدورة إلزاميًا') : s.tr('Post-course assessment made optional', 'أصبح تقييم ما بعد الدورة اختياريًا'))),
      );
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        s.tr('Decide whether the pre- and post-course knowledge assessments are required for this cohort.',
            'قرّر هل تقييمات المعرفة قبل الدورة وبعدها مطلوبة لهذه المجموعة.'),
        style: _small(context),
      ),
      const SizedBox(height: 8),
      row('pre', _assessPre),
      row('post', _assessPost),
      _confirm(s, 7, s.tr('Confirm selection', 'تأكيد الاختيار')),
    ]);
  }

  // ── Step 8 ──
  Widget _timerStep(AppStrings s) {
    final gs = _gs;
    final remainingMin = (((gs['timeRemaining'] as num?) ?? 0) / 60).round();
    _overlaySeconds ??= TextEditingController(text: '${_timerOverlay['durationSeconds'] ?? 300}');
    final pages = (_timerOverlay['pages'] as List<dynamic>? ?? []).join(', ');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _box(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(s.tr('Per-module decision timer', 'مؤقّت القرار لكل وحدة'), style: const TextStyle(fontWeight: FontWeight.w600)),
        Text(
          s.tr('Current game timer: $remainingMin min remaining${gs['isActive'] == true ? ' (active)' : ' (not running)'}. The duration below is used when the game starts from the Ready step - the timer is not started here.',
              'مؤقّت اللعبة الحالي: متبقٍ $remainingMin دقيقة${gs['isActive'] == true ? ' (يعمل)' : ' (متوقّف)'}. تُستخدم المدة أدناه عند بدء اللعبة من خطوة الجاهزية - لا يبدأ المؤقّت هنا.'),
          style: _small(context),
        ),
        Row(children: [
          SizedBox(
            width: 140,
            child: TextField(
              controller: _timerMinutes,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(isDense: true, labelText: s.tr('Minutes per module (1-120)', 'دقائق لكل وحدة (1-120)')),
              onChanged: (v) {
                final n = (int.tryParse(v) ?? 20).clamp(1, 120);
                _setW(_w.copyWith(timerMinutes: n));
              },
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: _busy
                ? null
                : () => _act(() async {
                      final res = await _repo.updateTimer(_w.timerMinutes);
                      if (res['success'] == false || res['error'] != null) {
                        throw FacilitatorActionException((res['error'] ?? res['message'] ?? 'Request failed').toString());
                      }
                    },
                        s.tr('Module timer set to ${_w.timerMinutes} minutes. Saved; this duration is also passed to Start game on the Ready step.',
                            'ضُبط مؤقّت الوحدة على ${_w.timerMinutes} دقيقة. حُفظ؛ وتُمرَّر هذه المدة أيضًا إلى بدء اللعبة في خطوة الجاهزية.')),
            child: Text(s.tr('Save duration', 'حفظ المدة')),
          ),
        ]),
      ])),
      _box(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(s.tr('Timer overlay', 'المؤقّت المعروض'), style: const TextStyle(fontWeight: FontWeight.w600)),
        Text(
          s.tr('Countdown overlay shown on team pages (${pages.isEmpty ? '—' : pages}). Currently ${_timerOverlay['isRunning'] == true ? 'running' : 'stopped'} · ${_timerOverlay['durationSeconds'] ?? 300}s configured.',
              'عدّاد تنازلي يظهر على صفحات الفرق (${pages.isEmpty ? '—' : pages}). حاليًا ${_timerOverlay['isRunning'] == true ? 'يعمل' : 'متوقّف'} · ${_timerOverlay['durationSeconds'] ?? 300} ثانية مضبوطة.'),
          style: _small(context),
        ),
        Row(children: [
          SizedBox(
            width: 140,
            child: TextField(
              controller: _overlaySeconds,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(isDense: true, labelText: s.tr('Overlay duration (seconds)', 'مدة العرض (ثوانٍ)')),
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: _busy
                ? null
                : () {
                    final secs = int.tryParse(_overlaySeconds!.text);
                    if (secs == null || secs < 1 || secs > 7200) {
                      _toast(s.tr('Invalid duration: must be between 1 and 7200 seconds.', 'مدة غير صالحة: يجب أن تكون بين 1 و7200 ثانية.'),
                          error: true);
                      return;
                    }
                    _act(() => _repo.saveTimerOverlaySeconds(secs), s.tr('Timer overlay settings saved', 'تم حفظ إعدادات المؤقّت المعروض'));
                  },
            child: Text(s.tr('Save overlay settings', 'حفظ إعدادات العرض')),
          ),
        ]),
      ])),
      _confirm(s, 8, s.tr('Confirm timer settings', 'تأكيد إعدادات المؤقّت')),
    ]);
  }

  // ── Step 9 ──
  List<(String, String, bool, String)> _preflight(AppStrings s) {
    final sys = _sys;
    final m = _model;
    final enabled = [...wizardRealismModules, ...wizardRatioModules]
        .where((x) => _realism[x.$1] == true)
        .map((x) => s.tr(x.$2, x.$3))
        .toList();
    final pre = _assessPre['mandated'] == true;
    final post = _assessPost['mandated'] == true;
    final health = _health['services'] is Map && _health['services']['database'] is Map ? _health['services']['database']['status'] : '?';
    return [
      ('system-health', s.tr('System health', 'سلامة النظام'), sys.api && sys.db && sys.engine,
          'API ${_health['status'] ?? '?'} · database $health · engine ${_conn['mode'] ?? '?'}'),
      ('cohort', s.tr('Cohort', 'المجموعة'), _w.isConfirmed(2), _cohortValue(s)),
      (
        'fresh-start',
        s.tr('Fresh start', 'بداية جديدة'),
        _step4 == StepStatus.green,
        _lastArchiveBatchId != null
            ? s.tr('Reset run this session — archive batch $_lastArchiveBatchId', 'نُفّذت إعادة الضبط في هذه الجلسة — دفعة الأرشيف $_lastArchiveBatchId')
            : _step4 == StepStatus.green
                ? s.tr('Environment verified clean (no reset run this session)', 'تم التحقّق من نظافة البيئة (لم تُنفّذ إعادة ضبط في هذه الجلسة)')
                : s.tr('Not clean — run Fresh start (step 4)', 'غير نظيفة — شغّل البداية الجديدة (الخطوة 4)'),
      ),
      (
        'model-integrity',
        s.tr('Model integrity', 'سلامة النموذج'),
        _step5 == StepStatus.green,
        '${s.tr('Sales Growth', 'نمو المبيعات')} = ${m.salesGrowth ?? s.tr('missing', 'مفقود')}'
            '${m.mismatches.isNotEmpty ? ' · ${s.tr('off-default', 'خارج الافتراضي')}: ${m.mismatches.map((x) => s.tr(x.$2, x.$3)).join(', ')}' : ''}',
      ),
      (
        'enabled-modules',
        s.tr('Enabled modules (${enabled.length})', 'الوحدات المفعّلة (${enabled.length})'),
        _realism.isNotEmpty,
        enabled.isEmpty ? s.tr('None enabled', 'لا شيء مفعّل') : enabled.join(' · '),
      ),
      (
        'assessments',
        s.tr('Assessments', 'التقييمات'),
        _assessPre.isNotEmpty && _assessPost.isNotEmpty,
        s.tr('Pre-assessment ${pre ? 'mandated' : 'optional'} · Post-assessment ${post ? 'mandated' : 'optional'}',
            'التقييم القبلي ${pre ? 'إلزامي' : 'اختياري'} · التقييم البعدي ${post ? 'إلزامي' : 'اختياري'}'),
      ),
      ('timer', s.tr('Timer', 'المؤقّت'), true, s.tr('${_w.timerMinutes} minutes per module', '${_w.timerMinutes} دقيقة لكل وحدة')),
    ];
  }

  List<(String, String, String)> get _runOfShow => wizardRunOfShow(
        lobbyUrl: _lobbyUrl,
        memberRecommendations: _realism['memberRecommendationsEnabled'] == true,
        preAssessmentMandated: _assessPre['mandated'] == true,
      );

  String _checklistText(AppStrings s) {
    final b = StringBuffer()
      ..writeln(s.tr('FinPlay session checklist', 'قائمة جلسة FinPlay'))
      ..writeln(DateTime.now().toLocal().toString().split(' ').first)
      ..writeln()
      ..writeln(s.tr('Pre-flight', 'الفحص المسبق'));
    for (final p in _preflight(s)) {
      b.writeln('${p.$3 ? '☑' : '☐'} ${p.$2}: ${p.$4}');
    }
    b
      ..writeln()
      ..writeln(s.tr('Delivery run-of-show', 'تسلسل التقديم'));
    var i = 1;
    for (final r in _runOfShow) {
      b.writeln('${_ticks.contains(r.$1) ? '☑' : '☐'} ${i++}. ${s.tr(r.$2, r.$3)}');
    }
    return b.toString();
  }

  Widget _checklistStep(AppStrings s) {
    final items = _runOfShow;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        s.tr('This checklist reflects this session\'s actual configuration. Copy it to deliver the session end-to-end on paper, or tick the run-of-show items on screen as you go. Ticks are saved on this device, separate from the wizard step confirmations.',
            'تعكس هذه القائمة الإعداد الفعلي لهذه الجلسة. انسخها لتقديم الجلسة من البداية إلى النهاية على الورق، أو أشّر على بنود التسلسل على الشاشة أثناء التقدّم. تُحفظ التأشيرات على هذا الجهاز، منفصلة عن تأكيدات خطوات المعالج.'),
        style: _small(context),
      ),
      const SizedBox(height: 8),
      Wrap(spacing: 8, children: [
        FilledButton.icon(
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: _checklistText(s)));
            _toast(s.tr('Checklist copied - paste it anywhere to print', 'تم نسخ القائمة - الصقها في أي مكان لطباعتها'));
          },
          icon: const Icon(Icons.copy_all_rounded, size: 16),
          label: Text(s.tr('Copy checklist', 'نسخ القائمة')),
        ),
        OutlinedButton.icon(
          onPressed: () => _setTicks({}),
          icon: const Icon(Icons.restart_alt_rounded, size: 16),
          label: Text(s.tr('Reset checklist', 'إعادة ضبط القائمة')),
        ),
      ]),
      const SizedBox(height: 10),
      Text(s.tr('Pre-flight — auto-filled from this session\'s configuration', 'الفحص المسبق — يُملأ تلقائيًا من إعداد هذه الجلسة'),
          style: const TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: 6),
      for (final p in _preflight(s)) _checkRow(s, ok: p.$3, label: p.$2, detail: p.$4),
      const SizedBox(height: 6),
      Text(s.tr('Delivery run-of-show — tick as you deliver', 'تسلسل التقديم — أشّر أثناء التقديم'),
          style: const TextStyle(fontWeight: FontWeight.w600)),
      for (var i = 0; i < items.length; i++)
        CheckboxListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
          value: _ticks.contains(items[i].$1),
          onChanged: (v) => _setTicks(v == true ? {..._ticks, items[i].$1} : (_ticks.toSet()..remove(items[i].$1))),
          title: Text(
            '${i + 1}. ${s.tr(items[i].$2, items[i].$3)}',
            style: TextStyle(
              fontSize: 13,
              decoration: _ticks.contains(items[i].$1) ? TextDecoration.lineThrough : null,
              color: _ticks.contains(items[i].$1) ? AppColors.textTertiary(context) : null,
            ),
          ),
        ),
    ]);
  }

  // ── Step 10 ──
  Future<void> _startGame(AppStrings s) async {
    setState(() => _busy = true);
    try {
      final res = await _repo.startGameWithTimer(_w.timerMinutes);
      _toast('${s.tr('Game started', 'بدأت اللعبة')}: ${res['message'] ?? s.tr('Round 1 Financing active with ${res['timerMinutes'] ?? 20} minute timer', 'تمويل الجولة 1 نشط بمؤقّت ${res['timerMinutes'] ?? 20} دقيقة')}');
    } catch (e) {
      _toast('${s.tr('Start failed', 'تعذّر البدء')}: ${e is FacilitatorActionException ? e.message : s.tr('Could not start game', 'تعذّر بدء اللعبة')}',
          error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
      await _refresh();
    }
  }

  Widget _readyStep(AppStrings s) {
    final titles = _stepTitles(s);
    final st = _statuses;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _box(
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            _statusIcon(_readyGate ? StepStatus.green : StepStatus.amber, size: 24),
            const SizedBox(width: 8),
            Text(_readyGate ? s.tr('Session ready', 'الجلسة جاهزة') : s.tr('Not ready yet', 'ليست جاهزة بعد'),
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: _readyGate ? AppColors.secondaryLight : AppColors.accentLight)),
          ]),
          if (!_readyGate)
            Text(
              s.tr('Steps 1 (System check), 4 (Fresh start) and 5 (Model integrity) must be green before starting.',
                  'يجب أن تكون الخطوات 1 (فحص النظام) و4 (بداية جديدة) و5 (سلامة النموذج) خضراء قبل البدء.'),
              style: const TextStyle(fontSize: 12),
            ),
        ]),
        tint: _readyGate ? AppColors.secondaryLight : AppColors.accentLight,
      ),
      for (var i = 0; i < 9; i++)
        InkWell(
          onTap: () => _setW(_w.copyWith(activeStep: i + 1)),
          child: _box(Row(children: [
            _statusIcon(st[i]),
            const SizedBox(width: 8),
            Expanded(child: Text('${i + 1}. ${titles[i]}', style: const TextStyle(fontSize: 13))),
            Text(
              () {
                final objective = i == 0 || i == 3 || i == 4 || i == 8;
                return switch (st[i]) {
                  StepStatus.green => objective ? s.tr('Verified', 'تم التحقّق') : s.tr('Confirmed', 'مؤكّد'),
                  StepStatus.amber => s.tr('Needs attention', 'يحتاج انتباهًا'),
                  StepStatus.pending => objective ? s.tr('Checking…', 'جارٍ الفحص…') : s.tr('Not confirmed', 'غير مؤكّد'),
                };
              }(),
              style: _small(context),
            ),
          ])),
        ),
      _box(
        Row(children: [
          Expanded(
            child: Text(s.tr('Copy the session checklist from the Checklist step before you start.',
                'انسخ قائمة الجلسة من خطوة القائمة قبل أن تبدأ.'), style: const TextStyle(fontSize: 12)),
          ),
          TextButton(onPressed: () => _setW(_w.copyWith(activeStep: 9)), child: Text(s.tr('Checklist step', 'خطوة القائمة'))),
        ]),
      ),
      _box(
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(s.tr('Lobby URL - share with teams', 'رابط الردهة - شاركه مع الفرق'), style: const TextStyle(fontWeight: FontWeight.w600)),
          Row(children: [
            Expanded(child: SelectableText(_lobbyUrl, style: GoogleFonts.jetBrainsMono(fontSize: 12))),
            IconButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: _lobbyUrl));
                _toast(s.tr('Lobby URL copied', 'تم نسخ رابط الردهة'));
              },
              icon: const Icon(Icons.copy_rounded, size: 16),
            ),
          ]),
        ]),
        tint: AppColors.primaryLight,
      ),
      _box(
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            s.tr('Start game begins the session for every team: Round 1 Financing opens with a ${_w.timerMinutes}-minute timer. Do this when teams are in the lobby and you are ready to go live.',
                '"بدء اللعبة" يبدأ الجلسة لكل الفرق: يُفتح تمويل الجولة 1 بمؤقّت ${_w.timerMinutes} دقيقة. افعل ذلك حين تكون الفرق في الردهة وتكون جاهزًا للانطلاق.'),
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: AppColors.secondary),
              onPressed: (!_readyGate || _busy) ? null : () => _startGame(s),
              icon: const Icon(Icons.rocket_launch_rounded, size: 16),
              label: Text(_busy
                  ? s.tr('Starting…', 'جارٍ البدء…')
                  : s.tr('Start game (${_w.timerMinutes} min timer)', 'بدء اللعبة (مؤقّت ${_w.timerMinutes} دقيقة)')),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.arrow_back_rounded, size: 16),
              label: Text(s.tr('Back to the facilitator panel', 'العودة إلى لوحة الميسّر')),
            ),
          ),
        ]),
        tint: AppColors.secondaryLight,
      ),
    ]);
  }
}
