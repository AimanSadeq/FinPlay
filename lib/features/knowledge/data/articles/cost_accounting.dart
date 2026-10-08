// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/cost-accounting.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbCostAccounting = KBArticle(
  id: 'cost-accounting',
  title: Bi('Cost Accounting: Absorption, Variable and Activity-Based', 'محاسبة التكاليف: الاستيعابية والمتغيرة والقائمة على الأنشطة'),
  category: 'financial-analysis',
  level: KBLevel.intermediate,
  readingMinutes: 8,
  summary: Bi('How overhead gets attached to products, why absorption and variable costing report different profits from identical operations, what activity-based costing fixes, and a worked example where the traditional allocation hides a loss-making product.', 'كيف تُحمَّل التكاليف غير المباشرة على المنتجات، ولماذا تعرض التكلفة الاستيعابية والمتغيرة أرباحاً مختلفة لعمليات متطابقة، وما الذي تصلحه التكلفة على أساس الأنشطة، ومثال محلول يخفي فيه التحميل التقليدي منتجاً خاسراً.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('Financial accounting tells the outside world what the company earned. Cost accounting tells management what things cost, which is a harder question than it sounds. Direct materials and direct labour are easy: you can trace them to a unit. The difficulty is overhead, the factory rent, the supervisors, the quality lab, the machine maintenance, costs that exist because the whole operation exists and belong to no single product. Every costing system is a rule for spreading those shared costs across output. The rule is a choice, and it is not neutral: change the rule and the same factory reports different product costs, different product margins, and sometimes different total profit. Managers who do not know which rule their numbers came from are making pricing and product decisions on an artefact of the allocation method.', 'المحاسبة المالية تخبر العالم الخارجي بما كسبته الشركة. ومحاسبة التكاليف تخبر الإدارة بكم تكلف الأشياء، وهو سؤال أصعب مما يبدو. فالمواد المباشرة والعمالة المباشرة سهلة: يمكن تتبعها إلى الوحدة. والصعوبة في التكاليف غير المباشرة: إيجار المصنع والمشرفون ومختبر الجودة وصيانة الآلات، وهي تكاليف توجد لأن العملية كلها موجودة ولا تخص منتجاً بعينه. وكل نظام تكاليف قاعدةٌ لتوزيع تلك التكاليف المشتركة على الإنتاج. والقاعدة اختيار، وليست محايدة: غيّر القاعدة فيعرض المصنع نفسه تكاليف منتجات مختلفة، وهوامش منتجات مختلفة، وأحياناً ربحاً إجمالياً مختلفاً. والمديرون الذين لا يعرفون من أي قاعدة جاءت أرقامهم يتخذون قرارات تسعير ومنتجات بناءً على أثر جانبي لطريقة التحميل.'),
      ],
    ),
    KBSection(
      heading: Bi('The formal treatment: three systems', 'المعالجة النظرية: ثلاثة أنظمة'),
      paragraphs: [
        Bi('Absorption costing, required by IAS 2 for inventory in published accounts, treats fixed production overhead as a product cost: it is absorbed into each unit using a predetermined rate, usually per labour hour or machine hour, and it stays in inventory on the balance sheet until the unit is sold. Variable costing, used only internally, treats fixed overhead as a period cost expensed as incurred, so unit cost contains only variable elements. The difference matters when production and sales differ. If a factory produces more than it sells, absorption costing parks some fixed overhead in closing inventory and reports higher profit; variable costing does not. That is why a plant can raise reported profit by building stock nobody ordered, a distortion variable costing removes and one that internal reporting should catch. Activity-based costing attacks a different problem: the assumption that overhead is driven by volume. ABC identifies the activities that actually consume resources, such as machine setups, purchase orders, inspections and customer deliveries, assigns costs to those activity pools, then charges products according to how much of each activity they demand. A low-volume product with frequent setups absorbs little under a labour-hour rate and a great deal under ABC, which is usually closer to the truth.', 'التكلفة الاستيعابية، وهي ما يوجبه IAS 2 للمخزون في الحسابات المنشورة، تعامل التكاليف الصناعية الثابتة تكلفةَ منتج: فتُستوعب في كل وحدة بمعدل محدد سلفاً، عادةً لكل ساعة عمل أو ساعة آلة، وتبقى في المخزون بالميزانية حتى تُباع الوحدة. والتكلفة المتغيرة، وتُستخدم داخلياً فقط، تعامل التكاليف الثابتة تكلفةَ فترة تُحمَّل عند تكبدها، فلا تحتوي تكلفة الوحدة إلا عناصر متغيرة. ويهم الفرق حين يختلف الإنتاج عن المبيعات. فإن أنتج مصنع أكثر مما باع، ركنت التكلفة الاستيعابية بعض التكاليف الثابتة في مخزون الإقفال وعرضت ربحاً أعلى؛ ولا تفعل التكلفة المتغيرة ذلك. ولهذا يستطيع مصنع رفع الربح المعروض ببناء مخزون لم يطلبه أحد، وهو تشويه تزيله التكلفة المتغيرة وينبغي أن تلتقطه التقارير الداخلية. أما التكلفة على أساس الأنشطة فتهاجم مشكلة أخرى: افتراض أن الحجم هو ما يقود التكاليف غير المباشرة. فهي تحدد الأنشطة التي تستهلك الموارد فعلاً، كتهيئة الآلات وأوامر الشراء وعمليات الفحص وتسليمات العملاء، وتُسند التكاليف إلى مجمعات تلك الأنشطة، ثم تحمّل المنتجات بحسب ما تطلبه من كل نشاط. فالمنتج قليل الحجم كثير التهيئة يستوعب قليلاً بمعدل ساعات العمل وكثيراً بالتكلفة على أساس الأنشطة، وهذا أقرب إلى الحقيقة عادةً.'),
      ],
      formulas: [
        KBFormula('Overhead absorption rate = Budgeted overhead ÷ Budgeted activity level    ·    Over/under absorption = Absorbed − Actual overhead', caption: Bi('The traditional single-rate method, and the variance it inevitably produces.', 'الطريقة التقليدية بمعدل واحد، والانحراف الذي تنتجه حتماً.')),
        KBFormula('ABC product cost = Direct costs + Σ (Activity cost per driver unit × Driver units consumed)', caption: Bi('Activity-based costing: overhead follows the activity that caused it.', 'التكلفة على أساس الأنشطة: التكلفة غير المباشرة تتبع النشاط الذي سببها.')),
      ],
    ),
    KBSection(
      heading: Bi('Worked example: the product that was never profitable', 'مثال محلول: المنتج الذي لم يكن رابحاً قط'),
      paragraphs: [
        Bi('A plant makes two products and incurs SAR 2,000,000 of overhead. Product A is high volume: 90,000 units, 18,000 labour hours, 20 production setups. Product B is a specialty line: 10,000 units, 2,000 labour hours, 180 setups. Under a traditional labour-hour rate, overhead is 2,000,000 ÷ 20,000 hours = SAR 100 per hour, so A absorbs SAR 1,800,000 (SAR 20 per unit) and B absorbs SAR 200,000 (SAR 20 per unit). Both look identically costly to produce. Now run ABC. Suppose SAR 800,000 of the overhead is setup-driven and the remaining SAR 1,200,000 genuinely tracks labour hours. Setup cost per setup is 800,000 ÷ 200 = SAR 4,000, so A takes 20 × 4,000 = SAR 80,000 and B takes 180 × 4,000 = SAR 720,000. The labour-driven pool splits 1,080,000 to A and 120,000 to B. Total: A absorbs SAR 1,160,000 (SAR 12.89 per unit) and B absorbs SAR 840,000 (SAR 84 per unit). B is more than four times as expensive per unit as the old system claimed. If B was priced on a SAR 20 overhead assumption, the specialty line has been quietly subsidised by the volume line for years, and the sales team has been rewarded for selling it.', 'مصنع ينتج منتجين ويتكبد تكاليف غير مباشرة قدرها مليونا ريال. المنتج (أ) كبير الحجم: 90,000 وحدة، و18,000 ساعة عمل، و20 عملية تهيئة. والمنتج (ب) خط متخصص: 10,000 وحدة، و2,000 ساعة عمل، و180 عملية تهيئة. وبمعدل ساعات العمل التقليدي تكون التكلفة غير المباشرة 2,000,000 ÷ 20,000 ساعة = 100 ريال للساعة، فيستوعب (أ) 1,800,000 ريال (20 ريالاً للوحدة) ويستوعب (ب) 200,000 ريال (20 ريالاً للوحدة). ويبدو إنتاجهما متساوي الكلفة تماماً. والآن طبّق التكلفة على أساس الأنشطة. افترض أن 800,000 ريال من التكاليف تقودها التهيئة وأن المليون ومئتي ألف الباقية تتبع ساعات العمل فعلاً. فتكلفة التهيئة الواحدة 800,000 ÷ 200 = 4,000 ريال، فيأخذ (أ) 20 × 4,000 = 80,000 ريال ويأخذ (ب) 180 × 4,000 = 720,000 ريال. ويُقسم مجمع ساعات العمل 1,080,000 لـ(أ) و120,000 لـ(ب). المجموع: يستوعب (أ) 1,160,000 ريال (12.89 ريالاً للوحدة) ويستوعب (ب) 840,000 ريال (84 ريالاً للوحدة). فالمنتج (ب) أغلى للوحدة بأكثر من أربعة أضعاف ما ادعاه النظام القديم. وإن كان (ب) قد سُعِّر على افتراض عشرين ريالاً للتكاليف غير المباشرة، فالخط المتخصص كان يُدعَم بهدوء من خط الحجم سنوات، وكان فريق المبيعات يُكافأ على بيعه.'),
      ],
    ),
    KBSection(
      heading: Bi('Choosing a system and living with it', 'اختيار نظام والتعايش معه'),
      paragraphs: [
        Bi('No system is right in the abstract; each answers a different question. Absorption costing answers "what must I report?" and is compulsory for inventory in the financial statements. Variable costing answers "what does one more unit cost?" and is the right input for short-run pricing, make-or-buy and capacity decisions, because contribution margin, not fully absorbed cost, is what covers fixed costs. ABC answers "which products, customers and channels actually consume our resources?" and is the right tool for portfolio and pricing strategy, though it is expensive to build and maintain, which is why many companies run it as a periodic study rather than a permanent ledger. The professional discipline is to know which number is on the page. A product that loses money under ABC may still be worth keeping if it contributes above its variable cost and the capacity has no better use, and a product that looks profitable under absorption costing may be destroying value once its true activity demands are counted.', 'لا نظام صحيح في المطلق؛ فكل واحد يجيب سؤالاً مختلفاً. التكلفة الاستيعابية تجيب «ماذا يجب أن أعرض؟» وهي إلزامية للمخزون في القوائم المالية. والتكلفة المتغيرة تجيب «كم تكلف وحدة إضافية؟» وهي المدخل الصحيح لقرارات التسعير قصير الأجل والتصنيع أو الشراء والطاقة، لأن هامش المساهمة، لا التكلفة المستوعبة كاملة، هو ما يغطي التكاليف الثابتة. والتكلفة على أساس الأنشطة تجيب «أي المنتجات والعملاء والقنوات تستهلك مواردنا فعلاً؟» وهي الأداة الصحيحة لاستراتيجية المحفظة والتسعير، وإن كانت مكلفة البناء والصيانة، ولهذا يديرها كثيرون دراسةً دورية لا دفتراً دائماً. والانضباط المهني أن تعرف أي رقم على الصفحة. فالمنتج الخاسر بمقياس الأنشطة قد يستحق البقاء إن ساهم فوق تكلفته المتغيرة ولم يكن للطاقة استخدام أفضل، والمنتج الذي يبدو رابحاً بالتكلفة الاستيعابية قد يكون مدمراً للقيمة متى حُسبت متطلباته الحقيقية من الأنشطة.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Using fully absorbed cost for a short-run pricing decision: fixed overhead does not change with the order, so contribution margin is the relevant measure.', 'استخدام التكلفة المستوعبة كاملة في قرار تسعير قصير الأجل: فالتكاليف الثابتة لا تتغير بالطلبية، وهامش المساهمة هو المقياس الملائم.'),
    Bi('Letting production run ahead of sales to absorb overhead into inventory. It raises reported profit and consumes cash, which is the opposite of value creation.', 'ترك الإنتاج يسبق المبيعات لاستيعاب التكاليف في المخزون. فذلك يرفع الربح المعروض ويستهلك النقد، وهو نقيض خلق القيمة.'),
    Bi('Treating an ABC study as permanent truth: drivers change as processes change, and a five-year-old model can be as misleading as the labour-hour rate it replaced.', 'معاملة دراسة الأنشطة حقيقةً دائمة: فالمسببات تتغير بتغير العمليات، ونموذج عمره خمس سنوات قد يضلل كما ضلل معدل ساعات العمل الذي حل محله.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IAS 2 §12–14',
      note: Bi('Inventory costing: fixed production overhead is allocated on normal capacity, and unallocated overhead is expensed.', 'تكلفة المخزون: تُوزع التكاليف الصناعية الثابتة على الطاقة العادية، ويُحمَّل غير الموزع مصروفاً.'),
      segments: [
        KBStandardSegment('IAS 2', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-2-inventories/'),
        KBStandardSegment(' §12–14'),
      ],
    ),
    KBStandardRef(
      standard: 'IAS 1 §99–105',
      note: Bi('Analysis of expenses by nature or by function: the presentation choice that determines what outsiders can see of cost structure.', 'تحليل المصروفات بالطبيعة أو بالوظيفة: خيار العرض الذي يحدد ما يراه الخارجيون من هيكل التكلفة.'),
      segments: [
        KBStandardSegment('IAS 1', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-1-presentation-of-financial-statements/'),
        KBStandardSegment(' §99–105'),
      ],
    ),
  ],
  relatedTerms: [
    'Cost Accounting',
    'Direct Costs',
    'Indirect Costs (Overhead)',
    'Fixed Costs',
    'Variable Costs',
    'Contribution Margin',
    'Cost of Goods Sold (COGS)',
  ],
  relatedModules: [
    KBRelatedModule('/education/break-even', Bi('Module: Break-Even Analysis', 'الوحدة: تحليل نقطة التعادل')),
    KBRelatedModule('/education/financial-analysis', Bi('Module: Analysis of Financial Statements', 'الوحدة: تحليل القوائم المالية')),
  ],
  relatedArticles: [
    'break-even-analysis',
    'inventory-costing',
    'budgeting-variance',
    'income-statement',
    'transfer-pricing',
  ],
  references: [
    'Kaplan, R. S., & Cooper, R. (1998). Cost and effect: Using integrated cost systems to drive profitability and performance. Harvard Business School Press.',
    'Drury, C. (2021). Management and cost accounting (11th ed.). Cengage.',
    'IFRS Foundation. (2003). IAS 2 Inventories. IFRS Foundation.',
  ],
  keywords: [
    'cost accounting',
    'absorption costing',
    'variable costing',
    'activity-based costing',
    'ABC',
    'overhead allocation',
    'cost driver',
    'contribution margin',
    'محاسبة التكاليف',
    'التكلفة الاستيعابية',
    'التكلفة على أساس الأنشطة',
    'مسببات التكلفة',
  ],
);
