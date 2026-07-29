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

  /// Anything else that went wrong, for display.
  final String? error;

  const CertificateStatus({
    this.completed = 0,
    this.total = 0,
    this.eligible = false,
    this.certificate,
    this.revoked = false,
    this.subscriptionRequired = false,
    this.error,
  });

  /// 0.0–1.0 progress toward eligibility. Guards total == 0 so a not-yet-loaded state renders
  /// an empty bar rather than throwing.
  double get progress => total <= 0 ? 0 : (completed / total).clamp(0, 1).toDouble();
}
