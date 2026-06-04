import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/i18n/app_strings.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/team_provider.dart';
import '../../../providers/game_state_provider.dart';
import '../../../providers/scenario_provider.dart';
import '../../../providers/decision_provider.dart';
import '../../../providers/financial_provider.dart';
import '../../../providers/socket_provider.dart';
import '../../../data/models/scenario.dart';
import '../../../data/models/financial_data.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/animated_counter.dart';
import '../../../shared/widgets/connection_badge.dart';
import '../../../shared/widgets/header_timer.dart';
import '../../../shared/widgets/active_shocks_display.dart';
import '../../../shared/widgets/team_leader_banner.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../providers/repository_providers.dart';
import '../../../providers/self_paced_provider.dart';
import '../widgets/self_paced_round_progress.dart';
import '../widgets/self_paced_scenario_panel.dart';
import '../widgets/self_paced_game_complete.dart';
import 'scenario_education_screen.dart';

// ---------------------------------------------------------------------------
// Case Study constraint data model
// ---------------------------------------------------------------------------

class CaseStudyConstraints {
  final String caseStudyId;
  final double budgetLimit;
  final Map<String, int> maxSelectionsPerModule;
  final String? description;

  const CaseStudyConstraints({
    required this.caseStudyId,
    required this.budgetLimit,
    this.maxSelectionsPerModule = const {},
    this.description,
  });

  factory CaseStudyConstraints.fromJson(Map<String, dynamic> json) {
    return CaseStudyConstraints(
      caseStudyId: json['caseStudyId']?.toString() ?? '',
      budgetLimit: (json['budgetLimit'] as num?)?.toDouble() ?? 0,
      maxSelectionsPerModule: (json['maxSelectionsPerModule'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, (v as num).toInt())) ??
          {},
      description: json['description'] as String?,
    );
  }
}

// ---------------------------------------------------------------------------
// Main Screen
// ---------------------------------------------------------------------------

class SimulationScreen extends ConsumerStatefulWidget {
  const SimulationScreen({super.key});

  @override
  ConsumerState<SimulationScreen> createState() => _SimulationScreenState();
}

class _SimulationScreenState extends ConsumerState<SimulationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _modules = const ['financing', 'investing', 'operating'];
  final _moduleLabels = const ['Financing', 'Investing', 'Operating'];
  final _moduleIcons = const [
    Icons.account_balance_wallet_rounded,
    Icons.trending_up_rounded,
    Icons.settings_rounded,
  ];
  final _moduleColors = const [
    AppColors.primaryLight,
    AppColors.secondaryLight,
    AppColors.accentLight,
  ];

  // Custom input values keyed by scenarioId -> fieldName -> value
  final Map<String, Map<String, String>> _customInputValues = {};

  // Case study constraints
  CaseStudyConstraints? _caseStudyConstraints;
  // ignore: unused_field
  bool _loadingConstraints = false;

  // Case study narrative toggle
  bool _caseStudyExpanded = false;
  Map<String, dynamic>? _caseStudyData;

  // Baseline financials for round 0
  FinancialData? _baselineFinancials;
  bool _loadingBaseline = false;

  // Whether we've confirmed no team is selected (after waiting for async load)
  bool _noTeamSelected = false;
  bool _dataLoaded = false;

  // Track the last round we loaded data for, to detect round changes
  int? _lastLoadedRound;

  // Per-module selected scenario cache (for the 3 progress boxes)
  // Keyed by module name -> list of {title, amount}
  final Map<String, List<Map<String, dynamic>>> _moduleSelections = {
    'financing': [],
    'investing': [],
    'operating': [],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);

    // Load data after frame (team might still be loading from SharedPreferences)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tryLoadData();
      _loadActiveShocks();
    });
  }

  /// Initial REST fetch of active/unacknowledged market shocks. The app
  /// otherwise only receives shocks via socket pushes, so a player who opens
  /// the simulation after a shock was triggered (common in self-paced mode)
  /// would never see it. Populates [activeShocksProvider] for both modes.
  Future<void> _loadActiveShocks() async {
    try {
      final api = ref.read(apiClientProvider);
      final results = await Future.wait([
        api.getList(ApiEndpoints.shocksActive),
        api.getList(ApiEndpoints.shocksUnacknowledged),
      ]);
      if (!mounted) return;
      final merged = <String, Map<String, dynamic>>{};
      for (final list in results) {
        for (final s in list) {
          if (s is Map) {
            final m = Map<String, dynamic>.from(s);
            final id = (m['id'] ?? m['shockId'] ?? '').toString();
            if (id.isNotEmpty) merged[id] = m;
          }
        }
      }
      if (merged.isNotEmpty) {
        ref.read(activeShocksProvider.notifier).state = merged.values.toList();
      }
    } catch (_) {
      // Best-effort; socket pushes remain the primary channel.
    }
  }

  bool get _isSelfPaced {
    final auth = ref.read(authProvider);
    return auth.user != null && !auth.isFacilitator && ref.read(teamProvider).selectedTeam == null;
  }

  /// Try to load data. If no team is selected and not self-paced, wait briefly
  /// for async team loading from SharedPreferences, then show message.
  Future<void> _tryLoadData() async {
    final auth = ref.read(authProvider);
    final isSelfPacedLoggedIn = auth.user != null && !auth.isFacilitator;

    if (isSelfPacedLoggedIn) {
      _loadInitialData();
      if (mounted) setState(() => _dataLoaded = true);
      return;
    }

    // Team might still be loading from SharedPreferences - wait up to 1.5s
    for (int i = 0; i < 6; i++) {
      final team = ref.read(teamProvider).selectedTeam;
      if (team != null) {
        _loadInitialData();
        if (mounted) setState(() => _dataLoaded = true);
        return;
      }
      await Future.delayed(const Duration(milliseconds: 250));
      if (!mounted) return;
    }

    // After waiting, still no team
    if (mounted) {
      setState(() => _noTeamSelected = true);
    }
  }

  String get _effectiveTeamId {
    final team = ref.read(teamProvider).selectedTeam;
    if (team != null) return team.id;
    final user = ref.read(authProvider).user;
    return user != null ? 'self-paced-${user.id}' : 'self-paced';
  }

  int get _effectiveRound {
    // Prefer game state round (from server API) over cached team round
    // This ensures R2/R3 scenarios load correctly after facilitator advances
    if (!_isSelfPaced) {
      final gsRound = ref.read(gameStateProvider).whenData((gs) => gs.currentRound).value;
      if (gsRound != null && gsRound > 0) return gsRound;
    }
    final team = ref.read(teamProvider).selectedTeam;
    if (team != null) return team.currentRound;
    final user = ref.read(authProvider).user;
    return user?.currentRound ?? 1;
  }

  bool _initialDataLoading = false;

  Future<void> _loadInitialData() async {
    if (_initialDataLoading) return; // Prevent duplicate calls
    _initialDataLoading = true;

    if (_isSelfPaced) {
      // Self-paced: fetch progress from /self-paced/me
      await ref.read(selfPacedProvider.notifier).fetchProgress();
      return;
    }

    // Await game state from server FIRST (ensures round, locks, module are current)
    // This prevents using stale team.currentRound (e.g. R1 when facilitator advanced to R2)
    await ref.read(gameStateProvider.notifier).fetchGameState();

    final round = _effectiveRound;
    // ignore: avoid_print
    print('[SimulationScreen] _loadInitialData: round=$round (from game state)');
    ref.read(scenarioProvider.notifier).fetchScenarios(
      module: 'financing',
      round: round,
      teamId: ref.read(teamProvider).selectedTeam?.id,
    );
    final team = ref.read(teamProvider).selectedTeam;
    if (team != null) {
      ref.read(financialProvider.notifier).fetchTeamFinancials(team.id);
      ref.read(decisionProvider.notifier).fetchTeamDecisions(team.id, round: round);
      _fetchBaselineFinancials(team.id);
    }
    _fetchCaseStudyConstraints();
  }

  Future<void> _fetchBaselineFinancials(String teamId) async {
    if (_loadingBaseline) return; // Prevent duplicate calls
    setState(() => _loadingBaseline = true);
    try {
      final api = ref.read(apiClientProvider);
      final response = await api.get(
        ApiEndpoints.sheetsBaseline,
        params: {'teamId': teamId},
      );
      if (mounted) {
        setState(() {
          _baselineFinancials = FinancialData.fromJson(response);
          _loadingBaseline = false;
        });
      }
    } catch (_) {
      // Baseline not available (Excel not connected) - silently skip
      if (mounted) setState(() => _loadingBaseline = false);
    }
  }

  Future<void> _fetchCaseStudyConstraints() async {
    setState(() => _loadingConstraints = true);
    try {
      final api = ref.read(apiClientProvider);
      final response = await api.get(ApiEndpoints.caseStudyActive);
      if (mounted && response['caseStudyId'] != null) {
        setState(() {
          _caseStudyConstraints = CaseStudyConstraints.fromJson(response);
          _caseStudyData = response;
          _loadingConstraints = false;
        });
      } else {
        if (mounted) setState(() => _loadingConstraints = false);
      }
    } catch (_) {
      if (mounted) setState(() => _loadingConstraints = false);
    }
  }

  Widget _buildSelfPacedSimulation(BuildContext context, dynamic authState) {
    final spState = ref.watch(selfPacedProvider);
    final userName = authState.user?.displayName ?? 'Player';
    final userEmail = authState.user?.email ?? '';
    final currentModule = spState.currentModule;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient(context)),
        child: SafeArea(
          child: Column(
            children: [
              // ── Top bar (matches website: VIFM logo area + nav + user badge) ──
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, size: 20),
                      onPressed: () => context.pop(),
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    ),
                    // FinPlay title
                    Text.rich(
                      TextSpan(children: [
                        TextSpan(
                          text: 'Fin',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF5793D6),
                          ),
                        ),
                        TextSpan(
                          text: 'Play',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF243C76),
                          ),
                        ),
                      ]),
                    ),
                    const Spacer(),
                    // User badge (matches website blue gradient)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.person_rounded, size: 14, color: Colors.white),
                          const SizedBox(width: 6),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                userName,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              if (userEmail.isNotEmpty)
                                Text(
                                  userEmail,
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    // Reset button (orange)
                    _SmallActionButton(
                      icon: Icons.refresh_rounded,
                      color: const Color(0xFFF97316),
                      onTap: () => _showResetDialog(context),
                    ),
                    const SizedBox(width: 4),
                    // Logout button
                    _SmallActionButton(
                      icon: Icons.logout_rounded,
                      color: AppColors.textSecondary(context),
                      onTap: () {
                        ref.read(authProvider.notifier).logout();
                        context.go('/');
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ── Content: scrollable single page (NO tabs — matches website) ──
              Expanded(
                child: spState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : spState.isGameComplete
                        ? SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                            child: Column(
                              children: [
                                SelfPacedRoundProgress(
                                  currentRound: spState.currentRound,
                                  currentModule: currentModule,
                                  decisions: spState.decisions,
                                ),
                                const SizedBox(height: 16),
                                const SelfPacedGameComplete(),
                              ],
                            ),
                          )
                        : SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Round progress boxes (3 blue gradient boxes)
                                SelfPacedRoundProgress(
                                  currentRound: spState.currentRound,
                                  currentModule: currentModule,
                                  decisions: spState.decisions,
                                ),
                                // Active market shocks (facilitator-pushed) — now
                                // shown in self-paced mode too, matching the website.
                                const ActiveShocksDisplay(),
                                const SizedBox(height: 20),
                                // Active module's scenario panel (single panel, no tabs)
                                SelfPacedScenarioPanel(
                                  key: ValueKey('sp-$currentModule-${spState.currentRound}'),
                                  round: spState.currentRound,
                                  module: currentModule == 'complete'
                                      ? 'operating'
                                      : currentModule,
                                  onModuleCompleted: () {
                                    // Provider already re-fetched progress
                                  },
                                ),
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

  Future<void> _showResetDialog(BuildContext context) async {
    final s = ref.read(stringsProvider);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(s.tr('Reset Progress?', 'إعادة تعيين التقدّم؟')),
        content: Text(
          s.tr(
            'This will erase all your decisions and restart from Round 1. '
            'This action cannot be undone.',
            'سيؤدي ذلك إلى مسح جميع قراراتك وإعادة البدء من الجولة 1. لا يمكن التراجع عن هذا الإجراء.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(s.tr('Cancel', 'إلغاء')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
            ),
            child: Text(s.tr('Reset', 'إعادة تعيين')),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      ref.read(selfPacedProvider.notifier).resetProgress();
    }
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) return;
    // Save current module's selections before switching
    _saveCurrentModuleSelections();
    final round = _effectiveRound;
    ref.read(scenarioProvider.notifier).fetchScenarios(
      module: _modules[_tabController.index],
      round: round,
      teamId: _isSelfPaced ? null : ref.read(teamProvider).selectedTeam?.id,
    );
  }

  /// Save current module's selected scenarios to the progress cache
  void _saveCurrentModuleSelections() {
    final scenarioState = ref.read(scenarioProvider);
    final currentModule = _modules[_tabController.index];
    final selected = scenarioState.scenarios
        .where((s) => scenarioState.selectedScenarioIds.contains(s.id))
        .map((s) => <String, dynamic>{
              'title': s.title,
              'amount': s.amount ?? 0,
            })
        .toList();
    _moduleSelections[currentModule] = selected;
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  /// Compute the total amount of all selected scenarios
  double _selectedTotal(ScenarioState scenarioState) {
    double total = 0;
    for (final s in scenarioState.scenarios) {
      if (scenarioState.selectedScenarioIds.contains(s.id) && s.amount != null) {
        total += s.amount!;
      }
    }
    return total;
  }

  /// Build the custom values map for decision submission
  Map<String, dynamic> _buildCustomValues() {
    final result = <String, dynamic>{};
    _customInputValues.forEach((scenarioId, fields) {
      final parsed = <String, dynamic>{};
      fields.forEach((name, value) {
        parsed[name] = double.tryParse(value) ?? value;
      });
      result[scenarioId] = parsed;
    });
    return result;
  }

  Future<void> _submitDecision() async {
    final teamId = _effectiveTeamId;
    final round = _effectiveRound;
    final module = _modules[_tabController.index];
    final scenarioState = ref.read(scenarioProvider);
    final decisionNotifier = ref.read(decisionProvider.notifier);

    // Include custom input values in decision data
    final customValues = _buildCustomValues();
    if (customValues.isNotEmpty) {
      decisionNotifier.setDecisionData({
        ...ref.read(decisionProvider).currentDecision,
        'customInputs': customValues,
      });
    }

    // Match website logic: prioritize scenarios with non-zero amounts from Excel,
    // fallback to user-selected scenarios if none have amounts
    final scenariosWithAmounts = scenarioState.scenarios
        .where((s) => s.amount != null && s.amount != 0)
        .toList();
    final scenariosToConfirm = scenariosWithAmounts.isNotEmpty
        ? scenariosWithAmounts
        : scenarioState.scenarios
            .where((s) => scenarioState.selectedScenarioIds.contains(s.id))
            .toList();

    final decisions = scenariosToConfirm
        .map((s) => <String, dynamic>{
              'scenarioId': s.id,
              'amount': s.amount ?? 0,
              if (customValues.containsKey(s.id)) 'customValues': customValues[s.id],
            })
        .toList();

    final scenarioIds = scenariosToConfirm.map((s) => s.id).toList();

    final success = await decisionNotifier.confirmDecision(
      teamId: teamId,
      round: round,
      module: module,
      scenarioIds: scenarioIds,
      decisions: decisions,
    );

    if (success && mounted) {
      if (!_isSelfPaced) {
        ref.read(socketManagerProvider).sendDecision({
          'teamId': teamId,
          'round': round,
          'module': module,
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(ref.read(stringsProvider).tr('Decision confirmed!', 'تم تأكيد القرار!')),
            ],
          ),
          backgroundColor: AppColors.secondary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );

      if (!_isSelfPaced) {
        final team = ref.read(teamProvider).selectedTeam;
        if (team != null) {
          ref.read(financialProvider.notifier).fetchTeamFinancials(team.id);
          // Re-fetch decisions so isLocked=true is picked up immediately
          // This activates the "Unlock Decisions" button right after confirm
          ref.read(decisionProvider.notifier).fetchTeamDecisions(team.id, round: round);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final teamState = ref.watch(teamProvider);
    final team = teamState.selectedTeam;
    final authState = ref.watch(authProvider);
    final gameState = ref.watch(gameStateProvider);
    final scenarioState = ref.watch(scenarioProvider);
    final decisionState = ref.watch(decisionProvider);

    final isSelfPacedMode = authState.user != null && !authState.isFacilitator && team == null;

    // Self-paced mode: completely separate widget tree
    if (isSelfPacedMode) {
      return _buildSelfPacedSimulation(context, authState);
    }

    // Show "no team selected" screen for corporate mode
    if (_noTeamSelected && !isSelfPacedMode && team == null) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(gradient: AppColors.backgroundGradient(context)),
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.groups_rounded, size: 40, color: Color(0xFFF59E0B)),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      s.tr('No Team Selected', 'لم يتم اختيار فريق'),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      s.tr('You need to join a team before entering the simulation.\nGo to the lobby to select your team.',
                          'يجب الانضمام إلى فريق قبل دخول المحاكاة.\nاذهب إلى الردهة لاختيار فريقك.'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary(context),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => context.go('/lobby'),
                        icon: const Icon(Icons.login_rounded),
                        label: Text(s.tr('Go to Team Lobby', 'الذهاب إلى ردهة الفرق')),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back_rounded, size: 18),
                      label: Text(s.tr('Go Back', 'رجوع')),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    // If team just loaded (was null but now available after async load), trigger data load
    if (_noTeamSelected && team != null && !isSelfPacedMode) {
      _noTeamSelected = false;
      if (!_dataLoaded) {
        _dataLoaded = true;
        WidgetsBinding.instance.addPostFrameCallback((_) => _loadInitialData());
      }
    }

    final currentRound = isSelfPacedMode
        ? (authState.user?.currentRound ?? 1)
        : (gameState.whenData((gs) => gs.currentRound).value ?? team?.currentRound ?? 1);
    final currentModule = isSelfPacedMode
        ? (authState.user?.currentModule ?? 'financing')
        : (team?.currentModule ?? 'financing');
    final activeModuleIndex = _modules.indexOf(currentModule).clamp(0, 2);

    // Detect round change (e.g., facilitator advanced from R1 to R2) and re-fetch scenarios
    if (_lastLoadedRound != null && _lastLoadedRound != currentRound && _dataLoaded) {
      // ignore: avoid_print
      print('[SimulationScreen] Round changed: $_lastLoadedRound -> $currentRound, re-fetching scenarios');
      _lastLoadedRound = currentRound;
      // Reset tab to financing (new round starts at financing)
      if (_tabController.index != 0) {
        _tabController.animateTo(0);
      }
      // Clear module selections cache for new round
      _moduleSelections['financing'] = [];
      _moduleSelections['investing'] = [];
      _moduleSelections['operating'] = [];
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(scenarioProvider.notifier).fetchScenarios(
          module: 'financing',
          round: currentRound,
          teamId: _isSelfPaced ? null : team?.id,
        );
        if (team != null) {
          ref.read(decisionProvider.notifier).fetchTeamDecisions(team.id, round: currentRound);
        }
      });
    }
    if (_lastLoadedRound == null && _dataLoaded) {
      _lastLoadedRound = currentRound;
    }

    // Check case study from game state
    final activeCaseStudyId = gameState.whenData((g) => g.activeCaseStudyId).value;
    final hasCaseStudy = !isSelfPacedMode && activeCaseStudyId != null && activeCaseStudyId.isNotEmpty;

    // Module lock status
    final isModuleLocked = !isSelfPacedMode && gameState.whenData((g) {
      switch (_modules[_tabController.index]) {
        case 'financing': return g.lockFinancing;
        case 'investing': return g.lockInvesting;
        case 'operating': return g.lockOperating;
        default: return false;
      }
    }).value == true;

    // Timer expired check
    final timerSeconds = ref.watch(timerSecondsProvider);
    final isTimerExpired = !isSelfPacedMode && timerSeconds != null && timerSeconds <= 0;

    // Team-leader hard lock: in team mode only, if a leader IS set and the
    // current user is NOT that leader, disable decision submission. Defensive:
    // when no leader set or status loading/error, keep normal (unlocked) behavior.
    final leaderStatus = isSelfPacedMode
        ? null
        : ref.watch(teamLeaderStatusProvider).valueOrNull;
    final isLeaderLocked =
        leaderStatus != null && leaderStatus.leader != null && !leaderStatus.amLeader;

    // Budget tracking
    final selectedTotal = _selectedTotal(scenarioState);
    final budgetLimit = _caseStudyConstraints?.budgetLimit ?? 0;
    final hasBudget = hasCaseStudy && budgetLimit > 0;
    final hasAnyAmounts = scenarioState.scenarios.any((s) =>
        scenarioState.selectedScenarioIds.contains(s.id) && s.amount != null);

    // Selected scenario names for status alert
    final selectedNames = scenarioState.scenarios
        .where((s) => scenarioState.selectedScenarioIds.contains(s.id))
        .map((s) => s.title)
        .toList();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient(context)),
        child: SafeArea(
          child: Column(
            children: [
              // Compact Top Bar - wrapped to prevent overflow
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 8, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, size: 20),
                      onPressed: () => context.pop(),
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    ),
                    _RoundBadge(round: currentRound),
                    const Spacer(),
                    if (team != null)
                      Flexible(
                        child: _TeamBadge(team: team),
                      )
                    else if (isSelfPacedMode)
                      Flexible(
                        child: _SelfPacedBadge(userName: authState.user?.displayName ?? 'You'),
                      ),
                    if (!isSelfPacedMode) ...[
                      const SizedBox(width: 4),
                      const ConnectionStatusBadge(),
                      const SizedBox(width: 4),
                      const HeaderTimer(),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Round Progress Boxes (like website's 3 colored boxes)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 6),
                      child: Text(
                        s.tr('Round $currentRound Progress  Year $currentRound of 3',
                            'تقدّم الجولة $currentRound  السنة $currentRound من 3'),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary(context),
                        ),
                      ),
                    ),
                    _RoundProgressBoxes(
                      modules: _moduleLabels,
                      moduleKeys: _modules,
                      icons: _moduleIcons,
                      colors: _moduleColors,
                      activeIndex: _tabController.index,
                      completedUpTo: activeModuleIndex,
                      moduleSelections: _moduleSelections,
                      currentScenarioState: scenarioState,
                      currentModuleKey: _modules[_tabController.index],
                      onTap: (i) {
                        _saveCurrentModuleSelections();
                        _tabController.animateTo(i);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Active Shocks from facilitator
              if (!isSelfPacedMode) const TeamLeaderBanner(),
              if (!isSelfPacedMode) const ActiveShocksDisplay(),

              // Timer Expired Alert
              if (isTimerExpired)
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.danger,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.timer_off_rounded, color: Colors.white, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.tr('TIME HAS EXPIRED!', 'انتهى الوقت!'),
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              s.tr('All scenario selections are now locked. Please wait for the facilitator to proceed.',
                                  'تم قفل جميع اختيارات السيناريوهات الآن. يُرجى انتظار الميسّر للمتابعة.'),
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              // Module Locked Alert
              if (isModuleLocked && !isTimerExpired)
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded, color: AppColors.secondaryLight, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          s.tr('Decisions for ${_moduleLabels[_tabController.index]} are locked.',
                              'قرارات ${_localizedModule(s, _modules[_tabController.index], _moduleLabels[_tabController.index])} مقفلة.'),
                          style: const TextStyle(fontSize: 12, color: AppColors.secondaryLight, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),

              // Selection Status Alert
              if (selectedNames.isNotEmpty && !isModuleLocked && !isTimerExpired)
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.info.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline_rounded, size: 16, color: AppColors.info),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          s.tr('${selectedNames.length} scenario${selectedNames.length != 1 ? 's' : ''} selected: ${selectedNames.join(', ')}',
                              'تم اختيار ${selectedNames.length} سيناريو: ${selectedNames.join('، ')}'),
                          style: TextStyle(fontSize: 11, color: AppColors.info, height: 1.3),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

              // Decision Status Bar (like website: Connected, Baseline, Locked, Team, R1)
              if (!isSelfPacedMode)
                Builder(builder: (context) {
                  // Check if existing decision for current module is locked in DB
                  final currentModuleKey = _modules[_tabController.index];
                  final existingDecision = decisionState.teamDecisions
                      .where((d) => d.module == currentModuleKey && d.roundNum == currentRound)
                      .firstOrNull;
                  final isDbLocked = existingDecision?.isLocked ?? false;
                  // Debug: trace decision lock state
                  // ignore: avoid_print
                  print('[DEBUG] teamDecisions count=${decisionState.teamDecisions.length}, '
                      'module=$currentModuleKey, round=$currentRound, '
                      'existingDecision=${existingDecision != null}, '
                      'isLocked=$isDbLocked');

                  return _DecisionStatusBar(
                    moduleName: _moduleLabels[_tabController.index],
                    moduleKey: currentModuleKey,
                    isLocked: isModuleLocked,
                    isTimerExpired: isTimerExpired,
                    isDecisionLockedInDb: isDbLocked,
                    teamId: team?.id ?? '',
                    currentRound: currentRound,
                    selectedCount: scenarioState.selectedScenarioIds.length,
                    baselineFinancials: _baselineFinancials,
                    onMoveNextTab: () {
                      _saveCurrentModuleSelections();
                      final currentIdx = _tabController.index;
                      if (currentIdx < 2) {
                        _tabController.animateTo(currentIdx + 1);
                      }
                    },
                  );
                }),

              const SizedBox(height: 4),

              // Feature 2: Case Study Constraints Panel
              if (hasCaseStudy && _caseStudyConstraints != null)
                _CaseStudyConstraintsPanel(
                  constraints: _caseStudyConstraints!,
                  selectedTotal: selectedTotal,
                  currentModule: _modules[_tabController.index],
                  selectedCount: scenarioState.selectedScenarioIds.length,
                ),

              // Case Study Narrative Toggle
              if (hasCaseStudy && _caseStudyData != null)
                _CaseStudyNarrativeToggle(
                  data: _caseStudyData!,
                  isExpanded: _caseStudyExpanded,
                  onToggle: () => setState(() => _caseStudyExpanded = !_caseStudyExpanded),
                ),

              // Module Content Tabs (hidden tabs, stepper controls)
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: List.generate(3, (moduleIndex) {
                    return _ModuleContent(
                      moduleIndex: moduleIndex,
                      moduleName: _moduleLabels[moduleIndex],
                      moduleColor: _moduleColors[moduleIndex],
                      moduleIcon: _moduleIcons[moduleIndex],
                      scenarioState: scenarioState,
                      financials: ref.watch(financialProvider),
                      isSelfPaced: isSelfPacedMode,
                      isLocked: isModuleLocked || isTimerExpired,
                      baselineFinancials: _baselineFinancials,
                      loadingBaseline: _loadingBaseline,
                      customInputValues: _customInputValues,
                      onCustomInputChanged: (scenarioId, fieldName, value) {
                        setState(() {
                          _customInputValues[scenarioId] ??= {};
                          _customInputValues[scenarioId]![fieldName] = value;
                        });
                      },
                      onToggle: (isModuleLocked || isTimerExpired)
                          ? (_) {} // No-op when locked
                          : (id) {
                              ref.read(scenarioProvider.notifier).toggleScenario(id);
                              if (!isSelfPacedMode) {
                                ref.read(socketManagerProvider).selectScenario({
                                  'scenarioId': id,
                                  'teamId': team?.id,
                                });
                              }
                            },
                    );
                  }),
                ),
              ),

              // Error bar
              if (decisionState.error != null)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.danger.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.danger.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.dangerLight, size: 18),
                      const SizedBox(width: 8),
                      Expanded(child: Text(decisionState.error!, style: const TextStyle(color: AppColors.dangerLight, fontSize: 12))),
                      IconButton(
                        icon: const Icon(Icons.close, size: 16, color: AppColors.dangerLight),
                        onPressed: () => ref.read(decisionProvider.notifier).clearError(),
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),

              // Feature 4: Budget Tracking Bar
              if (hasAnyAmounts || hasBudget)
                _BudgetTrackingBar(
                  selectedTotal: selectedTotal,
                  budgetLimit: hasBudget ? budgetLimit : null,
                ),

              // Bottom Action Bar
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.surfaceColor(context)
                      : AppColors.lightSurface,
                  border: Border(
                    top: BorderSide(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.borderColor(context).withValues(alpha: 0.5)
                          : AppColors.lightBorder,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    // Dashboard shortcut
                    _ActionIcon(
                      icon: Icons.bar_chart_rounded,
                      label: s.tr('Results', 'النتائج'),
                      onTap: () => context.push('/dashboard'),
                    ),
                    const SizedBox(width: 8),
                    _ActionIcon(
                      icon: Icons.school_rounded,
                      label: s.tr('Learn', 'تعلّم'),
                      onTap: () => context.push('/education'),
                    ),
                    const SizedBox(width: 12),
                    // Confirm / Locked / Next button
                    Expanded(
                      child: (isModuleLocked || isTimerExpired)
                          ? GestureDetector(
                              onTap: () {
                                // Navigate to next module or dashboard
                                final currentIdx = _tabController.index;
                                if (currentIdx < 2) {
                                  _tabController.animateTo(currentIdx + 1);
                                } else {
                                  context.push('/dashboard');
                                }
                              },
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: isTimerExpired
                                      ? AppColors.danger.withValues(alpha: 0.1)
                                      : AppColors.secondary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isTimerExpired
                                        ? AppColors.danger.withValues(alpha: 0.3)
                                        : AppColors.secondary.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      isTimerExpired ? Icons.timer_off_rounded : Icons.lock_rounded,
                                      size: 16,
                                      color: isTimerExpired ? AppColors.dangerLight : AppColors.secondaryLight,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      _tabController.index < 2 ? s.tr('Next Decisions', 'القرارات التالية') : s.tr('View Dashboard', 'عرض لوحة المعلومات'),
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: isTimerExpired ? AppColors.dangerLight : AppColors.secondaryLight,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      _tabController.index < 2 ? Icons.arrow_forward_rounded : Icons.bar_chart_rounded,
                                      size: 16,
                                      color: isTimerExpired ? AppColors.dangerLight : AppColors.secondaryLight,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : isLeaderLocked
                              ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GradientButton(
                                      text: s.tr('Confirm Decisions', 'تأكيد القرارات'),
                                      icon: Icons.lock_rounded,
                                      isLoading: false,
                                      onPressed: null,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      s.tr('Only the team leader can submit',
                                          'يمكن لقائد الفريق فقط تقديم القرارات'),
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.accentLight,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                )
                              : GradientButton(
                                  text: s.tr('Confirm Decisions', 'تأكيد القرارات'),
                                  icon: Icons.check_circle_rounded,
                                  isLoading: decisionState.isSubmitting,
                                  onPressed: (scenarioState.selectedScenarioIds.isNotEmpty ||
                                          scenarioState.scenarios.any((s) => s.amount != null && s.amount != 0))
                                      ? _submitDecision
                                      : null,
                                ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Feature 2: Case Study Constraints Panel
// ---------------------------------------------------------------------------

class _CaseStudyConstraintsPanel extends ConsumerWidget {
  final CaseStudyConstraints constraints;
  final double selectedTotal;
  final String currentModule;
  final int selectedCount;

  const _CaseStudyConstraintsPanel({
    required this.constraints,
    required this.selectedTotal,
    required this.currentModule,
    required this.selectedCount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    final budgetLimit = constraints.budgetLimit;
    final ratio = budgetLimit > 0 ? (selectedTotal / budgetLimit).clamp(0.0, 1.5) : 0.0;
    final isOverBudget = ratio > 1.0;
    final maxForModule = constraints.maxSelectionsPerModule[currentModule];
    final isOverMax = maxForModule != null && selectedCount > maxForModule;

    Color progressColor;
    if (ratio > 1.0) {
      progressColor = AppColors.dangerLight;
    } else if (ratio > 0.8) {
      progressColor = AppColors.accentLight;
    } else {
      progressColor = AppColors.secondaryLight;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isOverBudget
            ? AppColors.danger.withValues(alpha: 0.08)
            : AppColors.info.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isOverBudget
              ? AppColors.danger.withValues(alpha: 0.3)
              : AppColors.info.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.assignment_rounded,
                size: 16,
                color: isOverBudget ? AppColors.dangerLight : AppColors.info,
              ),
              const SizedBox(width: 6),
              Text(
                s.tr('Case Study Mode', 'وضع دراسة الحالة'),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isOverBudget ? AppColors.dangerLight : AppColors.info,
                  letterSpacing: 0.3,
                ),
              ),
              const Spacer(),
              if (constraints.description != null)
                Flexible(
                  child: Text(
                    constraints.description!,
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.textTertiary(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
          if (budgetLimit > 0) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  s.tr('Budget: ', 'الميزانية: '),
                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary(context)),
                ),
                Text(
                  '\$${_formatCurrency(selectedTotal)}',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: progressColor,
                  ),
                ),
                Text(
                  ' / \$${_formatCurrency(budgetLimit)}',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 12,
                    color: AppColors.textTertiary(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: ratio.clamp(0.0, 1.0),
                minHeight: 6,
                backgroundColor: AppColors.borderColor(context).withValues(alpha: 0.3),
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              ),
            ),
            if (isOverBudget) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, size: 14, color: AppColors.dangerLight),
                  const SizedBox(width: 4),
                  Text(
                    s.tr('Over budget by \$${_formatCurrency(selectedTotal - budgetLimit)}',
                        'تجاوز الميزانية بمقدار \$${_formatCurrency(selectedTotal - budgetLimit)}'),
                    style: const TextStyle(fontSize: 11, color: AppColors.dangerLight, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ],
          if (maxForModule != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  isOverMax ? Icons.warning_amber_rounded : Icons.checklist_rounded,
                  size: 14,
                  color: isOverMax ? AppColors.dangerLight : AppColors.textTertiary(context),
                ),
                const SizedBox(width: 4),
                Text(
                  s.tr('Max $maxForModule selections for ${currentModule[0].toUpperCase()}${currentModule.substring(1)} ($selectedCount selected)',
                      'الحد الأقصى $maxForModule اختيارات لـ ${currentModule[0].toUpperCase()}${currentModule.substring(1)} (تم اختيار $selectedCount)'),
                  style: TextStyle(
                    fontSize: 11,
                    color: isOverMax ? AppColors.dangerLight : AppColors.textSecondary(context),
                    fontWeight: isOverMax ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Case Study Narrative Toggle
// ---------------------------------------------------------------------------

class _CaseStudyNarrativeToggle extends ConsumerWidget {
  final Map<String, dynamic> data;
  final bool isExpanded;
  final VoidCallback onToggle;

  const _CaseStudyNarrativeToggle({
    required this.data,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    final title = data['title']?.toString() ?? data['caseStudyId']?.toString() ?? s.tr('Case Study', 'دراسة حالة');
    final narrative = data['narrative']?.toString() ?? data['description']?.toString() ?? '';
    final objectives = data['objectives'] as List<dynamic>? ?? [];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.info.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(Icons.business_center_rounded, size: 18, color: AppColors.info),
                  const SizedBox(width: 8),
                  Expanded(child: Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.info))),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(Icons.expand_more_rounded, size: 20, color: AppColors.textTertiary(context)),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 1),
                  const SizedBox(height: 8),
                  if (narrative.isNotEmpty)
                    Text(narrative, style: TextStyle(fontSize: 12, color: AppColors.textSecondary(context), height: 1.4)),
                  if (objectives.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(s.tr('Objectives:', 'الأهداف:'), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary(context))),
                    const SizedBox(height: 4),
                    ...objectives.map((o) => Padding(
                      padding: const EdgeInsets.only(left: 8, top: 2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('• ', style: TextStyle(color: AppColors.info, fontSize: 12)),
                          Expanded(child: Text(o.toString(), style: TextStyle(fontSize: 12, color: AppColors.textSecondary(context)))),
                        ],
                      ),
                    )),
                  ],
                ],
              ),
            ),
            crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }
}


// ---------------------------------------------------------------------------
// Feature 4: Budget Tracking Bar
// ---------------------------------------------------------------------------

class _BudgetTrackingBar extends ConsumerWidget {
  final double selectedTotal;
  final double? budgetLimit;

  const _BudgetTrackingBar({
    required this.selectedTotal,
    this.budgetLimit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    final hasBudget = budgetLimit != null && budgetLimit! > 0;
    final ratio = hasBudget ? (selectedTotal / budgetLimit!).clamp(0.0, 1.5) : 0.0;

    Color barColor;
    if (!hasBudget) {
      barColor = AppColors.primaryLight;
    } else if (ratio > 1.0) {
      barColor = AppColors.dangerLight;
    } else if (ratio > 0.8) {
      barColor = AppColors.accentLight;
    } else {
      barColor = AppColors.secondaryLight;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: barColor.withValues(alpha: 0.06),
        border: Border(
          top: BorderSide(color: barColor.withValues(alpha: 0.2)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.shopping_cart_rounded, size: 14, color: barColor),
              const SizedBox(width: 6),
              Text(
                s.tr('Selected: \$${_formatCurrency(selectedTotal)}', 'المحدد: \$${_formatCurrency(selectedTotal)}'),
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: barColor,
                ),
              ),
              if (hasBudget) ...[
                Text(
                  ' / \$${_formatCurrency(budgetLimit!)}',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 12,
                    color: AppColors.textTertiary(context),
                  ),
                ),
                Text(
                  s.tr(' budget', ' ميزانية'),
                  style: TextStyle(fontSize: 11, color: AppColors.textTertiary(context)),
                ),
              ],
            ],
          ),
          if (hasBudget) ...[
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: ratio.clamp(0.0, 1.0),
                minHeight: 4,
                backgroundColor: AppColors.borderColor(context).withValues(alpha: 0.3),
                valueColor: AlwaysStoppedAnimation<Color>(barColor),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Round Progress Stepper
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// 3 Round Progress Boxes (matches website's Financing/Investing/Operating boxes)
// ---------------------------------------------------------------------------

class _RoundProgressBoxes extends ConsumerWidget {
  final List<String> modules;
  final List<String> moduleKeys;
  final List<IconData> icons;
  final List<Color> colors;
  final int activeIndex;
  final int completedUpTo;
  final Map<String, List<Map<String, dynamic>>> moduleSelections;
  final ScenarioState currentScenarioState;
  final String currentModuleKey;
  final void Function(int) onTap;

  const _RoundProgressBoxes({
    required this.modules,
    required this.moduleKeys,
    required this.icons,
    required this.colors,
    required this.activeIndex,
    required this.completedUpTo,
    required this.moduleSelections,
    required this.currentScenarioState,
    required this.currentModuleKey,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    return SizedBox(
      height: 130,
      child: Row(
        children: List.generate(3, (index) {
          final isActive = index == activeIndex;
          final isCompleted = index < completedUpTo;
          final moduleKey = moduleKeys[index];

          // Get selections: for active module, use live data; for others, use cache
          List<Map<String, dynamic>> selections;
          if (moduleKey == currentModuleKey) {
            selections = currentScenarioState.scenarios
                .where((s) => currentScenarioState.selectedScenarioIds.contains(s.id))
                .map((s) => <String, dynamic>{
                      'title': s.title,
                      'amount': s.amount ?? 0,
                    })
                .toList();
          } else {
            selections = moduleSelections[moduleKey] ?? [];
          }

          // Colors matching website: active=deep blue, others=light blue
          final Color bgColor;
          final Color textColor;
          final Color borderColor;
          if (isActive) {
            bgColor = const Color(0xFF3B82F6); // blue-500
            textColor = Colors.white;
            borderColor = const Color(0xFF2563EB); // blue-600
          } else {
            bgColor = const Color(0xFFDBEAFE); // blue-100
            textColor = const Color(0xFF1E40AF); // blue-800
            borderColor = const Color(0xFFBFDBFE); // blue-200
          }

          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: EdgeInsets.only(
                  left: index == 0 ? 0 : 4,
                  right: index == 2 ? 0 : 4,
                ),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor, width: isActive ? 2 : 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Module name + checkmark
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _localizedModule(s, moduleKeys[index], modules[index]),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                          ),
                        ),
                        if (isCompleted || (isActive && selections.isNotEmpty))
                          Icon(
                            Icons.check_circle_rounded,
                            size: 16,
                            color: isActive
                                ? Colors.white.withValues(alpha: 0.8)
                                : const Color(0xFF16A34A),
                          )
                        else
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 14,
                            color: textColor.withValues(alpha: 0.5),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Selected scenarios list
                    Expanded(
                      child: selections.isEmpty
                          ? Center(
                              child: Text(
                                isActive ? s.tr('Select scenarios', 'اختر السيناريوهات') : s.tr('No selections', 'لا توجد اختيارات'),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: textColor.withValues(alpha: 0.5),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            )
                          : ListView(
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              children: selections.take(4).map((sel) {
                                final title = sel['title'] as String? ?? '';
                                final amount = (sel['amount'] as num?)?.toDouble() ?? 0;
                                final shortTitle = title.length > 20
                                    ? '${title.substring(0, 18)}...'
                                    : title;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          shortTitle,
                                          style: TextStyle(
                                            fontSize: 9,
                                            color: textColor.withValues(alpha: 0.85),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (amount != 0)
                                        Text(
                                          '\$${_formatCurrency(amount.abs())}',
                                          style: GoogleFonts.jetBrainsMono(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w600,
                                            color: textColor.withValues(alpha: 0.9),
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Decision Status Bar (matches website's status row)
// ---------------------------------------------------------------------------

class _DecisionStatusBar extends ConsumerStatefulWidget {
  final String moduleName;
  final String moduleKey;
  final bool isLocked;
  final bool isTimerExpired;
  final bool isDecisionLockedInDb;
  final String teamId;
  final int currentRound;
  final int selectedCount;
  final VoidCallback onMoveNextTab;
  final FinancialData? baselineFinancials;

  const _DecisionStatusBar({
    required this.moduleName,
    required this.moduleKey,
    required this.isLocked,
    required this.isTimerExpired,
    this.isDecisionLockedInDb = false,
    required this.teamId,
    required this.currentRound,
    required this.selectedCount,
    required this.onMoveNextTab,
    this.baselineFinancials,
  });

  @override
  ConsumerState<_DecisionStatusBar> createState() => _DecisionStatusBarState();
}

class _DecisionStatusBarState extends ConsumerState<_DecisionStatusBar> {
  bool _excelConnected = false;
  bool _unlocking = false;
  bool _advancing = false;

  @override
  void initState() {
    super.initState();
    _checkExcelConnection();
    // Poll decision lock state every 5 seconds (website polls every 3s)
    _startDecisionPolling();
  }

  Timer? _decisionPollTimer;
  Timer? _gameStatePollTimer;

  void _startDecisionPolling() {
    // Poll decision lock state every 5 seconds (website polls every 3s)
    _decisionPollTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted && widget.teamId.isNotEmpty) {
        ref.read(decisionProvider.notifier).fetchTeamDecisions(
          widget.teamId,
          round: widget.currentRound,
        );
      }
    });
    // Poll game state every 5 seconds to pick up facilitator unlock
    // (website polls round-state every 5s; facilitator toggle doesn't broadcast socket)
    _gameStatePollTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted) {
        ref.read(gameStateProvider.notifier).fetchGameState();
      }
    });
  }

  @override
  void dispose() {
    _decisionPollTimer?.cancel();
    _gameStatePollTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkExcelConnection() async {
    try {
      final api = ref.read(apiClientProvider);
      final response = await api.get(ApiEndpoints.excelConnectionStatus);
      if (mounted) {
        setState(() {
          _excelConnected = response['connected'] == true || response['status'] == 'connected';
        });
      }
    } catch (_) {
      // Excel not connected
    }
  }

  Future<void> _unlockDecisions() async {
    if (_unlocking || widget.teamId.isEmpty) return;
    setState(() => _unlocking = true);
    try {
      final api = ref.read(apiClientProvider);
      await api.post(ApiEndpoints.decisionsUnlock, data: {
        'teamId': widget.teamId,
        'module': widget.moduleKey,
        'round': widget.currentRound,
      });
      // Broadcast unlock via socket so teammates get notified
      final socketMgr = ref.read(socketManagerProvider);
      socketMgr.sendDecision({
        'teamId': widget.teamId,
        'module': widget.moduleKey,
        'round': widget.currentRound,
        'decisions': {'unlocked': true},
      });
      // Refresh game state + team decisions to pick up new lock status
      ref.read(gameStateProvider.notifier).fetchGameState();
      ref.read(decisionProvider.notifier).fetchTeamDecisions(
        widget.teamId,
        round: widget.currentRound,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.lock_open_rounded, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text(ref.read(stringsProvider).tr('Decisions unlocked! You can now modify selections.', 'تم فتح القرارات! يمكنك الآن تعديل الاختيارات.'))),
              ],
            ),
            backgroundColor: const Color(0xFF16A34A),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline_rounded, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text('${ref.read(stringsProvider).tr('Unlock Failed', 'فشل الفتح')}: ${e.toString().replaceAll('Exception: ', '')}')),
              ],
            ),
            backgroundColor: const Color(0xFFDC2626),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _unlocking = false);
    }
  }

  Future<void> _advanceToNextModule() async {
    if (_advancing || widget.teamId.isEmpty) return;

    // Check facilitator unlock first (like website)
    final gameState = ref.read(gameStateProvider);
    final isNextUnlocked = gameState.whenData((g) => g.nextDecisionsUnlocked).value ?? false;
    if (!isNextUnlocked) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.block_rounded, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text(ref.read(stringsProvider).tr('Advancement Locked by Facilitator. Please wait for facilitator approval.', 'التقدّم مقفل من قِبل الميسّر. يُرجى انتظار موافقة الميسّر.'))),
              ],
            ),
            backgroundColor: const Color(0xFFDC2626),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: const Duration(seconds: 3),
          ),
        );
      }
      return;
    }

    // Operating module → navigate to dashboard (like website)
    if (widget.moduleKey == 'operating') {
      if (mounted) {
        context.go('/dashboard');
      }
      return;
    }

    // Determine next module (financing→investing, investing→operating)
    final modules = ['financing', 'investing', 'operating'];
    final currentIdx = modules.indexOf(widget.moduleKey);
    final nextModule = modules[currentIdx + 1];

    // Toast titles matching website
    final s = ref.read(stringsProvider);
    final toastTitle = widget.moduleKey == 'financing'
        ? s.tr('Ready for Investing!', 'جاهز للاستثمار!')
        : s.tr('Ready for Operating!', 'جاهز للتشغيل!');

    setState(() => _advancing = true);
    try {
      final api = ref.read(apiClientProvider);
      await api.post(ApiEndpoints.excelAdvanceStage, data: {
        'currentModule': widget.moduleKey,
        'nextModule': nextModule,
        'teamId': widget.teamId,
      });
      // Refresh game state
      ref.read(gameStateProvider.notifier).fetchGameState();
      // Switch tab locally
      widget.onMoveNextTab();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text(s.tr('$toastTitle Moving to ${nextModule[0].toUpperCase()}${nextModule.substring(1)} Decisions...',
                    '$toastTitle جارٍ الانتقال إلى قرارات ${nextModule[0].toUpperCase()}${nextModule.substring(1)}...'))),
              ],
            ),
            backgroundColor: const Color(0xFF16A34A),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final errorMsg = e.toString().replaceAll('Exception: ', '');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline_rounded, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text('${ref.read(stringsProvider).tr('Cannot Advance', 'تعذّر التقدّم')}: $errorMsg')),
              ],
            ),
            backgroundColor: const Color(0xFFDC2626),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _advancing = false);
    }
  }

  void _showBaselineSheet() {
    final s = ref.read(stringsProvider);
    if (widget.baselineFinancials == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(s.tr('Baseline statements not available yet', 'القوائم الأساسية غير متاحة بعد')),
          backgroundColor: Colors.orange.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }
    // Show baseline in a bottom sheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollController) {
          final data = widget.baselineFinancials!;
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.assessment_rounded, color: Color(0xFF3B82F6)),
                    const SizedBox(width: 8),
                    Text(
                      s.tr('Baseline Financial Statements', 'القوائم المالية الأساسية'),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    _baselineRow(s.tr('Revenue', 'الإيرادات'), data.revenue),
                    _baselineRow(s.tr('Net Income', 'صافي الدخل'), data.netIncome),
                    _baselineRow(s.tr('Total Assets', 'إجمالي الأصول'), data.totalAssets),
                    _baselineRow(s.tr('Total Liabilities', 'إجمالي الخصوم'), data.totalLiabilities),
                    _baselineRow(s.tr('Total Equity', 'إجمالي حقوق الملكية'), data.totalEquity),
                    _baselineRow(s.tr('Operating Cash Flow', 'التدفق النقدي التشغيلي'), data.operatingCashFlow),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _baselineRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          Text(
            '\$${value.toStringAsFixed(0)}',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF3B82F6)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    // Socket connection status (real-time)
    final connectionAsync = ref.watch(connectionStatusProvider);
    final isSocketConnected = connectionAsync.when(
      data: (c) => c,
      loading: () => false,
      error: (_, _) => false,
    );

    // Team member count from socket presence
    final memberCount = ref.watch(teamMemberCountProvider);

    // Lock derived from multiple sources (matching website logic):
    // existingDecision?.isLocked || isConfirmed || isTimerExpired || gameState.lockModule
    final effectiveLocked = widget.isDecisionLockedInDb || widget.isLocked || widget.isTimerExpired;

    // "Move to Next" enabled when: locked AND facilitator unlocked (like website)
    // Website: disabled={!isLocked || !isNextDecisionsUnlocked}
    final gameState = ref.watch(gameStateProvider);
    final nextDecisionsUnlocked = gameState.whenData((g) => g.nextDecisionsUnlocked).value ?? false;
    final canMoveNext = effectiveLocked && nextDecisionsUnlocked;
    // Debug: trace Move to Next conditions
    // ignore: avoid_print
    print('[DEBUG] canMoveNext=$canMoveNext effectiveLocked=$effectiveLocked '
        'nextDecisionsUnlocked=$nextDecisionsUnlocked '
        'dbLock=${widget.isDecisionLockedInDb} gsLock=${widget.isLocked} timer=${widget.isTimerExpired}');
    final isOperating = widget.moduleKey == 'operating';
    final moveNextLabel = isOperating ? s.tr('Move to Team Dashboard', 'الانتقال إلى لوحة الفريق') : s.tr('Move to Next Decisions', 'الانتقال إلى القرارات التالية');

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 4, 12, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row: "Financing Decisions" + Locked/Open + R1
          Row(
            children: [
              Text(
                s.tr('${widget.moduleName} Decisions',
                    'قرارات ${_localizedModule(s, widget.moduleKey, widget.moduleName)}'),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              if (effectiveLocked)
                _StatusChipSmall(
                  icon: Icons.lock_rounded,
                  label: s.tr('Locked', 'مقفل'),
                  color: const Color(0xFF16A34A),
                )
              else
                _StatusChipSmall(
                  icon: Icons.lock_open_rounded,
                  label: s.tr('Open', 'مفتوح'),
                  color: const Color(0xFF3B82F6),
                ),
              const SizedBox(width: 4),
              _StatusChipSmall(
                label: 'R${widget.currentRound}',
                color: const Color(0xFF1F2937),
                filled: true,
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Status chips row (scrollable)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Connected badge - shows Excel connection, falls back to socket
                _StatusChipSmall(
                  icon: Icons.wifi_rounded,
                  label: (_excelConnected || isSocketConnected) ? s.tr('Connected', 'متصل') : s.tr('Disconnected', 'غير متصل'),
                  color: (_excelConnected || isSocketConnected)
                      ? const Color(0xFF16A34A)
                      : const Color(0xFFDC2626),
                ),
                const SizedBox(width: 6),
                // Synced badge - team member count (like website: teamSync.memberCount)
                _StatusChipSmall(
                  icon: Icons.sync_rounded,
                  label: s.tr('${memberCount > 0 ? memberCount : 1} synced', '${memberCount > 0 ? memberCount : 1} متزامن'),
                  color: const Color(0xFF3B82F6),
                ),
                const SizedBox(width: 6),
                // Baseline badge - tappable
                GestureDetector(
                  onTap: _showBaselineSheet,
                  child: _StatusChipSmall(
                    icon: Icons.assessment_rounded,
                    label: s.tr('Baseline', 'الأساس'),
                    color: widget.baselineFinancials != null
                        ? const Color(0xFF16A34A)
                        : Colors.grey,
                  ),
                ),
                const SizedBox(width: 6),
                // Team badge
                if (widget.teamId.isNotEmpty) ...[
                  _StatusChipSmall(
                    label: widget.teamId,
                    color: const Color(0xFF1F2937),
                    filled: true,
                  ),
                  const SizedBox(width: 6),
                ],
                // Unlock Decisions button - shows when decision is locked in DB
                // Website: only renders when existingDecision?.isLocked === true
                // But always shows on mobile for visibility, disabled when not locked
                GestureDetector(
                  onTap: widget.isDecisionLockedInDb ? _unlockDecisions : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: widget.isDecisionLockedInDb
                          ? (_unlocking ? const Color(0xFFB45309) : const Color(0xFFD97706))
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_unlocking)
                          const Padding(
                            padding: EdgeInsets.only(right: 4),
                            child: SizedBox(
                              width: 10, height: 10,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        Text(
                          _unlocking ? s.tr('Unlocking...', 'جارٍ الفتح...') : s.tr('Unlock Decisions', 'فتح القرارات'),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: widget.isDecisionLockedInDb ? Colors.white : Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                const SizedBox(width: 6),
                // Move to Next Decisions / Move to Team Dashboard button
                GestureDetector(
                  onTap: canMoveNext ? _advanceToNextModule : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: canMoveNext
                          ? const Color(0xFF16A34A)
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(6),
                      border: canMoveNext
                          ? null
                          : Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_advancing)
                          const Padding(
                            padding: EdgeInsets.only(right: 4),
                            child: SizedBox(
                              width: 10, height: 10,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        Text(
                          _advancing ? s.tr('Transitioning...', 'جارٍ الانتقال...') : moveNextLabel,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: canMoveNext ? Colors.white : Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChipSmall extends StatelessWidget {
  final IconData? icon;
  final String label;
  final Color color;
  final bool filled;

  const _StatusChipSmall({
    this.icon,
    required this.label,
    required this.color,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: filled ? color : color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: filled ? null : Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: filled ? Colors.white : color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: filled ? Colors.white : color,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundBadge extends ConsumerWidget {
  final int round;
  const _RoundBadge({required this.round});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary.withValues(alpha: 0.2), AppColors.primary.withValues(alpha: 0.05)],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.flag_rounded, size: 14, color: AppColors.primaryLight),
          const SizedBox(width: 4),
          Text(
            s.tr('Round $round/3', 'الجولة $round/3'),
            style: GoogleFonts.jetBrainsMono(
              fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryLight,
            ),
          ),
        ],
      ),
    );
  }
}

class _TeamBadge extends StatelessWidget {
  final dynamic team;
  const _TeamBadge({required this.team});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.teamColor(team.teamNumber - 1);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        team.name,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}

class _SelfPacedBadge extends StatelessWidget {
  final String userName;
  const _SelfPacedBadge({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.person_rounded, size: 14, color: AppColors.accentLight),
          const SizedBox(width: 4),
          Text(
            userName,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.accentLight),
          ),
        ],
      ),
    );
  }
}

class _SmallActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _SmallActionButton({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(color: color.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 14, color: color),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionIcon({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.borderColor(context)
                : AppColors.lightBorder,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: AppColors.primaryLight),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 9, color: AppColors.primaryLight)),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Module Content
// ---------------------------------------------------------------------------

class _ModuleContent extends ConsumerWidget {
  final int moduleIndex;
  final String moduleName;
  final Color moduleColor;
  final IconData moduleIcon;
  final ScenarioState scenarioState;
  final FinancialState financials;
  final bool isSelfPaced;
  final bool isLocked;
  final FinancialData? baselineFinancials;
  final bool loadingBaseline;
  final Map<String, Map<String, String>> customInputValues;
  final void Function(String scenarioId, String fieldName, String value) onCustomInputChanged;
  final void Function(String) onToggle;

  const _ModuleContent({
    required this.moduleIndex,
    required this.moduleName,
    required this.moduleColor,
    required this.moduleIcon,
    required this.scenarioState,
    required this.financials,
    required this.isSelfPaced,
    this.isLocked = false,
    required this.baselineFinancials,
    required this.loadingBaseline,
    required this.customInputValues,
    required this.onCustomInputChanged,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    if (scenarioState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (scenarioState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.warning_rounded, size: 48, color: moduleColor),
            const SizedBox(height: 12),
            Text(scenarioState.error!, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      );
    }

    if (scenarioState.scenarios.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(moduleIcon, size: 48, color: AppColors.textTertiary(context)),
            const SizedBox(height: 12),
            Text(s.tr('No scenarios available', 'لا توجد سيناريوهات متاحة'), style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(s.tr('Scenarios will appear when ready', 'ستظهر السيناريوهات عند الجاهزية'), style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      physics: const BouncingScrollPhysics(),
      children: [
        // Feature 1: Baseline Financials (corporate/team mode only)
        if (!isSelfPaced && baselineFinancials != null)
          _BaselineFinancialsCard(data: baselineFinancials!),

        if (!isSelfPaced && baselineFinancials != null)
          const SizedBox(height: 12),

        const SizedBox(height: 4),

        // Scenario cards
        ...scenarioState.scenarios.asMap().entries.map((entry) {
          final scenario = entry.value;
          final isSelected = scenarioState.selectedScenarioIds.contains(scenario.id);
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _ScenarioCard(
              scenario: scenario,
              isSelected: isSelected,
              isLocked: isLocked,
              moduleColor: moduleColor,
              customInputValues: customInputValues[scenario.id] ?? {},
              onCustomInputChanged: (fieldName, value) =>
                  onCustomInputChanged(scenario.id, fieldName, value),
              onTap: () => onToggle(scenario.id),
            ),
          );
        }),

        const SizedBox(height: 16),

        // Financial preview
        if (financials.teamFinancials != null)
          _FinancialPreview(data: financials.teamFinancials!),

        const SizedBox(height: 80),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Feature 1: Baseline Financials Card (Collapsible Accordion)
// ---------------------------------------------------------------------------

class _BaselineFinancialsCard extends ConsumerStatefulWidget {
  final FinancialData data;

  const _BaselineFinancialsCard({required this.data});

  @override
  ConsumerState<_BaselineFinancialsCard> createState() => _BaselineFinancialsCardState();
}

class _BaselineFinancialsCardState extends ConsumerState<_BaselineFinancialsCard> {
  bool _isExpanded = false;
  int _activeTab = 0; // 0 = I/S, 1 = B/S, 2 = CF

  // Tab labels for reference (used via short codes in UI)
  // ignore: unused_field
  static const _tabLabels = ['Income Statement', 'Balance Sheet', 'Cash Flow'];
  static const _tabIcons = [
    Icons.receipt_long_rounded,
    Icons.account_balance_rounded,
    Icons.swap_vert_rounded,
  ];

  /// Closing cash from the cash-flow map: prefer a key containing 'cash' and
  /// 'end'/'closing', else the last 'cash'-related entry. Null if none found.
  double? _closingCashFromCashFlow(Map<String, dynamic> cf) {
    if (cf.isEmpty) return null;
    double? lastCash;
    double? endCash;
    cf.forEach((key, value) {
      final t = key.toLowerCase();
      if (!t.contains('cash')) return;
      final v = _asDouble(value);
      if (v == null) return;
      lastCash = v;
      if (t.contains('end') || t.contains('closing')) endCash = v;
    });
    return endCash ?? lastCash;
  }

  /// Cash on the balance sheet: first key containing 'cash'. Null if none.
  double? _cashFromBalance(Map<String, dynamic> bs) {
    if (bs.isEmpty) return null;
    for (final entry in bs.entries) {
      if (entry.key.toLowerCase().contains('cash')) {
        return _asDouble(entry.value);
      }
    }
    return null;
  }

  double? _asDouble(dynamic v) {
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }

  Future<void> _exportBaseline(BuildContext context) async {
    final data = widget.data;
    final is_ = data.incomeStatement ?? {};
    final bs = data.balanceSheet ?? {};
    final cf = data.cashFlow ?? {};

    final buffer = StringBuffer();
    buffer.writeln('=== Baseline Financial Statements ===');
    buffer.writeln();
    buffer.writeln('--- Income Statement ---');
    for (final e in is_.entries) {
      buffer.writeln('${e.key}: ${e.value}');
    }
    buffer.writeln();
    buffer.writeln('--- Balance Sheet ---');
    for (final e in bs.entries) {
      buffer.writeln('${e.key}: ${e.value}');
    }
    buffer.writeln();
    buffer.writeln('--- Cash Flow ---');
    for (final e in cf.entries) {
      buffer.writeln('${e.key}: ${e.value}');
    }

    await Clipboard.setData(ClipboardData(text: buffer.toString()));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(ref.read(stringsProvider).tr('Baseline financials copied to clipboard', 'تم نسخ البيانات المالية الأساسية إلى الحافظة')),
          ],
        ),
        backgroundColor: AppColors.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final data = widget.data;
    final is_ = data.incomeStatement ?? {};
    final bs = data.balanceSheet ?? {};
    final cf = data.cashFlow ?? {};

    // Balance check: assets = liabilities + equity
    final totalAssets = data.totalAssets;
    final totalLiabilities = data.totalLiabilities;
    final totalEquity = data.totalEquity;
    final isBalanced = (totalAssets - (totalLiabilities + totalEquity)).abs() < 1.0;

    // Cash reconciliation: closing cash on the cash-flow statement vs. cash on
    // the balance sheet. Defensive — null when either value is unavailable.
    final cfCash = _closingCashFromCashFlow(cf);
    final bsCash = _cashFromBalance(bs);
    final bool? cashReconciled = (cfCash != null && bsCash != null)
        ? (cfCash - bsCash).abs() < (bsCash.abs() * 0.01).clamp(1.0, double.infinity)
        : null;

    return GlassCard(
      padding: EdgeInsets.zero,
      gradient: LinearGradient(
        colors: [AppColors.primary.withValues(alpha: 0.04), Colors.transparent],
      ),
      child: Column(
        children: [
          // Header (tap to expand/collapse)
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  const Icon(Icons.analytics_rounded, size: 18, color: AppColors.primaryLight),
                  const SizedBox(width: 8),
                  Text(
                    s.tr('Baseline Financials', 'البيانات المالية الأساسية'),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (isBalanced)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_circle, size: 12, color: AppColors.secondaryLight),
                          const SizedBox(width: 3),
                          Text(
                            s.tr('Balanced', 'متوازن'),
                            style: const TextStyle(fontSize: 10, color: AppColors.secondaryLight, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  if (cashReconciled != null) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: (cashReconciled ? AppColors.secondary : AppColors.accentLight)
                            .withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            cashReconciled ? Icons.check_circle : Icons.warning_amber_rounded,
                            size: 12,
                            color: cashReconciled ? AppColors.secondaryLight : AppColors.accentLight,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            cashReconciled
                                ? s.tr('Cash reconciled', 'النقد متطابق')
                                : s.tr('Cash mismatch', 'النقد غير متطابق'),
                            style: TextStyle(
                              fontSize: 10,
                              color: cashReconciled ? AppColors.secondaryLight : AppColors.accentLight,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const Spacer(),
                  // Download/Copy baseline data
                  GestureDetector(
                    onTap: () => _exportBaseline(context),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(Icons.copy_rounded, size: 16, color: AppColors.secondaryLight),
                    ),
                  ),
                  const SizedBox(width: 6),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: AppColors.textTertiary(context),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expandable content
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: [
                Divider(
                  height: 1,
                  color: AppColors.borderColor(context).withValues(alpha: 0.3),
                ),
                // Tab selector
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                  child: Row(
                    children: List.generate(3, (i) {
                      final isActive = i == _activeTab;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _activeTab = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? AppColors.primary.withValues(alpha: 0.1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isActive
                                    ? AppColors.primary.withValues(alpha: 0.3)
                                    : AppColors.borderColor(context).withValues(alpha: 0.2),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _tabIcons[i],
                                  size: 12,
                                  color: isActive ? AppColors.primaryLight : AppColors.textTertiary(context),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  i == 0 ? 'I/S' : i == 1 ? 'B/S' : 'CF',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                                    color: isActive ? AppColors.primaryLight : AppColors.textTertiary(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                // Tab content
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 4, 14, 14),
                  child: _activeTab == 0
                      ? _IncomeStatementTab(data: is_)
                      : _activeTab == 1
                          ? _BalanceSheetTab(data: bs, isBalanced: isBalanced)
                          : _CashFlowTab(data: cf),
                ),
              ],
            ),
            crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }
}

class _IncomeStatementTab extends ConsumerWidget {
  final Map<String, dynamic> data;
  const _IncomeStatementTab({required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    return Column(
      children: [
        _FinLine(s.tr('Revenue', 'الإيرادات'), _val(data['revenue']), AppColors.secondaryLight),
        _FinLine(s.tr('COGS', 'تكلفة البضاعة المباعة'), _val(data['cogs'] ?? data['costOfGoodsSold']), AppColors.textSecondary(context)),
        _FinLine(s.tr('Gross Profit', 'إجمالي الربح'), _val(data['grossProfit']), AppColors.primaryLight, bold: true),
        Divider(height: 12, color: AppColors.borderColor(context).withValues(alpha: 0.2)),
        _FinLine(s.tr('Operating Expenses', 'المصروفات التشغيلية'), _val(data['operatingExpenses'] ?? data['opex']), AppColors.textSecondary(context)),
        _FinLine(s.tr('Net Income', 'صافي الدخل'), _val(data['netIncome']), AppColors.secondaryLight, bold: true),
      ],
    );
  }
}

class _BalanceSheetTab extends ConsumerWidget {
  final Map<String, dynamic> data;
  final bool isBalanced;
  const _BalanceSheetTab({required this.data, required this.isBalanced});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    return Column(
      children: [
        _FinLine(s.tr('Total Assets', 'إجمالي الأصول'), _val(data['totalAssets']), AppColors.primaryLight, bold: true),
        _FinLine(s.tr('  Current Assets', '  الأصول المتداولة'), _val(data['currentAssets']), AppColors.textSecondary(context)),
        _FinLine(s.tr('  Fixed Assets', '  الأصول الثابتة'), _val(data['fixedAssets'] ?? data['nonCurrentAssets']), AppColors.textSecondary(context)),
        Divider(height: 12, color: AppColors.borderColor(context).withValues(alpha: 0.2)),
        _FinLine(s.tr('Total Liabilities', 'إجمالي الخصوم'), _val(data['totalLiabilities']), AppColors.accentLight, bold: true),
        _FinLine(s.tr('Total Equity', 'إجمالي حقوق الملكية'), _val(data['totalEquity']), AppColors.info, bold: true),
      ],
    );
  }
}

class _CashFlowTab extends ConsumerWidget {
  final Map<String, dynamic> data;
  const _CashFlowTab({required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    return Column(
      children: [
        _FinLine(s.tr('Operating', 'التشغيل'), _val(data['operatingCashFlow'] ?? data['operating']), AppColors.secondaryLight),
        _FinLine(s.tr('Investing', 'الاستثمار'), _val(data['investingCashFlow'] ?? data['investing']), AppColors.accentLight),
        _FinLine(s.tr('Financing', 'التمويل'), _val(data['financingCashFlow'] ?? data['financing']), AppColors.primaryLight),
        Divider(height: 12, color: AppColors.borderColor(context).withValues(alpha: 0.2)),
        _FinLine(
          s.tr('Net Cash Change', 'صافي التغيّر النقدي'),
          _val(data['netCashChange'] ?? data['netCash']),
          AppColors.info,
          bold: true,
        ),
      ],
    );
  }
}

/// Single financial line item
class _FinLine extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final bool bold;

  const _FinLine(this.label, this.value, this.color, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
                color: bold ? AppColors.textPrimary(context) : AppColors.textSecondary(context),
              ),
            ),
          ),
          Text(
            '${value < 0 ? '-' : ''}\$${_formatCurrency(value.abs())}',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 11,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
              color: value < 0 ? AppColors.dangerLight : color,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Scenario Card (with Features 3 & 5)
// ---------------------------------------------------------------------------

class _ScenarioCard extends ConsumerWidget {
  final dynamic scenario;
  final bool isSelected;
  final bool isLocked;
  final Color moduleColor;
  final Map<String, String> customInputValues;
  final void Function(String fieldName, String value) onCustomInputChanged;
  final VoidCallback onTap;

  const _ScenarioCard({
    required this.scenario,
    required this.isSelected,
    this.isLocked = false,
    required this.moduleColor,
    required this.customInputValues,
    required this.onCustomInputChanged,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final str = ref.watch(stringsProvider);
    final riskColor = _riskColor(scenario.riskLevel);
    final Scenario s = scenario as Scenario;
    final hasInputFields = s.inputFields != null && s.inputFields!.isNotEmpty;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isSelected
                ? [
                    isDark ? const Color(0xFF1E3A5F) : Colors.white,
                    isDark ? const Color(0xFF162D4A) : const Color(0xFFF0F7FF),
                  ]
                : [
                    isDark ? const Color(0xFF1A1A2E) : Colors.white,
                    isDark ? const Color(0xFF16213E) : const Color(0xFFFAFAFF),
                  ],
          ),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF1E40AF) // blue-800
                : isDark
                    ? AppColors.borderColor(context).withValues(alpha: 0.3)
                    : const Color(0xFF1E3A8A).withValues(alpha: 0.3), // blue-800/30
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: Learn button (absolute positioned in website, top-right here)
            Row(
              children: [
                // Risk badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: riskColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6, height: 6,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: riskColor),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        (scenario.riskLevel).toUpperCase(),
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: riskColor, letterSpacing: 0.5),
                      ),
                    ],
                  ),
                ),
                // Type badge (Debt/Equity like website)
                if (scenario.type.isNotEmpty) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: scenario.type == 'Equity'
                          ? const Color(0xFF3B82F6).withValues(alpha: 0.1)
                          : scenario.type == 'Debt'
                              ? const Color(0xFF6B7280).withValues(alpha: 0.1)
                              : const Color(0xFF6366F1).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: scenario.type == 'Equity'
                            ? const Color(0xFF3B82F6).withValues(alpha: 0.3)
                            : scenario.type == 'Debt'
                                ? const Color(0xFF6B7280).withValues(alpha: 0.3)
                                : const Color(0xFF6366F1).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      scenario.type,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: scenario.type == 'Equity'
                            ? const Color(0xFF2563EB)
                            : scenario.type == 'Debt'
                                ? const Color(0xFF4B5563)
                                : const Color(0xFF6366F1),
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                // Lock badge when decisions are locked
                if (isLocked && isSelected)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.lock_rounded, size: 10, color: AppColors.secondaryLight),
                        const SizedBox(width: 3),
                        Text(str.tr('Locked', 'مقفل'), style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: AppColors.secondaryLight)),
                      ],
                    ),
                  ),
                // Feature 5: Educational content button (opens full screen like website)
                _ScenarioLearnButton(scenario: s, moduleColor: moduleColor),
                const SizedBox(width: 4),
                // Quick tooltip button
                _EducationalTooltipButton(scenario: s, moduleColor: moduleColor),
              ],
            ),
            const SizedBox(height: 10),
            // Title - color coded by type (matching website)
            Text(
              scenario.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 17,
                color: scenario.type == 'Equity'
                    ? const Color(0xFF1D4ED8) // blue-700
                    : scenario.type == 'Debt'
                        ? const Color(0xFF15803D) // green-700
                        : AppColors.textPrimary(context),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),

            // Amount display (like website's gray box)
            if (scenario.amount != null && scenario.amount != 0)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : const Color(0xFFF9FAFB), // gray-50
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : const Color(0xFFE5E7EB), // gray-200
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      str.tr('Amount: ', 'المبلغ: '),
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary(context),
                      ),
                    ),
                    Text(
                      '${scenario.amount! < 0 ? '-' : ''}\$${_formatCurrency(scenario.amount!.abs())}',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: scenario.amount! > 0
                            ? const Color(0xFF15803D) // green-700
                            : const Color(0xFFDC2626), // red-600
                      ),
                    ),
                  ],
                ),
              ),

            // Type + Title subtitle (like website: "Debt: 10 Year Long-Term Loan...")
            if (scenario.type.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '${scenario.type}: ${scenario.title}',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary(context),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

            // Description (if different from type+title subtitle)
            if (scenario.description.isNotEmpty &&
                scenario.description != scenario.title &&
                scenario.description != '${scenario.type}: ${scenario.title}')
              Text(
                scenario.description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                  color: AppColors.textTertiary(context),
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

            // Constraint display (orange box - matching website)
            if (s.constraint != null && s.constraint!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED), // orange-50
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFFED7AA)), // orange-200
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline_rounded, size: 16, color: Color(0xFFF97316)), // orange-500
                    const SizedBox(width: 8),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: str.tr('Constraint: ', 'القيد: '),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF9A3412), // orange-800
                              ),
                            ),
                            TextSpan(
                              text: s.constraint!,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF9A3412), // orange-800
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Key Metrics display
            if (s.keyMetrics != null && s.keyMetrics!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E1B4B).withValues(alpha: 0.3) // indigo dark
                      : const Color(0xFFEEF2FF), // indigo-50
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF6366F1).withValues(alpha: 0.3)
                        : const Color(0xFFC7D2FE), // indigo-200
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.insights_rounded,
                      size: 16,
                      color: isDark ? const Color(0xFF818CF8) : const Color(0xFF6366F1),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        s.keyMetrics!,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? const Color(0xFFA5B4FC) : const Color(0xFF3730A3), // indigo-800
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Feature 3: Custom Input Fields
            if (hasInputFields && isSelected) ...[
              const SizedBox(height: 12),
              _ScenarioInputFields(
                inputFields: s.inputFields!,
                values: customInputValues,
                moduleColor: moduleColor,
                onChanged: onCustomInputChanged,
              ),
            ],

            const SizedBox(height: 12),

            // Selection button (matching website style)
            if (isLocked)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.secondary.withValues(alpha: 0.1)
                      : Colors.grey.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.secondary.withValues(alpha: 0.3)
                        : Colors.grey.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isSelected ? Icons.check_circle_rounded : Icons.lock_rounded,
                      size: 16,
                      color: isSelected ? AppColors.secondaryLight : Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isSelected ? str.tr('Decision Locked', 'القرار مقفل') : str.tr('Not Selected', 'غير محدد'),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? AppColors.secondaryLight : Colors.grey,
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF16A34A) // green-600
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF16A34A)
                        : const Color(0xFF1E40AF).withValues(alpha: 0.4), // blue-800
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isSelected ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded,
                      size: 18,
                      color: isSelected ? Colors.white : const Color(0xFF1E40AF),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isSelected ? str.tr('Selected', 'محدد') : str.tr('Add to Selection', 'أضف إلى الاختيار'),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : const Color(0xFF1E40AF),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _riskColor(String risk) {
    switch (risk.toLowerCase()) {
      case 'low': return AppColors.secondaryLight;
      case 'medium': return AppColors.accentLight;
      case 'high': return AppColors.dangerLight;
      default: return AppColors.lightTextTertiary;
    }
  }
}

// ---------------------------------------------------------------------------
// Feature 3: Scenario Input Fields
// ---------------------------------------------------------------------------

class _ScenarioInputFields extends ConsumerWidget {
  final List<ScenarioInputField> inputFields;
  final Map<String, String> values;
  final Color moduleColor;
  final void Function(String fieldName, String value) onChanged;

  const _ScenarioInputFields({
    required this.inputFields,
    required this.values,
    required this.moduleColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: moduleColor.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: moduleColor.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.tune_rounded, size: 14, color: moduleColor),
              const SizedBox(width: 4),
              Text(
                s.tr('Customize Values', 'تخصيص القيم'),
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: moduleColor),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...inputFields.map((field) {
            final currentValue = values[field.name] ?? field.defaultValue?.toString() ?? '';
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      field.label,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary(context),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: _CustomInputField(
                      fieldName: field.name,
                      initialValue: currentValue,
                      min: field.min,
                      max: field.max,
                      unit: field.unit,
                      moduleColor: moduleColor,
                      onChanged: (val) => onChanged(field.name, val),
                    ),
                  ),
                  if (field.unit != null) ...[
                    const SizedBox(width: 4),
                    Text(
                      field.unit!,
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textTertiary(context),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _CustomInputField extends ConsumerStatefulWidget {
  final String fieldName;
  final String initialValue;
  final double? min;
  final double? max;
  final String? unit;
  final Color moduleColor;
  final ValueChanged<String> onChanged;

  const _CustomInputField({
    required this.fieldName,
    required this.initialValue,
    this.min,
    this.max,
    this.unit,
    required this.moduleColor,
    required this.onChanged,
  });

  @override
  ConsumerState<_CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends ConsumerState<_CustomInputField> {
  late TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _validate(String val) {
    final s = ref.read(stringsProvider);
    final parsed = double.tryParse(val);
    String? error;
    if (val.isNotEmpty && parsed == null) {
      error = s.tr('Invalid number', 'رقم غير صالح');
    } else if (parsed != null) {
      if (widget.min != null && parsed < widget.min!) {
        error = s.tr('Min ${widget.min!.toStringAsFixed(0)}', 'الحد الأدنى ${widget.min!.toStringAsFixed(0)}');
      } else if (widget.max != null && parsed > widget.max!) {
        error = s.tr('Max ${widget.max!.toStringAsFixed(0)}', 'الحد الأقصى ${widget.max!.toStringAsFixed(0)}');
      }
    }
    setState(() => _errorText = error);
    widget.onChanged(val);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: GoogleFonts.jetBrainsMono(
        fontSize: 12,
        color: AppColors.textPrimary(context),
      ),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: _errorText != null
                ? AppColors.dangerLight
                : widget.moduleColor.withValues(alpha: 0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: _errorText != null
                ? AppColors.dangerLight
                : AppColors.borderColor(context).withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: widget.moduleColor),
        ),
        errorText: _errorText,
        errorStyle: const TextStyle(fontSize: 9),
        hintText: widget.min != null && widget.max != null
            ? '${widget.min!.toStringAsFixed(0)}-${widget.max!.toStringAsFixed(0)}'
            : null,
        hintStyle: TextStyle(fontSize: 10, color: AppColors.textTertiary(context)),
      ),
      onChanged: _validate,
      // Stop the tap from toggling the scenario card
      onTap: () {},
    );
  }
}

// ---------------------------------------------------------------------------
// Feature 5a: Scenario Learn Button (opens full educational content screen)
// ---------------------------------------------------------------------------

class _ScenarioLearnButton extends StatelessWidget {
  final Scenario scenario;
  final Color moduleColor;

  const _ScenarioLearnButton({
    required this.scenario,
    required this.moduleColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ScenarioEducationScreen(
              scenarioId: scenario.id,
              scenarioTitle: scenario.title,
            ),
          ),
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.primaryLight.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Icon(
          Icons.menu_book_rounded,
          size: 16,
          color: AppColors.primaryLight,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Feature 5b: Educational Tooltip Button
// ---------------------------------------------------------------------------

class _EducationalTooltipButton extends ConsumerWidget {
  final Scenario scenario;
  final Color moduleColor;

  const _EducationalTooltipButton({
    required this.scenario,
    required this.moduleColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    return GestureDetector(
      onTap: () => _showEducationalSheet(context, s),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.accentLight.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Icon(
          Icons.lightbulb_outline_rounded,
          size: 16,
          color: AppColors.accentLight,
        ),
      ),
    );
  }

  void _showEducationalSheet(BuildContext context, AppStrings s) {
    final impact = scenario.impact;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(ctx).size.height * 0.6,
          ),
          decoration: BoxDecoration(
            color: Theme.of(ctx).brightness == Brightness.dark
                ? AppColors.darkSurface
                : AppColors.lightSurface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderColor(ctx).withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: moduleColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.lightbulb_rounded, color: moduleColor, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            scenario.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary(ctx),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Description
                    Text(
                      s.tr('About this decision', 'حول هذا القرار'),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textTertiary(ctx),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      scenario.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary(ctx),
                        height: 1.5,
                      ),
                    ),

                    // Risk level explanation
                    const SizedBox(height: 16),
                    _EducationalRiskInfo(riskLevel: scenario.riskLevel),

                    // Impact breakdown
                    if (impact != null && impact.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(
                        s.tr('Financial Impact', 'الأثر المالي'),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textTertiary(ctx),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...impact.entries.map((entry) {
                        final val = (entry.value as num?)?.toDouble() ?? 0;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatImpactKey(entry.key),
                                style: TextStyle(fontSize: 12, color: AppColors.textSecondary(ctx)),
                              ),
                              Text(
                                '${val >= 0 ? '+' : ''}\$${_formatCurrency(val.abs())}',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: val >= 0 ? AppColors.secondaryLight : AppColors.dangerLight,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],

                    // AI Explanation button
                    const SizedBox(height: 16),
                    _AiExplainButton(term: '${scenario.title}: ${scenario.description}'),

                    // Full educational content button
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ScenarioEducationScreen(
                                scenarioId: scenario.id,
                                scenarioTitle: scenario.title,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.menu_book_rounded, size: 16),
                        label: Text(s.tr('Full Educational Content', 'المحتوى التعليمي الكامل')),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryLight,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    // Learn more link
                    const SizedBox(height: 8),
                    Center(
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          GoRouter.of(context).push('/education');
                        },
                        icon: const Icon(Icons.school_rounded, size: 16),
                        label: Text(s.tr('Education Hub', 'مركز التعليم')),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primaryLight,
                          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatImpactKey(String key) {
    // Convert camelCase to Title Case
    return key
        .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (m) => '${m[1]} ${m[2]}')
        .replaceRange(0, 1, key[0].toUpperCase());
  }
}

class _EducationalRiskInfo extends ConsumerWidget {
  final String riskLevel;
  const _EducationalRiskInfo({required this.riskLevel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    String riskDescription;
    String riskLabel;
    Color riskColor;
    IconData riskIcon;

    switch (riskLevel) {
      case 'low':
        riskLabel = s.tr('Low Risk', 'مخاطر منخفضة');
        riskDescription = s.tr(
            'Low risk decisions are conservative choices with predictable outcomes. '
            'They typically offer smaller returns but greater stability.',
            'القرارات منخفضة المخاطر هي خيارات متحفظة ذات نتائج متوقعة. عادةً ما تقدّم عوائد أقل لكن استقرارًا أكبر.');
        riskColor = AppColors.secondaryLight;
        riskIcon = Icons.shield_rounded;
        break;
      case 'high':
        riskLabel = s.tr('High Risk', 'مخاطر عالية');
        riskDescription = s.tr(
            'High risk decisions can lead to significant gains or losses. '
            'They require careful consideration and may dramatically change your financial position.',
            'القرارات عالية المخاطر قد تؤدي إلى مكاسب أو خسائر كبيرة. تتطلب دراسة متأنية وقد تغيّر مركزك المالي بشكل جذري.');
        riskColor = AppColors.dangerLight;
        riskIcon = Icons.local_fire_department_rounded;
        break;
      default:
        riskLabel = s.tr('Medium Risk', 'مخاطر متوسطة');
        riskDescription = s.tr(
            'Medium risk decisions balance potential reward with manageable risk. '
            'They offer moderate returns with some uncertainty.',
            'القرارات متوسطة المخاطر توازن بين العائد المحتمل والمخاطر القابلة للإدارة. تقدّم عوائد معتدلة مع بعض عدم اليقين.');
        riskColor = AppColors.accentLight;
        riskIcon = Icons.balance_rounded;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: riskColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: riskColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(riskIcon, size: 18, color: riskColor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  riskLabel,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: riskColor),
                ),
                const SizedBox(height: 4),
                Text(
                  riskDescription,
                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary(context), height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Financial Preview (existing, unchanged)
// ---------------------------------------------------------------------------

class _FinancialPreview extends ConsumerWidget {
  final dynamic data;

  const _FinancialPreview({required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    return GlassCard(
      padding: const EdgeInsets.all(16),
      gradient: LinearGradient(
        colors: [AppColors.accent.withValues(alpha: 0.06), Colors.transparent],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long_rounded, size: 18, color: AppColors.accentLight),
              const SizedBox(width: 8),
              Text(s.tr('Financial Snapshot', 'لمحة مالية'), style: Theme.of(context).textTheme.titleSmall),
              const Spacer(),
              GestureDetector(
                onTap: () => context.push('/dashboard'),
                child: Text(s.tr('View All', 'عرض الكل'), style: const TextStyle(fontSize: 12, color: AppColors.primaryLight, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _FinStat(s.tr('Revenue', 'الإيرادات'), data.revenue, AppColors.secondaryLight)),
              Expanded(child: _FinStat(s.tr('Net Income', 'صافي الدخل'), data.netIncome, AppColors.primaryLight)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _FinStat(s.tr('Assets', 'الأصول'), data.totalAssets, AppColors.accentLight)),
              Expanded(child: _FinStat(s.tr('Cash Flow', 'التدفق النقدي'), data.operatingCashFlow, const Color(0xFF06B6D4))),
            ],
          ),
        ],
      ),
    );
  }
}

class _FinStat extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _FinStat(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 10, color: AppColors.textTertiary(context))),
        const SizedBox(height: 2),
        AnimatedCounter(
          value: value,
          prefix: '\$',
          style: GoogleFonts.jetBrainsMono(
            fontSize: 14, fontWeight: FontWeight.w600,
            color: value < 0 ? AppColors.dangerLight : color,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Parse a dynamic value to double safely
double _val(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.toDouble();
  if (v is String) {
    if (v == 'NaN' || v.isEmpty) return 0;
    return double.tryParse(v) ?? 0;
  }
  return 0;
}

/// Format a number with thousand separators
String _formatCurrency(double value) {
  final intPart = value.toInt().toString();
  return intPart.replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (m) => '${m[1]},',
  );
}

/// Localized display name for a simulation module key, falling back to the
/// English label when the key is unknown.
String _localizedModule(AppStrings s, String key, String fallback) {
  switch (key) {
    case 'financing':
      return s.tr('Financing', 'التمويل');
    case 'investing':
      return s.tr('Investing', 'الاستثمار');
    case 'operating':
      return s.tr('Operating', 'التشغيل');
    default:
      return fallback;
  }
}

// ---------------------------------------------------------------------------
// AI Explanation Button (inside educational tooltip bottom sheet)
// ---------------------------------------------------------------------------
class _AiExplainButton extends ConsumerStatefulWidget {
  final String term;
  const _AiExplainButton({required this.term});

  @override
  ConsumerState<_AiExplainButton> createState() => _AiExplainButtonState();
}

class _AiExplainButtonState extends ConsumerState<_AiExplainButton> {
  bool _loading = false;
  String? _explanation;

  Future<void> _fetchExplanation() async {
    if (_explanation != null) return;
    setState(() => _loading = true);
    try {
      final repo = ref.read(educationRepositoryProvider);
      final result = await repo.fetchAiTooltip(term: widget.term);
      if (mounted) {
        final s = ref.read(stringsProvider);
        setState(() {
          _explanation = result['explanation'] as String? ??
              result['tooltip'] as String? ??
              s.tr('No explanation available.', 'لا يوجد تفسير متاح.');
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _explanation = ref.read(stringsProvider).tr('Could not load AI explanation.', 'تعذّر تحميل تفسير الذكاء الاصطناعي.');
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    if (_explanation != null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.auto_awesome, size: 14, color: AppColors.primaryLight),
                const SizedBox(width: 6),
                Text(s.tr('AI Explanation', 'تفسير الذكاء الاصطناعي'), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryLight, letterSpacing: 0.5)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _explanation!,
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary(context), height: 1.5),
            ),
          ],
        ),
      );
    }

    return Center(
      child: TextButton.icon(
        onPressed: _loading ? null : _fetchExplanation,
        icon: _loading
            ? SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryLight))
            : const Icon(Icons.auto_awesome, size: 16),
        label: Text(_loading ? s.tr('Loading...', 'جارٍ التحميل...') : s.tr('Ask AI to Explain', 'اطلب من الذكاء الاصطناعي الشرح')),
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
