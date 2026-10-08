// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/zakat-and-tax.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbZakatAndTax = KBArticle(
  id: 'zakat-and-tax',
  title: Bi('Zakat and Taxation in Saudi Arabia: An Overview', 'الزكاة والضرائب في المملكة العربية السعودية: نظرة عامة'),
  category: 'public-sector',
  level: KBLevel.intermediate,
  readingMinutes: 7,
  summary: Bi('The levies a business in the Kingdom actually meets: Zakat and corporate income tax and how ownership splits them, VAT and its invoice discipline, withholding tax, and the accounting that carries them into the statements.', 'الفرائض التي تواجهها المنشأة في المملكة فعلاً: الزكاة وضريبة الدخل وكيف تقسمهما الملكية، وضريبة القيمة المضافة وانضباط فواتيرها, وضريبة الاستقطاع، والمحاسبة التي تحملها إلى القوائم.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('The Saudi fiscal system, administered by the Zakat, Tax and Customs Authority (ZATCA), rests on a distinctive split. Zakat, the religious levy, applies to the share of a business owned by Saudi and GCC nationals; corporate income tax applies to the share owned by others. A wholly Saudi-owned company files Zakat; a wholly foreign-owned company files income tax; a mixed company files both, pro rata to ownership. Around this core sit the transaction taxes everyone meets regardless of ownership: value added tax on supplies, withholding tax on certain payments abroad, excise tax on specific goods, and real estate transaction tax. For a non-finance professional, the practical point is that these levies are not year-end events for the tax department; they live inside pricing, contracts, invoices, and cash flow timing all year.', 'يقوم النظام المالي السعودي، الذي تديره هيئة الزكاة والضريبة والجمارك، على قسمة مميزة. فالزكاة، الفريضة الشرعية، تسري على حصة المنشأة المملوكة لسعوديين ومواطني دول الخليج؛ وضريبة الدخل تسري على حصة غيرهم. الشركة السعودية بالكامل تقر عن الزكاة؛ والأجنبية بالكامل عن ضريبة الدخل؛ والمختلطة عن الاثنتين بنسبة الملكية. وحول هذا الجوهر تقف ضرائب المعاملات التي يواجهها الجميع أياً كانت الملكية: القيمة المضافة على التوريدات، والاستقطاع على مدفوعات معينة للخارج، والانتقائية على سلع محددة، وضريبة التصرفات العقارية. وللمهني غير المالي، النقطة العملية أن هذه الفرائض ليست أحداث نهاية سنة لإدارة الضرائب؛ إنها تعيش داخل التسعير والعقود والفواتير وتوقيت النقد طوال العام.'),
      ],
    ),
    KBSection(
      heading: Bi('Zakat and income tax: the direct levies', 'الزكاة وضريبة الدخل: الفريضتان المباشرتان'),
      paragraphs: [
        Bi('Zakat is charged at 2.5% (for a lunar year) not on profit but on the Zakat base, which approximates the capital employed in the business that is not invested in long-term assets: broadly equity plus certain additions (such as loans financing the business) minus deductions (such as fixed assets and long-term investments), with detailed rules in the ZATCA regulations. Two businesses with identical profits can owe very different Zakat because their balance sheets differ, which is why Zakat planning is balance-sheet planning. Corporate income tax is charged at 20% on adjusted taxable profit of the non-Saudi share, with the familiar machinery of add-backs, exemptions, and loss carry-forwards. Natural-resource activities carry their own higher regimes. Both levies are self-assessed through annual returns with ZATCA, and both interact with the transfer-pricing rules described in this knowledge base: intragroup prices move the profit and the base on which these levies land.', 'تُفرض الزكاة بواقع 2.5% (عن سنة هجرية) لا على الربح بل على الوعاء الزكوي الذي يقارب رأس المال العامل في النشاط غير المستثمر في أصول طويلة الأجل: تقريباً حقوق الملكية زائد إضافات معينة (كالقروض الممولة للنشاط) ناقص حسومات (كالأصول الثابتة والاستثمارات طويلة الأجل)، بقواعد تفصيلية في لوائح الهيئة. ومنشأتان بربح متطابق قد تدينان بزكاة مختلفة جداً لاختلاف ميزانيتيهما، ولهذا فتخطيط الزكاة تخطيطُ ميزانية. وتفرض ضريبة الدخل بواقع 20% على الربح الخاضع المعدل لحصة غير السعوديين، بالآلية المألوفة من الإضافات والإعفاءات وترحيل الخسائر. وللأنشطة الطبيعية أنظمتها الأعلى الخاصة. وكلتا الفريضتين تقر ذاتياً بإقرارات سنوية لدى الهيئة، وكلتاهما تتفاعل مع قواعد تسعير التحويل الموصوفة في قاعدة المعرفة هذه: فأسعار المجموعة تحرك الربح والوعاء اللذين تحط عليهما الفريضتان.'),
      ],
      formulas: [
        KBFormula('Zakat ≈ 2.5% × Zakat base (capital employed, per ZATCA rules)    ·    CIT = 20% × adjusted taxable profit (non-Saudi share)', caption: Bi('Awareness-level skeletons; the detailed base computations follow the ZATCA implementing regulations.', 'هيكلان للإحاطة؛ وحسابات الوعاء التفصيلية تتبع اللوائح التنفيذية للهيئة.')),
      ],
    ),
    KBSection(
      heading: Bi('VAT, withholding, and the invoice discipline', 'القيمة المضافة والاستقطاع وانضباط الفواتير'),
      paragraphs: [
        Bi('VAT applies at 15% (since July 2020) to most supplies of goods and services. Its logic is the credit chain: a registered business charges output VAT on sales, deducts input VAT on purchases, and remits the difference; the tax is designed to rest on the final consumer, not on compliant businesses. The design works only through documents, which is why the e-invoicing program (FATOORA) matters operationally: invoices are generated electronically in prescribed formats and, in the integration phase, cleared with ZATCA in near real time. For managers the discipline is simple: a purchase without a valid tax invoice is a purchase whose VAT the company eats, and pricing that forgets output VAT gives away margin by law. Withholding tax applies when payments for services, royalties, interest-like amounts, or rents go to non-residents: the Saudi payer withholds between 5% and 20% depending on the payment type (subject to tax treaties) and remits it monthly. Contracts with foreign providers should say explicitly who bears it; "net of tax" clauses quietly raise the real cost by the withholding.', 'تسري ضريبة القيمة المضافة بواقع 15% (منذ يوليو 2020) على معظم توريدات السلع والخدمات. ومنطقها سلسلة الخصم: المنشأة المسجلة تحصِّل ضريبة المخرجات على مبيعاتها، وتخصم ضريبة المدخلات على مشترياتها، وتورد الفرق؛ فالضريبة مصممة لتستقر على المستهلك النهائي لا على المنشآت الملتزمة. ولا يعمل التصميم إلا بالمستندات، ولهذا يهم برنامج الفوترة الإلكترونية (فاتورة) تشغيلياً: تُنشأ الفواتير إلكترونياً بصيغ محددة، وفي مرحلة الربط تُعتمد لدى الهيئة شبه لحظياً. وللمديرين الانضباط بسيط: شراء بلا فاتورة ضريبية صحيحة شراءٌ تبتلع الشركة ضريبته، وتسعيرٌ ينسى ضريبة المخرجات يتنازل عن الهامش بحكم النظام. وتسري ضريبة الاستقطاع حين تذهب مدفوعات الخدمات والإتاوات والمبالغ الشبيهة بالفوائد والإيجارات إلى غير مقيمين: يستقطع الدافع السعودي بين 5% و20% حسب نوع الدفعة (مع مراعاة الاتفاقيات الضريبية) ويوردها شهرياً. وينبغي أن تنص العقود مع المزودين الأجانب صراحة على من يتحملها؛ فبنود «صافياً من الضريبة» ترفع الكلفة الحقيقية بمقدار الاستقطاع بصمت.'),
      ],
    ),
    KBSection(
      heading: Bi('Where it all lands in the statements', 'أين يحط كل ذلك في القوائم'),
      paragraphs: [
        Bi('Zakat and income tax appear in the tax line of the income statement and as liabilities until settled; deferred tax (IAS 12) arises where accounting and tax measurements differ in timing. VAT, by contrast, mostly never touches revenue or expense for a compliant business: output VAT collected is a liability to ZATCA, input VAT paid is a receivable, and the statements show the net position, though VAT timing genuinely moves cash flow, which is why the 13-week forecast in this knowledge base carries tax dates as fixed cash lines. Assessments can be reopened and appealed within statutory windows, so provisions and disclosures for uncertain positions follow IAS 37 logic. The standing professional advice is the same as for transfer pricing: rates, thresholds, and procedures evolve (the VAT rate itself has changed once already), so treat this article as a map, and ZATCA guidance as the road.', 'تظهر الزكاة وضريبة الدخل في سطر الضريبة بقائمة الدخل والتزاماتٍ حتى السداد؛ وتنشأ الضريبة المؤجلة (IAS 12) حيث يختلف توقيت القياسين المحاسبي والضريبي. أما القيمة المضافة فلا تمس غالباً إيراد المنشأة الملتزمة ولا مصروفها: ضريبة المخرجات المحصلة التزامٌ للهيئة، وضريبة المدخلات المدفوعة ذمةٌ مدينة، وتعرض القوائم صافي المركز، وإن كان توقيت الضريبة يحرك النقد فعلاً، ولهذا يحمل تنبؤ الثلاثة عشر أسبوعاً في قاعدة المعرفة هذه مواعيدَ الضريبة بنوداً نقدية ثابتة. ويمكن إعادة فتح الربوط والاعتراض عليها ضمن مدد نظامية، فتتبع مخصصات المراكز غير المؤكدة وإفصاحاتها منطق IAS 37. والنصيحة المهنية الدائمة كنصيحة تسعير التحويل: المعدلات والعتبات والإجراءات تتطور (معدل القيمة المضافة ذاته تغير مرة)، فعامل هذه المقالة خريطةً، وإرشادات الهيئة طريقاً.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Planning Zakat off the profit line. The base is balance-sheet driven; profit planning alone misses it.', 'تخطيط الزكاة من سطر الربح. الوعاء تقوده الميزانية؛ وتخطيط الربح وحده يخطئه.'),
    Bi('Signing "net of tax" foreign contracts without pricing the withholding: the company just bought the counterparty\'s tax.', 'توقيع عقود أجنبية «صافياً من الضريبة» دون تسعير الاستقطاع: الشركة اشترت للتو ضريبة الطرف الآخر.'),
    Bi('Treating VAT as a cost or a revenue. For compliant businesses it is a pass-through with cash-timing effects; errors in either direction distort margins.', 'معاملة القيمة المضافة تكلفةً أو إيراداً. هي للمنشآت الملتزمة عبورٌ بأثر توقيت نقدي؛ والخطأ في أي اتجاه يشوه الهوامش.'),
    Bi('Missing the e-invoicing format and archiving rules and discovering it at audit or assessment time.', 'إغفال اشتراطات صيغة الفوترة الإلكترونية وأرشفتها واكتشاف ذلك عند التدقيق أو الربط.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'ZATCA regulations',
      note: Bi('Zakat implementing regulations, the Income Tax Law, the VAT Law and its implementing regulations, and the e-invoicing (FATOORA) resolutions: the primary sources for every figure in this article.', 'اللائحة التنفيذية للزكاة، ونظام ضريبة الدخل، ونظام القيمة المضافة ولائحته، وقرارات الفوترة الإلكترونية (فاتورة): المصادر الأولية لكل رقم في هذه المقالة.'),
      segments: [
        KBStandardSegment('ZATCA', href: 'https://zatca.gov.sa/en/RulesRegulations/Pages/systems.aspx'),
        KBStandardSegment(' regulations'),
      ],
    ),
    KBStandardRef(
      standard: 'IAS 12 · IFRIC 23',
      note: Bi('Income taxes and uncertainty over tax treatments: how the direct levies and disputed positions reach the financial statements.', 'ضرائب الدخل وعدم اليقين في المعالجات الضريبية: كيف تصل الفرائض المباشرة والمراكز المتنازع عليها إلى القوائم.'),
      segments: [
        KBStandardSegment('IAS 12', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-12-income-taxes/'),
        KBStandardSegment(' · '),
        KBStandardSegment('IFRIC 23', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ifric-23-uncertainty-over-income-tax-treatments/'),
      ],
    ),
  ],
  relatedTerms: [
    'Deferred Taxes (Cash Flow)',
  ],
  relatedModules: [
    KBRelatedModule('/education/compliance', Bi('Module: Compliance', 'الوحدة: الالتزام')),
    KBRelatedModule('/education/budgeting', Bi('Module: Government Budgeting (state revenue side)', 'الوحدة: الموازنة الحكومية (جانب إيرادات الدولة)')),
  ],
  relatedArticles: [
    'transfer-pricing',
    'government-budget-cycle',
    'income-statement',
    'deferred-tax',
  ],
  references: [
    'Zakat, Tax and Customs Authority. (2024). Zakat, tax and customs regulations and guidelines. ZATCA. https://zatca.gov.sa',
    'IFRS Foundation. (1996). IAS 12 Income taxes; IFRIC 23 Uncertainty over income tax treatments. IFRS Foundation.',
    'PwC Middle East. (2024). Saudi Arabia: Corporate tax summaries. PwC Worldwide Tax Summaries.',
  ],
  keywords: [
    'Zakat',
    'income tax',
    'VAT',
    'withholding',
    'ZATCA',
    'FATOORA',
    'e-invoicing',
    'زكاة',
    'ضريبة الدخل',
    'قيمة مضافة',
    'استقطاع',
    'فاتورة',
  ],
);
