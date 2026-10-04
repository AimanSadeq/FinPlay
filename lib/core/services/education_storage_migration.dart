import 'package:shared_preferences/shared_preferences.dart';

/// One-time migration of locally stored education progress.
///
/// Two things changed at once in storage version 2:
///
/// 1. Key prefix. Progress was stored under `gov_module_<scope>_<id>_<activity>`
///    and the selected team under `gov_team_id`. The prefixes are now
///    `edu_module_` and `edu_team_id`.
/// 2. Module identity. Older builds routed module screens by hub card position
///    and stored progress under that position, while the hub, the progress sync
///    and the server key everything by the permanent catalog id. The three
///    modules whose position differed from their id were stored wrongly:
///    position 2 (Understanding Financial Statements) is catalog id 3,
///    position 3 (Analysis of Financial Statements) is catalog id 4, and
///    position 8 (Sector Finance Comparison) is catalog id 2. Positions 11 and
///    12 were two retired bonus modules and are dropped.
///
/// Keys written by the old module screen used the position; keys written by the
/// sync service used the catalog id. A single key can therefore carry either
/// meaning, and nothing in the key says which. The migration reads every key as
/// positional, because that is the only reading under which work done on this
/// device and never synced is recoverable. Where the remapped key already has a
/// value, the two are merged so nothing is lost: booleans are OR-ed, integers
/// take the maximum. The next progress sync then pulls the server copy, which
/// wins wherever it is ahead, so synced learners converge on the server record.
class EducationStorageMigration {
  static const String versionKey = 'edu_storage_version';
  static const int currentVersion = 2;

  /// Old hub position -> permanent catalog id for the ids that differed.
  static const Map<int, int> positionToCatalogId = {2: 3, 3: 4, 8: 2};

  /// Old positions that pointed at retired modules; their keys are discarded.
  static const Set<int> retiredPositions = {11, 12};

  static final RegExp _activityKey = RegExp(r'^gov_module_([^_]+)_(\d+)_(.+)$');
  static final RegExp _hubKey = RegExp(r'^edu_(progress|passed)_(\d+)$');

  /// Runs once per device. Safe to call on every launch.
  ///
  /// Two phases on purpose: every old key is read and removed first, and only
  /// then are the remapped values written. A key such as `edu_progress_3` is
  /// both a source (position 3 moves to id 4) and a destination (position 2
  /// moves to id 3), so writing while still reading would let the order of
  /// iteration decide which value survives.
  static Future<bool> run(SharedPreferences prefs) async {
    if ((prefs.getInt(versionKey) ?? 1) >= currentVersion) return false;

    final writes = <MapEntry<String, Object?>>[];
    for (final key in prefs.getKeys().toList()) {
      final activity = _activityKey.firstMatch(key);
      if (activity != null) {
        final scope = activity.group(1)!;
        final oldId = int.parse(activity.group(2)!);
        final rest = activity.group(3)!;
        final value = prefs.get(key);
        await prefs.remove(key);
        if (retiredPositions.contains(oldId)) continue;
        final newId = positionToCatalogId[oldId] ?? oldId;
        writes.add(MapEntry('edu_module_${scope}_${newId}_$rest', value));
        continue;
      }

      final hub = _hubKey.firstMatch(key);
      if (hub != null) {
        final kind = hub.group(1)!;
        final oldId = int.parse(hub.group(2)!);
        if (!positionToCatalogId.containsKey(oldId) &&
            !retiredPositions.contains(oldId)) {
          continue; // already keyed by catalog id
        }
        final value = prefs.get(key);
        await prefs.remove(key);
        if (retiredPositions.contains(oldId)) continue;
        writes.add(MapEntry('edu_${kind}_${positionToCatalogId[oldId]}', value));
        continue;
      }

      if (key == 'gov_team_id') {
        final value = prefs.getInt(key);
        await prefs.remove(key);
        if (value != null) writes.add(MapEntry('edu_team_id', value));
      }
    }

    for (final w in writes) {
      await _merge(prefs, w.key, w.value);
    }

    await prefs.setInt(versionKey, currentVersion);
    return true;
  }

  /// Writes [value] under [key], merging with an existing value so a remap can
  /// never lower progress: booleans OR, integers max, anything else keeps the
  /// existing value.
  static Future<void> _merge(SharedPreferences prefs, String key, Object? value) async {
    final existing = prefs.get(key);
    if (value is bool) {
      await prefs.setBool(key, value || (existing is bool && existing));
    } else if (value is int) {
      await prefs.setInt(key, existing is int && existing > value ? existing : value);
    } else if (existing == null) {
      if (value is String) await prefs.setString(key, value);
      if (value is double) await prefs.setDouble(key, value);
      if (value is List<String>) await prefs.setStringList(key, value);
    }
  }
}
