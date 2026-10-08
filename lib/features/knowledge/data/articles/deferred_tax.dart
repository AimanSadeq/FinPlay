// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/deferred-tax.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbDeferredTax = KBArticle(
  id: 'deferred-tax',
  title: Bi('Deferred Tax and the Tax Reconciliation', 'الضريبة المؤجلة ومطابقة الضريبة'),
  category: 'accounting-foundations',
  level: KBLevel.advanced,
  readingMinutes: 7,
  summary: Bi('Why the tax charge in the income statement never equals the tax paid, how temporary differences create deferred tax assets and liabilities, a worked depreciation difference, and how to read the effective tax rate reconciliation.', 'لماذا لا يساوي عبء الضريبة في قائمة الدخل الضريبةَ المدفوعة، وكيف تُنشئ الفروق المؤقتة أصولاً والتزامات ضريبية مؤجلة، ومثال محلول على فرق الاستهلاك، وكيف تقرأ مطابقة معدل الضريبة الفعلي.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('A company keeps one set of records for shareholders and another for the tax authority, and the two follow different rules. Accounting profit follows IFRS; taxable profit follows tax law, which may allow faster depreciation, disallow certain provisions, or tax income only when cash arrives. Deferred tax is the accounting device that stops those differences from distorting the reported result. The intuition is a promise: where a difference will reverse in the future, the company either owes tax later (a deferred tax liability) or has already paid tax on income it has not yet reported (a deferred tax asset). Recognizing that promise now means the tax charge in the income statement matches the profit reported beside it, rather than the cheque written this year.', 'تحتفظ الشركة بسجل للمساهمين وآخر لهيئة الضريبة، ويسير السجلان على قواعد مختلفة. فالربح المحاسبي يتبع IFRS؛ والربح الخاضع للضريبة يتبع قانون الضريبة الذي قد يسمح باستهلاك أسرع، أو يرفض مخصصات معينة، أو لا يفرض الضريبة إلا عند وصول النقد. والضريبة المؤجلة هي الأداة المحاسبية التي تمنع تلك الفروق من تشويه النتيجة المعروضة. والفكرة وعدٌ: فحيث ينعكس الفرق مستقبلاً، تكون الشركة إما مدينة بضريبة لاحقاً (التزام ضريبي مؤجل) وإما قد دفعت ضريبة على دخل لم تعرضه بعد (أصل ضريبي مؤجل). والاعتراف بذلك الوعد الآن يجعل عبء الضريبة في قائمة الدخل مطابقاً للربح المعروض بجواره، لا للشيك المحرر هذه السنة.'),
      ],
    ),
    KBSection(
      heading: Bi('The formal treatment: temporary differences', 'المعالجة النظرية: الفروق المؤقتة'),
      paragraphs: [
        Bi('IAS 12 uses the balance sheet approach. For each asset and liability, compare its carrying amount in the accounts with its tax base, the amount the tax authority will allow against future taxable income. The gap is a temporary difference. A taxable temporary difference (carrying amount above tax base for an asset) produces a deferred tax liability; a deductible temporary difference produces a deferred tax asset. Multiply the difference by the tax rate enacted or substantively enacted by the reporting date and expected to apply when it reverses, and that is the deferred tax balance. Permanent differences, such as a fine that is never deductible, create no deferred tax at all: they simply make the effective rate diverge from the statutory one forever. Deferred tax assets carry an extra hurdle, because an asset is only worth something if there will be profit to use it against: unused tax losses are recognized only to the extent future taxable profit is probable, which is why loss-making companies often carry large unrecognized loss pools disclosed only in the notes.', 'يستخدم IAS 12 نهج الميزانية. فلكل أصل والتزام، قارن مبلغه الدفتري في الحسابات بأساسه الضريبي، أي المبلغ الذي ستسمح هيئة الضريبة بخصمه من الدخل الخاضع مستقبلاً. والفجوة فرقٌ مؤقت. الفرق المؤقت الخاضع للضريبة (مبلغ دفتري أعلى من الأساس الضريبي في أصل) ينتج التزاماً ضريبياً مؤجلاً؛ والفرق المؤقت القابل للخصم ينتج أصلاً ضريبياً مؤجلاً. اضرب الفرق في معدل الضريبة الصادر أو الصادر جوهرياً حتى تاريخ التقرير والمتوقع تطبيقه عند الانعكاس، فيكون الناتج رصيد الضريبة المؤجلة. أما الفروق الدائمة، كغرامة لا تُخصم أبداً، فلا تنشئ ضريبة مؤجلة إطلاقاً: هي فقط تجعل المعدل الفعلي يفارق المعدل النظامي إلى الأبد. وللأصول الضريبية المؤجلة عقبة إضافية، لأن الأصل لا يساوي شيئاً ما لم يوجد ربح يُستخدم مقابله: فالخسائر الضريبية غير المستخدمة لا يُعترف بها إلا بقدر رجحان وجود ربح خاضع مستقبلاً، ولهذا تحمل الشركات الخاسرة غالباً أرصدة خسائر كبيرة غير معترف بها لا تظهر إلا في الإيضاحات.'),
      ],
      formulas: [
        KBFormula('Temporary difference = Carrying amount − Tax base', caption: Bi('The balance sheet comparison that drives every deferred tax balance.', 'المقارنة الميزانية التي يقوم عليها كل رصيد ضريبة مؤجلة.')),
        KBFormula('Deferred tax = Temporary difference × Expected tax rate on reversal    ·    Total tax expense = Current tax + Movement in deferred tax', caption: Bi('Measurement, and how the two halves add up to the charge in profit or loss.', 'القياس، وكيف يجتمع الشقان في العبء المحمل على الربح أو الخسارة.')),
      ],
    ),
    KBSection(
      heading: Bi('Worked example: accelerated tax depreciation', 'مثال محلول: استهلاك ضريبي معجل'),
      paragraphs: [
        Bi('A company buys equipment for SAR 1,000,000. The accounts depreciate it straight-line over five years (SAR 200,000 a year); the tax rules allow 40% in year one, then less. After year one, the carrying amount is 1,000,000 − 200,000 = SAR 800,000, while the tax base is 1,000,000 − 400,000 = SAR 600,000. The taxable temporary difference is SAR 200,000, and at a 20% tax rate the deferred tax liability is SAR 40,000. Nothing has been avoided: the company deducted more this year and will deduct less later, so the liability records tax deferred, not tax escaped. Over the asset’s life the difference unwinds to zero, and the deferred tax liability drains back through the income statement. This is the single most common source of deferred tax on a manufacturer’s balance sheet, and the reason a capital-intensive company can report a modest current tax bill for years while its total tax expense looks ordinary.', 'تشتري شركة معدات بمليون ريال. تستهلكها الحسابات بالقسط الثابت على خمس سنوات (200 ألف ريال سنوياً)؛ وتسمح قواعد الضريبة بخصم 40% في السنة الأولى ثم أقل. بعد السنة الأولى يكون المبلغ الدفتري 1,000,000 − 200,000 = 800 ألف ريال، بينما الأساس الضريبي 1,000,000 − 400,000 = 600 ألف ريال. الفرق المؤقت الخاضع 200 ألف ريال، وبمعدل ضريبة 20% يكون الالتزام الضريبي المؤجل 40 ألف ريال. ولم يُتجنب شيء: فقد خصمت الشركة أكثر هذه السنة وستخصم أقل لاحقاً، فالالتزام يسجل ضريبة مؤجلة لا ضريبة هاربة. وعلى مدى عمر الأصل ينحل الفرق إلى صفر، وينحسر الالتزام الضريبي المؤجل عائداً عبر قائمة الدخل. وهذا أشيع مصدر منفرد للضريبة المؤجلة في ميزانية أي مصنّع، وسبب أن شركة كثيفة رأس المال قد تعرض ضريبة جارية متواضعة سنوات بينما يبدو إجمالي عبئها الضريبي عادياً.'),
      ],
    ),
    KBSection(
      heading: Bi('Reading the effective tax rate reconciliation', 'قراءة مطابقة معدل الضريبة الفعلي'),
      paragraphs: [
        Bi('The effective tax rate is total tax expense divided by pre-tax profit, and it rarely equals the statutory rate. IAS 12 requires a reconciliation between the two, and that note is one of the most informative disclosures in a set of accounts. It shows where profit is earned (income taxed at lower rates abroad), what is never deductible (fines, some entertainment, certain impairments), what incentives apply (tax holidays, investment allowances), and whether the company has written off or reinstated deferred tax assets on past losses. A Saudi group carries a further complication: Saudi and GCC ownership is subject to Zakat while non-GCC ownership is subject to income tax, so the same group presents two levies. Zakat sits outside IAS 12, under SOCPA’s own standard, and is presented as a separate line rather than reconciled to a statutory income-tax rate; deferred tax therefore arises only on the income-tax-bearing share, which is why a wholly Saudi-owned company can have none at all. A rate that swings sharply year to year without a change in the business is a signal to read that reconciliation line by line.', 'معدل الضريبة الفعلي هو إجمالي عبء الضريبة مقسوماً على الربح قبل الضريبة، ونادراً ما يساوي المعدل النظامي. ويوجب IAS 12 مطابقةً بين الاثنين، وذلك الإيضاح من أكثر الإفصاحات إفادة في أي مجموعة حسابات. فهو يبين أين يُكسب الربح (دخل يخضع لمعدلات أدنى في الخارج)، وما الذي لا يُخصم أبداً (الغرامات وبعض الضيافة وبعض الهبوطات)، وما الحوافز المطبقة (إعفاءات ضريبية وبدلات استثمار)، وهل شطبت الشركة أو أعادت أصولاً ضريبية مؤجلة عن خسائر سابقة. وفي المجموعة السعودية تعقيد إضافي: فالملكية السعودية والخليجية تخضع للزكاة بينما تخضع الملكية غير الخليجية لضريبة الدخل، فتعرض المجموعة الواحدة جبايتين. والزكاة خارج نطاق IAS 12، بموجب معيار الهيئة السعودية للمراجعين والمحاسبين، وتُعرض سطراً مستقلاً لا تُطابق بمعدل ضريبة دخل نظامي؛ فلا تنشأ الضريبة المؤجلة إلا على الحصة الخاضعة لضريبة الدخل، ولهذا قد لا توجد إطلاقاً في شركة مملوكة بالكامل لسعوديين. والمعدل الذي يتأرجح بحدة من سنة لأخرى دون تغير في النشاط إشارةٌ إلى قراءة تلك المطابقة سطراً سطراً.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Treating the deferred tax liability as a debt that will be settled on a date: it unwinds only as the differences reverse, and a company that keeps investing can carry it indefinitely.', 'معاملة الالتزام الضريبي المؤجل ديناً يُسدد في تاريخ محدد: فهو ينحل فقط بانعكاس الفروق، وشركة تواصل الاستثمار قد تحمله بلا نهاية.'),
    Bi('Recognizing deferred tax assets on losses without evidence of future taxable profit. The recognition test, not the size of the loss pool, decides what belongs on the balance sheet.', 'الاعتراف بأصول ضريبية مؤجلة عن خسائر دون دليل على ربح خاضع مستقبلاً. فاختبار الاعتراف، لا حجم رصيد الخسائر، هو ما يقرر ما يستحق مكاناً في الميزانية.'),
    Bi('Confusing a low current tax bill with tax avoidance: accelerated allowances defer tax, and the deferred tax note is where the postponed amount is disclosed.', 'الخلط بين ضريبة جارية منخفضة وبين التهرب الضريبي: فالبدلات المعجلة تؤجل الضريبة، وإيضاح الضريبة المؤجلة هو موضع الإفصاح عن المبلغ المؤجل.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IAS 12',
      note: Bi('Income taxes: the balance sheet liability method, recognition of deferred tax assets, and the rate reconciliation disclosure.', 'ضرائب الدخل: طريقة الالتزام الميزانية، والاعتراف بالأصول الضريبية المؤجلة، وإفصاح مطابقة المعدل.'),
      segments: [
        KBStandardSegment('IAS 12', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-12-income-taxes/'),
      ],
    ),
    KBStandardRef(
      standard: 'IFRIC 23',
      note: Bi('Uncertainty over income tax treatments: how to reflect a position the tax authority may not accept.', 'عدم اليقين في المعالجات الضريبية: كيف يُعكس موقف قد لا تقبله هيئة الضريبة.'),
      segments: [
        KBStandardSegment('IFRIC 23', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ifric-23-uncertainty-over-income-tax-treatments/'),
      ],
    ),
  ],
  relatedTerms: [
    'Deferred Tax Assets',
    'Deferred Tax Liabilities',
    'Deferred Taxes (Cash Flow)',
    'Income Tax Expense',
    'Earnings Before Tax (EBT)',
    'Depreciation',
  ],
  relatedModules: [
    KBRelatedModule('/education/financial-analysis', Bi('Module: Analysis of Financial Statements', 'الوحدة: تحليل القوائم المالية')),
    KBRelatedModule('/education/fundamentals', Bi('Module: Financial Management Primer', 'الوحدة: تمهيد الإدارة المالية')),
  ],
  relatedArticles: [
    'income-statement',
    'balance-sheet',
    'depreciation-methods',
    'zakat-and-tax',
    'accrual-accounting',
    'interim-reporting',
  ],
  references: [
    'IFRS Foundation. (1996). IAS 12 Income Taxes. IFRS Foundation.',
    'Kieso, D. E., Weygandt, J. J., & Warfield, T. D. (2020). Intermediate accounting: IFRS edition (4th ed.). Wiley.',
    'Penman, S. H. (2013). Financial statement analysis and security valuation (5th ed.). McGraw-Hill.',
  ],
  keywords: [
    'deferred tax',
    'IAS 12',
    'temporary difference',
    'tax base',
    'effective tax rate',
    'tax reconciliation',
    'deferred tax asset',
    'deferred tax liability',
    'الضريبة المؤجلة',
    'الفروق المؤقتة',
    'الأساس الضريبي',
    'معدل الضريبة الفعلي',
  ],
);
