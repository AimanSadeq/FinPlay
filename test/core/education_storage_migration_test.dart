import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finplay/core/services/education_storage_migration.dart';

void main() {
  group('EducationStorageMigration', () {
    test('renames the prefix and remaps position-keyed ids to catalog ids', () async {
      SharedPreferences.setMockInitialValues({
        'gov_module_sp_1_learn': true, // id 1: unchanged
        'gov_module_sp_2_learn': true, // position 2 -> catalog id 3
        'gov_module_sp_2_quizScore': 40,
        'gov_module_sp_8_learn': true, // position 8 -> catalog id 2
        'gov_module_sp_11_learn': true, // retired bonus module: dropped
        'edu_progress_3': 75, // position 3 -> catalog id 4
        'edu_passed_3': true,
        'edu_progress_6': 50, // already a catalog id: untouched
        'gov_team_id': 4,
      });
      final prefs = await SharedPreferences.getInstance();

      expect(await EducationStorageMigration.run(prefs), isTrue);

      expect(prefs.getBool('edu_module_sp_1_learn'), isTrue);
      expect(prefs.getBool('edu_module_sp_3_learn'), isTrue);
      expect(prefs.getInt('edu_module_sp_3_quizScore'), 40);
      expect(prefs.getBool('edu_module_sp_2_learn'), isTrue);
      expect(prefs.getInt('edu_progress_4'), 75);
      expect(prefs.getBool('edu_passed_4'), isTrue);
      expect(prefs.getInt('edu_progress_6'), 50);
      expect(prefs.getInt('edu_team_id'), 4);

      expect(prefs.getKeys().where((k) => k.startsWith('gov_')), isEmpty);
      expect(prefs.containsKey('edu_module_sp_11_learn'), isFalse);
      expect(prefs.containsKey('edu_progress_3'), isFalse);
      expect(prefs.getInt(EducationStorageMigration.versionKey),
          EducationStorageMigration.currentVersion);
    });

    test('merging never lowers progress when both keys exist', () async {
      SharedPreferences.setMockInitialValues({
        'gov_module_sp_2_learn': false, // positional Understanding FS, not done
        'gov_module_sp_3_learn': true, // could be synced Understanding FS (id 3)
        'edu_progress_2': 25, // positional
        'edu_progress_3': 100, // ambiguous: read as position 3, moved to id 4
      });
      final prefs = await SharedPreferences.getInstance();
      await EducationStorageMigration.run(prefs);

      // 2 -> 3 (false) merges with 3 -> 4 (true moved away): id 3 learn is the
      // moved positional value, id 4 learn is the OR of what landed there.
      expect(prefs.getBool('edu_module_sp_3_learn'), isFalse);
      expect(prefs.getBool('edu_module_sp_4_learn'), isTrue);
      expect(prefs.getInt('edu_progress_3'), 25);
      expect(prefs.getInt('edu_progress_4'), 100);
      // Both destinations received remapped values, so neither is trusted
      // until the server (or in-app work) confirms it.
      expect(await EducationStorageMigration.provisionalIds(prefs), {3, 4});
    });

    test('a device with synced progress gets its remapped ids marked provisional',
        () async {
      // The old sync service wrote these keys by CATALOG id: edu_progress_3 is
      // Understanding Financial Statements at 100%, edu_progress_2 is Sector
      // Finance Comparison at 40%. The migration cannot tell them from
      // positional keys, so it remaps them (3 -> 4, 2 -> 3) and marks every
      // destination provisional; the sync then lets the server correct them
      // instead of pushing a phantom completion of id 4.
      SharedPreferences.setMockInitialValues({
        'edu_progress_3': 100,
        'edu_passed_3': true,
        'edu_progress_2': 40,
        'gov_module_1_3_learn': true, // synced activity flags, team scope
        'gov_module_1_3_quiz': true,
        'gov_module_1_8_learn': true, // positional Sector Comparison -> id 2
        'edu_badges_3': ['m3_first_steps'],
        'edu_progress_6': 50, // id 6 is the same in both readings: untouched
      });
      final prefs = await SharedPreferences.getInstance();
      await EducationStorageMigration.run(prefs);

      expect(prefs.getInt('edu_progress_4'), 100);
      expect(prefs.getInt('edu_progress_3'), 40);
      expect(prefs.getBool('edu_module_1_4_learn'), isTrue);
      expect(prefs.getBool('edu_module_1_2_learn'), isTrue);
      expect(prefs.getInt('edu_progress_6'), 50);

      expect(prefs.getStringList(EducationStorageMigration.provisionalKey),
          ['2', '3', '4']);
      expect(await EducationStorageMigration.provisionalIds(prefs), {2, 3, 4});
    });

    test('nothing is provisional when no key was remapped', () async {
      SharedPreferences.setMockInitialValues({
        'gov_module_sp_1_learn': true,
        'edu_progress_1': 25,
        'edu_progress_6': 50,
        'gov_team_id': 2,
      });
      final prefs = await SharedPreferences.getInstance();
      await EducationStorageMigration.run(prefs);
      expect(prefs.containsKey(EducationStorageMigration.provisionalKey), isFalse);
      expect(await EducationStorageMigration.provisionalIds(prefs), isEmpty);
    });

    test('clearProvisional removes one id and drops the key when empty', () async {
      SharedPreferences.setMockInitialValues({
        EducationStorageMigration.provisionalKey: ['2', '3', '4'],
      });
      final prefs = await SharedPreferences.getInstance();
      await EducationStorageMigration.clearProvisional(prefs, 4);
      expect(await EducationStorageMigration.provisionalIds(prefs), {2, 3});
      await EducationStorageMigration.clearProvisional(prefs, 9); // not provisional
      expect(await EducationStorageMigration.provisionalIds(prefs), {2, 3});
      await EducationStorageMigration.clearProvisional(prefs, 2);
      await EducationStorageMigration.clearProvisional(prefs, 3);
      expect(prefs.containsKey(EducationStorageMigration.provisionalKey), isFalse);
    });

    test('runs only once', () async {
      SharedPreferences.setMockInitialValues({'gov_team_id': 2});
      final prefs = await SharedPreferences.getInstance();
      expect(await EducationStorageMigration.run(prefs), isTrue);
      await prefs.setInt('gov_team_id', 9); // would be migrated if it ran again
      expect(await EducationStorageMigration.run(prefs), isFalse);
      expect(prefs.getInt('edu_team_id'), 2);
    });
  });
}
