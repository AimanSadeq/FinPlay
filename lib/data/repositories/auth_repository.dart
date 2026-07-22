import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';

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

  Future<Map<String, dynamic>> getProfile() async {
    final response = await _api.get(ApiEndpoints.selfPacedProfile);
    return response;
  }

  Future<void> logout() async {
    await _api.post(ApiEndpoints.selfPacedLogout);
  }

  /// Verify the site-access password. Returns the full response so callers can
  /// branch on `isFacilitator` (the website auto-logs the facilitator in when the
  /// entered code is the admin password).
  Future<Map<String, dynamic>> verifySiteAccess(String password) async {
    return _api.post(ApiEndpoints.siteAccessVerify, data: {
      'password': password,
    });
  }

  Future<bool> validateSiteAccess(String password) async {
    final response = await verifySiteAccess(password);
    return response['success'] == true;
  }

  Future<Map<String, dynamic>> checkSiteAccess() async {
    return _api.get(ApiEndpoints.siteAccessCheck);
  }

  /// Whether the facilitator has enabled the global site-access password gate.
  /// Best-effort: returns false if the status cannot be fetched.
  Future<bool> isSiteAccessEnabled() async {
    try {
      final res = await checkSiteAccess();
      return res['enabled'] == true;
    } catch (_) {
      return false;
    }
  }
}
