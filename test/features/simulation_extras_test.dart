import 'package:finplay/app/i18n/app_strings.dart';
import 'package:finplay/core/network/api_client.dart';
import 'package:finplay/data/repositories/decision_repository.dart';
import 'package:finplay/features/hedges/hedge_providers.dart';
import 'package:finplay/features/hedges/hedge_repository.dart';
import 'package:finplay/features/simulation/impact/decision_impact.dart';
import 'package:finplay/features/simulation/impact/decision_impact_panel.dart';
import 'package:finplay/features/simulation/recommendations/member_recommendations.dart';
import 'package:finplay/features/simulation/widgets/pro_forma_preview.dart';
import 'package:finplay/providers/repository_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeDecisionRepository extends DecisionRepository {
  _FakeDecisionRepository() : super(ApiClient());
  final calls = <Map<String, double>>[];
  bool fail = false;

  @override
  Future<PreviewResult?> previewImpact({
    String? teamId,
    required String module,
    required int roundNum,
    required Map<String, double> pending,
    bool selfPaced = false,
  }) async {
    calls.add(pending);
    if (fail) return null;
    return PreviewResult.tryParse({
      'success': true,
      'roundNum': roundNum,
      'current': {'netIncome': 1000000, 'cash': 5000000, 'debtToEquity': 0.5},
      'projected': {'netIncome': 1250000, 'cash': 4000000, 'debtToEquity': 0.5},
      'deltas': {'netIncome': 250000, 'cash': -1000000, 'debtToEquity': 0},
    });
  }

  @override
  Future<Map<String, dynamic>?> fetchModelRates(int round) async => null;
}

void main() {
  group('pro-forma preview', () {
    test('parses only a well-formed success body', () {
      expect(PreviewResult.tryParse({'success': false}), isNull);
      expect(PreviewResult.tryParse({'success': true, 'current': {}}), isNull);
      final r = PreviewResult.tryParse({
        'success': true,
        'roundNum': 2,
        'current': {'netIncome': 1, 'cash': 2, 'totalAssets': 3, 'totalEquity': 4, 'debtToEquity': 0.5},
        'projected': {'netIncome': '10', 'cash': 20, 'totalAssets': 30, 'totalEquity': 40, 'debtToEquity': 1.25},
        'deltas': {'netIncome': 9, 'cash': 18, 'totalAssets': 27, 'totalEquity': 36, 'debtToEquity': 0.75},
      })!;
      expect(r.roundNum, 2);
      expect(r.projected['netIncome'], 10);
      expect(r.deltas['debtToEquity'], 0.75);
    });

    test('money format matches the website', () {
      expect(formatPreviewMoney(1234567890), r'$1.23B');
      expect(formatPreviewMoney(-4500000), r'-$4.5M');
      expect(formatPreviewMoney(12000), r'$12K');
      expect(formatPreviewMoney(950), r'$950');
    });

    test('pending key is order-independent', () {
      expect(ProFormaPreview.pendingKey({'2': -5, '1': 10}),
          ProFormaPreview.pendingKey({'1': 10, '2': -5}));
    });

    testWidgets('debounces, then shows the ticker; hides on failure', (tester) async {
      final repo = _FakeDecisionRepository();
      Widget app(Map<String, double> pending) => ProviderScope(
            overrides: [decisionRepositoryProvider.overrideWithValue(repo)],
            child: MaterialApp(
              home: Scaffold(
                body: ProFormaPreview(teamId: 'Team 1', module: 'financing', roundNum: 1, pending: pending),
              ),
            ),
          );
      await tester.pumpWidget(app({'1': 100}));
      await tester.pumpWidget(app({'1': 200}));
      await tester.pump(const Duration(milliseconds: 600));
      expect(repo.calls, hasLength(1)); // the first edit was superseded inside the debounce
      expect(repo.calls.single['1'], 200);
      await tester.pump();
      expect(find.text('LIVE'), findsOneWidget);
      expect(find.textContaining(r'$1.3M'), findsWidgets);

      repo.fail = true;
      await tester.pumpWidget(app({'1': 300}));
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump();
      expect(find.text('LIVE'), findsNothing);
    });
  });

  group('decision impact panel', () {
    testWidgets('explains a loan in English and hides at zero', (tester) async {
      Widget app(double amount) => ProviderScope(
            overrides: [decisionRepositoryProvider.overrideWithValue(_FakeDecisionRepository())],
            child: MaterialApp(
              home: Scaffold(
                body: DecisionImpactPanel(module: 'financing', engineRow: 1, amount: amount, round: 1),
              ),
            ),
          );
      await tester.pumpWidget(app(1000000));
      await tester.pump();
      expect(find.text('What this amount does'), findsOneWidget);
      expect(find.textContaining('tax shield SAR 14,000', findRichText: true), findsOneWidget);
      await tester.pumpWidget(app(0));
      expect(find.text('What this amount does'), findsNothing);
    });

    testWidgets('Arabic', (tester) async {
      await tester.pumpWidget(ProviderScope(
        overrides: [
          decisionRepositoryProvider.overrideWithValue(_FakeDecisionRepository()),
          stringsProvider.overrideWithValue(const AppStrings(true)),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: DecisionImpactPanel(module: 'operating', engineRow: 9, amount: -100000, round: 1),
          ),
        ),
      ));
      await tester.pump();
      expect(find.text('ماذا يفعل هذا المبلغ'), findsOneWidget);
      expect(describeImpact('operating', 9, -100000, lang: ImpactLang.ar)!.lines.first.text,
          contains('30٪'));
    });
  });

  group('hedge desk helpers', () {
    test('premium schedule mirrors the server', () {
      expect(hedgePremiumFor('low'), 100000);
      expect(hedgePremiumFor('medium'), 250000);
      expect(hedgePremiumFor('high'), 500000);
      expect(hedgePremiumFor(null), 250000);
      expect(formatUsd(250000), r'$250,000');
    });

    TeamHedge h(String id, String status, {String? forecast}) => TeamHedge(
        id: id, shockId: 'interest-rate-hike', forecastId: forecast, roundNum: 1, premium: 1, status: status);

    test('expired hedges do not mark a headline insured', () {
      final map = hedgesByForecast([h('a', 'active', forecast: 'f1'), h('b', 'expired', forecast: 'f2')]);
      expect(map.keys, ['f1']);
    });

    test('payoff toast only for hedges that flip to consumed after the first load', () {
      expect(newlyConsumed(null, [h('a', 'consumed')]), isEmpty);
      expect(newlyConsumed({'a'}, [h('a', 'consumed'), h('b', 'consumed')]).map((x) => x.id), ['b']);
      expect(prettyShockName('interest-rate-hike'), 'Interest Rate Hike');
    });

    test('forecast falls back to English when no Arabic headline', () {
      final f = ShockForecast.fromJson({'id': 'x', 'headline': 'Rates up?', 'headlineAr': '', 'roundNum': 2});
      expect(f.text(true), 'Rates up?');
    });
  });

  group('member recommendations', () {
    test('a member sees only the count before committing', () {
      final r = RecScenario.fromJson({'scenarioId': 3, 'count': 2, 'submittedByMe': false, 'mine': null});
      expect(r.scenarioId, '3');
      expect(r.mineAmount, isNull);
      expect(r.summary, isNull);
      expect(r.members, isNull);
    });

    test('leader synthesis parses summary and members', () {
      final r = RecScenario.fromJson({
        'scenarioId': '1',
        'count': 2,
        'submittedByMe': true,
        'mine': {'amount': -250000, 'rationale': 'cheap debt', 'playerRole': 'cfo'},
        'summary': {'n': 2, 'median': -200000, 'min': -250000, 'max': -150000},
        'members': [
          {'playerName': 'Ali', 'playerRole': 'cfo', 'amount': -250000, 'rationale': null},
          {'playerName': 'Sara', 'playerRole': null, 'amount': -150000, 'rationale': 'safer'},
        ],
      });
      expect(r.mineAmount, -250000);
      expect(r.summary!.median, -200000);
      expect(r.members!.map((m) => m.playerName), ['Ali', 'Sara']);
      expect(r.members!.last.rationale, 'safer');
    });
  });
}
