import 'dart:convert';
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/network/api_client.dart';
import '../core/network/api_endpoints.dart';
import '../core/services/education_progress_sync.dart';
import '../core/utils/constants.dart';
import '../data/models/user.dart';
import '../data/repositories/auth_repository.dart';
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
      await prefs.setString(_userKey, jsonEncode(user.toStorageJson()));
    } catch (_) {/* non-critical */}
  }

  /// Adopt a session the server issued outside [loginSelfPaced] (the demo
  /// sign-in): persist it like a login and mark the user signed in.
  Future<void> adoptSession(String token, SelfPacedUser user) async {
    await _persistSession(token, user);
    _api.setAuthToken(token);
    state = state.copyWith(status: AuthStatus.authenticated, user: user, token: token);
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
        final ok = _parseAuthResponse(response);
        // Cross-device parity: pull server-side progress on login so work
        // follows the learner across devices (website hydrates on login too).
        if (ok) _hydrateProgress();
        return ok;
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

  /// "Try Demo": POST /self-paced/demo-login provisions and signs in the demo
  /// learner (demo-player@vifm.com) and returns the same { success, token,
  /// user } payload as a login, so the session is stored and hydrated the same
  /// way. The demo account has no usable password, so this is the only way in.
  Future<bool> loginDemo() async {
    state = state.copyWith(status: AuthStatus.loading, error: null);
    try {
      final response = await _api.post(ApiEndpoints.selfPacedDemoLogin);
      if (response['success'] == true) {
        final ok = _parseAuthResponse(response);
        if (ok) _hydrateProgress();
        return ok;
      }
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        error: response['error']?.toString() ?? 'Could not start the demo',
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

  /// Fire-and-forget: refresh the self-paced game progress from the server after
  /// a login so a fresh device shows the learner's saved round/module + decisions.
  void _hydrateProgress() {
    try {
      _ref.read(selfPacedProvider.notifier).fetchProgress();
    } catch (_) {/* non-critical; the self-paced screens also hydrate */}
    // Education modules live in their own store — restore them too, keyed by
    // email like the website, so a fresh device opens the hub already caught up.
    final email = state.user?.email;
    if (email != null && email.isNotEmpty) {
      EducationProgressSync(_api).hydrate(teamName: email, scope: 'sp');
    }
  }

  /// Step 1 of verified sign-up (website parity): request a 6-digit code emailed
  /// to [email]. Returns true when the server confirms the code was sent. On
  /// failure the reason (invalid email, already registered, resend cooldown,
  /// email service down) is surfaced via [state.error].
  Future<bool> requestVerification(String email) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);
    try {
      final response = await _api.post(
        ApiEndpoints.selfPacedRequestVerification,
        data: {'email': email},
      );
      if (response['success'] == true) {
        state = state.copyWith(status: AuthStatus.unauthenticated, error: null);
        return true;
      }
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        error: response['error']?.toString() ?? 'Could not send verification code',
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

  /// Step 2 of verified sign-up: create the account with the emailed
  /// [verificationCode]. The server derives displayName as "$firstName $lastName".
  Future<bool> registerSelfPaced({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String title,
    required String company,
    required String phone,
    required String city,
    required String verificationCode,
    String? voucherCode,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);
    try {
      final data = <String, dynamic>{
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'title': title,
        'company': company,
        'phone': phone,
        'city': city,
        'verificationCode': verificationCode,
      };
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

  /// Leave the facilitator console: drop the password header and the
  /// facilitator flag, keeping any self-paced learner session on the device.
  void logoutFacilitator() {
    _api.clearFacilitatorPassword();
    state = state.copyWith(
      isFacilitator: false,
      status: state.user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated,
    );
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
    await _clearLocalSession();
  }

  /// The local half of [logout]: stored token + user, in-memory headers, cached
  /// self-paced progress/entitlement, and the auth state.
  Future<void> _clearLocalSession() async {
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

  /// Permanently delete the signed-in self-paced account (Apple 5.1.1(v)).
  ///
  /// The password is re-checked by the server. On success the session is
  /// cleared exactly like [logout] (without the server logout call: the token
  /// is already dead) and this learner's on-device data is wiped too. On a
  /// wrong password, demo account, rate limit or error the learner stays
  /// signed in. A 401 that is not a wrong password means the session expired:
  /// the learner is signed out locally so they can sign in again.
  Future<DeleteAccountResult> deleteAccount(String password) async {
    final user = state.user;
    if (user == null || state.isFacilitator) {
      return const DeleteAccountResult(DeleteAccountStatus.notSignedIn);
    }
    if (password.isEmpty) {
      return const DeleteAccountResult(DeleteAccountStatus.wrongPassword);
    }
    final DeleteAccountResult result;
    try {
      result = await _ref.read(authRepositoryProvider).deleteAccount(password);
    } catch (_) {
      return const DeleteAccountResult(DeleteAccountStatus.error);
    }
    switch (result.status) {
      case DeleteAccountStatus.success:
        // Drop the bearer and the user first, so any request still in flight
        // that now 401s cannot trigger the expired-session redirect.
        _api.clearAuthToken();
        state = const AuthState(status: AuthStatus.unauthenticated);
        try {
          final prefs = await SharedPreferences.getInstance();
          await clearDeletedUserData(prefs, email: user.email);
        } catch (_) {/* best-effort */}
        await _clearLocalSession();
      case DeleteAccountStatus.notSignedIn:
        await _clearLocalSession();
      case DeleteAccountStatus.wrongPassword:
      case DeleteAccountStatus.demoAccount:
      case DeleteAccountStatus.rateLimited:
      case DeleteAccountStatus.error:
        break;
    }
    return result;
  }

  /// Remove what this device stored for a self-paced learner whose account was
  /// just deleted. Corporate (team-scoped) progress and device settings
  /// (language, theme, corporate access code, cohort host, narration) stay.
  ///
  /// - `edu_module_sp_*`, `edu_resume_sp_*`, `edu_tool_visited_sp_*`: the
  ///   self-paced education scope (activities, resume positions, tool visits).
  /// - `edu_progress_*`, `edu_passed_*`, `edu_badges_*`: the hub's roll-up
  ///   mirror, last written by whichever scope was active; the corporate scope
  ///   rebuilds it from its own `edu_module_<team>_*` keys and server sync.
  /// - `assessment_pre_score` / `assessment_post_score`: last local scores.
  /// - `self_paced_plan_<email>`: cached billing plan.
  @visibleForTesting
  static Future<void> clearDeletedUserData(SharedPreferences prefs,
      {required String email}) async {
    const prefixes = [
      'edu_module_sp_',
      'edu_resume_sp_',
      'edu_tool_visited_sp_',
      'edu_progress_',
      'edu_passed_',
      'edu_badges_',
    ];
    for (final k in prefs.getKeys().toList()) {
      if (prefixes.any(k.startsWith)) await prefs.remove(k);
    }
    await prefs.remove('assessment_pre_score');
    await prefs.remove('assessment_post_score');
    if (email.isNotEmpty) await prefs.remove('self_paced_plan_$email');
    await prefs.remove(AppConstants.selfPacedTokenKey);
    await prefs.remove(_userKey);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(apiClientProvider), ref);
});
