import 'package:flutter_test/flutter_test.dart';
import 'package:finplay/data/education_catalog.dart';
import 'package:finplay/features/facilitator/screens/facilitator_screen.dart';

/// The server (POST /facilitator/toggle-education-module) validates moduleId
/// against the website's FORCE_UNLOCKABLE_MODULE_NUMS: every catalog entry
/// except the simulation. The per-module switches must offer exactly that set.
void main() {
  group('facilitator education module switches', () {
    test('are the catalog non-simulation ids in catalog order', () {
      final expected = educationCatalog
          .where((m) => !m.isSimulation)
          .map((m) => m.num)
          .toList();
      expect(facilitatorEducationModuleIds, expected);
    });

    test('never include the simulation (id 13), which the server rejects', () {
      expect(facilitatorEducationModuleIds, isNot(contains(13)));
      expect(facilitatorEducationModuleIds, isNot(contains(8))); // retired
    });
  });
}
