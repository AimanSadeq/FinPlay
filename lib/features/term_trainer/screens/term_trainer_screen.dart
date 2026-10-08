import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/i18n/app_strings.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/utils/constants.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/repository_providers.dart';
import '../../knowledge/data/financial_term.dart';
import '../data/srs_api.dart';
import '../data/trainer_session.dart';

const String _loginRoute = '/self-paced-login';
const String _hubRoute = '/education';

const _orange = Color(0xFFF97316);

/// Opens Daily Practice as a pop-up over the current screen (the website opens it as a
/// dialog on the education hub rather than navigating away).
Future<void> showDailyPractice(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (sheetContext) => FractionallySizedBox(
      heightFactor: 0.94,
      child: Consumer(builder: (context, ref, _) {
        final s = ref.watch(stringsProvider);
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 8, 4),
              child: Row(children: [
                const Icon(Icons.local_fire_department_rounded, color: Color(0xFFF59E0B)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    s.tr('Daily Practice - Term Trainer', 'التدريب اليومي - مدرب المصطلحات'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(sheetContext).pop(),
                ),
              ]),
            ),
            Expanded(
              child: TermTrainerView(embedded: true, onClose: () => Navigator.of(sheetContext).pop()),
            ),
          ],
        );
      }),
    ),
  );
}

/// Full-screen Term Trainer (web route /term-trainer).
class TermTrainerScreen extends ConsumerWidget {
  const TermTrainerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          const Icon(Icons.menu_book_rounded, color: AppColors.primaryLight, size: 20),
          const SizedBox(width: 8),
          Text(s.tr('Term Trainer', 'مدرب المصطلحات'),
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
        ]),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient(context)),
        child: const SafeArea(top: false, child: TermTrainerView()),
      ),
    );
  }
}

enum _Phase { checking, signedOut, loading, empty, session, done, error, expired }

/// Duolingo/Anki-style daily flashcard practice over the Financial Terms Directory
/// (website parity: client/src/pages/term-trainer.tsx). Scheduling lives on the server
/// (/api/srs, SM-2-lite); every review also feeds the daily streak in the flame chip.
class TermTrainerView extends ConsumerStatefulWidget {
  /// Hosted inside a pop-up: no page chrome, [onClose] replaces back-navigation.
  final bool embedded;
  final VoidCallback? onClose;
  const TermTrainerView({super.key, this.embedded = false, this.onClose});

  @override
  ConsumerState<TermTrainerView> createState() => _TermTrainerViewState();
}

class _TermTrainerViewState extends ConsumerState<TermTrainerView> {
  _Phase _phase = _Phase.checking;
  String? _token;
  TrainerSession? _session;
  StreakInfo _streak = const StreakInfo();
  int _learnedCount = 0;
  bool _revealed = false;
  bool _grading = false;
  String _error = '';

  /// Language the card is showing; reset to the app language for every card.
  late bool _showArabic;

  SrsApi get _api => SrsApi(ref.read(apiClientProvider));

  @override
  void initState() {
    super.initState();
    _showArabic = ref.read(stringsProvider).ar;
    _init();
  }

  Future<void> _init() async {
    _token = await SrsApi.learnerToken();
    if (!mounted) return;
    if (_token == null) {
      setState(() => _phase = _Phase.signedOut);
    } else {
      await _startSession();
    }
  }

  Future<void> _startSession() async {
    final token = _token;
    if (token == null) return;
    setState(() {
      _phase = _Phase.loading;
      _error = '';
    });
    try {
      final q = await _api.queue(token, allTermIds: allTrainerTermIds, limit: trainerSessionSize);
      final cards = buildSessionCards(q.due, q.newTerms);
      if (!mounted) return;
      setState(() {
        _streak = q.streak;
        _learnedCount = q.learnedCount;
        _session = TrainerSession(cards);
        _revealed = false;
        _showArabic = ref.read(stringsProvider).ar;
        _phase = cards.isEmpty ? _Phase.empty : _Phase.session;
      });
    } on SrsUnauthorized {
      if (mounted) setState(() => _phase = _Phase.expired);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e is SrsFailure ? e.message : 'Could not load your practice queue';
        _phase = _Phase.error;
      });
    }
  }

  Future<void> _grade(int grade) async {
    final session = _session;
    final token = _token;
    if (_grading || !_revealed || session == null || token == null) return;
    final card = session.current;
    if (card == null) return;
    setState(() => _grading = true);
    try {
      final streak = await _api.review(token, termId: card.id, grade: grade);
      if (streak != null) _streak = streak;
    } catch (_) {
      // A dropped review shouldn't strand the session: the card simply stays due.
    }
    if (!mounted) return;
    setState(() {
      session.grade(grade);
      _revealed = false;
      _showArabic = ref.read(stringsProvider).ar;
      _grading = false;
      if (session.isDone) _phase = _Phase.done;
    });
  }

  /// Closes the pop-up (when hosted in one) and goes to the self-paced sign-in.
  void _goToLogin() {
    final router = GoRouter.of(context);
    widget.onClose?.call();
    router.go(_loginRoute);
  }

  Future<void> _signInAgain() async {
    // Clear the dead self-paced credentials so every screen agrees the learner is signed out.
    try {
      final prefs = await SharedPreferences.getInstance();
      if ((prefs.getString(AppConstants.selfPacedTokenKey) ?? '').isNotEmpty) {
        await ref.read(authProvider.notifier).logout();
      }
    } catch (_) {/* navigation alone still lands on the login page */}
    if (mounted) _goToLogin();
  }

  void _leave() {
    if (widget.embedded && widget.onClose != null) {
      widget.onClose!();
    } else if (context.canPop()) {
      context.pop();
    } else {
      context.go(_hubRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final content = switch (_phase) {
      _Phase.checking || _Phase.loading => _loading(s),
      _Phase.signedOut => _signedOut(s),
      _Phase.error => _errorCard(s),
      _Phase.expired => _expired(s),
      _Phase.empty => _empty(s),
      _Phase.session => _sessionView(s),
      _Phase.done => _doneView(s),
    };
    final showStreak = _phase != _Phase.signedOut && _phase != _Phase.checking;
    return ListView(
      padding: EdgeInsets.fromLTRB(16, widget.embedded ? 0 : 16, 16, 24),
      children: [
        if (showStreak)
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: StreakChip(streak: _streak, s: s),
          ),
        const SizedBox(height: 8),
        content,
      ],
    );
  }

  Widget _card({required Widget child, Color? border}) => Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: border ?? AppColors.borderColor(context), width: 1.5),
        ),
        child: Padding(padding: const EdgeInsets.all(20), child: child),
      );

  Widget _iconBubble(IconData icon, Color color) => Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(color: color.withValues(alpha: 0.14), shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 28),
      );

  Widget _centered(List<Widget> children) => _card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      );

  TextStyle get _h => TextStyle(fontSize: 19, fontWeight: FontWeight.w700, color: AppColors.textPrimary(context));
  TextStyle get _p => TextStyle(fontSize: 13.5, height: 1.45, color: AppColors.textSecondary(context));

  Widget _loading(AppStrings s) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 80),
        child: Column(children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 14),
          Text(s.tr('Building your practice session...', 'جارٍ إعداد جلسة التدريب...'), style: _p),
        ]),
      );

  Widget _signedOut(AppStrings s) => _centered([
        Center(child: _iconBubble(Icons.local_fire_department_rounded, _orange)),
        const SizedBox(height: 14),
        Text(s.tr('Term Trainer', 'مدرب المصطلحات'), style: _h, textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text(
          s.tr(
            'Daily flashcard practice with spaced repetition and streaks is part of the self-paced program. Sign in to start building your streak.',
            'التدريب اليومي بالبطاقات مع التكرار المتباعد وسلاسل الأيام جزء من برنامج التعلّم الذاتي. سجّل الدخول لتبدأ سلسلتك.',
          ),
          style: _p,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 18),
        FilledButton.icon(
          onPressed: _goToLogin,
          icon: const Icon(Icons.login_rounded),
          label: Text(s.tr('Sign in to practice', 'سجّل الدخول للتدريب')),
        ),
        TextButton(onPressed: _leave, child: Text(widget.embedded ? s.tr('Close', 'إغلاق') : s.tr('Back to Education Hub', 'العودة إلى مركز التعلم'))),
      ]);

  Widget _errorCard(AppStrings s) => _card(
        border: AppColors.danger.withValues(alpha: 0.35),
        child: Column(children: [
          Text(_error, style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: _startSession,
            icon: const Icon(Icons.refresh_rounded),
            label: Text(s.tr('Try again', 'حاول مرة أخرى')),
          ),
        ]),
      );

  Widget _expired(AppStrings s) => _centered([
        Center(child: _iconBubble(Icons.login_rounded, _orange)),
        const SizedBox(height: 14),
        Text(s.tr('Session expired', 'انتهت الجلسة'), style: _h, textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text(
          s.tr("You've been signed out after a period of inactivity. Sign in again to keep your streak going.",
              'تم تسجيل خروجك بعد فترة من عدم النشاط. سجّل الدخول مجددًا لتحافظ على سلسلتك.'),
          style: _p,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 18),
        FilledButton.icon(
          onPressed: _signInAgain,
          icon: const Icon(Icons.login_rounded),
          label: Text(s.tr('Sign in again', 'سجّل الدخول مجددًا')),
        ),
        if (widget.embedded && widget.onClose != null)
          TextButton(onPressed: widget.onClose, child: Text(s.tr('Close', 'إغلاق'))),
      ]);

  Widget _empty(AppStrings s) => _centered([
        Center(child: _iconBubble(Icons.check_circle_rounded, AppColors.secondary)),
        const SizedBox(height: 14),
        Text(s.tr("You're all caught up!", 'أنهيت كل المستحق!'), style: _h, textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text(
          s.tr(
            "No cards are due right now. You've learned $_learnedCount term${_learnedCount == 1 ? '' : 's'} so far - come back tomorrow to keep your streak alive.",
            'لا توجد بطاقات مستحقة الآن. تعلّمت حتى الآن $_learnedCount مصطلحًا - عُد غدًا لتحافظ على سلسلتك.',
          ),
          style: _p,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: _leave,
          child: Text(widget.embedded ? s.tr('Close', 'إغلاق') : s.tr('Back to Education Hub', 'العودة إلى مركز التعلم')),
        ),
      ]);

  Widget _sessionView(AppStrings s) {
    final session = _session!;
    final card = session.current!;
    final ar = _showArabic;
    final total = session.totalUnique;
    final shownFormula = card.formulaIn(ar);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: total > 0 ? session.completed / total : 0,
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text('${(session.completed + 1).clamp(1, total)}/$total',
              style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary(context))),
        ]),
        const SizedBox(height: 14),
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.borderColor(context)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(termCategoryLabel(card.category, ar).toUpperCase(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 10.5, letterSpacing: 0.8, color: AppColors.textSecondary(context))),
                  ),
                ),
                const Spacer(),
                if (_revealed)
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    onPressed: () => setState(() => _showArabic = !_showArabic),
                    icon: const Icon(Icons.translate_rounded, size: 15),
                    label: Text(ar ? 'English' : 'العربية', style: const TextStyle(fontSize: 12)),
                  ),
              ]),
              const SizedBox(height: 12),
              // The chosen language leads; the other sits underneath as a reference.
              Text(card.termIn(ar),
                  textDirection: ar ? TextDirection.rtl : TextDirection.ltr,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary(context))),
              const SizedBox(height: 4),
              Text(card.termIn(!ar),
                  textDirection: ar ? TextDirection.ltr : TextDirection.rtl,
                  style: TextStyle(fontSize: 16, color: AppColors.textTertiary(context))),
              const SizedBox(height: 18),
              if (!_revealed)
                FilledButton(
                  style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                  onPressed: () => setState(() => _revealed = true),
                  child: Text(s.tr('Show answer', 'إظهار الإجابة')),
                )
              else
                Directionality(
                  textDirection: ar ? TextDirection.rtl : TextDirection.ltr,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Divider(),
                      const SizedBox(height: 6),
                      if (ar)
                        Text(card.arabicDefinition, style: _p.copyWith(fontSize: 15, color: AppColors.textPrimary(context)))
                      else ...[
                        Text(card.shortDefinition,
                            style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary(context))),
                        const SizedBox(height: 6),
                        Text(card.fullDefinition, style: _p),
                      ],
                      if (shownFormula != null) ...[
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4F46E5).withValues(alpha: 0.07),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFF4F46E5).withValues(alpha: 0.18)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ar ? 'الصيغة' : 'FORMULA',
                                  style: const TextStyle(
                                      fontSize: 10.5, fontWeight: FontWeight.w700, color: Color(0xFF6366F1), letterSpacing: 0.8)),
                              const SizedBox(height: 4),
                              // The Arabic formula is prose: RTL and a normal face; the English one is mono.
                              card.formulaIsArabic(ar)
                                  ? Text(shownFormula, style: const TextStyle(fontSize: 13.5, color: Color(0xFF312E81)))
                                  : Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: Text(shownFormula,
                                          style: GoogleFonts.jetBrainsMono(fontSize: 12.5, color: const Color(0xFF312E81))),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ).animate(key: ValueKey('${card.id}:${session.index}')).fadeIn(duration: 250.ms).slideX(begin: 0.08),
        if (_revealed) ...[
          const SizedBox(height: 12),
          Text(s.tr('How well did you know it?', 'ما مدى معرفتك بها؟'),
              textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context))),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 3.6,
            children: [
              _gradeButton(s.tr('Again', 'أعِدها'), const Color(0xFFEF4444), Grade.again),
              _gradeButton(s.tr('Hard', 'صعبة'), const Color(0xFFF59E0B), Grade.hard),
              _gradeButton(s.tr('Good', 'جيدة'), const Color(0xFF10B981), Grade.good),
              _gradeButton(s.tr('Easy', 'سهلة'), const Color(0xFF0EA5E9), Grade.easy),
            ],
          ),
        ],
      ],
    );
  }

  Widget _gradeButton(String label, Color color, int grade) => FilledButton(
        style: FilledButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white),
        onPressed: _grading ? null : () => _grade(grade),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
      );

  Widget _doneView(AppStrings s) {
    final session = _session!;
    final days = _streak.current;
    Widget stat(int value, String label, Color color) => Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withValues(alpha: 0.2)),
            ),
            child: Column(children: [
              Text('$value', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color)),
              Text(label, style: TextStyle(fontSize: 11.5, color: AppColors.textTertiary(context))),
            ]),
          ),
        );
    return _centered([
      Center(child: _iconBubble(Icons.auto_awesome_rounded, _orange)),
      const SizedBox(height: 14),
      Text(s.tr('Session complete!', 'اكتملت الجلسة!'), style: _h.copyWith(fontSize: 22), textAlign: TextAlign.center),
      const SizedBox(height: 6),
      Text(
        _streak.activeToday
            ? s.tr('Your streak is alive - $days day${days == 1 ? '' : 's'} in a row (best: ${_streak.best}).',
                'سلسلتك مستمرة - $days يومًا متتاليًا (الأفضل: ${_streak.best}).')
            : s.tr('Nice work today.', 'عمل رائع اليوم.'),
        style: _p,
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 18),
      Row(children: [
        stat(session.completed, s.tr('Reviewed', 'تمت مراجعتها'), AppColors.primary),
        const SizedBox(width: 8),
        stat(session.gotIt, s.tr('Got it', 'أتقنتها'), AppColors.secondary),
        const SizedBox(width: 8),
        stat(session.reviewing, s.tr('Reviewing', 'قيد المراجعة'), AppColors.accent),
      ]),
      const SizedBox(height: 20),
      FilledButton.icon(
        onPressed: _startSession,
        icon: const Icon(Icons.refresh_rounded),
        label: Text(s.tr('Practice again', 'تدرّب مجددًا')),
      ),
      const SizedBox(height: 6),
      OutlinedButton(
        onPressed: _leave,
        child: Text(widget.embedded ? s.tr('Close', 'إغلاق') : s.tr('Back to Education Hub', 'العودة إلى مركز التعلم')),
      ),
    ]);
  }
}

/// Streak flame chip: grey until today has been practised, lit once it has.
class StreakChip extends StatelessWidget {
  final StreakInfo streak;
  final AppStrings s;
  const StreakChip({super.key, required this.streak, required this.s});

  @override
  Widget build(BuildContext context) {
    final lit = streak.activeToday;
    final color = lit ? const Color(0xFFC2410C) : AppColors.textTertiary(context);
    return Tooltip(
      message: s.tr('Best streak: ${streak.best} day${streak.best == 1 ? '' : 's'}',
          'أفضل سلسلة: ${streak.best} يومًا'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: lit ? const Color(0xFFFFEDD5) : AppColors.cardColor(context),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: lit ? const Color(0xFFFDBA74) : AppColors.borderColor(context)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(lit ? Icons.local_fire_department_rounded : Icons.local_fire_department_outlined,
              size: 18, color: lit ? _orange : color),
          const SizedBox(width: 4),
          Text('${streak.current}', style: TextStyle(fontWeight: FontWeight.w700, color: color)),
        ]),
      ),
    );
  }
}
