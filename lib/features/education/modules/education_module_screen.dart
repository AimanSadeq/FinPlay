import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/i18n/app_strings.dart';
import '../../../core/services/education_progress_sync.dart';
<<<<<<< Updated upstream
import '../../../core/services/education_storage_migration.dart';
=======
import '../../../core/services/learn_resume.dart';
import '../../../data/repositories/education_repository.dart';
import '../../../providers/repository_providers.dart';
>>>>>>> Stashed changes
import '../../../providers/auth_provider.dart';
import '../../../providers/module_plan_provider.dart';
import '../../../shared/widgets/glass_card.dart';
import '../widgets/games/memory_match_game.dart';
import '../widgets/games/classification_game.dart';
import '../widgets/games/ordering_game.dart';
import '../widgets/games/quiz_widget.dart';
import '../widgets/games/statement_builder_game.dart';
import '../widgets/games/case_scenario_game.dart';
import '../widgets/games/calculator_exercise.dart';
import '../widgets/slide_narration_bar.dart';
import '../../../data/education_catalog.dart';
import '../../auth/providers/self_paced_plan_provider.dart';
import 'education_module_data.dart';

/// One in-app education module: Learn slides plus every Practice / Games / Sim
/// activity the website module has (keyed by the website's activity ids, scored
/// against the website's maxima, synced through [EducationProgressSync]).
class EducationModuleScreen extends ConsumerStatefulWidget {
  final int moduleId;
  const EducationModuleScreen({super.key, required this.moduleId});

  @override
  ConsumerState<EducationModuleScreen> createState() => _EducationModuleScreenState();
}

class _EducationModuleScreenState extends ConsumerState<EducationModuleScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _lessonComplete = false;
  int _currentSlide = 0;

  /// Best score + completion per website activity id.
  final Map<String, ActivityRecord> _records = {};

  /// Selected activity per tab (several activities share a tab).
  final Map<ActivityTab, String> _active = {};

  /// Last score reported by an activity widget, recorded on completion.
  final Map<String, int> _pendingScore = {};

<<<<<<< Updated upstream
  int get _maxGameScore => _availableGames.length * 50;

  // Catalog ids of the modules with in-app content, in the hub order of the
  // module plan (the two workshop tools, the web-only modules and modules the
  // plan leaves out are skipped for next-module).
  List<int> get _moduleOrder => [
        for (final n in ref.read(modulePlanProvider).hubModuleNums)
          if (catalogEntry(n)?.isContent == true && catalogEntry(n)!.inApp) n,
      ];
=======
  late LearnResumeRecorder _resume;
>>>>>>> Stashed changes

  EducationModuleContent get _module => educationModuleContents[widget.moduleId]!;

  // Catalog ids of the modules with in-app content, in hub order.
  static final List<int> _moduleOrder = inAppContentModules.map((m) => m.num).toList();

  int? get _nextModuleId {
    final order = _moduleOrder;
    final idx = order.indexOf(widget.moduleId);
    if (idx < 0 || idx >= order.length - 1) return null;
    return order[idx + 1];
  }

  int get _totalScore => _module.activities
      .fold(0, (t, a) => t + (_records[a.id]?.score ?? 0).clamp(0, a.maxScore));

  int get _maxScore =>
      EducationProgressSync.moduleMaxScores[widget.moduleId] ?? _module.maxScore;

  int _tabScore(ActivityTab tab) =>
      _module.activitiesIn(tab).fold(0, (t, a) => t + (_records[a.id]?.score ?? 0));

  bool _tabDone(ActivityTab tab) {
    final acts = _module.activitiesIn(tab);
    return acts.isNotEmpty && acts.every((a) => _records[a.id]?.completed ?? false);
  }

  bool get _allComplete =>
      _lessonComplete && ActivityTab.values.every(_tabDone);

  @override
  void initState() {
    super.initState();
    _resume = LearnResumeRecorder(LearnResumeStore.moduleKeyFor(widget.moduleId));
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(_guardLockedTabs);
    _restoreProgress();
  }

  // Progress scope: 'sp' for self-paced learners (per-user), else the corporate
  // team id (per-team).
  String _scope = 'sp';
  int? _teamId; // corporate team joined on this device, null when none

  Future<void> _restoreProgress() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    final auth = ref.read(authProvider);
    final isSelfPaced = auth.user != null && !auth.isFacilitator;
    _scope = LearnResumeStore.scopeFor(isSelfPaced: isSelfPaced, prefs: prefs);
    _teamId = prefs.getInt('edu_team_id');
    final m = _module;
    if (await ModuleProgressStore.migrateLegacy(prefs, _scope, m)) {
      await ModuleProgressStore.recompute(prefs, _scope, m, writeHub: _scope == 'sp');
    }
    final saved = await LearnResumeStore.get(_scope, LearnResumeStore.moduleKeyFor(m.id));
    if (!mounted) return;
    setState(() {
      _lessonComplete =
          prefs.getBool(ModuleProgressStore.key(_scope, m.id, 'learn')) ?? false;
      _records
        ..clear()
        ..addAll({
          for (final a in m.activities)
            a.id: ModuleProgressStore.read(prefs, _scope, m.id, a.id),
        });
      _currentSlide = LearnResumeStore.indexIn(m.sectionIds, saved?.sectionId);
    });
    // Stamp the position on open too, so merely visiting a module makes it the
    // hub's "Continue where you left off" target (website parity).
    _recordSlide();
  }

<<<<<<< Updated upstream
  /// Mirror this module's completion into the keys the /education hub reads
  /// (`edu_progress_<id>` / `edu_passed_<id>`) so its grid % and badge count
  /// reflect real progress. Only for self-paced learners (the 'sp' scope).
  Future<void> _syncHubProgress(SharedPreferences prefs) async {
    // Work done here proves the local value for this module is current, so a
    // remapped value the migration left provisional can be pushed again.
    await EducationStorageMigration.clearProvisional(prefs, widget.moduleId);
    if (_scope != 'sp') return;
    final done = [_lessonComplete, _quizComplete, _gameComplete, _simComplete]
        .where((b) => b).length;
    await prefs.setInt('edu_progress_${widget.moduleId}', done * 25);
    await prefs.setBool('edu_passed_${widget.moduleId}', done == 4);
    _queueServerSync();
=======
  void _recordSlide() {
    final ids = _module.sectionIds;
    if (_currentSlide < 0 || _currentSlide >= ids.length) return;
    _resume.record(ref, ids[_currentSlide]);
>>>>>>> Stashed changes
  }

  void _goToSlide(int i) {
    setState(() => _currentSlide = i);
    _recordSlide();
  }

  // Debounce so a burst of saves results in a single round-trip.
  Timer? _serverSyncDebounce;

  /// Push this module's progress to the database so it survives a reinstall and
  /// shows up on the learner's other devices / the website.
  ///
  /// Follows the hub's identity rule: no push for a facilitator previewing or a
  /// corporate device that never joined a team (it would write into Team 1).
  /// Returns the push for this device's identity, or null when it must not
  /// push. Reads [ref], so callers take it before any await; the closure needs
  /// no ref, so [dispose] can still flush it.
  Future<bool> Function()? _syncPush() {
    final auth = ref.read(authProvider);
    final identity = EducationProgressSync.progressIdentity(
      isFacilitator: auth.isFacilitator,
      isSelfPaced: auth.user != null && !auth.isFacilitator,
      email: auth.user?.email,
      teamId: _teamId,
    );
    if (identity == null) return null;
    final sync = ref.read(educationProgressSyncProvider);
    return () => sync.sync(teamName: identity.teamName, scope: identity.scope);
  }

  void _scheduleSync(Future<bool> Function()? push) {
    if (push == null) return;
    if (!mounted) {
      push(); // screen already gone: push now rather than drop it
      return;
    }
    _serverSyncDebounce?.cancel();
    _pendingSync = push;
    _serverSyncDebounce = Timer(const Duration(seconds: 2), _flushServerSync);
  }

  Future<bool> Function()? _pendingSync;

  void _flushServerSync() {
    final p = _pendingSync;
    _pendingSync = null;
    p?.call();
  }

  @override
  void didUpdateWidget(covariant EducationModuleScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.moduleId != widget.moduleId) {
      _resume.dispose();
      _resume = LearnResumeRecorder(LearnResumeStore.moduleKeyFor(widget.moduleId));
      _currentSlide = 0;
      _active.clear();
      _tabController.animateTo(0);
      _restoreProgress();
    }
  }

  /// Practice / Games / Sim / Results open once Learn is complete, or straight
  /// away for a demo account (plan == 'demo', website isDemoAccount()). The lock
  /// icons say so; the website dropped its "Complete the Learn section" banner.
  bool get _activitiesOpen => _lessonComplete || ref.read(isDemoAccountProvider);

  void _guardLockedTabs() {
    if (!_activitiesOpen && _tabController.index > 0) {
      _tabController.animateTo(0);
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _tabController.removeListener(_guardLockedTabs);
    _tabController.dispose();
    _serverSyncDebounce?.cancel();
    _flushServerSync(); // leaving right after finishing must still push
    _resume.dispose();
    super.dispose();
  }

  Future<void> _markLearnComplete() async {
    HapticFeedback.mediumImpact();
    final push = _syncPush();
    setState(() => _lessonComplete = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(ModuleProgressStore.key(_scope, widget.moduleId, 'learn'), true);
    await ModuleProgressStore.recompute(prefs, _scope, _module, writeHub: _scope == 'sp');
    _scheduleSync(push);
  }

  Future<void> _onActivityComplete(ModuleActivity a) async {
    HapticFeedback.heavyImpact();
<<<<<<< Updated upstream
    setState(() => _quizComplete = true);
    // The quiz score reaches the server through EducationProgressSync
    // (POST /education/progress/{teamName}/sync), queued by _saveProgress.
    _saveProgress('quiz', true, scoreKey: 'quizScore', scoreValue: _quizScore);
=======
    final push = _syncPush();
    final repo = ref.read(educationRepositoryProvider);
    final score = (_pendingScore[a.id] ?? 0).clamp(0, a.maxScore);
    final prev = _records[a.id] ?? const ActivityRecord();
    setState(() {
      _records[a.id] = ActivityRecord(
          completed: true, score: score > prev.score ? score : prev.score);
    });
    final prefs = await SharedPreferences.getInstance();
    await ModuleProgressStore.record(prefs, _scope, widget.moduleId, a, score);
    await ModuleProgressStore.recompute(prefs, _scope, _module, writeHub: _scope == 'sp');
    _scheduleSync(push);
    if (a.kind == ActivityKind.quiz) _submitQuiz(repo, a, score);
  }

  Future<void> _submitQuiz(EducationRepository repo, ModuleActivity a, int score) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final teamId = prefs.getInt('edu_team_id') ?? 1;
      await repo.submitQuiz(
        teamId: teamId,
        moduleId: widget.moduleId,
        answers: const [],
        score: score,
        total: a.questions.length,
      );
    } catch (_) {
      // Non-critical.
    }
>>>>>>> Stashed changes
  }

  // Website tab colors
  static const _activeBlue = Color(0xFF0B5ED7); // blue-700
  static const _activeBorderBlue = Color(0xFF0D6EFD); // blue-600
  static const _inactiveText = Color(0xFF131B2B); // dark gray

  Widget _buildTab(int index, IconData icon, String label,
      {required bool isLocked, required bool isComplete}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = _tabController.index == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (isLocked) return;
          setState(() => _tabController.animateTo(index));
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isSelected
                ? const Border(bottom: BorderSide(color: _activeBorderBlue, width: 2))
                : null,
            boxShadow: isSelected
                ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 2)]
                : null,
          ),
          child: Opacity(
            opacity: isLocked ? 0.5 : 1.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isLocked ? Icons.lock_rounded : icon,
                  size: 20,
                  color: isLocked
                      ? AppColors.dangerLight
                      : isComplete
                          ? AppColors.secondaryLight
                          : isSelected
                              ? _activeBlue
                              : (isDark ? AppColors.darkTextSecondary : _inactiveText),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: isLocked
                        ? AppColors.textTertiary(context)
                        : isSelected
                            ? _activeBlue
                            : (isDark ? AppColors.darkTextSecondary : _inactiveText),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    ref.watch(isDemoAccountProvider); // rebuild if /me reports a demo plan
    final activitiesLocked = !_activitiesOpen;
    final position = educationHubPosition(widget.moduleId) ?? widget.moduleId;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient(context)),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                        icon: const Icon(Icons.arrow_back_rounded),
                        onPressed: () => context.pop()),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
<<<<<<< Updated upstream
                          // Named by its title alone, never by a number.
                          Text(_module.title, style: Theme.of(context).textTheme.titleMedium),
=======
                          Text(s.tr('Module $position', 'الوحدة $position'),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: const Color(0xFFA78BFA), fontWeight: FontWeight.w600)),
                          Text(_module.titleFor(s.ar),
                              style: Theme.of(context).textTheme.titleMedium),
>>>>>>> Stashed changes
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.accentLight.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, size: 16, color: AppColors.accentLight),
                          const SizedBox(width: 4),
                          Text('$_totalScore',
                              style: GoogleFonts.jetBrainsMono(
                                  color: AppColors.accentLight,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(),
              const SizedBox(height: 8),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkSurface
                      : const Color(0xFFE5E5E5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    _buildTab(0, Icons.menu_book_rounded, s.tr('Learn', 'تعلّم'),
                        isLocked: false, isComplete: _lessonComplete),
                    _buildTab(1, Icons.help_outline_rounded, s.tr('Practice', 'تدريب'),
                        isLocked: activitiesLocked, isComplete: _tabDone(ActivityTab.practice)),
                    _buildTab(2, Icons.gamepad_rounded, s.tr('Games', 'ألعاب'),
                        isLocked: activitiesLocked, isComplete: _tabDone(ActivityTab.games)),
                    _buildTab(3, Icons.widgets_rounded, s.tr('Sim', 'محاكاة'),
                        isLocked: activitiesLocked, isComplete: _tabDone(ActivityTab.sim)),
                    _buildTab(4, Icons.emoji_events_rounded, s.tr('Results', 'النتائج'),
                        isLocked: activitiesLocked, isComplete: _allComplete),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Directionality(
                  textDirection: s.ar ? TextDirection.rtl : TextDirection.ltr,
                  child: TabBarView(
                    controller: _tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildLearnTab(),
                      _buildActivityTab(ActivityTab.practice),
                      _buildActivityTab(ActivityTab.games),
                      _buildActivityTab(ActivityTab.sim),
                      _buildResultsTab(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Localized value for a slide field: Arabic (`<field>Ar`) when the UI is
  /// Arabic and a translation exists, else the English value.
  String _slideText(Map<String, String> slide, String field) {
    final ar = ref.read(stringsProvider).ar;
    if (ar) {
      final v = slide['${field}Ar'];
      if (v != null && v.trim().isNotEmpty) return v;
    }
    return slide[field] ?? '';
  }

  void _showKeyTerms() {
    final s = ref.read(stringsProvider);
    final terms = _module.keyTerms;
    if (terms == null || terms.isEmpty) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Directionality(
        textDirection: s.ar ? TextDirection.rtl : TextDirection.ltr,
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          builder: (ctx, scrollController) => Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textTertiary(ctx).withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  children: [
                    const Icon(Icons.menu_book_rounded, color: AppColors.purple, size: 20),
                    const SizedBox(width: 8),
                    Text(s.tr('Key Terms', 'المصطلحات الرئيسية'),
                        style: Theme.of(ctx).textTheme.titleMedium),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: terms.length,
                  separatorBuilder: (_, i) => const Divider(height: 20),
                  itemBuilder: (_, i) {
                    final t = terms[i];
                    final term = s.ar && (t['termAr']?.isNotEmpty ?? false)
                        ? t['termAr']!
                        : (t['term'] ?? '');
                    final other = s.ar ? (t['term'] ?? '') : (t['termAr'] ?? '');
                    final def = s.ar && (t['defAr']?.isNotEmpty ?? false)
                        ? t['defAr']!
                        : (t['def'] ?? '');
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(term,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                        if (other.isNotEmpty && other != term)
                          Text(other,
                              style: TextStyle(
                                  fontSize: 12, color: AppColors.textTertiary(ctx))),
                        if (def.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(def,
                              style: TextStyle(
                                  fontSize: 13, height: 1.4, color: AppColors.textSecondary(ctx))),
                        ],
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _callout(IconData icon, Color color, String text, {String? title}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color.withValues(alpha: 0.08),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null && title.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(title,
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
                  ),
                Text(text, style: TextStyle(fontSize: 13, color: color, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLearnTab() {
    final s = ref.watch(stringsProvider);
    final slides = _module.slides;
    if (slides.isEmpty) return const SizedBox.shrink();
    final idx = _currentSlide.clamp(0, slides.length - 1);
    final slide = slides[idx];
    final hasKeyTerms = _module.keyTerms?.isNotEmpty ?? false;
    final keyPoint = _slideText(slide, 'keyPoint');
    final highlight = _slideText(slide, 'highlight');
    final examples = _slideText(slide, 'examples');
    final highlightType = slide['highlightType'] ?? 'info';
    final (hlIcon, hlColor) = switch (highlightType) {
      'warning' => (Icons.warning_amber_rounded, AppColors.dangerLight),
      'tip' => (Icons.tips_and_updates_rounded, AppColors.secondaryLight),
      'formula' => (Icons.functions_rounded, AppColors.primaryLight),
      _ => (Icons.info_outline_rounded, AppColors.info),
    };
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.purple.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text('${idx + 1}/${slides.length}',
                          style: const TextStyle(
                              fontSize: 11, color: Color(0xFFA78BFA), fontWeight: FontWeight.w600)),
                    ),
                    if (hasKeyTerms) ...[
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: _showKeyTerms,
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.purple.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppColors.purple.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.menu_book_rounded, size: 12, color: Color(0xFFA78BFA)),
                              const SizedBox(width: 4),
                              Text(s.tr('Key Terms', 'المصطلحات'),
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFFA78BFA),
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const Spacer(),
                    if (idx == slides.length - 1 && !_lessonComplete)
                      TextButton(
                        onPressed: _markLearnComplete,
                        child: Text(s.tr('Mark Complete', 'وضع علامة مكتمل')),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(_slideText(slide, 'title'), style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 12),
                Text(_slideText(slide, 'content'),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6)),
                if (examples.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _callout(Icons.list_alt_rounded, AppColors.primaryLight,
                      examples.split('\n').map((e) => '• $e').join('\n'),
                      title: _slideText(slide, 'examplesTitle')),
                ],
                if (keyPoint.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _callout(Icons.lightbulb_rounded, AppColors.accentLight,
                      keyPoint.split(' • ').map((e) => '• $e').join('\n')),
                ],
                if (highlight.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _callout(hlIcon, hlColor, highlight),
                ],
                const SizedBox(height: 16),
                SlideNarrationBar(
                  key: ValueKey('narration-${_module.id}-$idx-${s.ar}'),
                  moduleId: _module.id,
                  sectionId: slide['id'] ?? '$idx',
                  language: s.ar ? 'ar' : 'en',
                  text: [
                    _slideText(slide, 'title'),
                    _slideText(slide, 'content'),
                    keyPoint,
                  ].where((t) => t.isNotEmpty).join('\n\n'),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    if (idx > 0)
                      OutlinedButton.icon(
                        onPressed: () => _goToSlide(idx - 1),
                        icon: Icon(s.ar ? Icons.arrow_forward : Icons.arrow_back, size: 16),
                        label: Text(s.tr('Back', 'رجوع')),
                      ),
                    const Spacer(),
                    if (idx < slides.length - 1)
                      ElevatedButton.icon(
                        onPressed: () => _goToSlide(idx + 1),
                        icon: Icon(s.ar ? Icons.arrow_back : Icons.arrow_forward, size: 16),
                        label: Text(s.tr('Next', 'التالي')),
                      ),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            runSpacing: 6,
            children: List.generate(
              slides.length,
              (i) => GestureDetector(
                onTap: () => _goToSlide(i),
                child: Container(
                  width: i == idx ? 20 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: i == idx
                        ? AppColors.purple
                        : i <= idx
                            ? AppColors.purple.withValues(alpha: 0.4)
                            : AppColors.cardColor(context),
                  ),
                ),
              ),
            ),
          ),
          if (_lessonComplete) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.secondary.withValues(alpha: 0.1),
                border: Border.all(color: AppColors.secondaryLight.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle, color: AppColors.secondaryLight, size: 22),
                      const SizedBox(width: 8),
                      Text(s.tr('Lesson Complete!', 'اكتمل الدرس!'),
                          style: const TextStyle(
                              color: AppColors.secondaryLight,
                              fontWeight: FontWeight.w700,
                              fontSize: 15)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                      s.tr('You can now access all other activities.',
                          'يمكنك الآن الوصول إلى جميع الأنشطة الأخرى.'),
                      style: TextStyle(
                          fontSize: 12, color: AppColors.secondaryLight.withValues(alpha: 0.8))),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _tabController.animateTo(1),
                      icon: const Icon(Icons.help_outline_rounded, size: 18),
                      label: Text(s.tr('Start Practice', 'ابدأ التدريب')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryLight,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  static const Map<ActivityKind, IconData> _kindIcon = {
    ActivityKind.quiz: Icons.help_outline_rounded,
    ActivityKind.calculator: Icons.calculate_rounded,
    ActivityKind.memoryMatch: Icons.style_rounded,
    ActivityKind.classification: Icons.category_rounded,
    ActivityKind.ordering: Icons.format_list_numbered_rounded,
    ActivityKind.caseScenario: Icons.account_tree_rounded,
    ActivityKind.statementBuilder: Icons.widgets_rounded,
  };

  Widget _buildActivityTab(ActivityTab tab) {
    final s = ref.watch(stringsProvider);
    final acts = _module.activitiesIn(tab);
    if (acts.isEmpty) {
      return Center(child: Text(s.tr('No activities here.', 'لا توجد أنشطة هنا.')));
    }
    final activeId = _active[tab];
    final active = acts.firstWhere((a) => a.id == activeId,
        orElse: () => acts.firstWhere((a) => !(_records[a.id]?.completed ?? false),
            orElse: () => acts.first));
    final doneCount = acts.where((a) => _records[a.id]?.completed ?? false).length;
    final rec = _records[active.id];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (acts.length > 1) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: acts.map((a) {
                  final done = _records[a.id]?.completed ?? false;
                  final selected = a.id == active.id;
                  return ChoiceChip(
                    avatar: Icon(
                      done ? Icons.check_circle_rounded : _kindIcon[a.kind],
                      size: 16,
                      color: done
                          ? AppColors.secondaryLight
                          : selected
                              ? Colors.white
                              : AppColors.textSecondary(context),
                    ),
                    label: Text(a.title.of(s.ar)),
                    selected: selected,
                    onSelected: (_) => setState(() => _active[tab] = a.id),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
              Text(
                  s.tr('$doneCount/${acts.length} complete',
                      'اكتمل $doneCount/${acts.length}'),
                  style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 16),
            ],
<<<<<<< Updated upstream

            // Keep game state isolated per type with a ValueKey.
            KeyedSubtree(
              key: ValueKey('module-game-${widget.moduleId}-${active.name}'),
              child: _buildGame(active),
            ),
          ],
        ),
      ).animate().fadeIn(),
    );
  }

  Widget _buildGame(GameType game) {
    switch (game) {
      case GameType.memoryMatch:
        return MemoryMatchGame(
          pairs: _module.memoryPairs!,
          onComplete: () => _onGameComplete(game),
          onScoreUpdate: (s) => _onGameScoreUpdate(game, s),
        );
      case GameType.classification:
        return ClassificationGame(
          categories: _module.classificationCategories!,
          items: _module.classificationItems!,
          onComplete: () => _onGameComplete(game),
          onScoreUpdate: (s) => _onGameScoreUpdate(game, s),
        );
      case GameType.ordering:
        return OrderingGame(
          instruction: _module.orderingInstruction!,
          correctOrder: _module.orderingItems!,
          onComplete: () => _onGameComplete(game),
          onScoreUpdate: (s) => _onGameScoreUpdate(game, s),
        );
    }
  }

  Widget _buildQuizTab() {
    final s = ref.watch(stringsProvider);
    if (_quizComplete) {
      return Center(
        child: GlassCard(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.verified_rounded, color: AppColors.secondaryLight, size: 48),
              const SizedBox(height: 16),
              Text(s.tr('Practice Complete!', 'اكتمل التدريب!'), style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(s.tr('Total Score: $_totalScore', 'النتيجة الإجمالية: $_totalScore'), style: GoogleFonts.jetBrainsMono(
                fontSize: 24, color: AppColors.secondaryLight, fontWeight: FontWeight.w700)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() => _tabController.animateTo(3));
                },
                child: Text(s.tr('Continue to Sim', 'المتابعة إلى المحاكاة')),
              ),
            ],
          ),
        ).animate().scale(begin: const Offset(0.8, 0.8)).fadeIn(),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
=======
>>>>>>> Stashed changes
            Row(
              children: [
                Icon(_kindIcon[active.kind], color: const Color(0xFFA78BFA), size: 22),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(active.title.of(s.ar),
                        style: Theme.of(context).textTheme.titleLarge)),
              ],
            ),
            const SizedBox(height: 4),
            Text(active.description.of(s.ar), style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 6),
            Text(
              rec?.completed ?? false
                  ? s.tr('Best score: ${rec!.score} / ${active.maxScore}',
                      'أفضل نتيجة: ${rec.score} / ${active.maxScore}')
                  : s.tr('Up to ${active.maxScore} points', 'حتى ${active.maxScore} نقطة'),
              style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.accentLight),
            ),
            const SizedBox(height: 16),
            KeyedSubtree(
              key: ValueKey('activity-${widget.moduleId}-${active.id}'),
              child: _buildActivity(active),
            ),
          ],
        ),
      ).animate().fadeIn(),
    );
  }

  Widget _buildActivity(ModuleActivity a) {
    void onScore(int v) => _pendingScore[a.id] = v;
    void onDone() => _onActivityComplete(a);
    switch (a.kind) {
      case ActivityKind.quiz:
        return QuizWidget(
            questions: a.questions,
            maxScore: a.maxScore,
            onComplete: onDone,
            onScoreUpdate: onScore);
      case ActivityKind.calculator:
        return CalculatorExercise(
            instruction: a.instruction,
            problems: a.problems,
            maxScore: a.maxScore,
            onComplete: onDone,
            onScoreUpdate: onScore);
      case ActivityKind.memoryMatch:
        return MemoryMatchGame(
            pairs: a.pairs, maxScore: a.maxScore, onComplete: onDone, onScoreUpdate: onScore);
      case ActivityKind.classification:
        return ClassificationGame(
            categories: a.categories,
            items: a.items,
            maxScore: a.maxScore,
            onComplete: onDone,
            onScoreUpdate: onScore);
      case ActivityKind.ordering:
        return OrderingGame(
            instruction: a.instruction,
            steps: a.steps,
            maxScore: a.maxScore,
            onComplete: onDone,
            onScoreUpdate: onScore);
      case ActivityKind.caseScenario:
        return CaseScenarioGame(
            scenarios: a.scenarios,
            maxScore: a.maxScore,
            onComplete: onDone,
            onScoreUpdate: onScore);
      case ActivityKind.statementBuilder:
        return StatementBuilderGame(
            categories: a.categories,
            items: a.items,
            maxScore: a.maxScore,
            onComplete: onDone,
            onScoreUpdate: onScore);
    }
  }

  Widget _buildResultsTab() {
    final s = ref.watch(stringsProvider);
    final allComplete = _allComplete;
    final pct = ModuleProgressStore.percentOf(_totalScore, _maxScore);
    final passed = pct >= EducationProgressSync.passThreshold * 100;

    Widget tabRow(ActivityTab tab, IconData icon, String label) => _buildActivityRow(
        icon, label, _tabDone(tab), '${_tabScore(tab)} / ${_module.maxScoreIn(tab)}');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          GlassCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Icon(
                  allComplete ? Icons.emoji_events_rounded : Icons.pending_rounded,
                  color: allComplete ? AppColors.accentLight : AppColors.textTertiary(context),
                  size: 56,
                ),
                const SizedBox(height: 16),
                Text(
                  allComplete
                      ? s.tr('Module Complete!', 'اكتملت الوحدة!')
                      : s.tr('Module Progress', 'تقدّم الوحدة'),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  '$_totalScore / $_maxScore',
                  textDirection: TextDirection.ltr,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 28,
                    color: allComplete ? AppColors.accentLight : AppColors.textSecondary(context),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  passed
                      ? s.tr('$pct%: passed (70% needed)', '$pct%: ناجح (المطلوب 70%)')
                      : s.tr('$pct% (70% needed to pass)', '$pct% (المطلوب 70% للنجاح)'),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 24),
                _buildActivityRow(Icons.menu_book_rounded, s.tr('Learn', 'تعلّم'), _lessonComplete,
                    _lessonComplete ? s.tr('Done', 'مكتمل') : '-'),
                const SizedBox(height: 8),
                tabRow(ActivityTab.practice, Icons.help_outline_rounded, s.tr('Practice', 'تدريب')),
                const SizedBox(height: 8),
                tabRow(ActivityTab.games, Icons.gamepad_rounded, s.tr('Games', 'ألعاب')),
                const SizedBox(height: 8),
                tabRow(ActivityTab.sim, Icons.widgets_rounded, s.tr('Sim', 'محاكاة')),
                const SizedBox(height: 24),
                if (allComplete && _nextModuleId != null)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.pop();
                        context.push(moduleRouteFor(_nextModuleId!, arabic: s.ar));
                      },
                      icon: Icon(s.ar ? Icons.arrow_back_rounded : Icons.arrow_forward_rounded,
                          size: 18),
                      label: Text(s.tr('Next Module', 'الوحدة التالية')),
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14)),
                    ),
                  )
                else if (allComplete)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.pop(),
                      child: Text(s.tr('Back to Hub', 'العودة إلى المركز')),
                    ),
                  )
                else
                  Text(
                    s.tr('Complete all activities to unlock the next module.',
                        'أكمل جميع الأنشطة لفتح الوحدة التالية.'),
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ).animate().fadeIn(),
        ],
      ),
    );
  }

  Widget _buildActivityRow(IconData icon, String label, bool complete, String detail) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: complete ? AppColors.secondary.withValues(alpha: 0.08) : AppColors.cardColor(context),
        border: Border.all(
          color: complete
              ? AppColors.secondaryLight.withValues(alpha: 0.3)
              : AppColors.textTertiary(context).withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(icon,
              size: 18, color: complete ? AppColors.secondaryLight : AppColors.textTertiary(context)),
          const SizedBox(width: 10),
          Expanded(
              child: Text(label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: complete ? AppColors.secondaryLight : AppColors.textSecondary(context),
                  ))),
          Text(detail,
              textDirection: TextDirection.ltr,
              style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context))),
          const SizedBox(width: 8),
          Icon(
            complete ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
            size: 20,
            color: complete ? AppColors.secondaryLight : AppColors.textTertiary(context),
          ),
        ],
      ),
    );
  }
}
