// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/leases-ifrs16.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbLeasesIfrs16 = KBArticle(
  id: 'leases-ifrs16',
  title: Bi('Lease Accounting under IFRS 16', 'محاسبة عقود الإيجار وفق IFRS 16'),
  category: 'accounting-foundations',
  level: KBLevel.intermediate,
  readingMinutes: 6,
  summary: Bi('How IFRS 16 moved leases onto the balance sheet, the right-of-use asset and lease liability mechanics, a worked capitalization, and what the change did to familiar ratios.', 'كيف نقل IFRS 16 عقود الإيجار إلى الميزانية، وآلية أصل حق الاستخدام والتزام الإيجار، ومثال رسملة محلول، وما الذي فعله التغيير بالنسب المألوفة.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('A lease is the right to use an asset for a period in exchange for payments. For decades, companies could sign ten-year commitments for stores, aircraft and warehouses and keep both the asset and the obligation off the balance sheet by classifying the lease as operating. Analysts adjusted for it by hand because the economics were obvious: a non-cancellable payment stream is debt in everything but name. IFRS 16, effective 2019, ended the distinction for lessees. Nearly every lease now puts two things on the balance sheet: a right-of-use asset (the value of using the thing) and a lease liability (the present value of the promised payments). The income statement changes too: instead of one rent expense line, the lessee reports depreciation of the right-of-use asset plus interest on the lease liability.', 'عقد الإيجار هو حق استخدام أصل لفترة مقابل دفعات. ولعقود من الزمن استطاعت الشركات توقيع التزامات عشر سنوات لمتاجر وطائرات ومستودعات وإبقاء الأصل والالتزام معاً خارج الميزانية بتصنيف العقد إيجاراً تشغيلياً. وكان المحللون يعدلون ذلك يدوياً لأن الجوهر الاقتصادي واضح: تيار دفعات غير قابل للإلغاء دينٌ بكل شيء إلا الاسم. أنهى IFRS 16، النافذ منذ 2019، هذا التمييز لدى المستأجرين. فكل عقد إيجار تقريباً يضع الآن شيئين في الميزانية: أصل حق استخدام (قيمة الانتفاع بالشيء) والتزام إيجار (القيمة الحالية للدفعات الموعودة). وتتغير قائمة الدخل أيضاً: فبدل سطر واحد لمصروف الإيجار، يعرض المستأجر استهلاك أصل حق الاستخدام مضافاً إليه فائدة التزام الإيجار.'),
      ],
    ),
    KBSection(
      heading: Bi('The formal treatment: initial and subsequent measurement', 'المعالجة النظرية: القياس الأولي واللاحق'),
      paragraphs: [
        Bi('At commencement, the lease liability is the present value of the remaining lease payments, discounted at the rate implicit in the lease or, more commonly, the lessee’s incremental borrowing rate. The right-of-use asset starts at the same amount plus initial direct costs and restoration obligations. Afterwards the two halves live separate lives: the asset is depreciated, usually straight-line over the lease term, while the liability follows amortized-cost mechanics, growing by the interest charge and shrinking by each payment. Because interest is highest early in the term, total lease expense is front-loaded compared with the old flat rent charge. Two practical exemptions survive: leases of twelve months or less that contain no purchase option, and leases of low-value assets, may still be expensed straight-line over the lease term (or on another systematic basis) rather than capitalized.', 'عند بدء العقد، يكون التزام الإيجار هو القيمة الحالية للدفعات المتبقية مخصومةً بالمعدل الضمني في العقد، أو الأكثر شيوعاً بمعدل الاقتراض الإضافي للمستأجر. ويبدأ أصل حق الاستخدام بالمبلغ نفسه مضافاً إليه التكاليف المباشرة الأولية والتزامات إعادة الموقع إلى حاله. وبعدها يعيش الشقان حياتين منفصلتين: يُستهلك الأصل عادةً بالقسط الثابت على مدة العقد، بينما يتبع الالتزام آلية التكلفة المطفأة فينمو بعبء الفائدة وينكمش بكل دفعة. ولأن الفائدة أعلى في أول المدة، يكون مجموع مصروف الإيجار مُحمَّلاً على البدايات مقارنة بمصروف الإيجار الثابت القديم. ويبقى إعفاءان عمليان: عقود اثني عشر شهراً فأقل الخالية من خيار الشراء، وعقود الأصول منخفضة القيمة، يجوز إثباتها مصروفاً بالقسط الثابت على مدة العقد (أو على أساس منهجي آخر) بدل رسملتها.'),
      ],
      formulas: [
        KBFormula('Lease liability₀ = Σ Paymentₜ ÷ (1 + r)ᵗ', caption: Bi('Initial lease liability: present value of the lease payments at the discount rate r.', 'التزام الإيجار الأولي: القيمة الحالية لدفعات الإيجار بمعدل الخصم r.')),
        KBFormula('Liabilityₜ = Liabilityₜ₋₁ × (1 + r) − Paymentₜ', caption: Bi('Subsequent measurement: the liability accrues interest and is reduced by each payment.', 'القياس اللاحق: يتراكم على الالتزام فائدة وتخفضه كل دفعة.')),
      ],
    ),
    KBSection(
      heading: Bi('Worked example: capitalizing a warehouse lease', 'مثال محلول: رسملة عقد إيجار مستودع'),
      paragraphs: [
        Bi('A company signs a five-year warehouse lease at SAR 100,000 per year, paid at each year-end, and its incremental borrowing rate is 6%. The lease liability at commencement is the present value of five payments of 100,000 at 6%, which is 100,000 × 4.2124 = SAR 421,236. The right-of-use asset starts at the same figure. In year one, depreciation is 421,236 ÷ 5 = SAR 84,247 and interest is 6% × 421,236 = SAR 25,274, so total expense is SAR 109,521 against cash rent of SAR 100,000. The liability ends year one at 421,236 × 1.06 − 100,000 = SAR 346,510. By year four the pattern reverses and expense falls below the rent. Same cash, same warehouse; the accounting now shows the SAR 421,236 obligation the company always had.', 'توقع شركة عقد إيجار مستودع لخمس سنوات بمئة ألف ريال سنوياً تُدفع نهاية كل سنة، ومعدل اقتراضها الإضافي 6%. التزام الإيجار عند البدء هو القيمة الحالية لخمس دفعات من 100,000 عند 6%، أي 100,000 × 4.2124 = 421,236 ريالاً. ويبدأ أصل حق الاستخدام بالرقم نفسه. في السنة الأولى، الاستهلاك 421,236 ÷ 5 = 84,247 ريالاً والفائدة 6% × 421,236 = 25,274 ريالاً، فمجموع المصروف 109,521 ريالاً مقابل إيجار نقدي قدره 100,000 ريال. وينتهي الالتزام في السنة الأولى عند 421,236 × 1.06 − 100,000 = 346,510 ريالات. وبحلول السنة الرابعة ينعكس النمط ويهبط المصروف دون الإيجار. النقد نفسه والمستودع نفسه؛ لكن المحاسبة تعرض الآن التزام 421,236 ريالاً الذي كان على الشركة دائماً.'),
      ],
    ),
    KBSection(
      heading: Bi('What IFRS 16 did to the ratios', 'ما الذي فعله IFRS 16 بالنسب'),
      paragraphs: [
        Bi('The standard changed reported numbers without changing a single business. EBITDA rose, because rent left operating expenses and returned as depreciation and interest below the EBITDA line. Reported debt rose by the lease liabilities. Operating cash flow improved, because the principal portion of lease payments moved to financing activities. Asset turnover fell, because the denominator gained right-of-use assets. Any comparison that crosses 2019, or crosses into a company reporting under a framework that kept operating leases off balance sheet, must adjust before concluding anything. The lesson generalizes: when a ratio jumps, ask first whether the business changed or the measurement did.', 'غيّر المعيار الأرقام المعروضة دون أن يغيّر عملاً واحداً. ارتفع EBITDA لأن الإيجار غادر المصروفات التشغيلية وعاد استهلاكاً وفائدةً تحت سطر EBITDA. وارتفع الدين المعروض بمقدار التزامات الإيجار. وتحسن التدفق النقدي التشغيلي لأن جزء أصل الدين من دفعات الإيجار انتقل إلى أنشطة التمويل. وانخفض معدل دوران الأصول لأن المقام اكتسب أصول حق الاستخدام. وأي مقارنة تعبر سنة 2019، أو تعبر نحو شركة تُقرِّر وفق إطار أبقى الإيجارات التشغيلية خارج الميزانية، يجب أن تُعدَّل قبل استخلاص أي شيء. والدرس يعمم: حين تقفز نسبةٌ ما، اسأل أولاً هل تغيّر العمل أم تغيّر القياس.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Comparing EBITDA or leverage across the IFRS 16 boundary (over time or across frameworks) without restating: the jump is accounting, not performance.', 'مقارنة EBITDA أو الرافعة عبر حدود IFRS 16 (عبر الزمن أو عبر الأطر) دون إعادة عرض: القفزة محاسبة لا أداء.'),
    Bi('Assuming the right-of-use asset and the lease liability stay equal: they diverge immediately, because straight-line depreciation and amortized-cost interest follow different paths.', 'افتراض بقاء أصل حق الاستخدام والتزام الإيجار متساويين: فهما يفترقان فوراً، لأن الاستهلاك الثابت وفائدة التكلفة المطفأة يسلكان مسارين مختلفين.'),
    Bi('Forgetting that lessor accounting kept the old finance/operating distinction: the symmetry many expect between the two sides of the same contract does not exist.', 'نسيان أن محاسبة المؤجر احتفظت بالتمييز القديم بين التمويلي والتشغيلي: فالتناظر الذي يتوقعه كثيرون بين طرفي العقد نفسه غير موجود.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IFRS 16',
      note: Bi('Leases: the single lessee model (right-of-use asset plus lease liability) with the short-term and low-value exemptions.', 'عقود الإيجار: نموذج المستأجر الموحد (أصل حق الاستخدام مع التزام الإيجار) مع إعفاءي قصر الأجل وانخفاض القيمة.'),
      segments: [
        KBStandardSegment('IFRS 16', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ifrs-16-leases/'),
      ],
    ),
    KBStandardRef(
      standard: 'IAS 17 (superseded)',
      note: Bi('The old standard whose operating/finance split for lessees IFRS 16 replaced in 2019; you will still meet it in older statements.', 'المعيار القديم الذي استبدل IFRS 16 في 2019 تقسيمَه التشغيلي/التمويلي لدى المستأجرين؛ وستظل تقابله في قوائم أقدم.'),
      segments: [
        KBStandardSegment('IAS 17', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-17-leases/'),
        KBStandardSegment(' (superseded)'),
      ],
    ),
  ],
  relatedTerms: [
    'Right-of-Use Asset',
    'Lease Liabilities',
    'Finance Lease',
    'Operating Lease',
    'EBITDA',
    'Depreciation',
  ],
  relatedModules: [
    KBRelatedModule('/education/fundamentals', Bi('Module: Financial Management Primer (Financing pillar)', 'الوحدة: تمهيد الإدارة المالية (ركيزة التمويل)')),
    KBRelatedModule('/education/financial-analysis', Bi('Module: Analysis of Financial Statements', 'الوحدة: تحليل القوائم المالية')),
  ],
  relatedArticles: [
    'balance-sheet',
    'depreciation-methods',
    'time-value-of-money',
    'financial-ratios',
    'capital-structure',
    'investment-property',
    'credit-analysis',
  ],
  references: [
    'IFRS Foundation. (2016). IFRS 16 Leases. IFRS Foundation.',
    'Picker, R., Clark, K., Dunn, J., Kolitz, D., Livne, G., Loftus, J., & van der Tas, L. (2019). Applying IFRS standards (4th ed.). Wiley.',
    'Kieso, D. E., Weygandt, J. J., & Warfield, T. D. (2020). Intermediate accounting: IFRS edition (4th ed.). Wiley.',
  ],
  keywords: [
    'lease',
    'IFRS 16',
    'right-of-use asset',
    'lease liability',
    'operating lease',
    'finance lease',
    'capitalization',
    'عقود الإيجار',
    'أصل حق الاستخدام',
    'التزام الإيجار',
  ],
);
