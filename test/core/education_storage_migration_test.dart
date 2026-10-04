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
        'edu_progress_3': 100, // synced catalog id 3, remapped to 4
      });
      final prefs = await SharedPreferences.getInstance();
      await EducationStorageMigration.run(prefs);

      // 2 -> 3 (false) merges with 3 -> 4 (true moved away): id 3 learn is the
      // moved positional value, id 4 learn is the OR of what landed there.
      expect(prefs.getBool('edu_module_sp_3_learn'), isFalse);
      expect(prefs.getBool('edu_module_sp_4_learn'), isTrue);
      expect(prefs.getInt('edu_progress_3'), 25);
      expect(prefs.getInt('edu_progress_4'), 100);
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
