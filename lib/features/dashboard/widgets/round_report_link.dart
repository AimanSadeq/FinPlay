import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/constants.dart';

/// URL of the print-ready round report: GET /api/reports/round-report/:teamId/:round.
///
/// The report is opened as a plain browser navigation, where no Authorization header can
/// be sent, so the server (server/utils/exportAuth.ts, website 1cfce67) takes the
/// credential in the query string: `?token=` with the team-member token minted at lobby
/// sign-in (valid for the member's own team only), or `?password=` for the facilitator.
/// Without either it answers 401.
///
/// The host comes from the API client, so a cohort subdomain selected at runtime is kept.
Future<Uri> buildRoundReportUri(ApiClient api, String teamId, int round) async {
  final clamped = round < 1 ? 1 : (round > 3 ? 3 : round);
  final base = api.baseUrl.replaceAll(RegExp(r'/+$'), '');
  final query = <String, String>{};

  String? token;
  try {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString(AppConstants.teamMemberTokenKey);
  } catch (_) {}
  // The facilitator password is deliberately never put in a URL handed to the system
  // browser (it would land in its history); only the team-member token is sent.
  if (token != null && token.isNotEmpty) query['token'] = token;

  final uri = Uri.parse(
    '$base/reports/round-report/${Uri.encodeComponent(teamId)}/$clamped',
  );
  return query.isEmpty ? uri : uri.replace(queryParameters: query);
}
