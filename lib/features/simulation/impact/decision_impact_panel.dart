import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/i18n/app_strings.dart';
import '../../../data/repositories/decision_repository.dart';
import '../../../providers/repository_providers.dart';
import 'decision_impact.dart';

/// Keep a provider's value for [d] after its last listener goes, like react-query's staleTime.
void _cacheFor(Ref ref, Duration d) {
  final link = ref.keepAlive();
  final timer = Timer(d, link.close);
  ref.onDispose(timer.cancel);
}

/// The model's rates for a round (GET /api/model/rates); the template values on any failure.
/// Cached five minutes, as the website's useModelRates.
final modelRatesProvider = FutureProvider.autoDispose.family<ModelRates, int>((ref, round) async {
  _cacheFor(ref, const Duration(minutes: 5));
  final raw = await ref.read(decisionRepositoryProvider).fetchModelRates(round < 1 ? 1 : round);
  return ModelRates.fromJson(raw);
});

/// Opening reserves / retained earnings for (teamId, round); only read by the two equity cards.
final openingBalancesProvider = FutureProvider.autoDispose
    .family<OpeningBalances?, ({String teamId, int round})>((ref, key) async {
  _cacheFor(ref, const Duration(seconds: 30));
  return ref.read(decisionRepositoryProvider).fetchOpeningBalances(key.teamId, key.round);
});

/// Live "what this amount does" under a decision card's amount: which accounts move on which
/// statement, and what the decision means. Rules only, from the model's own rates; nothing
/// typed here leaves the app. Port of the website's DecisionImpactPanel.
class DecisionImpactPanel extends ConsumerWidget {
  final String module;
  final int? engineRow;
  final double amount;
  final int round;

  /// Needed only for Use Reserves / Use Retained Earnings, to show what is available.
  final String? teamId;

  const DecisionImpactPanel({
    super.key,
    required this.module,
    required this.engineRow,
    required this.amount,
    required this.round,
    this.teamId,
  });

  static const _icons = {
    'balance': Icons.account_balance_outlined,
    'income': Icons.show_chart_rounded,
    'cashflow': Icons.waves_rounded,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final row = engineRow;
    if (row == null || row == 0 || !amount.isFinite || amount == 0) return const SizedBox.shrink();
    final s = ref.watch(stringsProvider);
    final lang = s.ar ? ImpactLang.ar : ImpactLang.en;
    final r = round < 1 ? 1 : round;
    final rates = ref.watch(modelRatesProvider(r)).valueOrNull ?? ModelRates.template;
    final equityCard = module == 'financing' && (row == 6 || row == 9);
    final team = teamId;
    final opening = equityCard && team != null && team.isNotEmpty
        ? ref.watch(openingBalancesProvider((teamId: team, round: r))).valueOrNull
        : null;

    final impact = describeImpact(module, row, amount, rates: rates, lang: lang);
    if (impact == null) return const SizedBox.shrink();

    String? availableText;
    var over = false;
    if (equityCard && opening != null && amount < 0) {
      final raw = row == 9 ? opening.reserves : opening.retainedEarnings;
      final available = raw < 0 ? 0.0 : raw;
      over = amount.abs() > available + 0.5;
      final what = row == 9
          ? (s.ar ? 'الاحتياطيات' : 'reserves')
          : (s.ar ? 'الأرباح المبقاة' : 'retained earnings');
      availableText = s.ar
          ? 'المتاح من $what في بداية الجولة $r: ${fmtSar(available, lang)}${over ? '؛ المبلغ يتجاوز المتاح ولن يُقبل عند التأكيد' : ''}'
          : '${what[0].toUpperCase()}${what.substring(1)} available at the start of round $r: ${fmtSar(available, lang)}${over ? '; this amount exceeds it and will be refused at confirm' : ''}';
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    const amber800 = Color(0xFF92400E);
    const amber700 = Color(0xFFB45309);
    final body = isDark ? const Color(0xFFE5E7EB) : const Color(0xFF374151);
    final strong = isDark ? Colors.white : const Color(0xFF111827);
    return Directionality(
      textDirection: s.ar ? TextDirection.rtl : TextDirection.ltr,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF78350F).withValues(alpha: 0.18) : const Color(0xFFFFFBEB),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark ? const Color(0xFFF59E0B).withValues(alpha: 0.3) : const Color(0xFFFEF3C7),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb_outline_rounded,
                    size: 14, color: isDark ? const Color(0xFFFBBF24) : amber800),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    impact.heading,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: isDark ? const Color(0xFFFBBF24) : amber800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            for (final l in impact.lines)
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Icon(_icons[l.statement], size: 12, color: amber700),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text.rich(
                        TextSpan(children: [
                          TextSpan(
                            text: '${statementName(l.statement, lang)}: ',
                            style: TextStyle(fontWeight: FontWeight.w600, color: strong),
                          ),
                          TextSpan(text: l.text),
                        ]),
                        style: TextStyle(fontSize: 11, height: 1.35, color: body),
                      ),
                    ),
                  ],
                ),
              ),
            if (impact.meaning.isNotEmpty) ...[
              Divider(
                height: 8,
                thickness: 1,
                color: isDark ? Colors.white12 : const Color(0xFFFEF3C7),
              ),
              Text(
                impact.meaning,
                style: TextStyle(
                  fontSize: 11,
                  height: 1.35,
                  fontStyle: FontStyle.italic,
                  color: isDark ? const Color(0xFFD1D5DB) : const Color(0xFF4B5563),
                ),
              ),
            ],
            if (availableText != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  availableText,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: over ? const Color(0xFFB91C1C) : (isDark ? const Color(0xFFFBBF24) : amber800),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
