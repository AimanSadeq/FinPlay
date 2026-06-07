class SelfPacedUser {
  final String? id;
  final String email;
  final String displayName;
  final String? teamName;
  final String role;
  final int currentRound;
  final String currentModule;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? lastLoginAt;

  const SelfPacedUser({
    this.id,
    required this.email,
    required this.displayName,
    this.teamName,
    this.role = 'participant',
    this.currentRound = 1,
    this.currentModule = 'financing',
    this.isActive = true,
    this.createdAt,
    this.lastLoginAt,
  });

  factory SelfPacedUser.fromJson(Map<String, dynamic> json) {
    return SelfPacedUser(
      id: json['id']?.toString(),
      email: json['email'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      teamName: json['teamName'] as String?,
      role: json['role'] as String? ?? 'participant',
      currentRound: json['currentRound'] as int? ?? 1,
      currentModule: json['currentModule'] as String? ?? 'financing',
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) : null,
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.tryParse(json['lastLoginAt'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'email': email,
    'displayName': displayName,
    'teamName': teamName,
    'role': role,
  };

  /// Full serialization for local session persistence (includes system fields
  /// that toJson() intentionally omits from API payloads).
  Map<String, dynamic> toStorageJson() => {
    'id': id,
    'email': email,
    'displayName': displayName,
    'teamName': teamName,
    'role': role,
    'currentRound': currentRound,
    'currentModule': currentModule,
    'isActive': isActive,
  };
}
