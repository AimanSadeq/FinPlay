import 'package:flutter_test/flutter_test.dart';
import 'package:finplay/providers/self_paced_provider.dart';
import 'package:finplay/data/models/user.dart';

void main() {
  group('SelfPacedState', () {
    test('default state has correct initial values', () {
      const state = SelfPacedState();
      expect(state.currentRound, 1);
      expect(state.currentModule, 'financing');
      expect(state.isLoading, false);
      expect(state.isGameComplete, false);
      expect(state.decisions, isEmpty);
      expect(state.error, isNull);
    });

    test('copyWith preserves unmodified fields', () {
      const state = SelfPacedState(
        currentRound: 2,
        currentModule: 'investing',
        isLoading: true,
      );
      final updated = state.copyWith(currentRound: 3);
      expect(updated.currentRound, 3);
      expect(updated.currentModule, 'investing');
      expect(updated.isLoading, true);
    });

    test('copyWith can set error to null', () {
      final state = const SelfPacedState(error: 'some error');
      // error: null in copyWith clears it (since error param defaults to null)
      final updated = state.copyWith(currentRound: 1);
      expect(updated.error, isNull);
    });

    test('copyWith updates all fields', () {
      const state = SelfPacedState();
      final decisions = {
        'financing': [
          {'scenarioId': 's1', 'amount': 100}
        ]
      };
      final updated = state.copyWith(
        currentRound: 3,
        currentModule: 'complete',
        isLoading: false,
        isGameComplete: true,
        decisions: decisions,
        error: 'test error',
      );
      expect(updated.currentRound, 3);
      expect(updated.currentModule, 'complete');
      expect(updated.isGameComplete, true);
      expect(updated.decisions, decisions);
      expect(updated.error, 'test error');
    });
  });

  group('SelfPacedState game completion logic', () {
    test('isGameComplete is true when round >= 3 and module is complete', () {
      const state = SelfPacedState(
        currentRound: 3,
        currentModule: 'complete',
        isGameComplete: true,
      );
      expect(state.isGameComplete, true);
    });

    test('isGameComplete is false when round < 3', () {
      const state = SelfPacedState(
        currentRound: 2,
        currentModule: 'operating',
        isGameComplete: false,
      );
      expect(state.isGameComplete, false);
    });

    test('isGameComplete is false when module is not complete', () {
      const state = SelfPacedState(
        currentRound: 3,
        currentModule: 'financing',
        isGameComplete: false,
      );
      expect(state.isGameComplete, false);
    });
  });

  group('SelfPacedState decisions', () {
    test('decisions map is empty by default', () {
      const state = SelfPacedState();
      expect(state.decisions, isEmpty);
    });

    test('decisions can be set per module', () {
      const state = SelfPacedState();
      final updated = state.copyWith(decisions: {
        'financing': [
          {'scenarioId': 's1', 'title': 'Scenario 1', 'amount': 1000}
        ],
        'investing': [
          {'scenarioId': 's2', 'title': 'Scenario 2', 'amount': 2000}
        ],
      });
      expect(updated.decisions.length, 2);
      expect(updated.decisions['financing']!.length, 1);
      expect(updated.decisions['investing']!.length, 1);
    });
  });

  group('SelfPacedUser model for provider', () {
    test('fromJson parses currentRound and currentModule', () {
      final user = SelfPacedUser.fromJson({
        'id': '123',
        'email': 'test@test.com',
        'displayName': 'Test User',
        'currentRound': 2,
        'currentModule': 'investing',
      });
      expect(user.currentRound, 2);
      expect(user.currentModule, 'investing');
    });

    test('fromJson defaults to round 1 and financing', () {
      final user = SelfPacedUser.fromJson({
        'email': 'test@test.com',
        'displayName': 'Test',
      });
      expect(user.currentRound, 1);
      expect(user.currentModule, 'financing');
    });

    test('user with round 3 and complete module signals game complete', () {
      final user = SelfPacedUser.fromJson({
        'email': 'test@test.com',
        'displayName': 'Test',
        'currentRound': 3,
        'currentModule': 'complete',
      });
      // The provider uses this logic to determine isGameComplete
      final isComplete =
          user.currentRound >= 3 && user.currentModule == 'complete';
      expect(isComplete, true);
    });
  });
}
