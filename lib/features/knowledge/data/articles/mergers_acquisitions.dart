// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/mergers-acquisitions.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbMergersAcquisitions = KBArticle(
  id: 'mergers-acquisitions',
  title: Bi('Mergers and Acquisitions: Accretion Is Not Value', 'الاندماج والاستحواذ: الزيادة ليست قيمة'),
  category: 'corporate-finance',
  level: KBLevel.advanced,
  readingMinutes: 10,
  summary: Bi('How a deal is evaluated, why earnings per share rises almost mechanically in a cash deal, the separate test of whether value was created, and a worked example where both answers point in opposite directions.', 'كيف تُقيَّم الصفقة، ولماذا يرتفع ربح السهم شبه آلياً في صفقة نقدية، والاختبار المنفصل لما إذا كانت قيمة قد خُلقت، ومثال محلول تتعاكس فيه الإجابتان.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('An acquisition is the purchase of a business, and like any purchase it creates value for the buyer only if what is received is worth more than what is paid. That sentence is trivially true and routinely ignored, because acquisitions are usually judged by a different and much easier test: whether earnings per share goes up. The two tests are not the same, and they are not even correlated in any reliable way. Earnings per share rises whenever the earnings acquired cost less, per riyal of earnings, than the funding used to buy them, which is an arithmetic property of the financing mix and says nothing about whether the price was sensible. A deal can be accretive to earnings and destroy value; it can be dilutive and create value. Keeping the two questions apart is the single most useful discipline in deal analysis, and the reason boards that conflate them tend to overpay.', 'الاستحواذ شراء منشأة، وهو كأي شراء لا يخلق قيمة للمشتري إلا إذا كان ما يُستلم أثمن مما يُدفع. وتلك جملة صحيحة بداهةً ومُهمَلة روتيناً، لأن الاستحواذات تُحكَم عادةً باختبار آخر أسهل بكثير: هل ارتفع ربح السهم. والاختباران ليسا واحداً، بل ليسا مترابطين على أي نحو يُعتمد عليه. فربح السهم يرتفع كلما كانت الأرباح المقتناة أرخص، لكل ريال من الأرباح، من التمويل المستخدم لشرائها، وتلك خاصية حسابية لمزيج التمويل لا تقول شيئاً عن معقولية السعر. فقد تكون الصفقة زائدة للأرباح ومدمرة للقيمة؛ وقد تكون مخفِّضة للأرباح وخالقة للقيمة. وفصل السؤالين أنفع انضباط في تحليل الصفقات، وسبب ميل المجالس التي تخلطهما إلى المغالاة في الدفع.'),
      ],
    ),
    KBSection(
      heading: Bi('The formal treatment: two tests, two formulas', 'المعالجة النظرية: اختباران ومعادلتان'),
      paragraphs: [
        Bi('The earnings test is mechanical. Combine the acquirer\'s net income with the target\'s, subtract the after-tax cost of whatever funded the purchase, and divide by the resulting share count. In an all-cash deal funded with debt, the cost is the after-tax interest and the share count is unchanged. In an all-share deal there is no interest but the share count rises by the value of the consideration divided by the acquirer\'s share price. The shortcut is worth memorising: a cash deal is accretive when the target\'s earnings yield, its net income divided by the price paid, exceeds the after-tax cost of the debt; a share deal is accretive when the acquirer\'s price-earnings multiple is higher than the multiple it pays. Neither condition mentions value. The value test is separate and asks whether the price paid is below the target\'s standalone value plus the present value of synergies net of the cost of achieving them. Everything difficult lives in that second term: revenue synergies are the least reliable, cost synergies the most, and integration costs are real, immediate and usually underestimated. The accounting then follows under IFRS 3, which requires the acquisition method: identify the acquirer, measure the consideration at fair value, recognise the identifiable assets and liabilities acquired at fair value including intangibles the target never recognised itself, and record the residual as goodwill. That goodwill is not amortised but tested for impairment annually, which is how an overpayment eventually appears in the accounts, usually several years after the decision that caused it.', 'اختبار الأرباح آلي. اجمع صافي دخل المستحوِذ إلى صافي دخل المستهدَف، واطرح الكلفة بعد الضريبة لما موّل الشراء، واقسم على عدد الأسهم الناتج. ففي صفقة نقدية ممولة بالدين تكون الكلفة هي الفائدة بعد الضريبة ويبقى عدد الأسهم كما هو. وفي صفقة أسهم لا فائدة لكن عدد الأسهم يرتفع بقيمة العوض مقسومةً على سعر سهم المستحوِذ. والاختصار جدير بالحفظ: تكون الصفقة النقدية زائدة حين يفوق عائد أرباح المستهدَف، أي صافي دخله مقسوماً على الثمن المدفوع، كلفةَ الدين بعد الضريبة؛ وتكون صفقة الأسهم زائدة حين يكون مضاعف ربحية المستحوِذ أعلى من المضاعف الذي يدفعه. ولا يذكر أي من الشرطين قيمة. أما اختبار القيمة فمنفصل ويسأل هل الثمن المدفوع دون قيمة المستهدَف المستقلة زائداً القيمة الحالية للتآزرات صافيةً من كلفة تحقيقها. وكل الصعب يسكن في ذلك الحد الثاني: فتآزرات الإيراد أقلها موثوقية، وتآزرات الكلفة أعلاها، وتكاليف الدمج حقيقية وفورية ومُقدَّرة بأقل من حقها عادةً. ثم تتبع المحاسبة بموجب IFRS 3 الذي يوجب طريقة الاستحواذ: تحديد المستحوِذ، وقياس العوض بالقيمة العادلة، وإثبات الأصول والالتزامات المقتناة القابلة للتحديد بالقيمة العادلة بما فيها أصول غير ملموسة لم يثبتها المستهدَف قط، وتسجيل المتبقي شهرةً. وتلك الشهرة لا تُطفأ بل تُختبر للهبوط سنوياً، وهكذا تظهر المغالاة في الدفع في الحسابات آخر الأمر، وغالباً بعد سنوات من القرار الذي سببها.'),
      ],
      formulas: [
        KBFormula('Combined EPS = (Acquirer net income + Target net income − After-tax funding cost) ÷ Combined shares', caption: Bi('Accretive if this exceeds the acquirer standalone EPS. A financing outcome, not a value outcome.', 'زائدة إن فاق هذا ربح سهم المستحوِذ المستقل. وهي نتيجة تمويل لا نتيجة قيمة.')),
        KBFormula('Value created = Target standalone value + PV of net synergies − Price paid', caption: Bi('The only test that answers whether the acquirer is better off.', 'الاختبار الوحيد الذي يجيب هل صار المستحوِذ أفضل حالاً.')),
      ],
    ),
    KBSection(
      heading: Bi('Worked example: accretive and value destroying at once', 'مثال محلول: زائدة ومدمرة للقيمة معاً'),
      paragraphs: [
        Bi('An acquirer earns net income of SAR 400m on 500m shares, so earnings per share is SAR 0.80, and its shares trade at SAR 16, a multiple of 20 times. It buys a target earning SAR 90m for SAR 1,200m in cash, funded entirely with debt at 6%, with tax at 20%. The after-tax interest cost is 1,200 × 6% × (1 − 0.20) = SAR 57.6m. Combined net income is 400 + 90 − 57.6 = SAR 432.4m over an unchanged 500m shares, giving earnings per share of SAR 0.8648, an increase of 8.1%. The deal is comfortably accretive, and the reason is visible in the shortcut: the target\'s earnings yield is 90 ÷ 1,200 = 7.5%, well above the after-tax cost of debt of 4.8%. Now apply the second test. Suppose the target is worth SAR 1,000m on a standalone basis and the acquirer can realistically extract synergies with a present value of SAR 150m net of integration costs. The maximum justifiable price is SAR 1,150m, and the acquirer paid SAR 1,200m. It has transferred SAR 50m of value to the target\'s shareholders while reporting a rise in earnings per share, and the arithmetic that makes the deal look good is the same arithmetic that would make almost any debt-funded purchase of a lower-multiple business look good. The SAR 50m does not disappear. It sits in goodwill until an impairment test finds it, which is why an acquisitive company\'s goodwill balance deserves reading as a record of prices paid rather than assets held.', 'يكسب مستحوِذ صافي دخل بـ400 مليون ريال على 500 مليون سهم، فيكون ربح السهم 0.80 ريال، ويُتداول سهمه بـ16 ريالاً، أي مضاعف عشرين. ويشتري مستهدَفاً يكسب 90 مليوناً بـ1,200 مليون ريال نقداً، ممولةً بالدين كلها بمعدل 6%، والضريبة 20%. فتكون كلفة الفائدة بعد الضريبة 1,200 × 6% × (1 − 0.20) = 57.6 مليون ريال. وصافي الدخل المجمع 400 + 90 − 57.6 = 432.4 مليون ريال على 500 مليون سهم لم تتغير، فيكون ربح السهم 0.8648 ريال، بزيادة 8.1%. فالصفقة زائدة براحة، والسبب ظاهر في الاختصار: عائد أرباح المستهدَف 90 ÷ 1,200 = 7.5%، وهو فوق كلفة الدين بعد الضريبة البالغة 4.8% بمسافة واسعة. وطبّق الآن الاختبار الثاني. لنفترض أن المستهدَف يساوي 1,000 مليون ريال على أساس مستقل، وأن المستحوِذ يستطيع واقعياً انتزاع تآزرات قيمتها الحالية 150 مليوناً صافيةً من تكاليف الدمج. فيكون أقصى ثمن مبرَّر 1,150 مليوناً، وقد دفع المستحوِذ 1,200 مليون. فهو قد حوّل 50 مليون ريال من القيمة إلى مساهمي المستهدَف بينما يعرض ارتفاعاً في ربح السهم، والحساب الذي يُحسّن مظهر الصفقة هو نفسه الحساب الذي سيُحسّن مظهر أي شراء ممول بالدين لمنشأة أدنى مضاعفاً تقريباً. والخمسون مليوناً لا تختفي. بل تجلس في الشهرة حتى يجدها اختبار هبوط، ولهذا يستحق رصيد الشهرة في شركة مستحوِذة أن يُقرأ سجلَّ أثمانٍ دُفعت لا أصولٍ مملوكة.'),
      ],
    ),
    KBSection(
      heading: Bi('What separates the deals that work', 'ما يفصل الصفقات الناجحة'),
      paragraphs: [
        Bi('The empirical record on acquisitions is consistent and uncomfortable: on average acquirers do not earn back the premium, and the variance is driven less by strategy than by discipline about price. Four questions predict most of the difference. What exactly is the synergy, quantified as a line item with an owner and a date, rather than a percentage of combined costs. Who captures it, since a competitive auction transfers expected synergies to the seller in the premium before the buyer has earned any of them. What is the integration cost and how long does it run, because a two-year cost against a perpetual benefit is a different proposition from a five-year one. And what happens if the synergies arrive at half the assumed level, which is the sensitivity that should be run before the offer rather than after. For a Gulf audience two further features matter: many targets are family-held, so the standalone accounts may include owner remuneration and related party arrangements that normalise significantly on a change of control, and government-linked buyers are frequently pursuing a mandate alongside a return, in which case the value test still applies but the objective function against which it is measured needs stating explicitly rather than assumed away.', 'السجل التجريبي للاستحواذات متسق ومزعج: فالمستحوِذون في المتوسط لا يستردون العلاوة، والتباين تحركه الانضباطية في السعر أكثر مما تحركه الاستراتيجية. وأربعة أسئلة تتنبأ بمعظم الفرق. ما التآزر بالضبط، مكمَّماً بنداً له مالك وتاريخ، لا نسبةً مئوية من التكاليف المجمعة. ومن يلتقطه، إذ ينقل مزاد تنافسي التآزرات المتوقعة إلى البائع في العلاوة قبل أن يكسب المشتري منها شيئاً. وكم كلفة الدمج وكم تمتد، فكلفة سنتين مقابل منفعة دائمة طرحٌ مختلف عن كلفة خمس. وماذا يحدث إن جاءت التآزرات بنصف المستوى المفترض، وهي الحساسية التي ينبغي إجراؤها قبل العرض لا بعده. ولجمهور خليجي تهم سمتان إضافيتان: فكثير من المستهدَفين شركات عائلية، فقد تتضمن حساباتها المستقلة مكافآت مُلّاك وترتيبات أطراف ذات علاقة تتطبّع جوهرياً عند تغير السيطرة، والمشترون المرتبطون بالحكومة كثيراً ما يلاحقون تفويضاً إلى جانب العائد، وعندها يبقى اختبار القيمة سارياً لكن دالة الهدف التي يُقاس عليها تحتاج تصريحاً لا افتراضاً ضمنياً.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Presenting accretion as evidence of a good deal. Accretion follows arithmetically whenever the earnings yield of the target exceeds the after-tax cost of the funding, which a price well above fair value can still satisfy.', 'تقديم زيادة ربح السهم دليلاً على صفقة جيدة. فالزيادة تتبع حسابياً كلما تجاوز عائد أرباح المستهدَف كلفة التمويل بعد الضريبة، وقد يتحقق ذلك عند ثمن يفوق القيمة العادلة بكثير.'),
    Bi('Valuing the target at its standalone value plus all synergies. Synergies paid for in the premium belong to the seller; only the share retained creates value for the buyer.', 'تقييم المستهدَف بقيمته المستقلة زائداً التآزرات كلها. فالتآزرات المدفوع ثمنها في العلاوة تخص البائع؛ ولا يخلق القيمة للمشتري إلا الحصة المحتفظ بها.'),
    Bi('Treating goodwill as an asset that will be recovered. It is the residual of a price, and under IFRS 3 it is never amortised, so an overpayment surfaces only through impairment.', 'معاملة الشهرة أصلاً سيُسترد. فهي متبقي ثمن، ولا تُطفأ أبداً بموجب IFRS 3، فلا تظهر المغالاة في الدفع إلا عبر الهبوط.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IFRS 3',
      note: Bi('Business combinations: the acquisition method, fair value of consideration, recognition of acquired intangibles, and goodwill as the residual.', 'تجميع الأعمال: طريقة الاستحواذ، والقيمة العادلة للعوض، وإثبات الأصول غير الملموسة المقتناة، والشهرة بوصفها المتبقي.'),
      segments: [
        KBStandardSegment('IFRS 3', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ifrs-3-business-combinations/'),
      ],
    ),
    KBStandardRef(
      standard: 'IFRS 10',
      note: Bi('Consolidated financial statements: the control assessment that determines when the target is consolidated at all.', 'القوائم المالية الموحدة: تقييم السيطرة الذي يحدد متى يُوحَّد المستهدَف أصلاً.'),
      segments: [
        KBStandardSegment('IFRS 10', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ifrs-10-consolidated-financial-statements/'),
      ],
    ),
    KBStandardRef(
      standard: 'IAS 33',
      note: Bi('Earnings per share: the measure on which accretion is judged, including the dilution created by shares issued as consideration.', 'ربحية السهم: المقياس الذي يُحكم عليه بالزيادة، بما فيه التخفيض الناشئ عن أسهم تُصدر عوضاً.'),
      segments: [
        KBStandardSegment('IAS 33', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-33-earnings-per-share/'),
      ],
    ),
  ],
  relatedTerms: [
    'Goodwill',
    'Earnings Per Share (EPS)',
    'Enterprise Value (EV)',
    'Acquisitions & Disposals',
    'Price-to-Earnings Ratio (P/E)',
    'Subsidiary',
  ],
  relatedModules: [
    KBRelatedModule('/education/capital-budgeting', Bi('Module: Capital Budgeting', 'الوحدة: الموازنة الرأسمالية')),
    KBRelatedModule('/education/financial-analysis', Bi('Module: Analysis of Financial Statements', 'الوحدة: تحليل القوائم المالية')),
  ],
  relatedArticles: [
    'consolidation-goodwill',
    'dcf-valuation',
    'valuation-multiples',
    'wacc',
    'impairment-testing',
    'capital-structure',
  ],
  references: [
    'IFRS Foundation. (2008). IFRS 3 Business Combinations. IFRS Foundation.',
    'Damodaran, A. (2012). Investment valuation: Tools and techniques for determining the value of any asset (3rd ed.). Wiley.',
    'Brealey, R. A., Myers, S. C., & Allen, F. (2020). Principles of corporate finance (13th ed.). McGraw-Hill.',
  ],
  keywords: [
    'mergers and acquisitions',
    'accretion dilution',
    'synergies',
    'goodwill',
    'IFRS 3',
    'control premium',
    'الاندماج والاستحواذ',
    'زيادة ربح السهم',
    'التآزرات',
    'الشهرة',
  ],
);
