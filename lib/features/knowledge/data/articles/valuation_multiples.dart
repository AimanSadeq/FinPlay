// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/valuation-multiples.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbValuationMultiples = KBArticle(
  id: 'valuation-multiples',
  title: Bi('Valuation Multiples: P/E, EV/EBITDA and Their Relatives', 'مضاعفات التقييم: مكرر الربحية وEV/EBITDA وأقاربهما'),
  category: 'financial-analysis',
  level: KBLevel.intermediate,
  readingMinutes: 6,
  summary: Bi('What a multiple actually is (a compressed DCF), the enterprise-versus-equity consistency rule, a worked comparable-companies valuation, and how to choose the right multiple for the business.', 'ما المضاعف حقاً (تدفقات مخصومة مضغوطة)، وقاعدة الاتساق بين قيمة المنشأة وحقوق الملكية، وتقييم محلول بالشركات المقارنة، وكيف تختار المضاعف الملائم للنشاط.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('A valuation multiple is a price divided by a measure of what you get for it: price per riyal of earnings (P/E), enterprise value per riyal of EBITDA (EV/EBITDA), price per riyal of book value (P/B). Multiples work because value ultimately comes from discounted future cash flows, and for businesses with similar growth, risk and returns, the ratio of value to a current performance measure should be similar too. A multiple is therefore a compressed DCF: buried inside “12× EBITDA” are assumptions about growth and required return that the buyer may never have made explicit. Comparable-companies valuation borrows those assumptions from the market prices of similar firms and applies them to yours. It is fast, market-anchored, and only as good as the comparables.', 'مضاعف التقييم سعرٌ مقسوم على مقياس لما تحصل عليه مقابله: السعر لكل ريال من الأرباح (P/E)، وقيمة المنشأة لكل ريال من EBITDA، والسعر لكل ريال من القيمة الدفترية (P/B). وتعمل المضاعفات لأن القيمة تأتي في النهاية من تدفقات نقدية مستقبلية مخصومة، وللأعمال المتشابهة نمواً وخطراً وعوائد ينبغي أن تتشابه نسبة القيمة إلى مقياس أداء حالي أيضاً. فالمضاعف إذن تدفقات مخصومة مضغوطة: فداخل عبارة "12 ضعف EBITDA" تكمن افتراضات عن النمو والعائد المطلوب ربما لم يصرح بها المشتري قط. وتقييم الشركات المقارنة يستعير تلك الافتراضات من أسعار السوق لشركات مشابهة ويطبقها على شركتك. وهو سريع ومرتكز إلى السوق، وجودته من جودة المقارنات لا أكثر.'),
      ],
    ),
    KBSection(
      heading: Bi('The formal treatment: the consistency rule', 'المعالجة النظرية: قاعدة الاتساق'),
      paragraphs: [
        Bi('Every multiple must match its numerator’s claim to its denominator’s claim. Enterprise value (market capitalization plus net debt) is the value of the whole operation, so it pairs with measures earned for all capital providers before interest: revenue, EBITDA, EBIT. Equity value (market capitalization) is the shareholders’ slice, so it pairs with measures after interest: net income, book equity, dividends. Mixing levels produces nonsense: price-to-EBITDA rewards companies for carrying debt, because leverage shrinks the numerator while the denominator ignores interest entirely. The bridge between the two levels is mechanical: equity value = enterprise value minus net debt (and minus non-controlling interest and preferred claims where they exist). Every comparable-company valuation walks across that bridge twice, once to build the peers’ multiples and once to convert the implied enterprise value of the target back into equity.', 'كل مضاعف يجب أن يطابق بين مطالبة بسطه ومطالبة مقامه. فقيمة المنشأة (القيمة السوقية زائد صافي الدين) قيمةُ التشغيل كله، فتقترن بمقاييس تُكسب لكل مقدمي رأس المال قبل الفائدة: الإيراد وEBITDA وEBIT. وقيمة حقوق الملكية (القيمة السوقية) شريحةُ المساهمين، فتقترن بمقاييس ما بعد الفائدة: صافي الدخل والقيمة الدفترية لحقوق الملكية والتوزيعات. وخلط المستويين ينتج هراءً: فنسبة السعر إلى EBITDA تكافئ الشركات على حمل الدين، لأن الرافعة تقلص البسط بينما يتجاهل المقام الفائدة كلياً. والجسر بين المستويين آلي: قيمة حقوق الملكية = قيمة المنشأة ناقص صافي الدين (وناقص الحصة غير المسيطرة والمطالبات الممتازة حيث وُجدت). وكل تقييم بالشركات المقارنة يعبر ذلك الجسر مرتين: مرة لبناء مضاعفات النظائر ومرة لتحويل قيمة المنشأة الضمنية للشركة المستهدفة عائداً إلى حقوق الملكية.'),
      ],
      formulas: [
        KBFormula('EV = Market capitalization + Net debt    ·    Equity value = EV − Net debt', caption: Bi('The enterprise/equity bridge (extend with non-controlling interest and preferred stock where present).', 'جسر المنشأة/حقوق الملكية (يُوسَّع بالحصة غير المسيطرة والأسهم الممتازة حيث وُجدت).')),
        KBFormula('P/E = Price per share ÷ EPS    ·    EV/EBITDA = EV ÷ EBITDA    ·    P/B = Price ÷ Book value per share', caption: Bi('The three workhorse multiples: earnings for the equity level, EBITDA for the enterprise level, book value for balance-sheet-driven businesses.', 'مضاعفات العمل الثلاثة: الأرباح لمستوى حقوق الملكية، وEBITDA لمستوى المنشأة، والقيمة الدفترية للأعمال التي تقودها الميزانية.')),
      ],
    ),
    KBSection(
      heading: Bi('Worked example: pricing a company off its peers', 'مثال محلول: تسعير شركة من نظائرها'),
      paragraphs: [
        Bi('You are valuing an unlisted distributor with EBITDA of SAR 40m and net debt of SAR 60m. Four listed peers trade at EV/EBITDA of 7.1×, 7.8×, 8.2× and 12.5×. The 12.5× outlier is a peer with a fast-growing services arm, so you set it aside and take the median of the rest, roughly 7.8×. Implied enterprise value = 7.8 × 40 = SAR 312m. Cross the bridge: implied equity value = 312 − 60 = SAR 252m. Now test sensitivity: at 7.1× the equity is SAR 224m and at 8.2× it is SAR 268m, so the peer range moves the answer by SAR 44m before any judgment about whether your target deserves the median at all. A multiple valuation is honest only when presented as that range with the comparables named, not as a single confident number.', 'تقيّم موزعاً غير مدرج EBITDA لديه 40 مليون ريال وصافي دينه 60 مليوناً. تتداول أربع شركات نظيرة مدرجة عند EV/EBITDA قدره 7.1 و7.8 و8.2 و12.5 ضعفاً. القيمة الشاذة 12.5 لنظير له ذراع خدمات سريعة النمو، فتنحّيها وتأخذ وسيط البقية، نحو 7.8 ضعف. قيمة المنشأة الضمنية = 7.8 × 40 = 312 مليون ريال. اعبر الجسر: قيمة حقوق الملكية الضمنية = 312 − 60 = 252 مليون ريال. ثم اختبر الحساسية: عند 7.1 تكون حقوق الملكية 224 مليوناً وعند 8.2 تكون 268 مليوناً، فمدى النظائر يحرك الجواب 44 مليوناً قبل أي حكم في استحقاق شركتك للوسيط أصلاً. وتقييم المضاعفات لا يكون أميناً إلا معروضاً بذلك المدى مع تسمية المقارنات، لا رقماً واحداً واثقاً.'),
      ],
    ),
    KBSection(
      heading: Bi('Choosing the multiple for the business', 'اختيار المضاعف الملائم للنشاط'),
      paragraphs: [
        Bi('The right multiple follows the economics. EV/EBITDA suits capital-intensive businesses and cross-border comparisons because it neutralizes depreciation policy, leverage and tax regimes; its blind spot is that it also ignores the capital expenditure those depreciation charges represent. P/E is the shareholder’s shorthand and works when earnings are positive, stable and comparably leveraged; it collapses for loss-makers and flatters cyclicals at the peak, when earnings are highest and the multiple looks deceptively cheap. P/B matters where the balance sheet is the business, banks and insurers above all, and pairs naturally with return on equity: a company earning above its cost of equity deserves more than book, one earning below it deserves less. Revenue multiples are the measure of last resort for pre-profit companies, and the widest door for wishful thinking.', 'المضاعف الصائب يتبع الاقتصاد. فمضاعف EV/EBITDA يلائم الأعمال كثيفة رأس المال والمقارنات عبر الحدود لأنه يحيّد سياسة الاستهلاك والرافعة والأنظمة الضريبية؛ ونقطة عماه أنه يتجاهل أيضاً الإنفاق الرأسمالي الذي تمثله أعباء الاستهلاك تلك. ومكرر الربحية P/E اختصارُ المساهم ويعمل عندما تكون الأرباح موجبة ومستقرة ومتقاربة الرافعة؛ وينهار للخاسرين ويجامل الدوريين عند الذروة، حيث الأرباح في أعلاها فيبدو المضاعف رخيصاً خداعاً. وP/B مهم حيث تكون الميزانية هي النشاط، والبنوك وشركات التأمين قبل غيرها، ويقترن طبيعياً بالعائد على حقوق الملكية: فشركة تكسب فوق كلفة حقوق ملكيتها تستحق أكثر من الدفترية، ومن تكسب دونها تستحق أقل. ومضاعفات الإيراد مقياسُ الملاذ الأخير لشركات ما قبل الربح، وأوسع باب للتمني.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Mismatching levels: price-to-EBITDA or EV-to-net-income mixes claims of different capital providers and makes leveraged companies look artificially cheap or dear.', 'عدم مطابقة المستويين: نسبة السعر إلى EBITDA أو قيمة المنشأة إلى صافي الدخل تخلط مطالبات مقدمي رأس مال مختلفين وتُظهر الشركات المرفوعة رخيصة أو غالية زيفاً.'),
    Bi('Averaging in the outlier instead of asking why it is one: the 12.5× peer is either mispriced or a different business, and both answers matter.', 'إدخال القيمة الشاذة في المتوسط بدل السؤال عن سببها: فالنظير عند 12.5 ضعفاً إما مسعّر خطأً وإما نشاط مختلف، وكلا الجوابين مهم.'),
    Bi('Trusting trailing multiples at cyclical turning points: peak earnings make a cheap-looking P/E, which is precisely when the cycle is most dangerous.', 'الوثوق بالمضاعفات التاريخية عند منعطفات الدورة: أرباح الذروة تصنع مكرر ربحية يبدو رخيصاً، وذلك بالضبط حين تكون الدورة في أخطر حالاتها.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IAS 33',
      note: Bi('Earnings per share: the rules behind the basic and diluted EPS figures that P/E ratios consume.', 'ربحية السهم: القواعد خلف رقمي الربحية الأساسية والمخففة اللذين تستهلكهما مكررات الربحية.'),
      segments: [
        KBStandardSegment('IAS 33', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-33-earnings-per-share/'),
      ],
    ),
    KBStandardRef(
      standard: 'IFRS 13',
      note: Bi('Fair value measurement: recognizes market-multiple techniques as a valuation approach and governs their disclosure.', 'قياس القيمة العادلة: يقر أساليب مضاعفات السوق نهجاً للتقييم وينظم الإفصاح عنها.'),
      segments: [
        KBStandardSegment('IFRS 13', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ifrs-13-fair-value-measurement/'),
      ],
    ),
  ],
  relatedTerms: [
    'Price-to-Earnings Ratio (P/E)',
    'EV/EBITDA',
    'Enterprise Value (EV)',
    'EBITDA',
    'Price-to-Book Ratio (P/B)',
    'Market Capitalization',
    'Earnings Per Share (EPS)',
  ],
  relatedModules: [
    KBRelatedModule('/education/financial-analysis', Bi('Module: Analysis of Financial Statements', 'الوحدة: تحليل القوائم المالية')),
    KBRelatedModule('/education/capital-budgeting', Bi('Module: Capital Budgeting', 'الوحدة: الموازنة الرأسمالية')),
  ],
  relatedArticles: [
    'dcf-valuation',
    'financial-ratios',
    'statement-analysis-case',
    'wacc',
    'income-statement',
    'dividend-policy',
    'share-based-payment',
    'fair-value-measurement',
    'mergers-acquisitions',
  ],
  references: [
    'Koller, T., Goedhart, M., & Wessels, D. (2020). Valuation: Measuring and managing the value of companies (7th ed.). Wiley.',
    'Damodaran, A. (2012). Investment valuation: Tools and techniques for determining the value of any asset (3rd ed.). Wiley.',
    'Penman, S. H. (2013). Financial statement analysis and security valuation (5th ed.). McGraw-Hill.',
  ],
  keywords: [
    'valuation multiples',
    'P/E',
    'EV/EBITDA',
    'price to book',
    'comparable companies',
    'enterprise value',
    'equity value',
    'مضاعفات التقييم',
    'مكرر الربحية',
    'قيمة المنشأة',
    'الشركات المقارنة',
  ],
);
