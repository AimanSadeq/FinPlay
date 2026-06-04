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
  });

  factory Scenario.fromJson(Map<String, dynamic> json) {
    // API uses 'scenarioId', fallback to 'id'
    final id = json['scenarioId'] as String? ?? json['id'] as String? ?? '';
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
