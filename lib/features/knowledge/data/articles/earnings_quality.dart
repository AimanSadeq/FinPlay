// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/earnings-quality.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbEarningsQuality = KBArticle(
  id: 'earnings-quality',
  title: Bi('Earnings Quality and Accounting Red Flags', 'جودة الأرباح وإشارات الإنذار المحاسبية'),
  category: 'financial-analysis',
  level: KBLevel.advanced,
  readingMinutes: 8,
  summary: Bi('Why two companies reporting the same profit can differ in how much of it is real, the accrual gap that measures it, the levers management can pull within the rules, and a checklist for reading a suspect set of accounts.', 'لماذا تختلف شركتان تعرضان الربح نفسه في مقدار ما هو حقيقي منه، وفجوة الاستحقاق التي تقيس ذلك، والأذرع التي تحركها الإدارة داخل القواعد، وقائمة فحص لقراءة حسابات مشبوهة.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('Earnings quality asks a question the income statement cannot answer about itself: how much of this profit is likely to repeat, and how much of it is cash rather than judgment? Profit is an opinion supported by estimates, because accrual accounting deliberately recognizes revenues and expenses before or after the cash moves. That is a feature, not a defect: cash accounting would make a growing company look bankrupt and a collapsing one look healthy. But every estimate embedded in profit is a place where an honest manager exercises judgment and a pressured one shades it. High-quality earnings are backed by cash, arise from the core business, rest on conservative estimates, and are likely to recur. Low-quality earnings are none of those things, and the gap rarely shows up as fraud. It shows up as a pattern.', 'جودة الأرباح تسأل سؤالاً لا تستطيع قائمة الدخل أن تجيبه عن نفسها: كم من هذا الربح يُرجَّح تكراره، وكم منه نقدٌ لا اجتهاد؟ فالربح رأيٌ تسنده تقديرات، لأن محاسبة الاستحقاق تعترف عمداً بالإيرادات والمصروفات قبل حركة النقد أو بعدها. وتلك ميزة لا عيب: فالمحاسبة النقدية تجعل الشركة النامية تبدو مفلسة والمنهارة تبدو معافاة. لكن كل تقدير مغروس في الربح موضعٌ يمارس فيه المدير الأمين اجتهاده ويلوّنه المدير المضغوط. والأرباح عالية الجودة يسندها نقد، وتنشأ من النشاط الجوهري، وتقوم على تقديرات متحفظة، ويُرجَّح تكرارها. والأرباح متدنية الجودة ليست شيئاً من ذلك، والفجوة نادراً ما تظهر احتيالاً. بل تظهر نمطاً.'),
      ],
    ),
    KBSection(
      heading: Bi('The formal treatment: measuring the accrual gap', 'المعالجة النظرية: قياس فجوة الاستحقاق'),
      paragraphs: [
        Bi('The workhorse measure is simple: compare profit with the cash the business actually generated. Accruals are the difference between net income and operating cash flow, and the accruals ratio scales that difference so it can be compared across companies and years. Research going back to Sloan in 1996 established the accrual anomaly: firms with high accruals relative to earnings tend to see those earnings reverse, because accruals are the least persistent component of profit. The intuition is that a receivable is a promise and a cash collection is a fact, and promises fail at a higher rate than facts. Two refinements matter in practice. First, growth naturally generates accruals, since a growing company builds receivables and inventory, so the measure discriminates only when compared against a company’s own history and its peers rather than against zero. Second, the direction of the gap should be tested over several years: one weak year is noise, three consecutive years of profit exceeding cash generation is a trend that usually ends in a write-down.', 'المقياس الأساسي بسيط: قارن الربح بالنقد الذي ولّده النشاط فعلاً. فالاستحقاقات هي الفرق بين صافي الدخل والتدفق النقدي التشغيلي، ونسبة الاستحقاق تقيس ذلك الفرق ليصير قابلاً للمقارنة عبر الشركات والسنوات. وقد أرست بحوث تعود إلى سلون عام 1996 شذوذَ الاستحقاق: فالمنشآت ذات الاستحقاقات المرتفعة نسبة إلى أرباحها تميل إلى انعكاس تلك الأرباح، لأن الاستحقاقات أقل مكونات الربح ثباتاً. والفكرة أن الذمة المدينة وعد والتحصيل النقدي واقعة، والوعود تخفق بمعدل أعلى من الوقائع. ويهم تنقيحان عملياً. أولاً، النمو يولّد استحقاقات بطبيعته، إذ تبني الشركة النامية ذمماً ومخزوناً، فلا يميّز المقياس إلا بمقارنة الشركة بتاريخها ونظائرها لا بالصفر. وثانياً، ينبغي اختبار اتجاه الفجوة عبر سنوات عدة: فسنة ضعيفة واحدة ضجيج، أما ثلاث سنوات متتالية يفوق فيها الربح توليد النقد فاتجاهٌ ينتهي عادةً بتخفيض.'),
      ],
      formulas: [
        KBFormula('Accruals = Net income − Operating cash flow    ·    Cash conversion = Operating cash flow ÷ Net income', caption: Bi('Sustained cash conversion below 1.0 can mean profit is being reported ahead of collection.', 'استمرار التحول النقدي دون 1.0 قد يعني أن الربح يُعرض قبل التحصيل.')),
        KBFormula('Warning pattern: Revenue growth < Receivables growth  ·  Revenue growth < Inventory growth  ·  Operating cash flow growth < Profit growth', caption: Bi('Any one can be innocent; the three together rarely are.', 'كل واحدة قد تكون بريئة؛ لكن اجتماع الثلاث نادراً ما يكون كذلك.')),
      ],
    ),
    KBSection(
      heading: Bi('Worked example: the profit that did not arrive', 'مثال محلول: الربح الذي لم يصل'),
      paragraphs: [
        Bi('A company reports net income of SAR 240m, up 20% on the prior year, and the market reads a strong result. Operating cash flow is SAR 150m, so accruals are 240 − 150 = SAR 90m and cash conversion is 150 ÷ 240 = 0.62 times. Capital expenditure of SAR 60m leaves free cash flow of SAR 90m against a dividend the board has just raised. Now assemble the supporting evidence rather than the headline. Receivables grew 34% while revenue grew 20%, so customers are taking longer to pay or revenue is being recognized earlier. Inventory grew 28%, either a deliberate build or slow movers awaiting a write-down. The provisions note shows a SAR 18m release of warranty provisions raised in better years, which flowed straight to profit without any operating event. And development costs capitalized rose from SAR 12m to SAR 35m, moving spending off the income statement and onto the balance sheet. None of those four breaks a standard. Together they account for a large part of the 20% growth, and each one borrows from a future period that will have to give it back.', 'تعرض شركة صافي دخل قدره 240 مليون ريال، بارتفاع 20% عن العام السابق، فيقرأ السوق نتيجة قوية. والتدفق النقدي التشغيلي 150 مليوناً، فالاستحقاقات 240 − 150 = 90 مليون ريال والتحول النقدي 150 ÷ 240 = 0.62 مرة. وإنفاق رأسمالي قدره 60 مليوناً يترك تدفقاً حراً قدره 90 مليوناً مقابل توزيع رفعه المجلس للتو. والآن اجمع الأدلة المساندة لا العنوان. نمت الذمم المدينة 34% بينما نما الإيراد 20%، فإما أن العملاء صاروا أبطأ في السداد وإما أن الإيراد يُعترف به أبكر. ونما المخزون 28%، إما بناءً مقصوداً وإما بطيئي حركة في انتظار تخفيض. ويُظهر إيضاح المخصصات إطلاق 18 مليوناً من مخصصات ضمان كُوّنت في سنوات أفضل، تدفقت إلى الربح مباشرة دون أي حدث تشغيلي. وارتفعت تكاليف التطوير المرسمَلة من 12 مليوناً إلى 35 مليوناً، فنقلت إنفاقاً من قائمة الدخل إلى الميزانية. ولا يخالف أي من تلك الأربعة معياراً. لكنها مجتمعة تفسر جزءاً كبيراً من نمو الـ20%، وكل واحد منها يقترض من فترة مقبلة سيلزمها ردّه.'),
      ],
    ),
    KBSection(
      heading: Bi('The levers, and where to look for them', 'الأذرع وأين تبحث عنها'),
      paragraphs: [
        Bi('Most earnings management lives inside the rules, which is why reading standards well is the analytical skill that matters. Revenue timing is the largest lever, through the point at which control transfers, the estimate of variable consideration, and the choice between principal and agent presentation. Provisions are the second, since amounts raised generously in good years and released in bad ones smooth profit without any operating event, and the movements table in the provisions note is the public record of that behaviour. Capitalization is the third, though here the lever is timing rather than election: IAS 38 requires development costs to be capitalized once its six criteria are met, and IAS 23 requires it for a qualifying asset, so the judgement is the date the criteria are satisfied rather than whether to capitalize at all. Impairment timing is the fourth, and a large charge bundled with restructuring in a bad year flatters every following year. Depreciation assumptions are the fifth and quietest, since extending useful lives lowers the annual charge permanently. Four places carry the evidence: the accounting policies note for changes in method, the critical estimates note for what management itself flags as judgmental, the provisions movements table, and the reconciliation of profit to operating cash flow. A company that fails all of them at once is rare. A company that fails two, in the same direction, for two years running, deserves a hard question at the next results call.', 'معظم إدارة الأرباح يسكن داخل القواعد، ولهذا تكون قراءة المعايير جيداً هي المهارة التحليلية المهمة. وتوقيت الإيراد أكبر الأذرع، عبر لحظة انتقال السيطرة، وتقدير العوض المتغير، والاختيار بين عرض الأصيل والوكيل. والمخصصات الذراع الثانية، إذ إن مبالغ تُكوَّن بسخاء في السنوات الجيدة وتُطلق في السيئة تنعّم الربح دون أي حدث تشغيلي، وجدول الحركة في إيضاح المخصصات هو السجل العلني لذلك السلوك. والرسملة الثالثة، وإن كانت الأداة هنا التوقيت لا الاختيار: فـIAS 38 يوجب رسملة تكاليف التطوير متى استوفيت معاييره الستة، وIAS 23 يوجبها للأصل المؤهل، فالحكم هو تاريخ استيفاء المعايير لا رسملتها من عدمها. وتوقيت الهبوط رابعاً، وعبءٌ كبير محزوم مع إعادة هيكلة في سنة سيئة يجمّل كل سنة تالية. وافتراضات الاستهلاك خامساً وأهدؤها، إذ إن تمديد الأعمار النافعة يخفض العبء السنوي بصفة دائمة. وأربعة مواضع تحمل الدليل: إيضاح السياسات المحاسبية لتغيرات الطريقة، وإيضاح التقديرات الحرجة لما تصفه الإدارة نفسها بالاجتهادي، وجدول حركة المخصصات، ومطابقة الربح بالتدفق النقدي التشغيلي. والشركة التي تخفق فيها كلها دفعةً واحدة نادرة. أما التي تخفق في اثنين، في الاتجاه نفسه، سنتين متتاليتين، فتستحق سؤالاً صعباً في مؤتمر النتائج المقبل.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Treating a single year of weak cash conversion as evidence of manipulation. Fast growth, a large contract or a seasonal year end produce the same signature honestly.', 'اعتبار سنة واحدة من ضعف التحول النقدي دليلاً على التلاعب. فالنمو السريع أو عقد كبير أو نهاية سنة موسمية تنتج البصمة نفسها بصدق.'),
    Bi('Judging earnings quality without reading the critical estimates note, which is management telling you in advance exactly where the judgment sits.', 'الحكم على جودة الأرباح دون قراءة إيضاح التقديرات الحرجة، وهو إخبار الإدارة لك مسبقاً بموضع الاجتهاد بالضبط.'),
    Bi('Assuming that within the rules means without consequence. Every accrual choice borrows from a later period, so the reversal is scheduled even when nothing improper occurred.', 'افتراض أن ما هو داخل القواعد بلا عواقب. فكل خيار استحقاقي يقترض من فترة لاحقة، فالانعكاس مجدول ولو لم يقع أي أمر غير سليم.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IAS 1 §122–133',
      note: Bi('Disclosure of judgments and sources of estimation uncertainty: the note that names where earnings quality is decided.', 'الإفصاح عن الأحكام ومصادر عدم اليقين في التقدير: الإيضاح الذي يسمي موضع البت في جودة الأرباح.'),
      segments: [
        KBStandardSegment('IAS 1', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-1-presentation-of-financial-statements/'),
        KBStandardSegment(' §122–133'),
      ],
    ),
    KBStandardRef(
      standard: 'IAS 8 §32–40',
      note: Bi('Changes in accounting estimates are prospective, so a revised assumption lands wholly in the current period.', 'تغيرات التقديرات المحاسبية مستقبلية، فالافتراض المعدَّل يهبط كاملاً في الفترة الحالية.'),
      segments: [
        KBStandardSegment('IAS 8', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-8-accounting-policies-changes-in-accounting-estimates-and-errors/'),
        KBStandardSegment(' §32–40'),
      ],
    ),
    KBStandardRef(
      standard: 'IAS 7 §18–20',
      note: Bi('The reconciliation of profit to operating cash flow, which is where the accrual gap becomes visible.', 'مطابقة الربح بالتدفق النقدي التشغيلي، وحيث تظهر فجوة الاستحقاق.'),
      segments: [
        KBStandardSegment('IAS 7', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-7-statement-of-cash-flows/'),
        KBStandardSegment(' §18–20'),
      ],
    ),
  ],
  relatedTerms: [
    'Operating Cash Flow',
    'Net Income',
    'Accrual Accounting',
    'Provision',
    'Capitalization',
    'Days Sales Outstanding (DSO)',
    'Inventory Turnover',
  ],
  relatedModules: [
    KBRelatedModule('/education/financial-analysis', Bi('Module: Analysis of Financial Statements', 'الوحدة: تحليل القوائم المالية')),
    KBRelatedModule('/education/fundamentals', Bi('Module: Financial Management Primer', 'الوحدة: تمهيد الإدارة المالية')),
  ],
  relatedArticles: [
    'statement-analysis-case',
    'cash-flow-statement',
    'provisions-contingencies',
    'revenue-recognition',
    'accrual-accounting',
    'intangible-assets',
    'credit-analysis',
  ],
  references: [
    'Sloan, R. G. (1996). Do stock prices fully reflect information in accruals and cash flows about future earnings? The Accounting Review, 71(3), 289-315.',
    'Penman, S. H. (2013). Financial statement analysis and security valuation (5th ed.). McGraw-Hill.',
    'Schilit, H. M., Perler, J., & Engelhart, Y. (2018). Financial shenanigans (4th ed.). McGraw-Hill.',
    'Dechow, P. M., Ge, W., & Schrand, C. (2010). Understanding earnings quality. Journal of Accounting and Economics, 50(2-3), 344-401.',
  ],
  keywords: [
    'earnings quality',
    'accruals',
    'cash conversion',
    'red flags',
    'earnings management',
    'provisions release',
    'capitalization',
    'جودة الأرباح',
    'الاستحقاقات',
    'التحول النقدي',
    'إشارات الإنذار',
  ],
);
