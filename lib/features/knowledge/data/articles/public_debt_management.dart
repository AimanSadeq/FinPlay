// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/public-debt-management.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbPublicDebtManagement = KBArticle(
  id: 'public-debt-management',
  title: Bi('Public Debt Management and Portfolio Risk', 'إدارة الدين العام ومخاطر المحفظة'),
  category: 'public-sector',
  level: KBLevel.intermediate,
  readingMinutes: 10,
  summary: Bi('Why the composition of government debt matters as much as its size, the four portfolio risks a debt office manages, the cost and risk trade-off in a debt strategy, and a worked example measuring each exposure.', 'لماذا يهم تركيب الدين الحكومي بقدر ما يهم حجمه، والمخاطر الأربع التي يديرها مكتب الدين، والمفاضلة بين الكلفة والمخاطرة في استراتيجية الدين، ومثال محلول يقيس كل تعرض.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('Fiscal policy decides how much a government borrows. Debt management decides the shape of what it borrows: the maturities, the currencies, the mix of fixed and floating rates, the investor base. These are different jobs with different objectives, and conflating them is a common error. A debt manager is not asked to reduce the debt; that is a matter for the budget. The debt manager is asked to meet the government\'s financing needs at the lowest cost consistent with a prudent degree of risk, and to develop the domestic debt market while doing it. The reason composition matters independently of size is that two governments with identical debt-to-GDP ratios can face entirely different situations. One with long-dated local-currency fixed-rate debt held by domestic pension funds is close to insulated from a shock. One with the same ratio in short-dated foreign-currency floating-rate debt held by foreign investors can be forced into crisis by a currency move it does not control, without borrowing another riyal.', 'السياسة المالية تقرر كم تقترض الحكومة. وإدارة الدين تقرر شكل ما تقترضه: الآجال والعملات ومزيج المعدلات الثابتة والمتغيرة وقاعدة المستثمرين. وهما وظيفتان مختلفتان بهدفين مختلفين، وخلطهما خطأ شائع. فمدير الدين لا يُطلب إليه خفض الدين؛ فذاك شأن الموازنة. وإنما يُطلب إليه تلبية احتياجات الحكومة التمويلية بأدنى كلفة تتسق مع درجة حصيفة من المخاطرة، وتطوير سوق الدين المحلي في أثناء ذلك. وسبب أهمية التركيب استقلالاً عن الحجم أن حكومتين بنسبتي دين إلى ناتج محلي متطابقتين قد تواجهان وضعين مختلفين تماماً. فالأولى بدين محلي العملة ثابت المعدل طويل الأجل تحمله صناديق تقاعد محلية شبه معزولة عن الصدمات. والثانية بالنسبة نفسها في دين أجنبي العملة متغير المعدل قصير الأجل يحمله مستثمرون أجانب قد تُدفع إلى أزمة بحركة عملة لا تسيطر عليها، دون أن تقترض ريالاً إضافياً.'),
      ],
    ),
    KBSection(
      heading: Bi('The formal treatment: four risks and the strategy that trades them', 'المعالجة النظرية: أربع مخاطر والاستراتيجية التي تفاضل بينها'),
      paragraphs: [
        Bi('A debt portfolio carries four distinct risks and a strategy is the explicit choice of how much of each to accept. Refinancing risk is the risk that maturing debt cannot be rolled over, or can only be rolled at punitive cost; it is measured by the share of debt maturing within twelve months and by the average time to maturity of the portfolio, and it is managed by smoothing the redemption profile so that no single year carries a spike. Interest rate risk is the risk that rates rise before the debt is repriced; it is measured by the floating-rate share and by the average time to refixing, and reducing it means paying more today for fixed-rate certainty. Currency risk is the risk that a depreciation raises the local-currency value of foreign-currency debt; it is the only one of the four that can raise the debt stock through a pure price movement, and it is the reason foreign issuance is generally kept to a deliberate ceiling. Contingent liability risk is the risk that guarantees, public private partnership commitments and state enterprise debt crystallise onto the sovereign balance sheet; it is the least visible because these obligations often sit outside the reported debt figure entirely. The medium-term debt strategy is the document in which a government states its target ranges for each of these, and its value lies in making the cost and risk trade-off explicit: cheaper short-dated floating foreign borrowing is not an error, but choosing it without stating the risk accepted is.', 'تحمل محفظة الدين أربع مخاطر متمايزة، والاستراتيجية اختيار صريح لكم يُقبل من كل منها. فمخاطرة إعادة التمويل هي خطر تعذر تدوير الدين المستحق، أو تدويره بكلفة عقابية؛ وتُقاس بحصة الدين المستحق خلال اثني عشر شهراً وبمتوسط أجل المحفظة، وتُدار بتنعيم جدول الاستحقاقات حتى لا تحمل سنة واحدة ذروة. ومخاطرة معدل الفائدة هي خطر ارتفاع المعدلات قبل إعادة تسعير الدين؛ وتُقاس بحصة المعدل المتغير وبمتوسط أجل إعادة التثبيت، وخفضها يعني دفع المزيد اليوم مقابل يقين المعدل الثابت. ومخاطرة العملة هي خطر أن يرفع انخفاضٌ القيمةَ المحلية للدين الأجنبي العملة؛ وهي وحدها بين الأربع تستطيع رفع رصيد الدين بحركة سعرية محضة، ولهذا يُبقى الإصدار الأجنبي عادةً تحت سقف مقصود. ومخاطرة الالتزامات المحتملة هي خطر تبلور الضمانات وارتباطات الشراكة بين القطاعين والتزامات مؤسسات الدولة على ميزانية السيادة؛ وهي أقلها ظهوراً لأن هذه الالتزامات كثيراً ما تقع خارج رقم الدين المعروض بالكلية. واستراتيجية الدين متوسطة الأجل هي الوثيقة التي تعلن فيها الحكومة نطاقاتها المستهدفة لكل من هذه، وقيمتها في جعل المفاضلة بين الكلفة والمخاطرة صريحة: فالاقتراض الأجنبي المتغير القصير الأرخص ليس خطأً، لكن اختياره دون بيان المخاطرة المقبولة خطأ.'),
      ],
      formulas: [
        KBFormula('Refinancing exposure = Debt maturing within 12 months ÷ Total debt stock        Average time to maturity = Σ (Weight × Years to maturity)', caption: Bi('A high share maturing soon, or a short average maturity, means the portfolio must be refinanced often.', 'ارتفاع حصة المستحق قريباً، أو قصر متوسط الأجل، يعني وجوب إعادة تمويل المحفظة كثيراً.')),
        KBFormula('Currency shock = Foreign-currency debt × Depreciation %        Rate shock = Floating-rate debt × Rate rise', caption: Bi('The first raises the stock without new borrowing; the second raises the annual interest bill.', 'الأول يرفع الرصيد دون اقتراض جديد؛ والثاني يرفع فاتورة الفائدة السنوية.')),
      ],
    ),
    KBSection(
      heading: Bi('Worked example: measuring the four exposures', 'مثال محلول: قياس التعرضات الأربعة'),
      paragraphs: [
        Bi('A government carries a debt stock of SAR 400bn. Of that, SAR 90bn matures within twelve months, so refinancing exposure is 90 ÷ 400 = 22.5% of the portfolio to be rolled in a single year, and the average time to maturity is 6.2 years. Thirty per cent of the stock, SAR 120bn, is denominated in foreign currency; a 10% depreciation of the local currency would raise the local-currency value of that portion by 120 × 10% = SAR 12bn, adding 3% to the total debt stock without a single new bond being issued. Twenty-five per cent, SAR 100bn, is floating rate; a 200 basis point rise in reference rates adds 100 × 2% = SAR 2bn to the annual interest bill, which is a recurring budget cost rather than a one-off stock effect. Each number implies a different action. The 22.5% rollover concentration is managed by lengthening new issuance and by liability management operations that buy back or exchange near-dated paper. The currency exposure is managed by capping foreign issuance or hedging it, noting that a currency pegged to the issuance currency reduces this exposure substantially but does not remove the policy commitment that sustains the peg. The floating share is managed by issuing fixed, at the price of a higher coupon today. There is no configuration that minimises all four at once, which is exactly why the strategy has to state which risk the government is choosing to carry.', 'تحمل حكومة رصيد دين بـ400 مليار ريال. منه 90 ملياراً تستحق خلال اثني عشر شهراً، فيكون تعرض إعادة التمويل 90 ÷ 400 = 22.5% من المحفظة يجب تدويرها في سنة واحدة، ومتوسط أجل الاستحقاق 6.2 سنوات. وثلاثون في المئة من الرصيد، أي 120 ملياراً، مقومة بعملة أجنبية؛ فانخفاض العملة المحلية بنسبة 10% يرفع القيمة المحلية لذلك الجزء بمقدار 120 × 10% = 12 مليار ريال، مضيفاً 3% إلى رصيد الدين الكلي دون إصدار سند واحد جديد. وخمسة وعشرون في المئة، أي 100 مليار، بمعدل متغير؛ فارتفاع المعدلات المرجعية بمئتي نقطة أساس يضيف 100 × 2% = 2 مليار ريال إلى فاتورة الفائدة السنوية، وهي كلفة موازنة متكررة لا أثر رصيد لمرة واحدة. ويستلزم كل رقم إجراءً مختلفاً. فتركز التدوير عند 22.5% يُدار بإطالة الإصدار الجديد وبعمليات إدارة الالتزامات التي تشتري الورق قريب الأجل أو تبادله. ويُدار تعرض العملة بتسقيف الإصدار الأجنبي أو تحوطه، مع ملاحظة أن ربط العملة بعملة الإصدار يقلل هذا التعرض كثيراً لكنه لا يزيل الالتزام السياساتي الذي يديم الربط. وتُدار الحصة المتغيرة بالإصدار الثابت، بثمن قسيمة أعلى اليوم. ولا يوجد تركيب يُصغّر الأربعة معاً، وهذا بالضبط سبب وجوب أن تعلن الاستراتيجية أي مخاطرة تختار الحكومة حملها.'),
      ],
    ),
    KBSection(
      heading: Bi('What good debt management looks like from outside', 'كيف تبدو إدارة الدين الجيدة من الخارج'),
      paragraphs: [
        Bi('Assessing a debt operation from published information rests on four observable things. First, whether a debt strategy exists, is published, and states target ranges rather than aspirations; a strategy that reports outcomes without prior targets cannot be held to anything. Second, whether the reported debt figure is complete, which means asking what it excludes: guarantees, state enterprise borrowing, arrears to suppliers and public private partnership commitments are all debt in substance and frequently absent from the headline. Third, whether an issuance calendar is published in advance, since predictability is what lets a domestic market develop, and a market that cannot anticipate supply prices uncertainty into every auction. Fourth, whether the recording and reporting are auditable, which is where IPSAS 41 and the disclosure requirements it amended in IPSAS 30 do their work, and where the PEFA framework assesses debt recording and reporting as a distinct dimension of public financial management. For Gulf sovereigns and their related entities the analytically interesting feature is usually not the debt ratio, which is often modest, but the concentration of the investor base and the interaction between sovereign issuance and the borrowing of large state-owned enterprises, since the market frequently prices the two as one credit whether or not the guarantee is explicit.', 'يقوم تقييم عملية الدين من المعلومات المنشورة على أربعة أمور ملحوظة. الأول، هل توجد استراتيجية دين، منشورة، تعلن نطاقات مستهدفة لا تطلعات؛ فالاستراتيجية التي تعرض النتائج دون أهداف سابقة لا يمكن محاسبتها على شيء. الثاني، هل رقم الدين المعروض كامل، ومعناه السؤال عما يستبعده: فالضمانات واقتراض مؤسسات الدولة والمتأخرات للموردين وارتباطات الشراكة بين القطاعين كلها دين في الجوهر وكثيراً ما تغيب عن الرقم الرئيس. الثالث، هل يُنشر تقويم الإصدار مسبقاً، إذ القابلية للتنبؤ هي ما يتيح لسوق محلي أن يتطور، والسوق الذي لا يستطيع توقع المعروض يسعّر عدم اليقين في كل مزاد. الرابع، هل التسجيل والتقرير قابلان للتدقيق، وهنا يعمل IPSAS 41 ومتطلبات الإفصاح التي عدّلها في IPSAS 30، وهنا يقيّم إطار PEFA تسجيل الدين والتقرير عنه بُعداً متمايزاً من أبعاد إدارة المالية العامة. ولسيادات الخليج وكياناتها المرتبطة تكون السمة المثيرة تحليلياً عادةً ليست نسبة الدين، وهي متواضعة غالباً، بل تركز قاعدة المستثمرين والتفاعل بين الإصدار السيادي واقتراض المؤسسات الكبرى المملوكة للدولة، إذ كثيراً ما تسعّر السوق الاثنين ائتماناً واحداً سواء أكان الضمان صريحاً أم لا.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Judging a debt portfolio by its size alone. Two governments with the same debt-to-GDP ratio face different risks depending on maturity, currency and rate composition.', 'الحكم على محفظة دين بحجمها وحده. فحكومتان بنسبة الدين إلى الناتج نفسها تواجهان مخاطر مختلفة بحسب تركيب الأجل والعملة والمعدل.'),
    Bi('Treating the headline debt figure as complete. Guarantees, state enterprise borrowing, supplier arrears and partnership commitments are debt in substance and often sit outside it.', 'اعتبار رقم الدين الرئيس كاملاً. فالضمانات واقتراض مؤسسات الدولة ومتأخرات الموردين وارتباطات الشراكة دين في الجوهر وتقع خارجه غالباً.'),
    Bi('Asking the debt office to minimise cost. Its mandate is lowest cost subject to prudent risk, and the cheapest portfolio is almost always the short, floating, foreign-currency one.', 'مطالبة مكتب الدين بتصغير الكلفة. فتفويضه أدنى كلفة مع مخاطرة حصيفة، وأرخص المحافظ هي شبه دائماً القصيرة المتغيرة الأجنبية العملة.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IPSAS 41',
      note: Bi('Financial instruments: recognition and measurement of borrowings in public sector accounts, replacing IPSAS 29 for periods from 1 January 2023.', 'الأدوات المالية: إثبات القروض وقياسها في حسابات القطاع العام، ويحل محل IPSAS 29 للفترات من أول يناير 2023.'),
      segments: [
        KBStandardSegment('IPSAS 41', href: 'https://www.ipsasb.org/publications/ipsas-41-financial-instruments-1'),
      ],
    ),
    KBStandardRef(
      standard: 'IPSAS 30',
      note: Bi('Financial instruments disclosures: the maturity, currency and interest rate risk information a reader needs to assess the portfolio.', 'إفصاحات الأدوات المالية: معلومات مخاطر الأجل والعملة ومعدل الفائدة التي يحتاجها القارئ لتقييم المحفظة.'),
      segments: [
        KBStandardSegment('IPSAS 30', href: 'https://www.ipsasb.org/standards-pronouncements', viaIndex: true),
      ],
    ),
    KBStandardRef(
      standard: 'PEFA framework',
      note: Bi('Debt recording and reporting, and the management of fiscal risks from guarantees and public corporations, assessed as distinct dimensions.', 'تسجيل الدين والتقرير عنه، وإدارة المخاطر المالية من الضمانات والشركات العامة، وتُقيَّم أبعاداً متمايزة.'),
      segments: [
        KBStandardSegment('PEFA', href: 'https://www.pefa.org/resources/pefa-2016-framework'),
        KBStandardSegment(' framework'),
      ],
    ),
  ],
  relatedTerms: [
    'Long-term Debt',
    'Short-term Debt',
    'Interest Expense',
    'Debt Issuance / Repayment',
    'Liquidity',
    'Contingent Liability',
  ],
  relatedModules: [
    KBRelatedModule('/education/financing', Bi('Module: Financing Decisions', 'الوحدة: قرارات التمويل')),
    KBRelatedModule('/government-education/budgeting', Bi('Module: Government Budgeting', 'الوحدة: الموازنة الحكومية')),
  ],
  relatedArticles: [
    'fiscal-sustainability',
    'government-cash-management',
    'bonds-and-sukuk',
    'government-budget-cycle',
    'public-private-partnerships',
  ],
  references: [
    'International Monetary Fund & World Bank. (2014). Revised guidelines for public debt management. IMF.',
    'International Public Sector Accounting Standards Board. (2018). IPSAS 41: Financial instruments. IFAC.',
    'PEFA Secretariat. (2016). Framework for assessing public financial management. PEFA Secretariat.',
  ],
  keywords: [
    'public debt management',
    'refinancing risk',
    'medium-term debt strategy',
    'currency risk',
    'contingent liabilities',
    'IPSAS 41',
    'إدارة الدين العام',
    'مخاطرة إعادة التمويل',
    'استراتيجية الدين',
    'الالتزامات المحتملة',
  ],
);
