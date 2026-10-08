// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/capital-structure.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbCapitalStructure = KBArticle(
  id: 'capital-structure',
  title: Bi('Capital Structure: Debt versus Equity', 'هيكل رأس المال: الدين مقابل حقوق الملكية'),
  category: 'corporate-finance',
  level: KBLevel.advanced,
  readingMinutes: 6,
  summary: Bi('What debt and equity each cost the firm and its owners, why leverage magnifies returns in both directions, the Modigliani-Miller starting point, and the trade-off that sets real-world debt levels.', 'ماذا يكلف الدين وحقوق الملكية الشركةَ وملاكها، ولماذا تضخم الرافعة العوائد في الاتجاهين، ونقطة انطلاق موديلياني وميلر، والمفاضلة التي تحدد مستويات الدين في الواقع.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('Capital structure is the mix of debt and equity that finances a company\'s assets. The two claims differ in every dimension that matters. Debt is a contract: fixed payments, a maturity date, priority in liquidation, and no vote; miss the payments and creditors can force insolvency. Equity is a residual: no promised payment, no maturity, last claim in liquidation, and control through votes; its return is whatever remains after everyone else is paid. Debt is cheaper precisely because it is safer for the provider, and its interest is typically tax-deductible while dividends are not.', 'هيكل رأس المال هو مزيج الدين وحقوق الملكية الذي يمول أصول الشركة. والمطالبتان تختلفان في كل بعد مهم. الدين عقد: مدفوعات ثابتة، وتاريخ استحقاق، وأولوية عند التصفية، وبلا صوت؛ وإن فاتت المدفوعات استطاع الدائنون فرض الإعسار. وحقوق الملكية متبقية: لا دفعة موعودة، ولا استحقاق، وآخر مطالبة عند التصفية، وسيطرة عبر الأصوات؛ وعائدها ما يبقى بعد سداد الجميع. الدين أرخص تحديداً لأنه أكثر أماناً لمقدمه، وفائدته قابلة عادة للخصم الضريبي بينما التوزيعات ليست كذلك.'),
        Bi('Why not finance everything with the cheaper source, then? Because leverage cuts both ways: fixed debt service magnifies the owners\' return when the business earns more than the interest rate, and magnifies their loss when it earns less. The financing decision is therefore a risk decision wearing a cost disguise.', 'فلماذا لا نمول كل شيء بالمصدر الأرخص إذن؟ لأن الرافعة تقطع في الاتجاهين: خدمة الدين الثابتة تضخم عائد الملاك عندما تكسب الأعمال أكثر من سعر الفائدة، وتضخم خسارتهم عندما تكسب أقل. فقرار التمويل قرارُ مخاطر يرتدي زي التكلفة.'),
      ],
    ),
    KBSection(
      heading: Bi('Worked example: leverage in both directions', 'مثال محلول: الرافعة في الاتجاهين'),
      paragraphs: [
        Bi('Two companies hold identical assets of SAR 10m and face two scenarios: operating profit of SAR 1.5m (good year) or SAR 0.4m (bad year). Company U is all equity. Company L finances half with debt at 6% (interest SAR 300,000). Ignore tax for clarity. Good year: U returns 1.5 ÷ 10 = 15% on equity; L returns (1.5 − 0.3) ÷ 5 = 24%. Bad year: U returns 4%; L returns (0.4 − 0.3) ÷ 5 = 2%. Same assets, same operations; leverage turned a 15%/4% spread into 24%/2%. Push the bad year to SAR 0.2m and L\'s equity return goes negative while U still earns 2%. That widening of outcomes is the entire essence of financial leverage.', 'شركتان تملكان أصولاً متطابقة بعشرة ملايين ريال وتواجهان سيناريوهين: ربح تشغيلي 1.5 مليون (سنة جيدة) أو 0.4 مليون (سنة سيئة). الشركة غ بلا دين. والشركة ر تمول النصف بدين بمعدل 6% (فائدة 300,000). ولنغفل الضريبة للوضوح. السنة الجيدة: غ تعيد 1.5 ÷ 10 = 15% على حقوق الملكية؛ ور تعيد (1.5 − 0.3) ÷ 5 = 24%. السنة السيئة: غ تعيد 4%؛ ور تعيد (0.4 − 0.3) ÷ 5 = 2%. الأصول نفسها والتشغيل نفسه؛ حولت الرافعة مدى 15%/4% إلى 24%/2%. وادفع السنة السيئة إلى 0.2 مليون يصبح عائد ملكية ر سالباً بينما لا تزال غ تكسب 2%. هذا الاتساع في النواتج هو جوهر الرافعة المالية كله.'),
      ],
    ),
    KBSection(
      heading: Bi('The theory: MM and the trade-off', 'النظرية: موديلياني وميلر والمفاضلة'),
      paragraphs: [
        Bi('Modigliani and Miller (1958) proved the discipline\'s starting point: in a frictionless world (no taxes, no bankruptcy costs, no information problems), capital structure is irrelevant; the value of the firm depends on its assets, not on how their financing is sliced. The result is powerful not as a description but as a map: if financing choices matter in reality, they matter exactly through the frictions the proof assumed away. Taxes: interest deductibility makes debt create a tax shield, pushing firms toward leverage. Financial distress: as debt rises, so does the probability of costly distress (lost customers, fire sales, legal costs), pushing back. The trade-off theory sets the optimal structure where the marginal tax benefit equals the marginal expected distress cost, which is why stable, asset-heavy businesses (utilities, real estate) carry much more debt than volatile, intangible-heavy ones (software, pharma). Pecking-order behavior adds a second observed pattern: managers prefer internal funds, then debt, then outside equity last, because raising equity signals the shares may be overvalued.', 'أثبت موديلياني وميلر (1958) نقطة انطلاق هذا الفرع كله: في عالم بلا احتكاكات (لا ضرائب ولا تكاليف إفلاس ولا مشكلات معلومات) هيكل رأس المال غير ذي صلة؛ فقيمة الشركة من أصولها لا من طريقة تقطيع تمويلها. وقوة النتيجة ليست وصفاً بل خريطة: إذا كانت خيارات التمويل مهمة في الواقع فهي مهمة بالضبط عبر الاحتكاكات التي أسقطها البرهان. الضرائب: خصم الفائدة يجعل الدين ينشئ وفراً ضريبياً يدفع نحو الرافعة. والعسر المالي: مع ارتفاع الدين يرتفع احتمال عسر مكلف (عملاء يفرون، وبيوع اضطرارية، وتكاليف قانونية) فيدفع في الاتجاه المعاكس. وتضع نظرية المفاضلة الهيكل الأمثل حيث تتساوى المنفعة الضريبية الحدية مع تكلفة العسر المتوقعة الحدية، ولهذا تحمل الأعمال المستقرة كثيفة الأصول (المرافق والعقار) ديناً أكبر بكثير من المتقلبة كثيفة غير الملموس (البرمجيات والدواء). ويضيف سلوك الترتيب التفاضلي نمطاً ملحوظاً ثانياً: يفضل المديرون الأموال الداخلية ثم الدين ثم الملكية الخارجية أخيراً، لأن إصدار الأسهم يوحي بأنها قد تكون مقومة بأعلى من قيمتها.'),
      ],
      formulas: [
        KBFormula('Annual tax shield = Interest × Tax rate = r_d × D × T', caption: Bi('The cash the deduction saves each year; its value is why leverage is not neutral once taxes exist.', 'النقد الذي يوفره الخصم كل سنة؛ وقيمته هي سبب ألا تكون الرافعة محايدة متى وُجدت الضرائب.')),
      ],
    ),
    KBSection(
      heading: Bi('Judging a real structure', 'الحكم على هيكل حقيقي'),
      paragraphs: [
        Bi('Practitioners triangulate three measures. Debt-to-equity (or debt-to-total-capital) describes the mix. Interest cover (operating profit over finance costs) measures the earnings cushion; below roughly 2 to 3 times, lenders and rating agencies grow uncomfortable. Debt-to-EBITDA approximates the years of cash generation needed to repay: covenants routinely cap it. Behind all three sits one qualitative question: how stable are the cash flows that must carry the fixed payments? A structure that suits a utility bankrupts a startup. And in the Gulf context, note that the same economics drive sukuk structures: the instrument\'s legal form differs, but the fixed-obligation risk it creates for the issuer must be judged with exactly these tools.', 'يثلث الممارسون ثلاثة مقاييس. الدين إلى حقوق الملكية (أو إلى إجمالي رأس المال) يصف المزيج. وتغطية الفوائد (الربح التشغيلي على تكاليف التمويل) تقيس وسادة الأرباح؛ ودون نحو مرتين إلى ثلاث تقلق الجهات المقرضة ووكالات التصنيف. والدين إلى EBITDA يقارب سنوات توليد النقد اللازمة للسداد: وتقيده التعهدات عادة. وخلف الثلاثة سؤال نوعي واحد: ما مدى استقرار التدفقات التي ستحمل المدفوعات الثابتة؟ فهيكل يناسب شركة مرافق يفلس شركة ناشئة. وفي السياق الخليجي لاحظ أن الاقتصاديات نفسها تحكم هياكل الصكوك: يختلف الشكل القانوني للأداة، لكن مخاطر الالتزام الثابت التي تنشئها على المصدر تُحاكم بهذه الأدوات ذاتها.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Choosing debt because "it is cheaper than equity" without pricing the added distress risk the equity holders absorb: the cheaper instrument makes the expensive one costlier.', 'اختيار الدين لأنه «أرخص من حقوق الملكية» دون تسعير مخاطر العسر الإضافية التي يمتصها الملاك: الأداة الأرخص تجعل الأغلى أكثر كلفة.'),
    Bi('Reading a high ROE without checking how much of it is the equity multiplier at work.', 'قراءة عائد ملكية مرتفع دون فحص كم منه من عمل مضاعف حقوق الملكية.'),
    Bi('Ignoring off-balance-sheet fixed obligations: long leases and take-or-pay contracts are leverage in substance (IFRS 16 now puts most leases on the balance sheet for exactly this reason).', 'تجاهل الالتزامات الثابتة خارج الميزانية: عقود الإيجار الطويلة وعقود الالتزام بالشراء رافعةٌ في الجوهر (ولهذا بالضبط يضع IFRS 16 معظم الإيجارات في الميزانية الآن).'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IAS 32 · IFRS 9',
      note: Bi('The liability/equity boundary and financial-instrument measurement: whether an instrument is debt or equity follows its substance (an obligation to deliver cash), not its name.', 'حد الفصل بين الالتزام وحقوق الملكية وقياس الأدوات المالية: كون الأداة ديناً أو ملكية يتبع جوهرها (التزام بتسليم نقد) لا اسمها.'),
      segments: [
        KBStandardSegment('IAS 32', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-32-financial-instruments-presentation/'),
        KBStandardSegment(' · '),
        KBStandardSegment('IFRS 9', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ifrs-9-financial-instruments/'),
      ],
    ),
    KBStandardRef(
      standard: 'IFRS 16',
      note: Bi('Leases: brings most lease obligations onto the balance sheet, so leverage ratios now capture them.', 'عقود الإيجار: يدخل معظم التزامات الإيجار إلى الميزانية، فتلتقطها نسب الرافعة الآن.'),
      segments: [
        KBStandardSegment('IFRS 16', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ifrs-16-leases/'),
      ],
    ),
  ],
  relatedTerms: [
    'Financial Leverage',
    'Debt-to-Equity Ratio',
    'Interest Coverage Ratio',
  ],
  relatedModules: [
    KBRelatedModule('/education/fundamentals', Bi('Module: Financial Management Primer (Financing pillar)', 'الوحدة: تمهيد الإدارة المالية (ركيزة التمويل)')),
  ],
  relatedArticles: [
    'wacc',
    'balance-sheet',
    'bonds-and-sukuk',
    'leases-ifrs16',
    'dividend-policy',
    'share-based-payment',
    'borrowing-costs',
    'credit-analysis',
    'mergers-acquisitions',
  ],
  references: [
    'Modigliani, F., & Miller, M. H. (1958). The cost of capital, corporation finance and the theory of investment. American Economic Review, 48(3), 261-297.',
    'Myers, S. C. (1984). The capital structure puzzle. The Journal of Finance, 39(3), 574-592.',
    'Brealey, R. A., Myers, S. C., & Allen, F. (2020). Principles of corporate finance (13th ed.). McGraw-Hill.',
  ],
  keywords: [
    'capital structure',
    'debt',
    'equity',
    'leverage',
    'Modigliani Miller',
    'trade-off',
    'tax shield',
    'هيكل رأس المال',
    'رافعة',
    'وفر ضريبي',
    'دين',
  ],
);
