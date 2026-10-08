class Scenario {
  final String id;
  final int round;
  final String module;
  final String title;
  final String? titleAr;
  final String description;
  final String? descriptionAr;
  final String type;
  final String riskLevel;
  final double? amount;
  final String? category;
  final String? constraint;
  final String? keyMetrics;
  final Map<String, dynamic>? impact;
  final List<ScenarioInputField>? inputFields;

  /// Which way the card may go: 'both' | 'positive' | 'negative'. Resolved by the server
  /// (Model Editor catalog value, else shared/scenario-defaults.ts). Null on older payloads.
  final String? direction;

  /// Legend words for a positive / negative amount (English, from the catalog or defaults).
  final String? plusLabel;
  final String? minusLabel;

  /// True when [plusLabel]/[minusLabel] are the server's generic defaults rather than words
  /// a facilitator wrote in the Model Editor. Null when the server did not say.
  final bool? labelsAreDefault;

  /// Financial-engine row this card posts to (for impact previews). Null when absent.
  final int? engineRow;

  const Scenario({
    required this.id,
    required this.round,
    required this.module,
    required this.title,
    this.titleAr,
    required this.description,
    this.descriptionAr,
    required this.type,
    this.riskLevel = 'medium',
    this.amount,
    this.category,
    this.constraint,
    this.keyMetrics,
    this.impact,
    this.inputFields,
    this.direction,
    this.plusLabel,
    this.minusLabel,
    this.labelsAreDefault,
    this.engineRow,
  });

  factory Scenario.fromJson(Map<String, dynamic> json) {
    // API uses 'scenarioId', fallback to 'id'
    final id = json['scenarioId'] as String? ?? json['id'] as String? ?? '';
    final direction = json['direction']?.toString();
    String? label(dynamic v) {
      final t = v?.toString().trim();
      return (t == null || t.isEmpty) ? null : t;
    }
    return Scenario(
      id: id,
      round: json['round'] as int? ?? 1,
      module: json['module'] as String? ?? '',
      title: json['title'] as String? ?? '',
      titleAr: json['titleAr'] as String?,
      description: json['description'] as String? ?? '',
      descriptionAr: json['descriptionAr'] as String?,
      type: json['type'] as String? ?? '',
      riskLevel: json['riskLevel'] as String? ?? 'medium',
      amount: (json['amount'] as num?)?.toDouble(),
      category: json['category'] as String?,
      constraint: json['constraint'] as String?,
      keyMetrics: json['keyMetrics']?.toString(),
      impact: json['impact'] as Map<String, dynamic>?,
      inputFields: (json['inputFields'] as List<dynamic>?)
          ?.map((e) => ScenarioInputField.fromJson(e as Map<String, dynamic>))
          .toList(),
      direction: const {'both', 'positive', 'negative'}.contains(direction) ? direction : null,
      plusLabel: label(json['plusLabel']),
      minusLabel: label(json['minusLabel']),
      labelsAreDefault: json['labelsAreDefault'] is bool ? json['labelsAreDefault'] as bool : null,
      engineRow: (json['engineRow'] as num?)?.toInt(),
    );
  }

  String getTitle(bool isArabic) => (isArabic && titleAr != null) ? titleAr! : title;
  String getDescription(bool isArabic) =>
      (isArabic && descriptionAr != null) ? descriptionAr! : description;
}

class ScenarioInputField {
  final String name;
  final String label;
  final String? labelAr;
  final String type;
  final double? min;
  final double? max;
  final double? defaultValue;
  final String? unit;

  const ScenarioInputField({
    required this.name,
    required this.label,
    this.labelAr,
    this.type = 'number',
    this.min,
    this.max,
    this.defaultValue,
    this.unit,
  });

  factory ScenarioInputField.fromJson(Map<String, dynamic> json) {
    return ScenarioInputField(
      name: json['name'] as String,
      label: json['label'] as String,
      labelAr: json['labelAr'] as String?,
      type: json['type'] as String? ?? 'number',
      min: (json['min'] as num?)?.toDouble(),
      max: (json['max'] as num?)?.toDouble(),
      defaultValue: (json['defaultValue'] as num?)?.toDouble(),
      unit: json['unit'] as String?,
    );
  }
}
