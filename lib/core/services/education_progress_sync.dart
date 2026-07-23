import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/api_client.dart';
import '../network/api_endpoints.dart';
import '../../providers/repository_providers.dart';

/// Cross-device education progress (website parity with `hydrateProgressFromServer`
/// / `syncProgressToDatabase` in client/src/lib/educationProgress.ts).
///
/// Until now the app kept module progress only in SharedPreferences, so a learner
/// who studied on the website — or on another phone — started from zero here.
/// This service pulls the database copy written by either client and pushes the
/// local copy back, keyed the same way the website keys it:
///   * self-paced learners → their email (needs the bearer token)
///   * corporate teams     → "Team 1".."Team 7" (no token; lobby sign-in gates it)
///
/// Conflict rule mirrors the website: per module the SERVER wins only when its
/// score is HIGHER than the local one, so fresher local work is never downgraded.
class EducationProgressSync {
  EducationProgressSync(this._api);

  final ApiClient _api;

  /// Content modules the hub tracks (11 + 12 are calculators, no scored work).
  static const List<int> contentModules = [1, 2, 3, 4, 6, 7, 9, 10];

  /// Must match MODULE_MAX_SCORES in server/routes/education-modules.ts — the
  /// server clamps to these, and the website derives its % from them.
  static const Map<int, int> moduleMaxScores = {
    1: 225,
    2: 400,
    3: 375,
    4: 375,
    6: 400,
    7: 375,
    9: 400,
    10: 400,
  };

  static const double passThreshold = 0.7; // 70%, same as the server

  /// The four activities a mobile module tracks. Pushed under these ids so a
  /// device switch restores them exactly; the website ignores unknown ids and
  /// reads the module score instead.
  static const List<String> activities = ['learn', 'game', 'quiz', 'sim'];

  static String _moduleKey(int n) => 'module$n';

  /// Pref key used by gov_module_screen: `gov_module_<scope>_<moduleId>_<activity>`.
  static String _prefKey(String scope, int module, String activity) =>
      'gov_module_${scope}_${module}_$activity';

  /// Badge ids restored from the server, echoed back on push so a mobile sync
  /// never wipes badges the learner earned on the website.
  static String _badgeKey(int module) => 'edu_badges_$module';

  /// Pull the server copy, then push the (possibly newer) local copy back.
  /// One GET + one POST. Returns true when local prefs changed, so callers can
  /// recompute their derived state.
  Future<bool> sync({required String teamName, required String scope}) async {
    final saved = await _fetchSaved(teamName);
    final changed = saved == null
        ? false
        : await _applyToLocal(saved, scope: scope);
    await _push(teamName, scope: scope, serverModules: saved ?? const {});
    return changed;
  }

  /// Restore only — used right after login, before any screen reads prefs.
  Future<bool> hydrate({required String teamName, required String scope}) async {
    final saved = await _fetchSaved(teamName);
    if (saved == null) return false;
    return _applyToLocal(saved, scope: scope);
  }

  // ── server → local ────────────────────────────────────────────────────────

  /// GET /education/progress/{teamName}/saved -> { data: { modules: {...} } }.
  /// Returns null when the call fails (offline, 401) so callers leave local
  /// progress untouched rather than treating "no answer" as "no progress".
  Future<Map<String, dynamic>?> _fetchSaved(String teamName) async {
    try {
      final res = await _api.get(
        ApiEndpoints.educationProgressSaved
            .replaceFirst('{teamName}', Uri.encodeComponent(teamName)),
      );
      if (res['success'] != true) return null;
      final data = res['data'];
      if (data is! Map) return null;
      final modules = data['modules'];
      if (modules is! Map) return {};
      return Map<String, dynamic>.from(modules);
    } catch (_) {
      return null; // non-critical: the learner keeps working from local prefs
    }
  }

  Future<bool> _applyToLocal(
    Map<String, dynamic> serverModules, {
    required String scope,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    var changed = false;

    for (final n in contentModules) {
      final entry = serverModules[_moduleKey(n)];
      if (entry is! Map) continue;

      final maxScore = moduleMaxScores[n]!;
      final serverScore = (entry['moduleScore'] as num?)?.toInt() ?? 0;
      final serverPercent = ((serverScore / maxScore) * 100).round().clamp(0, 100);
      final localPercent = prefs.getInt('edu_progress_$n') ?? 0;

      // Badges are worth keeping even when the score isn't ahead — they're only
      // ever additive, and we echo them back on the next push.
      final badges = (entry['badges'] as List?)?.map((b) => b.toString()).toList();
      if (badges != null && badges.isNotEmpty) {
        await prefs.setStringList(_badgeKey(n), badges);
      }

      if (serverPercent <= localPercent) continue; // local is fresher — keep it

      final activityData = entry['activityData'] is Map
          ? Map<String, dynamic>.from(entry['activityData'] as Map)
          : <String, dynamic>{};
      final completed = entry['completed'] == true ||
          serverScore >= maxScore * passThreshold;

      // Learn completion rides in `__meta` (website writes it there so it
      // survives a device switch); a mobile-origin record also has a real
      // 'learn' activity entry.
      final meta = activityData['__meta'];
      var learnDone = prefs.getBool(_prefKey(scope, n, 'learn')) ?? false;
      if (meta is Map && meta['completed'] == true) learnDone = true;

      for (final activity in activities) {
        final a = activityData[activity];
        if (a is Map) {
          // Mobile-origin record: restore the flag and its score verbatim.
          final done = a['completed'] == true;
          if (activity == 'learn') {
            learnDone = learnDone || done;
          } else {
            await prefs.setBool(_prefKey(scope, n, activity), done);
            final score = (a['score'] as num?)?.toInt();
            if (score != null) {
              await prefs.setInt(_prefKey(scope, n, '${activity}Score'), score);
            }
          }
        } else if (completed && activity != 'learn') {
          // Website-origin record with its own activity ids: we can't map them
          // one-to-one, but a passed module means the work was done.
          await prefs.setBool(_prefKey(scope, n, activity), true);
        }
      }
      await prefs.setBool(_prefKey(scope, n, 'learn'), learnDone);

      await prefs.setInt('edu_progress_$n', serverPercent);
      await prefs.setBool('edu_passed_$n', completed);
      changed = true;
    }

    return changed;
  }

  // ── local → server ────────────────────────────────────────────────────────

  /// POST /education/progress/{teamName}/sync. Only modules where the local
  /// score is ahead of the server's are sent: the server replaces activityData
  /// wholesale, so pushing a module we haven't advanced would flatten the
  /// website's finer-grained per-activity records for no gain.
  Future<void> _push(
    String teamName, {
    required String scope,
    required Map<String, dynamic> serverModules,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final modules = <String, dynamic>{};
      final allBadges = <String>{};

      for (final n in contentModules) {
        final maxScore = moduleMaxScores[n]!;
        final flags = {
          for (final a in activities)
            a: prefs.getBool(_prefKey(scope, n, a)) ?? false,
        };
        final doneCount = flags.values.where((v) => v).length;
        // The hub's stored % is authoritative; fall back to the four activities.
        final localPercent =
            prefs.getInt('edu_progress_$n') ?? (doneCount * 25);
        if (localPercent <= 0) continue;

        final badges = prefs.getStringList(_badgeKey(n)) ?? const <String>[];
        allBadges.addAll(badges);

        final serverEntry = serverModules[_moduleKey(n)];
        final serverScore = serverEntry is Map
            ? ((serverEntry['moduleScore'] as num?)?.toInt() ?? 0)
            : 0;
        final localScore = ((localPercent / 100) * maxScore).round();
        if (localScore <= serverScore) continue; // nothing new to contribute

        final activityData = <String, dynamic>{};
        for (final a in activities) {
          if (a == 'learn') continue; // carried by __meta below
          activityData[a] = {
            'score': prefs.getInt(_prefKey(scope, n, '${a}Score')) ?? 0,
            'maxScore': 0,
            'completed': flags[a],
          };
        }
        activityData['__meta'] = {
          'score': 0,
          'maxScore': 0,
          'completed': flags['learn'],
        };

        modules[_moduleKey(n)] = {
          'totalScore': localScore,
          'badges': badges,
          'activityData': activityData,
        };
      }

      if (modules.isEmpty) return;

      await _api.post(
        ApiEndpoints.educationProgressSync
            .replaceFirst('{teamName}', Uri.encodeComponent(teamName)),
        data: {'modules': modules, 'totalBadges': allBadges.toList()},
      );
    } catch (_) {
      // Non-critical: local prefs stay the source of truth until the next sync.
    }
  }
}

final educationProgressSyncProvider = Provider<EducationProgressSync>(
  (ref) => EducationProgressSync(ref.watch(apiClientProvider)),
);
