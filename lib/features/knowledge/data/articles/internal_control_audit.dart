// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/internal-control-audit.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbInternalControlAudit = KBArticle(
  id: 'internal-control-audit',
  title: Bi('Internal Control and the Audit', 'الرقابة الداخلية والتدقيق'),
  category: 'public-sector',
  level: KBLevel.intermediate,
  readingMinutes: 6,
  summary: Bi('The COSO control components, the three-lines model that assigns who does what, the difference between internal and external audit, and how to read an audit opinion.', 'مكونات الرقابة في إطار COSO، ونموذج الخطوط الثلاثة الذي يوزع الأدوار، والفرق بين التدقيق الداخلي والخارجي، وكيف يُقرأ رأي المدقق.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('Internal control is the system of policies, processes, and behaviors that gives an organization reasonable assurance about three things: reliable reporting, effective and efficient operations, and compliance with laws and regulations. The dominant framework, COSO, describes five interlocking components: the control environment (tone at the top, integrity, competence), risk assessment, control activities (approvals, reconciliations, segregation of duties, system access), information and communication, and monitoring. The phrase "reasonable assurance" is deliberate: controls are performed by people, can be overridden by management, and cost money, so a control system is always a judgment about how much risk to buy down.', 'الرقابة الداخلية هي منظومة السياسات والعمليات والسلوكيات التي تمنح المنظمة تأكيداً معقولاً حول ثلاثة أمور: تقارير موثوقة، وعمليات فعالة وكفؤة، والتزام بالقوانين واللوائح. ويصف الإطار السائد COSO خمسة مكونات متشابكة: بيئة الرقابة (النبرة من القمة، والنزاهة، والكفاءة)، وتقييم المخاطر، وأنشطة الرقابة (الاعتمادات، والمطابقات، وفصل المهام، وصلاحيات الأنظمة)، والمعلومات والاتصال، والمتابعة. وعبارة «تأكيد معقول» مقصودة: فالضوابط يؤديها بشر، ويمكن للإدارة تجاوزها، وهي تكلف مالاً، فمنظومة الرقابة دوماً اجتهاد في مقدار المخاطر التي تُشترى إزالتها.'),
        Bi('The single most powerful control idea is segregation of duties: no one person should be able to initiate, approve, record, and hold custody over the same transaction. Most classic frauds are stories of these four hats worn by one head.', 'أقوى فكرة رقابية منفردة هي فصل المهام: لا ينبغي لشخص واحد أن يستطيع بدء المعاملة نفسها واعتمادها وتسجيلها وحيازة أصلها. ومعظم الاحتيالات الكلاسيكية حكايات عن هذه القبعات الأربع على رأس واحد.'),
      ],
    ),
    KBSection(
      heading: Bi('The three lines and the two audits', 'الخطوط الثلاثة والتدقيقان'),
      paragraphs: [
        Bi('The IIA\'s Three Lines Model assigns roles. First line: management and staff who own the risks and operate the controls inside daily processes. Second line: functions that set frameworks and monitor (risk management, compliance, financial control). Third line: internal audit, which independently assures the board and audit committee that the first two lines actually work, reporting functionally to the audit committee precisely so that it can criticize management. External audit stands outside all three: an independent firm (or, for governments, the supreme audit institution, such as the General Court of Audit in Saudi Arabia) examines the financial statements and expresses an opinion on whether they are free of material misstatement. Internal audit asks "are we running well and controlling our risks?"; external audit asks "are these statements fairly presented?" The two cooperate but answer to different masters and different questions.', 'يوزع نموذج الخطوط الثلاثة لمعهد المدققين الداخليين الأدوارَ. الخط الأول: الإدارة والعاملون الذين يملكون المخاطر ويشغلون الضوابط داخل العمليات اليومية. والخط الثاني: وظائف تضع الأطر وتراقب (إدارة المخاطر، والالتزام، والرقابة المالية). والخط الثالث: التدقيق الداخلي الذي يؤكد باستقلال للمجلس ولجنة المراجعة أن الخطين الأولين يعملان فعلاً، ويتبع وظيفياً للجنة المراجعة تحديداً ليستطيع نقد الإدارة. ويقف التدقيق الخارجي خارج الثلاثة كلها: شركة مستقلة (أو للجهات الحكومية الجهازُ الأعلى للرقابة، كالديوان العام للمحاسبة في السعودية) تفحص القوائم المالية وتبدي رأياً في خلوها من التحريف الجوهري. يسأل التدقيق الداخلي: «هل نُدار جيداً ونضبط مخاطرنا؟»؛ ويسأل الخارجي: «هل هذه القوائم معروضة بعدالة؟» يتعاون الاثنان لكنهما يتبعان مرجعيتين مختلفتين ويجيبان عن سؤالين مختلفين.'),
      ],
    ),
    KBSection(
      heading: Bi('Reading the audit opinion', 'قراءة رأي المدقق'),
      paragraphs: [
        Bi('The opinion paragraph is the product of the entire audit, and it comes in four grades. Unmodified (clean): the statements present fairly in all material respects; this is the normal outcome and says nothing about business quality, only reporting quality. Qualified ("except for"): fairly presented apart from a specific, contained problem, either a misstatement or an inability to obtain evidence. Adverse: the statements as a whole are materially misstated; a red alarm. Disclaimer: the auditor could not obtain enough evidence to form any opinion, often as alarming as an adverse. Modern reports also include Key Audit Matters, the issues that most occupied the auditor (revenue recognition judgments, impairment models, provisions), which are the best-informed reading list a statement user gets. Two further signals deserve attention: the going-concern section, and any material-uncertainty language around it.', 'فقرة الرأي هي ناتج التدقيق كله، وتأتي بأربع درجات. غير المعدل (النظيف): القوائم معروضة بعدالة من جميع الجوانب الجوهرية؛ وهذا هو الناتج المعتاد ولا يقول شيئاً عن جودة الأعمال بل جودة التقرير فقط. والمتحفظ («باستثناء»): عرض عادل عدا مشكلة محددة محصورة، تحريفاً كانت أو تعذر الحصول على أدلة. والمعارض: القوائم ككل محرفة جوهرياً؛ إنذار أحمر. والامتناع: لم يستطع المدقق جمع أدلة كافية لتكوين أي رأي، وكثيراً ما يكون بجسامة المعارض. وتتضمن التقارير الحديثة أيضاً أمور التدقيق الرئيسة، وهي القضايا التي شغلت المدقق أكثر من غيرها (اجتهادات الاعتراف بالإيراد، ونماذج الهبوط، والمخصصات)، وهي أفضل قائمة قراءة مطلعة يحصل عليها مستخدم القوائم. وإشارتان أخريان تستحقان الانتباه: قسم الاستمرارية، وأي لغة عن شك جوهري حوله.'),
      ],
      table: KBTable(
        headers: [
          Bi('Opinion', 'الرأي'),
          Bi('Meaning', 'المعنى'),
          Bi('Reader reaction', 'رد فعل القارئ'),
        ],
        rows: [
          [
            Bi('Unmodified', 'غير معدل'),
            Bi('Fair in all material respects', 'عادل من جميع الجوانب الجوهرية'),
            Bi('Normal; read Key Audit Matters', 'معتاد؛ اقرأ أمور التدقيق الرئيسة'),
          ],
          [
            Bi('Qualified', 'متحفظ'),
            Bi('Fair except for a defined issue', 'عادل باستثناء مسألة محددة'),
            Bi('Locate and size the exception', 'حدد الاستثناء وقس حجمه'),
          ],
          [
            Bi('Adverse', 'معارض'),
            Bi('Materially misstated overall', 'محرف جوهرياً في مجمله'),
            Bi('Do not rely on the statements', 'لا تعتمد على القوائم'),
          ],
          [
            Bi('Disclaimer', 'امتناع'),
            Bi('Insufficient evidence for any opinion', 'أدلة غير كافية لأي رأي'),
            Bi('Treat as a serious warning', 'عامله تحذيراً خطيراً'),
          ],
        ],
      ),
    ),
    KBSection(
      heading: Bi('The public-sector dimension', 'البعد الحكومي'),
      paragraphs: [
        Bi('In government, control and audit carry an extra mandate: guarding public money on behalf of citizens. Supreme audit institutions, organized globally under INTOSAI, conduct three audit families: financial audits (the opinion above), compliance audits (was money spent within the budget law and regulations?), and performance audits (economy, efficiency, effectiveness: did the spending achieve value?). Budget execution controls (commitment controls that block spending beyond appropriations) are the public sector\'s distinctive first-line control, and audit findings flow to the legislature, not to shareholders. For professionals in ministries and agencies, the practical takeaway is symmetrical with the private sector: controls are not bureaucracy layered on the work; they are the evidence that the work can be trusted.', 'في الحكومة تحمل الرقابة والتدقيق تفويضاً إضافياً: حراسة المال العام نيابة عن المواطنين. وتجري الأجهزة العليا للرقابة، المنتظمة عالمياً في منظمة الإنتوساي، ثلاث عائلات من التدقيق: المالي (الرأي أعلاه)، والالتزام (هل أُنفق المال ضمن نظام الموازنة واللوائح؟)، والأداء (الاقتصاد والكفاءة والفعالية: هل حقق الإنفاق قيمة؟). وضوابط تنفيذ الموازنة (ضوابط الارتباط التي تمنع الإنفاق فوق الاعتمادات) هي ضابط الخط الأول المميز للقطاع العام، وتتدفق نتائج التدقيق إلى السلطة التشريعية لا إلى مساهمين. وللمهنيين في الوزارات والأجهزة، الخلاصة العملية متناظرة مع القطاع الخاص: الضوابط ليست بيروقراطية فوق العمل؛ إنها الدليل على أن العمل جدير بالثقة.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Reading a clean opinion as a health certificate for the business. It certifies the reporting, not the strategy, the margins, or the future.', 'قراءة الرأي النظيف شهادةَ عافية للأعمال. إنه يشهد للتقرير لا للاستراتيجية ولا للهوامش ولا للمستقبل.'),
    Bi('Treating internal audit as the owner of controls. Ownership sits in the first line; an audit function that operates controls cannot audit them.', 'اعتبار التدقيق الداخلي مالكَ الضوابط. الملكية في الخط الأول؛ ووظيفة تدقيق تشغل الضوابط لا تستطيع تدقيقها.'),
    Bi('Designing controls only against error. Management override and collusion defeat routine controls, which is why the control environment and whistleblowing channels matter more than any checklist.', 'تصميم الضوابط ضد الخطأ فقط. تجاوز الإدارة والتواطؤ يهزمان الضوابط الروتينية، ولهذا تفوق بيئةُ الرقابة وقنوات الإبلاغ أهميةً أي قائمة تحقق.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'COSO (2013)',
      note: Bi('Internal Control - Integrated Framework: the five components and seventeen principles most control systems are mapped against.', 'الرقابة الداخلية - الإطار المتكامل: المكونات الخمسة والمبادئ السبعة عشر التي تُقاس عليها معظم المنظومات.'),
      segments: [
        KBStandardSegment('COSO', href: 'https://www.coso.org/guidance-on-ic'),
        KBStandardSegment(' (2013)'),
      ],
    ),
    KBStandardRef(
      standard: 'ISA 700–706 · ISSAI',
      note: Bi('International Standards on Auditing for the opinion and its modifications; the ISSAI framework extends them to supreme audit institutions.', 'المعايير الدولية للتدقيق لفقرة الرأي وتعديلاتها؛ ويمدها إطار ISSAI إلى الأجهزة العليا للرقابة.'),
      segments: [
        KBStandardSegment('ISA 700–706', href: 'https://www.iaasb.org/publications/international-standard-auditing-isa-700-revised-forming-opinion-and-reporting-financial-statements'),
        KBStandardSegment(' · '),
        KBStandardSegment('ISSAI', href: 'https://www.issai.org/professional-pronouncements/'),
      ],
    ),
    KBStandardRef(
      standard: 'IIA Three Lines Model (2020)',
      note: Bi('The role architecture for risk and control across management, oversight functions, and internal audit.', 'معمارية الأدوار للمخاطر والرقابة عبر الإدارة ووظائف الإشراف والتدقيق الداخلي.'),
      segments: [
        KBStandardSegment('IIA Three Lines Model', href: 'https://www.theiia.org/en/content/position-papers/2020/the-iias-three-lines-model-an-update-of-the-three-lines-of-defense/'),
        KBStandardSegment(' (2020)'),
      ],
    ),
  ],
  relatedTerms: [
    'Internal Controls',
  ],
  relatedModules: [
    KBRelatedModule('/education/compliance', Bi('Module: Compliance', 'الوحدة: الالتزام')),
    KBRelatedModule('/education/auditing', Bi('Module: Financial Auditing & Review', 'الوحدة: التدقيق والمراجعة المالية')),
  ],
  relatedArticles: [
    'ifrs-vs-ipsas',
    'balance-sheet',
    'provisions-contingencies',
    'public-private-partnerships',
    'related-party-disclosures',
  ],
  references: [
    'Committee of Sponsoring Organizations of the Treadway Commission. (2013). Internal control - integrated framework. COSO.',
    'Institute of Internal Auditors. (2020). The IIA\'s three lines model. IIA.',
    'International Auditing and Assurance Standards Board. (2015). ISA 700 (revised): Forming an opinion and reporting on financial statements. IFAC.',
    'INTOSAI. (2019). ISSAI 100: Fundamental principles of public-sector auditing. INTOSAI.',
  ],
  keywords: [
    'internal control',
    'COSO',
    'three lines',
    'audit opinion',
    'segregation of duties',
    'INTOSAI',
    'رقابة داخلية',
    'تدقيق',
    'فصل المهام',
    'رأي المدقق',
  ],
);
