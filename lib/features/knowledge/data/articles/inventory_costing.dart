// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/inventory-costing.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbInventoryCosting = KBArticle(
  id: 'inventory-costing',
  title: Bi('Inventory and Cost Flow: FIFO and Weighted Average', 'المخزون وتدفق التكلفة: الوارد أولاً صادر أولاً والمتوسط المرجح'),
  category: 'accounting-foundations',
  level: KBLevel.foundation,
  readingMinutes: 5,
  summary: Bi('How the cost of goods sold is decided when identical units were bought at different prices, the two formulas IAS 2 allows, one purchase history worked under both, and the write-down rule.', 'كيف تتحدد تكلفة البضاعة المباعة عندما اشتُريت وحدات متطابقة بأسعار مختلفة، والصيغتان اللتان يجيزهما IAS 2، وسجل مشتريات واحد محلول بالطريقتين، وقاعدة تخفيض القيمة.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('When a company sells a unit from a shelf holding identical units bought at different prices, accounting must decide which cost leaves the balance sheet (becoming cost of goods sold) and which cost stays (as ending inventory). This is a cost-flow assumption, not a physical claim: nobody tracks which physical carton left the warehouse. The choice matters because in times of changing prices it moves profit between periods and changes both the income statement and the balance sheet at once.', 'عندما تبيع شركة وحدة من رف يحمل وحدات متطابقة اشتُريت بأسعار مختلفة، على المحاسبة أن تقرر أي تكلفة تغادر الميزانية (فتصير تكلفة بضاعة مباعة) وأي تكلفة تبقى (مخزوناً آخر المدة). هذا افتراض لتدفق التكلفة لا ادعاء مادي: لا أحد يتتبع أي كرتونة بعينها غادرت المستودع. والاختيار مهم لأنه في أزمنة تغير الأسعار ينقل الربح بين الفترات ويغير قائمة الدخل والميزانية معاً في آن واحد.'),
        Bi('IAS 2 permits two cost formulas for interchangeable items: FIFO (first-in, first-out), where the oldest costs leave first, and weighted average, where every unit carries the running average cost of the pool. Specific identification is required where items are not interchangeable (a car dealership, a jeweler). LIFO (last-in, first-out) is prohibited under IFRS, a genuine difference from US GAAP that still matters when comparing companies across regimes.', 'يجيز المعيار IAS 2 صيغتين للتكلفة في البنود المتماثلة: الوارد أولاً صادر أولاً (FIFO) حيث تغادر التكاليف الأقدم أولاً، والمتوسط المرجح حيث تحمل كل وحدة متوسط التكلفة الجاري للمجموعة. ويجب التحديد المعين حين لا تكون البنود متماثلة (معرض سيارات، ومحل مجوهرات). أما الوارد أخيراً صادر أولاً (LIFO) فمحظور في IFRS، وهو فرق حقيقي عن المعايير الأمريكية لا يزال مهماً عند مقارنة شركات عبر النظامين.'),
      ],
    ),
    KBSection(
      heading: Bi('Worked example: one history, two answers', 'مثال محلول: سجل واحد وإجابتان'),
      paragraphs: [
        Bi('A distributor starts the month with nothing, buys 100 units at SAR 50 (5,000), later 100 units at SAR 60 (6,000), and sells 120 units at SAR 90. Total available: 200 units costing SAR 11,000.', 'يبدأ موزع الشهر بلا رصيد، فيشتري 100 وحدة بسعر 50 ريالاً (5,000)، ثم 100 وحدة بسعر 60 ريالاً (6,000)، ويبيع 120 وحدة بسعر 90 ريالاً. المتاح الكلي: 200 وحدة تكلفتها 11,000 ريال.'),
      ],
      table: KBTable(
        headers: [
          Bi('Measure', 'المقياس'),
          Bi('FIFO', 'FIFO'),
          Bi('Weighted average', 'المتوسط المرجح'),
        ],
        rows: [
          [
            Bi('Cost of goods sold (120 units)', 'تكلفة البضاعة المباعة (120 وحدة)'),
            Bi('100 × 50 + 20 × 60 = SAR 6,200', '100 × 50 + 20 × 60 = 6,200 ريال'),
            Bi('120 × 55 = SAR 6,600', '120 × 55 = 6,600 ريال'),
          ],
          [
            Bi('Ending inventory (80 units)', 'مخزون آخر المدة (80 وحدة)'),
            Bi('80 × 60 = SAR 4,800', '80 × 60 = 4,800 ريال'),
            Bi('80 × 55 = SAR 4,400', '80 × 55 = 4,400 ريال'),
          ],
          [
            Bi('Gross profit on SAR 10,800 revenue', 'مجمل الربح على إيراد 10,800 ريال'),
            Bi('SAR 4,600', '4,600 ريال'),
            Bi('SAR 4,200', '4,200 ريال'),
          ],
        ],
      ),
    ),
    KBSection(
      heading: Bi('Reading the difference', 'قراءة الفرق'),
      paragraphs: [
        Bi('With prices rising, FIFO reports the higher profit (old, cheap costs go to COGS) and the fresher balance sheet (inventory at recent prices). Weighted average smooths both. Neither is "right": they are different allocations of the same SAR 11,000, and over the whole life of the inventory the total profit is identical; only its timing differs. The professional’s job is to know which formula a company uses (the accounting policy note says so), apply it consistently, and adjust mentally when comparing competitors on different formulas, especially for margin and inventory-turnover ratios.', 'مع ارتفاع الأسعار يعرض FIFO ربحاً أعلى (التكاليف القديمة الرخيصة تذهب إلى تكلفة المبيعات) وميزانية أحدث (المخزون بأسعار قريبة). ويُنعِّم المتوسط المرجح الاثنين. وليست إحداهما «الصواب»: إنهما توزيعان مختلفان للـ 11,000 ريال نفسها، وعلى مدى عمر المخزون كله يتطابق الربح الكلي؛ ويختلف توقيته فقط. ومهمة المهني أن يعرف الصيغة التي تستخدمها الشركة (إيضاح السياسات المحاسبية يقولها)، وأن تُطبق باتساق، وأن يعدل ذهنياً عند مقارنة منافسين على صيغتين مختلفتين، خاصة في نسب الهامش ودوران المخزون.'),
      ],
    ),
    KBSection(
      heading: Bi('The write-down rule and what goes into cost', 'قاعدة التخفيض وما يدخل في التكلفة'),
      paragraphs: [
        Bi('Two further IAS 2 rules complete the picture. First, measurement: inventory is carried at the lower of cost and net realizable value (estimated selling price minus costs to complete and sell). When goods become obsolete, damaged, or overpriced against the market, the write-down hits profit immediately; a later recovery can be reversed, but never above original cost. Second, composition of cost: purchase price plus import duties, transport and handling, plus production conversion costs with fixed overheads absorbed at normal capacity. Abnormal waste, storage of finished goods, and selling costs are expensed as incurred, never parked in inventory. Inventory is the classic place where profit problems hide, which is why analysts watch inventory growing faster than sales as an early warning.', 'قاعدتان أخريان في IAS 2 تكملان الصورة. أولاً القياس: يُقيد المخزون بالأقل من التكلفة وصافي القيمة القابلة للتحقق (سعر البيع المقدر ناقص تكاليف الإتمام والبيع). فإذا تقادمت البضاعة أو تلفت أو غلت على السوق، ضرب التخفيضُ الربحَ فوراً؛ ويجوز عكس استرداد لاحق لكن ليس فوق التكلفة الأصلية أبداً. ثانياً مكونات التكلفة: ثمن الشراء زائد الرسوم الجمركية والنقل والمناولة، زائد تكاليف التحويل الإنتاجية مع استيعاب الأعباء الثابتة عند الطاقة العادية. أما الهدر غير العادي وتخزين البضاعة الجاهزة وتكاليف البيع فتُحمَّل مصروفات فور وقوعها ولا تُركن في المخزون أبداً. والمخزون هو المكان الكلاسيكي الذي تختبئ فيه مشكلات الربح، ولهذا يراقب المحللون نمو المخزون الأسرع من المبيعات إنذاراً مبكراً.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Believing the cost formula tracks physical goods. It allocates costs; the warehouse can ship any carton it likes.', 'الاعتقاد بأن صيغة التكلفة تتتبع البضاعة مادياً. إنها توزع التكاليف؛ وللمستودع أن يشحن أي كرتونة يشاء.'),
    Bi('Comparing margins across companies on different cost formulas without adjustment, especially in inflationary periods.', 'مقارنة الهوامش بين شركات على صيغ تكلفة مختلفة دون تعديل، خاصة في فترات التضخم.'),
    Bi('Letting slow-moving stock sit at cost. The lower-of-cost-and-NRV test is continuous, not a year-end ritual.', 'ترك البضاعة بطيئة الحركة بالتكلفة. اختبار الأقل من التكلفة وصافي القيمة القابلة للتحقق مستمر، لا طقساً لنهاية السنة.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IAS 2',
      note: Bi('Inventories: cost composition (§10–18), FIFO/weighted average (§25–27), LIFO prohibition, and the NRV write-down (§28–33).', 'المخزون: مكونات التكلفة (الفقرات 10–18)، وصيغتا FIFO والمتوسط المرجح (25–27)، وحظر LIFO، وتخفيض صافي القيمة القابلة للتحقق (28–33).'),
      segments: [
        KBStandardSegment('IAS 2', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-2-inventories/'),
      ],
    ),
    KBStandardRef(
      standard: 'IPSAS 12',
      note: Bi('The public-sector mirror, extended for inventories held for distribution at no charge (measured at the lower of cost and current replacement cost).', 'المرآة في القطاع العام، موسعةً للمخزون المحتفظ به للتوزيع بلا مقابل (يقاس بالأقل من التكلفة وتكلفة الإحلال الجارية).'),
      segments: [
        KBStandardSegment('IPSAS 12', href: 'https://www.ipsasb.org/standards-pronouncements', viaIndex: true),
      ],
    ),
  ],
  relatedTerms: [
    'Inventory',
    'Cost of Goods Sold (COGS)',
    'FIFO (First-In, First-Out)',
    'Weighted Average Cost Method',
  ],
  relatedModules: [
    KBRelatedModule('/education/financial-statements', Bi('Module: Understanding Financial Statements', 'الوحدة: فهم القوائم المالية')),
  ],
  relatedArticles: [
    'balance-sheet',
    'working-capital',
    'income-statement',
    'cost-accounting',
  ],
  references: [
    'IFRS Foundation. (2003). IAS 2 Inventories. IFRS Foundation.',
    'Kieso, D. E., Weygandt, J. J., & Warfield, T. D. (2020). Intermediate accounting: IFRS edition (4th ed.). Wiley.',
    'International Public Sector Accounting Standards Board. (2001). IPSAS 12: Inventories. IFAC.',
  ],
  keywords: [
    'inventory',
    'FIFO',
    'weighted average',
    'COGS',
    'NRV',
    'write-down',
    'مخزون',
    'الوارد أولاً',
    'متوسط مرجح',
    'تكلفة البضاعة المباعة',
  ],
);
