// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/public-private-partnerships.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbPublicPrivatePartnerships = KBArticle(
  id: 'public-private-partnerships',
  title: Bi('Public-Private Partnerships and Service Concessions', 'الشراكات بين القطاعين العام والخاص وامتيازات الخدمة'),
  category: 'public-sector',
  level: KBLevel.advanced,
  readingMinutes: 8,
  summary: Bi('How a government builds infrastructure without paying for it upfront, why the accounting asks who controls the asset rather than who owns it, the grantor and operator sides of the same contract, and a worked availability-payment PPP.', 'كيف تبني الحكومة بنية تحتية دون دفع ثمنها مقدماً، ولماذا تسأل المحاسبة عمن يسيطر على الأصل لا عمن يملكه، وجانبا المانح والمشغل من العقد نفسه، ومثال محلول لشراكة بدفعات إتاحة.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('A public-private partnership is a long-term contract in which a private operator builds or upgrades public infrastructure, then operates it for a fixed period before handing it back. A hospital, a desalination plant, a school, a stretch of road: the government gets the asset without an upfront capital outlay, and the operator gets a revenue stream, either from users (a toll) or from the government itself (availability payments). The financial appeal to a treasury is obvious and dangerous in equal measure. The obvious part is that the capital cost moves off this year’s budget. The dangerous part is that the obligation does not disappear; it becomes a multi-decade commitment that binds future budgets exactly as debt would. Accounting standards exist precisely to stop that commitment from becoming invisible.', 'الشراكة بين القطاعين العام والخاص عقدٌ طويل الأجل يبني فيه مشغل خاص بنية تحتية عامة أو يطورها، ثم يشغّلها مدة محددة قبل إعادتها. مستشفى أو محطة تحلية أو مدرسة أو امتداد طريق: تحصل الحكومة على الأصل دون إنفاق رأسمالي مقدم، ويحصل المشغل على تيار إيراد، إما من المستخدمين (رسوم) وإما من الحكومة نفسها (دفعات إتاحة). والجاذبية المالية للخزانة بديهية وخطيرة بالقدر نفسه. البديهي أن الكلفة الرأسمالية تخرج من موازنة هذه السنة. والخطير أن الالتزام لا يختفي؛ بل يصير تعهداً لعقود يقيّد الموازنات المقبلة تماماً كما يفعل الدين. ووُجدت المعايير المحاسبية تحديداً لمنع ذلك التعهد من أن يصير غير مرئي.'),
      ],
    ),
    KBSection(
      heading: Bi('The formal treatment: control, not legal title', 'المعالجة النظرية: السيطرة لا الملكية القانونية'),
      paragraphs: [
        Bi('Both sides of the contract are governed by a control test rather than by who holds the deed. On the public side, IPSAS 32 requires the grantor to recognize the service concession asset, and a matching liability, when the government controls or regulates what services the operator must provide, to whom and at what price, and controls any significant residual interest in the asset at the end of the term. Where those conditions hold, the road sits on the government’s balance sheet from day one even though a private company built and holds it. The offsetting liability takes one of two forms: a financial liability where the government pays the operator directly, or an unearned revenue liability where the operator is instead granted the right to charge users. On the private side, IFRIC 12 tells the operator it cannot recognize infrastructure it does not control, because the grantor controls the service, the price and the residual interest, whoever holds legal title: it recognizes either a financial asset (an unconditional right to cash from the grantor) or an intangible asset (a licence to charge users), and often a mix of both.', 'يحكم جانبي العقد اختبارُ سيطرة لا هوية حامل الصك. فعلى الجانب العام يوجب IPSAS 32 أن يعترف المانح بأصل امتياز الخدمة، وبالتزام مقابل له، عندما تسيطر الحكومة أو تنظّم أي خدمات يجب أن يقدمها المشغل ولمن وبأي سعر، وتسيطر على أي حصة متبقية جوهرية في الأصل عند نهاية المدة. وحيث تتحقق تلك الشروط يجلس الطريق في ميزانية الحكومة من اليوم الأول وإن بنته شركة خاصة وحازته. ويأخذ الالتزام المقابل صورة من اثنتين: التزام مالي حيث تدفع الحكومة للمشغل مباشرة، أو التزام إيراد غير مكتسب حيث يُمنح المشغل بدلاً من ذلك حق تحصيل رسوم من المستخدمين. وعلى الجانب الخاص يخبر IFRIC 12 المشغلَ أنه لا يستطيع الاعتراف ببنية تحتية لا يسيطر عليها، لأن المانح يسيطر على الخدمة والسعر والحصة المتبقية، أياً كان حامل الصك القانوني: فيعترف إما بأصل مالي (حق غير مشروط في نقد من المانح) وإما بأصل غير ملموس (رخصة تحصيل من المستخدمين)، وكثيراً بمزيج منهما.'),
      ],
      formulas: [
        KBFormula('Grantor at inception: Dr Service concession asset (fair value)   Cr Financial liability and/or Unearned revenue', caption: Bi('IPSAS 32 recognition: the asset and the obligation enter the accounts together.', 'اعتراف IPSAS 32: يدخل الأصل والالتزام الحسابات معاً.')),
        KBFormula('Availability payment = Interest on liability + Repayment of liability + Service and operating charge', caption: Bi('Unbundling the unitary charge: only the service element is an operating expense.', 'تفكيك الدفعة الموحدة: العنصر الخدمي وحده مصروف تشغيلي.')),
      ],
    ),
    KBSection(
      heading: Bi('Worked example: an availability-payment hospital', 'مثال محلول: مستشفى بدفعات إتاحة'),
      paragraphs: [
        Bi('A ministry contracts an operator to build a hospital worth SAR 500m and maintain it for 25 years, paying SAR 62m a year. The government sets the services, the standards and the tariffs, and takes the building back at the end, so it controls the asset: IPSAS 32 puts the SAR 500m on the ministry’s balance sheet at commissioning, with a SAR 500m financial liability beside it. Each annual payment is then split, not expensed whole. If the implicit finance rate is 6%, year one carries interest of SAR 30m, a service element of, say, SAR 20m, and the remaining SAR 12m reduces the liability. The budget line that used to read "hospital payment SAR 62m" now reads as SAR 20m of service cost, SAR 30m of finance cost, and SAR 12m of debt repayment, alongside depreciation of the asset over its useful life. Nothing about the cash changed. What changed is that the ministry can no longer describe a 25-year borrowing as an annual operating expense.', 'تتعاقد وزارة مع مشغل لبناء مستشفى بقيمة 500 مليون ريال وصيانته 25 سنة، مقابل 62 مليون ريال سنوياً. تحدد الحكومة الخدمات والمعايير والتعرفة، وتستعيد المبنى في النهاية، فهي إذن تسيطر على الأصل: ويضع IPSAS 32 الخمسمئة مليون في ميزانية الوزارة عند التشغيل، وبجوارها التزام مالي بخمسمئة مليون. ثم تُقسَّم كل دفعة سنوية ولا تُحمَّل مصروفاً بكاملها. فإن كان معدل التمويل الضمني 6%، حملت السنة الأولى فائدة قدرها 30 مليوناً، وعنصراً خدمياً قدره مثلاً 20 مليوناً، وخفضت الاثنا عشر مليوناً الباقية الالتزام. وسطر الموازنة الذي كان يقرأ "دفعة مستشفى 62 مليوناً" صار يقرأ عشرين مليوناً كلفةَ خدمة، وثلاثين مليوناً كلفةَ تمويل، واثني عشر مليوناً سدادَ دين، إلى جانب استهلاك الأصل على عمره النافع. ولم يتغير شيء في النقد. الذي تغير أن الوزارة لم تعد تستطيع وصف اقتراض لخمس وعشرين سنة بأنه مصروف تشغيلي سنوي.'),
      ],
    ),
    KBSection(
      heading: Bi('Fiscal risk, value for money and Vision 2030', 'المخاطر المالية والقيمة مقابل المال ورؤية 2030'),
      paragraphs: [
        Bi('The policy question a PPP must answer is value for money: does transferring construction, operating and demand risk to a private party justify a financing cost above what the government could borrow at? Sometimes it clearly does, where private discipline delivers on time and operates better. Often the honest answer is that the deal was chosen because it fit a budget rule rather than because it was cheaper. This is why fiscal frameworks now require PPP commitments and contingent liabilities such as guaranteed minimum revenue to be disclosed in fiscal risk statements, and why the IMF and World Bank publish assessment tools for exactly this exposure. For Saudi Arabia the topic is live rather than theoretical: Vision 2030 programmes rely heavily on private participation and privatization across health, water, transport and education, with the National Center for Privatization structuring the pipeline. A public finance professional there needs both halves of this article, because the ministry booking an IPSAS 32 asset and the operator booking an IFRIC 12 intangible are describing the same contract from opposite ends.', 'السؤال السياساتي الذي يجب أن تجيبه أي شراكة هو القيمة مقابل المال: هل يبرر نقل مخاطر الإنشاء والتشغيل والطلب إلى طرف خاص تكلفةَ تمويل تفوق ما تستطيع الحكومة الاقتراض به؟ أحياناً يبرره بوضوح، حيث يسلّم الانضباط الخاص في الوقت ويشغّل أفضل. وغالباً يكون الجواب الأمين أن الصفقة اختيرت لأنها لاءمت قاعدة موازنة لا لأنها أرخص. ولهذا صارت الأطر المالية توجب الإفصاح عن تعهدات الشراكات والالتزامات المحتملة كضمان حد أدنى من الإيراد في بيانات المخاطر المالية، ولهذا ينشر صندوق النقد والبنك الدولي أدوات تقييم لهذا التعرض تحديداً. وفي السعودية الموضوع حيٌّ لا نظري: فبرامج رؤية 2030 تعتمد اعتماداً كبيراً على المشاركة الخاصة والتخصيص في الصحة والمياه والنقل والتعليم، والمركز الوطني للتخصيص يهيكل المسار. ويحتاج مهني المالية العامة هناك شقّي هذه المقالة معاً، لأن الوزارة التي تقيّد أصلاً وفق IPSAS 32 والمشغلَ الذي يقيّد أصلاً غير ملموس وفق IFRIC 12 يصفان العقد نفسه من طرفين متقابلين.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Treating a PPP as off-balance-sheet by default. Under IPSAS 32 the control test, not the legal title or the funding route, decides, and most availability-payment deals land on the government’s books.', 'اعتبار الشراكة خارج الميزانية افتراضاً. فاختبار السيطرة في IPSAS 32، لا الملكية القانونية ولا مسار التمويل، هو الفيصل، ومعظم صفقات دفعات الإتاحة تستقر في دفاتر الحكومة.'),
    Bi('Expensing the whole unitary payment: it bundles finance cost, debt repayment and service, and only the last is an operating expense of the period.', 'تحميل الدفعة الموحدة بكاملها مصروفاً: فهي تحزم كلفة التمويل وسداد الدين والخدمة، والأخيرة وحدها مصروف تشغيلي للفترة.'),
    Bi('Ignoring guarantees and demand risk retained by the state. A minimum revenue guarantee is a contingent liability that can crystallize precisely when the budget is weakest.', 'تجاهل الضمانات ومخاطر الطلب التي تحتفظ بها الدولة. فضمان الحد الأدنى من الإيراد التزامٌ محتمل قد يتجسد في أضعف لحظات الموازنة بالضبط.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IPSAS 32',
      note: Bi('Service concession arrangements, grantor: when the public entity recognizes the asset and the matching liability.', 'ترتيبات امتياز الخدمة لدى المانح: متى تعترف الجهة العامة بالأصل وبالالتزام المقابل.'),
      segments: [
        KBStandardSegment('IPSAS 32', href: 'https://www.ipsasb.org/standards-pronouncements', viaIndex: true),
      ],
    ),
    KBStandardRef(
      standard: 'IFRIC 12',
      note: Bi('Service concession arrangements, operator: the financial asset and intangible asset models on the private side.', 'ترتيبات امتياز الخدمة لدى المشغل: نموذجا الأصل المالي والأصل غير الملموس في الجانب الخاص.'),
      segments: [
        KBStandardSegment('IFRIC 12', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ifric-12-service-concession-arrangements/'),
      ],
    ),
    KBStandardRef(
      standard: 'IPSAS 19',
      note: Bi('Provisions and contingent liabilities: where guarantees given to an operator are recognized or disclosed.', 'المخصصات والالتزامات المحتملة: حيث يُعترف بالضمانات الممنوحة للمشغل أو يُفصح عنها.'),
      segments: [
        KBStandardSegment('IPSAS 19', href: 'https://www.ipsasb.org/standards-pronouncements', viaIndex: true),
      ],
    ),
  ],
  relatedTerms: [
    'Fixed Assets',
    'Capital Expenditure (CapEx)',
    'Long-term Debt',
    'Contingent Liability',
    'Intangible Assets',
  ],
  relatedModules: [
    KBRelatedModule('/government-education/ipsas-reporting', Bi('Module: IPSAS Reporting', 'الوحدة: التقارير وفق IPSAS')),
    KBRelatedModule('/government-education/budgeting', Bi('Module: Government Budgeting', 'الوحدة: الموازنة الحكومية')),
  ],
  relatedArticles: [
    'ifrs-vs-ipsas',
    'government-budget-cycle',
    'leases-ifrs16',
    'provisions-contingencies',
    'npv-irr',
    'fiscal-sustainability',
    'government-grants',
    'public-debt-management',
  ],
  references: [
    'International Public Sector Accounting Standards Board. (2011). IPSAS 32: Service concession arrangements - grantor. IFAC.',
    'IFRS Foundation. (2006). IFRIC 12 Service Concession Arrangements. IFRS Foundation.',
    'International Monetary Fund. (2018). Public investment management assessment framework. IMF.',
    'World Bank. (2017). Public-private partnerships reference guide (version 3). World Bank Group.',
  ],
  keywords: [
    'public-private partnership',
    'PPP',
    'service concession',
    'IPSAS 32',
    'IFRIC 12',
    'availability payment',
    'grantor',
    'operator',
    'privatization',
    'الشراكة بين القطاعين',
    'امتياز الخدمة',
    'دفعات الإتاحة',
    'التخصيص',
  ],
);
