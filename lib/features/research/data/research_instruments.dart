/// Research / DBA instrument definitions (ported from the web research module).
/// Used by the consent → demographics → questionnaire flow.
library;

enum FieldType { likert5, text, singleSelect, boolean, nps }

class ResearchField {
  final String id;
  final String label;
  final FieldType type;
  final List<String> options; // for singleSelect
  final bool optional;

  const ResearchField({
    required this.id,
    required this.label,
    required this.type,
    this.options = const [],
    this.optional = false,
  });
}

class ResearchInstrument {
  final String key;
  final String title;
  final String intro;
  final List<ResearchField> fields;

  const ResearchInstrument({
    required this.key,
    required this.title,
    required this.intro,
    required this.fields,
  });
}

/// Demographics / enrollment descriptors.
const kDescriptors = ResearchInstrument(
  key: 'descriptors',
  title: 'About you',
  intro: 'A few background details. These help us interpret the results.',
  fields: [
    ResearchField(
        id: 'role',
        label: 'Your current role',
        type: FieldType.singleSelect,
        options: [
          'Senior executive',
          'Manager',
          'Specialist / analyst',
          'Other'
        ]),
    ResearchField(
        id: 'orgType',
        label: 'Your organisation is mainly',
        type: FieldType.singleSelect,
        options: ['Government / public sector', 'Private sector', 'Other']),
    ResearchField(
        id: 'sector',
        label: 'Your sector / field (optional)',
        type: FieldType.text,
        optional: true),
    ResearchField(
        id: 'experienceBand',
        label: 'Years of professional experience',
        type: FieldType.singleSelect,
        options: ['0–2', '3–5', '6–10', '11+']),
    ResearchField(
        id: 'education',
        label: 'Highest education completed',
        type: FieldType.singleSelect,
        options: [
          'Secondary / diploma',
          "Bachelor's",
          "Master's",
          'Doctorate'
        ]),
    ResearchField(
        id: 'priorFinanceTraining',
        label: 'Have you had formal finance training before?',
        type: FieldType.boolean),
    ResearchField(
        id: 'priorFinanceHours',
        label: 'If yes, roughly how much?',
        type: FieldType.singleSelect,
        options: ['None', '<10h', '10–40h', '>40h']),
  ],
);

/// Financial Self-Efficacy Scale (used both pre and post).
const kSelfEfficacy = ResearchInstrument(
  key: 'self_efficacy',
  title: 'Your confidence with finance',
  intro: 'Rate how much you agree with each statement right now.',
  fields: [
    ResearchField(
        id: 'fse_bs',
        label: 'I am confident I can read and interpret a balance sheet.',
        type: FieldType.likert5),
    ResearchField(
        id: 'fse_is',
        label: 'I am confident I can read and interpret an income statement.',
        type: FieldType.likert5),
    ResearchField(
        id: 'fse_cf',
        label:
            'I am confident I can read and interpret a cash-flow statement.',
        type: FieldType.likert5),
    ResearchField(
        id: 'fse_ratios',
        label:
            'I am confident I can calculate and interpret basic financial ratios.',
        type: FieldType.likert5),
    ResearchField(
        id: 'fse_decide',
        label:
            'I am confident I can make sound financial decisions under uncertainty.',
        type: FieldType.likert5),
    ResearchField(
        id: 'fse_explain',
        label:
            "I am confident I can explain a financial decision's impact to colleagues.",
        type: FieldType.likert5),
  ],
);

/// Daily reflection (days 1–3).
const kReflection = ResearchInstrument(
  key: 'reflection',
  title: "Today's reflection",
  intro: 'A quick end-of-day reflection. There are no right answers.',
  fields: [
    ResearchField(
        id: 'sdt_autonomy',
        label: "Today's activities let me make meaningful choices.",
        type: FieldType.likert5),
    ResearchField(
        id: 'sdt_competence',
        label: 'Today I felt I was getting better at understanding finance.',
        type: FieldType.likert5),
    ResearchField(
        id: 'sdt_relatedness',
        label: 'Working with my team today helped my learning.',
        type: FieldType.likert5),
    ResearchField(
        id: 'engagement',
        label: 'I was fully engaged in today\'s session.',
        type: FieldType.likert5),
    ResearchField(
        id: 'open_useful',
        label: 'The most useful thing I learned today was…',
        type: FieldType.text),
    ResearchField(
        id: 'open_confusing',
        label: 'Something that was confusing or unclear today…',
        type: FieldType.text,
        optional: true),
    ResearchField(
        id: 'open_apply',
        label: 'One thing I will apply at work…',
        type: FieldType.text,
        optional: true),
  ],
);

/// Post-training evaluation.
const kPostEval = ResearchInstrument(
  key: 'post_eval',
  title: 'Your evaluation of the programme',
  intro:
      'Please tell us how the programme worked for you. Your honest feedback shapes the next version.',
  fields: [
    ResearchField(
        id: 'l1_relevant',
        label: 'The content was relevant to my work.',
        type: FieldType.likert5),
    ResearchField(
        id: 'l1_clear',
        label: 'The material was clear and easy to follow.',
        type: FieldType.likert5),
    ResearchField(
        id: 'l1_engaging',
        label: 'The programme kept me engaged.',
        type: FieldType.likert5),
    ResearchField(
        id: 'l1_paced',
        label: 'The pace was right for me.',
        type: FieldType.likert5),
    ResearchField(
        id: 'game_enjoy',
        label: 'I enjoyed the game-based competition.',
        type: FieldType.likert5),
    ResearchField(
        id: 'game_motivate',
        label: 'The competition motivated me to learn more.',
        type: FieldType.likert5),
    ResearchField(
        id: 'game_fair',
        label: 'The scoring and leaderboard felt fair.',
        type: FieldType.likert5),
    ResearchField(
        id: 'ai_useful',
        label: 'AI-designed training content was useful for my learning.',
        type: FieldType.likert5),
    ResearchField(
        id: 'ai_easy',
        label: 'The platform was easy to use.',
        type: FieldType.likert5),
    ResearchField(
        id: 'ai_intend',
        label: 'I would take AI-assisted training like this again.',
        type: FieldType.likert5),
    ResearchField(
        id: 'gain_understand',
        label:
            'I understand financial statements better than before this programme.',
        type: FieldType.likert5),
    ResearchField(
        id: 'transfer_intent',
        label: 'I intend to apply what I learned in my work.',
        type: FieldType.likert5),
    ResearchField(
        id: 'nps',
        label:
            'How likely are you to recommend this programme to a colleague? (0–10)',
        type: FieldType.nps),
    ResearchField(
        id: 'open_worked',
        label: 'What worked best for you?',
        type: FieldType.text,
        optional: true),
    ResearchField(
        id: 'open_improve',
        label: 'What should we improve?',
        type: FieldType.text,
        optional: true),
    ResearchField(
        id: 'open_ai_view',
        label: 'What is your view on training content designed with AI?',
        type: FieldType.text,
        optional: true),
  ],
);
