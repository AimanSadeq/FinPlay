import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/network/api_endpoints.dart';
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

enum _Phase { intro, running, results }

class _AssessmentScreenState extends ConsumerState<AssessmentScreen> {
  _Phase _phase = _Phase.intro;
  int _index = 0;
  final Map<String, int> _answers = {};

  // The working question set. Loaded from the server per kind (so pre/post can
  // differ and stay current); falls back to the bundled bank when offline.
  List<AssessmentQuestion> _questions = kAssessmentBank;

  // results
  int _score = 0;
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
    });
  }

  Future<void> _submit() async {
    int score = 0;
    for (final q in _questions) {
      if (_answers[q.id] == q.correctIdx) score++;
    }
    _score = score;

    // Persist locally so pre/post can be compared.
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_storeKey, score);

    // Best-effort submit to the backend (ignored if offline).
    try {
      await ref.read(apiClientProvider).post(
        ApiEndpoints.assessmentSubmit,
        data: {
          'kind': widget.kind,
          'answers': _answers,
          'version': kAssessmentVersion,
        },
      );
    } catch (_) {/* offline-friendly */}

    if (mounted) setState(() => _phase = _Phase.results);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration:
            BoxDecoration(gradient: AppColors.backgroundGradient(context)),
        child: SafeArea(
          child: switch (_phase) {
            _Phase.intro => _buildIntro(),
            _Phase.running => _buildRunner(),
            _Phase.results => _buildResults(),
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
                  onPressed: selected == null
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
    final total = _questions.length;
    final pct = (_score / total * 100).round();
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
                final correct = sel == q.correctIdx;
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
                        if (!correct)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                                s.tr('Correct: ', 'الصحيح: ') + q.options[q.correctIdx],
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
