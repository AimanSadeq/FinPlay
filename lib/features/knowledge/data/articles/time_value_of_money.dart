// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/time-value-of-money.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbTimeValueOfMoney = KBArticle(
  id: 'time-value-of-money',
  title: Bi('The Time Value of Money', 'القيمة الزمنية للنقود'),
  category: 'corporate-finance',
  level: KBLevel.foundation,
  readingMinutes: 7,
  summary: Bi('Compounding and discounting as one machine run in two directions: future value, present value, annuities and perpetuities, effective versus nominal rates, and a loan example worked in full.', 'التركيب والخصم آلة واحدة تعمل في اتجاهين: القيمة المستقبلية، والقيمة الحالية، والدفعات المتساوية والدائمة، والمعدل الفعلي مقابل الاسمي، ومثال قرض محلول كاملاً.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('Money has a time dimension because it can work while it waits. A riyal invested today at rate r becomes (1 + r) riyals in a year; therefore a riyal promised in a year is worth only 1 ÷ (1 + r) today. Compounding rolls value forward; discounting rolls it back. They are the same machine run in opposite directions, and every valuation tool in finance (NPV, bond pricing, loan schedules, pension math) is an application of this one machine.', 'للنقود بعد زمني لأنها تستطيع العمل وهي تنتظر. الريال المستثمر اليوم بمعدل r يصير (1 + r) ريالاً بعد سنة؛ ولذلك فإن ريالاً موعوداً بعد سنة لا يساوي اليوم إلا 1 ÷ (1 + r). التركيب يدحرج القيمة إلى الأمام؛ والخصم يعيدها إلى الوراء. إنهما الآلة نفسها تعمل في اتجاهين متعاكسين، وكل أداة تقييم في المالية (NPV، وتسعير السندات، وجداول القروض، وحسابات التقاعد) تطبيق لهذه الآلة الواحدة.'),
        Bi('The power in compounding is that interest itself earns interest. SAR 100,000 at 8% is not 100,000 + 8,000 × 10 = 180,000 after ten years; it is 100,000 × 1.08¹⁰ = 215,892. The 35,892 difference is interest on interest, and it grows with time faster than intuition expects, which is why starting early dominates in savings and why long delays are so expensive in liabilities.', 'قوة التركيب في أن الفائدة نفسها تكسب فائدة. 100,000 ريال بمعدل 8% ليست 100,000 + 8,000 × 10 = 180,000 بعد عشر سنين؛ بل 100,000 × 1.08¹⁰ = 215,892. والفرق البالغ 35,892 هو فائدة على الفائدة، وهو ينمو مع الزمن أسرع مما يتوقع الحدس، ولهذا يتفوق البدء المبكر في الادخار، ولهذا يكون التأخير الطويل باهظاً في الالتزامات.'),
      ],
      formulas: [
        KBFormula('FV = PV × (1 + r)ⁿ        PV = FV ÷ (1 + r)ⁿ', caption: Bi('Future value and present value of a single amount over n periods at rate r.', 'القيمة المستقبلية والحالية لمبلغ واحد عبر n فترة بمعدل r.')),
      ],
    ),
    KBSection(
      heading: Bi('Annuities and perpetuities', 'الدفعات المتساوية والدائمة'),
      paragraphs: [
        Bi('Most real cash flows are streams, not single amounts: salaries, rents, loan installments, subscription revenue. An annuity is a stream of equal payments at regular intervals for a fixed term; a perpetuity is the same stream with no end. Their present values have closed forms, which is what makes loan schedules and simple valuations computable by hand. The perpetuity formula PV = C ÷ r, extended with growth to PV = C ÷ (r − g), is the seed of the dividend-growth valuation model and of every "terminal value" in a discounted cash flow.', 'معظم التدفقات الحقيقية سيول لا مبالغ مفردة: رواتب وإيجارات وأقساط قروض وإيراد اشتراكات. الدفعات المتساوية سيل من مدفوعات متساوية على فترات منتظمة لأجل محدد؛ والدائمة السيل نفسه بلا نهاية. ولقيمهما الحالية صيغ مغلقة، وهذا ما يجعل جداول القروض والتقييمات البسيطة قابلة للحساب يدوياً. وصيغة الدائمة PV = C ÷ r، وبإضافة النمو PV = C ÷ (r − g)، هي بذرة نموذج تقييم توزيعات الأرباح النامية وكل «قيمة نهائية» في التدفقات النقدية المخصومة.'),
      ],
      formulas: [
        KBFormula('PV(annuity) = C × [1 − (1 + r)⁻ⁿ] ÷ r', caption: Bi('C: the equal periodic payment. This is the formula behind every loan installment.', 'C: الدفعة الدورية المتساوية. هذه هي الصيغة وراء كل قسط قرض.')),
        KBFormula('PV(perpetuity) = C ÷ r        PV(growing perpetuity) = C₁ ÷ (r − g),  r > g', caption: Bi('The perpetuity shortcut and its growing form. C is the level payment; C₁ is the cash flow one period from now, so a stream growing at g from a current C₀ uses C₀ × (1 + g).', 'اختصار الدائمة وصيغتها النامية. C هي الدفعة الثابتة؛ وC₁ هي التدفق النقدي بعد فترة واحدة، فالتيار النامي بمعدل g من تدفق حالي C₀ يستخدم C₀ × (1 + g).')),
      ],
    ),
    KBSection(
      heading: Bi('Worked example: a loan installment from first principles', 'مثال محلول: قسط قرض من المبادئ الأولى'),
      paragraphs: [
        Bi('A company borrows SAR 2,000,000 for 5 years at 8% with equal annual installments. The installment C solves 2,000,000 = C × [1 − 1.08⁻⁵] ÷ 0.08. The bracket equals 3.9927, so C = 2,000,000 ÷ 3.9927 = SAR 500,913 per year. Check the first year: interest = 8% × 2,000,000 = 160,000, so principal repaid = 500,913 − 160,000 = 340,913, leaving 1,659,087 outstanding. Note the anatomy: early installments are mostly interest, late ones mostly principal, the shape of every amortizing loan and every mortgage, and the reason early prepayment saves the most interest.', 'اقترضت شركة 2,000,000 ريال لخمس سنوات بمعدل 8% بأقساط سنوية متساوية. القسط C يحل المعادلة 2,000,000 = C × [1 − 1.08⁻⁵] ÷ 0.08. قيمة القوس 3.9927، إذن C = 2,000,000 ÷ 3.9927 = 500,913 ريالاً سنوياً. تحقق من السنة الأولى: الفائدة = 8% × 2,000,000 = 160,000، فالمسدد من الأصل = 500,913 − 160,000 = 340,913، ويبقى 1,659,087. لاحظ التشريح: الأقساط المبكرة معظمها فائدة والمتأخرة معظمها أصل، وهذا شكل كل قرض مستهلك وكل تمويل عقاري، وسبب كون السداد المبكر أوفرَ ما يكون في الفائدة.'),
      ],
    ),
    KBSection(
      heading: Bi('Nominal versus effective rates', 'المعدل الاسمي مقابل الفعلي'),
      paragraphs: [
        Bi('Rates are quoted per year but often compound more frequently, and the compounding frequency changes the true cost. A "12% annual rate, compounded monthly" means 1% per month, and 1.01¹² = 1.1268: the effective annual rate is 12.68%, not 12%. Comparing offers quoted with different compounding without converting to effective rates is comparing apples to oranges, and the mistake always flatters the more frequently compounded quote. The same discipline separates real from nominal: discount nominal cash flows with nominal rates and real cash flows with real rates, never mixed.', 'تُعلن المعدلات سنوياً لكنها كثيراً ما تركب بتواتر أعلى، وتواتر التركيب يغير الكلفة الحقيقية. «معدل سنوي 12% بتركيب شهري» يعني 1% شهرياً، و1.01¹² = 1.1268: فالمعدل السنوي الفعلي 12.68% لا 12%. ومقارنة عروض معلنة بتواترات تركيب مختلفة دون التحويل إلى المعدلات الفعلية مقارنةُ تفاح ببرتقال، والخطأ يجامل دائماً العرضَ الأكثر تواتراً في التركيب. والانضباط نفسه يفصل الحقيقي عن الاسمي: اخصم التدفقات الاسمية بمعدلات اسمية والحقيقية بمعدلات حقيقية، ولا تخلط أبداً.'),
      ],
      formulas: [
        KBFormula('EAR = (1 + r ÷ m)ᵐ − 1', caption: Bi('Effective annual rate for a nominal rate r compounded m times per year.', 'المعدل السنوي الفعلي لمعدل اسمي r يركب m مرة في السنة.')),
      ],
    ),
  ],
  pitfalls: [
    Bi('Adding cash flows from different dates as if they were comparable. Bring everything to one date first; that is the entire discipline.', 'جمع تدفقات من تواريخ مختلفة كأنها قابلة للمقارنة. أعد كل شيء إلى تاريخ واحد أولاً؛ هذا هو الانضباط كله.'),
    Bi('Comparing quoted rates with different compounding frequencies without converting to effective annual rates.', 'مقارنة معدلات معلنة بتواترات تركيب مختلفة دون تحويلها إلى معدلات سنوية فعلية.'),
    Bi('Using the growing-perpetuity formula with g close to or above r: the formula explodes, and the valuation with it.', 'استخدام صيغة الدائمة النامية بنموٍّ يقارب r أو يتجاوزه: تنفجر الصيغة وينفجر التقييم معها.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IFRS 9 (amortized cost)',
      note: Bi('The effective interest method is annuity mathematics inside a standard: interest income and expense are recognized at the effective rate, exactly as the loan example computes it.', 'طريقة الفائدة الفعلية رياضياتُ دفعات داخل معيار: يُعترف بإيراد الفائدة ومصروفها بالمعدل الفعلي، تماماً كما حسبها مثال القرض.'),
      segments: [
        KBStandardSegment('IFRS 9', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ifrs-9-financial-instruments/'),
        KBStandardSegment(' (amortized cost)'),
      ],
    ),
    KBStandardRef(
      standard: 'IFRS 13 · IAS 36',
      note: Bi('Present-value techniques are embedded in fair value measurement and impairment testing throughout IFRS.', 'أساليب القيمة الحالية مضمنة في قياس القيمة العادلة واختبار الهبوط عبر المعايير كلها.'),
      segments: [
        KBStandardSegment('IFRS 13', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ifrs-13-fair-value-measurement/'),
        KBStandardSegment(' · '),
        KBStandardSegment('IAS 36', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-36-impairment-of-assets/'),
      ],
    ),
  ],
  relatedTerms: [],
  relatedModules: [
    KBRelatedModule('/education/capital-budgeting', Bi('Tool: Capital Budgeting (TVM calculators)', 'الأداة: الموازنة الرأسمالية (حاسبات القيمة الزمنية)')),
    KBRelatedModule('/education/fundamentals', Bi('Module: Financial Management Primer', 'الوحدة: تمهيد الإدارة المالية')),
  ],
  relatedArticles: [
    'npv-irr',
    'wacc',
    'bonds-and-sukuk',
    'leases-ifrs16',
    'dcf-valuation',
    'employee-benefits',
  ],
  references: [
    'Brealey, R. A., Myers, S. C., & Allen, F. (2020). Principles of corporate finance (13th ed.). McGraw-Hill.',
    'Berk, J., & DeMarzo, P. (2020). Corporate finance (5th ed.). Pearson.',
    'Ross, S. A., Westerfield, R. W., & Jordan, B. D. (2022). Fundamentals of corporate finance (13th ed.). McGraw-Hill.',
  ],
  keywords: [
    'time value',
    'present value',
    'future value',
    'annuity',
    'perpetuity',
    'compounding',
    'effective rate',
    'قيمة زمنية',
    'قيمة حالية',
    'دفعات',
    'تركيب',
    'معدل فعلي',
  ],
);
