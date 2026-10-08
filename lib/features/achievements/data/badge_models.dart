// Models for /api/badges/* (website server/routes/badges.ts + services/badgeService.ts).

double _toDouble(dynamic v) {
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v) ?? 0;
  return 0;
}

int? _toIntOrNull(dynamic v) {
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v);
  return null;
}

/// Arabic badge descriptions.
///
/// NOT FROM THE WEBSITE: the server catalog carries `nameAr` but no Arabic description,
/// and the website renders the English description in every language. These are the
/// app's own translations, keyed by badge id; if the server ever adds `descriptionAr`,
/// [CatalogBadge.fromJson] prefers it.
const Map<String, String> kBadgeDescriptionsAr = {
  'liquidity-guardian':
      'حافظ على نسبة التداول عند 1.5 أو أعلى — الأصول المتداولة تغطي الالتزامات المتداولة بارتياح.',
  'leverage-tamer':
      'أبقى نسبة الدين إلى حقوق الملكية عند 1.0 أو أقل — الشركة ممولة من الملاك أكثر من المقرضين.',
  'profit-pioneer': 'أنهى الجولة بصافي دخل موجب — الإيرادات تجاوزت جميع المصروفات.',
  'balanced-books':
      'اجتاز فحص الميزانية العمومية — إجمالي الأصول يساوي إجمالي الالتزامات وحقوق الملكية حتى آخر سنت.',
  'growth-investor':
      'أكّد قرارًا استثماريًا — التزم برأس مال متوقعًا عوائد مستقبلية (النفقات الرأسمالية).',
  'cost-surgeon':
      'أكّد قرارًا تشغيليًا يوفّر النقد — خفض التكاليف يرفع هامش التشغيل.',
  'capital-raiser':
      'أكّد قرار تمويل يجلب النقد — جمع رأس المال يموّل الأعمال.',
  'comeback-kid': 'حسّن صافي الدخل مقارنة بالجولة السابقة — خط الاتجاه يتجه صعودًا.',
  'steady-hand':
      'أكّد قرارات في كل وحدات الجولة — التمويل والاستثمار والتشغيل.',
};

/// One entry of GET /api/badges/catalog → data.badges[].
class CatalogBadge {
  final String id;
  final String name;
  final String nameAr;
  final String description;
  final String? descriptionAr;
  final String icon; // emoji

  const CatalogBadge({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.description,
    required this.icon,
    this.descriptionAr,
  });

  factory CatalogBadge.fromJson(Map<String, dynamic> j) {
    final id = j['id']?.toString() ?? '';
    final serverAr = j['descriptionAr']?.toString();
    return CatalogBadge(
      id: id,
      name: j['name']?.toString() ?? id,
      nameAr: j['nameAr']?.toString() ?? '',
      description: j['description']?.toString() ?? '',
      descriptionAr: (serverAr != null && serverAr.isNotEmpty) ? serverAr : kBadgeDescriptionsAr[id],
      icon: j['icon']?.toString() ?? '🏅',
    );
  }

  String localizedName(bool ar) => ar && nameAr.isNotEmpty ? nameAr : name;
  String localizedDescription(bool ar) =>
      ar && (descriptionAr?.isNotEmpty ?? false) ? descriptionAr! : description;
}

/// One row of GET /api/badges/team/:teamId or /api/badges/self-paced/mine → data.badges[].
/// Catalog metadata joined with the earned row (roundNum, earnedAt, metadata).
class EarnedBadge extends CatalogBadge {
  final int? roundNum;
  final DateTime? earnedAt;

  const EarnedBadge({
    required super.id,
    required super.name,
    required super.nameAr,
    required super.description,
    required super.icon,
    super.descriptionAr,
    this.roundNum,
    this.earnedAt,
  });

  factory EarnedBadge.fromJson(Map<String, dynamic> j) {
    final c = CatalogBadge.fromJson(j);
    return EarnedBadge(
      id: c.id,
      name: c.name,
      nameAr: c.nameAr,
      description: c.description,
      descriptionAr: c.descriptionAr,
      icon: c.icon,
      roundNum: _toIntOrNull(j['roundNum']),
      earnedAt: DateTime.tryParse(j['earnedAt']?.toString() ?? ''),
    );
  }
}

/// A badge can be earned in several rounds; show it once, with its earliest round
/// (website BadgeShelf de-duplication rule).
List<EarnedBadge> uniqueEarliest(List<EarnedBadge> badges) {
  final sorted = [...badges]..sort((a, b) => (a.roundNum ?? 0).compareTo(b.roundNum ?? 0));
  final seen = <String>{};
  final out = <EarnedBadge>[];
  for (final b in sorted) {
    if (seen.add(b.id)) out.add(b);
  }
  return out;
}

/// Earliest round a badge id was earned in (website achievements.tsx `earnedRoundFor`).
int? earnedRoundFor(List<EarnedBadge> badges, String badgeId) {
  int? best;
  for (final b in badges) {
    if (b.id != badgeId || b.roundNum == null || b.roundNum == 0) continue;
    if (best == null || b.roundNum! < best) best = b.roundNum;
  }
  return best;
}

List<T> _list<T>(dynamic body, T Function(Map<String, dynamic>) parse) {
  if (body is! Map) return const [];
  final data = body['data'];
  final raw = data is Map ? data['badges'] : null;
  if (raw is! List) return const [];
  return raw.whereType<Map>().map((e) => parse(Map<String, dynamic>.from(e))).toList();
}

List<CatalogBadge> parseCatalog(dynamic body) => _list(body, CatalogBadge.fromJson);
List<EarnedBadge> parseEarned(dynamic body) => _list(body, EarnedBadge.fromJson);

// ── Podium ──────────────────────────────────────────────────────────────────

class PodiumEntry {
  final String teamId;
  final double value;
  const PodiumEntry(this.teamId, this.value);

  static PodiumEntry? fromJson(dynamic j) {
    if (j is! Map) return null;
    return PodiumEntry(j['teamId']?.toString() ?? '', _toDouble(j['value']));
  }
}

/// GET /api/badges/podium?round=N → data.dimensions[].
class PodiumDimension {
  /// 'profitability' | 'resilience' | 'mostImproved'
  final String dimension;
  final String label;
  final String description;
  final PodiumEntry? winner;
  final List<PodiumEntry> runnersUp;

  const PodiumDimension({
    required this.dimension,
    required this.label,
    required this.description,
    this.winner,
    this.runnersUp = const [],
  });

  factory PodiumDimension.fromJson(Map<String, dynamic> j) {
    final ru = j['runnersUp'];
    return PodiumDimension(
      dimension: j['dimension']?.toString() ?? '',
      label: j['label']?.toString() ?? '',
      description: j['description']?.toString() ?? '',
      winner: PodiumEntry.fromJson(j['winner']),
      runnersUp: ru is List ? ru.map(PodiumEntry.fromJson).whereType<PodiumEntry>().toList() : const [],
    );
  }

  String get icon => switch (dimension) {
        'profitability' => '💰',
        'resilience' => '🛡️',
        'mostImproved' => '📈',
        _ => '🏆',
      };

  /// Resilience is a ratio composite; the other two are money (website formatDimensionValue).
  String formatValue(double v) => dimension == 'resilience' ? v.toStringAsFixed(2) : formatMoneyShort(v);

  // NOT FROM THE WEBSITE: the server sends English-only label/description.
  static const Map<String, (String, String)> _ar = {
    'profitability': ('الربحية', 'أعلى صافي دخل في هذه الجولة'),
    'resilience': ('المرونة', 'سيولة قوية مع رافعة مالية منخفضة (نسبة التداول ناقص الدين إلى حقوق الملكية)'),
    'mostImproved': ('الأكثر تحسنًا', 'أكبر زيادة في صافي الدخل مقارنة بالجولة السابقة'),
  };

  String localizedLabel(bool ar) => ar ? (_ar[dimension]?.$1 ?? label) : label;
  String localizedDescription(bool ar) => ar ? (_ar[dimension]?.$2 ?? description) : description;
}

List<PodiumDimension> parsePodium(dynamic body) {
  if (body is! Map) return const [];
  final data = body['data'];
  final raw = data is Map ? data['dimensions'] : null;
  if (raw is! List) return const [];
  return raw.whereType<Map>().map((e) => PodiumDimension.fromJson(Map<String, dynamic>.from(e))).toList();
}

/// Website achievements.tsx formatMoney: $1.2M / $3.4K / $560, sign in front.
String formatMoneyShort(double n) {
  final sign = n < 0 ? '-' : '';
  final abs = n.abs();
  if (abs >= 1000000) return '$sign\$${(abs / 1000000).toStringAsFixed(1)}M';
  if (abs >= 1000) return '$sign\$${(abs / 1000).toStringAsFixed(1)}K';
  return '$sign\$${abs.toStringAsFixed(0)}';
}

/// POST /api/badges/evaluate and /api/badges/self-paced/evaluate → data.
class BadgeEvaluation {
  final int round;
  final bool throttled;
  final List<({String badgeId, int roundNum, String? teamId})> newlyEarned;

  const BadgeEvaluation({required this.round, this.throttled = false, this.newlyEarned = const []});

  factory BadgeEvaluation.fromResponse(dynamic body) {
    final data = body is Map ? body['data'] : null;
    if (data is! Map) return const BadgeEvaluation(round: 0);
    final ne = data['newlyEarned'];
    return BadgeEvaluation(
      round: _toIntOrNull(data['round']) ?? 0,
      throttled: data['throttled'] == true,
      newlyEarned: ne is List
          ? ne.whereType<Map>().map((m) => (
                badgeId: m['badgeId']?.toString() ?? '',
                roundNum: _toIntOrNull(m['roundNum']) ?? 0,
                teamId: m['teamId']?.toString(),
              )).toList()
          : const [],
    );
  }
}
