// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/bonds-and-sukuk.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbBondsAndSukuk = KBArticle(
  id: 'bonds-and-sukuk',
  title: Bi('Bonds and Sukuk', 'السندات والصكوك'),
  category: 'corporate-finance',
  level: KBLevel.intermediate,
  readingMinutes: 6,
  summary: Bi('How a bond works and how it is priced with present values, why price and yield move in opposite directions, and how sukuk deliver a comparable financing result through asset-based structures.', 'كيف يعمل السند وكيف يسعَّر بالقيم الحالية، ولماذا يتحرك السعر والعائد في اتجاهين متعاكسين، وكيف تحقق الصكوك نتيجة تمويلية مقارنة عبر هياكل قائمة على الأصول.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('A bond is a tradable loan. The issuer receives cash today and promises a schedule: periodic coupons (fixed interest on the face value) and repayment of the face value at maturity. Because the promise is a fixed stream of cash flows, a bond is the purest application of time-value mathematics in finance: its fair price is simply the present value of the coupons plus the present value of the face amount, discounted at the return investors currently require for that maturity and credit risk (the yield).', 'السند قرض قابل للتداول. يستلم المصدر نقداً اليوم ويعد بجدول: كوبونات دورية (فائدة ثابتة على القيمة الاسمية) وسداد القيمة الاسمية عند الاستحقاق. ولأن الوعد سيل ثابت من التدفقات، فالسند أنقى تطبيق لرياضيات القيمة الزمنية في المالية: سعره العادل ببساطة هو القيمة الحالية للكوبونات زائد القيمة الحالية للمبلغ الاسمي، مخصومة بالعائد الذي يطلبه المستثمرون حالياً لذلك الأجل وتلك المخاطر الائتمانية (العائد).'),
        Bi('One mechanical truth follows and explains most bond-market headlines: price and yield move inversely. The coupons are fixed by contract; when market rates rise, the old fixed stream is worth less, so the price falls until a new buyer earns the market rate. The longer the maturity, the larger the swing (duration).', 'وتلزم من ذلك حقيقة آلية تفسر معظم عناوين أسواق السندات: السعر والعائد يتحركان عكسياً. فالكوبونات مثبتة بالعقد؛ وعندما ترتفع معدلات السوق يقل ما يستحقه السيل الثابت القديم، فيهبط السعر حتى يكسب المشتري الجديد معدل السوق. وكلما طال الأجل كبر التأرجح (المدة).'),
      ],
      formulas: [
        KBFormula('Price = Σₜ C ÷ (1 + y)ᵗ + F ÷ (1 + y)ⁿ', caption: Bi('C: coupon per period; F: face value; y: yield per period; n: periods to maturity.', 'C: الكوبون للفترة؛ وF: القيمة الاسمية؛ وy: العائد للفترة؛ وn: الفترات حتى الاستحقاق.')),
      ],
    ),
    KBSection(
      heading: Bi('Worked example: pricing under a rate change', 'مثال محلول: التسعير بعد تغير المعدل'),
      paragraphs: [
        Bi('A 5-year bond, face SAR 1,000, pays a 6% annual coupon (SAR 60). If the market yield for this credit is 6%, the price is exactly SAR 1,000: coupon equals yield, so the bond trades at par. Now let market yields rise to 8%. Price = 60 × [1 − 1.08⁻⁵] ÷ 0.08 + 1,000 ÷ 1.08⁵ = 60 × 3.9927 + 680.58 = 239.56 + 680.58 = SAR 920.15. The bond now trades at a discount: the buyer at 920.15 earns 8% overall, part coupon, part pull-to-par as the price climbs back to 1,000 at maturity. Had yields fallen to 4%, the same arithmetic gives SAR 1,089: a premium. Nothing about the issuer changed; only the alternative available to investors did.', 'سند خمس سنوات، قيمته الاسمية 1,000 ريال، يدفع كوبوناً سنوياً 6% (60 ريالاً). إذا كان عائد السوق لهذه الجدارة 6% فالسعر بالضبط 1,000 ريال: الكوبون يساوي العائد فيتداول السند على القيمة الاسمية. فلترتفع عوائد السوق إلى 8%. السعر = 60 × [1 − 1.08⁻⁵] ÷ 0.08 + 1,000 ÷ 1.08⁵ = 60 × 3.9927 + 680.58 = 239.56 + 680.58 = 920.15 ريالاً. يتداول السند الآن بخصم: مشتريه عند 920.15 يكسب 8% إجمالاً، بعضها كوبون وبعضها انجذاب نحو الاسمية مع تسلق السعر إلى 1,000 عند الاستحقاق. ولو هبطت العوائد إلى 4% لأعطت الحسبة نفسها 1,089 ريالاً: علاوة. لم يتغير شيء في المصدر؛ تغير فقط البديل المتاح للمستثمرين.'),
      ],
    ),
    KBSection(
      heading: Bi('Sukuk: the same need, a different structure', 'الصكوك: الحاجة نفسها وهيكل مختلف'),
      paragraphs: [
        Bi('Sukuk raise financing in a form consistent with Islamic commercial law, which prohibits interest on a pure money loan. Instead of a promise of interest, a sukuk gives holders certificates representing beneficial ownership in identified assets, usufruct, or a venture, and their return comes from those assets. In the most common structure, sukuk al-ijara, the originator sells assets to a special purpose vehicle funded by the sukuk holders and leases them back; the rental stream provides the periodic distributions, and a purchase undertaking returns the principal at maturity. Other families include murabaha (cost-plus sale), mudaraba/musharaka (profit-sharing), and wakala (agency) structures. Standard-setting bodies (AAOIFI for Sharia and accounting standards, the IFSB for prudential standards) govern the field, and Saudi Arabia is one of the world\'s largest sukuk markets, with the government funding part of the budget through regular riyal sukuk programs.', 'تجمع الصكوك التمويل بصيغة متسقة مع الفقه التجاري الإسلامي الذي يحرم الفائدة على قرض النقد المحض. فبدل وعد بفائدة، تمنح الصكوك حامليها شهادات تمثل ملكية نفعية في أصول محددة أو منفعة أو مشروع، ويأتي عائدهم من تلك الأصول. وفي الهيكل الأشيع، صكوك الإجارة، يبيع المنشئ أصولاً إلى شركة ذات غرض خاص يمولها حملة الصكوك ثم يستأجرها منها؛ فيوفر تيار الأجرة التوزيعات الدورية، ويعيد تعهدُ الشراء رأسَ المال عند الاستحقاق. ومن العائلات الأخرى هياكل المرابحة (بيع بالتكلفة زائد ربح) والمضاربة/المشاركة (تقاسم الربح) والوكالة. وتحكم المجالَ هيئات معايير (أيوفي للمعايير الشرعية والمحاسبية، ومجلس الخدمات المالية الإسلامية للمعايير الاحترازية)، والمملكة العربية السعودية من أكبر أسواق الصكوك في العالم، إذ تمول الحكومة جزءاً من الموازنة عبر برامج صكوك ريالية منتظمة.'),
        Bi('For the financial manager the practical comparison is disciplined sameness: sukuk distributions are periodic fixed obligations in substance, sukuk are priced and traded with yield mathematics like the bond above, and rating agencies assess the originator\'s credit in much the same way. The genuine differences are structural: the need for identifiable assets, Sharia governance and certification, the legal position of holders relative to the assets, and documentation complexity. A treasury choosing between a bond and a sukuk is choosing between legal architectures for one economic act: borrowing against future cash flows.', 'وللمدير المالي، المقارنة العملية تماثلٌ منضبط: توزيعات الصكوك التزامات دورية ثابتة في الجوهر، وتسعَّر الصكوك وتتداول برياضيات العائد كالسند أعلاه، وتقيم وكالات التصنيف جدارة المنشئ بالطريقة ذاتها تقريباً. أما الفروق الحقيقية فهيكلية: الحاجة إلى أصول قابلة للتحديد، وحوكمة شرعية وشهادتها، والمركز القانوني للحملة تجاه الأصول، وتعقيد التوثيق. فالخزانة التي تختار بين سند وصك تختار بين معماريين قانونيين لفعل اقتصادي واحد: الاقتراض مقابل تدفقات مستقبلية.'),
      ],
    ),
    KBSection(
      heading: Bi('Credit risk and the yield spread', 'المخاطر الائتمانية وفارق العائد'),
      paragraphs: [
        Bi('A bond\'s yield decomposes into the risk-free rate for that maturity plus a credit spread compensating for default risk (and a sliver for liquidity). Rating agencies grade issuers from AAA downward; the investment-grade boundary (BBB−) matters because many institutional mandates stop there. Spreads breathe with the cycle: they compress in calm markets and gap open in stress, so an issuer\'s funding cost can jump without any change in its own business. Reading the spread is reading the market\'s live opinion of the borrower, which is why treasurers track their own secondary-market spreads as a dashboard of investor confidence.', 'يتحلل عائد السند إلى المعدل الخالي من المخاطر لذلك الأجل زائد فارق ائتماني يعوض عن مخاطر التعثر (وشريحة صغيرة للسيولة). وتدرج وكالات التصنيف المصدرين من AAA نزولاً؛ وحد الدرجة الاستثمارية (−BBB) مهم لأن تفويضات مؤسسية كثيرة تقف عنده. والفوارق تتنفس مع الدورة: تنضغط في الأسواق الهادئة وتنفرج في الضغوط، فقد تقفز كلفة تمويل مصدرٍ دون أي تغير في أعماله. وقراءة الفارق قراءةٌ لرأي السوق الحي في المقترض، ولهذا يتتبع أمناء الخزانة فوارقهم في السوق الثانوية لوحةَ قياس لثقة المستثمرين.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Confusing coupon with yield. The coupon is a contractual cash amount; the yield is the market return implied by today\'s price.', 'الخلط بين الكوبون والعائد. الكوبون مبلغ نقدي تعاقدي؛ والعائد هو عائد السوق الذي يتضمنه سعر اليوم.'),
    Bi('Treating a bond fund as safe because bonds repay at par. Funds have no maturity; rate rises turn into permanent-looking price losses.', 'اعتبار صندوق السندات آمناً لأن السندات تُسدد بالاسمية. الصناديق بلا استحقاق؛ وارتفاعات المعدلات تتحول إلى خسائر أسعار تبدو دائمة.'),
    Bi('Assuming a sukuk carries no fixed-obligation risk because it is not legally a loan. Distribution obligations discipline cash flow in substance and must be sized like debt service.', 'افتراض أن الصك بلا مخاطر التزام ثابت لأنه ليس قرضاً قانوناً. التزامات التوزيع تضبط التدفق النقدي في الجوهر ويجب تحجيمها كخدمة الدين.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IFRS 9 (amortized cost)',
      note: Bi('Bonds held to collect contractual cash flows are measured at amortized cost using the effective interest method: the pricing mathematics above, embedded in the accounting.', 'السندات المحتفظ بها لتحصيل التدفقات التعاقدية تقاس بالتكلفة المطفأة بطريقة الفائدة الفعلية: رياضيات التسعير أعلاه مضمنةً في المحاسبة.'),
      segments: [
        KBStandardSegment('IFRS 9', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ifrs-9-financial-instruments/'),
        KBStandardSegment(' (amortized cost)'),
      ],
    ),
    KBStandardRef(
      standard: 'AAOIFI FAS · Sharia Standard 17',
      note: Bi('The AAOIFI standards governing investment sukuk: asset requirements, tradability conditions, and accounting by issuers and holders.', 'معايير أيوفي الحاكمة لصكوك الاستثمار: متطلبات الأصول وشروط التداول والمحاسبة لدى المصدرين والحملة.'),
      segments: [
        KBStandardSegment('AAOIFI', href: 'https://aaoifi.com/e-standards/?lang=en'),
        KBStandardSegment(' FAS · Sharia Standard 17'),
      ],
    ),
  ],
  relatedTerms: [],
  relatedModules: [
    KBRelatedModule('/education/fundamentals', Bi('Module: Financial Management Primer (Bonds & Sukuk slide)', 'الوحدة: تمهيد الإدارة المالية (شريحة السندات والصكوك)')),
  ],
  relatedArticles: [
    'time-value-of-money',
    'capital-structure',
    'risk-management-hedging',
    'financial-instruments',
    'fiscal-sustainability',
    'credit-analysis',
    'public-debt-management',
  ],
  references: [
    'Fabozzi, F. J. (2021). Bond markets, analysis, and strategies (10th ed.). MIT Press.',
    'Accounting and Auditing Organization for Islamic Financial Institutions. (2015). Sharia standards. AAOIFI.',
    'Usmani, M. T. (2002). An introduction to Islamic finance. Kluwer Law International.',
    'Brealey, R. A., Myers, S. C., & Allen, F. (2020). Principles of corporate finance (13th ed.). McGraw-Hill.',
  ],
  keywords: [
    'bond',
    'sukuk',
    'coupon',
    'yield',
    'ijara',
    'credit spread',
    'AAOIFI',
    'سند',
    'صكوك',
    'كوبون',
    'عائد',
    'إجارة',
  ],
);
