import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/network/api_client.dart';
import '../core/network/api_endpoints.dart';
import '../core/utils/constants.dart';
import '../data/models/user.dart';
import '../app/router/app_router.dart';
import 'repository_providers.dart';
import 'self_paced_provider.dart';

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
  final Ref _ref;

  AuthNotifier(this._api, this._ref) : super(const AuthState()) {
    // Force a self-paced sign-out when the server rejects our token (401).
    _api.onUnauthorized = _handleUnauthorized;
  }

  static const _userKey = 'self_paced_user';
  bool _handlingUnauthorized = false;

  /// A 401 on an authenticated request means our session is expired/revoked.
  /// Sign the self-paced user out and bounce to login (website parity). Ignored
  /// for corporate/facilitator sessions (no self-paced user).
  void _handleUnauthorized() {
    if (_handlingUnauthorized || state.user == null) return;
    _handlingUnauthorized = true;
    logout().whenComplete(() => _handlingUnauthorized = false);
    AppRouter.router.go('/self-paced-login');
  }

  /// Persist the self-paced session so the user stays signed in across relaunches
  /// (website parity — it keeps the token + user in localStorage).
  Future<void> _persistSession(String? token, SelfPacedUser user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (token != null) await prefs.setString(AppConstants.selfPacedTokenKey, token);
      await prefs.setString(_userKey, jsonEncode(user.toJson()));
    } catch (_) {/* non-critical */}
  }

  /// Restore a saved self-paced session on app launch. Returns true if a session
  /// was restored. Trusts the stored token (the website does the same).
  Future<bool> restoreSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.selfPacedTokenKey);
      final userJson = prefs.getString(_userKey);
      if (token == null || token.isEmpty || userJson == null) return false;
      final user = SelfPacedUser.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
      _api.setAuthToken(token);
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        token: token,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> loginSelfPaced(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);
    try {
      final response = await _api.post(ApiEndpoints.selfPacedLogin, data: {
        'email': email,
        'password': password,
      });
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
      _persistSession(token, user); // keep the user signed in across relaunches
      return true;
    } catch (e) {
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

  /// Clear only the transient error (e.g. when toggling between login/register).
  void clearError() {
    if (state.error != null) state = state.copyWith(error: null);
  }

  /// Full sign-out (website parity): invalidate the server session, clear the
  /// stored token + user, drop the in-memory header, and reset self-paced state.
  Future<void> logout() async {
    // Best-effort server-side session invalidation (don't block on failure).
    try {
      await _ref.read(authRepositoryProvider).logout();
    } catch (_) {/* ignore */}
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.selfPacedTokenKey);
      await prefs.remove(_userKey);
    } catch (_) {/* ignore */}
    _api.clearAuthToken();
    _api.clearFacilitatorPassword();
    // Reset any cached self-paced progress so it can't bleed into a next session.
    _ref.invalidate(selfPacedProvider);
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(apiClientProvider), ref);
});
