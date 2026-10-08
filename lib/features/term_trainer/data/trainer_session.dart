// Pure session bookkeeping for the Term Trainer (website parity: term-trainer.tsx).
// Kept free of Flutter and networking so it can be unit-tested.

import '../../knowledge/data/financial_term.dart';
import '../../knowledge/data/financial_terms_data.dart';

/// Cards per session (website SESSION_SIZE).
const int trainerSessionSize = 10;

/// Grades, as the server expects them.
abstract final class Grade {
  static const again = 0;
  static const hard = 1;
  static const good = 2;
  static const easy = 3;
}

/// Every term id the client can render, in directory order. Sent as `allTermIds`:
/// the server deals new cards in this order and never deals an id missing from it.
final List<String> allTrainerTermIds = [for (final t in financialTerms) t.id];

final Map<String, FinancialTerm> _termsById = {for (final t in financialTerms) t.id: t};

/// Due cards first (oldest due first, as the server ordered them), then new terms,
/// dropping ids this build doesn't know and capping to one session.
List<FinancialTerm> buildSessionCards(List<String> due, List<String> newTerms,
    {int size = trainerSessionSize}) {
  return [...due, ...newTerms]
      .map((id) => _termsById[id])
      .whereType<FinancialTerm>()
      .take(size)
      .toList();
}

class TrainerSession {
  final List<FinancialTerm> cards;
  int index = 0;

  /// Final grade per card id; only set once a card is graded Hard/Good/Easy.
  final Map<String, int> finalGrades = {};

  TrainerSession(List<FinancialTerm> initial) : cards = [...initial];

  FinancialTerm? get current => index < cards.length ? cards[index] : null;

  /// The queue grows when "Again" cards are re-dealt, so progress counts unique cards.
  int get totalUnique => cards.map((c) => c.id).toSet().length;
  int get completed => finalGrades.length;
  int get gotIt => finalGrades.values.where((g) => g >= Grade.good).length;
  int get reviewing => completed - gotIt;
  bool get isDone => current == null;

  /// Applies a grade to the current card. "Again" re-deals it at the end of this
  /// session; it keeps coming back until it gets a passing grade.
  void grade(int grade) {
    final card = current;
    if (card == null) return;
    if (grade == Grade.again) {
      cards.add(card);
    } else {
      finalGrades[card.id] = grade;
    }
    index++;
  }
}
