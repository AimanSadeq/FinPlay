import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finplay/core/utils/simulation_access.dart';
import 'package:finplay/data/education_catalog.dart';

/// The corporate simulation gate, as the website decides it in
/// client/src/pages/home.tsx (`corporateSimLocked`): a corporate team member
/// waits while the facilitator's switch is closed, unless the team finished
/// every Learn section. Self-paced learners and facilitators are never gated.
void main() {
  SimulationEntry decide({
    bool hasTeam = true,
    bool isSelfPaced = false,
    bool isFacilitator = false,
    bool? gateOpen = false,
    bool learnComplete = false,
  }) =>
      simulationEntryFor(
        hasTeam: hasTeam,
        isSelfPaced: isSelfPaced,
        isFacilitator: isFacilitator,
        gateOpen: gateOpen,
        learnComplete: learnComplete,
      );

  group('simulationEntryFor', () {
    test('a corporate team member waits while the switch is closed', () {
      expect(decide(gateOpen: false), SimulationEntry.waitForFacilitator);
    });

    test('the team enters once the facilitator opens the simulation', () {
      expect(decide(gateOpen: true), SimulationEntry.enter);
    });

    test('a self-paced learner is never gated', () {
      expect(
        decide(isSelfPaced: true, hasTeam: false, gateOpen: false),
        SimulationEntry.enter,
      );
    });

    test('a facilitator device is never gated', () {
      expect(decide(isFacilitator: true, gateOpen: false), SimulationEntry.enter);
    });

    test('a device with no team is not gated here (the screen asks it to join)', () {
      expect(decide(hasTeam: false, gateOpen: false), SimulationEntry.enter);
    });

    test('an unreadable switch leaves the simulation open, as on the website', () {
      expect(decide(gateOpen: null), SimulationEntry.enter);
    });

    test('a team that finished every Learn section enters without the switch', () {
      expect(decide(gateOpen: false, learnComplete: true), SimulationEntry.enter);
    });
  });

  group('simulationAccessFromJson', () {
    test('reads the { success, open } payload', () {
      expect(simulationAccessFromJson({'success': true, 'open': true}), isTrue);
      expect(simulationAccessFromJson({'success': true, 'open': false}), isFalse);
    });

    test('a dead route or a payload without the switch is unknown, not closed', () {
      expect(
        simulationAccessFromJson({'success': false, 'error': 'API route not found'}),
        isNull,
      );
      expect(simulationAccessFromJson({'success': true}), isNull);
      expect(simulationAccessFromJson({'success': true, 'open': 'yes'}), isNull);
    });
  });

  group('learnCompleteForScope', () {
    test('is false until every in-app content module has its Learn done', () async {
      SharedPreferences.setMockInitialValues({
        for (final m in inAppContentModules.take(7)) 'edu_module_3_${m.num}_learn': true,
      });
      final prefs = await SharedPreferences.getInstance();
      expect(learnCompleteForScope(prefs, '3'), isFalse);
    });

    test('is true once all eight in-app content modules are done for the team', () async {
      SharedPreferences.setMockInitialValues({
        for (final m in inAppContentModules) 'edu_module_3_${m.num}_learn': true,
      });
      final prefs = await SharedPreferences.getInstance();
      expect(inAppContentModules.length, 8);
      expect(learnCompleteForScope(prefs, '3'), isTrue);
      // Another team's progress does not count.
      expect(learnCompleteForScope(prefs, '4'), isFalse);
    });
  });
}
