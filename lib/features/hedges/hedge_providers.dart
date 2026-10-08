import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/repository_providers.dart';
import 'hedge_repository.dart';

final hedgeRepositoryProvider = Provider<HedgeRepository>((ref) {
  return HedgeRepository(ref.watch(apiClientProvider));
});

/// Live forecasts on the market wire, per team (so a team switch or sign-out never shows the
/// previous team's wire; disposed when the simulation goes). Filled by MarketWireSection's
/// poll: one fetch shared by the ticker and the Hedge Desk, as the website shares one key.
final marketForecastsProvider =
    StateProvider.autoDispose.family<List<ShockForecast>, String>((ref, teamId) => const []);

/// The team's hedges (null until first loaded), per team. Filled by MarketWireSection.
final teamHedgesProvider =
    StateProvider.autoDispose.family<List<TeamHedge>?, String>((ref, teamId) => null);

/// forecastId -> the team's non-expired hedge on it.
Map<String, TeamHedge> hedgesByForecast(List<TeamHedge>? hedges) {
  final out = <String, TeamHedge>{};
  for (final h in hedges ?? const <TeamHedge>[]) {
    final f = h.forecastId;
    if (f != null && h.status != 'expired') out[f] = h;
  }
  return out;
}

/// Hedges that flipped to 'consumed' since [known] (the payoff toast). [known] null = first
/// load, which must not replay history as fresh payoffs.
List<TeamHedge> newlyConsumed(Set<String>? known, List<TeamHedge> hedges) {
  if (known == null) return const [];
  return [
    for (final h in hedges)
      if (h.status == 'consumed' && !known.contains(h.id)) h,
  ];
}

/// 'interest-rate-hike' -> 'Interest Rate Hike' (for the payoff toast).
String prettyShockName(String shockId) {
  if (shockId.isEmpty) return 'Market shock';
  return shockId
      .split('-')
      .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
      .join(' ');
}

/// $250,000 style (website formatUSD).
String formatUsd(double n) {
  final v = n.round().abs().toString();
  final buf = StringBuffer();
  for (var i = 0; i < v.length; i++) {
    if (i > 0 && (v.length - i) % 3 == 0) buf.write(',');
    buf.write(v[i]);
  }
  return '${n < 0 ? '-' : ''}\$$buf';
}
