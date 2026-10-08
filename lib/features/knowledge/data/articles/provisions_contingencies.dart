// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/provisions-contingencies.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbProvisionsContingencies = KBArticle(
  id: 'provisions-contingencies',
  title: Bi('Provisions and Contingent Liabilities (IAS 37)', 'المخصصات والالتزامات المحتملة (IAS 37)'),
  category: 'accounting-foundations',
  level: KBLevel.intermediate,
  readingMinutes: 6,
  summary: Bi('How accounting handles obligations of uncertain timing or amount: the three-part recognition test, expected-value measurement, the disclosure ladder for contingencies, and a worked warranty provision.', 'كيف تتعامل المحاسبة مع التزامات غير مؤكدة التوقيت أو المبلغ: اختبار الاعتراف الثلاثي، والقياس بالقيمة المتوقعة، وسلم الإفصاح للالتزامات المحتملة، ومخصص ضمان محلول.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('Some obligations are certain in existence but uncertain in size or timing: warranty claims on products already sold, a lawsuit the lawyers expect to lose, the cost of dismantling a plant at the end of its life. A provision is a liability recognized for exactly this class of obligation. The intuition is the matching principle under uncertainty: the sale that created the warranty exposure happened this year, so this year should carry the expected cost of honoring it, even though the individual claims will arrive later and their total is an estimate. IAS 37 also polices the opposite abuse. Companies once built generous provisions in good years and released them in bad ones, smoothing profit invisibly. The standard’s recognition test exists to permit real obligations and forbid these rainy-day reserves.', 'بعض الالتزامات مؤكدة الوجود لكنها غير مؤكدة الحجم أو التوقيت: مطالبات ضمان عن منتجات بيعت فعلاً، ودعوى قضائية يتوقع المحامون خسارتها، وتكلفة تفكيك مصنع في نهاية عمره. والمخصص التزامٌ يُعترف به لهذه الفئة من الالتزامات تحديداً. والفكرة هي مبدأ المقابلة في ظل عدم اليقين: فالبيع الذي أنشأ التعرض للضمان حدث هذه السنة، فينبغي أن تحمل هذه السنة التكلفة المتوقعة للوفاء به، وإن كانت المطالبات الفردية ستصل لاحقاً ومجموعها تقدير. ويضبط IAS 37 أيضاً الإساءة المعاكسة. فقد اعتادت شركاتٌ بناء مخصصات سخية في السنوات الجيدة وإطلاقها في السيئة، فتُنعِّم الربح خفيةً. واختبار الاعتراف في المعيار موجود ليجيز الالتزامات الحقيقية ويحظر احتياطيات الأيام الممطرة هذه.'),
      ],
    ),
    KBSection(
      heading: Bi('The formal treatment: recognition and measurement', 'المعالجة النظرية: الاعتراف والقياس'),
      paragraphs: [
        Bi('A provision is recognized only when three conditions hold together: a present obligation (legal or constructive) exists from a past event; an outflow of resources is probable, meaning more likely than not; and the amount can be estimated reliably. A constructive obligation arises from conduct rather than contract, as when a published refund policy creates a valid expectation customers rely on. Measurement is the best estimate of the expenditure required to settle the obligation today: for a large population of similar items, that is the probability-weighted expected value; for a single item, usually the most likely outcome. Material long-dated provisions are discounted to present value, and the discount unwinds through finance cost each year. If the outflow is only possible rather than probable, or cannot be measured reliably, nothing is recognized: the item is a contingent liability, disclosed in the notes. If the possibility is remote, it disappears entirely. Contingent assets are treated more strictly still: disclosed when probable, recognized only when virtually certain.', 'يُعترف بالمخصص فقط عند اجتماع ثلاثة شروط: وجود التزام حالي (قانوني أو استدلالي) ناشئ عن حدث ماضٍ؛ ورجحان تدفق موارد خارج، أي أرجح من عدمه؛ وإمكان تقدير المبلغ بموثوقية. وينشأ الالتزام الاستدلالي من السلوك لا من العقد، كسياسة استرداد معلنة تخلق توقعاً مشروعاً يعتمد عليه العملاء. والقياس هو أفضل تقدير للإنفاق اللازم لتسوية الالتزام اليوم: فلمجموعة كبيرة من البنود المتشابهة يكون القيمةَ المتوقعة المرجحة بالاحتمالات؛ ولبند واحد يكون عادةً النتيجة الأرجح. وتُخصم المخصصات الجوهرية بعيدة الأجل إلى قيمتها الحالية، وينحل الخصم عبئاً تمويلياً كل سنة. فإن كان التدفق ممكناً فقط لا راجحاً، أو تعذر قياسه بموثوقية، لم يُعترف بشيء: فالبند التزام محتمل يُفصح عنه في الإيضاحات. وإن كان الاحتمال بعيداً اختفى كلياً. أما الأصول المحتملة فتُعامل بصرامة أشد: يُفصح عنها عند الرجحان، ولا يُعترف بها إلا عند شبه اليقين.'),
      ],
      formulas: [
        KBFormula('Provision = Σ (Outcomeᵢ × Probabilityᵢ)', caption: Bi('Expected-value measurement for large populations of similar obligations.', 'القياس بالقيمة المتوقعة لمجموعات كبيرة من الالتزامات المتشابهة.')),
      ],
    ),
    KBSection(
      heading: Bi('Worked example: a warranty provision', 'مثال محلول: مخصص ضمان'),
      paragraphs: [
        Bi('A manufacturer sells 20,000 appliances this year with a two-year warranty. Experience says 4% of units develop a minor fault costing SAR 150 to repair and 1% develop a major fault costing SAR 900. The provision is 20,000 × (4% × 150 + 1% × 900) = 20,000 × (6 + 9) = SAR 300,000, recognized as an expense now, against this year’s revenue. As actual claims arrive they are charged against the provision, not against future income statements. At each reporting date the estimate is revisited: if failure rates run at 5%, the provision is topped up through profit; if a design fix cuts them, the excess is released. The income statement effect always lands in the period when the estimate changes, which is exactly why auditors read warranty tables and claims histories closely.', 'يبيع مصنّع 20,000 جهاز هذه السنة بضمان سنتين. تقول الخبرة إن 4% من الوحدات يصيبها عطل بسيط كلفة إصلاحه 150 ريالاً و1% يصيبها عطل كبير كلفته 900 ريال. المخصص = 20,000 × (4% × 150 + 1% × 900) = 20,000 × (6 + 9) = 300,000 ريال، يُثبت مصروفاً الآن مقابل إيراد هذه السنة. وعندما تصل المطالبات الفعلية تُحمَّل على المخصص لا على قوائم دخل مقبلة. وفي كل تاريخ تقرير يُراجع التقدير: فإن جرت معدلات الأعطال عند 5% عُزز المخصص عبر الربح؛ وإن خفضها إصلاح تصميمي أُطلق الفائض. ويقع أثر قائمة الدخل دائماً في فترة تغير التقدير، ولهذا بالضبط يقرأ المدققون جداول الضمان وسجلات المطالبات بعناية.'),
      ],
    ),
    KBSection(
      heading: Bi('Where the judgment lives', 'أين يسكن الحكم المهني'),
      paragraphs: [
        Bi('The line between probable and possible is the most litigated word in IAS 37, and it decides whether a lawsuit hits the balance sheet or only the notes. Restructuring provisions have their own gate: a detailed formal plan and a valid expectation among those affected, announced or begun, before anything is recognized, and future operating losses never qualify because they have no past obligating event. For the reader of statements, the provisions note rewards attention. The movements table (additions, amounts used, amounts reversed) is a public record of how good management’s past estimates were. Consistent reversals mean consistent over-provisioning, and that is an earnings-quality signal, not a rounding error.', 'الحد بين الراجح والممكن أكثر كلمة يُتنازع عليها في IAS 37، وهو الذي يقرر هل تضرب الدعوى القضائية الميزانيةَ أم الإيضاحات فقط. ولمخصصات إعادة الهيكلة بوابتها الخاصة: خطة رسمية مفصلة وتوقع مشروع لدى المتأثرين، معلنة أو مبدوءة، قبل الاعتراف بأي شيء، والخسائر التشغيلية المستقبلية لا تتأهل أبداً لأنها بلا حدث ماضٍ ملزم. ولقارئ القوائم، إيضاح المخصصات يكافئ الانتباه. فجدول الحركة (الإضافات والمبالغ المستخدمة والمبالغ المعكوسة) سجل علني لجودة تقديرات الإدارة الماضية. والعكوسات المتواصلة تعني إفراطاً متواصلاً في التخصيص، وتلك إشارة عن جودة الأرباح لا خطأ تقريب.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Using provisions to smooth profit: building them in good years and releasing them in bad ones is exactly the practice IAS 37’s recognition test was written to stop.', 'استخدام المخصصات لتنعيم الربح: بناؤها في السنوات الجيدة وإطلاقها في السيئة هو بالضبط ما كُتب اختبار الاعتراف في IAS 37 لإيقافه.'),
    Bi('Confusing provisions with reserves: a provision is a liability for an obligation to outsiders; a reserve is an equity appropriation. The words are casual synonyms in conversation and opposites on a balance sheet.', 'الخلط بين المخصصات والاحتياطيات: المخصص التزام تجاه أطراف خارجية؛ والاحتياطي تجنيب من حقوق الملكية. اللفظان مترادفان في الحديث ومتضادان في الميزانية.'),
    Bi('Ignoring contingent liabilities because they are “only disclosure”: a note about a possible obligation of material size is risk information the balance sheet is not allowed to show you.', 'تجاهل الالتزامات المحتملة لأنها "مجرد إفصاح": فإيضاح عن التزام ممكن بحجم جوهري معلومةُ خطرٍ لا يُسمح للميزانية بعرضها.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IAS 37',
      note: Bi('Provisions, contingent liabilities and contingent assets: the recognition test, best-estimate measurement, and the restructuring rules.', 'المخصصات والالتزامات المحتملة والأصول المحتملة: اختبار الاعتراف والقياس بأفضل تقدير وقواعد إعادة الهيكلة.'),
      segments: [
        KBStandardSegment('IAS 37', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-37-provisions-contingent-liabilities-and-contingent-assets/'),
      ],
    ),
    KBStandardRef(
      standard: 'IFRS 15 §B28–B33',
      note: Bi('Warranties: assurance-type warranties are IAS 37 provisions; service-type warranties are separate performance obligations.', 'الضمانات: ضمانات التأكيد مخصصات وفق IAS 37؛ وضمانات الخدمة التزامات أداء منفصلة.'),
      segments: [
        KBStandardSegment('IFRS 15', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ifrs-15-revenue-from-contracts-with-customers/'),
        KBStandardSegment(' §B28–B33'),
      ],
    ),
  ],
  relatedTerms: [
    'Provision',
    'Contingent Liability',
    'Liabilities',
    'Accrued Expenses',
    'Conservatism (Prudence)',
    'Matching Principle',
  ],
  relatedModules: [
    KBRelatedModule('/education/fundamentals', Bi('Module: Financial Management Primer', 'الوحدة: تمهيد الإدارة المالية')),
    KBRelatedModule('/education/financial-analysis', Bi('Module: Analysis of Financial Statements', 'الوحدة: تحليل القوائم المالية')),
  ],
  relatedArticles: [
    'accrual-accounting',
    'balance-sheet',
    'revenue-recognition',
    'income-statement',
    'internal-control-audit',
    'deferred-tax',
    'employee-benefits',
    'earnings-quality',
  ],
  references: [
    'IFRS Foundation. (1998). IAS 37 Provisions, Contingent Liabilities and Contingent Assets. IFRS Foundation.',
    'Picker, R., Clark, K., Dunn, J., Kolitz, D., Livne, G., Loftus, J., & van der Tas, L. (2019). Applying IFRS standards (4th ed.). Wiley.',
    'Kieso, D. E., Weygandt, J. J., & Warfield, T. D. (2020). Intermediate accounting: IFRS edition (4th ed.). Wiley.',
  ],
  keywords: [
    'provision',
    'contingent liability',
    'IAS 37',
    'warranty',
    'restructuring',
    'expected value',
    'constructive obligation',
    'المخصصات',
    'الالتزامات المحتملة',
    'الضمان',
  ],
);
