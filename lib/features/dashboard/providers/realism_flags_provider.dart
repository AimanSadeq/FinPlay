import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart' show httpStatusKey;
import '../../../providers/repository_providers.dart';

// GET /api/realism/status (same path as ApiEndpoints.realismStatus). Unauthenticated; the
// facilitator's per-cohort switches for the finance-realism analytics modules.
const _realismStatusPath = '/realism/status';

/// The facilitator's analytics switches, as the website's use-realism-flag.ts reads them.
/// A self-paced learner has no facilitator, so every module is on for them (the web's
/// ALL_ON); a corporate team sees only what the facilitator enabled (missing = off).
class RealismFlags {
  final Map<String, bool> flags;
  final double maxDebtToEbitda;
  final double minInterestCoverage;

  const RealismFlags({
    this.flags = const {},
    this.maxDebtToEbitda = 4.0,
    this.minInterestCoverage = 2.0,
  });

  static const allOn = RealismFlags(flags: {
    'workingCapitalEnabled': true,
    'duPontEnabled': true,
    'waccEnabled': true,
    'creditRatingEnabled': true,
    'debtCovenantsEnabled': true,
    'capTableEnabled': true,
    'dividendPolicyEnabled': true,
    'ratiosLiquidityEnabled': true,
    'ratiosEfficiencyEnabled': true,
    'ratiosProfitabilityEnabled': true,
    'ratiosSolvencyEnabled': true,
    'ratiosMarketEnabled': true,
  });

  bool isOn(String flag) => flags[flag] == true;

  /// Any of the five ratio categories is on (the dashboard's "Ratios" card).
  bool get anyRatios => const [
        'ratiosLiquidityEnabled',
        'ratiosEfficiencyEnabled',
        'ratiosProfitabilityEnabled',
        'ratiosSolvencyEnabled',
        'ratiosMarketEnabled',
      ].any(isOn);

  /// First enabled ratio category route, liquidity first (the web's nav-card order).
  String? get firstRatiosRoute {
    const order = ['liquidity', 'efficiency', 'profitability', 'solvency', 'market'];
    for (final c in order) {
      if (isOn('ratios${c[0].toUpperCase()}${c.substring(1)}Enabled')) return '/ratios/$c';
    }
    return null;
  }

  factory RealismFlags.fromJson(Map<String, dynamic> json) {
    final flags = <String, bool>{
      for (final e in json.entries)
        if (e.value is bool) e.key: e.value as bool,
    };
    final t = json['covenantThresholds'];
    double num_(Object? v, double d) => v is num ? v.toDouble() : d;
    return RealismFlags(
      flags: flags,
      maxDebtToEbitda: t is Map ? num_(t['maxDebtToEbitda'], 4.0) : 4.0,
      minInterestCoverage: t is Map ? num_(t['minInterestCoverage'], 2.0) : 2.0,
    );
  }
}

/// Corporate flags from the server. Failures read as "all off", like the web's EMPTY.
final corporateRealismFlagsProvider = FutureProvider.autoDispose<RealismFlags>((ref) async {
  try {
    final res = await ref.watch(apiClientProvider).get(_realismStatusPath);
    if (res[httpStatusKey] != null) return const RealismFlags();
    return RealismFlags.fromJson(res);
  } catch (_) {
    return const RealismFlags();
  }
});
