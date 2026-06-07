import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/i18n/app_strings.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/utils/constants.dart';
import '../../../data/models/decision.dart';
import '../../../providers/repository_providers.dart';
import '../../../providers/team_provider.dart';
import '../../../providers/socket_provider.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/connection_badge.dart';

class LobbyScreen extends ConsumerStatefulWidget {
  const LobbyScreen({super.key});

  @override
  ConsumerState<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends ConsumerState<LobbyScreen> {
  final _nameController = TextEditingController();
  String? _nameError;
  bool _lobbyOpen = true;
  bool _joining = false;
  Timer? _lobbyPollTimer;

  // Round Recaps state
  bool _recapsExpanded = false;
  int? _selectedRecapRound; // null = "All Rounds"
  List<Decision> _recapDecisions = [];
  bool _recapsLoading = false;

  static const _teamIcons = [
    Icons.diamond_rounded,
    Icons.castle_rounded,
    Icons.landscape_rounded,
    Icons.water_rounded,
    Icons.park_rounded,
    Icons.shield_rounded,
    Icons.star_rounded,
  ];

  // City-themed icons (parity with the website's per-city team icons), with an
  // index-based fallback for non-city team names.
  IconData _iconForTeam(String teamName, int index) {
    final n = teamName.toLowerCase();
    if (n.contains('riyadh') || n.contains('الرياض')) return Icons.workspace_premium_rounded; // crown
    if (n.contains('jeddah') || n.contains('jiddah') || n.contains('جدة')) return Icons.waves_rounded;
    if (n.contains('dammam') || n.contains('الدمام')) return Icons.oil_barrel_rounded;
    if (n.contains('makkah') || n.contains('mecca') || n.contains('مكة')) return Icons.mosque_rounded;
    if (n.contains('madinah') || n.contains('medina') || n.contains('المدينة')) return Icons.mosque_rounded;
    if (n.contains('khobar') || n.contains('الخبر')) return Icons.anchor_rounded;
    if (n.contains('abha') || n.contains('أبها')) return Icons.terrain_rounded;
    if (n.contains('tabuk') || n.contains('تبوك')) return Icons.landscape_rounded;
    return _teamIcons[index % _teamIcons.length];
  }

  StreamSubscription<dynamic>? _facilitatorActionSub;

  @override
  void initState() {
    super.initState();
    ref.read(socketManagerProvider).connect();
    Future(() => ref.read(teamProvider.notifier).fetchTeams());
    _checkLobbyStatus();
    _lobbyPollTimer = Timer.periodic(const Duration(seconds: 5), (_) => _checkLobbyStatus());

    // Listen for instant lobby_opened broadcast from facilitator via Socket.IO
    _facilitatorActionSub = ref
        .read(socketManagerProvider)
        .onEvent('facilitator:action')
        .listen((payload) {
      if (payload is Map && payload['action'] == 'lobby_opened') {
        _checkLobbyStatus();
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lobbyPollTimer?.cancel();
    _facilitatorActionSub?.cancel();
    super.dispose();
  }

  Future<void> _checkLobbyStatus() async {
    try {
      final api = ref.read(apiClientProvider);
      final res = await api.get(ApiEndpoints.facilitatorLobbyStatus);
      if (mounted) {
        setState(() => _lobbyOpen = res['lobbyOpen'] == true);
      }
    } catch (_) {
      // If endpoint fails, assume lobby is open (backwards compat)
      if (mounted) setState(() => _lobbyOpen = true);
    }
  }

  Future<void> _fetchRecapDecisions() async {
    final team = ref.read(teamProvider).selectedTeam;
    if (team == null) return;

    setState(() => _recapsLoading = true);
    try {
      final repo = ref.read(decisionRepositoryProvider);
      final decisions = await repo.fetchTeamDecisions(
        team.id,
        round: _selectedRecapRound,
      );
      if (mounted) {
        setState(() {
          _recapDecisions = decisions;
          _recapsLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _recapDecisions = [];
          _recapsLoading = false;
        });
      }
    }
  }

  Future<void> _freshStart() async {
    final team = ref.read(teamProvider).selectedTeam;
    if (team == null) return;
    final s = ref.read(stringsProvider);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E293B) : Colors.white,
        title: Text(s.tr('Fresh Start', 'بداية جديدة')),
        content: Text(s.tr(
            'Reset ${team.name} to Round 1 Financing?\n\nThis will clear all decisions and progress for this team. This action cannot be undone.',
            'إعادة تعيين ${team.name} إلى الجولة 1 التمويل؟\n\nسيؤدي ذلك إلى مسح جميع القرارات والتقدّم لهذا الفريق. لا يمكن التراجع عن هذا الإجراء.')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(s.tr('Cancel', 'إلغاء'))),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            child: Text(s.tr('Reset Team', 'إعادة تعيين الفريق')),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      final api = ref.read(apiClientProvider);
      await api.post('/facilitator/team-fresh-start', data: {'teamId': team.id});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(s.tr('${team.name} reset to Round 1', 'تمت إعادة تعيين ${team.name} إلى الجولة 1')),
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

  Future<void> _joinTeam() async {
    final s = ref.read(stringsProvider);
    final name = _nameController.text.trim();
    if (name.length < 2) {
      setState(() => _nameError = s.tr('Name must be at least 2 characters', 'يجب أن يتكوّن الاسم من حرفين على الأقل'));
      return;
    }
    if (name.length > 30) {
      setState(() => _nameError = s.tr('Name must be under 30 characters', 'يجب أن يكون الاسم أقل من 30 حرفًا'));
      return;
    }
    setState(() { _nameError = null; _joining = true; });

    final team = ref.read(teamProvider).selectedTeam;
    if (team == null) { setState(() => _joining = false); return; }

    HapticFeedback.mediumImpact();

    final api = ref.read(apiClientProvider);
    final prefs = await SharedPreferences.getInstance();

    // Persist the joined name so the team-leader gate can tell if "I" am leader.
    await prefs.setString(AppConstants.playerNameKey, name);

    // Store the current reset epoch so /home can detect a stale session later.
    try {
      final epochRes = await api.get(ApiEndpoints.facilitatorResetEpoch);
      final epoch = epochRes['epoch']?.toString() ?? epochRes['resetEpoch']?.toString();
      if (epoch != null && epoch.isNotEmpty) await prefs.setString('reset_epoch', epoch);
    } catch (_) {/* non-critical */}

    // STEP 1: Register sign-in. We AWAIT this (not fire-and-forget) because the
    // server mints a team-member token that decision-write endpoints require, and
    // it lets us reject a name already taken on this team.
    try {
      final reg = await api.post(ApiEndpoints.facilitatorRegisterSignin, data: {
        'teamId': team.id,
        'playerName': name,
      });
      final token = reg['token'];
      if (token is String && token.isNotEmpty) {
        await prefs.setString(AppConstants.teamMemberTokenKey, token);
        api.setAuthToken(token); // carry as Bearer on subsequent decision writes
        // Honor a server-sanitized name if it changed ours.
        final sanitized = reg['playerName'];
        if (sanitized is String && sanitized.isNotEmpty && sanitized != name) {
          await prefs.setString(AppConstants.playerNameKey, sanitized);
        }
      } else if (reg['success'] == false || reg['error'] != null) {
        // Hard rejection (e.g. duplicate name on this team) — abort the join so
        // the user can pick a different name.
        if (mounted) {
          setState(() {
            _joining = false;
            _nameError = (reg['error'] as String?) ??
                s.tr('That name is already taken on this team. Please choose another.',
                    'هذا الاسم مستخدم بالفعل في هذا الفريق. الرجاء اختيار اسم آخر.');
          });
        }
        return;
      }
      // else: older backend without a token — proceed leniently.
    } catch (_) {
      // Network/5xx — don't hard-block the join over a transient failure.
    }

    // STEP 2: Reconnect socket with teamId and join team room
    ref.read(socketManagerProvider).connect(teamId: team.id);
    ref.read(socketManagerProvider).joinTeam(team.id);

    // STEP 3: Fetch team progression for late joiner sync (like website)
    String targetModule = 'financing';
    int currentRound = 1;
    try {
      final progressionRes = await api.get(
        '${ApiEndpoints.teamProgression}/${Uri.encodeComponent(team.id)}',
      );
      if (progressionRes['currentModule'] != null) {
        targetModule = progressionRes['currentModule'] as String;
      }
    } catch (_) {
      // Default to financing if API fails
    }

    // Fetch current round from game state
    try {
      final roundRes = await api.get(ApiEndpoints.roundState);
      if (roundRes['roundNum'] != null) {
        currentRound = (roundRes['roundNum'] as num).toInt();
      }
    } catch (_) {
      // Default to round 1
    }

    // Navigate to /home immediately (like website navigates to /home)
    if (mounted) {
      setState(() => _joining = false);
      context.go('/home');
    }

    // STEP 4: Background initialization (non-blocking, like website's setTimeout)
    // Unlock decisions with correct module/round
    api.post(ApiEndpoints.decisionsUnlock, data: {
      'teamId': team.id,
      'module': targetModule,
      'round': currentRound,
    }).catchError((_) => <String, dynamic>{});

    // Start gamification
    api.post(ApiEndpoints.gamificationStart, data: {
      'teamId': team.id,
    }).catchError((_) => <String, dynamic>{});
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final teamState = ref.watch(teamProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      onPressed: () => context.pop(),
                    ),
                    const Spacer(),
                    Text(s.tr('Team Lobby', 'ردهة الفرق'), style: Theme.of(context).textTheme.headlineMedium),
                    const Spacer(),
                    const ConnectionStatusBadge(),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Player name input
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GlassCard(
                  padding: const EdgeInsets.all(16),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.06),
                      Colors.transparent,
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.tr('Your Name', 'اسمك'), style: Theme.of(context).textTheme.labelMedium),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: s.tr('Enter your name...', 'أدخل اسمك...'),
                          prefixIcon: const Icon(Icons.person_rounded, size: 20),
                          errorText: _nameError,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                        textCapitalization: TextCapitalization.words,
                        onChanged: (_) {
                          if (_nameError != null) setState(() => _nameError = null);
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Section title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(s.tr('Select Your Team', 'اختر فريقك'), style: Theme.of(context).textTheme.titleMedium),
                    const Spacer(),
                    if (teamState.teams.isNotEmpty)
                      Text(
                        s.tr('${teamState.teams.length} teams', '${teamState.teams.length} فرق'),
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.textTertiary(context) : AppColors.lightTextTertiary,
                        ),
                      ),
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded, size: 20),
                      onPressed: () => ref.read(teamProvider.notifier).fetchTeams(),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Team Grid + Round Recaps + Education Links
              Expanded(
                child: teamState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : teamState.error != null
                        ? _ErrorView(
                            error: teamState.error!,
                            onRetry: () => ref.read(teamProvider.notifier).fetchTeams(),
                          )
                        : teamState.teams.isEmpty
                            ? _EmptyView(
                                onRetry: () => ref.read(teamProvider.notifier).fetchTeams(),
                              )
                            : ListView(
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                children: [
                                  // Team Grid (non-scrollable inside ListView)
                                  // Block team selection until the facilitator
                                  // opens the lobby (parity with the website).
                                  IgnorePointer(
                                    ignoring: !_lobbyOpen,
                                    child: Opacity(
                                      opacity: _lobbyOpen ? 1.0 : 0.4,
                                      child: GridView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 12,
                                      crossAxisSpacing: 12,
                                      childAspectRatio: 0.95,
                                    ),
                                    itemCount: teamState.teams.length,
                                    itemBuilder: (context, index) {
                                      final team = teamState.teams[index];
                                      final isSelected = teamState.selectedTeam?.id == team.id;
                                      final teamColor = AppColors.teamColor(index);
                                      final teamIcon = _iconForTeam(team.name, index);

                                      return _TeamCard(
                                        team: team,
                                        index: index,
                                        isSelected: isSelected,
                                        teamColor: teamColor,
                                        teamIcon: teamIcon,
                                        onTap: () {
                                          HapticFeedback.mediumImpact();
                                          ref.read(teamProvider.notifier).selectTeam(team);
                                        },
                                      );
                                    },
                                      ),
                                    ),
                                  ),

                                  // Round Recaps Section (only when team selected)
                                  if (teamState.selectedTeam != null) ...[
                                    const SizedBox(height: 16),
                                    _buildRoundRecapsSection(context, isDark),
                                  ],

                                  // Education Quick Links
                                  const SizedBox(height: 16),
                                  _buildEducationQuickLinks(context, isDark),
                                  const SizedBox(height: 16),
                                ],
                              ),
              ),

              // Lobby closed banner
              if (!_lobbyOpen)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.lock_clock_rounded, color: AppColors.accentLight, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          s.tr('Waiting for facilitator to open the lobby...', 'بانتظار فتح الميسّر للردهة...'),
                          style: TextStyle(fontSize: 13, color: AppColors.accentLight),
                        ),
                      ),
                    ],
                  ),
                ),

              // Join Button
              if (teamState.selectedTeam != null && _lobbyOpen)
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        (isDark ? AppColors.bgColor(context) : AppColors.lightBg).withValues(alpha: 0.0),
                        isDark ? AppColors.bgColor(context) : AppColors.lightBg,
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      // Fresh Start button
                      IconButton(
                        onPressed: _freshStart,
                        icon: const Icon(Icons.restart_alt_rounded),
                        tooltip: s.tr('Fresh Start', 'بداية جديدة'),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.danger.withValues(alpha: 0.1),
                          foregroundColor: AppColors.dangerLight,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GradientButton(
                          text: s.tr('Join ${teamState.selectedTeam!.name}', 'انضم إلى ${teamState.selectedTeam!.name}'),
                          icon: Icons.login_rounded,
                          isLoading: _joining,
                          width: double.infinity,
                          gradient: LinearGradient(
                            colors: [
                              AppColors.teamColor(teamState.selectedTeam!.teamNumber - 1),
                              AppColors.teamColor(teamState.selectedTeam!.teamNumber - 1).withValues(alpha: 0.8),
                            ],
                          ),
                          onPressed: _joining ? null : _joinTeam,
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
  Widget _buildRoundRecapsSection(BuildContext context, bool isDark) {
    final s = ref.watch(stringsProvider);
    return GlassCard(
      padding: const EdgeInsets.all(16),
      gradient: LinearGradient(
        colors: [
          AppColors.secondary.withValues(alpha: 0.06),
          Colors.transparent,
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row (tappable to expand/collapse)
          GestureDetector(
            onTap: () {
              setState(() => _recapsExpanded = !_recapsExpanded);
              if (_recapsExpanded && _recapDecisions.isEmpty) {
                _fetchRecapDecisions();
              }
            },
            child: Row(
              children: [
                Icon(Icons.history_rounded, size: 20,
                    color: AppColors.secondary),
                const SizedBox(width: 8),
                Text(s.tr('Round Recaps', 'ملخّصات الجولات'),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        )),
                const Spacer(),
                AnimatedRotation(
                  turns: _recapsExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(Icons.expand_more_rounded, size: 22,
                      color: AppColors.textTertiary(context)),
                ),
              ],
            ),
          ),

          // Expandable content
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                // Round selector dropdown
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: (isDark ? Colors.white : Colors.black)
                        .withValues(alpha: 0.05),
                    border: Border.all(
                      color: (isDark ? Colors.white : Colors.black)
                          .withValues(alpha: 0.1),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int?>(
                      value: _selectedRecapRound,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down_rounded),
                      style: Theme.of(context).textTheme.bodyMedium,
                      items: [
                        DropdownMenuItem(value: null, child: Text(s.tr('All Rounds', 'جميع الجولات'))),
                        DropdownMenuItem(value: 1, child: Text(s.tr('Round 1', 'الجولة 1'))),
                        DropdownMenuItem(value: 2, child: Text(s.tr('Round 2', 'الجولة 2'))),
                        DropdownMenuItem(value: 3, child: Text(s.tr('Round 3', 'الجولة 3'))),
                      ],
                      onChanged: (value) {
                        setState(() => _selectedRecapRound = value);
                        _fetchRecapDecisions();
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Decisions content
                if (_recapsLoading)
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  )
                else if (_recapDecisions.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        s.tr('No decisions yet', 'لا توجد قرارات بعد'),
                        style: TextStyle(
                          color: AppColors.textTertiary(context),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  )
                else
                  ..._buildDecisionsByModule(context, isDark),
              ],
            ),
            crossFadeState: _recapsExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDecisionsByModule(BuildContext context, bool isDark) {
    final s = ref.watch(stringsProvider);
    final modules = <String, List<Decision>>{};
    for (final d in _recapDecisions) {
      modules.putIfAbsent(d.module, () => []).add(d);
    }

    final moduleConfig = {
      'financing': (icon: Icons.account_balance_rounded, label: s.tr('Financing', 'التمويل')),
      'investing': (icon: Icons.trending_up_rounded, label: s.tr('Investing', 'الاستثمار')),
      'operating': (icon: Icons.settings_rounded, label: s.tr('Operating', 'التشغيل')),
    };

    final widgets = <Widget>[];
    for (final entry in modules.entries) {
      final config = moduleConfig[entry.key] ??
          (icon: Icons.receipt_long_rounded, label: entry.key);

      widgets.add(
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: (isDark ? Colors.white : Colors.black)
                .withValues(alpha: 0.03),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Module header
              Row(
                children: [
                  Icon(config.icon, size: 16, color: AppColors.secondary),
                  const SizedBox(width: 6),
                  Text(
                    config.label,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const Spacer(),
                  Text(
                    s.tr('${entry.value.length} decision${entry.value.length != 1 ? 's' : ''}',
                        '${entry.value.length} قرار'),
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textTertiary(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Decision items
              ...entry.value.map((d) => _buildDecisionItem(context, d, isDark)),
            ],
          ),
        ),
      );
    }
    return widgets;
  }

  Widget _buildDecisionItem(BuildContext context, Decision d, bool isDark) {
    final data = d.decisionData;
    final amounts = <String>[];
    for (final e in data.entries) {
      final val = e.value;
      if (val is num && val != 0) {
        amounts.add('${_formatKey(e.key)}: \$${_formatAmount(val.toDouble())}');
      } else if (val is String && val.isNotEmpty) {
        amounts.add('${_formatKey(e.key)}: $val');
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.textTertiary(context),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Round ${d.roundNum} - ${d.module.substring(0, 1).toUpperCase()}${d.module.substring(1)}',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
                if (amounts.isNotEmpty)
                  Text(
                    amounts.join(' | '),
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textTertiary(context),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatKey(String key) {
    // Convert camelCase to Title Case
    return key.replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
      (m) => '${m[1]} ${m[2]}',
    ).replaceFirst(key[0], key[0].toUpperCase());
  }

  String _formatAmount(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
    return value.toStringAsFixed(0);
  }

  Widget _buildEducationQuickLinks(BuildContext context, bool isDark) {
    final s = ref.watch(stringsProvider);
    return GlassCard(
      padding: const EdgeInsets.all(14),
      gradient: LinearGradient(
        colors: [
          AppColors.primary.withValues(alpha: 0.04),
          Colors.transparent,
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_stories_rounded, size: 18,
                  color: AppColors.primary),
              const SizedBox(width: 8),
              Text(s.tr('Education Quick Links', 'روابط تعليمية سريعة'),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      )),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _EducationChip(
                label: s.tr('Financial Education', 'التثقيف المالي'),
                icon: Icons.school_rounded,
                onTap: () => context.push('/education'),
              ),
              _EducationChip(
                label: s.tr('Break-Even', 'نقطة التعادل'),
                icon: Icons.calculate_rounded,
                onTap: () => context.push('/education/break-even'),
              ),
              _EducationChip(
                label: s.tr('Capital Budgeting', 'الموازنة الرأسمالية'),
                icon: Icons.account_balance_rounded,
                onTap: () => context.push('/education/capital-budgeting'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EducationChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _EducationChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.08),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppColors.primary
                      : AppColors.primary.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TeamCard extends ConsumerWidget {
  final dynamic team;
  final int index;
  final bool isSelected;
  final Color teamColor;
  final IconData teamIcon;
  final VoidCallback onTap;

  const _TeamCard({
    required this.team,
    required this.index,
    required this.isSelected,
    required this.teamColor,
    required this.teamIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? teamColor : teamColor.withValues(alpha: 0.15),
            width: isSelected ? 2 : 1,
          ),
          color: isSelected
              ? teamColor.withValues(alpha: 0.08)
              : Colors.white.withValues(alpha: Theme.of(context).brightness == Brightness.dark ? 0.04 : 0.6),
          boxShadow: isSelected
              ? [BoxShadow(color: teamColor.withValues(alpha: 0.2), blurRadius: 16, offset: const Offset(0, 4))]
              : null,
        ),
        child: Stack(
          children: [
            // Glow effect when selected
            if (isSelected)
              Positioned(
                top: -20, right: -20,
                child: Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [teamColor.withValues(alpha: 0.15), Colors.transparent],
                    ),
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Team icon
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 52, height: 52,
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? LinearGradient(colors: [teamColor, teamColor.withValues(alpha: 0.7)])
                          : null,
                      color: isSelected ? null : teamColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      teamIcon,
                      color: isSelected ? Colors.white : teamColor,
                      size: 26,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Team name
                  Text(
                    team.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),

                  // Status chips
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _StatusChip(
                        label: 'R${team.currentRound}',
                        color: teamColor,
                      ),
                      if (team.currentModule.isNotEmpty) ...[
                        const SizedBox(width: 4),
                        _StatusChip(
                          label: _moduleShort(team.currentModule),
                          color: team.isActive ? AppColors.secondaryLight : AppColors.textTertiary(context),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Selected indicator
                  if (isSelected)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: teamColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, color: teamColor, size: 14),
                          const SizedBox(width: 4),
                          Text(s.tr('Selected', 'محدّد'), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: teamColor)),
                        ],
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

  String _moduleShort(String module) {
    switch (module) {
      case 'financing': return 'FIN';
      case 'investing': return 'INV';
      case 'operating': return 'OPS';
      default: return module.length >= 3 ? module.substring(0, 3).toUpperCase() : module.toUpperCase();
    }
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}

class _ErrorView extends ConsumerWidget {
  final String error;
  final VoidCallback onRetry;
  const _ErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off_rounded, size: 56, color: AppColors.textTertiary(context)),
            const SizedBox(height: 16),
            Text(s.tr('Connection Error', 'خطأ في الاتصال'), style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(error, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center, maxLines: 3, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 20),
            ElevatedButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh_rounded, size: 18), label: Text(s.tr('Retry', 'إعادة المحاولة'))),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends ConsumerWidget {
  final VoidCallback onRetry;
  const _EmptyView({required this.onRetry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.groups_rounded, size: 56, color: AppColors.textTertiary(context)),
          const SizedBox(height: 16),
          Text(s.tr('No teams available', 'لا توجد فرق متاحة'), style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(s.tr('Ask the facilitator to set up teams', 'اطلب من الميسّر إعداد الفرق'), style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 20),
          ElevatedButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh_rounded, size: 18), label: Text(s.tr('Refresh', 'تحديث'))),
        ],
      ),
    );
  }
}
