import '../../core/network/api_client.dart';

// Endpoints used only here (kept local; not in ApiEndpoints).
//   GET  /shocks/forecasts[?round=N]          -> { success, forecasts: [...] }   (public)
//   GET  /hedges/team/{teamId}                -> { success, hedges: [...] }      (public)
//   GET  /hedges/quote?forecastId=&teamId=    -> { success, premium, alreadyInsured, ... }
//   POST /hedges/purchase { teamId, forecastId, playerName }  (team bearer; leader-only
//        when the team has a leader; premium is in-game currency charged as opex)
const String _forecastsPath = '/shocks/forecasts';
const String _teamHedgesPath = '/hedges/team';
const String _quotePath = '/hedges/quote';
const String _purchasePath = '/hedges/purchase';

/// A forward-looking market headline the facilitator published on the wire. Teams cannot
/// tell whether it hints at a real shock or is a red herring.
class ShockForecast {
  final String id;
  final String headline;
  final String? headlineAr;
  final int roundNum;

  /// 'low' | 'medium' | 'high' | null
  final String? severityHint;

  const ShockForecast({
    required this.id,
    required this.headline,
    this.headlineAr,
    required this.roundNum,
    this.severityHint,
  });

  factory ShockForecast.fromJson(Map<String, dynamic> j) => ShockForecast(
        id: j['id'].toString(),
        headline: j['headline']?.toString() ?? '',
        headlineAr: (j['headlineAr']?.toString().trim().isEmpty ?? true) ? null : j['headlineAr'].toString(),
        roundNum: (j['roundNum'] as num?)?.toInt() ?? 1,
        severityHint: j['severityHint']?.toString(),
      );

  String text(bool arabic) => arabic && headlineAr != null ? headlineAr! : headline;
}

class TeamHedge {
  final String id;
  final String shockId; // '' = a red-herring hedge
  final String? forecastId;
  final int roundNum;
  final double premium;

  /// 'active' | 'consumed' | 'expired'
  final String status;

  const TeamHedge({
    required this.id,
    required this.shockId,
    required this.forecastId,
    required this.roundNum,
    required this.premium,
    required this.status,
  });

  factory TeamHedge.fromJson(Map<String, dynamic> j) => TeamHedge(
        id: j['id'].toString(),
        shockId: j['shockId']?.toString() ?? '',
        forecastId: j['forecastId']?.toString(),
        roundNum: (j['roundNum'] as num?)?.toInt() ?? 1,
        premium: (j['premium'] is num)
            ? (j['premium'] as num).toDouble()
            : double.tryParse('${j['premium']}') ?? 0,
        status: j['status']?.toString() ?? 'active',
      );
}

class HedgeQuote {
  final double premium;
  final bool alreadyInsured;
  const HedgeQuote(this.premium, this.alreadyInsured);
}

/// Mirrors the server's HEDGE_PREMIUM_SCHEDULE (hedgeService.ts) for instant display; the
/// confirm dialog shows the server's authoritative quote before purchase.
double hedgePremiumFor(String? severityHint) {
  switch (severityHint) {
    case 'low':
      return 100000;
    case 'medium':
      return 250000;
    case 'high':
      return 500000;
  }
  return 250000;
}

class HedgeRepository {
  final ApiClient _api;
  HedgeRepository(this._api);

  /// Active (unresolved) forecasts, newest first. Null on failure (keep what is shown).
  Future<List<ShockForecast>?> fetchForecasts({int? round}) async {
    try {
      final res = await _api.get(_forecastsPath, params: {'round': ?round});
      final list = res['forecasts'];
      if (res['success'] != true || list is! List) return null;
      return [
        for (final f in list)
          if (f is Map && f['id'] != null) ShockForecast.fromJson(Map<String, dynamic>.from(f)),
      ];
    } catch (_) {
      return null;
    }
  }

  Future<List<TeamHedge>?> fetchTeamHedges(String teamId) async {
    try {
      final res = await _api.get('$_teamHedgesPath/${Uri.encodeComponent(teamId)}');
      final list = res['hedges'];
      if (res['success'] != true || list is! List) return null;
      return [
        for (final h in list)
          if (h is Map && h['id'] != null) TeamHedge.fromJson(Map<String, dynamic>.from(h)),
      ];
    } catch (_) {
      return null;
    }
  }

  Future<HedgeQuote?> quote(String forecastId, String teamId) async {
    try {
      final res = await _api.get(_quotePath, params: {'forecastId': forecastId, 'teamId': teamId});
      if (res['success'] != true) return null;
      final p = res['premium'];
      return HedgeQuote(p is num ? p.toDouble() : 0, res['alreadyInsured'] == true);
    } catch (_) {
      return null;
    }
  }

  /// Returns (premium paid, null) on success, or (null, server error message) on refusal.
  Future<(double?, String?)> purchase({
    required String teamId,
    required String forecastId,
    required String playerName,
  }) async {
    try {
      final res = await _api.post(_purchasePath, data: {
        'teamId': teamId,
        'forecastId': forecastId,
        'playerName': playerName,
      });
      if (res['success'] == true) {
        final hedge = res['hedge'];
        final p = hedge is Map ? hedge['premium'] : null;
        return (p is num ? p.toDouble() : double.tryParse('$p') ?? 0, null);
      }
      final err = res['error'] ?? res['message'];
      return (null, err is String && err.isNotEmpty ? err : 'Failed to purchase insurance');
    } catch (_) {
      return (null, 'Failed to purchase insurance');
    }
  }
}
