import '../../../core/network/api_client.dart' show httpStatusKey;

/// A simulation certificate as returned by the server's toCertPayload()
/// (website server/routes/certificate.ts).
class SimCertificate {
  final String verificationCode;
  final String learnerName;
  final String programName;
  final DateTime? issuedAt;

  /// Public verification page, built by the server (PUBLIC_BASE_URL or the request host),
  /// so a cohort subdomain is already correct.
  final String verifyUrl;

  const SimCertificate({
    required this.verificationCode,
    required this.learnerName,
    required this.programName,
    required this.verifyUrl,
    this.issuedAt,
  });

  static SimCertificate? fromJson(dynamic j) {
    if (j is! Map) return null;
    final code = j['verificationCode']?.toString() ?? '';
    if (code.isEmpty) return null;
    return SimCertificate(
      verificationCode: code,
      learnerName: j['learnerName']?.toString() ?? '',
      programName: j['programName']?.toString() ?? 'FinPlay Business Simulation',
      issuedAt: DateTime.tryParse(j['issuedAt']?.toString() ?? ''),
      verifyUrl: j['verifyUrl']?.toString() ?? '',
    );
  }

  /// LinkedIn "Add licence or certification" deep link — byte-for-byte the website's
  /// CertificatePanel.linkedInUrl(). Month is 1-based; issue date in the device's local zone
  /// (the website uses the browser's local zone too).
  Uri get linkedInAddToProfileUrl {
    final issued = (issuedAt ?? DateTime.now()).toLocal();
    return Uri.parse('https://www.linkedin.com/profile/add?startTask=CERTIFICATION_NAME'
        '&name=${Uri.encodeComponent(programName)}'
        '&organizationName=VIFM'
        '&issueYear=${issued.year}'
        '&issueMonth=${issued.month}'
        '&certUrl=${Uri.encodeComponent(verifyUrl)}'
        '&certId=$verificationCode');
  }
}

enum SimCertState { signedOut, loading, issued, eligible, locked, error }

/// GET /api/certificate/simulation/mine →
/// { success, mode, eligible, revoked, progress:{currentRound,totalRounds}, certificates:[cert] }
/// 401 → signed out (the panel hides itself, as on the website).
class SimCertificateStatus {
  final bool unauthorized;
  final String? mode; // 'corporate' | 'self-paced'
  final bool eligible;
  final bool revoked;
  final int currentRound;
  final int totalRounds;
  final SimCertificate? certificate;
  final String? error;

  const SimCertificateStatus({
    this.unauthorized = false,
    this.mode,
    this.eligible = false,
    this.revoked = false,
    this.currentRound = 0,
    this.totalRounds = 3,
    this.certificate,
    this.error,
  });

  static const signedOut = SimCertificateStatus(unauthorized: true);

  factory SimCertificateStatus.fromResponse(Map<String, dynamic> r) {
    if (r[httpStatusKey] == 401) return signedOut;
    if (r['success'] != true) {
      return SimCertificateStatus(error: r['error']?.toString() ?? 'Could not load certificates');
    }
    final p = r['progress'];
    final certs = r['certificates'];
    int asInt(dynamic v, int d) => v is num ? v.toInt() : d;
    return SimCertificateStatus(
      mode: r['mode']?.toString(),
      eligible: r['eligible'] == true,
      revoked: r['revoked'] == true,
      currentRound: p is Map ? asInt(p['currentRound'], 0) : 0,
      totalRounds: p is Map ? asInt(p['totalRounds'], 3) : 3,
      certificate: certs is List && certs.isNotEmpty ? SimCertificate.fromJson(certs.first) : null,
    );
  }

  SimCertState get state {
    if (unauthorized) return SimCertState.signedOut;
    if (error != null) return SimCertState.error;
    if (certificate != null) return SimCertState.issued;
    if (eligible) return SimCertState.eligible;
    return SimCertState.locked;
  }
}

/// Outcome of POST /simulation/claim (corporate) or /simulation/claim-self-paced.
///   200 { success:true, alreadyIssued, certificate }
///   403 { success:false, error, currentRound, totalRounds }   not finished yet
///   410 { success:false, error }                               revoked
///   402 { success:false, code:'SUBSCRIPTION_REQUIRED', ... }   self-paced, access lapsed
///   401                                                        token missing/expired
class SimClaimResult {
  final SimCertificate? certificate;
  final bool alreadyIssued;
  final bool subscriptionRequired;
  final bool unauthorized;
  final bool revoked;
  final String? error;

  const SimClaimResult({
    this.certificate,
    this.alreadyIssued = false,
    this.subscriptionRequired = false,
    this.unauthorized = false,
    this.revoked = false,
    this.error,
  });

  bool get ok => certificate != null;

  factory SimClaimResult.fromResponse(Map<String, dynamic> r) {
    final cert = r['success'] == true ? SimCertificate.fromJson(r['certificate']) : null;
    if (cert != null) return SimClaimResult(certificate: cert, alreadyIssued: r['alreadyIssued'] == true);
    final status = r[httpStatusKey];
    return SimClaimResult(
      subscriptionRequired: r['code'] == 'SUBSCRIPTION_REQUIRED' || status == 402,
      unauthorized: status == 401,
      revoked: status == 410,
      error: r['error']?.toString(),
    );
  }
}

const _monthsEn = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];
const _monthsAr = [
  'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
  'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
];

/// "5 October 2026" — the website's toLocaleDateString('en-GB', {day, month:'long', year}).
String formatCertificateDate(DateTime d, bool ar) {
  final local = d.toLocal();
  final m = (ar ? _monthsAr : _monthsEn)[local.month - 1];
  return '${local.day} $m ${local.year}';
}
