import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/network/api_client.dart';
import '../../../core/utils/constants.dart';

/// Which kind of player is on this device, as far as badges / certificates are concerned.
enum GamificationMode { corporate, selfPaced, none }

/// Who is asking, and with which bearer token.
///
/// Mirrors the website's detection (client/src/pages/achievements.tsx):
///   corporate  — a teamId is stored (localStorage 'teamId'); certificate calls carry the
///                team-member token minted at lobby sign-in ('teamMemberToken').
///   self-paced — a self-paced session token is stored AND no corporate teamId.
///
/// The app keeps one global Authorization header that is whichever token was set last, so
/// the gamification calls never rely on it: every authenticated call sends the token for
/// the resolved mode explicitly (see [GamificationHttp]).
class GamificationSession {
  final GamificationMode mode;
  final String? teamId;
  final String? teamMemberToken;
  final String? selfPacedToken;

  const GamificationSession({
    required this.mode,
    this.teamId,
    this.teamMemberToken,
    this.selfPacedToken,
  });

  static const none = GamificationSession(mode: GamificationMode.none);

  bool get isSelfPaced => mode == GamificationMode.selfPaced;
  bool get isCorporate => mode == GamificationMode.corporate;

  /// The bearer the certificate endpoints expect for this mode (null = signed out).
  String? get bearer => switch (mode) {
        GamificationMode.corporate => teamMemberToken,
        GamificationMode.selfPaced => selfPacedToken,
        GamificationMode.none => null,
      };

  /// Pure resolution rule, exposed for tests.
  static GamificationSession resolve({
    String? teamId,
    String? teamMemberToken,
    String? selfPacedToken,
  }) {
    String? clean(String? v) => (v == null || v.trim().isEmpty) ? null : v;
    final t = clean(teamId);
    final tm = clean(teamMemberToken);
    final sp = clean(selfPacedToken);
    if (sp != null && t == null) {
      return GamificationSession(mode: GamificationMode.selfPaced, selfPacedToken: sp);
    }
    if (t != null) {
      return GamificationSession(
        mode: GamificationMode.corporate,
        teamId: t,
        teamMemberToken: tm,
      );
    }
    return none;
  }

  static Future<GamificationSession> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return resolve(
        teamId: prefs.getString(AppConstants.teamIdKey),
        teamMemberToken: prefs.getString(AppConstants.teamMemberTokenKey),
        selfPacedToken: prefs.getString(AppConstants.selfPacedTokenKey),
      );
    } catch (_) {
      return none;
    }
  }
}

/// Small HTTP helper over the shared Dio instance that (a) sends an explicit bearer per
/// request and (b) keeps 4xx bodies instead of throwing, stamping the status under
/// [httpStatusKey] — the same convention as [ApiClient.get].
class GamificationHttp {
  final ApiClient api;
  const GamificationHttp(this.api);

  Options _opts(String? bearer, Map<String, dynamic>? extra) => Options(
        headers: bearer == null ? null : {'Authorization': 'Bearer $bearer'},
        extra: extra,
      );

  /// [extra] goes to `RequestOptions.extra` (e.g. [noRetryExtra],
  /// [skipUnauthorizedHandlerExtra]).
  Future<Map<String, dynamic>> get(String path,
      {String? bearer, Map<String, dynamic>? query, Map<String, dynamic>? extra}) async {
    return _wrap(
        () => api.dio.get(path, queryParameters: query, options: _opts(bearer, extra)));
  }

  Future<Map<String, dynamic>> post(String path,
      {String? bearer, Object? data, Map<String, dynamic>? extra}) async {
    return _wrap(
        () => api.dio.post(path, data: data ?? const {}, options: _opts(bearer, extra)));
  }

  Future<Map<String, dynamic>> _wrap(Future<Response<dynamic>> Function() call) async {
    try {
      final res = await call();
      final body = res.data;
      if (body is Map) return Map<String, dynamic>.from(body);
      return {'success': true, 'data': body};
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final body = e.response?.data;
      if (body is Map) {
        final map = Map<String, dynamic>.from(body);
        if (status != null) map[httpStatusKey] = status;
        return map;
      }
      if (status != null) {
        return {'success': false, 'error': 'Request failed ($status)', httpStatusKey: status};
      }
      rethrow;
    }
  }
}
