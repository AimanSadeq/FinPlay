// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/npv-irr.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbNpvIrr = KBArticle(
  id: 'npv-irr',
  title: Bi('Net Present Value and Internal Rate of Return', 'صافي القيمة الحالية ومعدل العائد الداخلي'),
  category: 'corporate-finance',
  level: KBLevel.intermediate,
  readingMinutes: 6,
  summary: Bi('The time value of money made operational: how NPV prices an investment against the cost of capital, what IRR really measures, a worked appraisal, and the known cases where the two disagree.', 'القيمة الزمنية للنقود مفعَّلةً: كيف يسعِّر NPV استثماراً مقابل تكلفة رأس المال، وما الذي يقيسه IRR فعلاً، وتقييم محلول، والحالات المعروفة التي يختلف فيها المقياسان.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('A riyal today is worth more than a riyal next year, because today\'s riyal can be invested to grow, is certain rather than promised, and is not eroded by inflation while you wait. Discounting is the arithmetic of that preference: it shrinks future cash flows back to their equivalent value today. Net present value applies it to an investment decision: discount every expected cash flow at the opportunity cost of capital, sum them, and subtract the investment. A positive NPV means the project returns more than the same money could earn elsewhere at the same risk; it adds value. A negative NPV destroys value even if the project "makes money" in nominal terms.', 'ريال اليوم يساوي أكثر من ريال العام القادم، لأن ريال اليوم يمكن استثماره لينمو، ولأنه مؤكد لا موعود، ولا يأكله التضخم وأنت تنتظر. والخصم هو حسابُ هذا التفضيل: يُرجع التدفقات النقدية المستقبلية إلى ما يعادلها اليوم. ويطبقه صافي القيمة الحالية على قرار استثماري: اخصم كل تدفق نقدي متوقع بتكلفة الفرصة لرأس المال، واجمع، ثم اطرح الاستثمار. NPV الموجب يعني أن المشروع يعيد أكثر مما كان المال نفسه سيكسبه في مكان آخر بالمخاطر نفسها؛ أي أنه يضيف قيمة. وNPV السالب يهدم قيمة حتى لو كان المشروع «يكسب» اسمياً.'),
        Bi('The internal rate of return asks the inverse question: at what discount rate would this project\'s NPV be exactly zero? IRR is the project\'s break-even cost of capital. The decision rule pairs them: accept when NPV > 0, equivalently (for conventional cash flows) when IRR exceeds the hurdle rate.', 'ويسأل معدل العائد الداخلي السؤال المعكوس: عند أي معدل خصم يصبح NPV لهذا المشروع صفراً بالضبط؟ إن IRR هو تكلفة رأس المال التي يتعادل عندها المشروع. وقاعدة القرار تجمعهما: اقبل عندما يكون NPV > 0، أو بصورة مكافئة (للتدفقات التقليدية) عندما يتجاوز IRR معدلَ العتبة.'),
      ],
      formulas: [
        KBFormula('NPV = Σₜ CFₜ ÷ (1 + r)ᵗ − I₀', caption: Bi('CFₜ: expected cash flow in period t; r: opportunity cost of capital; I₀: initial investment.', 'CFₜ: التدفق النقدي المتوقع في الفترة t؛ وr: تكلفة الفرصة لرأس المال؛ وI₀: الاستثمار الأولي.')),
        KBFormula('IRR solves: Σₜ CFₜ ÷ (1 + IRR)ᵗ = I₀', caption: Bi('The rate that sets NPV to zero; found iteratively, not algebraically.', 'المعدل الذي يجعل NPV صفراً؛ ويوجد بالتكرار لا بالجبر.')),
      ],
    ),
    KBSection(
      heading: Bi('Worked example', 'مثال محلول'),
      paragraphs: [
        Bi('A SAR 1,000,000 machine is expected to generate SAR 320,000 at the end of each year for four years. The company\'s cost of capital is 10%. Discount each flow: 320,000 ÷ 1.10 = 290,909; ÷ 1.10² = 264,463; ÷ 1.10³ = 240,421; ÷ 1.10⁴ = 218,564. The present values total 1,014,357, so NPV = 1,014,357 − 1,000,000 = SAR +14,357: accept, narrowly. The IRR works out to roughly 10.7%, confirming the same verdict: the project clears a 10% hurdle with less than one percentage point to spare. The thin margin is the real finding; a small shortfall in the annual flows or a rise in funding costs flips the decision, so sensitivity analysis matters more here than the point estimate.', 'آلة بمليون ريال يُتوقع أن تدر 320,000 ريال في نهاية كل سنة لأربع سنوات، وتكلفة رأس مال الشركة 10%. اخصم كل تدفق: 320,000 ÷ 1.10 = 290,909؛ ÷ 1.10² = 264,463؛ ÷ 1.10³ = 240,421؛ ÷ 1.10⁴ = 218,564. مجموع القيم الحالية 1,014,357، إذن NPV = 1,014,357 − 1,000,000 = +14,357 ريالاً: اقبل، بفارق ضئيل. ويبلغ IRR نحو 10.7% مؤكداً الحكم نفسه: يتجاوز المشروع عتبة 10% بأقل من نقطة مئوية. والهامش الرقيق هو الاستنتاج الحقيقي؛ فنقص يسير في التدفقات السنوية أو ارتفاع في تكلفة التمويل يقلب القرار، ولذا يهم تحليل الحساسية هنا أكثر من التقدير النقطي.'),
      ],
    ),
    KBSection(
      heading: Bi('When NPV and IRR disagree', 'عندما يختلف NPV وIRR'),
      paragraphs: [
        Bi('For a single conventional project the two rules agree. They diverge in three known situations. Mutually exclusive projects of different scale: a small project can post a spectacular IRR while a larger rival adds more absolute value; NPV ranks correctly because you cannot bank a percentage. Non-conventional cash flows (outflows after inflows, as in mine-closure or decommissioning costs): the IRR equation can have multiple roots or none, while NPV stays well-defined. Reinvestment assumptions: IRR implicitly assumes interim flows are reinvested at the IRR itself, which flatters high-IRR projects; the modified IRR (MIRR) repairs this by compounding at the cost of capital. Corporate-finance doctrine is therefore consistent: IRR is a useful communication device, NPV is the decision criterion.', 'في المشروع المفرد التقليدي تتفق القاعدتان. وتفترقان في ثلاث حالات معروفة. المشاريع المتنافية مختلفة الحجم: قد يسجل مشروع صغير IRR باهراً بينما يضيف منافسه الأكبر قيمة مطلقة أعلى؛ وNPV يرتب ترتيباً صحيحاً لأنك لا تودع نسبةً مئوية في البنك. التدفقات غير التقليدية (خروج نقدي بعد الدخول، كما في تكاليف إغلاق المناجم أو إيقاف التشغيل): قد يكون لمعادلة IRR جذور متعددة أو لا جذر لها، بينما يبقى NPV معرَّفاً جيداً. وافتراض إعادة الاستثمار: يفترض IRR ضمنياً إعادة استثمار التدفقات البينية بمعدل IRR نفسه، وهو ما يجامل المشاريع مرتفعة العائد؛ ويصلح ذلك معدلُ العائد الداخلي المعدل (MIRR) بالتركيب عند تكلفة رأس المال. ولذا فمذهب المالية الراسخ متسق: IRR أداة تواصل مفيدة، وNPV هو معيار القرار.'),
      ],
    ),
    KBSection(
      heading: Bi('Where the discount rate comes from', 'من أين يأتي معدل الخصم'),
      paragraphs: [
        Bi('The rate r is not a preference; it is the return investors could earn on alternatives of equivalent risk, which for the average-risk project of a firm is the weighted average cost of capital. Using a single corporate WACC for projects of very different risk is a known bias: it makes risky projects look better and safe projects look worse than they are. The WACC article develops this fully.', 'المعدل r ليس ذوقاً شخصياً؛ إنه العائد الذي يمكن للمستثمرين تحقيقه في بدائل بمخاطر مكافئة، وهو للمشروع متوسط المخاطر في الشركة المتوسطُ المرجح لتكلفة رأس المال. واستخدام WACC واحد للشركة في مشاريع شديدة التباين في المخاطر انحيازٌ معروف: يجمِّل المشاريع الخطرة ويظلم الآمنة. وتتوسع مقالة WACC في هذا كاملاً.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Ranking mutually exclusive projects by IRR. Percentages do not pay salaries; absolute value does. Rank by NPV.', 'ترتيب المشاريع المتنافية بمعدل IRR. النسب المئوية لا تدفع الرواتب؛ القيمة المطلقة تفعل. رتب بـ NPV.'),
    Bi('Discounting nominal cash flows with a real rate (or vice versa). Keep inflation treatment consistent on both sides.', 'خصم تدفقات اسمية بمعدل حقيقي (أو العكس). أبقِ معالجة التضخم متسقة في الطرفين.'),
    Bi('Counting sunk costs, or ignoring opportunity costs and cannibalization. Only incremental cash flows belong in the appraisal.', 'احتساب التكاليف الغارقة، أو تجاهل تكاليف الفرصة وأكل مبيعات المنتجات القائمة. لا يدخل التقييمَ إلا التدفقات الإضافية.'),
    Bi('Presenting a single-point NPV without sensitivities when the margin is thin, as in the worked example above.', 'عرض NPV نقطي وحيد بلا تحليل حساسية عندما يكون الهامش رقيقاً، كما في المثال المحلول أعلاه.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IAS 36 §55–57',
      note: Bi('Discounting is embedded in IFRS itself: value-in-use for impairment testing requires pre-tax rates reflecting the asset\'s specific risks.', 'الخصم مضمَّن في المعايير ذاتها: القيمة قيد الاستخدام في اختبار الهبوط تتطلب معدلات قبل الضريبة تعكس مخاطر الأصل بعينه.'),
      segments: [
        KBStandardSegment('IAS 36', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-36-impairment-of-assets/'),
        KBStandardSegment(' §55–57'),
      ],
    ),
    KBStandardRef(
      standard: 'IFRS 13',
      note: Bi('Fair value measurement: present-value techniques as Level 3 valuation tools.', 'قياس القيمة العادلة: أساليب القيمة الحالية أدواتِ تقييم في المستوى الثالث.'),
      segments: [
        KBStandardSegment('IFRS 13', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ifrs-13-fair-value-measurement/'),
      ],
    ),
  ],
  relatedTerms: [],
  relatedModules: [
    KBRelatedModule('/education/capital-budgeting', Bi('Tool: Capital Budgeting (NPV/IRR calculators)', 'الأداة: الموازنة الرأسمالية (حاسبات NPV/IRR)')),
    KBRelatedModule('/education/fundamentals', Bi('Module: Financial Management Primer (Investing pillar)', 'الوحدة: تمهيد الإدارة المالية (ركيزة الاستثمار)')),
  ],
  relatedArticles: [
    'wacc',
    'working-capital',
    'time-value-of-money',
    'impairment-testing',
    'dcf-valuation',
  ],
  references: [
    'Brealey, R. A., Myers, S. C., & Allen, F. (2020). Principles of corporate finance (13th ed.). McGraw-Hill.',
    'Berk, J., & DeMarzo, P. (2020). Corporate finance (5th ed.). Pearson.',
    'Graham, J. R., & Harvey, C. R. (2001). The theory and practice of corporate finance: Evidence from the field. Journal of Financial Economics, 60(2-3), 187-243.',
  ],
  keywords: [
    'NPV',
    'IRR',
    'discounting',
    'capital budgeting',
    'hurdle rate',
    'time value',
    'صافي القيمة الحالية',
    'معدل العائد الداخلي',
    'خصم',
    'الموازنة الرأسمالية',
  ],
);
