import 'package:dio/dio.dart';
import '../utils/constants.dart';

/// Key under which ApiClient stamps the HTTP status onto a preserved 4xx response body, so a
/// caller can distinguish (say) an expired session from a generic failure. Underscore-prefixed
/// to make clear it is added by the client and never sent by the server.
const String httpStatusKey = '_httpStatus';

/// True when a response map returned by ApiClient is a failure: the server said
/// so (`success: false`) or the request was rejected with a 4xx that ApiClient
/// preserved as a body. A missing route answers 404 {success:false, error:'API
/// route not found'}, so a caller that does not check this treats a dead route
/// as success.
bool apiFailed(Map<String, dynamic> res) =>
    res['success'] == false || ((res[httpStatusKey] as int?) ?? 0) >= 400;

class ApiClient {
  static ApiClient? _instance;
  late final Dio _dio;

  /// Invoked when an AUTHENTICATED request (one carrying an Authorization bearer)
  /// is rejected with 401 — used to force a self-paced sign-out + redirect to login.
  void Function()? onUnauthorized;

  ApiClient._() {
    _dio = Dio(BaseOptions(
      baseUrl: '${AppConstants.baseUrl}${AppConstants.apiPrefix}',
      connectTimeout: AppConstants.apiTimeout,
      receiveTimeout: AppConstants.apiTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.addAll([
      _LoggingInterceptor(),
      _AuthInterceptor(this),
      _RetryInterceptor(_dio),
    ]);
  }

  factory ApiClient() {
    _instance ??= ApiClient._();
    return _instance!;
  }

  Dio get dio => _dio;

  /// Switch the API host (used to select a cohort, which is its own subdomain).
  /// Accepts a full origin like "https://groupa.finplay.viftraining.com"; the
  /// "/api" prefix is appended if missing.
  void setBaseHost(String origin) {
    final trimmed = origin.replaceAll(RegExp(r'/+$'), '');
    _dio.options.baseUrl =
        trimmed.endsWith(AppConstants.apiPrefix) ? trimmed : '$trimmed${AppConstants.apiPrefix}';
  }

  String get baseUrl => _dio.options.baseUrl;

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  /// Facilitator console auth: the backend accepts this header on every
  /// facilitator-gated route, so set it once after the facilitator logs in.
  void setFacilitatorPassword(String password) {
    _dio.options.headers['x-facilitator-password'] = password;
  }

  void clearFacilitatorPassword() {
    _dio.options.headers.remove('x-facilitator-password');
  }

  /// True once a facilitator has signed in on this device (the password header
  /// is attached), so reads can use the facilitator-gated routes.
  bool get hasFacilitatorPassword =>
      (_dio.options.headers['x-facilitator-password'] as String?)?.isNotEmpty == true;

  /// GET that returns a Map response
  Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? params}) async {
    try {
      final response = await _dio.get(path, queryParameters: params);
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      // Wrap non-map responses
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return _preserved4xx(e) ?? (throw e);
    }
  }

  /// The server's error body for a 4xx, stamped with the status, or null when
  /// the error is not a 4xx and should propagate.
  ///
  /// The body is preserved (e.g. a 402 SUBSCRIPTION_REQUIRED carries
  /// {success:false, code:'SUBSCRIPTION_REQUIRED', ...} that the UI acts on)
  /// instead of letting the exception bubble up and break the screen. The
  /// status is stamped under [httpStatusKey] because not every error carries a
  /// `code`: a 401 is just {success:false, error:'Not authenticated'}, which a
  /// caller otherwise cannot tell apart from any other failure, and a 404 from
  /// a route that no longer exists is {success:false, error:'API route not
  /// found'}. Every verb goes through here so a POST caller can detect a dead
  /// route the same way a GET caller can.
  Map<String, dynamic>? _preserved4xx(DioException e, {bool authMessages = false}) {
    final statusCode = e.response?.statusCode;
    if (e.response?.data is Map) {
      final body = Map<String, dynamic>.from(e.response!.data as Map);
      if (statusCode != null) body[httpStatusKey] = statusCode;
      return body;
    }
    if (statusCode == null || statusCode < 400 || statusCode >= 500) return null;
    final error = switch (statusCode) {
      401 when authMessages => 'Invalid email or password',
      409 when authMessages => 'Email already registered',
      _ => 'Request failed ($statusCode)',
    };
    return {'success': false, 'error': error, httpStatusKey: statusCode};
  }

  /// GET that returns a List response
  Future<List<dynamic>> getList(String path, {Map<String, dynamic>? params}) async {
    final response = await _dio.get(path, queryParameters: params);
    if (response.data is List) {
      return response.data as List<dynamic>;
    }
    // If wrapped in {success, data: [...]}
    if (response.data is Map && response.data['data'] is List) {
      return response.data['data'] as List<dynamic>;
    }
    return [];
  }

  /// POST
  Future<Map<String, dynamic>> post(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      // Same rule as get(): a 4xx body comes back stamped with its status.
      return _preserved4xx(e, authMessages: true) ?? (throw e);
    }
  }

  /// PUT
  Future<Map<String, dynamic>> put(String path, {dynamic data}) async {
    try {
      final response = await _dio.put(path, data: data);
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return _preserved4xx(e) ?? (throw e);
    }
  }

  /// PATCH
  Future<Map<String, dynamic>> patch(String path, {dynamic data}) async {
    try {
      final response = await _dio.patch(path, data: data);
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return _preserved4xx(e) ?? (throw e);
    }
  }

  /// DELETE
  Future<Map<String, dynamic>> delete(String path) async {
    try {
      final response = await _dio.delete(path);
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return _preserved4xx(e) ?? (throw e);
    }
  }
}

class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // ignore: avoid_print
    print('[API] ${options.method} ${options.path}');
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // ignore: avoid_print
    print('[API ERROR] ${err.response?.statusCode} ${err.message}');
    handler.next(err);
  }
}

// Detects 401 on authenticated requests (those carrying an Authorization bearer)
// and fires onUnauthorized so the app can sign the self-paced user out. Login /
// register / auth requests don't carry the bearer, so they won't trigger it.
class _AuthInterceptor extends Interceptor {
  final ApiClient _client;
  _AuthInterceptor(this._client);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401 &&
        err.requestOptions.headers.containsKey('Authorization')) {
      _client.onUnauthorized?.call();
    }
    handler.next(err);
  }
}

class _RetryInterceptor extends Interceptor {
  final Dio _dio;
  static const int _maxRetries = 2;

  _RetryInterceptor(this._dio);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err) && (err.requestOptions.extra['retryCount'] ?? 0) < _maxRetries) {
      final retryCount = (err.requestOptions.extra['retryCount'] ?? 0) + 1;
      err.requestOptions.extra['retryCount'] = retryCount;

      await Future.delayed(Duration(seconds: retryCount));

      try {
        final response = await _dio.fetch(err.requestOptions);
        handler.resolve(response);
        return;
      } catch (_) {}
    }
    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    // Don't retry connection errors (server not reachable)
    if (err.type == DioExceptionType.connectionError) return false;
    // Don't retry baseline/case-study 500s (expected when Excel not connected)
    final path = err.requestOptions.path;
    if (path.contains('baseline') || path.contains('case-study') || path.contains('excel') || path.contains('leaderboard')) {
      return false;
    }
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        (err.response?.statusCode != null && err.response!.statusCode! >= 500);
  }
}
