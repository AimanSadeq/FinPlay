import '../../core/network/api_client.dart' show httpStatusKey;
import '../../core/utils/constants.dart';

/// A learner's completion certificate, mirrored from GET /api/certificate/me.
///
/// The server issues it automatically the first time every learning module is complete, so there
/// is no "generate" action — the app only reads. [verificationCode] is the public identifier an
/// employer can check.
class Certificate {
  final String verificationCode;
  final String learnerName;
  final String programName;
  final DateTime? issuedAt;

  /// Server-relative path (e.g. "/api/certificate/view/ABC123"). Use [viewUrl] to open it.
  final String viewPath;

  const Certificate({
    required this.verificationCode,
    required this.learnerName,
    required this.programName,
    this.issuedAt,
    required this.viewPath,
  });

  /// Absolute URL of the printable certificate — opened in the browser, since it is a
  /// server-rendered HTML page the app does not reproduce.
  String get viewUrl => viewPath.startsWith('http')
      ? viewPath
      : '${AppConstants.baseUrl}$viewPath';

  /// Public verification page an employer can open to confirm the certificate is genuine.
  String get verifyUrl => '${AppConstants.baseUrl}/verify/$verificationCode';

  factory Certificate.fromJson(Map<String, dynamic> json) {
    final issued = json['issuedAt'];
    return Certificate(
      verificationCode: json['verificationCode']?.toString() ?? '',
      learnerName: json['learnerName']?.toString() ?? '',
      programName: json['programName']?.toString() ?? '',
      issuedAt: issued == null ? null : DateTime.tryParse(issued.toString())?.toLocal(),
      viewPath: json['viewUrl']?.toString() ?? '',
    );
  }
}

/// The full state of GET /certificate/me. The endpoint answers three different questions at once
/// (progress, eligibility, and the certificate itself), so they are modelled together rather than
/// as a nullable certificate that silently hides *why* it is missing.
class CertificateStatus {
  /// Modules completed and the total required — shown as progress while not yet eligible.
  final int completed;
  final int total;

  /// True once [completed] >= [total]. Eligibility is decided by the server, not here.
  final bool eligible;

  /// Set only when eligible and not revoked.
  final Certificate? certificate;

  /// An issued certificate that was later revoked. Eligible, but must not be presented as valid.
  final bool revoked;

  /// Access lapsed (HTTP 402). Distinct from "not eligible" — the learner may well have finished
  /// the work; the server just will not mint a certificate without an active entitlement.
  final bool subscriptionRequired;

  /// Session expired or missing (HTTP 401). Sessions last 7 days, so this is routine rather than
  /// exceptional, and it needs its own state: without it the screen falls through to [error] and
  /// shows the server's raw "Not authenticated", which is a dead end rather than an instruction.
  final bool sessionExpired;

  /// Anything else that went wrong, for display.
  final String? error;

  const CertificateStatus({
    this.completed = 0,
    this.total = 0,
    this.eligible = false,
    this.certificate,
    this.revoked = false,
    this.subscriptionRequired = false,
    this.sessionExpired = false,
    this.error,
  });

  /// 0.0–1.0 progress toward eligibility. Guards total == 0 so a not-yet-loaded state renders
  /// an empty bar rather than throwing.
  double get progress => total <= 0 ? 0 : (completed / total).clamp(0, 1).toDouble();

  /// Map a GET /certificate/me response (or a preserved 4xx body) onto a status.
  ///
  /// Pure and separate from the repository so every branch is testable without mocking the
  /// network — the branch that matters most is 401, where falling through to [error] would show
  /// the server's raw "Not authenticated" instead of offering a way to sign in.
  factory CertificateStatus.fromResponse(Map<String, dynamic> res) {
    if (res['code'] == 'SUBSCRIPTION_REQUIRED') {
      return const CertificateStatus(subscriptionRequired: true);
    }
    if (res[httpStatusKey] == 401) {
      return const CertificateStatus(sessionExpired: true);
    }
    if (res['success'] != true) {
      return CertificateStatus(error: res['error']?.toString() ?? 'Could not load certificate');
    }

    final completed = (res['completed'] as num?)?.toInt() ?? 0;
    final total = (res['total'] as num?)?.toInt() ?? 0;
    if (res['eligible'] != true) {
      return CertificateStatus(completed: completed, total: total, eligible: false);
    }
    if (res['revoked'] == true) {
      return CertificateStatus(
          completed: completed, total: total, eligible: true, revoked: true);
    }
    final raw = res['certificate'];
    return CertificateStatus(
      completed: completed,
      total: total,
      eligible: true,
      certificate: raw is Map ? Certificate.fromJson(Map<String, dynamic>.from(raw)) : null,
    );
  }
}
