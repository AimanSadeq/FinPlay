import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/i18n/app_strings.dart';
import '../../../../providers/repository_providers.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../widgets/games/memory_match_game.dart';
import '../../widgets/games/classification_game.dart';
import '../../widgets/games/ordering_game.dart';
import '../../widgets/games/quiz_widget.dart';
import '../../widgets/games/statement_builder_game.dart';
import '../../widgets/games/case_scenario_game.dart';
import 'gov_module_data.dart';
import 'case_scenario_data.dart';

class GovModuleScreen extends ConsumerStatefulWidget {
  final int moduleId;
  const GovModuleScreen({super.key, required this.moduleId});

  @override
  ConsumerState<GovModuleScreen> createState() => _GovModuleScreenState();
}

class _GovModuleScreenState extends ConsumerState<GovModuleScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // Per-activity scores matching website max values
  int _gameScore = 0;   // sum across all games in the module
  int _quizScore = 0;   // max 50
  int _simScore = 0;    // max 100
  bool _lessonComplete = false;
  bool _gameComplete = false;
  bool _quizComplete = false;
  bool _simComplete = false;
  int _currentSlide = 0;

  // Multi-game support: a module can ship several games (memory + classification
  // + ordering). The website renders all of them; we surface each as a sub-tab
  // inside the Games tab and require all to be completed.
  final Set<GameType> _gamesDone = {};
  final Map<GameType, int> _gameScores = {};
  GameType? _activeGame;

  int get _totalScore => _gameScore + _quizScore + _simScore;

  /// Games this module actually has data for, primary (declared) game first.
  List<GameType> get _availableGames {
    final m = _module;
    final games = <GameType>[];
    void add(GameType g, bool has) {
      if (has && !games.contains(g)) games.add(g);
    }
    // Declared gameType first so the intended primary game leads.
    add(m.gameType, switch (m.gameType) {
      GameType.memoryMatch => m.memoryPairs != null,
      GameType.classification => m.classificationItems != null,
      GameType.ordering => m.orderingItems != null,
    });
    add(GameType.memoryMatch, m.memoryPairs != null);
    add(GameType.classification, m.classificationItems != null);
    add(GameType.ordering, m.orderingItems != null);
    return games.isEmpty ? [m.gameType] : games;
  }

  int get _maxGameScore => _availableGames.length * 50;

  // Hub display order: 1,2,3, (4,5 are Break-Even/CapBudget), 6,7,8,9,10
  static const _moduleOrder = [1, 2, 3, 6, 7, 8, 9, 10, 11, 12];

  GovModuleContent get _module => govModuleContents[widget.moduleId]!;

  int? get _nextModuleId {
    final idx = _moduleOrder.indexOf(widget.moduleId);
    if (idx < 0 || idx >= _moduleOrder.length - 1) return null;
    return _moduleOrder[idx + 1];
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(_guardLockedTabs);
    _restoreProgress();
  }

  String _prefKey(String activity) => 'gov_module_${widget.moduleId}_$activity';

  Future<void> _restoreProgress() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _lessonComplete = prefs.getBool(_prefKey('learn')) ?? false;
      _gameComplete = prefs.getBool(_prefKey('game')) ?? false;
      _quizComplete = prefs.getBool(_prefKey('quiz')) ?? false;
      _simComplete = prefs.getBool(_prefKey('sim')) ?? false;
      _gameScore = prefs.getInt(_prefKey('gameScore')) ?? 0;
      _quizScore = prefs.getInt(_prefKey('quizScore')) ?? 0;
      _simScore = prefs.getInt(_prefKey('simScore')) ?? 0;
      // Restore per-game completion + scores.
      _gamesDone
        ..clear()
        ..addAll((prefs.getStringList(_prefKey('gamesDone')) ?? [])
            .map((n) => GameType.values.asNameMap()[n])
            .whereType<GameType>());
      _gameScores.clear();
      for (final g in GameType.values) {
        final s = prefs.getInt(_prefKey('gameScore_${g.name}'));
        if (s != null) _gameScores[g] = s;
      }
      _activeGame ??= _availableGames.first;
    });
  }

  Future<void> _saveProgress(String activity, bool value, {String? scoreKey, int? scoreValue}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey(activity), value);
    if (scoreKey != null && scoreValue != null) {
      await prefs.setInt(_prefKey(scoreKey), scoreValue);
    }
  }

  @override
  void didUpdateWidget(covariant GovModuleScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.moduleId != widget.moduleId) {
      _currentSlide = 0;
      _tabController.animateTo(0);
      _restoreProgress();
    }
  }

  /// Prevent navigating to tabs 1-4 when Learn is not complete (like website).
  /// Also triggers rebuild so tab highlight stays in sync.
  void _guardLockedTabs() {
    if (!_lessonComplete && _tabController.index > 0) {
      _tabController.animateTo(0);
      if (mounted) {
        final s = ref.read(stringsProvider);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text(s.tr('Complete the Learn section first to unlock other activities',
                'أكمل قسم التعلّم أولًا لفتح بقية الأنشطة')),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ));
      }
    }
    // Rebuild to keep selected-tab highlight in sync
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _tabController.removeListener(_guardLockedTabs);
    _tabController.dispose();
    super.dispose();
  }

  void _onGameScoreUpdate(GameType game, int score) {
    setState(() {
      _gameScores[game] = score;
      _gameScore = _gameScores.values.fold(0, (a, b) => a + b);
    });
    _persistGames();
  }

  void _onGameComplete(GameType game) {
    HapticFeedback.heavyImpact();
    setState(() {
      _gamesDone.add(game);
      // Module game activity is done only when every available game is done.
      _gameComplete = _availableGames.every(_gamesDone.contains);
      // Auto-advance to the next not-yet-done game for convenience.
      final next = _availableGames.where((g) => !_gamesDone.contains(g));
      if (next.isNotEmpty) _activeGame = next.first;
    });
    _persistGames();
  }

  Future<void> _persistGames() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey('game'), _gameComplete);
    await prefs.setInt(_prefKey('gameScore'), _gameScore);
    await prefs.setStringList(
        _prefKey('gamesDone'), _gamesDone.map((g) => g.name).toList());
    for (final e in _gameScores.entries) {
      await prefs.setInt(_prefKey('gameScore_${e.key.name}'), e.value);
    }
  }

  void _onQuizComplete() {
    HapticFeedback.heavyImpact();
    setState(() => _quizComplete = true);
    _saveProgress('quiz', true, scoreKey: 'quizScore', scoreValue: _quizScore);
    _submitProgress();
  }

  // Website tab colors
  static const _activeBlue = Color(0xFF0B5ED7);      // blue-700
  static const _activeBorderBlue = Color(0xFF0D6EFD); // blue-600
  static const _inactiveText = Color(0xFF131B2B);     // dark gray

  /// Builds a single tab matching website mobile layout (icon above text, 5 equal cols).
  Widget _buildTab(int index, IconData icon, String label, {
    required bool isLocked,
    required bool isComplete,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = _tabController.index == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (isLocked) {
            _guardLockedTabs();
          } else {
            setState(() => _tabController.animateTo(index));
          }
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
                ? Border(bottom: BorderSide(color: _activeBorderBlue, width: 2))
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

  Future<void> _submitProgress() async {
    try {
      final repo = ref.read(educationRepositoryProvider);
      final prefs = await SharedPreferences.getInstance();
      final teamId = prefs.getInt('gov_team_id') ?? 1;
      await repo.submitQuiz(
        teamId: teamId,
        moduleId: widget.moduleId,
        answers: const [],
        score: _quizScore,
        total: _module.quizQuestions.length,
      );
    } catch (_) {
      // Progress submission is non-critical — silently ignore
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient(context)),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.tr('Module ${widget.moduleId}', 'الوحدة ${widget.moduleId}'), style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: const Color(0xFFA78BFA), fontWeight: FontWeight.w600)),
                          Text(_module.title, style: Theme.of(context).textTheme.titleMedium),
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
                          Text('$_totalScore', style: GoogleFonts.jetBrainsMono(
                            color: AppColors.accentLight, fontWeight: FontWeight.w600, fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(),

              const SizedBox(height: 8),

              // Tabs — 5 equal-width columns, icon above text (matches website mobile)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkSurface
                      : const Color(0xFFE5E5E5), // muted gray like website
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    _buildTab(0, Icons.menu_book_rounded, s.tr('Learn', 'تعلّم'),
                      isLocked: false,
                      isComplete: _lessonComplete),
                    _buildTab(1, Icons.help_outline_rounded, s.tr('Practice', 'تدريب'),
                      isLocked: !_lessonComplete,
                      isComplete: _quizComplete),
                    _buildTab(2, Icons.gamepad_rounded, s.tr('Games', 'ألعاب'),
                      isLocked: !_lessonComplete,
                      isComplete: _gameComplete),
                    _buildTab(3, Icons.widgets_rounded, s.tr('Sim', 'محاكاة'),
                      isLocked: !_lessonComplete,
                      isComplete: _simComplete),
                    _buildTab(4, Icons.emoji_events_rounded, s.tr('Results', 'النتائج'),
                      isLocked: !_lessonComplete,
                      isComplete: _lessonComplete && _gameComplete && _quizComplete && _simComplete),
                  ],
                ),
              ),

              // Warning banner when Learn is not complete
              if (!_lessonComplete)
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.lock_rounded, size: 16, color: Color(0xFFD97706)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          s.tr('Complete the Learn section to unlock other activities',
                              'أكمل قسم التعلّم لفتح بقية الأنشطة'),
                          style: TextStyle(
                            fontSize: 12,
                            color: const Color(0xFF92400E),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 8),

              // Tab content — swiping disabled so users must tap tabs
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildLearnTab(),
                    _buildQuizTab(),
                    _buildPlayTab(),
                    _buildSimulationTab(),
                    _buildResultsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLearnTab() {
    final s = ref.watch(stringsProvider);
    final slides = _module.slides;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Slide viewer
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
                      child: Text('${_currentSlide + 1}/${slides.length}',
                        style: const TextStyle(fontSize: 11, color: Color(0xFFA78BFA), fontWeight: FontWeight.w600)),
                    ),
                    const Spacer(),
                    if (_currentSlide == slides.length - 1 && !_lessonComplete)
                      TextButton(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          setState(() {
                            _lessonComplete = true;
                          });
                          _saveProgress('learn', true);
                        },
                        child: Text(s.tr('Mark Complete', 'وضع علامة مكتمل')),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(slides[_currentSlide]['title']!,
                  style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 12),
                Text(slides[_currentSlide]['content']!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6)),
                if (slides[_currentSlide]['keyPoint'] != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.accentLight.withValues(alpha: 0.08),
                      border: Border.all(color: AppColors.accentLight.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.lightbulb_rounded, color: AppColors.accentLight, size: 18),
                        const SizedBox(width: 8),
                        Expanded(child: Text(slides[_currentSlide]['keyPoint']!,
                          style: const TextStyle(fontSize: 13, color: AppColors.accentLight, height: 1.4))),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Row(
                  children: [
                    if (_currentSlide > 0)
                      OutlinedButton.icon(
                        onPressed: () => setState(() => _currentSlide--),
                        icon: const Icon(Icons.arrow_back, size: 16),
                        label: Text(s.tr('Back', 'رجوع')),
                      ),
                    const Spacer(),
                    if (_currentSlide < slides.length - 1)
                      ElevatedButton.icon(
                        onPressed: () => setState(() => _currentSlide++),
                        icon: const Icon(Icons.arrow_forward, size: 16),
                        label: Text(s.tr('Next', 'التالي')),
                      ),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(),

          const SizedBox(height: 12),

          // Slide dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(slides.length, (i) => Container(
              width: i == _currentSlide ? 20 : 8, height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: i == _currentSlide
                    ? AppColors.purple
                    : i <= _currentSlide
                        ? AppColors.purple.withValues(alpha: 0.4)
                        : AppColors.cardColor(context),
              ),
            )),
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
                      Text(s.tr('Lesson Complete!', 'اكتمل الدرس!'), style: const TextStyle(
                        color: AppColors.secondaryLight, fontWeight: FontWeight.w700, fontSize: 15)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(s.tr('You can now access all other activities.', 'يمكنك الآن الوصول إلى جميع الأنشطة الأخرى.'),
                    style: TextStyle(fontSize: 12, color: AppColors.secondaryLight.withValues(alpha: 0.8))),
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

  static const Map<GameType, (IconData, String)> _gameMeta = {
    GameType.memoryMatch: (Icons.style_rounded, 'Term Match'),
    GameType.classification: (Icons.category_rounded, 'Sort & Classify'),
    GameType.ordering: (Icons.format_list_numbered_rounded, 'Sequence'),
  };

  Widget _buildPlayTab() {
    final s = ref.watch(stringsProvider);
    final games = _availableGames;
    _activeGame ??= games.first;
    final active = games.contains(_activeGame) ? _activeGame! : games.first;

    if (_gameComplete) {
      return Center(
        child: GlassCard(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.emoji_events_rounded, color: AppColors.accentLight, size: 48),
              const SizedBox(height: 16),
              Text(games.length > 1 ? s.tr('All Games Complete!', 'اكتملت جميع الألعاب!') : s.tr('Game Complete!', 'اكتملت اللعبة!'),
                style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(s.tr('Score: $_totalScore', 'النتيجة: $_totalScore'), style: GoogleFonts.jetBrainsMono(
                fontSize: 24, color: AppColors.accentLight, fontWeight: FontWeight.w700)),
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
            Row(
              children: [
                const Icon(Icons.gamepad_rounded, color: Color(0xFFA78BFA), size: 22),
                const SizedBox(width: 8),
                Expanded(child: Text(_module.gameTitle, style: Theme.of(context).textTheme.titleLarge)),
              ],
            ),
            const SizedBox(height: 4),
            Text(_module.gameDescription, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 16),

            // Sub-tab chip selector when the module has more than one game.
            if (games.length > 1) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: games.map((g) {
                  final meta = _gameMeta[g]!;
                  final done = _gamesDone.contains(g);
                  final selected = g == active;
                  return ChoiceChip(
                    avatar: Icon(
                      done ? Icons.check_circle_rounded : meta.$1,
                      size: 16,
                      color: done
                          ? AppColors.secondaryLight
                          : selected ? Colors.white : AppColors.textSecondary(context),
                    ),
                    label: Text(meta.$2),
                    selected: selected,
                    onSelected: (_) => setState(() => _activeGame = g),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
              Text(s.tr('${_gamesDone.length}/${games.length} games complete',
                  'اكتملت ${_gamesDone.length}/${games.length} ألعاب'),
                style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 16),
            ],

            // Keep game state isolated per type with a ValueKey.
            KeyedSubtree(
              key: ValueKey('gov-game-${widget.moduleId}-${active.name}'),
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
            Row(
              children: [
                const Icon(Icons.help_outline_rounded, color: Color(0xFFA78BFA), size: 22),
                const SizedBox(width: 8),
                Text(s.tr('Knowledge Check', 'اختبار المعرفة'), style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const SizedBox(height: 16),
            QuizWidget(
              questions: _module.quizQuestions,
              onComplete: _onQuizComplete,
              onScoreUpdate: (score) {
                setState(() => _quizScore = score);
                _saveProgress('quiz', _quizComplete, scoreKey: 'quizScore', scoreValue: score);
              },
            ),
          ],
        ),
      ).animate().fadeIn(),
    );
  }

  void _onSimComplete() {
    HapticFeedback.heavyImpact();
    setState(() => _simComplete = true);
    _saveProgress('sim', true, scoreKey: 'simScore', scoreValue: _simScore);
  }

  void _onSimScore(int score) {
    setState(() => _simScore = score);
    _saveProgress('sim', _simComplete, scoreKey: 'simScore', scoreValue: score);
  }

  Widget _buildSimulationTab() {
    final s = ref.watch(stringsProvider);
    // Modules that ship branching case scenarios render the Case Scenario
    // Simulator here; the rest keep the Statement Builder activity.
    final scenarios = caseScenariosByModule[widget.moduleId];
    final useCases = scenarios != null && scenarios.isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(useCases ? Icons.account_tree_rounded : Icons.widgets_rounded,
                    color: const Color(0xFFA78BFA), size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(useCases ? s.tr('Case Scenario Simulator', 'محاكي دراسات الحالة') : s.tr('Financial Statement Builder', 'منشئ القوائم المالية'),
                      style: Theme.of(context).textTheme.titleLarge),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              useCases
                  ? s.tr('Work through a real-world case: analyse, decide, and recommend. Each choice is scored.',
                      'اعمل على حالة واقعية: حلّل وقرّر وأوصِ. تُحتسب نقاط لكل اختيار.')
                  : s.tr('Drag or tap each item to classify it into the correct financial statement.',
                      'اسحب أو انقر كل عنصر لتصنيفه ضمن القائمة المالية الصحيحة.'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            if (useCases)
              CaseScenarioGame(
                scenarios: scenarios,
                onComplete: _onSimComplete,
                onScoreUpdate: _onSimScore,
              )
            else
              StatementBuilderGame(
                categories: _module.statementBuilderCategories,
                items: _module.statementBuilderItems,
                onComplete: _onSimComplete,
                onScoreUpdate: _onSimScore,
              ),
          ],
        ),
      ).animate().fadeIn(),
    );
  }

  Widget _buildResultsTab() {
    final s = ref.watch(stringsProvider);
    final allComplete = _lessonComplete && _gameComplete && _quizComplete && _simComplete;

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
                  allComplete ? s.tr('Module Complete!', 'اكتملت الوحدة!') : s.tr('Module Progress', 'تقدّم الوحدة'),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  s.tr('Total Score: $_totalScore', 'النتيجة الإجمالية: $_totalScore'),
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 28,
                    color: allComplete ? AppColors.accentLight : AppColors.textSecondary(context),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 24),

                // Activity progress
                _buildActivityRow(Icons.menu_book_rounded, s.tr('Learn', 'تعلّم'), _lessonComplete, _lessonComplete ? s.tr('Done', 'مكتمل') : '—'),
                const SizedBox(height: 8),
                _buildActivityRow(Icons.help_outline_rounded, s.tr('Practice', 'تدريب'), _quizComplete, '$_quizScore / 50'),
                const SizedBox(height: 8),
                _buildActivityRow(Icons.gamepad_rounded, s.tr('Games', 'ألعاب'), _gameComplete, '$_gameScore / $_maxGameScore'),
                const SizedBox(height: 8),
                _buildActivityRow(Icons.widgets_rounded, s.tr('Sim', 'محاكاة'), _simComplete, '$_simScore / 100'),

                const SizedBox(height: 24),

                // Next module button
                if (allComplete && _nextModuleId != null)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.pop();
                        context.push('/gov-education/module/$_nextModuleId');
                      },
                      icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                      label: Text(s.tr('Next Module', 'الوحدة التالية')),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
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
        color: complete
            ? AppColors.secondary.withValues(alpha: 0.08)
            : AppColors.cardColor(context),
        border: Border.all(
          color: complete
              ? AppColors.secondaryLight.withValues(alpha: 0.3)
              : AppColors.textTertiary(context).withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: complete ? AppColors.secondaryLight : AppColors.textTertiary(context)),
          const SizedBox(width: 10),
          Expanded(child: Text(label, style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: complete ? AppColors.secondaryLight : AppColors.textSecondary(context),
          ))),
          Text(detail, style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context))),
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
