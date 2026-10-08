// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/budgeting-variance.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbBudgetingVariance = KBArticle(
  id: 'budgeting-variance',
  title: Bi('Budgeting and Variance Analysis', 'الموازنات وتحليل الانحرافات'),
  category: 'financial-analysis',
  level: KBLevel.intermediate,
  readingMinutes: 7,
  summary: Bi('How budgets convert strategy into numbers, why a raw budget-versus-actual comparison misleads, and the flexible-budget method that separates volume effects from price and efficiency effects.', 'كيف تحول الموازنات الاستراتيجية إلى أرقام، ولماذا تضلل المقارنة الخام بين الموازنة والفعلي، وطريقة الموازنة المرنة التي تفصل أثر الحجم عن أثري السعر والكفاءة.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('A budget is a plan expressed in money: management\'s statement of what resources will be used, where, and what results they should produce in the coming period. It serves three functions at once. Planning forces choices to be made in advance and in numbers. Coordination aligns departments that would otherwise optimize locally. Control provides the baseline against which actual results are judged, which is where variance analysis begins.', 'الموازنة خطة معبَّر عنها بالنقود: بيان الإدارة عن الموارد التي ستُستخدم، وأين، وما النتائج التي ينبغي أن تنتجها في الفترة القادمة. وهي تؤدي ثلاث وظائف معاً. التخطيط يفرض اتخاذ الخيارات مسبقاً وبالأرقام. والتنسيق يوائم بين إدارات كانت ستُحسِّن كلٌّ لنفسها محلياً. والرقابة توفر خط الأساس الذي تُحاكم إليه النتائج الفعلية، ومن هنا يبدأ تحليل الانحرافات.'),
        Bi('A variance is simply actual minus budget. The craft is in decomposition: a single "we overspent" number is unmanageable, but a variance separated into what was caused by volume, what by price, and what by efficiency assigns each part to the manager who can act on it. By convention a variance is favorable (F) when it increases profit and adverse (A) when it reduces it, and the sign is judged against profit, not against spending.', 'الانحراف ببساطة هو الفعلي ناقص الموازنة. والحِرفة في التفكيك: رقم واحد يقول «تجاوزنا الإنفاق» لا يمكن إدارته، أما الانحراف المفصول إلى ما سببه الحجم وما سببه السعر وما سببته الكفاءة فيُسند كل جزء إلى المدير القادر على معالجته. وعرفاً يكون الانحراف مواتياً (F) إذا زاد الربح وعكسياً (A) إذا أنقصه، وتُحاكم الإشارة إلى الربح لا إلى الإنفاق.'),
      ],
    ),
    KBSection(
      heading: Bi('The formal treatment: the flexible budget', 'المعالجة النظرية: الموازنة المرنة'),
      paragraphs: [
        Bi('The central error in naive budget control is comparing actual results at actual volume with a budget built for a different volume. If you sold 12,000 units against a budget of 10,000, costs should be higher; punishing the production manager for the extra material consumed by real demand is analytical nonsense. The flexible budget repairs this: restate the budget at the actual activity level, using budgeted prices and budgeted per-unit quantities. The total variance then splits cleanly in two. The sales-volume variance (flexible budget versus static budget) captures the profit effect of activity being different from plan, and belongs to the commercial side. The flexible-budget variance (actual versus flexible budget) captures price and efficiency effects at the true volume, and belongs to operations and procurement.', 'الخطأ المركزي في الرقابة الساذجة هو مقارنة نتائج فعلية عند حجم فعلي بموازنة بُنيت لحجم مختلف. إذا بعتَ 12,000 وحدة مقابل موازنة 10,000 فمن الطبيعي أن ترتفع التكاليف؛ ومعاقبة مدير الإنتاج على المواد الإضافية التي استهلكها الطلب الحقيقي عبثٌ تحليلي. والموازنة المرنة تصلح ذلك: أعد صياغة الموازنة عند مستوى النشاط الفعلي، بأسعار الموازنة وكميات الموازنة لكل وحدة. عندها ينقسم الانحراف الكلي انقساماً نظيفاً إلى اثنين. انحراف حجم المبيعات (المرنة مقابل الثابتة) يلتقط أثر اختلاف النشاط عن الخطة في الربح، وهو من نصيب الجانب التجاري. وانحراف الموازنة المرنة (الفعلي مقابل المرنة) يلتقط أثري السعر والكفاءة عند الحجم الحقيقي، وهو من نصيب العمليات والمشتريات.'),
        Bi('For any variable cost, the flexible-budget variance decomposes one level further. The price (rate) variance asks: did each unit of input cost more or less than planned? The efficiency (usage) variance asks: did we use more or fewer inputs per unit of output than planned? The two sum exactly to the flexible-budget variance for that cost.', 'ولأي تكلفة متغيرة، ينحل انحراف الموازنة المرنة مستوى آخر. انحراف السعر (المعدل) يسأل: هل كلفت وحدة المدخلات أكثر أم أقل من المخطط؟ وانحراف الكفاءة (الاستخدام) يسأل: هل استهلكنا مدخلات لكل وحدة إنتاج أكثر أم أقل من المخطط؟ ويساوي مجموع الاثنين بالضبط انحراف الموازنة المرنة لتلك التكلفة.'),
      ],
      formulas: [
        KBFormula('Price variance = (Actual price − Budget price) × Actual quantity', caption: Bi('Owned by whoever buys the input.', 'مسؤولية من يشتري المدخلات.')),
        KBFormula('Efficiency variance = (Actual quantity − Standard quantity for actual output) × Budget price', caption: Bi('Owned by whoever uses the input.', 'مسؤولية من يستخدم المدخلات.')),
      ],
    ),
    KBSection(
      heading: Bi('Worked example', 'مثال محلول'),
      paragraphs: [
        Bi('A training company budgets 100 course-days at a trainer cost of SAR 3,000 per day (SAR 300,000). The year closes with 120 course-days delivered at an average trainer cost of SAR 3,200 (SAR 384,000 actual). The naive reading: SAR 84,000 overspend, adverse. The flexible budget for 120 days is 120 × 3,000 = SAR 360,000. Decomposition: volume effect = 360,000 − 300,000 = SAR 60,000, extra cost that came with extra revenue-generating activity, not a control failure; price effect = (3,200 − 3,000) × 120 = SAR 24,000 adverse, the only part procurement should answer for. The 84,000 headline dissolves into 60,000 of healthy growth and 24,000 of genuine rate slippage.', 'شركة تدريب وضعت موازنة لـ 100 يوم تدريبي بتكلفة مدرب 3,000 ريال لليوم (300,000 ريال). وأُقفلت السنة على 120 يوماً منفذاً بمتوسط تكلفة 3,200 ريال (384,000 ريال فعلياً). القراءة الساذجة: تجاوز 84,000 ريال، عكسي. الموازنة المرنة لـ 120 يوماً = 120 × 3,000 = 360,000 ريال. التفكيك: أثر الحجم = 360,000 − 300,000 = 60,000 ريال، تكلفة إضافية جاءت مع نشاط إضافي مولد للإيراد لا إخفاق رقابي؛ وأثر السعر = (3,200 − 3,000) × 120 = 24,000 ريال عكسي، وهو الجزء الوحيد الذي تُسأل عنه المشتريات. يتحلل عنوان الـ 84,000 إلى 60,000 نمو صحي و24,000 انزلاق حقيقي في المعدل.'),
      ],
    ),
    KBSection(
      heading: Bi('Beyond the annual budget', 'ما بعد الموازنة السنوية'),
      paragraphs: [
        Bi('The fixed annual budget has known weaknesses: it ages quickly, it invites gaming (padded costs, sandbagged targets), and it can anchor spending to last year plus a percentage. The standard remedies each fix one weakness. Rolling forecasts re-plan a constant horizon (say, four quarters ahead) every quarter. Zero-based budgeting rebuilds spending from zero against activities rather than history, at a real administrative cost, so it is best applied selectively. In the public sector, program and performance budgeting links appropriations to objectives and outputs rather than to line items alone, the direction of most government budget reform, including in the GCC.', 'للموازنة السنوية الثابتة عيوب معروفة: تشيخ سريعاً، وتغري بالتلاعب (تكاليف منفوخة وأهداف مخفَّضة)، وقد ترسو بالإنفاق عند «العام الماضي زائد نسبة». والعلاجات المعيارية يعالج كل منها عيباً. التنبؤات المتدحرجة تعيد التخطيط لأفق ثابت (أربعة أرباع مثلاً) كل ربع. والموازنة الصفرية تعيد بناء الإنفاق من الصفر على أساس الأنشطة لا التاريخ، بتكلفة إدارية حقيقية، فالأفضل تطبيقها انتقائياً. وفي القطاع العام تربط موازنة البرامج والأداء الاعتماداتِ بالأهداف والمخرجات لا بالبنود وحدها، وهي وجهة معظم إصلاحات الموازنات الحكومية، ومنها إصلاحات دول الخليج.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Judging managers against the static budget at a different volume. Flex first; assign blame after.', 'محاكمة المديرين إلى الموازنة الثابتة عند حجم مختلف. مرِّن الموازنة أولاً؛ ثم وزِّع المسؤولية.'),
    Bi('Treating every favorable variance as good news. Under-spending on maintenance or training is a future cost wearing a green label.', 'اعتبار كل انحراف موافٍ خبراً ساراً. فالإنفاق الأقل على الصيانة أو التدريب تكلفة مستقبلية تلبس لافتة خضراء.'),
    Bi('Investigating every variance. Set materiality thresholds; chasing noise costs more than it saves.', 'التحقيق في كل انحراف. ضع عتبات أهمية نسبية؛ فمطاردة الضجيج تكلف أكثر مما توفر.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IPSAS 24',
      note: Bi('Presentation of budget information in financial statements: public-sector entities that publish their budgets must report actuals against them on a comparable basis, making variance analysis a statutory discipline.', 'عرض معلومات الموازنة في القوائم المالية: على منشآت القطاع العام التي تنشر موازناتها أن تعرض الفعلي مقابلها على أساس قابل للمقارنة، مما يجعل تحليل الانحرافات انضباطاً نظامياً.'),
      segments: [
        KBStandardSegment('IPSAS 24', href: 'https://www.ipsasb.org/standards-pronouncements', viaIndex: true),
      ],
    ),
    KBStandardRef(
      standard: 'IAS 1 (comparatives)',
      note: Bi('Private-sector statements do not present budgets; budget control is a management-accounting discipline that lives alongside, not inside, IFRS reporting.', 'قوائم القطاع الخاص لا تعرض الموازنات؛ فالرقابة الموازنية انضباط في المحاسبة الإدارية يعيش بجانب تقارير IFRS لا داخلها.'),
      segments: [
        KBStandardSegment('IAS 1', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-1-presentation-of-financial-statements/'),
        KBStandardSegment(' (comparatives)'),
      ],
    ),
  ],
  relatedTerms: [
    'Variance Analysis',
  ],
  relatedModules: [
    KBRelatedModule('/education/budgeting', Bi('Module: Government Budgeting', 'الوحدة: الموازنة الحكومية')),
  ],
  relatedArticles: [
    'income-statement',
    'break-even-analysis',
    'government-budget-cycle',
    'cost-accounting',
  ],
  references: [
    'Drury, C. (2021). Management and cost accounting (11th ed.). Cengage.',
    'Horngren, C. T., Datar, S. M., & Rajan, M. V. (2021). Cost accounting: A managerial emphasis (17th ed.). Pearson.',
    'International Public Sector Accounting Standards Board. (2006). IPSAS 24: Presentation of budget information in financial statements. IFAC.',
    'OECD. (2019). Budgeting and public expenditures in OECD countries 2019. OECD Publishing.',
  ],
  keywords: [
    'budget',
    'variance',
    'flexible budget',
    'zero-based',
    'rolling forecast',
    'موازنة',
    'انحرافات',
    'موازنة مرنة',
    'موازنة صفرية',
  ],
);
