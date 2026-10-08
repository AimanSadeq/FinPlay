// A Financial Terms Directory entry (website parity: client/src/data/financial-terms.ts
// plus the Arabic extras from financial-terms-ar.ts). The data is generated into
// `financial_terms_data.dart`; the glossary and the Term Trainer both read it.

import 'financial_terms_data.dart';

class FinancialTerm {
  final String id;
  final String term;
  final String arabicTerm;
  final String category;
  final String shortDefinition;
  final String fullDefinition;
  final String arabicDefinition;
  final String? formula;
  final String? example;
  final String? importance;
  final List<String> relatedTerms;
  final List<String> tips;

  // Arabic halves of the fields above (absent where the website has none).
  final String? formulaAr;
  final String? exampleAr;
  final String? importanceAr;
  final List<String> tipsAr;

  const FinancialTerm({
    required this.id,
    required this.term,
    required this.arabicTerm,
    required this.category,
    required this.shortDefinition,
    required this.fullDefinition,
    required this.arabicDefinition,
    this.formula,
    this.example,
    this.importance,
    this.relatedTerms = const [],
    this.tips = const [],
    this.formulaAr,
    this.exampleAr,
    this.importanceAr,
    this.tipsAr = const [],
  });

  String termIn(bool ar) => ar ? arabicTerm : term;
  String definitionIn(bool ar) => ar ? arabicDefinition : fullDefinition;

  /// Website behaviour: the formula block only renders when an English formula
  /// exists; in Arabic it shows the Arabic formula when there is one.
  String? formulaIn(bool ar) => formula == null ? null : (ar ? (formulaAr ?? formula) : formula);
  String? exampleIn(bool ar) => example == null ? null : (ar ? (exampleAr ?? example) : example);
  String? importanceIn(bool ar) =>
      importance == null ? null : (ar ? (importanceAr ?? importance) : importance);
  List<String> tipsIn(bool ar) => tips.isEmpty ? const [] : (ar && tipsAr.isNotEmpty ? tipsAr : tips);

  /// True when the shown formula is the Arabic prose version (RTL, normal face).
  bool formulaIsArabic(bool ar) => ar && formula != null && formulaAr != null;
}

/// Arabic category label, falling back to the English one so nothing renders blank.
String termCategoryLabel(String category, bool ar) =>
    ar ? (arabicTermCategories[category] ?? category) : category;

/// Website search (financial-education.tsx): case-insensitive substring over the
/// English term, the Arabic term and the short definition. Extended here to the
/// Arabic definition too, so an Arabic query also matches on meaning.
bool termMatches(FinancialTerm t, String query) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return true;
  return t.term.toLowerCase().contains(q) ||
      t.arabicTerm.toLowerCase().contains(q) ||
      t.shortDefinition.toLowerCase().contains(q) ||
      t.arabicDefinition.contains(q);
}

/// Resolves a display name (e.g. a Knowledge Base related-term chip) to a term,
/// using the website's deep-link matching order: exact, then "(ABBR)", then
/// substring either way.
FinancialTerm? findTermByName(String name) {
  final wanted = name.toLowerCase();
  for (final t in financialTerms) {
    if (t.term.toLowerCase() == wanted) return t;
  }
  for (final t in financialTerms) {
    if (t.term.toLowerCase().contains('($wanted)')) return t;
  }
  for (final t in financialTerms) {
    final tl = t.term.toLowerCase();
    if (tl.contains(wanted) || wanted.contains(tl)) return t;
  }
  return null;
}
