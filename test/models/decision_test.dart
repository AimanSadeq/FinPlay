import 'package:flutter_test/flutter_test.dart';
import 'package:finplay/data/models/decision.dart';

void main() {
  group('Decision', () {
    group('fromJson', () {
      test('parses complete decision', () {
        final json = {
          'id': 42,
          'teamId': 'Team 1',
          'roundNum': 2,
          'module': 'financing',
          'decisionData': {
            'debtFinancing': 50000,
            'equityFinancing': 30000,
          },
          'submittedAt': '2025-03-01T10:30:00.000Z',
          'isLocked': true,
        };

        final decision = Decision.fromJson(json);

        expect(decision.id, '42'); // id is normalized to String by the model
        expect(decision.teamId, 'Team 1');
        expect(decision.roundNum, 2);
        expect(decision.module, 'financing');
        expect(decision.decisionData['debtFinancing'], 50000);
        expect(decision.submittedAt, isNotNull);
        expect(decision.submittedAt!.year, 2025);
        expect(decision.isLocked, true);
      });

      test('converts int teamId to string', () {
        final json = {
          'teamId': 3,
          'roundNum': 1,
          'module': 'investing',
        };

        final decision = Decision.fromJson(json);
        expect(decision.teamId, '3');
      });

      test('handles null decisionData', () {
        final json = {
          'teamId': 'Team 1',
          'roundNum': 1,
          'module': 'financing',
          'decisionData': null,
        };

        final decision = Decision.fromJson(json);
        expect(decision.decisionData, isEmpty);
      });

      test('defaults isLocked to false', () {
        final json = {
          'teamId': 'Team 1',
          'roundNum': 1,
          'module': 'financing',
        };

        final decision = Decision.fromJson(json);
        expect(decision.isLocked, false);
      });

      test('handles null submittedAt', () {
        final json = {
          'teamId': 'Team 1',
          'roundNum': 1,
          'module': 'financing',
        };

        final decision = Decision.fromJson(json);
        expect(decision.submittedAt, isNull);
      });
    });

    group('toJson', () {
      test('serializes correctly', () {
        const decision = Decision(
          id: '1',
          teamId: 'Team 1',
          roundNum: 2,
          module: 'investing',
          decisionData: {'capex': 100000},
        );

        final json = decision.toJson();

        expect(json['teamId'], 'Team 1');
        expect(json['roundNum'], 2);
        expect(json['module'], 'investing');
        expect(json['decisionData']['capex'], 100000);
        // Should NOT include id or submittedAt
        expect(json.containsKey('id'), false);
        expect(json.containsKey('submittedAt'), false);
      });
    });
  });

  group('FinancingDecision', () {
    test('serializes with all fields', () {
      const d = FinancingDecision(
        debtFinancing: 50000,
        equityFinancing: 30000,
        shortTermLoan: 10000,
        longTermDebt: 20000,
        strategy: 'conservative',
      );

      final json = d.toJson();

      expect(json['debtFinancing'], 50000);
      expect(json['equityFinancing'], 30000);
      expect(json['shortTermLoan'], 10000);
      expect(json['longTermDebt'], 20000);
      expect(json['strategy'], 'conservative');
    });

    test('omits null strategy', () {
      const d = FinancingDecision(
        debtFinancing: 50000,
        equityFinancing: 30000,
      );

      final json = d.toJson();
      expect(json.containsKey('strategy'), false);
    });

    test('uses zero defaults', () {
      const d = FinancingDecision();

      final json = d.toJson();
      expect(json['debtFinancing'], 0);
      expect(json['equityFinancing'], 0);
      expect(json['shortTermLoan'], 0);
      expect(json['longTermDebt'], 0);
    });
  });

  group('InvestingDecision', () {
    test('serializes with all fields', () {
      const d = InvestingDecision(
        capex: 100000,
        equipment: 50000,
        rnd: 25000,
        strategy: 'growth',
        riskLevel: 'high',
      );

      final json = d.toJson();

      expect(json['capex'], 100000);
      expect(json['equipment'], 50000);
      expect(json['rnd'], 25000);
      expect(json['strategy'], 'growth');
      expect(json['riskLevel'], 'high');
    });

    test('omits null optional fields', () {
      const d = InvestingDecision(capex: 100000);

      final json = d.toJson();
      expect(json.containsKey('strategy'), false);
      expect(json.containsKey('riskLevel'), false);
    });
  });

  group('OperatingDecision', () {
    test('serializes with all fields', () {
      const d = OperatingDecision(
        productionVolume: 10000,
        marketingSpend: 5000,
        staffingLevel: 100,
        pricingStrategy: 'premium',
        operationalEfficiency: 0.85,
        qualityLevel: 'high',
      );

      final json = d.toJson();

      expect(json['productionVolume'], 10000);
      expect(json['marketingSpend'], 5000);
      expect(json['staffingLevel'], 100);
      expect(json['pricingStrategy'], 'premium');
      expect(json['operationalEfficiency'], 0.85);
      expect(json['qualityLevel'], 'high');
    });

    test('omits null optional fields', () {
      const d = OperatingDecision(productionVolume: 10000);

      final json = d.toJson();
      expect(json.containsKey('pricingStrategy'), false);
      expect(json.containsKey('qualityLevel'), false);
      expect(json['operationalEfficiency'], 0);
    });
  });
}
