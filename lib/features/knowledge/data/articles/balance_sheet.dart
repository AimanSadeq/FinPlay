// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/balance-sheet.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbBalanceSheet = KBArticle(
  id: 'balance-sheet',
  title: Bi('The Balance Sheet in Depth', 'الميزانية العمومية بعمق'),
  category: 'financial-statements',
  level: KBLevel.foundation,
  readingMinutes: 6,
  summary: Bi('The accounting equation as a claims statement, current/non-current classification under IAS 1, the mixed measurement problem, and what the balance sheet systematically leaves out.', 'معادلة المحاسبة بوصفها قائمةَ مطالبات، وتصنيف المتداول وغير المتداول وفق IAS 1، ومشكلة القياس المختلط، وما الذي تُغفله الميزانية العمومية بصورة منهجية.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('The balance sheet (statement of financial position) reports, at one instant, the resources an entity controls (assets) and the claims against those resources: creditors\' claims (liabilities) and the owners\' residual claim (equity). The equation Assets = Liabilities + Equity is not a rule that companies try to satisfy; it is an identity that follows from double-entry bookkeeping. Every asset was financed by someone, so listing the assets and listing the claims are two descriptions of the same total.', 'تعرض الميزانية العمومية (قائمة المركز المالي)، في لحظة واحدة، الموارد التي تسيطر عليها المنشأة (الأصول) والمطالبات على تلك الموارد: مطالبات الدائنين (الالتزامات) ومطالبة الملاك المتبقية (حقوق الملكية). ومعادلة الأصول = الالتزامات + حقوق الملكية ليست قاعدة تجتهد الشركات في تحقيقها؛ بل متطابقة تنتج من القيد المزدوج. فكل أصل مُوِّل من جهة ما، ولذلك فإن سرد الأصول وسرد المطالبات وصفان لمجموع واحد.'),
        Bi('Equity is therefore not "what the company is worth". It is the residual of two accounting measurements, made under specific recognition and measurement rules. Market value answers a different question with different inputs, which is why market-to-book ratios far from 1 are normal, especially for businesses rich in internally generated intangibles.', 'وعليه فحقوق الملكية ليست «قيمة الشركة». إنها المتبقي من قياسين محاسبيين أُجريا وفق قواعد اعتراف وقياس محددة. القيمة السوقية تجيب عن سؤال آخر بمدخلات أخرى، ولهذا فإن نسب القيمة السوقية إلى الدفترية البعيدة عن 1 أمر طبيعي، خاصة في الشركات الغنية بالأصول غير الملموسة المولدة داخلياً.'),
      ],
      formulas: [
        KBFormula('Assets = Liabilities + Equity    ⇔    Equity = Assets − Liabilities', caption: Bi('The accounting identity, read left as a financing statement and right as a residual-claim statement.', 'المتطابقة المحاسبية، تُقرأ يساراً بوصفها قائمة تمويل ويميناً بوصفها قائمة المطالبة المتبقية.')),
      ],
    ),
    KBSection(
      heading: Bi('The formal treatment: classification and measurement', 'المعالجة النظرية: التصنيف والقياس'),
      paragraphs: [
        Bi('IAS 1 requires assets and liabilities to be split into current (expected to be realized or settled within the normal operating cycle or twelve months) and non-current. This split powers liquidity analysis: working capital, the current ratio, and the quick ratio all read directly off it. A liability is current if the entity does not have the right at the reporting date to defer settlement for at least twelve months, a test that regularly reclassifies long-term loans with breached covenants into current liabilities and transforms the apparent liquidity position overnight.', 'يوجب المعيار IAS 1 فصل الأصول والالتزامات إلى متداولة (يُتوقع تحققها أو تسويتها خلال دورة التشغيل العادية أو اثني عشر شهراً) وغير متداولة. وعلى هذا الفصل يقوم تحليل السيولة: فرأس المال العامل ونسبة التداول والنسبة السريعة تُقرأ منه مباشرة. ويكون الالتزام متداولاً إذا لم يكن للمنشأة في تاريخ التقرير حقٌّ في تأجيل التسوية اثني عشر شهراً على الأقل، وهو اختبار يعيد بانتظام تصنيف قروض طويلة الأجل خُرقت تعهداتها إلى التزامات متداولة فيقلب صورة السيولة الظاهرة بين ليلة وضحاها.'),
        Bi('Measurement is deliberately mixed. Property, plant and equipment sits at depreciated historical cost (or revalued amounts under IAS 16), inventories at the lower of cost and net realizable value (IAS 2), most financial instruments at amortized cost or fair value (IFRS 9), and provisions at the best estimate of the settlement amount (IAS 37). A single column of numbers therefore mixes measurement dates and measurement bases; totals like "total assets" are meaningful for structure and financing analysis, but they are not a valuation.', 'القياس مختلط عمداً. فالممتلكات والمصانع والمعدات تُقاس بالتكلفة التاريخية المهلكة (أو بمبالغ إعادة التقييم وفق IAS 16)، والمخزون بالأقل من التكلفة وصافي القيمة القابلة للتحقق (IAS 2)، ومعظم الأدوات المالية بالتكلفة المطفأة أو القيمة العادلة (IFRS 9)، والمخصصات بأفضل تقدير لمبلغ التسوية (IAS 37). وهكذا يمزج عمود واحد من الأرقام تواريخ قياس وأسس قياس مختلفة؛ فمجاميع مثل «إجمالي الأصول» ذات معنى لتحليل الهيكل والتمويل، لكنها ليست تقييماً.'),
      ],
    ),
    KBSection(
      heading: Bi('Worked example: reading a financing structure', 'مثال محلول: قراءة هيكل تمويل'),
      paragraphs: [
        Bi('A company shows total assets of SAR 8.0m: current assets 3.0m (of which inventory 1.4m) and non-current 5.0m. It is financed by current liabilities of 2.5m, long-term debt of 3.0m, and equity of 2.5m. Working capital is 3.0 − 2.5 = SAR 0.5m; the current ratio is 1.20 and the quick ratio (excluding inventory) is (3.0 − 1.4) ÷ 2.5 = 0.64. Debt-to-equity is (2.5 + 3.0) ÷ 2.5 = 2.2. The reading: solvent but tightly financed, dependent on converting inventory on schedule, and with limited equity cushion; a covenant breach that reclassified the long-term debt would push the current ratio below 0.55 instantly. This is how classification turns a static list into a risk assessment.', 'تعرض شركة إجمالي أصول قدره 8.0 ملايين ريال: أصول متداولة 3.0 ملايين (منها مخزون 1.4 مليون) وغير متداولة 5.0 ملايين. وتُموَّل بالتزامات متداولة 2.5 مليون وديون طويلة الأجل 3.0 ملايين وحقوق ملكية 2.5 مليون. رأس المال العامل = 3.0 − 2.5 = 0.5 مليون ريال؛ ونسبة التداول 1.20؛ والنسبة السريعة (باستبعاد المخزون) = (3.0 − 1.4) ÷ 2.5 = 0.64. ونسبة الدين إلى حقوق الملكية = (2.5 + 3.0) ÷ 2.5 = 2.2. القراءة: شركة قادرة على الوفاء لكن تمويلها مشدود، تعتمد على تحويل المخزون في موعده، وبوسادة ملكية محدودة؛ ولو خُرق تعهدٌ فأعيد تصنيف الدين طويل الأجل لهبطت نسبة التداول دون 0.55 فوراً. هكذا يحول التصنيفُ قائمةً ساكنة إلى تقييم للمخاطر.'),
      ],
    ),
    KBSection(
      heading: Bi('What the balance sheet leaves out', 'ما الذي تُغفله الميزانية العمومية'),
      paragraphs: [
        Bi('Internally generated brands, customer relationships, trained workforces, and all research spending never appear as assets (IAS 38 prohibits recognizing internally generated goodwill and brands, and requires research to be expensed as incurred; only development costs meeting its criteria may be capitalized). Purchased versions of the same items do appear, which is why two economically similar companies can show very different balance sheets depending on whether they grew organically or by acquisition. Professionals should read the balance sheet as a rigorous record of transactions and obligations, not as an inventory of everything valuable the organization controls.', 'العلامات التجارية المولدة داخلياً وعلاقات العملاء والقوى العاملة المدربة وكل الإنفاق البحثي لا تظهر أصولاً أبداً (يحظر IAS 38 الاعتراف بالشهرة والعلامات المولدة داخلياً، ويوجب تحميل البحث مصروفاً عند تكبده؛ ولا يجوز رسملة سوى تكاليف التطوير المستوفية لمعاييره). بينما تظهر النسخ المشتراة من البنود ذاتها، ولهذا قد تعرض شركتان متشابهتان اقتصادياً ميزانيتين مختلفتين جداً تبعاً لنموهما العضوي أو بالاستحواذ. وعلى المهنيين قراءة الميزانية بوصفها سجلاً صارماً للمعاملات والالتزامات، لا حصراً لكل ما تسيطر عليه المنظمة من قيمة.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Reading equity as market value. Book equity is a residual of accounting measurements, not a valuation.', 'قراءة حقوق الملكية على أنها القيمة السوقية. فحقوق الملكية الدفترية متبقٍ من قياسات محاسبية، لا تقييم.'),
    Bi('Comparing companies\' asset totals without noting revaluation policies and acquisition history.', 'مقارنة إجماليات أصول الشركات دون الانتباه إلى سياسات إعادة التقييم وتاريخ الاستحواذات.'),
    Bi('Ignoring the maturity profile inside "non-current": debt due in 13 months and debt due in 10 years carry very different refinancing risk.', 'تجاهل جدول الاستحقاق داخل «غير المتداول»: فدين يستحق بعد 13 شهراً ودين يستحق بعد 10 سنوات يحملان مخاطر إعادة تمويل مختلفة جداً.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IAS 1 §54–80A',
      note: Bi('Minimum line items and the current/non-current classification, including the right-to-defer test for liabilities.', 'الحد الأدنى من البنود وتصنيف المتداول/غير المتداول، بما فيه اختبار حق التأجيل للالتزامات.'),
      segments: [
        KBStandardSegment('IAS 1', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-1-presentation-of-financial-statements/'),
        KBStandardSegment(' §54–80A'),
      ],
    ),
    KBStandardRef(
      standard: 'IAS 16 · IAS 2 · IFRS 9 · IAS 37 · IAS 38',
      note: Bi('The measurement bases that make the statement a mixed-attribute model.', 'أسس القياس التي تجعل القائمة نموذجاً مختلط الخصائص.'),
      segments: [
        KBStandardSegment('IAS 16', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-16-property-plant-and-equipment/'),
        KBStandardSegment(' · '),
        KBStandardSegment('IAS 2', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-2-inventories/'),
        KBStandardSegment(' · '),
        KBStandardSegment('IFRS 9', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ifrs-9-financial-instruments/'),
        KBStandardSegment(' · '),
        KBStandardSegment('IAS 37', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-37-provisions-contingent-liabilities-and-contingent-assets/'),
        KBStandardSegment(' · '),
        KBStandardSegment('IAS 38', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-38-intangible-assets/'),
      ],
    ),
    KBStandardRef(
      standard: 'IPSAS 1',
      note: Bi('Public-sector presentation of financial statements, with net assets/equity in place of shareholders\' equity.', 'عرض القوائم المالية في القطاع العام، مع صافي الأصول/حقوق الملكية بدل حقوق المساهمين.'),
      segments: [
        KBStandardSegment('IPSAS 1', href: 'https://www.ipsasb.org/standards-pronouncements', viaIndex: true),
      ],
    ),
  ],
  relatedTerms: [
    'Balance Sheet',
    'Assets',
    'Liabilities',
    'Shareholders\' Equity',
    'Current Ratio',
    'Working Capital',
  ],
  relatedModules: [
    KBRelatedModule('/education/financial-statements', Bi('Module: Understanding Financial Statements', 'الوحدة: فهم القوائم المالية')),
    KBRelatedModule('/education/financial-analysis', Bi('Module: Analysis of Financial Statements', 'الوحدة: تحليل القوائم المالية')),
  ],
  relatedArticles: [
    'income-statement',
    'working-capital',
    'wacc',
    'financial-ratios',
    'depreciation-methods',
    'inventory-costing',
    'esg-sustainability-reporting',
    'consolidation-goodwill',
    'leases-ifrs16',
    'impairment-testing',
    'provisions-contingencies',
    'equity-and-oci',
    'financial-instruments',
    'deferred-tax',
    'employee-benefits',
    'discontinued-operations',
    'borrowing-costs',
    'intangible-assets',
    'investment-property',
  ],
  references: [
    'IFRS Foundation. (2007). IAS 1 Presentation of financial statements. IFRS Foundation.',
    'IFRS Foundation. (2003). IAS 16 Property, plant and equipment; IAS 2 Inventories; IAS 38 Intangible assets. IFRS Foundation.',
    'Penman, S. H. (2013). Financial statement analysis and security valuation (5th ed.). McGraw-Hill.',
    'International Public Sector Accounting Standards Board. (2006). IPSAS 1: Presentation of financial statements. IFAC.',
  ],
  keywords: [
    'balance sheet',
    'financial position',
    'assets',
    'liabilities',
    'equity',
    'classification',
    'ميزانية',
    'مركز مالي',
    'أصول',
    'التزامات',
  ],
);
