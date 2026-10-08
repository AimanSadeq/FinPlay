import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/i18n/app_strings.dart';
import '../../../app/theme/app_colors.dart';
import '../../../data/repositories/facilitator_repository.dart';
import '../../../shared/widgets/glass_card.dart';
import '../poll_visibility.dart';
import 'console_links.dart';

String _when(String? iso) {
  final d = DateTime.tryParse(iso ?? '')?.toLocal();
  if (d == null) return '';
  String two(int n) => n.toString().padLeft(2, '0');
  return '${d.year}-${two(d.month)}-${two(d.day)} ${two(d.hour)}:${two(d.minute)}';
}

// ─────────────────────────────────────────────────────────────────────────────
// Activity log (website ActivityLogAdmin)
// ─────────────────────────────────────────────────────────────────────────────

const List<String> activityCategories = ['auth', 'education', 'simulation', 'commerce', 'facilitator', 'system'];

/// Who an event is about, as the website labels it.
String activityActorLabel(Map<String, dynamic> e) {
  for (final k in ['actorName', 'actorEmail', 'teamId']) {
    final v = e[k];
    if (v != null && v.toString().isNotEmpty) return v.toString();
  }
  return e['actorType'] == 'facilitator' ? 'Facilitator' : 'Unknown';
}

class ActivityLogPanel extends ConsumerStatefulWidget {
  final FacilitatorRepository repo;
  const ActivityLogPanel({super.key, required this.repo});

  @override
  ConsumerState<ActivityLogPanel> createState() => _ActivityLogPanelState();
}

class _ActivityLogPanelState extends ConsumerState<ActivityLogPanel> {
  String _category = '';
  String _search = '';
  final _searchC = TextEditingController();
  bool _loading = true;
  bool _configured = true;
  String? _error;
  List<Map<String, dynamic>> _events = [];
  Timer? _poll;

  @override
  void initState() {
    super.initState();
    _load();
    _poll = Timer.periodic(const Duration(seconds: 30), (_) {
      if (isPollVisible(this)) _load();
    });
  }

  @override
  void dispose() {
    _poll?.cancel();
    _searchC.dispose();
    super.dispose();
  }

  bool _inFlight = false;

  Future<void> _load() async {
    if (_inFlight) return;
    _inFlight = true;
    try {
      final r = await widget.repo.fetchActivityLog(category: _category, search: _search);
      if (mounted) setState(() { _events = r.events; _configured = r.configured; _loading = false; _error = null; });
    } catch (e) {
      if (mounted) setState(() { _loading = false; _error = e is FacilitatorActionException ? e.message : e.toString(); });
    } finally {
      _inFlight = false;
    }
  }

  Color _catColor(String c) => switch (c) {
        'auth' => AppColors.primaryLight,
        'education' => AppColors.secondaryLight,
        'simulation' => AppColors.accentLight,
        'commerce' => AppColors.purple,
        'facilitator' => AppColors.dangerLight,
        _ => Colors.grey,
      };

  String _catLabel(AppStrings s, String c) => switch (c) {
        'auth' => s.tr('auth', 'الدخول'),
        'education' => s.tr('education', 'التعليم'),
        'simulation' => s.tr('simulation', 'المحاكاة'),
        'commerce' => s.tr('commerce', 'التجارة'),
        'facilitator' => s.tr('facilitator', 'الميسّر'),
        'system' => s.tr('system', 'النظام'),
        _ => c,
      };

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final small = TextStyle(fontSize: 11, color: AppColors.textTertiary(context));
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(padding: const EdgeInsets.all(16), children: [
        Row(children: [
          const Icon(Icons.timeline_rounded, color: AppColors.primaryLight),
          const SizedBox(width: 8),
          Expanded(child: Text(s.tr('Activity Log', 'سجل النشاط'), style: Theme.of(context).textTheme.titleMedium)),
          if (_events.isNotEmpty) Text('${_events.length}', style: small),
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh_rounded)),
        ]),
        Wrap(spacing: 6, runSpacing: 6, children: [
          ChoiceChip(
            label: Text(s.tr('All', 'الكل')),
            selected: _category.isEmpty,
            onSelected: (_) { setState(() => _category = ''); _load(); },
          ),
          for (final c in activityCategories)
            ChoiceChip(
              label: Text(_catLabel(s, c)),
              selected: _category == c,
              onSelected: (_) { setState(() => _category = c); _load(); },
            ),
        ]),
        const SizedBox(height: 8),
        TextField(
          controller: _searchC,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            isDense: true,
            hintText: s.tr('Name, email, action', 'الاسم أو البريد أو الإجراء'),
            suffixIcon: IconButton(
              icon: const Icon(Icons.search_rounded),
              onPressed: () { _search = _searchC.text.trim(); _load(); },
            ),
          ),
          onSubmitted: (v) { _search = v.trim(); _load(); },
        ),
        const SizedBox(height: 12),
        if (_loading)
          const Center(child: CircularProgressIndicator())
        else if (_error != null)
          Text(_error!, style: const TextStyle(color: AppColors.dangerLight))
        else if (!_configured)
          Column(children: [
            const Icon(Icons.error_outline_rounded, color: AppColors.accentLight, size: 32),
            Text(s.tr('Activity log is not set up yet', 'سجل النشاط غير مُعدّ بعد')),
            Text(s.tr('Run the create-activity-log-table migration to start capturing activity.',
                'شغّل ترحيل create-activity-log-table لبدء تسجيل النشاط.'), style: small, textAlign: TextAlign.center),
          ])
        else if (_events.isEmpty)
          Center(child: Text(s.tr('No activity recorded yet', 'لم يُسجَّل أي نشاط بعد'), style: small))
        else
          for (final e in _events)
            Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderColor(context)),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(
                    child: Text('${activityActorLabel(e)}  ·  ${e['actorType'] ?? ''}',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: _catColor('${e['category']}').withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(_catLabel(s, '${e['category']}'), style: TextStyle(fontSize: 10, color: _catColor('${e['category']}'))),
                  ),
                ]),
                Text('${e['action'] ?? ''}', style: const TextStyle(fontSize: 13)),
                if (e['detail'] is Map && (e['detail'] as Map).isNotEmpty)
                  Text((e['detail'] as Map).entries.map((d) => '${d.key}: ${d.value}').join(' · '), style: small),
                Text(_when(e['createdAt']?.toString()), style: small),
              ]),
            ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Self-paced members (website SelfPacedMembersAdmin) - facilitator administration of
// accounts, not a purchase surface.
// ─────────────────────────────────────────────────────────────────────────────

const List<String> memberAccessStates = ['subscription', 'trial', 'lapsed', 'student', 'comp'];

String memberAccessLabel(AppStrings s, String state) => switch (state) {
      'subscription' => s.tr('Paid', 'مدفوع'),
      'trial' => s.tr('Trial', 'تجربة'),
      'student' => s.tr('Student (free)', 'طالب (مجاني)'),
      'comp' => s.tr('Comped', 'مجاني بمنحة'),
      'lapsed' => s.tr('Lapsed', 'منتهٍ'),
      _ => state,
    };

/// Website daysUntil: whole days to [iso], negative once past; null with no date.
int? daysUntil(String? iso, {DateTime? now}) {
  final d = DateTime.tryParse(iso ?? '');
  if (d == null) return null;
  return (d.difference(now ?? DateTime.now()).inMilliseconds / 86400000).ceil();
}

/// The access window line under a member's badge, as on the website.
String memberWindowLabel(AppStrings s, Map<String, dynamic> m, {DateTime? now}) {
  final state = m['accessState'];
  if (state == 'student') {
    final dom = m['studentEmailDomain'] ?? s.tr('university email', 'بريد جامعي');
    return s.tr('$dom · never expires', '$dom · لا تنتهي');
  }
  if (state == 'comp') return s.tr('never expires', 'لا تنتهي');
  final isSub = state == 'subscription' || m['hasEverPaid'] == true;
  final d = daysUntil((isSub ? m['subscriptionExpiresAt'] : m['trialEndsAt'])?.toString(), now: now);
  if (d == null) return '';
  if (d < 0) return s.tr('expired ${d.abs()}d ago', 'انتهى قبل ${d.abs()} يوم');
  return isSub ? s.tr('renews in ${d}d', 'يتجدّد خلال $d يوم') : s.tr('trial ends in ${d}d', 'تنتهي التجربة خلال $d يوم');
}

class SelfPacedMembersPanel extends ConsumerStatefulWidget {
  final FacilitatorRepository repo;
  const SelfPacedMembersPanel({super.key, required this.repo});

  @override
  ConsumerState<SelfPacedMembersPanel> createState() => _SelfPacedMembersPanelState();
}

class _SelfPacedMembersPanelState extends ConsumerState<SelfPacedMembersPanel> {
  List<Map<String, dynamic>> _members = [];
  bool _loading = true;
  String? _error;
  String? _busyEmail;
  Timer? _poll;

  @override
  void initState() {
    super.initState();
    _load();
    _poll = Timer.periodic(const Duration(seconds: 30), (_) {
      if (isPollVisible(this)) _load();
    });
  }

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }

  bool _inFlight = false;

  Future<void> _load() async {
    if (_inFlight) return;
    _inFlight = true;
    try {
      final m = await widget.repo.fetchSelfPacedMembers();
      if (mounted) setState(() { _members = m; _loading = false; _error = null; });
    } catch (e) {
      if (mounted) setState(() { _loading = false; _error = e is FacilitatorActionException ? e.message : e.toString(); });
    } finally {
      _inFlight = false;
    }
  }

  Future<void> _togglePlan(AppStrings s, Map<String, dynamic> m) async {
    final email = m['email'].toString();
    setState(() => _busyEmail = email);
    try {
      await widget.repo.setMemberPlan(email, m['plan'] == 'demo' ? 'trial' : 'demo');
      await _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e is FacilitatorActionException ? e.message : s.tr('Failed to update plan', 'تعذّر تحديث الخطة')),
            backgroundColor: AppColors.danger));
      }
    } finally {
      if (mounted) setState(() => _busyEmail = null);
    }
  }

  Color _stateColor(String? st) => switch (st) {
        'subscription' => AppColors.secondaryLight,
        'trial' => AppColors.primaryLight,
        'student' => AppColors.accentLight,
        'comp' => AppColors.purple,
        'lapsed' => AppColors.dangerLight,
        _ => Colors.grey,
      };

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final small = TextStyle(fontSize: 11, color: AppColors.textTertiary(context));
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(padding: const EdgeInsets.all(16), children: [
        Row(children: [
          const Icon(Icons.people_alt_rounded, color: AppColors.primaryLight),
          const SizedBox(width: 8),
          Expanded(child: Text(s.tr('Self-Paced Members', 'أعضاء التعلّم الذاتي'), style: Theme.of(context).textTheme.titleMedium)),
          Text('${_members.length}', style: small),
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh_rounded)),
        ]),
        if (_loading)
          const Center(child: CircularProgressIndicator())
        else if (_error != null)
          Text(_error!, style: const TextStyle(color: AppColors.dangerLight))
        else if (_members.isEmpty)
          Text(s.tr('Members will appear here when they register in self-paced mode',
              'سيظهر الأعضاء هنا عند تسجيلهم في وضع التعلّم الذاتي'), style: small)
        else ...[
          // Who is actually paying, at a glance (website revenue summary).
          Wrap(spacing: 6, runSpacing: 6, children: [
            for (final st in memberAccessStates)
              if (_members.any((m) => m['accessState'] == st))
                Chip(
                  visualDensity: VisualDensity.compact,
                  backgroundColor: _stateColor(st).withValues(alpha: 0.12),
                  label: Text('${memberAccessLabel(s, st)}: ${_members.where((m) => m['accessState'] == st).length}',
                      style: TextStyle(fontSize: 11, color: _stateColor(st))),
                ),
            Chip(
              visualDensity: VisualDensity.compact,
              label: Text(s.tr('Ever paid: ${_members.where((m) => m['hasEverPaid'] == true).length}',
                  'دفع سابقًا: ${_members.where((m) => m['hasEverPaid'] == true).length}'), style: const TextStyle(fontSize: 11)),
            ),
          ]),
          const SizedBox(height: 8),
          for (final m in _members) _memberRow(s, m, small),
        ],
      ]),
    );
  }

  Widget _memberRow(AppStrings s, Map<String, dynamic> m, TextStyle small) {
    final round = (m['currentRound'] as num?)?.toInt() ?? 1;
    final module = '${m['currentModule'] ?? 'financing'}';
    final progress = (((round - 1) * 3 + ['financing', 'investing', 'operating'].indexOf(module).clamp(0, 2)) / 9 * 100).round();
    final st = m['accessState']?.toString();
    final plan = m['plan']?.toString() ?? 'trial';
    final window = memberWindowLabel(s, m);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.borderColor(context))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${m['displayName'] ?? m['email']}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              Text('${m['email']}', style: small),
              Text('${m['company'] ?? '-'}${m['title'] != null ? ' · ${m['title']}' : ''}', style: small),
            ]),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: _stateColor(st).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
            child: Text(memberAccessLabel(s, st ?? ''), style: TextStyle(fontSize: 11, color: _stateColor(st))),
          ),
        ]),
        const SizedBox(height: 4),
        Text(
          '${s.tr('Progress', 'التقدّم')} $progress% · ${s.tr('R$round', 'ج$round')} ${module.length >= 3 ? module.substring(0, 3) : module}'
          ' · ${s.tr('Last active', 'آخر نشاط')}: ${m['lastLoginAt'] == null ? s.tr('Never', 'أبدًا') : _when(m['lastLoginAt'].toString())}',
          style: small,
        ),
        if (window.isNotEmpty) Text(window, style: small),
        Row(children: [
          Text('${s.tr('Plan', 'الخطة')}: ', style: small),
          Text(plan, style: GoogleFonts.jetBrainsMono(fontSize: 11, fontWeight: FontWeight.w600)),
          const Spacer(),
          OutlinedButton(
            onPressed: _busyEmail != null ? null : () => _togglePlan(s, m),
            child: Text(
              plan == 'demo' ? s.tr('Revoke demo', 'إلغاء العرض التجريبي') : s.tr('Make demo', 'جعله عرضًا تجريبيًا'),
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ]),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sim Control (website TeamDashboardNavigator)
// ─────────────────────────────────────────────────────────────────────────────

/// The website opens a team's dashboard in a new browser tab; the app shows the same
/// figures (GET /dashboard-data) for any team and round without signing in as the team.
class SimControlPanel extends ConsumerStatefulWidget {
  final FacilitatorRepository repo;
  const SimControlPanel({super.key, required this.repo});

  @override
  ConsumerState<SimControlPanel> createState() => _SimControlPanelState();
}

class _SimControlPanelState extends ConsumerState<SimControlPanel> {
  List<Map<String, dynamic>> _teams = [];
  bool _loading = true;
  Timer? _poll;

  @override
  void initState() {
    super.initState();
    _load();
    _poll = Timer.periodic(const Duration(seconds: 30), (_) {
      if (isPollVisible(this)) _load();
    });
  }

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }

  bool _inFlight = false;

  Future<void> _load() async {
    if (_inFlight) return;
    _inFlight = true;
    try {
      final t = await widget.repo.fetchTeamsRaw();
      if (mounted) setState(() { _teams = t; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    } finally {
      _inFlight = false;
    }
  }

  Color _color(String? hex, int i) {
    final h = (hex ?? '').replaceFirst('#', '');
    final v = int.tryParse(h.length == 6 ? 'FF$h' : '', radix: 16);
    return v == null ? AppColors.teamColor(i) : Color(v);
  }

  void _open(Map<String, dynamic> team, int round) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => _TeamRoundView(repo: widget.repo, team: team, round: round),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    if (_loading) return const Center(child: CircularProgressIndicator());
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(padding: const EdgeInsets.all(16), children: [
        Text(s.tr('Access Team Dashboards', 'الوصول إلى لوحات الفرق'), style: Theme.of(context).textTheme.titleMedium),
        Text(s.tr('Open any team\'s results for any round to see their perspective and progress.',
            'افتح نتائج أي فريق لأي جولة لترى منظوره وتقدّمه.'), style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context))),
        const SizedBox(height: 12),
        if (_teams.isEmpty)
          Text(s.tr('No teams found', 'لم يُعثر على فرق'))
        else
          for (var i = 0; i < _teams.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GlassCard(
                padding: const EdgeInsets.all(12),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    CircleAvatar(radius: 6, backgroundColor: _color(_teams[i]['color']?.toString(), i)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(displayTeamName(_teams[i]['name']?.toString(), _teams[i]['id'].toString()),
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ]),
                  const SizedBox(height: 6),
                  // Baseline / R1 / R2 / R3 stay left-to-right in Arabic too (website dir=ltr).
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Row(children: [
                      for (final r in [0, 1, 2, 3])
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 6)),
                              onPressed: () => _open(_teams[i], r),
                              child: Text(r == 0 ? s.tr('Baseline', 'الأساس') : 'R$r', style: const TextStyle(fontSize: 12)),
                            ),
                          ),
                        ),
                    ]),
                  ),
                ]),
              ),
            ),
      ]),
    );
  }
}

class _TeamRoundView extends ConsumerStatefulWidget {
  final FacilitatorRepository repo;
  final Map<String, dynamic> team;
  final int round;
  const _TeamRoundView({required this.repo, required this.team, required this.round});

  @override
  ConsumerState<_TeamRoundView> createState() => _TeamRoundViewState();
}

class _TeamRoundViewState extends ConsumerState<_TeamRoundView> {
  Map<String, dynamic>? _data;
  String? _error;

  @override
  void initState() {
    super.initState();
    widget.repo.fetchTeamRoundData(widget.team['id'].toString(), widget.round).then((d) {
      if (mounted) setState(() => _data = d);
    }).catchError((Object e) {
      if (mounted) setState(() => _error = e is FacilitatorActionException ? e.message : e.toString());
    });
  }

  List<Map<String, dynamic>> _rows(String statement, String key) {
    final st = _data?[statement];
    if (st is! Map) return [];
    final fin = st['financials'];
    if (fin is! Map) return [];
    return (fin[key] as List<dynamic>? ?? []).whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }

  String _fmt(dynamic v, {bool ratio = false}) {
    if (v == null) return 'n/m';
    final n = (v as num).toDouble();
    if (ratio) return n.toStringAsFixed(2);
    final abs = n.abs().round().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},');
    return n < 0 ? '($abs)' : abs;
  }

  Widget _table(String title, List<Map<String, dynamic>> rows, {bool ratio = false}) => ExpansionTile(
        initiallyExpanded: !ratio,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        children: [
          for (final r in rows)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              child: Row(children: [
                Expanded(
                  child: Text('${r['title']}',
                      style: TextStyle(fontSize: 12, fontWeight: r['isMajor'] == true || r['isCalculation'] == true ? FontWeight.w700 : FontWeight.normal)),
                ),
                if (!(r['isHeader'] == true))
                  Text(_fmt(r['value'], ratio: ratio), style: GoogleFonts.jetBrainsMono(fontSize: 12)),
              ]),
            ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final name = displayTeamName(widget.team['name']?.toString(), widget.team['id'].toString());
    final roundLabel = widget.round == 0 ? s.tr('Baseline', 'الأساس') : s.tr('Round ${widget.round}', 'الجولة ${widget.round}');
    final v = _data?['validation'] is Map ? Map<String, dynamic>.from(_data!['validation']) : null;
    final checks = v?['validation'] is Map ? Map<String, dynamic>.from(v!['validation']) : null;
    return Scaffold(
      appBar: AppBar(title: Text('$name · $roundLabel', style: const TextStyle(fontSize: 16))),
      body: _error != null
          ? Center(child: Text(_error!, style: const TextStyle(color: AppColors.dangerLight)))
          : _data == null
              ? const Center(child: CircularProgressIndicator())
              : ListView(children: [
                  if (checks != null)
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Wrap(spacing: 8, runSpacing: 6, children: [
                        Chip(
                          avatar: Icon(checks['isBalanceSheetBalanced'] == true ? Icons.check_circle : Icons.error,
                              size: 16, color: checks['isBalanceSheetBalanced'] == true ? AppColors.secondaryLight : AppColors.dangerLight),
                          label: Text(s.tr('Balance sheet balances', 'الميزانية متوازنة'), style: const TextStyle(fontSize: 11)),
                        ),
                        Chip(
                          avatar: Icon(checks['isCashFlowBalanced'] == true ? Icons.check_circle : Icons.error,
                              size: 16, color: checks['isCashFlowBalanced'] == true ? AppColors.secondaryLight : AppColors.dangerLight),
                          label: Text(s.tr('Cash flow ties to cash', 'التدفق النقدي يطابق النقد'), style: const TextStyle(fontSize: 11)),
                        ),
                        if (v?['overdraft'] == true)
                          Chip(label: Text(s.tr('Overdraft', 'سحب على المكشوف'), style: const TextStyle(fontSize: 11, color: AppColors.dangerLight))),
                      ]),
                    ),
                  _table(s.tr('Income Statement', 'قائمة الدخل'), _rows('income', 'incomeStatement')),
                  _table(s.tr('Balance Sheet', 'الميزانية العمومية'), _rows('balance', 'balanceSheet')),
                  _table(s.tr('Cash Flow', 'التدفقات النقدية'), _rows('cashflow', 'cashFlow')),
                  _table(s.tr('Ratios', 'النسب'), _rows('ratios', 'ratios'), ratio: true),
                  const SizedBox(height: 24),
                ]),
    );
  }
}
