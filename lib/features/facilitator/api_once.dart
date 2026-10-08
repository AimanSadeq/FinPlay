import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';

/// [ApiClient.post] without the client's automatic retry. ApiClient's retry interceptor
/// re-sends a request up to twice after a 5xx or a receive timeout, which is only safe for
/// idempotent calls. Anything that orders paid work (AI questions, avatar videos, narration),
/// creates something (cohorts, codes, personas, forecasts, shocks) or wipes data goes
/// through here, so a slow or partly failed request is never performed twice.
///
/// Same result contract as [ApiClient.post]: the server's JSON body, also for 4xx/5xx
/// answers (stamped with [httpStatusKey]); a bare 4xx becomes `{success: false, error}`.
extension PostOnce on ApiClient {
  Future<Map<String, dynamic>> postOnce(String path, {dynamic data}) =>
      sendOnce('POST', path, data: data);

  Future<Map<String, dynamic>> sendOnce(String method, String path, {dynamic data}) async {
    try {
      final r = await dio.request<dynamic>(
        path,
        data: data,
        options: Options(method: method, extra: {noRetryExtra: true}),
      );
      final body = r.data;
      if (body is Map) return Map<String, dynamic>.from(body);
      return {'success': true, 'data': body};
    } on DioException catch (e) {
      final body = e.response?.data;
      final code = e.response?.statusCode;
      if (body is Map) return {...Map<String, dynamic>.from(body), httpStatusKey: ?code};
      if (code != null && code >= 400) {
        return {'success': false, 'error': 'Request failed ($code)', httpStatusKey: code};
      }
      rethrow;
    }
  }
}
