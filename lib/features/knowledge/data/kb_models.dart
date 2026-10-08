// Knowledge Base article schema (website parity: client/src/data/knowledge-base/types.ts).
//
// The article data itself is generated from the website's TypeScript into
// `articles/` + `kb_catalog.dart`; this file holds the shapes plus the small
// amount of logic the screens share (lookup, search, labels).

/// A bilingual string.
class Bi {
  final String en;
  final String ar;
  const Bi(this.en, this.ar);

  String of(bool arabic) => arabic ? ar : en;
}

enum KBLevel { foundation, intermediate, advanced }

/// Level badge labels, copied from the website's article pages.
const Map<KBLevel, Bi> kbLevelLabels = {
  KBLevel.foundation: Bi('Foundation', 'تأسيسي'),
  KBLevel.intermediate: Bi('Intermediate', 'متوسط'),
  KBLevel.advanced: Bi('Advanced', 'متقدم'),
};

class KBCategory {
  final String id;
  final Bi label;
  final Bi description;
  const KBCategory(this.id, {required this.label, required this.description});
}

class KBFormula {
  /// Unicode math, always rendered LTR even in Arabic mode.
  final String formula;
  final Bi? caption;
  const KBFormula(this.formula, {this.caption});
}

class KBTable {
  final List<Bi> headers;
  final List<List<Bi>> rows;
  const KBTable({required this.headers, required this.rows});
}

class KBSection {
  final Bi heading;
  final List<Bi> paragraphs;
  final List<KBFormula> formulas;
  final List<Bi> bullets;
  final KBTable? table;
  const KBSection({
    required this.heading,
    required this.paragraphs,
    this.formulas = const [],
    this.bullets = const [],
    this.table,
  });
}

/// One run of a standards label. Runs with [href] name a standard whose
/// issuing body publishes a confirmed landing page (pre-computed by the
/// website's `parseStandardLabel`); the rest are plain text.
class KBStandardSegment {
  final String text;
  final String? href;

  /// True when [href] is a pronouncements index rather than the standard's own page.
  final bool viaIndex;
  const KBStandardSegment(this.text, {this.href, this.viaIndex = false});
}

class KBStandardRef {
  /// e.g. "IAS 7 §18–20". Shown verbatim, LTR.
  final String standard;
  final Bi note;
  final List<KBStandardSegment> segments;
  const KBStandardRef({required this.standard, required this.note, required this.segments});
}

class KBRelatedModule {
  /// Website path of the module (mapped to an in-app route via the education catalog).
  final String href;
  final Bi label;
  const KBRelatedModule(this.href, this.label);
}

class KBArticle {
  final String id;
  final Bi title;
  final String category;
  final KBLevel level;
  final int readingMinutes;
  final Bi summary;
  final List<KBSection> sections;
  final List<Bi> pitfalls;
  final List<KBStandardRef> standards;

  /// Display names of glossary entries.
  final List<String> relatedTerms;
  final List<KBRelatedModule> relatedModules;
  final List<String> relatedArticles;

  /// APA 7th entries, English only.
  final List<String> references;

  /// Extra search hooks in both languages.
  final List<String> keywords;

  const KBArticle({
    required this.id,
    required this.title,
    required this.category,
    required this.level,
    required this.readingMinutes,
    required this.summary,
    required this.sections,
    required this.pitfalls,
    required this.standards,
    required this.relatedTerms,
    required this.relatedModules,
    required this.relatedArticles,
    required this.references,
    required this.keywords,
  });
}
