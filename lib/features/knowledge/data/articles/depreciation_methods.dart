// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/depreciation-methods.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbDepreciationMethods = KBArticle(
  id: 'depreciation-methods',
  title: Bi('Depreciation and Amortization in Depth', 'الإهلاك والإطفاء بعمق'),
  category: 'accounting-foundations',
  level: KBLevel.foundation,
  readingMinutes: 6,
  summary: Bi('Why depreciation is cost allocation rather than valuation, the straight-line, diminishing-balance, and units-of-production methods compared on one asset, and the estimates managers actually control.', 'لماذا الإهلاك توزيع للتكلفة لا تقييم، ومقارنة طرق القسط الثابت والقسط المتناقص ووحدات الإنتاج على أصل واحد، والتقديرات التي يتحكم فيها المديرون فعلاً.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('When a company buys a machine that will serve it for eight years, expensing the whole price in year one would misstate every one of the eight years: year one would look terrible, years two to eight artificially good. Depreciation fixes this by allocating the asset\'s depreciable amount (cost minus expected residual value) systematically over its useful life, so each period that benefits from the asset carries a share of its cost. This is the matching principle applied to long-lived assets. Amortization is the same mechanism applied to intangible assets with finite lives (software, licenses).', 'عندما تشتري شركة آلة ستخدمها ثماني سنوات، فإن تحميل الثمن كله على السنة الأولى يشوه السنوات الثماني جميعاً: تبدو الأولى سيئة جداً والباقيات جيدات زيفاً. يعالج الإهلاك ذلك بتوزيع المبلغ القابل للإهلاك (التكلفة ناقص القيمة المتبقية المتوقعة) توزيعاً منهجياً على العمر الإنتاجي، فتحمل كل فترة تنتفع بالأصل نصيباً من تكلفته. وهذا هو مبدأ المقابلة مطبقاً على الأصول طويلة العمر. والإطفاء هو الآلية نفسها مطبقة على الأصول غير الملموسة ذات الأعمار المحددة (البرمجيات والتراخيص).'),
        Bi('One sentence prevents most confusion: depreciation allocates cost; it does not measure value. The carrying amount of a five-year-old machine is what remains unallocated of its cost, not what the machine would fetch if sold. Value questions are answered by impairment testing and fair-value measurement, not by the depreciation schedule.', 'جملة واحدة تمنع معظم الخلط: الإهلاك يوزع التكلفة ولا يقيس القيمة. فالقيمة الدفترية لآلة عمرها خمس سنوات هي ما بقي من تكلفتها دون توزيع، لا ما ستجلبه لو بيعت. أسئلة القيمة تجيب عنها اختبارات الهبوط وقياس القيمة العادلة، لا جدول الإهلاك.'),
      ],
    ),
    KBSection(
      heading: Bi('The formal treatment: three methods', 'المعالجة النظرية: ثلاث طرق'),
      paragraphs: [
        Bi('IAS 16 requires the depreciation method to reflect the pattern in which the asset\'s future economic benefits are consumed, and requires the method, useful life, and residual value to be reviewed at least annually. Three methods dominate. Straight-line charges an equal amount each period, fitting assets consumed by the passage of time. Diminishing balance applies a fixed percentage to the opening carrying amount, front-loading the charge, fitting assets that give more service (or lose more value) early, such as IT equipment. Units of production charges in proportion to actual output or usage, fitting machinery whose wear tracks activity rather than time. Revenue-based depreciation is explicitly prohibited for property, plant and equipment: revenue reflects prices and volumes, not consumption of the asset.', 'يوجب المعيار IAS 16 أن تعكس طريقة الإهلاك النمط الذي تُستهلك به المنافع الاقتصادية المستقبلية للأصل، وأن تُراجع الطريقة والعمر الإنتاجي والقيمة المتبقية سنوياً على الأقل. وتسود ثلاث طرق. القسط الثابت يحمِّل مبلغاً متساوياً كل فترة، ويناسب الأصول التي يستهلكها مرور الزمن. والقسط المتناقص يطبق نسبة ثابتة على القيمة الدفترية الافتتاحية فيقدِّم العبء، ويناسب الأصول التي تعطي خدمة أكبر (أو تفقد قيمة أكبر) مبكراً كمعدات تقنية المعلومات. ووحدات الإنتاج تحمِّل بنسبة الإنتاج أو الاستخدام الفعلي، وتناسب الآلات التي يتبع اهتراؤها النشاطَ لا الزمن. أما الإهلاك على أساس الإيراد فمحظور صراحة للممتلكات والمصانع والمعدات: فالإيراد يعكس الأسعار والأحجام لا استهلاك الأصل.'),
      ],
      formulas: [
        KBFormula('Straight-line charge = (Cost − Residual value) ÷ Useful life', caption: Bi('Equal periodic allocation.', 'توزيع دوري متساوٍ.')),
        KBFormula('Diminishing balance charge = Rate × Opening carrying amount', caption: Bi('A constant rate on a shrinking base produces a declining charge.', 'نسبة ثابتة على قاعدة متقلصة تنتج عبئاً متناقصاً.')),
      ],
    ),
    KBSection(
      heading: Bi('Worked example: one asset, three profiles', 'مثال محلول: أصل واحد وثلاثة أنماط'),
      paragraphs: [
        Bi('A machine costs SAR 500,000, residual value SAR 50,000, useful life 5 years or 90,000 machine-hours. Year-1 usage is 27,000 hours. Compare the year-1 charge:', 'آلة تكلفتها 500,000 ريال، وقيمتها المتبقية 50,000 ريال، وعمرها 5 سنوات أو 90,000 ساعة تشغيل. استخدام السنة الأولى 27,000 ساعة. قارن عبء السنة الأولى:'),
      ],
      table: KBTable(
        headers: [
          Bi('Method', 'الطريقة'),
          Bi('Year-1 charge', 'عبء السنة الأولى'),
          Bi('Logic', 'المنطق'),
        ],
        rows: [
          [
            Bi('Straight-line', 'القسط الثابت'),
            Bi('(500,000 − 50,000) ÷ 5 = SAR 90,000', '(500,000 − 50,000) ÷ 5 = 90,000 ريال'),
            Bi('Time-based, equal every year', 'زمني، متساوٍ كل سنة'),
          ],
          [
            Bi('Diminishing balance (40%)', 'القسط المتناقص (40%)'),
            Bi('40% × 500,000 = SAR 200,000', '40% × 500,000 = 200,000 ريال'),
            Bi('Front-loaded; falls every year after', 'مقدَّم؛ ويهبط كل سنة تالية'),
          ],
          [
            Bi('Units of production', 'وحدات الإنتاج'),
            Bi('(450,000 ÷ 90,000) × 27,000 = SAR 135,000', '(450,000 ÷ 90,000) × 27,000 = 135,000 ريال'),
            Bi('Tracks actual usage', 'يتبع الاستخدام الفعلي'),
          ],
        ],
      ),
    ),
    KBSection(
      heading: Bi('The estimates, and why analysts watch them', 'التقديرات ولماذا يراقبها المحللون'),
      paragraphs: [
        Bi('Every depreciation number rests on three management estimates: useful life, residual value, and consumption pattern. Lengthening lives or raising residual values cuts the charge and lifts profit with no change in the business, which is why changes in these estimates must be disclosed and applied prospectively (IAS 8), and why analysts compare depreciation policy across peers before comparing margins. Depreciation also never moves cash: the cash left when the asset was bought (investing outflow), which is why the charge is added back in the indirect cash flow statement, and why EBITDA excludes it, at the price of ignoring the very real need to replace assets eventually.', 'كل رقم إهلاك يقوم على ثلاثة تقديرات إدارية: العمر الإنتاجي، والقيمة المتبقية، ونمط الاستهلاك. وإطالة الأعمار أو رفع القيم المتبقية يخفض العبء ويرفع الربح دون أي تغير في الأعمال، ولهذا يجب الإفصاح عن تغييرات هذه التقديرات وتطبيقها مستقبلياً (IAS 8)، ولهذا يقارن المحللون سياسة الإهلاك بين النظائر قبل مقارنة الهوامش. كما أن الإهلاك لا يحرك نقداً أبداً: فالنقد خرج عند شراء الأصل (تدفق استثماري خارج)، ولهذا يُضاف العبء في قائمة التدفقات بالطريقة غير المباشرة، ولهذا يستبعده EBITDA، على حساب تجاهل الحاجة الحقيقية جداً إلى إحلال الأصول يوماً ما.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Reading carrying amount as market value. It is unallocated cost, nothing more.', 'قراءة القيمة الدفترية قيمةً سوقية. إنها تكلفة غير موزعة، لا أكثر.'),
    Bi('Believing "depreciation generates cash" because of the indirect-method add-back. The cash effect happened at purchase.', 'الاعتقاد بأن «الإهلاك يولد نقداً» بسبب الإضافة في الطريقة غير المباشرة. الأثر النقدي وقع عند الشراء.'),
    Bi('Ignoring component depreciation: under IAS 16, significant parts with different lives (an aircraft engine versus its airframe) are depreciated separately.', 'تجاهل إهلاك المكونات: بموجب IAS 16 تُهلك الأجزاء المهمة ذات الأعمار المختلفة (محرك الطائرة مقابل هيكلها) كلٌّ على حدة.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IAS 16 §43–62A',
      note: Bi('Depreciation of property, plant and equipment: component approach, methods, annual review of estimates, prohibition of revenue-based methods.', 'إهلاك الممتلكات والمصانع والمعدات: نهج المكونات، والطرق، والمراجعة السنوية للتقديرات، وحظر الطرق القائمة على الإيراد.'),
      segments: [
        KBStandardSegment('IAS 16', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-16-property-plant-and-equipment/'),
        KBStandardSegment(' §43–62A'),
      ],
    ),
    KBStandardRef(
      standard: 'IAS 38 §97–108',
      note: Bi('Amortization of intangibles with finite lives; indefinite-life intangibles are not amortized but tested for impairment.', 'إطفاء غير الملموسات محددة العمر؛ أما غير محددة العمر فلا تُطفأ بل تُختبر للهبوط.'),
      segments: [
        KBStandardSegment('IAS 38', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-38-intangible-assets/'),
        KBStandardSegment(' §97–108'),
      ],
    ),
    KBStandardRef(
      standard: 'IAS 8 §32–40',
      note: Bi('Changes in useful life, residual value, or method are changes in estimate: prospective application, with disclosure.', 'تغييرات العمر أو القيمة المتبقية أو الطريقة تغييرات في التقدير: تطبيق مستقبلي مع الإفصاح.'),
      segments: [
        KBStandardSegment('IAS 8', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-8-accounting-policies-changes-in-accounting-estimates-and-errors/'),
        KBStandardSegment(' §32–40'),
      ],
    ),
  ],
  relatedTerms: [
    'Depreciation',
    'Amortization',
    'EBITDA',
  ],
  relatedModules: [
    KBRelatedModule('/education/financial-statements', Bi('Module: Understanding Financial Statements', 'الوحدة: فهم القوائم المالية')),
  ],
  relatedArticles: [
    'accrual-accounting',
    'balance-sheet',
    'cash-flow-statement',
    'leases-ifrs16',
    'impairment-testing',
    'deferred-tax',
    'borrowing-costs',
    'government-grants',
    'intangible-assets',
  ],
  references: [
    'IFRS Foundation. (2003). IAS 16 Property, plant and equipment. IFRS Foundation.',
    'IFRS Foundation. (2004). IAS 38 Intangible assets. IFRS Foundation.',
    'Kieso, D. E., Weygandt, J. J., & Warfield, T. D. (2020). Intermediate accounting: IFRS edition (4th ed.). Wiley.',
  ],
  keywords: [
    'depreciation',
    'amortization',
    'straight line',
    'diminishing balance',
    'units of production',
    'إهلاك',
    'إطفاء',
    'قسط ثابت',
    'قسط متناقص',
  ],
);
