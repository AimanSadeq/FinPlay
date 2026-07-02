import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/utils/constants.dart';
import '../../../data/models/game_state.dart';
import '../../../data/models/shock.dart';
import '../../../data/repositories/facilitator_repository.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../providers/repository_providers.dart';
import '../../../providers/team_provider.dart';
import '../../../providers/game_state_provider.dart';

import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/gradient_button.dart';
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
    _tabController = TabController(length: 19, vsync: this);
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
      final repo = ref.read(facilitatorRepositoryProvider);
      final success = await repo.login(_passwordController.text);
      if (success) {
        setState(() => _isAuthenticated = true);
        ref.read(teamProvider.notifier).fetchTeams();
        ref.read(gameStateProvider.notifier).fetchGameState();
        _loadShocks();
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

  Future<void> _triggerShock(String shockId) async {
    try {
      final repo = ref.read(facilitatorRepositoryProvider);
      await repo.triggerShock(shockId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ref.read(stringsProvider).tr('Shock triggered!', 'تم تفعيل الصدمة!')),
            backgroundColor: AppColors.danger,
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

  Future<void> _toggleModuleLock(String module, bool locked) async {
    try {
      final repo = ref.read(facilitatorRepositoryProvider);
      await repo.lockModule(module, locked);
      ref.read(gameStateProvider.notifier).fetchGameState();
    } catch (_) {}
  }

  Future<void> _toggleEducation(String feature, bool unlocked) async {
    try {
      final repo = ref.read(facilitatorRepositoryProvider);
      await repo.unlockEducation(feature, unlocked);
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
    if (confirmed != true) return;

    try {
      final repo = ref.read(facilitatorRepositoryProvider);
      await repo.advanceRound();
      ref.read(gameStateProvider.notifier).fetchGameState();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(s.tr('Round advanced!', 'تم تقديم الجولة!')), backgroundColor: AppColors.secondary),
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
                      icon: const Icon(Icons.logout_rounded, color: AppColors.dangerLight),
                      onPressed: () => setState(() => _isAuthenticated = false),
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
                  Tab(text: s.tr('Leaderboard', 'لوحة المتصدّرين')),
                  Tab(text: s.tr('Teams', 'الفرق')),
                  Tab(text: s.tr('Sign-In', 'تسجيل الدخول')),
                  Tab(text: s.tr('Shocks', 'الصدمات')),
                  Tab(text: s.tr('Timer', 'المؤقّت')),
                  Tab(text: s.tr('Education', 'التعليم')),
                  Tab(text: s.tr('Realism', 'الواقعية')),
                  Tab(text: s.tr('Vouchers', 'القسائم')),
                  Tab(text: s.tr('Assessments', 'التقييمات')),
                  Tab(text: s.tr('QR Code', 'رمز QR')),
                  Tab(text: s.tr('Rounds', 'الجولات')),
                  Tab(text: s.tr('Round Details', 'تفاصيل الجولة')),
                  Tab(text: s.tr('Answer Key', 'مفتاح الإجابات')),
                  Tab(text: s.tr('Excel', 'إكسل')),
                  Tab(text: s.tr('Downloads', 'التنزيلات')),
                  Tab(text: s.tr('Game Checks', 'فحوصات اللعبة')),
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
                    _CohortsTab(repo: ref.read(facilitatorRepositoryProvider)),
                    _LeaderboardTab(repo: ref.read(facilitatorRepositoryProvider)),
                    _TeamsTab(teams: teamState.teams),
                    _TeamSignInTab(repo: ref.read(facilitatorRepositoryProvider)),
                    _ShocksTab(
                      shocks: _shocks,
                      onTrigger: _triggerShock,
                      repo: ref.read(facilitatorRepositoryProvider),
                    ),
                    _TimerTab(repo: ref.read(facilitatorRepositoryProvider)),
                    _EducationTab(gameState: gameState, onToggle: _toggleEducation),
                    _RealismTab(repo: ref.read(facilitatorRepositoryProvider)),
                    _VouchersTab(repo: ref.read(facilitatorRepositoryProvider)),
                    _AssessmentsTab(repo: ref.read(facilitatorRepositoryProvider)),
                    _QrCodeTab(repo: ref.read(facilitatorRepositoryProvider)),
                    _RoundsTab(gameState: gameState, onAdvance: _advanceRound),
                    _RoundDetailsTab(repo: ref.read(facilitatorRepositoryProvider)),
                    const _AnswerKeyTab(),
                    _ExcelViewerTab(repo: ref.read(facilitatorRepositoryProvider)),
                    _DownloadsTab(repo: ref.read(facilitatorRepositoryProvider)),
                    _GameChecksTab(repo: ref.read(facilitatorRepositoryProvider)),
                    _SettingsTab(
                      gameState: gameState,
                      repo: ref.read(facilitatorRepositoryProvider),
                      onToggleLock: _toggleModuleLock,
                      onClearCache: () async {
                        try {
                          await ref.read(gameRepositoryProvider).clearCache();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(s.tr('Cache cleared', 'تم مسح ذاكرة التخزين المؤقت')), backgroundColor: AppColors.secondary),
                            );
                          }
                        } catch (_) {}
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
  bool _siteAccessEnabled = false;
  bool _corporateModeEnabled = false;
  bool _lobbyOpen = false;
  String _gameStatus = 'stopped';
  bool _loading = false;

  // Covenant threshold overrides
  final _maxLeverageC = TextEditingController(text: '3.0');
  final _minCoverageC = TextEditingController(text: '1.5');
  bool _savingCovenant = false;

  // Budget constraints
  final _budgetC = TextEditingController(text: '1000000');
  String _constraintLevel = 'Beginner';
  bool _savingConstraint = false;

  @override
  void dispose() {
    _maxLeverageC.dispose();
    _minCoverageC.dispose();
    _budgetC.dispose();
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

  Future<void> _saveConstraint(AppStrings s) async {
    final budget = double.tryParse(_budgetC.text.trim());
    if (budget == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(s.tr('Enter a valid budget', 'أدخل ميزانية صحيحة')),
        backgroundColor: AppColors.danger));
      return;
    }
    setState(() => _savingConstraint = true);
    final ok = await widget.repo.setTeamConstraints(level: _constraintLevel, budget: budget);
    if (mounted) {
      setState(() => _savingConstraint = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(ok
            ? s.tr('Budget constraint saved', 'تم حفظ قيد الميزانية')
            : s.tr('Could not save constraint', 'تعذّر حفظ القيد')),
        backgroundColor: ok ? AppColors.secondary : AppColors.danger,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncFromGameState();
  }

  void _syncFromGameState() {
    final gs = widget.gameState;
    gs.whenData((data) {
      if (mounted) {
        setState(() {
          _siteAccessEnabled = data.siteAccessEnabled;
          _corporateModeEnabled = data.corporateModeEnabled;
          _gameStatus = data.isActive ? 'playing' : 'stopped';
        });
      }
    });
  }

  Future<void> _toggleSiteAccess(bool val) async {
    setState(() => _loading = true);
    try {
      await widget.repo.toggleSiteAccess(val);
      setState(() => _siteAccessEnabled = val);
      widget.onRefreshState();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.danger),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _toggleCorporateMode(bool val) async {
    setState(() => _loading = true);
    try {
      await widget.repo.toggleCorporateMode(val);
      setState(() => _corporateModeEnabled = val);
      widget.onRefreshState();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.danger),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _gameControl(String action) async {
    setState(() => _loading = true);
    try {
      await widget.repo.gameControl(action);
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.danger),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _toggleLobby(bool open) async {
    setState(() => _loading = true);
    try {
      await widget.repo.toggleLobby(open);
      setState(() => _lobbyOpen = open);
      widget.onRefreshState();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.danger),
        );
      }
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
        // Site Access Toggle
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: (_siteAccessEnabled ? AppColors.secondary : AppColors.danger).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _siteAccessEnabled ? Icons.public_rounded : Icons.public_off_rounded,
                color: _siteAccessEnabled ? AppColors.secondaryLight : AppColors.dangerLight,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.tr('Site Access', 'الوصول إلى الموقع'), style: Theme.of(context).textTheme.titleMedium),
                Text(
                  _siteAccessEnabled ? s.tr('Public - Anyone can access', 'عام - يمكن للجميع الوصول') : s.tr('Private - Access restricted', 'خاص - الوصول مقيّد'),
                  style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context)),
                ),
              ],
            )),
            Switch(
              value: _siteAccessEnabled,
              onChanged: _loading ? null : _toggleSiteAccess,
              activeTrackColor: AppColors.secondaryLight,
            ),
          ]),
        ),
        const SizedBox(height: 12),

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
                  _lobbyOpen ? s.tr('Lobby is open for players', 'الردهة مفتوحة للاعبين') : s.tr('Lobby is closed', 'الردهة مغلقة'),
                  style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context)),
                ),
              ],
            )),
            Switch(
              value: _lobbyOpen,
              onChanged: _loading ? null : _toggleLobby,
              activeTrackColor: AppColors.secondaryLight,
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
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Unlock Decisions
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.lock_open_rounded, color: AppColors.secondaryLight, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.tr('Unlock Decisions', 'فتح القرارات'), style: Theme.of(context).textTheme.titleMedium),
                Text(s.tr('Unlock next module for all teams', 'فتح الوحدة التالية لجميع الفرق'), style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context))),
              ],
            )),
            ElevatedButton(
              onPressed: _loading ? null : _unlockDecisions,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
              child: Text(s.tr('Unlock', 'فتح'), style: const TextStyle(fontSize: 12)),
            ),
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

        // ── Rules: Budget constraints ──
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const Icon(Icons.account_balance_wallet_rounded, color: AppColors.primaryLight, size: 20),
                const SizedBox(width: 8),
                Text(s.tr('Budget Constraints', 'قيود الميزانية'), style: Theme.of(context).textTheme.titleMedium),
              ]),
              const SizedBox(height: 4),
              Text(s.tr('Set the starting budget per difficulty level.',
                  'حدّد الميزانية الابتدائية لكل مستوى صعوبة.'),
                  style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context))),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: DropdownButtonFormField<String>(
                  initialValue: _constraintLevel,
                  isDense: true,
                  decoration: InputDecoration(
                    labelText: s.tr('Level', 'المستوى'), isDense: true, border: const OutlineInputBorder()),
                  items: const ['Beginner', 'Intermediate', 'Advanced']
                      .map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                  onChanged: (v) => setState(() => _constraintLevel = v ?? _constraintLevel),
                )),
                const SizedBox(width: 10),
                Expanded(child: TextField(
                  controller: _budgetC,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: s.tr('Budget', 'الميزانية'), isDense: true, border: const OutlineInputBorder()),
                )),
              ]),
              const SizedBox(height: 12),
              SizedBox(width: double.infinity, child: ElevatedButton.icon(
                onPressed: _savingConstraint ? null : () => _saveConstraint(s),
                icon: _savingConstraint
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.save_rounded, size: 18),
                label: Text(s.tr('Save Constraint', 'حفظ القيد')),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              )),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Force Excel Cache Refresh
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
                Text(s.tr('Excel Cache', 'ذاكرة Excel المؤقتة'), style: Theme.of(context).textTheme.titleMedium),
                Text(s.tr('Force refresh server Excel cache', 'فرض تحديث ذاكرة Excel على الخادم'), style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context))),
              ],
            )),
            ElevatedButton(
              onPressed: _loading ? null : _refreshExcelCache,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
              child: Text(s.tr('Refresh', 'تحديث'), style: const TextStyle(fontSize: 12)),
            ),
          ]),
        ),
        const SizedBox(height: 12),

        // Research (DBA) mode toggle — gates the learner-facing research flow.
        const _ResearchModeCard(),
      ],
    );
    });
  }

  Future<void> _forcePosition(int round, String module) async {
    setState(() => _loading = true);
    try {
      await widget.repo.forceRound(round);
      await widget.repo.forceModule(module);
      widget.onRefreshState();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Moved to Round $round - ${module[0].toUpperCase()}${module.substring(1)}'),
            backgroundColor: AppColors.secondary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
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

  Future<void> _unlockDecisions() async {
    setState(() => _loading = true);
    try {
      await widget.repo.unlockDecisions();
      widget.onRefreshState();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Decisions unlocked'), backgroundColor: AppColors.secondary),
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

  Future<void> _refreshExcelCache() async {
    setState(() => _loading = true);
    try {
      await widget.repo.refreshExcelCache();
      widget.onRefreshState();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Excel cache refreshed'), backgroundColor: AppColors.secondary),
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

  static const _sheetKeys = ['Income Statement', 'Balance Sheet', 'Cash Flow', 'Ratios'];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final data = await widget.repo.fetchExcelData();
      // The payload may be wrapped under a 'data' or 'sheets' key.
      final inner = data['data'] is Map
          ? Map<String, dynamic>.from(data['data'] as Map)
          : data['sheets'] is Map
              ? Map<String, dynamic>.from(data['sheets'] as Map)
              : data;
      if (mounted) setState(() { _data = inner; _loading = false; });
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
          final label = (row['label'] ?? row['name'] ?? row['key'] ?? 'Row ${i + 1}').toString();
          final value = (row['value'] ?? row['amount'] ?? '').toString();
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
                    title: k,
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
  Map<String, dynamic> _signinData = {};
  bool _isLoading = true;
  String? _error;
  // teamId (number string) -> current leader name.
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
      for (var i = 1; i <= AppConstants.maxTeams; i++) widget.repo.fetchTeamLeader('$i'),
    ]);
    if (!mounted) return;
    setState(() {
      for (var i = 0; i < results.length; i++) {
        _leaders['${i + 1}'] = results[i];
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
      final data = await widget.repo.getTeamSignins();
      if (mounted) {
        setState(() {
          _signinData = data;
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

    // Parse teams data - handle various response formats
    final teamsData = _signinData['data'] as Map<String, dynamic>? ?? _signinData['teams'] as Map<String, dynamic>? ?? {};

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: AppConstants.maxTeams,
      itemBuilder: (context, index) {
        final teamKey = 'Team ${index + 1}';
        final color = AppColors.teamColor(index);
        final teamInfo = teamsData[teamKey] as Map<String, dynamic>?;
        final players = teamInfo?['players'] as List<dynamic>? ?? teamInfo?['members'] as List<dynamic>? ?? [];

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
                if (teamInfo?['round'] != null || teamInfo?['module'] != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    '${s.tr('Round', 'الجولة')} ${teamInfo?['round'] ?? '?'} - ${teamInfo?['module'] ?? '?'}',
                    style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context)),
                  ),
                ],
                if (players.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  // Current team leader + remove (tap a member below to set).
                  Builder(builder: (context) {
                    final teamId = '${index + 1}';
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
                      final name = p is String ? p : (p as Map<String, dynamic>)['name']?.toString() ?? 'Unknown';
                      final teamId = '${index + 1}';
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

// ---- Shocks Tab ----
class _ShocksTab extends StatefulWidget {
  final List<Shock> shocks;
  final Future<void> Function(String) onTrigger;
  final FacilitatorRepository repo;
  const _ShocksTab({required this.shocks, required this.onTrigger, required this.repo});

  @override
  State<_ShocksTab> createState() => _ShocksTabState();
}

class _ShocksTabState extends State<_ShocksTab> {
  final _nameC = TextEditingController();
  final _descC = TextEditingController();
  final _hintC = TextEditingController();
  final _durationC = TextEditingController(text: '30');
  String _category = 'economic';
  String _severity = 'medium';
  bool _sending = false;

  List<Map<String, dynamic>> _active = [];
  List<Map<String, dynamic>> _history = [];

  static const _categories = ['economic', 'regulatory', 'competitive', 'operational'];
  static const _severities = ['low', 'medium', 'high', 'critical'];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  void dispose() {
    _nameC.dispose();
    _descC.dispose();
    _hintC.dispose();
    _durationC.dispose();
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

  Future<void> _triggerCustom() async {
    if (_nameC.text.trim().isEmpty || _descC.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and description are required')));
      return;
    }
    setState(() => _sending = true);
    try {
      await widget.repo.triggerCustomShock(
        name: _nameC.text.trim(),
        description: _descC.text.trim(),
        category: _category,
        severity: _severity,
        durationMinutes: int.tryParse(_durationC.text.trim()),
        hint: _hintC.text.trim().isEmpty ? null : _hintC.text.trim(),
      );
      _nameC.clear(); _descC.clear(); _hintC.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Custom shock triggered!')));
      }
      await _refresh();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not trigger custom shock')));
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _clearAll() async {
    final ok = await widget.repo.clearAllShocks();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(ok ? 'All shocks cleared' : 'Clear not supported by server')));
    }
    await _refresh();
  }

  Future<void> _dismissOne(Map<String, dynamic> shock) async {
    final id = (shock['id'] ?? shock['instanceId'] ?? shock['shockInstanceId'])?.toString();
    if (id == null || id.isEmpty) return;
    final ok = await widget.repo.dismissShock(id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(ok ? 'Shock dismissed' : 'Could not dismiss shock')));
    }
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
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Custom shock builder ──
          GlassCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Icon(Icons.add_circle_outline_rounded, size: 18, color: AppColors.primaryLight),
                  const SizedBox(width: 8),
                  Text('Create Custom Shock', style: Theme.of(context).textTheme.titleMedium),
                ]),
                const SizedBox(height: 12),
                TextField(controller: _nameC, decoration: const InputDecoration(
                    labelText: 'Name', isDense: true, border: OutlineInputBorder())),
                const SizedBox(height: 10),
                TextField(controller: _descC, maxLines: 2, decoration: const InputDecoration(
                    labelText: 'Describe the market event…', isDense: true, border: OutlineInputBorder())),
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(child: DropdownButtonFormField<String>(
                    initialValue: _category,
                    isDense: true,
                    decoration: const InputDecoration(labelText: 'Category', isDense: true, border: OutlineInputBorder()),
                    items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (v) => setState(() => _category = v ?? _category),
                  )),
                  const SizedBox(width: 10),
                  Expanded(child: DropdownButtonFormField<String>(
                    initialValue: _severity,
                    isDense: true,
                    decoration: const InputDecoration(labelText: 'Severity', isDense: true, border: OutlineInputBorder()),
                    items: _severities.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                    onChanged: (v) => setState(() => _severity = v ?? _severity),
                  )),
                ]),
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(child: TextField(controller: _durationC, keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Duration (min)', isDense: true, border: OutlineInputBorder()))),
                  const SizedBox(width: 10),
                  Expanded(flex: 2, child: TextField(controller: _hintC,
                    decoration: const InputDecoration(labelText: 'Hint for teams (optional)', isDense: true, border: OutlineInputBorder()))),
                ]),
                const SizedBox(height: 12),
                SizedBox(width: double.infinity, child: ElevatedButton.icon(
                  onPressed: _sending ? null : _triggerCustom,
                  icon: _sending
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.bolt_rounded, size: 18),
                  label: const Text('Trigger Custom Shock'),
                )),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Active shocks ──
          Row(children: [
            Text('Active Shocks', style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            if (_active.isNotEmpty)
              TextButton.icon(
                onPressed: _clearAll,
                icon: const Icon(Icons.clear_all_rounded, size: 16),
                label: const Text('Clear all'),
                style: TextButton.styleFrom(foregroundColor: AppColors.dangerLight),
              ),
          ]),
          const SizedBox(height: 8),
          if (_active.isEmpty)
            Text('No active shocks', style: TextStyle(color: AppColors.textTertiary(context)))
          else
            ..._active.map((s) => _activeCard(s)),

          const SizedBox(height: 20),

          // ── Predefined shocks ──
          Text('Predefined Shocks', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (widget.shocks.isEmpty)
            Text('Loading shocks…', style: TextStyle(color: AppColors.textTertiary(context)))
          else
            ...widget.shocks.map(_predefinedCard),

          // ── History ──
          if (_history.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text('Shock History', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ..._history.take(20).map((s) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(children: [
                const Icon(Icons.history_rounded, size: 14),
                const SizedBox(width: 8),
                Expanded(child: Text((s['name'] ?? s['shockId'] ?? 'Shock').toString(),
                    style: Theme.of(context).textTheme.bodySmall)),
              ]),
            )),
          ],
        ],
      ),
    );
  }

  Widget _activeCard(Map<String, dynamic> s) {
    final sev = (s['severity'] ?? 'medium').toString();
    final c = _sevColor(sev);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassCard(
        padding: const EdgeInsets.all(14),
        child: Row(children: [
          Icon(Icons.flash_on_rounded, color: c, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text((s['name'] ?? 'Shock').toString(), style: Theme.of(context).textTheme.titleSmall),
            if (s['description'] != null)
              Text(s['description'].toString(),
                  maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall),
          ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: c.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
            child: Text(sev.toUpperCase(), style: TextStyle(fontSize: 10, color: c, fontWeight: FontWeight.w600)),
          ),
          // Dismiss this single shock (reverts its Excel impact)
          IconButton(
            onPressed: () => _dismissOne(s),
            icon: const Icon(Icons.close_rounded, size: 18),
            color: AppColors.dangerLight,
            tooltip: 'Dismiss',
            visualDensity: VisualDensity.compact,
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.only(left: 8),
          ),
        ]),
      ),
    );
  }

  Widget _predefinedCard(Shock shock) {
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
              onPressed: () async { await widget.onTrigger(shock.id); await _refresh(); },
              style: ElevatedButton.styleFrom(
                backgroundColor: shock.severityColor,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                minimumSize: Size.zero,
              ),
              child: const Text('Trigger', style: TextStyle(fontSize: 12)),
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
    show ? await widget.repo.showTimerOverlay() : await widget.repo.hideTimerOverlay();
    _snack(show
        ? s.tr('Timer overlay shown on participant screens', 'تم عرض المؤقّت على شاشات المشاركين')
        : s.tr('Timer overlay hidden', 'تم إخفاء المؤقّت'));
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
                    Text(s.tr('Show or hide the countdown on every participant screen.',
                        'إظهار أو إخفاء العدّ التنازلي على شاشات جميع المشاركين.'),
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
          ],
        ),
      );
    });
  }
}

// ---- Education Tab ----
// The 11 unlockable education modules (id → label), matching the website's
// EducationAdmin grid. Ids are intentionally non-sequential (5 and 8 are absent).
const List<(int, String, String)> _eduModules = [
  (1, 'Financial Primer', 'تمهيد مالي'),
  (3, 'Financial Statements', 'القوائم المالية'),
  (4, 'Financial Analysis', 'التحليل المالي'),
  (11, 'Break-Even Analysis', 'تحليل نقطة التعادل'),
  (12, 'Capital Budgeting', 'الموازنة الرأسمالية'),
  (6, 'Budgeting & Planning', 'الموازنة والتخطيط'),
  (7, 'Reporting Standards', 'معايير التقارير'),
  (2, 'Sector Comparison', 'مقارنة القطاعات'),
  (9, 'Compliance', 'الامتثال'),
  (10, 'Auditing', 'التدقيق'),
  (13, 'Simulation', 'المحاكاة'),
];

class _EducationTab extends ConsumerStatefulWidget {
  final AsyncValue<GameState> gameState;
  final Future<void> Function(String, bool) onToggle;
  const _EducationTab({required this.gameState, required this.onToggle});

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
              final isOn = unlocked.contains(m.$1);
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(children: [
                    Icon(Icons.school_rounded, size: 20,
                        color: isOn ? AppColors.secondaryLight : AppColors.textTertiary(context)),
                    const SizedBox(width: 12),
                    Expanded(child: Text(s.tr(m.$2, m.$3), style: Theme.of(context).textTheme.bodyLarge)),
                    Switch(
                      value: isOn,
                      onChanged: _busy ? null : (v) => _run((r) => r.toggleEducationModule(m.$1, v)),
                      activeTrackColor: AppColors.secondaryLight,
                    ),
                  ]),
                ),
              );
            }),
            const SizedBox(height: 12),
            // Other education controls (gov education, retry)
            _eduRow(context, s.tr('Government Education', 'التعليم الحكومي'), gs.govEducationUnlocked,
                (v) => widget.onToggle('govEducation', v)),
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

// ---- Cohorts Tab ----
class _CohortsTab extends ConsumerStatefulWidget {
  final FacilitatorRepository repo;
  const _CohortsTab({required this.repo});
  @override
  ConsumerState<_CohortsTab> createState() => _CohortsTabState();
}

class _CohortsTabState extends ConsumerState<_CohortsTab> {
  List<Map<String, dynamic>> _cohorts = [];
  bool _loading = true;
  bool _busy = false;
  final _subdomain = TextEditingController();
  final _displayName = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _subdomain.dispose();
    _displayName.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final cohorts = await widget.repo.fetchCohorts();
    if (mounted) setState(() { _cohorts = cohorts; _loading = false; });
  }

  Future<void> _create() async {
    final sub = _subdomain.text.trim();
    final name = _displayName.text.trim();
    if (sub.isEmpty || name.isEmpty) return;
    setState(() => _busy = true);
    final res = await widget.repo.createCohort(sub, name);
    _subdomain.clear();
    _displayName.clear();
    await _load();
    if (mounted) {
      setState(() => _busy = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(res['success'] == true ? 'Cohort created' : (res['error']?.toString() ?? 'Could not create'))));
    }
  }

  Future<void> _switch(String url) async {
    final api = ref.read(apiClientProvider);
    api.setBaseHost(url);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cohort_base_url', url);
    // Refresh data against the newly selected cohort host.
    ref.read(gameStateProvider.notifier).fetchGameState();
    ref.read(teamProvider.notifier).fetchTeams();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Switched to $url')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    if (_loading) return const Center(child: CircularProgressIndicator());
    final currentHost = ref.read(apiClientProvider).baseUrl;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(children: [
            const Icon(Icons.dns_rounded, size: 18, color: AppColors.primaryLight),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(s.tr('Current host', 'المضيف الحالي'),
                  style: TextStyle(fontSize: 11, color: AppColors.textTertiary(context))),
              Text(currentHost, style: GoogleFonts.jetBrainsMono(fontSize: 12)),
            ])),
          ]),
        ),
        const SizedBox(height: 16),
        Text(s.tr('Cohorts', 'المجموعات'), style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        if (_cohorts.isEmpty)
          Text(s.tr('No cohorts yet', 'لا توجد مجموعات بعد'),
              style: TextStyle(color: AppColors.textTertiary(context)))
        else
          ..._cohorts.map((c) {
            final url = (c['url'] ?? '').toString();
            final active = c['isActive'] != false;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text((c['displayName'] ?? c['subdomain'] ?? '').toString(),
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    Text(url, style: GoogleFonts.jetBrainsMono(fontSize: 11, color: AppColors.textTertiary(context))),
                  ])),
                  TextButton(
                    onPressed: (_busy || url.isEmpty) ? null : () => _switch(url),
                    child: Text(active ? s.tr('Switch', 'تبديل') : s.tr('Inactive', 'غير نشط')),
                  ),
                ]),
              ),
            );
          }),
        const SizedBox(height: 16),
        Text(s.tr('Create cohort', 'إنشاء مجموعة'), style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        GlassCard(
          padding: const EdgeInsets.all(14),
          child: Column(children: [
            TextField(
              controller: _subdomain,
              decoration: InputDecoration(
                labelText: s.tr('Subdomain', 'النطاق الفرعي'),
                hintText: 'groupa',
                isDense: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _displayName,
              decoration: InputDecoration(
                labelText: s.tr('Display name', 'الاسم المعروض'),
                hintText: 'May Cohort',
                isDense: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _busy ? null : _create,
                icon: const Icon(Icons.add_rounded, size: 16),
                label: Text(s.tr('Create', 'إنشاء')),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
              ),
            ),
          ]),
        ),
      ],
    );
  }
}

// ---- Realism Tab ----
// The 12 finance-realism modules (flag → label) shown on team dashboards.
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

  Future<void> _generate() async {
    if (_busy) return;
    setState(() => _busy = true);
    final created = await widget.repo.createVouchers(count: 1, maxUses: 1);
    await _load();
    if (mounted) {
      setState(() => _busy = false);
      if (created.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Created code: ${created.first['code']}')));
      }
    }
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
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(code, style: GoogleFonts.jetBrainsMono(fontWeight: FontWeight.w700, fontSize: 15)),
                    Text('${v['label'] ?? ''}  ·  $used/$max ${s.tr('used', 'مستخدم')}${active ? '' : ' · ${s.tr('revoked', 'ملغى')}'}',
                        style: TextStyle(fontSize: 11, color: AppColors.textTertiary(context))),
                  ])),
                  IconButton(
                    onPressed: _busy ? null : () => _delete(v['id'].toString()),
                    icon: const Icon(Icons.delete_outline_rounded, size: 20),
                    color: AppColors.dangerLight,
                    visualDensity: VisualDensity.compact,
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

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final attempts = await widget.repo.fetchAssessmentAttempts();
    final gs = ref.read(gameStateProvider).valueOrNull;
    if (mounted) {
      setState(() {
        _attempts = attempts;
        _loading = false;
        if (gs != null) {
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
        Row(children: [
          Expanded(child: _mandateCard(context, s, s.tr('Mandate Pre', 'إلزام القبلي'), _preMandated, (v) async {
            setState(() => _preMandated = v);
            await widget.repo.setAssessmentMandate('pre', v);
          })),
          const SizedBox(width: 10),
          Expanded(child: _mandateCard(context, s, s.tr('Mandate Post', 'إلزام البعدي'), _postMandated, (v) async {
            setState(() => _postMandated = v);
            await widget.repo.setAssessmentMandate('post', v);
          })),
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

  Widget _mandateCard(BuildContext context, AppStrings s, String label, bool value, ValueChanged<bool> onChanged) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(children: [
        Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
        Switch(value: value, onChanged: onChanged, activeTrackColor: AppColors.secondaryLight),
      ]),
    );
  }
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

// ---- QR Code Tab ----
class _QrCodeTab extends StatelessWidget {
  final FacilitatorRepository repo;
  const _QrCodeTab({required this.repo});

  Future<void> _overlay(BuildContext context, bool show) async {
    try {
      show ? await repo.showQr() : await repo.hideQr();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(show ? 'QR overlay shown on participant screens' : 'QR overlay removed from all screens'),
          backgroundColor: AppColors.secondary,
          behavior: SnackBarBehavior.floating,
        ));
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Overlay control failed'), backgroundColor: AppColors.danger));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final joinUrl = '${AppConstants.baseUrl}/join';

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text('Share Access', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Scan to join the simulation', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 16),
            // Live QR overlay broadcast controls (push the QR to participant screens).
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.cast_rounded, size: 18, color: AppColors.primaryLight),
                    const SizedBox(width: 8),
                    Text('Live QR Overlay', style: Theme.of(context).textTheme.titleMedium),
                  ]),
                  const SizedBox(height: 4),
                  Text('Show or hide the join QR on every participant screen.',
                      style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(child: ElevatedButton.icon(
                      onPressed: () => _overlay(context, true),
                      icon: const Icon(Icons.visibility_rounded, size: 16),
                      label: const Text('Show overlay'),
                    )),
                    const SizedBox(width: 10),
                    Expanded(child: OutlinedButton.icon(
                      onPressed: () => _overlay(context, false),
                      icon: const Icon(Icons.visibility_off_rounded, size: 16),
                      label: const Text('Hide overlay'),
                    )),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Manage the 6 placeholder QR destinations (assessment, survey, LinkedIn, info).
            _QrPlaceholdersCard(repo: repo),
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
                Expanded(child: Text(joinUrl, style: GoogleFonts.jetBrainsMono(fontSize: 12, color: AppColors.primaryLight))),
              ]),
            ),
            const SizedBox(height: 24),
            Text('Team QR Codes', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12, runSpacing: 12,
              children: List.generate(AppConstants.maxTeams, (i) {
                final teamUrl = '${AppConstants.baseUrl}/join?team=${i + 1}';
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
                    Text('Team ${i + 1}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
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
  Map<String, dynamic>? _teamsStatus;
  Map<String, dynamic>? _allDecisions;
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
      final results = await Future.wait([
        widget.repo.getTeamsStatus(),
        widget.repo.getAllDecisions(),
      ]);
      if (mounted) {
        setState(() {
          _teamsStatus = results[0];
          _allDecisions = results[1];
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

  double _parseDouble(dynamic value) {
    if (value == null || value.toString() == 'NaN') return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
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

    final teamsData = _teamsStatus?['data'] as Map<String, dynamic>? ?? _teamsStatus ?? {};
    final decisionsData = _allDecisions?['data'] as Map<String, dynamic>? ?? _allDecisions ?? {};

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Performance Heatmap
          Text('Team Performance', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          GlassCard(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _buildPerformanceTable(context, teamsData),
            ),
          ),

          const SizedBox(height: 24),

          // Decisions Overview
          Text('Decisions Overview', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          ...List.generate(AppConstants.maxTeams, (i) {
            final teamKey = 'Team ${i + 1}';
            final color = AppColors.teamColor(i);
            final teamDecisions = decisionsData[teamKey] as Map<String, dynamic>? ?? {};

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

  Widget _buildPerformanceTable(BuildContext context, Map<String, dynamic> teamsData) {
    final metrics = ['Score', 'Revenue', 'Net Income', 'Assets'];
    final metricKeys = ['score', 'revenue', 'netIncome', 'totalAssets'];

    // Collect values per metric for relative coloring
    final teamValues = <String, List<double>>{};
    for (final key in metricKeys) {
      teamValues[key] = [];
      for (int i = 0; i < AppConstants.maxTeams; i++) {
        final teamKey = 'Team ${i + 1}';
        final team = teamsData[teamKey] as Map<String, dynamic>? ?? {};
        teamValues[key]!.add(_parseDouble(team[key]));
      }
    }

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
      rows: List.generate(metrics.length, (mIdx) {
        final key = metricKeys[mIdx];
        final values = teamValues[key]!;
        final maxVal = values.isEmpty ? 1.0 : values.reduce((a, b) => a > b ? a : b);
        final minVal = values.isEmpty ? 0.0 : values.reduce((a, b) => a < b ? a : b);
        final range = maxVal - minVal;

        return DataRow(cells: [
          DataCell(Text(metrics[mIdx], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
          ...List.generate(AppConstants.maxTeams, (tIdx) {
            final val = values[tIdx];
            final ratio = range > 0 ? (val - minVal) / range : 0.5;
            final cellColor = Color.lerp(AppColors.dangerLight, AppColors.secondaryLight, ratio)!.withValues(alpha: 0.15);
            return DataCell(Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: cellColor, borderRadius: BorderRadius.circular(4)),
              child: Text(
                val.abs() > 999999 ? '${(val / 1000000).toStringAsFixed(1)}M' :
                val.abs() > 999 ? '${(val / 1000).toStringAsFixed(1)}K' :
                val.toStringAsFixed(0),
                style: GoogleFonts.jetBrainsMono(fontSize: 11),
              ),
            ));
          }),
        ]);
      }),
    );
  }
}

class _ExpandableDecisionCard extends StatefulWidget {
  final String teamName;
  final Color color;
  final Map<String, dynamic> decisions;
  const _ExpandableDecisionCard({required this.teamName, required this.color, required this.decisions});

  @override
  State<_ExpandableDecisionCard> createState() => _ExpandableDecisionCardState();
}

class _ExpandableDecisionCardState extends State<_ExpandableDecisionCard> {
  bool _expanded = false;

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
                      final moduleData = widget.decisions[module];
                      if (moduleData == null) return const SizedBox.shrink();
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
                            if (moduleData is Map)
                              ...moduleData.entries.map((e) => Padding(
                                padding: const EdgeInsets.only(left: 8, top: 2),
                                child: Text('${e.key}: ${e.value}', style: TextStyle(fontSize: 12, color: AppColors.textSecondary(context))),
                              ))
                            else if (moduleData is List)
                              ...moduleData.map((item) => Padding(
                                padding: const EdgeInsets.only(left: 8, top: 2),
                                child: Text('$item', style: TextStyle(fontSize: 12, color: AppColors.textSecondary(context))),
                              ))
                            else
                              Padding(
                                padding: const EdgeInsets.only(left: 8, top: 2),
                                child: Text('$moduleData', style: TextStyle(fontSize: 12, color: AppColors.textSecondary(context))),
                              ),
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
      buffer.writeln('Team,Score,Net Income,Total Assets,Cash Flow');
      for (final entry in data) {
        if (entry is Map<String, dynamic>) {
          buffer.writeln(
            '${entry['teamName'] ?? entry['teamId'] ?? ''},'
            '${entry['score'] ?? ''},'
            '${entry['netIncome'] ?? ''},'
            '${entry['totalAssets'] ?? ''},'
            '${entry['cashFlow'] ?? ''}'
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
      final teamsStatus = await widget.repo.getTeamsStatus();
      final teamsData = teamsStatus['data'] as Map<String, dynamic>? ?? teamsStatus;
      final buffer = StringBuffer();
      buffer.writeln('=== TEAM REPORTS ===');
      buffer.writeln('Generated: ${DateTime.now().toIso8601String()}');
      buffer.writeln('');

      for (int i = 0; i < AppConstants.maxTeams; i++) {
        final teamKey = 'Team ${i + 1}';
        final team = teamsData[teamKey] as Map<String, dynamic>? ?? {};
        buffer.writeln('--- $teamKey ---');
        for (final entry in team.entries) {
          buffer.writeln('  ${entry.key}: ${entry.value}');
        }
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
      final decisions = await widget.repo.getAllDecisions();
      final data = decisions['data'] as Map<String, dynamic>? ?? decisions;
      final buffer = StringBuffer();
      buffer.writeln('=== ALL DECISIONS ===');
      buffer.writeln('Generated: ${DateTime.now().toIso8601String()}');
      buffer.writeln('');

      for (final entry in data.entries) {
        buffer.writeln('--- ${entry.key} ---');
        if (entry.value is Map) {
          for (final sub in (entry.value as Map).entries) {
            buffer.writeln('  ${sub.key}: ${sub.value}');
          }
        } else {
          buffer.writeln('  ${entry.value}');
        }
        buffer.writeln('');
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

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Export Data', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text('Data will be copied to clipboard', style: TextStyle(fontSize: 13, color: AppColors.textTertiary(context))),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.count(
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
          ),
        ],
      ),
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

  Future<void> _toggleScenarioResults(AppStrings s, bool val) async {
    setState(() => _scenarioResultsVisible = val);
    await widget.repo.setScenarioResultsVisible(val);
    if (!mounted) return;
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
        content: Text(s.tr('Clear all education progress for all teams? This cannot be undone.',
            'مسح كل تقدّم التعليم لجميع الفرق؟ لا يمكن التراجع عن هذا الإجراء.')),
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
                Text(s.tr('Permanently clears education progress for every team.',
                    'يمسح نهائيًا تقدّم التعليم لكل فريق.'),
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
    {'name': 'Excel Connection', 'endpoint': '/excel/connection-status', 'icon': Icons.table_chart_rounded},
    {'name': 'Timer Status', 'endpoint': '/timer/status', 'icon': Icons.timer_rounded},
    {'name': 'Game State', 'endpoint': '/facilitator/status', 'icon': Icons.gamepad_rounded},
    {'name': 'Shocks', 'endpoint': '/shocks/predefined', 'icon': Icons.flash_on_rounded},
    {'name': 'Education', 'endpoint': '/education-modules/status', 'icon': Icons.school_rounded},
    {'name': 'Site Access', 'endpoint': '/site-access/check', 'icon': Icons.public_rounded},
  ];

  Future<void> _runAllChecks() async {
    setState(() {
      _isRunning = true;
      _checks = _checkDefinitions.map((d) => {...d, 'status': 'running', 'time': 0}).toList();
    });

    for (int i = 0; i < _checks.length; i++) {
      final start = DateTime.now();
      try {
        await widget.repo.runHealthCheck(_checks[i]['endpoint'] as String);
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

/// Facilitator toggle for RESEARCH_MODE (DBA study). Mirrors the website's
/// ResearchModeToggle — when on, learners are offered the research flow.
class _ResearchModeCard extends ConsumerStatefulWidget {
  const _ResearchModeCard();

  @override
  ConsumerState<_ResearchModeCard> createState() => _ResearchModeCardState();
}

class _ResearchModeCardState extends ConsumerState<_ResearchModeCard> {
  bool _enabled = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final res = await ref.read(apiClientProvider).get(ApiEndpoints.researchConfig);
      if (mounted) setState(() { _enabled = res['enabled'] == true; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _toggle(bool value) async {
    setState(() => _enabled = value);
    try {
      await ref.read(apiClientProvider).post(ApiEndpoints.researchMode, data: {'enabled': value});
    } catch (_) {
      if (mounted) setState(() => _enabled = !value); // revert on failure
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(children: [
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
            Text(s.tr('Research Mode (DBA)', 'وضع البحث'), style: Theme.of(context).textTheme.titleMedium),
            Text(s.tr('Offer consent & questionnaires to learners', 'عرض الموافقة والاستبيانات على المتعلمين'),
                style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context))),
          ],
        )),
        _loading
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
            : Switch(value: _enabled, activeThumbColor: AppColors.purple, onChanged: _toggle),
      ]),
    );
  }
}
