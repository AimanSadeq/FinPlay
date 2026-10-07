import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/education_catalog.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';
import '../../providers/repository_providers.dart';
import 'education_storage_migration.dart';

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
///
/// One exception: ids that EducationStorageMigration marked provisional (local
/// progress that came from a position-to-id remap and may belong to another
/// module). Those are never pushed, and on the next pull the server record
/// replaces the local one even when local is ahead, after which the id is no
/// longer provisional. When the server has no record for a provisional id the
/// local value is left alone and stays provisional until the learner works on
/// that module in this app.
class EducationProgressSync {
  EducationProgressSync(this._api);

  final ApiClient _api;

  /// Content modules whose work is done in this app, by permanent catalog id
  /// (education_catalog.dart). Only these are pushed to the server.
  static final List<int> contentModules =
      inAppContentModules.map((m) => m.num).toList();

  /// Every scored content module, in-app or website-only. All of them are
  /// restored from the server so the hub shows website progress too.
  static final List<int> restoredModules =
      educationCatalog.where((m) => m.isContent).map((m) => m.num).toList();

  /// Must match MODULE_MAX_SCORES in server/routes/education-modules.ts — the
  /// server clamps to these, and the website derives its % from them.
  static const Map<int, int> moduleMaxScores = {
    1: 225,
    2: 275,
    3: 300,
    4: 325,
    5: 400,
    6: 300,
    7: 275,
    9: 300,
    10: 300,
    14: 300,
    15: 300,
    16: 300,
    17: 300,
    18: 300,
  };

  /// What the server grades a module against when MODULE_MAX_SCORES has no
  /// entry for it (`moduleMaxScore` in server/services/educationProgressMerge.ts
  /// falls back to 325). The library modules (ids 19 to 22) have no entry yet.
  static const int defaultModuleMaxScore = 325;

  /// The maximum score the server grades module [n] against.
  static int maxScoreFor(int n) => moduleMaxScores[n] ?? defaultModuleMaxScore;

  static const double passThreshold = 0.7; // 70%, same as the server

  /// The four activities a mobile module tracks. Pushed under these ids so a
  /// device switch restores them exactly; the website ignores unknown ids and
  /// reads the module score instead.
  static const List<String> activities = ['learn', 'game', 'quiz', 'sim'];

  /// Server progress key. Time Value of Money (id 5) is stored as `tvm` on the
  /// website; every other module is `module` followed by its catalog id.
  static String _moduleKey(int n) => n == 5 ? 'tvm' : 'module$n';

  /// Pref key used by edu_module_screen: `edu_module_` + scope + id + activity.
  static String _prefKey(String scope, int module, String activity) =>
      'edu_module_${scope}_${module}_$activity';

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
    final provisional = await EducationStorageMigration.provisionalIds(prefs);
    var changed = false;

    for (final n in restoredModules) {
      final entry = serverModules[_moduleKey(n)];
      // No server record: local stays as it is. A provisional id stays
      // provisional, since nothing has confirmed its remapped value yet.
      if (entry is! Map) continue;

      final maxScore = maxScoreFor(n);
      final serverScore = (entry['moduleScore'] as num?)?.toInt() ?? 0;
      final serverPercent = ((serverScore / maxScore) * 100).round().clamp(0, 100);
      final localPercent = prefs.getInt('edu_progress_$n') ?? 0;

      // Badges are worth keeping even when the score isn't ahead — they're only
      // ever additive, and we echo them back on the next push.
      final badges = (entry['badges'] as List?)?.map((b) => b.toString()).toList();
      if (badges != null && badges.isNotEmpty) {
        await prefs.setStringList(_badgeKey(n), badges);
      }

      // The server wins for a provisional id whatever the local value says:
      // that value may be another module's progress moved here by the
      // migration, and the server record is the only trustworthy copy.
      final serverWins = provisional.contains(n);
      if (!serverWins && serverPercent <= localPercent) {
        continue; // local is fresher — keep it
      }

      final activityData = entry['activityData'] is Map
          ? Map<String, dynamic>.from(entry['activityData'] as Map)
          : <String, dynamic>{};
      final completed = entry['completed'] == true ||
          serverScore >= maxScore * passThreshold;

      // Learn completion rides in `__meta` (website writes it there so it
      // survives a device switch); a mobile-origin record also has a real
      // 'learn' activity entry.
      final meta = activityData['__meta'];
      var learnDone = serverWins
          ? false
          : prefs.getBool(_prefKey(scope, n, 'learn')) ?? false;
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
        } else if (activity != 'learn' && (completed || serverWins)) {
          // Website-origin record with its own activity ids: we can't map them
          // one-to-one, but a passed module means the work was done. For a
          // provisional id an unpassed module also resets the remapped flags.
          await prefs.setBool(_prefKey(scope, n, activity), completed);
        }
      }
      await prefs.setBool(_prefKey(scope, n, 'learn'), learnDone);

      await prefs.setInt('edu_progress_$n', serverPercent);
      await prefs.setBool('edu_passed_$n', completed);
      if (serverWins) {
        await EducationStorageMigration.clearProvisional(prefs, n);
      }
      changed = true;
    }

    return changed;
  }

  // ── local → server ────────────────────────────────────────────────────────

  /// POST /education/progress/{teamName}/sync. Only modules where the local
  /// score is ahead of the server's are sent: the server replaces activityData
  /// wholesale, so pushing a module we haven't advanced would flatten the
  /// website's finer-grained per-activity records for no gain. Provisional ids
  /// (see the class doc) are never sent, however far ahead local looks.
  Future<void> _push(
    String teamName, {
    required String scope,
    required Map<String, dynamic> serverModules,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final provisional = await EducationStorageMigration.provisionalIds(prefs);
      final modules = <String, dynamic>{};
      final allBadges = <String>{};

      for (final n in contentModules) {
        if (provisional.contains(n)) continue; // unconfirmed remap: never push
        final maxScore = maxScoreFor(n);
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
