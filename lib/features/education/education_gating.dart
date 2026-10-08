/// Who can open which education module, and when the simulation opens.
///
/// Pure functions, mirroring the website's client/src/pages/education-hub.tsx
/// (isModuleUnlocked / progressiveUnlocked), client/src/pages/home.tsx
/// (corporateSimLocked) and shared/education-catalog.ts (isModuleInPlan,
/// scoredModuleIdsForPlan). Kept free of Flutter and SharedPreferences so the
/// rules can be unit-tested; the screens feed in what they read from prefs and
/// the server.
///
/// One app-specific rule: a content module whose lessons live only on the
/// website (no in-app route) cannot be finished inside the app, so it never
/// holds the chain or the simulation back here. Pass it in [passThrough].
library;

import '../../data/education_catalog.dart';

/// The simulation's catalog id.
const int simulationCatalogId = 13;

/// Is this module part of the cohort's engagement? A null or empty plan means
/// "everything" (the main site and every unplanned cohort).
bool isModuleInPlan(int id, List<int>? plan) {
  if (plan == null || plan.isEmpty) return true;
  return plan.contains(id);
}

/// Parse GET /education/module-plan -> { moduleNums: int[] | null, catalog }.
/// Anything unexpected resolves to null (the whole catalog): the plan fails open.
List<int>? parseModulePlan(Map<String, dynamic>? res) {
  final raw = res?['moduleNums'];
  if (raw is! List) return null;
  final nums = raw.whereType<num>().map((n) => n.toInt()).toSet();
  // Same normalisation as the website: keep only real catalog ids, in catalog
  // order, and treat a plan that names nothing real as "everything".
  final kept = [
    for (final m in educationCatalog)
      if (nums.contains(m.num)) m.num,
  ];
  return kept.isEmpty ? null : kept;
}

/// An optional module is required only when the cohort's plan names it.
bool isRequiredModule(int id, List<int>? plan) {
  final entry = catalogEntry(id);
  if (entry == null || !entry.optional) return true;
  return plan != null && plan.contains(id);
}

/// Progressive unlock: the set of catalog ids open to a learner, plus
/// [simulationCatalogId] once every REQUIRED module is complete.
///
/// [displayed] is the hub's cards in hub order, already filtered by the plan,
/// simulation excluded. A content module is complete when its Learn section is
/// done ([learnDone]); a workshop tool when it has been opened at least once
/// ([toolVisited]) — opening it is what moves the chain past it, one tile at a
/// time. [passThrough] modules count as complete (see library comment).
Set<int> progressiveUnlocked({
  required List<int> displayed,
  required bool Function(int id) learnDone,
  required bool Function(int id) toolVisited,
  bool Function(int id)? passThrough,
  List<int>? plan,
}) {
  bool isComplete(int id) {
    if (passThrough != null && passThrough(id)) return true;
    final entry = catalogEntry(id);
    if (entry != null && entry.isWorkshop) return toolVisited(id);
    return learnDone(id);
  }

  final open = <int>{};
  var chainOpen = true; // the first module is always open
  for (final id in displayed) {
    if (id == simulationCatalogId) continue;
    if (chainOpen) open.add(id);
    chainOpen = chainOpen && isComplete(id);
  }
  final required = displayed
      .where((id) => id != simulationCatalogId && isRequiredModule(id, plan));
  if (required.every(isComplete)) open.add(simulationCatalogId);
  return open;
}

/// Workshop visits recorded before visit-tracking existed (or lost to a new
/// device or a reinstall — the visit flag is local and not synced): a tool
/// counts as opened when it was recorded as opened, or when any module after
/// it in hub order already has progress, since the learner could only have got
/// there through the tool. [hubOrder] is the full hub order, game excluded.
Set<int> inferToolsVisited({
  required List<int> hubOrder,
  required Set<int> visited,
  required bool Function(int id) hasProgress,
}) {
  final result = {...visited};
  var laterProgress = false;
  for (final id in hubOrder.reversed) {
    if (id == simulationCatalogId) continue;
    final entry = catalogEntry(id);
    if (entry != null && entry.isWorkshop) {
      if (laterProgress) result.add(id);
    } else if (hasProgress(id)) {
      laterProgress = true;
    }
  }
  return result;
}

/// Website isModuleUnlocked().
///
/// * Self-paced: the simulation is open from the start; content modules are
///   progressive, except for demo accounts (plan == 'demo'), which see all.
/// * Corporate: the simulation opens on full completion, when the facilitator
///   opens the game ([simAccessOpen]), or for the facilitator's own session.
///   Content modules are progressive, and the facilitator's list
///   ([forceUnlocked]) force-opens on top. The facilitator's global Education
///   lock wins over both.
bool isHubModuleUnlocked(
  int id, {
  required bool isSelfPaced,
  required Set<int> progressive,
  bool isDemoAccount = false,
  bool isFacilitator = false,
  bool simAccessOpen = false,
  bool educationGloballyLocked = false,
  List<int> forceUnlocked = const [],
}) {
  if (isSelfPaced) {
    if (id == simulationCatalogId) return true;
    return isDemoAccount || progressive.contains(id);
  }
  if (id == simulationCatalogId) {
    return progressive.contains(simulationCatalogId) || simAccessOpen || isFacilitator;
  }
  if (educationGloballyLocked && !isFacilitator) return false;
  return progressive.contains(id) || forceUnlocked.contains(id);
}

/// Website isEducationLearnComplete(): every scored content module required by
/// default (no plan, optional modules excluded) has its Learn section done.
bool isEducationLearnComplete({
  required bool Function(int id) learnDone,
  bool Function(int id)? passThrough,
}) {
  return educationCatalog
      .where((m) => m.isContent && !m.optional)
      .every((m) => (passThrough != null && passThrough(m.num)) || learnDone(m.num));
}

/// Website home.tsx corporateSimLocked: the home "simulation" tile is dimmed
/// for a corporate delegate until they finish the modules OR the facilitator
/// opens the game. Only an explicit `open: false` locks — while the setting is
/// loading or unreadable ([simAccessOpen] null) the tile stays enabled.
bool isCorporateSimLocked({
  required bool isSelfPaced,
  required bool hasTeam,
  required bool? simAccessOpen,
  required bool learnComplete,
  bool isFacilitator = false,
  bool isDemoAccount = false,
}) {
  return !isSelfPaced &&
      hasTeam &&
      !isFacilitator &&
      !isDemoAccount &&
      simAccessOpen == false &&
      !learnComplete;
}

/// Pref key recording that a workshop tool was opened (website toolsVisited),
/// per progress scope ('sp' or the corporate team id), like the module keys.
String toolVisitedPrefKey(String scope, int id) => 'edu_tool_visited_${scope}_$id';
