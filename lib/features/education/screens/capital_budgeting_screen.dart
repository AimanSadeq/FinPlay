import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../app/i18n/app_strings.dart';
import '../../../core/services/learn_resume.dart';

// ─── DATA MODELS ───────────────────────────────────────────────────────────────

/// One Learn slide, ported verbatim (EN + AR) from the website's
/// capital-budgeting-slides-content.ts (CB.1-CB.14). [id] is the website section id: it is what
/// the resume position stores, so it must stay identical to the web.
class CapitalBudgetingSlide {
  final String id;
  final String number;
  final String title;
  final String titleAr;
  final List<String> content;
  final List<String> contentAr;
  final List<String> keyPoints;
  final List<String> keyPointsAr;
  final String? highlightType;
  final String? highlight;
  final String? highlightAr;
  final String? examplesTitle;
  final String? examplesTitleAr;
  final List<String> examples;
  final List<String> examplesAr;

  const CapitalBudgetingSlide({
    required this.id,
    required this.number,
    required this.title,
    required this.titleAr,
    required this.content,
    required this.contentAr,
    this.keyPoints = const [],
    this.keyPointsAr = const [],
    this.highlightType,
    this.highlight,
    this.highlightAr,
    this.examplesTitle,
    this.examplesTitleAr,
    this.examples = const [],
    this.examplesAr = const [],
  });

  static bool _has(String? v) => v != null && v.trim().isNotEmpty;
  static bool _hasAll(List<String> v) => v.isNotEmpty && v.every(_has);

  // Arabic when the UI is Arabic and a translation exists, else English.
  String titleFor(bool ar) => ar && _has(titleAr) ? titleAr : title;
  List<String> contentFor(bool ar) => ar && _hasAll(contentAr) ? contentAr : content;
  List<String> keyPointsFor(bool ar) => ar && _hasAll(keyPointsAr) ? keyPointsAr : keyPoints;
  String? highlightFor(bool ar) => ar && _has(highlightAr) ? highlightAr : highlight;
  String? examplesTitleFor(bool ar) => ar && _has(examplesTitleAr) ? examplesTitleAr : examplesTitle;
  List<String> examplesFor(bool ar) => ar && _hasAll(examplesAr) ? examplesAr : examples;
}

class _PracticeScenario {
  final String title;
  final String location;
  final String currency;
  final String difficulty;
  final Color difficultyColor;
  final String context;
  final String givenData;
  final String calculation;
  final String result;
  final String verdict;

  /// Graded-practice target. [answer] is the known correct numeric value the
  /// learner should arrive at; [answerLabel]/[answerUnit] describe what to enter
  /// (e.g. "NPV" / "SAR"). Answers are graded within a ±5% tolerance.
  final double answer;
  final String answerLabel;
  final String answerUnit;

  const _PracticeScenario({
    required this.title,
    required this.location,
    required this.currency,
    required this.difficulty,
    required this.difficultyColor,
    required this.context,
    required this.givenData,
    required this.calculation,
    required this.result,
    required this.verdict,
    required this.answer,
    required this.answerLabel,
    required this.answerUnit,
  });
}

// ─── SLIDE DATA ────────────────────────────────────────────────────────────────

// Ported from the website by a generator (tool/generators/gen_decks.ts + patch_decks.py); do not hand-edit.
const List<CapitalBudgetingSlide> capitalBudgetingSlides = [
  CapitalBudgetingSlide(
    id: 'section-cb-overview',
    number: 'CB.1',
    title: 'Introduction to Capital Budgeting',
    titleAr: 'مقدمة في موازنة رأس المال',
    content: ['Capital budgeting is the process of evaluating long-term investments such as equipment purchases, expansions or new product launches. The goal is to determine which projects add the most value to the company.', 'One principle governs the whole subject: a riyal today is worth more than a riyal tomorrow, because a riyal held today can be invested. Every technique in this module is a way of applying that idea to a stream of future cash flows.', 'It leads to three decision rules you will meet in turn: accept a project when its net present value is positive, when its internal rate of return exceeds the hurdle rate, and prefer a shorter payback where two projects are otherwise equal.'],
    contentAr: ['موازنة رأس المال هي عملية تقييم الاستثمارات طويلة الأجل مثل شراء المعدات أو التوسع أو إطلاق منتجات جديدة. والهدف تحديد أي المشاريع يضيف أكبر قيمة للشركة.', 'ويحكم الموضوع كله مبدأ واحد: الريال اليوم يساوي أكثر من الريال غداً، لأن الريال المحتفظ به اليوم يمكن استثماره. وكل أسلوب في هذه الوحدة طريقة لتطبيق تلك الفكرة على سلسلة من التدفقات النقدية المستقبلية.', 'ويقود ذلك إلى ثلاث قواعد قرار ستقابلها تباعاً: اقبل المشروع حين يكون صافي قيمته الحالية موجباً، وحين يفوق معدل عائده الداخلي المعدل المطلوب، وفضّل الاسترداد الأقصر حين يتساوى مشروعان فيما عدا ذلك.'],
    keyPoints: ['A riyal today is worth more than a riyal tomorrow', 'NPV above zero, IRR above the hurdle rate, shorter payback', 'These decisions are large and usually irreversible'],
    keyPointsAr: ['الريال اليوم يساوي أكثر من الريال غداً', 'صافي قيمة حالية فوق الصفر، ومعدل عائد داخلي فوق المطلوب، واسترداد أقصر', 'هذه القرارات كبيرة وغير قابلة للعكس عادةً'],
  ),
  CapitalBudgetingSlide(
    id: 'section-cb-1',
    number: 'CB.2',
    title: 'What is Capital Budgeting?',
    titleAr: 'ما هي الموازنة الرأسمالية؟',
    content: ['Capital budgeting is the process of evaluating and selecting long-term investment projects that will generate returns over multiple years.', 'These decisions involve significant capital outlay - purchasing equipment, building facilities, launching new products, or expanding into new markets.', 'Unlike day-to-day operating decisions, capital budgeting decisions are often irreversible and have long-lasting impacts on the organization.', 'The fundamental challenge is comparing an upfront cost today with uncertain future cash flows, requiring the use of discounting techniques.'],
    contentAr: ['الموازنة الرأسمالية هي عملية تقييم واختيار المشاريع الاستثمارية طويلة الأجل التي ستولد عوائد على مدى سنوات متعددة.', 'تتضمن هذه القرارات إنفاقاً رأسمالياً كبيراً - شراء المعدات، بناء المنشآت، إطلاق منتجات جديدة، أو التوسع في أسواق جديدة.', 'على عكس القرارات التشغيلية اليومية، غالباً ما تكون قرارات الموازنة الرأسمالية غير قابلة للعكس ولها تأثيرات طويلة الأمد على المنظمة.', 'التحدي الأساسي هو مقارنة تكلفة مقدمة اليوم بتدفقات نقدية مستقبلية غير مؤكدة، مما يتطلب استخدام تقنيات الخصم.'],
    keyPoints: ['Evaluates long-term investment projects', 'Decisions are often irreversible', 'Compares upfront costs with future returns'],
    keyPointsAr: ['يقيّم المشاريع الاستثمارية طويلة الأجل', 'القرارات غالباً غير قابلة للعكس', 'يقارن التكاليف المقدمة بالعوائد المستقبلية'],
  ),
  CapitalBudgetingSlide(
    id: 'section-cb-2',
    number: 'CB.3',
    title: 'Time Value of Money',
    titleAr: 'القيمة الزمنية للنقود',
    content: ['The Time Value of Money (TVM) is the concept that a dollar today is worth more than a dollar in the future, because today\'s dollar can be invested to earn returns.', 'This principle arises from three factors: the opportunity cost of capital, the risk of not receiving future payments, and the eroding effect of inflation.', 'TVM is the foundation of all capital budgeting methods. Without accounting for time value, comparing investments made today with returns received years later would be meaningless.', 'The discount rate reflects the required return - the minimum rate an investment must earn to be considered worthwhile, accounting for risk and opportunity cost.'],
    contentAr: ['القيمة الزمنية للنقود هي مفهوم أن الدولار اليوم يساوي أكثر من الدولار في المستقبل، لأن دولار اليوم يمكن استثماره لكسب عوائد.', 'ينشأ هذا المبدأ من ثلاثة عوامل: تكلفة الفرصة البديلة لرأس المال، وخطر عدم استلام المدفوعات المستقبلية، والتأثير المتآكل للتضخم.', 'القيمة الزمنية للنقود هي أساس جميع طرق الموازنة الرأسمالية. بدون مراعاة القيمة الزمنية، ستكون مقارنة الاستثمارات التي تتم اليوم بالعوائد المستلمة بعد سنوات بلا معنى.', 'يعكس معدل الخصم العائد المطلوب - الحد الأدنى للمعدل الذي يجب أن يحققه الاستثمار ليعتبر جديراً بالاهتمام، مع مراعاة المخاطر وتكلفة الفرصة البديلة.'],
    keyPoints: ['A dollar today > a dollar tomorrow', 'Driven by opportunity cost, risk, and inflation', 'Foundation of all capital budgeting methods'],
    keyPointsAr: ['الدولار اليوم أكثر قيمة من دولار الغد', 'مدفوع بتكلفة الفرصة والمخاطر والتضخم', 'أساس جميع طرق الموازنة الرأسمالية'],
  ),
  CapitalBudgetingSlide(
    id: 'section-cb-3',
    number: 'CB.4',
    title: 'Present & Future Value',
    titleAr: 'القيمة الحالية والمستقبلية',
    content: ['Future Value (FV) calculates what an amount invested today will grow to at a given interest rate over time: FV = PV x (1 + r)^n.', 'Present Value (PV) calculates what a future amount is worth today by discounting it back: PV = FV / (1 + r)^n.', 'The discount factor 1/(1+r)^n decreases as n increases, meaning cash flows further in the future are worth progressively less today.', 'These formulas can be applied to single amounts or to streams of cash flows (annuities). Most capital budgeting involves discounting a series of future cash flows.'],
    contentAr: ['القيمة المستقبلية تحسب ما سينمو إليه مبلغ مستثمر اليوم بمعدل فائدة معين بمرور الوقت: القيمة المستقبلية = القيمة الحالية × (1 + معدل)^عدد الفترات.', 'القيمة الحالية تحسب ما يساويه مبلغ مستقبلي اليوم بخصمه: القيمة الحالية = القيمة المستقبلية / (1 + معدل)^عدد الفترات.', 'عامل الخصم 1/(1+معدل)^عدد الفترات يتناقص كلما زادت الفترات، مما يعني أن التدفقات النقدية البعيدة في المستقبل تساوي أقل تدريجياً اليوم.', 'يمكن تطبيق هذه الصيغ على مبالغ فردية أو على سلسلة من التدفقات النقدية (الدفعات السنوية). معظم الموازنة الرأسمالية تتضمن خصم سلسلة من التدفقات النقدية المستقبلية.'],
    keyPoints: ['FV = PV x (1 + r)^n', 'PV = FV / (1 + r)^n', 'Farther cash flows are worth less today'],
    keyPointsAr: ['القيمة المستقبلية = القيمة الحالية × (1 + معدل)^ن', 'القيمة الحالية = القيمة المستقبلية / (1 + معدل)^ن', 'التدفقات الأبعد تساوي أقل اليوم'],
    highlightType: 'formula',
    highlight: 'PV = FV / (1 + r)^n  |  FV = PV x (1 + r)^n',
    highlightAr: 'القيمة الحالية = القيمة المستقبلية / (1 + معدل)^ن',
  ),
  CapitalBudgetingSlide(
    id: 'section-cb-4',
    number: 'CB.5',
    title: 'Net Present Value (NPV)',
    titleAr: 'صافي القيمة الحالية',
    content: ['Net Present Value (NPV) is the sum of all discounted future cash flows minus the initial investment. It represents the value a project adds to the firm.', 'NPV = -Initial Investment + CF1/(1+r)^1 + CF2/(1+r)^2 + ... + CFn/(1+r)^n, where r is the discount rate.', 'Decision rule: Accept the project if NPV > 0 (adds value), reject if NPV < 0 (destroys value). NPV = 0 means the project earns exactly the required return.', 'NPV is considered the gold standard of capital budgeting because it directly measures wealth creation in today\'s dollars, accounting for risk and time value.'],
    contentAr: ['صافي القيمة الحالية هو مجموع كل التدفقات النقدية المستقبلية المخصومة ناقص الاستثمار الأولي. يمثل القيمة التي يضيفها المشروع للشركة.', 'صافي القيمة الحالية = -الاستثمار الأولي + التدفق1/(1+معدل)^1 + التدفق2/(1+معدل)^2 + ... + التدفقn/(1+معدل)^n.', 'قاعدة القرار: اقبل المشروع إذا كان صافي القيمة الحالية > 0 (يضيف قيمة)، ارفض إذا < 0 (يدمر القيمة). صافي القيمة الحالية = 0 يعني أن المشروع يحقق بالضبط العائد المطلوب.', 'يُعتبر صافي القيمة الحالية المعيار الذهبي للموازنة الرأسمالية لأنه يقيس مباشرة خلق الثروة بدولارات اليوم، مع مراعاة المخاطر والقيمة الزمنية.'],
    keyPoints: ['NPV = Sum of discounted CFs - Initial Investment', 'Accept if NPV > 0, Reject if NPV < 0', 'Gold standard of capital budgeting'],
    keyPointsAr: ['صافي القيمة الحالية = مجموع التدفقات المخصومة - الاستثمار الأولي', 'اقبل إذا > 0، ارفض إذا < 0', 'المعيار الذهبي للموازنة الرأسمالية'],
    highlightType: 'formula',
    highlight: 'NPV = -I₀ + CF₁/(1+r)¹ + CF₂/(1+r)² + ... + CFₙ/(1+r)ⁿ',
    highlightAr: 'صافي القيمة الحالية = -الاستثمار + مجموع التدفقات المخصومة',
  ),
  CapitalBudgetingSlide(
    id: 'section-cb-5',
    number: 'CB.6',
    title: 'Internal Rate of Return (IRR)',
    titleAr: 'معدل العائد الداخلي',
    content: ['The Internal Rate of Return (IRR) is the discount rate that makes the NPV of a project equal to zero. It represents the project\'s own rate of return.', 'Decision rule: Accept if IRR > required rate of return (hurdle rate), reject if IRR < hurdle rate.', 'IRR is intuitive because it expresses project profitability as a percentage, making it easy to compare with the cost of capital - which is the correct hurdle rate for projects of average risk.', 'Limitations: (1) with non-conventional cash flows (more than one sign change), a project can have multiple IRRs or none at all; (2) IRR implicitly assumes interim cash flows are reinvested at the IRR itself, which overstates attractiveness when the IRR is high - NPV assumes reinvestment at the cost of capital, a more realistic rate; (3) for mutually exclusive projects of different sizes or timing, IRR rankings can conflict with NPV rankings - when they conflict, follow NPV, because it measures the value added in currency terms.'],
    contentAr: ['معدل العائد الداخلي هو معدل الخصم الذي يجعل صافي القيمة الحالية للمشروع يساوي صفراً. يمثل معدل العائد الخاص بالمشروع.', 'قاعدة القرار: اقبل إذا كان معدل العائد الداخلي > معدل العائد المطلوب، ارفض إذا كان أقل.', 'معدل العائد الداخلي بديهي لأنه يعبر عن ربحية المشروع كنسبة مئوية، مما يسهل مقارنته بتكلفة رأس المال - وهي معدل العائد المطلوب الصحيح للمشاريع ذات المخاطر المتوسطة.', 'القيود: (1) مع التدفقات النقدية غير التقليدية (أكثر من تغير واحد في الإشارة) قد يكون للمشروع أكثر من معدل عائد داخلي أو لا يوجد له معدل أصلاً؛ (2) يفترض معدل العائد الداخلي ضمنياً إعادة استثمار التدفقات المرحلية بالمعدل نفسه، مما يبالغ في جاذبية المشروع عندما يكون المعدل مرتفعاً - بينما يفترض صافي القيمة الحالية إعادة الاستثمار بتكلفة رأس المال، وهو معدل أكثر واقعية؛ (3) في المشاريع المتنافية المختلفة في الحجم أو التوقيت قد يتعارض ترتيب معدل العائد الداخلي مع ترتيب صافي القيمة الحالية - وعند التعارض اتبع صافي القيمة الحالية لأنه يقيس القيمة المضافة بوحدات نقدية.'],
    keyPoints: ['Discount rate that makes NPV = 0', 'Accept if IRR > cost of capital (hurdle rate)', 'When IRR and NPV conflict, follow NPV'],
    keyPointsAr: ['معدل الخصم الذي يجعل صافي القيمة الحالية = 0', 'اقبل إذا كان أعلى من تكلفة رأس المال (المعدل المطلوب)', 'عند تعارض المعدل مع صافي القيمة الحالية، اتبع صافي القيمة الحالية'],
  ),
  CapitalBudgetingSlide(
    id: 'section-cb-6',
    number: 'CB.7',
    title: 'Payback Period',
    titleAr: 'فترة الاسترداد',
    content: ['The payback period is the time it takes for cumulative cash flows to recover the initial investment. Shorter payback periods are preferred.', 'Simple Payback does not account for the time value of money. Discounted Payback uses discounted cash flows for a more accurate measure.', 'To compute discounted payback, discount each year’s cash flow first - CF/(1+r)^n - then accumulate the discounted amounts until they cover the initial investment. Because discounting shrinks every inflow, discounted payback is always longer than simple payback.', 'Decision rule: Accept if payback period < the company\'s target cutoff period. Useful as a quick liquidity and risk screening tool.', 'Limitations: ignores cash flows after the payback period, does not measure total profitability, and may reject profitable long-term projects.'],
    contentAr: ['فترة الاسترداد هي الوقت اللازم للتدفقات النقدية التراكمية لاسترداد الاستثمار الأولي. فترات الاسترداد الأقصر مفضلة.', 'الاسترداد البسيط لا يراعي القيمة الزمنية للنقود. الاسترداد المخصوم يستخدم التدفقات النقدية المخصومة لقياس أكثر دقة.', 'ولحساب الاسترداد المخصوم، اخصم تدفق كل سنة أولاً - التدفق/(1+معدل)^ن - ثم اجمع المبالغ المخصومة تراكمياً حتى تغطي الاستثمار الأولي. ولأن الخصم يقلّص كل تدفق داخل، فإن الاسترداد المخصوم يكون دائماً أطول من الاسترداد البسيط.', 'قاعدة القرار: اقبل إذا كانت فترة الاسترداد أقل من الفترة المستهدفة للشركة. مفيدة كأداة فرز سريعة للسيولة والمخاطر.', 'القيود: تتجاهل التدفقات النقدية بعد فترة الاسترداد، لا تقيس الربحية الإجمالية، وقد ترفض مشاريع طويلة الأجل مربحة.'],
    keyPoints: ['Time to recover initial investment', 'Shorter payback = Lower risk', 'Does not measure total profitability'],
    keyPointsAr: ['الوقت لاسترداد الاستثمار الأولي', 'استرداد أقصر = مخاطر أقل', 'لا يقيس الربحية الإجمالية'],
  ),
  CapitalBudgetingSlide(
    id: 'section-cb-arr',
    number: 'CB.8',
    title: 'Accounting Rate of Return (ARR)',
    titleAr: 'معدل العائد المحاسبي',
    content: ['The Accounting Rate of Return (ARR) expresses a project’s average annual profit as a percentage of the money tied up in it. Unlike every other measure in this module it is built from accounting profit rather than discounted cash flow, which is exactly why boards still ask for it: it speaks the language of the income statement and the return-on-capital targets that management is judged against.', 'ARR = Average Annual Profit / Average Investment. Average annual profit is the total profit the project earns over its life divided by the number of years, where total profit is all the cash the project returns plus any salvage value, less the amount originally invested. Average investment is (Initial Investment + Salvage Value) / 2, the midpoint between what is put in at the start and what is left at the end.', 'Worked example: a 150,000 machine returning 45,000 a year for five years with no salvage value. Total profit is (5 x 45,000) - 150,000 = 75,000, so average annual profit is 15,000. Average investment is 150,000 / 2 = 75,000. ARR = 15,000 / 75,000 = 20 percent.', 'Decision rule: accept if ARR exceeds the company’s target accounting return. Limitations: it ignores the time value of money entirely and depends on accounting policy - a change in the depreciation method changes the ARR without changing a single riyal of cash. Use it alongside NPV, never instead of it.'],
    contentAr: ['معدل العائد المحاسبي يعبّر عن متوسط الربح السنوي للمشروع كنسبة مئوية من الأموال المرتبطة به. وهو - خلافاً لكل المقاييس الأخرى في هذه الوحدة - مبني على الربح المحاسبي لا على التدفق النقدي المخصوم، ولهذا تحديداً ما زالت المجالس تطلبه: فهو يتحدث بلغة قائمة الدخل وأهداف العائد على رأس المال التي تُقاس بها الإدارة.', 'معدل العائد المحاسبي = متوسط الربح السنوي / متوسط الاستثمار. ومتوسط الربح السنوي هو إجمالي ربح المشروع على مدى عمره مقسوماً على عدد السنوات، حيث إجمالي الربح هو كل ما يعيده المشروع من نقد زائداً القيمة المتبقية ناقصاً المبلغ المستثمر أصلاً. ومتوسط الاستثمار = (الاستثمار الأولي + القيمة المتبقية) / 2، أي منتصف المسافة بين ما يُوضع في البداية وما يتبقى في النهاية.', 'مثال محلول: آلة بـ 150,000 تعيد 45,000 سنوياً لخمس سنوات بلا قيمة متبقية. إجمالي الربح = (5 × 45,000) - 150,000 = 75,000، فيكون متوسط الربح السنوي 15,000. ومتوسط الاستثمار = 150,000 / 2 = 75,000. إذاً معدل العائد المحاسبي = 15,000 / 75,000 = 20 بالمئة.', 'قاعدة القرار: اقبل إذا تجاوز معدل العائد المحاسبي العائد المحاسبي المستهدف للشركة. أما القيود فهي أنه يتجاهل القيمة الزمنية للنقود تماماً ويعتمد على السياسة المحاسبية - فتغيير طريقة الإهلاك يغيّر المعدل دون أن يتغير ريال واحد من النقد. استخدمه إلى جانب صافي القيمة الحالية، لا بديلاً عنه.'],
    keyPoints: ['ARR = Average Annual Profit / Average Investment', 'Average Investment = (Initial Investment + Salvage) / 2', 'Ignores time value - pair it with NPV, never replace NPV'],
    keyPointsAr: ['معدل العائد المحاسبي = متوسط الربح السنوي / متوسط الاستثمار', 'متوسط الاستثمار = (الاستثمار الأولي + القيمة المتبقية) / 2', 'يتجاهل القيمة الزمنية - اقرنه بصافي القيمة الحالية ولا تستبدله به'],
    highlightType: 'formula',
    highlight: 'ARR = Average Annual Profit / Average Investment, where Average Investment = (I₀ + Salvage) / 2',
    highlightAr: 'معدل العائد المحاسبي = متوسط الربح السنوي / متوسط الاستثمار، حيث متوسط الاستثمار = (الاستثمار + القيمة المتبقية) ÷ 2',
  ),
  CapitalBudgetingSlide(
    id: 'section-cb-7',
    number: 'CB.9',
    title: 'Profitability Index',
    titleAr: 'مؤشر الربحية',
    content: ['The Profitability Index (PI) measures the value created per dollar invested. PI = PV of Future Cash Flows / Initial Investment.', 'Alternatively: PI = 1 + (NPV / Initial Investment). A PI greater than 1 means the project creates value.', 'Decision rule: Accept if PI > 1 (equivalent to NPV > 0), reject if PI < 1. The higher the PI, the more value per dollar invested.', 'PI is especially useful for capital rationing - when limited funds must be allocated among multiple positive-NPV projects, rank them by PI to maximize total value.'],
    contentAr: ['مؤشر الربحية يقيس القيمة المُنشأة لكل دولار مستثمر. مؤشر الربحية = القيمة الحالية للتدفقات المستقبلية / الاستثمار الأولي.', 'بديلاً: مؤشر الربحية = 1 + (صافي القيمة الحالية / الاستثمار الأولي). مؤشر ربحية أكبر من 1 يعني أن المشروع يخلق قيمة.', 'قاعدة القرار: اقبل إذا كان مؤشر الربحية > 1 (يعادل صافي القيمة الحالية > 0)، ارفض إذا < 1. كلما ارتفع المؤشر، زادت القيمة لكل دولار مستثمر.', 'مؤشر الربحية مفيد بشكل خاص لتقنين رأس المال - عندما يجب تخصيص أموال محدودة بين مشاريع متعددة إيجابية صافي القيمة الحالية، رتبها حسب المؤشر لتعظيم القيمة الإجمالية.'],
    keyPoints: ['PI = PV of Cash Flows / Initial Investment', 'Accept if PI > 1', 'Best for ranking projects under capital rationing'],
    keyPointsAr: ['مؤشر الربحية = القيمة الحالية للتدفقات / الاستثمار الأولي', 'اقبل إذا كان المؤشر > 1', 'الأفضل لترتيب المشاريع عند تقنين رأس المال'],
    highlightType: 'formula',
    highlight: 'PI = PV of Future Cash Flows / Initial Investment',
    highlightAr: 'مؤشر الربحية = القيمة الحالية للتدفقات / الاستثمار الأولي',
  ),
  CapitalBudgetingSlide(
    id: 'section-cb-8',
    number: 'CB.10',
    title: 'Capital Rationing',
    titleAr: 'تقنين رأس المال',
    content: ['Capital rationing occurs when a company has more positive-NPV projects than it can fund. Limited budgets force managers to choose the best combination.', 'Hard rationing is an external constraint (e.g., cannot raise more capital). Soft rationing is an internal budget limit set by management.', 'Under capital rationing, NPV alone is insufficient - you must maximize total NPV within the budget. PI ranking helps identify the best portfolio.', 'The optimal approach is to rank projects by PI and select from the top until the budget is exhausted, then verify total NPV is maximized.'],
    contentAr: ['يحدث تقنين رأس المال عندما يكون لدى الشركة مشاريع إيجابية صافي القيمة الحالية أكثر مما يمكنها تمويله. الميزانيات المحدودة تجبر المديرين على اختيار أفضل مجموعة.', 'التقنين الصعب هو قيد خارجي (مثل عدم القدرة على جمع المزيد من رأس المال). التقنين المرن هو حد ميزانية داخلي تحدده الإدارة.', 'تحت تقنين رأس المال، صافي القيمة الحالية وحده غير كافٍ - يجب تعظيم إجمالي صافي القيمة الحالية ضمن الميزانية. ترتيب مؤشر الربحية يساعد في تحديد أفضل محفظة.', 'النهج الأمثل هو ترتيب المشاريع حسب مؤشر الربحية والاختيار من الأعلى حتى تنفد الميزانية، ثم التحقق من تعظيم إجمالي صافي القيمة الحالية.'],
    keyPoints: ['More good projects than available funds', 'Rank by PI to maximize portfolio value', 'Hard vs. soft rationing constraints'],
    keyPointsAr: ['مشاريع جيدة أكثر من الأموال المتاحة', 'رتب حسب مؤشر الربحية لتعظيم قيمة المحفظة', 'قيود التقنين الصعب مقابل المرن'],
  ),
  CapitalBudgetingSlide(
    id: 'section-cb-9',
    number: 'CB.11',
    title: 'Decision Rules Summary',
    titleAr: 'ملخص قواعد القرار',
    content: ['NPV: Accept if > 0. The most reliable method - directly measures value creation. Always use NPV as the primary decision criterion.', 'IRR: Accept if > hurdle rate. Intuitive but can be misleading for non-conventional cash flows or mutually exclusive projects.', 'Payback: Accept if < target cutoff. Quick risk/liquidity check, but ignores time value and post-payback cash flows.', 'PI: Accept if > 1. Best for capital rationing decisions. Equivalent to NPV for accept/reject but superior for ranking under budget constraints.', 'ARR: Accept if above the target accounting return. The only measure here based on accounting profit rather than cash flow, so it connects the project to reported return on capital - but it ignores time value entirely.'],
    contentAr: ['صافي القيمة الحالية: اقبل إذا > 0. الطريقة الأكثر موثوقية - تقيس مباشرة خلق القيمة. استخدمها دائماً كمعيار القرار الأساسي.', 'معدل العائد الداخلي: اقبل إذا > المعدل المطلوب. بديهي لكن قد يكون مضللاً للتدفقات غير التقليدية أو المشاريع المتبادلة.', 'فترة الاسترداد: اقبل إذا < الحد المستهدف. فحص سريع للمخاطر/السيولة، لكن يتجاهل القيمة الزمنية والتدفقات بعد الاسترداد.', 'مؤشر الربحية: اقبل إذا > 1. الأفضل لقرارات تقنين رأس المال. يعادل صافي القيمة الحالية للقبول/الرفض لكنه أفضل للترتيب تحت قيود الميزانية.', 'معدل العائد المحاسبي: اقبل إذا تجاوز العائد المحاسبي المستهدف. وهو المقياس الوحيد هنا المبني على الربح المحاسبي لا على التدفق النقدي، فيربط المشروع بالعائد على رأس المال المُعلن - لكنه يتجاهل القيمة الزمنية تماماً.'],
    keyPoints: ['NPV is the primary decision tool', 'Use multiple metrics for complete analysis', 'Each metric has strengths and limitations'],
    keyPointsAr: ['صافي القيمة الحالية هو أداة القرار الأساسية', 'استخدم مقاييس متعددة للتحليل الكامل', 'كل مقياس له نقاط قوة وقيود'],
  ),
  CapitalBudgetingSlide(
    id: 'section-cb-10',
    number: 'CB.12',
    title: 'Summary of Capital Budgeting',
    titleAr: 'ملخص الموازنة الرأسمالية',
    content: ['Capital budgeting provides a systematic framework for evaluating long-term investments, ensuring resources are allocated to projects that create the most value.', 'The Time Value of Money is the foundation: present value and future value calculations enable meaningful comparison of cash flows across time periods.', 'NPV remains the gold standard, supported by IRR for intuitive return comparisons, Payback for risk screening, and PI for capital rationing.', 'Effective capital budgeting combines quantitative analysis with qualitative judgment about strategic fit, market conditions, and organizational capabilities.'],
    contentAr: ['توفر الموازنة الرأسمالية إطاراً منهجياً لتقييم الاستثمارات طويلة الأجل، مما يضمن تخصيص الموارد للمشاريع التي تخلق أكبر قيمة.', 'القيمة الزمنية للنقود هي الأساس: حسابات القيمة الحالية والمستقبلية تمكن من المقارنة الهادفة للتدفقات النقدية عبر الفترات الزمنية.', 'صافي القيمة الحالية يبقى المعيار الذهبي، مدعوماً بمعدل العائد الداخلي لمقارنات العائد البديهية، وفترة الاسترداد لفحص المخاطر، ومؤشر الربحية لتقنين رأس المال.', 'الموازنة الرأسمالية الفعالة تجمع بين التحليل الكمي والحكم النوعي حول الملاءمة الاستراتيجية وظروف السوق وقدرات المنظمة.'],
    keyPoints: ['Systematic framework for investment evaluation', 'NPV is the gold standard metric', 'Combines quantitative and qualitative analysis'],
    keyPointsAr: ['إطار منهجي لتقييم الاستثمارات', 'صافي القيمة الحالية هو المعيار الذهبي', 'يجمع بين التحليل الكمي والنوعي'],
  ),
  CapitalBudgetingSlide(
    id: 'section-cb-frameworks',
    number: 'CB.13',
    title: 'Grounded in International Frameworks',
    titleAr: 'مُؤسَّس على الأطر الدولية',
    content: ['The investment criteria taught in this module - NPV, IRR, payback and discounted payback, and the profitability index - follow the standard corporate finance canon as codified by the global professional bodies.', 'The primary anchor is the CFA Program curriculum of CFA Institute, in the Corporate Issuers area, which establishes the primacy of the NPV rule, documents the IRR pitfalls covered here (multiple IRRs with non-conventional cash flows, the reinvestment-rate assumption, and conflicting rankings for mutually exclusive projects), and examines capital allocation with exactly these decision rules: accept positive-NPV projects, use the cost of capital as the discount rate, and rely on NPV when methods disagree.'],
    contentAr: ['معايير الاستثمار التي تُدرَّس في هذه الوحدة - صافي القيمة الحالية، ومعدل العائد الداخلي، وفترة الاسترداد والاسترداد المخصوم، ومؤشر الربحية - تتبع المرجعية القياسية لتمويل الشركات كما تُقنِّنها الهيئات المهنية العالمية.', 'المرجع الأساسي هو منهج برنامج المحلل المالي المعتمد (CFA) الصادر عن معهد CFA، في مجال "الجهات المُصدِرة" (Corporate Issuers)، الذي يُرسِّخ أولوية قاعدة صافي القيمة الحالية، ويوثق قيود معدل العائد الداخلي المشمولة هنا (تعدد المعدلات مع التدفقات غير التقليدية، وافتراض معدل إعادة الاستثمار، وتعارض الترتيب في المشاريع المتنافية)، ويختبر تخصيص رأس المال بقواعد القرار نفسها: اقبل المشاريع ذات صافي القيمة الحالية الموجب، واستخدم تكلفة رأس المال معدلاً للخصم، واعتمد على صافي القيمة الحالية عند اختلاف الطرق.'],
    keyPoints: ['CFA Institute, CFA Program curriculum (Corporate Issuers) - NPV rule primacy, IRR pitfalls, capital allocation criteria'],
    keyPointsAr: ['معهد CFA، منهج برنامج CFA (مجال الجهات المُصدِرة) - أولوية قاعدة NPV وقيود IRR ومعايير تخصيص رأس المال'],
  ),
  CapitalBudgetingSlide(
    id: 'section-cb-framework-bodies',
    number: 'CB.14',
    title: 'ACCA and the Shared Foundations',
    titleAr: 'جمعية ACCA والأسس المشتركة',
    content: ['The same appraisal framework is examinable content in the Financial Management (FM) syllabus of ACCA (the Association of Chartered Certified Accountants), where investment appraisal using NPV, IRR, and payback against the cost of capital is a named syllabus area.', 'The time-value-of-money foundations - present value, future value, and discounting - are common to the curricula of both bodies and to the quantitative methods portion of the CFA Program. Aligning with these frameworks ensures that what you practice in the calculators of this module is the same analysis applied in professional investment appraisal.'],
    contentAr: ['وإطار التقييم ذاته محتوى قابل للاختبار في منهج «الإدارة المالية» (FM) الصادر عن جمعية المحاسبين القانونيين المعتمدين (ACCA)، حيث يشكل تقييم الاستثمار باستخدام NPV وIRR وفترة الاسترداد مقابل تكلفة رأس المال مجالاً منهجياً معتمداً.', 'وأسس القيمة الزمنية للنقود - القيمة الحالية والقيمة المستقبلية والخصم - مشتركة بين منهجي الهيئتين وبين قسم الأساليب الكمية في برنامج CFA. والتوافق مع هذه الأطر يضمن أن ما تتدرب عليه في حاسبات هذه الوحدة هو التحليل ذاته المطبق في التقييم الاستثماري المهني.'],
    keyPoints: ['ACCA, Financial Management (FM) syllabus - investment appraisal with NPV, IRR, and payback', 'Cost of capital as the hurdle rate - shared by both frameworks'],
    keyPointsAr: ['جمعية ACCA، منهج «الإدارة المالية» (FM) - تقييم الاستثمار بـ NPV وIRR وفترة الاسترداد', 'تكلفة رأس المال معدلاً للعائد المطلوب - قاسم مشترك بين الإطارين'],
    highlightType: 'info',
    highlight: 'This module is aligned with these corporate finance frameworks to ensure objective, verifiable knowledge transfer.',
    highlightAr: 'هذه الوحدة متوائمة مع أطر تمويل الشركات هذه لضمان نقل معرفة موضوعية قابلة للتحقق.',
  ),
];

/// Icon + accent color per slide (by website section id; unknown ids cycle).
(IconData, Color) _cbSlideStyle(String id, int index) {
  const styles = <String, (IconData, Color)>{
    'section-cb-overview': (Icons.account_balance_rounded, AppColors.primaryLight),
    'section-cb-1': (Icons.business_center_rounded, AppColors.primaryLight),
    'section-cb-2': (Icons.schedule_rounded, Color(0xFF8B5CF6)),
    'section-cb-3': (Icons.trending_up_rounded, Color(0xFF06B6D4)),
    'section-cb-4': (Icons.attach_money_rounded, AppColors.secondaryLight),
    'section-cb-5': (Icons.percent_rounded, Color(0xFFF59E0B)),
    'section-cb-6': (Icons.timer_rounded, Color(0xFFEF4444)),
    'section-cb-arr': (Icons.bar_chart_rounded, Color(0xFFEC4899)),
    'section-cb-7': (Icons.analytics_rounded, Color(0xFF8B5CF6)),
    'section-cb-8': (Icons.filter_alt_rounded, Color(0xFF06B6D4)),
    'section-cb-9': (Icons.checklist_rounded, AppColors.secondaryLight),
    'section-cb-10': (Icons.lightbulb_rounded, AppColors.accentLight),
    'section-cb-frameworks': (Icons.public_rounded, AppColors.primaryLight),
    'section-cb-framework-bodies': (Icons.school_rounded, Color(0xFF06B6D4)),
  };
  const cycle = [AppColors.primaryLight, AppColors.secondaryLight, Color(0xFFF59E0B), Color(0xFF8B5CF6)];
  return styles[id] ?? (Icons.menu_book_rounded, cycle[index % cycle.length]);
}

/// Renders one deck slide: number + title, paragraphs, key points, highlight
/// and examples. Scrolls inside the page so long slides never overflow.
Widget _buildCbSlideCard(BuildContext context, {
  required CapitalBudgetingSlide slide,
  required int index,
  required int total,
  required bool ar,
  required IconData icon,
  required Color color,
}) {
  final dir = ar ? TextDirection.rtl : TextDirection.ltr;
  final align = ar ? TextAlign.right : TextAlign.left;
  final keyPoints = slide.keyPointsFor(ar);
  final highlight = slide.highlightFor(ar);
  final examples = slide.examplesFor(ar);
  final hlIcon = switch (slide.highlightType) {
    'formula' => Icons.functions_rounded,
    'warning' => Icons.warning_amber_rounded,
    'tip' => Icons.lightbulb_rounded,
    _ => Icons.info_outline_rounded,
  };
  return GlassCard(
    borderColor: color.withValues(alpha: 0.3),
    padding: const EdgeInsets.all(20),
    child: Directionality(
      textDirection: dir,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color.withValues(alpha: 0.15),
                        ),
                        child: Icon(icon, color: color, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              slide.number,
                              textDirection: TextDirection.ltr,
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 11,
                                color: color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              slide.titleFor(ar),
                              textAlign: align,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...slide.contentFor(ar).map((p) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          p,
                          textAlign: align,
                          style: TextStyle(
                            fontSize: 14.5,
                            height: 1.6,
                            color: AppColors.textSecondary(context),
                          ),
                        ),
                      )),
                  if (keyPoints.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: color.withValues(alpha: 0.08),
                        border: Border.all(color: color.withValues(alpha: 0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.check_circle_outline_rounded, size: 16, color: color),
                              const SizedBox(width: 6),
                              Text(
                                ar ? 'النقاط الرئيسية' : 'Key Points',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: color,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...keyPoints.map((k) => Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('•  ', style: TextStyle(color: color, height: 1.5)),
                                    Expanded(
                                      child: Text(
                                        k,
                                        textAlign: align,
                                        style: TextStyle(
                                          fontSize: 13,
                                          height: 1.5,
                                          color: AppColors.textPrimary(context),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                  if (examples.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      slide.examplesTitleFor(ar) ?? (ar ? 'أمثلة' : 'Examples'),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 6),
                    ...examples.map((e) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text('•  $e',
                              textAlign: align,
                              style: TextStyle(
                                  fontSize: 13, height: 1.5, color: AppColors.textSecondary(context))),
                        )),
                  ],
                  if (highlight != null && highlight.trim().isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.accentLight.withValues(alpha: 0.08),
                        border: Border.all(color: AppColors.accentLight.withValues(alpha: 0.25)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(hlIcon, size: 18, color: AppColors.accentLight),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              highlight,
                              textAlign: align,
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.5,
                                fontWeight: slide.highlightType == 'formula'
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: AppColors.textPrimary(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (index + 1) / total,
              minHeight: 4,
              backgroundColor: AppColors.borderColor(context),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    ),
  );
}

// ─── PRACTICE DATA ─────────────────────────────────────────────────────────────

List<_PracticeScenario> _buildScenarios(AppStrings s) => <_PracticeScenario>[
  _PracticeScenario(
    title: s.tr('Restaurant Kitchen', '\u0645\u0637\u0628\u062e \u0645\u0637\u0639\u0645'),
    location: 'Riyadh',
    currency: 'SAR',
    difficulty: s.tr('Beginner', '\u0645\u0628\u062a\u062f\u0626'),
    difficultyColor: AppColors.secondaryLight,
    context: s.tr(
        'Al-Faisal Restaurant is considering upgrading its commercial kitchen '
        'equipment to improve efficiency and reduce operating costs.',
        '\u064a\u062f\u0631\u0633 \u0645\u0637\u0639\u0645 \u0627\u0644\u0641\u064a\u0635\u0644 \u062a\u0631\u0642\u064a\u0629 \u0645\u0639\u062f\u0627\u062a \u0645\u0637\u0628\u062e\u0647 \u0627\u0644\u062a\u062c\u0627\u0631\u064a \u0644\u062a\u062d\u0633\u064a\u0646 \u0627\u0644\u0643\u0641\u0627\u0621\u0629 \u0648\u062e\u0641\u0636 \u062a\u0643\u0627\u0644\u064a\u0641 \u0627\u0644\u062a\u0634\u063a\u064a\u0644.'),
    givenData: s.tr(
        'Investment: SAR 150,000\n'
        'Annual savings: SAR 45,000\n'
        'Project life: 5 years\n'
        'Discount rate: 10%',
        '\u0627\u0644\u0627\u0633\u062a\u062b\u0645\u0627\u0631: 150,000 \u0631\u064a\u0627\u0644\n'
        '\u0627\u0644\u0648\u0641\u0648\u0631\u0627\u062a \u0627\u0644\u0633\u0646\u0648\u064a\u0629: 45,000 \u0631\u064a\u0627\u0644\n'
        '\u0639\u0645\u0631 \u0627\u0644\u0645\u0634\u0631\u0648\u0639: 5 \u0633\u0646\u0648\u0627\u062a\n'
        '\u0645\u0639\u062f\u0644 \u0627\u0644\u062e\u0635\u0645: 10%'),
    calculation:
        'NPV = \u2013150,000 + 45,000/(1.10)\u00b9 + 45,000/(1.10)\u00b2 + 45,000/(1.10)\u00b3 + 45,000/(1.10)\u2074 + 45,000/(1.10)\u2075\n'
        '    = \u2013150,000 + 40,909 + 37,190 + 33,809 + 30,735 + 27,941\n'
        '    = \u2013150,000 + 170,584',
    result: 'NPV = SAR 20,567',
    verdict: s.tr('Accept \u2014 NPV is positive, the investment creates value.',
        '\u0627\u0642\u0628\u0644 \u0627\u0644\u0645\u0634\u0631\u0648\u0639 \u2014 \u0635\u0627\u0641\u064a \u0627\u0644\u0642\u064a\u0645\u0629 \u0627\u0644\u062d\u0627\u0644\u064a\u0629 \u0645\u0648\u062c\u0628\u060c \u0641\u0627\u0644\u0627\u0633\u062a\u062b\u0645\u0627\u0631 \u064a\u062e\u0644\u0642 \u0642\u064a\u0645\u0629.'),
    answer: 20567,
    answerLabel: s.tr('NPV', '\u0635\u0627\u0641\u064a \u0627\u0644\u0642\u064a\u0645\u0629 \u0627\u0644\u062d\u0627\u0644\u064a\u0629'),
    answerUnit: 'SAR',
  ),
  _PracticeScenario(
    title: s.tr('Coffee Shop Expansion', '\u062a\u0648\u0633\u0639\u0629 \u0645\u0642\u0647\u0649'),
    location: 'Dubai',
    currency: 'AED',
    difficulty: s.tr('Beginner', '\u0645\u0628\u062a\u062f\u0626'),
    difficultyColor: AppColors.secondaryLight,
    context: s.tr(
        'Brew Masters wants to open a second location in Dubai Marina '
        'with premium seating and specialty coffee equipment.',
        '\u062a\u0631\u063a\u0628 \u00ab\u0628\u0631\u0648 \u0645\u0627\u0633\u062a\u0631\u0632\u00bb \u0641\u064a \u0627\u0641\u062a\u062a\u0627\u062d \u0641\u0631\u0639 \u062b\u0627\u0646\u064d \u0641\u064a \u062f\u0628\u064a \u0645\u0627\u0631\u064a\u0646\u0627 \u0628\u0645\u0642\u0627\u0639\u062f \u0641\u0627\u062e\u0631\u0629 \u0648\u0645\u0639\u062f\u0627\u062a \u0642\u0647\u0648\u0629 \u0645\u062a\u062e\u0635\u0635\u0629.'),
    givenData: s.tr(
        'Investment: AED 200,000\n'
        'Year 1: AED 50,000\n'
        'Year 2: AED 60,000\n'
        'Year 3: AED 70,000\n'
        'Year 4: AED 70,000\n'
        'Year 5: AED 70,000\n'
        'Discount rate: 12%',
        '\u0627\u0644\u0627\u0633\u062a\u062b\u0645\u0627\u0631: 200,000 \u062f\u0631\u0647\u0645\n'
        '\u0627\u0644\u0633\u0646\u0629 1: 50,000 \u062f\u0631\u0647\u0645\n'
        '\u0627\u0644\u0633\u0646\u0629 2: 60,000 \u062f\u0631\u0647\u0645\n'
        '\u0627\u0644\u0633\u0646\u0629 3: 70,000 \u062f\u0631\u0647\u0645\n'
        '\u0627\u0644\u0633\u0646\u0629 4: 70,000 \u062f\u0631\u0647\u0645\n'
        '\u0627\u0644\u0633\u0646\u0629 5: 70,000 \u062f\u0631\u0647\u0645\n'
        '\u0645\u0639\u062f\u0644 \u0627\u0644\u062e\u0635\u0645: 12%'),
    calculation: s.tr(
        'Cumulative CFs:\n'
        'Y1: 50,000 (total: 50,000)\n'
        'Y2: 60,000 (total: 110,000)\n'
        'Y3: 70,000 (total: 180,000)\n'
        'Y4: 70,000 (total: 250,000)\n\n'
        'Payback in Y3: 200,000 \u2013 180,000 = 20,000 remaining\n'
        '20,000 / 70,000 = 0.29 years into Y4',
        '\u0627\u0644\u062a\u062f\u0641\u0642\u0627\u062a \u0627\u0644\u0646\u0642\u062f\u064a\u0629 \u0627\u0644\u062a\u0631\u0627\u0643\u0645\u064a\u0629:\n'
        '\u0627\u0644\u0633\u0646\u0629 1: 50,000 (\u0627\u0644\u0625\u062c\u0645\u0627\u0644\u064a: 50,000)\n'
        '\u0627\u0644\u0633\u0646\u0629 2: 60,000 (\u0627\u0644\u0625\u062c\u0645\u0627\u0644\u064a: 110,000)\n'
        '\u0627\u0644\u0633\u0646\u0629 3: 70,000 (\u0627\u0644\u0625\u062c\u0645\u0627\u0644\u064a: 180,000)\n'
        '\u0627\u0644\u0633\u0646\u0629 4: 70,000 (\u0627\u0644\u0625\u062c\u0645\u0627\u0644\u064a: 250,000)\n\n'
        '\u0627\u0644\u0627\u0633\u062a\u0631\u062f\u0627\u062f \u0641\u064a \u0627\u0644\u0633\u0646\u0629 3: 200,000 \u2013 180,000 = 20,000 \u0645\u062a\u0628\u0642\u0651\u064a\u0629\n'
        '20,000 / 70,000 = 0.29 \u0633\u0646\u0629 \u0641\u064a \u0627\u0644\u0633\u0646\u0629 4'),
    result: s.tr('Payback: 3.3 years', '\u0641\u062a\u0631\u0629 \u0627\u0644\u0627\u0633\u062a\u0631\u062f\u0627\u062f: 3.3 \u0633\u0646\u0648\u0627\u062a'),
    verdict: s.tr('Investment is recovered within 3.3 years.',
        '\u064a\u064f\u0633\u062a\u0631\u062f \u0627\u0644\u0627\u0633\u062a\u062b\u0645\u0627\u0631 \u062e\u0644\u0627\u0644 3.3 \u0633\u0646\u0648\u0627\u062a.'),
    answer: 3.3,
    answerLabel: s.tr('Payback period', '\u0641\u062a\u0631\u0629 \u0627\u0644\u0627\u0633\u062a\u0631\u062f\u0627\u062f'),
    answerUnit: s.tr('years', '\u0633\u0646\u0648\u0627\u062a'),
  ),
  _PracticeScenario(
    title: s.tr('Delivery Fleet', '\u0623\u0633\u0637\u0648\u0644 \u062a\u0648\u0635\u064a\u0644'),
    location: 'Jeddah',
    currency: 'SAR',
    difficulty: s.tr('Beginner', '\u0645\u0628\u062a\u062f\u0626'),
    difficultyColor: AppColors.secondaryLight,
    context: s.tr(
        'A logistics company in Jeddah is evaluating the purchase of '
        'a delivery fleet with expected salvage value at end of life.',
        '\u062a\u0642\u064a\u0651\u0645 \u0634\u0631\u0643\u0629 \u0644\u0648\u062c\u0633\u062a\u064a\u0629 \u0641\u064a \u062c\u062f\u0629 \u0634\u0631\u0627\u0621 \u0623\u0633\u0637\u0648\u0644 \u062a\u0648\u0635\u064a\u0644 \u0628\u0642\u064a\u0645\u0629 \u062e\u0631\u062f\u0629 \u0645\u062a\u0648\u0642\u0639\u0629 \u0641\u064a \u0646\u0647\u0627\u064a\u0629 \u0639\u0645\u0631\u0647 \u0627\u0644\u0625\u0646\u062a\u0627\u062c\u064a.'),
    givenData: s.tr(
        'Investment: SAR 180,000\n'
        'Annual CF: SAR 55,000\n'
        'Life: 4 years\n'
        'Salvage value: SAR 20,000\n'
        'Discount rate: 8%',
        '\u0627\u0644\u0627\u0633\u062a\u062b\u0645\u0627\u0631: 180,000 \u0631\u064a\u0627\u0644\n'
        '\u0627\u0644\u062a\u062f\u0641\u0642 \u0627\u0644\u0646\u0642\u062f\u064a \u0627\u0644\u0633\u0646\u0648\u064a: 55,000 \u0631\u064a\u0627\u0644\n'
        '\u0627\u0644\u0639\u0645\u0631: 4 \u0633\u0646\u0648\u0627\u062a\n'
        '\u0642\u064a\u0645\u0629 \u0627\u0644\u062e\u0631\u062f\u0629: 20,000 \u0631\u064a\u0627\u0644\n'
        '\u0645\u0639\u062f\u0644 \u0627\u0644\u062e\u0635\u0645: 8%'),
    calculation:
        'NPV = \u2013180,000 + 55,000/(1.08)\u00b9 + 55,000/(1.08)\u00b2 + 55,000/(1.08)\u00b3 + (55,000+20,000)/(1.08)\u2074\n'
        '    = \u2013180,000 + 50,926 + 47,154 + 43,661 + 55,125\n'
        '    = \u2013180,000 + 196,866',
    result: s.tr('NPV (with salvage) = SAR 16,866',
        '\u0635\u0627\u0641\u064a \u0627\u0644\u0642\u064a\u0645\u0629 \u0627\u0644\u062d\u0627\u0644\u064a\u0629 (\u0645\u0639 \u0627\u0644\u062e\u0631\u062f\u0629) = 16,866 \u0631\u064a\u0627\u0644'),
    verdict: s.tr('Accept \u2014 positive NPV including salvage value.',
        '\u0627\u0642\u0628\u0644 \u0627\u0644\u0645\u0634\u0631\u0648\u0639 \u2014 \u0635\u0627\u0641\u064a \u0642\u064a\u0645\u0629 \u062d\u0627\u0644\u064a\u0629 \u0645\u0648\u062c\u0628 \u064a\u0634\u0645\u0644 \u0642\u064a\u0645\u0629 \u0627\u0644\u062e\u0631\u062f\u0629.'),
    answer: 16866,
    answerLabel: s.tr('NPV (with salvage)', '\u0635\u0627\u0641\u064a \u0627\u0644\u0642\u064a\u0645\u0629 \u0627\u0644\u062d\u0627\u0644\u064a\u0629 (\u0645\u0639 \u0627\u0644\u062e\u0631\u062f\u0629)'),
    answerUnit: 'SAR',
  ),
  _PracticeScenario(
    title: s.tr('Gym Equipment', '\u0645\u0639\u062f\u0627\u062a \u0646\u0627\u062f\u064d \u0631\u064a\u0627\u0636\u064a'),
    location: 'Abu Dhabi',
    currency: 'AED',
    difficulty: s.tr('Intermediate', '\u0645\u062a\u0648\u0633\u0637'),
    difficultyColor: AppColors.accentLight,
    context: s.tr(
        'FitZone gym in Abu Dhabi has a limited budget and must choose between '
        'two equipment packages. This is a capital rationing problem.',
        '\u064a\u0645\u0644\u0643 \u0646\u0627\u062f\u064a \u00ab\u0641\u064a\u062a \u0632\u0648\u0646\u00bb \u0641\u064a \u0623\u0628\u0648\u0638\u0628\u064a \u0645\u0648\u0627\u0632\u0646\u0629 \u0645\u062d\u062f\u0648\u062f\u0629 \u0648\u0639\u0644\u064a\u0647 \u0627\u0644\u0627\u062e\u062a\u064a\u0627\u0631 \u0628\u064a\u0646 \u0628\u0627\u0642\u062a\u064a \u0645\u0639\u062f\u0627\u062a. \u0648\u0647\u0630\u0647 \u0645\u0633\u0623\u0644\u0629 \u062a\u0631\u0634\u064a\u062f \u0631\u0623\u0633 \u0645\u0627\u0644.'),
    givenData: s.tr(
        'Option A: AED 300,000 investment, AED 90,000/year, 5 years\n'
        'Option B: AED 200,000 investment, AED 65,000/year, 5 years\n'
        'Discount rate: 10%',
        '\u0627\u0644\u062e\u064a\u0627\u0631 \u0623: \u0627\u0633\u062a\u062b\u0645\u0627\u0631 300,000 \u062f\u0631\u0647\u0645\u060c 90,000 \u062f\u0631\u0647\u0645/\u0633\u0646\u0629\u060c 5 \u0633\u0646\u0648\u0627\u062a\n'
        '\u0627\u0644\u062e\u064a\u0627\u0631 \u0628: \u0627\u0633\u062a\u062b\u0645\u0627\u0631 200,000 \u062f\u0631\u0647\u0645\u060c 65,000 \u062f\u0631\u0647\u0645/\u0633\u0646\u0629\u060c 5 \u0633\u0646\u0648\u0627\u062a\n'
        '\u0645\u0639\u062f\u0644 \u0627\u0644\u062e\u0635\u0645: 10%'),
    calculation: s.tr(
        'PV of CFs (annuity factor for 5yr @ 10% = 3.7908):\n'
        'Option A PV = 90,000 \u00d7 3.7908 = 341,172\n'
        'PI(A) = 341,172 / 300,000 = 1.14\n\n'
        'Option B PV = 65,000 \u00d7 3.7908 = 246,402\n'
        'PI(B) = 246,402 / 200,000 = 1.23',
        '\u0627\u0644\u0642\u064a\u0645\u0629 \u0627\u0644\u062d\u0627\u0644\u064a\u0629 \u0644\u0644\u062a\u062f\u0641\u0642\u0627\u062a (\u0645\u0639\u0627\u0645\u0644 \u0627\u0644\u062f\u0641\u0639\u0627\u062a \u0644\u0640 5 \u0633\u0646\u0648\u0627\u062a \u0639\u0646\u062f 10% = 3.7908):\n'
        '\u0627\u0644\u0642\u064a\u0645\u0629 \u0627\u0644\u062d\u0627\u0644\u064a\u0629 \u0644\u0644\u062e\u064a\u0627\u0631 \u0623 = 90,000 \u00d7 3.7908 = 341,172\n'
        '\u0645\u0624\u0634\u0631 \u0627\u0644\u0631\u0628\u062d\u064a\u0629 (\u0623) = 341,172 / 300,000 = 1.14\n\n'
        '\u0627\u0644\u0642\u064a\u0645\u0629 \u0627\u0644\u062d\u0627\u0644\u064a\u0629 \u0644\u0644\u062e\u064a\u0627\u0631 \u0628 = 65,000 \u00d7 3.7908 = 246,402\n'
        '\u0645\u0624\u0634\u0631 \u0627\u0644\u0631\u0628\u062d\u064a\u0629 (\u0628) = 246,402 / 200,000 = 1.23'),
    result: s.tr('PI for Option B: 1.23 vs Option A: 1.14',
        '\u0645\u0624\u0634\u0631 \u0631\u0628\u062d\u064a\u0629 \u0627\u0644\u062e\u064a\u0627\u0631 \u0628: 1.23 \u0645\u0642\u0627\u0628\u0644 \u0627\u0644\u062e\u064a\u0627\u0631 \u0623: 1.14'),
    verdict: s.tr('Choose B \u2014 higher PI means better value per dirham invested.',
        '\u0627\u062e\u062a\u0631 \u0627\u0644\u062e\u064a\u0627\u0631 \u0628 \u2014 \u0645\u0624\u0634\u0631 \u0627\u0644\u0631\u0628\u062d\u064a\u0629 \u0627\u0644\u0623\u0639\u0644\u0649 \u064a\u0639\u0646\u064a \u0642\u064a\u0645\u0629 \u0623\u0641\u0636\u0644 \u0644\u0643\u0644 \u062f\u0631\u0647\u0645 \u0645\u0633\u062a\u062b\u0645\u0631.'),
    answer: 1.23,
    answerLabel: s.tr('PI for Option B', '\u0645\u0624\u0634\u0631 \u0631\u0628\u062d\u064a\u0629 \u0627\u0644\u062e\u064a\u0627\u0631 \u0628'),
    answerUnit: '',
  ),
  _PracticeScenario(
    title: s.tr('Retail Expansion', '\u062a\u0648\u0633\u0639\u0629 \u062a\u062c\u0632\u0626\u0629'),
    location: 'Muscat',
    currency: 'OMR',
    difficulty: s.tr('Intermediate', '\u0645\u062a\u0648\u0633\u0637'),
    difficultyColor: AppColors.accentLight,
    context: s.tr(
        'A retail chain in Muscat is evaluating two mutually exclusive '
        'expansion projects. Only one can be selected.',
        '\u062a\u0642\u064a\u0651\u0645 \u0633\u0644\u0633\u0644\u0629 \u062a\u062c\u0632\u0626\u0629 \u0641\u064a \u0645\u0633\u0642\u0637 \u0645\u0634\u0631\u0648\u0639\u064e\u064a \u062a\u0648\u0633\u0639\u0629 \u0645\u062a\u0646\u0627\u0641\u064a\u064a\u0646. \u0648\u0644\u0627 \u064a\u0645\u0643\u0646 \u0627\u062e\u062a\u064a\u0627\u0631 \u0633\u0648\u0649 \u0648\u0627\u062d\u062f.'),
    givenData: s.tr(
        'Project X: OMR 50,000 investment\n'
        '  CFs: 18,000 / 22,000 / 25,000\n'
        'Project Y: OMR 75,000 investment\n'
        '  CFs: 20,000 / 30,000 / 45,000\n'
        'Discount rate: 12%',
        '\u0627\u0644\u0645\u0634\u0631\u0648\u0639 \u0633: \u0627\u0633\u062a\u062b\u0645\u0627\u0631 50,000 \u0631\u064a\u0627\u0644 \u0639\u0645\u0627\u0646\u064a\n'
        '  \u0627\u0644\u062a\u062f\u0641\u0642\u0627\u062a: 18,000 / 22,000 / 25,000\n'
        '\u0627\u0644\u0645\u0634\u0631\u0648\u0639 \u0635: \u0627\u0633\u062a\u062b\u0645\u0627\u0631 75,000 \u0631\u064a\u0627\u0644 \u0639\u0645\u0627\u0646\u064a\n'
        '  \u0627\u0644\u062a\u062f\u0641\u0642\u0627\u062a: 20,000 / 30,000 / 45,000\n'
        '\u0645\u0639\u062f\u0644 \u0627\u0644\u062e\u0635\u0645: 12%'),
    calculation:
        'NPV(X) = \u201350,000 + 18,000/1.12 + 22,000/1.12\u00b2 + 25,000/1.12\u00b3\n'
        '       = \u201350,000 + 16,071 + 17,538 + 17,795\n'
        '       = 1,403\n\n'
        'NPV(Y) = \u201375,000 + 20,000/1.12 + 30,000/1.12\u00b2 + 45,000/1.12\u00b3\n'
        '       = \u201375,000 + 17,857 + 23,916 + 32,028\n'
        '       = \u20131,199',
    result: 'NPV(X) = OMR 1,403 | NPV(Y) = OMR \u20131,199',
    verdict: s.tr('Choose Project X \u2014 only project with positive NPV.',
        '\u0627\u062e\u062a\u0631 \u0627\u0644\u0645\u0634\u0631\u0648\u0639 \u0633 \u2014 \u0627\u0644\u0645\u0634\u0631\u0648\u0639 \u0627\u0644\u0648\u062d\u064a\u062f \u0630\u0648 \u0635\u0627\u0641\u064a \u0642\u064a\u0645\u0629 \u062d\u0627\u0644\u064a\u0629 \u0645\u0648\u062c\u0628.'),
    answer: 1403,
    answerLabel: s.tr('NPV of Project X', '\u0635\u0627\u0641\u064a \u0627\u0644\u0642\u064a\u0645\u0629 \u0627\u0644\u062d\u0627\u0644\u064a\u0629 \u0644\u0644\u0645\u0634\u0631\u0648\u0639 \u0633'),
    answerUnit: 'OMR',
  ),
  _PracticeScenario(
    title: s.tr('Hotel Renovation', '\u062a\u062c\u062f\u064a\u062f \u0641\u0646\u062f\u0642'),
    location: 'Doha',
    currency: 'QAR',
    difficulty: s.tr('Advanced', '\u0645\u062a\u0642\u062f\u0651\u0645'),
    difficultyColor: AppColors.dangerLight,
    context: s.tr(
        'A hotel in Doha is choosing between a basic and premium renovation. '
        'This scenario demonstrates the NPV vs IRR conflict.',
        '\u064a\u062e\u062a\u0627\u0631 \u0641\u0646\u062f\u0642 \u0641\u064a \u0627\u0644\u062f\u0648\u062d\u0629 \u0628\u064a\u0646 \u062a\u062c\u062f\u064a\u062f \u0623\u0633\u0627\u0633\u064a \u0648\u0622\u062e\u0631 \u0641\u0627\u062e\u0631. \u0648\u064a\u0648\u0636\u0651\u062d \u0647\u0630\u0627 \u0627\u0644\u0633\u064a\u0646\u0627\u0631\u064a\u0648 \u062a\u0639\u0627\u0631\u0636 NPV \u0645\u0639 IRR.'),
    givenData: s.tr(
        'Basic: QAR 500,000 investment, QAR 140,000/yr, 5 years, IRR \u2248 16%\n'
        'Premium: QAR 800,000 investment, QAR 210,000/yr, 5 years, IRR \u2248 14%\n'
        'Discount rate: 10%',
        '\u0627\u0644\u0623\u0633\u0627\u0633\u064a: \u0627\u0633\u062a\u062b\u0645\u0627\u0631 500,000 \u0631\u064a\u0627\u0644 \u0642\u0637\u0631\u064a\u060c 140,000 \u0631\u064a\u0627\u0644/\u0633\u0646\u0629\u060c 5 \u0633\u0646\u0648\u0627\u062a\u060c IRR \u2248 16%\n'
        '\u0627\u0644\u0641\u0627\u062e\u0631: \u0627\u0633\u062a\u062b\u0645\u0627\u0631 800,000 \u0631\u064a\u0627\u0644 \u0642\u0637\u0631\u064a\u060c 210,000 \u0631\u064a\u0627\u0644/\u0633\u0646\u0629\u060c 5 \u0633\u0646\u0648\u0627\u062a\u060c IRR \u2248 14%\n'
        '\u0645\u0639\u062f\u0644 \u0627\u0644\u062e\u0635\u0645: 10%'),
    calculation: s.tr(
        'Annuity factor (5yr @ 10%) = 3.7908\n\n'
        'Basic NPV = \u2013500,000 + 140,000 \u00d7 3.7908 = 30,712\n'
        'Basic IRR \u2248 16%\n\n'
        'Premium NPV = \u2013800,000 + 210,000 \u00d7 3.7908 = \u20133,932\n'
        'Premium IRR \u2248 14%',
        '\u0645\u0639\u0627\u0645\u0644 \u0627\u0644\u062f\u0641\u0639\u0627\u062a (5 \u0633\u0646\u0648\u0627\u062a \u0639\u0646\u062f 10%) = 3.7908\n\n'
        'NPV \u0627\u0644\u0623\u0633\u0627\u0633\u064a = \u2013500,000 + 140,000 \u00d7 3.7908 = 30,712\n'
        'IRR \u0627\u0644\u0623\u0633\u0627\u0633\u064a \u2248 16%\n\n'
        'NPV \u0627\u0644\u0641\u0627\u062e\u0631 = \u2013800,000 + 210,000 \u00d7 3.7908 = \u20133,932\n'
        'IRR \u0627\u0644\u0641\u0627\u062e\u0631 \u2248 14%'),
    result: s.tr('Basic NPV: QAR 30,712 | Premium NPV: QAR \u20133,932',
        'NPV \u0627\u0644\u0623\u0633\u0627\u0633\u064a: 30,712 \u0631\u064a\u0627\u0644 \u0642\u0637\u0631\u064a | NPV \u0627\u0644\u0641\u0627\u062e\u0631: \u20133,932 \u0631\u064a\u0627\u0644 \u0642\u0637\u0631\u064a'),
    verdict: s.tr(
        'Choose Basic \u2014 despite Premium having decent IRR (14%), its NPV is negative! '
        'This demonstrates the NPV vs IRR conflict: always trust NPV as the primary criterion.',
        '\u0627\u062e\u062a\u0631 \u0627\u0644\u0623\u0633\u0627\u0633\u064a \u2014 \u0641\u0631\u063a\u0645 \u0623\u0646 \u0627\u0644\u0641\u0627\u062e\u0631 \u064a\u062d\u0642\u0642 IRR \u0644\u0627 \u0628\u0623\u0633 \u0628\u0647 (14%) \u0625\u0644\u0627 \u0623\u0646 NPV \u0627\u0644\u062e\u0627\u0635 \u0628\u0647 \u0633\u0627\u0644\u0628! '
        '\u0648\u0647\u0630\u0627 \u064a\u0648\u0636\u0651\u062d \u062a\u0639\u0627\u0631\u0636 NPV \u0645\u0639 IRR: \u0627\u0639\u062a\u0645\u062f \u062f\u0627\u0626\u0645\u064b\u0627 \u0639\u0644\u0649 NPV \u0643\u0645\u0639\u064a\u0627\u0631 \u0623\u0633\u0627\u0633\u064a.'),
    answer: 30712,
    answerLabel: s.tr('Basic NPV', 'NPV \u0627\u0644\u0623\u0633\u0627\u0633\u064a'),
    answerUnit: 'QAR',
  ),
];

// ─── MAIN SCREEN ───────────────────────────────────────────────────────────────

class CapitalBudgetingScreen extends ConsumerStatefulWidget {
  const CapitalBudgetingScreen({super.key});

  @override
  ConsumerState<CapitalBudgetingScreen> createState() =>
      _CapitalBudgetingScreenState();
}

class _CapitalBudgetingScreenState
    extends ConsumerState<CapitalBudgetingScreen> {
  // Main tabs: 0=Learn, 1=Tools, 2=Practice
  int _mainTab = 0;

  // Tools sub-tab: 0=NPV, 1=IRR, 2=TVM
  int _toolTab = 0;

  // Learn tab
  PageController _slideController = PageController();
  int _currentSlide = 0;
  // Resume at the last slide viewed (website a2da32f, key 'capital-budgeting').
  final LearnResumeRecorder _resume =
      LearnResumeRecorder(LearnResumeStore.capitalBudgetingKey);

  @override
  void initState() {
    super.initState();
    _restoreSlide();
  }

  /// Reopen the deck at the slide the learner last had on screen.
  Future<void> _restoreSlide() async {
    final saved = await _resume.restore(ref);
    if (!mounted) return;
    final i = LearnResumeStore.indexIn(
        capitalBudgetingSlides.map((sl) => sl.id).toList(), saved);
    if (i != _currentSlide) {
      setState(() {
        _currentSlide = i;
        if (_slideController.hasClients) {
          _slideController.jumpToPage(i);
        } else {
          _slideController.dispose();
          _slideController = PageController(initialPage: i);
        }
      });
    }
    _resume.record(ref, capitalBudgetingSlides[i].id);
  }

  void _onSlideChanged(int i) {
    setState(() => _currentSlide = i);
    _resume.record(ref, capitalBudgetingSlides[i].id);
  }

  // Practice tab
  final Set<int> _expandedScenarios = {};

  // ── NPV fields ──
  double _npvInitialInvestment = 100000;
  double _npvDiscountRate = 10;
  int _npvPeriods = 5;
  final List<double> _npvCashFlows = [25000, 30000, 35000, 30000, 25000];

  // ── IRR fields ──
  double _irrInitialInvestment = 100000;
  final List<double> _irrCashFlows = [25000, 30000, 35000, 40000, 45000];

  // ── TVM fields ──
  double _tvmPresentValue = 10000;
  double _tvmRate = 8;
  int _tvmPeriods = 10;
  bool _tvmCompounding = true;

  // ── Calculations ──

  double get _npvResult {
    double npv = -_npvInitialInvestment;
    for (int i = 0; i < _npvCashFlows.length; i++) {
      npv += _npvCashFlows[i] / pow(1 + _npvDiscountRate / 100, i + 1);
    }
    return npv;
  }

  double get _profitabilityIndex => _npvInitialInvestment > 0
      ? (_npvResult + _npvInitialInvestment) / _npvInitialInvestment
      : 0;

  double get _npvPaybackPeriod {
    double cumulative = -_npvInitialInvestment;
    for (int i = 0; i < _npvCashFlows.length; i++) {
      cumulative += _npvCashFlows[i];
      if (cumulative >= 0) return i + 1.0;
    }
    return _npvCashFlows.length.toDouble();
  }

  double get _irrResult {
    double rate = 0.1;
    for (int iter = 0; iter < 100; iter++) {
      double npv = -_irrInitialInvestment;
      double dNpv = 0;
      for (int i = 0; i < _irrCashFlows.length; i++) {
        npv += _irrCashFlows[i] / pow(1 + rate, i + 1);
        dNpv -= (i + 1) * _irrCashFlows[i] / pow(1 + rate, i + 2);
      }
      if (dNpv.abs() < 1e-10) break;
      final newRate = rate - npv / dNpv;
      if ((newRate - rate).abs() < 1e-8) {
        rate = newRate;
        break;
      }
      rate = newRate;
    }
    return rate * 100;
  }

  double get _tvmFutureValue {
    if (_tvmCompounding) {
      return _tvmPresentValue * pow(1 + _tvmRate / 100, _tvmPeriods);
    } else {
      return _tvmPresentValue * (1 + (_tvmRate / 100) * _tvmPeriods);
    }
  }

  double get _tvmTotalInterest => _tvmFutureValue - _tvmPresentValue;

  void _updateNpvPeriods(int periods) {
    setState(() {
      _npvPeriods = periods;
      while (_npvCashFlows.length < periods) {
        _npvCashFlows.add(25000);
      }
      while (_npvCashFlows.length > periods) {
        _npvCashFlows.removeLast();
      }
    });
  }

  void _updateIrrPeriods(int periods) {
    setState(() {
      while (_irrCashFlows.length < periods) {
        _irrCashFlows.add(25000);
      }
      while (_irrCashFlows.length > periods) {
        _irrCashFlows.removeLast();
      }
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _resume.dispose();
    super.dispose();
  }

  // ── BUILD ──

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration:
            BoxDecoration(gradient: AppColors.backgroundGradient(context)),
        child: SafeArea(
          child: Column(
            children: [
              // App bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      onPressed: () => context.pop(),
                    ),
                    const Spacer(),
                    Consumer(builder: (context, ref, _) => Text(
                        ref.watch(stringsProvider).tr('Capital Budgeting', 'الموازنة الرأسمالية'),
                        style: Theme.of(context).textTheme.headlineMedium)),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
              ).animate().fadeIn(),

              const SizedBox(height: 16),

              // Main tab selector
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _MainTabBar(
                  activeTab: _mainTab,
                  onChanged: (i) => setState(() => _mainTab = i),
                ),
              ).animate().fadeIn(delay: 100.ms),

              const SizedBox(height: 12),

              // Tab content
              Expanded(
                child: AnimatedSwitcher(
                  duration: 300.ms,
                  child: _mainTab == 0
                      ? _buildLearnTab()
                      : _mainTab == 1
                          ? _buildToolsTab()
                          : _buildPracticeTab(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LEARN TAB
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildLearnTab() {
    final s = ref.watch(stringsProvider);
    const slides = capitalBudgetingSlides;
    return Column(
      key: const ValueKey('learn'),
      children: [
        // Progress text
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                '${s.tr('Slide', 'الشريحة')} ${_currentSlide + 1} ${s.tr('of', 'من')} ${slides.length}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary(context),
                ),
              ),
              const Spacer(),
              Text(
                '${((_currentSlide + 1) / slides.length * 100).toInt()}%',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 13,
                  color: AppColors.primaryLight,
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 200.ms),

        const SizedBox(height: 8),

        // Progress bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (_currentSlide + 1) / slides.length,
              minHeight: 4,
              backgroundColor:
                  AppColors.borderColor(context).withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation(AppColors.primaryLight),
            ),
          ),
        ).animate().fadeIn(delay: 250.ms),

        const SizedBox(height: 16),

        // Page view
        Expanded(
          child: PageView.builder(
            controller: _slideController,
            itemCount: slides.length,
            onPageChanged: _onSlideChanged,
            itemBuilder: (context, index) {
              final st = _cbSlideStyle(slides[index].id, index);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildCbSlideCard(context,
                    slide: slides[index],
                    index: index,
                    total: slides.length,
                    ar: s.ar,
                    icon: st.$1,
                    color: st.$2),
              );
            },
          ),
        ),

        // Dots
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(slides.length, (i) {
              final isActive = i == _currentSlide;
              return AnimatedContainer(
                duration: 250.ms,
                width: isActive ? 24 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: isActive
                      ? _cbSlideStyle(slides[_currentSlide].id, _currentSlide).$2
                      : AppColors.borderColor(context),
                ),
              );
            }),
          ),
        ).animate().fadeIn(delay: 300.ms),

        // Navigation arrows
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: Row(
            children: [
              _NavArrow(
                icon: Icons.arrow_back_rounded,
                enabled: _currentSlide > 0,
                onTap: () => _slideController.previousPage(
                    duration: 350.ms, curve: Curves.easeInOut),
              ),
              const Spacer(),
              _NavArrow(
                icon: Icons.arrow_forward_rounded,
                enabled: _currentSlide < slides.length - 1,
                onTap: () => _slideController.nextPage(
                    duration: 350.ms, curve: Curves.easeInOut),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 350.ms),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TOOLS TAB
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildToolsTab() {
    return CustomScrollView(
      key: const ValueKey('tools'),
      slivers: [
        // Tool sub-tabs
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _ToolTab(
                  title: 'NPV',
                  icon: Icons.calculate_rounded,
                  color: AppColors.primaryLight,
                  isActive: _toolTab == 0,
                  onTap: () => setState(() => _toolTab = 0),
                ),
                const SizedBox(width: 12),
                _ToolTab(
                  title: 'IRR',
                  icon: Icons.percent_rounded,
                  color: AppColors.secondaryLight,
                  isActive: _toolTab == 1,
                  onTap: () => setState(() => _toolTab = 1),
                ),
                const SizedBox(width: 12),
                _ToolTab(
                  title: 'TVM',
                  icon: Icons.timeline_rounded,
                  color: AppColors.accentLight,
                  isActive: _toolTab == 2,
                  onTap: () => setState(() => _toolTab = 2),
                ),
              ],
            ).animate().fadeIn(delay: 200.ms),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 12)),

        // Active calculator
        if (_toolTab == 0) ..._buildNpvSection(),
        if (_toolTab == 1) ..._buildIrrSection(),
        if (_toolTab == 2) ..._buildTvmSection(),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }

  List<Widget> _buildNpvSection() {
    final isPositive = _npvResult >= 0;
    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.0,
            children: [
              _ResultCard(
                'NPV',
                'SAR ${_npvResult.toStringAsFixed(0)}',
                Icons.assessment_rounded,
                isPositive
                    ? AppColors.secondaryLight
                    : AppColors.dangerLight,
              ),
              _ResultCard(
                'PI',
                _profitabilityIndex.toStringAsFixed(2),
                Icons.pie_chart_rounded,
                AppColors.primaryLight,
              ),
              _ResultCard(
                'Payback',
                '${_npvPaybackPeriod.toStringAsFixed(1)} yr',
                Icons.timer_rounded,
                AppColors.accentLight,
              ),
            ],
          ).animate().fadeIn(delay: 300.ms),
        ),
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('NPV Calculator',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                _SliderRow(
                  label: 'Initial Investment',
                  value: _npvInitialInvestment,
                  min: 10000,
                  max: 500000,
                  prefix: 'SAR ',
                  divisions: 49,
                  onChanged: (v) =>
                      setState(() => _npvInitialInvestment = v),
                ),
                _SliderRow(
                  label: 'Discount Rate',
                  value: _npvDiscountRate,
                  min: 1,
                  max: 30,
                  suffix: '%',
                  divisions: 29,
                  onChanged: (v) =>
                      setState(() => _npvDiscountRate = v),
                ),
                _SliderRow(
                  label: 'Periods',
                  value: _npvPeriods.toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  onChanged: (v) => _updateNpvPeriods(v.toInt()),
                ),
                const SizedBox(height: 12),
                Text('Cash Flows per Period',
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                ...List.generate(
                  _npvCashFlows.length,
                  (i) => _SliderRow(
                    label: 'Year ${i + 1}',
                    value: _npvCashFlows[i],
                    min: 0,
                    max: 200000,
                    prefix: 'SAR ',
                    divisions: 40,
                    onChanged: (v) =>
                        setState(() => _npvCashFlows[i] = v),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 400.ms),
        ),
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Cash Flow Timeline',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: BarChart(BarChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (v) => FlLine(
                        color: AppColors.borderColor(context)
                            .withValues(alpha: 0.3),
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 50,
                          getTitlesWidget: (v, _) => Text(
                            'SAR ${(v / 1000).toInt()}k',
                            style: TextStyle(
                              fontSize: 9,
                              color: AppColors.textTertiary(context),
                            ),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (v, _) => Text(
                            v.toInt() == 0 ? 'Inv' : 'Y${v.toInt()}',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary(context),
                            ),
                          ),
                        ),
                      ),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: [
                      BarChartGroupData(x: 0, barRods: [
                        BarChartRodData(
                          toY: -_npvInitialInvestment,
                          color: AppColors.dangerLight,
                          width: 16,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(4),
                            bottomRight: Radius.circular(4),
                          ),
                        ),
                      ]),
                      ...List.generate(
                        _npvCashFlows.length,
                        (i) => BarChartGroupData(x: i + 1, barRods: [
                          BarChartRodData(
                            toY: _npvCashFlows[i],
                            color: AppColors.secondaryLight,
                            width: 16,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4),
                            ),
                          ),
                        ]),
                      ),
                    ],
                  )),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 500.ms),
        ),
      ),
    ];
  }

  List<Widget> _buildIrrSection() {
    final irr = _irrResult;
    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GlassCard(
            borderColor: AppColors.secondaryLight.withValues(alpha: 0.3),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Icon(Icons.percent_rounded,
                    color: AppColors.secondaryLight, size: 32),
                const SizedBox(height: 12),
                Text(
                  '${irr.toStringAsFixed(2)}%',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: AppColors.secondaryLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text('Internal Rate of Return',
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: (irr > 10 ? AppColors.secondary : AppColors.danger)
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    irr > 15
                        ? 'Strong Investment'
                        : irr > 10
                            ? 'Acceptable'
                            : irr > 5
                                ? 'Marginal'
                                : 'Reject',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: irr > 10
                          ? AppColors.secondaryLight
                          : AppColors.dangerLight,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 300.ms),
        ),
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('IRR Calculator',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                _SliderRow(
                  label: 'Initial Investment',
                  value: _irrInitialInvestment,
                  min: 10000,
                  max: 500000,
                  prefix: 'SAR ',
                  divisions: 49,
                  onChanged: (v) =>
                      setState(() => _irrInitialInvestment = v),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text('Cash Flows (${_irrCashFlows.length} periods)',
                        style: Theme.of(context).textTheme.titleSmall),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline,
                          size: 20),
                      onPressed: _irrCashFlows.length > 1
                          ? () => _updateIrrPeriods(
                              _irrCashFlows.length - 1)
                          : null,
                    ),
                    IconButton(
                      icon:
                          const Icon(Icons.add_circle_outline, size: 20),
                      onPressed: _irrCashFlows.length < 10
                          ? () => _updateIrrPeriods(
                              _irrCashFlows.length + 1)
                          : null,
                    ),
                  ],
                ),
                ...List.generate(
                  _irrCashFlows.length,
                  (i) => _SliderRow(
                    label: 'Year ${i + 1}',
                    value: _irrCashFlows[i],
                    min: 0,
                    max: 200000,
                    prefix: 'SAR ',
                    divisions: 40,
                    onChanged: (v) =>
                        setState(() => _irrCashFlows[i] = v),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 400.ms),
        ),
      ),
    ];
  }

  List<Widget> _buildTvmSection() {
    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.4,
            children: [
              _ResultCard(
                'Future Value',
                'SAR ${_tvmFutureValue.toStringAsFixed(0)}',
                Icons.trending_up_rounded,
                AppColors.accentLight,
              ),
              _ResultCard(
                'Total Interest',
                'SAR ${_tvmTotalInterest.toStringAsFixed(0)}',
                Icons.monetization_on_rounded,
                AppColors.secondaryLight,
              ),
            ],
          ).animate().fadeIn(delay: 300.ms),
        ),
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Time Value of Money',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                _SliderRow(
                  label: 'Present Value',
                  value: _tvmPresentValue,
                  min: 1000,
                  max: 500000,
                  prefix: 'SAR ',
                  divisions: 100,
                  onChanged: (v) =>
                      setState(() => _tvmPresentValue = v),
                ),
                _SliderRow(
                  label: 'Interest Rate',
                  value: _tvmRate,
                  min: 1,
                  max: 30,
                  suffix: '%',
                  divisions: 29,
                  onChanged: (v) => setState(() => _tvmRate = v),
                ),
                _SliderRow(
                  label: 'Periods (Years)',
                  value: _tvmPeriods.toDouble(),
                  min: 1,
                  max: 30,
                  divisions: 29,
                  onChanged: (v) =>
                      setState(() => _tvmPeriods = v.toInt()),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text('Compound Interest',
                        style: Theme.of(context).textTheme.bodyMedium),
                    const Spacer(),
                    Switch(
                      value: _tvmCompounding,
                      activeTrackColor: AppColors.primaryLight,
                      onChanged: (v) =>
                          setState(() => _tvmCompounding = v),
                    ),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(delay: 400.ms),
        ),
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Growth Over Time',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: LineChart(LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (v) => FlLine(
                        color: AppColors.borderColor(context)
                            .withValues(alpha: 0.3),
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 55,
                          getTitlesWidget: (v, _) => Text(
                            'SAR ${(v / 1000).toInt()}k',
                            style: TextStyle(
                              fontSize: 9,
                              color: AppColors.textTertiary(context),
                            ),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (v, _) => Text(
                            '${v.toInt()}',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary(context),
                            ),
                          ),
                        ),
                      ),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(
                          _tvmPeriods + 1,
                          (i) => FlSpot(
                            i.toDouble(),
                            _tvmPresentValue *
                                pow(1 + _tvmRate / 100, i),
                          ),
                        ),
                        isCurved: true,
                        color: AppColors.accentLight,
                        barWidth: 2,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color:
                              AppColors.accentLight.withValues(alpha: 0.1),
                        ),
                      ),
                      LineChartBarData(
                        spots: List.generate(
                          _tvmPeriods + 1,
                          (i) => FlSpot(
                            i.toDouble(),
                            _tvmPresentValue *
                                (1 + (_tvmRate / 100) * i),
                          ),
                        ),
                        isCurved: false,
                        color: AppColors.primaryLight
                            .withValues(alpha: 0.5),
                        barWidth: 1,
                        dashArray: [4, 4],
                        dotData: const FlDotData(show: false),
                      ),
                    ],
                  )),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _Legend('Compound', AppColors.accentLight),
                    const SizedBox(width: 16),
                    _Legend('Simple', AppColors.primaryLight),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(delay: 500.ms),
        ),
      ),
    ];
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PRACTICE TAB
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildPracticeTab() {
    final scenarios = _buildScenarios(ref.watch(stringsProvider));
    return ListView.builder(
      key: const ValueKey('practice'),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: scenarios.length,
      itemBuilder: (context, index) {
        final scenario = scenarios[index];
        final isExpanded = _expandedScenarios.contains(index);
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _PracticeCard(
            scenario: scenario,
            isExpanded: isExpanded,
            onToggle: () {
              setState(() {
                if (isExpanded) {
                  _expandedScenarios.remove(index);
                } else {
                  _expandedScenarios.add(index);
                }
              });
            },
          ),
        ).animate().fadeIn(delay: (100 + index * 80).ms).slideY(
              begin: 0.05,
              end: 0,
              duration: 350.ms,
              curve: Curves.easeOut,
            );
      },
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// PRIVATE WIDGETS
// ═════════════════════════════════════════════════════════════════════════════

// ── Main Tab Bar (Learn / Tools / Practice) ──

class _MainTabBar extends StatelessWidget {
  final int activeTab;
  final ValueChanged<int> onChanged;

  const _MainTabBar({required this.activeTab, required this.onChanged});

  // Website-matching tab colors
  static const _activeBlue = Color(0xFF0B5ED7);
  static const _activeBorderBlue = Color(0xFF0D6EFD);
  static const _inactiveText = Color(0xFF131B2B);

  static const _tabs = [
    (icon: Icons.school_rounded, label: 'Learn'),
    (icon: Icons.build_rounded, label: 'Tools'),
    (icon: Icons.help_outline_rounded, label: 'Practice'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : const Color(0xFFE5E5E5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: List.generate(_tabs.length, (i) {
          final isActive = activeTab == i;
          final tab = _tabs[i];
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: 250.ms,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: isActive
                      ? (isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white)
                      : Colors.transparent,
                  border: isActive
                      ? Border(bottom: BorderSide(color: _activeBorderBlue, width: 2))
                      : null,
                  boxShadow: isActive
                      ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 2)]
                      : null,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      tab.icon,
                      size: 20,
                      color: isActive
                          ? _activeBlue
                          : (isDark ? AppColors.darkTextSecondary : _inactiveText),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      tab.label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: isActive
                            ? _activeBlue
                            : (isDark ? AppColors.darkTextSecondary : _inactiveText),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ── Learn Slide Card ──

// ── Navigation Arrow ──

class _NavArrow extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _NavArrow({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: 200.ms,
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: enabled
              ? AppColors.primaryLight.withValues(alpha: 0.15)
              : AppColors.borderColor(context).withValues(alpha: 0.2),
          border: Border.all(
            color: enabled
                ? AppColors.primaryLight.withValues(alpha: 0.3)
                : Colors.transparent,
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: enabled
              ? AppColors.primaryLight
              : AppColors.textTertiary(context).withValues(alpha: 0.4),
        ),
      ),
    );
  }
}

// ── Practice Card ──

class _PracticeCard extends StatelessWidget {
  final _PracticeScenario scenario;
  final bool isExpanded;
  final VoidCallback onToggle;

  const _PracticeCard({
    required this.scenario,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderColor: isExpanded
          ? scenario.difficultyColor.withValues(alpha: 0.4)
          : null,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          // Header - always visible
          GestureDetector(
            onTap: onToggle,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Location icon
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color:
                          scenario.difficultyColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.location_city_rounded,
                      color: scenario.difficultyColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          scenario.title,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary(context),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${scenario.location} \u2022 ${scenario.currency}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textTertiary(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Difficulty badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color:
                          scenario.difficultyColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      scenario.difficulty,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: scenario.difficultyColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: 250.ms,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.textTertiary(context),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expandable content
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: _PracticeCardContent(scenario: scenario),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: 300.ms,
          ),
        ],
      ),
    );
  }
}

class _PracticeCardContent extends ConsumerStatefulWidget {
  final _PracticeScenario scenario;

  const _PracticeCardContent({required this.scenario});

  @override
  ConsumerState<_PracticeCardContent> createState() =>
      _PracticeCardContentState();
}

class _PracticeCardContentState extends ConsumerState<_PracticeCardContent> {
  final _answerController = TextEditingController();

  // null = not yet checked; true/false = last check outcome.
  bool? _correct;

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  void _check() {
    final scenario = widget.scenario;
    final raw = _answerController.text.trim().replaceAll(',', '');
    final entered = double.tryParse(raw);
    if (entered == null) {
      setState(() => _correct = null);
      return;
    }
    // ±5% tolerance (relative to the magnitude of the known answer). Falls back
    // to a small absolute tolerance when the answer is near zero.
    final target = scenario.answer;
    final tol = target.abs() < 1 ? 0.05 : target.abs() * 0.05;
    setState(() => _correct = (entered - target).abs() <= tol);
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final scenario = widget.scenario;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            color: AppColors.borderColor(context).withValues(alpha: 0.4),
            height: 1,
          ),
          const SizedBox(height: 14),

          // Context
          _SectionLabel(label: s.tr('Business Context', 'سياق العمل'), color: AppColors.primaryLight),
          const SizedBox(height: 6),
          Text(
            scenario.context,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: AppColors.textSecondary(context),
            ),
          ),

          const SizedBox(height: 14),

          // Given data
          _SectionLabel(label: s.tr('Given Data', 'المعطيات'), color: AppColors.accentLight),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.accentLight.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.accentLight.withValues(alpha: 0.15),
              ),
            ),
            child: Text(
              scenario.givenData,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 12,
                height: 1.6,
                color: AppColors.textPrimary(context),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Graded practice — attempt before the worked solution below.
          _buildGradedInput(context, s, scenario),

          const SizedBox(height: 14),

          // Calculation steps
          _SectionLabel(label: s.tr('Calculation', 'الحساب'), color: AppColors.secondaryLight),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.secondaryLight.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.secondaryLight.withValues(alpha: 0.15),
              ),
            ),
            child: Text(
              scenario.calculation,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 11,
                height: 1.6,
                color: AppColors.textPrimary(context),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Result
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  scenario.difficultyColor.withValues(alpha: 0.12),
                  scenario.difficultyColor.withValues(alpha: 0.04),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: scenario.difficultyColor.withValues(alpha: 0.25),
              ),
            ),
            child: Column(
              children: [
                Text(
                  scenario.result,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: scenario.difficultyColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  scenario.verdict,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                    color: AppColors.textSecondary(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradedInput(
      BuildContext context, AppStrings s, _PracticeScenario scenario) {
    final unitSuffix =
        scenario.answerUnit.isEmpty ? '' : ' ${scenario.answerUnit}';
    final Color feedbackColor = _correct == null
        ? AppColors.primaryLight
        : _correct!
            ? AppColors.secondaryLight
            : AppColors.dangerLight;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: feedbackColor.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(
              label: s.tr('Your Turn', 'دورك'), color: AppColors.primaryLight),
          const SizedBox(height: 8),
          Text(
            s.tr('Compute the ${scenario.answerLabel}$unitSuffix and check your answer.',
                'احسب ${scenario.answerLabel}$unitSuffix وتحقّق من إجابتك.'),
            style: TextStyle(
              fontSize: 12.5,
              height: 1.4,
              color: AppColors.textSecondary(context),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _answerController,
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true, signed: true),
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 14,
                    color: AppColors.textPrimary(context),
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: scenario.answerUnit.isEmpty
                        ? s.tr('Enter value', 'أدخل القيمة')
                        : scenario.answerUnit,
                    hintStyle: TextStyle(
                        fontSize: 13, color: AppColors.textTertiary(context)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                          color: AppColors.borderColor(context)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                          color: AppColors.borderColor(context)),
                    ),
                  ),
                  onSubmitted: (_) => _check(),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _check,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryLight,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(s.tr('Check', 'تحقّق'),
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          if (_correct != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  _correct!
                      ? Icons.check_circle_rounded
                      : Icons.cancel_rounded,
                  size: 18,
                  color: feedbackColor,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _correct!
                        ? s.tr('Correct! Within ±5% of the target.',
                            'صحيح! ضمن ±5٪ من القيمة المستهدفة.')
                        : s.tr('Not quite — check the worked solution below.',
                            'ليس تمامًا — راجع الحل أدناه.'),
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: feedbackColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final Color color;

  const _SectionLabel({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

// ── Tool Tab (for NPV/IRR/TVM sub-tabs) ──

class _ToolTab extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final bool isActive;
  final VoidCallback onTap;

  const _ToolTab({
    required this.title,
    required this.icon,
    required this.color,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GlassCard(
        onTap: onTap,
        borderColor: isActive ? color.withValues(alpha: 0.5) : null,
        backgroundColor: isActive ? color.withValues(alpha: 0.08) : null,
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Icon(icon,
                color:
                    isActive ? color : AppColors.textTertiary(context),
                size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color:
                    isActive ? color : AppColors.textTertiary(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Slider Row ──

class _SliderRow extends StatelessWidget {
  final String label;
  final double value;
  final double min, max;
  final String? prefix, suffix;
  final int? divisions;
  final ValueChanged<double> onChanged;

  const _SliderRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    this.prefix,
    this.suffix,
    this.divisions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    String display = value >= 1000
        ? '${(value / 1000).toStringAsFixed(value % 1000 == 0 ? 0 : 1)}k'
        : value.toStringAsFixed(value == value.toInt() ? 0 : 1);
    if (prefix != null) display = '$prefix$display';
    if (suffix != null) display = '$display$suffix';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          Row(children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            const Spacer(),
            Text(display,
                style: GoogleFonts.jetBrainsMono(
                    fontSize: 13, color: AppColors.primaryLight)),
          ]),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            activeColor: AppColors.primaryLight,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

// ── Result Card ──

class _ResultCard extends StatelessWidget {
  final String title, value;
  final IconData icon;
  final Color color;

  const _ResultCard(this.title, this.value, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderColor: color.withValues(alpha: 0.3),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          FittedBox(
            child: Text(
              value,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

// ── Legend ──

class _Legend extends StatelessWidget {
  final String label;
  final Color color;

  const _Legend(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 3, color: color),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(
                fontSize: 11, color: AppColors.textSecondary(context))),
      ],
    );
  }
}
