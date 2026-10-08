// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/fair-value-measurement.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbFairValueMeasurement = KBArticle(
  id: 'fair-value-measurement',
  title: Bi('Fair Value Measurement and the Hierarchy', 'قياس القيمة العادلة والتسلسل الهرمي'),
  category: 'accounting-foundations',
  level: KBLevel.advanced,
  readingMinutes: 10,
  summary: Bi('Fair value as an exit price in a market the entity may never enter, the three-level input hierarchy, highest and best use, and a worked Level 3 valuation showing how much rests on one unobservable assumption.', 'القيمة العادلة سعر خروج في سوق قد لا تدخله المنشأة أبداً، والتسلسل الهرمي للمدخلات بمستوياته الثلاثة، وأفضل استخدام، وتقييم محلول من المستوى الثالث يبين حجم ما يتوقف على افتراض واحد غير ملحوظ.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('IFRS 13 does not tell you when to measure something at fair value. Other standards do that. What it supplies is a single definition and a single method, so that fair value means the same thing in an impairment test, a financial instrument, an investment property and a business combination. The definition is deliberately precise: the price that would be received to sell an asset, or paid to transfer a liability, in an orderly transaction between market participants at the measurement date. Four things are doing work in that sentence. It is an exit price, not the entry price you paid. It is a price between market participants, so the entity\'s own intentions, its cost of capital and its private synergies are irrelevant. It is an orderly transaction, so a forced sale price is not fair value. And it is at the measurement date, so it is a snapshot, not a view of what the asset will be worth. Fair value is therefore a hypothetical price in a hypothetical transaction the entity has no obligation to enter, which is why it feels artificial to preparers and why the standard invests so heavily in making the inputs to it visible.', 'لا يخبرك IFRS 13 متى تقيس شيئاً بالقيمة العادلة. فذلك شأن معايير أخرى. وإنما يوفر تعريفاً واحداً ومنهجاً واحداً، حتى تعني القيمة العادلة الشيء نفسه في اختبار هبوط وأداة مالية وعقار استثماري وتجميع أعمال. والتعريف دقيق عن قصد: السعر الذي يُقبض لبيع أصل، أو يُدفع لتحويل التزام، في معاملة منظمة بين متعاملين في السوق في تاريخ القياس. وأربعة أمور تعمل في تلك الجملة. فهو سعر خروج لا سعر الدخول الذي دفعته. وهو سعر بين متعاملين في السوق، فنوايا المنشأة وتكلفة رأسمالها وتآزراتها الخاصة غير ذات صلة. وهو معاملة منظمة، فسعر البيع القسري ليس قيمة عادلة. وهو في تاريخ القياس، فهو لقطة لا رؤية لما سيساويه الأصل. فالقيمة العادلة إذاً سعر افتراضي في معاملة افتراضية لا تلتزم المنشأة بدخولها، ولهذا تبدو مصطنعة للمُعِدّين، ولهذا يستثمر المعيار كثيراً في إظهار مدخلاتها.'),
      ],
    ),
    KBSection(
      heading: Bi('The formal treatment: market, use and the three levels', 'المعالجة النظرية: السوق والاستخدام والمستويات الثلاثة'),
      paragraphs: [
        Bi('Measurement starts with the market. Fair value is measured in the principal market for the asset, the market with the greatest volume and level of activity that the entity can access, and only where there is no principal market does the entity use the most advantageous market. Transaction costs are not part of fair value, though transport costs are where location is a characteristic of the asset. For non-financial assets, and only for those, measurement assumes the highest and best use by a market participant, which may not be the entity\'s current use: land under a low-yield warehouse is measured on the assumption a buyer would redevelop it, if that is what a market participant would do and it is physically possible, legally permissible and financially feasible. The inputs are then ranked in a hierarchy that gives priority to observable evidence. Level 1 inputs are unadjusted quoted prices in active markets for identical assets, and an entity may not override a Level 1 price with its own model. Level 2 inputs are other observable inputs: quoted prices for similar assets, quoted prices in inactive markets, interest rates and yield curves. Level 3 inputs are unobservable, meaning the entity must build them from the best information available, including its own data adjusted for what a market participant would use. The level of the whole measurement is set by the lowest level input that is significant to it, so a single significant unobservable adjustment drags an otherwise observable valuation into Level 3, and with it the requirement to disclose the unobservable inputs, the valuation process, and a sensitivity analysis showing what happens if those inputs change.', 'يبدأ القياس بالسوق. فالقيمة العادلة تُقاس في السوق الرئيس للأصل، أي السوق الأكبر حجماً ومستوى نشاط الذي تستطيع المنشأة الوصول إليه، ولا تستخدم المنشأة السوق الأكثر منفعة إلا حيث لا يوجد سوق رئيس. وتكاليف المعاملة ليست جزءاً من القيمة العادلة، أما تكاليف النقل فتدخل في القياس حيث يكون الموقع خاصية من خصائص الأصل. وللأصول غير المالية، ولها وحدها، يفترض القياس أفضل استخدام لدى متعامل في السوق، وقد لا يكون استخدام المنشأة الحالي: فالأرض تحت مستودع منخفض العائد تُقاس على افتراض أن مشترياً سيعيد تطويرها، إن كان ذلك ما سيفعله متعامل في السوق وكان ممكناً مادياً وجائزاً قانوناً ومجدياً مالياً. ثم تُرتَّب المدخلات في تسلسل هرمي يعطي الأولوية للبينة الملحوظة. فمدخلات المستوى الأول أسعار معلنة غير معدَّلة في أسواق نشطة لأصول مطابقة، ولا يجوز للمنشأة أن تتجاوز سعر المستوى الأول بنموذجها. ومدخلات المستوى الثاني مدخلات ملحوظة أخرى: أسعار معلنة لأصول مشابهة، وأسعار في أسواق غير نشطة، ومعدلات فائدة ومنحنيات عائد. ومدخلات المستوى الثالث غير ملحوظة، بمعنى أن على المنشأة بناءها من أفضل المعلومات المتاحة، بما فيها بياناتها الخاصة معدَّلةً بما سيستخدمه متعامل في السوق. ويتحدد مستوى القياس كله بأدنى مستوى مدخلٍ جوهريٍّ فيه، فتعديل واحد غير ملحوظ وجوهري يجرّ تقييماً ملحوظاً في سائره إلى المستوى الثالث، ومعه وجوب الإفصاح عن المدخلات غير الملحوظة وعن عملية التقييم وعن تحليل حساسية يبين ما يحدث إذا تغيرت تلك المدخلات.'),
      ],
      formulas: [
        KBFormula('Measurement level = Lowest level of any input that is significant to the measurement as a whole', caption: Bi('One significant unobservable input places the entire measurement in Level 3.', 'مدخل واحد غير ملحوظ وجوهري يضع القياس كله في المستوى الثالث.')),
        KBFormula('Fair value of a stake = (Peer multiple × Metric − Net debt) × Ownership % × (1 − Discount for lack of marketability)', caption: Bi('A common Level 3 build: the multiple is observable, the discount is not.', 'بناء شائع للمستوى الثالث: المضاعف ملحوظ والخصم ليس كذلك.')),
      ],
    ),
    KBSection(
      heading: Bi('Worked example: a Level 3 stake in an unlisted company', 'مثال محلول: حصة من المستوى الثالث في شركة غير مدرجة'),
      paragraphs: [
        Bi('An entity holds 20% of an unlisted manufacturer and must measure it at fair value. The company earns EBITDA of SAR 45m and carries net debt of SAR 90m. Listed peers trade at 8.0 times EBITDA, an observable input, giving an enterprise value of 45 × 8.0 = SAR 360m and equity value of 360 − 90 = SAR 270m. The 20% stake is therefore worth SAR 54m on a pro-rata basis. But a minority stake in an unlisted company cannot be sold on demand, so the entity applies a discount for lack of marketability of 20%, giving a fair value of 54 × 0.80 = SAR 43.2m. That discount is the whole difficulty. It is not observable, it is significant to the measurement, and it therefore places the entire valuation in Level 3 even though the multiple that did most of the work came from a live market. The disclosure requirement follows directly: had the entity used 25% instead of 20%, a defensible range in most marketability studies, the fair value would be 54 × 0.75 = SAR 40.5m, a difference of SAR 2.7m. The sensitivity disclosure exists precisely so a reader can see that the reported SAR 43.2m is one point in a range, not a fact, and can judge whether the point chosen sits at the comfortable end of it.', 'تملك منشأة 20% من شركة تصنيع غير مدرجة وعليها قياسها بالقيمة العادلة. وتحقق الشركة أرباحاً قبل الفوائد والضرائب والاستهلاك والإطفاء قدرها 45 مليون ريال وتحمل ديناً صافياً بـ90 مليوناً. وتُتداول النظائر المدرجة بثمانية أمثال ذلك الرقم، وهو مدخل ملحوظ، فتكون قيمة المنشأة 45 × 8.0 = 360 مليون ريال وقيمة حقوق الملكية 360 − 90 = 270 مليون ريال. فتساوي حصة الـ20% إذاً 54 مليوناً على أساس تناسبي. لكن حصة أقلية في شركة غير مدرجة لا تُباع عند الطلب، فتطبق المنشأة خصماً لانعدام قابلية التسويق بنسبة 20%، فتكون القيمة العادلة 54 × 0.80 = 43.2 مليون ريال. وذلك الخصم هو الإشكال كله. فهو غير ملحوظ، وجوهري للقياس، ومن ثم يضع التقييم كله في المستوى الثالث وإن كان المضاعف الذي أدى معظم العمل جاء من سوق حية. ويتبع وجوب الإفصاح مباشرةً: فلو استخدمت المنشأة 25% بدل 20%، وهو نطاق قابل للدفاع في معظم دراسات قابلية التسويق، لكانت القيمة العادلة 54 × 0.75 = 40.5 مليون ريال، بفارق 2.7 مليون. ووجد الإفصاح عن الحساسية تحديداً ليرى القارئ أن الـ43.2 مليون المعروضة نقطة في نطاق لا واقعة، وليحكم إن كانت النقطة المختارة تقع في الطرف المريح منه.'),
      ],
    ),
    KBSection(
      heading: Bi('What the hierarchy is actually telling you', 'ما الذي يخبرك به التسلسل الهرمي فعلاً'),
      paragraphs: [
        Bi('The hierarchy is best read as a disclosure about confidence rather than a technical classification. A balance sheet whose fair values sit overwhelmingly in Level 1 is reporting numbers a reader can verify independently. One with material Level 3 balances is reporting management\'s estimates, arrived at honestly but unavoidably shaped by the assumptions management chose. Three analytical habits follow. Read the Level 3 reconciliation, which shows the opening balance, purchases, sales, gains recognised in profit and gains recognised in other comprehensive income; unrealised gains on Level 3 assets are profit that no transaction has confirmed. Watch transfers between levels, because a transfer out of Level 1 into Level 2 usually means a market stopped being active, which is information about liquidity that arrives before it arrives anywhere else. And read the sensitivity table as a range, then ask where in that range the reported number sits. For an audience in the Gulf this matters most in unlisted equity stakes, investment property and long-dated infrastructure assets, all of which are commonly held, rarely traded and therefore almost always Level 3.', 'خير قراءة للتسلسل الهرمي أنه إفصاح عن الثقة لا تصنيف فني. فالميزانية التي تقع قيمها العادلة في معظمها الساحق في المستوى الأول تعرض أرقاماً يستطيع القارئ التحقق منها مستقلاً. وأما التي تحمل أرصدة جوهرية في المستوى الثالث فتعرض تقديرات الإدارة، بُلغت بأمانة لكنها تتشكل حتماً بالافتراضات التي اختارتها الإدارة. وتتبع ذلك ثلاث عادات تحليلية. اقرأ مطابقة المستوى الثالث، فهي تبين الرصيد الافتتاحي والمشتريات والمبيعات والمكاسب المثبتة في الربح والمكاسب المثبتة في الدخل الشامل الآخر؛ والمكاسب غير المحققة على أصول المستوى الثالث ربحٌ لم تؤكده معاملة. وراقب التحويلات بين المستويات، فالتحويل من الأول إلى الثاني يعني عادةً أن سوقاً كفّت عن النشاط، وتلك معلومة عن السيولة تصل قبل وصولها إلى أي مكان آخر. واقرأ جدول الحساسية بوصفه نطاقاً، ثم اسأل أين يقع الرقم المعروض من ذلك النطاق. وهذا أهم ما يكون لجمهور في الخليج في حصص الملكية غير المدرجة والعقارات الاستثمارية وأصول البنية التحتية طويلة الأجل، وكلها شائعة الحيازة نادرة التداول ومن ثم شبه دائمة الوقوع في المستوى الثالث.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Treating fair value as the price the entity would accept. It is a market participant exit price, so the entity\'s intentions, holding period and private synergies are excluded by definition.', 'اعتبار القيمة العادلة السعر الذي تقبله المنشأة. فهي سعر خروج لدى متعامل في السوق، فتُستبعد نوايا المنشأة وفترة احتفاظها وتآزراتها الخاصة بحكم التعريف.'),
    Bi('Applying highest and best use to financial assets. That assumption is limited to non-financial assets; a financial instrument is measured as it is, not as it could be redeployed.', 'تطبيق أفضل استخدام على الأصول المالية. فذلك الافتراض مقصور على الأصول غير المالية؛ والأداة المالية تُقاس كما هي لا كما يمكن إعادة توظيفها.'),
    Bi('Reading the level from the dominant input. The measurement takes the level of the lowest significant input, so one unobservable adjustment makes the whole valuation Level 3.', 'قراءة المستوى من المدخل الغالب. فالقياس يأخذ مستوى أدنى مدخل جوهري، فتعديل واحد غير ملحوظ يجعل التقييم كله من المستوى الثالث.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IFRS 13',
      note: Bi('Fair value measurement: the exit price definition, principal market, highest and best use, the three-level hierarchy and the Level 3 disclosures.', 'قياس القيمة العادلة: تعريف سعر الخروج، والسوق الرئيس، وأفضل استخدام، والتسلسل الهرمي بمستوياته الثلاثة، وإفصاحات المستوى الثالث.'),
      segments: [
        KBStandardSegment('IFRS 13', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ifrs-13-fair-value-measurement/'),
      ],
    ),
    KBStandardRef(
      standard: 'IFRS 9',
      note: Bi('Financial instruments: the classifications that require fair value measurement through profit or loss or through other comprehensive income.', 'الأدوات المالية: التصنيفات التي توجب القياس بالقيمة العادلة عبر الربح أو الخسارة أو عبر الدخل الشامل الآخر.'),
      segments: [
        KBStandardSegment('IFRS 9', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ifrs-9-financial-instruments/'),
      ],
    ),
    KBStandardRef(
      standard: 'IAS 36',
      note: Bi('Impairment: fair value less costs of disposal is one of the two limbs of recoverable amount, and it is measured under IFRS 13.', 'الهبوط: القيمة العادلة ناقص تكاليف الاستبعاد أحد ركني المبلغ القابل للاسترداد، وتُقاس بموجب IFRS 13.'),
      segments: [
        KBStandardSegment('IAS 36', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-36-impairment-of-assets/'),
      ],
    ),
  ],
  relatedTerms: [
    'Fair Value',
    'Marketable Securities',
    'EV/EBITDA',
    'Enterprise Value (EV)',
    'Impairment',
    'Long-term Investments',
  ],
  relatedModules: [
    KBRelatedModule('/education/financial-analysis', Bi('Module: Analysis of Financial Statements', 'الوحدة: تحليل القوائم المالية')),
  ],
  relatedArticles: [
    'financial-instruments',
    'impairment-testing',
    'valuation-multiples',
    'investment-property',
    'earnings-quality',
  ],
  references: [
    'IFRS Foundation. (2011). IFRS 13 Fair Value Measurement. IFRS Foundation.',
    'Palepu, K. G., Healy, P. M., & Peek, E. (2019). Business analysis and valuation: IFRS edition (5th ed.). Cengage.',
    'Damodaran, A. (2012). Investment valuation: Tools and techniques for determining the value of any asset (3rd ed.). Wiley.',
  ],
  keywords: [
    'fair value',
    'IFRS 13',
    'fair value hierarchy',
    'Level 3',
    'exit price',
    'highest and best use',
    'القيمة العادلة',
    'التسلسل الهرمي',
    'المستوى الثالث',
    'سعر الخروج',
  ],
);
