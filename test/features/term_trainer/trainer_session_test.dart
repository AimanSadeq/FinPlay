import 'package:finplay/features/knowledge/data/financial_terms_data.dart';
import 'package:finplay/features/term_trainer/data/srs_api.dart';
import 'package:finplay/features/term_trainer/data/trainer_session.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final ids = financialTerms.map((t) => t.id).toList();

  test('allTermIds is the directory, in order', () {
    expect(allTrainerTermIds, ids);
  });

  test('session deals due first, then new, drops unknown ids, caps at 10', () {
    final cards = buildSessionCards([ids[5], 'gone-term', ids[1]], ids.sublist(10, 30));
    expect(cards.first.id, ids[5]);
    expect(cards[1].id, ids[1]);
    expect(cards[2].id, ids[10]);
    expect(cards, hasLength(trainerSessionSize));
  });

  test('"Again" re-deals the card until it passes; each card counts once', () {
    final s = TrainerSession(buildSessionCards([ids[0], ids[1]], const []));
    expect(s.totalUnique, 2);
    s.grade(Grade.again); // ids[0] goes to the back
    expect(s.current!.id, ids[1]);
    s.grade(Grade.good);
    expect(s.current!.id, ids[0]);
    expect(s.completed, 1);
    s.grade(Grade.hard);
    expect(s.isDone, isTrue);
    expect(s.completed, 2);
    expect(s.gotIt, 1);
    expect(s.reviewing, 1);
  });

  test('queue response parses the server contract', () {
    final q = SrsQueue.fromJson({
      'success': true,
      'due': ['a'],
      'newTerms': ['b', 'c'],
      'stats': {'dueCount': 1, 'learnedCount': 7},
      'streak': {'current': 3, 'best': 5, 'activeToday': true},
    });
    expect(q.due, ['a']);
    expect(q.newTerms, ['b', 'c']);
    expect(q.learnedCount, 7);
    expect(q.streak.current, 3);
    expect(q.streak.best, 5);
    expect(q.streak.activeToday, isTrue);
  });
}
