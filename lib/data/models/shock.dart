import 'dart:ui';

class Shock {
  final String id;
  final String name;
  final String? nameAr;
  final String description;
  final String? descriptionAr;
  final String category;
  final String severity;
  final Map<String, dynamic>? parameters;
  final bool isActive;

  const Shock({
    required this.id,
    required this.name,
    this.nameAr,
    required this.description,
    this.descriptionAr,
    required this.category,
    this.severity = 'medium',
    this.parameters,
    this.isActive = false,
  });

  factory Shock.fromJson(Map<String, dynamic> json) {
    return Shock(
      id: json['id'] as String,
      name: json['name'] as String,
      nameAr: json['nameAr'] as String?,
      description: json['description'] as String,
      descriptionAr: json['descriptionAr'] as String?,
      category: json['category'] as String,
      severity: json['severity'] as String? ?? 'medium',
      parameters: json['parameters'] as Map<String, dynamic>?,
      isActive: json['isActive'] as bool? ?? false,
    );
  }

  String getName(bool isArabic) => (isArabic && nameAr != null) ? nameAr! : name;
  String getDescription(bool isArabic) =>
      (isArabic && descriptionAr != null) ? descriptionAr! : description;

  Color get severityColor {
    switch (severity) {
      case 'low': return const Color(0xFF10B981);
      case 'medium': return const Color(0xFFF59E0B);
      case 'high': return const Color(0xFFEF4444);
      case 'critical': return const Color(0xFF7C3AED);
      default: return const Color(0xFF6B7280);
    }
  }
}
