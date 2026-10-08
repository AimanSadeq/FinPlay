// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/ifrs-vs-ipsas.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbIfrsVsIpsas = KBArticle(
  id: 'ifrs-vs-ipsas',
  title: Bi('IFRS versus IPSAS: Private and Public Sector Reporting', 'المعايير الدولية IFRS مقابل IPSAS: التقرير في القطاعين الخاص والعام'),
  category: 'public-sector',
  level: KBLevel.intermediate,
  readingMinutes: 7,
  summary: Bi('Why governments have their own accounting standards, where IPSAS deliberately follows IFRS, where it deliberately departs, and what the accrual transition means for public-sector professionals.', 'لماذا للحكومات معاييرها المحاسبية الخاصة، وأين تتبع IPSAS المعاييرَ الدولية IFRS عمداً، وأين تفارقها عمداً، وماذا يعني التحول إلى الاستحقاق لمهنيي القطاع العام.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('IFRS serves investors and lenders deciding whether to commit capital to profit-seeking entities. Governments have no shareholders and do not exist to earn profit: they raise resources through taxes and fees, largely without giving anything directly in exchange, and they exist to deliver services. IPSAS (International Public Sector Accounting Standards, issued by the IPSASB under IFAC) adapts the accrual accounting model to that reality. The accountability question changes from "what did you earn?" to "what did you receive, what did it cost to deliver services, and what capacity remains?"', 'تخدم المعايير الدولية IFRS المستثمرين والمقرضين وهم يقررون توظيف رأس المال في منشآت تسعى للربح. أما الحكومات فلا مساهمين لها ولا توجد لتربح: فهي تحشد الموارد بالضرائب والرسوم، دون مقابل مباشر غالباً، وتوجد لتقديم الخدمات. ومعايير IPSAS (معايير المحاسبة الدولية للقطاع العام، الصادرة عن مجلس IPSASB التابع للاتحاد الدولي للمحاسبين) تكيف نموذج محاسبة الاستحقاق مع تلك الحقيقة. فيتغير سؤال المساءلة من «كم كسبتم؟» إلى «ماذا استلمتم، وكم كلف تقديم الخدمات، وما القدرة المتبقية؟»'),
        Bi('Structurally, most IPSAS are drawn from a corresponding IFRS with terminology and scope adapted: IPSAS 1 mirrors IAS 1, IPSAS 2 mirrors IAS 7, and IPSAS 45 mirrors IAS 16 (having replaced IPSAS 17 from 1 January 2025, while adding public-sector guidance on heritage and infrastructure assets). The differences that remain are not accidents of drafting; each one exists because a public-sector transaction has no private-sector equivalent.', 'بنيوياً، معظم معايير IPSAS مستمد من معيار IFRS مقابل بعد تكييف المصطلحات والنطاق: IPSAS 1 يقابل IAS 1، وIPSAS 2 يقابل IAS 7، وIPSAS 45 يقابل IAS 16 (بعد أن حل محل IPSAS 17 اعتباراً من 1 يناير 2025، مضيفاً إرشادات للقطاع العام عن أصول التراث والبنية التحتية). أما الفروق الباقية فليست مصادفات صياغة؛ كل فرق موجود لأن في القطاع العام معاملة لا نظير لها في القطاع الخاص.'),
      ],
    ),
    KBSection(
      heading: Bi('The deliberate departures', 'المفارقات المقصودة'),
      paragraphs: [
        Bi('Four departures carry most of the practical weight. First, revenue (IPSAS 47, effective 1 January 2026): taxes, fines and transfers arrive without anyone buying anything, so the public sector needs a model IFRS 15 does not provide. IPSAS 47 replaced IPSAS 23 (and IPSAS 9 and IPSAS 11) with a single standard that asks one question first: does a binding arrangement impose performance obligations? Where it does, recognition follows IFRS 15, extended to public-sector arrangements whose ultimate beneficiary is a third party rather than the payer. Where it does not, the older logic survives: revenue is recognized when the taxable event occurs and the resources meet the asset recognition criteria, with a liability only where a present obligation is genuinely enforceable. Readers of pre-2026 statements will still meet IPSAS 23, and its exchange versus non-exchange vocabulary, throughout the comparatives. Second, budget reporting (IPSAS 24): entities whose approved budgets are public must present actuals against budget on a comparable basis and explain material differences: accountability to the legislature is a reporting objective in its own right. Third, service-potential language: public assets (roads, schools, heritage buildings) justify recognition through service potential, not only future cash flows, which changes impairment logic (IPSAS 21 tests non-cash-generating assets against remaining service potential). Fourth, the statement of net assets/equity replaces shareholders\' equity, and the bottom line is surplus or deficit, not profit.', 'أربع مفارقات تحمل معظم الثقل العملي. أولاً، الإيراد (IPSAS 47، النافذ في 1 يناير 2026): الضرائب والغرامات والتحويلات تصل دون أن يشتري أحد شيئاً، فيحتاج القطاع العام نموذجاً لا يقدمه IFRS 15. وقد استبدل IPSAS 47 معيارَ IPSAS 23 (ومعياري IPSAS 9 وIPSAS 11) بمعيار واحد يسأل أولاً سؤالاً واحداً: هل يفرض ترتيبٌ ملزم التزاماتِ أداء؟ فإن فرضها، سار الاعتراف على نهج IFRS 15، ممتداً إلى ترتيبات القطاع العام التي يكون المستفيد النهائي فيها طرفاً ثالثاً لا الدافع. وإن لم يفرضها، بقي المنطق القديم: يُعترف بالإيراد عند وقوع الحدث الخاضع وتحقق معايير الاعتراف بالأصل، مع التزام فقط حيث يوجد التزام حالي واجب النفاذ فعلاً. وسيظل قارئ قوائم ما قبل 2026 يقابل IPSAS 23 ومفرداته عن التبادلي وغير التبادلي في أرقام المقارنة. ثانياً، تقارير الموازنة (IPSAS 24): على المنشآت التي تُنشر موازناتها المعتمدة أن تعرض الفعلي مقابل الموازنة على أساس قابل للمقارنة وأن تفسر الفروق الجوهرية: فالمساءلة أمام السلطة التشريعية هدف تقرير قائم بذاته. ثالثاً، لغة الطاقة الخدمية: الأصول العامة (الطرق والمدارس والمباني التراثية) تبرر الاعتراف بها بطاقتها الخدمية لا بالتدفقات النقدية المستقبلية وحدها، مما يغير منطق الهبوط (يختبر IPSAS 21 الأصول غير المولدة للنقد مقابل الطاقة الخدمية المتبقية). رابعاً، تحل قائمة صافي الأصول/حقوق الملكية محل حقوق المساهمين، والسطر الأخير فائض أو عجز لا ربح.'),
      ],
      table: KBTable(
        headers: [
          Bi('Topic', 'الموضوع'),
          Bi('IFRS (private)', 'IFRS (خاص)'),
          Bi('IPSAS (public)', 'IPSAS (عام)'),
        ],
        rows: [
          [
            Bi('Primary users', 'المستخدمون الرئيسون'),
            Bi('Investors and lenders', 'المستثمرون والمقرضون'),
            Bi('Citizens, legislature, resource providers', 'المواطنون والسلطة التشريعية ومقدمو الموارد'),
          ],
          [
            Bi('Core revenue', 'الإيراد الجوهري'),
            Bi('Contracts with customers (IFRS 15)', 'عقود مع العملاء (IFRS 15)'),
            Bi('Taxes and transfers, with or without performance obligations (IPSAS 47, replacing IPSAS 23)', 'ضرائب وتحويلات، بالتزامات أداء أو بدونها (IPSAS 47 بديلاً عن IPSAS 23)'),
          ],
          [
            Bi('Budget in the statements', 'الموازنة في القوائم'),
            Bi('Not presented', 'لا تُعرض'),
            Bi('Budget vs actual required when budget is public (IPSAS 24)', 'الموازنة مقابل الفعلي مطلوبة عند علنية الموازنة (IPSAS 24)'),
          ],
          [
            Bi('Bottom line', 'السطر الأخير'),
            Bi('Profit or loss', 'ربح أو خسارة'),
            Bi('Surplus or deficit', 'فائض أو عجز'),
          ],
          [
            Bi('Asset justification', 'مسوِّغ الأصل'),
            Bi('Future economic benefits', 'منافع اقتصادية مستقبلية'),
            Bi('Benefits OR service potential', 'منافع أو طاقة خدمية'),
          ],
        ],
      ),
    ),
    KBSection(
      heading: Bi('The accrual transition', 'التحول إلى الاستحقاق'),
      paragraphs: [
        Bi('Historically most governments kept cash-basis books: revenue when collected, expenditure when paid. Cash accounting is simple and matches appropriations control, but it hides obligations (unpaid invoices, employee benefits earned, pension promises) and it carries no asset register, so nobody can say what infrastructure exists, what condition it is in, or what it costs to consume it. The global reform movement is therefore toward accrual-basis IPSAS, and IPSAS 33 governs first-time adoption, allowing transitional relief periods (up to three years for recognizing certain assets and liabilities) because building an opening balance sheet for an entire government is a genuinely large undertaking. Saudi Arabia\'s public-sector accrual transformation is part of this movement, which is precisely why financial competence for government professionals now demands accrual literacy: budget officers raised on cash appropriations must learn to read depreciation, provisions, and receivables.', 'تاريخياً أمسكت معظم الحكومات دفاترها على الأساس النقدي: الإيراد عند التحصيل والمصروف عند الدفع. الأساس النقدي بسيط ويوافق رقابة الاعتمادات، لكنه يخفي الالتزامات (فواتير غير مسددة، ومنافع موظفين مستحقة، ووعود تقاعد) ولا سجل أصول معه، فلا أحد يستطيع القول أي بنية تحتية موجودة وبأي حالة وكم يكلف استهلاكها. لذا يتجه الإصلاح العالمي نحو IPSAS على أساس الاستحقاق، وينظم IPSAS 33 التطبيقَ الأول مانحاً فترات انتقالية ميسِّرة (حتى ثلاث سنوات للاعتراف ببعض الأصول والالتزامات) لأن بناء ميزانية افتتاحية لحكومة كاملة مشروع ضخم حقاً. وتحول القطاع العام السعودي إلى الاستحقاق جزء من هذه الحركة، وهذا بالضبط ما يجعل الكفاءة المالية لمهنيي الحكومة اليوم تتطلب إلماماً بالاستحقاق: فموظفو الموازنة الذين نشؤوا على الاعتمادات النقدية عليهم أن يتعلموا قراءة الإهلاك والمخصصات والذمم.'),
      ],
    ),
    KBSection(
      heading: Bi('Reading a government financial statement', 'قراءة قائمة مالية حكومية'),
      paragraphs: [
        Bi('The practical reading order for a public-sector statement differs from the corporate one. Start with budget versus actual (IPSAS 24): it is the accountability heart of the document. Then the statement of financial performance: is there a structural deficit, and is it driven by service costs or by transfers? Then net assets and the composition of liabilities: employee benefits and long-term obligations often dwarf everything else. A surplus is not "profit to distribute" and a deficit is not automatically failure; both must be read against policy intent: a government running a planned deficit to build infrastructure is executing policy, not losing money.', 'ترتيب القراءة العملي لقائمة القطاع العام يختلف عن الشركات. ابدأ بالموازنة مقابل الفعلي (IPSAS 24): فهي قلب المساءلة في الوثيقة. ثم قائمة الأداء المالي: هل ثمة عجز هيكلي، وهل يقوده كلف الخدمات أم التحويلات؟ ثم صافي الأصول وتركيبة الالتزامات: فمنافع الموظفين والالتزامات طويلة الأجل كثيراً ما تتقزم أمامها البنود الأخرى. الفائض ليس «ربحاً للتوزيع» والعجز ليس فشلاً تلقائياً؛ فكلاهما يُقرأ على ضوء القصد السياساتي: حكومة تدير عجزاً مخططاً لبناء بنية تحتية تنفذ سياسة، لا تخسر مالاً.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Judging a government like a company: surplus/deficit is a policy outcome as much as a performance measure.', 'محاكمة الحكومة كأنها شركة: الفائض/العجز نتيجة سياسات بقدر ما هو مقياس أداء.'),
    Bi('Assuming IPSAS equals IFRS with new labels. The revenue, budget reporting, and service-potential departures change recognition, not just names.', 'افتراض أن IPSAS هي IFRS بمسميات جديدة. مفارقات الإيراد وتقارير الموازنة والطاقة الخدمية تغير الاعتراف لا الأسماء فقط.'),
    Bi('Comparing accrual-basis entities with cash-basis entities during a phased national transition; the same ministry can look completely different across the boundary.', 'مقارنة جهات على الاستحقاق بجهات على النقدي أثناء تحول وطني متدرج؛ فالوزارة نفسها قد تبدو مختلفة تماماً عبر الحد الفاصل.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IPSAS 1 · IPSAS 2',
      note: Bi('Presentation and cash flow statements: the IAS 1 / IAS 7 counterparts, with net assets/equity and surplus/deficit.', 'العرض وقائمة التدفقات: مقابلا IAS 1 وIAS 7، مع صافي الأصول/حقوق الملكية والفائض/العجز.'),
      segments: [
        KBStandardSegment('IPSAS 1', href: 'https://www.ipsasb.org/standards-pronouncements', viaIndex: true),
        KBStandardSegment(' · '),
        KBStandardSegment('IPSAS 2', href: 'https://www.ipsasb.org/standards-pronouncements', viaIndex: true),
      ],
    ),
    KBStandardRef(
      standard: 'IPSAS 47 · IPSAS 24',
      note: Bi('The two most distinctive public-sector standards: revenue including taxes and transfers (IPSAS 47 superseded IPSAS 23 from 1 January 2026), and budget-versus-actual reporting.', 'أكثر معيارين تمييزاً للقطاع العام: الإيراد شاملاً الضرائب والتحويلات (حل IPSAS 47 محل IPSAS 23 اعتباراً من 1 يناير 2026)، والموازنة مقابل الفعلي.'),
      segments: [
        KBStandardSegment('IPSAS 47', href: 'https://www.ipsasb.org/publications/ipsas-47-revenue'),
        KBStandardSegment(' · '),
        KBStandardSegment('IPSAS 24', href: 'https://www.ipsasb.org/standards-pronouncements', viaIndex: true),
      ],
    ),
    KBStandardRef(
      standard: 'IPSAS 33',
      note: Bi('First-time adoption of accrual-basis IPSAS, with transitional relief: the legal frame of most government accrual programs.', 'التطبيق الأول لمعايير الاستحقاق مع إعفاءات انتقالية: الإطار النظامي لمعظم برامج التحول الحكومي.'),
      segments: [
        KBStandardSegment('IPSAS 33', href: 'https://www.ipsasb.org/publications/ipsas-33-first-time-adoption-accrual-basis-ipsas-standards'),
      ],
    ),
  ],
  relatedTerms: [
    'Accrual Accounting',
    'Revenue',
  ],
  relatedModules: [
    KBRelatedModule('/education/reporting-standards', Bi('Module: IPSAS Reporting', 'الوحدة: تقارير IPSAS')),
    KBRelatedModule('/education/sector-comparison', Bi('Module: Government vs Private Sector', 'الوحدة: الحكومة مقابل القطاع الخاص')),
  ],
  relatedArticles: [
    'accrual-accounting',
    'budgeting-variance',
    'balance-sheet',
    'government-budget-cycle',
    'internal-control-audit',
    'public-private-partnerships',
    'fiscal-sustainability',
    'government-grants',
  ],
  references: [
    'International Public Sector Accounting Standards Board. (2023). Handbook of international public sector accounting pronouncements. IFAC.',
    'International Public Sector Accounting Standards Board. (2023). IPSAS 47: Revenue. IFAC.',
    'International Public Sector Accounting Standards Board. (2015). IPSAS 33: First-time adoption of accrual basis IPSASs. IFAC.',
    'OECD/IFAC. (2017). Accrual practices and reform experiences in OECD countries. OECD Publishing.',
    'Chan, J. L. (2003). Government accounting: An assessment of theory, purposes and standards. Public Money & Management, 23(1), 13-20.',
  ],
  keywords: [
    'IPSAS',
    'IFRS',
    'public sector',
    'government accounting',
    'non-exchange',
    'IPSAS 47',
    'accrual transition',
    'قطاع عام',
    'محاسبة حكومية',
    'إيراد غير تبادلي',
    'تحول استحقاقي',
  ],
);
