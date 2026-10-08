// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/accrual-accounting.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbAccrualAccounting = KBArticle(
  id: 'accrual-accounting',
  title: Bi('Accrual Accounting versus Cash Accounting', 'المحاسبة على أساس الاستحقاق مقابل الأساس النقدي'),
  category: 'accounting-foundations',
  level: KBLevel.foundation,
  readingMinutes: 6,
  summary: Bi('Why financial statements record economic events when they occur rather than when cash moves, what this assumption changes, and where cash-basis thinking still matters.', 'لماذا تسجل القوائم المالية الأحداث الاقتصادية عند وقوعها لا عند تحرك النقد، وما الذي يغيره هذا الافتراض، وأين يظل التفكير على الأساس النقدي مهماً.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('Accrual accounting recognizes transactions and events when they occur, not when cash is received or paid. A sale made on credit in December is December revenue, even if the customer pays in February. An electricity bill for December is a December expense, even if it is settled in January. The alternative, cash accounting, records only cash movements: nothing exists in the books until money changes hands.', 'تعترف المحاسبة على أساس الاستحقاق بالمعاملات والأحداث عند وقوعها، وليس عند قبض النقد أو دفعه. فالبيع الآجل في ديسمبر هو إيراد لشهر ديسمبر حتى لو سدد العميل في فبراير. وفاتورة الكهرباء عن ديسمبر هي مصروف لشهر ديسمبر حتى لو سُددت في يناير. أما البديل، وهو الأساس النقدي، فلا يسجل إلا حركة النقد: لا يوجد شيء في الدفاتر حتى ينتقل المال فعلاً.'),
        Bi('The intuition is simple: performance and cash are two different questions. "Did we create value this period?" is answered by matching the revenues earned with the expenses incurred to earn them. "Can we pay our bills?" is answered by the cash flow statement. Accrual accounting exists so that the first question gets an honest answer, and the cash flow statement exists so the second one does too.', 'الفكرة بسيطة: الأداء والنقد سؤالان مختلفان. سؤال «هل أنشأنا قيمة في هذه الفترة؟» تجيب عنه مقابلة الإيرادات المكتسبة بالمصروفات التي تُكبدت لاكتسابها. وسؤال «هل نستطيع سداد التزاماتنا؟» تجيب عنه قائمة التدفقات النقدية. وُجدت محاسبة الاستحقاق ليحصل السؤال الأول على إجابة أمينة، ووُجدت قائمة التدفقات النقدية ليحصل السؤال الثاني عليها أيضاً.'),
      ],
    ),
    KBSection(
      heading: Bi('The formal treatment', 'المعالجة النظرية'),
      paragraphs: [
        Bi('The IFRS Conceptual Framework names accrual accounting as the basis on which financial statements depict the effects of transactions: it "depicts the effects of transactions and other events and circumstances on a reporting entity\'s economic resources and claims in the periods in which those effects occur" (IFRS Foundation, 2018, §1.17). Two working principles operationalize it. Revenue recognition: revenue is recognized when the entity satisfies a performance obligation by transferring control of a good or service (IFRS 15\'s five-step model). Matching: expenses are recognized in the same period as the revenues they help generate, which is why inventory cost waits on the balance sheet as an asset until the goods are sold and then becomes cost of goods sold.', 'يسمي الإطار المفاهيمي للمعايير الدولية (IFRS) أساس الاستحقاق أساساً تُصوَّر به آثار المعاملات في القوائم المالية: فهو «يصوِّر آثار المعاملات والأحداث والظروف الأخرى على الموارد الاقتصادية للمنشأة والمطالبات عليها في الفترات التي تقع فيها تلك الآثار» (الإطار المفاهيمي، الفقرة 1-17). ويُفعَّل هذا الأساس بمبدأين عمليين. الاعتراف بالإيراد: يُعترف بالإيراد عندما تفي المنشأة بالتزام الأداء بنقل السيطرة على السلعة أو الخدمة (نموذج الخطوات الخمس في المعيار IFRS 15). والمقابلة: يُعترف بالمصروفات في الفترة نفسها التي تُعترف فيها الإيرادات التي ساعدت في توليدها، ولهذا تبقى تكلفة المخزون أصلاً في الميزانية حتى تُباع البضاعة فتتحول إلى تكلفة البضاعة المباعة.'),
        Bi('Accrual accounting creates four recurring account families that pure cash books never need: receivables (revenue earned, cash not yet received), payables and accrued liabilities (expense incurred, cash not yet paid), prepayments (cash paid, expense not yet incurred), and deferred or unearned revenue (cash received, revenue not yet earned). Every period-end adjustment an accountant makes is one of these four in motion.', 'تنشئ محاسبة الاستحقاق أربع عائلات متكررة من الحسابات لا تحتاجها الدفاتر النقدية البحتة: الذمم المدينة (إيراد مكتسب ولم يُقبض نقده بعد)، والذمم الدائنة والمصروفات المستحقة (مصروف مُتكبد ولم يُدفع نقده بعد)، والمصروفات المدفوعة مقدماً (نقد مدفوع ومصروف لم يُتكبد بعد)، والإيراد المؤجل أو غير المكتسب (نقد مقبوض وإيراد لم يُكتسب بعد). وكل تسوية يجريها المحاسب في نهاية الفترة هي واحدة من هذه الأربع وهي تتحرك.'),
      ],
    ),
    KBSection(
      heading: Bi('Worked example', 'مثال محلول'),
      paragraphs: [
        Bi('A training company delivers a SAR 120,000 program in December 2025. The client pays 50% in advance in November and the balance in February 2026. The trainers\' fees of SAR 40,000 for the December delivery are paid in January. Compare the two bases for December:', 'تنفذ شركة تدريب برنامجاً بقيمة 120,000 ريال في ديسمبر 2025. يدفع العميل 50% مقدماً في نوفمبر والباقي في فبراير 2026. وتُدفع أتعاب المدربين البالغة 40,000 ريال عن تنفيذ ديسمبر في يناير. قارن بين الأساسين لشهر ديسمبر:'),
      ],
      formulas: [
        KBFormula('Accrual profit = Revenue earned − Expenses incurred, regardless of cash timing', caption: Bi('The accrual result (SAR 80,000) describes December\'s performance; the cash result describes December\'s cash movements. Both are true; they answer different questions.', 'نتيجة الاستحقاق (80,000 ريال) تصف أداء ديسمبر؛ والنتيجة النقدية تصف حركة النقد في ديسمبر. كلتاهما صحيحة؛ لكنهما تجيبان عن سؤالين مختلفين.')),
      ],
      table: KBTable(
        headers: [
          Bi('December 2025', 'ديسمبر 2025'),
          Bi('Accrual basis', 'أساس الاستحقاق'),
          Bi('Cash basis', 'الأساس النقدي'),
        ],
        rows: [
          [
            Bi('Revenue', 'الإيراد'),
            Bi('SAR 120,000 (program delivered)', '120,000 ريال (نُفذ البرنامج)'),
            Bi('SAR 0 (November advance was recorded in November)', 'صفر (سُجلت دفعة نوفمبر في نوفمبر)'),
          ],
          [
            Bi('Expense', 'المصروف'),
            Bi('SAR 40,000 (trainers earned it in December)', '40,000 ريال (استحقها المدربون في ديسمبر)'),
            Bi('SAR 0 (paid in January)', 'صفر (دُفعت في يناير)'),
          ],
          [
            Bi('Profit for December', 'ربح ديسمبر'),
            Bi('SAR 80,000', '80,000 ريال'),
            Bi('SAR 0', 'صفر'),
          ],
        ],
      ),
    ),
    KBSection(
      heading: Bi('Why it matters for non-finance professionals', 'لماذا يهم هذا غير المتخصصين في المالية'),
      paragraphs: [
        Bi('Almost every misreading of financial statements by operational managers traces back to mixing the two bases. A profitable, fast-growing business can run out of cash because accrual profit races ahead of collections. A loss-making period can coincide with strong cash inflows when old receivables are collected. Budget holders who approve a purchase in December should expect it in December\'s results even if the invoice is paid in the new year. Reading profit and cash as one number is the single most common and most expensive confusion this knowledge base exists to remove.', 'تكاد كل قراءة خاطئة للقوائم المالية من المديرين التشغيليين ترجع إلى الخلط بين الأساسين. فقد ينفد النقد من شركة رابحة سريعة النمو لأن ربح الاستحقاق يسبق التحصيل. وقد تتزامن فترة خاسرة مع تدفقات نقدية داخلة قوية عند تحصيل ذمم قديمة. وعلى مالكي الميزانيات الذين يعتمدون شراءً في ديسمبر أن يتوقعوه في نتائج ديسمبر حتى لو سُددت الفاتورة في العام الجديد. إن قراءة الربح والنقد كرقم واحد هي أكثر أنواع الخلط شيوعاً وأغلاها ثمناً، وهذا ما وُجدت قاعدة المعرفة هذه لإزالته.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Treating profit as cash. Net income is an accrual construct; the company\'s ability to pay salaries next month lives in the cash flow statement.', 'التعامل مع الربح على أنه نقد. صافي الدخل بناء استحقاقي؛ أما قدرة الشركة على دفع الرواتب الشهر القادم فمكانها قائمة التدفقات النقدية.'),
    Bi('Assuming revenue means an invoice was issued. Under IFRS 15, recognition follows the transfer of control, which can be earlier or later than invoicing.', 'افتراض أن الإيراد يعني إصدار فاتورة. بموجب IFRS 15 يتبع الاعترافُ انتقالَ السيطرة، وقد يكون ذلك قبل الفوترة أو بعدها.'),
    Bi('Forgetting that period-end adjustments (accruals, prepayments, deferrals) are estimates. They are honest estimates, but they carry judgment, which is why auditors focus on them.', 'نسيان أن تسويات نهاية الفترة (الاستحقاقات، والمدفوعات المقدمة، والمؤجلات) تقديرات. هي تقديرات أمينة لكنها تنطوي على اجتهاد، ولهذا يركز المدققون عليها.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IFRS Conceptual Framework §1.17',
      note: Bi('Establishes accrual accounting as the basis for depicting financial performance.', 'يرسي أساس الاستحقاق أساساً لتصوير الأداء المالي.'),
      segments: [
        KBStandardSegment('IFRS Conceptual Framework', href: 'https://www.ifrs.org/issued-standards/list-of-standards/conceptual-framework/'),
        KBStandardSegment(' §1.17'),
      ],
    ),
    KBStandardRef(
      standard: 'IFRS 15',
      note: Bi('Revenue from Contracts with Customers: the five-step model that decides when revenue is recognized.', 'الإيراد من العقود مع العملاء: نموذج الخطوات الخمس الذي يحدد متى يُعترف بالإيراد.'),
      segments: [
        KBStandardSegment('IFRS 15', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ifrs-15-revenue-from-contracts-with-customers/'),
      ],
    ),
    KBStandardRef(
      standard: 'IPSAS 33',
      note: Bi('For the public sector: first-time adoption of accrual-basis IPSAS, the reform path many governments (including in the GCC) are on.', 'للقطاع العام: التطبيق الأول لمعايير IPSAS على أساس الاستحقاق، وهو مسار الإصلاح الذي تسلكه حكومات كثيرة (ومنها حكومات خليجية).'),
      segments: [
        KBStandardSegment('IPSAS 33', href: 'https://www.ipsasb.org/publications/ipsas-33-first-time-adoption-accrual-basis-ipsas-standards'),
      ],
    ),
  ],
  relatedTerms: [
    'Accrual Accounting',
    'Revenue Recognition',
    'Accounts Receivable',
    'Deferred Revenue',
    'Matching Principle',
  ],
  relatedModules: [
    KBRelatedModule('/education/financial-statements', Bi('Module: Understanding Financial Statements', 'الوحدة: فهم القوائم المالية')),
  ],
  relatedArticles: [
    'income-statement',
    'cash-flow-statement',
    'ifrs-vs-ipsas',
    'depreciation-methods',
    'revenue-recognition',
    'provisions-contingencies',
    'employee-benefits',
    'earnings-quality',
  ],
  references: [
    'IFRS Foundation. (2018). Conceptual framework for financial reporting. IFRS Foundation.',
    'IFRS Foundation. (2014). IFRS 15 Revenue from contracts with customers. IFRS Foundation.',
    'Kieso, D. E., Weygandt, J. J., & Warfield, T. D. (2020). Intermediate accounting: IFRS edition (4th ed.). Wiley.',
    'International Public Sector Accounting Standards Board. (2015). IPSAS 33: First-time adoption of accrual basis IPSASs. IFAC.',
  ],
  keywords: [
    'accrual',
    'cash basis',
    'matching',
    'recognition',
    'استحقاق',
    'أساس نقدي',
    'مقابلة',
    'اعتراف',
  ],
);
