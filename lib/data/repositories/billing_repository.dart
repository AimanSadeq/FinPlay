import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../models/billing_plan.dart';
import '../models/entitlement.dart';

/// Self-paced subscription billing (MamoPay). The backend owns the payment; this client
/// fetches the plan catalog, starts a hosted-checkout link, and verifies/refreshes access.
/// All calls use the self-paced bearer token already set on ApiClient after login.
class BillingRepository {
  final ApiClient _api;
  BillingRepository(this._api);

  /// GET /billing/plans → { success, configured, currency, trialDays, plans: [...] }
  Future<({bool configured, String currency, int trialDays, List<BillingPlan> plans})>
      fetchPlans() async {
    final res = await _api.get(ApiEndpoints.billingPlans);
    final rawPlans = res['plans'];
    final plans = rawPlans is List
        ? rawPlans
            .whereType<Map>()
            .map((e) => BillingPlan.fromJson(Map<String, dynamic>.from(e)))
            .toList()
        : <BillingPlan>[];
    return (
      configured: res['configured'] == true,
      currency: res['currency']?.toString() ?? 'AED',
      trialDays: (res['trialDays'] as num?)?.toInt() ?? 7,
      plans: plans,
    );
  }

  /// POST /billing/checkout { planId } → { success, paymentUrl, linkId }
  /// paymentUrl is Mamo's hosted page; open it in a WebView.
  Future<({bool success, String? paymentUrl, String? error})> createCheckout(String planId) async {
    final res = await _api.post(ApiEndpoints.billingCheckout, data: {'planId': planId});
    if (res['success'] == true && res['paymentUrl'] != null) {
      return (success: true, paymentUrl: res['paymentUrl'].toString(), error: null);
    }
    return (success: false, paymentUrl: null, error: res['error']?.toString());
  }

  /// POST /billing/verify → confirms the payment with Mamo and grants; returns entitlement.
  Future<Entitlement?> verify() async {
    final res = await _api.post(ApiEndpoints.billingVerify, data: {});
    final ent = res['entitlement'];
    return ent is Map ? Entitlement.fromJson(Map<String, dynamic>.from(ent)) : null;
  }

  /// GET /billing/status → current entitlement (used to poll after a webhook grant).
  Future<Entitlement?> status() async {
    final res = await _api.get(ApiEndpoints.billingStatus);
    final ent = res['entitlement'];
    return ent is Map ? Entitlement.fromJson(Map<String, dynamic>.from(ent)) : null;
  }
}
