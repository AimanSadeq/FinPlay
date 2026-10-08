/// Per-cohort education module plan: the pure rules behind the facilitator's
/// module plan editor (website CohortModulePlanEditor.tsx + shared/education-catalog.ts).
///
/// A plan is a list of catalog ids. `null` means "the whole catalog", which is a real
/// state rather than every box ticked: a module added to FinPlay later then appears for
/// every cohort that bought everything. Saving a full selection, or an empty one,
/// therefore stores `null`.
library;

import '../../data/education_catalog.dart';

/// Every catalog id, in hub order (website `EDUCATION_CATALOG_NUMS`).
final List<int> educationCatalogNums = [for (final m in educationCatalog) m.num];

/// The key a module's work is stored under in the server's progress table, which is what
/// GET /facilitator/cohorts/:id/module-progress counts by. The workshop tools (ids 11, 12)
/// and the game (13) are not scored and have none. Mirrors `progressId` in the website's
/// shared/education-catalog.ts.
String? catalogProgressId(int num) {
  final entry = catalogEntry(num);
  if (entry == null || !entry.isContent) return null;
  if (num == 5) return 'tvm';
  return 'module$num';
}

/// Website `normalizeModulePlan`: keeps only real catalog ids, in catalog order; an empty
/// result is `null` (the whole catalog).
List<int>? normalizeModulePlan(Iterable<int>? input) {
  if (input == null) return null;
  final wanted = input.toSet();
  final kept = educationCatalogNums.where(wanted.contains).toList();
  return kept.isEmpty ? null : kept;
}

/// The selection the editor opens with: the stored plan, or every module when none.
Set<int> initialPlanSelection(List<int>? plan) =>
    (plan == null || plan.isEmpty) ? educationCatalogNums.toSet() : plan.toSet();

/// What "Save plan" sends: `null` for all or nothing, else the ticked ids in catalog order.
List<int>? planToSave(Set<int> selected) {
  if (selected.isEmpty || selected.length == educationCatalogNums.length) return null;
  return normalizeModulePlan(selected);
}

/// Modules about to be hidden that teams have already worked in.
List<EducationCatalogEntry> modulesLosingWork(Set<int> selected, Map<String, int> progress) => [
      for (final m in educationCatalog)
        if (!selected.contains(m.num) && (progress[catalogProgressId(m.num) ?? ''] ?? 0) > 0) m,
    ];

/// Reads a cohort's `educationModuleNums` from the API (null = whole catalog).
List<int>? readPlan(dynamic raw) {
  if (raw is! List) return null;
  final nums = raw.whereType<num>().map((n) => n.toInt()).toList();
  return nums.isEmpty ? null : nums;
}
