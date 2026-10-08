// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/financial-instruments.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbFinancialInstruments = KBArticle(
  id: 'financial-instruments',
  title: Bi('Financial Instruments under IFRS 9', 'الأدوات المالية وفق IFRS 9'),
  category: 'accounting-foundations',
  level: KBLevel.advanced,
  readingMinutes: 7,
  summary: Bi('How a financial asset is classified (amortized cost, FVOCI, FVTPL), why the business model and the cash flow test both matter, the expected credit loss model that replaced waiting for default, and a worked ECL provision.', 'كيف يُصنَّف الأصل المالي (التكلفة المطفأة، والقيمة العادلة عبر الدخل الشامل، والقيمة العادلة عبر الأرباح)، ولماذا يهم نموذج الأعمال واختبار التدفقات معاً، ونموذج الخسائر الائتمانية المتوقعة الذي حل محل انتظار التعثر، ومخصص محلول.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('A financial instrument is a contract that creates a financial asset for one party and a financial liability or equity instrument for another: cash, receivables, loans, bonds, shares, derivatives. The accounting question is deceptively simple. Do you carry the instrument at what you paid, adjusted over time, or at what it is worth today? IFRS 9 answers it by asking what the company actually intends to do with the asset, because the same bond is a different economic thing to a bank holding it to maturity and to a trader flipping it next week. Classification therefore drives measurement, and measurement drives whether market movements land in profit, in other comprehensive income, or nowhere at all until sale.', 'الأداة المالية عقدٌ ينشئ أصلاً مالياً لطرف والتزاماً مالياً أو أداة حقوق ملكية لطرف آخر: نقد وذمم مدينة وقروض وسندات وأسهم ومشتقات. والسؤال المحاسبي أبسط مما يبدو. هل تحمل الأداة بما دفعته معدَّلاً عبر الزمن، أم بما تساويه اليوم؟ يجيب IFRS 9 بسؤال عما تنوي الشركة فعله بالأصل حقاً، لأن السند نفسه شيء اقتصادي مختلف لدى بنك يحتفظ به حتى الاستحقاق وتاجرٍ يبيعه الأسبوع المقبل. فالتصنيف إذن يقود القياس، والقياس يقرر هل تهبط تحركات السوق في الأرباح أم في الدخل الشامل الآخر أم لا تظهر إطلاقاً حتى البيع.'),
      ],
    ),
    KBSection(
      heading: Bi('The formal treatment: two tests, three categories', 'المعالجة النظرية: اختباران وثلاث فئات'),
      paragraphs: [
        Bi('Every financial asset passes through two tests. The business model test asks whether the company holds the asset to collect contractual cash flows, to collect and also to sell, or for something else such as trading. The cash flow characteristics test, usually called SPPI, asks whether the contractual terms give rise solely to payments of principal and interest on the principal outstanding. An asset held to collect that passes SPPI is measured at amortized cost. An asset held both to collect and to sell that passes SPPI is measured at fair value through other comprehensive income, so market swings sit in equity until realization. Everything else, including derivatives and any instrument failing SPPI, is measured at fair value through profit or loss, where every movement hits earnings. Equity investments are FVTPL by default, and those neither held for trading nor contingent consideration in a business combination carry an irrevocable option at initial recognition to present fair value changes in OCI, and under that election the gains are never recycled to profit even on sale. Financial liabilities remain at amortized cost unless held for trading or designated at fair value.', 'يمر كل أصل مالي باختبارين. اختبار نموذج الأعمال يسأل هل تحتفظ الشركة بالأصل لتحصيل تدفقات تعاقدية، أم للتحصيل والبيع معاً، أم لغرض آخر كالمتاجرة. واختبار خصائص التدفقات، ويُسمى عادةً SPPI، يسأل هل تنشئ الشروط التعاقدية دفعات أصلٍ وفائدة على الأصل القائم فحسب. فالأصل المحتفظ به للتحصيل والمجتاز لاختبار SPPI يُقاس بالتكلفة المطفأة. والأصل المحتفظ به للتحصيل والبيع معاً والمجتاز للاختبار يُقاس بالقيمة العادلة عبر الدخل الشامل الآخر، فتستقر تقلبات السوق في حقوق الملكية حتى التحقق. وكل ما عداهما، ومنه المشتقات وأي أداة تخفق في SPPI، يُقاس بالقيمة العادلة عبر الأرباح أو الخسائر حيث تصيب كل حركة الأرباح. واستثمارات حقوق الملكية تقع افتراضاً في القيمة العادلة عبر الأرباح، وما لم يكن منها محتفظاً به للمتاجرة ولا عوضاً محتملاً في اندماج أعمال فله خيار غير قابل للنقض عند الاعتراف الأولي بعرض تغيرات القيمة العادلة في الدخل الشامل، وبموجب ذلك الخيار لا تُعاد المكاسب إلى الأرباح أبداً ولو عند البيع. أما الالتزامات المالية فتبقى بالتكلفة المطفأة ما لم تكن للمتاجرة أو مصنفة بالقيمة العادلة.'),
      ],
      formulas: [
        KBFormula('Amortized cost carrying amount = Opening balance + Effective interest − Cash received − Loss allowance', caption: Bi('The amortized cost roll-forward: interest accrues on the effective yield, not the coupon.', 'تدحرج التكلفة المطفأة: الفائدة تتراكم على العائد الفعلي لا على الكوبون.')),
        KBFormula('ECL = Probability of default × Loss given default × Exposure at default', caption: Bi('Expected credit loss, discounted to present value and weighted across scenarios.', 'الخسارة الائتمانية المتوقعة، مخصومة إلى القيمة الحالية ومرجحة عبر السيناريوهات.')),
      ],
    ),
    KBSection(
      heading: Bi('Worked example: an expected credit loss provision', 'مثال محلول: مخصص خسائر ائتمانية متوقعة'),
      paragraphs: [
        Bi('A company holds trade receivables of SAR 20m and applies the simplified approach IFRS 9 requires for trade receivables without a significant financing component, a provision matrix based on ageing. Historical experience, adjusted for the expected economy, gives loss rates of 0.5% on current balances, 3% on 1 to 30 days overdue, 10% on 31 to 90 days, and 30% beyond 90 days. With balances of 14m, 3m, 2m and 1m respectively, the allowance is (14 × 0.5%) + (3 × 3%) + (2 × 10%) + (1 × 30%) = 0.07 + 0.09 + 0.20 + 0.30 = SAR 0.66m. Notice what the old rules would have shown: under the previous incurred-loss model, nothing would be provided until a specific customer showed signs of trouble. IFRS 9 requires a loss on day one, on receivables the company fully expects to collect, because across a portfolio some of them statistically will not pay. That is the shift the standard was written to make after the financial crisis: provisioning too little too late was the diagnosis, and forward-looking expected loss was the cure.', 'تحمل شركة ذمماً مدينة تجارية بعشرين مليون ريال وتطبق النهج المبسط الذي يوجبه IFRS 9 للذمم التجارية الخالية من مكوّن تمويلي جوهري، أي مصفوفة مخصص قائمة على الأعمار. تعطي الخبرة التاريخية، معدلةً بالاقتصاد المتوقع، معدلات خسارة قدرها 0.5% على الأرصدة الجارية، و3% على المتأخر من يوم إلى ثلاثين، و10% على 31 إلى 90 يوماً، و30% لما تجاوز التسعين. وبأرصدة قدرها 14 و3 و2 ومليون على التوالي، يكون المخصص (14 × 0.5%) + (3 × 3%) + (2 × 10%) + (1 × 30%) = 0.07 + 0.09 + 0.20 + 0.30 = 0.66 مليون ريال. ولاحظ ما كانت ستعرضه القواعد القديمة: فبنموذج الخسارة المتكبدة السابق، لا يُخصص شيء حتى يُظهر عميل بعينه بوادر تعثر. أما IFRS 9 فيوجب خسارة من اليوم الأول، على ذمم تتوقع الشركة تحصيلها كاملة، لأن بعضها إحصائياً لن يُسدَّد على مستوى المحفظة. وهذا هو التحول الذي كُتب المعيار لإحداثه بعد الأزمة المالية: كان التشخيص أن التخصيص جاء قليلاً ومتأخراً، وكان العلاج خسارةً متوقعة استشرافية.'),
      ],
    ),
    KBSection(
      heading: Bi('The three stages and what they signal', 'المراحل الثلاث وما تشير إليه'),
      paragraphs: [
        Bi('For loans and debt instruments, the general model runs in three stages. Stage 1 covers performing exposures and provides for losses expected from defaults within the next twelve months. Stage 2 begins when credit risk has increased significantly since origination, and the provision jumps to lifetime expected losses even though no payment has been missed. Stage 3 is credit-impaired, where interest itself is calculated on the net carrying amount. The practical consequence is that a bank’s provision can rise sharply before a single borrower defaults, simply because the outlook darkened, and the movement between stages is disclosed. For anyone reading a lender’s accounts, the stage 2 balance is the early-warning indicator: it is management telling you which part of the book it has quietly reclassified as worrying.', 'للقروض وأدوات الدين يعمل النموذج العام على ثلاث مراحل. المرحلة الأولى تغطي التعرضات المنتظمة وتخصص للخسائر المتوقعة من التعثرات خلال اثني عشر شهراً. وتبدأ المرحلة الثانية حين ترتفع مخاطر الائتمان ارتفاعاً جوهرياً منذ النشأة، فيقفز المخصص إلى الخسائر المتوقعة على مدى العمر رغم أن أي دفعة لم تفت. والمرحلة الثالثة هي الهبوط الائتماني حيث تُحسب الفائدة نفسها على صافي المبلغ الدفتري. والنتيجة العملية أن مخصص البنك قد يرتفع بحدة قبل أن يتعثر مقترض واحد، لمجرد أن الأفق أظلم، والحركة بين المراحل يُفصح عنها. ولمن يقرأ حسابات مقرض، يكون رصيد المرحلة الثانية مؤشر الإنذار المبكر: فهو إخبار الإدارة لك بالجزء الذي أعادت تصنيفه بهدوء إلى خانة القلق.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Reading a fair value gain in OCI as earnings quality: under the equity election those gains never pass through profit, so a company can build large unrealized gains that never appear in EPS.', 'قراءة مكسب القيمة العادلة في الدخل الشامل بوصفه جودة أرباح: فبموجب خيار حقوق الملكية لا تمر تلك المكاسب أبداً عبر الأرباح، فقد تتراكم مكاسب غير محققة كبيرة لا تظهر قط في ربحية السهم.'),
    Bi('Assuming an expected credit loss means the company expects not to be paid. ECL is a probability-weighted portfolio number, not a judgment about any single customer.', 'افتراض أن الخسارة الائتمانية المتوقعة تعني أن الشركة لا تتوقع السداد. فهي رقم محفظة مرجح بالاحتمالات، لا حكم على عميل بعينه.'),
    Bi('Classifying by instrument name rather than by the two tests: a plain-looking bond with a leverage feature fails SPPI and lands in fair value through profit or loss.', 'التصنيف باسم الأداة بدل الاختبارين: فسند يبدو بسيطاً وفيه خاصية رافعة يخفق في SPPI ويقع في القيمة العادلة عبر الأرباح.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IFRS 9',
      note: Bi('Financial instruments: classification and measurement, the expected credit loss model, and hedge accounting.', 'الأدوات المالية: التصنيف والقياس، ونموذج الخسائر الائتمانية المتوقعة، ومحاسبة التحوط.'),
      segments: [
        KBStandardSegment('IFRS 9', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ifrs-9-financial-instruments/'),
      ],
    ),
    KBStandardRef(
      standard: 'IAS 32',
      note: Bi('Presentation: the debt-versus-equity classification that decides whether an instrument is a liability at all.', 'العرض: تصنيف الدين مقابل حقوق الملكية الذي يقرر أصلاً هل الأداة التزام.'),
      segments: [
        KBStandardSegment('IAS 32', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-32-financial-instruments-presentation/'),
      ],
    ),
    KBStandardRef(
      standard: 'IFRS 7',
      note: Bi('Disclosures: credit risk, liquidity risk and market risk, including the ECL staging tables.', 'الإفصاحات: مخاطر الائتمان والسيولة والسوق، بما فيها جداول مراحل الخسائر المتوقعة.'),
      segments: [
        KBStandardSegment('IFRS 7', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ifrs-7-financial-instruments-disclosures/'),
      ],
    ),
  ],
  relatedTerms: [
    'Fair Value',
    'Marketable Securities',
    'Short-term Investments',
    'Long-term Investments',
    'Allowance for Doubtful Accounts',
    'Bad Debt Expense',
    'Accounts Receivable',
  ],
  relatedModules: [
    KBRelatedModule('/education/financial-analysis', Bi('Module: Analysis of Financial Statements', 'الوحدة: تحليل القوائم المالية')),
    KBRelatedModule('/education/fundamentals', Bi('Module: Financial Management Primer (Financing pillar)', 'الوحدة: تمهيد الإدارة المالية (ركيزة التمويل)')),
  ],
  relatedArticles: [
    'bonds-and-sukuk',
    'risk-management-hedging',
    'balance-sheet',
    'working-capital',
    'impairment-testing',
    'foreign-currency',
    'fair-value-measurement',
  ],
  references: [
    'IFRS Foundation. (2014). IFRS 9 Financial Instruments. IFRS Foundation.',
    'IFRS Foundation. (2005). IFRS 7 Financial Instruments: Disclosures. IFRS Foundation.',
    'Picker, R., Clark, K., Dunn, J., Kolitz, D., Livne, G., Loftus, J., & van der Tas, L. (2019). Applying IFRS standards (4th ed.). Wiley.',
    'Hull, J. C. (2018). Risk management and financial institutions (5th ed.). Wiley.',
  ],
  keywords: [
    'IFRS 9',
    'financial instruments',
    'amortized cost',
    'FVOCI',
    'FVTPL',
    'expected credit loss',
    'ECL',
    'SPPI',
    'staging',
    'الأدوات المالية',
    'التكلفة المطفأة',
    'الخسائر الائتمانية المتوقعة',
  ],
);
