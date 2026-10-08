// What a decision amount does, in words: which accounts move on which statement, and what
// the decision means. A port of the website's shared/decision-impact.ts (with
// shared/ppe-schedule.ts lifeForCard/annualDepreciation and shared/eosb-schedule.ts eosbRate).
//
// The rule TABLE (accounts, cash-flow sections, meanings, which income builder each card
// uses) is generated from the TypeScript into decision_impact_rules.g.dart; the builders and
// describeImpact() below are the hand port, checked against a golden fixture produced by the
// same generator (test/fixtures/decision_impact_golden.json).
//
// Keyed by module and ENGINE row (1-9): the row the amount books to in the model template.
// The server gives every card its engineRow (Scenario.engineRow).

part 'decision_impact_rules.g.dart';

enum ImpactLang { en, ar }

/// A bilingual string.
class Bi {
  final String en;
  final String ar;
  const Bi(this.en, this.ar);
  String of(ImpactLang lang) => lang == ImpactLang.ar ? ar : en;
}

/// The model rates the rules use, keyed as in model_assumptions (GET /api/model/rates).
/// Any key the server does not send keeps its template value.
class ModelRates {
  final Map<String, double> _values;
  const ModelRates._(this._values);

  static const ModelRates template = ModelRates._(kTemplateRates);

  /// Overlay a `rates` map (from /api/model/rates) on the template values.
  factory ModelRates.fromJson(Map<String, dynamic>? json) {
    if (json == null || json.isEmpty) return template;
    final values = Map<String, double>.from(kTemplateRates);
    json.forEach((key, value) {
      if (!values.containsKey(key)) return;
      final v = value is num ? value.toDouble() : double.tryParse('$value');
      if (v != null && v.isFinite) values[key] = v;
    });
    return ModelRates._(values);
  }

  double operator [](String key) => _values[key] ?? kTemplateRates[key] ?? 0;

  double get interestExpenseRate => this['interestExpenseRate'];
  double get taxRate => this['taxRate'];
  double get revenueMultiplier => this['revenueMultiplier'];
  double get marketingROI => this['marketingROI'];
  double get inventoryWriteOffRate => this['inventoryWriteOffRate'];
  double get capacityPerSarOfPpe => this['capacityPerSarOfPpe'];
  double get productivityPerMillion => this['productivityPerMillion'];
  double get productivityCap => this['productivityCap'];
  double get marketingCarryOver => this['marketingCarryOver'];
  double get lifeIntangibles => this['lifeIntangibles'];
}

class ImpactLine {
  /// 'balance' | 'income' | 'cashflow'
  final String statement;
  final String text;
  const ImpactLine(this.statement, this.text);
}

class DecisionImpact {
  final List<ImpactLine> lines;
  final String meaning;

  /// Short heading for the panel.
  final String heading;
  const DecisionImpact({required this.lines, required this.meaning, required this.heading});
}

// ---------------------------------------------------------------- formatting (JS parity)

/// A number as JavaScript's String(n) prints it: 5 -> "5", 2.5 -> "2.5".
String _jsNum(num n) {
  if (n is int) return '$n';
  if (n.isFinite && n == n.truncateToDouble() && n.abs() < 1e21) return n.toInt().toString();
  return n.toString();
}

/// JS Math.round: halves round toward +infinity.
double _jsRound(double x) => (x + 0.5).floorToDouble();

String _thousands(int n) {
  final s = n.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
    buf.write(s[i]);
  }
  return buf.toString();
}

/// SAR with thousands separators, no decimals; sign carried by the caller's wording.
String fmtSar(num n, ImpactLang lang) {
  final abs = _jsRound(n.abs().toDouble()).toInt();
  final digits = _thousands(abs);
  return lang == ImpactLang.ar ? "$digits ريال" : "SAR $digits";
}

String _pct(double r, ImpactLang lang) {
  final tenths = _jsRound(r * 1000) / 10; // 0.07 -> 7, 0.075 -> 7.5
  final v = tenths == tenths.truncateToDouble() ? _jsNum(tenths) : tenths.toStringAsFixed(1);
  return lang == ImpactLang.ar ? '$v٪' : '$v%';
}

String statementName(String statement, ImpactLang lang) =>
    _statementNames[statement]?.of(lang) ?? statement;

// ---------------------------------------------------------------- schedules (ppe / eosb)

double _lifeForCard(int engineRow, ModelRates r) {
  switch (engineRow) {
    case 1:
      return r['lifeMachinery'];
    case 2:
      return r['lifeBuildings'];
    case 3:
      return r['lifeAutomation'];
    case 4:
      return r['lifeTechnology'];
    case 5:
      return r['lifeNewRegion'];
    case 8:
      return r['lifeIntangibles'];
    default:
      return 0;
  }
}

double _annualDepreciation(double cost, double lifeYears) =>
    lifeYears > 0 ? (cost < 0 ? 0 : cost) / lifeYears : 0;

double _eosbRate(int serviceYear, ModelRates r) {
  final stepped = serviceYear <= 5 ? r['eosbRateYears1to5'] : r['eosbAccrualRateOfSalaryCost'];
  final mode = r['eosbRateMode'].clamp(0.0, 1.0);
  return mode * stepped + (1 - mode) * r['eosbAccrualRateOfSalaryCost'];
}

// ---------------------------------------------------------------- rule table types

class _Rule {
  /// balance-sheet account(s) that move, besides cash
  final Bi bsAccount;

  /// cash also moves (false for pure equity appropriations)
  final bool cashMoves;

  /// which cash-flow section: 'financing' | 'investing' | 'operating' | null
  final String? cf;

  /// income statement effect builder; null = none
  final _Income? income;
  final Bi meaningPlus;
  final Bi meaningMinus;

  const _Rule({
    required this.bsAccount,
    required this.cashMoves,
    required this.cf,
    required this.income,
    required this.meaningPlus,
    required this.meaningMinus,
  });
}

String _yearly(ImpactLang lang) => lang == ImpactLang.ar ? 'سنويًا' : 'a year';
String _join(List<String> parts, ImpactLang lang) => parts.join(lang == ImpactLang.ar ? '؛ ' : '; ');

abstract class _Income {
  const _Income();
  String describe(double amt, ModelRates r, ImpactLang lang);
}

/// Text that depends only on the sign of the amount.
class _FixedIncome extends _Income {
  final Bi plus;
  final Bi minus;
  const _FixedIncome(this.plus, this.minus);
  @override
  String describe(double amt, ModelRates r, ImpactLang lang) => (amt > 0 ? plus : minus).of(lang);
}

class _InterestIncome extends _Income {
  final Bi label;
  const _InterestIncome(this.label);
  @override
  String describe(double amt, ModelRates r, ImpactLang lang) {
    final interest = amt.abs() * r.interestExpenseRate;
    final shield = interest * r.taxRate;
    final up = amt > 0;
    return lang == ImpactLang.ar
        ? '${label.ar} ${up ? 'يرتفع' : 'ينخفض'} بنحو ${fmtSar(interest, lang)} ${_yearly(lang)} من هذا العام (${_pct(r.interestExpenseRate, lang)})، ووفر ضريبي قدره ${fmtSar(shield, lang)}'
        : '${label.en} ${up ? 'rises' : 'falls'} by about ${fmtSar(interest, lang)} ${_yearly(lang)} from this year (${_pct(r.interestExpenseRate, lang)}); tax shield ${fmtSar(shield, lang)}';
  }
}

/// Capital cards: straight-line depreciation over the class life, capacity and a persistent
/// sales lift; automation and technology also cut cost of sales.
class _CapexIncome extends _Income {
  final int engineRow;
  const _CapexIncome(this.engineRow);
  @override
  String describe(double amt, ModelRates r, ImpactLang lang) {
    final ar = lang == ImpactLang.ar;
    final buy = amt < 0;
    final life = _lifeForCard(engineRow, r);
    final parts = <String>[];
    if (buy) {
      final dep = _annualDepreciation(amt.abs(), life);
      final cap = amt.abs() * r.capacityPerSarOfPpe;
      final lift = amt.abs() * r.revenueMultiplier;
      parts.add(ar
          ? 'إهلاك ${fmtSar(dep, lang)} ${_yearly(lang)} لمدة ${_jsNum(life)} سنوات (قسط ثابت على التكلفة، يُسجَّل في الإهلاك والإطفاء لا في المصروفات التشغيلية)'
          : 'depreciation of ${fmtSar(dep, lang)} ${_yearly(lang)} for ${_jsNum(life)} years (straight-line on cost, booked in D&A, not in operating expenses)');
      parts.add(ar
          ? 'يضيف طاقة مبيعات ${fmtSar(cap, lang)} ويرفع المبيعات بنحو ${fmtSar(lift, lang)} ${_yearly(lang)} ما دام الأصل في الخدمة'
          : 'adds ${fmtSar(cap, lang)} of sales capacity and lifts sales by about ${fmtSar(lift, lang)} ${_yearly(lang)} while in service');
      if (engineRow == 3 || engineRow == 4) {
        final raw = r.productivityPerMillion * (amt.abs() / 1000000);
        final cut = raw < r.productivityCap ? raw : r.productivityCap;
        parts.add(ar
            ? 'يخفض نسبة تكلفة المبيعات بنحو ${_pct(cut, lang)} (نقطة لكل مليون، بحد ${_pct(r.productivityCap, lang)})'
            : 'cuts the cost-of-sales percentage by about ${_pct(cut, lang)} (1 point per million, capped at ${_pct(r.productivityCap, lang)})');
      }
    } else {
      parts.add(ar
          ? 'يخرج الأصل بقيمته الدفترية ويتوقف إهلاكه؛ تنخفض طاقة المبيعات؛ لا ربح ولا خسارة بيع في هذا النموذج'
          : 'the asset leaves at book value and its depreciation stops; sales capacity falls; no gain or loss in this model');
    }
    return _join(parts, lang);
  }
}

class _OpexIncome extends _Income {
  final bool salesLift;
  final Bi? extra;
  // ignore: unused_element_parameter
  const _OpexIncome(this.salesLift, [this.extra]); // extra: the TS builder's optional suffix
  @override
  String describe(double amt, ModelRates r, ImpactLang lang) {
    final ar = lang == ImpactLang.ar;
    final spend = amt < 0;
    final a = fmtSar(amt, lang);
    final parts = <String>[
      ar
          ? (spend
              ? 'المصروفات التشغيلية ترتفع بمقدار $a هذا العام، فينخفض الربح التشغيلي بالقدر نفسه'
              : 'المصروفات التشغيلية تنخفض بمقدار $a هذا العام، فيرتفع الربح التشغيلي بالقدر نفسه')
          : (spend
              ? 'operating expenses rise by $a this year, so operating profit falls by the same'
              : 'operating expenses fall by $a this year, so operating profit rises by the same'),
    ];
    if (salesLift && spend) {
      final lift = amt.abs() * r.marketingROI;
      final carry = lift * r.marketingCarryOver;
      parts.add(ar
          ? 'المبيعات ترتفع بنحو ${fmtSar(lift, lang)} هذا العام (${_pct(r.marketingROI, lang)} من الإنفاق) و${fmtSar(carry, lang)} العام القادم'
          : 'sales rise by about ${fmtSar(lift, lang)} this year (${_pct(r.marketingROI, lang)} of the spend) and ${fmtSar(carry, lang)} next year');
    }
    if (salesLift && !spend) {
      parts.add(ar ? 'التخفيض يوفر التكلفة ولا يرفع المبيعات' : 'a cut saves the cost and lifts nothing');
    }
    if (extra != null) parts.add(extra!.of(lang));
    return _join(parts, lang);
  }
}

/// Staff cards: wages are expensed, plus a non-cash end-of-service accrual at the year 1-5 rate.
class _StaffIncome extends _Income {
  final bool salesLift;
  const _StaffIncome(this.salesLift);
  @override
  String describe(double amt, ModelRates r, ImpactLang lang) {
    final ar = lang == ImpactLang.ar;
    final spend = amt < 0;
    final rate = _eosbRate(1, r);
    final a = fmtSar(amt, lang);
    final accrual = fmtSar(amt.abs() * rate, lang);
    final parts = <String>[];
    if (spend) {
      parts.add(ar
          ? 'المصروفات التشغيلية ترتفع بمقدار $a (أجور) زائد مخصص نهاية خدمة $accrual (${_pct(rate, lang)} من الأجور، غير نقدي)'
          : 'operating expenses rise by $a (wages) plus an end-of-service accrual of $accrual (${_pct(rate, lang)} of wages, non-cash)');
      if (salesLift) {
        final lift = amt.abs() * r.marketingROI;
        parts.add(ar
            ? 'المبيعات ترتفع بنحو ${fmtSar(lift, lang)} (${_pct(r.marketingROI, lang)} من الإنفاق)'
            : 'sales rise by about ${fmtSar(lift, lang)} (${_pct(r.marketingROI, lang)} of the spend)');
      }
    } else {
      parts.add(ar
          ? 'المصروفات التشغيلية تنخفض بمقدار $a؛ يُدفع $accrual من مخصص نهاية الخدمة نقدًا، دون أثر على الربح'
          : 'operating expenses fall by $a; $accrual is paid out of the end-of-service provision in cash, with no effect on profit');
    }
    return _join(parts, lang);
  }
}

/// Inventory: the share sold in the year goes to cost of sales, the rest next year; never opex.
class _InventoryIncome extends _Income {
  const _InventoryIncome();
  @override
  String describe(double amt, ModelRates r, ImpactLang lang) {
    final cost = amt.abs();
    final sold = fmtSar(cost * r.inventoryWriteOffRate, lang);
    final rest = fmtSar(cost * (1 - r.inventoryWriteOffRate), lang);
    return lang == ImpactLang.ar
        ? 'تكلفة المبيعات ترتفع بمقدار $sold هذا العام (${_pct(r.inventoryWriteOffRate, lang)} من الشراء) و$rest العام القادم عند بيع الباقي؛ ينخفض مجمل الربح؛ لا يُحمَّل شيء على المصروفات التشغيلية'
        : 'cost of sales rises by $sold this year (${_pct(r.inventoryWriteOffRate, lang)} of the purchase) and $rest next year as the rest is sold; gross profit falls; nothing is charged to operating expenses';
  }
}

/// Intangibles (investing row 8): straight-line amortisation over the intangibles life.
class _AmortizationIncome extends _Income {
  const _AmortizationIncome();
  @override
  String describe(double amt, ModelRates r, ImpactLang lang) {
    final a = _annualDepreciation(amt.abs(), r.lifeIntangibles);
    return lang == ImpactLang.ar
        ? 'إطفاء ${fmtSar(a, lang)} ${_yearly(lang)} على ${_jsNum(r.lifeIntangibles)} سنوات (قسط ثابت، معيار المحاسبة الدولي 38)'
        : 'amortization of ${fmtSar(a, lang)} ${_yearly(lang)} over ${_jsNum(r.lifeIntangibles)} years (straight-line, IAS 38)';
  }
}

// ---------------------------------------------------------------- describeImpact

bool hasImpactRule(String module, int engineRow) => _rules[module]?[engineRow] != null;

/// Describe what [amount] does on this card. Returns null when the amount is zero or the row
/// is unknown. Amount sign follows the app: for financing + is cash in; for investing and
/// operating - is cash out (buy / spend).
DecisionImpact? describeImpact(
  String module,
  int engineRow,
  double amount, {
  ModelRates rates = ModelRates.template,
  ImpactLang lang = ImpactLang.en,
}) {
  final rule = _rules[module]?[engineRow];
  if (rule == null || !amount.isFinite || amount == 0) return null;
  final ar = lang == ImpactLang.ar;
  final a = fmtSar(amount, lang);
  final cashIn = amount > 0; // every module: + is cash in, - is cash out
  final lines = <ImpactLine>[];

  String dir(bool up) => ar ? (up ? 'يرتفع' : 'ينخفض') : (up ? 'up' : 'down');
  String bs;
  if (module == 'financing' && !rule.cashMoves) {
    bs = ar
        ? '${rule.bsAccount.ar} ${dir(false)} بمقدار $a؛ الاحتياطي العام ${dir(true)} بمقدار $a؛ النقد لا يتغير'
        : '${rule.bsAccount.en} ${dir(false)} $a; general reserve ${dir(true)} $a; cash unchanged';
  } else if (module == 'financing') {
    final accountUp = amount > 0 && engineRow != 8 && engineRow != 9;
    final accountDown = amount < 0;
    final up = (engineRow == 8 || engineRow == 9) ? false : accountUp && !accountDown;
    bs = ar
        ? '${rule.bsAccount.ar} ${dir(up)} بمقدار $a؛ النقد ${dir(cashIn)} بمقدار $a'
        : '${rule.bsAccount.en} ${dir(up)} $a; cash ${dir(cashIn)} $a';
  } else if (module == 'investing') {
    final buy = amount < 0;
    bs = ar
        ? '${rule.bsAccount.ar} ${dir(buy)} بمقدار $a؛ النقد ${dir(!buy)} بمقدار $a'
        : '${rule.bsAccount.en} ${dir(buy)} $a; cash ${dir(!buy)} $a';
  } else {
    final spend = amount < 0;
    final acct = rule.bsAccount.of(lang);
    if (engineRow == 9) {
      final kept = fmtSar(amount.abs() * (1 - rates.inventoryWriteOffRate), lang);
      final keptPct = _pct(1 - rates.inventoryWriteOffRate, lang);
      lines.add(ImpactLine(
        'balance',
        ar
            ? '$acct ${dir(spend)} بمقدار $kept ($keptPct من الشراء يبقى في المخزون)؛ النقد ${dir(!spend)} بمقدار $a'
            : '$acct ${dir(spend)} $kept ($keptPct of the purchase stays in stock); cash ${dir(!spend)} $a',
      ));
      return _finish(rule, lines, amount, rates, lang);
    }
    if (engineRow == 2 || engineRow == 8) {
      final prov = fmtSar(amount.abs() * _eosbRate(1, rates), lang);
      lines.add(ImpactLine(
        'balance',
        ar
            ? (spend
                ? 'النقد ينخفض بمقدار $a؛ $acct يرتفع بمقدار $prov (استحقاق غير نقدي)'
                : 'النقد يرتفع بمقدار $a ناقص $prov تُدفع من $acct')
            : (spend
                ? 'cash down $a; $acct up $prov (non-cash accrual)'
                : 'cash up $a less $prov paid out of the ${acct.toLowerCase()}'),
      ));
      return _finish(rule, lines, amount, rates, lang);
    }
    final acctPart = ar ? '$acct؛ ' : '$acct; ';
    bs = ar ? '$acctPartالنقد ${dir(!spend)} بمقدار $a' : '${acctPart}cash ${dir(!spend)} $a';
  }
  lines.add(ImpactLine('balance', bs));
  return _finish(rule, lines, amount, rates, lang);
}

DecisionImpact _finish(
  _Rule rule,
  List<ImpactLine> lines,
  double amount,
  ModelRates rates,
  ImpactLang lang,
) {
  final ar = lang == ImpactLang.ar;
  final a = fmtSar(amount, lang);
  final cashIn = amount > 0;
  // Income statement
  lines.add(ImpactLine(
    'income',
    rule.income != null
        ? rule.income!.describe(amount, rates, lang)
        : (ar ? 'لا أثر مباشر على الربح' : 'no direct effect on profit'),
  ));

  // Cash flow
  final cf = rule.cf;
  if (cf != null && rule.cashMoves) {
    final cfName = _cfNames[cf]!.of(lang);
    lines.add(ImpactLine(
      'cashflow',
      ar
          ? '${cashIn ? 'تدفق داخل' : 'تدفق خارج'} بمقدار $a ضمن $cfName'
          : '${cashIn ? 'inflow' : 'outflow'} of $a under $cfName',
    ));
  } else {
    lines.add(ImpactLine(
      'cashflow',
      ar ? 'لا حركة نقدية: تحويل داخل حقوق الملكية' : 'no cash movement: a transfer within equity',
    ));
  }

  final primary = (amount > 0 ? rule.meaningPlus : rule.meaningMinus).of(lang);
  final meaning =
      primary.isNotEmpty ? primary : (amount > 0 ? rule.meaningMinus : rule.meaningPlus).of(lang);
  final heading = ar ? 'ماذا يفعل هذا المبلغ' : 'What this amount does';
  return DecisionImpact(lines: lines, meaning: meaning, heading: heading);
}
