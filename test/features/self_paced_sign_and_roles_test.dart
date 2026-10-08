import 'package:finplay/app/i18n/app_strings.dart';
import 'package:finplay/features/roles/role_picker.dart';
import 'package:finplay/features/roles/team_roles.dart';
import 'package:finplay/features/simulation/impact/engine_row_map.dart';
import 'package:finplay/features/simulation/sign_policy.dart';
import 'package:finplay/features/simulation/widgets/self_paced_scenario_panel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('self-paced amount sign (website parity)', () {
    test('default directions mirror shared/scenario-defaults.ts', () {
      expect(defaultDirection('investing', '1', 'Buy machinery'), AmountDirection.both);
      expect(defaultDirection('investing', '2', 'New factory'), AmountDirection.negative);
      expect(defaultDirection('operating', '5', 'Quality'), AmountDirection.negative);
      expect(defaultDirection('operating', '9', 'Buy Inventory'), AmountDirection.negative);
      expect(defaultDirection('operating', '1', 'Marketing'), AmountDirection.both);
      expect(defaultDirection('financing', '5', 'IPO'), AmountDirection.both);
      expect(defaultDirection('financing', '7', 'Rights issue'), AmountDirection.positive);
      expect(defaultDirection('financing', '8', 'Dividends'), AmountDirection.negative);
      expect(directionFor('investing', '2', null, 'both'), AmountDirection.both);
    });

    test('a spend card refuses a positive amount and accepts a negative one', () {
      const s = AppStrings(false);
      expect(validateAmountDirection(s, AmountDirection.negative, 250000), isNotNull);
      expect(validateAmountDirection(s, AmountDirection.negative, -250000), isNull);
      expect(validateAmountDirection(s, AmountDirection.positive, -1), isNotNull);
      expect(validateAmountDirection(s, AmountDirection.both, -1), isNull);
    });

    test('confirm payload carries the signed amounts as entered', () {
      final scenarios = <Map<String, dynamic>>[
        {'scenarioId': '2', 'amount': 0},
        {'scenarioId': '3', 'amount': 0},
      ];
      final payload = selfPacedConfirmPayload(['2', '3'], {'2': -1500000}, scenarios);
      expect(payload, [
        {'scenarioId': '2', 'amount': -1500000},
        {'scenarioId': '3', 'amount': 0},
      ]);
    });
  });

  group('role picker', () {
    const roles = [
      TeamRoleAssignment('Sara', 'cfo'),
      TeamRoleAssignment('Ali', 'risk_officer'),
      TeamRoleAssignment('Omar', 'analyst'),
    ];

    test('unique roles show their holder; analyst and my own role stay free', () {
      expect(roleTakenBy('cfo', roles, 'Ali'), 'Sara');
      expect(roleTakenBy('risk_officer', roles, 'ali'), isNull);
      expect(roleTakenBy('treasurer', roles, 'Ali'), isNull);
      expect(roleTakenBy('analyst', roles, 'Ali'), isNull);
    });

    test('offers the four roles in the website order', () {
      expect(kRoleOptions.map((o) => o.$1), ['cfo', 'treasurer', 'risk_officer', 'analyst']);
      expect(kRoleOptions.every((o) => kTeamRoles.containsKey(o.$1)), isTrue);
    });
  });

  test('self-paced engine rows follow scenario-row-map.ts', () {
    expect(engineRowFor('financing', 1, 3, 9), 3); // live 9-card catalog: positional
    expect(engineRowFor('financing', 1, 2, 3), 5); // dev catalog: Equity Investment -> IPO
    expect(engineRowFor('operating', 2, 1, 3), 9); // Supply Chain -> inventory
    expect(engineRowFor('investing', 1, 7, 3), 7); // unmapped -> catalog id
  });
}
