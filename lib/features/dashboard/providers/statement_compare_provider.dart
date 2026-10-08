import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart' show httpStatusKey, skipUnauthorizedHandlerExtra;
import '../../achievements/data/gamification_session.dart' show GamificationHttp;
import '../../debrief/data/self_paced_bearer.dart';
import '../../../providers/repository_providers.dart';
import '../logic/statement_analysis.dart';

// Endpoints (kept local; same paths as ApiEndpoints.dashboardData /
// ApiEndpoints.selfPacedProgressDashboardData).
//   GET /api/dashboard-data?teamId=&currentRound=&previousRound=
//   GET /api/self-paced/progress/dashboard-data?currentRound=&previousRound=  (Bearer)
// Both answer {data: {currentRound: {income, balance, cashflow, ratios},
//                     previousRound: {...}}} and accept any previousRound (0 = baseline).
const _dashboardDataPath = '/dashboard-data';
const _selfPacedDashboardDataPath = '/self-paced/progress/dashboard-data';

typedef StatementCompareKey = ({bool selfPaced, String teamId, int round, int compare});

/// The round shown and the chosen comparison period, fetched in one call so the
/// statement tables can line both up. Null when the server answered an error body.
final statementCompareProvider = FutureProvider.autoDispose
    .family<StatementComparison?, StatementCompareKey>((ref, key) async {
  final http = GamificationHttp(ref.watch(apiClientProvider));
  final params = <String, dynamic>{
    if (!key.selfPaced) 'teamId': key.teamId,
    'currentRound': key.round,
    'previousRound': key.compare,
  };
  // Self-paced: send the learner's own token explicitly (the shared header may hold a
  // corporate team token), and answer a 401 here instead of signing the learner out.
  String? bearer;
  if (key.selfPaced) {
    bearer = await readSelfPacedBearer();
    if (bearer == null) return null;
  }
  final res = await http.get(
    key.selfPaced ? _selfPacedDashboardDataPath : _dashboardDataPath,
    bearer: bearer,
    query: params,
    extra: const {skipUnauthorizedHandlerExtra: true},
  );
  if (res[httpStatusKey] != null || res['data'] is! Map) return null;
  return StatementComparison.fromResponse(res, key.round, key.compare);
});
