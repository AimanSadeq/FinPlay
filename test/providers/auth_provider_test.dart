import 'package:flutter_test/flutter_test.dart';
import 'package:finplay/providers/auth_provider.dart';
import 'package:finplay/data/models/user.dart';

void main() {
  group('AuthState', () {
    test('initial state has correct defaults', () {
      const state = AuthState();
      expect(state.status, AuthStatus.initial);
      expect(state.user, isNull);
      expect(state.token, isNull);
      expect(state.error, isNull);
      expect(state.isFacilitator, false);
    });

    test('copyWith preserves unmodified fields', () {
      const state = AuthState(
        status: AuthStatus.authenticated,
        isFacilitator: true,
      );
      final updated = state.copyWith(token: 'abc123');
      expect(updated.status, AuthStatus.authenticated);
      expect(updated.isFacilitator, true);
      expect(updated.token, 'abc123');
    });

    test('copyWith can set all fields', () {
      const state = AuthState();
      final user = SelfPacedUser(
        email: 'test@test.com',
        displayName: 'Test User',
      );
      final updated = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        token: 'token123',
        error: null,
        isFacilitator: false,
      );
      expect(updated.status, AuthStatus.authenticated);
      expect(updated.user?.email, 'test@test.com');
      expect(updated.user?.displayName, 'Test User');
      expect(updated.token, 'token123');
      expect(updated.isFacilitator, false);
    });
  });

  group('AuthStatus', () {
    test('all status values exist', () {
      expect(AuthStatus.values.length, 4);
      expect(AuthStatus.values, contains(AuthStatus.initial));
      expect(AuthStatus.values, contains(AuthStatus.authenticated));
      expect(AuthStatus.values, contains(AuthStatus.unauthenticated));
      expect(AuthStatus.values, contains(AuthStatus.loading));
    });
  });

  group('AuthState self-paced detection', () {
    test('self-paced user is detected correctly', () {
      final state = AuthState(
        status: AuthStatus.authenticated,
        user: SelfPacedUser(
          email: 'user@test.com',
          displayName: 'SP User',
        ),
        isFacilitator: false,
      );
      // The simulation screen uses: user != null && !isFacilitator && team == null
      final isSelfPaced = state.user != null && !state.isFacilitator;
      expect(isSelfPaced, true);
    });

    test('facilitator is not detected as self-paced', () {
      final state = AuthState(
        status: AuthStatus.authenticated,
        user: SelfPacedUser(
          email: 'admin@test.com',
          displayName: 'Admin',
        ),
        isFacilitator: true,
      );
      final isSelfPaced = state.user != null && !state.isFacilitator;
      expect(isSelfPaced, false);
    });

    test('unauthenticated user is not self-paced', () {
      const state = AuthState(
        status: AuthStatus.unauthenticated,
      );
      final isSelfPaced = state.user != null && !state.isFacilitator;
      expect(isSelfPaced, false);
    });
  });

  group('SelfPacedUser for auth', () {
    test('fromJson success with full data', () {
      final user = SelfPacedUser.fromJson({
        'id': 'u1',
        'email': 'test@example.com',
        'displayName': 'Test Player',
        'teamName': 'My Team',
        'role': 'participant',
        'currentRound': 2,
        'currentModule': 'investing',
        'isActive': true,
      });
      expect(user.id, 'u1');
      expect(user.email, 'test@example.com');
      expect(user.displayName, 'Test Player');
      expect(user.teamName, 'My Team');
      expect(user.role, 'participant');
      expect(user.currentRound, 2);
      expect(user.currentModule, 'investing');
      expect(user.isActive, true);
    });

    test('fromJson handles missing optional fields', () {
      final user = SelfPacedUser.fromJson({
        'email': 'min@test.com',
        'displayName': 'Min',
      });
      expect(user.id, isNull);
      expect(user.teamName, isNull);
      expect(user.role, 'participant');
      expect(user.currentRound, 1);
      expect(user.currentModule, 'financing');
      expect(user.isActive, true);
      expect(user.createdAt, isNull);
      expect(user.lastLoginAt, isNull);
    });

    test('toJson includes basic fields', () {
      const user = SelfPacedUser(
        email: 'test@test.com',
        displayName: 'Test',
        teamName: 'Team A',
      );
      final json = user.toJson();
      expect(json['email'], 'test@test.com');
      expect(json['displayName'], 'Test');
      expect(json['teamName'], 'Team A');
      expect(json['role'], 'participant');
    });

    test('fromJson parses dates correctly', () {
      final user = SelfPacedUser.fromJson({
        'email': 'date@test.com',
        'displayName': 'Date Test',
        'createdAt': '2026-01-15T10:30:00Z',
        'lastLoginAt': '2026-03-12T08:00:00Z',
      });
      expect(user.createdAt, isNotNull);
      expect(user.createdAt!.year, 2026);
      expect(user.lastLoginAt, isNotNull);
    });
  });
}
