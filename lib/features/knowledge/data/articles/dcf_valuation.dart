// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/dcf-valuation.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbDcfValuation = KBArticle(
  id: 'dcf-valuation',
  title: Bi('Discounted Cash Flow Valuation', 'التقييم بالتدفقات النقدية المخصومة'),
  category: 'corporate-finance',
  level: KBLevel.advanced,
  readingMinutes: 7,
  summary: Bi('The full DCF architecture: free cash flow, the explicit forecast, terminal value, discounting at WACC, the bridge to equity value, and a complete worked valuation with its sensitivities.', 'بنية التدفقات المخصومة كاملة: التدفق النقدي الحر، وفترة التنبؤ الصريحة، والقيمة النهائية، والخصم بتكلفة رأس المال المرجحة، والجسر إلى قيمة حقوق الملكية، وتقييم محلول كامل بحساسياته.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('A business is worth the cash it will hand its capital providers over its life, discounted for time and risk. Discounted cash flow valuation takes that sentence literally: forecast the free cash flows, discount each one at the opportunity cost of capital, and add them up. Where a multiple borrows the market’s assumptions, a DCF forces you to write your own down: how fast revenue grows, what margin survives competition, how much capital the growth consumes, and what return investors require. That explicitness is the method’s value and its danger. The arithmetic is trivial, the output looks precise, and every digit of it is hostage to the assumptions. Professionals therefore treat a DCF less as a number and more as a disciplined argument about where value comes from.', 'العمل يساوي النقد الذي سيسلمه لمقدمي رأس ماله على مدى حياته، مخصوماً للزمن والمخاطر. والتقييم بالتدفقات المخصومة يأخذ تلك الجملة حرفياً: تنبأ بالتدفقات النقدية الحرة، واخصم كلاً منها بتكلفة الفرصة لرأس المال، ثم اجمعها. وحيث يستعير المضاعف افتراضات السوق، تجبرك التدفقات المخصومة على كتابة افتراضاتك أنت: كم ينمو الإيراد، وأي هامش يصمد أمام المنافسة، وكم من رأس المال يستهلكه النمو، وأي عائد يطلبه المستثمرون. وهذا التصريح قيمةُ الطريقة وخطرها معاً. فالحساب تافه، والناتج يبدو دقيقاً، وكل خانة منه رهينة الافتراضات. لذا يعامل المهنيون التدفقات المخصومة حجةً منضبطة عن منبع القيمة أكثر مما يعاملونها رقماً.'),
      ],
    ),
    KBSection(
      heading: Bi('The formal treatment: free cash flow, horizon and terminal value', 'المعالجة النظرية: التدفق الحر والأفق والقيمة النهائية'),
      paragraphs: [
        Bi('The standard enterprise DCF discounts free cash flow to the firm: operating profit after tax, plus depreciation and other non-cash charges, minus capital expenditure, minus the increase in working capital. This is cash available to all capital providers, so the discount rate is the weighted average cost of capital. The forecast splits into two parts. An explicit period, typically five to ten years, carries the years you can defend line by line. Everything beyond collapses into a terminal value, most often the Gordon growth formula applied to the first post-horizon cash flow, with a growth rate no higher than the long-run growth of the economy the firm operates in. Discounting the explicit flows and the terminal value gives enterprise value; subtracting net debt (and any non-controlling interest and preferred claims) gives equity value. The terminal value routinely carries 60% to 80% of the total, which is the method’s standing warning: most of a DCF is an assumption about the distant future dressed as a formula.', 'التدفقات المخصومة المعيارية للمنشأة تخصم التدفق النقدي الحر للشركة: الربح التشغيلي بعد الضريبة، زائد الاستهلاك وسائر الأعباء غير النقدية، ناقص الإنفاق الرأسمالي، ناقص الزيادة في رأس المال العامل. وهذا نقد متاح لكل مقدمي رأس المال، فمعدل الخصم هو المتوسط المرجح لتكلفة رأس المال. وينقسم التنبؤ شطرين. فترة صريحة، عادة من خمس إلى عشر سنوات، تحمل السنوات التي تستطيع الدفاع عنها بنداً بنداً. وما بعدها ينطوي في قيمة نهائية، غالباً بصيغة نمو جوردون مطبقة على أول تدفق بعد الأفق، بمعدل نمو لا يتجاوز نمو الاقتصاد الذي تعمل فيه الشركة في الأجل الطويل. وخصمُ التدفقات الصريحة والقيمة النهائية يعطي قيمة المنشأة؛ وطرح صافي الدين (وأي حصة غير مسيطرة ومطالبات ممتازة) يعطي قيمة حقوق الملكية. وتحمل القيمة النهائية عادة 60% إلى 80% من الإجمالي، وذلك تحذير الطريقة الدائم: معظم التقييم المخصوم افتراضٌ عن مستقبل بعيد يرتدي ثوب معادلة.'),
      ],
      formulas: [
        KBFormula('FCF = EBIT × (1 − tax) + D&A − CapEx − ΔWorking capital', caption: Bi('Free cash flow to the firm: cash generated for all capital providers.', 'التدفق النقدي الحر للشركة: النقد المولد لكل مقدمي رأس المال.')),
        KBFormula('EV = Σ FCFₜ ÷ (1 + WACC)ᵗ + TV ÷ (1 + WACC)ⁿ,   TV = FCFₙ₊₁ ÷ (WACC − g)', caption: Bi('Enterprise value: explicit-period flows plus the Gordon-growth terminal value, all discounted at WACC.', 'قيمة المنشأة: تدفقات الفترة الصريحة زائد القيمة النهائية بنمو جوردون، مخصومة جميعاً بتكلفة رأس المال المرجحة.')),
      ],
    ),
    KBSection(
      heading: Bi('Worked example: a five-year DCF', 'مثال محلول: تدفقات مخصومة لخمس سنوات'),
      paragraphs: [
        Bi('A company generated free cash flow of SAR 10m last year. You forecast 8% growth for five years, then 3% forever, with a WACC of 10%. The explicit flows are 10.8, 11.7, 12.6, 13.6 and 14.7, and their present values are 9.8, 9.6, 9.5, 9.3 and 9.1, totalling SAR 47.3m. The terminal value at the end of year five is 14.7 × 1.03 ÷ (0.10 − 0.03) = SAR 216.2m, worth 216.2 ÷ 1.10⁵ = SAR 134.2m today. Enterprise value = 47.3 + 134.2 = SAR 181.5m; with net debt of SAR 20m, equity is worth about SAR 161.5m. Note the anatomy: the terminal value is 74% of enterprise value. Move terminal growth from 3% to 2% and equity drops to roughly SAR 144m; move WACC from 10% to 9% and it jumps to about SAR 193m. A percentage point in either assumption moves the answer by more than a whole year of cash flow, which is why a serious DCF always ships with its sensitivity table.', 'ولّدت شركة تدفقاً نقدياً حراً قدره 10 ملايين ريال العام الماضي. تتنبأ بنمو 8% لخمس سنوات ثم 3% للأبد، بتكلفة رأس مال مرجحة 10%. التدفقات الصريحة هي 10.8 و11.7 و12.6 و13.6 و14.7، وقيمها الحالية 9.8 و9.6 و9.5 و9.3 و9.1، بمجموع 47.3 مليوناً. والقيمة النهائية في نهاية السنة الخامسة = 14.7 × 1.03 ÷ (0.10 − 0.03) = 216.2 مليوناً، وتساوي اليوم 216.2 ÷ 1.10⁵ = 134.2 مليوناً. قيمة المنشأة = 47.3 + 134.2 = 181.5 مليون ريال؛ وبصافي دين 20 مليوناً تساوي حقوق الملكية نحو 161.5 مليوناً. ولاحظ التشريح: القيمة النهائية 74% من قيمة المنشأة. حرّك النمو النهائي من 3% إلى 2% فتهبط حقوق الملكية إلى نحو 144 مليوناً؛ وحرّك تكلفة رأس المال من 10% إلى 9% فتقفز إلى نحو 193 مليوناً. نقطة مئوية واحدة في أي من الافتراضين تحرك الجواب أكثر من سنة كاملة من التدفق، ولهذا يُسلَّم أي تقييم مخصوم جاد ومعه جدول حساسياته.'),
      ],
    ),
    KBSection(
      heading: Bi('DCF and multiples: rivals or witnesses', 'التدفقات المخصومة والمضاعفات: خصمان أم شاهدان'),
      paragraphs: [
        Bi('In practice the two methods cross-examine each other. A DCF that implies the company is worth 15× EBITDA when every peer trades at 8× is not automatically wrong, but it owes you an explanation of what the market is missing. A comparables valuation that cannot survive translation into DCF assumptions (what growth and margin would justify that multiple?) is borrowing someone else’s error. The professional habit is triangulation: run the DCF for the logic, run the multiples for the market anchor, and investigate the gap between them, because the gap is where either your model or the market is wrong, and both possibilities are worth money. This is also the machinery regulators and auditors see in impairment tests, purchase price allocations and fairness opinions; valuation is one discipline wearing several uniforms.', 'عملياً تستجوب الطريقتان إحداهما الأخرى. فتقييم مخصوم يقتضي أن الشركة تساوي 15 ضعف EBITDA بينما يتداول كل نظير عند 8 أضعاف ليس خاطئاً تلقائياً، لكنه يدين لك بتفسير ما الذي يفوت السوق. وتقييم مقارن لا ينجو من الترجمة إلى افتراضات تدفقات مخصومة (أي نمو وهامش يبرران ذلك المضاعف؟) يستعير خطأ شخص آخر. وعادة المهنيين التثليث: شغّل التدفقات المخصومة للمنطق، وشغّل المضاعفات لمرساة السوق، وحقق في الفجوة بينهما، لأن الفجوة هي حيث يكون نموذجك أو السوق مخطئاً، وكلا الاحتمالين يساوي مالاً. وهذه أيضاً الآلية التي يراها المنظمون والمدققون في اختبارات الهبوط وتوزيعات ثمن الشراء وآراء العدالة؛ فالتقييم تخصص واحد يرتدي أزياء عدة.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Terminal growth above the economy’s long-run rate: a company growing faster than GDP forever eventually becomes the economy, and the formula quietly assumes it.', 'نمو نهائي فوق معدل الاقتصاد في الأجل الطويل: شركة تنمو أسرع من الناتج المحلي للأبد تصير الاقتصادَ نفسه في النهاية، والمعادلة تفترض ذلك بصمت.'),
    Bi('Growth without capital: raising the revenue forecast while holding capital expenditure and working capital flat manufactures value from an inconsistency, not from the business.', 'نمو بلا رأس مال: رفع تنبؤ الإيراد مع تثبيت الإنفاق الرأسمالي ورأس المال العامل يصنع قيمة من تناقض لا من العمل.'),
    Bi('Double counting or dropping claims at the bridge: cash already netted in net debt, unconsolidated associates, and non-controlling interest each belong on exactly one side of the enterprise-to-equity walk.', 'عد المطالبات مرتين أو إسقاطها عند الجسر: النقد المصفى فعلاً في صافي الدين، والزميلات غير الموحدة، والحصة غير المسيطرة، لكل منها جانب واحد بالضبط في العبور من المنشأة إلى حقوق الملكية.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IFRS 13',
      note: Bi('Fair value measurement: the income approach (present value techniques) and the Level 3 disclosure regime for model-based valuations.', 'قياس القيمة العادلة: نهج الدخل (أساليب القيمة الحالية) ونظام إفصاح المستوى الثالث للتقييمات النموذجية.'),
      segments: [
        KBStandardSegment('IFRS 13', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ifrs-13-fair-value-measurement/'),
      ],
    ),
    KBStandardRef(
      standard: 'IAS 36',
      note: Bi('Value in use is a constrained DCF: the same machinery with standard-setter limits on horizon, growth and restructurings.', 'القيمة من الاستخدام تدفقات مخصومة مقيدة: الآلية نفسها بحدود واضعي المعايير على الأفق والنمو وإعادات الهيكلة.'),
      segments: [
        KBStandardSegment('IAS 36', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-36-impairment-of-assets/'),
      ],
    ),
  ],
  relatedTerms: [
    'Free Cash Flow',
    'WACC (Weighted Average Cost of Capital)',
    'Enterprise Value (EV)',
    'Capital Expenditure (CapEx)',
    'Operating Cash Flow',
    'Fair Value',
  ],
  relatedModules: [
    KBRelatedModule('/education/capital-budgeting', Bi('Module: Capital Budgeting (NPV machinery)', 'الوحدة: الموازنة الرأسمالية (آلية القيمة الحالية)')),
    KBRelatedModule('/education/financial-analysis', Bi('Module: Analysis of Financial Statements', 'الوحدة: تحليل القوائم المالية')),
  ],
  relatedArticles: [
    'time-value-of-money',
    'npv-irr',
    'wacc',
    'valuation-multiples',
    'cash-flow-forecasting',
    'mergers-acquisitions',
  ],
  references: [
    'Koller, T., Goedhart, M., & Wessels, D. (2020). Valuation: Measuring and managing the value of companies (7th ed.). Wiley.',
    'Damodaran, A. (2012). Investment valuation: Tools and techniques for determining the value of any asset (3rd ed.). Wiley.',
    'Brealey, R. A., Myers, S. C., & Allen, F. (2020). Principles of corporate finance (13th ed.). McGraw-Hill.',
  ],
  keywords: [
    'DCF',
    'discounted cash flow',
    'free cash flow',
    'terminal value',
    'Gordon growth',
    'enterprise value',
    'valuation',
    'sensitivity analysis',
    'التدفقات النقدية المخصومة',
    'التدفق النقدي الحر',
    'القيمة النهائية',
    'التقييم',
  ],
);
