import 'data/module1_data.dart';
import 'data/module2_data.dart';
import 'data/module3_data.dart';
import 'data/module4_data.dart';
import 'data/module6_data.dart';
import 'data/module7_data.dart';
import 'data/module9_data.dart';
import 'data/module10_data.dart';

enum GameType { memoryMatch, classification, ordering }

class GovModuleContent {
  final int id;
  final String title;
  final String gameTitle;
  final String gameDescription;
  final GameType gameType;
  // Each slide is a map with 'title'/'content'/'keyPoint' (English) and optional
  // 'titleAr'/'contentAr'/'keyPointAr' (Arabic). The renderer picks by locale and
  // falls back to English when an Arabic value is absent — so partially-translated
  // modules still work. Optional Arabic title too: 'title'/'titleAr'.
  final List<Map<String, String>> slides;
  final List<Map<String, dynamic>> quizQuestions;
  // Optional bilingual module title (falls back to `title` when null).
  final String? titleAr;
  // Key Terms glossary for this module (website parity). Each entry:
  // { 'term', 'termAr', 'def', 'defAr' }. When present, the Learn tab shows a
  // "Key Terms" pill that opens these in a modal.
  final List<Map<String, String>>? keyTerms;

  // Memory match
  final List<Map<String, String>>? memoryPairs;
  // Classification
  final List<String>? classificationCategories;
  final List<Map<String, String>>? classificationItems;
  // Ordering
  final String? orderingInstruction;
  final List<String>? orderingItems;
  // Statement builder
  final List<String>? statementBuilderCategories;
  final List<Map<String, String>>? statementBuilderItems;

  const GovModuleContent({
    required this.id,
    required this.title,
    required this.gameTitle,
    required this.gameDescription,
    required this.gameType,
    required this.slides,
    required this.quizQuestions,
    this.titleAr,
    this.keyTerms,
    this.memoryPairs,
    this.classificationCategories,
    this.classificationItems,
    this.orderingInstruction,
    this.orderingItems,
    this.statementBuilderCategories,
    this.statementBuilderItems,
  });
}

// Keyed by the module's PERMANENT catalog id (lib/data/education_catalog.dart),
// which is also each content file's `id`. This map used to be keyed by hub card
// position, so Understanding Financial Statements (id 3) was stored and synced
// as id 2, which the server and the hub read as Sector Finance Comparison.
// Listed in hub order. Time Value of Money (id 5) and ids 14-18 have no ported
// content yet; the hub opens them on the website. Id 8 is retired.
final govModuleContents = <int, GovModuleContent>{
  1:  module1Data,   // Financial Management Primer
  3:  module3Data,   // Understanding Financial Statements
  4:  module4Data,   // Analysis of Financial Statements
  6:  module6Data,   // Budgeting & Financial Planning
  7:  module7Data,   // IFRS vs IPSAS Standards
  2:  module2Data,   // Sector Finance Comparison
  9:  module9Data,   // Compliance & Internal Controls
  10: module10Data,  // Financial Auditing & Review
};
