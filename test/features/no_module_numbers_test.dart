import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Modules are named by title only, never by number, anywhere a learner or a
/// facilitator looks. Scans every string literal under lib/ (comments are not
/// displayed and are skipped) for "Module" or "الوحدة" followed by a digit or
/// by an interpolated value.
void main() {
  final literal = RegExp(r"'(?:[^'\\]|\\.)*'" '|' r'"(?:[^"\\]|\\.)*"');
  final english = RegExp(r'Module\s*(?:\d|\$)');
  final arabic = RegExp(r'الوحدة\s*(?:\d|[٠-٩]|\$)');

  List<String> hits() {
    final found = <String>[];
    final files = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'));
    for (final file in files) {
      final lines = file.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (line.trimLeft().startsWith('//')) continue;
        for (final m in literal.allMatches(line)) {
          final text = m.group(0)!;
          if (english.hasMatch(text) || arabic.hasMatch(text)) {
            found.add('${file.path}:${i + 1}: $text');
          }
        }
      }
    }
    return found;
  }

  test('the patterns catch a numbered module label', () {
    for (final sample in [
      "'Module 3'",
      r"'Module $position'",
      r"'Module ${n + 1}'",
      "'الوحدة 4'",
      r"'الوحدة $position'",
      "'الوحدة ٤'",
    ]) {
      final text = literal.firstMatch(sample)!.group(0)!;
      expect(english.hasMatch(text) || arabic.hasMatch(text), isTrue, reason: sample);
    }
    expect(english.hasMatch("'Next Module'"), isFalse);
    expect(arabic.hasMatch("'الوحدة التالية'"), isFalse);
  });

  test('no displayed string names a module by number', () {
    final found = hits();
    expect(found, isEmpty, reason: found.join('\n'));
  });
}
