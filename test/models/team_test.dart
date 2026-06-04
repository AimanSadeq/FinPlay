import 'package:flutter_test/flutter_test.dart';
import 'package:finplay/data/models/team.dart';

void main() {
  group('Team', () {
    group('fromJson', () {
      test('parses complete JSON correctly', () {
        final json = {
          'id': 'Team 1',
          'name': 'Riyadh (Team 1)',
          'initial': 'R',
          'currentRound': 2,
          'currentModule': 'investing',
          'totalScore': 1500.5,
          'isActive': true,
          'color': '#3B82F6',
          'createdAt': '2025-01-01T00:00:00.000Z',
        };

        final team = Team.fromJson(json);

        expect(team.id, 'Team 1');
        expect(team.name, 'Riyadh (Team 1)');
        expect(team.initial, 'R');
        expect(team.currentRound, 2);
        expect(team.currentModule, 'investing');
        expect(team.totalScore, 1500.5);
        expect(team.isActive, true);
        expect(team.color, '#3B82F6');
        expect(team.createdAt, isNotNull);
      });

      test('converts int id to string', () {
        final json = {
          'id': 3,
          'name': 'Team 3',
        };

        final team = Team.fromJson(json);
        expect(team.id, '3');
      });

      test('applies defaults for missing fields', () {
        final json = <String, dynamic>{};

        final team = Team.fromJson(json);

        expect(team.id, '');
        expect(team.name, '');
        expect(team.initial, '');
        expect(team.currentRound, 1);
        expect(team.totalScore, 0);
        expect(team.isActive, true);
        expect(team.color, isNull);
      });

      test('handles null totalScore', () {
        final json = {
          'id': 'Team 1',
          'name': 'Test',
          'totalScore': null,
        };

        final team = Team.fromJson(json);
        expect(team.totalScore, 0);
      });

      test('parses totalScore from int', () {
        final json = {
          'id': 'Team 1',
          'name': 'Test',
          'totalScore': 100,
        };

        final team = Team.fromJson(json);
        expect(team.totalScore, 100.0);
      });
    });

    group('teamNumber', () {
      test('extracts number from "Team 1"', () {
        const team = Team(id: 'Team 1', name: 'T1');
        expect(team.teamNumber, 1);
      });

      test('extracts number from "Team 7"', () {
        const team = Team(id: 'Team 7', name: 'T7');
        expect(team.teamNumber, 7);
      });

      test('extracts number from plain numeric id "3"', () {
        const team = Team(id: '3', name: 'T3');
        expect(team.teamNumber, 3);
      });

      test('returns 0 for non-numeric id', () {
        const team = Team(id: 'alpha', name: 'Alpha');
        expect(team.teamNumber, 0);
      });

      test('returns 0 for empty id', () {
        const team = Team(id: '', name: '');
        expect(team.teamNumber, 0);
      });

      test('extracts first number from complex id', () {
        const team = Team(id: 'Group 12 Beta', name: 'G12');
        expect(team.teamNumber, 12);
      });
    });

    group('copyWith', () {
      test('creates copy with updated fields', () {
        const original = Team(
          id: 'Team 1',
          name: 'Alpha',
          currentRound: 1,
          totalScore: 500,
        );

        final copy = original.copyWith(currentRound: 2, totalScore: 750);

        expect(copy.id, 'Team 1');
        expect(copy.name, 'Alpha');
        expect(copy.currentRound, 2);
        expect(copy.totalScore, 750);
      });

      test('preserves unchanged fields', () {
        const original = Team(
          id: 'Team 1',
          name: 'Alpha',
          color: '#FF0000',
          isActive: false,
        );

        final copy = original.copyWith(name: 'Beta');

        expect(copy.id, 'Team 1');
        expect(copy.name, 'Beta');
        expect(copy.color, '#FF0000');
        expect(copy.isActive, false);
      });
    });

    group('toJson', () {
      test('serializes all public fields', () {
        const team = Team(
          id: 'Team 1',
          name: 'Alpha',
          initial: 'A',
          currentRound: 2,
          currentModule: 'investing',
          totalScore: 800,
          isActive: true,
          color: '#3B82F6',
        );

        final json = team.toJson();

        expect(json['id'], 'Team 1');
        expect(json['name'], 'Alpha');
        expect(json['totalScore'], 800);
        expect(json['color'], '#3B82F6');
      });
    });
  });
}
