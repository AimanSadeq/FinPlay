import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/repository_providers.dart';

/// The signed-in self-paced learner's billing plan ('trial', 'voucher',
/// 'self_paced', 'student', 'comp', 'demo'), or null when unknown / not a
/// self-paced learner.
///
/// Only GET /self-paced/me carries `plan` (login and register do not), so this
/// reads /me whenever the signed-in learner changes and caches the answer per
/// email, the way the website keeps it in its selfPacedUser blob. The cache
/// means a demo account's unlocks and the lapsed-access wording are right on
/// the first frame of the next launch, before /me answers.
class SelfPacedPlanNotifier extends StateNotifier<String?> {
  SelfPacedPlanNotifier(this._ref, this._email, String? initial) : super(initial) {
    if (_email != null && _email.isNotEmpty) {
      if (initial == null) _loadCached();
      refresh();
    }
  }

  final Ref _ref;
  final String? _email;

  String get _cacheKey => 'self_paced_plan_$_email';

  Future<void> _loadCached() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString(_cacheKey);
      if (cached != null && mounted && state == null) state = cached;
    } catch (_) {/* cache is best-effort */}
  }

  /// Re-read the plan from /self-paced/me. Fail-quiet: keeps the last known
  /// value on any error.
  Future<void> refresh() async {
    if (_email == null || _email.isEmpty) return;
    try {
      final res = await _ref.read(selfPacedRepositoryProvider).fetchMe();
      final user = res['user'];
      if (user is! Map || !user.containsKey('plan')) return;
      final plan = user['plan']?.toString();
      if (!mounted) return;
      state = plan;
      final prefs = await SharedPreferences.getInstance();
      if (plan == null) {
        await prefs.remove(_cacheKey);
      } else {
        await prefs.setString(_cacheKey, plan);
      }
    } catch (_) {/* keep the last known plan */}
  }
}

final selfPacedPlanProvider =
    StateNotifierProvider<SelfPacedPlanNotifier, String?>((ref) {
  final auth = ref.watch(authProvider.select(
      (a) => (email: a.isFacilitator ? null : a.user?.email, plan: a.user?.plan)));
  return SelfPacedPlanNotifier(ref, auth.email, auth.plan);
});

/// A business-development demo account (website isDemoAccount()): every earned
/// lock — module chain, module tabs, simulation tile — is lifted.
final isDemoAccountProvider = Provider<bool>((ref) {
  return ref.watch(selfPacedPlanProvider) == 'demo';
});
