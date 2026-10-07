import 'package:flutter_test/flutter_test.dart';
import 'package:finplay/data/education_catalog.dart';
import 'package:finplay/data/module_plan.dart';
import 'package:finplay/features/education/screens/education_hub_screen.dart';

/// The hub, the simulation gates and the web-module screen all read the module
/// plan from GET /education/module-plan through [ModulePlan].
void main() {
  const library = [19, 20, 21, 22];
  // Today's hub: the sixteen modules in today's order.
  const todaysHub = [1, 3, 4, 5, 11, 12, 6, 7, 2, 9, 10, 14, 15, 16, 17, 18];

  group('fallback (no plan, or the call failed)', () {
    test('is today\'s hub without the library modules', () {
      const plan = ModulePlan.fallback;
      expect(plan.isServerPlan, isFalse);
      expect(plan.hubModuleNums, todaysHub);
      for (final n in library) {
        expect(plan.includes(n), isFalse, reason: 'id $n');
      }
      expect(plan.includes(13), isFalse, reason: 'the game is not a card');
    });

    test('marks Financial Risk Assessment optional, as the catalog does', () {
      const plan = ModulePlan.fallback;
      expect(plan.isOptional(18), isTrue);
      expect(plan.isRequired(18), isFalse);
      expect(plan.isRequired(1), isTrue);
      expect(plan.requiredContentNums,
          [1, 3, 4, 5, 6, 7, 2, 9, 10, 14, 15, 16, 17]);
      expect(plan.requiredInAppContentNums,
          inAppContentModules.map((m) => m.num).toList());
    });

    test('moduleNums null in the response is the fallback', () {
      final plan = ModulePlan.fromJson({
        'success': true,
        'moduleNums': null,
        'optionalModuleNums': <int>[],
        'course': null,
        'catalog': educationCatalog.map((m) => m.num).toList(),
        'addons': <Object>[],
      });
      expect(plan, ModulePlan.fallback);
      expect(plan.hubModuleNums, isNot(contains(19)));
    });

    test('an error body, a missing field or a junk value is the fallback', () {
      expect(ModulePlan.fromJson({'success': false, 'moduleNums': [1, 2]}),
          ModulePlan.fallback);
      expect(ModulePlan.fromJson({'success': true}), ModulePlan.fallback);
      expect(ModulePlan.fromJson({'success': true, 'moduleNums': 'all'}),
          ModulePlan.fallback);
    });

    test('a plan naming nothing the hub can show is the fallback', () {
      expect(ModulePlan.fromJson({'success': true, 'moduleNums': <int>[]}),
          ModulePlan.fallback);
      expect(ModulePlan.fromJson({'success': true, 'moduleNums': [8, 99]}),
          ModulePlan.fallback);
      expect(ModulePlan.fromJson({'success': true, 'moduleNums': [13]}),
          ModulePlan.fallback);
    });
  });

  group('server plan', () {
    test('shows exactly the plan\'s modules in the plan\'s order', () {
      final plan = ModulePlan.fromJson({
        'success': true,
        'moduleNums': [20, 1, 19, 6, 13, 18],
        'optionalModuleNums': [18],
      });
      expect(plan.isServerPlan, isTrue);
      expect(plan.hubModuleNums, [20, 1, 19, 6, 18]);
      expect(plan.includes(3), isFalse);
    });

    test('the self-paced core set reproduces today\'s hub', () {
      final plan = ModulePlan.fromJson({
        'success': true,
        'moduleNums': todaysHub,
        'optionalModuleNums': [18],
      });
      expect(plan.hubModuleNums, todaysHub);
      expect(plan.isOptional(18), isTrue);
      expect(plan.requiredContentNums, ModulePlan.fallback.requiredContentNums);
    });

    test('optional comes from the plan, not the catalog', () {
      final plan = ModulePlan.fromJson({
        'success': true,
        'moduleNums': [1, 18, 21, 22],
        'optionalModuleNums': [22],
      });
      // Financial Risk Assessment is required in a plan that does not mark it.
      expect(plan.isOptional(18), isFalse);
      expect(plan.isRequired(18), isTrue);
      expect(plan.isOptional(22), isTrue);
      expect(plan.requiredContentNums, [1, 18, 21]);
      // Of those, only id 1 has its Learn section in the app.
      expect(plan.requiredInAppContentNums, [1]);
    });

    test('unknown ids and duplicates are dropped; optional ids outside the plan are ignored', () {
      final plan = ModulePlan.fromJson({
        'success': true,
        'moduleNums': [3, 8, 3, 99, 21, 4.0],
        'optionalModuleNums': [21, 5],
      });
      expect(plan.hubModuleNums, [3, 21, 4]);
      expect(plan.optionalModuleNums, {21});
      expect(plan.isOptional(5), isFalse);
    });

    test('survives the cache round trip', () {
      final plan = ModulePlan.of([19, 1, 18], optional: [18]);
      expect(ModulePlan.fromJson(plan.toJson()), plan);
      expect(ModulePlan.fromJson(ModulePlan.fallback.toJson()), ModulePlan.fallback);
    });
  });

  group('hub cards', () {
    test('follow the plan\'s order and filter', () {
      final plan = ModulePlan.of([22, 1, 11, 18, 19], optional: [18]);
      expect(educationHubCardIdsFor(plan), [22, 1, 11, 18, 19]);
    });

    test('fallback draws today\'s sixteen cards, none of the library modules', () {
      final ids = educationHubCardIdsFor(ModulePlan.fallback);
      expect(ids, todaysHub);
      for (final n in library) {
        expect(ids, isNot(contains(n)));
      }
    });

    test('every catalog module can be drawn when a plan names it', () {
      final all = educationCatalog.map((m) => m.num).toList();
      final plan = ModulePlan.of(all);
      expect(educationHubCardIdsFor(plan),
          educationCatalog.where((m) => !m.isSimulation).map((m) => m.num));
    });
  });
}
