// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/equity-and-oci.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbEquityAndOci = KBArticle(
  id: 'equity-and-oci',
  title: Bi('Equity, Comprehensive Income and the Fourth Statement', 'حقوق الملكية والدخل الشامل والقائمة الرابعة'),
  category: 'financial-statements',
  level: KBLevel.intermediate,
  readingMinutes: 7,
  summary: Bi('What sits inside shareholders’ equity, why some gains bypass profit and land in other comprehensive income, which of them ever return, and how the statement of changes in equity ties the whole set of statements together.', 'ما الذي يقع داخل حقوق المساهمين، ولماذا تتجاوز بعض المكاسب الأرباحَ لتستقر في الدخل الشامل الآخر، وأيها يعود يوماً، وكيف تربط قائمة التغيرات في حقوق الملكية مجموعة القوائم كلها.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('Equity is the residual: assets minus liabilities, the owners’ claim on what is left. But the single line labelled total equity is a container holding several very different things. Share capital and share premium record what owners paid in. Retained earnings record profits the company kept rather than distributed. Treasury shares record buybacks, sitting as a negative. Reserves record gains the accounting rules have parked outside profit, such as revaluation surpluses and translation differences. Reading equity as one number misses the point: two companies with identical total equity can differ entirely in whether that equity was contributed by shareholders, earned and retained over decades, or created by revaluing property.', 'حقوق الملكية هي المتبقي: الأصول ناقص الالتزامات، أي مطالبة الملاك بما بقي. لكن السطر الواحد المعنون إجمالي حقوق الملكية وعاءٌ يحوي أشياء شديدة الاختلاف. فرأس المال وعلاوة الإصدار يسجلان ما دفعه الملاك. والأرباح المبقاة تسجل أرباحاً احتفظت بها الشركة بدل توزيعها. وأسهم الخزينة تسجل عمليات إعادة الشراء وتقف رقماً سالباً. والاحتياطيات تسجل مكاسب ركنتها القواعد المحاسبية خارج الأرباح، كفوائض إعادة التقييم وفروق الترجمة. وقراءة حقوق الملكية رقماً واحداً تُفوّت المقصد: فشركتان بإجمالي حقوق ملكية متطابق قد تختلفان كلياً في كون تلك الحقوق مساهماتِ ملاك، أو أرباحاً كُسبت واحتُفظ بها عقوداً، أو ناتجَ إعادة تقييم عقارات.'),
      ],
    ),
    KBSection(
      heading: Bi('The formal treatment: profit, OCI and recycling', 'المعالجة النظرية: الربح والدخل الشامل وإعادة التدوير'),
      paragraphs: [
        Bi('Total comprehensive income is profit or loss plus other comprehensive income. OCI exists because certain gains and losses are real but not yet realized, and putting them through profit would make earnings swing on events management did not cause and cannot control. IAS 1 splits OCI into two families, and the distinction matters more than the label suggests. Items that will be reclassified to profit later include foreign currency translation differences on foreign operations, fair value movements on debt instruments held at FVOCI, and the effective portion of cash flow hedges: these sit in reserves and are recycled into profit when the underlying transaction completes. Items that will never be reclassified include revaluation surpluses on property under IAS 16, remeasurements of defined benefit pension plans, and fair value changes on equity investments where the FVOCI election was made: these may be transferred within equity to retained earnings when realized, and never pass through the income statement.', 'الدخل الشامل الإجمالي هو الربح أو الخسارة زائد الدخل الشامل الآخر. ويوجد الدخل الشامل الآخر لأن مكاسب وخسائر معينة حقيقية لكنها غير محققة بعد، وإمرارها عبر الأرباح يجعل الأرباح تتأرجح بأحداث لم تُحدثها الإدارة ولا تملك السيطرة عليها. ويقسم IAS 1 الدخل الشامل الآخر أسرتين، والتمييز أهم مما يوحي به المسمى. فالبنود التي ستُعاد تصنيفها إلى الأرباح لاحقاً تشمل فروق ترجمة العملات الأجنبية للعمليات الخارجية، وتحركات القيمة العادلة لأدوات الدين المقاسة بالقيمة العادلة عبر الدخل الشامل، والجزء الفعال من تحوطات التدفق النقدي: تستقر هذه في الاحتياطيات وتُعاد إلى الأرباح عند اكتمال المعاملة الأساسية. أما البنود التي لن يُعاد تصنيفها أبداً فتشمل فوائض إعادة تقييم العقارات وفق IAS 16، وإعادة قياس خطط المنافع المحددة للتقاعد، وتغيرات القيمة العادلة لاستثمارات حقوق الملكية حيث اتُّخذ خيار الدخل الشامل: يجوز تحويل هذه داخل حقوق الملكية إلى الأرباح المبقاة عند التحقق، ولا تمر بقائمة الدخل أبداً.'),
      ],
      formulas: [
        KBFormula('Total comprehensive income = Profit or loss + Other comprehensive income', caption: Bi('The full change in equity from performance, before any transaction with owners.', 'التغير الكامل في حقوق الملكية الناتج عن الأداء، قبل أي معاملة مع الملاك.')),
        KBFormula('Closing equity = Opening equity + Total comprehensive income + Shares issued − Buybacks − Dividends', caption: Bi('The statement of changes in equity: performance and owner transactions, kept separate.', 'قائمة التغيرات في حقوق الملكية: الأداء ومعاملات الملاك، كلٌّ على حدة.')),
      ],
    ),
    KBSection(
      heading: Bi('Worked example: reconciling a year of equity', 'مثال محلول: مطابقة سنة من حقوق الملكية'),
      paragraphs: [
        Bi('A company opens the year with equity of SAR 500m. It earns a profit of SAR 80m and records OCI of SAR 12m: a SAR 20m revaluation surplus on land, less SAR 8m of negative translation differences on a foreign subsidiary. It issues shares for SAR 30m, buys back SAR 15m of its own stock, and pays dividends of SAR 25m. Closing equity = 500 + 80 + 12 + 30 − 15 − 25 = SAR 582m. Note what each component says. Performance added SAR 92m, of which only SAR 80m reached earnings per share. Owners injected SAR 30m and took out SAR 40m between dividends and buybacks, so the company returned more to shareholders than it raised. And SAR 20m of the increase is a land revaluation that produced no cash and will never appear in profit, even when the land is sold. A reader who looked only at the SAR 82m rise in equity would misread all three of those facts.', 'تفتح شركة السنة بحقوق ملكية قدرها 500 مليون ريال. تحقق ربحاً قدره 80 مليوناً وتسجل دخلاً شاملاً آخر قدره 12 مليوناً: فائض إعادة تقييم أرض بعشرين مليوناً، ناقص ثمانية ملايين فروق ترجمة سالبة عن شركة تابعة أجنبية. وتصدر أسهماً بثلاثين مليوناً، وتعيد شراء أسهم لها بخمسة عشر مليوناً، وتوزع أرباحاً بخمسة وعشرين مليوناً. حقوق الملكية الختامية = 500 + 80 + 12 + 30 − 15 − 25 = 582 مليون ريال. ولاحظ ما يقوله كل مكوّن. أضاف الأداء 92 مليوناً، وصل منها 80 مليوناً فقط إلى ربحية السهم. وضخ الملاك 30 مليوناً وأخرجوا 40 مليوناً بين توزيعات وإعادة شراء، فأعادت الشركة إلى المساهمين أكثر مما جمعت. وعشرون مليوناً من الزيادة إعادةُ تقييم أرض لم تنتج نقداً ولن تظهر في الأرباح أبداً، ولو بيعت الأرض. والقارئ الذي ينظر إلى ارتفاع حقوق الملكية البالغ 82 مليوناً وحده يسيء قراءة تلك الحقائق الثلاث جميعاً.'),
      ],
    ),
    KBSection(
      heading: Bi('Why the fourth statement matters', 'لماذا تهم القائمة الرابعة'),
      paragraphs: [
        Bi('The statement of changes in equity is the least read of the four primary statements and the one that makes the others cohere. It is where the income statement connects to the balance sheet, because profit lands in retained earnings there. It is where you find every transaction with owners, dividends declared, shares issued, buybacks executed, which the income statement deliberately excludes because they are not performance. And it is where prior period adjustments and changes in accounting policy appear as restatements of opening balances, which is the only place a reader learns that last year’s numbers moved. For anyone assessing whether reported growth in equity came from running the business or from asking shareholders for money, this statement answers the question directly and no other statement does.', 'قائمة التغيرات في حقوق الملكية أقل القوائم الأساسية الأربع قراءةً، وهي التي تجعل بقيتها متماسكة. فهي حيث تتصل قائمة الدخل بالميزانية، لأن الربح يستقر هناك في الأرباح المبقاة. وهي حيث تجد كل معاملة مع الملاك: التوزيعات المعلنة والأسهم المصدرة وعمليات إعادة الشراء المنفذة، وهي ما تستبعده قائمة الدخل عمداً لأنها ليست أداءً. وهي حيث تظهر تعديلات الفترات السابقة وتغيرات السياسات المحاسبية بوصفها إعادة عرض للأرصدة الافتتاحية، وذلك الموضع الوحيد الذي يعلم منه القارئ أن أرقام العام الماضي قد تحركت. ولمن يقيّم هل جاء النمو المعروض في حقوق الملكية من تشغيل النشاط أم من طلب المال من المساهمين، تجيب هذه القائمة مباشرة ولا تجيب سواها.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Treating total equity as “what the company is worth”: it is a historical accounting residual, and the market value of a healthy company is usually a multiple of it.', 'معاملة إجمالي حقوق الملكية على أنه "قيمة الشركة": فهو متبقٍ محاسبي تاريخي، والقيمة السوقية لشركة سليمة عادةً أضعافه.'),
    Bi('Judging performance on profit alone when OCI is large: a company can report solid earnings while translation or pension remeasurements quietly erode equity.', 'الحكم على الأداء بالربح وحده والدخل الشامل الآخر كبير: فقد تعرض شركة أرباحاً متينة بينما تقضم فروق الترجمة أو إعادة قياس التقاعد حقوق الملكية بهدوء.'),
    Bi('Forgetting that reserves are not cash. A revaluation surplus cannot pay a dividend, and distributable reserves are a legal question, not a balance sheet caption.', 'نسيان أن الاحتياطيات ليست نقداً. ففائض إعادة التقييم لا يدفع توزيعاً، والاحتياطيات القابلة للتوزيع مسألة قانونية لا عنوان في الميزانية.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IAS 1 §81A–105, §106–110',
      note: Bi('Presentation of comprehensive income and the statement of changes in equity, including the reclassification split.', 'عرض الدخل الشامل وقائمة التغيرات في حقوق الملكية، بما فيه الفصل بين ما يُعاد تصنيفه وما لا يُعاد.'),
      segments: [
        KBStandardSegment('IAS 1', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-1-presentation-of-financial-statements/'),
        KBStandardSegment(' §81A–105, §106–110'),
      ],
    ),
    KBStandardRef(
      standard: 'IAS 21',
      note: Bi('Foreign exchange: where translation differences on foreign operations arise and when they recycle.', 'الصرف الأجنبي: من أين تنشأ فروق ترجمة العمليات الخارجية ومتى تُعاد إلى الأرباح.'),
      segments: [
        KBStandardSegment('IAS 21', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-21-the-effects-of-changes-in-foreign-exchange-rates/'),
      ],
    ),
    KBStandardRef(
      standard: 'IAS 8 §19–31, §41–49',
      note: Bi('Changes in policy and prior period errors: the restatements that appear in opening equity.', 'تغيرات السياسات وأخطاء الفترات السابقة: إعادات العرض التي تظهر في حقوق الملكية الافتتاحية.'),
      segments: [
        KBStandardSegment('IAS 8', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-8-accounting-policies-changes-in-accounting-estimates-and-errors/'),
        KBStandardSegment(' §19–31, §41–49'),
      ],
    ),
  ],
  relatedTerms: [
    'Shareholders\' Equity',
    'Retained Earnings',
    'Accumulated Other Comprehensive Income (AOCI)',
    'Common Stock',
    'Additional Paid-in Capital (APIC)',
    'Treasury Stock',
    'Dividends',
  ],
  relatedModules: [
    KBRelatedModule('/education/financial-analysis', Bi('Module: Analysis of Financial Statements', 'الوحدة: تحليل القوائم المالية')),
    KBRelatedModule('/education/fundamentals', Bi('Module: Financial Management Primer', 'الوحدة: تمهيد الإدارة المالية')),
  ],
  relatedArticles: [
    'balance-sheet',
    'income-statement',
    'dividend-policy',
    'capital-structure',
    'financial-instruments',
    'foreign-currency',
    'share-based-payment',
  ],
  references: [
    'IFRS Foundation. (2007). IAS 1 Presentation of Financial Statements. IFRS Foundation.',
    'Kieso, D. E., Weygandt, J. J., & Warfield, T. D. (2020). Intermediate accounting: IFRS edition (4th ed.). Wiley.',
    'Penman, S. H. (2013). Financial statement analysis and security valuation (5th ed.). McGraw-Hill.',
  ],
  keywords: [
    'equity',
    'other comprehensive income',
    'OCI',
    'statement of changes in equity',
    'recycling',
    'reserves',
    'retained earnings',
    'treasury shares',
    'حقوق الملكية',
    'الدخل الشامل الآخر',
    'الاحتياطيات',
    'الأرباح المبقاة',
  ],
);
