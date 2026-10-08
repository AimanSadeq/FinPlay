class SelfPacedUser {
  final String? id;
  final String email;
  final String displayName;
  final String? teamName;
  // Verified self-paced registration profile (website parity). The server
  // derives displayName as "$firstName $lastName" and returns these on the user.
  final String? firstName;
  final String? lastName;
  final String? title;
  final String? company;
  final String? phone;
  final String? city;
  final String role;
  /// Billing plan: 'trial' | 'voucher' | 'self_paced' | 'student' | 'comp' |
  /// 'demo'. Only GET /self-paced/me returns it (login/register do not), so it
  /// is null until /me has been read. 'demo' lifts every earned lock.
  final String? plan;
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
    this.firstName,
    this.lastName,
    this.title,
    this.company,
    this.phone,
    this.city,
    this.role = 'participant',
    this.plan,
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
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      title: json['title'] as String?,
      company: json['company'] as String?,
      phone: json['phone'] as String?,
      city: json['city'] as String?,
      role: json['role'] as String? ?? 'participant',
      plan: json['plan']?.toString(),
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
    'firstName': firstName,
    'lastName': lastName,
    'title': title,
    'company': company,
    'phone': phone,
    'city': city,
    'role': role,
    'plan': plan,
    'currentRound': currentRound,
    'currentModule': currentModule,
    'isActive': isActive,
  };

  /// A business-development demo account (website isDemoAccount()).
  bool get isDemoPlan => plan == 'demo';
}
