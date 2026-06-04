import 'data/module1_data.dart';
import 'data/module2_data.dart';
import 'data/module3_data.dart';
import 'data/module4_data.dart';
import 'data/module5_data.dart';
import 'data/module6_data.dart';
import 'data/module7_data.dart';
import 'data/module8_data.dart';
import 'data/module9_data.dart';
import 'data/module10_data.dart';

enum GameType { memoryMatch, classification, ordering }

class GovModuleContent {
  final int id;
  final String title;
  final String gameTitle;
  final String gameDescription;
  final GameType gameType;
  final List<Map<String, String>> slides;
  final List<Map<String, dynamic>> quizQuestions;

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
    this.memoryPairs,
    this.classificationCategories,
    this.classificationItems,
    this.orderingInstruction,
    this.orderingItems,
    this.statementBuilderCategories,
    this.statementBuilderItems,
  });
}

// Display order matches the website education hub exactly.
// Positions 4 & 5 (Break-Even, Capital Budgeting) are separate screens, not gov modules.
final govModuleContents = <int, GovModuleContent>{
  1:  module1Data,   // 1. Financial Management Primer
  2:  module3Data,   // 2. Understanding Financial Statements
  3:  module4Data,   // 3. Analysis of Financial Statements
  // 4. Break-Even Analysis        → routes to /education/break-even
  // 5. Capital Budgeting           → routes to /education/capital-budgeting
  6:  module6Data,   // 6. Budgeting & Financial Planning
  7:  module7Data,   // 7. IFRS vs IPSAS Standards
  8:  module2Data,   // 8. Sector Finance Comparison
  9:  module9Data,   // 9. Compliance & Internal Controls
  10: module10Data,  // 10. Financial Auditing & Review
  // Bonus modules — fully authored content surfaced as extra hub slots.
  11: module5Data,   // 11. Elements of Finance
  12: module8Data,   // 12. Government Financial Decisions
};
