// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/foreign-currency.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbForeignCurrency = KBArticle(
  id: 'foreign-currency',
  title: Bi('Foreign Currency: Transactions and Translation', 'العملات الأجنبية: المعاملات والترجمة'),
  category: 'accounting-foundations',
  level: KBLevel.intermediate,
  readingMinutes: 8,
  summary: Bi('The difference between a transaction in a foreign currency and translating a foreign operation, how functional currency is determined, why one set of differences hits profit and the other sits in equity, and a worked translation.', 'الفرق بين معاملة بعملة أجنبية وترجمة عملية خارجية، وكيف تُحدد العملة الوظيفية، ولماذا تصيب مجموعةٌ من الفروق الأرباحَ بينما تستقر الأخرى في حقوق الملكية، ومثال ترجمة محلول.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('Two quite different problems hide behind the phrase "foreign currency". The first is a transaction: a Saudi company buys machinery invoiced in euros and pays three months later. Between the purchase and the payment the exchange rate moves, so the company owes a different number of riyals than it expected. That difference is a real gain or loss and belongs in profit. The second problem is translation: the same company owns a subsidiary in Egypt that keeps its books in Egyptian pounds, and the group must present one set of statements in riyals. Nothing has been bought or sold; a set of numbers simply has to be restated in another unit. IAS 21 treats these two situations differently because they are economically different, and most confusion about foreign currency accounting comes from mixing them up.', 'مشكلتان مختلفتان تماماً تختبئان خلف عبارة «العملة الأجنبية». الأولى معاملة: شركة سعودية تشتري آلات بفاتورة باليورو وتدفع بعد ثلاثة أشهر. وبين الشراء والدفع يتحرك سعر الصرف، فتصير الشركة مدينة بعدد ريالات يخالف ما توقعت. وذلك الفرق مكسب أو خسارة حقيقية ومكانه الأرباح. والمشكلة الثانية ترجمة: الشركة نفسها تملك تابعة في مصر تمسك دفاترها بالجنيه المصري، وعلى المجموعة أن تعرض قوائم واحدة بالريال. ولم يُشترَ شيء ولم يُبَع؛ بل مجرد أرقام يجب إعادة عرضها بوحدة أخرى. ويعامل IAS 21 هاتين الحالتين معاملتين مختلفتين لأنهما مختلفتان اقتصادياً، ومعظم اللبس في محاسبة العملات الأجنبية ينشأ من الخلط بينهما.'),
      ],
    ),
    KBSection(
      heading: Bi('The formal treatment: functional currency first', 'المعالجة النظرية: العملة الوظيفية أولاً'),
      paragraphs: [
        Bi('Every entity has one functional currency: the currency of the primary economic environment in which it operates, determined by what mainly influences its selling prices, its labour and material costs, and the currency in which it retains its receipts. It is a matter of fact, not choice. The presentation currency, by contrast, is a free choice, which is why a Gulf group can operate in dollars and present in riyals. Once functional currency is fixed, transaction accounting follows three rules: record at the spot rate on the transaction date; at each reporting date retranslate monetary items (cash, receivables, payables, loans) at the closing rate while leaving non-monetary items measured at historical cost alone; and put all resulting exchange differences in profit or loss. Translating a foreign operation into a different presentation currency follows a separate rule set: assets and liabilities at the closing rate, income and expenses at the rates on the transaction dates (an average is the usual practical approximation), and every resulting difference into other comprehensive income, accumulated in a translation reserve until the operation is disposed of, when it recycles to profit.', 'لكل منشأة عملة وظيفية واحدة: عملة البيئة الاقتصادية الأساسية التي تعمل فيها، تُحدد بما يؤثر أساساً في أسعار بيعها وتكاليف عمالتها وموادها، وبالعملة التي تحتفظ فيها بمتحصلاتها. وهي مسألة واقع لا اختيار. أما عملة العرض فاختيار حر، ولهذا تستطيع مجموعة خليجية أن تعمل بالدولار وتعرض بالريال. ومتى ثبتت العملة الوظيفية سارت محاسبة المعاملات على ثلاث قواعد: القيد بالسعر الفوري في تاريخ المعاملة؛ وفي كل تاريخ تقرير تُعاد ترجمة البنود النقدية (النقد والذمم المدينة والدائنة والقروض) بسعر الإقفال مع ترك البنود غير النقدية المقاسة بالتكلفة التاريخية على حالها؛ ووضع كل فروق الصرف الناتجة في الربح أو الخسارة. أما ترجمة عملية خارجية إلى عملة عرض مختلفة فتتبع مجموعة قواعد منفصلة: الأصول والالتزامات بسعر الإقفال، والإيرادات والمصروفات بأسعار تواريخ المعاملات (والمتوسط تقريب عملي معتاد)، وكل فرق ناتج إلى الدخل الشامل الآخر، متراكماً في احتياطي ترجمة حتى استبعاد العملية فيُعاد حينها إلى الأرباح.'),
      ],
      formulas: [
        KBFormula('Transaction difference = Amount × (Settlement or closing rate − Rate at initial recognition)   →   profit or loss', caption: Bi('Monetary items are retranslated; the difference is realized or unrealized but always in earnings.', 'البنود النقدية يُعاد ترجمتها؛ والفرق محقق أو غير محقق لكنه دائماً في الأرباح.')),
        KBFormula('Translation reserve movement = Net assets × (Closing rate − Opening rate) + Profit × (Closing rate − Average rate)   →   other comprehensive income', caption: Bi('Translating a foreign operation: the difference never touches profit until disposal.', 'ترجمة عملية خارجية: الفرق لا يمس الأرباح حتى الاستبعاد.')),
      ],
    ),
    KBSection(
      heading: Bi('Worked example: one purchase, one subsidiary', 'مثال محلول: عملية شراء واحدة وشركة تابعة واحدة'),
      paragraphs: [
        Bi('A Saudi company buys equipment for EUR 1,000,000 when the rate is SAR 4.00 per euro, so it records the asset and the payable at SAR 4,000,000. At the year end the invoice is unpaid and the rate is SAR 4.15. The payable is a monetary item, so it is retranslated to SAR 4,150,000 and the SAR 150,000 difference is an exchange loss in profit. The equipment is non-monetary and stays at SAR 4,000,000 forever; it is never retranslated. Now the subsidiary. It has net assets of EGP 50,000,000, translated at an opening rate of SAR 0.078 (SAR 3,900,000) and a closing rate of SAR 0.072 (SAR 3,600,000). Nothing happened inside the subsidiary, yet the group reports SAR 300,000 less. That loss goes to the translation reserve in other comprehensive income, not to profit, because the group has not lost anything it can spend until it sells the subsidiary. Two exposures, one currency market, two entirely different places in the accounts.', 'تشتري شركة سعودية معدات بمليون يورو حين يكون السعر 4.00 ريالات لليورو، فتقيد الأصل والذمة الدائنة بأربعة ملايين ريال. وفي نهاية السنة تكون الفاتورة غير مسددة والسعر 4.15 ريال. والذمة الدائنة بند نقدي فيُعاد ترجمتها إلى 4,150,000 ريال ويكون فرق المئة والخمسين ألفاً خسارة صرف في الأرباح. أما المعدات فغير نقدية وتبقى بأربعة ملايين ريال إلى الأبد؛ ولا يُعاد ترجمتها أبداً. والآن التابعة. لديها صافي أصول قدره خمسون مليون جنيه مصري، مترجمة بسعر افتتاحي 0.078 ريال (3,900,000 ريال) وسعر إقفال 0.072 ريال (3,600,000 ريال). لم يحدث شيء داخل التابعة، ومع ذلك تعرض المجموعة ثلاثمئة ألف ريال أقل. وتذهب تلك الخسارة إلى احتياطي الترجمة في الدخل الشامل الآخر لا إلى الأرباح، لأن المجموعة لم تفقد شيئاً قابلاً للإنفاق حتى تبيع التابعة. تعرضان، وسوق عملة واحد، وموضعان مختلفان تماماً في الحسابات.'),
      ],
    ),
    KBSection(
      heading: Bi('The Saudi angle: a peg is not immunity', 'الزاوية السعودية: الربط ليس حصانة'),
      paragraphs: [
        Bi('The riyal has been pegged to the US dollar at 3.75 since 1986, which removes most translation noise from dollar-denominated trade and makes Saudi accounts unusually stable against the world’s reserve currency. It is tempting to conclude that foreign exchange is not a Saudi problem. Three things break that conclusion. First, the peg covers one pair: exposure to euros, yen, Egyptian pounds, Turkish lira and every other trading currency is fully live, and importers of European equipment carry it in full. Second, a peg is a policy, and policies are maintained at a cost, so treasury teams still monitor the forward market and the reserves that defend it. Third, groups expanding across the region under Vision 2030 acquire subsidiaries in genuinely volatile currencies, which imports translation risk into the consolidated accounts even when every operating decision was sound. The useful habit is to read the currency note and ask which exposures are transaction exposures that will hit earnings, and which are translation exposures that will quietly reshape equity.', 'الريال مربوط بالدولار الأمريكي عند 3.75 منذ 1986، وهو ما يزيل معظم ضجيج الترجمة من التجارة المقومة بالدولار ويجعل الحسابات السعودية مستقرة استقراراً غير معتاد أمام عملة الاحتياط العالمية. ويغري ذلك باستنتاج أن الصرف الأجنبي ليس مشكلة سعودية. وثلاثة أمور تكسر ذلك الاستنتاج. أولاً، الربط يغطي زوجاً واحداً: فالتعرض لليورو والين والجنيه المصري والليرة التركية وسائر عملات التجارة قائم بالكامل، ومستوردو المعدات الأوروبية يحملونه كاملاً. ثانياً، الربط سياسة، والسياسات تُصان بكلفة، فتظل فرق الخزانة تراقب السوق الآجل والاحتياطيات التي تدافع عنه. ثالثاً، المجموعات المتوسعة إقليمياً في ظل رؤية 2030 تستحوذ على تابعات بعملات متقلبة فعلاً، فتستورد مخاطر الترجمة إلى الحسابات الموحدة ولو كان كل قرار تشغيلي سليماً. والعادة المفيدة قراءة إيضاح العملات والسؤال: أي التعرضات تعرضاتُ معاملات ستصيب الأرباح، وأيها تعرضاتُ ترجمة ستعيد تشكيل حقوق الملكية بهدوء.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Retranslating non-monetary assets: equipment bought in euros is fixed in riyals at the historical rate, and "updating" it for currency movements is simply wrong.', 'إعادة ترجمة الأصول غير النقدية: فالمعدات المشتراة باليورو مثبتة بالريال بالسعر التاريخي، و«تحديثها» لتحركات العملة خطأ بحت.'),
    Bi('Treating a translation loss in OCI as a performance failure: it reflects the rate, not the management of the subsidiary, and reverses if the rate does.', 'معاملة خسارة الترجمة في الدخل الشامل إخفاقاً في الأداء: فهي تعكس السعر لا إدارة التابعة، وتنعكس إذا انعكس السعر.'),
    Bi('Choosing functional currency for convenience. It follows the economics of the entity, and getting it wrong misstates every subsequent gain and loss.', 'اختيار العملة الوظيفية للتيسير. فهي تتبع اقتصاد المنشأة، والخطأ فيها يُخطئ كل مكسب وخسارة لاحقة.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IAS 21',
      note: Bi('The effects of changes in foreign exchange rates: functional currency, monetary items, and translation of foreign operations.', 'آثار التغيرات في أسعار صرف العملات: العملة الوظيفية والبنود النقدية وترجمة العمليات الخارجية.'),
      segments: [
        KBStandardSegment('IAS 21', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-21-the-effects-of-changes-in-foreign-exchange-rates/'),
      ],
    ),
    KBStandardRef(
      standard: 'IAS 29',
      note: Bi('Financial reporting in hyperinflationary economies: the restatement required before translating such an operation.', 'التقرير المالي في الاقتصادات ذات التضخم المفرط: إعادة العرض المطلوبة قبل ترجمة عملية كهذه.'),
      segments: [
        KBStandardSegment('IAS 29', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-29-financial-reporting-in-hyperinflationary-economies/'),
      ],
    ),
    KBStandardRef(
      standard: 'IFRS 9 (Chapter 6)',
      note: Bi('Hedge accounting: how forwards and net investment hedges align accounting with the economics of managed exposure.', 'محاسبة التحوط: كيف توائم العقود الآجلة وتحوطات صافي الاستثمار المحاسبةَ مع اقتصاد التعرض المُدار.'),
      segments: [
        KBStandardSegment('IFRS 9', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ifrs-9-financial-instruments/'),
        KBStandardSegment(' (Chapter 6)'),
      ],
    ),
  ],
  relatedTerms: [
    'Accumulated Other Comprehensive Income (AOCI)',
    'Fair Value',
    'Cash and Cash Equivalents',
    'Accounts Payable',
    'Long-term Debt',
  ],
  relatedModules: [
    KBRelatedModule('/education/fundamentals', Bi('Module: Financial Management Primer', 'الوحدة: تمهيد الإدارة المالية')),
    KBRelatedModule('/education/financial-analysis', Bi('Module: Analysis of Financial Statements', 'الوحدة: تحليل القوائم المالية')),
  ],
  relatedArticles: [
    'equity-and-oci',
    'risk-management-hedging',
    'consolidation-goodwill',
    'financial-instruments',
    'balance-sheet',
  ],
  references: [
    'IFRS Foundation. (2003). IAS 21 The Effects of Changes in Foreign Exchange Rates. IFRS Foundation.',
    'Picker, R., Clark, K., Dunn, J., Kolitz, D., Livne, G., Loftus, J., & van der Tas, L. (2019). Applying IFRS standards (4th ed.). Wiley.',
    'Saudi Central Bank. (2024). Annual report. SAMA.',
  ],
  keywords: [
    'foreign currency',
    'IAS 21',
    'functional currency',
    'presentation currency',
    'translation reserve',
    'monetary items',
    'exchange difference',
    'riyal peg',
    'العملة الوظيفية',
    'فروق الصرف',
    'احتياطي الترجمة',
    'ربط الريال',
  ],
);
