// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/borrowing-costs.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbBorrowingCosts = KBArticle(
  id: 'borrowing-costs',
  title: Bi('Borrowing Costs and Capitalization', 'تكاليف الاقتراض والرسملة'),
  category: 'accounting-foundations',
  level: KBLevel.intermediate,
  readingMinutes: 8,
  summary: Bi('When interest becomes part of an asset rather than an expense, what makes an asset qualifying, the capitalization rate for general borrowings, and a worked calculation with the cap that limits it.', 'متى تصير الفائدة جزءاً من الأصل بدل أن تكون مصروفاً، وما الذي يجعل الأصل مؤهلاً، ومعدل الرسملة للاقتراض العام، وحساب محلول مع السقف الذي يحده.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('Interest is normally a financing cost of the period: you borrowed money, you paid for the use of it, the expense belongs to the year. IAS 23 carves out one exception. When borrowed money funds an asset that takes a substantial period to build, the interest incurred during construction is treated as part of the cost of getting that asset ready, in exactly the way the concrete and the labour are. The logic is that a factory built over three years genuinely costs more than an identical factory bought finished, because the builder carried the funding for three years, and the balance sheet should say so. Capitalization is mandatory for such assets, not a policy choice; what remains a matter of judgment is which assets qualify and which costs are directly attributable.', 'الفائدة عادةً كلفة تمويل للفترة: اقترضت مالاً، ودفعت ثمن استخدامه، فالمصروف يخص السنة. ويستثني IAS 23 حالة واحدة. فحين يموّل المال المقترض أصلاً يستغرق بناؤه فترة جوهرية، تُعامل الفائدة المتكبدة أثناء الإنشاء جزءاً من كلفة تهيئة ذلك الأصل، تماماً كالخرسانة والعمالة. والمنطق أن مصنعاً بُني على ثلاث سنوات يكلف فعلاً أكثر من مصنع مطابق اشتُري جاهزاً، لأن الباني حمل التمويل ثلاث سنوات، وعلى الميزانية أن تقول ذلك. والرسملة إلزامية لتلك الأصول لا خيار سياسة؛ وإنما يبقى الاجتهاد في تحديد الأصول المؤهلة والتكاليف المنسوبة مباشرة.'),
      ],
    ),
    KBSection(
      heading: Bi('The formal treatment: qualifying assets, rates and timing', 'المعالجة النظرية: الأصول المؤهلة والمعدلات والتوقيت'),
      paragraphs: [
        Bi('A qualifying asset is one that necessarily takes a substantial period of time to get ready for its intended use or sale: a plant under construction, a power station, an investment property being developed, inventories that require a long maturation such as aged products. Assets ready for use when acquired do not qualify, nor do inventories routinely manufactured in large quantities over short periods, and financial assets never qualify. The measurement then splits by funding source. Where funds are borrowed specifically for the asset, the amount capitalized is the actual borrowing costs incurred on that borrowing during the period, less any investment income earned on temporarily investing those funds before they are spent. Where the asset is funded from general borrowings, the entity applies a capitalization rate, the weighted average of the borrowing costs on its general pool, to the expenditures on the asset, subject to a ceiling: the amount capitalized in a period can never exceed the borrowing costs actually incurred in that period. Timing has three gates. Capitalization begins only when expenditures are being incurred, borrowing costs are being incurred, and the activities to prepare the asset are in progress, all three together. It is suspended during extended periods in which active development pauses. It ceases when substantially all the activities necessary to prepare the asset are complete, which is when the asset is ready for use, not when it is actually used.', 'الأصل المؤهل هو ما يستغرق بالضرورة فترة جوهرية لتهيئته للاستخدام المقصود أو للبيع: مصنع تحت الإنشاء، أو محطة كهرباء، أو عقار استثماري قيد التطوير، أو مخزون يتطلب نضجاً طويلاً كالمنتجات المعتَّقة. أما الأصول الجاهزة للاستخدام عند اقتنائها فلا تتأهل، ولا المخزون المصنّع روتينياً بكميات كبيرة في فترات قصيرة، والأصول المالية لا تتأهل أبداً. ثم ينقسم القياس بحسب مصدر التمويل. فحيث تُقترض الأموال خصيصاً للأصل، يكون المرسمَل هو تكاليف الاقتراض الفعلية المتكبدة على ذلك الاقتراض خلال الفترة، ناقص أي دخل استثماري مكتسب من الاستثمار المؤقت لتلك الأموال قبل إنفاقها. وحيث يُموَّل الأصل من اقتراض عام، تطبق المنشأة معدل رسملة، وهو المتوسط المرجح لتكاليف الاقتراض على مجمعها العام، على الإنفاق على الأصل، بسقف: فالمبلغ المرسمَل في فترة لا يجوز أن يتجاوز أبداً تكاليف الاقتراض المتكبدة فعلاً في تلك الفترة. وللتوقيت ثلاث بوابات. تبدأ الرسملة فقط عند تكبد النفقات، وتكبد تكاليف الاقتراض، وجريان أنشطة تهيئة الأصل، الثلاثة معاً. وتُعلَّق خلال فترات ممتدة يتوقف فيها التطوير الفعلي. وتنتهي عند اكتمال جوهر الأنشطة اللازمة لتهيئة الأصل، أي حين يصير جاهزاً للاستخدام لا حين يُستخدم فعلاً.'),
      ],
      formulas: [
        KBFormula('Capitalization rate = Weighted average borrowing costs on the general pool ÷ Weighted average general borrowings', caption: Bi('Applied to expenditures on the asset, and capped at the borrowing costs actually incurred in the period.', 'يُطبق على الإنفاق على الأصل، ويُقيَّد بتكاليف الاقتراض المتكبدة فعلاً في الفترة.')),
        KBFormula('Specific borrowing: Capitalized = Actual borrowing costs − Investment income on temporary investment of those funds', caption: Bi('The deduction applies only to specific borrowings, not to the general pool.', 'الخصم يسري على الاقتراض المخصص فقط لا على المجمع العام.')),
      ],
    ),
    KBSection(
      heading: Bi('Worked example: general borrowings on a plant', 'مثال محلول: اقتراض عام على مصنع'),
      paragraphs: [
        Bi('A company is building a plant and has no borrowing specific to it. Its general debt is SAR 200m at 6% and SAR 100m at 9%, so annual borrowing costs are 12 + 9 = SAR 21m on SAR 300m of debt, a capitalization rate of 21 ÷ 300 = 7%. During the year it spends SAR 60m at the start and a further SAR 40m at the half-year, so the weighted average expenditure is 60 × 12/12 + 40 × 6/12 = SAR 80m. Borrowing costs capitalized are 80 × 7% = SAR 5.6m, comfortably below the SAR 21m ceiling of costs actually incurred, so the cap does not bite. The remaining SAR 15.4m is expensed. Two consequences follow that a reader should anticipate. Profit this year is SAR 5.6m higher than it would be if all interest were expensed, and the plant will carry SAR 5.6m more depreciation across its life, so the effect is timing rather than value. And because capitalization stops when the plant is ready, the year it comes into service is the year interest expense jumps and depreciation starts, a double hit that has nothing to do with trading.', 'شركة تبني مصنعاً وليس لديها اقتراض مخصص له. ودينها العام 200 مليون ريال بمعدل 6% و100 مليون بمعدل 9%، فتكاليف الاقتراض السنوية 12 + 9 = 21 مليون ريال على 300 مليون من الدين، أي معدل رسملة 21 ÷ 300 = 7%. وخلال السنة تنفق 60 مليوناً في بدايتها و40 مليوناً أخرى في منتصفها، فيكون متوسط الإنفاق المرجح 60 × 12/12 + 40 × 6/12 = 80 مليون ريال. فتكاليف الاقتراض المرسمَلة 80 × 7% = 5.6 ملايين ريال، وهي دون سقف الـ21 مليوناً المتكبدة فعلاً بمسافة مريحة، فلا يعمل السقف. ويُحمَّل الباقي البالغ 15.4 مليوناً مصروفاً. ويتبع ذلك أثران ينبغي أن يتوقعهما القارئ. فربح هذه السنة أعلى بـ5.6 ملايين مما كان سيكون لو حُمّلت الفائدة كلها مصروفاً، وسيحمل المصنع 5.6 ملايين استهلاكاً إضافياً على مدى عمره، فالأثر توقيت لا قيمة. ولأن الرسملة تتوقف حين يجهز المصنع، تكون سنة دخوله الخدمة هي سنة قفزة مصروف الفائدة وبدء الاستهلاك معاً، وهي ضربة مزدوجة لا علاقة لها بالنشاط التجاري.'),
      ],
    ),
    KBSection(
      heading: Bi('Why it matters more in a construction economy', 'لماذا يهم أكثر في اقتصاد إنشائي'),
      paragraphs: [
        Bi('Capitalized interest is one of the quieter levers on reported profit, and it grows in importance exactly where large long-duration projects dominate, which describes much of the Gulf construction, utilities, petrochemical and real estate landscape. Three analytical habits follow. Read the note that discloses the amount capitalized and the capitalization rate, because that number is profit the income statement did not have to carry. Compare interest paid in the cash flow statement with interest expense in the income statement, since a persistent gap usually points to capitalization rather than to accruals. And remember that heavy capitalizers report strong operating profit during a build phase and then face the reversal when assets enter service, which is why a company at the end of a long capital programme can report deteriorating earnings while its underlying operations improve. None of this is manipulation; it is the standard working as designed, and the reader who does not adjust for it will mistake a construction cycle for a performance trend.', 'الفائدة المرسمَلة من أهدأ الأذرع المؤثرة في الربح المعروض، وتتعاظم أهميتها حيث تسود المشاريع الكبيرة طويلة المدة، وهو وصف كبير من مشهد الإنشاءات والمرافق والبتروكيماويات والعقار في الخليج. وتتبع ذلك ثلاث عادات تحليلية. اقرأ الإيضاح الذي يفصح عن المبلغ المرسمَل ومعدل الرسملة، فذلك الرقم ربحٌ لم تضطر قائمة الدخل إلى حمله. وقارن الفائدة المدفوعة في قائمة التدفقات بمصروف الفائدة في قائمة الدخل، فالفجوة المستمرة تشير عادةً إلى رسملة لا إلى استحقاقات. وتذكر أن كثيري الرسملة يعرضون ربحاً تشغيلياً قوياً أثناء مرحلة البناء ثم يواجهون الانعكاس حين تدخل الأصول الخدمة، ولهذا قد تعرض شركة في نهاية برنامج رأسمالي طويل أرباحاً متدهورة بينما تتحسن عملياتها الأساسية. وليس شيء من ذلك تلاعباً؛ بل هو المعيار يعمل كما صُمم، والقارئ الذي لا يعدّل له سيخلط دورة إنشاء بمسار أداء.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Treating capitalization as optional. For a qualifying asset IAS 23 requires it; the judgment is over which assets qualify, not whether to capitalize.', 'معاملة الرسملة خياراً. فـIAS 23 يوجبها للأصل المؤهل؛ والاجتهاد في أي الأصول تتأهل لا في الرسملة من عدمها.'),
    Bi('Deducting investment income from the general pool. The deduction for temporary investment income applies only to funds borrowed specifically for the asset.', 'خصم الدخل الاستثماري من المجمع العام. فخصم دخل الاستثمار المؤقت يسري فقط على الأموال المقترضة خصيصاً للأصل.'),
    Bi('Continuing to capitalize while a project is stalled, or after the asset is ready but not yet used. Both stop capitalization: suspension in the first case, cessation in the second.', 'مواصلة الرسملة أثناء تعثر المشروع، أو بعد جهوزية الأصل وقبل استخدامه. وكلاهما يوقف الرسملة: تعليقاً في الأولى وانتهاءً في الثانية.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IAS 23',
      note: Bi('Borrowing costs: qualifying assets, the capitalization rate, the actual-cost ceiling, and commencement, suspension and cessation.', 'تكاليف الاقتراض: الأصول المؤهلة ومعدل الرسملة وسقف التكلفة الفعلية والبدء والتعليق والانتهاء.'),
      segments: [
        KBStandardSegment('IAS 23', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-23-borrowing-costs/'),
      ],
    ),
    KBStandardRef(
      standard: 'IAS 16 §16–22',
      note: Bi('Cost of property, plant and equipment: the elements capitalized interest joins.', 'تكلفة الممتلكات والمصانع والمعدات: العناصر التي تنضم إليها الفائدة المرسمَلة.'),
      segments: [
        KBStandardSegment('IAS 16', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-16-property-plant-and-equipment/'),
        KBStandardSegment(' §16–22'),
      ],
    ),
    KBStandardRef(
      standard: 'IAS 7 §31–34',
      note: Bi('Cash flow classification of interest paid, which is where capitalized interest becomes visible against the expense line.', 'تصنيف الفائدة المدفوعة في التدفقات النقدية، وحيث تظهر الفائدة المرسمَلة مقابل سطر المصروف.'),
      segments: [
        KBStandardSegment('IAS 7', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-7-statement-of-cash-flows/'),
        KBStandardSegment(' §31–34'),
      ],
    ),
  ],
  relatedTerms: [
    'Interest Expense',
    'Capitalization',
    'Capital Expenditure (CapEx)',
    'Property, Plant & Equipment (PP&E)',
    'Depreciation',
    'Long-term Debt',
  ],
  relatedModules: [
    KBRelatedModule('/education/capital-budgeting', Bi('Module: Capital Budgeting', 'الوحدة: الموازنة الرأسمالية')),
    KBRelatedModule('/education/financial-analysis', Bi('Module: Analysis of Financial Statements', 'الوحدة: تحليل القوائم المالية')),
  ],
  relatedArticles: [
    'depreciation-methods',
    'balance-sheet',
    'cash-flow-statement',
    'earnings-quality',
    'capital-structure',
  ],
  references: [
    'IFRS Foundation. (2007). IAS 23 Borrowing Costs. IFRS Foundation.',
    'Kieso, D. E., Weygandt, J. J., & Warfield, T. D. (2020). Intermediate accounting: IFRS edition (4th ed.). Wiley.',
    'Penman, S. H. (2013). Financial statement analysis and security valuation (5th ed.). McGraw-Hill.',
  ],
  keywords: [
    'borrowing costs',
    'IAS 23',
    'capitalization rate',
    'qualifying asset',
    'capitalized interest',
    'construction',
    'تكاليف الاقتراض',
    'معدل الرسملة',
    'الأصل المؤهل',
    'الفائدة المرسملة',
  ],
);
