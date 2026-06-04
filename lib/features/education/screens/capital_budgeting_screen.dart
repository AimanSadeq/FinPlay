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

// ─── DATA MODELS ───────────────────────────────────────────────────────────────

class _SlideData {
  final String title;
  final IconData icon;
  final String description;
  final String? formula;
  final Color color;

  const _SlideData({
    required this.title,
    required this.icon,
    required this.description,
    this.formula,
    required this.color,
  });
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

List<_SlideData> _buildSlides(AppStrings s) => <_SlideData>[
  _SlideData(
    title: s.tr('What is Capital Budgeting?', 'ما هي الموازنة الرأسمالية؟'),
    icon: Icons.account_balance_rounded,
    description: s.tr(
        'The process of evaluating long-term investment projects. '
        'Involves significant capital outlays. '
        'Decisions are often irreversible with lasting impact on the firm.',
        'عملية تقييم المشاريع الاستثمارية طويلة الأجل. '
        'تنطوي على إنفاق رأسمالي كبير. '
        'وغالبًا ما تكون القرارات غير قابلة للتراجع ولها أثر دائم على المنشأة.'),
    color: AppColors.primaryLight,
  ),
  _SlideData(
    title: s.tr('Time Value of Money', 'القيمة الزمنية للنقود'),
    icon: Icons.schedule_rounded,
    description: s.tr(
        'A dollar today is worth more than a dollar tomorrow. '
        'Driven by opportunity cost, risk, and inflation. '
        'This is the foundation for all capital budgeting techniques.',
        'الريال اليوم يساوي أكثر من الريال غدًا. '
        'يعود ذلك إلى تكلفة الفرصة البديلة والمخاطر والتضخم. '
        'وهذا هو الأساس لجميع أساليب الموازنة الرأسمالية.'),
    color: AppColors.accentLight,
  ),
  _SlideData(
    title: s.tr('Present & Future Value', 'القيمة الحالية والمستقبلية'),
    icon: Icons.swap_vert_rounded,
    description: s.tr(
        'Convert between present and future cash flows using discount/growth rates. '
        'Cash flows further in the future are worth progressively less today.',
        'التحويل بين التدفقات النقدية الحالية والمستقبلية باستخدام معدلات الخصم/النمو. '
        'فالتدفقات النقدية الأبعد في المستقبل تساوي قيمة أقل تدريجيًا اليوم.'),
    formula: 'FV = PV \u00d7 (1 + r)\u207f\nPV = FV / (1 + r)\u207f',
    color: AppColors.secondaryLight,
  ),
  _SlideData(
    title: s.tr('Net Present Value (NPV)', '\u0635\u0627\u0641\u064a \u0627\u0644\u0642\u064a\u0645\u0629 \u0627\u0644\u062d\u0627\u0644\u064a\u0629 (NPV)'),
    icon: Icons.assessment_rounded,
    description: s.tr(
        'The "gold standard" of capital budgeting \u2014 directly measures wealth creation. '
        'Accept the project if NPV > 0. Reject if NPV < 0.',
        '\u0627\u0644\u0645\u0639\u064a\u0627\u0631 \u0627\u0644\u0630\u0647\u0628\u064a \u0644\u0644\u0645\u0648\u0627\u0632\u0646\u0629 \u0627\u0644\u0631\u0623\u0633\u0645\u0627\u0644\u064a\u0629 \u2014 \u064a\u0642\u064a\u0633 \u0645\u0628\u0627\u0634\u0631\u0629\u064b \u062e\u0644\u0642 \u0627\u0644\u062b\u0631\u0648\u0629. '
        '\u0627\u0642\u0628\u0644 \u0627\u0644\u0645\u0634\u0631\u0648\u0639 \u0625\u0630\u0627 \u0643\u0627\u0646\u062a NPV > 0\u060c \u0648\u0627\u0631\u0641\u0636\u0647 \u0625\u0630\u0627 \u0643\u0627\u0646\u062a NPV < 0.'),
    formula: 'NPV = \u2013Investment + \u03a3 CF\u2099 / (1+r)\u207f',
    color: AppColors.primaryLight,
  ),
  _SlideData(
    title: s.tr('Internal Rate of Return', 'معدل العائد الداخلي'),
    icon: Icons.percent_rounded,
    description: s.tr(
        'The discount rate that makes NPV equal to zero. '
        'Accept if IRR > hurdle rate. '
        'Intuitive percentage return, but can mislead for non-conventional cash flows.',
        'معدل الخصم الذي يجعل صافي القيمة الحالية مساويًا للصفر. '
        'اقبل المشروع إذا كان IRR > المعدل الأدنى المطلوب. '
        'عائد نسبي بديهي، لكنه قد يضلّل في حالة التدفقات النقدية غير التقليدية.'),
    formula: '0 = \u2013Investment + \u03a3 CF\u2099 / (1+IRR)\u207f',
    color: AppColors.secondaryLight,
  ),
  _SlideData(
    title: s.tr('Payback Period', 'فترة الاسترداد'),
    icon: Icons.timer_rounded,
    description: s.tr(
        'Time for cumulative cash flows to recover the initial investment. '
        'Simple version ignores TVM. Discounted version is more accurate. '
        'Ignores all cash flows occurring after the payback point.',
        'الوقت اللازم لاسترداد الاستثمار الأولي من التدفقات النقدية المتراكمة. '
        'النسخة البسيطة تتجاهل القيمة الزمنية للنقود، والنسخة المخصومة أكثر دقة. '
        'وتتجاهل جميع التدفقات النقدية التي تحدث بعد نقطة الاسترداد.'),
    color: AppColors.accentLight,
  ),
  _SlideData(
    title: s.tr('Profitability Index', '\u0645\u0624\u0634\u0631 \u0627\u0644\u0631\u0628\u062d\u064a\u0629'),
    icon: Icons.pie_chart_rounded,
    description: s.tr(
        'Measures value created per dollar invested. '
        'Accept if PI > 1. '
        'Best metric for capital rationing \u2014 maximizes value per dollar invested.',
        '\u064a\u0642\u064a\u0633 \u0627\u0644\u0642\u064a\u0645\u0629 \u0627\u0644\u0645\u062a\u0648\u0644\u062f\u0629 \u0639\u0646 \u0643\u0644 \u0631\u064a\u0627\u0644 \u0645\u0633\u062a\u062b\u0645\u0631. '
        '\u0627\u0642\u0628\u0644 \u0627\u0644\u0645\u0634\u0631\u0648\u0639 \u0625\u0630\u0627 \u0643\u0627\u0646 PI > 1. '
        '\u0648\u0647\u0648 \u0623\u0641\u0636\u0644 \u0645\u0642\u064a\u0627\u0633 \u0639\u0646\u062f \u062a\u0631\u0634\u064a\u062f \u0631\u0623\u0633 \u0627\u0644\u0645\u0627\u0644 \u2014 \u0625\u0630 \u064a\u0639\u0638\u0651\u0645 \u0627\u0644\u0642\u064a\u0645\u0629 \u0644\u0643\u0644 \u0631\u064a\u0627\u0644 \u0645\u0633\u062a\u062b\u0645\u0631.'),
    formula: 'PI = PV of Cash Flows / Investment',
    color: AppColors.primaryLight,
  ),
  _SlideData(
    title: s.tr('Capital Rationing', 'ترشيد رأس المال'),
    icon: Icons.savings_rounded,
    description: s.tr(
        'Occurs when there are more positive-NPV projects than available funds. '
        'Rank projects by PI and select from the top until the budget is exhausted. '
        'Hard rationing (external) vs soft rationing (internal).',
        'يحدث عندما تتوفر مشاريع ذات صافي قيمة حالية موجبة أكثر من الأموال المتاحة. '
        'رتّب المشاريع حسب مؤشر الربحية واختر من الأعلى حتى نفاد الموازنة. '
        'الترشيد الصارم (خارجي) مقابل الترشيد المرن (داخلي).'),
    color: AppColors.dangerLight,
  ),
  _SlideData(
    title: s.tr('Discounted Cash Flow (DCF)', 'التدفق النقدي المخصوم (DCF)'),
    icon: Icons.water_drop_rounded,
    description: s.tr(
        'The umbrella technique behind NPV and IRR: project future cash flows, '
        'then discount each back to today at the required rate of return. '
        'Value depends on the size, timing, and risk of those cash flows.',
        'الأسلوب الشامل الذي تستند إليه NPV و IRR: توقّع التدفقات النقدية المستقبلية، '
        'ثم اخصم كلًّا منها إلى قيمته الحالية باستخدام معدل العائد المطلوب. '
        'وتعتمد القيمة على حجم تلك التدفقات وتوقيتها ومخاطرها.'),
    formula: 'Value = Σ CFₙ / (1 + r)ⁿ',
    color: AppColors.primaryLight,
  ),
  _SlideData(
    title: s.tr('Future Value (FV)', 'القيمة المستقبلية (FV)'),
    icon: Icons.trending_up_rounded,
    description: s.tr(
        'How much a sum invested today grows to by a future date at a given rate. '
        'The mirror image of present value — compounding forward instead of '
        'discounting back.',
        'إلى أي قيمة ينمو مبلغ مستثمر اليوم بحلول تاريخ مستقبلي عند معدل معيّن. '
        'وهي الصورة المعاكسة للقيمة الحالية — تراكم إلى الأمام بدلًا من الخصم إلى الوراء.'),
    formula: 'FV = PV × (1 + r)ⁿ',
    color: AppColors.accentLight,
  ),
  _SlideData(
    title: s.tr('Discounted Payback Period', 'فترة الاسترداد المخصومة'),
    icon: Icons.timelapse_rounded,
    description: s.tr(
        'Like payback, but recovers the investment from DISCOUNTED cash flows, '
        'so it respects the time value of money. Always longer than simple '
        'payback. Still ignores cash flows after the cut-off.',
        'مثل فترة الاسترداد، لكنها تسترد الاستثمار من التدفقات النقدية المخصومة، '
        'لذا تراعي القيمة الزمنية للنقود. وهي دائمًا أطول من الاسترداد البسيط. '
        'ولا تزال تتجاهل التدفقات النقدية بعد نقطة القطع.'),
    color: AppColors.accentLight,
  ),
  _SlideData(
    title: s.tr('Accounting Rate of Return (ARR)', 'المعدل المحاسبي للعائد (ARR)'),
    icon: Icons.calculate_rounded,
    description: s.tr(
        'A profitability measure based on accounting profit, not cash flow. '
        'Easy to compute from financial statements, but ignores the time value '
        'of money — use it only as a rough screen.',
        'مقياس للربحية يستند إلى الربح المحاسبي وليس التدفق النقدي. '
        'سهل الحساب من القوائم المالية، لكنه يتجاهل القيمة الزمنية للنقود — '
        'استخدمه فقط كأداة فرز أولية تقريبية.'),
    formula: 'ARR = Average Accounting Profit / Average Investment',
    color: AppColors.dangerLight,
  ),
  _SlideData(
    title: s.tr('Mutually Exclusive Projects', 'المشاريع المتنافية'),
    icon: Icons.call_split_rounded,
    description: s.tr(
        'When choosing only ONE of several projects, pick the highest POSITIVE '
        'NPV — not the highest IRR. IRR and PI can rank mutually exclusive '
        'projects incorrectly because of differences in scale and timing.',
        'عند اختيار مشروع واحد فقط من بين عدة مشاريع، اختر صاحب أعلى صافي قيمة حالية '
        'موجبة — وليس أعلى معدل عائد داخلي. فمعدل العائد الداخلي ومؤشر الربحية قد يرتّبان '
        'المشاريع المتنافية ترتيبًا خاطئًا بسبب اختلاف الحجم والتوقيت.'),
    color: AppColors.purple,
  ),
  _SlideData(
    title: s.tr('NPV vs IRR Conflicts', 'تعارض NPV مع IRR'),
    icon: Icons.compare_arrows_rounded,
    description: s.tr(
        'NPV and IRR usually agree, but can conflict with mutually exclusive '
        'projects or non-conventional cash flows (which may give multiple IRRs). '
        'When they disagree, trust NPV — it measures wealth created directly.',
        'عادةً ما تتفق NPV و IRR، لكنهما قد تتعارضان في المشاريع المتنافية أو التدفقات '
        'النقدية غير التقليدية (التي قد تعطي عدة قيم لـ IRR). '
        'وعند اختلافهما، اعتمد على NPV — فهي تقيس الثروة المتولدة مباشرةً.'),
    color: AppColors.secondaryLight,
  ),
  _SlideData(
    title: s.tr('Decision Rules Summary', 'ملخص قواعد القرار'),
    icon: Icons.checklist_rounded,
    description: s.tr(
        'NPV > 0 (primary criterion)\n'
        'IRR > hurdle rate\n'
        'Payback < target period\n'
        'PI > 1\n\n'
        'NPV is the most reliable and should be the primary criterion.',
        'NPV > 0 (المعيار الأساسي)\n'
        'IRR > المعدل الأدنى المطلوب\n'
        'فترة الاسترداد < الفترة المستهدفة\n'
        'PI > 1\n\n'
        'صافي القيمة الحالية هو الأكثر موثوقية ويجب أن يكون المعيار الأساسي.'),
    color: AppColors.secondaryLight,
  ),
  _SlideData(
    title: s.tr('Key Takeaways', 'أبرز النقاط'),
    icon: Icons.lightbulb_rounded,
    description: s.tr(
        'TVM is the foundation of all analysis. '
        'NPV is the gold standard metric. '
        'Use multiple metrics together for robust decisions. '
        'Combine quantitative analysis with qualitative judgment.',
        'القيمة الزمنية للنقود هي أساس كل تحليل. '
        'وصافي القيمة الحالية هو المقياس المعياري الذهبي. '
        'استخدم عدة مقاييس معًا لاتخاذ قرارات متينة. '
        'وادمج التحليل الكمي مع الحكم النوعي.'),
    color: AppColors.accentLight,
  ),
];

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
  final PageController _slideController = PageController();
  int _currentSlide = 0;

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
    final slides = _buildSlides(s);
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
            onPageChanged: (i) => setState(() => _currentSlide = i),
            itemBuilder: (context, index) {
              final slide = slides[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _LearnSlideCard(slide: slide, index: index, total: slides.length),
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
                      ? slides[_currentSlide].color
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

class _LearnSlideCard extends StatelessWidget {
  final _SlideData slide;
  final int index;
  final int total;

  const _LearnSlideCard({required this.slide, required this.index, required this.total});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderColor: slide.color.withValues(alpha: 0.3),
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Slide number badge
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: slide.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${index + 1} / $total',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: slide.color,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: slide.color.withValues(alpha: 0.12),
              ),
              child: Icon(slide.icon, color: slide.color, size: 32),
            ),

            const SizedBox(height: 20),

            // Title
            Text(
              slide.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary(context),
              ),
            ),

            const SizedBox(height: 16),

            // Description
            Text(
              slide.description,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                height: 1.6,
                color: AppColors.textSecondary(context),
              ),
            ),

            // Formula box (optional)
            if (slide.formula != null) ...[
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: slide.color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: slide.color.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  slide.formula!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.6,
                    color: slide.color,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

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
