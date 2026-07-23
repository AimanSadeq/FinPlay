import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/i18n/app_strings.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/utils/constants.dart';
import '../../../data/repositories/earnings_call_repository.dart';
import '../../../providers/repository_providers.dart';
import '../../../providers/team_provider.dart';
import '../../../shared/widgets/glass_card.dart';

/// Earnings Call — team view (website parity with client/src/pages/earnings-call.tsx).
///
/// Three facilitator-driven stages:
///   off  → "not started" placeholder
///   prep → playbook/SOP + countdown + the team's own R1-vs-R2 numbers
///   live → released analyst questions (typed answer + AI critique) and rating
///          the other teams' presentations
///
/// All numbers come from GET /earnings-call/team/{teamId} — the same payload the
/// AI analyst was prompted with, so teams see exactly what the "analyst" saw.
class EarningsCallScreen extends ConsumerStatefulWidget {
  const EarningsCallScreen({super.key});

  @override
  ConsumerState<EarningsCallScreen> createState() => _EarningsCallScreenState();
}

class _EarningsCallScreenState extends ConsumerState<EarningsCallScreen> {
  Map<String, dynamic> _state = const {'stage': 'off'};
  Map<String, dynamic>? _payload;
  List<Map<String, dynamic>> _questions = const [];
  bool _loading = true;
  String? _playerName;

  Timer? _statusTimer;
  Timer? _questionsTimer;

  String get _stage => _state['stage']?.toString() ?? 'off';
  String get _teamId => ref.read(teamProvider).selectedTeam?.id ?? '';

  @override
  void initState() {
    super.initState();
    _loadPlayerName();
    _refreshStatus(initial: true);
    // The website polls the stage every 10s; questions every 15s while live.
    _statusTimer = Timer.periodic(const Duration(seconds: 10), (_) => _refreshStatus());
    _questionsTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      if (_stage == 'live') _refreshQuestions();
    });
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    _questionsTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadPlayerName() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() => _playerName = prefs.getString(AppConstants.playerNameKey));
    }
  }

  Future<void> _refreshStatus({bool initial = false}) async {
    final repo = ref.read(earningsCallRepositoryProvider);
    try {
      final state = await repo.status();
      if (!mounted) return;
      final wasStage = _stage;
      setState(() {
        _state = state;
        if (initial) _loading = false;
      });
      if (_stage != 'off' && (_payload == null || wasStage != _stage)) {
        await _refreshPayload();
      }
      if (_stage == 'live' && (_questions.isEmpty || wasStage != 'live')) {
        await _refreshQuestions();
      }
    } catch (_) {
      if (mounted && initial) setState(() => _loading = false);
    }
  }

  Future<void> _refreshPayload() async {
    if (_teamId.isEmpty) return;
    try {
      final payload = await ref.read(earningsCallRepositoryProvider).teamPayload(_teamId);
      if (mounted) setState(() => _payload = payload);
    } catch (_) {
      // Keep whatever we already rendered.
    }
  }

  Future<void> _refreshQuestions() async {
    if (_teamId.isEmpty) return;
    try {
      final qs = await ref.read(earningsCallRepositoryProvider).releasedQuestions(_teamId);
      if (mounted) setState(() => _questions = qs);
    } catch (_) {
      // Released questions stay as they were.
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final teamId = _teamId;

    return Scaffold(
      backgroundColor: _bg(isDark),
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.podcasts_rounded, size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                s.tr('Earnings Call', 'مكالمة الأرباح'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        actions: [
          if (_stage == 'prep' && _state['prepEndsAt'] != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              child: _Countdown(endsAt: _state['prepEndsAt'].toString()),
            ),
          if (_stage == 'live')
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFDC2626),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                s.tr('● LIVE', '● مباشر'),
                style: const TextStyle(
                    color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800),
              ),
            ),
          IconButton(
            tooltip: s.tr('Simulation', 'المحاكاة'),
            icon: const Icon(Icons.videogame_asset_rounded),
            onPressed: () => context.go('/simulation'),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await _refreshStatus();
                await _refreshPayload();
                if (_stage == 'live') await _refreshQuestions();
              },
              child: ListView(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 32),
                children: [
                  if (_stage == 'off') _placeholder(s, isDark, off: true),
                  if (_stage != 'off' && teamId.isEmpty) _placeholder(s, isDark, off: false),
                  if (_stage == 'prep')
                    _Briefing(
                      s: s,
                      isDark: isDark,
                      prepMinutes: (_state['prepMinutes'] as num?)?.toInt() ?? 30,
                    ),
                  if (_stage == 'live' && _questions.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _questionsCard(s, isDark, teamId),
                  ],
                  if (_payload != null) ...[
                    const SizedBox(height: 12),
                    _talkingPoints(s, isDark),
                    const SizedBox(height: 12),
                    ..._statements(s, isDark),
                    const SizedBox(height: 12),
                    _decisionsCard(s, isDark),
                    const SizedBox(height: 12),
                    _shocksCard(s, isDark),
                  ],
                  if (_stage == 'live' && teamId.isNotEmpty) ...[
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 18, color: Color(0xFFF59E0B)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            s.tr("Rate the other teams' presentations",
                                'قيّموا عروض الفرق الأخرى'),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: _textPrimary(isDark),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...EarningsCallRepository.teams
                        .where((t) => t != teamId)
                        .map((t) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _RatingCard(
                                presenter: t,
                                raterTeamId: teamId,
                                raterPlayerName: _playerName,
                                s: s,
                                isDark: isDark,
                              ),
                            )),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _placeholder(AppStrings s, bool isDark, {required bool off}) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        children: [
          Icon(off ? Icons.podcasts_rounded : Icons.groups_rounded,
              size: 40, color: _textSecondary(isDark).withValues(alpha: 0.5)),
          const SizedBox(height: 12),
          Text(
            off
                ? s.tr(
                    'The earnings call has not started yet. Your facilitator will open it after Round 2.',
                    'لم تبدأ مكالمة الأرباح بعد. سيقوم المدرّب بتفعيلها بعد نهاية السنة الثانية.')
                : s.tr('Join your team first from the lobby, then return here.',
                    'انضم إلى فريقك أولاً من صفحة الانضمام.'),
            textAlign: TextAlign.center,
            style: TextStyle(color: _textSecondary(isDark), height: 1.5),
          ),
        ],
      ),
    );
  }

  // ── Analyst questions ─────────────────────────────────────────────────────

  Widget _questionsCard(AppStrings s, bool isDark, String teamId) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      borderColor: const Color(0xFFC4B5FD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.help_center_rounded, size: 20, color: Color(0xFF7C3AED)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  s.tr('Analyst questions for your team', 'أسئلة المحلل لفريقكم'),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _textPrimary(isDark),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (var i = 0; i < _questions.length; i++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${i + 1}.',
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, color: Color(0xFF7C3AED))),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    s.ar
                        ? (_questions[i]['questionAr']?.toString() ??
                            _questions[i]['questionEn']?.toString() ??
                            '')
                        : (_questions[i]['questionEn']?.toString() ?? ''),
                    style: TextStyle(
                        fontSize: 14, height: 1.45, color: _textPrimary(isDark)),
                  ),
                ),
              ],
            ),
            if ((_questions[i]['focus']?.toString() ?? '').isNotEmpty)
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 22, top: 4),
                child: _Chip(text: _questions[i]['focus'].toString()),
              ),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 22, top: 6, bottom: 14),
              child: _AnswerBox(
                teamId: teamId,
                questionIndex: i,
                question: _questions[i],
                s: s,
                isDark: isDark,
              ),
            ),
          ],
          Text(
            s.tr(
                'Answer aloud in the room first, then type your official response here — the AI reviews its content against your own numbers.',
                'أجيبوا شفهياً في القاعة أولاً، ثم دوّنوا إجابتكم الرسمية هنا ليقدّم الذكاء الاصطناعي ملاحظاته على مضمونها مقارنةً بأرقامكم.'),
            style: TextStyle(fontSize: 11, color: _textSecondary(isDark), height: 1.4),
          ),
        ],
      ),
    );
  }

  // ── Numbers ───────────────────────────────────────────────────────────────

  String get _from => _payload?['compare']?['from']?.toString() ?? 'r1';
  String get _to => _payload?['compare']?['to']?.toString() ?? 'r2';

  Widget _talkingPoints(AppStrings s, bool isDark) {
    final points = (_payload?['talkingPoints'] as List?) ?? const [];
    if (points.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: points.whereType<Map>().map((tp) {
        final from = (tp['from'] as num?)?.toDouble() ?? 0;
        final to = (tp['to'] as num?)?.toDouble() ?? 0;
        return SizedBox(
          width: (MediaQuery.of(context).size.width - 28 - 10) / 2,
          child: GlassCard(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            child: Column(
              children: [
                Text(
                  tp['metric']?.toString() ?? '',
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 0.4,
                    color: _textSecondary(isDark),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _fmt(to),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: _textPrimary(isDark),
                  ),
                ),
                const SizedBox(height: 2),
                _Delta(from: from, to: to),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  List<Widget> _statements(AppStrings s, bool isDark) {
    final f = _payload?['financials'] as Map?;
    if (f == null) return const [];
    final tables = [
      (s.tr('Income Statement', 'قائمة الدخل'), f['income']),
      (s.tr('Key Ratios', 'النسب المالية'), f['ratios']),
      (s.tr('Balance Sheet', 'الميزانية العمومية'), f['balance']),
      (s.tr('Cash Flow', 'قائمة التدفقات النقدية'), f['cashflow']),
    ];
    return [
      for (final (title, rows) in tables)
        if (rows is List && rows.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _StatementTable(
              title: title,
              rows: rows.whereType<Map>().map((r) => Map<String, dynamic>.from(r)).toList(),
              from: _from,
              to: _to,
              s: s,
              isDark: isDark,
            ),
          ),
    ];
  }

  Widget _decisionsCard(AppStrings s, bool isDark) {
    final decisions = (_payload?['decisions'] as Map?) ?? const {};
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            s.tr('Your decisions by round', 'قراراتكم حسب السنة'),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: _textPrimary(isDark),
            ),
          ),
          const SizedBox(height: 8),
          ...decisions.entries.map((entry) {
            final modules = (entry.value as Map?) ?? const {};
            final items = modules.entries.expand((m) {
              final list = (m.value as List?) ?? const [];
              return list.whereType<Map>().map((d) => (module: m.key.toString(), d: d));
            }).toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6, bottom: 4),
                  child: Text(
                    entry.key.toString().toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: _textSecondary(isDark),
                    ),
                  ),
                ),
                if (items.isEmpty)
                  Text(
                    s.tr('No decisions recorded.', 'لا توجد قرارات مسجلة.'),
                    style: TextStyle(fontSize: 13, color: _textSecondary(isDark)),
                  ),
                ...items.map((it) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Chip(text: it.module),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '${it.d['description'] ?? ''} '
                              '(${_fmt((it.d['amount'] as num?)?.toDouble() ?? 0)})',
                              style: TextStyle(
                                  fontSize: 13, color: _textPrimary(isDark)),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _shocksCard(AppStrings s, bool isDark) {
    final shocks = (_payload?['shocks'] as List?) ?? const [];
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            s.tr('Market shocks during the game', 'صدمات السوق خلال اللعبة'),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: _textPrimary(isDark),
            ),
          ),
          const SizedBox(height: 8),
          if (shocks.isEmpty)
            Text(
              s.tr('No shocks recorded.', 'لا توجد صدمات مسجلة.'),
              style: TextStyle(fontSize: 13, color: _textSecondary(isDark)),
            ),
          ...shocks.whereType<Map>().map((sh) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    _Chip(
                        text: (sh['severity'] ?? sh['category'] ?? 'shock').toString()),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        (sh['name'] ?? sh['title'] ?? 'Market event').toString(),
                        style:
                            TextStyle(fontSize: 13, color: _textPrimary(isDark)),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// Theme-aware colors keyed by an isDark flag — the AppColors helpers take a
// BuildContext, which the small leaf widgets below don't carry around.
Color _textPrimary(bool isDark) =>
    isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
Color _textSecondary(bool isDark) =>
    isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
Color _bg(bool isDark) => isDark ? AppColors.darkBg : AppColors.lightBg;

/// Website's `fmt`: thousands separators, at most 2 decimals for small numbers.
String _fmt(num n) {
  final abs = n.abs();
  if (abs >= 1000) {
    final rounded = n.round().toString();
    final neg = rounded.startsWith('-');
    final digits = neg ? rounded.substring(1) : rounded;
    final buf = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buf.write(',');
      buf.write(digits[i]);
    }
    return '${neg ? '-' : ''}$buf';
  }
  final fixed = n.toStringAsFixed(2);
  return fixed.endsWith('.00') ? fixed.substring(0, fixed.length - 3) : fixed;
}

/// Round-over-round change, matching the website's `Delta` component.
class _Delta extends StatelessWidget {
  const _Delta({required this.from, required this.to});

  final double from;
  final double to;

  @override
  Widget build(BuildContext context) {
    if (from == 0 || !from.isFinite) {
      return const Icon(Icons.remove, size: 12, color: Color(0xFF9CA3AF));
    }
    final p = ((to - from) / from.abs()) * 100;
    final up = p > 0.05;
    final down = p < -0.05;
    final color = up
        ? const Color(0xFF059669)
        : down
            ? const Color(0xFFDC2626)
            : const Color(0xFF9CA3AF);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          up
              ? Icons.trending_up_rounded
              : down
                  ? Icons.trending_down_rounded
                  : Icons.remove,
          size: 12,
          color: color,
        ),
        const SizedBox(width: 2),
        Text(
          p.abs() >= 0.05 ? '${p > 0 ? '+' : ''}${p.toStringAsFixed(1)}%' : '—',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _textSecondary(isDark).withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 10, color: _textSecondary(isDark)),
      ),
    );
  }
}

/// Prep countdown to `prepEndsAt`; turns red in the last five minutes.
class _Countdown extends StatefulWidget {
  const _Countdown({required this.endsAt});

  final String endsAt;

  @override
  State<_Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<_Countdown> {
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final endsAt = DateTime.tryParse(widget.endsAt);
    final remaining = endsAt == null
        ? 0
        : endsAt.difference(DateTime.now()).inSeconds.clamp(0, 1 << 31);
    final mm = (remaining ~/ 60).toString().padLeft(2, '0');
    final ss = (remaining % 60).toString().padLeft(2, '0');
    final urgent = remaining < 300;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: urgent ? const Color(0xFFFEE2E2) : const Color(0xFFDBEAFE),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_outlined,
              size: 14, color: urgent ? const Color(0xFFB91C1C) : const Color(0xFF1D4ED8)),
          const SizedBox(width: 4),
          Text(
            '$mm:$ss',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: urgent ? const Color(0xFFB91C1C) : const Color(0xFF1D4ED8),
            ),
          ),
        ],
      ),
    );
  }
}

/// The "how to run your earnings call" brief shown during prep.
class _Briefing extends StatelessWidget {
  const _Briefing({required this.s, required this.isDark, required this.prepMinutes});

  final AppStrings s;
  final bool isDark;
  final int prepMinutes;

  @override
  Widget build(BuildContext context) {
    final steps = s.ar
        ? const [
            ['الافتتاح (٣٠ ثانية)', 'عرّفوا بأنفسكم وقدموا العنوان الرئيسي لنتائج السنة.'],
            ['النتائج (٩٠ ثانية)', 'الإيرادات وصافي الدخل والهوامش — السنة الثانية مقابل الأولى بالأرقام.'],
            ['المحركات (٦٠ ثانية)', 'القرارات التي اتخذتموها وصدمات السوق التي أثّرت على النتائج.'],
            ['التوجيهات (٦٠ ثانية)', 'أولوياتكم للسنة الثالثة وما ستفعلونه بشكل مختلف.'],
          ]
        : const [
            ['Opening (30s)', 'Introduce yourselves and give the one-line headline of your year.'],
            ['Results (90s)', 'Revenue, net income, margins — Round 2 vs Round 1, with the numbers.'],
            ['Drivers (60s)', 'The decisions you took and the market shocks that moved your results.'],
            ['Guidance (60s)', 'Your Round 3 priorities and what you will do differently.'],
          ];
    final rules = s.ar
        ? const [
            'كل ادعاء يجب أن يستند إلى رقم في قوائمكم المالية.',
            'يقود العرضَ قائدُ الفريق (المدير المالي)، ويمكن للجميع المشاركة في الإجابات.',
            'التزموا بالوقت المحدد — سيتم إيقاف العرض عند انتهاء الوقت.',
            'ستُقيّمكم الفرق الأخرى على: وضوح العرض، وعمق التحليل، وثقة المستثمر.',
            'سيطرح المحلل أسئلة عن أرقامكم — استعدوا لتفسير أي تغير كبير.',
          ]
        : const [
            'Every claim must be backed by a number from your own statements.',
            'The team leader presents as CFO; anyone may help answer questions.',
            'Respect the timer — presentations are cut off when time is up.',
            'Other teams rate you on: clarity, insight (WHY numbers moved), and investor confidence.',
            'An analyst will question your numbers — be ready to explain every big movement.',
          ];

    return GlassCard(
      padding: const EdgeInsets.all(14),
      borderColor: const Color(0xFF93C5FD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.assignment_rounded, size: 20, color: Color(0xFF2563EB)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  s.ar
                      ? 'دليل مكالمة الأرباح — لديكم $prepMinutes دقيقة للتحضير'
                      : 'Earnings Call Playbook — you have $prepMinutes minutes to prepare',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _textPrimary(isDark),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            s.tr('Presentation structure (4 minutes)', 'هيكل العرض (٤ دقائق)'),
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w700, color: _textPrimary(isDark)),
          ),
          const SizedBox(height: 6),
          ...steps.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 13, height: 1.4, color: _textPrimary(isDark)),
                    children: [
                      TextSpan(
                        text: '${e.key + 1}. ${e.value[0]}: ',
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, color: Color(0xFF1D4ED8)),
                      ),
                      TextSpan(text: e.value[1]),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 8),
          Text(
            s.tr('Rules of the call', 'قواعد المكالمة'),
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w700, color: _textPrimary(isDark)),
          ),
          const SizedBox(height: 6),
          ...rules.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(Icons.check_circle_rounded,
                          size: 15, color: Color(0xFF3B82F6)),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        r,
                        style: TextStyle(
                            fontSize: 13, height: 1.4, color: _textPrimary(isDark)),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

/// One financial statement, from-round vs to-round with the % change.
class _StatementTable extends StatelessWidget {
  const _StatementTable({
    required this.title,
    required this.rows,
    required this.from,
    required this.to,
    required this.s,
    required this.isDark,
  });

  final String title;
  final List<Map<String, dynamic>> rows;
  final String from;
  final String to;
  final AppStrings s;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    double v(Map<String, dynamic> r, String key) => (r[key] as num?)?.toDouble() ?? 0;
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: _textPrimary(isDark),
            ),
          ),
          const SizedBox(height: 8),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(2.4),
              1: FlexColumnWidth(1.1),
              2: FlexColumnWidth(1.1),
              3: FlexColumnWidth(1.1),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: _textSecondary(isDark).withValues(alpha: 0.2)),
                  ),
                ),
                children: [
                  _head(s.tr('Item', 'البند'), TextAlign.start),
                  _head(from.toUpperCase(), TextAlign.end),
                  _head(to.toUpperCase(), TextAlign.end),
                  _head('Δ', TextAlign.end),
                ],
              ),
              ...rows.map((r) => TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          r['label']?.toString() ?? '',
                          style: TextStyle(
                              fontSize: 12.5, color: _textPrimary(isDark)),
                        ),
                      ),
                      _cell(_fmt(v(r, from)), _textSecondary(isDark)),
                      _cell(_fmt(v(r, to)), _textPrimary(isDark), bold: true),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: _Delta(from: v(r, from), to: v(r, to)),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _head(String text, TextAlign align) => Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Text(
          text,
          textAlign: align,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w600, color: _textSecondary(isDark)),
        ),
      );

  Widget _cell(String text, Color color, {bool bold = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(
          text,
          textAlign: TextAlign.end,
          style: TextStyle(
              fontSize: 12.5, color: color, fontWeight: bold ? FontWeight.w600 : null),
        ),
      );
}

/// The typed "official response to the analyst" plus the AI's formative critique.
/// The spoken answer is judged by humans (facilitator rubric + peer scores); the
/// AI only reviews this text against the team's own numbers.
class _AnswerBox extends ConsumerStatefulWidget {
  const _AnswerBox({
    required this.teamId,
    required this.questionIndex,
    required this.question,
    required this.s,
    required this.isDark,
  });

  final String teamId;
  final int questionIndex;
  final Map<String, dynamic> question;
  final AppStrings s;
  final bool isDark;

  @override
  ConsumerState<_AnswerBox> createState() => _AnswerBoxState();
}

enum _AnswerPhase { idle, saving, reviewing, done, error }

class _AnswerBoxState extends ConsumerState<_AnswerBox> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.question['answerText']?.toString() ?? '');
  _AnswerPhase _phase = _AnswerPhase.idle;
  String _error = '';
  ({String en, String ar})? _feedback;

  @override
  void initState() {
    super.initState();
    final en = widget.question['aiFeedbackEn']?.toString();
    if (en != null && en.isNotEmpty) {
      _feedback = (en: en, ar: widget.question['aiFeedbackAr']?.toString() ?? '');
      _phase = _AnswerPhase.done;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _phase = _AnswerPhase.saving;
      _error = '';
      _feedback = null;
    });
    final repo = ref.read(earningsCallRepositoryProvider);
    try {
      final saveError = await repo.submitAnswer(
        teamId: widget.teamId,
        questionIndex: widget.questionIndex,
        answerText: text,
      );
      if (saveError != null) throw Exception(saveError);
      if (!mounted) return;
      setState(() => _phase = _AnswerPhase.reviewing);
      final feedback = await repo.answerFeedback(
        teamId: widget.teamId,
        questionIndex: widget.questionIndex,
      );
      if (!mounted) return;
      setState(() {
        _feedback = feedback;
        _phase = _AnswerPhase.done;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _phase = _AnswerPhase.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.s;
    final busy = _phase == _AnswerPhase.saving || _phase == _AnswerPhase.reviewing;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          maxLength: 1200,
          maxLines: 3,
          enabled: !busy,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            isDense: true,
            counterText: '',
            hintText: s.tr('Your official response to the analyst (2–3 sentences)…',
                'إجابتكم الرسمية للمحلل (٢–٣ جمل)…'),
            hintStyle: TextStyle(
                fontSize: 12.5, color: _textSecondary(widget.isDark)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            FilledButton(
              onPressed: busy ? null : _submit,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                minimumSize: const Size(0, 32),
              ),
              child: Text(
                switch (_phase) {
                  _AnswerPhase.saving => s.tr('Saving…', 'جارٍ الحفظ…'),
                  _AnswerPhase.reviewing => s.tr('Analyst reviewing…', 'المحلل يراجع…'),
                  _ => s.tr('Submit for review', 'إرسال للمراجعة'),
                },
                style: const TextStyle(fontSize: 12),
              ),
            ),
            if (_phase == _AnswerPhase.error) ...[
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _error,
                  style: const TextStyle(fontSize: 11, color: Color(0xFFDC2626)),
                ),
              ),
            ],
          ],
        ),
        if (_feedback != null)
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFA7F3D0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.tr('Analyst feedback (AI)', 'ملاحظات المحلل (ذكاء اصطناعي)'),
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                    color: Color(0xFF047857),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  s.ar && _feedback!.ar.isNotEmpty ? _feedback!.ar : _feedback!.en,
                  style: const TextStyle(
                      fontSize: 13, height: 1.45, color: Color(0xFF1F2937)),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Rate one other team's presentation: clarity, insight, investor confidence.
class _RatingCard extends ConsumerStatefulWidget {
  const _RatingCard({
    required this.presenter,
    required this.raterTeamId,
    required this.raterPlayerName,
    required this.s,
    required this.isDark,
  });

  final String presenter;
  final String raterTeamId;
  final String? raterPlayerName;
  final AppStrings s;
  final bool isDark;

  @override
  ConsumerState<_RatingCard> createState() => _RatingCardState();
}

class _RatingCardState extends ConsumerState<_RatingCard> {
  int _clarity = 0;
  int _insight = 0;
  int _confidence = 0;
  bool _submitted = false;
  bool _busy = false;
  String? _error;

  bool get _complete => _clarity > 0 && _insight > 0 && _confidence > 0;

  Future<void> _submit() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final error = await ref.read(earningsCallRepositoryProvider).ratePresentation(
          presenterTeamId: widget.presenter,
          raterTeamId: widget.raterTeamId,
          clarity: _clarity,
          insight: _insight,
          confidence: _confidence,
          raterPlayerName: widget.raterPlayerName,
        );
    if (!mounted) return;
    setState(() {
      _busy = false;
      _submitted = error == null;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.s;
    return GlassCard(
      padding: const EdgeInsets.all(12),
      borderColor: _submitted ? const Color(0xFFA7F3D0) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.presenter,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _textPrimary(widget.isDark),
                  ),
                ),
              ),
              if (_submitted)
                const Icon(Icons.check_circle_rounded, size: 18, color: Color(0xFF059669)),
            ],
          ),
          const SizedBox(height: 6),
          _stars(s.tr('Clarity', 'الوضوح'), _clarity, (v) => setState(() => _clarity = v)),
          _stars(s.tr('Insight', 'عمق التحليل'), _insight, (v) => setState(() => _insight = v)),
          _stars(s.tr('Investor confidence', 'ثقة المستثمر'), _confidence,
              (v) => setState(() => _confidence = v)),
          if (!_submitted) ...[
            const SizedBox(height: 6),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: !_complete || _busy ? null : _submit,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  minimumSize: const Size(0, 32),
                ),
                child: Text(
                  _busy ? '…' : s.tr('Submit rating', 'إرسال التقييم'),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(_error!,
                  style: const TextStyle(fontSize: 11, color: Color(0xFFDC2626))),
            ),
        ],
      ),
    );
  }

  Widget _stars(String label, int value, ValueChanged<int> onPick) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 12, color: _textSecondary(widget.isDark)),
            ),
          ),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(5, (i) {
                final v = i + 1;
                return IconButton(
                  onPressed: _submitted ? null : () => onPick(v),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                  icon: Icon(
                    value >= v ? Icons.star_rounded : Icons.star_border_rounded,
                    size: 20,
                    color: value >= v ? const Color(0xFFF59E0B) : const Color(0xFFD1D5DB),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
