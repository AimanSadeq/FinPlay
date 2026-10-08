import '../../achievements/data/gamification_session.dart';
import 'sim_certificate_models.dart';

/// Endpoint paths (relative to the ApiClient's `/api` base). Local to this feature because
/// api_endpoints.dart is owned elsewhere; can be moved there verbatim.
class SimCertificateEndpoints {
  SimCertificateEndpoints._();

  /// GET. Accepts EITHER a team-member token or a self-paced session token as Bearer.
  static const String mine = '/certificate/simulation/mine';

  /// POST, no body. Corporate: Bearer team-member token (requireTeamMember).
  static const String claimCorporate = '/certificate/simulation/claim';

  /// POST, no body. Self-paced: Bearer session token + active entitlement (402 otherwise).
  static const String claimSelfPaced = '/certificate/simulation/claim-self-paced';
}

class SimCertificateRepository {
  final GamificationHttp _http;
  SimCertificateRepository(this._http);

  Future<SimCertificateStatus> mine(GamificationSession session) async {
    final bearer = session.bearer;
    if (bearer == null) return SimCertificateStatus.signedOut;
    try {
      return SimCertificateStatus.fromResponse(
          await _http.get(SimCertificateEndpoints.mine, bearer: bearer));
    } catch (e) {
      return SimCertificateStatus(error: e.toString());
    }
  }

  Future<SimClaimResult> claim(GamificationSession session) async {
    final bearer = session.bearer;
    if (bearer == null) return const SimClaimResult(unauthorized: true);
    final path = session.isSelfPaced
        ? SimCertificateEndpoints.claimSelfPaced
        : SimCertificateEndpoints.claimCorporate;
    try {
      return SimClaimResult.fromResponse(await _http.post(path, bearer: bearer));
    } catch (_) {
      return const SimClaimResult();
    }
  }
}
