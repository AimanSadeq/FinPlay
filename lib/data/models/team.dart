class Team {
  final String id;
  final String name;
  final String initial;
  final int currentRound;
  final String currentModule;
  final double totalScore;
  final bool isActive;
  final String? color;
  final DateTime? createdAt;

  const Team({
    required this.id,
    required this.name,
    this.initial = '',
    this.currentRound = 1,
    this.currentModule = 'financing',
    this.totalScore = 0,
    this.isActive = true,
    this.color,
    this.createdAt,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      initial: json['initial'] as String? ?? '',
      currentRound: json['currentRound'] as int? ?? 1,
      currentModule: json['currentModule'] as String? ?? 'financing',
      totalScore: (json['totalScore'] as num?)?.toDouble() ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      color: json['color'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'initial': initial,
    'currentRound': currentRound,
    'currentModule': currentModule,
    'totalScore': totalScore,
    'isActive': isActive,
    'color': color,
  };

  /// Extract team number from id like "Team 1" -> 1
  int get teamNumber {
    final match = RegExp(r'\d+').firstMatch(id);
    return match != null ? int.parse(match.group(0)!) : 0;
  }

  Team copyWith({
    String? id,
    String? name,
    String? initial,
    int? currentRound,
    String? currentModule,
    double? totalScore,
    bool? isActive,
    String? color,
  }) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      initial: initial ?? this.initial,
      currentRound: currentRound ?? this.currentRound,
      currentModule: currentModule ?? this.currentModule,
      totalScore: totalScore ?? this.totalScore,
      isActive: isActive ?? this.isActive,
      color: color ?? this.color,
      createdAt: createdAt,
    );
  }
}
