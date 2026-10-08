// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/government-cash-management.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbGovernmentCashManagement = KBArticle(
  id: 'government-cash-management',
  title: Bi('Government Cash Management and the Treasury Single Account', 'إدارة النقد الحكومي والحساب الموحد للخزانة'),
  category: 'public-sector',
  level: KBLevel.intermediate,
  readingMinutes: 8,
  summary: Bi('Why a government can hold billions and still borrow, how a treasury single account consolidates idle balances, the forecasting and commitment controls that prevent arrears, and a worked cost of fragmentation.', 'لماذا قد تحتفظ حكومة بالمليارات وتقترض رغم ذلك، وكيف يوحّد الحساب الموحد للخزانة الأرصدة الخاملة، وضوابط التنبؤ والارتباط التي تمنع المتأخرات، وحساب محلول لكلفة التشتت.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('A budget says what a government intends to spend over a year. Cash management is the entirely separate discipline of making sure the money is in the right account on the day a payment falls due. The two are easy to confuse and very different in practice: an appropriation is legal authority to spend, not cash in hand, and a ministry can hold a fully approved budget line and still be unable to pay a supplier this week. The classic failure is fragmentation. Where every ministry, agency and project keeps its own bank accounts, the state as a whole can be sitting on very large idle balances scattered across dozens of banks while the treasury issues short-term debt to cover a deficit elsewhere, paying interest to borrow money it already owns. The remedy is consolidation: one view, and ideally one account structure, over all public money.', 'الموازنة تقول ما تنوي الحكومة إنفاقه خلال سنة. أما إدارة النقد فتخصص منفصل تماماً غايته ضمان وجود المال في الحساب الصحيح يوم استحقاق الدفع. ويسهل الخلط بينهما مع اختلافهما الشديد عملياً: فالاعتماد سلطة قانونية للإنفاق لا نقد في اليد، وقد تحمل وزارة بند موازنة معتمداً بالكامل وتعجز رغم ذلك عن سداد مورد هذا الأسبوع. والإخفاق الكلاسيكي هو التشتت. فحيث تحتفظ كل وزارة وجهة ومشروع بحساباتها المصرفية، قد تجلس الدولة ككل على أرصدة خاملة ضخمة موزعة على عشرات البنوك بينما تصدر الخزانة ديناً قصير الأجل لتغطية عجز في مكان آخر، فتدفع فائدة لتقترض مالاً تملكه أصلاً. والعلاج هو التوحيد: رؤية واحدة، ويفضَّل هيكل حساب واحد، على كل المال العام.'),
      ],
    ),
    KBSection(
      heading: Bi('The formal treatment: the TSA and the controls around it', 'المعالجة النظرية: الحساب الموحد والضوابط حوله'),
      paragraphs: [
        Bi('A treasury single account is a unified structure of government bank accounts, usually held at the central bank, that gives a consolidated view of and control over all government cash resources. It need not be one physical account: the common design is a main account with subsidiary ledger accounts for each spending unit, swept to zero daily so balances consolidate while each unit still tracks its own position. Three benefits follow directly. Idle balances stop financing individual banks and start offsetting the state’s own borrowing need. The treasury can see the whole cash position daily rather than reconstructing it monthly. And unauthorized accounts, which are where leakage tends to happen, become visible by exception. Around the account sit three controls that decide whether it works. Cash forecasting projects inflows and outflows over a rolling horizon, typically weekly for a quarter and monthly for a year, and is only as good as the revenue and payment data feeding it. Commitment controls stop a spending unit entering an obligation it has no cash plan to honour, which is the single most effective defence against arrears. And a cash plan, agreed with spending units and revised as forecasts move, converts the annual budget into a schedule of releases rather than a race to spend. Where these are weak, governments accumulate arrears to suppliers, which is borrowing from the private sector at an unrecorded and usually punitive implicit rate.', 'الحساب الموحد للخزانة هيكل موحد لحسابات الحكومة المصرفية، يُحتفظ به عادةً لدى البنك المركزي، ويمنح رؤية موحدة لموارد النقد الحكومية كلها وسيطرة عليها. ولا يلزم أن يكون حساباً مادياً واحداً: فالتصميم الشائع حساب رئيس مع حسابات دفترية فرعية لكل وحدة إنفاق، تُكنس إلى الصفر يومياً فتتجمع الأرصدة ويظل كل وحدة تتابع مركزها. وتتبع ذلك ثلاث منافع مباشرة. تتوقف الأرصدة الخاملة عن تمويل بنوك بعينها وتبدأ في مقاصة حاجة الدولة نفسها إلى الاقتراض. وتستطيع الخزانة رؤية المركز النقدي كاملاً يومياً بدل إعادة تركيبه شهرياً. وتصير الحسابات غير المصرح بها، وهي موضع التسرب عادةً، مرئية بالاستثناء. وحول الحساب تقف ثلاثة ضوابط تقرر نجاحه. التنبؤ النقدي يسقط التدفقات الداخلة والخارجة على أفق متدحرج، عادةً أسبوعياً لربع وشهرياً لسنة، وجودته من جودة بيانات الإيراد والدفع التي تغذيه. وضوابط الارتباط تمنع وحدة إنفاق من الدخول في التزام لا خطة نقدية لديها للوفاء به، وهي أنجع دفاع منفرد ضد المتأخرات. والخطة النقدية، المتفق عليها مع وحدات الإنفاق والمنقحة مع تحرك التنبؤات، تحول الموازنة السنوية إلى جدول إفراجات بدل سباق على الإنفاق. وحيث تضعف هذه، تراكم الحكومات متأخرات لمورديها، وهو اقتراض من القطاع الخاص بمعدل ضمني غير مسجل وعقابي عادةً.'),
      ],
      formulas: [
        KBFormula('Carry cost of fragmentation = Idle balances × (Government borrowing rate − Rate earned on those balances)', caption: Bi('The recurring cost of holding cash outside a consolidated account while borrowing elsewhere.', 'الكلفة المتكررة للاحتفاظ بنقد خارج حساب موحد مع الاقتراض في مكان آخر.')),
      ],
    ),
    KBSection(
      heading: Bi('Worked example: what fragmentation costs', 'مثال محلول: كم يكلف التشتت'),
      paragraphs: [
        Bi('Suppose ministries and agencies collectively hold SAR 8bn in commercial bank accounts, earning an average 2%, while the treasury funds a temporary deficit by issuing short-term paper at 5.5%. The state earns SAR 160m on those balances and pays SAR 440m on the equivalent borrowing, so fragmentation costs 8,000 × (5.5% − 2.0%) = SAR 280m a year for nothing at all. No service improves, no asset is built, and the loss does not appear as a line item anywhere: it is spread across interest expense in one place and forgone offset in another. Consolidating those balances into a treasury single account removes the borrowing need altogether while the balances persist. Two caveats keep the arithmetic honest. Some balances are genuinely committed within days and cannot be swept indefinitely, so the realizable saving is smaller than the gross figure. And moving deposits out of commercial banks withdraws liquidity from the banking system, which is why treasuries coordinate the transition with the central bank rather than executing it overnight.', 'افترض أن الوزارات والجهات تحتفظ مجتمعةً بثمانية مليارات ريال في حسابات مصارف تجارية بعائد متوسط 2%، بينما تموّل الخزانة عجزاً مؤقتاً بإصدار أوراق قصيرة الأجل بمعدل 5.5%. فتكسب الدولة 160 مليون ريال على تلك الأرصدة وتدفع 440 مليوناً على الاقتراض المكافئ، فيكلف التشتت 8,000 × (5.5% − 2.0%) = 280 مليون ريال سنوياً مقابل لا شيء إطلاقاً. فلا خدمة تتحسن ولا أصل يُبنى، ولا تظهر الخسارة بنداً في أي مكان: بل تتوزع بين مصروف فائدة هنا ومقاصة فائتة هناك. وتوحيد تلك الأرصدة في حساب موحد للخزانة يزيل الحاجة إلى الاقتراض كلياً ما دامت الأرصدة قائمة. ويحفظ تحفظان أمانة الحساب. فبعض الأرصدة مرتبط فعلاً خلال أيام ولا يمكن كنسه إلى ما لا نهاية، فالوفر القابل للتحقق أصغر من الرقم الإجمالي. ونقلُ الودائع من المصارف التجارية يسحب سيولة من الجهاز المصرفي، ولهذا تنسق الخزانات التحول مع البنك المركزي بدل تنفيذه بين ليلة وضحاها.'),
      ],
    ),
    KBSection(
      heading: Bi('Where it sits in the reform agenda', 'موقعه في أجندة الإصلاح'),
      paragraphs: [
        Bi('Cash management reform tends to arrive as part of a wider public financial management programme, and it is usually sequenced alongside the move to accrual accounting, because both depend on the same underlying capability: knowing what is owed and owing, when, across the whole of government. In Saudi Arabia, the completed Fiscal Sustainability Program listed among its achievements the groundwork for a unified treasury account and the transition toward accrual accounting, which is the standard pairing. Assessment frameworks treat the two as linked as well: PEFA scores predictability and control in budget execution, including cash forecasting and the consolidation of cash balances, as a distinct pillar from budget preparation. For a professional working inside this, the practical measures of success are unglamorous and unambiguous. Is the daily consolidated cash position known? Are commitments recorded before an obligation is incurred rather than when the invoice arrives? Is the stock of supplier arrears measured, published and falling? A government that can answer those three has functioning cash management, whatever its accounting basis; one that cannot will keep generating arrears no matter how good its budget documents look.', 'يأتي إصلاح إدارة النقد عادةً ضمن برنامج أوسع للإدارة المالية العامة، ويُرتَّب غالباً بالتوازي مع الانتقال إلى محاسبة الاستحقاق، لأن كليهما يعتمد على القدرة الأساسية نفسها: معرفة ما لك وما عليك، ومتى، على مستوى الحكومة كلها. وفي السعودية، أدرج برنامج الاستدامة المالية المكتمل ضمن إنجازاته التمهيد لحساب موحد للخزانة والتحول نحو محاسبة الاستحقاق، وهو الاقتران المعتاد. وتعامل أطر التقييم الأمرين مترابطين أيضاً: فإطار PEFA يقيّم القابلية للتنبؤ والرقابة في تنفيذ الموازنة، بما فيها التنبؤ النقدي وتوحيد الأرصدة النقدية، ركيزةً متميزة عن إعداد الموازنة. وللمهني العامل في هذا المجال تكون مقاييس النجاح العملية غير براقة وغير ملتبسة. هل المركز النقدي الموحد اليومي معروف؟ وهل تُسجَّل الارتباطات قبل نشوء الالتزام لا عند وصول الفاتورة؟ وهل رصيد متأخرات الموردين مقيس ومنشور ومتناقص؟ الحكومة التي تجيب عن هذه الثلاثة لديها إدارة نقد عاملة أياً كان أساسها المحاسبي؛ والتي لا تستطيع ستظل تولّد متأخرات مهما بدت وثائق موازنتها جيدة.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Confusing budget authority with cash. An approved appropriation is permission to spend, not money available on the day the payment is due.', 'الخلط بين سلطة الموازنة والنقد. فالاعتماد المقر إذنٌ بالإنفاق لا مالٌ متاح يوم استحقاق الدفع.'),
    Bi('Measuring cash management by the size of balances. Large balances alongside short-term borrowing are the symptom of fragmentation, not evidence of prudence.', 'قياس إدارة النقد بحجم الأرصدة. فالأرصدة الكبيرة مع اقتراض قصير الأجل عَرَضُ تشتت لا دليل تحوّط.'),
    Bi('Ignoring supplier arrears because they carry no interest. They are unrecorded borrowing from the private sector, and they raise the price of every future contract.', 'تجاهل متأخرات الموردين لأنها بلا فائدة. فهي اقتراض غير مسجل من القطاع الخاص، وترفع سعر كل عقد مقبل.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IPSAS 2',
      note: Bi('Cash flow statements: the public-sector counterpart of IAS 7, and the reporting frame for consolidated cash movements.', 'قوائم التدفقات النقدية: نظير IAS 7 في القطاع العام، وإطار عرض حركات النقد الموحدة.'),
      segments: [
        KBStandardSegment('IPSAS 2', href: 'https://www.ipsasb.org/standards-pronouncements', viaIndex: true),
      ],
    ),
    KBStandardRef(
      standard: 'PEFA framework',
      note: Bi('Predictability and control in budget execution: cash forecasting, consolidation of balances, commitment controls and arrears monitoring.', 'القابلية للتنبؤ والرقابة في تنفيذ الموازنة: التنبؤ النقدي وتوحيد الأرصدة وضوابط الارتباط ومتابعة المتأخرات.'),
      segments: [
        KBStandardSegment('PEFA', href: 'https://www.pefa.org/resources/pefa-2016-framework'),
        KBStandardSegment(' framework'),
      ],
    ),
    KBStandardRef(
      standard: 'IPSAS 1',
      note: Bi('Presentation: what a consolidated public-sector position must show once balances are brought together.', 'العرض: ما يجب أن يظهره المركز الموحد للقطاع العام متى جُمعت الأرصدة.'),
      segments: [
        KBStandardSegment('IPSAS 1', href: 'https://www.ipsasb.org/standards-pronouncements', viaIndex: true),
      ],
    ),
  ],
  relatedTerms: [
    'Cash and Cash Equivalents',
    'Liquidity',
    'Short-term Debt',
    'Accounts Payable',
    'Operating Cash Flow',
  ],
  relatedModules: [
    KBRelatedModule('/government-education/budgeting', Bi('Module: Government Budgeting', 'الوحدة: الموازنة الحكومية')),
    KBRelatedModule('/government-education/financial-decisions', Bi('Module: Government Financial Decisions', 'الوحدة: القرارات المالية الحكومية')),
  ],
  relatedArticles: [
    'government-budget-cycle',
    'cash-flow-forecasting',
    'fiscal-sustainability',
    'working-capital',
    'internal-control-audit',
    'public-debt-management',
  ],
  references: [
    'Williams, M. (2010). Government cash management: Its interaction with other financial policies (IMF Technical Notes and Manuals 10/13). International Monetary Fund.',
    'Pattanayak, S., & Fainboim, I. (2011). Treasury single account: An essential tool for government cash management (IMF Technical Notes and Manuals 11/04). International Monetary Fund.',
    'PEFA Secretariat. (2016). Framework for assessing public financial management. PEFA Secretariat.',
    'International Public Sector Accounting Standards Board. (2000). IPSAS 2: Cash flow statements. IFAC.',
  ],
  keywords: [
    'treasury single account',
    'TSA',
    'cash management',
    'commitment control',
    'arrears',
    'cash forecasting',
    'public financial management',
    'الحساب الموحد للخزانة',
    'إدارة النقد',
    'ضوابط الارتباط',
    'المتأخرات',
  ],
);
