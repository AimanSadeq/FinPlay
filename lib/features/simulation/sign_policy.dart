import '../../app/i18n/app_strings.dart';

/// Which way a decision card's amount may go. Port of the website's
/// shared/scenario-defaults.ts (ScenarioDirection / defaultDirection), used by both the
/// corporate cards and the self-paced panel. Sign convention, every module: + is cash in,
/// − is cash out (financing raise/repay, investing sell/buy, operating save/spend).
enum AmountDirection { positive, negative, both }

/// When the catalog (or the API) does not say:
///   financing: 1-5 both ways; 6 (retained earnings), 8 (dividends), 9 (reserves) outflow
///              only; 7 (rights issue) raise only
///   investing: 2, 3, 4, 5, 8, 9 buy only
///   operating: 5, 6, 7, 8 and anything with "inventory" spend only
AmountDirection defaultDirection(String module, String scenarioId, String? title) {
  final id = scenarioId;
  final t = (title ?? '').toLowerCase();
  if (module == 'operating') {
    if (t.contains('inventory')) return AmountDirection.negative;
    return const ['5', '6', '7', '8'].contains(id) ? AmountDirection.negative : AmountDirection.both;
  }
  if (module == 'financing') {
    if (id == '7') return AmountDirection.positive;
    if (const ['6', '8', '9'].contains(id)) return AmountDirection.negative;
    return AmountDirection.both;
  }
  return const ['2', '3', '4', '5', '8', '9'].contains(id) ? AmountDirection.negative : AmountDirection.both;
}

/// The server's resolved `direction` when it sent one, else the default.
AmountDirection directionFor(String module, String scenarioId, String? title, String? direction) {
  switch (direction) {
    case 'positive':
      return AmountDirection.positive;
    case 'negative':
      return AmountDirection.negative;
    case 'both':
      return AmountDirection.both;
  }
  return defaultDirection(module, scenarioId, title);
}

/// A localized error when [amount]'s sign is not allowed, else null.
String? validateAmountDirection(AppStrings s, AmountDirection d, double amount) {
  switch (d) {
    case AmountDirection.positive:
      return amount < 0
          ? s.tr('This amount must be positive or zero.', 'يجب أن يكون هذا المبلغ موجبًا أو صفرًا.')
          : null;
    case AmountDirection.negative:
      return amount > 0
          ? s.tr('This amount must be negative or zero.', 'يجب أن يكون هذا المبلغ سالبًا أو صفرًا.')
          : null;
    case AmountDirection.both:
      return null;
  }
}

/// Generic words for + / − on a module: (positive, negative).
(String, String) moduleDirectionVerbs(AppStrings s, String module) {
  switch (module) {
    case 'financing':
      return (s.tr('Raise / Borrow', 'جمع / اقتراض'), s.tr('Repay / Return', 'سداد / إرجاع'));
    case 'investing':
      return (s.tr('Sell / Divest', 'بيع / تصفية'), s.tr('Buy / Invest', 'شراء / استثمار'));
    default: // operating
      return (s.tr('Save / Cut cost', 'توفير / خفض التكلفة'), s.tr('Spend / Expand', 'إنفاق / توسّع'));
  }
}
