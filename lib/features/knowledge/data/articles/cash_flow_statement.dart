// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/cash-flow-statement.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbCashFlowStatement = KBArticle(
  id: 'cash-flow-statement',
  title: Bi('The Statement of Cash Flows in Depth', 'قائمة التدفقات النقدية بعمق'),
  category: 'financial-statements',
  level: KBLevel.intermediate,
  readingMinutes: 6,
  summary: Bi('The three activities, the direct and indirect methods under IAS 7, a full indirect-method reconciliation you can reproduce, and how to read the pattern of signs across the three sections.', 'الأنشطة الثلاثة، والطريقتان المباشرة وغير المباشرة وفق المعيار IAS 7، وتسوية كاملة بالطريقة غير المباشرة يمكنك إعادة إنتاجها، وكيف تُقرأ إشارات الأقسام الثلاثة معاً.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('The statement of cash flows explains the change in cash and cash equivalents over the period by classifying every cash movement into one of three activities. Operating activities are the cash effects of the main revenue-producing activities. Investing activities are the acquisition and disposal of long-term assets and investments. Financing activities are changes in the size and composition of contributed equity and borrowings. The three subtotals must sum exactly to the change in the cash balance between two balance sheets: the statement is an articulation, not an opinion.', 'تفسر قائمة التدفقات النقدية التغير في النقد وما يعادله خلال الفترة عبر تصنيف كل حركة نقدية ضمن واحد من ثلاثة أنشطة. الأنشطة التشغيلية هي الآثار النقدية للأنشطة الرئيسة المولدة للإيراد. والأنشطة الاستثمارية هي اقتناء الأصول طويلة الأجل والاستثمارات والتصرف فيها. والأنشطة التمويلية هي التغيرات في حجم وتركيبة حقوق الملكية المساهم بها والاقتراض. ويجب أن يساوي مجموع الأقسام الثلاثة بالضبط التغير في رصيد النقد بين ميزانيتين: فالقائمة ترابطٌ حسابي، لا رأي.'),
        Bi('Why does a profitable company need this statement at all? Because accrual profit and cash generation can diverge for long stretches: revenue can sit in receivables, profit can be absorbed into inventory, and heavy capital expenditure never touches the income statement in the year it is paid. Analysts treat sustained divergence between operating cash flow and net income as one of the strongest early warnings in financial analysis.', 'لماذا تحتاج شركة رابحة إلى هذه القائمة أصلاً؟ لأن ربح الاستحقاق وتوليد النقد قد يفترقان لفترات طويلة: فقد يظل الإيراد حبيس الذمم المدينة، وقد يُمتص الربح في المخزون، والإنفاق الرأسمالي الكبير لا يمس قائمة الدخل في سنة دفعه. ويَعُدُّ المحللون الافتراق المستمر بين التدفق النقدي التشغيلي وصافي الدخل واحداً من أقوى إشارات الإنذار المبكر في التحليل المالي.'),
      ],
    ),
    KBSection(
      heading: Bi('The formal treatment: direct versus indirect', 'المعالجة النظرية: الطريقة المباشرة مقابل غير المباشرة'),
      paragraphs: [
        Bi('IAS 7 permits two presentations of operating cash flow. The direct method lists gross cash receipts and payments by class (cash received from customers, cash paid to suppliers and employees). The indirect method starts from profit or loss and adjusts it for non-cash items (depreciation, amortization, provisions), for items belonging to investing or financing (gains on disposals, finance costs presented elsewhere), and for changes in working capital. IAS 7 §19 encourages the direct method, but the indirect method dominates practice because it is produced from statements companies already prepare and because the reconciliation itself is analytically valuable: it shows exactly where profit went instead of becoming cash.', 'يسمح المعيار IAS 7 بعرضين للتدفق النقدي التشغيلي. الطريقة المباشرة تسرد المقبوضات والمدفوعات النقدية الإجمالية حسب فئتها (نقد مقبوض من العملاء، نقد مدفوع للموردين والعاملين). والطريقة غير المباشرة تبدأ من الربح أو الخسارة ثم تعدله بالبنود غير النقدية (الإهلاك، والإطفاء، والمخصصات)، وبالبنود العائدة للاستثمار أو التمويل (أرباح بيع الأصول، وتكاليف التمويل المعروضة في موضع آخر)، وبالتغيرات في رأس المال العامل. تشجع الفقرة 19 من IAS 7 على الطريقة المباشرة، لكن غير المباشرة هي السائدة عملياً لأنها تُعد مما تجهزه الشركات أصلاً، ولأن التسوية ذاتها ذات قيمة تحليلية: فهي تُظهر بالضبط أين ذهب الربح بدلاً من أن يصير نقداً.'),
        Bi('The working-capital adjustments follow one mechanical rule: an increase in an operating asset consumes cash (subtract); an increase in an operating liability releases cash (add). Receivables up means sales not yet collected. Inventory up means cash converted into stock. Payables up means suppliers financing you a little longer.', 'تتبع تسويات رأس المال العامل قاعدة آلية واحدة: زيادة الأصل التشغيلي تستهلك نقداً (تُطرح)؛ وزيادة الالتزام التشغيلي تحرر نقداً (تُضاف). ارتفاع الذمم المدينة يعني مبيعات لم تُحصَّل بعد. وارتفاع المخزون يعني نقداً تحول إلى بضاعة. وارتفاع الذمم الدائنة يعني أن الموردين يمولونك مدة أطول قليلاً.'),
      ],
      formulas: [
        KBFormula('CFO = Net income + Non-cash charges − Gains (+ Losses) on disposals − ΔReceivables − ΔInventory + ΔPayables', caption: Bi('Indirect-method skeleton. Δ means "increase in"; reverse the sign for decreases.', 'الهيكل العام للطريقة غير المباشرة. يعني الرمز Δ «الزيادة في»؛ وتُعكس الإشارة عند النقصان.')),
      ],
    ),
    KBSection(
      heading: Bi('Worked example: an indirect-method reconciliation', 'مثال محلول: تسوية بالطريقة غير المباشرة'),
      paragraphs: [
        Bi('A company reports net income of SAR 900,000. Depreciation for the year is SAR 300,000. It sold old equipment at a gain of SAR 50,000. Receivables rose by SAR 220,000, inventory fell by SAR 80,000, and payables rose by SAR 120,000. Build operating cash flow:', 'أبلغت شركة عن صافي دخل قدره 900,000 ريال. بلغ إهلاك السنة 300,000 ريال. وباعت معدات قديمة بربح 50,000 ريال. وارتفعت الذمم المدينة 220,000 ريال، وانخفض المخزون 80,000 ريال، وارتفعت الذمم الدائنة 120,000 ريال. لنبنِ التدفق النقدي التشغيلي:'),
      ],
      table: KBTable(
        headers: [
          Bi('Reconciliation line', 'بند التسوية'),
          Bi('SAR', 'ريال'),
          Bi('Why', 'السبب'),
        ],
        rows: [
          [
            Bi('Net income', 'صافي الدخل'),
            Bi('900,000', '900,000'),
            Bi('Starting point', 'نقطة البداية'),
          ],
          [
            Bi('+ Depreciation', '+ الإهلاك'),
            Bi('+300,000', '+300,000'),
            Bi('Expense that never left the bank', 'مصروف لم يغادر البنك أصلاً'),
          ],
          [
            Bi('− Gain on disposal', '− ربح بيع الأصول'),
            Bi('−50,000', '−50,000'),
            Bi('Cash from the sale belongs to investing', 'نقد البيع مكانه الأنشطة الاستثمارية'),
          ],
          [
            Bi('− Increase in receivables', '− الزيادة في الذمم المدينة'),
            Bi('−220,000', '−220,000'),
            Bi('Sales booked, cash not yet collected', 'مبيعات سُجلت ولم يُحصَّل نقدها بعد'),
          ],
          [
            Bi('+ Decrease in inventory', '+ النقص في المخزون'),
            Bi('+80,000', '+80,000'),
            Bi('Stock converted back into cash', 'مخزون عاد نقداً'),
          ],
          [
            Bi('+ Increase in payables', '+ الزيادة في الذمم الدائنة'),
            Bi('+120,000', '+120,000'),
            Bi('Suppliers financed the difference', 'مَوَّل الموردون الفرق'),
          ],
          [
            Bi('Cash flow from operations', 'التدفق النقدي من العمليات'),
            Bi('1,130,000', '1,130,000'),
            Bi('CFO exceeds profit here: a healthy sign', 'التدفق التشغيلي يتجاوز الربح هنا: علامة صحية'),
          ],
        ],
      ),
    ),
    KBSection(
      heading: Bi('Reading the pattern of signs', 'قراءة نمط الإشارات'),
      paragraphs: [
        Bi('The three subtotals form a signature. Mature healthy business: operating positive, investing negative (reinvestment), financing negative (dividends, debt repayment). Growth business: operating positive, investing strongly negative, financing positive (raising capital to fund growth). Distress: operating negative, investing positive (selling assets to survive), financing positive (borrowing to cover operations). No single period proves a diagnosis, but three or four consecutive periods of the distress signature rarely lie.', 'تشكل الأقسام الثلاثة بصمةً مميزة. الشركة الناضجة الصحية: تشغيلي موجب، واستثماري سالب (إعادة استثمار)، وتمويلي سالب (توزيعات وسداد ديون). وشركة النمو: تشغيلي موجب، واستثماري سالب بقوة، وتمويلي موجب (جمع رأسمال لتمويل النمو). والتعثر: تشغيلي سالب، واستثماري موجب (بيع أصول للبقاء)، وتمويلي موجب (اقتراض لتغطية التشغيل). لا تثبت فترة واحدة أي تشخيص، لكن ثلاث أو أربع فترات متتالية من بصمة التعثر نادراً ما تكذب.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Adding depreciation back and concluding "depreciation generates cash". It does not; the add-back only reverses a non-cash expense that was subtracted on the way to net income.', 'إضافة الإهلاك ثم استنتاج أن «الإهلاك يولد نقداً». هو لا يفعل؛ فالإضافة تعكس فحسب مصروفاً غير نقدي سبق طرحه في الطريق إلى صافي الدخل.'),
    Bi('Forgetting the interest and dividends classification choice. Under IAS 7, interest paid may appear in operating or financing; comparisons across companies must check the policy note first.', 'نسيان خيار تصنيف الفوائد والتوزيعات. بموجب IAS 7 قد تظهر الفوائد المدفوعة ضمن التشغيل أو التمويل؛ وأي مقارنة بين الشركات يجب أن تبدأ من الإيضاح الخاص بالسياسة.'),
    Bi('Judging a company on one strong operating cash flow figure that was produced by squeezing payables or delaying purchases: working-capital timing can flatter a single period.', 'الحكم على شركة من رقم تشغيلي قوي واحد نتج عن الضغط على الذمم الدائنة أو تأجيل المشتريات: فتوقيت رأس المال العامل قد يجمِّل فترة واحدة.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IAS 7',
      note: Bi('Statement of Cash Flows: the three-activity classification, direct/indirect choice (§18–20), and interest/dividend classification options (§31–34).', 'قائمة التدفقات النقدية: تصنيف الأنشطة الثلاثة، وخيار الطريقة المباشرة/غير المباشرة (الفقرات 18–20)، وخيارات تصنيف الفوائد والتوزيعات (الفقرات 31–34).'),
      segments: [
        KBStandardSegment('IAS 7', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-7-statement-of-cash-flows/'),
      ],
    ),
    KBStandardRef(
      standard: 'IPSAS 2',
      note: Bi('The public-sector equivalent of IAS 7, with the same three-activity structure.', 'المقابل في القطاع العام للمعيار IAS 7، بهيكل الأنشطة الثلاثة نفسه.'),
      segments: [
        KBStandardSegment('IPSAS 2', href: 'https://www.ipsasb.org/standards-pronouncements', viaIndex: true),
      ],
    ),
  ],
  relatedTerms: [
    'Cash Flow Statement',
    'Operating Cash Flow',
    'Free Cash Flow',
    'Working Capital',
    'Depreciation',
  ],
  relatedModules: [
    KBRelatedModule('/education/financial-statements', Bi('Module: Understanding Financial Statements', 'الوحدة: فهم القوائم المالية')),
    KBRelatedModule('/education/fundamentals', Bi('Module: Financial Management Primer', 'الوحدة: تمهيد الإدارة المالية')),
  ],
  relatedArticles: [
    'accrual-accounting',
    'working-capital',
    'income-statement',
    'depreciation-methods',
    'cash-flow-forecasting',
    'dividend-policy',
    'equity-and-oci',
    'earnings-quality',
    'borrowing-costs',
  ],
  references: [
    'IFRS Foundation. (2016). IAS 7 Statement of cash flows. IFRS Foundation.',
    'Kieso, D. E., Weygandt, J. J., & Warfield, T. D. (2020). Intermediate accounting: IFRS edition (4th ed.). Wiley.',
    'Penman, S. H. (2013). Financial statement analysis and security valuation (5th ed.). McGraw-Hill.',
    'International Public Sector Accounting Standards Board. (2000). IPSAS 2: Cash flow statements. IFAC.',
  ],
  keywords: [
    'cash flow',
    'IAS 7',
    'indirect method',
    'direct method',
    'operating activities',
    'تدفقات نقدية',
    'الطريقة غير المباشرة',
    'أنشطة تشغيلية',
  ],
);
