import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/education_catalog.dart';
import '../../features/education/modules/education_module_data.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';
import '../../providers/repository_providers.dart';
import 'education_storage_migration.dart';

/// "Resume at the last slide" (website parity with a2da32f:
/// `setLastViewedSection` / `getLastViewedSection` / `getLastActiveModule` in
/// client/src/lib/educationProgress.ts).
///
/// The position is stored as the slide's SECTION ID (e.g. `section-4-7`,
/// `section-be-3`), never as an index, so content edits between visits can never
/// land the learner on the wrong slide. Ids are the website's own, so a position
/// written on the website restores here and vice versa.
///
/// Storage is per progress scope (`sp` for a self-paced learner, the team id for
/// corporate), mirroring the module screen. Self-paced positions also ride the
/// progress sync as `activityData.__resume = {sectionId, at}`; corporate stays
/// per-device because team rows are shared (exactly as the website does).
class LearnResume {
  /// Progress key: `module<id>` for content modules, `tvm` for id 5, and
  /// `break-even` / `capital-budgeting` for the two workshop decks.
  final String moduleKey;
  final String sectionId;
  final DateTime at;

  const LearnResume({
    required this.moduleKey,
    required this.sectionId,
    required this.at,
  });

  /// Permanent catalog id of the module/deck (education_catalog.dart), or null
  /// for an unknown key.
  int? get catalogId => LearnResumeStore.catalogIdFor(moduleKey);

  /// ISO-8601 UTC, the same format the website writes (`new Date().toISOString()`).
  String get atIso => at.toUtc().toIso8601String();

  Map<String, dynamic> toJson() => {'sectionId': sectionId, 'at': atIso};

  @override
  String toString() => 'LearnResume($moduleKey, $sectionId, $atIso)';
}

class LearnResumeStore {
  LearnResumeStore._();

  static const String breakEvenKey = 'break-even';
  static const String capitalBudgetingKey = 'capital-budgeting';

  /// Website progress key for a catalog id (same rule as the progress sync).
  static String moduleKeyFor(int catalogId) => switch (catalogId) {
        5 => 'tvm',
        11 => breakEvenKey,
        12 => capitalBudgetingKey,
        _ => 'module$catalogId',
      };

  static int? catalogIdFor(String moduleKey) {
    if (moduleKey == 'tvm') return 5;
    if (moduleKey == breakEvenKey) return 11;
    if (moduleKey == capitalBudgetingKey) return 12;
    if (moduleKey.startsWith('module')) return int.tryParse(moduleKey.substring(6));
    return null;
  }

  static String _prefix(String scope) => 'edu_resume_${scope}_';
  static String prefKey(String scope, String moduleKey) => '${_prefix(scope)}$moduleKey';

  /// The progress scope the module screens use: `sp` for a self-paced learner,
  /// else the corporate team id.
  static String scopeFor({required bool isSelfPaced, required SharedPreferences prefs}) =>
      isSelfPaced ? 'sp' : (prefs.getInt('edu_team_id') ?? 1).toString();

  /// Record the slide on screen (call on every slide change and once on open).
  static Future<void> save(String scope, String moduleKey, String sectionId,
      {DateTime? at}) async {
    if (sectionId.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final r = LearnResume(
        moduleKey: moduleKey, sectionId: sectionId, at: (at ?? DateTime.now()).toUtc());
    await prefs.setString(prefKey(scope, moduleKey), jsonEncode(r.toJson()));
  }

  static LearnResume? _decode(String moduleKey, String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final m = jsonDecode(raw);
      if (m is! Map) return null;
      final id = m['sectionId'];
      final at = DateTime.tryParse('${m['at']}');
      if (id is! String || id.isEmpty || at == null) return null;
      return LearnResume(moduleKey: moduleKey, sectionId: id, at: at.toUtc());
    } catch (_) {
      return null;
    }
  }

  /// The saved position of one module/deck, or null for a fresh start.
  static Future<LearnResume?> get(String scope, String moduleKey) async {
    final prefs = await SharedPreferences.getInstance();
    return _decode(moduleKey, prefs.getString(prefKey(scope, moduleKey)));
  }

  /// Every saved position in [scope].
  static Future<List<LearnResume>> all(String scope) async {
    final prefs = await SharedPreferences.getInstance();
    final p = _prefix(scope);
    final out = <LearnResume>[];
    for (final k in prefs.getKeys()) {
      if (!k.startsWith(p)) continue;
      final r = _decode(k.substring(p.length), prefs.getString(k));
      if (r != null) out.add(r);
    }
    return out;
  }

  /// The most recently visited module/deck in [scope]: powers the hub's
  /// "Continue where you left off" banner (website `getLastActiveModule`).
  static Future<LearnResume?> lastResume(String scope) async {
    LearnResume? best;
    for (final r in await all(scope)) {
      if (best == null || r.at.isAfter(best.at)) best = r;
    }
    return best;
  }

  /// Slide index to open at for a deck whose slides carry [sectionIds]; 0 when
  /// nothing is saved or the saved slide no longer exists.
  static int indexIn(List<String> sectionIds, String? sectionId) {
    if (sectionId == null) return 0;
    final i = sectionIds.indexOf(sectionId);
    return i < 0 ? 0 : i;
  }

  /// Merge a server `__resume` entry by RECENCY (independent of score, like the
  /// website's hydrate). Returns true when the local position changed.
  static Future<bool> mergeServer(
      String scope, String moduleKey, Object? serverResume) async {
    if (serverResume is! Map) return false;
    final id = serverResume['sectionId'];
    final at = DateTime.tryParse('${serverResume['at']}');
    if (id is! String || id.isEmpty || at == null) return false;
    final local = await get(scope, moduleKey);
    if (local != null && !at.toUtc().isAfter(local.at)) return false;
    await save(scope, moduleKey, id, at: at);
    return true;
  }
}

/// A module's stored progress for one activity (website `ActivityProgress`).
class ActivityRecord {
  final bool completed;
  final int score; // best score so far
  const ActivityRecord({this.completed = false, this.score = 0});
}

/// Per-activity module progress in SharedPreferences, keyed by the WEBSITE's
/// activity ids so both clients read and write the same records.
///
/// Keys (scope = `sp` for a self-paced learner, else the corporate team id):
///   * `edu_module_<scope>_<id>_act_<activityId>`        bool  completed
///   * `edu_module_<scope>_<id>_act_<activityId>_score`  int   best score
///   * `edu_module_<scope>_<id>_learn`                   bool  Learn done
///   * tab roll-ups `…_quiz` / `…_game` / `…_sim` (bool, all activities of the
///     Practice / Games / Sim tab done) and `…_quizScore` / `…_gameScore` /
///     `…_simScore` (sum of the tab's best scores), kept for the hub and older
///     readers.
///   * hub keys `edu_progress_<id>` (score / server max, %) and
///     `edu_passed_<id>` (>= 70%, the server's pass rule).
///
/// Scoring contract (website `saveActivityScore` + `calculateModuleTotalScore`):
/// an activity keeps its BEST score and is completed once finished; the module
/// score is the sum of activity scores, whose maxima add up to the server's
/// MODULE_MAX_SCORES entry.
class ModuleProgressStore {
  ModuleProgressStore._();

  static String key(String scope, int module, String activity) =>
      'edu_module_${scope}_${module}_$activity';
  static String doneKey(String scope, int module, String activityId) =>
      key(scope, module, 'act_$activityId');
  static String scoreKey(String scope, int module, String activityId) =>
      key(scope, module, 'act_${activityId}_score');

  static const Map<ActivityTab, String> tabFlag = {
    ActivityTab.practice: 'quiz',
    ActivityTab.games: 'game',
    ActivityTab.sim: 'sim',
  };

  static ActivityRecord read(
          SharedPreferences prefs, String scope, int module, String activityId) =>
      ActivityRecord(
        completed: prefs.getBool(doneKey(scope, module, activityId)) ?? false,
        score: prefs.getInt(scoreKey(scope, module, activityId)) ?? 0,
      );

  /// Record a finished attempt: completed, best score kept (clamped to max).
  static Future<void> record(SharedPreferences prefs, String scope, int module,
      ModuleActivity activity, int score,
      {bool completed = true}) async {
    final prev = read(prefs, scope, module, activity.id);
    final best = score.clamp(0, activity.maxScore);
    await prefs.setBool(
        doneKey(scope, module, activity.id), prev.completed || completed);
    await prefs.setInt(scoreKey(scope, module, activity.id),
        best > prev.score ? best : prev.score);
  }

  static int totalScore(
      SharedPreferences prefs, String scope, EducationModuleContent content) {
    var t = 0;
    for (final a in content.activities) {
      t += read(prefs, scope, content.id, a.id).score.clamp(0, a.maxScore);
    }
    return t;
  }

  /// Last server percentage seen for a module (floor for the hub keys).
  static String serverPctKey(int module) => 'edu_server_pct_$module';

  static int percentOf(int score, int max) =>
      max <= 0 ? 0 : ((score / max) * 100).round().clamp(0, 100);

  /// Rewrite the tab roll-ups and (when [writeHub]) the hub keys from the
  /// per-activity records. [floorPercent] keeps a higher server percentage
  /// (e.g. a legacy record we cannot attribute to activities).
  static Future<void> recompute(SharedPreferences prefs, String scope,
      EducationModuleContent content,
      {bool writeHub = true, int floorPercent = 0}) async {
    final n = content.id;
    for (final tab in ActivityTab.values) {
      final acts = content.activitiesIn(tab);
      final flag = tabFlag[tab]!;
      final done =
          acts.isNotEmpty && acts.every((a) => read(prefs, scope, n, a.id).completed);
      final sum = acts.fold<int>(0, (t, a) => t + read(prefs, scope, n, a.id).score);
      await prefs.setBool(key(scope, n, flag), done);
      await prefs.setInt(key(scope, n, '${flag}Score'), sum);
    }
    if (!writeHub) return;
    final max = EducationProgressSync.moduleMaxScores[n] ?? content.maxScore;
    var pct = percentOf(totalScore(prefs, scope, content), max);
    // Never report less than the last server percentage: activities the server
    // credits may not all be attributable locally (legacy records, offline).
    final serverPct = prefs.getInt(serverPctKey(n)) ?? 0;
    if (serverPct > floorPercent) floorPercent = serverPct;
    if (floorPercent > pct) pct = floorPercent;
    await prefs.setInt('edu_progress_$n', pct);
    await prefs.setBool('edu_passed_$n', pct >= EducationProgressSync.passThreshold * 100);
  }

  /// One-time upgrade of progress written by the previous app version, which
  /// tracked one score per TAB (`quizScore` out of 50, `gameScore_<type>` out of
  /// 50/75, `simScore` out of 100) instead of per website activity. Each tab
  /// score is attributed to the first activity of the matching kind, rescaled
  /// to that activity's max. Returns true when anything was migrated.
  static Future<bool> migrateLegacy(SharedPreferences prefs, String scope,
      EducationModuleContent content) async {
    final n = content.id;
    final marker = key(scope, n, 'actsMigrated');
    if (prefs.getBool(marker) ?? false) return false;
    await prefs.setBool(marker, true);
    final anyNew = content.activities
        .any((a) => prefs.containsKey(doneKey(scope, n, a.id)));
    if (anyNew) return false;

    var migrated = false;
    Future<void> put(ModuleActivity? a, bool done, int? score, int legacyMax) async {
      if (a == null || (!done && (score ?? 0) <= 0)) return;
      final scaled = score == null
          ? (done ? a.maxScore : 0)
          : ((score / legacyMax) * a.maxScore).round();
      await prefs.setBool(doneKey(scope, n, a.id), done);
      await prefs.setInt(scoreKey(scope, n, a.id), scaled.clamp(0, a.maxScore));
      migrated = true;
    }

    ModuleActivity? first(ActivityTab tab, [ActivityKind? kind]) {
      for (final a in content.activitiesIn(tab)) {
        if (kind == null || a.kind == kind) return a;
      }
      return null;
    }

    await put(first(ActivityTab.practice, ActivityKind.quiz),
        prefs.getBool(key(scope, n, 'quiz')) ?? false,
        prefs.getInt(key(scope, n, 'quizScore')), 50);
    final gamesDone = prefs.getStringList(key(scope, n, 'gamesDone')) ?? const [];
    for (final (legacy, kind, legacyMax) in const [
      ('memoryMatch', ActivityKind.memoryMatch, 50),
      ('classification', ActivityKind.classification, 75),
      ('ordering', ActivityKind.ordering, 50),
    ]) {
      await put(first(ActivityTab.games, kind), gamesDone.contains(legacy),
          prefs.getInt(key(scope, n, 'gameScore_$legacy')), legacyMax);
    }
    await put(first(ActivityTab.sim), prefs.getBool(key(scope, n, 'sim')) ?? false,
        prefs.getInt(key(scope, n, 'simScore')), 100);
    return migrated;
  }
}

/// Cross-device education progress (website parity with `hydrateProgressFromServer`
/// / `syncProgressToDatabase` in client/src/lib/educationProgress.ts).
///
/// Pulls the database copy written by either client and pushes the local copy
/// back, keyed the same way the website keys it:
///   * self-paced learners → their email (needs the bearer token)
///   * corporate teams     → "Team 1".."Team 7" (no token; lobby sign-in gates it)
///
<<<<<<< Updated upstream
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
=======
/// Activities sync under the WEBSITE's activity ids with their real scores, so
/// a learner's quiz on the phone shows as that quiz on the website and vice
/// versa. Per activity the best score wins and completion is sticky; Learn
/// completion rides in `__meta`, and the last Learn slide in `__resume`
/// (self-paced only, newest wins) exactly as the website writes them.
>>>>>>> Stashed changes
class EducationProgressSync {
  EducationProgressSync(this._api);

  final ApiClient _api;

  /// Content modules whose work is done in this app, by permanent catalog id
  /// (education_catalog.dart). Only these carry activity records.
  static final List<int> contentModules =
      inAppContentModules.map((m) => m.num).toList();

  /// Every scored content module, in-app or website-only. All of them are
  /// restored from the server so the hub shows website progress too.
  static final List<int> restoredModules =
      educationCatalog.where((m) => m.isContent).map((m) => m.num).toList();

  /// Must match MODULE_MAX_SCORES in server/routes/education-modules.ts: the
  /// server clamps to these, and the website derives its % from them. For the
  /// in-app modules each equals the sum of the module's activity maxima.
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
    19: 300,
    20: 300,
    21: 300,
    22: 300,
  };

  /// What the server grades a module against when MODULE_MAX_SCORES has no
  /// entry for it (`moduleMaxScore` in server/services/educationProgressMerge.ts
  /// falls back to 325).
  static const int defaultModuleMaxScore = 325;

  /// The maximum score the server grades module [n] against.
  static int maxScoreFor(int n) => moduleMaxScores[n] ?? defaultModuleMaxScore;

  static const double passThreshold = 0.7; // 70%, same as the server

  /// Who progress syncs as (the hub's `_progressIdentity` rule), or null when
  /// this device must not push at all: a facilitator previewing, a self-paced
  /// learner without an email, or a corporate device that never joined a team
  /// (it would otherwise write into Team 1's row).
  static ({String teamName, String scope})? progressIdentity({
    required bool isFacilitator,
    required bool isSelfPaced,
    String? email,
    int? teamId,
  }) {
    if (isFacilitator) return null;
    if (isSelfPaced) {
      final e = email ?? '';
      return e.isEmpty ? null : (teamName: e, scope: 'sp');
    }
    if (teamId == null) return null;
    return (teamName: 'Team $teamId', scope: '$teamId');
  }

  /// The tab roll-up flags a module screen keeps (`learn` + one per tab).
  static const List<String> activities = ['learn', 'game', 'quiz', 'sim'];

  /// Activity ids written by the previous app version (one per tab). They are
  /// not website activities, so a push drops them rather than letting the
  /// website sum them into its module total.
  static const Set<String> legacyActivityIds = {'game', 'sim'};

  /// Server progress key. Time Value of Money (id 5) is stored as `tvm` on the
  /// website; every other module is `module` followed by its catalog id.
  static String moduleKey(int n) => n == 5 ? 'tvm' : 'module$n';

  /// Workshop decks whose Learn position also syncs (website a2da32f).
  static const List<String> deckKeys = [
    LearnResumeStore.breakEvenKey,
    LearnResumeStore.capitalBudgetingKey,
  ];

  static String _badgeKey(int module) => 'edu_badges_$module';

  /// Pull the server copy, then push the (possibly newer) local copy back.
  /// One GET + at most one POST. Returns true when local prefs changed.
  Future<bool> sync({required String teamName, required String scope}) async {
    final saved = await _fetchSaved(teamName);
    if (saved == null) return false; // offline: never push blind
    final changed = await _applyToLocal(saved, scope: scope);
    await _push(teamName, scope: scope, serverModules: saved);
    return changed;
  }

  /// Restore only: used right after login, before any screen reads prefs.
  Future<bool> hydrate({required String teamName, required String scope}) async {
    final saved = await _fetchSaved(teamName);
    if (saved == null) return false;
    return _applyToLocal(saved, scope: scope);
  }

  /// GET /education/progress/{teamName}/saved -> { data: { modules: {...} } }.
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

  // ── server → local ────────────────────────────────────────────────────────

  Future<bool> _applyToLocal(Map<String, dynamic> serverModules,
      {required String scope}) =>
      applyServerToLocal(serverModules, scope: scope);

  /// Merge the server copy into local prefs. Public for tests.
  static Future<bool> applyServerToLocal(
    Map<String, dynamic> serverModules, {
    required String scope,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final provisional = await EducationStorageMigration.provisionalIds(prefs);
    var changed = false;
    final selfPaced = scope == 'sp';

    // Resume positions: by recency, independent of score (self-paced only).
    if (selfPaced) {
      final keys = [
        for (final n in restoredModules) moduleKey(n),
        ...deckKeys,
      ];
      for (final k in keys) {
        final entry = serverModules[k];
        if (entry is! Map) continue;
        final ad = entry['activityData'];
        if (ad is Map &&
            await LearnResumeStore.mergeServer(scope, k, ad['__resume'])) {
          changed = true;
        }
      }
    }

    for (final n in restoredModules) {
<<<<<<< Updated upstream
      final entry = serverModules[_moduleKey(n)];
      // No server record: local stays as it is. A provisional id stays
      // provisional, since nothing has confirmed its remapped value yet.
=======
      final entry = serverModules[moduleKey(n)];
>>>>>>> Stashed changes
      if (entry is! Map) continue;

      final maxScore = maxScoreFor(n);
      final serverScore = (entry['moduleScore'] as num?)?.toInt() ?? 0;
      final serverPercent = ModuleProgressStore.percentOf(serverScore, maxScore);

      final badges = (entry['badges'] as List?)?.map((b) => b.toString()).toList();
      if (badges != null && badges.isNotEmpty) {
        await prefs.setStringList(_badgeKey(n), badges);
      }

<<<<<<< Updated upstream
      // The server wins for a provisional id whatever the local value says:
      // that value may be another module's progress moved here by the
      // migration, and the server record is the only trustworthy copy.
      final serverWins = provisional.contains(n);
      if (!serverWins && serverPercent <= localPercent) {
        continue; // local is fresher — keep it
      }

=======
>>>>>>> Stashed changes
      final activityData = entry['activityData'] is Map
          ? Map<String, dynamic>.from(entry['activityData'] as Map)
          : <String, dynamic>{};

<<<<<<< Updated upstream
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
=======
      final content = educationModuleContents[n];
      if (content == null) {
        // Website-only module: the hub just mirrors the server percentage.
        final localPercent = prefs.getInt('edu_progress_$n') ?? 0;
        if (serverPercent <= localPercent) continue;
        await prefs.setInt('edu_progress_$n', serverPercent);
        await prefs.setBool(
            'edu_passed_$n', entry['completed'] == true || serverPercent >= 70);
        changed = true;
        continue;
      }

      await ModuleProgressStore.migrateLegacy(prefs, scope, content);
      var moduleChanged = false;

      for (final a in content.activities) {
        final s = activityData[a.id];
        if (s is! Map) continue;
        final local = ModuleProgressStore.read(prefs, scope, n, a.id);
        final sScore = ((s['score'] as num?)?.toInt() ?? 0).clamp(0, a.maxScore);
        final sDone = s['completed'] == true;
        if (sScore > local.score || (sDone && !local.completed)) {
          await prefs.setBool(
              ModuleProgressStore.doneKey(scope, n, a.id), local.completed || sDone);
          await prefs.setInt(ModuleProgressStore.scoreKey(scope, n, a.id),
              sScore > local.score ? sScore : local.score);
          moduleChanged = true;
>>>>>>> Stashed changes
        }
      }

<<<<<<< Updated upstream
      await prefs.setInt('edu_progress_$n', serverPercent);
      await prefs.setBool('edu_passed_$n', completed);
      if (serverWins) {
        await EducationStorageMigration.clearProvisional(prefs, n);
      }
      changed = true;
=======
      final meta = activityData['__meta'];
      final learnKey = ModuleProgressStore.key(scope, n, 'learn');
      final learnLocal = prefs.getBool(learnKey) ?? false;
      final legacyLearn = activityData['learn'];
      final learnServer = (meta is Map && meta['completed'] == true) ||
          (legacyLearn is Map && legacyLearn['completed'] == true);
      if (learnServer && !learnLocal) {
        await prefs.setBool(learnKey, true);
        moduleChanged = true;
      }

      await prefs.setInt(ModuleProgressStore.serverPctKey(n), serverPercent);
      final before = prefs.getInt('edu_progress_$n') ?? 0;
      await ModuleProgressStore.recompute(prefs, scope, content,
          floorPercent: serverPercent);
      if (moduleChanged || (prefs.getInt('edu_progress_$n') ?? 0) != before) {
        changed = true;
      }
>>>>>>> Stashed changes
    }

    return changed;
  }

  // ── local → server ────────────────────────────────────────────────────────

<<<<<<< Updated upstream
  /// POST /education/progress/{teamName}/sync. Only modules where the local
  /// score is ahead of the server's are sent: the server replaces activityData
  /// wholesale, so pushing a module we haven't advanced would flatten the
  /// website's finer-grained per-activity records for no gain. Provisional ids
  /// (see the class doc) are never sent, however far ahead local looks.
=======
>>>>>>> Stashed changes
  Future<void> _push(
    String teamName, {
    required String scope,
    required Map<String, dynamic> serverModules,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
<<<<<<< Updated upstream
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

=======
      final payload = await buildPushPayload(prefs,
          scope: scope, serverModules: serverModules);
      if (payload == null) return;
>>>>>>> Stashed changes
      await _api.post(
        ApiEndpoints.educationProgressSync
            .replaceFirst('{teamName}', Uri.encodeComponent(teamName)),
        data: payload,
      );
    } catch (_) {
      // Non-critical: local prefs stay the source of truth until the next sync.
    }
  }

  static Map<String, dynamic> _resumeEntry(LearnResume r) => {
        'score': 0,
        'maxScore': 0,
        'completed': false,
        'sectionId': r.sectionId,
        'at': r.atIso,
      };

  /// The POST /sync body, or null when nothing local is ahead of the server.
  ///
  /// The server REPLACES each sent module's activityData and recomputes the
  /// team total from the modules in the body, so:
  ///   * a changed module starts from the server's activityData (keeping the
  ///     website's own activities, `__meta` and `__resume`) and only raises
  ///     what this device is ahead on;
  ///   * every other server module is echoed back unchanged so the team total
  ///     stays the sum of all modules.
  /// Public for tests.
  static Future<Map<String, dynamic>?> buildPushPayload(
    SharedPreferences prefs, {
    required String scope,
    required Map<String, dynamic> serverModules,
  }) async {
    final selfPaced = scope == 'sp';
    final modules = <String, dynamic>{};
    final allBadges = <String>{};
    var anyChange = false;

    Map<String, dynamic> serverActivityData(Object? entry) =>
        entry is Map && entry['activityData'] is Map
            ? Map<String, dynamic>.from(entry['activityData'] as Map)
            : <String, dynamic>{};

    Future<bool> mergeResume(String key, Map<String, dynamic> ad) async {
      if (!selfPaced) return false; // corporate resume stays per-device
      final local = await LearnResumeStore.get(scope, key);
      if (local == null) return false;
      final s = ad['__resume'];
      final sAt = s is Map ? DateTime.tryParse('${s['at']}') : null;
      if (sAt != null && !local.at.isAfter(sAt.toUtc())) return false;
      ad['__resume'] = _resumeEntry(local);
      return true;
    }

    for (final n in contentModules) {
      final content = educationModuleContents[n];
      if (content == null) continue;
      await ModuleProgressStore.migrateLegacy(prefs, scope, content);
      final key = moduleKey(n);
      final serverEntry = serverModules[key];
      final serverScore = serverEntry is Map
          ? ((serverEntry['moduleScore'] as num?)?.toInt() ?? 0)
          : 0;
      final ad = serverActivityData(serverEntry);
      var changed = false;

      for (final legacy in legacyActivityIds) {
        if (content.activities.any((a) => a.id == legacy)) continue;
        if (ad.remove(legacy) != null) changed = true;
      }

      var total = 0;
      for (final a in content.activities) {
        final local = ModuleProgressStore.read(prefs, scope, n, a.id);
        final s = ad[a.id];
        final sScore = s is Map ? ((s['score'] as num?)?.toInt() ?? 0) : 0;
        final sDone = s is Map && s['completed'] == true;
        final best = (local.score > sScore ? local.score : sScore).clamp(0, a.maxScore);
        final done = local.completed || sDone;
        if (local.score > sScore || (local.completed && !sDone)) {
          ad[a.id] = {'score': best, 'maxScore': a.maxScore, 'completed': done};
          changed = true;
        }
        total += best;
      }

      final learn =
          prefs.getBool(ModuleProgressStore.key(scope, n, 'learn')) ?? false;
      final meta = ad['__meta'];
      final metaDone = meta is Map && meta['completed'] == true;
      if (learn && !metaDone) {
        ad['__meta'] = {'score': 0, 'maxScore': 0, 'completed': true};
        changed = true;
      } else if (meta == null && serverEntry is Map) {
        ad['__meta'] = {'score': 0, 'maxScore': 0, 'completed': false};
      }
      if (await mergeResume(key, ad)) changed = true;

      final badges = prefs.getStringList(_badgeKey(n)) ??
          ((serverEntry is Map ? serverEntry['badges'] as List? : null)
                  ?.map((b) => b.toString())
                  .toList() ??
              const <String>[]);
      final moduleTotal = total > serverScore ? total : serverScore;
      if (!changed && serverEntry is! Map) continue; // nothing anywhere
      if (changed) anyChange = true;
      allBadges.addAll(badges);
      modules[key] = {
        'totalScore': moduleTotal.clamp(0, moduleMaxScores[n] ?? moduleTotal),
        'badges': badges,
        'activityData': ad,
      };
    }

    // Workshop decks: resume-only records (self-paced), like the website's
    // `break-even` / `capital-budgeting` progress entries.
    for (final key in deckKeys) {
      final serverEntry = serverModules[key];
      final ad = serverActivityData(serverEntry);
      final changed = await mergeResume(key, ad);
      if (!changed && serverEntry is! Map) continue;
      if (changed) anyChange = true;
      modules[key] = {
        'totalScore': serverEntry is Map
            ? ((serverEntry['moduleScore'] as num?)?.toInt() ?? 0)
            : 0,
        'badges': serverEntry is Map
            ? ((serverEntry['badges'] as List?)?.map((b) => b.toString()).toList() ??
                const <String>[])
            : const <String>[],
        'activityData': ad,
      };
    }

    if (!anyChange) return null;

    // Echo every other server module verbatim (website-only modules, TVM…).
    for (final e in serverModules.entries) {
      if (modules.containsKey(e.key)) continue;
      final v = e.value;
      if (v is! Map) continue;
      final badges =
          (v['badges'] as List?)?.map((b) => b.toString()).toList() ?? const <String>[];
      allBadges.addAll(badges);
      modules[e.key] = {
        'totalScore': (v['moduleScore'] as num?)?.toInt() ?? 0,
        'badges': badges,
        'activityData': serverActivityData(v),
      };
    }

    return {'modules': modules, 'totalBadges': allBadges.toList()};
  }
}

final educationProgressSyncProvider = Provider<EducationProgressSync>(
  (ref) => EducationProgressSync(ref.watch(apiClientProvider)),
);
