import '../../../data/models/financial_data.dart';

/// Finds a statement line by label the way the website's analytics routes do
/// (extractRow in server/routes/du-pont.ts, covenants.ts, ...): an exact label beats a
/// prefix match, which beats a substring match; earlier matchers rank higher; and a line
/// with a non-zero value beats an empty one. Returns null when nothing matches.
StatementRow? matchStatementRow(List<StatementRow> rows, List<String> matchers) {
  StatementRow? best;
  var bestScore = -1;
  for (final r in rows) {
    final label = r.title.trim().toLowerCase();
    if (label.isEmpty) continue;
    for (var i = 0; i < matchers.length; i++) {
      final m = matchers[i];
      var score = label == m
          ? 300 - i
          : label.startsWith(m)
              ? 200 - i
              : label.contains(m)
                  ? 100 - i
                  : -1;
      if (score < 0) continue;
      if (r.value != 0) score += 1000;
      if (score > bestScore) {
        bestScore = score;
        best = r;
      }
    }
  }
  return best;
}

/// The matched line's value, or 0 when nothing matches.
double matchStatementValue(List<StatementRow> rows, List<String> matchers) =>
    matchStatementRow(rows, matchers)?.value ?? 0;
