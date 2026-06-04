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
import '../data/research_instruments.dart';
import '../../../app/i18n/app_strings.dart';

/// Research / DBA data-collection flow: consent → instrument hub → forms.
/// Responses are stored locally and submitted to the backend best-effort.
class ResearchScreen extends ConsumerStatefulWidget {
  const ResearchScreen({super.key});

  @override
  ConsumerState<ResearchScreen> createState() => _ResearchScreenState();
}

class _ResearchScreenState extends ConsumerState<ResearchScreen> {
  bool _loaded = false;
  bool _consented = false;
  final Set<String> _completed = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _consented = prefs.getBool('research_consented') ?? false;
      _completed.addAll(prefs.getStringList('research_completed') ?? const []);
      _loaded = true;
    });
  }

  Future<void> _markConsented() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('research_consented', true);
    try {
      await ref.read(apiClientProvider).post(ApiEndpoints.researchConsent,
          data: {'consentToParticipate': true, 'consentToDataUse': true});
    } catch (_) {}
    if (mounted) setState(() => _consented = true);
  }

  Future<void> _completeInstrument(
      String key, Map<String, dynamic> answers) async {
    final prefs = await SharedPreferences.getInstance();
    _completed.add(key);
    await prefs.setStringList('research_completed', _completed.toList());
    try {
      final path = key == 'descriptors'
          ? ApiEndpoints.researchDescriptors
          : ApiEndpoints.researchResponse;
      await ref.read(apiClientProvider).post(path,
          data: {'instrumentKey': key, 'answers': answers});
    } catch (_) {}
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: Theme.of(context).brightness == Brightness.dark
                ? const [AppColors.darkBg, AppColors.darkSurface]
                : const [Color(0xFFF5F3FF), Colors.white],
          ),
        ),
        child: SafeArea(
          child: !_loaded
              ? const Center(child: CircularProgressIndicator())
              : _consented
                  ? _buildHub()
                  : _buildConsent(),
        ),
      ),
    );
  }

  // ── Consent ──
  Widget _buildConsent() {
    final s = ref.watch(stringsProvider);
    return Column(
      children: [
        _appBar(s.tr('Research Participation', 'المشاركة في البحث')),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
            children: [
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.purple.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.science_rounded,
                              color: AppColors.purple, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(s.tr('About this study', 'حول هذه الدراسة'),
                              style:
                                  Theme.of(context).textTheme.titleLarge),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _consentSection(
                        s.tr('What this is', 'ما هذا'),
                        s.tr(
                            'FinPlay is part of a DBA research study on AI-assisted financial-competence training. Taking part is voluntary.',
                            'FinPlay جزء من دراسة بحثية لدرجة الدكتوراه في إدارة الأعمال حول التدريب على الكفاءة المالية بمساعدة الذكاء الاصطناعي. المشاركة طوعية.')),
                    _consentSection(
                        s.tr('What we collect', 'ما الذي نجمعه'),
                        s.tr(
                            'Short questionnaires (background, confidence, reflections, evaluation), your pre/post knowledge tests, and anonymous usage data.',
                            'استبيانات قصيرة (الخلفية، الثقة، التأملات، التقييم)، واختبارات معرفتك قبل/بعد الدورة، وبيانات استخدام مجهولة الهوية.')),
                    _consentSection(
                        s.tr('How your identity is protected', 'كيف تُحمى هويتك'),
                        s.tr(
                            'You are identified only by an anonymised participant code. Data is stored securely and handled in line with KSA & UAE PDPL.',
                            'يتم تعريفك فقط برمز مشارك مجهول الهوية. تُخزَّن البيانات بأمان وتُعالَج وفقًا لأنظمة حماية البيانات الشخصية في السعودية والإمارات.')),
                    _consentSection(
                        s.tr('Your rights', 'حقوقك'),
                        s.tr(
                            'Participation is voluntary. You may skip any question, withdraw at any time, and request access to or deletion of your data.',
                            'المشاركة طوعية. يمكنك تخطّي أي سؤال، والانسحاب في أي وقت، وطلب الاطلاع على بياناتك أو حذفها.')),
                  ],
                ),
              ).animate().fadeIn(),
              const SizedBox(height: 16),
              _ConsentAffirmations(onConsent: _markConsented),
            ],
          ),
        ),
      ],
    );
  }

  Widget _consentSection(String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.purple)),
          const SizedBox(height: 4),
          Text(body,
              style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: AppColors.textSecondary(context))),
        ],
      ),
    );
  }

  // ── Instrument hub ──
  Widget _buildHub() {
    final s = ref.watch(stringsProvider);
    final items = <(String, String, IconData, ResearchInstrument)>[
      ('descriptors', s.tr('About You', 'عنك'), Icons.badge_rounded, kDescriptors),
      ('self_efficacy_pre', s.tr('Confidence (Pre)', 'الثقة (قبل)'), Icons.trending_up_rounded,
          kSelfEfficacy),
      ('reflection', s.tr('Daily Reflection', 'تأمل يومي'), Icons.event_note_rounded,
          kReflection),
      ('self_efficacy_post', s.tr('Confidence (Post)', 'الثقة (بعد)'), Icons.show_chart_rounded,
          kSelfEfficacy),
      ('post_eval', s.tr('Programme Evaluation', 'تقييم البرنامج'), Icons.rate_review_rounded,
          kPostEval),
    ];
    return Column(
      children: [
        _appBar(s.tr('Research', 'البحث')),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
          child: Row(
            children: [
              const Icon(Icons.verified_user_rounded,
                  size: 16, color: AppColors.secondaryLight),
              const SizedBox(width: 6),
              Text(s.tr('Consent recorded · ${_completed.length}/${items.length} completed',
                  'تم تسجيل الموافقة · ${_completed.length}/${items.length} مكتملة'),
                  style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textTertiary(context))),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            itemCount: items.length,
            itemBuilder: (context, i) {
              final (key, title, icon, instrument) = items[i];
              final done = _completed.contains(key);
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GlassCard(
                  borderColor: done
                      ? AppColors.secondaryLight.withValues(alpha: 0.35)
                      : null,
                  padding: EdgeInsets.zero,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 4),
                    leading: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: (done
                                ? AppColors.secondaryLight
                                : AppColors.purple)
                            .withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon,
                          color: done
                              ? AppColors.secondaryLight
                              : AppColors.purple,
                          size: 22),
                    ),
                    title: Text(title,
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 14, fontWeight: FontWeight.w700)),
                    subtitle: Text(s.tr('${instrument.fields.length} questions',
                        '${instrument.fields.length} أسئلة'),
                        style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textTertiary(context))),
                    trailing: done
                        ? const Icon(Icons.check_circle_rounded,
                            color: AppColors.secondaryLight)
                        : const Icon(Icons.chevron_right_rounded),
                    onTap: () => _openInstrument(key, instrument),
                  ),
                ),
              ).animate().fadeIn(delay: (60 * i).ms);
            },
          ),
        ),
      ],
    );
  }

  Future<void> _openInstrument(
      String key, ResearchInstrument instrument) async {
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (_) => _InstrumentForm(instrument: instrument, title: key),
      ),
    );
    if (result != null) {
      await _completeInstrument(key, result);
    }
  }

  Widget _appBar(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => context.pop()),
          const Spacer(),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

// ── Consent affirmations card ──
class _ConsentAffirmations extends StatefulWidget {
  final VoidCallback onConsent;
  const _ConsentAffirmations({required this.onConsent});

  @override
  State<_ConsentAffirmations> createState() => _ConsentAffirmationsState();
}

class _ConsentAffirmationsState extends State<_ConsentAffirmations> {
  bool _participate = false;
  bool _dataUse = false;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final s = ref.watch(stringsProvider);
      return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          CheckboxListTile(
            value: _participate,
            onChanged: (v) => setState(() => _participate = v ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            activeColor: AppColors.purple,
            title: Text(
                s.tr(
                    'I have read the information above and voluntarily agree to take part in this study.',
                    'لقد قرأت المعلومات أعلاه وأوافق طوعًا على المشاركة في هذه الدراسة.'),
                style: const TextStyle(fontSize: 13)),
          ),
          CheckboxListTile(
            value: _dataUse,
            onChanged: (v) => setState(() => _dataUse = v ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            activeColor: AppColors.purple,
            title: Text(
                s.tr(
                    'I consent to my anonymised data being used for research analysis and academic publication.',
                    'أوافق على استخدام بياناتي مجهولة الهوية لأغراض التحليل البحثي والنشر الأكاديمي.'),
                style: const TextStyle(fontSize: 13)),
          ),
          const SizedBox(height: 12),
          GradientButton(
            text: s.tr('I Agree & Continue', 'أوافق وأتابع'),
            icon: Icons.check_rounded,
            width: double.infinity,
            gradient: const LinearGradient(
                colors: [AppColors.purple, AppColors.purpleLight]),
            onPressed:
                (_participate && _dataUse) ? widget.onConsent : null,
          ),
        ],
      ),
    );
    });
  }
}

// ── Generic instrument form ──
class _InstrumentForm extends StatefulWidget {
  final ResearchInstrument instrument;
  final String title;
  const _InstrumentForm({required this.instrument, required this.title});

  @override
  State<_InstrumentForm> createState() => _InstrumentFormState();
}

class _InstrumentFormState extends State<_InstrumentForm> {
  final Map<String, dynamic> _answers = {};

  bool get _complete {
    for (final f in widget.instrument.fields) {
      if (f.optional) continue;
      if (!_answers.containsKey(f.id) ||
          (_answers[f.id] is String &&
              (_answers[f.id] as String).trim().isEmpty)) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final inst = widget.instrument;
    return Consumer(builder: (context, ref, _) {
      final s = ref.watch(stringsProvider);
      return Scaffold(
      body: Container(
        decoration:
            BoxDecoration(gradient: AppColors.backgroundGradient(context)),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    IconButton(
                        icon: const Icon(Icons.arrow_back_rounded),
                        onPressed: () => Navigator.of(context).pop()),
                    const Spacer(),
                    Flexible(
                      child: Text(inst.title,
                          style: Theme.of(context).textTheme.titleLarge,
                          overflow: TextOverflow.ellipsis),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                  children: [
                    Text(inst.intro,
                        style: TextStyle(
                            fontSize: 13.5,
                            height: 1.5,
                            color: AppColors.textSecondary(context))),
                    const SizedBox(height: 16),
                    ...inst.fields.map(_buildField),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: GradientButton(
                  text: s.tr('Submit', 'إرسال'),
                  icon: Icons.send_rounded,
                  width: double.infinity,
                  gradient: const LinearGradient(
                      colors: [AppColors.purple, AppColors.purpleLight]),
                  onPressed: _complete
                      ? () => Navigator.of(context).pop(_answers)
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    });
  }

  Widget _buildField(ResearchField f) {
    return Consumer(builder: (context, ref, _) {
      final s = ref.watch(stringsProvider);
      return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(f.label + (f.optional ? s.tr('  (optional)', '  (اختياري)') : ''),
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                  color: AppColors.textPrimary(context))),
          const SizedBox(height: 10),
          switch (f.type) {
            FieldType.likert5 => _likert(f),
            FieldType.nps => _nps(f),
            FieldType.boolean => _boolean(f),
            FieldType.singleSelect => _singleSelect(f),
            FieldType.text => _text(f),
          },
        ],
      ),
    );
    });
  }

  Widget _likert(ResearchField f) {
    const labels = ['1', '2', '3', '4', '5'];
    return Row(
      children: List.generate(5, (i) {
        final v = i + 1;
        final sel = _answers[f.id] == v;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 6),
            child: GestureDetector(
              onTap: () => setState(() => _answers[f.id] = v),
              child: Container(
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: sel
                      ? AppColors.purple.withValues(alpha: 0.15)
                      : AppColors.surfaceColor(context),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: sel
                          ? AppColors.purple
                          : AppColors.borderColor(context),
                      width: sel ? 2 : 1),
                ),
                child: Text(labels[i],
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: sel
                            ? AppColors.purple
                            : AppColors.textSecondary(context))),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _nps(ResearchField f) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: List.generate(11, (i) {
        final sel = _answers[f.id] == i;
        return GestureDetector(
          onTap: () => setState(() => _answers[f.id] = i),
          child: Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: sel
                  ? AppColors.purple.withValues(alpha: 0.15)
                  : AppColors.surfaceColor(context),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color:
                      sel ? AppColors.purple : AppColors.borderColor(context),
                  width: sel ? 2 : 1),
            ),
            child: Text('$i',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: sel
                        ? AppColors.purple
                        : AppColors.textSecondary(context))),
          ),
        );
      }),
    );
  }

  Widget _boolean(ResearchField f) {
    return Consumer(builder: (context, ref, _) {
      final s = ref.watch(stringsProvider);
      return Row(
      children: [
        for (final opt in const ['Yes', 'No'])
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              label: Text(opt == 'Yes' ? s.tr('Yes', 'نعم') : s.tr('No', 'لا')),
              selected: _answers[f.id] == (opt == 'Yes'),
              selectedColor: AppColors.purple.withValues(alpha: 0.2),
              onSelected: (_) =>
                  setState(() => _answers[f.id] = opt == 'Yes'),
            ),
          ),
      ],
    );
    });
  }

  Widget _singleSelect(ResearchField f) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: f.options.map((opt) {
        final sel = _answers[f.id] == opt;
        return ChoiceChip(
          label: Text(opt, style: const TextStyle(fontSize: 12.5)),
          selected: sel,
          selectedColor: AppColors.purple.withValues(alpha: 0.2),
          onSelected: (_) => setState(() => _answers[f.id] = opt),
        );
      }).toList(),
    );
  }

  Widget _text(ResearchField f) {
    return Consumer(builder: (context, ref, _) {
      final s = ref.watch(stringsProvider);
      return TextField(
      maxLines: 3,
      minLines: 1,
      onChanged: (v) => setState(() => _answers[f.id] = v),
      decoration: InputDecoration(
        hintText: s.tr('Your answer…', 'إجابتك…'),
        border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
    });
  }
}
