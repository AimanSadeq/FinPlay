import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/i18n/app_strings.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/utils/constants.dart';
import '../../../providers/repository_providers.dart';
import '../../../providers/socket_provider.dart';
import '../../roles/team_roles.dart';

// Member recommendations (website MemberRecommendations, 909a3eb): in corporate mode every
// team member privately commits a recommended amount per scenario BEFORE the leader confirms.
//
//   GET  /api/recommendations/{teamId}?roundNum=&module=&playerName=   (team bearer)
//        -> { success, isLeader, scenarios: [{ scenarioId, count, submittedByMe, mine,
//             summary?: {n, median, min, max}, members?: [...] }] }
//   POST /api/recommendations { teamId, roundNum, module, scenarioId, playerName, amount,
//        rationale? }  (team bearer; 403 when the flag is off, 409 MODULE_LOCKED once confirmed)
//   socket 'recommendations:updated' { teamId, module, roundNum, scenarioId, count }
//
// Anti-anchoring: a member sees only the COUNT of teammates who recommended until they commit
// their own number; then the summary unlocks. The leader always sees the full synthesis.
// Gated by the facilitator's `memberRecommendationsEnabled` realism flag (GET /api/realism/status).
const String _recsPath = '/recommendations';
const String _signinsPath = '/facilitator/team-signins';

class RecSummary {
  final int n;
  final double median;
  final double min;
  final double max;
  const RecSummary(this.n, this.median, this.min, this.max);
}

class RecMember {
  final String playerName;
  final String? playerRole;
  final double amount;
  final String? rationale;
  const RecMember(this.playerName, this.playerRole, this.amount, this.rationale);
}

class RecScenario {
  final String scenarioId;
  final int count;
  final bool submittedByMe;
  final double? mineAmount;
  final String? mineRationale;
  final RecSummary? summary;
  final List<RecMember>? members;

  const RecScenario({
    required this.scenarioId,
    required this.count,
    required this.submittedByMe,
    this.mineAmount,
    this.mineRationale,
    this.summary,
    this.members,
  });

  static double _n(dynamic v) => v is num ? v.toDouble() : double.tryParse('$v') ?? 0;
  static String? _s(dynamic v) => (v == null || '$v'.trim().isEmpty) ? null : '$v';

  factory RecScenario.fromJson(Map<String, dynamic> j) {
    final mine = j['mine'];
    final summary = j['summary'];
    final members = j['members'];
    return RecScenario(
      scenarioId: '${j['scenarioId']}',
      count: (j['count'] as num?)?.toInt() ?? 0,
      submittedByMe: j['submittedByMe'] == true,
      mineAmount: mine is Map ? _n(mine['amount']) : null,
      mineRationale: mine is Map ? _s(mine['rationale']) : null,
      summary: summary is Map
          ? RecSummary((summary['n'] as num?)?.toInt() ?? 0, _n(summary['median']),
              _n(summary['min']), _n(summary['max']))
          : null,
      members: members is List
          ? [
              for (final m in members)
                if (m is Map)
                  RecMember('${m['playerName']}', _s(m['playerRole']), _n(m['amount']),
                      _s(m['rationale'])),
            ]
          : null,
    );
  }
}

class MemberRecsState {
  /// Corporate + flag on + team, player name and team token all present.
  final bool enabled;
  final String teamId;
  final String module;
  final int roundNum;
  final String playerName;
  final bool isLeader;
  final Map<String, RecScenario> scenarios;

  /// Signed-in members of the team (GET /facilitator/team-signins), for "N of M teammates".
  final List<String> members;

  const MemberRecsState({
    this.enabled = false,
    this.teamId = '',
    this.module = '',
    this.roundNum = 1,
    this.playerName = '',
    this.isLeader = false,
    this.scenarios = const {},
    this.members = const [],
  });

  MemberRecsState copyWith({
    bool? enabled,
    String? teamId,
    String? module,
    int? roundNum,
    String? playerName,
    bool? isLeader,
    Map<String, RecScenario>? scenarios,
    List<String>? members,
  }) =>
      MemberRecsState(
        enabled: enabled ?? this.enabled,
        teamId: teamId ?? this.teamId,
        module: module ?? this.module,
        roundNum: roundNum ?? this.roundNum,
        playerName: playerName ?? this.playerName,
        isLeader: isLeader ?? this.isLeader,
        scenarios: scenarios ?? this.scenarios,
        members: members ?? this.members,
      );
}

/// Shared by the poller (writes) and every card's block (reads). Keyed by team so a team
/// switch or sign-out never shows the previous team's view; disposed with the simulation.
final memberRecsProvider =
    StateProvider.autoDispose.family<MemberRecsState, String>((ref, teamId) => const MemberRecsState());

class MemberRecsRepository {
  final ApiClient _api;
  MemberRecsRepository(this._api);

  Future<bool?> flagEnabled() async {
    try {
      final res = await _api.get(ApiEndpoints.realismStatus);
      return res['memberRecommendationsEnabled'] == true;
    } catch (_) {
      return null;
    }
  }

  Future<({bool isLeader, Map<String, RecScenario> scenarios})?> fetch({
    required String teamId,
    required int roundNum,
    required String module,
    required String playerName,
  }) async {
    try {
      final res = await _api.get('$_recsPath/${Uri.encodeComponent(teamId)}', params: {
        'roundNum': roundNum,
        'module': module,
        'playerName': playerName,
      });
      if (res['success'] != true) return null;
      final list = res['scenarios'];
      return (
        isLeader: res['isLeader'] == true,
        scenarios: {
          if (list is List)
            for (final s in list)
              if (s is Map) '${s['scenarioId']}': RecScenario.fromJson(Map<String, dynamic>.from(s)),
        },
      );
    } catch (_) {
      return null;
    }
  }

  Future<List<String>?> signins(String teamId) async {
    try {
      final res = await _api.get('$_signinsPath/${Uri.encodeComponent(teamId)}');
      final data = res['data'];
      if (data is! List) return null;
      return [
        for (final m in data)
          if (m is Map && m['playerName'] != null) '${m['playerName']}',
      ];
    } catch (_) {
      return null;
    }
  }

  /// Null on success, else the server's message.
  Future<String?> submit({
    required String teamId,
    required int roundNum,
    required String module,
    required String scenarioId,
    required String playerName,
    required double amount,
    String? rationale,
  }) async {
    try {
      final res = await _api.post(_recsPath, data: {
        'teamId': teamId,
        'roundNum': roundNum,
        'module': module,
        'scenarioId': scenarioId,
        'playerName': playerName,
        'amount': amount,
        if (rationale != null && rationale.isNotEmpty) 'rationale': rationale,
      });
      if (res['success'] == true) return null;
      final err = res['error'] ?? res['message'];
      return err is String && err.isNotEmpty ? err : 'Failed to submit recommendation';
    } catch (_) {
      return 'Failed to submit recommendation';
    }
  }
}

final memberRecsRepositoryProvider = Provider<MemberRecsRepository>((ref) {
  return MemberRecsRepository(ref.watch(apiClientProvider));
});

bool _routeIsCurrent(BuildContext context) => ModalRoute.of(context)?.isCurrent ?? true;

/// Mounted once on the corporate simulation screen. Polls the realism flag every 10 s and,
/// while it is on, the team's recommendations for the visible module every 5 s (website
/// cadence; the 'recommendations:updated' push refreshes at once). Stands down while another
/// route covers the simulation. Renders nothing.
class MemberRecommendationsPoller extends ConsumerStatefulWidget {
  final String teamId;
  final String module;
  final int roundNum;
  const MemberRecommendationsPoller({
    super.key,
    required this.teamId,
    required this.module,
    required this.roundNum,
  });

  @override
  ConsumerState<MemberRecommendationsPoller> createState() => _MemberRecommendationsPollerState();
}

class _MemberRecommendationsPollerState extends ConsumerState<MemberRecommendationsPoller> {
  Timer? _timer;
  int _ticks = 0;
  bool _flag = false;
  String _player = '';
  bool _hasToken = false;
  bool _busy = false;
  final _subs = <StreamSubscription<dynamic>>[];

  @override
  void initState() {
    super.initState();
    _bootstrap();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || !_routeIsCurrent(context)) return;
      _ticks++;
      _refresh(checkFlag: _ticks.isEven);
    });
    final socket = ref.read(socketManagerProvider);
    _subs.add(socket.onEvent('recommendations:updated').listen((_) => _refresh(), onError: (_) {}));
    for (final e in const ['team:member_joined', 'team:member_left']) {
      _subs.add(socket.onEvent(e).listen((_) => _loadMembers(), onError: (_) {}));
    }
  }

  Future<void> _bootstrap() async {
    final prefs = await SharedPreferences.getInstance();
    _player = prefs.getString(AppConstants.playerNameKey)?.trim() ?? '';
    _hasToken = prefs.getString(AppConstants.teamMemberTokenKey)?.isNotEmpty == true;
    if (!mounted) return;
    await _refresh(checkFlag: true);
    _loadMembers();
  }

  @override
  void didUpdateWidget(covariant MemberRecommendationsPoller old) {
    super.didUpdateWidget(old);
    if (old.teamId != widget.teamId || old.module != widget.module || old.roundNum != widget.roundNum) {
      // Deferred: this runs while the screen rebuilds, and a synchronous provider write here
      // would throw ("modify a provider while the widget tree was building").
      final teamChanged = old.teamId != widget.teamId;
      Future.microtask(() {
        if (!mounted) return;
        final p = memberRecsProvider(widget.teamId);
        ref.read(p.notifier).state = ref.read(p).copyWith(scenarios: const {});
        _refresh();
        if (teamChanged) _loadMembers();
      });
    }
  }

  Future<void> _loadMembers() async {
    if (!_flag || widget.teamId.isEmpty) return;
    final members = await ref.read(memberRecsRepositoryProvider).signins(widget.teamId);
    if (!mounted || members == null) return;
    final p = memberRecsProvider(widget.teamId);
    ref.read(p.notifier).state = ref.read(p).copyWith(members: members);
  }

  Future<void> _refresh({bool checkFlag = false}) async {
    if (_busy) return;
    _busy = true;
    try {
      final repo = ref.read(memberRecsRepositoryProvider);
      if (checkFlag) {
        final flag = await repo.flagEnabled();
        if (flag != null) {
          final turnedOn = flag && !_flag;
          _flag = flag;
          if (turnedOn) _loadMembers();
        }
      }
      final enabled = _flag && widget.teamId.isNotEmpty && _player.isNotEmpty && _hasToken;
      if (!mounted) return;
      if (!enabled) {
        ref.read(memberRecsProvider(widget.teamId).notifier).state = const MemberRecsState();
        return;
      }
      final team = widget.teamId, module = widget.module, round = widget.roundNum;
      final res = await repo.fetch(teamId: team, roundNum: round, module: module, playerName: _player);
      if (!mounted || team != widget.teamId || module != widget.module || round != widget.roundNum) {
        return;
      }
      final prev = ref.read(memberRecsProvider(team));
      ref.read(memberRecsProvider(team).notifier).state = prev.copyWith(
        enabled: true,
        teamId: team,
        module: module,
        roundNum: round,
        playerName: _player,
        isLeader: res?.isLeader ?? prev.isLeader,
        scenarios: res?.scenarios ?? prev.scenarios,
      );
    } finally {
      _busy = false;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final s in _subs) {
      s.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Keep this team's shared state alive while the poller is mounted.
    ref.watch(memberRecsProvider(widget.teamId));
    return const SizedBox.shrink();
  }
}

String _fmt(double n) {
  final v = n.abs().round().toString();
  final buf = StringBuffer();
  for (var i = 0; i < v.length; i++) {
    if (i > 0 && (v.length - i) % 3 == 0) buf.write(',');
    buf.write(v[i]);
  }
  return '${n < 0 ? '−' : ''}\$$buf';
}

String _fmtSummary(AppStrings s, RecSummary x) => s.tr(
      'n=${x.n} · median ${_fmt(x.median)} · range ${_fmt(x.min)} – ${_fmt(x.max)}',
      'العدد=${x.n} · الوسيط ${_fmt(x.median)} · المدى ${_fmt(x.min)} – ${_fmt(x.max)}',
    );

bool _same(String a, String b) => a.trim().toLowerCase() == b.trim().toLowerCase();

/// The per-card block: a commit form for members, the "Team input" synthesis for the leader.
/// Renders nothing unless the poller has enabled recommendations for this card's module.
class MemberRecommendationsBlock extends ConsumerStatefulWidget {
  final String teamId;
  final String scenarioId;
  final String module;

  /// Module confirmed/locked: inputs become read-only (the server answers 409 anyway).
  final bool moduleLocked;

  const MemberRecommendationsBlock({
    super.key,
    required this.teamId,
    required this.scenarioId,
    required this.module,
    required this.moduleLocked,
  });

  @override
  ConsumerState<MemberRecommendationsBlock> createState() => _MemberRecommendationsBlockState();
}

class _MemberRecommendationsBlockState extends ConsumerState<MemberRecommendationsBlock> {
  bool _editing = false;
  bool _expanded = false;
  bool _submitting = false;
  final _amount = TextEditingController();
  final _rationale = TextEditingController();

  @override
  void dispose() {
    _amount.dispose();
    _rationale.dispose();
    super.dispose();
  }

  Future<void> _submit(MemberRecsState st) async {
    final s = ref.read(stringsProvider);
    final messenger = ScaffoldMessenger.of(context);
    final amount = double.tryParse(_amount.text.replaceAll(RegExp(r'[^0-9.eE+\-]'), ''));
    if (amount == null || !amount.isFinite) {
      messenger.showSnackBar(SnackBar(
        backgroundColor: const Color(0xFFDC2626),
        content: Text(s.tr(
          'Enter an amount: your recommendation must be a number (same +/− convention as this card).',
          'أدخل مبلغًا: يجب أن تكون توصيتك رقمًا (بنفس اصطلاح +/− المتبع في هذه البطاقة).',
        )),
      ));
      return;
    }
    setState(() => _submitting = true);
    final err = await ref.read(memberRecsRepositoryProvider).submit(
          teamId: st.teamId,
          roundNum: st.roundNum,
          module: widget.module,
          scenarioId: widget.scenarioId,
          playerName: st.playerName,
          amount: amount,
          rationale: _rationale.text.trim(),
        );
    if (!mounted) return;
    setState(() => _submitting = false);
    if (err == null) {
      setState(() => _editing = false);
      // Pull the fresh view now (the server also pushes recommendations:updated).
      final res = await ref.read(memberRecsRepositoryProvider).fetch(
          teamId: st.teamId, roundNum: st.roundNum, module: widget.module, playerName: st.playerName);
      if (mounted && res != null) {
        final cur = ref.read(memberRecsProvider(st.teamId));
        if (cur.module == widget.module) {
          ref.read(memberRecsProvider(st.teamId).notifier).state =
              cur.copyWith(isLeader: res.isLeader, scenarios: res.scenarios);
        }
      }
      messenger.showSnackBar(SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(s.tr('Recommendation committed', 'تم تسجيل توصيتك')),
      ));
    } else {
      messenger.showSnackBar(SnackBar(
        backgroundColor: const Color(0xFFDC2626),
        content: Text('${s.tr('Could not submit', 'تعذّر الإرسال')}: $err'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final st = ref.watch(memberRecsProvider(widget.teamId));
    if (!st.enabled || st.module != widget.module) return const SizedBox.shrink();
    final s = ref.watch(stringsProvider);
    final rec = st.scenarios[widget.scenarioId];
    final count = rec?.count ?? 0;

    // Absorb taps so they don't toggle the card underneath.
    Widget shell(Widget child) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {},
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF).withValues(alpha: 0.8), // indigo-50
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFC7D2FE)), // indigo-200
            ),
            child: child,
          ),
        );
    const indigo900 = Color(0xFF312E81);
    const indigo700 = Color(0xFF4338CA);

    // ─── LEADER VIEW: "Team input" synthesis + expandable member list ───
    if (st.isLeader) {
      final members = rec?.members;
      return shell(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: count > 0 ? () => setState(() => _expanded = !_expanded) : null,
            child: Row(
              children: [
                const Icon(Icons.groups_rounded, size: 15, color: Color(0xFF4F46E5)),
                const SizedBox(width: 6),
                Text(s.tr('Team input', 'مدخلات الفريق'),
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: indigo900)),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E7FF),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text('$count',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: indigo700)),
                ),
                const Spacer(),
                if (count > 0)
                  Icon(_expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                      size: 18, color: indigo900),
              ],
            ),
          ),
          const SizedBox(height: 4),
          if (count == 0)
            Text(
              s.tr('No member recommendations yet for this scenario.',
                  'لا توجد توصيات من الأعضاء لهذا السيناريو بعد.'),
              style: TextStyle(fontSize: 11, color: indigo700.withValues(alpha: 0.8)),
            )
          else ...[
            if (rec?.summary != null)
              Text(_fmtSummary(s, rec!.summary!), style: const TextStyle(fontSize: 11, color: indigo900)),
            if (_expanded && members != null) ...[
              const Divider(height: 10),
              for (final m in members)
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    children: [
                      Text(m.playerName,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: indigo900)),
                      if (m.playerRole != null) TeamRoleBadge(role: m.playerRole!),
                      Text(
                        _fmt(m.amount),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: m.amount < 0 ? const Color(0xFFB91C1C) : const Color(0xFF047857),
                        ),
                      ),
                      if (m.rationale != null)
                        Text('— ${m.rationale}',
                            style: TextStyle(
                                fontSize: 11, fontStyle: FontStyle.italic, color: indigo700.withValues(alpha: 0.8))),
                    ],
                  ),
                ),
            ],
          ],
        ],
      ));
    }

    // ─── MEMBER VIEW ───
    final mine = rec?.mineAmount;
    final others = st.members.where((m) => !_same(m, st.playerName)).length;
    final submittedAdj = (rec?.submittedByMe ?? false) ? 1 : 0;
    final teammatesTotal = others > count - submittedAdj ? others : count - submittedAdj;
    final showForm = !widget.moduleLocked && (mine == null || _editing);

    return shell(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.groups_rounded, size: 15, color: Color(0xFF4F46E5)),
            const SizedBox(width: 6),
            Expanded(
              child: Text(s.tr('Your recommendation', 'توصيتك'),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: indigo900)),
            ),
            if (widget.moduleLocked) const Icon(Icons.lock_rounded, size: 13, color: Colors.grey),
          ],
        ),
        // Pre-submission: count only - never teammates' numbers (anti-anchoring).
        if (mine == null)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              s.tr('$count of $teammatesTotal teammates have recommended.',
                  'قدّم $count من أصل $teammatesTotal من زملائك توصياتهم.'),
              style: TextStyle(fontSize: 11, color: indigo700.withValues(alpha: 0.9)),
            ),
          ),
        if (showForm) ...[
          const SizedBox(height: 6),
          Text(
            s.tr('Commit your view before the team decides. Same +/− convention as this card.',
                'سجّل رأيك قبل أن يقرر الفريق. بنفس اصطلاح +/− المتبع في هذه البطاقة.'),
            style: TextStyle(fontSize: 10.5, color: const Color(0xFF4F46E5).withValues(alpha: 0.85)),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _amount,
            keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,\-+eE]'))],
            textAlign: TextAlign.end,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              hintText: s.tr('Amount (e.g. -250000)', 'المبلغ (مثال: ‎-250000)'),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _rationale,
            maxLength: 280,
            style: const TextStyle(fontSize: 12),
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              counterText: '',
              hintText: s.tr('Why? (optional, one line)', 'لماذا؟ (اختياري، سطر واحد)'),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _submitting ? null : () => _submit(st),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    foregroundColor: Colors.white,
                    visualDensity: VisualDensity.compact,
                  ),
                  child: Text(
                    _submitting
                        ? s.tr('Committing…', 'جارٍ التسجيل…')
                        : mine != null
                            ? s.tr('Update', 'تحديث')
                            : s.tr('Commit', 'تسجيل'),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
              if (_editing) ...[
                const SizedBox(width: 6),
                TextButton(
                  onPressed: () => setState(() => _editing = false),
                  child: Text(s.tr('Cancel', 'إلغاء'), style: const TextStyle(fontSize: 12)),
                ),
              ],
            ],
          ),
        ] else if (mine != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.check_circle_rounded, size: 15, color: Color(0xFF059669)),
              const SizedBox(width: 4),
              Text(
                _fmt(mine),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: mine < 0 ? const Color(0xFFB91C1C) : const Color(0xFF047857),
                ),
              ),
              const SizedBox(width: 4),
              Text(s.tr('committed', 'مسجّلة'),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: indigo900)),
              const Spacer(),
              if (!widget.moduleLocked)
                TextButton.icon(
                  style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                  onPressed: () => setState(() {
                    _amount.text = mine == mine.roundToDouble() ? mine.toInt().toString() : '$mine';
                    _rationale.text = rec?.mineRationale ?? '';
                    _editing = true;
                  }),
                  icon: const Icon(Icons.edit_rounded, size: 12),
                  label: Text(s.tr('Update', 'تحديث'), style: const TextStyle(fontSize: 11)),
                ),
            ],
          ),
          if (rec?.mineRationale != null)
            Text('“${rec!.mineRationale}”',
                style: TextStyle(fontSize: 10.5, fontStyle: FontStyle.italic, color: indigo700.withValues(alpha: 0.8))),
          // Post-submission: the team summary unlocks.
          if (rec?.summary != null) ...[
            const Divider(height: 10),
            Text(
              '${s.tr('Team so far', 'الفريق حتى الآن')}: ${_fmtSummary(s, rec!.summary!)}',
              style: const TextStyle(fontSize: 11, color: indigo900),
            ),
          ],
        ] else
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              s.tr('Decisions are locked — recommendations for this module are closed.',
                  'القرارات مقفلة — أُغلقت التوصيات لهذه الوحدة.'),
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),
      ],
    ));
  }
}
