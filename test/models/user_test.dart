import 'package:flutter_test/flutter_test.dart';
import 'package:finplay/data/models/user.dart';

void main() {
  group('SelfPacedUser', () {
    group('fromJson', () {
      test('parses complete JSON correctly', () {
        final json = {
          'id': 42,
          'email': 'test@example.com',
          'displayName': 'John Doe',
          'teamName': 'Alpha',
          'role': 'admin',
          'currentRound': 3,
          'currentModule': 'investing',
          'isActive': true,
          'createdAt': '2025-01-15T10:30:00.000Z',
          'lastLoginAt': '2025-03-01T08:00:00.000Z',
        };

        final user = SelfPacedUser.fromJson(json);

        expect(user.id, '42'); // id is normalized to String by the model
        expect(user.email, 'test@example.com');
        expect(user.displayName, 'John Doe');
        expect(user.teamName, 'Alpha');
        expect(user.role, 'admin');
        expect(user.currentRound, 3);
        expect(user.currentModule, 'investing');
        expect(user.isActive, true);
        expect(user.createdAt, isNotNull);
        expect(user.createdAt!.year, 2025);
        expect(user.lastLoginAt, isNotNull);
      });

      test('applies defaults for missing optional fields', () {
        final json = {
          'email': 'min@test.com',
          'displayName': 'Min User',
        };

        final user = SelfPacedUser.fromJson(json);

        expect(user.id, isNull);
        expect(user.email, 'min@test.com');
        expect(user.displayName, 'Min User');
        expect(user.teamName, isNull);
        expect(user.role, 'participant');
        expect(user.currentRound, 1);
        expect(user.currentModule, 'financing');
        expect(user.isActive, true);
        expect(user.createdAt, isNull);
        expect(user.lastLoginAt, isNull);
      });

      test('handles null role gracefully', () {
        final json = {
          'email': 'a@b.com',
          'displayName': 'Test',
          'role': null,
        };

        final user = SelfPacedUser.fromJson(json);
        expect(user.role, 'participant');
      });

      test('handles null currentRound gracefully', () {
        final json = {
          'email': 'a@b.com',
          'displayName': 'Test',
          'currentRound': null,
        };

        final user = SelfPacedUser.fromJson(json);
        expect(user.currentRound, 1);
      });
    });

    group('toJson', () {
      test('serializes only public fields', () {
        const user = SelfPacedUser(
          id: '10',
          email: 'test@example.com',
          displayName: 'John',
          teamName: 'Bravo',
          role: 'participant',
          currentRound: 2,
          currentModule: 'operating',
        );

        final json = user.toJson();

        expect(json['email'], 'test@example.com');
        expect(json['displayName'], 'John');
        expect(json['teamName'], 'Bravo');
        expect(json['role'], 'participant');
        // Should NOT contain system fields
        expect(json.containsKey('id'), false);
        expect(json.containsKey('currentRound'), false);
        expect(json.containsKey('currentModule'), false);
        expect(json.containsKey('createdAt'), false);
        expect(json.containsKey('lastLoginAt'), false);
      });
    });

    group('constructor defaults', () {
      test('uses correct defaults', () {
        const user = SelfPacedUser(
          email: 'a@b.com',
          displayName: 'Test',
        );

        expect(user.role, 'participant');
        expect(user.currentRound, 1);
        expect(user.currentModule, 'financing');
        expect(user.isActive, true);
      });
    });
  });
}
