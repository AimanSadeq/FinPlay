import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';

/// Outcome of POST /self-paced/delete-account.
enum DeleteAccountStatus {
  /// 200: the account is gone server-side; the caller must clear the local session.
  success,

  /// 401 `INVALID_PASSWORD`: the learner stays signed in.
  wrongPassword,

  /// 403 `DEMO_ACCOUNT`: the shared demo account cannot be deleted.
  demoAccount,

  /// 401 without `INVALID_PASSWORD`: the session itself is no longer valid.
  notSignedIn,

  /// 429: too many attempts.
  rateLimited,

  /// 400 / 5xx / network / anything unexpected.
  error,
}

class DeleteAccountResult {
  final DeleteAccountStatus status;

  /// Server-provided message, when there was one (only meaningful for [DeleteAccountStatus.error]).
  final String? message;

  const DeleteAccountResult(this.status, {this.message});

  bool get isSuccess => status == DeleteAccountStatus.success;

  /// Map an HTTP status + JSON body to a result. Pure, so it is unit-testable.
  static DeleteAccountResult fromResponse(int? statusCode, Object? body) {
    final map = body is Map ? body : const {};
    final code = map['code']?.toString();
    final error = map['error']?.toString() ?? map['message']?.toString();
    if (statusCode != null && statusCode >= 200 && statusCode < 300) {
      // A 2xx is only a success when the server says so (guards against an HTML
      // SPA fallback page if the route is missing on this host).
      return map['success'] == true
          ? const DeleteAccountResult(DeleteAccountStatus.success)
          : DeleteAccountResult(DeleteAccountStatus.error, message: error);
    }
    switch (statusCode) {
      case 401:
        return code == 'INVALID_PASSWORD'
            ? const DeleteAccountResult(DeleteAccountStatus.wrongPassword)
            : const DeleteAccountResult(DeleteAccountStatus.notSignedIn);
      case 403:
        return code == 'DEMO_ACCOUNT'
            ? const DeleteAccountResult(DeleteAccountStatus.demoAccount)
            : DeleteAccountResult(DeleteAccountStatus.error, message: error);
      case 429:
        return const DeleteAccountResult(DeleteAccountStatus.rateLimited);
      default:
        return DeleteAccountResult(DeleteAccountStatus.error, message: error);
    }
  }
}

class AuthRepository {
  final ApiClient _api;

  AuthRepository(this._api);

  Future<Map<String, dynamic>> loginSelfPaced(String email, String password) async {
    final response = await _api.post(ApiEndpoints.selfPacedLogin, data: {
      'email': email,
      'password': password,
    });
    return response;
  }

  /// "Try Demo": the server owns the demo learner and signs it in
  /// (POST /self-paced/demo-login, no body). Same { success, token, user }
  /// shape as a login, so the session is stored the same way.
  Future<Map<String, dynamic>> demoLogin() async {
    return _api.post(ApiEndpoints.selfPacedDemoLogin);
  }

  /// Step 1 of verified sign-up: email a 6-digit verification code.
  Future<Map<String, dynamic>> requestVerification(String email) async {
    return _api.post(ApiEndpoints.selfPacedRequestVerification, data: {'email': email});
  }

  /// Step 2 of verified sign-up. The server derives displayName from
  /// "$firstName $lastName" and requires the emailed [verificationCode].
  Future<Map<String, dynamic>> registerSelfPaced({
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
    return response;
  }

  Future<void> forgotPassword(String email) async {
    // Use /self-paced/forgot-password (the real endpoint). The previous
    // /password-reset path returned the SPA 404 page, so no email was sent.
    final res = await _api.post(ApiEndpoints.selfPacedForgotPassword, data: {
      'email': email,
    });
    if (res['success'] != true) {
      throw Exception(res['error'] ?? 'Could not send reset instructions');
    }
  }

  /// Complete a password reset with the token from the email link.
  Future<Map<String, dynamic>> resetPassword({
    required String token,
    required String password,
  }) async {
    return _api.post(ApiEndpoints.selfPacedResetPassword, data: {
      'token': token,
      'password': password,
    });
  }

  Future<void> logout() async {
    await _api.post(ApiEndpoints.selfPacedLogout);
  }

<<<<<<< Updated upstream
  // There is no site-access password on the website; the /site-access/* gate
  // this repository used to call never existed on the server and could never
  // block sign-in. The website's only entry gate is the corporate simulation
  // gate (GET/POST /facilitator/simulation-access), which the simulation
  // screen enforces through FacilitatorRepository.fetchSimulationAccess.
=======
  /// Permanently delete the signed-in self-paced account (Apple 5.1.1(v)).
  ///
  /// Goes through Dio directly (not [ApiClient.post]) because the outcome depends
  /// on the HTTP status, which `post` drops. The request is flagged so that:
  /// - a 401 (wrong password) does NOT fire the global sign-out handler, and
  /// - a 5xx is never auto-retried (deleting is not idempotent).
  Future<DeleteAccountResult> deleteAccount(String password) async {
    try {
      final res = await _api.dio.post(
        ApiEndpoints.selfPacedDeleteAccount,
        data: {'password': password},
        options: Options(extra: {
          skipUnauthorizedHandlerExtra: true,
          noRetryExtra: true,
        }),
      );
      return DeleteAccountResult.fromResponse(res.statusCode, res.data);
    } on DioException catch (e) {
      final r = e.response;
      if (r == null) {
        return const DeleteAccountResult(DeleteAccountStatus.error);
      }
      return DeleteAccountResult.fromResponse(r.statusCode, r.data);
    } catch (_) {
      return const DeleteAccountResult(DeleteAccountStatus.error);
    }
  }

  /// "Try Demo": the server owns the demo learner (POST /self-paced/demo-login,
  /// no body) and signs it in, provisioning it on first use. Returns the same
  /// { success, token, user, entitlement } shape as a normal login.
  Future<Map<String, dynamic>> demoLogin() async {
    return _api.post(ApiEndpoints.selfPacedDemoLogin);
  }

  /// Pre-check an access code on the sign-up form. POST /vouchers/validate ->
  /// { valid, reason?, accessDays? } — accessDays is the access period the code
  /// grants (null for a code that only admits).
  Future<({bool valid, String? reason, int? accessDays})> validateVoucher(
      String code) async {
    try {
      final res = await _api.post(ApiEndpoints.vouchersValidate, data: {'code': code});
      return (
        valid: res['valid'] == true,
        reason: res['reason']?.toString(),
        accessDays: (res['accessDays'] as num?)?.toInt(),
      );
    } catch (_) {
      return (valid: false, reason: null, accessDays: null);
    }
  }
>>>>>>> Stashed changes
}
