import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/utils/constants.dart';

/// The stored self-paced session token. Self-paced calls send it explicitly instead of
/// relying on ApiClient's shared Authorization header, which holds whichever token was set
/// last (a device can also hold a corporate team-member token).
Future<String?> readSelfPacedBearer() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final t = prefs.getString(AppConstants.selfPacedTokenKey);
    return (t == null || t.trim().isEmpty) ? null : t;
  } catch (_) {
    return null;
  }
}
