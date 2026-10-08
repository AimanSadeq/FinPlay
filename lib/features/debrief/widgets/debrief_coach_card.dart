import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/i18n/app_strings.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/glass_card.dart';
import '../data/debrief_models.dart';
import '../data/debrief_repository.dart';

/// AI Debrief Coach (website DebriefCoach.tsx): on demand, fetches the stored round debrief
/// or has the server generate one — a short summary, the key Net Income drivers and three
/// Socratic reflection questions — in the app's language. Shows a friendly note when the
/// deployment has no AI provider.
class DebriefCoachCard extends ConsumerStatefulWidget {
  final String teamId;
  final int round;
  final bool selfPaced;

  const DebriefCoachCard({
    super.key,
    required this.teamId,
    required this.round,
    this.selfPaced = false,
  });

  @override
  ConsumerState<DebriefCoachCard> createState() => _DebriefCoachCardState();
}

class _DebriefCoachCardState extends ConsumerState<DebriefCoachCard> {
  bool _pending = false;
  CoachResult? _result;

  @override
  void didUpdateWidget(covariant DebriefCoachCard old) {
    super.didUpdateWidget(old);
    if (old.round != widget.round || old.teamId != widget.teamId) _result = null;
  }

  Future<void> _generate() async {
    final s = ref.read(stringsProvider);
    setState(() => _pending = true);
    final res = await ref.read(debriefRepositoryProvider).generateCoach(
          teamId: widget.selfPaced ? null : widget.teamId,
          round: widget.round,
          selfPaced: widget.selfPaced,
          language: s.ar ? 'ar' : 'en',
        );
    if (!mounted) return;
    setState(() {
      _pending = false;
      _result = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final result = _result;
    final debrief = result?.status == CoachStatus.ok ? result!.debrief : null;
    final canRun = widget.round >= 1 && widget.round <= 3;

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.school_rounded, size: 20, color: Color(0xFF4F46E5)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  s.tr('AI Debrief Coach - Round ${widget.round}',
                      'مدرّب المراجعة الذكي - الجولة ${widget.round}'),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            s.tr(
                'A short coaching debrief of your round: what happened, what drove it, and questions to discuss as a team.',
                'مراجعة تدريبية قصيرة لجولتك: ما الذي حدث، وما الذي أدى إليه، وأسئلة للنقاش كفريق.'),
            style: TextStyle(fontSize: 11, color: AppColors.textTertiary(context)),
          ),
          const SizedBox(height: 12),
          if (debrief == null)
            Center(
              child: Column(
                children: [
                  FilledButton.icon(
                    style: FilledButton.styleFrom(backgroundColor: const Color(0xFF4F46E5)),
                    onPressed: _pending || !canRun ? null : _generate,
                    icon: _pending
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.auto_awesome_rounded, size: 18),
                    label: Text(_pending
                        ? s.tr('Preparing your debrief...', 'جارٍ إعداد مراجعتك...')
                        : s.tr('Generate AI Debrief', 'إنشاء مراجعة بالذكاء الاصطناعي')),
                  ),
                  if (_pending)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        s.tr('Reviewing your decisions and financial results. This can take a few seconds.',
                            'نراجع قراراتك ونتائجك المالية. قد يستغرق ذلك بضع ثوانٍ.'),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11, color: AppColors.textTertiary(context)),
                      ),
                    ),
                ],
              ),
            ),
          if (result?.status == CoachStatus.notConfigured)
            _notice(
              context,
              s.tr(
                  'The AI debrief coach is not configured for this deployment. Ask your facilitator to set up an AI provider to enable round debriefs.',
                  'مدرّب المراجعة الذكي غير مُفعّل في هذا الإصدار. اطلب من الميسّر إعداد مزوّد ذكاء اصطناعي لتفعيل مراجعات الجولات.'),
              AppColors.accent,
            ),
          if (result?.status == CoachStatus.failed)
            _notice(
              context,
              s.tr('Something went wrong while generating your debrief. Please try again.',
                  'حدث خطأ أثناء إنشاء مراجعتك. يُرجى المحاولة مرة أخرى.'),
              AppColors.danger,
            ),
          if (debrief != null)
            Directionality(
              // The debrief reads in the language it was written in.
              textDirection: result!.language == 'ar' ? TextDirection.rtl : TextDirection.ltr,
              child: _debriefBody(context, s, debrief, result.cached),
            ),
        ],
      ),
    );
  }

  Widget _notice(BuildContext context, String text, Color color) => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Text(text, style: TextStyle(fontSize: 12.5, color: color)),
      );

  Widget _debriefBody(BuildContext context, AppStrings s, DebriefContent d, bool cached) {
    final body = TextStyle(fontSize: 13, height: 1.45, color: AppColors.textSecondary(context));
    Widget heading(IconData? icon, Color? color, String text) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              if (icon != null) ...[Icon(icon, size: 16, color: color), const SizedBox(width: 6)],
              Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            ],
          ),
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        heading(null, null, s.tr('Round summary', 'ملخص الجولة')),
        Text(d.summary, style: body),
        const SizedBox(height: 14),
        heading(Icons.lightbulb_rounded, AppColors.accentLight, s.tr('Key drivers', 'العوامل الرئيسية')),
        for (final driver in d.drivers)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('•', style: TextStyle(color: Color(0xFF6366F1))),
                ),
                Expanded(child: Text(driver, style: body)),
              ],
            ),
          ),
        const SizedBox(height: 10),
        heading(Icons.contact_support_rounded, const Color(0xFF6366F1),
            s.tr('Think about this', 'فكّر في هذا')),
        for (var i = 0; i < d.questions.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text('${i + 1}.',
                      style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF4F46E5))),
                ),
                Expanded(child: Text(d.questions[i], style: body)),
              ],
            ),
          ),
        if (cached)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              widget.selfPaced
                  ? s.tr('Showing your saved debrief for this round.', 'نعرض مراجعتك المحفوظة لهذه الجولة.')
                  : s.tr("Showing your team's saved debrief for this round.",
                      'نعرض مراجعة فريقك المحفوظة لهذه الجولة.'),
              style: TextStyle(fontSize: 11, color: AppColors.textTertiary(context)),
            ),
          ),
      ],
    );
  }
}
