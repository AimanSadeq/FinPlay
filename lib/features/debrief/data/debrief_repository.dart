import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../providers/repository_providers.dart';
import '../../achievements/data/gamification_session.dart' show GamificationHttp;
import 'debrief_models.dart';
import 'self_paced_bearer.dart';

// Debrief API (website server/routes/debrief.ts, mounted at /api/debrief). The ApiClient
// base URL already ends in /api. Corporate calls are unauthenticated and take the team id
// ("Team 1".."Team 7"); self-paced calls identify the learner by the Bearer token the
// ApiClient already carries. round must be 1, 2 or 3.
const _waterfallPath = '/debrief/waterfall';
const _coachPath = '/debrief/coach';
const _spWaterfallPath = '/debrief/self-paced/waterfall';
const _spCoachPath = '/debrief/self-paced/coach';

class DebriefRepository {
  final GamificationHttp _http;
  final Future<String?> Function() _selfPacedBearer;

  DebriefRepository(ApiClient api, {Future<String?> Function()? selfPacedBearer})
      : _http = GamificationHttp(api),
        _selfPacedBearer = selfPacedBearer ?? readSelfPacedBearer;

  // A 401 here is answered in place (error state), never by a global sign-out.
  static const _quiet = {skipUnauthorizedHandlerExtra: true};
  // The coach is an AI generation: never let the retry interceptor fire it again.
  static const _coachExtra = {skipUnauthorizedHandlerExtra: true, noRetryExtra: true};

  /// Throws when the server answers an error (the card shows its error state).
  Future<WaterfallData> fetchWaterfall({String? teamId, required int round, required bool selfPaced}) async {
    final Map<String, dynamic> res;
    if (selfPaced) {
      final bearer = await _selfPacedBearer();
      if (bearer == null) throw Exception('Not signed in');
      res = await _http.get(_spWaterfallPath,
          bearer: bearer, query: {'round': round}, extra: _quiet);
    } else {
      res = await _http.get(_waterfallPath,
          query: {'teamId': teamId ?? '', 'round': round}, extra: _quiet);
    }
    if (res['success'] != true) {
      throw Exception(res['error']?.toString() ?? 'Failed to load decision impact data');
    }
    return WaterfallData.fromJson(res);
  }

  /// Returns the stored debrief for the round and language when one exists, otherwise the
  /// server generates and stores one. Never throws: failures map to [CoachStatus.failed].
  Future<CoachResult> generateCoach({
    String? teamId,
    required int round,
    required bool selfPaced,
    required String language,
  }) async {
    try {
      final Map<String, dynamic> res;
      if (selfPaced) {
        final bearer = await _selfPacedBearer();
        if (bearer == null) return const CoachResult(status: CoachStatus.failed);
        res = await _http.post(_spCoachPath,
            bearer: bearer, data: {'round': round, 'language': language}, extra: _coachExtra);
      } else {
        res = await _http.post(_coachPath,
            data: {'teamId': teamId ?? '', 'round': round, 'language': language},
            extra: _coachExtra);
      }
      return CoachResult.fromJson(res);
    } catch (_) {
      return const CoachResult(status: CoachStatus.failed);
    }
  }
}

final debriefRepositoryProvider =
    Provider<DebriefRepository>((ref) => DebriefRepository(ref.watch(apiClientProvider)));

typedef WaterfallKey = ({bool selfPaced, String teamId, int round});

final decisionWaterfallProvider =
    FutureProvider.autoDispose.family<WaterfallData, WaterfallKey>((ref, key) {
  return ref.read(debriefRepositoryProvider).fetchWaterfall(
        teamId: key.selfPaced ? null : key.teamId,
        round: key.round,
        selfPaced: key.selfPaced,
      );
});
