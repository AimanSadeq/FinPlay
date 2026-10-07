/// The program's module plan: which catalog modules a learner works through,
/// in which order, and which of them are optional.
///
/// The website resolves it per host (the main site's self-paced core set, or a
/// cohort's own selection) and serves it unauthenticated from
/// GET /api/education/module-plan as
/// `{ success, moduleNums, optionalModuleNums, course, catalog, addons }`,
/// where `moduleNums` is the ordered selection, or null when no plan is set.
/// The server fails open: a lookup error answers `moduleNums: null`.
///
/// Every place in the app that decides which modules a learner sees or must
/// finish reads one [ModulePlan], so the hub, the simulation gates and the
/// web-module screen agree with each other and with the website.
library;

import 'package:flutter/foundation.dart';

import 'education_catalog.dart';

@immutable
class ModulePlan {
  /// The plan's catalog ids in the server's order, or null for no plan, in
  /// which case the default core set applies (see [ModulePlan.fallback]).
  final List<int>? moduleNums;

  /// Ids the plan marks optional: shown and scored, never required.
  final Set<int> optionalModuleNums;

  const ModulePlan._(this.moduleNums, this.optionalModuleNums);

  /// No server plan (none set, call failed, or not answered yet): the hub as it
  /// was before plans, without the library modules outside the default core
  /// set, and optional where the catalog says so.
  static const ModulePlan fallback = ModulePlan._(null, <int>{});

  /// A plan from the server's lists. Ids the catalog does not know are dropped
  /// and duplicates keep their first position; a plan left with no module the
  /// app can show is treated as no plan, so a drifted plan never empties the
  /// hub. Optional ids outside the plan are ignored.
  factory ModulePlan.of(List<int>? moduleNums, {Iterable<int> optional = const []}) {
    if (moduleNums == null) return fallback;
    final seen = <int>{};
    final kept = <int>[
      for (final n in moduleNums)
        if (catalogEntry(n) != null && seen.add(n)) n,
    ];
    if (!kept.any((n) => !catalogEntry(n)!.isSimulation)) return fallback;
    return ModulePlan._(
      List.unmodifiable(kept),
      Set.unmodifiable(optional.where(seen.contains)),
    );
  }

  /// Parses the module-plan response. Anything unreadable is [fallback].
  factory ModulePlan.fromJson(Map<String, dynamic> json) {
    if (json['success'] == false) return fallback;
    final nums = _ints(json['moduleNums']);
    if (nums == null) return fallback;
    return ModulePlan.of(nums, optional: _ints(json['optionalModuleNums']) ?? const []);
  }

  /// The form the plan is cached in, readable by [ModulePlan.fromJson].
  Map<String, dynamic> toJson() => {
        'success': true,
        'moduleNums': moduleNums,
        'optionalModuleNums': optionalModuleNums.toList(),
      };

  static List<int>? _ints(Object? value) {
    if (value is! List) return null;
    return [
      for (final v in value)
        if (v is num && v == v.roundToDouble()) v.toInt(),
    ];
  }

  /// True when the server sent a plan; false for [fallback].
  bool get isServerPlan => moduleNums != null;

  /// The hub's module cards in display order: the plan's modules without the
  /// game (the hub shows the game in its own banner).
  List<int> get hubModuleNums => moduleNums == null
      ? defaultCoreModuleNums
      : [
          for (final n in moduleNums!)
            if (!catalogEntry(n)!.isSimulation) n,
        ];

  /// Is this module one of the hub's cards under this plan?
  bool includes(int num) => hubModuleNums.contains(num);

  /// Shown but not required: named optional by the plan, or by the catalog
  /// when no plan is in force.
  bool isOptional(int num) => moduleNums == null
      ? (catalogEntry(num)?.optional ?? false)
      : optionalModuleNums.contains(num);

  /// Counts toward completion: in the plan and not optional.
  bool isRequired(int num) => includes(num) && !isOptional(num);

  /// The scored content modules a learner must finish, in hub order.
  List<int> get requiredContentNums => [
        for (final n in hubModuleNums)
          if (catalogEntry(n)!.isContent && !isOptional(n)) n,
      ];

  /// The required content modules whose Learn section is done in this app:
  /// what the app's simulation gates check.
  List<int> get requiredInAppContentNums => [
        for (final n in requiredContentNums)
          if (catalogEntry(n)!.inApp) n,
      ];

  /// 1-based position of a module among the hub's cards under this plan, or
  /// null when the plan does not show it. Display only.
  int? hubPosition(int num) {
    final idx = hubModuleNums.indexOf(num);
    return idx < 0 ? null : idx + 1;
  }

  @override
  bool operator ==(Object other) =>
      other is ModulePlan &&
      listEquals(other.moduleNums, moduleNums) &&
      setEquals(other.optionalModuleNums, optionalModuleNums);

  @override
  int get hashCode => Object.hash(
        moduleNums == null ? null : Object.hashAll(moduleNums!),
        Object.hashAllUnordered(optionalModuleNums),
      );
}
