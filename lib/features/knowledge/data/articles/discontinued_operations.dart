// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/discontinued-operations.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbDiscontinuedOperations = KBArticle(
  id: 'discontinued-operations',
  title: Bi('Assets Held for Sale and Discontinued Operations', 'الأصول المحتفظ بها للبيع والعمليات المتوقفة'),
  category: 'financial-statements',
  level: KBLevel.intermediate,
  readingMinutes: 7,
  summary: Bi('What changes the moment a business is put up for sale, the strict criteria for held-for-sale classification, why discontinued operations get their own line, and a worked example of the profit picture before and after.', 'ما الذي يتغير لحظة عرض نشاط للبيع، والمعايير الصارمة لتصنيف المحتفظ به للبيع، ولماذا تحصل العمليات المتوقفة على سطر خاص بها، ومثال محلول لصورة الربح قبل وبعد.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('When a company decides to sell a division, the accounts face a reporting problem. Next year that division will be gone, so leaving its revenue and costs mixed into the ordinary results makes this year’s figures a poor guide to the future, which is the main thing a reader wants from them. IFRS 5 solves it in two moves. First, the assets and liabilities being disposed of are pulled out of their normal balance sheet lines and shown as single held-for-sale captions, measured on a new basis, because the company will recover their value through sale rather than through use. Second, if what is being disposed of is a whole major line of business or geographical area, its results are stripped out of continuing operations and presented as one after-tax line called discontinued operations. The reader can then see the profit of the business that will still exist next year, which is exactly the point.', 'حين تقرر شركة بيع قطاع، تواجه الحسابات مشكلة عرض. ففي السنة المقبلة سيكون ذلك القطاع قد رحل، وترك إيراده وتكاليفه ممزوجة بالنتائج العادية يجعل أرقام هذه السنة دليلاً رديئاً على المستقبل، وهو أهم ما يريده القارئ منها. ويحل IFRS 5 ذلك بخطوتين. أولاً، تُسحب الأصول والالتزامات موضع الاستبعاد من سطورها المعتادة في الميزانية وتُعرض عناوينَ واحدة للمحتفظ به للبيع، مقيسةً على أساس جديد، لأن الشركة ستسترد قيمتها بالبيع لا بالاستخدام. وثانياً، إن كان المستبعد خط أعمال رئيساً كاملاً أو منطقة جغرافية كاملة، جُرِّدت نتائجه من العمليات المستمرة وعُرضت سطراً واحداً بعد الضريبة يسمى العمليات المتوقفة. فيستطيع القارئ حينها رؤية ربح النشاط الذي سيظل قائماً في السنة المقبلة، وذلك هو المقصود تماماً.'),
      ],
    ),
    KBSection(
      heading: Bi('The formal treatment: strict criteria, new measurement', 'المعالجة النظرية: معايير صارمة وقياس جديد'),
      paragraphs: [
        Bi('Held-for-sale classification is not available for an intention. The asset or disposal group must be available for immediate sale in its present condition, and the sale must be highly probable: management committed to a plan, an active programme to find a buyer under way, the asset marketed at a price reasonable relative to its fair value, and the sale expected to complete within twelve months. Once classified, measurement changes to the lower of carrying amount and fair value less costs to sell, and, crucially, depreciation stops, because the asset is no longer being consumed through use. Any write-down goes to profit immediately. A discontinued operation is a narrower idea: a component that has been disposed of or is held for sale and represents a separate major line of business or geographical area of operations, or a subsidiary acquired exclusively with a view to resale. When one exists, the income statement presents a single post-tax figure for it, prior periods are re-presented on the same basis so the comparatives are consistent, and the notes break the figure down into revenue, expenses, tax and any gain or loss on remeasurement or disposal.', 'تصنيف المحتفظ به للبيع لا يُمنح لمجرد نية. فيجب أن يكون الأصل أو مجموعة الاستبعاد متاحاً للبيع الفوري بحالته الراهنة، وأن يكون البيع مرجحاً بدرجة عالية: إدارة ملتزمة بخطة، وبرنامج فعال جارٍ لإيجاد مشترٍ، وأصل مسوَّق بسعر معقول نسبة إلى قيمته العادلة، وبيع يُتوقع إتمامه خلال اثني عشر شهراً. ومتى صُنِّف تغير القياس إلى الأقل بين المبلغ الدفتري والقيمة العادلة ناقص تكاليف البيع، والأهم أن الاستهلاك يتوقف، لأن الأصل لم يعد يُستهلك بالاستخدام. وأي تخفيض يذهب إلى الأرباح فوراً. أما العملية المتوقفة ففكرة أضيق: مكوّن استُبعد أو مُحتفظ به للبيع ويمثل خط أعمال رئيساً منفصلاً أو منطقة عمليات جغرافية منفصلة، أو شركة تابعة استُحوذ عليها حصراً بقصد إعادة البيع. ومتى وُجدت، عرضت قائمة الدخل رقماً واحداً لها بعد الضريبة، وأُعيد عرض الفترات السابقة على الأساس نفسه لتتسق أرقام المقارنة، وفصّلت الإيضاحات الرقم إلى إيراد ومصروفات وضريبة وأي مكسب أو خسارة من إعادة القياس أو الاستبعاد.'),
      ],
      formulas: [
        KBFormula('Held-for-sale carrying amount = min(Carrying amount, Fair value − Costs to sell)   ·   Depreciation ceases', caption: Bi('A measurement basis borrowed from exit values, not from continued use.', 'أساس قياس مستعار من قيم الخروج لا من الاستخدام المستمر.')),
      ],
    ),
    KBSection(
      heading: Bi('Worked example: before and after the reclassification', 'مثال محلول: قبل إعادة التصنيف وبعدها'),
      paragraphs: [
        Bi('A group reports revenue of SAR 800m and profit after tax of SAR 40m. Inside that sits a retail division with revenue of SAR 200m and an after-tax loss of SAR 30m, which the board has now committed to sell, with a broker appointed and completion expected in nine months. The division qualifies as held for sale and as a discontinued operation. Re-presented, continuing operations show revenue of SAR 600m and profit of SAR 70m, and a single line below reports a SAR 30m loss from discontinued operations, giving the same SAR 40m total. The reader now sees an 11.7% margin on the business that will exist next year rather than a 5% margin on a business that is about to change shape. Two further effects follow. The division’s assets, say SAR 250m, move to a single held-for-sale line in current assets, and depreciation on them stops, which mechanically shrinks the reported loss inside the discontinued line in the months before completion; continuing profit is unaffected, because the division’s costs already sit below it. If the expected sale price is below carrying amount, an impairment is booked now inside the discontinued line, not spread over the sale year.', 'تعرض مجموعة إيراداً قدره 800 مليون ريال وربحاً بعد الضريبة قدره 40 مليوناً. وداخله قطاع تجزئة بإيراد 200 مليون وخسارة بعد الضريبة قدرها 30 مليوناً، وقد التزم المجلس ببيعه الآن، مع تعيين وسيط وتوقع الإتمام خلال تسعة أشهر. ويتأهل القطاع بوصفه محتفظاً به للبيع وعمليةً متوقفة. وبإعادة العرض تُظهر العمليات المستمرة إيراداً قدره 600 مليون وربحاً قدره 70 مليوناً، ويعرض سطر واحد أدناه خسارة 30 مليوناً من العمليات المتوقفة، فيبقى المجموع 40 مليوناً نفسه. ويرى القارئ الآن هامش 11.7% على النشاط الذي سيوجد في السنة المقبلة بدل هامش 5% على نشاط على وشك تغيير هيئته. ويتبع ذلك أثران آخران. تنتقل أصول القطاع، ولنقل 250 مليوناً، إلى سطر واحد للمحتفظ به للبيع ضمن الأصول المتداولة، ويتوقف استهلاكها، فتنكمش آلياً الخسارة المعروضة داخل سطر العمليات المتوقفة في الأشهر السابقة للإتمام؛ ولا يتأثر الربح المستمر، لأن تكاليف القطاع تقع أصلاً تحته. وإن كان سعر البيع المتوقع دون المبلغ الدفتري قُيِّد هبوطٌ الآن داخل سطر العمليات المتوقفة، لا موزعاً على سنة البيع.'),
      ],
    ),
    KBSection(
      heading: Bi('Where the presentation can mislead', 'أين يمكن أن يضلل العرض'),
      paragraphs: [
        Bi('The split into continuing and discontinued is genuinely useful and genuinely exploitable. Because the discontinued line is a single after-tax number, everything unflattering inside it, restructuring costs, write-downs, operating losses, is compressed into one figure most readers skip. A company disposing of a weak division can therefore show a sharp improvement in continuing margin that reflects arithmetic rather than management action, and headline commentary tends to quote continuing operations without saying so. Two habits protect against this. Read the discontinued note in full, since it contains the revenue, expenses and disposal gain the face of the statement hides. And check whether the classification criteria were really met, because a sale that keeps being delayed beyond twelve months, with the asset still classified as held for sale, usually means the price expected was never realistic.', 'القسمة بين المستمر والمتوقف مفيدة فعلاً وقابلة للاستغلال فعلاً. فلأن سطر المتوقف رقم واحد بعد الضريبة، ينضغط فيه كل ما لا يجمّل: تكاليف إعادة الهيكلة والتخفيضات والخسائر التشغيلية، في رقم واحد يتخطاه معظم القراء. فتستطيع شركة تستبعد قطاعاً ضعيفاً أن تُظهر تحسناً حاداً في هامش العمليات المستمرة يعكس حساباً لا فعلاً إدارياً، وتميل التعليقات الرئيسة إلى اقتباس العمليات المستمرة دون قول ذلك. وعادتان تحميان من هذا. اقرأ إيضاح العمليات المتوقفة كاملاً، فهو يحوي الإيراد والمصروفات ومكسب الاستبعاد التي يخفيها وجه القائمة. وتحقق هل استُوفيت معايير التصنيف حقاً، فالبيع الذي يتأخر مراراً بعد اثني عشر شهراً والأصل ما زال مصنفاً محتفظاً به للبيع يعني عادةً أن السعر المتوقع لم يكن واقعياً قط.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Comparing this year’s continuing-operations margin with last year’s total margin: the comparatives are re-presented, so the right comparison is continuing against re-presented continuing.', 'مقارنة هامش العمليات المستمرة هذه السنة بالهامش الإجمالي للسنة الماضية: فأرقام المقارنة يُعاد عرضها، والمقارنة الصحيحة مستمرٌّ مقابل مستمرٍّ معاد عرضه.'),
    Bi('Assuming held-for-sale means sold. Classification reflects intent plus evidence, and deals fall through, at which point the asset returns to its normal lines with depreciation caught up.', 'افتراض أن المحتفظ به للبيع يعني المباع. فالتصنيف يعكس نية ودليلاً، والصفقات تنهار، فيعود الأصل عندها إلى سطوره المعتادة مع تدارك الاستهلاك.'),
    Bi('Ignoring the cash flow consequences: disposal proceeds are an investing inflow that can flatter free cash flow in the year of sale and never recur.', 'تجاهل الآثار النقدية: فمتحصلات الاستبعاد تدفق استثماري داخل قد يجمّل التدفق الحر في سنة البيع ولا يتكرر أبداً.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IFRS 5',
      note: Bi('Non-current assets held for sale and discontinued operations: classification criteria, measurement, and presentation.', 'الأصول غير المتداولة المحتفظ بها للبيع والعمليات المتوقفة: معايير التصنيف والقياس والعرض.'),
      segments: [
        KBStandardSegment('IFRS 5', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ifrs-5-non-current-assets-held-for-sale-and-discontinued-operations/'),
      ],
    ),
    KBStandardRef(
      standard: 'IFRS 8',
      note: Bi('Operating segments: the segment note usually shows the disposed business as its own segment before the sale.', 'القطاعات التشغيلية: يُظهر إيضاح القطاعات عادةً النشاط المستبعد قطاعاً مستقلاً قبل البيع.'),
      segments: [
        KBStandardSegment('IFRS 8', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ifrs-8-operating-segments/'),
      ],
    ),
    KBStandardRef(
      standard: 'IAS 36',
      note: Bi('Impairment: the write-down tested before an asset enters the held-for-sale measurement basis.', 'الهبوط في القيمة: التخفيض المختبر قبل دخول الأصل أساس قياس المحتفظ به للبيع.'),
      segments: [
        KBStandardSegment('IAS 36', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-36-impairment-of-assets/'),
      ],
    ),
  ],
  relatedTerms: [
    'Non-Current Assets',
    'Current Assets',
    'Fair Value',
    'Impairment',
    'Acquisitions & Disposals',
  ],
  relatedModules: [
    KBRelatedModule('/education/financial-analysis', Bi('Module: Analysis of Financial Statements', 'الوحدة: تحليل القوائم المالية')),
  ],
  relatedArticles: [
    'income-statement',
    'balance-sheet',
    'impairment-testing',
    'segment-reporting',
    'consolidation-goodwill',
  ],
  references: [
    'IFRS Foundation. (2004). IFRS 5 Non-current Assets Held for Sale and Discontinued Operations. IFRS Foundation.',
    'Kieso, D. E., Weygandt, J. J., & Warfield, T. D. (2020). Intermediate accounting: IFRS edition (4th ed.). Wiley.',
    'Penman, S. H. (2013). Financial statement analysis and security valuation (5th ed.). McGraw-Hill.',
  ],
  keywords: [
    'discontinued operations',
    'held for sale',
    'IFRS 5',
    'disposal group',
    're-presentation',
    'continuing operations',
    'العمليات المتوقفة',
    'المحتفظ به للبيع',
    'مجموعة الاستبعاد',
    'العمليات المستمرة',
  ],
);
