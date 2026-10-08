// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/wacc.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbWacc = KBArticle(
  id: 'wacc',
  title: Bi('Cost of Capital and WACC', 'تكلفة رأس المال والمتوسط المرجح WACC'),
  category: 'corporate-finance',
  level: KBLevel.advanced,
  readingMinutes: 7,
  summary: Bi('What the firm\'s hurdle rate is made of: the cost of debt after tax, the cost of equity via CAPM, the weighting logic, a full computation, and the judgment calls hiding inside each input.', 'مم يتكون معدل عتبة الشركة: تكلفة الدين بعد الضريبة، وتكلفة حقوق الملكية عبر CAPM، ومنطق الترجيح، وحساب كامل، والاجتهادات المختبئة داخل كل مدخل.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('A company is financed by a mix of debt and equity, and each provider of capital requires a return for the risk they carry. The weighted average cost of capital blends those required returns in proportion to the market values of debt and equity in the capital structure. It answers one question: what must the company earn on an average-risk investment merely to satisfy everyone who financed it? That is why WACC is the default discount rate in NPV analysis and the benchmark in value-based management: returns above WACC create value, returns below it destroy value even when accounting profit is positive.', 'تُموَّل الشركة بمزيج من الدين وحقوق الملكية، وكل مقدم لرأس المال يطلب عائداً لقاء المخاطر التي يحملها. ويمزج المتوسط المرجح لتكلفة رأس المال تلك العوائد المطلوبة بنسب القيم السوقية للدين وحقوق الملكية في هيكل رأس المال. وهو يجيب عن سؤال واحد: كم يجب أن تكسب الشركة على استثمار متوسط المخاطر لمجرد إرضاء كل من موَّلها؟ ولهذا فإن WACC هو معدل الخصم الافتراضي في تحليل NPV والمرجع في الإدارة القائمة على القيمة: العوائد فوق WACC تنشئ قيمة، ودونه تهدم قيمة حتى مع ربح محاسبي موجب.'),
      ],
      formulas: [
        KBFormula('WACC = (E ÷ V) × rₑ + (D ÷ V) × r_d × (1 − T)', caption: Bi('E, D: market values of equity and debt; V = E + D; rₑ: cost of equity; r_d: pre-tax cost of debt; T: corporate tax rate.', 'E وD: القيمتان السوقيتان لحقوق الملكية والدين؛ وV = E + D؛ وrₑ: تكلفة حقوق الملكية؛ وr_d: تكلفة الدين قبل الضريبة؛ وT: معدل ضريبة الشركات.')),
      ],
    ),
    KBSection(
      heading: Bi('The components', 'المكونات'),
      paragraphs: [
        Bi('Cost of debt is the easier half: the rate the company would pay to borrow today (yield on its bonds or current loan pricing), not the historical coupon on old debt. Interest is tax-deductible in most jurisdictions, so the after-tax cost is r_d × (1 − T). Cost of equity cannot be observed and must be modeled. The standard model is the Capital Asset Pricing Model: shareholders require the risk-free rate plus compensation for the systematic (non-diversifiable) risk of the stock, measured by beta, times the market risk premium. Judgment enters every input: which government curve is genuinely risk-free in the market at hand, whether beta comes from the company\'s own noisy history or from re-levered peer betas, and which equity risk premium estimate to adopt (survey, historical, or implied).', 'تكلفة الدين هي النصف الأسهل: المعدل الذي ستدفعه الشركة لو اقترضت اليوم (عائد سنداتها أو تسعير قروضها الحالي)، لا الكوبون التاريخي لدين قديم. والفائدة قابلة للخصم الضريبي في معظم الولايات، فتكون التكلفة بعد الضريبة r_d × (1 − T). أما تكلفة حقوق الملكية فلا تُرصد مباشرة ويجب نمذجتها. والنموذج المعياري هو نموذج تسعير الأصول الرأسمالية CAPM: يطلب المساهمون المعدل الخالي من المخاطر زائداً تعويضاً عن المخاطر المنتظمة (غير القابلة للتنويع) للسهم، مقيسةً بمعامل بيتا، مضروبة في علاوة مخاطر السوق. ويدخل الاجتهاد في كل مدخل: أي منحنى حكومي يُعد خالياً من المخاطر حقاً في السوق المعنية، وهل تُؤخذ بيتا من تاريخ الشركة المشوش أم من بيتات نظائر يعاد ترجيحها برافعة الشركة، وأي تقدير لعلاوة مخاطر الملكية يُعتمد (مسحي أو تاريخي أو ضمني).'),
      ],
      formulas: [
        KBFormula('rₑ = r_f + β × (E[r_m] − r_f)', caption: Bi('CAPM: r_f is the risk-free rate, β the stock\'s systematic risk, and (E[r_m] − r_f) the market risk premium.', 'نموذج CAPM: حيث r_f المعدل الخالي من المخاطر، وβ المخاطر المنتظمة للسهم، و(E[r_m] − r_f) علاوة مخاطر السوق.')),
      ],
    ),
    KBSection(
      heading: Bi('Worked example', 'مثال محلول'),
      paragraphs: [
        Bi('A company has market equity of SAR 600m and debt of SAR 400m (V = 1,000m; E/V = 60%, D/V = 40%). Practitioners often weight on net debt instead, debt less surplus cash; either is defensible provided the cost of debt applied matches the balance being weighted. Its current borrowing cost is 6%, the tax rate is 20%, the risk-free rate is 4.5%, its beta is 1.2, and the market risk premium is 6%. Cost of equity: 4.5% + 1.2 × 6% = 11.7%. After-tax cost of debt: 6% × (1 − 0.20) = 4.8%. WACC = 0.60 × 11.7% + 0.40 × 4.8% = 7.02% + 1.92% = 8.94%, in practice quoted as ≈ 9%. Every average-risk project must clear roughly 9%; the machine in the NPV article, with its 10.7% IRR, survives this hurdle too, but a riskier venture should be tested against a higher, risk-adjusted rate, not this corporate average.', 'شركة قيمتها السوقية لحقوق الملكية 600 مليون ريال ودينها 400 مليون (V = 1,000 مليون؛ E/V = 60%؛ D/V = 40%). وكثيراً ما يرجّح الممارسون بصافي الدين بدلاً من ذلك، أي الدين ناقص النقد الفائض؛ وكلاهما مقبول ما دامت تكلفة الدين المطبقة تطابق الرصيد المرجَّح. تكلفة اقتراضها الحالية 6%، ومعدل الضريبة 20%، والمعدل الخالي من المخاطر 4.5%، وبيتا 1.2، وعلاوة مخاطر السوق 6%. تكلفة حقوق الملكية: 4.5% + 1.2 × 6% = 11.7%. وتكلفة الدين بعد الضريبة: 6% × (1 − 0.20) = 4.8%. إذن WACC = 0.60 × 11.7% + 0.40 × 4.8% = 7.02% + 1.92% = 8.94%، وتُقرَّب عملياً إلى نحو 9%. فعلى كل مشروع متوسط المخاطر أن يتجاوز نحو 9%؛ والآلة في مقالة NPV، بعائدها الداخلي 10.7%، تجتاز هذه العتبة أيضاً، أما مشروع أعلى مخاطرة فيُختبر بمعدل أعلى معدَّل بالمخاطر، لا بهذا المتوسط العام للشركة.'),
      ],
    ),
    KBSection(
      heading: Bi('Uses, limits, and the risk-matching principle', 'الاستخدامات والحدود ومبدأ مطابقة المخاطر'),
      paragraphs: [
        Bi('WACC is the correct discount rate only for projects whose risk resembles the company\'s existing business and whose financing does not materially change the capital structure. Applying one corporate WACC everywhere systematically favors risky divisions and starves safe ones, a bias documented in survey evidence on capital budgeting practice. The remedy is divisional or project-specific rates built from peer betas of the relevant industry. A second discipline: weights must be market values, not book values, and the target structure matters more than today\'s snapshot when the company is deliberately re-levering. Finally, WACC moves: rate cycles, country risk, and structure changes all shift it, so a hurdle rate fixed years ago is a decision error waiting to happen.', 'ليس WACC معدلَ الخصم الصحيح إلا للمشاريع التي تشبه مخاطرُها أعمالَ الشركة القائمة ولا يغيِّر تمويلُها هيكلَ رأس المال جوهرياً. وتطبيق WACC واحد في كل مكان يحابي منهجياً الأقسامَ الخطرة ويحرم الآمنة، وهو انحياز موثق في أدلة المسوح عن ممارسات الموازنة الرأسمالية. والعلاج معدلات على مستوى القسم أو المشروع تُبنى من بيتات نظائر الصناعة المعنية. وثمة انضباط ثانٍ: يجب أن تكون الأوزان قيماً سوقية لا دفترية، والهيكل المستهدف أهم من لقطة اليوم عندما تعيد الشركة هيكلة رافعتها عمداً. وأخيراً، WACC يتحرك: فدورات الفائدة ومخاطر البلد وتغيرات الهيكل كلها تحركه، ومعدل عتبة ثُبِّت قبل سنوات خطأ قرارات ينتظر وقوعه.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Using book-value weights. The claims investors hold are priced in markets; the weights must be too.', 'استخدام أوزان دفترية. مطالبات المستثمرين تُسعَّر في الأسواق؛ فكذلك يجب أن تكون الأوزان.'),
    Bi('Using the coupon on existing debt as the cost of debt instead of today\'s refinancing rate.', 'اعتماد كوبون الدين القائم تكلفةً للدين بدل معدل إعادة التمويل اليوم.'),
    Bi('Discounting a high-risk new venture at the corporate WACC: risk-matching is the whole point of the exercise.', 'خصم مشروع جديد عالي المخاطر بمتوسط الشركة: مطابقة المخاطر هي جوهر التمرين كله.'),
    Bi('Double-counting the tax shield by using after-tax cash flows AND an after-tax rate inconsistently; pick a consistent framework.', 'ازدواج احتساب الوفر الضريبي باستخدام تدفقات بعد الضريبة ومعدل بعد الضريبة على نحو غير متسق؛ اختر إطاراً متسقاً.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IAS 36 §55–57, A15–A21',
      note: Bi('Impairment testing explicitly contemplates WACC as a starting point for the value-in-use discount rate.', 'اختبار الهبوط ينص صراحة على WACC نقطةَ بداية لمعدل خصم القيمة قيد الاستخدام.'),
      segments: [
        KBStandardSegment('IAS 36', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-36-impairment-of-assets/'),
        KBStandardSegment(' §55–57, A15–A21'),
      ],
    ),
    KBStandardRef(
      standard: 'IFRS 13 §B12–B30',
      note: Bi('Present-value techniques and the components of a discount rate in fair value measurement.', 'أساليب القيمة الحالية ومكونات معدل الخصم في قياس القيمة العادلة.'),
      segments: [
        KBStandardSegment('IFRS 13', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ifrs-13-fair-value-measurement/'),
        KBStandardSegment(' §B12–B30'),
      ],
    ),
  ],
  relatedTerms: [
    'WACC (Weighted Average Cost of Capital)',
    'Cost of Equity',
    'Cost of Debt',
  ],
  relatedModules: [
    KBRelatedModule('/education/fundamentals', Bi('Module: Financial Management Primer (Financing pillar, WACC slide)', 'الوحدة: تمهيد الإدارة المالية (ركيزة التمويل، شريحة WACC)')),
    KBRelatedModule('/education/capital-budgeting', Bi('Tool: Capital Budgeting', 'الأداة: الموازنة الرأسمالية')),
  ],
  relatedArticles: [
    'npv-irr',
    'balance-sheet',
    'time-value-of-money',
    'capital-structure',
    'impairment-testing',
    'valuation-multiples',
    'dcf-valuation',
    'dividend-policy',
    'mergers-acquisitions',
  ],
  references: [
    'Brealey, R. A., Myers, S. C., & Allen, F. (2020). Principles of corporate finance (13th ed.). McGraw-Hill.',
    'Sharpe, W. F. (1964). Capital asset prices: A theory of market equilibrium under conditions of risk. The Journal of Finance, 19(3), 425-442.',
    'Graham, J. R., & Harvey, C. R. (2001). The theory and practice of corporate finance: Evidence from the field. Journal of Financial Economics, 60(2-3), 187-243.',
    'Koller, T., Goedhart, M., & Wessels, D. (2020). Valuation: Measuring and managing the value of companies (7th ed.). Wiley.',
  ],
  keywords: [
    'WACC',
    'cost of capital',
    'CAPM',
    'beta',
    'hurdle rate',
    'capital structure',
    'تكلفة رأس المال',
    'بيتا',
    'هيكل رأس المال',
  ],
);
