import 'case_scenario_data.dart';
import 'data/module1_data.dart';
import 'data/module2_data.dart';
import 'data/module3_data.dart';
import 'data/module4_data.dart';
import 'data/module6_data.dart';
import 'data/module7_data.dart';
import 'data/module9_data.dart';
import 'data/module10_data.dart';

/// A bilingual string. [of] returns Arabic when the UI is Arabic and a
/// translation exists, else English (website `biText` parity).
class Bi {
  final String en;
  final String ar;
  const Bi(this.en, [this.ar = '']);

  String of(bool isArabic) => isArabic && ar.trim().isNotEmpty ? ar : en;

  bool get isEmpty => en.trim().isEmpty && ar.trim().isEmpty;
}

/// The three activity tabs of a module (the website's practiceActivities /
/// gameActivities / simulationActivities).
enum ActivityTab { practice, games, sim }

/// What widget renders an activity.
enum ActivityKind {
  quiz,
  calculator,
  memoryMatch,
  classification,
  ordering,
  caseScenario,
  statementBuilder,
}

class QuizQuestion {
  final String id;
  final Bi question;
  final List<Bi> options;
  final int correctIndex;
  final Bi explanation;
  const QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    this.explanation = const Bi(''),
  });
}

/// English term ↔ Arabic translation (the website's memory match).
class MemoryPair {
  final String id;
  final String term;
  final String match;
  const MemoryPair({required this.id, required this.term, required this.match});
}

class ClassCategory {
  final String id;
  final Bi name;
  final Bi description;
  const ClassCategory({
    required this.id,
    required this.name,
    this.description = const Bi(''),
  });
}

class ClassItem {
  final String id;
  final Bi name;
  final String category; // ClassCategory.id
  final Bi hint;
  const ClassItem({
    required this.id,
    required this.name,
    required this.category,
    this.hint = const Bi(''),
  });
}

/// One step of an ordering game. Steps are listed in their CORRECT order.
class OrderStep {
  final String id;
  final Bi name;
  final Bi description;
  final Bi hint;
  const OrderStep({
    required this.id,
    required this.name,
    this.description = const Bi(''),
    this.hint = const Bi(''),
  });
}

enum CalcFieldType { input, display, result }

class CalcField {
  final String id;
  final Bi label;
  final CalcFieldType type;
  final double? value;
  final double? correctAnswer;
  final String unit;
  final String formula;
  final double tolerance;
  final Bi hint;
  const CalcField({
    required this.id,
    required this.label,
    required this.type,
    this.value,
    this.correctAnswer,
    this.unit = '',
    this.formula = '',
    this.tolerance = 0,
    this.hint = const Bi(''),
  });

  bool get isAnswerable => type != CalcFieldType.display;

  /// Website CalculatorExercise.checkAnswer: |answer - correct| <= tolerance.
  bool check(String raw) {
    final v = double.tryParse(raw.trim().replaceAll(',', ''));
    if (v == null || correctAnswer == null) return false;
    return (v - correctAnswer!).abs() <= tolerance + 1e-9;
  }
}

class CalcProblem {
  final String id;
  final Bi title;
  final Bi scenario;
  final Bi explanation;
  final List<CalcField> fields;
  const CalcProblem({
    required this.id,
    required this.title,
    required this.scenario,
    this.explanation = const Bi(''),
    required this.fields,
  });
}

/// One scored activity, keyed by the WEBSITE's activity id (`quiz`, `quiz3`,
/// `memoryMatch`, `ratioClassification`, `budgetSimulator`…). The id is the
/// progress key both clients sync under, and [maxScore] is the website's, so a
/// module's activities sum to the server's MODULE_MAX_SCORES entry.
class ModuleActivity {
  final String id;
  final ActivityTab tab;
  final ActivityKind kind;
  final Bi title;
  final Bi description;
  final int maxScore;

  // Payload (only the fields for [kind] are set).
  final List<QuizQuestion> questions;
  final List<MemoryPair> pairs;
  final List<ClassCategory> categories;
  final List<ClassItem> items;
  final Bi instruction;
  final List<OrderStep> steps;
  final List<CalcProblem> problems;
  final List<CaseScenario> scenarios;

  const ModuleActivity({
    required this.id,
    required this.tab,
    required this.kind,
    required this.title,
    this.description = const Bi(''),
    required this.maxScore,
    this.questions = const [],
    this.pairs = const [],
    this.categories = const [],
    this.items = const [],
    this.instruction = const Bi(''),
    this.steps = const [],
    this.problems = const [],
    this.scenarios = const [],
  });
}

class EducationModuleContent {
  final int id;
  final String title;
  final String? titleAr;

  // Each slide is a map with the website section 'id' and 'number', plus
  // 'title'/'content'/'keyPoint' (English) and 'titleAr'/'contentAr'/'keyPointAr'
  // (Arabic); optional 'highlight'/'highlightAr'/'highlightType' and
  // 'examplesTitle'/'examples' (+Ar). The renderer picks by locale and falls
  // back to English when an Arabic value is absent.
  final List<Map<String, String>> slides;

  // Key Terms glossary: { 'term', 'termAr', 'def', 'defAr' }.
  final List<Map<String, String>>? keyTerms;

  /// Every Practice / Games / Sim activity the website module has.
  final List<ModuleActivity> activities;

  const EducationModuleContent({
    required this.id,
    required this.title,
    this.titleAr,
    required this.slides,
    this.keyTerms,
    required this.activities,
  });

  String titleFor(bool isArabic) =>
      isArabic && (titleAr?.trim().isNotEmpty ?? false) ? titleAr! : title;

  List<ModuleActivity> activitiesIn(ActivityTab tab) =>
      activities.where((a) => a.tab == tab).toList();

  int maxScoreIn(ActivityTab tab) =>
      activitiesIn(tab).fold(0, (t, a) => t + a.maxScore);

  /// Sum of every activity's max: equals the server's module max score.
  int get maxScore => activities.fold(0, (t, a) => t + a.maxScore);

  /// The website section ids, in slide order (resume support).
  List<String> get sectionIds => [for (final s in slides) s['id'] ?? ''];
}

// Keyed by the module's PERMANENT catalog id (lib/data/education_catalog.dart),
// which is also each content file's `id`. Listed in hub order. Time Value of
// Money (id 5) and ids 14-18 have no ported content yet; the hub opens them on
// the website. Id 8 is retired.
final educationModuleContents = <int, EducationModuleContent>{
  1: module1Data, // Financial Management Primer
  3: module3Data, // Understanding Financial Statements
  4: module4Data, // Analysis of Financial Statements
  6: module6Data, // Budgeting & Financial Planning
  7: module7Data, // IFRS vs IPSAS Standards
  2: module2Data, // Sector Finance Comparison
  9: module9Data, // Compliance & Internal Controls
  10: module10Data, // Financial Auditing & Review
};
