// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/cash-flow-forecasting.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbCashFlowForecasting = KBArticle(
  id: 'cash-flow-forecasting',
  title: Bi('Cash Flow Forecasting and Liquidity Management', 'التنبؤ بالتدفقات النقدية وإدارة السيولة'),
  category: 'financial-analysis',
  level: KBLevel.intermediate,
  readingMinutes: 6,
  summary: Bi('The 13-week direct forecast that keeps companies alive, the driver-based indirect forecast that guides strategy, the variance discipline that makes both trustworthy, and the liquidity buffer question.', 'تنبؤ الثلاثة عشر أسبوعاً المباشر الذي يبقي الشركات حية، والتنبؤ غير المباشر القائم على المحركات الذي يوجه الاستراتيجية، وانضباط الانحرافات الذي يجعلهما جديرين بالثقة، وسؤال وسادة السيولة.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('Companies do not fail when they run out of profit; they fail when they run out of cash on a Thursday with salaries due on Sunday. Cash flow forecasting is the discipline of seeing that Thursday early enough to act. It answers three questions on three horizons: can we pay what is due in the next days and weeks (operational), will we need the credit line or have surplus to place in the next quarters (tactical), and does the business model generate or consume cash across years (strategic)? Different horizons need different methods, which is why treasury teams run two forecasts, not one.', 'لا تسقط الشركات حين ينفد ربحها؛ بل حين ينفد نقدها يوم خميس والرواتب مستحقة يوم الأحد. والتنبؤ بالتدفقات هو انضباط رؤية ذلك الخميس مبكراً بما يكفي للتصرف. وهو يجيب عن ثلاثة أسئلة على ثلاثة آفاق: هل نستطيع دفع المستحق في الأيام والأسابيع القادمة (تشغيلي)، وهل سنحتاج خط الائتمان أم سيفيض لدينا ما يُوظف في الأرباع القادمة (تكتيكي)، وهل يولد نموذج الأعمال نقداً أم يستهلكه عبر السنين (استراتيجي)؟ والآفاق المختلفة تحتاج طرقاً مختلفة، ولهذا تدير فرق الخزانة تنبؤين لا واحداً.'),
      ],
    ),
    KBSection(
      heading: Bi('The 13-week direct forecast', 'تنبؤ الثلاثة عشر أسبوعاً المباشر'),
      paragraphs: [
        Bi('The workhorse of liquidity management is a rolling 13-week schedule of expected receipts and payments, week by week, built directly from operational sources: the receivables ledger with realistic collection timing (not due dates: actual payment behavior), confirmed sales orders, the payables ledger, payroll, rent, loan service, tax and Zakat dates, and committed capital spending. Each line is dated cash, not accounting revenue or expense. The bottom line per week is the projected closing balance against available facilities; any week that dips near zero is an action trigger with weeks of warning instead of days. The forecast rolls: every week, the completed week drops off, a new week 13 is added, and actuals are compared to what was forecast.', 'حصان الشغل في إدارة السيولة جدول متدحرج لثلاثة عشر أسبوعاً بالمقبوضات والمدفوعات المتوقعة، أسبوعاً بأسبوع، يُبنى مباشرة من المصادر التشغيلية: دفتر الذمم المدينة بتوقيت تحصيل واقعي (لا تواريخ الاستحقاق: سلوك السداد الفعلي)، وأوامر البيع المؤكدة، ودفتر الذمم الدائنة، والرواتب، والإيجار، وخدمة القروض، ومواعيد الضريبة والزكاة، والإنفاق الرأسمالي الملتزم به. كل بند نقد مؤرخ، لا إيراد محاسبي ولا مصروف. والسطر الأخير لكل أسبوع هو الرصيد الختامي المتوقع مقابل التسهيلات المتاحة؛ وأي أسبوع يقترب من الصفر زنادُ تصرف بأسابيع من الإنذار بدل أيام. والتنبؤ يتدحرج: كل أسبوع يسقط الأسبوع المكتمل، ويضاف أسبوع 13 جديد، وتقارن الفعليات بما كان متوقعاً.'),
        Bi('That last habit is what separates a forecast from a wish. Weekly variance review (forecast versus actual, line by line) exposes systematic bias: collections forecast on due dates instead of behavior, "confirmed" sales that slip, seasonal patterns nobody encoded. Within a quarter of honest variance reviews, most 13-week forecasts become accurate enough to run a company on.', 'تلك العادة الأخيرة هي الفاصل بين التنبؤ والتمني. فمراجعة الانحرافات أسبوعياً (المتوقع مقابل الفعلي بنداً بنداً) تكشف الانحياز المنهجي: تحصيلات قُدرت على تواريخ الاستحقاق لا السلوك، ومبيعات «مؤكدة» تنزلق، وأنماط موسمية لم يرمزها أحد. وخلال ربع سنة من مراجعات أمينة تصبح معظم تنبؤات الثلاثة عشر أسبوعاً دقيقة بما يكفي لإدارة شركة عليها.'),
      ],
    ),
    KBSection(
      heading: Bi('The driver-based indirect forecast', 'التنبؤ غير المباشر القائم على المحركات'),
      paragraphs: [
        Bi('For horizons beyond a quarter, line-by-line cash listing becomes fiction; the method switches to indirect: start from the profit plan, convert to cash with the working-capital drivers. The machinery is the ratio set worn in reverse: if the plan says revenue grows 20% and DSO stays at 60 days, receivables must grow with revenue and that growth is cash consumed; the same for inventory via DIO and payables via DPO; subtract capital expenditure and loan service. This is why growth companies with healthy profits show years of negative free cash flow, and the indirect forecast makes that visible before the funding gap arrives. A useful one-line summary of the mechanics: cash need from growth ≈ (CCC ÷ 365) × incremental revenue.', 'لآفاق تتجاوز ربع السنة يصير السرد النقدي بنداً بنداً خيالاً؛ فتتحول الطريقة إلى غير المباشرة: ابدأ من خطة الربح وحولها نقداً بمحركات رأس المال العامل. والآلية هي مجموعة النسب مرتديةً بالمقلوب: إذا قالت الخطة إن الإيراد ينمو 20% وفترة التحصيل تبقى 60 يوماً، فلا بد أن تنمو الذمم المدينة مع الإيراد وذلك النمو نقدٌ مستهلك؛ وكذلك المخزون عبر فترة بقائه والذمم الدائنة عبر فترة سدادها؛ ثم اطرح الإنفاق الرأسمالي وخدمة القروض. ولهذا تعرض شركات النمو ذات الأرباح الصحية سنوات من التدفق الحر السالب، والتنبؤ غير المباشر يجعل ذلك مرئياً قبل وصول فجوة التمويل. وخلاصة سطرية مفيدة للآلية: حاجة النقد من النمو ≈ (دورة التحول النقدي ÷ 365) × الإيراد الإضافي.'),
      ],
      formulas: [
        KBFormula('Cash need from growth ≈ (CCC ÷ 365) × ΔRevenue', caption: Bi('The working-capital cash a revenue increase consumes at an unchanged cash conversion cycle.', 'نقد رأس المال العامل الذي تستهلكه زيادة الإيراد عند دورة تحول نقدي ثابتة.')),
      ],
    ),
    KBSection(
      heading: Bi('The buffer question', 'سؤال الوسادة'),
      paragraphs: [
        Bi('Forecasts are distributions pretending to be lines, so liquidity management ends with a sizing decision: how much cash and committed, undrawn facility should stand between the company and its forecast error? The professional approach stresses the forecast (largest customer pays 30 days late; revenue falls 15%; a facility is not renewed) and holds a buffer that survives the combination the board agrees to survive. Two structural notes complete the picture: committed lines differ from uncommitted ones exactly on the day you need them, and groups concentrate balances (cash pooling, a treasury single account in government) so one entity’s surplus funds another’s deficit instead of both paying the bank.', 'التنبؤات توزيعات تتنكر خطوطاً، فتنتهي إدارة السيولة بقرار تحجيم: كم من النقد والتسهيلات الملتزم بها غير المسحوبة يجب أن يقف بين الشركة وخطأ تنبئها؟ والنهج المهني يجهد التنبؤ (أكبر عميل يتأخر ثلاثين يوماً؛ الإيراد يهبط 15%؛ تسهيل لا يُجدد) ويحتفظ بوسادة تنجو من التوليفة التي يقرر المجلس النجاة منها. وملاحظتان هيكليتان تكملان الصورة: الخطوط الملتزم بها تختلف عن غير الملتزم بها بالضبط في اليوم الذي تحتاجها فيه، والمجموعات تركز الأرصدة (تجميع النقد، وحساب الخزانة الموحد في الحكومة) ليمول فائضُ كيانٍ عجزَ آخر بدل أن يدفع كلاهما للبنك.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Forecasting collections on invoice due dates. Customers pay on their behavior, not your terms; use observed payment patterns.', 'تقدير التحصيل على تواريخ استحقاق الفواتير. العملاء يدفعون على سلوكهم لا على شروطك؛ استخدم أنماط السداد الملحوظة.'),
    Bi('Building the forecast and never reviewing variances. An unreviewed forecast keeps its biases forever.', 'بناء التنبؤ دون مراجعة الانحرافات أبداً. التنبؤ غير المراجَع يحتفظ بانحيازاته إلى الأبد.'),
    Bi('Confusing profit planning with cash planning in growth phases: the faster the growth, the wider the gap between the two.', 'الخلط بين تخطيط الربح وتخطيط النقد في مراحل النمو: كلما تسارع النمو اتسعت الفجوة بينهما.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IAS 7 §50',
      note: Bi('Encourages disclosure of undrawn borrowing facilities: the external mirror of the internal buffer decision.', 'يشجع الإفصاح عن التسهيلات غير المسحوبة: المرآة الخارجية لقرار الوسادة الداخلي.'),
      segments: [
        KBStandardSegment('IAS 7', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-7-statement-of-cash-flows/'),
        KBStandardSegment(' §50'),
      ],
    ),
    KBStandardRef(
      standard: 'IFRS 7 §39',
      note: Bi('Requires a maturity analysis of financial liabilities and a description of how liquidity risk is managed.', 'يتطلب تحليل استحقاق الالتزامات المالية ووصف كيفية إدارة مخاطر السيولة.'),
      segments: [
        KBStandardSegment('IFRS 7', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ifrs-7-financial-instruments-disclosures/'),
        KBStandardSegment(' §39'),
      ],
    ),
  ],
  relatedTerms: [
    'Liquidity',
    'Free Cash Flow',
    'Cash Conversion Cycle (CCC)',
  ],
  relatedModules: [
    KBRelatedModule('/education/fundamentals', Bi('Module: Financial Management Primer (Operating pillar)', 'الوحدة: تمهيد الإدارة المالية (ركيزة التشغيل)')),
  ],
  relatedArticles: [
    'cash-flow-statement',
    'working-capital',
    'budgeting-variance',
    'dcf-valuation',
    'government-cash-management',
    'credit-analysis',
  ],
  references: [
    'Brealey, R. A., Myers, S. C., & Allen, F. (2020). Principles of corporate finance (13th ed.). McGraw-Hill.',
    'Association for Financial Professionals. (2022). AFP guide to cash flow forecasting. AFP.',
    'IFRS Foundation. (2016). IAS 7 Statement of cash flows; IFRS 7 Financial instruments: Disclosures. IFRS Foundation.',
  ],
  keywords: [
    'cash forecast',
    '13-week',
    'liquidity',
    'treasury',
    'rolling forecast',
    'buffer',
    'تنبؤ نقدي',
    'سيولة',
    'خزانة',
    'ثلاثة عشر أسبوعاً',
  ],
);
