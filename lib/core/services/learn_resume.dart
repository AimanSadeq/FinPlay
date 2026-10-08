import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/auth_provider.dart';
import 'education_progress_sync.dart';

// The resume model and store live in education_progress_sync.dart (which must not
// depend on the auth provider); re-exported here as the public resume API.
export 'education_progress_sync.dart' show LearnResume, LearnResumeStore;

/// Convenience for screens: save the slide locally and, for a self-paced
/// learner, schedule a debounced progress sync that carries `__resume`.
class LearnResumeRecorder {
  LearnResumeRecorder(this.moduleKey);

  final String moduleKey;
  Timer? _debounce;

  /// Resolve the scope for the signed-in user. Reads [ref] before any await.
  static Future<String> scopeOf(WidgetRef ref) async {
    final auth = ref.read(authProvider);
    final isSelfPaced = auth.user != null && !auth.isFacilitator;
    final prefs = await SharedPreferences.getInstance();
    return LearnResumeStore.scopeFor(isSelfPaced: isSelfPaced, prefs: prefs);
  }

  /// The section id to reopen at, or null.
  Future<String?> restore(WidgetRef ref) async {
    final scope = await scopeOf(ref);
    return (await LearnResumeStore.get(scope, moduleKey))?.sectionId;
  }

  /// Save the slide; for a self-paced learner also schedule the sync. Every
  /// [ref] read happens before the first await, so a swipe followed by an
  /// immediate pop never touches a disposed ref.
  Future<void> record(WidgetRef ref, String sectionId) async {
    final auth = ref.read(authProvider);
    final sync = ref.read(educationProgressSyncProvider);
    final isSelfPaced = auth.user != null && !auth.isFacilitator;
    final identity = EducationProgressSync.progressIdentity(
      isFacilitator: auth.isFacilitator,
      isSelfPaced: isSelfPaced,
      email: auth.user?.email,
    );
    final prefs = await SharedPreferences.getInstance();
    final scope = LearnResumeStore.scopeFor(isSelfPaced: isSelfPaced, prefs: prefs);
    await LearnResumeStore.save(scope, moduleKey, sectionId);
    // Corporate resume stays per-device (website parity); only a self-paced
    // identity pushes `__resume`.
    if (!isSelfPaced || identity == null) return;
    _debounce?.cancel();
    _pending = () => sync.sync(teamName: identity.teamName, scope: identity.scope);
    _debounce = Timer(const Duration(seconds: 3), () {
      final p = _pending;
      _pending = null;
      p?.call();
    });
  }

  Future<bool> Function()? _pending;

  /// Cancels the debounce but still flushes a pending sync, so leaving the
  /// screen right after a slide change keeps the cross-device position.
  void dispose() {
    _debounce?.cancel();
    final p = _pending;
    _pending = null;
    p?.call();
  }
}
