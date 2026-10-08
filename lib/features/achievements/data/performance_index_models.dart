// Models for GET /api/leaderboard/live after website d19723d ("Rank the leaderboard on the
// FinPlay Performance Index"): `score` is the 0–100 index (one decimal), each played team
// carries `index` (pillars → metrics, flags), `scoredRound` (latest COMPLETED round: highest
// round whose operating module is locked, else the current round) and `hasPlayed` (false →
// no confirmed decision yet: score 0, index null, scoredRound 0).
//
// Shapes: shared/performance-index.ts (PerformanceIndex / IndexPillar / IndexMetric).

double _d(dynamic v) {
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v) ?? 0;
  return 0;
}

int _i(dynamic v, [int fallback = 0]) {
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v) ?? fallback;
  return fallback;
}

/// Bilingual label `{en, ar}` — the index ships its own Arabic.
class Bi {
  final String en;
  final String ar;
  const Bi(this.en, this.ar);

  static Bi? fromJson(dynamic j) {
    if (j is! Map) return null;
    final en = j['en']?.toString() ?? '';
    return Bi(en, j['ar']?.toString() ?? en);
  }

  String of(bool arabic) => arabic && ar.isNotEmpty ? ar : en;
}

class IndexMetric {
  final String key;
  final Bi label;
  final double? value;
  final String display;
  final double points;
  final double max;
  final Bi? note;

  const IndexMetric({
    required this.key,
    required this.label,
    required this.display,
    required this.points,
    required this.max,
    this.value,
    this.note,
  });

  factory IndexMetric.fromJson(Map<String, dynamic> j) => IndexMetric(
        key: j['key']?.toString() ?? '',
        label: Bi.fromJson(j['label']) ?? const Bi('', ''),
        value: j['value'] == null ? null : _d(j['value']),
        display: j['display']?.toString() ?? '',
        points: _d(j['points']),
        max: _d(j['max']),
        note: Bi.fromJson(j['note']),
      );
}

class IndexPillar {
  /// 'profitability' | 'cash' | 'health' | 'efficiency' | 'growth'
  final String key;
  final Bi label;
  final double points;
  final double max;
  final List<IndexMetric> metrics;

  const IndexPillar({
    required this.key,
    required this.label,
    required this.points,
    required this.max,
    this.metrics = const [],
  });

  factory IndexPillar.fromJson(Map<String, dynamic> j) {
    final m = j['metrics'];
    return IndexPillar(
      key: j['key']?.toString() ?? '',
      label: Bi.fromJson(j['label']) ?? const Bi('', ''),
      points: _d(j['points']),
      max: _d(j['max']),
      metrics: m is List
          ? m.whereType<Map>().map((e) => IndexMetric.fromJson(Map<String, dynamic>.from(e))).toList()
          : const [],
    );
  }

  double get fraction => max > 0 ? (points / max).clamp(0, 1).toDouble() : 0;
}

class IndexFlags {
  final bool distress; // cash below zero → score capped at 40
  final bool idleCash;
  final bool negativeEquity;
  final bool goingConcern;
  const IndexFlags({this.distress = false, this.idleCash = false, this.negativeEquity = false, this.goingConcern = false});

  factory IndexFlags.fromJson(dynamic j) {
    if (j is! Map) return const IndexFlags();
    return IndexFlags(
      distress: j['distress'] == true,
      idleCash: j['idleCash'] == true,
      negativeEquity: j['negativeEquity'] == true,
      goingConcern: j['goingConcern'] == true,
    );
  }
}

class PerformanceIndex {
  final double score; // 0–100, one decimal
  final double uncapped;
  final List<IndexPillar> pillars;
  final IndexFlags flags;

  const PerformanceIndex({required this.score, required this.uncapped, this.pillars = const [], this.flags = const IndexFlags()});

  static PerformanceIndex? fromJson(dynamic j) {
    if (j is! Map) return null;
    final p = j['pillars'];
    return PerformanceIndex(
      score: _d(j['score']),
      uncapped: _d(j['uncapped']),
      pillars: p is List
          ? p.whereType<Map>().map((e) => IndexPillar.fromJson(Map<String, dynamic>.from(e))).toList()
          : const [],
      flags: IndexFlags.fromJson(j['flags']),
    );
  }
}

class IndexLeaderboardRow {
  final String teamId;
  final String teamName;
  final String displayName;
  final double score;
  final bool hasPlayed;
  final int rank;
  final int rankChange; // + = moved up (server-computed vs its previous snapshot)
  final int round; // the team's own current round
  final int scoredRound; // round the index scores (0 when not played)
  final double netIncome;
  final double revenue;
  final double roe; // percent
  final bool isCashRich;
  final PerformanceIndex? index;

  const IndexLeaderboardRow({
    required this.teamId,
    required this.teamName,
    required this.displayName,
    required this.score,
    required this.hasPlayed,
    required this.rank,
    this.rankChange = 0,
    this.round = 1,
    this.scoredRound = 0,
    this.netIncome = 0,
    this.revenue = 0,
    this.roe = 0,
    this.isCashRich = false,
    this.index,
  });

  factory IndexLeaderboardRow.fromJson(Map<String, dynamic> j, {int fallbackRank = 0}) {
    final metrics = j['metrics'] is Map ? Map<String, dynamic>.from(j['metrics'] as Map) : const <String, dynamic>{};
    final cash = j['cashFlow'] is Map ? Map<String, dynamic>.from(j['cashFlow'] as Map) : const <String, dynamic>{};
    final index = PerformanceIndex.fromJson(j['index']);
    final teamName = j['teamName']?.toString() ?? j['teamId']?.toString() ?? '';
    return IndexLeaderboardRow(
      teamId: j['teamId']?.toString() ?? '',
      teamName: teamName,
      displayName: (j['displayName']?.toString().isNotEmpty ?? false) ? j['displayName'].toString() : teamName,
      score: _d(j['score']),
      // Older servers didn't send hasPlayed; treat a row with an index as played.
      hasPlayed: j['hasPlayed'] is bool ? j['hasPlayed'] as bool : index != null,
      rank: _i(j['rank'], fallbackRank),
      rankChange: _i(j['rankChange']),
      round: _i(j['round'], 1),
      scoredRound: _i(j['scoredRound']),
      netIncome: _d(metrics['netIncome']),
      revenue: _d(metrics['revenue']),
      roe: _d(metrics['roe']),
      isCashRich: cash['isCashRich'] == true,
      index: index,
    );
  }
}

class IndexLeaderboard {
  final List<IndexLeaderboardRow> rows;
  final int round; // most advanced team's round
  final DateTime? lastUpdated;
  final int totalTeams;

  const IndexLeaderboard({this.rows = const [], this.round = 1, this.lastUpdated, this.totalTeams = 0});

  factory IndexLeaderboard.fromJson(Map<String, dynamic> j) {
    final raw = j['leaderboard'];
    final rows = <IndexLeaderboardRow>[];
    if (raw is List) {
      var i = 0;
      for (final e in raw.whereType<Map>()) {
        i++;
        rows.add(IndexLeaderboardRow.fromJson(Map<String, dynamic>.from(e), fallbackRank: i));
      }
    }
    rows.sort((a, b) => b.score.compareTo(a.score));
    return IndexLeaderboard(
      rows: rows,
      round: _i(j['round'], 1),
      lastUpdated: DateTime.tryParse(j['lastUpdated']?.toString() ?? ''),
      totalTeams: _i(j['totalTeams'], rows.length),
    );
  }
}

/// Index score as the website prints it: JS number → "63.5" or "64".
String formatIndexScore(double v) {
  final r = (v * 10).round() / 10;
  return r == r.roundToDouble() ? r.toInt().toString() : r.toStringAsFixed(1);
}

/// Points as the website prints them (raw JS numbers, at most one decimal here).
String formatPoints(double v) => formatIndexScore(v);
