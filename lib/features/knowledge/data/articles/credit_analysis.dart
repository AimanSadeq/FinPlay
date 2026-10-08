// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/credit-analysis.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbCreditAnalysis = KBArticle(
  id: 'credit-analysis',
  title: Bi('Credit Analysis and Covenant Headroom', 'التحليل الائتماني وهامش التعهدات'),
  category: 'financial-analysis',
  level: KBLevel.advanced,
  readingMinutes: 9,
  summary: Bi('How a lender reads a borrower, the difference between maintenance and incurrence covenants, a worked headroom calculation in both leverage and coverage terms, and why the classification of a liability now turns on when a covenant is tested.', 'كيف يقرأ المقرض المقترض، والفرق بين تعهدات الصيانة وتعهدات الإنشاء، وحساب محلول للهامش بدلالة الرافعة والتغطية معاً، ولماذا صار تصنيف الالتزام يتوقف على موعد اختبار التعهد.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('Equity analysis asks how much a business will earn. Credit analysis asks a narrower and harder question: will it still be able to pay, in the worst plausible case, before the debt matures. That reframing changes what matters. Upside is almost irrelevant to a lender who cannot participate in it, so the analysis concentrates on downside, on the reliability of cash flow rather than its size, and on the order in which claims are paid if things go wrong. It also shifts attention from the income statement to two other places: the cash flow statement, because interest is paid in cash and not in accruals, and the loan documentation, because the covenants written there determine when a lender may act. A company does not usually fail because it becomes unprofitable. It fails because a covenant trips, the facility becomes repayable, and no one will refinance it.', 'يسأل تحليل حقوق الملكية كم ستكسب المنشأة. ويسأل التحليل الائتماني سؤالاً أضيق وأصعب: هل ستظل قادرة على السداد، في أسوأ الحالات المعقولة، قبل استحقاق الدين. وتغير إعادة الصياغة هذه ما يهم. فالجانب الصاعد شبه عديم الصلة بمقرض لا يشارك فيه، فيتركز التحليل على الجانب الهابط، وعلى موثوقية التدفق النقدي لا حجمه، وعلى ترتيب سداد المطالبات إن ساءت الأمور. وهو ينقل الانتباه أيضاً من قائمة الدخل إلى موضعين آخرين: قائمة التدفقات النقدية، لأن الفائدة تُدفع نقداً لا استحقاقاً، ووثائق القرض، لأن التعهدات المكتوبة فيها تحدد متى يجوز للمقرض أن يتصرف. فالشركة لا تنهار عادةً لأنها كفّت عن الربح. بل تنهار لأن تعهداً انكسر، فصار التسهيل مستحق السداد، ولم يُعد أحد تمويله.'),
      ],
    ),
    KBSection(
      heading: Bi('The formal treatment: ratios, covenant types and the reporting-date test', 'المعالجة النظرية: النسب وأنواع التعهدات واختبار تاريخ التقرير'),
      paragraphs: [
        Bi('Credit metrics come in two families. Stock measures compare debt to a measure of earning power, most commonly net debt to EBITDA, and answer how many years of current earnings the debt represents. Flow measures compare earnings to the cost of servicing the debt, most commonly EBITDA to interest, and answer whether this year\'s cash covers this year\'s obligations. A lender sets covenants on both because they fail in different ways: a company can have comfortable coverage and unsustainable leverage, or the reverse. Covenants themselves split into two kinds. A maintenance covenant is tested at every reporting date regardless of what the borrower does, and breaching it is an event of default. An incurrence covenant is tested only when the borrower takes an action, typically raising more debt or paying a dividend, and it restricts rather than defaults. Definitions matter more than levels: contracts specify their own EBITDA, often with addbacks for exceptional items, share-based payment and pro forma synergies, and a covenant EBITDA can differ from the reported figure by a wide margin. Since the amendments to IAS 1 effective for annual periods beginning on or after 1 January 2024, the classification of a liability as current or non-current depends only on covenants the borrower must comply with on or before the reporting date. A covenant tested after the reporting date does not make the liability current, but where a liability is classified as non-current and is subject to such covenants within twelve months, the entity discloses information about them so a reader can assess the risk that they will be breached.', 'تأتي المقاييس الائتمانية في عائلتين. فمقاييس الرصيد تقارن الدين بمقياس للقدرة على الكسب، وأشيعها صافي الدين إلى الأرباح قبل الفوائد والضرائب والاستهلاك والإطفاء، وتجيب كم سنة من الأرباح الحالية يمثل الدين. ومقاييس التدفق تقارن الأرباح بكلفة خدمة الدين، وأشيعها تلك الأرباح إلى الفائدة، وتجيب هل يغطي نقد هذه السنة التزاماتها. ويضع المقرض تعهدات على الاثنين لأنهما يخفقان بطريقتين مختلفتين: فقد تكون للشركة تغطية مريحة ورفع غير مستدام، أو العكس. وتنقسم التعهدات نفسها نوعين. فتعهد الصيانة يُختبر في كل تاريخ تقرير مهما فعل المقترض، وكسره حدث إخلال. وتعهد الإنشاء لا يُختبر إلا حين يتخذ المقترض إجراءً، وغالباً رفع دين إضافي أو توزيع أرباح، وهو يقيّد ولا يُخِلّ. والتعريفات أهم من المستويات: فالعقود تحدد أرباحها الخاصة قبل الفوائد والضرائب والاستهلاك والإطفاء، وكثيراً ما تضيف إليها بنوداً استثنائية ومدفوعات على أساس الأسهم وتآزرات مفترضة، وقد يختلف رقم التعهد عن الرقم المعروض بفارق واسع. ومنذ تعديلات IAS 1 النافذة للفترات السنوية التي تبدأ في أول يناير 2024 أو بعده، صار تصنيف الالتزام متداولاً أو غير متداول يتوقف فقط على التعهدات التي على المقترض الالتزام بها في تاريخ التقرير أو قبله. فالتعهد المختبَر بعد تاريخ التقرير لا يجعل الالتزام متداولاً، لكن حيث يُصنف التزام غير متداول ويخضع لتعهدات كهذه خلال اثني عشر شهراً، تفصح المنشأة عن معلومات عنها ليقدّر القارئ خطر كسرها.'),
      ],
      formulas: [
        KBFormula('Net leverage = Net debt ÷ EBITDA        Interest coverage = EBITDA ÷ Interest expense', caption: Bi('The two families: how much debt relative to earnings, and whether earnings service it.', 'العائلتان: كم الدين نسبةً إلى الأرباح، وهل تخدمه الأرباح.')),
        KBFormula('EBITDA headroom = EBITDA − (Net debt ÷ Covenant leverage limit)', caption: Bi('The fall in earnings the borrower can absorb before the leverage covenant is breached.', 'مقدار الهبوط في EBITDA الذي يحتمله المقترض قبل كسر تعهد الرافعة.')),
      ],
    ),
    KBSection(
      heading: Bi('Worked example: measuring the cushion two ways', 'مثال محلول: قياس الوسادة بطريقتين'),
      paragraphs: [
        Bi('A borrower reports EBITDA of SAR 180m, net debt of SAR 620m and interest expense of SAR 48m. Its facility carries a maintenance covenant of net leverage no greater than 3.75 times and interest coverage no less than 3.0 times. Current leverage is 620 ÷ 180 = 3.44 times, so the covenant is met. To see how comfortably, invert it: the covenant allows net debt of 3.75 times EBITDA, so the minimum EBITDA consistent with SAR 620m of debt is 620 ÷ 3.75 = SAR 165.3m. Earnings can therefore fall by SAR 14.7m, about 8.1%, before the leverage test fails. Coverage is 180 ÷ 48 = 3.75 times against a 3.0 limit, so interest could rise to 180 ÷ 3.0 = SAR 60m, a 25% increase, before that test fails. Two headroom numbers, two different exposures: this borrower is more vulnerable to a fall in trading than to a rise in rates. Now add a detail. The company holds lease liabilities of SAR 140m recognised under IFRS 16. If the covenant definition of net debt includes them, leverage becomes 760 ÷ 180 = 4.22 times and the covenant is already breached; if the facility was signed on a frozen definition that excludes them, it is not. Nothing about the business has changed between those two sentences. This is why covenant analysis begins with the definitions clause and not with the financial statements.', 'يعرض مقترض أرباحاً قبل الفوائد والضرائب والاستهلاك والإطفاء بـ180 مليون ريال، وديناً صافياً بـ620 مليوناً، ومصروف فائدة بـ48 مليوناً. ويحمل تسهيله تعهد صيانة برفع صافٍ لا يتجاوز 3.75 أمثال وتغطية فائدة لا تقل عن 3.0 أمثال. فالرافعة الحالية 620 ÷ 180 = 3.44 أمثال، والتعهد مستوفى. ولرؤية مدى الراحة، اعكسه: فالتعهد يجيز ديناً صافياً بـ3.75 أمثال الأرباح، فيكون أدنى EBITDA يتسق مع 620 مليوناً من الدين هو 620 ÷ 3.75 = 165.3 مليون ريال. فتستطيع الأرباح إذاً أن تهبط 14.7 مليوناً، أي نحو 8.1%، قبل إخفاق اختبار الرافعة. والتغطية 180 ÷ 48 = 3.75 أمثال مقابل حد 3.0، فتستطيع الفائدة أن ترتفع إلى 180 ÷ 3.0 = 60 مليون ريال، بزيادة 25%، قبل إخفاق ذلك الاختبار. رقما هامش، وتعرضان مختلفان: فهذا المقترض أشد هشاشةً أمام هبوط النشاط منه أمام ارتفاع المعدلات. وأضف الآن تفصيلاً. تحمل الشركة التزامات إيجار بـ140 مليون ريال مثبتة بموجب IFRS 16. فإن كان تعريف التعهد لصافي الدين يشملها صارت الرافعة 760 ÷ 180 = 4.22 أمثال والتعهد مكسور فعلاً؛ وإن كان التسهيل وُقّع على تعريف مجمَّد يستبعدها فليس بمكسور. ولم يتغير شيء في النشاط بين تينك الجملتين. ولهذا يبدأ تحليل التعهدات ببند التعريفات لا بالقوائم المالية.'),
      ],
    ),
    KBSection(
      heading: Bi('Where the risk actually sits', 'أين تقع المخاطرة فعلاً'),
      paragraphs: [
        Bi('A disciplined credit read assembles four things that the ratios alone do not give. The maturity profile, because a company with comfortable metrics and a large maturity inside twelve months is a refinancing risk and not a leverage risk, and the two are managed differently. The quality of EBITDA, since covenant compliance is measured on a defined number and the gap between defined and reported EBITDA is where optimism accumulates; comparing operating cash flow with EBITDA over three years is the fastest test of whether the earnings are collectible. The security and ranking, because a secured lender with a first charge over the operating assets and an unsecured bondholder in the same capital structure face entirely different losses on the same default. And the liquidity sources, meaning undrawn committed facilities and unrestricted cash, which decide whether a temporary breach is survivable. For borrowers in the Gulf, two features recur often enough to check by default: parent or government support that is real in practice but not contractually committed, and facilities whose covenant definitions predate IFRS 16, which is precisely the trap in the worked example above.', 'القراءة الائتمانية المنضبطة تجمع أربعة أمور لا تعطيها النسب وحدها. جدول الاستحقاقات، فالشركة ذات المقاييس المريحة واستحقاق كبير خلال اثني عشر شهراً خطرُ إعادة تمويل لا خطر رافعة، والاثنان يُداران على نحو مختلف. وجودة EBITDA، إذ يُقاس الالتزام بالتعهد على رقم معرَّف، والفجوة بين الرقم المعرَّف والرقم المعروض هي حيث يتراكم التفاؤل؛ ومقارنة التدفق النقدي التشغيلي بتلك الأرباح على ثلاث سنوات أسرع اختبار لقابلية الأرباح للتحصيل. والضمان والترتيب، فالمقرض المضمون برهن أول على الأصول التشغيلية وحامل السند غير المضمون في الهيكل الرأسمالي نفسه يواجهان خسارتين مختلفتين تماماً عن الإخلال نفسه. ومصادر السيولة، أي التسهيلات الملتزَم بها غير المسحوبة والنقد غير المقيد، وهي التي تقرر إن كان كسر مؤقت قابلاً للنجاة منه. وللمقترضين في الخليج تتكرر سمتان بما يكفي لفحصهما افتراضياً: دعم الشركة الأم أو الحكومة الحقيقي عملياً غير الملتزَم به تعاقدياً، وتسهيلات تسبق تعريفاتُ تعهداتها معيارَ IFRS 16، وهو تحديداً الفخ في المثال أعلاه.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Computing covenant ratios from the reported financial statements. The facility defines its own EBITDA and its own net debt, and the two can differ materially from the published figures.', 'حساب نسب التعهدات من القوائم المالية المعروضة. فالتسهيل يعرّف أرباحه وصافي دينه، وقد يختلف الاثنان جوهرياً عن الأرقام المنشورة.'),
    Bi('Reading a covenant tested after the reporting date as making the debt current. Since the 2024 amendments only covenants due on or before the reporting date affect classification, though the later ones must be disclosed.', 'اعتبار تعهد مختبَر بعد تاريخ التقرير مُصيِّراً الدين متداولاً. فمنذ تعديلات 2024 لا يؤثر في التصنيف إلا التعهدات المستحقة في تاريخ التقرير أو قبله، وإن وجب الإفصاح عن اللاحقة.'),
    Bi('Judging headroom on leverage alone. A borrower can be comfortable on leverage and one rate rise away from breaching coverage, so both cushions must be measured.', 'الحكم على الهامش بالرافعة وحدها. فقد يكون المقترض مرتاحاً في الرافعة وعلى بعد رفعة معدل واحدة من كسر التغطية، فيجب قياس الوسادتين معاً.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IAS 1 §69–76B',
      note: Bi('Classification of liabilities as current or non-current, as amended for covenants with effect from 1 January 2024, including the disclosures about covenants tested within twelve months.', 'تصنيف الالتزامات متداولة أو غير متداولة، بصيغته المعدلة للتعهدات اعتباراً من أول يناير 2024، بما فيه الإفصاحات عن التعهدات المختبَرة خلال اثني عشر شهراً.'),
      segments: [
        KBStandardSegment('IAS 1', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-1-presentation-of-financial-statements/'),
        KBStandardSegment(' §69–76B'),
      ],
    ),
    KBStandardRef(
      standard: 'IFRS 7',
      note: Bi('Financial instrument disclosures: the liquidity risk table with contractual maturities, and defaults and breaches during the period.', 'إفصاحات الأدوات المالية: جدول مخاطر السيولة بالاستحقاقات التعاقدية، وحالات الإخلال والكسر خلال الفترة.'),
      segments: [
        KBStandardSegment('IFRS 7', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ifrs-7-financial-instruments-disclosures/'),
      ],
    ),
    KBStandardRef(
      standard: 'IFRS 16',
      note: Bi('Leases: the lease liabilities whose inclusion in or exclusion from a covenant definition of net debt can decide compliance.', 'عقود الإيجار: التزامات الإيجار التي قد يقرر إدراجها أو استبعادها من تعريف التعهد لصافي الدين مسألةَ الالتزام.'),
      segments: [
        KBStandardSegment('IFRS 16', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ifrs-16-leases/'),
      ],
    ),
  ],
  relatedTerms: [
    'Debt-to-EBITDA',
    'Interest Coverage Ratio',
    'EBITDA',
    'Long-term Debt',
    'Current Portion of Long-term Debt',
    'Liquidity',
  ],
  relatedModules: [
    KBRelatedModule('/education/financial-analysis', Bi('Module: Analysis of Financial Statements', 'الوحدة: تحليل القوائم المالية')),
    KBRelatedModule('/education/financing', Bi('Module: Financing Decisions', 'الوحدة: قرارات التمويل')),
  ],
  relatedArticles: [
    'financial-ratios',
    'capital-structure',
    'bonds-and-sukuk',
    'cash-flow-forecasting',
    'earnings-quality',
    'leases-ifrs16',
  ],
  references: [
    'IFRS Foundation. (2022). Non-current liabilities with covenants: Amendments to IAS 1. IFRS Foundation.',
    'Ganguin, B., & Bilardello, J. (2005). Fundamentals of corporate credit analysis. McGraw-Hill.',
    'Palepu, K. G., Healy, P. M., & Peek, E. (2019). Business analysis and valuation: IFRS edition (5th ed.). Cengage.',
  ],
  keywords: [
    'credit analysis',
    'covenants',
    'headroom',
    'net leverage',
    'interest coverage',
    'IAS 1 covenants amendment',
    'التحليل الائتماني',
    'التعهدات',
    'هامش التعهد',
    'الرافعة الصافية',
  ],
);
