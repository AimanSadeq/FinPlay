import 'package:dio/dio.dart';
import '../utils/constants.dart';

class ApiClient {
  static ApiClient? _instance;
  late final Dio _dio;

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
      _RetryInterceptor(_dio),
    ]);
  }

  factory ApiClient() {
    _instance ??= ApiClient._();
    return _instance!;
  }

  Dio get dio => _dio;

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  /// GET that returns a Map response
  Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? params}) async {
    final response = await _dio.get(path, queryParameters: params);
    if (response.data is Map<String, dynamic>) {
      return response.data as Map<String, dynamic>;
    }
    // Wrap non-map responses
    return {'success': true, 'data': response.data};
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
      // Return error response body for 4xx errors instead of throwing
      if (e.response?.data is Map<String, dynamic>) {
        return e.response!.data as Map<String, dynamic>;
      }
      if (e.response?.data is Map) {
        return Map<String, dynamic>.from(e.response!.data as Map);
      }
      // Extract a user-friendly message
      final statusCode = e.response?.statusCode;
      if (statusCode == 401) {
        return {'success': false, 'error': 'Invalid email or password'};
      }
      if (statusCode == 409) {
        return {'success': false, 'error': 'Email already registered'};
      }
      if (statusCode != null && statusCode >= 400 && statusCode < 500) {
        return {'success': false, 'error': 'Request failed ($statusCode)'};
      }
      rethrow;
    }
  }

  /// PUT
  Future<Map<String, dynamic>> put(String path, {dynamic data}) async {
    final response = await _dio.put(path, data: data);
    if (response.data is Map<String, dynamic>) {
      return response.data as Map<String, dynamic>;
    }
    return {'success': true, 'data': response.data};
  }

  /// DELETE
  Future<Map<String, dynamic>> delete(String path) async {
    final response = await _dio.delete(path);
    if (response.data is Map<String, dynamic>) {
      return response.data as Map<String, dynamic>;
    }
    return {'success': true, 'data': response.data};
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
