import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/utils/constants.dart';
import '../../../data/education_catalog.dart';
import '../../../data/models/game_state.dart';
import '../../../data/models/shock.dart';
import '../../../data/repositories/facilitator_repository.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/repository_providers.dart';
import '../../../providers/team_provider.dart';
import '../../../providers/game_state_provider.dart';

import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../earnings_call/widgets/earnings_call_facilitator_card.dart';
import '../widgets/admin_panels.dart';
import '../widgets/cohorts_panel.dart';
import '../widgets/controls_cards.dart';
import '../widgets/downloads_cards.dart';
import '../widgets/delivery_checklist.dart';
import '../widgets/insights_panel.dart';
import '../widgets/market_forecasts_card.dart';
import '../widgets/master_voucher_card.dart';
import 'setup_wizard_screen.dart';
import '../../../app/i18n/app_strings.dart';

class FacilitatorScreen extends ConsumerStatefulWidget {
  const FacilitatorScreen({super.key});

  @override
  ConsumerState<FacilitatorScreen> createState() => _FacilitatorScreenState();
}

class _FacilitatorScreenState extends ConsumerState<FacilitatorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isAuthenticated = false;
  bool _isLoggingIn = false;
  String? _loginError;
  final _passwordController = TextEditingController();
  List<Shock> _shocks = [];

  @override
  void initState() {
    super.initState();
<<<<<<< Updated upstream
    _tabController = TabController(length: 19, vsync: this);
    // A facilitator who authenticated in the home "Admin Access" dialog already
    // holds a session (authProvider.isFacilitator, password header attached):
    // open the panel instead of asking for the password a second time.
    if (ref.read(authProvider).isFacilitator) {
      _isAuthenticated = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _loadAfterLogin();
      });
    }
  }

  void _loadAfterLogin() {
    ref.read(teamProvider.notifier).fetchTeams();
    ref.read(gameStateProvider.notifier).fetchGameState();
    _loadShocks();
=======
    _tabController = TabController(length: 23, vsync: this);
>>>>>>> Stashed changes
  }

  @override
  void dispose() {
    _tabController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() { _isLoggingIn = true; _loginError = null; });
    try {
      // One sign-in for the whole app: the auth provider stores the session
      // (password header) that every facilitator read and write then reuses.
      final success = await ref.read(authProvider.notifier).loginFacilitator(_passwordController.text);
      if (success) {
        setState(() => _isAuthenticated = true);
        _loadAfterLogin();
      } else {
        setState(() => _loginError = ref.read(stringsProvider).tr('Invalid password', 'كلمة مرور غير صحيحة'));
      }
    } catch (e) {
      setState(() => _loginError = e.toString());
    } finally {
      setState(() => _isLoggingIn = false);
    }
  }

  Future<void> _loadShocks() async {
    try {
      final repo = ref.read(facilitatorRepositoryProvider);
      final shocks = await repo.fetchShocks();
      setState(() => _shocks = shocks);
    } catch (_) {}
  }

  Future<void> _triggerShock(String shockId, int round) async {
    final s = ref.read(stringsProvider);
    try {
      final repo = ref.read(facilitatorRepositoryProvider);
      final gs = ref.read(gameStateProvider).valueOrNull;
      final res = await repo.triggerShock(shockId, round: round, module: gs?.currentModule);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res['message']?.toString() ?? s.tr('Shock triggered!', 'تم تفعيل الصدمة!')),
            backgroundColor: AppColors.danger,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      // 409 (already active for this round) and 400 (round outside 1-3) carry a
      // readable server message; show it as-is.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e is FacilitatorActionException
                ? e.message
                : s.tr('Could not trigger the shock', 'تعذّر تفعيل الصدمة')),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  Future<void> _toggleModuleLock(String module, bool locked) async {
    try {
      final repo = ref.read(facilitatorRepositoryProvider);
      await repo.lockModule(module, locked);
      ref.read(gameStateProvider.notifier).fetchGameState();
    } catch (_) {}
  }

  Future<void> _advanceRound() async {
    final s = ref.read(stringsProvider);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E293B) : Colors.white,
        title: Text(s.tr('Advance Round', 'تقديم الجولة')),
        content: Text(s.tr('This will move all teams to the next round. This action cannot be undone.',
            'سيؤدي هذا إلى نقل جميع الفرق إلى الجولة التالية. لا يمكن التراجع عن هذا الإجراء.')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(s.tr('Cancel', 'إلغاء'))),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            child: Text(s.tr('Advance', 'تقديم')),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final currentRound = ref.read(gameStateProvider).valueOrNull?.currentRound ?? 1;
    if (currentRound >= AppConstants.maxRounds) return;
    final repo = ref.read(facilitatorRepositoryProvider);
    final moved = await _forceRoundWithGapCheck(context, s, (force) => repo.advanceRound(currentRound, force: force));
    if (!moved) return;
    ref.read(gameStateProvider.notifier).fetchGameState();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(s.tr('All teams moved to Round ${currentRound + 1} Financing',
              'تم نقل جميع الفرق إلى تمويل الجولة ${currentRound + 1}')),
          backgroundColor: AppColors.secondary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAuthenticated) return _buildLoginView();
    return _buildAdminView();
  }

  Widget _buildLoginView() {
    final s = ref.watch(stringsProvider);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient(context)),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 72, height: 72,
                    decoration: BoxDecoration(
                      gradient: AppColors.dangerGradient,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(Icons.admin_panel_settings_rounded, color: Colors.white, size: 36),
                  ).animate().fadeIn().scale(begin: const Offset(0.5, 0.5)),
                  const SizedBox(height: 20),
                  Text(s.tr('Facilitator Access', 'دخول الميسّر'), style: Theme.of(context).textTheme.displaySmall)
                      .animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: 32),
                  GlassCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: s.tr('Admin Password', 'كلمة مرور المسؤول'),
                            prefixIcon: const Icon(Icons.lock_rounded),
                          ),
                          onFieldSubmitted: (_) => _login(),
                        ),
                        if (_loginError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Text(_loginError!, style: const TextStyle(color: AppColors.dangerLight, fontSize: 13)),
                          ),
                        const SizedBox(height: 20),
                        GradientButton(
                          text: s.tr('Authenticate', 'تسجيل الدخول'),
                          width: double.infinity,
                          gradient: AppColors.dangerGradient,
                          isLoading: _isLoggingIn,
                          onPressed: _login,
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 400.ms),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back),
                    label: Text(s.tr('Back', 'رجوع')),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdminView() {
    final teamState = ref.watch(teamProvider);
    final gameState = ref.watch(gameStateProvider);
    final s = ref.watch(stringsProvider);

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
                    IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
                    const Spacer(),
                    Text(s.tr('Facilitator Panel', 'لوحة الميسّر'), style: Theme.of(context).textTheme.headlineMedium),
                    const Spacer(),
                    IconButton(
                      tooltip: s.tr('Session Setup Wizard', 'معالج إعداد الجلسة'),
                      icon: const Icon(Icons.flag_rounded, color: AppColors.purple),
                      onPressed: () => SetupWizardScreen.open(context),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout_rounded, color: AppColors.dangerLight),
                      onPressed: () {
                        ref.read(authProvider.notifier).logoutFacilitator();
                        setState(() => _isAuthenticated = false);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                tabs: [
                  Tab(text: s.tr('Controls', 'التحكّم')),
                  Tab(text: s.tr('Cohorts', 'المجموعات')),
                  Tab(text: s.tr('Checklist', 'قائمة التقديم')),
                  Tab(text: s.tr('Leaderboard', 'لوحة المتصدّرين')),
                  Tab(text: s.tr('Teams', 'الفرق')),
                  Tab(text: s.tr('Sign-In', 'تسجيل الدخول')),
                  Tab(text: s.tr('Shocks', 'الصدمات')),
                  Tab(text: s.tr('Insights', 'الملاحظات')),
                  Tab(text: s.tr('Timer', 'المؤقّت')),
                  Tab(text: s.tr('Education', 'التعليم')),
                  Tab(text: s.tr('Realism', 'الواقعية')),
                  Tab(text: s.tr('Vouchers', 'القسائم')),
                  Tab(text: s.tr('Assessments', 'التقييمات')),
                  Tab(text: s.tr('QR Code', 'رمز QR')),
                  Tab(text: s.tr('Rounds', 'الجولات')),
                  Tab(text: s.tr('Round Details', 'تفاصيل الجولة')),
                  Tab(text: s.tr('Sim Control', 'التحكّم بالمحاكاة')),
                  Tab(text: s.tr('Answer Key', 'مفتاح الإجابات')),
                  Tab(text: s.tr('Downloads', 'التنزيلات')),
                  Tab(text: s.tr('Game Checks', 'فحوصات اللعبة')),
                  Tab(text: s.tr('Members', 'الأعضاء')),
                  Tab(text: s.tr('Activity', 'النشاط')),
                  Tab(text: s.tr('Settings', 'الإعدادات')),
                ],
              ),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _ControlsTab(
                      gameState: gameState,
                      repo: ref.read(facilitatorRepositoryProvider),
                      onRefreshState: () => ref.read(gameStateProvider.notifier).fetchGameState(),
                    ),
                    CohortsPanel(repo: ref.read(facilitatorRepositoryProvider)),
                    DeliveryChecklist(
                      repo: ref.read(facilitatorRepositoryProvider),
                      onOpenWizard: () => SetupWizardScreen.open(context),
                    ),
                    _LeaderboardTab(repo: ref.read(facilitatorRepositoryProvider)),
                    _TeamsTab(teams: teamState.teams),
                    _TeamSignInTab(repo: ref.read(facilitatorRepositoryProvider)),
                    _ShocksTab(
                      shocks: _shocks,
                      onTrigger: _triggerShock,
                      repo: ref.read(facilitatorRepositoryProvider),
                      currentRound: gameState.valueOrNull?.currentRound ?? 1,
                      currentModule: gameState.valueOrNull?.currentModule,
                    ),
                    InsightsPanel(
                      repo: ref.read(facilitatorRepositoryProvider),
                      currentRound: gameState.valueOrNull?.currentRound,
                    ),
                    _TimerTab(repo: ref.read(facilitatorRepositoryProvider)),
                    _EducationTab(gameState: gameState),
                    _RealismTab(repo: ref.read(facilitatorRepositoryProvider)),
                    _VouchersTab(repo: ref.read(facilitatorRepositoryProvider)),
                    _AssessmentsTab(repo: ref.read(facilitatorRepositoryProvider)),
                    _QrCodeTab(repo: ref.read(facilitatorRepositoryProvider), gameState: gameState),
                    _RoundsTab(gameState: gameState, onAdvance: _advanceRound),
                    _RoundDetailsTab(repo: ref.read(facilitatorRepositoryProvider)),
                    SimControlPanel(repo: ref.read(facilitatorRepositoryProvider)),
                    const _AnswerKeyTab(),
                    _DownloadsTab(repo: ref.read(facilitatorRepositoryProvider)),
                    _GameChecksTab(repo: ref.read(facilitatorRepositoryProvider)),
                    SelfPacedMembersPanel(repo: ref.read(facilitatorRepositoryProvider)),
                    ActivityLogPanel(repo: ref.read(facilitatorRepositoryProvider)),
                    _SettingsTab(
                      gameState: gameState,
                      repo: ref.read(facilitatorRepositoryProvider),
                      onToggleLock: _toggleModuleLock,
                      onClearCache: () async {
                        try {
                          // Local response cache, then the server's data cache (POST
                          // /cache/clear with the facilitator password).
                          await ref.read(gameRepositoryProvider).clearCache();
                          await ref.read(facilitatorRepositoryProvider).clearServerCache();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(s.tr('Cache cleared', 'تم مسح ذاكرة التخزين المؤقت')), backgroundColor: AppColors.secondary),
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(e is FacilitatorActionException
                                    ? e.message
                                    : s.tr('Could not clear the cache', 'تعذّر مسح ذاكرة التخزين المؤقت')),
                                backgroundColor: AppColors.danger,
                              ),
                            );
                          }
                        }
                      },
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

String _moduleLabel(AppStrings s, String module) => switch (module) {
      'financing' => s.tr('financing', 'التمويل'),
      'investing' => s.tr('investing', 'الاستثمار'),
      'operating' => s.tr('operating', 'التشغيل'),
      _ => module,
    };

/// Runs a force-round call. When the server refuses the forward move because the round
/// before is incomplete (400 ROUND_INCOMPLETE), lists the teams and missing modules and
/// offers "Move anyway", which resends with `force: true` — the website's standing rule.
/// Returns true when the teams were moved.
Future<bool> _forceRoundWithGapCheck(
  BuildContext context,
  AppStrings s,
  Future<void> Function(bool force) send,
) async {
  try {
    await send(false);
    return true;
  } on RoundIncompleteException catch (e) {
    if (!context.mounted) return false;
    final moveAnyway = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(s.tr('Round ${e.round - 1} is not complete', 'الجولة ${e.round - 1} غير مكتملة')),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.tr(
                'Every team must confirm at least one financing, one investing and one operating decision before Round ${e.round} opens. Still missing:',
                'يجب على كل فريق تأكيد قرار واحد على الأقل في التمويل والاستثمار والتشغيل قبل فتح الجولة ${e.round}. ما زال ناقصًا:',
              )),
              const SizedBox(height: 10),
              if (e.gaps.isEmpty)
                Text(e.message)
              else
                ...e.gaps.map((g) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Icon(Icons.warning_amber_rounded, size: 16, color: AppColors.accentLight),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '${g.teamName.replaceAll(RegExp(r'\s*\(Team\s+\d+\)'), '')}: '
                            '${g.missing.map((m) => _moduleLabel(s, m)).join(s.tr(', ', '، '))}',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ]),
                    )),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(s.tr('Cancel', 'إلغاء'))),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            child: Text(s.tr('Move anyway', 'النقل على أي حال')),
          ),
        ],
      ),
    );
    if (moveAnyway != true) return false;
    try {
      await send(true);
      return true;
    } catch (err) {
      if (context.mounted) _showActionError(context, s, err);
      return false;
    }
  } catch (err) {
    if (context.mounted) _showActionError(context, s, err);
    return false;
  }
}

void _showActionError(BuildContext context, AppStrings s, Object err) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(err is FacilitatorActionException
        ? err.message
        : s.tr('Something went wrong. Please try again.', 'حدث خطأ ما. يرجى المحاولة مرة أخرى.')),
    backgroundColor: AppColors.danger,
  ));
}

// ---- Controls Tab ----
class _ControlsTab extends StatefulWidget {
  final AsyncValue<GameState> gameState;
  final FacilitatorRepository repo;
  final VoidCallback onRefreshState;
  const _ControlsTab({required this.gameState, required this.repo, required this.onRefreshState});

  @override
  State<_ControlsTab> createState() => _ControlsTabState();
}

class _ControlsTabState extends State<_ControlsTab> {
  bool _corporateModeEnabled = false;
  // Corporate FinPlay game gate: the simulation tile stays dimmed for delegates until
  // they finish the learning modules OR the facilitator opens the game here.
  bool _simulationOpen = false;
  bool _simulationAccessLoaded = false;
  // Whether teams may move on to the next decision module (toggle-next-decisions).
  bool _nextDecisionsUnlocked = false;
  // Cohort access code minted when corporate mode is turned on — shared with the
  // room and required for team sign-in. Empty when corporate mode is off.
  String _corporateAccessCode = '';
  bool _lobbyOpen = false;
  String _gameStatus = 'stopped';
  // Server gameState.nextDecisionsUnlocked: whether teams may "Move to Next
  // Decisions". Mirrors what the server reports, never what was last tapped.
  bool _nextDecisionsUnlocked = false;
  bool _loading = false;

  // Covenant threshold overrides
  final _maxLeverageC = TextEditingController(text: '3.0');
  final _minCoverageC = TextEditingController(text: '1.5');
  bool _savingCovenant = false;

<<<<<<< Updated upstream
=======
  // Budget constraints
  // Case-study constraint overrides per module (website "Constraints" card).
  static const _constraintModules = ['financing', 'investing', 'operating'];
  final Map<String, TextEditingController> _maxBudgetC = {
    for (final m in _constraintModules) m: TextEditingController(),
  };
  final Map<String, TextEditingController> _maxSelectionsC = {
    for (final m in _constraintModules) m: TextEditingController(),
  };
  bool _caseStudyActive = false;
  bool _savingConstraint = false;

>>>>>>> Stashed changes
  @override
  void dispose() {
    _maxLeverageC.dispose();
    _minCoverageC.dispose();
<<<<<<< Updated upstream
=======
    for (final c in [..._maxBudgetC.values, ..._maxSelectionsC.values]) {
      c.dispose();
    }
>>>>>>> Stashed changes
    super.dispose();
  }

  Future<void> _saveCovenant(AppStrings s) async {
    final maxLev = double.tryParse(_maxLeverageC.text.trim());
    final minCov = double.tryParse(_minCoverageC.text.trim());
    if (maxLev == null || minCov == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(s.tr('Enter valid numbers', 'أدخل أرقامًا صحيحة')),
        backgroundColor: AppColors.danger));
      return;
    }
    setState(() => _savingCovenant = true);
    final ok = await widget.repo.setCovenantThresholds(maxLeverage: maxLev, minCoverage: minCov);
    if (mounted) {
      setState(() => _savingCovenant = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(ok
            ? s.tr('Covenant thresholds saved', 'تم حفظ حدود التعهّدات')
            : s.tr('Could not save thresholds', 'تعذّر حفظ الحدود')),
        backgroundColor: ok ? AppColors.secondary : AppColors.danger,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
    }
  }

<<<<<<< Updated upstream
=======
  Future<void> _loadCaseStudyConstraints() async {
    try {
      final cs = await widget.repo.fetchActiveCaseStudy();
      if (!mounted) return;
      setState(() {
        _caseStudyActive = cs != null;
        final constraints = cs?['constraints'];
        if (constraints is Map) {
          for (final m in _constraintModules) {
            final c = constraints[m];
            if (c is! Map) continue;
            _maxBudgetC[m]!.text = c['maxBudget'] != null ? '${c['maxBudget']}' : '';
            _maxSelectionsC[m]!.text = c['maxSelections'] != null ? '${c['maxSelections']}' : '';
          }
        }
      });
    } catch (_) {/* offline */}
  }

  Future<void> _saveConstraint(AppStrings s) async {
    final overrides = <String, Map<String, num>>{};
    for (final m in _constraintModules) {
      final entry = <String, num>{};
      final b = num.tryParse(_maxBudgetC[m]!.text.trim());
      final n = int.tryParse(_maxSelectionsC[m]!.text.trim());
      if (b != null) entry['maxBudget'] = b;
      if (n != null) entry['maxSelections'] = n;
      overrides[m] = entry;
    }
    setState(() => _savingConstraint = true);
    try {
      await widget.repo.saveCaseStudyOverrides(overrides);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(s.tr('Constraints saved', 'تم حفظ القيود')),
          backgroundColor: AppColors.secondary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ));
      }
    } catch (e) {
      if (mounted) _showActionError(context, s, e);
    } finally {
      if (mounted) setState(() => _savingConstraint = false);
    }
  }

>>>>>>> Stashed changes
  @override
  void initState() {
    super.initState();
    _loadSimulationAccess();
    _loadFacilitatorStatus();
    _loadLobbyStatus();
    _loadCaseStudyConstraints();
  }

  /// The lobby opens when a facilitator signs in and closes on a game reset; there is no
  /// switch for it on the server, so the panel only reports it (as the website does).
  Future<void> _loadLobbyStatus() async {
    try {
      final open = await widget.repo.fetchLobbyOpen();
      if (mounted) setState(() => _lobbyOpen = open);
    } catch (_) {}
  }

  /// Corporate mode and its access code come from GET /facilitator/status: the public
  /// round state never carries the code.
  Future<void> _loadFacilitatorStatus() async {
    try {
      final st = await widget.repo.getState();
      if (!mounted) return;
      setState(() {
        _corporateModeEnabled = st['corporateModeEnabled'] == true;
        _nextDecisionsUnlocked = st['nextDecisionsUnlocked'] == true;
        _corporateAccessCode = (st['corporateAccessCode'] ?? '').toString();
      });
    } catch (_) {/* keep what we have */}
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncFromGameState();
  }

  @override
  void didUpdateWidget(covariant _ControlsTab oldWidget) {
    super.didUpdateWidget(oldWidget);
<<<<<<< Updated upstream
    // The parent rebuilds this tab with a fresh AsyncValue after every
    // fetchGameState(); didChangeDependencies does not fire for that.
    if (!identical(oldWidget.gameState, widget.gameState)) _syncFromGameState();
=======
    if (oldWidget.gameState != widget.gameState) _syncFromGameState();
  }

  Future<void> _loadSimulationAccess() async {
    try {
      final open = await widget.repo.fetchSimulationAccess();
      if (mounted) setState(() { _simulationOpen = open; _simulationAccessLoaded = true; });
    } catch (_) {
      if (mounted) setState(() => _simulationAccessLoaded = true);
    }
  }

  Future<void> _toggleSimulationAccess(AppStrings s, bool open) async {
    setState(() => _loading = true);
    try {
      final now = await widget.repo.setSimulationAccess(open);
      if (!mounted) return;
      setState(() => _simulationOpen = now);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(now
            ? s.tr('FinPlay game opened: delegates can now enter the simulation from the home screen.',
                'تم فتح لعبة FinPlay: يمكن للمشاركين الآن دخول المحاكاة من الشاشة الرئيسية.')
            : s.tr('FinPlay game closed: the game tile is dimmed until delegates finish the modules or you open it.',
                'تم إغلاق لعبة FinPlay: تبقى بطاقة اللعبة باهتة حتى يُكمل المشاركون الوحدات أو تفتحها أنت.')),
        backgroundColor: now ? AppColors.secondary : AppColors.accent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
    } catch (e) {
      if (mounted) _showActionError(context, s, e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
>>>>>>> Stashed changes
  }

  void _syncFromGameState() {
    final gs = widget.gameState;
    gs.whenData((data) {
      if (mounted) {
        setState(() {
<<<<<<< Updated upstream
          // GET /facilitator/status: corporateAccessCode is the live cohort code
          // while corporate mode is on and null once it is off.
          _corporateModeEnabled = data.corporateModeEnabled;
          _corporateAccessCode = data.corporateAccessCode ?? '';
=======
          _nextDecisionsUnlocked = data.nextDecisionsUnlocked;
>>>>>>> Stashed changes
          _gameStatus = data.isActive ? 'playing' : 'stopped';
          _nextDecisionsUnlocked = data.nextDecisionsUnlocked;
        });
      }
    });
  }

  Future<void> _toggleCorporateMode(bool val) async {
    setState(() => _loading = true);
    try {
      final res = await widget.repo.toggleCorporateMode(val);
      if (res['success'] != true) {
        throw Exception(res['message'] ?? res['error'] ?? 'Corporate mode was not changed');
      }
      setState(() {
        _corporateModeEnabled = res['corporateModeEnabled'] == true;
        // Server mints a fresh code on enable, clears it on disable.
        _corporateAccessCode = res['corporateAccessCode']?.toString() ?? '';
      });
      widget.onRefreshState();
    } catch (e) {
      if (mounted) _showActionError(context, ProviderScope.containerOf(context).read(stringsProvider), e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  /// Play / Pause / Continue / Reset map to the server's start-game,
  /// pause-game, continue-game and reset-game routes. The status label only
  /// changes once the server confirmed the action.
  Future<void> _gameControl(String action) async {
    if (action == 'reset') {
      // Reset wipes every team's decisions and closes the lobby and the game gate; the
      // website guards it with a confirm dialog, so this does too.
      final s = ProviderScope.containerOf(context).read(stringsProvider);
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(s.tr('Reset the game?', 'إعادة تعيين اللعبة؟')),
          content: Text(s.tr(
              'This clears every team\'s decisions and progress and closes the lobby and the game. It cannot be undone.',
              'يمسح هذا قرارات جميع الفرق وتقدّمها ويغلق الردهة واللعبة. لا يمكن التراجع عن هذا الإجراء.')),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(s.tr('Cancel', 'إلغاء'))),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
              child: Text(s.tr('Reset', 'إعادة تعيين')),
            ),
          ],
        ),
      );
      if (ok != true || !mounted) return;
    }
    setState(() => _loading = true);
    try {
      final r = widget.repo;
      final ok = await switch (action) {
        'play' => r.startGame(),
        'pause' => r.pauseGame(),
        'continue' => r.continueGame(),
        'reset' => r.resetGame(),
        _ => Future.value(false),
      };
      if (!ok) throw Exception('The server rejected the request');
      setState(() => _gameStatus = action == 'reset' ? 'stopped' : action);
      widget.onRefreshState();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Game ${action == 'play' ? 'started' : action == 'pause' ? 'paused' : action == 'continue' ? 'continued' : 'reset'}'),
            backgroundColor: action == 'reset' ? AppColors.danger : AppColors.secondary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      if (mounted) _showActionError(context, ProviderScope.containerOf(context).read(stringsProvider), e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final s = ref.watch(stringsProvider);
      return ListView(
      padding: const EdgeInsets.all(16),
      children: [
<<<<<<< Updated upstream
        // There is no site-access password on the website (the old switch posted
        // to a route that never existed). The website's entry gate is the
        // corporate game gate; see ApiEndpoints.facilitatorSimulationAccess.
        // TODO(owner): decide whether to add a /facilitator/simulation-access switch here.
=======
>>>>>>> Stashed changes
        // Corporate Mode Toggle
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: (_corporateModeEnabled ? AppColors.primary : AppColors.cardColor(context)).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _corporateModeEnabled ? Icons.business_rounded : Icons.person_rounded,
                color: _corporateModeEnabled ? AppColors.primaryLight : AppColors.textTertiary(context),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.tr('Corporate Mode', 'وضع الشركات'), style: Theme.of(context).textTheme.titleMedium),
                Text(
                  _corporateModeEnabled ? s.tr('Team-based mode enabled', 'تم تفعيل الوضع الجماعي') : s.tr('Self-paced mode', 'وضع التعلّم الذاتي'),
                  style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context)),
                ),
              ],
            )),
            Switch(
              value: _corporateModeEnabled,
              onChanged: _loading ? null : _toggleCorporateMode,
              activeTrackColor: AppColors.primaryLight,
            ),
          ]),
        ),
        // Cohort access code — shown only to the facilitator, to read out to the
        // room. Participants must enter it to join a team while corporate is live.
        if (_corporateModeEnabled && _corporateAccessCode.isNotEmpty) ...[
          const SizedBox(height: 8),
          GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(children: [
              const Icon(Icons.vpn_key_rounded, color: Color(0xFFF59E0B), size: 20),
              const SizedBox(width: 12),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.tr('Cohort access code', 'رمز الدخول للجلسة'),
                      style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context))),
                  SelectableText(
                    _corporateAccessCode,
                    style: GoogleFonts.jetBrainsMono(
                        fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: 3),
                  ),
                ],
              )),
              IconButton(
                tooltip: s.tr('Copy', 'نسخ'),
                icon: const Icon(Icons.copy_rounded, size: 18),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _corporateAccessCode));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(s.tr('Code copied', 'تم نسخ الرمز'))));
                },
              ),
            ]),
          ),
        ],
        // One QR per team: scanning carries the cohort code and the team (website TeamJoinCodes).
        if (_corporateModeEnabled) ...[
          const SizedBox(height: 8),
          TeamJoinCodesCard(repo: widget.repo, accessCode: _corporateAccessCode),
        ],
        // Corporate mode on with no code stored is not a cosmetic gap: sign-in is only
        // gated when a code exists, so the cohort is open to anyone with the link.
        if (_corporateModeEnabled && _corporateAccessCode.isEmpty) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.danger.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.dangerLight.withValues(alpha: 0.6), width: 1.5),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.warning_amber_rounded, color: AppColors.dangerLight, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text(
                s.tr('No access code - anyone with the link can join. Corporate mode is on but this cohort has no code stored, and sign-in is only gated when a code exists. Turn Corporate Mode off, then on again: the code is generated on that switch and will appear here.',
                    'لا يوجد رمز دخول - يمكن لأي شخص لديه الرابط الانضمام. وضع الشركات مفعّل لكن لا يوجد رمز محفوظ لهذه المجموعة، ولا يُقيَّد تسجيل الدخول إلا عند وجود رمز. أوقف وضع الشركات ثم فعّله مجددًا: يُنشأ الرمز عند هذا التبديل وسيظهر هنا.'),
                style: const TextStyle(fontSize: 12, color: AppColors.dangerLight),
              )),
            ]),
          ),
        ],
        const SizedBox(height: 16),

        // Game Controls
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const Icon(Icons.gamepad_rounded, color: AppColors.primaryLight, size: 20),
                const SizedBox(width: 8),
                Text(s.tr('Game Controls', 'أدوات التحكّم باللعبة'), style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (_gameStatus == 'play' || _gameStatus == 'playing' || _gameStatus == 'continue'
                        ? AppColors.secondary
                        : _gameStatus == 'pause'
                            ? AppColors.accent
                            : AppColors.danger).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _gameStatus == 'play' || _gameStatus == 'playing' || _gameStatus == 'continue'
                        ? s.tr('PLAYING', 'قيد التشغيل')
                        : _gameStatus == 'pause'
                            ? s.tr('PAUSED', 'متوقّفة مؤقتًا')
                            : s.tr('STOPPED', 'متوقّفة'),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _gameStatus == 'play' || _gameStatus == 'playing' || _gameStatus == 'continue'
                          ? AppColors.secondaryLight
                          : _gameStatus == 'pause'
                              ? AppColors.accentLight
                              : AppColors.dangerLight,
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _GameControlButton(
                    icon: Icons.play_arrow_rounded,
                    label: s.tr('Play', 'تشغيل'),
                    color: AppColors.secondary,
                    onPressed: _loading ? null : () => _gameControl('play'),
                  )),
                  const SizedBox(width: 8),
                  Expanded(child: _GameControlButton(
                    icon: Icons.pause_rounded,
                    label: s.tr('Pause', 'إيقاف مؤقت'),
                    color: AppColors.accent,
                    onPressed: _loading ? null : () => _gameControl('pause'),
                  )),
                  const SizedBox(width: 8),
                  Expanded(child: _GameControlButton(
                    icon: Icons.play_circle_outline_rounded,
                    label: s.tr('Continue', 'متابعة'),
                    color: AppColors.primaryLight,
                    onPressed: _loading ? null : () => _gameControl('continue'),
                  )),
                  const SizedBox(width: 8),
                  Expanded(child: _GameControlButton(
                    icon: Icons.refresh_rounded,
                    label: s.tr('Reset', 'إعادة تعيين'),
                    color: AppColors.danger,
                    onPressed: _loading ? null : () => _gameControl('reset'),
                  )),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // FinPlay game gate (website "FinPlay Game Open/Close")
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: (_simulationOpen ? AppColors.secondary : AppColors.cardColor(context)).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _simulationOpen ? Icons.sports_esports_rounded : Icons.lock_rounded,
                color: _simulationOpen ? AppColors.secondaryLight : AppColors.textTertiary(context),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.tr('FinPlay Game', 'لعبة FinPlay'), style: Theme.of(context).textTheme.titleMedium),
                Text(
                  _simulationOpen
                      ? s.tr('Open - delegates can enter the simulation', 'مفتوحة - يمكن للمشاركين دخول المحاكاة')
                      : s.tr('Closed - opens when delegates finish the modules, or when you open it',
                          'مغلقة - تُفتح عندما يُكمل المشاركون الوحدات، أو عندما تفتحها أنت'),
                  style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context)),
                ),
              ],
            )),
            Switch(
              value: _simulationOpen,
              onChanged: (_loading || !_simulationAccessLoaded) ? null : (v) => _toggleSimulationAccess(s, v),
              activeTrackColor: AppColors.secondaryLight,
            ),
          ]),
        ),
        const SizedBox(height: 12),

        // Lobby Controls
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: (_lobbyOpen ? AppColors.secondary : AppColors.cardColor(context)).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _lobbyOpen ? Icons.meeting_room_rounded : Icons.door_front_door_rounded,
                color: _lobbyOpen ? AppColors.secondaryLight : AppColors.textTertiary(context),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.tr('Lobby', 'الردهة'), style: Theme.of(context).textTheme.titleMedium),
                Text(
                  _lobbyOpen
                      ? s.tr('Lobby is open for players. It closes when the game is reset.',
                          'الردهة مفتوحة للاعبين. تُغلق عند إعادة تعيين اللعبة.')
                      : s.tr('Lobby is closed. Signing in to this panel opens it.',
                          'الردهة مغلقة. يفتحها تسجيل الدخول إلى هذه اللوحة.'),
                  style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context)),
                ),
              ],
            )),
            IconButton(
              tooltip: s.tr('Refresh', 'تحديث'),
              onPressed: _loadLobbyStatus,
              icon: const Icon(Icons.refresh_rounded, size: 20),
            ),
          ]),
        ),
        const SizedBox(height: 12),

        // Round/Module Navigation Grid
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const Icon(Icons.grid_view_rounded, color: AppColors.primaryLight, size: 20),
                const SizedBox(width: 8),
                Text(s.tr('Round/Module Navigation', 'التنقّل بين الجولات/الوحدات'), style: Theme.of(context).textTheme.titleMedium),
              ]),
              const SizedBox(height: 12),
              Row(
                children: [
                  const SizedBox(width: 40),
                  ...['Fin', 'Inv', 'Ops'].asMap().entries.map((e) => Expanded(
                    child: Center(child: Text(e.value, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600,
                      color: e.key == 0 ? AppColors.secondaryLight : e.key == 1 ? AppColors.primaryLight : AppColors.accentLight))),
                  )),
                ],
              ),
              const SizedBox(height: 8),
              ...List.generate(3, (r) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    SizedBox(width: 40, child: Text('R${r + 1}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13))),
                    ...['financing', 'investing', 'operating'].asMap().entries.map((e) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: SizedBox(
                          height: 36,
                          child: ElevatedButton(
                            onPressed: _loading ? null : () => _forcePosition(r + 1, e.value),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: (e.key == 0 ? AppColors.secondary : e.key == 1 ? AppColors.primary : AppColors.accent).withValues(alpha: 0.15),
                              foregroundColor: e.key == 0 ? AppColors.secondaryLight : e.key == 1 ? AppColors.primaryLight : AppColors.accentLight,
                              padding: EdgeInsets.zero, elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text('R${r + 1} ${e.value.substring(0, 3).toUpperCase()}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
              )),
              const SizedBox(height: 4),
              // Park every team on a round's results dashboard (decisions of that round locked).
              Row(children: [
                const SizedBox(width: 40),
                ...List.generate(3, (r) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: SizedBox(
                      height: 36,
                      child: OutlinedButton(
                        onPressed: _loading ? null : () => _sendTeamsToResults(s, r + 1),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.purple,
                          side: BorderSide(color: AppColors.purple.withValues(alpha: 0.5)),
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(s.tr('Teams to R${r + 1} results', 'الفرق إلى نتائج ج${r + 1}'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                )),
              ]),
            ],
          ),
        ),
        const SizedBox(height: 12),

<<<<<<< Updated upstream
        // Next Decisions (website "Unlock / Lock" next-decisions control):
        // POST /facilitator/toggle-next-decisions. The label and the button
        // follow the server's nextDecisionsUnlocked, so the facilitator sees
        // whether teams can currently "Move to Next Decisions".
=======
        // Next decisions gate (website "Unlock Decisions Control"): teams can only move on
        // to the next decision module while this is unlocked.
>>>>>>> Stashed changes
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
<<<<<<< Updated upstream
                color: (_nextDecisionsUnlocked ? AppColors.secondary : AppColors.danger).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _nextDecisionsUnlocked ? Icons.lock_open_rounded : Icons.lock_rounded,
                color: _nextDecisionsUnlocked ? AppColors.secondaryLight : AppColors.dangerLight,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.tr('Next Decisions', 'القرارات التالية'), style: Theme.of(context).textTheme.titleMedium),
                Text(
                  _nextDecisionsUnlocked
                      ? s.tr('Unlocked: teams can move to the next decisions', 'مفتوحة: يمكن للفرق الانتقال إلى القرارات التالية')
                      : s.tr('Locked: teams cannot move to the next decisions yet', 'مقفلة: لا يمكن للفرق الانتقال إلى القرارات التالية بعد'),
                  style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context)),
                ),
              ],
            )),
            ElevatedButton(
              onPressed: _loading ? null : () => _toggleNextDecisions(!_nextDecisionsUnlocked, s),
              style: ElevatedButton.styleFrom(
                backgroundColor: _nextDecisionsUnlocked ? AppColors.danger : AppColors.secondary,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(
                _nextDecisionsUnlocked ? s.tr('Lock', 'قفل') : s.tr('Unlock', 'فتح'),
                style: const TextStyle(fontSize: 12),
              ),
=======
                color: (_nextDecisionsUnlocked ? AppColors.secondary : AppColors.danger).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: (_nextDecisionsUnlocked ? AppColors.secondaryLight : AppColors.dangerLight).withValues(alpha: 0.5)),
              ),
              child: Text(
                _nextDecisionsUnlocked
                    ? s.tr('🔓 Teams CAN advance to next module', '🔓 يمكن للفرق الانتقال إلى الوحدة التالية')
                    : s.tr('🔒 Teams CANNOT advance (waiting for unlock)', '🔒 لا يمكن للفرق الانتقال (بانتظار الفتح)'),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _nextDecisionsUnlocked ? AppColors.secondaryLight : AppColors.dangerLight),
              ),
>>>>>>> Stashed changes
            ),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: ElevatedButton(
                onPressed: (_loading || _nextDecisionsUnlocked) ? null : () => _toggleNextDecisions(s, true),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
                child: Text(s.tr('🔓 Unlock', '🔓 فتح'), style: const TextStyle(fontSize: 12)),
              )),
              const SizedBox(width: 8),
              Expanded(child: ElevatedButton(
                onPressed: (_loading || !_nextDecisionsUnlocked) ? null : () => _toggleNextDecisions(s, false),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
                child: Text(s.tr('🔒 Lock', '🔒 قفل'), style: const TextStyle(fontSize: 12)),
              )),
            ]),
          ]),
        ),
        const SizedBox(height: 12),

        // Lock & Advance to Next Module
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.skip_next_rounded, color: AppColors.primaryLight, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.tr('Lock & Advance Module', 'قفل والتقدّم للوحدة'), style: Theme.of(context).textTheme.titleMedium),
                Text(s.tr('Lock current module & move all teams to the next', 'قفل الوحدة الحالية ونقل جميع الفرق للتالية'), style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context))),
              ],
            )),
            ElevatedButton(
              onPressed: _loading ? null : _lockAndAdvanceModule,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
              child: Text(s.tr('Advance', 'تقدّم'), style: const TextStyle(fontSize: 12)),
            ),
          ]),
        ),
        const SizedBox(height: 12),

        // End Timer
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.timer_off_rounded, color: AppColors.accentLight, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.tr('End Timer', 'إنهاء المؤقّت'), style: Theme.of(context).textTheme.titleMedium),
                Text(s.tr('Lock all scenarios immediately', 'قفل جميع السيناريوهات فورًا'), style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context))),
              ],
            )),
            ElevatedButton(
              onPressed: _loading ? null : _endTimer,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
              child: Text(s.tr('End', 'إنهاء'), style: const TextStyle(fontSize: 12)),
            ),
          ]),
        ),
        const SizedBox(height: 12),

        // ── Rules: Covenant thresholds ──
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const Icon(Icons.rule_rounded, color: AppColors.accentLight, size: 20),
                const SizedBox(width: 8),
                Text(s.tr('Covenant Thresholds', 'حدود التعهّدات'), style: Theme.of(context).textTheme.titleMedium),
              ]),
              const SizedBox(height: 4),
              Text(s.tr('Override the leverage and coverage limits for all teams.',
                  'تجاوز حدود الرافعة والتغطية لجميع الفرق.'),
                  style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context))),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: TextField(
                  controller: _maxLeverageC,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: s.tr('Max Leverage', 'أقصى رافعة'),
                    isDense: true, border: const OutlineInputBorder()),
                )),
                const SizedBox(width: 10),
                Expanded(child: TextField(
                  controller: _minCoverageC,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: s.tr('Min Coverage', 'أدنى تغطية'),
                    isDense: true, border: const OutlineInputBorder()),
                )),
              ]),
              const SizedBox(height: 12),
              SizedBox(width: double.infinity, child: ElevatedButton.icon(
                onPressed: _savingCovenant ? null : () => _saveCovenant(s),
                icon: _savingCovenant
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.save_rounded, size: 18),
                label: Text(s.tr('Save Thresholds', 'حفظ الحدود')),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
              )),
            ],
          ),
        ),
        const SizedBox(height: 12),

<<<<<<< Updated upstream
        // (The "Budget constraints" card was removed: the server has no
        // per-level budget route. Constraints on the website are case-study
        // driven: /facilitator/set-case-study and set-case-study-overrides.)
=======
        // ── Case-study template (GET /case-study/templates, POST /facilitator/set-case-study) ──
        CaseStudyPickerCard(repo: widget.repo, onChanged: _loadCaseStudyConstraints),
        const SizedBox(height: 12),

        // ── Rules: case-study constraints (POST /facilitator/set-case-study-overrides) ──
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const Icon(Icons.account_balance_wallet_rounded, color: AppColors.primaryLight, size: 20),
                const SizedBox(width: 8),
                Text(s.tr('Constraints', 'القيود'), style: Theme.of(context).textTheme.titleMedium),
              ]),
              const SizedBox(height: 4),
              Text(
                  _caseStudyActive
                      ? s.tr('Override the active case study\'s budget and selection limits per module. Leave a field empty to keep the case study\'s value.',
                          'تجاوز حدود الميزانية وعدد الاختيارات لدراسة الحالة النشطة لكل وحدة. اترك الحقل فارغًا للإبقاء على قيمة دراسة الحالة.')
                      : s.tr('No case study is active, so there are no constraints to override.',
                          'لا توجد دراسة حالة نشطة، لذا لا توجد قيود لتجاوزها.'),
                  style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context))),
              if (_caseStudyActive) ...[
                const SizedBox(height: 12),
                for (final m in _constraintModules)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(children: [
                      SizedBox(width: 78, child: Text(_moduleLabel(s, m),
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
                      Expanded(child: TextField(
                        controller: _maxBudgetC[m],
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: s.tr('Max budget', 'أقصى ميزانية'), isDense: true, border: const OutlineInputBorder()),
                      )),
                      const SizedBox(width: 8),
                      Expanded(child: TextField(
                        controller: _maxSelectionsC[m],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: s.tr('Max selections', 'أقصى عدد اختيارات'), isDense: true, border: const OutlineInputBorder()),
                      )),
                    ]),
                  ),
                SizedBox(width: double.infinity, child: ElevatedButton.icon(
                  onPressed: _savingConstraint ? null : () => _saveConstraint(s),
                  icon: _savingConstraint
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.save_rounded, size: 18),
                  label: Text(s.tr('Save Constraints', 'حفظ القيود')),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                )),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
>>>>>>> Stashed changes

        // Force server data-cache refresh (POST /cache/clear)
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.cloud_sync_rounded, color: AppColors.primaryLight, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.tr('Data Cache', 'ذاكرة البيانات المؤقتة'), style: Theme.of(context).textTheme.titleMedium),
                Text(s.tr('Clear the server data cache so dashboards load the latest data', 'مسح ذاكرة البيانات المؤقتة على الخادم لتعرض اللوحات أحدث البيانات'), style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context))),
              ],
            )),
            ElevatedButton(
              onPressed: _loading ? null : () => _clearServerCache(s),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
              child: Text(s.tr('Refresh', 'تحديث'), style: const TextStyle(fontSize: 12)),
            ),
          ]),
        ),
        const SizedBox(height: 12),

        // DBA study site toggle — suppresses the commercial assessments in this cohort.
        const _ResearchModeCard(),
        const SizedBox(height: 12),

        // Earnings Call — stage machine, analyst questions, ratings, rubric.
        const EarningsCallFacilitatorCard(),
      ],
    );
    });
  }

  /// The website's grid sends POST /facilitator/force-module {round, module} for every cell
  /// (financing included) after a confirm: one call, no round-completeness check. The gap
  /// check applies only to the Rounds tab's "Advance to Next Round" (force-round).
  Future<void> _forcePosition(int round, String module) async {
    final s = ProviderScope.containerOf(context).read(stringsProvider);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(s.tr('Move all teams to Round $round ${_moduleLabel(s, module)}?',
            'نقل جميع الفرق إلى ${_moduleLabel(s, module)} الجولة $round؟')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(s.tr('Cancel', 'إلغاء'))),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: Text(s.tr('Move', 'نقل'))),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    setState(() => _loading = true);
    try {
      await widget.repo.forceModule(module, round: round);
      widget.onRefreshState();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(s.tr('All teams moved to Round $round ${_moduleLabel(s, module)}',
                'تم نقل جميع الفرق إلى ${_moduleLabel(s, module)} الجولة $round')),
            backgroundColor: AppColors.secondary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      if (mounted) _showActionError(context, s, e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  /// POST /facilitator/force-module {round, module: 'dashboard'}: every team parked on the
  /// round's results screen with that round's decisions locked (website 5fcc4ee).
  Future<void> _sendTeamsToResults(AppStrings s, int round) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(s.tr('Teams to Round $round results', 'الفرق إلى نتائج الجولة $round')),
        content: Text(s.tr(
            'Send ALL teams to the Round $round results dashboard? Their Round $round decisions will be locked.',
            'إرسال جميع الفرق إلى لوحة نتائج الجولة $round؟ سيتم قفل قرارات الجولة $round الخاصة بهم.')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(s.tr('Cancel', 'إلغاء'))),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.purple),
            child: Text(s.tr('Send', 'إرسال')),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    setState(() => _loading = true);
    try {
      await widget.repo.forceModule('dashboard', round: round);
      widget.onRefreshState();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(s.tr('All teams sent to the Round $round results dashboard',
              'تم إرسال جميع الفرق إلى لوحة نتائج الجولة $round')),
          backgroundColor: AppColors.secondary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ));
      }
    } catch (e) {
      if (mounted) _showActionError(context, s, e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _lockAndAdvanceModule() async {
    setState(() => _loading = true);
    try {
      final res = await widget.repo.lockAndAdvanceModule();
      widget.onRefreshState();
      if (mounted) {
        final ok = res['success'] == true;
        final msg = (res['message'] as String?) ??
            (ok ? 'Advanced to next module' : 'Could not advance');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: ok ? AppColors.primary : AppColors.danger),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.danger));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

<<<<<<< Updated upstream
  /// Unlock or lock "Move to Next Decisions" for every team. The state shown
  /// afterwards is the one the server confirmed; a failed call (401 from a
  /// stale password, 400, dead route) is reported and nothing changes.
  Future<void> _toggleNextDecisions(bool unlock, AppStrings s) async {
    setState(() => _loading = true);
    try {
      final res = await widget.repo.toggleNextDecisions(unlock);
      if (res['success'] != true) {
        throw Exception(res['message'] ?? res['error'] ?? 'Next decisions were not changed');
      }
      final confirmed = res['nextDecisionsUnlocked'] as bool? ?? unlock;
      if (mounted) setState(() => _nextDecisionsUnlocked = confirmed);
      widget.onRefreshState();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(confirmed
                ? s.tr('Next decisions unlocked: teams can move on', 'تم فتح القرارات التالية: يمكن للفرق الانتقال')
                : s.tr('Next decisions locked', 'تم قفل القرارات التالية')),
            backgroundColor: confirmed ? AppColors.secondary : AppColors.accent,
          ),
        );
      }
=======
  Future<void> _toggleNextDecisions(AppStrings s, bool unlock) async {
    setState(() => _loading = true);
    try {
      final now = await widget.repo.toggleNextDecisions(unlock);
      widget.onRefreshState();
      if (!mounted) return;
      setState(() => _nextDecisionsUnlocked = now);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(now
            ? s.tr('Next decisions unlocked: teams can now move to the next module',
                'تم فتح القرارات التالية: يمكن للفرق الآن الانتقال إلى الوحدة التالية')
            : s.tr('Next decisions locked: teams can no longer move to the next module',
                'تم قفل القرارات التالية: لم يعد بإمكان الفرق الانتقال إلى الوحدة التالية')),
        backgroundColor: now ? AppColors.secondary : AppColors.accent,
      ));
>>>>>>> Stashed changes
    } catch (e) {
      if (mounted) _showActionError(context, s, e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _endTimer() async {
    setState(() => _loading = true);
    try {
      await widget.repo.setTimer(0, action: 'reset');
      widget.onRefreshState();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Timer ended, scenarios locked'), backgroundColor: AppColors.accent),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.danger));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _clearServerCache(AppStrings s) async {
    setState(() => _loading = true);
    try {
      await widget.repo.clearServerCache();
      widget.onRefreshState();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(s.tr('Data cache cleared - dashboards will load the latest data',
                'تم مسح ذاكرة البيانات المؤقتة - ستعرض اللوحات أحدث البيانات')),
            backgroundColor: AppColors.secondary,
          ),
        );
      }
    } catch (e) {
      if (mounted) _showActionError(context, s, e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}

class _GameControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onPressed;
  const _GameControlButton({required this.icon, required this.label, required this.color, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ---- Leaderboard Tab (live, in-panel) ----
class _LeaderboardTab extends StatefulWidget {
  final FacilitatorRepository repo;
  const _LeaderboardTab({required this.repo});

  @override
  State<_LeaderboardTab> createState() => _LeaderboardTabState();
}

class _LeaderboardTabState extends State<_LeaderboardTab> {
  Timer? _timer;
  List<Map<String, dynamic>> _rows = [];
  bool _loading = true;
  String? _error;
  DateTime? _lastUpdated;

  @override
  void initState() {
    super.initState();
    _load();
    _timer = Timer.periodic(const Duration(seconds: 15), (_) => _load());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Defensive accessors — the API list items are Maps with varying key names.
  String _name(Map m) =>
      (m['teamName'] ?? m['team'] ?? m['name'] ?? m['teamId'] ?? '—').toString();

  double _num(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0;
  }

  double _score(Map m) => _num(m['score']);
  double _netIncome(Map m) => _num(m['netIncome'] ?? m['net_income']);

  Future<void> _load() async {
    try {
      final raw = await widget.repo.getLeaderboard();
      final rows = raw
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
      rows.sort((a, b) => _score(b).compareTo(_score(a)));
      if (mounted) {
        setState(() {
          _rows = rows;
          _loading = false;
          _error = null;
          _lastUpdated = DateTime.now();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = e.toString();
        });
      }
    }
  }

  String _fmt(double v) {
    if (v.abs() > 999999) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v.abs() > 999) return '${(v / 1000).toStringAsFixed(1)}K';
    return v.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final s = ref.watch(stringsProvider);
      if (_loading) return const Center(child: CircularProgressIndicator());
      if (_error != null && _rows.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline_rounded, size: 48, color: AppColors.textTertiary(context)),
              const SizedBox(height: 12),
              Text(s.tr('Could not load leaderboard', 'تعذّر تحميل لوحة المتصدّرين'),
                  style: TextStyle(color: AppColors.textTertiary(context))),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: _load,
                icon: const Icon(Icons.refresh),
                label: Text(s.tr('Retry', 'إعادة المحاولة')),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(children: [
              Text(s.tr('Live Leaderboard', 'لوحة المتصدّرين المباشرة'),
                  style: Theme.of(context).textTheme.titleLarge),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.refresh_rounded, color: AppColors.primaryLight),
                tooltip: s.tr('Refresh', 'تحديث'),
                onPressed: _load,
              ),
            ]),
            Text(
              _lastUpdated == null
                  ? s.tr('Auto-refreshes every 15s', 'يتم التحديث تلقائيًا كل 15 ثانية')
                  : '${s.tr('Updated', 'تم التحديث')} ${_lastUpdated!.hour.toString().padLeft(2, '0')}:${_lastUpdated!.minute.toString().padLeft(2, '0')}:${_lastUpdated!.second.toString().padLeft(2, '0')} · ${s.tr('auto every 15s', 'تلقائيًا كل 15 ثانية')}',
              style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context)),
            ),
            const SizedBox(height: 12),
            if (_rows.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(s.tr('No teams ranked yet', 'لا توجد فرق مصنّفة بعد'),
                      style: TextStyle(color: AppColors.textTertiary(context))),
                ),
              )
            else
              ..._rows.asMap().entries.map((entry) {
                final rank = entry.key + 1;
                final m = entry.value;
                final color = AppColors.teamColor(entry.key);
                final medal = rank == 1
                    ? AppColors.accentLight
                    : rank == 2
                        ? AppColors.textSecondary(context)
                        : rank == 3
                            ? const Color(0xFFCD7F32)
                            : color;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GlassCard(
                    borderColor: rank <= 3 ? medal.withValues(alpha: 0.4) : null,
                    padding: const EdgeInsets.all(14),
                    child: Row(children: [
                      Container(
                        width: 34, height: 34,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: medal.withValues(alpha: 0.18),
                        ),
                        child: Center(
                          child: Text('$rank',
                              style: TextStyle(fontWeight: FontWeight.w800, color: medal)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_name(m), style: Theme.of(context).textTheme.titleMedium),
                            Text(
                              '${s.tr('Net Income', 'صافي الدخل')}: ${_fmt(_netIncome(m))}',
                              style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context)),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(_fmt(_score(m)),
                              style: GoogleFonts.jetBrainsMono(
                                  fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.accentLight)),
                          Text(s.tr('score', 'النقاط'),
                              style: TextStyle(fontSize: 10, color: AppColors.textTertiary(context))),
                        ],
                      ),
                    ]),
                  ),
                ).animate().fadeIn(delay: (50 * entry.key).ms);
              }),
          ],
        ),
      );
    });
  }
}

<<<<<<< Updated upstream
// ---- Excel Worksheet Viewer Tab ----
class _ExcelViewerTab extends StatefulWidget {
  final FacilitatorRepository repo;
  const _ExcelViewerTab({required this.repo});

  @override
  State<_ExcelViewerTab> createState() => _ExcelViewerTabState();
}

class _ExcelViewerTabState extends State<_ExcelViewerTab> {
  Map<String, dynamic> _data = {};
  bool _loading = true;
  String? _error;

  // Keys of the baseline statements payload (GameRepository.fetchBaselineStatements)
  // in display order, with the sheet title shown for each.
  static const _sheetKeys = ['incomeStatement', 'balanceSheet', 'cashFlow', 'ratios'];
  static const _sheetTitles = {
    'incomeStatement': 'Income Statement',
    'balanceSheet': 'Balance Sheet',
    'cashFlow': 'Cash Flow',
    'ratios': 'Ratios',
  };

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final data = await widget.repo.fetchExcelData();
      if (mounted) setState(() { _data = data; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _loading = false; _error = e.toString(); });
    }
  }

  // Count rows for a sheet value that may be a List or a Map.
  int _rowCount(dynamic sheet) {
    if (sheet is List) return sheet.length;
    if (sheet is Map) return sheet.length;
    return 0;
  }

  // Flatten a sheet into label:value pairs defensively.
  List<MapEntry<String, String>> _pairs(dynamic sheet) {
    final out = <MapEntry<String, String>>[];
    if (sheet is Map) {
      sheet.forEach((k, v) {
        out.add(MapEntry(k.toString(), v is Map || v is List ? '…' : '$v'));
      });
    } else if (sheet is List) {
      for (var i = 0; i < sheet.length; i++) {
        final row = sheet[i];
        if (row is Map) {
          // Statement rows are { title, value, isHeader, ... }; a header row
          // (a section label such as "ASSETS:") carries no amount.
          final label = (row['title'] ?? row['label'] ?? row['name'] ?? row['key'] ?? 'Row ${i + 1}')
              .toString();
          final value = row['isHeader'] == true
              ? ''
              : (row['value'] ?? row['amount'] ?? '').toString();
          out.add(MapEntry(label, value));
        } else {
          out.add(MapEntry('Row ${i + 1}', '$row'));
        }
      }
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final s = ref.watch(stringsProvider);
      if (_loading) return const Center(child: CircularProgressIndicator());
      if (_error != null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_off_rounded, size: 48, color: AppColors.textTertiary(context)),
              const SizedBox(height: 12),
              Text(s.tr('Could not load Excel data', 'تعذّر تحميل بيانات Excel'),
                  style: TextStyle(color: AppColors.textTertiary(context))),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: _load,
                icon: const Icon(Icons.refresh),
                label: Text(s.tr('Retry', 'إعادة المحاولة')),
              ),
            ],
          ),
        );
      }

      // Prefer the well-known sheet keys, then any extra keys present.
      final keys = <String>[
        ..._sheetKeys.where((k) => _data.containsKey(k)),
        ..._data.keys.where((k) => !_sheetKeys.contains(k)),
      ];

      return RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(children: [
              Text(s.tr('Excel Worksheets', 'أوراق عمل Excel'),
                  style: Theme.of(context).textTheme.titleLarge),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.refresh_rounded, color: AppColors.primaryLight),
                onPressed: _load,
              ),
            ]),
            const SizedBox(height: 4),
            Text(s.tr('Read-only view of the server workbook', 'عرض للقراءة فقط لمصنّف الخادم'),
                style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context))),
            const SizedBox(height: 12),
            if (keys.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(s.tr('No worksheet data available', 'لا توجد بيانات أوراق عمل متاحة'),
                      style: TextStyle(color: AppColors.textTertiary(context))),
                ),
              )
            else
              ...keys.map((k) {
                final sheet = _data[k];
                final pairs = _pairs(sheet);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _ExcelSheetCard(
                    title: _sheetTitles[k] ?? k,
                    rowCount: _rowCount(sheet),
                    pairs: pairs,
                  ),
                );
              }),
          ],
        ),
      );
    });
  }
}

class _ExcelSheetCard extends StatefulWidget {
  final String title;
  final int rowCount;
  final List<MapEntry<String, String>> pairs;
  const _ExcelSheetCard({required this.title, required this.rowCount, required this.pairs});

  @override
  State<_ExcelSheetCard> createState() => _ExcelSheetCardState();
}

class _ExcelSheetCardState extends State<_ExcelSheetCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                const Icon(Icons.table_chart_rounded, color: AppColors.primaryLight, size: 20),
                const SizedBox(width: 10),
                Expanded(child: Text(widget.title, style: Theme.of(context).textTheme.titleMedium)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('${widget.rowCount} rows',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryLight)),
                ),
                const SizedBox(width: 8),
                Icon(_expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                    color: AppColors.textTertiary(context)),
              ]),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  const Divider(),
                  if (widget.pairs.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text('No rows', style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context), fontStyle: FontStyle.italic)),
                    )
                  else
                    ...widget.pairs.take(60).map((p) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(children: [
                        Expanded(flex: 3, child: Text(p.key, style: TextStyle(fontSize: 12, color: AppColors.textSecondary(context)))),
                        Expanded(flex: 2, child: Text(p.value, textAlign: TextAlign.right,
                            style: GoogleFonts.jetBrainsMono(fontSize: 12, fontWeight: FontWeight.w600))),
                      ]),
                    )),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

=======
>>>>>>> Stashed changes
// ---- Teams Tab ----
class _TeamsTab extends StatelessWidget {
  final List teams;
  const _TeamsTab({required this.teams});

  @override
  Widget build(BuildContext context) {
    if (teams.isEmpty) return const Center(child: CircularProgressIndicator());
    return Consumer(builder: (context, ref, _) {
      final s = ref.watch(stringsProvider);
      return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: teams.length,
      itemBuilder: (context, index) {
        final team = teams[index];
        final color = AppColors.teamColor(index);
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GlassCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withValues(alpha: 0.2),
                  child: Text('T${index + 1}', style: TextStyle(color: color, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(team.name, style: Theme.of(context).textTheme.titleMedium),
                    Text('${s.tr('Round', 'الجولة')} ${team.currentRound} • ${team.currentModule}', style: Theme.of(context).textTheme.bodySmall),
                  ],
                )),
                Text('${team.totalScore.toStringAsFixed(0)} ${s.tr('pts', 'نقطة')}',
                  style: GoogleFonts.jetBrainsMono(fontSize: 13, color: AppColors.accentLight)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (team.isActive ? AppColors.secondary : AppColors.cardColor(context)).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(team.isActive ? s.tr('Active', 'نشط') : s.tr('Inactive', 'غير نشط'),
                    style: TextStyle(fontSize: 11, color: team.isActive ? AppColors.secondaryLight : AppColors.textTertiary(context))),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.dashboard_rounded, size: 20, color: AppColors.primaryLight),
                  tooltip: s.tr('View dashboard', 'عرض لوحة المعلومات'),
                  onPressed: () => context.go('/dashboard'),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: (80 * index).ms);
      },
    );
    });
  }
}

// ---- Team Sign-In Tab ----
class _TeamSignInTab extends StatefulWidget {
  final FacilitatorRepository repo;
  const _TeamSignInTab({required this.repo});

  @override
  State<_TeamSignInTab> createState() => _TeamSignInTabState();
}

class _TeamSignInTabState extends State<_TeamSignInTab> {
  Timer? _refreshTimer;
  // teams[] from GET /facilitator/team-overview.
  List<Map<String, dynamic>> _teams = [];
  bool _isLoading = true;
  String? _error;
  // teamId ("Team N") -> current leader name.
  final Map<String, String?> _leaders = {};

  @override
  void initState() {
    super.initState();
    _fetchSignins();
    _fetchLeaders();
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (_) => _fetchSignins());
  }

  Future<void> _fetchLeaders() async {
    final results = await Future.wait([
      // Leaders are keyed by the real team id ("Team 1"...), as the website stores them.
      for (var i = 1; i <= AppConstants.maxTeams; i++) widget.repo.fetchTeamLeader('Team $i'),
    ]);
    if (!mounted) return;
    setState(() {
      for (var i = 0; i < results.length; i++) {
        _leaders['Team ${i + 1}'] = results[i];
      }
    });
  }

  Future<void> _makeLeader(String teamId, String name) async {
    setState(() => _leaders[teamId] = name);
    try {
      await widget.repo.setTeamLeader(teamId, name);
    } catch (_) {/* keep optimistic */}
  }

  Future<void> _removeLeader(String teamId) async {
    setState(() => _leaders[teamId] = null);
    try {
      await widget.repo.removeTeamLeader(teamId);
    } catch (_) {}
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchSignins() async {
    try {
      final teams = await widget.repo.getTeamOverviewTeams();
      if (mounted) {
        setState(() {
          _teams = teams;
          _isLoading = false;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = e.toString();
        });
      }
    }
  }

  Future<void> _removePlayer(String playerName, String teamId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => Consumer(builder: (ctx, ref, _) {
        final s = ref.watch(stringsProvider);
        return AlertDialog(
        title: Text(s.tr('Remove Player', 'إزالة لاعب')),
        content: Text(s.tr('Remove $playerName from $teamId?', 'إزالة $playerName من $teamId؟')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(s.tr('Cancel', 'إلغاء'))),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            child: Text(s.tr('Remove', 'إزالة')),
          ),
        ],
      );
      }),
    );
    if (confirmed != true) return;
    try {
      await widget.repo.removePlayer(playerName, teamId);
      _fetchSignins();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.danger),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final s = ref.watch(stringsProvider);
      return _buildContent(context, s);
    });
  }

  Widget _buildContent(BuildContext context, AppStrings s) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded, size: 48, color: AppColors.textTertiary(context)),
          const SizedBox(height: 12),
          Text(s.tr('Could not load sign-in data', 'تعذّر تحميل بيانات تسجيل الدخول'), style: TextStyle(color: AppColors.textTertiary(context))),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: _fetchSignins,
            icon: const Icon(Icons.refresh),
            label: Text(s.tr('Retry', 'إعادة المحاولة')),
          ),
        ],
      ));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: AppConstants.maxTeams,
      itemBuilder: (context, index) {
        final teamKey = 'Team ${index + 1}';
        final color = AppColors.teamColor(index);
        // team-overview: teams[].connectedMembers[].playerName (Postgres sign-ins).
        final teamInfo = _overviewTeam(_teams, index + 1);
        final players = teamInfo?['connectedMembers'] as List<dynamic>? ?? [];

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GlassCard(
            borderColor: color.withValues(alpha: 0.3),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: color.withValues(alpha: 0.2),
                    child: Text('T${index + 1}', style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 13)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(
                    teamKey,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: color),
                  )),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      s.tr('${players.length} player${players.length == 1 ? '' : 's'}', '${players.length} لاعب'),
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
                    ),
                  ),
                ]),
                if (teamInfo?['currentRound'] != null || teamInfo?['currentModule'] != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    '${s.tr('Round', 'الجولة')} ${teamInfo?['currentRound'] ?? '?'} - ${teamInfo?['currentModule'] ?? '?'}',
                    style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context)),
                  ),
                ],
                if (players.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  // Current team leader + remove (tap a member below to set).
                  Builder(builder: (context) {
                    final teamId = teamKey;
                    final leader = _leaders[teamId];
                    if (leader == null) {
                      return Text('No leader — tap a member to make leader',
                          style: TextStyle(fontSize: 11, color: AppColors.textTertiary(context), fontStyle: FontStyle.italic));
                    }
                    return Row(children: [
                      const Icon(Icons.workspace_premium_rounded, size: 14, color: AppColors.accentLight),
                      const SizedBox(width: 4),
                      Text('Leader: $leader',
                          style: const TextStyle(fontSize: 11, color: AppColors.accentLight, fontWeight: FontWeight.w700)),
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: () => _removeLeader(teamId),
                        child: Text('remove', style: TextStyle(fontSize: 11, color: AppColors.dangerLight)),
                      ),
                    ]);
                  }),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: players.map<Widget>((p) {
<<<<<<< Updated upstream
                      final name = p is String
                          ? p
                          : ((p as Map)['playerName'] ?? p['name'])?.toString() ?? 'Unknown';
                      final teamId = '${index + 1}';
=======
                      final name = p is String ? p : (p as Map<String, dynamic>)['name']?.toString() ?? 'Unknown';
                      final teamId = teamKey;
>>>>>>> Stashed changes
                      final isLeader = _leaders[teamId] == name;
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: isLeader ? 0.2 : 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: color.withValues(alpha: isLeader ? 0.5 : 0.2)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Tap the crown to make this member the team leader.
                            InkWell(
                              onTap: () => _makeLeader(teamId, name),
                              child: Icon(
                                isLeader ? Icons.workspace_premium_rounded : Icons.person_rounded,
                                size: 14,
                                color: isLeader ? AppColors.accentLight : color,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(name, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500)),
                            const SizedBox(width: 4),
                            InkWell(
                              onTap: () => _removePlayer(name, teamKey),
                              child: Icon(Icons.close_rounded, size: 14, color: color.withValues(alpha: 0.6)),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ] else ...[
                  const SizedBox(height: 8),
                  Text(
                    'No players signed in',
                    style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context), fontStyle: FontStyle.italic),
                  ),
                ],
              ],
            ),
          ),
        ).animate().fadeIn(delay: (80 * index).ms);
      },
    );
  }
}

/// The team-overview entry for team number [n] ("Team 3" / "team-3" / 3), or
/// null when the server lists no such team.
Map<String, dynamic>? _overviewTeam(List<Map<String, dynamic>> teams, int n) {
  for (final t in teams) {
    if (_overviewTeamNumber(t) == n) return t;
  }
  return null;
}

int? _overviewTeamNumber(Map<String, dynamic> t) {
  for (final key in ['teamId', 'teamName']) {
    final digits = RegExp(r'\d+').firstMatch(t[key]?.toString() ?? '');
    if (digits != null) return int.tryParse(digits.group(0)!);
  }
  return null;
}

// ---- Shocks Tab ----
class _ShocksTab extends StatefulWidget {
  final List<Shock> shocks;
  final Future<void> Function(String shockId, int round) onTrigger;
  final FacilitatorRepository repo;
  final int currentRound;
  final String? currentModule;
  const _ShocksTab({
    required this.shocks,
    required this.onTrigger,
    required this.repo,
    required this.currentRound,
    this.currentModule,
  });

  @override
  State<_ShocksTab> createState() => _ShocksTabState();
}

class _ShocksTabState extends State<_ShocksTab> {
  final _nameC = TextEditingController();
  final _descC = TextEditingController();
  final _responseC = TextEditingController();
  String _category = 'economic';
  String _severity = 'medium';
  bool _sending = false;
  // Which game year the shock is stamped with. Defaults to the current round; a shock
  // stamped with an earlier round rewrites results teams have already seen.
  late int _round = widget.currentRound.clamp(1, 3);
  bool _roundPicked = false;

  List<Map<String, dynamic>> _active = [];
  List<Map<String, dynamic>> _history = [];

  // The server's ShockCategory values.
  static const _categories = [
    'economic', 'market', 'regulatory', 'operational',
    'financial', 'competitive', 'environmental', 'political',
  ];
  static const _severities = ['low', 'medium', 'high', 'critical'];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  void didUpdateWidget(covariant _ShocksTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Follow the game's round until the facilitator picks one deliberately.
    if (!_roundPicked && oldWidget.currentRound != widget.currentRound) {
      _round = widget.currentRound.clamp(1, 3);
    }
  }

  @override
  void dispose() {
    _nameC.dispose();
    _descC.dispose();
    _responseC.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    try {
      final results = await Future.wait([
        widget.repo.fetchActiveShocks(),
        widget.repo.fetchShockHistory(),
      ]);
      if (mounted) setState(() { _active = results[0]; _history = results[1]; });
    } catch (_) {/* offline */}
  }

  /// Active/history rows are ActiveShock objects: the name lives under `definition`.
  String _shockName(Map<String, dynamic> s) {
    final def = s['definition'];
    return ((def is Map ? def['name'] : null) ?? s['name'] ?? s['shockId'] ?? 'Shock').toString();
  }

  String? _shockDescription(Map<String, dynamic> s) {
    final def = s['definition'];
    return ((def is Map ? def['description'] : null) ?? s['description'])?.toString();
  }

  String _shockSeverity(Map<String, dynamic> s) {
    final def = s['definition'];
    return ((def is Map ? def['severity'] : null) ?? s['severity'] ?? 'medium').toString();
  }

  void _snack(String msg, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: error ? AppColors.danger : null,
    ));
  }

  Future<void> _triggerCustom(AppStrings s) async {
    if (_nameC.text.trim().isEmpty || _descC.text.trim().isEmpty) {
      _snack(s.tr('Name and description are required', 'الاسم والوصف مطلوبان'));
      return;
    }
    setState(() => _sending = true);
    try {
      final res = await widget.repo.triggerCustomShock(
        name: _nameC.text.trim(),
        description: _descC.text.trim(),
        category: _category,
        severity: _severity,
        round: _round,
        module: widget.currentModule,
        suggestedResponse: _responseC.text.trim().isEmpty ? null : _responseC.text.trim(),
      );
      _nameC.clear(); _descC.clear(); _responseC.clear();
      _snack(res['message']?.toString() ?? s.tr('Custom shock triggered!', 'تم تفعيل الصدمة المخصّصة!'));
      await _refresh();
    } catch (e) {
      _snack(
        e is FacilitatorActionException
            ? e.message
            : s.tr('Could not trigger custom shock', 'تعذّر تفعيل الصدمة المخصّصة'),
        error: true,
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _clearAll(AppStrings s) async {
    final ok = await widget.repo.clearAllShocks();
    _snack(ok
        ? s.tr('All shocks cleared', 'تم مسح جميع الصدمات')
        : s.tr('Could not clear shocks', 'تعذّر مسح الصدمات'), error: !ok);
    await _refresh();
  }

  Future<void> _dismissOne(AppStrings s, Map<String, dynamic> shock) async {
    final id = (shock['id'] ?? shock['instanceId'] ?? shock['shockInstanceId'])?.toString();
    if (id == null || id.isEmpty) return;
    final ok = await widget.repo.dismissShock(id);
    _snack(ok
        ? s.tr('Shock dismissed', 'تم إلغاء الصدمة')
        : s.tr('Could not dismiss shock', 'تعذّر إلغاء الصدمة'), error: !ok);
    await _refresh();
  }

  Color _sevColor(String s) => switch (s.toLowerCase()) {
        'low' => AppColors.info,
        'high' => AppColors.dangerLight,
        'critical' => const Color(0xFF7C3AED),
        _ => AppColors.accentLight,
      };

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final s = ref.watch(stringsProvider);
      return RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── Round the shock is stamped with ──
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.event_note_rounded, size: 18, color: AppColors.primaryLight),
                    const SizedBox(width: 8),
                    Expanded(child: Text(s.tr('Shock round', 'جولة الصدمة'),
                        style: Theme.of(context).textTheme.titleMedium)),
                    SegmentedButton<int>(
                      segments: [
                        for (final r in [1, 2, 3])
                          ButtonSegment(value: r, label: Text(s.tr('R$r', 'ج$r'))),
                      ],
                      selected: {_round},
                      onSelectionChanged: (sel) => setState(() { _round = sel.first; _roundPicked = true; }),
                      showSelectedIcon: false,
                    ),
                  ]),
                  if (_round < widget.currentRound) ...[
                    const SizedBox(height: 8),
                    Text(
                      s.tr(
                        'Round $_round is behind the game\'s current round (${widget.currentRound}). A shock stamped with an earlier year rewrites results teams have already seen, and its effect compounds into later years.',
                        'الجولة $_round تسبق الجولة الحالية للعبة (${widget.currentRound}). الصدمة المسجّلة على سنة سابقة تعيد كتابة نتائج اطّلعت عليها الفرق، ويتراكم أثرها على السنوات اللاحقة.',
                      ),
                      style: const TextStyle(fontSize: 12, color: AppColors.accentLight),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Custom shock builder ──
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.add_circle_outline_rounded, size: 18, color: AppColors.primaryLight),
                    const SizedBox(width: 8),
                    Text(s.tr('Create Custom Shock', 'إنشاء صدمة مخصّصة'), style: Theme.of(context).textTheme.titleMedium),
                  ]),
                  const SizedBox(height: 12),
                  TextField(controller: _nameC, decoration: InputDecoration(
                      labelText: s.tr('Name', 'الاسم'), isDense: true, border: const OutlineInputBorder())),
                  const SizedBox(height: 10),
                  TextField(controller: _descC, maxLines: 2, decoration: InputDecoration(
                      labelText: s.tr('Describe the market event…', 'صف حدث السوق…'), isDense: true, border: const OutlineInputBorder())),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(child: DropdownButtonFormField<String>(
                      initialValue: _category,
                      isDense: true,
                      isExpanded: true,
                      decoration: InputDecoration(labelText: s.tr('Category', 'الفئة'), isDense: true, border: const OutlineInputBorder()),
                      items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (v) => setState(() => _category = v ?? _category),
                    )),
                    const SizedBox(width: 10),
                    Expanded(child: DropdownButtonFormField<String>(
                      initialValue: _severity,
                      isDense: true,
                      isExpanded: true,
                      decoration: InputDecoration(labelText: s.tr('Severity', 'الشدّة'), isDense: true, border: const OutlineInputBorder()),
                      items: _severities.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                      onChanged: (v) => setState(() => _severity = v ?? _severity),
                    )),
                  ]),
                  const SizedBox(height: 10),
                  TextField(controller: _responseC, decoration: InputDecoration(
                      labelText: s.tr('Suggested response (optional)', 'الاستجابة المقترحة (اختياري)'),
                      isDense: true, border: const OutlineInputBorder())),
                  const SizedBox(height: 12),
                  SizedBox(width: double.infinity, child: ElevatedButton.icon(
                    onPressed: _sending ? null : () => _triggerCustom(s),
                    icon: _sending
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.bolt_rounded, size: 18),
                    label: Text(s.tr('Trigger Custom Shock (Round $_round)', 'تفعيل الصدمة المخصّصة (الجولة $_round)')),
                  )),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Active shocks ──
            Row(children: [
              Text(s.tr('Active Shocks', 'الصدمات النشطة'), style: Theme.of(context).textTheme.titleMedium),
              const Spacer(),
              if (_active.isNotEmpty)
                TextButton.icon(
                  onPressed: () => _clearAll(s),
                  icon: const Icon(Icons.clear_all_rounded, size: 16),
                  label: Text(s.tr('Clear all', 'مسح الكل')),
                  style: TextButton.styleFrom(foregroundColor: AppColors.dangerLight),
                ),
            ]),
            const SizedBox(height: 8),
            if (_active.isEmpty)
              Text(s.tr('No active shocks', 'لا توجد صدمات نشطة'), style: TextStyle(color: AppColors.textTertiary(context)))
            else
              ..._active.map((a) => _activeCard(s, a)),

            const SizedBox(height: 20),

            // ── Market forecasts + shock insurance ──
            MarketForecastsCard(repo: widget.repo, currentRound: widget.currentRound),
            const SizedBox(height: 20),

            // ── Predefined shocks ──
            Text(s.tr('Predefined Shocks', 'الصدمات المعدّة مسبقًا'), style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (widget.shocks.isEmpty)
              Text(s.tr('Loading shocks…', 'جارٍ تحميل الصدمات…'), style: TextStyle(color: AppColors.textTertiary(context)))
            else
              ...widget.shocks.map((sh) => _predefinedCard(s, sh)),

            // ── History ──
            if (_history.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(s.tr('Shock History', 'سجل الصدمات'), style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              ..._history.take(20).map((h) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(children: [
                  const Icon(Icons.history_rounded, size: 14),
                  const SizedBox(width: 8),
                  Expanded(child: Text(
                      '${_shockName(h)}${h['round'] != null ? ' · ${s.tr('Round', 'الجولة')} ${h['round']}' : ''}',
                      style: Theme.of(context).textTheme.bodySmall)),
                ]),
              )),
            ],
          ],
        ),
      );
    });
  }

  Widget _activeCard(AppStrings s, Map<String, dynamic> shock) {
    final sev = _shockSeverity(shock);
    final c = _sevColor(sev);
    final desc = _shockDescription(shock);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassCard(
        padding: const EdgeInsets.all(14),
        child: Row(children: [
          Icon(Icons.flash_on_rounded, color: c, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(_shockName(shock), style: Theme.of(context).textTheme.titleSmall),
            if (shock['round'] != null)
              Text('${s.tr('Round', 'الجولة')} ${shock['round']} · ${shock['target'] == 'all' || shock['target'] == null ? s.tr('All teams', 'جميع الفرق') : shock['target']}',
                  style: TextStyle(fontSize: 11, color: AppColors.textTertiary(context))),
            if (desc != null)
              Text(desc,
                  maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall),
          ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: c.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
            child: Text(sev.toUpperCase(), style: TextStyle(fontSize: 10, color: c, fontWeight: FontWeight.w600)),
          ),
          // Dismiss this single shock (reverts its model impact)
          IconButton(
            onPressed: () => _dismissOne(s, shock),
            icon: const Icon(Icons.close_rounded, size: 18),
            color: AppColors.dangerLight,
            tooltip: s.tr('Dismiss', 'إلغاء'),
            visualDensity: VisualDensity.compact,
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.only(left: 8),
          ),
        ]),
      ),
    );
  }

  Widget _predefinedCard(AppStrings s, Shock shock) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: shock.severityColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.flash_on_rounded, color: shock.severityColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(shock.name, style: Theme.of(context).textTheme.titleMedium),
                Row(children: [
                  Text(shock.category, style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: shock.severityColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(shock.severity.toUpperCase(),
                      style: TextStyle(fontSize: 10, color: shock.severityColor, fontWeight: FontWeight.w600)),
                  ),
                ]),
              ],
            )),
            ElevatedButton(
              onPressed: () async { await widget.onTrigger(shock.id, _round); await _refresh(); },
              style: ElevatedButton.styleFrom(
                backgroundColor: shock.severityColor,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                minimumSize: Size.zero,
              ),
              child: Text(s.tr('Trigger', 'تفعيل'), style: const TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}

// ---- Timer Tab ----
class _TimerTab extends StatefulWidget {
  final FacilitatorRepository repo;
  const _TimerTab({required this.repo});
  @override
  State<_TimerTab> createState() => _TimerTabState();
}

class _TimerTabState extends State<_TimerTab> {
  int _minutes = 15;

  // Per-activity timer presets (website 2e7c9a3): how long each activity type gets;
  // a row's play button starts the session timer with that duration.
  static const _activities = <(String, String, String)>[
    ('financing', 'Financing decisions', 'قرارات التمويل'),
    ('investing', 'Investing decisions', 'قرارات الاستثمار'),
    ('operating', 'Operating decisions', 'قرارات التشغيل'),
    ('shock', 'Market shock response', 'الاستجابة لصدمة السوق'),
    ('education', 'Education module block', 'فترة الوحدات التعليمية'),
    ('debrief', 'Debrief / discussion', 'المراجعة / النقاش'),
  ];
  final Map<String, TextEditingController> _presetC = {
    for (final a in _activities) a.$1: TextEditingController(),
  };
  bool _presetsLoaded = false;
  bool _savingPresets = false;

  @override
  void initState() {
    super.initState();
    _loadPresets();
  }

  @override
  void dispose() {
    for (final c in _presetC.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _loadPresets() async {
    try {
      final presets = await widget.repo.fetchTimerPresets();
      for (final e in presets.entries) {
        _presetC[e.key]?.text = '${e.value}';
      }
    } catch (_) {/* offline: fields stay empty */}
    if (mounted) setState(() => _presetsLoaded = true);
  }

  int? _presetMinutes(String key) {
    final n = int.tryParse(_presetC[key]?.text.trim() ?? '');
    return (n != null && n >= 1 && n <= 120) ? n : null;
  }

  Future<void> _savePresets(AppStrings s) async {
    final presets = <String, int>{
      for (final a in _activities)
        if (_presetMinutes(a.$1) != null) a.$1: _presetMinutes(a.$1)!,
    };
    setState(() => _savingPresets = true);
    try {
      final saved = await widget.repo.saveTimerPresets(presets);
      for (final e in saved.entries) {
        _presetC[e.key]?.text = '${e.value}';
      }
      _snack(s.tr('Activity times saved', 'تم حفظ أوقات الأنشطة'));
    } catch (e) {
      _snack(e is FacilitatorActionException
          ? e.message
          : s.tr('Could not save timer presets', 'تعذّر حفظ أوقات الأنشطة'), color: AppColors.danger);
    } finally {
      if (mounted) setState(() => _savingPresets = false);
    }
  }

  Future<void> _startPreset(AppStrings s, String key) async {
    final m = _presetMinutes(key);
    if (m == null) {
      _snack(s.tr('Enter 1-120 minutes', 'أدخل من 1 إلى 120 دقيقة'), color: AppColors.danger);
      return;
    }
    setState(() => _minutes = m);
    final res = await widget.repo.startTimerMinutes(m);
    final ok = res['success'] != false;
    _snack(ok
        ? s.tr('$m minute session timer is now active', 'مؤقّت الجلسة لمدة $m دقيقة يعمل الآن')
        : (res['message'] ?? res['error'] ?? s.tr('Could not start timer', 'تعذّر بدء المؤقّت')).toString(),
        color: ok ? null : AppColors.danger);
  }

  void _snack(String msg, {Color? color}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: color ?? AppColors.secondary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  Future<void> _overlay(bool show, AppStrings s) async {
<<<<<<< Updated upstream
    final ok = show ? await widget.repo.showTimerOverlay() : await widget.repo.hideTimerOverlay();
    if (!ok) {
      _snack(s.tr('Could not update the timer overlay', 'تعذّر تحديث عرض المؤقّت'),
          color: AppColors.danger);
      return;
    }
    _snack(show
        ? s.tr('Timer overlay shown on participant screens', 'تم عرض المؤقّت على شاشات المشاركين')
        : s.tr('Timer overlay hidden', 'تم إخفاء المؤقّت'));
=======
    try {
      show
          ? await widget.repo.showTimerOverlay(durationSeconds: _minutes * 60)
          : await widget.repo.hideTimerOverlay();
      _snack(show
          ? s.tr('$_minutes-minute countdown overlay started', 'بدأ عرض العدّ التنازلي لمدة $_minutes دقيقة')
          : s.tr('Timer overlay stopped', 'تم إيقاف عرض المؤقّت'));
    } catch (e) {
      _snack(e is FacilitatorActionException
          ? e.message
          : s.tr('Overlay control failed', 'تعذّر التحكم في العرض'), color: AppColors.danger);
    }
>>>>>>> Stashed changes
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final s = ref.watch(stringsProvider);
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200, height: 200,
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primaryLight, width: 4)),
              child: Center(
                child: Text('${_minutes.toString().padLeft(2, '0')}:00',
                  style: GoogleFonts.jetBrainsMono(fontSize: 48, fontWeight: FontWeight.w700, color: AppColors.primaryLight)),
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.center,
              children: [1, 2, 5, 10, 15, 20, 30, 45, 60].map((m) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(label: Text('${m}m'), selected: _minutes == m, onSelected: (_) => setState(() => _minutes = m)),
              )).toList(),
            ),
            const SizedBox(height: 12),
            // Free-form numeric entry (1–120 min) with a stepper.
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => setState(() => _minutes = (_minutes - 1).clamp(1, 120)),
                  icon: const Icon(Icons.remove_circle_outline_rounded),
                ),
                SizedBox(
                  width: 70,
                  child: TextField(
                    controller: TextEditingController(text: _minutes.toString())
                      ..selection = TextSelection.collapsed(offset: _minutes.toString().length),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.jetBrainsMono(fontSize: 18, fontWeight: FontWeight.w700),
                    decoration: const InputDecoration(suffixText: 'm', isDense: true, border: OutlineInputBorder()),
                    onSubmitted: (v) {
                      final n = int.tryParse(v.trim());
                      if (n != null) setState(() => _minutes = n.clamp(1, 120));
                    },
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => _minutes = (_minutes + 1).clamp(1, 120)),
                  icon: const Icon(Icons.add_circle_outline_rounded),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12, runSpacing: 12,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    widget.repo.startTimerMinutes(_minutes);
                    _snack(s.tr('Timer started', 'بدأ المؤقّت'));
                  },
                  icon: const Icon(Icons.play_arrow_rounded), label: Text(s.tr('Start', 'بدء')),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final res = await widget.repo.updateTimer(_minutes);
                    final ok = res['success'] == true;
                    _snack(
                      ok
                          ? s.tr('Timer updated to ${_minutes}m', 'تم تحديث المؤقّت إلى $_minutes د')
                          : (res['message'] as String? ?? s.tr('Could not update timer', 'تعذّر تحديث المؤقّت')),
                      color: ok ? AppColors.primary : AppColors.danger,
                    );
                  },
                  icon: const Icon(Icons.update_rounded), label: Text(s.tr('Update', 'تحديث')),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    widget.repo.setTimer(0, action: 'pause');
                    _snack(s.tr('Timer paused', 'تم إيقاف المؤقّت مؤقتًا'), color: AppColors.accent);
                  },
                  icon: const Icon(Icons.pause_rounded), label: Text(s.tr('Pause', 'إيقاف مؤقت')),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    widget.repo.setTimer(0, action: 'reset');
                    _snack(s.tr('Timer reset', 'تمت إعادة تعيين المؤقّت'), color: AppColors.danger);
                  },
                  icon: const Icon(Icons.refresh_rounded), label: Text(s.tr('Reset', 'إعادة تعيين')),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
                ),
              ],
            ),
            const SizedBox(height: 28),
            // Broadcast the timer overlay to all participant screens.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GlassCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      const Icon(Icons.cast_rounded, size: 18, color: AppColors.primaryLight),
                      const SizedBox(width: 8),
                      Text(s.tr('Live Timer Overlay', 'عرض المؤقّت المباشر'),
                          style: Theme.of(context).textTheme.titleMedium),
                    ]),
                    const SizedBox(height: 4),
                    Text(s.tr('Start or stop the projected countdown overlay, using the minutes set above.',
                        'ابدأ أو أوقف عرض العدّ التنازلي المعروض على الشاشة، بالدقائق المحدّدة أعلاه.'),
                        style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 12),
                    Row(children: [
                      Expanded(child: ElevatedButton.icon(
                        onPressed: () => _overlay(true, s),
                        icon: const Icon(Icons.visibility_rounded, size: 16),
                        label: Text(s.tr('Show overlay', 'إظهار')),
                      )),
                      const SizedBox(width: 10),
                      Expanded(child: OutlinedButton.icon(
                        onPressed: () => _overlay(false, s),
                        icon: const Icon(Icons.visibility_off_rounded, size: 16),
                        label: Text(s.tr('Hide overlay', 'إخفاء')),
                      )),
                    ]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Per-activity timer presets.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GlassCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      const Icon(Icons.timelapse_rounded, size: 18, color: AppColors.primaryLight),
                      const SizedBox(width: 8),
                      Text(s.tr('Activity Timers', 'مؤقّتات الأنشطة'),
                          style: Theme.of(context).textTheme.titleMedium),
                    ]),
                    const SizedBox(height: 4),
                    Text(s.tr('Set how long each activity gets; play starts the session timer with that time.',
                        'حدّد مدة كل نشاط؛ زر التشغيل يبدأ مؤقّت الجلسة بهذه المدة.'),
                        style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 12),
                    if (!_presetsLoaded)
                      const Center(child: Padding(padding: EdgeInsets.all(8), child: CircularProgressIndicator()))
                    else ...[
                      ..._activities.map((a) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(children: [
                          Expanded(child: Text(s.tr(a.$2, a.$3), style: const TextStyle(fontSize: 13))),
                          SizedBox(
                            width: 72,
                            child: TextField(
                              controller: _presetC[a.$1],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  suffixText: s.tr('m', 'د'), isDense: true, border: const OutlineInputBorder()),
                            ),
                          ),
                          IconButton(
                            tooltip: s.tr('Start timer', 'بدء المؤقّت'),
                            onPressed: () => _startPreset(s, a.$1),
                            icon: const Icon(Icons.play_circle_rounded, color: AppColors.secondaryLight),
                          ),
                        ]),
                      )),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _savingPresets ? null : () => _savePresets(s),
                          icon: const Icon(Icons.save_rounded, size: 16),
                          label: Text(s.tr('Save activity times', 'حفظ أوقات الأنشطة')),
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

// ---- Education Tab ----
<<<<<<< Updated upstream
// Every module the facilitator can force open (permanent catalog id, title),
// in hub order, straight from the catalog: the server validates the id against
// the website's FORCE_UNLOCKABLE_MODULE_NUMS, which is every catalog entry
// except the simulation (id 13), so the game gets no switch here. It answers to
// the game gate under Game Controls instead.
final List<(int, String, String)> _eduModules = [
  for (final m in educationCatalog)
    if (!m.isSimulation) (m.num, m.titleEn, m.titleAr),
];
=======
// Every module the facilitator can force open, in hub order, labelled by its
// catalog title: the catalog minus the game, matching the website's
// FORCE_UNLOCKABLE_MODULE_NUMS. The game card answers to the game gate, not
// this list, and the server rejects id 13 here.
final List<EducationCatalogEntry> _eduModules =
    educationCatalog.where((m) => !m.isSimulation).toList();
>>>>>>> Stashed changes

/// Ids behind the per-module unlock switches. Exposed so a test can pin them to
/// the catalog's non-simulation entries.
@visibleForTesting
List<int> get facilitatorEducationModuleIds =>
    _eduModules.map((m) => m.$1).toList();

class _EducationTab extends ConsumerStatefulWidget {
  final AsyncValue<GameState> gameState;
  const _EducationTab({required this.gameState});

  @override
  ConsumerState<_EducationTab> createState() => _EducationTabState();
}

class _EducationTabState extends ConsumerState<_EducationTab> {
  bool _busy = false;

  Future<void> _run(Future<void> Function(FacilitatorRepository repo) action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action(ref.read(facilitatorRepositoryProvider));
      await ref.read(gameStateProvider.notifier).fetchGameState();
    } catch (_) {/* ignore — UI reflects refreshed state */}
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    return widget.gameState.when(
      data: (gs) {
        final unlocked = gs.educationModulesUnlocked.toSet();
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Master education gate + Unlock-All / Lock-All
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(Icons.menu_book_rounded,
                        color: gs.educationUnlocked ? AppColors.secondaryLight : AppColors.textTertiary(context)),
                    const SizedBox(width: 12),
                    Expanded(child: Text(s.tr('Education (master)', 'التعليم (رئيسي)'),
                        style: Theme.of(context).textTheme.titleMedium)),
                    Switch(
                      value: gs.educationUnlocked,
                      onChanged: _busy ? null : (v) => _run((r) => r.toggleEducation(v)),
                      activeTrackColor: AppColors.secondaryLight,
                    ),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _busy ? null : () => _run((r) => r.toggleAllEducationModules(true)),
                        icon: const Icon(Icons.lock_open_rounded, size: 16),
                        label: Text(s.tr('Unlock All', 'فتح الكل')),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _busy ? null : () => _run((r) => r.toggleAllEducationModules(false)),
                        icon: const Icon(Icons.lock_rounded, size: 16),
                        label: Text(s.tr('Lock All', 'قفل الكل')),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(s.tr('Modules', 'الوحدات'),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.textSecondary(context))),
            const SizedBox(height: 8),
            ..._eduModules.map((m) {
              final isOn = unlocked.contains(m.num);
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(children: [
                    Icon(Icons.school_rounded, size: 20,
                        color: isOn ? AppColors.secondaryLight : AppColors.textTertiary(context)),
                    const SizedBox(width: 12),
                    Expanded(child: Text(s.tr(m.titleEn, m.titleAr), style: Theme.of(context).textTheme.bodyLarge)),
                    Switch(
                      value: isOn,
                      onChanged: _busy ? null : (v) => _run((r) => r.toggleEducationModule(m.num, v)),
                      activeTrackColor: AppColors.secondaryLight,
                    ),
                  ]),
                ),
              );
            }),
            const SizedBox(height: 12),
            // Other education controls
            _eduRow(context, s.tr('Activity Retry', 'إعادة المحاولة'), gs.educationRetryUnlocked,
                (v) => _run((r) => r.toggleEducationRetry(v))),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  Widget _eduRow(BuildContext context, String label, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(children: [
          Icon(Icons.tune_rounded, color: value ? AppColors.secondaryLight : AppColors.textTertiary(context)),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: Theme.of(context).textTheme.titleMedium)),
          Switch(value: value, onChanged: _busy ? null : onChanged, activeTrackColor: AppColors.secondaryLight),
        ]),
      ),
    );
  }
}

// ---- Cohorts Tab: see widgets/cohorts_panel.dart ----

// ---- Realism Tab ----
// The 12 finance-realism modules shown on team dashboards, plus the member-recommendations
// research flag (flag → label), matching the server's REALISM_FLAGS allow-list.
const List<(String, String, String)> _realismFlags = [
  ('workingCapitalEnabled', 'Working Capital', 'رأس المال العامل'),
  ('duPontEnabled', 'DuPont Analysis', 'تحليل دوبونت'),
  ('waccEnabled', 'WACC', 'المتوسط المرجّح لتكلفة رأس المال'),
  ('creditRatingEnabled', 'Credit Rating', 'التصنيف الائتماني'),
  ('debtCovenantsEnabled', 'Debt Covenants', 'تعهّدات الدين'),
  ('capTableEnabled', 'Cap Table', 'جدول الملكية'),
  ('dividendPolicyEnabled', 'Dividend Policy', 'سياسة التوزيعات'),
  ('ratiosLiquidityEnabled', 'Liquidity Ratios', 'نسب السيولة'),
  ('ratiosEfficiencyEnabled', 'Efficiency Ratios', 'نسب الكفاءة'),
  ('ratiosProfitabilityEnabled', 'Profitability Ratios', 'نسب الربحية'),
  ('ratiosSolvencyEnabled', 'Solvency Ratios', 'نسب الملاءة'),
  ('ratiosMarketEnabled', 'Market Ratios', 'نسب السوق'),
  // Research instrumentation (website REALISM_FLAGS / setup wizard): each member commits a
  // recommended amount before the team leader decides.
  ('memberRecommendationsEnabled', 'Member recommendations (research)', 'توصيات الأعضاء (بحث)'),
];

class _RealismTab extends ConsumerStatefulWidget {
  final FacilitatorRepository repo;
  const _RealismTab({required this.repo});
  @override
  ConsumerState<_RealismTab> createState() => _RealismTabState();
}

class _RealismTabState extends ConsumerState<_RealismTab> {
  Map<String, dynamic> _status = {};
  bool _loading = true;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final status = await widget.repo.fetchRealismStatus();
    if (mounted) setState(() { _status = status; _loading = false; });
  }

  Future<void> _toggle(String flag, bool enabled) async {
    if (_busy) return;
    setState(() { _busy = true; _status[flag] = enabled; }); // optimistic
    await widget.repo.toggleRealism(flag, enabled);
    await _load();
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    if (_loading) return const Center(child: CircularProgressIndicator());
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(s.tr('Show these finance modules on team dashboards.',
            'إظهار هذه الوحدات المالية على لوحات الفرق.'),
            style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context))),
        const SizedBox(height: 12),
        ..._realismFlags.map((f) {
          final isOn = _status[f.$1] == true;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(children: [
                Icon(Icons.insights_rounded, size: 20,
                    color: isOn ? AppColors.secondaryLight : AppColors.textTertiary(context)),
                const SizedBox(width: 12),
                Expanded(child: Text(s.tr(f.$2, f.$3), style: Theme.of(context).textTheme.bodyLarge)),
                Switch(value: isOn, onChanged: _busy ? null : (v) => _toggle(f.$1, v),
                    activeTrackColor: AppColors.secondaryLight),
              ]),
            ),
          );
        }),
      ],
    );
  }
}

// ---- Vouchers Tab ----
class _VouchersTab extends ConsumerStatefulWidget {
  final FacilitatorRepository repo;
  const _VouchersTab({required this.repo});
  @override
  ConsumerState<_VouchersTab> createState() => _VouchersTabState();
}

// Access period an account gets when it signs up with a code (website VouchersAdmin
// ACCESS_OPTIONS). null = no grant: the standard trial.
const List<(int?, String, String)> _voucherAccessOptions = [
  (30, '30 days', '30 يومًا'),
  (90, '3 months', '3 أشهر'),
  (183, '6 months', '6 أشهر'),
  (365, '1 year', 'سنة واحدة'),
  (730, '2 years', 'سنتان'),
  (null, 'None - standard trial', 'بدون - الفترة التجريبية العادية'),
];

String _voucherAccessLabel(AppStrings s, int? days) {
  if (days == null || days <= 0) return s.tr('Trial only', 'تجربة فقط');
  for (final o in _voucherAccessOptions) {
    if (o.$1 == days) return s.tr(o.$2, o.$3);
  }
  return s.tr('$days days', '$days يومًا');
}

/// Dropdown for a voucher's access period; keeps a non-preset value selectable.
Widget _voucherAccessDropdown(AppStrings s, int? value, ValueChanged<int?> onChanged) {
  final options = [
    if (value != null && !_voucherAccessOptions.any((o) => o.$1 == value))
      (value, '$value days', '$value يومًا'),
    ..._voucherAccessOptions,
  ];
  return DropdownButtonFormField<int?>(
    initialValue: value,
    isExpanded: true,
    decoration: InputDecoration(isDense: true, labelText: s.tr('Access period', 'مدة الوصول')),
    items: options
        .map((o) => DropdownMenuItem<int?>(value: o.$1, child: Text(s.tr(o.$2, o.$3))))
        .toList(),
    onChanged: onChanged,
  );
}

class _VouchersTabState extends ConsumerState<_VouchersTab> {
  List<Map<String, dynamic>> _vouchers = [];
  bool _gating = false;
  bool _loading = true;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final vouchers = await widget.repo.fetchVouchers();
    final gating = await widget.repo.fetchVoucherGating();
    if (mounted) setState(() { _vouchers = vouchers; _gating = gating; _loading = false; });
  }

  /// Website parity: "one code per user" mints N single-use codes, "one shared
  /// code" mints a single code with N uses.
  Future<void> _generate() async {
    if (_busy) return;
    final s = ref.read(stringsProvider);
    final countController = TextEditingController(text: '1');
    var shared = false;
    int? accessDays = 365;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: Text(s.tr('Generate access codes', 'إنشاء رموز دخول')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SegmentedButton<bool>(
                segments: [
                  ButtonSegment(
                      value: false,
                      label: Text(s.tr('One per user', 'رمز لكل مستخدم'),
                          style: const TextStyle(fontSize: 12))),
                  ButtonSegment(
                      value: true,
                      label: Text(s.tr('One shared code', 'رمز مشترك واحد'),
                          style: const TextStyle(fontSize: 12))),
                ],
                selected: {shared},
                onSelectionChanged: (sel) => setLocal(() => shared = sel.first),
                showSelectedIcon: false,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: countController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: shared
                      ? s.tr('How many people can redeem it', 'كم شخصًا يمكنه استخدامه')
                      : s.tr('How many codes', 'عدد الرموز'),
                ),
              ),
              const SizedBox(height: 12),
              _voucherAccessDropdown(s, accessDays, (v) => setLocal(() => accessDays = v)),
              const SizedBox(height: 4),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  accessDays != null
                      ? s.tr('Full access from sign-up, replacing the 7-day trial',
                          'وصول كامل من التسجيل، بدلًا من التجربة لمدة 7 أيام')
                      : s.tr('Learners get the standard 7-day trial',
                          'يحصل المتعلّمون على التجربة العادية لمدة 7 أيام'),
                  style: TextStyle(fontSize: 11, color: AppColors.textTertiary(context)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(s.tr('Cancel', 'إلغاء'))),
            FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(s.tr('Generate', 'إنشاء'))),
          ],
        ),
      ),
    );
    if (confirmed != true || !mounted) return;

    final n = (int.tryParse(countController.text.trim()) ?? 1).clamp(1, 500);
    setState(() => _busy = true);
    final created = shared
        ? await widget.repo.createVouchers(count: 1, maxUses: n, accessDays: accessDays)
        : await widget.repo.createVouchers(count: n, maxUses: 1, accessDays: accessDays);
    await _load();
    if (mounted) {
      setState(() => _busy = false);
      if (created.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(created.length == 1
              ? '${s.tr('Created code', 'تم إنشاء الرمز')}: ${created.first['code']}'
              : '${created.length} ${s.tr('codes created', 'رمزًا تم إنشاؤه')}'),
        ));
      }
    }
  }

  /// Shareable redemption link — opens self-paced sign-up with the code
  /// pre-filled and validated (same URL shape the website copies).
  String _linkFor(String code) {
    final base = ref
        .read(apiClientProvider)
        .baseUrl
        .replaceFirst(RegExp('${RegExp.escape(AppConstants.apiPrefix)}/*\$'), '');
    return '$base/self-paced-login?code=${Uri.encodeComponent(code)}';
  }

  Future<void> _copy(String text, String toast) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(toast)));
    }
  }

  /// Change the access period granted by a code. Applies to redemptions from now on;
  /// accounts already created keep the access they were given.
  Future<void> _editAccess(Map<String, dynamic> voucher) async {
    final s = ref.read(stringsProvider);
    int? days = (voucher['accessDays'] as num?)?.toInt();
    final picked = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: Text(s.tr('Access period', 'مدة الوصول')),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            _voucherAccessDropdown(s, days, (v) => setLocal(() => days = v)),
            const SizedBox(height: 8),
            Text(
              s.tr('Applies to accounts created with this code from now on.',
                  'ينطبق على الحسابات التي تُنشأ بهذا الرمز من الآن فصاعدًا.'),
              style: TextStyle(fontSize: 11, color: AppColors.textTertiary(context)),
            ),
          ]),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(s.tr('Cancel', 'إلغاء'))),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(s.tr('Save', 'حفظ'))),
          ],
        ),
      ),
    );
    if (picked != true || !mounted) return;
    setState(() => _busy = true);
    try {
      await widget.repo.updateVoucher(voucher['id'].toString(), {'accessDays': days});
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(s.tr('Could not update the code', 'تعذّر تحديث الرمز')),
            backgroundColor: AppColors.danger));
      }
    }
    await _load();
    if (mounted) setState(() => _busy = false);
  }

  /// Extend or clear a code's expiry (website parity with the inline Edit action).
  Future<void> _editExpiry(Map<String, dynamic> voucher) async {
    final s = ref.read(stringsProvider);
    final current = DateTime.tryParse(voucher['expiresAt']?.toString() ?? '');
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? now.add(const Duration(days: 30)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 3)),
      helpText: s.tr('Code valid until', 'الرمز صالح حتى'),
    );
    if (picked == null || !mounted) return;
    setState(() => _busy = true);
    await widget.repo.updateVoucher(
      voucher['id'].toString(),
      {'expiresAt': picked.toUtc().toIso8601String()},
    );
    await _load();
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _clearExpiry(Map<String, dynamic> voucher) async {
    setState(() => _busy = true);
    await widget.repo.updateVoucher(voucher['id'].toString(), {'expiresAt': null});
    await _load();
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _delete(String id) async {
    setState(() => _busy = true);
    await widget.repo.deleteVoucher(id);
    await _load();
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    if (_loading) return const Center(child: CircularProgressIndicator());
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(children: [
            Icon(Icons.verified_user_rounded, color: _gating ? AppColors.secondaryLight : AppColors.textTertiary(context)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(s.tr('Require access code', 'طلب رمز الدخول'), style: Theme.of(context).textTheme.titleMedium),
              Text(s.tr('Gate self-paced sign-up behind a voucher', 'تقييد التسجيل الذاتي برمز قسيمة'),
                  style: TextStyle(fontSize: 11, color: AppColors.textTertiary(context))),
            ])),
            Switch(
              value: _gating,
              onChanged: _busy ? null : (v) async {
                setState(() { _busy = true; _gating = v; });
                await widget.repo.setVoucherGating(v);
                if (mounted) setState(() => _busy = false);
              },
              activeTrackColor: AppColors.secondaryLight,
            ),
          ]),
        ),
        const SizedBox(height: 12),
        MasterVoucherCard(repo: widget.repo),
        const SizedBox(height: 12),
        Row(children: [
          Text(s.tr('Codes', 'الرموز'), style: Theme.of(context).textTheme.titleMedium),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: _busy ? null : _generate,
            icon: const Icon(Icons.add_rounded, size: 16),
            label: Text(s.tr('Generate', 'إنشاء')),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
          ),
        ]),
        const SizedBox(height: 8),
        if (_vouchers.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(s.tr('No codes yet', 'لا توجد رموز بعد'),
                style: TextStyle(color: AppColors.textTertiary(context))),
          )
        else
          ..._vouchers.map((v) {
            final code = (v['code'] ?? '').toString();
            final used = v['usedCount'] ?? 0;
            final max = v['maxUses'] ?? 1;
            final active = v['isActive'] != false;
            final expires = DateTime.tryParse(v['expiresAt']?.toString() ?? '');
            final accessDays = (v['accessDays'] as num?)?.toInt();
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      GestureDetector(
                        onTap: () => _copy(code, s.tr('Code copied', 'تم نسخ الرمز')),
                        child: Text(code,
                            style: GoogleFonts.jetBrainsMono(
                                fontWeight: FontWeight.w700, fontSize: 15)),
                      ),
                      Text(
                        '${v['label'] ?? ''}  ·  $used/$max ${s.tr('used', 'مستخدم')}'
                        '${active ? '' : ' · ${s.tr('revoked', 'ملغى')}'}'
                        '${expires == null ? '' : ' · ${s.tr('Code valid until', 'الرمز صالح حتى')} ${expires.toLocal().toString().split(' ').first}'}',
                        style: TextStyle(fontSize: 11, color: AppColors.textTertiary(context)),
                      ),
                      Text(
                        '${s.tr('Access', 'الوصول')}: ${_voucherAccessLabel(s, accessDays)}',
                        style: TextStyle(
                            fontSize: 11,
                            color: accessDays != null ? AppColors.textSecondary(context) : AppColors.accentLight),
                      ),
                    ])),
                    IconButton(
                      tooltip: s.tr('Copy redemption link', 'نسخ رابط الاستخدام'),
                      onPressed: _busy
                          ? null
                          : () => _copy(_linkFor(code),
                              s.tr('Link copied', 'تم نسخ الرابط')),
                      icon: const Icon(Icons.link_rounded, size: 20),
                      visualDensity: VisualDensity.compact,
                    ),
                    IconButton(
                      tooltip: s.tr('Change access period', 'تغيير مدة الوصول'),
                      onPressed: _busy ? null : () => _editAccess(v),
                      icon: const Icon(Icons.hourglass_bottom_rounded, size: 20),
                      visualDensity: VisualDensity.compact,
                    ),
                    IconButton(
                      tooltip: expires == null
                          ? s.tr('Set "code valid until"', 'تحديد تاريخ صلاحية الرمز')
                          : s.tr('Change "code valid until"', 'تغيير تاريخ صلاحية الرمز'),
                      onPressed: _busy ? null : () => _editExpiry(v),
                      icon: const Icon(Icons.event_rounded, size: 20),
                      visualDensity: VisualDensity.compact,
                    ),
                    if (expires != null)
                      IconButton(
                        tooltip: s.tr('Clear "code valid until"', 'إزالة تاريخ صلاحية الرمز'),
                        onPressed: _busy ? null : () => _clearExpiry(v),
                        icon: const Icon(Icons.event_busy_rounded, size: 20),
                        visualDensity: VisualDensity.compact,
                      ),
                    IconButton(
                      onPressed: _busy ? null : () => _delete(v['id'].toString()),
                      icon: const Icon(Icons.delete_outline_rounded, size: 20),
                      color: AppColors.dangerLight,
                      visualDensity: VisualDensity.compact,
                    ),
                  ]),
                  // The full link, selectable, so a facilitator can read it out
                  // or select it directly (website shows it under each code).
                  SelectableText(
                    _linkFor(code),
                    style: TextStyle(fontSize: 10, color: AppColors.textTertiary(context)),
                  ),
                ]),
              ),
            );
          }),
      ],
    );
  }
}

// ---- Assessments Tab ----
class _AssessmentsTab extends ConsumerStatefulWidget {
  final FacilitatorRepository repo;
  const _AssessmentsTab({required this.repo});
  @override
  ConsumerState<_AssessmentsTab> createState() => _AssessmentsTabState();
}

class _AssessmentsTabState extends ConsumerState<_AssessmentsTab> {
  List<Map<String, dynamic>> _attempts = [];
  bool _loading = true;
  bool _preMandated = false;
  bool _postMandated = false;
  // A DBA study cohort does not run the commercial assessments at all: the server
  // refuses a mandate with 409, so the switches are disabled rather than left to fail.
  bool _researchOn = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _setMandate(String kind, bool v) async {
    final s = ref.read(stringsProvider);
    final prevPre = _preMandated, prevPost = _postMandated;
    setState(() => kind == 'pre' ? _preMandated = v : _postMandated = v);
    try {
      await widget.repo.setAssessmentMandate(kind, v);
    } catch (e) {
      if (!mounted) return;
      setState(() { _preMandated = prevPre; _postMandated = prevPost; });
      _showActionError(context, s, e);
    }
  }

  Future<void> _load() async {
    final results = await Future.wait<Object?>([
      widget.repo.fetchAssessmentAttempts(),
      widget.repo.fetchResearchEnabled(),
      // The mandates live on the facilitator status (the public round state omits them).
      widget.repo.getState().then<Map<String, dynamic>?>((v) => v).catchError((_) => null),
    ]);
    final attempts = results[0] as List<Map<String, dynamic>>;
    final st = results[2] as Map<String, dynamic>?;
    final gs = ref.read(gameStateProvider).valueOrNull;
    if (mounted) {
      setState(() {
        _attempts = attempts;
        _researchOn = results[1] as bool;
        _loading = false;
        if (st != null) {
          _preMandated = st['preAssessmentMandated'] == true;
          _postMandated = st['postAssessmentMandated'] == true;
        } else if (gs != null) {
          _preMandated = gs.preAssessmentMandated;
          _postMandated = gs.postAssessmentMandated;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    if (_loading) return const Center(child: CircularProgressIndicator());
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (_researchOn) ...[
          _researchSuppressedNote(context, s,
              s.tr('The pre-course assessment, post-course assessment and course-survey QR do not run here. The study collects its questionnaires anonymously on a separate platform, and running an attributed assessment alongside them would undo that. Turn off the DBA study switch (Controls tab) to run this cohort commercially.',
                  'لا يُجرى هنا التقييم القبلي ولا التقييم البعدي ولا رمز QR لاستبيان الدورة. تجمع الدراسة استبياناتها دون الكشف عن الهوية على منصة منفصلة، وإجراء تقييم منسوب إلى المشاركين بالتوازي معها يُلغي ذلك. أوقف مفتاح دراسة الدكتوراه (تبويب التحكّم) لتشغيل هذه المجموعة تجاريًا.')),
          const SizedBox(height: 10),
        ],
        Row(children: [
          Expanded(child: _mandateCard(context, s, s.tr('Mandate Pre', 'إلزام القبلي'),
              _preMandated && !_researchOn, _researchOn ? null : (v) => _setMandate('pre', v))),
          const SizedBox(width: 10),
          Expanded(child: _mandateCard(context, s, s.tr('Mandate Post', 'إلزام البعدي'),
              _postMandated && !_researchOn, _researchOn ? null : (v) => _setMandate('post', v))),
        ]),
        const SizedBox(height: 16),
        Text('${s.tr('Attempts', 'المحاولات')} (${_attempts.length})',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        if (_attempts.isEmpty)
          Text(s.tr('No attempts yet', 'لا توجد محاولات بعد'),
              style: TextStyle(color: AppColors.textTertiary(context)))
        else
          ..._attempts.map((a) {
            final kind = (a['kind'] ?? '').toString();
            final name = (a['playerName'] ?? '—').toString();
            final score = a['score'] ?? 0;
            final total = a['total'] ?? 0;
            final pct = a['percentage'] ?? 0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: (kind == 'post' ? AppColors.primary : AppColors.accent).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(kind.toUpperCase(),
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                            color: kind == 'post' ? AppColors.primaryLight : AppColors.accentLight)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(name, style: Theme.of(context).textTheme.bodyLarge)),
                  Text('$score/$total  ·  $pct%', style: GoogleFonts.jetBrainsMono(fontSize: 13, fontWeight: FontWeight.w600)),
                ]),
              ),
            );
          }),
      ],
    );
  }

  Widget _mandateCard(BuildContext context, AppStrings s, String label, bool value, ValueChanged<bool>? onChanged) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(children: [
        Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
        Switch(value: value, onChanged: onChanged, activeTrackColor: AppColors.secondaryLight),
      ]),
    );
  }
}

/// Purple notice shown where a DBA study cohort suppresses the commercial assessments.
Widget _researchSuppressedNote(BuildContext context, AppStrings s, String body) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppColors.purple.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.purple.withValues(alpha: 0.35)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(s.tr('This cohort is enrolled in the DBA study.', 'هذه المجموعة مسجّلة في دراسة الدكتوراه (DBA).'),
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.purple)),
      const SizedBox(height: 4),
      Text(body, style: TextStyle(fontSize: 12, color: AppColors.textSecondary(context))),
    ]),
  );
}

// Editable QR placeholder destinations (the 6 fixed keys), matching the website.
const List<(String, String, String)> _qrPlaceholderKeys = [
  ('preAssessment', 'Pre-Assessment', 'التقييم القبلي'),
  ('postAssessment', 'Post-Assessment', 'التقييم البعدي'),
  ('courseSurvey', 'Course Survey', 'استبيان الدورة'),
  ('consultantLinkedin', 'Consultant LinkedIn', 'لينكدإن المستشار'),
  ('companyLinkedin', 'Company LinkedIn', 'لينكدإن الشركة'),
  ('infoSheet', 'Info Sheet', 'ورقة المعلومات'),
];

class _QrPlaceholdersCard extends ConsumerStatefulWidget {
  final FacilitatorRepository repo;
  const _QrPlaceholdersCard({required this.repo});
  @override
  ConsumerState<_QrPlaceholdersCard> createState() => _QrPlaceholdersCardState();
}

class _QrPlaceholdersCardState extends ConsumerState<_QrPlaceholdersCard> {
  final Map<String, TextEditingController> _url = {};
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    for (final k in _qrPlaceholderKeys) {
      _url[k.$1] = TextEditingController();
    }
    _load();
  }

  @override
  void dispose() {
    for (final c in _url.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    final status = await widget.repo.fetchQrStatus();
    final ph = status['qrPlaceholders'];
    if (ph is Map) {
      for (final k in _qrPlaceholderKeys) {
        final v = ph[k.$1];
        if (v is Map && v['url'] != null) _url[k.$1]!.text = v['url'].toString();
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final placeholders = <String, dynamic>{};
    for (final k in _qrPlaceholderKeys) {
      placeholders[k.$1] = {'url': _url[k.$1]!.text.trim(), 'label': ''};
    }
    final ok = await widget.repo.saveQrPlaceholders(placeholders);
    if (mounted) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ok ? 'QR destinations saved' : 'Could not save')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.qr_code_2_rounded, size: 18, color: AppColors.primaryLight),
            const SizedBox(width: 8),
            Text(s.tr('QR Destinations', 'وجهات رمز QR'), style: Theme.of(context).textTheme.titleMedium),
          ]),
          const SizedBox(height: 4),
          Text(s.tr('Set the URLs the overlay QR codes point to.',
              'حدّد الروابط التي تشير إليها رموز QR.'),
              style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 12),
          if (_loading)
            const Center(child: Padding(padding: EdgeInsets.all(8), child: CircularProgressIndicator()))
          else ...[
            ..._qrPlaceholderKeys.map((k) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextField(
                controller: _url[k.$1],
                keyboardType: TextInputType.url,
                style: const TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  labelText: s.tr(k.$2, k.$3),
                  hintText: 'https://…',
                  isDense: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            )),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saving ? null : _save,
                icon: const Icon(Icons.save_rounded, size: 16),
                label: Text(s.tr('Save Destinations', 'حفظ الوجهات')),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// The overlays /facilitator/qr-show accepts. A DBA study cohort refuses the first three
// (the commercial assessments and course survey), so the panel disables them.
const List<(String, String, String, bool)> _qrOverlays = [
  ('PRE_ASSESSMENT', 'Pre-Assessment', 'التقييم القبلي', true),
  ('POST_ASSESSMENT', 'Post-Assessment', 'التقييم البعدي', true),
  ('COURSE_SURVEY', 'Course Survey', 'استبيان الدورة', true),
  ('LINKEDIN', 'LinkedIn', 'لينكدإن', false),
  ('INFO_SHEET', 'Info Sheet', 'ورقة المعلومات', false),
];

// ---- QR Code Tab ----
class _QrCodeTab extends ConsumerStatefulWidget {
  final FacilitatorRepository repo;
  final AsyncValue<GameState> gameState;
  const _QrCodeTab({required this.repo, required this.gameState});

  @override
  ConsumerState<_QrCodeTab> createState() => _QrCodeTabState();
}

class _QrCodeTabState extends ConsumerState<_QrCodeTab> {
  bool _researchOn = false;
  // The cohort access code (facilitator-only, from /facilitator/status); the round state
  // the rest of the app reads never carries it.
  String? _accessCode;

  @override
  void initState() {
    super.initState();
    widget.repo.fetchResearchEnabled().then((on) {
      if (mounted) setState(() => _researchOn = on);
    });
    widget.repo.getState().then((st) {
      final code = (st['corporateAccessCode'] ?? '').toString();
      if (mounted) setState(() => _accessCode = code.isEmpty ? null : code);
    }).catchError((_) {});
  }

  Future<void> _show(AppStrings s, String placeholder, String label) async {
    try {
      await widget.repo.showQr(placeholder);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(s.tr('$label QR shown on participant screens', 'تم عرض رمز $label على شاشات المشاركين')),
          backgroundColor: AppColors.secondary,
          behavior: SnackBarBehavior.floating,
        ));
      }
    } catch (e) {
      if (mounted) _showActionError(context, s, e);
    }
  }

  Future<void> _hide(AppStrings s) async {
    try {
      await widget.repo.hideQr();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(s.tr('QR overlay removed from all screens', 'تمت إزالة رمز QR من جميع الشاشات')),
          backgroundColor: AppColors.secondary,
          behavior: SnackBarBehavior.floating,
        ));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(s.tr('Overlay control failed', 'تعذّر التحكم في العرض')),
            backgroundColor: AppColors.danger));
      }
    }
  }

  /// The cohort's own origin (the API host without /api): each cohort is its own subdomain.
  String get _origin => ref
      .read(apiClientProvider)
      .baseUrl
      .replaceFirst(RegExp('${RegExp.escape(AppConstants.apiPrefix)}/*\$'), '');

  /// client/src/lib/team-join-link.ts: the lobby with the team preset and the cohort code,
  /// so a delegate types only their name.
  String _teamJoinUrl(String teamId, String? accessCode) => Uri.parse('$_origin/lobby').replace(
        queryParameters: {
          'team': teamId,
          if (accessCode != null && accessCode.isNotEmpty) 'code': accessCode,
        },
      ).toString();

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final accessCode = _accessCode ?? widget.gameState.valueOrNull?.corporateAccessCode;
    final joinUrl = Uri.parse('$_origin/lobby').replace(queryParameters: {
      if (accessCode != null && accessCode.isNotEmpty) 'code': accessCode,
    }).toString().replaceFirst(RegExp(r'\?$'), '');

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(s.tr('Share Access', 'مشاركة الوصول'), style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(s.tr('Scan to join the simulation', 'امسح للانضمام إلى المحاكاة'), style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 16),
            // Live QR overlay broadcast controls (push a QR to participant screens).
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.cast_rounded, size: 18, color: AppColors.primaryLight),
                    const SizedBox(width: 8),
                    Text(s.tr('Live QR Overlay', 'عرض رمز QR المباشر'), style: Theme.of(context).textTheme.titleMedium),
                  ]),
                  const SizedBox(height: 4),
                  Text(s.tr('Show a QR on every participant screen, or hide it.',
                      'اعرض رمز QR على شاشات جميع المشاركين، أو أخفِه.'),
                      style: Theme.of(context).textTheme.bodySmall),
                  if (_researchOn) ...[
                    const SizedBox(height: 10),
                    _researchSuppressedNote(context, s,
                        s.tr('Pre-Assessment, Post-Assessment and Course Survey cannot be shown here. The study collects its questionnaires anonymously on a separate platform, and broadcasting these would link participants to it. Info Sheet and LinkedIn still work.',
                            'لا يمكن عرض التقييم القبلي والتقييم البعدي واستبيان الدورة هنا. تجمع الدراسة استبياناتها دون الكشف عن الهوية على منصة منفصلة، وبثّ هذه الرموز سيربط المشاركين بها. ورقة المعلومات ولينكدإن ما زالتا تعملان.')),
                  ],
                  const SizedBox(height: 12),
                  Wrap(spacing: 8, runSpacing: 8, children: [
                    for (final o in _qrOverlays)
                      ElevatedButton.icon(
                        onPressed: (o.$4 && _researchOn) ? null : () => _show(s, o.$1, s.tr(o.$2, o.$3)),
                        icon: const Icon(Icons.visibility_rounded, size: 16),
                        label: Text(s.tr(o.$2, o.$3), style: const TextStyle(fontSize: 12)),
                      ),
                  ]),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _hide(s),
                      icon: const Icon(Icons.visibility_off_rounded, size: 16),
                      label: Text(s.tr('Hide overlay', 'إخفاء')),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Manage the 6 placeholder QR destinations (assessment, survey, LinkedIn, info).
            _QrPlaceholdersCard(repo: widget.repo),
            const SizedBox(height: 16),
            GlassCard(
              padding: const EdgeInsets.all(24),
              child: QrImageView(
                data: joinUrl,
                version: QrVersions.auto,
                size: 220,
                eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.circle, color: AppColors.primaryLight),
                dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.circle, color: AppColors.primaryLight),
                backgroundColor: Colors.transparent,
              ),
            ),
            const SizedBox(height: 16),
            GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(children: [
                const Icon(Icons.link_rounded, color: AppColors.primaryLight, size: 18),
                const SizedBox(width: 8),
                Expanded(child: SelectableText(joinUrl, style: GoogleFonts.jetBrainsMono(fontSize: 12, color: AppColors.primaryLight))),
              ]),
            ),
            const SizedBox(height: 24),
            Text(s.tr('Team QR Codes', 'رموز QR للفرق'), style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(s.tr('Each opens the lobby with the team and cohort code filled in.',
                'يفتح كل رمز الردهة مع تعبئة الفريق ورمز المجموعة.'),
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12, runSpacing: 12,
              children: List.generate(AppConstants.maxTeams, (i) {
                final teamUrl = _teamJoinUrl('Team ${i + 1}', accessCode);
                final color = AppColors.teamColor(i);
                return GlassCard(
                  borderColor: color.withValues(alpha: 0.3),
                  padding: const EdgeInsets.all(12),
                  child: Column(children: [
                    QrImageView(data: teamUrl, version: QrVersions.auto, size: 80,
                      eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.circle, color: color),
                      dataModuleStyle: QrDataModuleStyle(dataModuleShape: QrDataModuleShape.circle, color: color),
                      backgroundColor: Colors.transparent),
                    const SizedBox(height: 6),
                    Text(s.tr('Team ${i + 1}', 'الفريق ${i + 1}'), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
                  ]),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// ---- Rounds Tab ----
class _RoundsTab extends StatelessWidget {
  final AsyncValue<GameState> gameState;
  final VoidCallback onAdvance;
  const _RoundsTab({required this.gameState, required this.onAdvance});

  @override
  Widget build(BuildContext context) {
    return gameState.when(
      data: (gs) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Current round display
              GlassCard(
                padding: const EdgeInsets.all(24),
                gradient: LinearGradient(colors: [AppColors.primary.withValues(alpha: 0.1), Colors.transparent]),
                child: Column(children: [
                  Text('Current Round', style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 8),
                  Text('${gs.currentRound}', style: GoogleFonts.jetBrainsMono(fontSize: 64, fontWeight: FontWeight.w800, color: AppColors.primaryLight)),
                  Text('of ${AppConstants.maxRounds}', style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 4),
                  Text('Module: ${gs.currentModule}', style: TextStyle(color: AppColors.primaryLight, fontSize: 13, fontWeight: FontWeight.w600)),
                ]),
              ),

              const SizedBox(height: 16),

              // Round progression
              ...List.generate(AppConstants.maxRounds, (i) {
                final roundNum = i + 1;
                final isDone = roundNum < gs.currentRound;
                final isCurrent = roundNum == gs.currentRound;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: GlassCard(
                    borderColor: isCurrent ? AppColors.primaryLight.withValues(alpha: 0.5) : null,
                    padding: const EdgeInsets.all(14),
                    child: Row(children: [
                      Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDone ? AppColors.secondary.withValues(alpha: 0.2) : isCurrent ? AppColors.primary.withValues(alpha: 0.2) : AppColors.cardColor(context),
                        ),
                        child: Center(child: isDone
                          ? const Icon(Icons.check, color: AppColors.secondaryLight, size: 18)
                          : Text('$roundNum', style: TextStyle(fontWeight: FontWeight.w700, color: isCurrent ? AppColors.primaryLight : AppColors.textTertiary(context)))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Round $roundNum — Year $roundNum', style: Theme.of(context).textTheme.titleSmall),
                          Text(isDone ? 'Completed' : isCurrent ? 'In Progress' : 'Upcoming',
                            style: TextStyle(fontSize: 12, color: isDone ? AppColors.secondaryLight : isCurrent ? AppColors.primaryLight : AppColors.textTertiary(context))),
                        ],
                      )),
                    ]),
                  ),
                );
              }),

              const SizedBox(height: 16),

              if (gs.currentRound < AppConstants.maxRounds)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onAdvance,
                    icon: const Icon(Icons.skip_next_rounded),
                    label: const Text('Advance to Next Round'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.danger,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                )
              else
                GlassCard(
                  borderColor: AppColors.secondaryLight.withValues(alpha: 0.3),
                  padding: const EdgeInsets.all(16),
                  child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.check_circle, color: AppColors.secondaryLight),
                    SizedBox(width: 8),
                    Text('All rounds completed', style: TextStyle(color: AppColors.secondaryLight, fontWeight: FontWeight.w600)),
                  ]),
                ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

// ---- Round Details Tab ----
class _RoundDetailsTab extends StatefulWidget {
  final FacilitatorRepository repo;
  const _RoundDetailsTab({required this.repo});

  @override
  State<_RoundDetailsTab> createState() => _RoundDetailsTabState();
}

class _RoundDetailsTabState extends State<_RoundDetailsTab> {
<<<<<<< Updated upstream
  // GET /facilitator/team-overview (teams[] with round, module, decision status).
  Map<String, dynamic>? _overview;
  // GET /facilitator/all-decisions pivoted by team: team -> module -> round -> rows.
  Map<String, Map<String, Map<String, List<Map<String, dynamic>>>>>? _allDecisions;
=======
  Map<String, Map<String, dynamic>>? _teamsStatus;
  Map<String, dynamic>? _allDecisions;
>>>>>>> Stashed changes
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() { _isLoading = true; _error = null; });
    try {
<<<<<<< Updated upstream
      final results = await Future.wait([
        widget.repo.getTeamOverview(),
=======
      final results = await Future.wait<Object>([
        widget.repo.getTeamPerformance(),
>>>>>>> Stashed changes
        widget.repo.getAllDecisions(),
      ]);
      if (mounted) {
        setState(() {
<<<<<<< Updated upstream
          _overview = results[0];
          _allDecisions = FacilitatorRepository.decisionsByTeam(results[1]);
=======
          _teamsStatus = results[0] as Map<String, Map<String, dynamic>>;
          _allDecisions = results[1] as Map<String, dynamic>;
>>>>>>> Stashed changes
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded, size: 48, color: AppColors.textTertiary(context)),
          const SizedBox(height: 12),
          Text('Could not load round details', style: TextStyle(color: AppColors.textTertiary(context))),
          const SizedBox(height: 8),
          TextButton.icon(onPressed: _loadData, icon: const Icon(Icons.refresh), label: const Text('Retry')),
        ],
      ));
    }

<<<<<<< Updated upstream
    final teams = ((_overview?['teams'] as List?) ?? const [])
        .map((t) => Map<String, dynamic>.from(t as Map))
        .toList();
    final decisionsData = _allDecisions ?? const {};
=======
    final Map<String, dynamic> teamsData = _teamsStatus ?? {};
    // all-decisions is keyed module -> team -> round; the cards want team -> module -> round.
    final decisionsData = <String, Map<String, dynamic>>{};
    for (final module in const ['financing', 'investing', 'operating']) {
      final byTeam = _allDecisions?[module];
      if (byTeam is! Map) continue;
      for (final e in byTeam.entries) {
        if (e.value is Map && (e.value as Map).isNotEmpty) {
          (decisionsData[e.key.toString()] ??= {})[module] = e.value;
        }
      }
    }
>>>>>>> Stashed changes

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Progress per team: round, module and decision status
          Text('Team Progress', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          GlassCard(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _buildProgressTable(context, teams),
            ),
          ),

          const SizedBox(height: 24),

          // Decisions Overview
          Text('Decisions Overview', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          ...List.generate(AppConstants.maxTeams, (i) {
            final teamKey = 'Team ${i + 1}';
            final color = AppColors.teamColor(i);
<<<<<<< Updated upstream
            final teamDecisions = decisionsData[teamKey] ?? const {};
=======
            final teamDecisions = decisionsData[teamKey] ?? const <String, dynamic>{};
>>>>>>> Stashed changes

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _ExpandableDecisionCard(
                teamName: teamKey,
                color: color,
                decisions: teamDecisions,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildProgressTable(BuildContext context, List<Map<String, dynamic>> teams) {
    const rows = <(String, String?)>[
      ('Round', null),
      ('Financing', 'financing'),
      ('Investing', 'investing'),
      ('Operating', 'operating'),
      ('Members', null),
    ];

    String cell(Map<String, dynamic>? t, (String, String?) row) {
      if (t == null) return '-';
      final module = row.$2;
      if (module == null) {
        if (row.$1 == 'Round') return '${t['currentRound'] ?? '?'}';
        final members = t['connectedMembers'];
        final count = t['onlineCount'] ?? (members is List ? members.length : 0);
        return '$count';
      }
      final ms = t['moduleStatus'];
      final entry = ms is Map ? ms[module] : null;
      final status = entry is Map ? entry['status']?.toString() : null;
      final current = t['currentModule'] == module;
      final label = switch (status) {
        'confirmed' => 'Confirmed',
        'in_progress' => 'In progress',
        _ => current ? 'Current' : '-',
      };
      return label;
    }

    Color cellColor(String label) => switch (label) {
          'Confirmed' => AppColors.secondaryLight,
          'In progress' => AppColors.accentLight,
          'Current' => AppColors.primaryLight,
          _ => Colors.transparent,
        }.withValues(alpha: 0.15);

    return DataTable(
      columnSpacing: 16,
      headingRowHeight: 40,
      dataRowMinHeight: 36,
      dataRowMaxHeight: 42,
      columns: [
        const DataColumn(label: Text('Metric', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
        ...List.generate(AppConstants.maxTeams, (i) => DataColumn(
          label: Text('T${i + 1}', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.teamColor(i))),
        )),
      ],
      rows: rows.map((row) {
        return DataRow(cells: [
          DataCell(Text(row.$1, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
          ...List.generate(AppConstants.maxTeams, (tIdx) {
            final label = cell(_overviewTeam(teams, tIdx + 1), row);
            return DataCell(Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: cellColor(label), borderRadius: BorderRadius.circular(4)),
              child: Text(label, style: GoogleFonts.jetBrainsMono(fontSize: 11)),
            ));
          }),
        ]);
      }).toList(),
    );
  }
}

class _ExpandableDecisionCard extends StatefulWidget {
  final String teamName;
  final Color color;
  /// module -> round -> rows {scenarioId, title, amount, confirmed}.
  final Map<String, Map<String, List<Map<String, dynamic>>>> decisions;
  const _ExpandableDecisionCard({required this.teamName, required this.color, required this.decisions});

  @override
  State<_ExpandableDecisionCard> createState() => _ExpandableDecisionCardState();
}

class _ExpandableDecisionCardState extends State<_ExpandableDecisionCard> {
  bool _expanded = false;

<<<<<<< Updated upstream
  /// 1234567 -> "1,234,567"; -3000000 -> "-3,000,000".
  static String _formatAmount(Object? amount) {
    final n = amount is num ? amount : num.tryParse('$amount');
    if (n == null) return '$amount';
    final digits = n.abs().round().toString();
    final buf = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buf.write(',');
      buf.write(digits[i]);
    }
    return '${n < 0 ? '-' : ''}$buf';
=======
  static String _fmtAmount(num v) {
    final a = v.abs();
    if (a >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (a >= 1000) return '${(v / 1000).toStringAsFixed(1)}K';
    return v.toStringAsFixed(0);
  }

  /// One figure. `confirmed: false` is an amount the team typed but never confirmed: it is
  /// not a decision and the model ignores it, so it is marked as a draft (website bdcb696).
  Widget _decisionLine(BuildContext context, Map item) {
    final draft = item['confirmed'] == false;
    final amount = item['amount'];
    final title = (item['title'] ?? 'Scenario ${item['scenarioId']}').toString();
    final amountText = amount is num ? _fmtAmount(amount) : '${amount ?? ''}';
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 2),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child: Text(title,
              style: TextStyle(
                  fontSize: 12,
                  color: draft ? AppColors.textTertiary(context) : AppColors.textSecondary(context),
                  fontStyle: draft ? FontStyle.italic : FontStyle.normal)),
        ),
        const SizedBox(width: 8),
        Tooltip(
          message: draft ? 'Typed but never confirmed. This is not a decision and the model ignores it.' : '',
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: (draft ? AppColors.accent : AppColors.secondary).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(4),
              border: draft ? Border.all(color: AppColors.accentLight.withValues(alpha: 0.6)) : null,
            ),
            child: Text(
              draft ? '$amountText · not confirmed' : amountText,
              style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  fontStyle: draft ? FontStyle.italic : FontStyle.normal,
                  color: draft ? AppColors.accentLight : AppColors.secondaryLight),
            ),
          ),
        ),
      ]),
    );
>>>>>>> Stashed changes
  }

  @override
  Widget build(BuildContext context) {
    final modules = ['financing', 'investing', 'operating'];

    return GlassCard(
      borderColor: widget.color.withValues(alpha: 0.3),
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: widget.color.withValues(alpha: 0.2),
                  child: Text(widget.teamName.replaceAll('Team ', 'T'), style: TextStyle(color: widget.color, fontWeight: FontWeight.w700, fontSize: 12)),
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(widget.teamName, style: Theme.of(context).textTheme.titleMedium)),
                Icon(
                  _expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                  color: AppColors.textTertiary(context),
                ),
              ]),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  if (widget.decisions.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text('No decisions recorded', style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context), fontStyle: FontStyle.italic)),
                    )
                  else
                    ...modules.map((module) {
<<<<<<< Updated upstream
                      final moduleData = widget.decisions[module];
                      if (moduleData == null) return const SizedBox.shrink();
                      final rounds = moduleData.keys.toList()
                        ..sort((a, b) => (int.tryParse(a) ?? 0).compareTo(int.tryParse(b) ?? 0));
=======
                      // {round: [{scenarioId, title, amount, confirmed}]}
                      final byRound = widget.decisions[module];
                      if (byRound is! Map || byRound.isEmpty) return const SizedBox.shrink();
                      final rounds = byRound.keys.map((k) => k.toString()).toList()..sort();
>>>>>>> Stashed changes
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              module[0].toUpperCase() + module.substring(1),
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: widget.color),
                            ),
                            const SizedBox(height: 4),
<<<<<<< Updated upstream
                            for (final round in rounds) ...[
                              Padding(
                                padding: const EdgeInsets.only(left: 8, top: 2),
                                child: Text('Round $round',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary(context))),
                              ),
                              ...moduleData[round]!.map((row) => Padding(
                                padding: const EdgeInsets.only(left: 16, top: 2),
                                child: Text(
                                  '${row['title'] ?? 'Scenario ${row['scenarioId']}'}: '
                                  '${_formatAmount(row['amount'])}'
                                  '${row['confirmed'] == true ? '' : ' (not confirmed)'}',
                                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary(context)),
                                ),
                              )),
=======
                            for (final r in rounds) ...[
                              Padding(
                                padding: const EdgeInsets.only(left: 8, top: 2),
                                child: Text('Round $r',
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textTertiary(context))),
                              ),
                              ...((byRound[r] ?? byRound[int.tryParse(r)]) as List<dynamic>? ?? const [])
                                  .whereType<Map>()
                                  .map((item) => _decisionLine(context, item)),
>>>>>>> Stashed changes
                            ],
                          ],
                        ),
                      );
                    }),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ---- Answer Key Tab ----
class _AnswerKeyTab extends StatelessWidget {
  const _AnswerKeyTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Break-Even Answer Keys', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        ..._breakEvenScenarios.asMap().entries.map((entry) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _AnswerKeyCard(
            index: entry.key + 1,
            color: AppColors.primaryLight,
            title: entry.value['title'] as String,
            details: entry.value['details'] as List<_AnswerDetail>,
          ),
        )),

        const SizedBox(height: 24),

        Text('Capital Budgeting Answer Keys', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        ..._capitalBudgetingScenarios.asMap().entries.map((entry) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _AnswerKeyCard(
            index: entry.key + 1,
            color: AppColors.accentLight,
            title: entry.value['title'] as String,
            details: entry.value['details'] as List<_AnswerDetail>,
          ),
        )),
      ],
    );
  }

  static final List<Map<String, dynamic>> _breakEvenScenarios = [
    {
      'title': 'Scenario 1: Basic Product Launch',
      'details': [
        _AnswerDetail('Fixed Costs', '\$50,000'),
        _AnswerDetail('Variable Cost / Unit', '\$20'),
        _AnswerDetail('Selling Price / Unit', '\$50'),
        _AnswerDetail('Break-Even Point', '1,667 units'),
        _AnswerDetail('BEP Revenue', '\$83,333'),
        _AnswerDetail('Margin of Safety (at 2,500 units)', '33.3%'),
      ],
    },
    {
      'title': 'Scenario 2: Service Business',
      'details': [
        _AnswerDetail('Fixed Costs', '\$120,000'),
        _AnswerDetail('Variable Cost / Unit', '\$35'),
        _AnswerDetail('Selling Price / Unit', '\$85'),
        _AnswerDetail('Break-Even Point', '2,400 units'),
        _AnswerDetail('BEP Revenue', '\$204,000'),
        _AnswerDetail('Margin of Safety (at 3,200 units)', '25.0%'),
      ],
    },
    {
      'title': 'Scenario 3: Manufacturing Scale-Up',
      'details': [
        _AnswerDetail('Fixed Costs', '\$200,000'),
        _AnswerDetail('Variable Cost / Unit', '\$45'),
        _AnswerDetail('Selling Price / Unit', '\$100'),
        _AnswerDetail('Break-Even Point', '3,637 units'),
        _AnswerDetail('BEP Revenue', '\$363,636'),
        _AnswerDetail('Margin of Safety (at 5,000 units)', '27.3%'),
      ],
    },
  ];

  static final List<Map<String, dynamic>> _capitalBudgetingScenarios = [
    {
      'title': 'Scenario 1: Equipment Purchase',
      'details': [
        _AnswerDetail('Initial Investment', '\$100,000'),
        _AnswerDetail('Annual Cash Flows', '\$30,000 x 5 years'),
        _AnswerDetail('Discount Rate', '10%'),
        _AnswerDetail('NPV', '\$13,724'),
        _AnswerDetail('IRR', '15.2%'),
        _AnswerDetail('Recommendation', 'Accept - NPV > 0'),
      ],
    },
    {
      'title': 'Scenario 2: Expansion Project',
      'details': [
        _AnswerDetail('Initial Investment', '\$250,000'),
        _AnswerDetail('Cash Flows', '\$60K, \$70K, \$80K, \$90K, \$100K'),
        _AnswerDetail('Discount Rate', '12%'),
        _AnswerDetail('NPV', '\$33,516'),
        _AnswerDetail('IRR', '17.4%'),
        _AnswerDetail('Recommendation', 'Accept - NPV > 0, IRR > hurdle rate'),
      ],
    },
    {
      'title': 'Scenario 3: Technology Upgrade',
      'details': [
        _AnswerDetail('Initial Investment', '\$175,000'),
        _AnswerDetail('Annual Cash Flows', '\$50,000 x 4 years'),
        _AnswerDetail('Discount Rate', '8%'),
        _AnswerDetail('NPV', '-\$9,371'),
        _AnswerDetail('IRR', '5.6%'),
        _AnswerDetail('Recommendation', 'Reject - NPV < 0, IRR < hurdle rate'),
      ],
    },
  ];
}

class _AnswerDetail {
  final String label;
  final String value;
  const _AnswerDetail(this.label, this.value);
}

class _AnswerKeyCard extends StatefulWidget {
  final int index;
  final Color color;
  final String title;
  final List<_AnswerDetail> details;
  const _AnswerKeyCard({required this.index, required this.color, required this.title, required this.details});

  @override
  State<_AnswerKeyCard> createState() => _AnswerKeyCardState();
}

class _AnswerKeyCardState extends State<_AnswerKeyCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderColor: widget.color.withValues(alpha: 0.3),
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: widget.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(child: Text('${widget.index}', style: TextStyle(color: widget.color, fontWeight: FontWeight.w700))),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(widget.title, style: Theme.of(context).textTheme.titleSmall)),
                Icon(
                  _expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                  color: AppColors.textTertiary(context),
                ),
              ]),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  const Divider(),
                  ...widget.details.map((d) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(children: [
                      Expanded(
                        flex: 2,
                        child: Text(d.label, style: TextStyle(fontSize: 13, color: AppColors.textSecondary(context))),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(d.value, style: GoogleFonts.jetBrainsMono(fontSize: 13, fontWeight: FontWeight.w600, color: widget.color)),
                      ),
                    ]),
                  )),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ---- Downloads Tab ----
class _DownloadsTab extends StatefulWidget {
  final FacilitatorRepository repo;
  const _DownloadsTab({required this.repo});

  @override
  State<_DownloadsTab> createState() => _DownloadsTabState();
}

class _DownloadsTabState extends State<_DownloadsTab> {
  bool _loadingLeaderboard = false;
  bool _loadingTeamReport = false;

  Future<void> _exportLeaderboard() async {
    setState(() => _loadingLeaderboard = true);
    try {
      final data = await widget.repo.getLeaderboard();
      final buffer = StringBuffer();
      buffer.writeln('Team,Score,Revenue,Net Income,Total Assets');
      for (final entry in data) {
        if (entry is Map<String, dynamic>) {
          buffer.writeln(
            '"${entry['teamName'] ?? entry['teamId'] ?? ''}",'
            '${entry['score'] ?? ''},'
            '${entry['revenue'] ?? ''},'
            '${entry['netIncome'] ?? ''},'
            '${entry['totalAssets'] ?? ''}'
          );
        }
      }
      await Clipboard.setData(ClipboardData(text: buffer.toString()));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Leaderboard CSV copied to clipboard'),
            backgroundColor: AppColors.secondary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.danger),
        );
      }
    } finally {
      if (mounted) setState(() => _loadingLeaderboard = false);
    }
  }

  Future<void> _exportTeamReport() async {
    setState(() => _loadingTeamReport = true);
    try {
<<<<<<< Updated upstream
      final teams = await widget.repo.getTeamOverviewTeams();
=======
      // Team overview (round, module, per-module status, members) + live performance.
      final teams = await widget.repo.getTeamOverview();
      Map<String, Map<String, dynamic>> perf = {};
      try {
        perf = await widget.repo.getTeamPerformance();
      } catch (_) {/* report without figures */}
>>>>>>> Stashed changes
      final buffer = StringBuffer();
      buffer.writeln('=== TEAM REPORTS ===');
      buffer.writeln('Generated: ${DateTime.now().toIso8601String()}');
      buffer.writeln('');

<<<<<<< Updated upstream
      for (int i = 0; i < AppConstants.maxTeams; i++) {
        final teamKey = 'Team ${i + 1}';
        final team = _overviewTeam(teams, i + 1);
        buffer.writeln('--- ${team?['teamName'] ?? teamKey} ---');
        if (team == null) {
          buffer.writeln('  (not on the server)');
          buffer.writeln('');
          continue;
=======
      for (final t in teams) {
        final id = (t['teamId'] ?? '').toString();
        buffer.writeln('--- ${t['teamName'] ?? id} ---');
        buffer.writeln('  Round: ${t['currentRound']}  Module: ${t['currentModule']}');
        final status = t['moduleStatus'];
        if (status is Map) {
          for (final m in status.entries) {
            final st = m.value is Map ? (m.value as Map)['status'] : m.value;
            buffer.writeln('  ${m.key}: $st');
          }
        }
        final members = (t['connectedMembers'] as List<dynamic>? ?? [])
            .map((m) => m is Map ? m['playerName'] : m)
            .join(', ');
        buffer.writeln('  Members: ${members.isEmpty ? '-' : members}');
        final p = perf[id];
        if (p != null) {
          buffer.writeln('  Score: ${p['score']}  Revenue: ${p['revenue']}  '
              'Net Income: ${p['netIncome']}  Total Assets: ${p['totalAssets']}');
>>>>>>> Stashed changes
        }
        buffer.writeln('  round: ${team['currentRound']}');
        buffer.writeln('  module: ${team['currentModule']}');
        final ms = team['moduleStatus'];
        if (ms is Map) {
          for (final m in ['financing', 'investing', 'operating']) {
            final st = ms[m];
            if (st is Map) {
              buffer.writeln('  $m: ${st['status']} (${(st['scenarios'] as List?)?.join(', ') ?? ''})');
            }
          }
        }
        final members = (team['connectedMembers'] as List?)
                ?.map((m) => (m as Map)['playerName']?.toString() ?? 'Anonymous')
                .toList() ??
            const [];
        buffer.writeln('  members (${members.length}): ${members.join(', ')}');
        buffer.writeln('');
      }

      await Clipboard.setData(ClipboardData(text: buffer.toString()));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Team report copied to clipboard'),
            backgroundColor: AppColors.secondary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.danger),
        );
      }
    } finally {
      if (mounted) setState(() => _loadingTeamReport = false);
    }
  }

  Future<void> _exportDecisions() async {
    try {
<<<<<<< Updated upstream
      // module -> team -> round -> rows, as the server sends it.
=======
>>>>>>> Stashed changes
      final data = await widget.repo.getAllDecisions();
      final buffer = StringBuffer();
      buffer.writeln('Module,Team,Round,Scenario,Amount,Confirmed');
      // {module: {teamId: {round: [{scenarioId, title, amount, confirmed}]}}}
      for (final module in const ['financing', 'investing', 'operating']) {
        final byTeam = data[module];
        if (byTeam is! Map) continue;
        for (final t in byTeam.entries) {
          if (t.value is! Map) continue;
          for (final r in (t.value as Map).entries) {
            for (final item in (r.value as List<dynamic>? ?? const []).whereType<Map>()) {
              final title = (item['title'] ?? item['scenarioId']).toString().replaceAll('"', '""');
              buffer.writeln('$module,"${t.key}",${r.key},"$title",${item['amount']},'
                  '${item['confirmed'] == false ? 'no (draft)' : 'yes'}');
            }
          }
        }
      }

      await Clipboard.setData(ClipboardData(text: buffer.toString()));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Decisions data copied to clipboard'),
            backgroundColor: AppColors.secondary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.danger),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final exports = [
      (
        'Leaderboard CSV',
        'Export current standings as CSV',
        Icons.leaderboard_rounded,
        AppColors.accentLight,
        _loadingLeaderboard,
        _exportLeaderboard,
      ),
      (
        'Team Reports',
        'Full status report for all teams',
        Icons.assessment_rounded,
        AppColors.primaryLight,
        _loadingTeamReport,
        _exportTeamReport,
      ),
      (
        'All Decisions',
        'Export all team decisions',
        Icons.checklist_rounded,
        AppColors.secondaryLight,
        false,
        _exportDecisions,
      ),
    ];

    return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Export Data', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text('Data will be copied to clipboard', style: TextStyle(fontSize: 13, color: AppColors.textTertiary(context))),
          const SizedBox(height: 16),
          GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.2,
              children: exports.map((e) => GlassCard(
                borderColor: e.$4.withValues(alpha: 0.3),
                padding: const EdgeInsets.all(16),
                onTap: e.$5 ? null : e.$6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 52, height: 52,
                      decoration: BoxDecoration(
                        color: e.$4.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: e.$5
                          ? const Padding(
                              padding: EdgeInsets.all(14),
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(e.$3, color: e.$4, size: 26),
                    ),
                    const SizedBox(height: 12),
                    Text(e.$1, style: Theme.of(context).textTheme.titleSmall, textAlign: TextAlign.center),
                    const SizedBox(height: 4),
                    Text(e.$2, style: TextStyle(fontSize: 11, color: AppColors.textTertiary(context)), textAlign: TextAlign.center),
                  ],
                ),
              )).toList(),
          ),
          const SizedBox(height: 16),
          const CourseSlidesCard(),
          const SizedBox(height: 16),
          FinancialStatementsCard(repo: widget.repo),
        ],
    );
  }
}

// ---- Settings Tab ----
class _SettingsTab extends StatefulWidget {
  final AsyncValue<GameState> gameState;
  final FacilitatorRepository repo;
  final Future<void> Function(String, bool) onToggleLock;
  final VoidCallback onClearCache;

  const _SettingsTab({
    required this.gameState,
    required this.repo,
    required this.onToggleLock,
    required this.onClearCache,
  });

  @override
  State<_SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<_SettingsTab> {
  bool _scenarioResultsVisible = false;
  bool _clearingProgress = false;

  @override
  void initState() {
    super.initState();
    // Visible when any capital-budgeting scenario's results are unlocked.
    widget.repo.getState().then((st) {
      final unlocked = st['capitalBudgetingResultsUnlocked'];
      if (mounted) setState(() => _scenarioResultsVisible = unlocked is List && unlocked.isNotEmpty);
    }).catchError((_) {});
  }

  Future<void> _toggleScenarioResults(AppStrings s, bool val) async {
<<<<<<< Updated upstream
    final ok = await widget.repo.setScenarioResultsVisible(val);
=======
    final prev = _scenarioResultsVisible;
    setState(() => _scenarioResultsVisible = val);
    try {
      await widget.repo.setScenarioResultsVisible(val);
    } catch (e) {
      if (!mounted) return;
      setState(() => _scenarioResultsVisible = prev);
      _showActionError(context, s, e);
      return;
    }
>>>>>>> Stashed changes
    if (!mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(s.tr('Could not change scenario results visibility', 'تعذّر تغيير إظهار نتائج السيناريو')),
        backgroundColor: AppColors.danger,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
      return;
    }
    setState(() => _scenarioResultsVisible = val);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(val
          ? s.tr('Scenario results are now visible to learners', 'أصبحت نتائج السيناريو مرئية للمتعلّمين')
          : s.tr('Scenario results are now hidden from learners', 'أصبحت نتائج السيناريو مخفية عن المتعلّمين')),
      backgroundColor: AppColors.secondary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  Future<void> _clearEducationProgress(AppStrings s) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E293B) : Colors.white,
        title: Text(s.tr('Clear Education Progress', 'مسح تقدّم التعليم')),
        content: Text(s.tr('Reset ALL teams\' education progress and scores and remove all team members? This cannot be undone.',
            'إعادة تعيين تقدّم التعليم والنقاط لجميع الفرق وإزالة جميع أعضاء الفرق؟ لا يمكن التراجع عن هذا الإجراء.')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(s.tr('Cancel', 'إلغاء'))),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            child: Text(s.tr('Clear', 'مسح')),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _clearingProgress = true);
    final ok = await widget.repo.clearEducationProgress();
    if (!mounted) return;
    setState(() => _clearingProgress = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(ok
          ? s.tr('Education progress cleared', 'تم مسح تقدّم التعليم')
          : s.tr('Could not clear education progress', 'تعذّر مسح تقدّم التعليم')),
      backgroundColor: ok ? AppColors.secondary : AppColors.danger,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final s = ref.watch(stringsProvider);
      return widget.gameState.when(
        data: (gs) {
          return ListView(padding: const EdgeInsets.all(16), children: [
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Module Locks', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                _LockRow('Financing Module', gs.lockFinancing, (v) => widget.onToggleLock('financing', v)),
                _LockRow('Investing Module', gs.lockInvesting, (v) => widget.onToggleLock('investing', v)),
                _LockRow('Operating Module', gs.lockOperating, (v) => widget.onToggleLock('operating', v)),
              ]),
            ),
            const SizedBox(height: 16),
            ScenarioResultsCard(repo: widget.repo),
            const SizedBox(height: 16),
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(s.tr('Learner Visibility', 'ما يراه المتعلّم'), style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(s.tr('Show scenario results to learners', 'إظهار نتائج السيناريو للمتعلّمين'),
                      style: Theme.of(context).textTheme.bodyMedium),
                  value: _scenarioResultsVisible,
                  activeTrackColor: AppColors.secondaryLight,
                  onChanged: (v) => _toggleScenarioResults(s, v),
                ),
              ]),
            ),
            const SizedBox(height: 16),
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('System', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                Row(children: [
                  Icon(Icons.info_outline, color: AppColors.textTertiary(context), size: 18),
                  const SizedBox(width: 8),
                  Text('Game Mode: ${gs.gameMode}', style: Theme.of(context).textTheme.bodyMedium),
                ]),
                const SizedBox(height: 8),
                Row(children: [
                  Icon(Icons.info_outline, color: AppColors.textTertiary(context), size: 18),
                  const SizedBox(width: 8),
                  Text('Round: ${gs.currentRound} / 3', style: Theme.of(context).textTheme.bodyMedium),
                ]),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: widget.onClearCache,
                    icon: const Icon(Icons.cleaning_services_rounded, size: 18),
                    label: const Text('Clear Cache'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => context.push('/admin/model'),
                    icon: const Icon(Icons.tune_rounded, size: 18),
                    label: const Text('Model Editor'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 16),
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(s.tr('Danger Zone', 'منطقة الخطر'), style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(s.tr('Permanently resets education progress and scores for every team and removes all team members.',
                    'يعيد نهائيًا تعيين تقدّم التعليم والنقاط لكل فريق ويزيل جميع أعضاء الفرق.'),
                    style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context))),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _clearingProgress ? null : () => _clearEducationProgress(s),
                    icon: _clearingProgress
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.delete_forever_rounded, size: 18),
                    label: Text(s.tr('Clear Education Progress', 'مسح تقدّم التعليم')),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger, foregroundColor: Colors.white),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 16),
            TestEmailCard(repo: widget.repo),
          ]);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      );
    });
  }
}

class _LockRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _LockRow(this.label, this.value, this.onChanged);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        Icon(value ? Icons.lock_rounded : Icons.lock_open_rounded, size: 18,
          color: value ? AppColors.dangerLight : AppColors.secondaryLight),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
        Switch(value: value, onChanged: onChanged, activeTrackColor: AppColors.dangerLight),
      ]),
    );
  }
}

// ---- Game Checks Tab ----
class _GameChecksTab extends StatefulWidget {
  final FacilitatorRepository repo;
  const _GameChecksTab({required this.repo});

  @override
  State<_GameChecksTab> createState() => _GameChecksTabState();
}

class _GameChecksTabState extends State<_GameChecksTab> {
  List<Map<String, dynamic>> _checks = [];
  bool _isRunning = false;
  bool _hasRun = false;

  static const _checkDefinitions = <Map<String, dynamic>>[
    {'name': 'API Health', 'endpoint': '/health', 'icon': Icons.favorite_rounded},
    {'name': 'Round State', 'endpoint': '/round/state', 'icon': Icons.play_circle_rounded},
    {'name': 'Teams Data', 'endpoint': '/teams', 'icon': Icons.groups_rounded},
    {'name': 'Leaderboard', 'endpoint': '/leaderboard/day', 'icon': Icons.leaderboard_rounded},
<<<<<<< Updated upstream
    {'name': 'Engine Connection', 'endpoint': ApiEndpoints.healthConnection, 'icon': Icons.table_chart_rounded},
=======
    // The website's system check: the Postgres-backed financial engine (mode 'online').
    {'name': 'Financial Engine (Database)', 'endpoint': '/health/connection', 'icon': Icons.storage_rounded, 'engine': true},
>>>>>>> Stashed changes
    {'name': 'Timer Status', 'endpoint': '/timer/status', 'icon': Icons.timer_rounded},
    {'name': 'Game State', 'endpoint': '/facilitator/status', 'icon': Icons.gamepad_rounded},
    {'name': 'Shocks', 'endpoint': '/shocks/predefined', 'icon': Icons.flash_on_rounded},
    {'name': 'Education', 'endpoint': '/education-modules/status', 'icon': Icons.school_rounded},
<<<<<<< Updated upstream
    {'name': 'Game Gate', 'endpoint': ApiEndpoints.facilitatorSimulationAccess, 'icon': Icons.public_rounded},
=======
>>>>>>> Stashed changes
  ];

  Future<void> _runAllChecks() async {
    setState(() {
      _isRunning = true;
      _checks = _checkDefinitions.map((d) => {...d, 'status': 'running', 'time': 0}).toList();
    });

    for (int i = 0; i < _checks.length; i++) {
      final start = DateTime.now();
      try {
<<<<<<< Updated upstream
        // runHealthCheck throws on a 4xx or success:false, so a dead route
        // shows as failed rather than passed-with-latency.
        await widget.repo.runHealthCheck(_checks[i]['endpoint'] as String);
=======
        if (_checks[i]['engine'] == true) {
          if (!await widget.repo.checkEngineHealth()) throw const FacilitatorActionException('offline');
        } else {
          await widget.repo.runHealthCheck(_checks[i]['endpoint'] as String);
        }
>>>>>>> Stashed changes
        final elapsed = DateTime.now().difference(start).inMilliseconds;
        if (mounted) {
          setState(() {
            _checks[i]['status'] = 'passed';
            _checks[i]['time'] = elapsed;
          });
        }
      } catch (e) {
        final elapsed = DateTime.now().difference(start).inMilliseconds;
        if (mounted) {
          setState(() {
            _checks[i]['status'] = 'failed';
            _checks[i]['time'] = elapsed;
          });
        }
      }
    }

    if (mounted) {
      setState(() {
        _isRunning = false;
        _hasRun = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasRun && !_isRunning) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.health_and_safety_rounded, color: AppColors.primaryLight, size: 36),
            ),
            const SizedBox(height: 16),
            Text('Game Connectivity Checks', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Test all API endpoints', style: TextStyle(color: AppColors.textTertiary(context))),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _runAllChecks,
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Run All Checks'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
            ),
          ],
        ),
      );
    }

    final passed = _checks.where((c) => c['status'] == 'passed').length;
    final failed = _checks.where((c) => c['status'] == 'failed').length;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: (failed == 0 && _hasRun ? AppColors.secondary : failed > 0 ? AppColors.danger : AppColors.primary).withValues(alpha: 0.1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _CheckStat('Total', '${_checks.length}', AppColors.primaryLight),
              _CheckStat('Passed', '$passed', AppColors.secondaryLight),
              _CheckStat('Failed', '$failed', failed > 0 ? AppColors.dangerLight : AppColors.textTertiary(context)),
              if (_isRunning)
                const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              else
                IconButton(
                  icon: const Icon(Icons.refresh_rounded, color: AppColors.primaryLight),
                  onPressed: _runAllChecks,
                ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _checks.length,
            itemBuilder: (context, index) {
              final check = _checks[index];
              final status = check['status'] as String;
              final time = check['time'] as int? ?? 0;

              Color statusColor;
              IconData statusIcon;
              if (status == 'running') {
                statusColor = AppColors.primaryLight;
                statusIcon = Icons.hourglass_top_rounded;
              } else if (status == 'passed') {
                statusColor = AppColors.secondaryLight;
                statusIcon = Icons.check_circle_rounded;
              } else {
                statusColor = AppColors.dangerLight;
                statusIcon = Icons.cancel_rounded;
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GlassCard(
                  padding: const EdgeInsets.all(12),
                  borderColor: statusColor.withValues(alpha: 0.3),
                  child: Row(
                    children: [
                      Icon(check['icon'] as IconData, color: statusColor, size: 20),
                      const SizedBox(width: 10),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(check['name'] as String, style: Theme.of(context).textTheme.titleSmall),
                          Text(check['endpoint'] as String, style: TextStyle(fontSize: 11, color: AppColors.textTertiary(context))),
                        ],
                      )),
                      if (status == 'running')
                        const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      else ...[
                        Text('${time}ms', style: GoogleFonts.jetBrainsMono(fontSize: 11, color: statusColor)),
                        const SizedBox(width: 8),
                        Icon(statusIcon, color: statusColor, size: 20),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CheckStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _CheckStat(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.jetBrainsMono(fontSize: 20, fontWeight: FontWeight.w700, color: color)),
        Text(label, style: TextStyle(fontSize: 11, color: AppColors.textTertiary(context))),
      ],
    );
  }
}

/// Facilitator switch marking this cohort as a DBA study site (POST /research/mode).
/// FinPlay collects none of the study's data; the switch only suppresses the commercial
/// pre/post assessments and course survey here, as the website's Cohorts panel does.
class _ResearchModeCard extends ConsumerStatefulWidget {
  const _ResearchModeCard();

  @override
  ConsumerState<_ResearchModeCard> createState() => _ResearchModeCardState();
}

class _ResearchModeCardState extends ConsumerState<_ResearchModeCard> {
  bool _enabled = false;
  bool _loading = true;
  // Whose assessments the study suppresses: 'corporate' (default) or 'all'. Scoped
  // per-cohort server-side; this switch applies to the cohort below.
  String _audience = 'corporate';
  String? _cohortLabel; // which cohort this toggle applies to (null = main site)

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final res = await ref.read(apiClientProvider).get(ApiEndpoints.researchConfig);
      if (mounted) {
        setState(() {
          _enabled = res['enabled'] == true;
          final audience = res['audience']?.toString();
          _audience = audience == 'all' ? 'all' : 'corporate';
          _cohortLabel = _readCohortLabel(res['cohort']);
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  String? _readCohortLabel(dynamic cohort) {
    if (cohort is Map) {
      final display = cohort['displayName']?.toString();
      if (display != null && display.trim().isNotEmpty) return display;
      final sub = cohort['subdomain']?.toString();
      if (sub != null && sub.trim().isNotEmpty) return sub;
    }
    return null;
  }

  Future<void> _toggle(bool value) async {
    final prev = _enabled;
    setState(() => _enabled = value);
    try {
      // Send audience so the server keeps the current scoping on toggle.
      await ref.read(apiClientProvider).post(ApiEndpoints.researchMode,
          data: {'enabled': value, 'audience': _audience});
    } catch (_) {
      if (mounted) setState(() => _enabled = prev); // revert on failure
    }
  }

  Future<void> _setAudience(String value) async {
    if (value == _audience) return;
    final prev = _audience;
    setState(() => _audience = value);
    try {
      await ref.read(apiClientProvider).post(ApiEndpoints.researchMode,
          data: {'enabled': _enabled, 'audience': value});
    } catch (_) {
      if (mounted) setState(() => _audience = prev); // revert on failure
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final appliesTo = _cohortLabel ?? s.tr('main site', 'الموقع الرئيسي');
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: AppColors.purple.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.science_rounded, color: AppColors.purple, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.tr('Part of the DBA research study', 'جزء من دراسة الدكتوراه (DBA)'), style: Theme.of(context).textTheme.titleMedium),
                Text(
                  _enabled
                      ? s.tr('On: a study site. The course\'s own pre and post assessments and course survey do not run here.',
                          'مفعّل: موقع للدراسة. لا يُجرى هنا التقييمان القبلي والبعدي ولا استبيان الدورة.')
                      : s.tr('Off: a normal commercial delivery with everything included.',
                          'متوقّف: تقديم تجاري عادي يشمل كل شيء.'),
                  style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context)),
                ),
                Text(
                  s.tr('Applies to: $appliesTo', 'ينطبق على: $appliesTo'),
                  style: TextStyle(fontSize: 11, color: AppColors.textTertiary(context)),
                ),
              ],
            )),
            _loading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : Switch(value: _enabled, activeThumbColor: AppColors.purple, onChanged: _toggle),
          ]),
          // Audience selector — whose assessments are suppressed while this is on.
          if (_enabled && !_loading) ...[
            const SizedBox(height: 12),
            Text(
              s.tr('Whose assessments are switched off', 'لمن تُوقَف التقييمات'),
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textTertiary(context)),
            ),
            const SizedBox(height: 6),
            SegmentedButton<String>(
              segments: [
                ButtonSegment(
                    value: 'corporate',
                    label: Text(s.tr('Corporate only', 'الشركات فقط'),
                        style: const TextStyle(fontSize: 12))),
                ButtonSegment(
                    value: 'all',
                    label: Text(s.tr('Everyone', 'الجميع'),
                        style: const TextStyle(fontSize: 12))),
              ],
              selected: {_audience},
              onSelectionChanged: (sel) => _setAudience(sel.first),
              showSelectedIcon: false,
            ),
            const SizedBox(height: 4),
            Text(
              _audience == 'corporate'
                  ? s.tr('Self-paced learners keep their assessments.',
                      'يحتفظ متعلّمو التعلّم الذاتي بتقييماتهم.')
                  : s.tr('Corporate and self-paced learners both skip the assessments.',
                      'يتخطّى متعلّمو الشركات والتعلّم الذاتي التقييمات معًا.'),
              style: TextStyle(fontSize: 11, color: AppColors.textTertiary(context)),
            ),
          ],
        ],
      ),
    );
  }
}
