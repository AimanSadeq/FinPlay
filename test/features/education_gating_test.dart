import 'package:flutter_test/flutter_test.dart';
import 'package:finplay/data/education_catalog.dart';
import 'package:finplay/features/education/education_gating.dart';

/// Hub order without the game, as the hub shows it.
final List<int> hubOrder =
    educationCatalog.where((m) => !m.isSimulation).map((m) => m.num).toList();

bool webOnly(int id) {
  final e = catalogEntry(id);
  return e != null && e.isContent && !e.inApp;
}

void main() {
  group('module plan', () {
    test('null or empty plan means every module', () {
      expect(isModuleInPlan(15, null), isTrue);
      expect(isModuleInPlan(15, const []), isTrue);
      expect(isModuleInPlan(15, const [1, 3]), isFalse);
      expect(isModuleInPlan(3, const [1, 3]), isTrue);
    });

    test('parse keeps real ids in catalog order and fails open', () {
      expect(parseModulePlan({'moduleNums': null}), isNull);
      expect(parseModulePlan(null), isNull);
      expect(parseModulePlan({'moduleNums': 'oops'}), isNull);
      // 99 is not a catalog id; nothing real -> whole catalog.
      expect(parseModulePlan({'moduleNums': [99]}), isNull);
      // Catalog (hub) order: 1, 3, 4 ... 2 comes after 7.
      expect(parseModulePlan({'moduleNums': [2, 1, 4, 99]}), [1, 4, 2]);
    });

    test('optional module 18 is required only when the plan names it', () {
      expect(isRequiredModule(18, null), isFalse);
      expect(isRequiredModule(18, const [1, 3]), isFalse);
      expect(isRequiredModule(18, const [1, 18]), isTrue);
      expect(isRequiredModule(1, null), isTrue);
    });
  });

  group('progressive unlock', () {
    test('only the first module is open on a fresh start', () {
      final open = progressiveUnlocked(
        displayed: hubOrder,
        learnDone: (_) => false,
        toolVisited: (_) => false,
      );
      expect(open, {hubOrder.first});
    });

    test('a workshop tool advances the chain only once it has been opened', () {
      // 1, 3, 4, 5 done; 5 is followed by the Break-Even tool (11), then 12.
      final done = {1, 3, 4, 5};
      final notVisited = progressiveUnlocked(
        displayed: hubOrder,
        learnDone: done.contains,
        toolVisited: (_) => false,
      );
      expect(notVisited, containsAll([1, 3, 4, 5, 11]));
      expect(notVisited.contains(12), isFalse, reason: 'tool 11 not opened yet');

      final visited = progressiveUnlocked(
        displayed: hubOrder,
        learnDone: done.contains,
        toolVisited: (id) => id == 11,
      );
      expect(visited.contains(12), isTrue);
      expect(visited.contains(6), isFalse, reason: 'tool 12 not opened yet');
    });

    test('an existing learner past the tools is not re-locked behind them', () {
      // Progress from before visit-tracking: lessons done well past 11 and 12,
      // no visit flags (or a new device / reinstall, where flags are not synced).
      final done = {1, 3, 4, 5, 6, 7};
      final visited = inferToolsVisited(
        hubOrder: hubOrder,
        visited: const {},
        hasProgress: done.contains,
      );
      expect(visited, {11, 12});
      final open = progressiveUnlocked(
        displayed: hubOrder,
        learnDone: done.contains,
        toolVisited: visited.contains,
      );
      expect(open, containsAll([6, 7, 2]));
    });

    test('tool visits are not inferred without later progress', () {
      expect(
          inferToolsVisited(hubOrder: hubOrder, visited: const {}, hasProgress: {1, 3, 4, 5}.contains),
          isEmpty);
      // Progress just past 11 (on 12 itself is a tool) — only 6 onwards counts.
      expect(
          inferToolsVisited(hubOrder: hubOrder, visited: const {11}, hasProgress: {6}.contains),
          {11, 12});
    });

    test('simulation opens once every REQUIRED module is complete', () {
      final allButOptional = progressiveUnlocked(
        displayed: hubOrder,
        learnDone: (id) => id != 18,
        toolVisited: (_) => true,
      );
      expect(allButOptional.contains(simulationCatalogId), isTrue,
          reason: 'optional 18 outside the plan never holds the game back');

      final planNames18 = progressiveUnlocked(
        displayed: hubOrder,
        learnDone: (id) => id != 18,
        toolVisited: (_) => true,
        plan: hubOrder,
      );
      expect(planNames18.contains(simulationCatalogId), isFalse);
    });

    test('a plan narrows the chain to its own modules', () {
      final plan = [1, 3, 6];
      final displayed = hubOrder.where((id) => isModuleInPlan(id, plan)).toList();
      expect(displayed, [1, 3, 6]);
      final open = progressiveUnlocked(
        displayed: displayed,
        learnDone: {1, 3}.contains,
        toolVisited: (_) => false,
        plan: plan,
      );
      expect(open, {1, 3, 6});
      final finished = progressiveUnlocked(
        displayed: displayed,
        learnDone: {1, 3, 6}.contains,
        toolVisited: (_) => false,
        plan: plan,
      );
      expect(finished.contains(simulationCatalogId), isTrue);
    });

    test('website-only modules pass through in the app', () {
      final open = progressiveUnlocked(
        displayed: hubOrder,
        learnDone: (id) => catalogEntry(id)?.inApp ?? false,
        toolVisited: (_) => true,
        passThrough: webOnly,
      );
      expect(open, containsAll(hubOrder));
      expect(open.contains(simulationCatalogId), isTrue);
    });
  });

  group('hub unlock', () {
    const progressive = {1, 3};

    test('self-paced: simulation open from the start, content progressive', () {
      expect(isHubModuleUnlocked(13, isSelfPaced: true, progressive: progressive), isTrue);
      expect(isHubModuleUnlocked(3, isSelfPaced: true, progressive: progressive), isTrue);
      expect(isHubModuleUnlocked(4, isSelfPaced: true, progressive: progressive), isFalse);
      // The facilitator list does not apply to self-paced learners.
      expect(
          isHubModuleUnlocked(4,
              isSelfPaced: true, progressive: progressive, forceUnlocked: const [4]),
          isFalse);
    });

    test('demo account lifts the module chain', () {
      expect(
          isHubModuleUnlocked(15,
              isSelfPaced: true, progressive: progressive, isDemoAccount: true),
          isTrue);
    });

    test('corporate: facilitator list force-opens on top of progression', () {
      expect(isHubModuleUnlocked(3, isSelfPaced: false, progressive: progressive), isTrue);
      expect(isHubModuleUnlocked(9, isSelfPaced: false, progressive: progressive), isFalse);
      expect(
          isHubModuleUnlocked(9,
              isSelfPaced: false, progressive: progressive, forceUnlocked: const [9]),
          isTrue);
    });

    test('corporate: the global Education lock wins', () {
      expect(
          isHubModuleUnlocked(1,
              isSelfPaced: false,
              progressive: progressive,
              forceUnlocked: const [1],
              educationGloballyLocked: true),
          isFalse);
      // The facilitator's own session is never locked out.
      expect(
          isHubModuleUnlocked(1,
              isSelfPaced: false,
              progressive: progressive,
              isFacilitator: true,
              educationGloballyLocked: true),
          isTrue);
    });

    test('corporate simulation: earned, opened by the facilitator, or facilitator session', () {
      expect(isHubModuleUnlocked(13, isSelfPaced: false, progressive: progressive), isFalse);
      // Not on the force-open list's terms.
      expect(
          isHubModuleUnlocked(13,
              isSelfPaced: false, progressive: progressive, forceUnlocked: const [13]),
          isFalse);
      expect(
          isHubModuleUnlocked(13,
              isSelfPaced: false, progressive: progressive, simAccessOpen: true),
          isTrue);
      expect(
          isHubModuleUnlocked(13,
              isSelfPaced: false, progressive: progressive, isFacilitator: true),
          isTrue);
      expect(
          isHubModuleUnlocked(13,
              isSelfPaced: false, progressive: {...progressive, 13}),
          isTrue);
    });
  });

  group('home simulation tile (corporate gate)', () {
    test('locked only on an explicit closed switch with lessons unfinished', () {
      expect(
          isCorporateSimLocked(
              isSelfPaced: false, hasTeam: true, simAccessOpen: false, learnComplete: false),
          isTrue);
      expect(
          isCorporateSimLocked(
              isSelfPaced: false, hasTeam: true, simAccessOpen: null, learnComplete: false),
          isFalse,
          reason: 'unknown state never dims the tile');
      expect(
          isCorporateSimLocked(
              isSelfPaced: false, hasTeam: true, simAccessOpen: true, learnComplete: false),
          isFalse);
      expect(
          isCorporateSimLocked(
              isSelfPaced: false, hasTeam: true, simAccessOpen: false, learnComplete: true),
          isFalse);
    });

    test('self-paced, facilitator, demo and team-less sessions are never gated', () {
      expect(
          isCorporateSimLocked(
              isSelfPaced: true, hasTeam: true, simAccessOpen: false, learnComplete: false),
          isFalse);
      expect(
          isCorporateSimLocked(
              isSelfPaced: false,
              hasTeam: true,
              isFacilitator: true,
              simAccessOpen: false,
              learnComplete: false),
          isFalse);
      expect(
          isCorporateSimLocked(
              isSelfPaced: false,
              hasTeam: true,
              isDemoAccount: true,
              simAccessOpen: false,
              learnComplete: false),
          isFalse);
      expect(
          isCorporateSimLocked(
              isSelfPaced: false, hasTeam: false, simAccessOpen: false, learnComplete: false),
          isFalse);
    });

    test('learn-complete needs every required module, never optional 18', () {
      expect(isEducationLearnComplete(learnDone: (id) => id != 18), isTrue);
      expect(isEducationLearnComplete(learnDone: (id) => id != 1), isFalse);
      expect(
          isEducationLearnComplete(
              learnDone: (id) => catalogEntry(id)?.inApp ?? false, passThrough: webOnly),
          isTrue);
    });
  });

  test('tool visits are kept per progress scope', () {
    expect(toolVisitedPrefKey('sp', 11), 'edu_tool_visited_sp_11');
    expect(toolVisitedPrefKey('3', 12), 'edu_tool_visited_3_12');
  });
}
