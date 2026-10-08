// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/income-statement.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbIncomeStatement = KBArticle(
  id: 'income-statement',
  title: Bi('The Income Statement in Depth', 'قائمة الدخل بعمق'),
  category: 'financial-statements',
  level: KBLevel.foundation,
  readingMinutes: 5,
  summary: Bi('The architecture of profit: how IAS 1 structures the statement, what each margin level isolates, the by-nature versus by-function choice, and the quality-of-earnings questions professionals should ask.', 'بنية الربح: كيف يهيكل المعيار IAS 1 القائمة، وما الذي يعزله كل مستوى من مستويات الهامش، والاختيار بين العرض حسب الطبيعة وحسب الوظيفة، وأسئلة جودة الأرباح التي ينبغي للمهنيين طرحها.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('The income statement reports financial performance for a period: the revenues earned, the expenses incurred to earn them, and the resulting profit or loss. Unlike the balance sheet, which is a photograph at an instant, the income statement is a film of the whole period. Its power comes from its layered structure: each subtotal deliberately isolates one class of decision so that different questions can be answered from different lines.', 'تعرض قائمة الدخل الأداء المالي عن فترة: الإيرادات المكتسبة، والمصروفات المتكبدة لاكتسابها، وما ينتج عن ذلك من ربح أو خسارة. وعلى خلاف الميزانية العمومية التي هي صورة في لحظة، فإن قائمة الدخل شريط للفترة كلها. وتأتي قوتها من هيكلها المتدرج: كل مجموع فرعي يعزل عمداً فئة واحدة من القرارات بحيث تُجاب أسئلة مختلفة من سطور مختلفة.'),
      ],
    ),
    KBSection(
      heading: Bi('The formal treatment: the margin ladder', 'المعالجة النظرية: سلم الهوامش'),
      paragraphs: [
        Bi('Gross profit (revenue minus cost of sales) isolates the economics of the product itself: what it costs to make or buy what you sell. Operating profit (gross profit minus selling, general, administrative and other operating costs) adds the cost of running the organization that sells it; this is the line that measures management\'s operating performance and the one most ratio analysis is built on. Profit before tax then layers in the financing structure (finance costs and finance income), and net income adds the tax effect. Reading top to bottom is reading three separate verdicts: on the product, on the operation, and on the financing and tax position.', 'مجمل الربح (الإيراد ناقص تكلفة المبيعات) يعزل اقتصاديات المنتج نفسه: كم يكلف صنع أو شراء ما تبيعه. والربح التشغيلي (مجمل الربح ناقص مصروفات البيع والعمومية والإدارية وسائر تكاليف التشغيل) يضيف تكلفة إدارة المنظمة التي تبيع؛ وهذا هو السطر الذي يقيس الأداء التشغيلي للإدارة وعليه يُبنى معظم تحليل النسب. ثم يضيف الربح قبل الضريبة طبقة هيكل التمويل (تكاليف التمويل ودخله)، ويضيف صافي الدخل أثر الضريبة. قراءة القائمة من أعلى إلى أسفل هي قراءة ثلاثة أحكام منفصلة: على المنتج، وعلى التشغيل، وعلى وضع التمويل والضريبة.'),
        Bi('IAS 1 allows expenses to be presented by nature (depreciation, employee benefits, raw materials) or by function (cost of sales, distribution, administration). By-function produces the familiar gross-profit format but requires allocation judgments; by-nature is more objective and is common in continental Europe and in the public sector. An entity presenting by function must still disclose the nature figures in the notes (IAS 1 §104), which is where analysts go to find, for example, total employee costs.', 'يسمح المعيار IAS 1 بعرض المصروفات حسب طبيعتها (الإهلاك، ومنافع الموظفين، والمواد الخام) أو حسب وظيفتها (تكلفة المبيعات، والتوزيع، والإدارة). العرض الوظيفي ينتج الشكل المألوف بمجمل الربح لكنه يتطلب اجتهادات توزيع؛ والعرض حسب الطبيعة أكثر موضوعية وهو شائع في أوروبا القارية وفي القطاع العام. وعلى المنشأة التي تعرض حسب الوظيفة أن تفصح مع ذلك عن أرقام الطبيعة في الإيضاحات (IAS 1 الفقرة 104)، وهناك يذهب المحللون ليجدوا مثلاً إجمالي تكاليف الموظفين.'),
      ],
      formulas: [
        KBFormula('Gross margin = Gross profit ÷ Revenue    ·    Operating margin = Operating profit ÷ Revenue    ·    Net margin = Net income ÷ Revenue', caption: Bi('The three margin ratios; each one converts a subtotal of the ladder into a comparable percentage.', 'نسب الهامش الثلاث؛ كل واحدة تحول مجموعاً فرعياً من السلم إلى نسبة قابلة للمقارنة.')),
      ],
    ),
    KBSection(
      heading: Bi('Worked example: same profit, different stories', 'مثال محلول: الربح نفسه وقصتان مختلفتان'),
      paragraphs: [
        Bi('Two companies each report net income of SAR 1.0m on revenue of SAR 10.0m. Company A: gross margin 60%, operating margin 15%, heavy finance costs. Company B: gross margin 25%, operating margin 12%, no debt. Identical bottom lines, opposite diagnoses: A has a strong product carrying an expensive organization and balance sheet; B is a thin-margin operator whose discipline in overheads is doing the work. Decisions about pricing, cost programs, or refinancing land in completely different places even though "profit" is the same number.', 'شركتان تبلغ كل منهما عن صافي دخل 1.0 مليون ريال على إيراد 10.0 ملايين. الشركة أ: هامش مجمل 60%، وهامش تشغيلي 15%، وتكاليف تمويل ثقيلة. والشركة ب: هامش مجمل 25%، وهامش تشغيلي 12%، وبلا ديون. السطران الأخيران متطابقان والتشخيصان متعاكسان: أ لديها منتج قوي يحمل منظمة وميزانية مكلفتين؛ وب مشغِّل بهوامش رقيقة ينهض انضباطها في المصروفات العامة بالعبء. قرارات التسعير أو برامج التكلفة أو إعادة التمويل تقع في مواضع مختلفة تماماً رغم أن «الربح» هو الرقم نفسه.'),
      ],
    ),
    KBSection(
      heading: Bi('Quality of earnings', 'جودة الأرباح'),
      paragraphs: [
        Bi('Sophisticated readers interrogate the composition of profit, not only its size. Recurring or one-off? Gains on asset sales and reversal of provisions inflate a single period. Cash-backed or accrual-heavy? Compare net income with operating cash flow over several periods. Sustainable or squeezed? A margin improvement produced by cutting maintenance, training, or marketing borrows from future periods. These questions convert the income statement from a scoreboard into evidence.', 'القارئ المتمرس يسائل تركيب الربح لا حجمه فقط. أهو متكرر أم لمرة واحدة؟ فأرباح بيع الأصول وعكس المخصصات تضخم فترة واحدة. أهو مدعوم بالنقد أم مثقل بالاستحقاقات؟ قارن صافي الدخل بالتدفق التشغيلي عبر عدة فترات. أهو قابل للاستمرار أم منتزع انتزاعاً؟ فتحسن الهامش الناتج عن خفض الصيانة أو التدريب أو التسويق اقتراضٌ من فترات قادمة. هذه الأسئلة تحول قائمة الدخل من لوحة نتائج إلى أدلة.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Comparing operating margins across companies without checking the by-nature/by-function presentation and where depreciation sits.', 'مقارنة الهوامش التشغيلية بين الشركات دون التحقق من طريقة العرض (طبيعة/وظيفة) وأين يقع الإهلاك.'),
    Bi('Reading revenue growth as health without asking about credit terms: sales pulled forward with generous terms show up later as receivables trouble.', 'قراءة نمو الإيراد بوصفه عافيةً دون السؤال عن شروط الائتمان: فالمبيعات المسحوبة مقدماً بشروط سخية تظهر لاحقاً متاعبَ في الذمم المدينة.'),
    Bi('Treating EBITDA as cash flow. It ignores working capital, capex, interest, and tax, all four of which are real cash.', 'التعامل مع EBITDA على أنه تدفق نقدي. فهو يتجاهل رأس المال العامل والإنفاق الرأسمالي والفوائد والضريبة، وكلها نقد حقيقي.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IAS 1 §81A–105',
      note: Bi('Structure and content of the statement of profit or loss; by-nature versus by-function presentation.', 'هيكل ومحتوى قائمة الربح أو الخسارة؛ والعرض حسب الطبيعة مقابل الوظيفة.'),
      segments: [
        KBStandardSegment('IAS 1', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-1-presentation-of-financial-statements/'),
        KBStandardSegment(' §81A–105'),
      ],
    ),
    KBStandardRef(
      standard: 'IFRS 15',
      note: Bi('Determines when the top line exists at all: the five-step revenue model.', 'يحدد متى يوجد السطر الأول أصلاً: نموذج الإيراد ذو الخطوات الخمس.'),
      segments: [
        KBStandardSegment('IFRS 15', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ifrs-15-revenue-from-contracts-with-customers/'),
      ],
    ),
    KBStandardRef(
      standard: 'IFRS 18 (effective 2027)',
      note: Bi('Will restructure the statement into operating, investing and financing categories with defined subtotals; worth tracking for any multi-year training content.', 'سيعيد هيكلة القائمة إلى فئات تشغيلية واستثمارية وتمويلية بمجاميع فرعية معرفة؛ يجدر تتبعه في أي محتوى تدريبي متعدد السنوات.'),
      segments: [
        KBStandardSegment('IFRS 18', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ifrs-18-presentation-and-disclosure-in-financial-statements/'),
        KBStandardSegment(' (effective 2027)'),
      ],
    ),
  ],
  relatedTerms: [
    'Income Statement',
    'Gross Profit',
    'Operating Profit',
    'EBITDA',
    'Net Income',
    'Revenue Recognition',
  ],
  relatedModules: [
    KBRelatedModule('/education/financial-statements', Bi('Module: Understanding Financial Statements', 'الوحدة: فهم القوائم المالية')),
    KBRelatedModule('/education/financial-analysis', Bi('Module: Analysis of Financial Statements', 'الوحدة: تحليل القوائم المالية')),
  ],
  relatedArticles: [
    'accrual-accounting',
    'balance-sheet',
    'cash-flow-statement',
    'financial-ratios',
    'revenue-recognition',
    'statement-analysis-case',
    'consolidation-goodwill',
    'provisions-contingencies',
    'valuation-multiples',
    'segment-reporting',
    'deferred-tax',
    'equity-and-oci',
    'discontinued-operations',
    'cost-accounting',
    'interim-reporting',
  ],
  references: [
    'IFRS Foundation. (2007). IAS 1 Presentation of financial statements. IFRS Foundation.',
    'IFRS Foundation. (2024). IFRS 18 Presentation and disclosure in financial statements. IFRS Foundation.',
    'Penman, S. H. (2013). Financial statement analysis and security valuation (5th ed.). McGraw-Hill.',
    'Kieso, D. E., Weygandt, J. J., & Warfield, T. D. (2020). Intermediate accounting: IFRS edition (4th ed.). Wiley.',
  ],
  keywords: [
    'income statement',
    'profit',
    'margins',
    'EBITDA',
    'by nature',
    'by function',
    'قائمة الدخل',
    'هامش',
    'مجمل الربح',
  ],
);
