// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/working-capital.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbWorkingCapital = KBArticle(
  id: 'working-capital',
  title: Bi('Working Capital and the Cash Conversion Cycle', 'رأس المال العامل ودورة التحول النقدي'),
  category: 'financial-analysis',
  level: KBLevel.intermediate,
  readingMinutes: 5,
  summary: Bi('Why growth consumes cash, how the cash conversion cycle quantifies it in days, and the operating levers (receivables, inventory, payables) that finance and operations share.', 'لماذا يستهلك النمو نقداً، وكيف تقيس دورة التحول النقدي ذلك بالأيام، وما أذرع التشغيل (الذمم المدينة والمخزون والذمم الدائنة) التي تتشاركها المالية والعمليات.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('Working capital is current assets minus current liabilities: the net short-term resources tied up in running the operating cycle. The operating intuition is a loop: cash buys inventory, inventory becomes a sale, the sale becomes a receivable, and the receivable becomes cash again. Every day a riyal spends inside that loop is a day it cannot be used elsewhere, and every riyal of sales growth drags a proportional riyal of loop financing with it. This is why fast-growing profitable companies are chronically short of cash.', 'رأس المال العامل هو الأصول المتداولة ناقص الالتزامات المتداولة: صافي الموارد قصيرة الأجل المحتجزة في تشغيل الدورة التشغيلية. والفكرة التشغيلية حلقة: النقد يشتري مخزوناً، والمخزون يصير بيعاً، والبيع يصير ذمة مدينة، والذمة تعود نقداً. وكل يوم يقضيه الريال داخل تلك الحلقة يومٌ لا يمكن استخدامه فيه في مكان آخر، وكل ريال من نمو المبيعات يجر معه ريالاً متناسباً من تمويل الحلقة. ولهذا تعاني الشركات الرابحة سريعة النمو شحاً نقدياً مزمناً.'),
      ],
    ),
    KBSection(
      heading: Bi('The formal treatment: the cycle in days', 'المعالجة النظرية: الدورة بالأيام'),
      paragraphs: [
        Bi('Three ratios convert balance-sheet stocks into days of flow. Days sales outstanding (DSO) measures how long customers take to pay. Days inventory outstanding (DIO) measures how long stock sits before it is sold. Days payables outstanding (DPO) measures how long the company takes to pay suppliers. The cash conversion cycle nets them: CCC = DSO + DIO − DPO, the number of days between paying for inputs and collecting from customers. A shorter cycle means the operation finances itself sooner; a negative cycle (large retailers collecting cash today and paying suppliers in 60 days) means customers and suppliers finance the business.', 'ثلاث نسب تحول أرصدة الميزانية إلى أيام تدفق. فترة تحصيل الذمم المدينة (DSO) تقيس كم يستغرق العملاء للسداد. وفترة بقاء المخزون (DIO) تقيس كم تمكث البضاعة قبل بيعها. وفترة سداد الذمم الدائنة (DPO) تقيس كم تستغرق الشركة لسداد مورديها. وتجمعها دورة التحول النقدي صافيةً: CCC = DSO + DIO − DPO، أي عدد الأيام بين الدفع للمدخلات والتحصيل من العملاء. الدورة الأقصر تعني أن التشغيل يمول نفسه أبكر؛ والدورة السالبة (كبار تجار التجزئة يقبضون اليوم ويدفعون لمورديهم بعد 60 يوماً) تعني أن العملاء والموردين يمولون الأعمال.'),
      ],
      formulas: [
        KBFormula('DSO = Receivables ÷ Revenue × 365    ·    DIO = Inventory ÷ COGS × 365    ·    DPO = Payables ÷ COGS × 365', caption: Bi('The three component ratios (period averages are preferable to closing balances when activity is seasonal).', 'النسب المكونة الثلاث (يُفضل متوسط الفترة على أرصدة الإقفال عندما يكون النشاط موسمياً).')),
        KBFormula('CCC = DSO + DIO − DPO', caption: Bi('Cash conversion cycle: days of operating activity the company must finance.', 'دورة التحول النقدي: أيام النشاط التشغيلي التي يجب على الشركة تمويلها.')),
      ],
    ),
    KBSection(
      heading: Bi('Worked example: the cost of 10 days', 'مثال محلول: كلفة عشرة أيام'),
      paragraphs: [
        Bi('A distributor has revenue of SAR 36.5m, COGS of SAR 29.2m, receivables of SAR 6.0m, inventory of SAR 4.0m and payables of SAR 3.2m. DSO = 6.0 ÷ 36.5 × 365 = 60 days; DIO = 4.0 ÷ 29.2 × 365 = 50 days; DPO = 3.2 ÷ 29.2 × 365 = 40 days; CCC = 60 + 50 − 40 = 70 days. Cutting DSO by 10 days (tighter credit control, no price change) releases roughly 10 ÷ 365 × 36.5m = SAR 1.0m of cash, once and permanently, at zero margin cost. Compare that with how much extra revenue would be needed to add SAR 1.0m of cash through profit, and the case for working-capital discipline makes itself.', 'موزع إيراده 36.5 مليون ريال، وتكلفة مبيعاته 29.2 مليوناً، وذممه المدينة 6.0 ملايين، ومخزونه 4.0 ملايين، وذممه الدائنة 3.2 ملايين. DSO = 6.0 ÷ 36.5 × 365 = 60 يوماً؛ وDIO = 4.0 ÷ 29.2 × 365 = 50 يوماً؛ وDPO = 3.2 ÷ 29.2 × 365 = 40 يوماً؛ وCCC = 60 + 50 − 40 = 70 يوماً. خفضُ DSO عشرة أيام (ضبط ائتماني أدق دون تغيير سعر) يحرر نحو 10 ÷ 365 × 36.5 مليوناً = 1.0 مليون ريال نقداً، مرة واحدة وبشكل دائم وبكلفة هامش صفرية. قارن ذلك بحجم الإيراد الإضافي اللازم لإضافة مليون ريال نقداً عبر الربح، وستجد أن قضية انضباط رأس المال العامل تدافع عن نفسها.'),
      ],
    ),
    KBSection(
      heading: Bi('The levers and their owners', 'الأذرع وملاكها'),
      paragraphs: [
        Bi('Working capital is the clearest case of finance being everyone\'s job. Sales owns credit terms and collection discipline (DSO). Operations and procurement own stock levels and lead times (DIO). Procurement and treasury own payment terms (DPO), where stretching too far damages supplier pricing and reliability. The financial manager\'s task is to make the trade-offs explicit: every relaxation of terms is a loan the company is silently extending, and every buffer of stock is an investment that must earn its keep.', 'رأس المال العامل أوضح مثال على أن المالية مهمة الجميع. فالمبيعات تملك شروط الائتمان وانضباط التحصيل (DSO). والعمليات والمشتريات تملكان مستويات المخزون وآجال التوريد (DIO). والمشتريات والخزانة تملكان شروط السداد (DPO) حيث يضر الإفراط في التمديد بأسعار الموردين وموثوقيتهم. ومهمة المدير المالي أن يجعل المفاضلات صريحة: فكل تيسير في الشروط قرضٌ تمنحه الشركة بصمت، وكل مخزون احتياطي استثمارٌ عليه أن يبرر كلفته.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Judging working capital by the current ratio alone: a rising ratio driven by swelling inventory is deterioration dressed as safety.', 'الحكم على رأس المال العامل بنسبة التداول وحدها: فارتفاع النسبة بفعل تضخم المخزون تدهورٌ يرتدي ثوب الأمان.'),
    Bi('Comparing DSO across businesses with different revenue models (cash retail versus contract B2B) as if the benchmark were universal.', 'مقارنة DSO بين أعمال بنماذج إيراد مختلفة (تجزئة نقدية مقابل عقود بين الشركات) كأن المعيار واحد للجميع.'),
    Bi('Window-dressing at period end: delaying payments or factoring receivables just before the reporting date changes the photo, not the film.', 'التجميل في نهاية الفترة: تأخير المدفوعات أو بيع الذمم قبيل تاريخ التقرير يغير الصورة لا الشريط.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IAS 1 §60–76',
      note: Bi('The current/non-current classification on which every working-capital measure rests.', 'تصنيف المتداول/غير المتداول الذي تقوم عليه كل مقاييس رأس المال العامل.'),
      segments: [
        KBStandardSegment('IAS 1', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-1-presentation-of-financial-statements/'),
        KBStandardSegment(' §60–76'),
      ],
    ),
    KBStandardRef(
      standard: 'IAS 2',
      note: Bi('Inventory measurement (lower of cost and net realizable value) - the accounting floor under DIO.', 'قياس المخزون (الأقل من التكلفة وصافي القيمة القابلة للتحقق) - الأساس المحاسبي تحت DIO.'),
      segments: [
        KBStandardSegment('IAS 2', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-2-inventories/'),
      ],
    ),
  ],
  relatedTerms: [
    'Working Capital',
    'Cash Conversion Cycle (CCC)',
    'Accounts Receivable',
    'Inventory',
    'Current Ratio',
  ],
  relatedModules: [
    KBRelatedModule('/education/fundamentals', Bi('Module: Financial Management Primer (Operating pillar)', 'الوحدة: تمهيد الإدارة المالية (ركيزة التشغيل)')),
    KBRelatedModule('/education/financial-analysis', Bi('Module: Analysis of Financial Statements', 'الوحدة: تحليل القوائم المالية')),
  ],
  relatedArticles: [
    'balance-sheet',
    'cash-flow-statement',
    'financial-ratios',
    'cash-flow-forecasting',
    'statement-analysis-case',
    'financial-instruments',
    'government-cash-management',
  ],
  references: [
    'Brealey, R. A., Myers, S. C., & Allen, F. (2020). Principles of corporate finance (13th ed.). McGraw-Hill.',
    'Ross, S. A., Westerfield, R. W., & Jordan, B. D. (2022). Fundamentals of corporate finance (13th ed.). McGraw-Hill.',
    'IFRS Foundation. (2003). IAS 2 Inventories. IFRS Foundation.',
  ],
  keywords: [
    'working capital',
    'cash conversion cycle',
    'DSO',
    'DIO',
    'DPO',
    'liquidity',
    'رأس المال العامل',
    'دورة التحول النقدي',
    'سيولة',
  ],
);
