<<<<<<< Updated upstream
/// Data model + content for the Case Scenario Simulator — multi-step branching
/// role-play decision cases used by several education modules on the
/// website (modules 4, 6, 7, 9, 10). Each scenario walks the learner through a
/// sequence of typed steps (analysis / decision / recommendation / stakeholder);
/// every step offers options carrying correctness, feedback and a consequence,
/// and the run is scored out of 100.
=======
/// Data model for the Case Scenario Simulator: multi-step branching role-play
/// decision cases (website `CaseScenarioSimulator`, client/src/components/
/// education/modules/simulation/CaseScenarioSimulator.tsx). Each scenario walks
/// the learner through typed steps (analysis / decision / recommendation /
/// stakeholder); every step offers options carrying correctness, feedback and
/// an optional consequence, and the run is scored as
/// round(correct / totalSteps × maxScore).
>>>>>>> Stashed changes
///
/// Content lives with each module's activities (data/module`N`_data.dart),
/// generated from the website's module`N`-scenarios.ts.
///
/// Bilingual: every text is a [Bi]; `…For(bool ar)` returns Arabic when active
/// and falls back to English when no translation is supplied.
library;

import 'education_module_data.dart';

enum CaseStepType { analysis, decision, recommendation, stakeholder }

class CaseOption {
  final Bi text;
  final bool isCorrect;
  final Bi feedback;
  final Bi consequence;
  const CaseOption(
    this.text, {
    this.isCorrect = false,
    required this.feedback,
    this.consequence = const Bi(''),
  });

  String textFor(bool ar) => text.of(ar);
  String feedbackFor(bool ar) => feedback.of(ar);
  String? consequenceFor(bool ar) => consequence.isEmpty ? null : consequence.of(ar);
}

/// A labelled figure shown with a step (website `ScenarioStep.data`).
class CaseDatum {
  final Bi label;
  final String value;
  const CaseDatum(this.label, this.value);
}

class CaseStep {
  final String id;
  final CaseStepType type;
  final Bi title;
  final Bi description;
  final Bi context;
  final List<CaseDatum> data;
  final Bi question;
  final List<CaseOption> options;
  const CaseStep({
    this.id = '',
    required this.type,
    this.title = const Bi(''),
    this.description = const Bi(''),
    this.context = const Bi(''),
    this.data = const [],
    required this.question,
    required this.options,
  });

  String promptFor(bool ar) => question.of(ar);
}

class CaseScenario {
  final String id;
  final Bi title;
  final Bi role;
  final Bi overview;
  final Bi finalSummary;
  final List<CaseStep> steps;
  const CaseScenario({
    required this.id,
    required this.title,
    required this.role,
    required this.overview,
    this.finalSummary = const Bi(''),
    required this.steps,
  });

  String titleFor(bool ar) => title.of(ar);
  String roleFor(bool ar) => role.of(ar);
  String overviewFor(bool ar) => overview.of(ar);
}
