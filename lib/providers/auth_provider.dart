import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/network/api_client.dart';
import '../core/network/api_endpoints.dart';
import '../data/models/user.dart';
import 'repository_providers.dart';

enum AuthStatus { initial, authenticated, unauthenticated, loading }

class AuthState {
  final AuthStatus status;
  final SelfPacedUser? user;
  final String? token;
  final String? error;
  final bool isFacilitator;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.token,
    this.error,
    this.isFacilitator = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    SelfPacedUser? user,
    String? token,
    String? error,
    bool? isFacilitator,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      token: token ?? this.token,
      error: error ?? this.error,
      isFacilitator: isFacilitator ?? this.isFacilitator,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final ApiClient _api;

  AuthNotifier(this._api) : super(const AuthState());

  Future<bool> loginSelfPaced(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);
    try {
      final response = await _api.post(ApiEndpoints.selfPacedLogin, data: {
        'email': email,
        'password': password,
      });
      // ignore: avoid_print
      print('[Auth] login response keys: ${response.keys.toList()}');
      if (response['success'] == true) {
        return _parseAuthResponse(response);
      }
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        error: response['error']?.toString() ?? 'Login failed',
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        error: e.toString(),
      );
      return false;
    }
  }

  Future<bool> registerSelfPaced(String email, String password, String displayName,
      {String? teamName, String? voucherCode}) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);
    try {
      final data = <String, dynamic>{
        'email': email,
        'password': password,
        'displayName': displayName,
      };
      if (teamName != null) data['teamName'] = teamName;
      if (voucherCode != null && voucherCode.isNotEmpty) data['voucherCode'] = voucherCode;
      final response = await _api.post(ApiEndpoints.selfPacedRegister, data: data);
      // ignore: avoid_print
      print('[Auth] register response keys: ${response.keys.toList()}');
      if (response['success'] == true) {
        // Register response includes token + user (same structure as login)
        return _parseAuthResponse(response);
      }
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        error: response['error']?.toString() ?? 'Registration failed',
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Shared parser for login/register responses: { success, token, user: {...} }
  bool _parseAuthResponse(Map<String, dynamic> response) {
    try {
      // ignore: avoid_print
      print('[Auth] full response: $response');

      // Backend returns token + user at top level (no 'data' wrapper)
      // Safely extract user data from ANY response format
      Map<String, dynamic>? userData;

      // Try top-level 'user'
      final userField = response['user'];
      if (userField is Map<String, dynamic>) {
        userData = userField;
      } else if (userField is Map) {
        userData = Map<String, dynamic>.from(userField);
      }

      // Fallback: try response['data']['user']
      if (userData == null) {
        final dataField = response['data'];
        if (dataField is Map) {
          final nested = dataField['user'];
          if (nested is Map<String, dynamic>) {
            userData = nested;
          } else if (nested is Map) {
            userData = Map<String, dynamic>.from(nested);
          }
        }
      }

      // Fallback: try response['data'] directly as user data
      if (userData == null) {
        final dataField = response['data'];
        if (dataField is Map<String, dynamic> && dataField.containsKey('email')) {
          userData = dataField;
        } else if (dataField is Map && dataField.containsKey('email')) {
          userData = Map<String, dynamic>.from(dataField);
        }
      }

      // Last resort: if the response itself looks like user data (has email field)
      if (userData == null && response.containsKey('email')) {
        userData = response;
      }

      if (userData == null) {
        // ignore: avoid_print
        print('[Auth] ERROR: no user data found. keys=${response.keys.toList()}, '
            'user type=${response['user']?.runtimeType}, '
            'data type=${response['data']?.runtimeType}');
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          error: 'Invalid server response (no user data)',
        );
        return false;
      }

      final user = SelfPacedUser.fromJson(userData);

      // Extract token from either top-level or nested 'data'
      String? token;
      if (response['token'] is String) {
        token = response['token'] as String;
      } else if (response['data'] is Map) {
        final t = (response['data'] as Map)['token'];
        if (t is String) token = t;
      }

      if (token != null) _api.setAuthToken(token);
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        token: token,
      );
      return true;
    } catch (e) {
      // ignore: avoid_print
      print('[Auth] ERROR parsing auth response: $e');
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        error: 'Failed to parse server response: $e',
      );
      return false;
    }
  }

  Future<bool> loginFacilitator(String password) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);
    try {
      final response = await _api.post(ApiEndpoints.facilitatorAuth, data: {
        'password': password,
      });
      if (response['success'] == true) {
        // Attach the password to every later facilitator-gated request.
        _api.setFacilitatorPassword(password);
        state = state.copyWith(
          status: AuthStatus.authenticated,
          isFacilitator: true,
        );
        return true;
      }
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        error: response['error'] as String? ?? 'Invalid password',
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        error: e.toString(),
      );
      return false;
    }
  }

  void logout() {
    _api.clearAuthToken();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(apiClientProvider));
});
