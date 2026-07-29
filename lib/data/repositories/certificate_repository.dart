import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../models/certificate.dart';

/// Completion certificates. Read-only: the backend issues the certificate automatically the
/// first time a learner has completed every module, so there is nothing for the app to create.
class CertificateRepository {
  final ApiClient _api;
  CertificateRepository(this._api);

  /// GET /certificate/me → eligibility, progress, and the certificate when there is one.
  ///
  /// The endpoint is entitlement-gated, so a lapsed learner gets 402 SUBSCRIPTION_REQUIRED.
  /// ApiClient preserves 4xx bodies, so that arrives as a normal map rather than a throw — it is
  /// surfaced as [CertificateStatus.subscriptionRequired] instead of being reported as a failure,
  /// because "your access ended" is a different message from "something went wrong".
  Future<CertificateStatus> fetch() async {
    try {
      final res = await _api.get(ApiEndpoints.certificateMe);

      if (res['code'] == 'SUBSCRIPTION_REQUIRED') {
        return const CertificateStatus(subscriptionRequired: true);
      }
      if (res['success'] != true) {
        return CertificateStatus(error: res['error']?.toString() ?? 'Could not load certificate');
      }

      final completed = (res['completed'] as num?)?.toInt() ?? 0;
      final total = (res['total'] as num?)?.toInt() ?? 0;
      final eligible = res['eligible'] == true;

      if (!eligible) {
        return CertificateStatus(completed: completed, total: total, eligible: false);
      }
      if (res['revoked'] == true) {
        return CertificateStatus(
          completed: completed,
          total: total,
          eligible: true,
          revoked: true,
        );
      }

      final raw = res['certificate'];
      return CertificateStatus(
        completed: completed,
        total: total,
        eligible: true,
        certificate:
            raw is Map ? Certificate.fromJson(Map<String, dynamic>.from(raw)) : null,
      );
    } catch (e) {
      return CertificateStatus(error: e.toString());
    }
  }
}
