// Lookup and search over the generated Knowledge Base catalog
// (website parity: getArticle / getCategoryLabel / searchArticles in
// client/src/data/knowledge-base/index.ts).

import '../../../data/education_catalog.dart';
import 'kb_catalog.dart';
import 'kb_models.dart';

KBArticle? kbArticleById(String id) {
  for (final a in kbArticles) {
    if (a.id == id) return a;
  }
  return null;
}

Bi kbCategoryLabel(String id) {
  for (final c in kbCategories) {
    if (c.id == id) return c.label;
  }
  return Bi(id, id);
}

/// Case-insensitive substring search across titles, summaries, keywords, related
/// terms and section headings in both languages (same haystack as the website).
List<KBArticle> kbSearch(String query, {String? category}) {
  final q = query.trim().toLowerCase();
  return kbArticles.where((a) {
    if (category != null && a.category != category) return false;
    if (q.isEmpty) return true;
    final haystack = [
      a.title.en,
      a.title.ar,
      a.summary.en,
      a.summary.ar,
      ...a.keywords,
      ...a.relatedTerms,
      ...a.sections.map((s) => '${s.heading.en} ${s.heading.ar}'),
    ].join(' ').toLowerCase();
    return haystack.contains(q);
  }).toList();
}

int kbCategoryCount(String category) => kbArticles.where((a) => a.category == category).length;

/// In-app route for a related-module chip. Articles link modules by their website
/// path; the education catalog maps that to the app's screen. Paths that are not in
/// the catalog (retired government-track and pre-rename links, which 404 on the
/// website too) return null and the chip is not shown.
String? kbModuleRoute(String href) {
  for (final e in educationCatalog) {
    if (e.href == href) return e.route;
  }
  return null;
}
