import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/utils/constants.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/repository_providers.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../data/assessment_bank.dart';
import '../../../app/i18n/app_strings.dart';

/// Pre / post knowledge assessment. `kind` is 'pre' or 'post'.
class AssessmentScreen extends ConsumerStatefulWidget {
  final String kind;
  const AssessmentScreen({super.key, required this.kind});

  @override
  ConsumerState<AssessmentScreen> createState() => _AssessmentScreenState();
}

enum _Phase { loading, intro, running, results, blocked }

/// Why the assessment cannot be taken here (website assessment.tsx gates).
enum AssessmentBlock { loadError, suppressed, alreadyDone, needsSignIn }

/// What GET /assessments/status means for this learner, decided before the
/// first question (website 515b5a1 / 5d894a7 / 1cfce67).
class AssessmentGate {
  const AssessmentGate._(this.block, {this.reason, this.score, this.total});

  /// Null when the assessment may be taken.
  final AssessmentBlock? block;
  final String? reason;
  final int? score;
  final int? total;

  bool get open => block == null;

  /// `suppressed` (a research cohort: the assessment does not run here) wins,
  /// then `anonymous` (no valid session: a submit would be refused), then a
  /// recorded attempt (one attempt per person per kind).
  factory AssessmentGate.fromStatus(Map<String, dynamic> status) {
    if (status['suppressed'] == true) {
      return AssessmentGate._(AssessmentBlock.suppressed,
          reason: status['suppressedReason']?.toString());
    }
    if (status['anonymous'] == true) return const AssessmentGate._(AssessmentBlock.needsSignIn);
    if (status['completed'] == true) {
      final last = status['lastScore'];
      return AssessmentGate._(AssessmentBlock.alreadyDone,
          score: last is Map ? (last['score'] as num?)?.toInt() : null,
          total: last is Map ? (last['total'] as num?)?.toInt() : null);
    }
    return const AssessmentGate._(null);
  }
}

class _AssessmentScreenState extends ConsumerState<AssessmentScreen> {
  _Phase _phase = _Phase.loading;
  AssessmentBlock? _block;
  String? _blockReason; // suppressedReason from the server
  int? _priorScore; // a recorded attempt (status lastScore, or the 409 body)
  int? _priorTotal;
  bool _submitting = false;
  bool _sessionExpired = false; // a submit came back 401
  String? _submitError;
  String? _startedAt;
  // Correct option per question id, from the server's grading (authoritative).
  Map<String, int> _serverKey = const {};
  int _index = 0;
  final Map<String, int> _answers = {};

  // The working question set. Loaded from the server per kind (so pre/post can
  // differ and stay current); falls back to the bundled bank when offline.
  List<AssessmentQuestion> _questions = kAssessmentBank;

  // results (the server's grade)
  int _score = 0;
  int _total = 0;
  int? _otherScore; // the opposite kind's last score, for comparison

  bool get _isPre => widget.kind == 'pre';
  String get _kindLabel {
    final s = ref.read(stringsProvider);
    return _isPre ? s.tr('Pre-Course', 'ما قبل الدورة') : s.tr('Post-Course', 'ما بعد الدورة');
  }

  String get _storeKey => 'assessment_${widget.kind}_score';
  String get _otherKey =>
      'assessment_${_isPre ? 'post' : 'pre'}_score';

  Future<void> _loadOther() async {
    final prefs = await SharedPreferences.getInstance();
    final v = prefs.getInt(_otherKey);
    if (mounted) setState(() => _otherScore = v);
  }

  @override
  void initState() {
    super.initState();
    _loadOther();
    _loadQuestions();
    _loadStatus();
  }

  /// Corporate delegates identify with their team-member bearer token plus
  /// x-team-id / x-player-name (website assessment-api.ts). Self-paced learners
  /// need only the bearer, which ApiClient already carries.
  Future<Map<String, String>> _actorHeaders() async {
    if (ref.read(authProvider).user != null) return const {};
    final prefs = await SharedPreferences.getInstance();
    final teamId = prefs.getString(AppConstants.teamIdKey);
    final player = prefs.getString(AppConstants.playerNameKey);
    if (teamId == null || player == null || player.isEmpty) return const {};
    return {'x-team-id': teamId, 'x-player-name': player};
  }

  /// A request that keeps the HTTP status (ApiClient.post drops it).
  Future<({int status, Map<String, dynamic> body})> _request(String path,
      {Map<String, dynamic>? query, Object? data}) async {
    final dio = ref.read(apiClientProvider).dio;
    final options = Options(headers: await _actorHeaders());
    try {
      final r = data == null
          ? await dio.get(path, queryParameters: query, options: options)
          : await dio.post(path, data: data, options: options);
      final body = r.data is Map ? Map<String, dynamic>.from(r.data as Map) : <String, dynamic>{};
      return (status: r.statusCode ?? 200, body: body);
    } on DioException catch (e) {
      final res = e.response;
      if (res == null) rethrow; // offline / timeout
      final body = res.data is Map ? Map<String, dynamic>.from(res.data as Map) : <String, dynamic>{};
      return (status: res.statusCode ?? 0, body: body);
    }
  }

  Future<void> _loadStatus() async {
    setState(() {
      _phase = _Phase.loading;
      _block = null;
    });
    try {
      final r = await _request(ApiEndpoints.assessmentStatus, query: {'kind': widget.kind});
      if (!mounted) return;
      if (r.status >= 400) throw Exception(r.body['error'] ?? 'Failed to load status');
      final gate = AssessmentGate.fromStatus(r.body);
      setState(() {
        if (gate.open) {
          _phase = _Phase.intro;
        } else {
          _phase = _Phase.blocked;
          _block = gate.block;
          _blockReason = gate.reason;
          _priorScore = gate.score;
          _priorTotal = gate.total;
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _phase = _Phase.blocked;
        _block = AssessmentBlock.loadError;
      });
    }
  }

  /// Fetch the question set for this kind from the server, merging the local
  /// answer key (matched by id) for client-side scoring. The server omits the
  /// correct answers (anti-cheat), so we keep the bundled key. Falls back to the
  /// full local bank on any failure.
  Future<void> _loadQuestions() async {
    try {
      final res = await ref
          .read(apiClientProvider)
          .get(ApiEndpoints.assessmentQuestions, params: {'kind': widget.kind});
      final raw = res['questions'];
      if (raw is! List || raw.isEmpty) return;
      final keyById = {for (final q in kAssessmentBank) q.id: q.correctIdx};
      final merged = <AssessmentQuestion>[];
      for (final item in raw) {
        if (item is! Map) continue;
        final id = (item['id'] ?? '').toString();
        final options =
            (item['options'] as List?)?.map((e) => e.toString()).toList() ?? const [];
        if (id.isEmpty || options.isEmpty) continue;
        merged.add(AssessmentQuestion(
          id: id,
          module: (item['module'] ?? '').toString(),
          topic: (item['topic'] ?? '').toString(),
          question: (item['question'] ?? '').toString(),
          options: options,
          // Use the bundled answer key; -1 means "unscorable" (kept out of scoring).
          correctIdx: keyById[id] ?? -1,
        ));
      }
      if (merged.isNotEmpty && mounted) setState(() => _questions = merged);
    } catch (_) {
      // Offline / unauthenticated — keep the bundled bank.
    }
  }

  void _start() {
    setState(() {
      _phase = _Phase.running;
      _index = 0;
      _startedAt ??= DateTime.now().toUtc().toIso8601String();
    });
  }

  /// The server grades the attempt; a result is shown only once it has been
  /// recorded. Failures keep the answers and say so — never a local score.
  Future<void> _submit() async {
    if (_submitting) return;
    setState(() {
      _submitting = true;
      _submitError = null;
      _sessionExpired = false;
    });
    final s = ref.read(stringsProvider);
    try {
      final r = await _request(ApiEndpoints.assessmentSubmit, data: {
        'kind': widget.kind,
        'answers': _answers,
        if (_startedAt != null) 'startedAt': _startedAt,
      });
      if (!mounted) return;
      final attempt = r.body['attempt'];
      if (r.status == 409) {
        // One attempt per person per kind: show the one already on record.
        setState(() {
          _phase = _Phase.blocked;
          _block = AssessmentBlock.alreadyDone;
          _priorScore = attempt is Map ? (attempt['score'] as num?)?.toInt() : null;
          _priorTotal = attempt is Map ? (attempt['total'] as num?)?.toInt() : null;
        });
      } else if (r.status == 403) {
        // A research cohort: the server refuses the commercial assessment.
        setState(() {
          _phase = _Phase.blocked;
          _block = AssessmentBlock.suppressed;
          _blockReason = r.body['error']?.toString();
        });
      } else if (r.status == 401) {
        // Session died mid-assessment. Stay on the runner so the answers are
        // kept: the learner signs in (the login pops back here) and resubmits.
        setState(() {
          _sessionExpired = true;
          _submitError = s.tr(
              "Your session isn't active, so your answers couldn't be saved. Sign in, then submit again - your answers are kept.",
              'جلستك غير نشطة، لذا تعذّر حفظ إجاباتك. سجّل الدخول ثم أعد الإرسال - إجاباتك محفوظة.');
        });
      } else if (r.status < 300 && r.body['success'] == true && attempt is Map) {
        final score = (attempt['score'] as num?)?.toInt() ?? 0;
        final total = (attempt['total'] as num?)?.toInt() ?? _questions.length;
        final key = <String, int>{};
        final per = r.body['perQuestion'];
        if (per is List) {
          for (final q in per) {
            if (q is Map && q['id'] != null && q['correct'] is num) {
              key[q['id'].toString()] = (q['correct'] as num).toInt();
            }
          }
        }
        // Persist locally so pre/post can be compared.
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(_storeKey, score);
        if (!mounted) return;
        setState(() {
          _score = score;
          _total = total;
          _serverKey = key;
          _phase = _Phase.results;
        });
      } else {
        setState(() => _submitError = r.body['error']?.toString() ??
            s.tr('Submit failed. Please try again.', 'تعذّر الإرسال. يرجى المحاولة مرة أخرى.'));
      }
    } catch (_) {
      if (mounted) {
        setState(() => _submitError = s.tr(
            "Couldn't reach the server, so your answers were not saved. Check your connection and submit again.",
            'تعذّر الوصول إلى الخادم، لذا لم تُحفظ إجاباتك. تحقّق من اتصالك وأعد الإرسال.'));
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration:
            BoxDecoration(gradient: AppColors.backgroundGradient(context)),
        child: SafeArea(
          child: switch (_phase) {
            _Phase.loading => const Center(child: CircularProgressIndicator()),
            _Phase.intro => _buildIntro(),
            _Phase.running => _buildRunner(),
            _Phase.results => _buildResults(),
            _Phase.blocked => _buildBlocked(),
          },
        ),
      ),
    );
  }

  // ── Intro ──
  Widget _buildIntro() {
    final s = ref.watch(stringsProvider);
    return Column(
      children: [
        _appBar('$_kindLabel ${s.tr('Assessment', 'التقييم')}'),
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: GlassCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.quiz_rounded,
                          color: AppColors.primaryLight, size: 32),
                    ),
                    const SizedBox(height: 16),
                    Text('$_kindLabel ${s.tr('Knowledge Check', 'اختبار المعرفة')}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(
                      _isPre
                          ? s.tr(
                              'This is your baseline. ${_questions.length} quick questions across all modules — don\'t worry if you miss some; the course will fill the gaps.',
                              'هذا هو مستواك الأساسي. ${_questions.length} أسئلة سريعة تغطي جميع الوحدات — لا تقلق إن أخطأت في بعضها؛ ستملأ الدورة الفجوات.')
                          : s.tr(
                              'Great work finishing the course. Answer ${_questions.length} questions, then compare with your pre-course score to see your progress.',
                              'عمل رائع بإكمالك الدورة. أجب عن ${_questions.length} سؤالًا، ثم قارن نتيجتك بما قبل الدورة لترى تقدّمك.'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 13.5,
                          height: 1.5,
                          color: AppColors.textSecondary(context)),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _introStat('${_questions.length}', s.tr('Questions', 'أسئلة')),
                        _introStat('11', s.tr('Modules', 'وحدات')),
                        _introStat('~8', s.tr('Minutes', 'دقائق')),
                      ],
                    ),
                    const SizedBox(height: 24),
                    GradientButton(
                      text: s.tr('Start Assessment', 'ابدأ التقييم'),
                      icon: Icons.play_arrow_rounded,
                      width: double.infinity,
                      onPressed: _start,
                    ),
                  ],
                ),
              ).animate().fadeIn().slideY(begin: 0.05),
            ),
          ),
        ),
      ],
    );
  }

  Widget _introStat(String v, String l) => Column(
        children: [
          Text(v,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryLight)),
          Text(l,
              style: TextStyle(
                  fontSize: 11, color: AppColors.textTertiary(context))),
        ],
      );

  // ── Runner ──
  Widget _buildRunner() {
    final s = ref.watch(stringsProvider);
    final q = _questions[_index];
    final answered = _answers.length;
    final selected = _answers[q.id];
    final isLast = _index == _questions.length - 1;

    return Column(
      children: [
        _appBar(s.tr('Question ${_index + 1} of ${_questions.length}',
            'السؤال ${_index + 1} من ${_questions.length}')),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: answered / _questions.length,
                  minHeight: 5,
                  backgroundColor:
                      AppColors.borderColor(context).withValues(alpha: 0.3),
                  valueColor: const AlwaysStoppedAnimation(
                      AppColors.primaryLight),
                ),
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerRight,
                child: Text(s.tr('$answered / ${_questions.length} answered',
                    '$answered / ${_questions.length} تمت الإجابة عنها'),
                    style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textTertiary(context))),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            key: ValueKey(q.id),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(q.module,
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryLight)),
                  ),
                  const SizedBox(width: 8),
                  Text(q.topic,
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textTertiary(context))),
                ],
              ),
              const SizedBox(height: 14),
              Text(q.question,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      height: 1.4,
                      color: AppColors.textPrimary(context))),
              const SizedBox(height: 18),
              ...List.generate(q.options.length, (i) {
                final isSel = selected == i;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: () => setState(() => _answers[q.id] = i),
                    child: AnimatedContainer(
                      duration: 150.ms,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isSel
                            ? AppColors.primaryLight.withValues(alpha: 0.1)
                            : AppColors.surfaceColor(context),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSel
                              ? AppColors.primaryLight
                              : AppColors.borderColor(context),
                          width: isSel ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSel
                                  ? AppColors.primaryLight
                                  : Colors.transparent,
                              border: Border.all(
                                  color: isSel
                                      ? AppColors.primaryLight
                                      : AppColors.borderColor(context),
                                  width: 1.5),
                            ),
                            child: Center(
                              child: Text(
                                String.fromCharCode(65 + i),
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: isSel
                                        ? Colors.white
                                        : AppColors.textTertiary(context)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(q.options[i],
                                style: TextStyle(
                                    fontSize: 14,
                                    height: 1.4,
                                    color: AppColors.textPrimary(context))),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        if (_submitError != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Column(
              children: [
                Text(_submitError!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12.5, color: AppColors.dangerLight)),
                if (_sessionExpired)
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    children: [
                      // Pushed (not go): this screen and its answers stay underneath.
                      TextButton(
                        onPressed: () => context.push('/self-paced-login?return=1'),
                        child: Text(s.tr('Learner sign in', 'تسجيل دخول المتعلّم')),
                      ),
                      TextButton(
                        onPressed: _submitting ? null : _submit,
                        child: Text(s.tr('Submit again', 'أعد الإرسال')),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        // Nav
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: Row(
            children: [
              if (_index > 0)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => setState(() => _index--),
                    icon: const Icon(Icons.arrow_back_rounded, size: 18),
                    label: Text(s.tr('Back', 'رجوع')),
                    style: OutlinedButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(vertical: 14)),
                  ),
                ),
              if (_index > 0) const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: GradientButton(
                  text: isLast
                      ? s.tr('Submit ($answered/${_questions.length})',
                          'إرسال ($answered/${_questions.length})')
                      : s.tr('Next', 'التالي'),
                  icon: isLast
                      ? Icons.check_rounded
                      : Icons.arrow_forward_rounded,
                  width: double.infinity,
                  isLoading: _submitting,
                  onPressed: selected == null || _submitting
                      ? null
                      : isLast
                          ? (answered == _questions.length
                              ? _submit
                              : () => _jumpToFirstUnanswered())
                          : () => setState(() => _index++),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _jumpToFirstUnanswered() {
    final i = _questions.indexWhere((q) => !_answers.containsKey(q.id));
    if (i >= 0) {
      setState(() => _index = i);
      final s = ref.read(stringsProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(s.tr('Please answer all questions before submitting.',
                'يرجى الإجابة عن جميع الأسئلة قبل الإرسال.'))),
      );
    } else {
      _submit();
    }
  }

  // ── Results ──
  Widget _buildResults() {
    final s = ref.watch(stringsProvider);
    final total = _total > 0 ? _total : _questions.length;
    final pct = total == 0 ? 0 : (_score / total * 100).round();
    final Color tone = pct >= 80
        ? AppColors.secondaryLight
        : pct >= 50
            ? AppColors.accentLight
            : AppColors.dangerLight;

    return Column(
      children: [
        _appBar('$_kindLabel ${s.tr('Results', 'النتائج')}'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              GlassCard(
                borderColor: tone.withValues(alpha: 0.4),
                backgroundColor: tone.withValues(alpha: 0.05),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text('$_score / $total',
                        style: GoogleFonts.jetBrainsMono(
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                            color: tone)),
                    Text('$pct%',
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: tone)),
                    const SizedBox(height: 10),
                    Text(
                      _isPre
                          ? s.tr(
                              "This is your baseline. Don't worry if you missed some; the course will build the gaps.",
                              'هذا هو مستواك الأساسي. لا تقلق إن أخطأت في بعضها؛ ستبني الدورة الفجوات.')
                          : s.tr(
                              'Great work finishing the course. Compare with your pre-course score to see your progress.',
                              'عمل رائع بإكمالك الدورة. قارن نتيجتك بما قبل الدورة لترى تقدّمك.'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 13,
                          height: 1.5,
                          color: AppColors.textSecondary(context)),
                    ),
                    if (_otherScore != null) ...[
                      const SizedBox(height: 14),
                      _comparison(total),
                    ],
                  ],
                ),
              ).animate().fadeIn().slideY(begin: 0.05),
              const SizedBox(height: 16),
              Text(s.tr('Review', 'مراجعة'),
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              ..._questions.map((q) {
                final sel = _answers[q.id];
                final correctIdx = _serverKey[q.id] ?? q.correctIdx;
                final correct = sel == correctIdx;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GlassCard(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              correct
                                  ? Icons.check_circle_rounded
                                  : Icons.cancel_rounded,
                              color: correct
                                  ? AppColors.secondaryLight
                                  : AppColors.dangerLight,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(q.question,
                                  style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w600,
                                      height: 1.35,
                                      color:
                                          AppColors.textPrimary(context))),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(s.tr('Your answer: ', 'إجابتك: ') + (sel != null ? q.options[sel] : '—'),
                            style: TextStyle(
                                fontSize: 12.5,
                                color: correct
                                    ? AppColors.secondaryLight
                                    : AppColors.dangerLight)),
                        if (!correct && correctIdx >= 0 && correctIdx < q.options.length)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                                s.tr('Correct: ', 'الصحيح: ') + q.options[correctIdx],
                                style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.secondaryLight)),
                          ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 8),
              GradientButton(
                text: s.tr('Done', 'تم'),
                icon: Icons.done_all_rounded,
                width: double.infinity,
                onPressed: () => context.pop(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Blocked (website FullPageMessage states) ──
  Widget _buildBlocked() {
    final s = ref.watch(stringsProvider);
    late final String title;
    late final String body;
    IconData icon = Icons.info_outline_rounded;
    final actions = <Widget>[];
    Widget back() => OutlinedButton(
          onPressed: () => context.pop(),
          child: Text(s.tr('Back to the course', 'العودة إلى الدورة')),
        );
    switch (_block!) {
      case AssessmentBlock.alreadyDone:
        icon = Icons.task_alt_rounded;
        title = _isPre
            ? s.tr('Pre-course assessment already completed', 'تم إكمال تقييم ما قبل الدورة مسبقًا')
            : s.tr('Post-course assessment already completed', 'تم إكمال تقييم ما بعد الدورة مسبقًا');
        body = (_priorTotal ?? 0) > 0
            ? s.tr(
                'Your recorded score is $_priorScore/$_priorTotal. Each assessment can be taken once.',
                'نتيجتك المسجّلة هي $_priorScore/$_priorTotal. يمكن أداء كل تقييم مرة واحدة فقط.')
            : s.tr('You have already completed this assessment. Each assessment can be taken once.',
                'لقد أكملت هذا التقييم مسبقًا. يمكن أداء كل تقييم مرة واحدة فقط.');
        actions.add(back());
      case AssessmentBlock.suppressed:
        icon = Icons.block_rounded;
        title = s.tr('Assessment not available for this group', 'التقييم غير متاح لهذه المجموعة');
        body = _blockReason ??
            s.tr('This cohort is enrolled in the research study, so the course assessment does not run here.',
                'هذه المجموعة مسجّلة في الدراسة البحثية، لذا لا يُجرى تقييم الدورة هنا.');
        actions.add(back());
      case AssessmentBlock.needsSignIn:
        icon = Icons.lock_outline_rounded;
        title = s.tr('Sign in to take the assessment', 'سجّل الدخول لأداء التقييم');
        body = s.tr(
            "Your session isn't active, so your answers couldn't be saved. Sign in first.",
            'جلستك غير نشطة، لذا تعذّر حفظ إجاباتك. سجّل الدخول أولًا.');
        actions
          ..add(FilledButton(
            onPressed: () => context.push('/self-paced-login'),
            child: Text(s.tr('Learner sign in', 'تسجيل دخول المتعلّم')),
          ))
          ..add(OutlinedButton(
            onPressed: () => context.push('/lobby'),
            child: Text(s.tr('Join a team', 'انضم إلى فريق')),
          ));
      case AssessmentBlock.loadError:
        icon = Icons.cloud_off_rounded;
        title = s.tr("Couldn't load the assessment", 'تعذّر تحميل التقييم');
        body = s.tr('Check your connection and try again.', 'تحقّق من اتصالك وحاول مرة أخرى.');
        actions.add(FilledButton(
          onPressed: _loadStatus,
          child: Text(s.tr('Try again', 'حاول مرة أخرى')),
        ));
    }
    return Column(
      children: [
        _appBar('$_kindLabel ${s.tr('Assessment', 'التقييم')}'),
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: GlassCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(icon, size: 40, color: AppColors.primaryLight),
                    const SizedBox(height: 14),
                    Text(title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(body,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 13.5,
                            height: 1.5,
                            color: AppColors.textSecondary(context))),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: actions,
                    ),
                  ],
                ),
              ).animate().fadeIn(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _comparison(int total) {
    final s = ref.watch(stringsProvider);
    final other = _otherScore!;
    final delta = _isPre ? 0 : _score - other; // post − pre
    final preScore = _isPre ? _score : other;
    final postScore = _isPre ? other : _score;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _cmpStat(s.tr('Pre', 'قبل'), '$preScore/$total', AppColors.textSecondary(context)),
              const Icon(Icons.arrow_forward_rounded, size: 16),
              _cmpStat(s.tr('Post', 'بعد'), '$postScore/$total', AppColors.primaryLight),
            ],
          ),
          if (!_isPre) ...[
            const SizedBox(height: 8),
            Text(
              delta > 0
                  ? s.tr('▲ +$delta improvement vs pre-course',
                      '▲ +$delta تحسّن مقارنةً بما قبل الدورة')
                  : delta == 0
                      ? s.tr('Same as your pre-course score',
                          'نفس نتيجة ما قبل الدورة')
                      : s.tr('▼ $delta vs pre-course',
                          '▼ $delta مقارنةً بما قبل الدورة'),
              style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: delta > 0
                      ? AppColors.secondaryLight
                      : delta == 0
                          ? AppColors.textTertiary(context)
                          : AppColors.dangerLight),
            ),
          ],
        ],
      ),
    );
  }

  Widget _cmpStat(String label, String value, Color color) => Column(
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 11, color: AppColors.textTertiary(context))),
          Text(value,
              style: GoogleFonts.jetBrainsMono(
                  fontSize: 16, fontWeight: FontWeight.w700, color: color)),
        ],
      );

  Widget _appBar(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () => context.pop()),
          const Spacer(),
          Flexible(
            child: Text(title,
                style: Theme.of(context).textTheme.titleLarge,
                overflow: TextOverflow.ellipsis),
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
