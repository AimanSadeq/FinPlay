// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/impairment-testing.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbImpairmentTesting = KBArticle(
  id: 'impairment-testing',
  title: Bi('Impairment Testing under IAS 36', 'اختبار الهبوط في القيمة وفق IAS 36'),
  category: 'accounting-foundations',
  level: KBLevel.advanced,
  readingMinutes: 7,
  summary: Bi('When an asset’s carrying amount stops being defensible, how recoverable amount is built from fair value and value in use, why goodwill is tested at the cash-generating-unit level, and a worked test.', 'متى يصبح المبلغ الدفتري للأصل غير قابل للدفاع عنه، وكيف يُبنى المبلغ القابل للاسترداد من القيمة العادلة والقيمة من الاستخدام، ولماذا تُختبر الشهرة على مستوى الوحدة المولدة للنقد، مع اختبار محلول.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('The balance sheet carries assets at cost less depreciation, but cost is history and value is expectation. Impairment is the accounting admission that an asset will no longer earn back its carrying amount, whether through use or through sale. IAS 36 forces the question with a simple rule: an asset must not be carried above its recoverable amount, defined as the higher of fair value less costs of disposal (what a buyer would pay) and value in use (what the asset will earn for its current owner, discounted). If carrying amount exceeds that higher figure, the difference is written off through profit or loss immediately. The test runs whenever an indicator of impairment appears, such as a lost contract, a technology shift, or a market collapse. Goodwill and indefinite-life intangibles are tested every year regardless of indicators, because they never depreciate on their own.', 'تحمل الميزانية الأصول بالتكلفة ناقص الاستهلاك، لكن التكلفة تاريخ والقيمة توقع. والهبوط في القيمة اعتراف محاسبي بأن الأصل لن يسترد مبلغه الدفتري، سواء بالاستخدام أو بالبيع. يفرض IAS 36 السؤال بقاعدة بسيطة: يجب ألا يُحمل الأصل بأعلى من مبلغه القابل للاسترداد، وهو الأعلى بين القيمة العادلة ناقص تكاليف البيع (ما سيدفعه مشترٍ) والقيمة من الاستخدام (ما سيكسبه الأصل لمالكه الحالي مخصوماً). فإن جاوز المبلغ الدفتري ذلك الرقم الأعلى، شُطب الفرق في الربح أو الخسارة فوراً. ويجري الاختبار كلما ظهر مؤشر هبوط، كعقد ضائع أو تحول تقني أو انهيار سوق. أما الشهرة والأصول غير الملموسة غير محددة العمر فتُختبر كل سنة بصرف النظر عن المؤشرات، لأنها لا تُستهلك من تلقاء نفسها.'),
      ],
    ),
    KBSection(
      heading: Bi('The formal treatment: recoverable amount and the CGU', 'المعالجة النظرية: المبلغ القابل للاسترداد والوحدة المولدة للنقد'),
      paragraphs: [
        Bi('Value in use is a discounted cash flow exercise with rules attached: cash flow projections from budgets management has approved, normally capped at five years before extrapolating with a steady or declining growth rate, excluding future restructurings and enhancements the asset does not yet have, discounted at a pre-tax rate reflecting the asset’s risks. Most assets do not generate cash alone, so the test runs on the smallest group of assets that produces largely independent cash inflows, the cash-generating unit (CGU). Goodwill cannot be tested at all on its own; it is allocated to the CGUs expected to benefit from the acquisition and tested inside them. When a CGU fails the test, the impairment loss goes first against its goodwill, then pro rata against the other assets. Goodwill impairments can never be reversed; impairments of other assets can be, if the reasons disappear.', 'القيمة من الاستخدام تمرينُ تدفقات نقدية مخصومة بقواعد ملحقة: إسقاطات تدفق من موازنات اعتمدتها الإدارة، تُحد عادةً بخمس سنوات قبل الاستقراء بمعدل نمو ثابت أو متناقص، مع استبعاد إعادات الهيكلة المستقبلية والتحسينات التي لا يملكها الأصل بعد، مخصومةً بمعدل قبل الضريبة يعكس مخاطر الأصل. ومعظم الأصول لا تولد نقداً وحدها، فيجري الاختبار على أصغر مجموعة أصول تنتج تدفقات نقدية داخلة مستقلة إلى حد كبير، وهي الوحدة المولدة للنقد. والشهرة لا يمكن اختبارها وحدها أصلاً؛ بل تُوزع على الوحدات المتوقع انتفاعها من الاستحواذ وتُختبر داخلها. وعندما تخفق وحدة في الاختبار، تُحمَّل خسارة الهبوط أولاً على شهرتها ثم بالتناسب على بقية الأصول. وهبوط الشهرة لا يُعكس أبداً؛ أما هبوط الأصول الأخرى فيجوز عكسه إن زالت أسبابه.'),
      ],
      formulas: [
        KBFormula('Recoverable amount = max(Fair value − Costs of disposal, Value in use)', caption: Bi('The IAS 36 ceiling on carrying amount.', 'سقف IAS 36 على المبلغ الدفتري.')),
        KBFormula('Impairment loss = Carrying amount − Recoverable amount   (if positive)', caption: Bi('Recognized in profit or loss when carrying amount exceeds recoverable amount.', 'تُثبت في الربح أو الخسارة عندما يجاوز المبلغ الدفتري المبلغ القابل للاسترداد.')),
      ],
    ),
    KBSection(
      heading: Bi('Worked example: testing a division', 'مثال محلول: اختبار قطاع'),
      paragraphs: [
        Bi('A CGU carries assets of SAR 80m, including SAR 12m of allocated goodwill. Approved budgets project cash inflows of SAR 12m per year for five years, and a buyer has informally indicated it would pay about SAR 55m net of costs. Value in use at a 10% pre-tax discount rate, assuming no growth beyond year five and a terminal value of the year-five flow capitalized at 10% (12 ÷ 0.10 = 120, discounted five years to 74.5), is 12 × 3.791 + 74.5 = SAR 120m… which passes easily. Now stress it: the division loses its largest customer and projected flows drop to SAR 7m. Value in use becomes 7 × 3.791 + (7 ÷ 0.10) × 0.6209 = 26.5 + 43.5 = SAR 70m; fair value less costs remains SAR 55m. Recoverable amount is the higher, SAR 70m. Impairment = 80 − 70 = SAR 10m, charged first against the SAR 12m goodwill, which falls to SAR 2m. One customer call moved the balance sheet by ten million: impairment is where valuation and accounting meet.', 'وحدة مولدة للنقد تحمل أصولاً بثمانين مليون ريال، منها 12 مليوناً شهرة موزعة. تتوقع الموازنات المعتمدة تدفقات داخلة قدرها 12 مليوناً سنوياً لخمس سنوات، وألمح مشترٍ إلى استعداده لدفع نحو 55 مليوناً صافياً من التكاليف. القيمة من الاستخدام بمعدل خصم 10% قبل الضريبة، بافتراض لا نمو بعد السنة الخامسة وقيمة نهائية لتدفق السنة الخامسة مرسملة عند 10% (12 ÷ 0.10 = 120 مخصومةً خمس سنوات إلى 74.5)، هي 12 × 3.791 + 74.5 = 120 مليوناً؛ فينجح الاختبار بسهولة. الآن ضع ضغطاً: يفقد القطاع أكبر عملائه وتهبط التدفقات المتوقعة إلى 7 ملايين. تصبح القيمة من الاستخدام 7 × 3.791 + (7 ÷ 0.10) × 0.6209 = 26.5 + 43.5 = 70 مليوناً؛ وتبقى القيمة العادلة ناقص التكاليف 55 مليوناً. المبلغ القابل للاسترداد هو الأعلى، أي 70 مليوناً. الهبوط = 80 − 70 = 10 ملايين ريال، تُحمَّل أولاً على شهرة الاثني عشر مليوناً فتهبط إلى مليونين. مكالمة عميل واحدة حركت الميزانية عشرة ملايين: الهبوط هو حيث يلتقي التقييم بالمحاسبة.'),
      ],
    ),
    KBSection(
      heading: Bi('Reading impairments as an analyst', 'قراءة الهبوط بعين المحلل'),
      paragraphs: [
        Bi('An impairment charge is a non-cash entry, but it is not information-free. It tells you management’s own model no longer supports the number, and because the inputs (discount rates, growth assumptions, forecast horizons) are disclosed in the notes, the impairment note is one of the few places where a company publishes its internal valuation assumptions. Watch two behaviors. Serial small impairments suggest forecasts that are chronically optimistic by a constant margin. A single enormous impairment in a bad year, bundled with restructuring charges, suggests big-bath accounting: overstating today’s loss to flatter every future year. Both are legal; neither is neutral.', 'قيد الهبوط قيد غير نقدي، لكنه ليس خالياً من المعلومات. فهو يخبرك أن نموذج الإدارة نفسه لم يعد يدعم الرقم، ولأن المدخلات (معدلات الخصم وافتراضات النمو وآفاق التنبؤ) تُفصح في الإيضاحات، فإن إيضاح الهبوط من المواضع القليلة التي تنشر فيها الشركة افتراضات تقييمها الداخلي. راقب سلوكين. الهبوطات الصغيرة المتوالية توحي بتنبؤات متفائلة مزمناً بهامش ثابت. والهبوط الواحد الهائل في سنة سيئة، محزوماً مع أعباء إعادة هيكلة، يوحي بمحاسبة الحمام الكبير: تضخيم خسارة اليوم لتجميل كل سنة مقبلة. كلاهما قانوني؛ ولا أحدهما محايد.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Testing goodwill at too high a level: allocating it to the whole company lets profitable units shelter a failed acquisition, which is exactly what CGU allocation exists to prevent.', 'اختبار الشهرة على مستوى أعلى مما ينبغي: توزيعها على الشركة كلها يدع الوحدات الرابحة تستر استحواذاً فاشلاً، وهذا بالضبط ما وُجد توزيع الوحدات المولدة للنقد لمنعه.'),
    Bi('Letting value-in-use forecasts include the rescue plan: IAS 36 excludes future restructurings and enhancements precisely because every troubled asset has a turnaround story.', 'السماح لتنبؤات القيمة من الاستخدام بتضمين خطة الإنقاذ: يستبعد IAS 36 إعادات الهيكلة والتحسينات المستقبلية تحديداً لأن لكل أصل متعثر قصة تعافٍ.'),
    Bi('Treating an impairment as “non-cash, so ignore it”: the cash left when the asset was bought; the impairment is the delayed confession about that earlier price.', 'معاملة الهبوط على أنه "غير نقدي فتجاهله": فالنقد خرج يوم شراء الأصل؛ والهبوط هو الاعتراف المؤجل بذلك الثمن السابق.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IAS 36',
      note: Bi('Impairment of assets: recoverable amount, value in use, CGUs, goodwill allocation, and reversal rules.', 'الهبوط في قيمة الأصول: المبلغ القابل للاسترداد والقيمة من الاستخدام والوحدات المولدة للنقد وتوزيع الشهرة وقواعد العكس.'),
      segments: [
        KBStandardSegment('IAS 36', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-36-impairment-of-assets/'),
      ],
    ),
    KBStandardRef(
      standard: 'IFRS 13',
      note: Bi('Fair value measurement: the framework behind the fair-value-less-costs-of-disposal leg of the test.', 'قياس القيمة العادلة: الإطار خلف شق القيمة العادلة ناقص تكاليف البيع من الاختبار.'),
      segments: [
        KBStandardSegment('IFRS 13', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ifrs-13-fair-value-measurement/'),
      ],
    ),
  ],
  relatedTerms: [
    'Impairment',
    'Goodwill',
    'Fair Value',
    'Book Value',
    'Intangible Assets',
  ],
  relatedModules: [
    KBRelatedModule('/education/financial-analysis', Bi('Module: Analysis of Financial Statements', 'الوحدة: تحليل القوائم المالية')),
    KBRelatedModule('/education/capital-budgeting', Bi('Module: Capital Budgeting (discounting machinery)', 'الوحدة: الموازنة الرأسمالية (آلية الخصم)')),
  ],
  relatedArticles: [
    'consolidation-goodwill',
    'depreciation-methods',
    'wacc',
    'npv-irr',
    'balance-sheet',
    'discontinued-operations',
    'interim-reporting',
    'intangible-assets',
    'fair-value-measurement',
  ],
  references: [
    'IFRS Foundation. (2004). IAS 36 Impairment of Assets. IFRS Foundation.',
    'IFRS Foundation. (2011). IFRS 13 Fair Value Measurement. IFRS Foundation.',
    'Penman, S. H. (2013). Financial statement analysis and security valuation (5th ed.). McGraw-Hill.',
    'Kieso, D. E., Weygandt, J. J., & Warfield, T. D. (2020). Intermediate accounting: IFRS edition (4th ed.). Wiley.',
  ],
  keywords: [
    'impairment',
    'IAS 36',
    'recoverable amount',
    'value in use',
    'cash-generating unit',
    'CGU',
    'goodwill impairment',
    'write-down',
    'الهبوط في القيمة',
    'المبلغ القابل للاسترداد',
    'الوحدة المولدة للنقد',
  ],
);
