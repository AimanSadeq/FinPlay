// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/esg-sustainability-reporting.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbEsgSustainabilityReporting = KBArticle(
  id: 'esg-sustainability-reporting',
  title: Bi('ESG and Sustainability Reporting', 'تقارير الاستدامة والحوكمة البيئية والاجتماعية'),
  category: 'financial-statements',
  level: KBLevel.intermediate,
  readingMinutes: 6,
  summary: Bi('What ESG information reports, the two materiality lenses that divide the frameworks, the ISSB baseline (IFRS S1 and S2) now consolidating the field, emissions scopes, and how to read a sustainability report without being greenwashed.', 'ما الذي تبلغ عنه معلومات ESG، وعدسـتا الأهمية النسبية اللتان تقسمان الأطر، وخط الأساس من مجلس ISSB (المعياران IFRS S1 وS2) الذي يوحد المجال الآن، ونطاقات الانبعاثات، وكيف يُقرأ تقرير استدامة دون الوقوع في الغسل الأخضر.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('ESG reporting discloses how a company interacts with the environment (emissions, energy, water, waste), society (workforce safety, labor practices, community, product responsibility), and governance (board composition, ethics, controls). Two forces made it mainstream. Investors concluded that climate transition, resource scarcity, and social license affect cash flows and risk, so they demand decision-useful data. And regulators concluded that markets cannot price what companies do not disclose. The balance-sheet article in this knowledge base notes what accounting leaves out; sustainability reporting is the systematic attempt to report a slice of exactly that.', 'تفصح تقارير ESG عن كيفية تعامل الشركة مع البيئة (الانبعاثات والطاقة والمياه والنفايات)، والمجتمع (سلامة القوى العاملة وممارسات العمل والمجتمع المحلي ومسؤولية المنتج)، والحوكمة (تركيبة المجلس والأخلاقيات والضوابط). وقد عمّمها دافعان. خلص المستثمرون إلى أن التحول المناخي وندرة الموارد والرخصة الاجتماعية تمس التدفقات والمخاطر، فطلبوا بيانات نافعة للقرار. وخلص المنظمون إلى أن الأسواق لا تستطيع تسعير ما لا تفصح عنه الشركات. ومقالة الميزانية في قاعدة المعرفة هذه تشير إلى ما تغفله المحاسبة؛ وتقارير الاستدامة هي المحاولة المنهجية للإبلاغ عن شريحة من ذلك بالذات.'),
      ],
    ),
    KBSection(
      heading: Bi('Two materiality lenses, one consolidating baseline', 'عدستا أهمية نسبية وخط أساس يتوحد'),
      paragraphs: [
        Bi('The framework landscape is best understood through one question: material to whom? Financial materiality asks what sustainability matters affect the company\'s own value: the investor lens. Impact materiality asks what the company does to the world regardless of the effect on its value: the stakeholder lens. The ISSB standards (IFRS S1 for general sustainability disclosures, IFRS S2 for climate, both issued 2023 by the IFRS Foundation) take the investor lens and are becoming the global baseline, absorbing the earlier TCFD architecture of governance, strategy, risk management, metrics and targets. GRI remains the reference for impact materiality, and Europe\'s CSRD/ESRS requires double materiality: both lenses at once. In the Gulf, the Saudi Exchange has published ESG disclosure guidelines and regional adoption of the ISSB baseline is progressing, so professionals should expect the investor-lens vocabulary to dominate regulatory conversations.', 'يُفهم مشهد الأطر عبر سؤال واحد: جوهري لمن؟ الأهمية المالية تسأل أي قضايا الاستدامة تمس قيمة الشركة ذاتها: عدسة المستثمر. وأهمية الأثر تسأل ماذا تفعل الشركة بالعالم بصرف النظر عن أثر ذلك في قيمتها: عدسة أصحاب المصلحة. معايير مجلس ISSB (المعيار IFRS S1 للإفصاحات العامة وIFRS S2 للمناخ، وكلاهما صدر 2023 عن مؤسسة IFRS) تتبنى عدسة المستثمر وتتحول إلى خط الأساس العالمي، مستوعبةً معمارية TCFD السابقة: الحوكمة والاستراتيجية وإدارة المخاطر والمقاييس والمستهدفات. وتبقى GRI مرجع أهمية الأثر، وتوجب أوروبا في CSRD/ESRS الأهمية المزدوجة: العدستين معاً. وفي الخليج نشرت تداول السعودية إرشادات إفصاح ESG ويتقدم تبني خط أساس ISSB إقليمياً، فعلى المهنيين توقع هيمنة مفردات عدسة المستثمر على الحوار التنظيمي.'),
      ],
      table: KBTable(
        headers: [
          Bi('Framework', 'الإطار'),
          Bi('Lens', 'العدسة'),
          Bi('Role today', 'الدور اليوم'),
        ],
        rows: [
          [
            Bi('ISSB: IFRS S1/S2', 'ISSB: المعياران IFRS S1/S2'),
            Bi('Financial materiality', 'الأهمية المالية'),
            Bi('Global investor baseline, absorbing TCFD', 'خط الأساس العالمي للمستثمرين، مستوعباً TCFD'),
          ],
          [
            Bi('GRI', 'GRI'),
            Bi('Impact materiality', 'أهمية الأثر'),
            Bi('Stakeholder reporting reference', 'مرجع تقارير أصحاب المصلحة'),
          ],
          [
            Bi('CSRD / ESRS (EU)', 'CSRD / ESRS (الاتحاد الأوروبي)'),
            Bi('Double materiality', 'الأهمية المزدوجة'),
            Bi('Mandatory for EU-scope companies', 'إلزامي للشركات في نطاق الاتحاد'),
          ],
          [
            Bi('Saudi Exchange guidelines', 'إرشادات تداول السعودية'),
            Bi('Investor-oriented', 'موجهة للمستثمرين'),
            Bi('Listed-company disclosure guidance', 'إرشاد إفصاح للشركات المدرجة'),
          ],
        ],
      ),
    ),
    KBSection(
      heading: Bi('The metrics: emissions scopes and targets', 'المقاييس: نطاقات الانبعاثات والمستهدفات'),
      paragraphs: [
        Bi('Climate metrics rest on the GHG Protocol\'s three scopes. Scope 1: direct emissions from sources the company owns or controls (its boilers, its vehicle fleet). Scope 2: indirect emissions from purchased electricity, steam, heating and cooling. Scope 3: everything else along the value chain, upstream and downstream (purchased goods, logistics, business travel, use of sold products), typically the largest and always the hardest to measure, because it depends on suppliers\' and customers\' data. IFRS S2 requires disclosure of all three scopes, with transition relief on Scope 3 timing. Targets deserve the same scrutiny as the metrics: a credible one names a base year, a horizon, the scopes covered, and the share of reduction versus offsets; "net zero by 2050" with no interim milestones is a slogan wearing a date.', 'تقوم مقاييس المناخ على النطاقات الثلاثة لبروتوكول غازات الدفيئة. النطاق 1: انبعاثات مباشرة من مصادر تملكها الشركة أو تسيطر عليها (غلاياتها وأسطول مركباتها). والنطاق 2: انبعاثات غير مباشرة من الكهرباء والبخار والتدفئة والتبريد المشتراة. والنطاق 3: كل ما عدا ذلك على امتداد سلسلة القيمة صعوداً ونزولاً (السلع المشتراة، والخدمات اللوجستية، وسفر الأعمال، واستخدام المنتجات المباعة)، وهو الأكبر عادة والأصعب قياساً دوماً لاعتماده على بيانات الموردين والعملاء. ويوجب IFRS S2 الإفصاح عن النطاقات الثلاثة مع تيسير انتقالي لتوقيت النطاق 3. وتستحق المستهدفات تدقيق المقاييس نفسه: المستهدف الموثوق يسمي سنة أساس وأفقاً والنطاقات المشمولة وحصة الخفض مقابل التعويضات؛ أما «الحياد الصفري بحلول 2050» بلا محطات مرحلية فشعارٌ يرتدي تاريخاً.'),
      ],
    ),
    KBSection(
      heading: Bi('Reading a report without being greenwashed', 'قراءة التقرير دون غسل أخضر'),
      paragraphs: [
        Bi('Apply the same skepticism financial statements earn. Check the boundary: does the reported data cover the whole group or the convenient subsidiaries? Check comparability: same metrics, same base year, restated when the business changed? Check the direction of selectivity: glossy pages on the small good news, a footnote for the material bad news, is the signature of greenwashing. Check assurance: limited assurance on selected indicators is the current norm under ISAE 3000 (Revised), and ISSA 5000 will professionalize the field once it takes effect for periods beginning on or after 15 December 2026, but "assured" on the cover rarely means everything inside was verified. And connect to the money: under IFRS S1 the sustainability disclosures are supposed to link to the financial statements, so ask where the transition plan shows up in capex, impairment assumptions, and provisions. A transition narrative with no financial footprint is a story, not a strategy.', 'طبق الشك نفسه الذي تستحقه القوائم المالية. افحص الحدود: هل تغطي البيانات المجموعة كلها أم الشركات التابعة المريحة؟ وافحص القابلية للمقارنة: المقاييس ذاتها وسنة الأساس ذاتها مع إعادة عرض عند تغير الأعمال؟ وافحص اتجاه الانتقائية: صفحات لامعة للخبر الجيد الصغير وحاشية للخبر السيئ الجوهري هي توقيع الغسل الأخضر. وافحص التوكيد: التوكيد المحدود على مؤشرات مختارة هو العرف الحالي وفق ISAE 3000 (المعدل)؛ وسيمهنن ISSA 5000 المجال متى نفذ للفترات التي تبدأ في 15 ديسمبر 2026 أو بعده، لكن كلمة «مؤكَّد» على الغلاف نادراً ما تعني أن كل ما بداخله تم التحقق منه. واربط بالمال: بموجب IFRS S1 يفترض أن تتصل إفصاحات الاستدامة بالقوائم المالية، فاسأل أين تظهر خطة التحول في الإنفاق الرأسمالي وافتراضات الهبوط والمخصصات. سرديةُ تحولٍ بلا أثر مالي حكايةٌ لا استراتيجية.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Treating an ESG rating as a fact. Rating agencies disagree with each other far more than credit raters do; read the underlying disclosures.', 'اعتبار تصنيف ESG حقيقة. وكالات التصنيف تختلف فيما بينها أكثر بكثير من مصنفي الائتمان؛ اقرأ الإفصاحات الأصلية.'),
    Bi('Comparing companies on Scope 1 and 2 alone when the business model puts the real footprint in Scope 3.', 'مقارنة الشركات على النطاقين 1 و2 فقط بينما يضع نموذج الأعمال البصمة الحقيقية في النطاق 3.'),
    Bi('Reading intensity improvements (emissions per unit) as absolute progress while volumes grow faster than the intensity falls.', 'قراءة تحسن الكثافة (الانبعاثات لكل وحدة) تقدماً مطلقاً بينما تنمو الأحجام أسرع من هبوط الكثافة.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IFRS S1 · IFRS S2',
      note: Bi('The ISSB baseline: general sustainability-related disclosures and climate, structured on governance, strategy, risk management, metrics and targets.', 'خط أساس ISSB: الإفصاحات العامة المتصلة بالاستدامة والمناخ، على هيكل الحوكمة والاستراتيجية وإدارة المخاطر والمقاييس والمستهدفات.'),
      segments: [
        KBStandardSegment('IFRS S1', href: 'https://www.ifrs.org/issued-standards/ifrs-sustainability-standards-navigator/ifrs-s1-general-requirements/'),
        KBStandardSegment(' · '),
        KBStandardSegment('IFRS S2', href: 'https://www.ifrs.org/issued-standards/ifrs-sustainability-standards-navigator/ifrs-s2-climate-related-disclosures/'),
      ],
    ),
    KBStandardRef(
      standard: 'GHG Protocol',
      note: Bi('The corporate accounting standard behind Scope 1, 2, and 3 emissions.', 'معيار المحاسبة المؤسسية وراء انبعاثات النطاقات 1 و2 و3.'),
      segments: [
        KBStandardSegment('GHG Protocol', href: 'https://ghgprotocol.org/standards'),
      ],
    ),
    KBStandardRef(
      standard: 'ISSA 5000 (effective 15 December 2026)',
      note: Bi('The IAASB\'s general sustainability assurance standard: the audit profession\'s answer to greenwashing risk.', 'معيار التوكيد العام للاستدامة من IAASB: جواب مهنة التدقيق على مخاطر الغسل الأخضر.'),
      segments: [
        KBStandardSegment('ISSA 5000', href: 'https://www.iaasb.org/publications/international-standard-sustainability-assurance-5000-general-requirements-sustainability-assurance'),
        KBStandardSegment(' (effective 15 December 2026)'),
      ],
    ),
  ],
  relatedTerms: [
    'Materiality',
  ],
  relatedModules: [
    KBRelatedModule('/education/reporting-standards', Bi('Module: IPSAS Reporting', 'الوحدة: تقارير IPSAS')),
    KBRelatedModule('/education/compliance', Bi('Module: Compliance', 'الوحدة: الالتزام')),
  ],
  relatedArticles: [
    'balance-sheet',
    'internal-control-audit',
  ],
  references: [
    'IFRS Foundation. (2023). IFRS S1 General requirements for disclosure of sustainability-related financial information; IFRS S2 Climate-related disclosures. IFRS Foundation.',
    'World Resources Institute & WBCSD. (2004). The greenhouse gas protocol: A corporate accounting and reporting standard (revised ed.). WRI/WBCSD.',
    'International Auditing and Assurance Standards Board. (2024). ISSA 5000: General requirements for sustainability assurance engagements. IFAC.',
    'Saudi Exchange. (2021). ESG disclosure guidelines. Saudi Tadawul Group.',
  ],
  keywords: [
    'ESG',
    'sustainability',
    'ISSB',
    'IFRS S2',
    'GRI',
    'scope 3',
    'greenwashing',
    'double materiality',
    'استدامة',
    'انبعاثات',
    'غسل أخضر',
    'أهمية نسبية',
  ],
);
