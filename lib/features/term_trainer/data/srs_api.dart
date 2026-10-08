// Client for the website's spaced-repetition API (server/routes/srs.ts).
//
//   POST /api/srs/queue   {allTermIds: string[], limit: number}
//        -> {success, due: string[], newTerms: string[],
//            stats: {dueCount, learnedCount}, streak: {current, best, activeToday}}
//   POST /api/srs/review  {termId: string, grade: 0|1|2|3}
//        -> {success, next: {intervalDays, dueAt}, streak}
//
// Auth (server `verifyLearnerAuth`): a self-paced session token, or a corporate team
// member's lobby-issued token (mapped server-side to a per-player identity). The website
// sends `selfPacedToken || teamMemberToken`; this client does the same, explicitly per
// request, because the app's shared Authorization header is whichever token was set last.

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/network/api_client.dart';
import '../../../core/utils/constants.dart';

const String _srsQueuePath = '/srs/queue';
const String _srsReviewPath = '/srs/review';

class StreakInfo {
  final int current;
  final int best;
  final bool activeToday;
  const StreakInfo({this.current = 0, this.best = 0, this.activeToday = false});

  factory StreakInfo.fromJson(Map<String, dynamic>? j) => StreakInfo(
        current: (j?['current'] as num?)?.toInt() ?? 0,
        best: (j?['best'] as num?)?.toInt() ?? 0,
        activeToday: j?['activeToday'] == true,
      );
}

class SrsQueue {
  final List<String> due;
  final List<String> newTerms;
  final int dueCount;
  final int learnedCount;
  final StreakInfo streak;
  const SrsQueue({
    required this.due,
    required this.newTerms,
    required this.dueCount,
    required this.learnedCount,
    required this.streak,
  });

  factory SrsQueue.fromJson(Map<String, dynamic> j) {
    final stats = j['stats'] is Map ? Map<String, dynamic>.from(j['stats'] as Map) : const <String, dynamic>{};
    List<String> ids(Object? v) => v is List ? v.whereType<String>().toList() : const [];
    return SrsQueue(
      due: ids(j['due']),
      newTerms: ids(j['newTerms']),
      dueCount: (stats['dueCount'] as num?)?.toInt() ?? 0,
      learnedCount: (stats['learnedCount'] as num?)?.toInt() ?? 0,
      streak: StreakInfo.fromJson(j['streak'] is Map ? Map<String, dynamic>.from(j['streak'] as Map) : null),
    );
  }
}

/// The stored token is dead (expired/revoked): retrying can never succeed.
class SrsUnauthorized implements Exception {
  const SrsUnauthorized();
}

class SrsFailure implements Exception {
  final String message;
  const SrsFailure(this.message);
  @override
  String toString() => message;
}

class SrsApi {
  final ApiClient api;
  const SrsApi(this.api);

  /// The learner's bearer: self-paced first, then the corporate team-member token
  /// (website `getToken()` order). Null when signed out.
  static Future<String?> learnerToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      for (final key in [AppConstants.selfPacedTokenKey, AppConstants.teamMemberTokenKey]) {
        final v = prefs.getString(key);
        if (v != null && v.isNotEmpty) return v;
      }
    } catch (_) {/* storage unavailable: treat as signed out */}
    return null;
  }

  Future<Map<String, dynamic>> _post(String path, String token, Map<String, dynamic> body) async {
    try {
      final res = await api.dio.post(
        path,
        data: body,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final data = res.data;
      if (data is Map) return Map<String, dynamic>.from(data);
      throw const SrsFailure('Unexpected response');
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 401) throw const SrsUnauthorized();
      final data = e.response?.data;
      final serverMsg = data is Map ? data['error'] : null;
      throw SrsFailure(serverMsg is String ? serverMsg : 'Request failed (${status ?? 'network'})');
    }
  }

  Future<SrsQueue> queue(String token, {required List<String> allTermIds, required int limit}) async {
    final j = await _post(_srsQueuePath, token, {'allTermIds': allTermIds, 'limit': limit});
    if (j['success'] != true) throw const SrsFailure('Could not load your practice queue');
    return SrsQueue.fromJson(j);
  }

  /// Records one review. Returns the updated streak when the server sends one.
  Future<StreakInfo?> review(String token, {required String termId, required int grade}) async {
    final j = await _post(_srsReviewPath, token, {'termId': termId, 'grade': grade});
    return j['streak'] is Map ? StreakInfo.fromJson(Map<String, dynamic>.from(j['streak'] as Map)) : null;
  }
}
