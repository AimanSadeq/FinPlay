/// Self-paced access state, mirrored from the backend's computeEntitlement().
///
/// The server returns this on /self-paced/me and login as `entitlement`, and gates paid content
/// (simulation scenarios, dashboard) with a 402 { code: 'SUBSCRIPTION_REQUIRED' } when it lapses.
///
/// iOS is WEB-ONLY billing: this app never shows a price or a purchase button (App Store policy).
/// It only reflects state — a trial countdown, or an "access ended, manage on the website" notice.
class Entitlement {
  /// Whether paid content is currently accessible.
  final bool active;

  /// Why: 'student' | 'comp' | 'subscription' | 'trial' | 'none'.
  final String reason;

  /// When the current access window ends (trial end or subscription expiry), if known.
  final DateTime? accessUntil;

  /// Whether the backend is enforcing billing at all. When false, [active] is always true.
  final bool enforced;

  const Entitlement({
    required this.active,
    required this.reason,
    this.accessUntil,
    this.enforced = false,
  });

  /// A permissive default used before /me resolves — never locks a learner out on unknown state.
  static const Entitlement unknown =
      Entitlement(active: true, reason: 'none', enforced: false);

  factory Entitlement.fromJson(Map<String, dynamic> json) {
    return Entitlement(
      active: json['active'] as bool? ?? true,
      reason: json['reason']?.toString() ?? 'none',
      accessUntil: json['accessUntil'] != null
          ? DateTime.tryParse(json['accessUntil'].toString())
          : null,
      enforced: json['enforced'] as bool? ?? false,
    );
  }

  /// On a free trial with billing enforced (so the countdown is meaningful).
  bool get isTrial => reason == 'trial';

  /// Access has lapsed and the backend is enforcing — show the "access ended" gate.
  bool get isLapsed => enforced && !active;

  /// Whole days remaining until [accessUntil] (0 if past or unknown).
  int get daysRemaining {
    if (accessUntil == null) return 0;
    final diff = accessUntil!.difference(DateTime.now());
    if (diff.isNegative) return 0;
    // Round up so "23h left" reads as 1 day, not 0.
    return diff.inHours <= 0 ? 0 : (diff.inHours / 24).ceil();
  }
}
