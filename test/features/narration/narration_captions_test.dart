import 'package:finplay/features/education/widgets/slide_narration_bar.dart';
import 'package:flutter_test/flutter_test.dart';

// Same cases as the website's tests/unit/narration-and-print.test.ts.
void main() {
  const script =
      'Ratios turn raw numbers into comparisons. A current ratio of 2 means two riyals of short-term assets for each riyal due! Is that good? It depends on the industry.';

  test('splits the script into its sentences, in order', () {
    expect(captionTimeline(script).map((c) => c.text).toList(), [
      'Ratios turn raw numbers into comparisons.',
      'A current ratio of 2 means two riyals of short-term assets for each riyal due!',
      'Is that good?',
      'It depends on the industry.',
    ]);
  });

  test('gives each sentence a share that grows with its length and ends at 1', () {
    final t = captionTimeline(script);
    expect(t.last.end, closeTo(1, 1e-9));
    for (var i = 1; i < t.length; i++) {
      expect(t[i].end, greaterThan(t[i - 1].end));
    }
    expect(t[1].end - t[0].end, greaterThan(t[2].end - t[1].end));
  });

  test('splits Arabic on the Arabic question mark too', () {
    expect(captionTimeline('ما النسبة؟ إنها مقارنة.').map((c) => c.text).toList(),
        ['ما النسبة؟', 'إنها مقارنة.']);
  });

  test('captionAt follows playback position', () {
    final t = captionTimeline(script);
    expect(captionAt(t, 0), t.first.text);
    expect(captionAt(t, 1), t.last.text);
    expect(captionAt(t, 0.99999), t.last.text);
    expect(captionAt(const [], 0.5), isNull);
    expect(captionTimeline('   '), isEmpty);
  });
}
