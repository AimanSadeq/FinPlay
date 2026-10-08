// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/statement-analysis-case.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbStatementAnalysisCase = KBArticle(
  id: 'statement-analysis-case',
  title: Bi('Reading a Company: A Full Statement Analysis', 'قراءة شركة: تحليل متكامل للقوائم'),
  category: 'financial-analysis',
  level: KBLevel.advanced,
  readingMinutes: 6,
  summary: Bi('One company, two years, every tool in sequence: growth, margins, DuPont, liquidity, leverage, and cash quality, ending with the verdict and the questions the numbers cannot answer alone.', 'شركة واحدة وسنتان وكل الأدوات بالتسلسل: النمو والهوامش وديبونت والسيولة والرافعة وجودة النقد، وصولاً إلى الحكم والأسئلة التي لا تجيب عنها الأرقام وحدها.'),
  sections: [
    KBSection(
      heading: Bi('The discipline of sequence', 'انضباط التسلسل'),
      paragraphs: [
        Bi('Statement analysis fails most often not from missing tools but from missing order. The professional sequence is fixed: first size and growth (what happened to the top line?), then profitability (what survived the cost structure?), then the DuPont decomposition (where does the return come from?), then liquidity and leverage (can the structure carry a bad year?), and last cash quality (does the profit exist in cash?). Each step frames the next; jumping straight to a favorite ratio produces confident answers to the wrong question.', 'يفشل تحليل القوائم غالباً لا لنقص الأدوات بل لغياب الترتيب. والتسلسل المهني ثابت: أولاً الحجم والنمو (ماذا حدث للسطر الأول؟)، ثم الربحية (ماذا نجا من هيكل التكاليف؟)، ثم تفكيك ديبونت (من أين يأتي العائد؟)، ثم السيولة والرافعة (هل يحتمل الهيكل سنة سيئة؟)، وأخيراً جودة النقد (هل الربح موجود نقداً؟). كل خطوة تؤطر التالية؛ والقفز إلى نسبة مفضلة ينتج إجابات واثقة عن السؤال الخطأ.'),
        Bi('The case: Gulf Distribution Co. (illustrative), a consumer-goods distributor. The two-year summary below is the entire dataset; everything that follows is computed from it.', 'الحالة: شركة الخليج للتوزيع (افتراضية)، موزع سلع استهلاكية. الملخص أدناه لسنتين هو مجموعة البيانات كاملة؛ وكل ما يلي محسوب منها.'),
      ],
      table: KBTable(
        headers: [
          Bi('SAR 000', 'بآلاف الريالات'),
          Bi('Year 1', 'السنة 1'),
          Bi('Year 2', 'السنة 2'),
        ],
        rows: [
          [
            Bi('Revenue', 'الإيراد'),
            Bi('40,000', '40,000'),
            Bi('48,000', '48,000'),
          ],
          [
            Bi('Cost of sales', 'تكلفة المبيعات'),
            Bi('30,000', '30,000'),
            Bi('37,440', '37,440'),
          ],
          [
            Bi('Operating expenses', 'مصروفات التشغيل'),
            Bi('6,400', '6,400'),
            Bi('7,200', '7,200'),
          ],
          [
            Bi('Finance costs', 'تكاليف التمويل'),
            Bi('600', '600'),
            Bi('1,060', '1,060'),
          ],
          [
            Bi('Net income (after 20% tax)', 'صافي الدخل (بعد ضريبة 20%)'),
            Bi('2,400', '2,400'),
            Bi('1,840', '1,840'),
          ],
          [
            Bi('Receivables', 'الذمم المدينة'),
            Bi('6,600', '6,600'),
            Bi('10,500', '10,500'),
          ],
          [
            Bi('Inventory', 'المخزون'),
            Bi('5,000', '5,000'),
            Bi('7,800', '7,800'),
          ],
          [
            Bi('Total assets', 'إجمالي الأصول'),
            Bi('25,000', '25,000'),
            Bi('32,000', '32,000'),
          ],
          [
            Bi('Total debt', 'إجمالي الدين'),
            Bi('7,500', '7,500'),
            Bi('13,000', '13,000'),
          ],
          [
            Bi('Equity', 'حقوق الملكية'),
            Bi('10,000', '10,000'),
            Bi('11,000', '11,000'),
          ],
          [
            Bi('Cash flow from operations', 'التدفق النقدي التشغيلي'),
            Bi('2,700', '2,700'),
            Bi('−1,300', '−1,300'),
          ],
        ],
      ),
    ),
    KBSection(
      heading: Bi('Steps one to three: growth, margins, DuPont', 'الخطوات من الأولى إلى الثالثة: النمو والهوامش وديبونت'),
      paragraphs: [
        Bi('Growth: revenue rose 20%, a strong headline. Margins: gross margin fell from 25.0% to 22.0% and net margin from 6.0% to 3.8%; the growth was bought with price concessions or a costlier mix, and operating expenses grew slower than revenue, so the damage sits in cost of sales. DuPont: Year 1 ROE = 6.0% margin × 1.60 turnover × 2.50 multiplier = 24.0%. Year 2 ROE = 3.8% × 1.50 × 2.91 = 16.7%. Every engine weakened except leverage, which rose; the return is not only smaller but of poorer quality, since more of it now rests on borrowed money.', 'النمو: ارتفع الإيراد 20%، عنوان قوي. الهوامش: هبط الهامش المجمل من 25.0% إلى 22.0% والصافي من 6.0% إلى 3.8%؛ اشتُري النمو بتنازلات سعرية أو مزيج أعلى كلفة، ونمت مصروفات التشغيل أبطأ من الإيراد، فالضرر يقبع في تكلفة المبيعات. ديبونت: عائد السنة 1 = هامش 6.0% × دوران 1.60 × مضاعف 2.50 = 24.0%. وعائد السنة 2 = 3.8% × 1.50 × 2.91 = 16.7%. ضعف كل محرك إلا الرافعة التي ارتفعت؛ فالعائد ليس أصغر فحسب بل أدنى جودة، إذ يستند الآن أكثر إلى مال مقترض.'),
      ],
    ),
    KBSection(
      heading: Bi('Steps four and five: structure and cash quality', 'الخطوتان الرابعة والخامسة: الهيكل وجودة النقد'),
      paragraphs: [
        Bi('Structure: debt rose from 7,500 to 13,000 while equity barely moved; debt-to-equity climbed from 0.75 to 1.18, and interest cover (operating profit over finance costs) fell from 6.0 times to 3.2 times: still serviceable, no longer comfortable. Working capital tells the operational story: DSO stretched from 60 to 80 days and DIO from 61 to 76 days; the cash conversion cycle lengthened by roughly five weeks. Cash quality is the verdict-maker: net income of 1,840 coexists with operating cash flow of MINUS 1,300. The bridge is exactly the working-capital build: receivables up 3,900 and inventory up 2,800 consumed 6,700 of cash, more than all the profit earned. The new debt did not fund expansion assets; it funded unpaid invoices and unsold stock.', 'الهيكل: ارتفع الدين من 7,500 إلى 13,000 وحقوق الملكية بالكاد تحركت؛ صعدت نسبة الدين إلى حقوق الملكية من 0.75 إلى 1.18، وهبطت تغطية الفوائد (الربح التشغيلي على تكاليف التمويل) من 6.0 أضعاف إلى 3.2: ما زالت قابلة للخدمة، ولم تعد مريحة. ورأس المال العامل يروي القصة التشغيلية: امتدت فترة التحصيل من 60 إلى 80 يوماً وفترة المخزون من 61 إلى 76 يوماً؛ فطالت دورة التحول النقدي نحو خمسة أسابيع. وجودة النقد هي صانعة الحكم: صافي دخل 1,840 يتعايش مع تدفق تشغيلي سالب 1,300. والجسر بينهما هو بالضبط تراكم رأس المال العامل: ذمم زادت 3,900 ومخزون زاد 2,800 استهلكا 6,700 من النقد، أكثر من كل الربح المكتسب. الدين الجديد لم يمول أصول توسع؛ مول فواتير غير محصلة وبضاعة غير مباعة.'),
      ],
    ),
    KBSection(
      heading: Bi('The verdict, and the questions for management', 'الحكم والأسئلة للإدارة'),
      paragraphs: [
        Bi('The integrated reading: growth purchased with margin, funded by leverage, and not yet converted to cash. This is not yet distress; it is the specific pattern that precedes distress when repeated for a second or third year. The analysis does not end with a number but with the questions it licenses: Which customers or terms drove 20 days of DSO stretch, and what share is collectible? Is the inventory build deliberate (ahead of contracted demand) or accumulation of slow movers awaiting a write-down? What covenant headroom remains at 3.2 times cover? And what margin does management expect on the incremental revenue once introductory pricing ends? Numbers select the questions; management answers decide the verdict.', 'القراءة المتكاملة: نمو اشتُري بالهامش، ومُوِّل بالرافعة، ولم يتحول نقداً بعد. ليس هذا عسراً بعد؛ لكنه النمط المحدد الذي يسبق العسر إذا تكرر سنة ثانية أو ثالثة. ولا ينتهي التحليل برقم بل بالأسئلة التي يجيزها: أي عملاء أو شروط مدت التحصيل عشرين يوماً، وما الحصة القابلة للتحصيل؟ وهل تراكم المخزون مقصود (استباقاً لطلب متعاقد عليه) أم تكدس بطيئي الحركة في انتظار تخفيض؟ وما هامش الأمان المتبقي في التعهدات عند تغطية 3.2؟ وما الهامش الذي تتوقعه الإدارة على الإيراد الإضافي بعد انتهاء الأسعار الترويجية؟ الأرقام تختار الأسئلة؛ وإجابات الإدارة تحسم الحكم.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Stopping at the income statement. This case looks like a modest profit dip until the cash flow statement reverses the verdict.', 'التوقف عند قائمة الدخل. تبدو الحالة تراجعاً متواضعاً في الربح حتى تقلب قائمة التدفقات الحكم.'),
    Bi('Averaging away the trend. Two-year comparisons reveal direction; a single year reveals only position.', 'إذابة الاتجاه في المتوسطات. مقارنة سنتين تكشف الاتجاه؛ وسنة واحدة لا تكشف إلا الموضع.'),
    Bi('Treating the ratios as the conclusion. They are the interrogation plan for the conversation with management.', 'اعتبار النسب خلاصةً. إنها خطة الاستجواب للحوار مع الإدارة.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IAS 1 · IAS 7',
      note: Bi('The presentation and cash flow standards that make this cross-statement reading possible on a comparable basis.', 'معيارا العرض والتدفقات اللذان يجعلان هذه القراءة العابرة للقوائم ممكنة على أساس قابل للمقارنة.'),
      segments: [
        KBStandardSegment('IAS 1', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-1-presentation-of-financial-statements/'),
        KBStandardSegment(' · '),
        KBStandardSegment('IAS 7', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-7-statement-of-cash-flows/'),
      ],
    ),
    KBStandardRef(
      standard: 'IFRS 8',
      note: Bi('For diversified groups, run this same sequence per segment before trusting the consolidated picture.', 'للمجموعات المتنوعة، طبق التسلسل نفسه لكل قطاع قبل الوثوق بالصورة الموحدة.'),
      segments: [
        KBStandardSegment('IFRS 8', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ifrs-8-operating-segments/'),
      ],
    ),
  ],
  relatedTerms: [
    'Return on Equity (ROE)',
    'Cash Conversion Cycle (CCC)',
    'Interest Coverage Ratio',
  ],
  relatedModules: [
    KBRelatedModule('/education/financial-analysis', Bi('Module: Analysis of Financial Statements', 'الوحدة: تحليل القوائم المالية')),
  ],
  relatedArticles: [
    'financial-ratios',
    'cash-flow-statement',
    'working-capital',
    'income-statement',
    'consolidation-goodwill',
    'valuation-multiples',
    'segment-reporting',
    'earnings-quality',
  ],
  references: [
    'Penman, S. H. (2013). Financial statement analysis and security valuation (5th ed.). McGraw-Hill.',
    'Palepu, K. G., Healy, P. M., & Peek, E. (2019). Business analysis and valuation: IFRS edition (5th ed.). Cengage.',
    'Wahlen, J. M., Baginski, S. P., & Bradshaw, M. (2018). Financial reporting, financial statement analysis and valuation (9th ed.). Cengage.',
  ],
  keywords: [
    'case study',
    'statement analysis',
    'DuPont',
    'cash quality',
    'integrated analysis',
    'دراسة حالة',
    'تحليل القوائم',
    'جودة النقد',
    'تحليل متكامل',
  ],
);
