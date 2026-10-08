// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/revenue-recognition.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbRevenueRecognition = KBArticle(
  id: 'revenue-recognition',
  title: Bi('Revenue Recognition under IFRS 15', 'الاعتراف بالإيراد وفق المعيار IFRS 15'),
  category: 'accounting-foundations',
  level: KBLevel.intermediate,
  readingMinutes: 5,
  summary: Bi('The five-step model that decides when the top line exists: identifying the contract and its promises, pricing them, and recognizing revenue as control transfers, over time or at a point in time.', 'نموذج الخطوات الخمس الذي يقرر متى يوجد السطر الأول أصلاً: تحديد العقد ووعوده، وتسعيرها، والاعتراف بالإيراد مع انتقال السيطرة، عبر الزمن أو عند نقطة منه.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('Revenue is the largest number on most income statements and historically the most manipulated one, which is why a single global model now governs it. The core principle of IFRS 15 is simple to state: recognize revenue when (or as) the entity transfers control of promised goods or services to the customer, in the amount it expects to be entitled to. Everything else in the standard is machinery for applying that sentence to real contracts, which bundle goods with services, carry discounts and bonuses, and stretch over months or years.', 'الإيراد أكبر رقم في معظم قوائم الدخل، وتاريخياً أكثرها تعرضاً للتلاعب، ولهذا يحكمه اليوم نموذج عالمي واحد. المبدأ الجوهري في IFRS 15 سهل النطق: اعترف بالإيراد عندما (أو بينما) تنقل المنشأة السيطرة على السلع أو الخدمات الموعودة إلى العميل، وبالمبلغ الذي تتوقع أن تستحقه. وكل ما عدا ذلك في المعيار آلية لتطبيق هذه الجملة على عقود حقيقية تجمع السلع مع الخدمات، وتحمل خصومات وحوافز، وتمتد شهوراً أو سنين.'),
        Bi('Why control rather than cash or invoicing? Because cash timing is a financing matter (advances and credit terms change nothing about performance), and invoices are paperwork the seller controls. Control of the good or service is the economic event: the moment the customer can direct its use and obtain its benefits, the seller has performed.', 'لماذا السيطرة لا النقد ولا الفوترة؟ لأن توقيت النقد شأن تمويلي (الدفعات المقدمة وشروط الائتمان لا تغير شيئاً في الأداء)، والفواتير أوراق يتحكم بها البائع. السيطرة على السلعة أو الخدمة هي الحدث الاقتصادي: فاللحظة التي يستطيع فيها العميل توجيه استخدامها والانتفاع بها يكون البائع قد أدى.'),
      ],
    ),
    KBSection(
      heading: Bi('The five steps', 'الخطوات الخمس'),
      paragraphs: [
        Bi('Step 1: identify the contract with the customer (enforceable rights and obligations, commercial substance, collection probable). Step 2: identify the performance obligations, meaning each distinct promise; a good or service is distinct when the customer can benefit from it on its own and it is separately identifiable in the contract. Step 3: determine the transaction price, including estimates of variable consideration (rebates, bonuses, penalties), which are included only to the extent that it is highly probable that a significant reversal in cumulative revenue recognized will not occur. Step 4: allocate the transaction price to the performance obligations in proportion to their stand-alone selling prices. Step 5: recognize revenue when or as each obligation is satisfied: over time if the customer consumes the benefit as the work happens, if the work builds an asset the customer controls, or if the asset has no alternative use and payment for work to date is enforceable; otherwise at a point in time, when control passes.', 'الخطوة 1: تحديد العقد مع العميل (حقوق والتزامات واجبة النفاذ، وجوهر تجاري، وتحصيل مرجح). الخطوة 2: تحديد التزامات الأداء، أي كل وعد متميز؛ وتكون السلعة أو الخدمة متميزة إذا استطاع العميل الانتفاع بها وحدها وكانت قابلة للفصل في سياق العقد. الخطوة 3: تحديد سعر المعاملة، بما فيه تقديرات العوض المتغير (الحسومات والمكافآت والغرامات)، ولا تُدرج إلا بالقدر الذي يكون معه من المرجح بشدة ألا يقع انعكاس جوهري في الإيراد المتراكم المعترف به. الخطوة 4: توزيع سعر المعاملة على التزامات الأداء بنسبة أسعار بيعها المستقلة. الخطوة 5: الاعتراف بالإيراد عندما، أو بينما، يُستوفى كل التزام: عبر الزمن إذا كان العميل يستهلك المنفعة أثناء العمل، أو كان العمل يبني أصلاً يسيطر عليه العميل، أو كان الأصل بلا استخدام بديل مع حق نافذ في مقابل العمل المنجز؛ وإلا فعند نقطة زمنية ينتقل فيها السيطرة.'),
      ],
    ),
    KBSection(
      heading: Bi('Worked example: a bundled training contract', 'مثال محلول: عقد تدريب مجمع'),
      paragraphs: [
        Bi('A provider signs a SAR 300,000 contract covering a four-day training program (stand-alone price SAR 260,000) and twelve months of platform access (stand-alone price SAR 65,000). Stand-alone prices total 325,000, so the contract price is allocated pro rata: training 260 ÷ 325 × 300,000 = SAR 240,000; platform access 65 ÷ 325 × 300,000 = SAR 60,000. The training is satisfied over the four delivery days (revenue as delivered); the platform access is satisfied evenly over twelve months (SAR 5,000 per month). If the client paid the full 300,000 in advance, the unearned balance sits as a contract liability (deferred revenue) and is released as each obligation is performed. Cash: 300,000 on day one. Revenue in month one: 240,000 + 5,000. The difference is the discipline.', 'وقع مزود عقداً بـ 300,000 ريال يغطي برنامجاً تدريبياً من أربعة أيام (سعره المستقل 260,000 ريال) واشتراكاً في المنصة اثني عشر شهراً (سعره المستقل 65,000 ريال). مجموع الأسعار المستقلة 325,000، فيوزع سعر العقد بالتناسب: التدريب 260 ÷ 325 × 300,000 = 240,000 ريال؛ والمنصة 65 ÷ 325 × 300,000 = 60,000 ريال. يُستوفى التدريب عبر أيام التنفيذ الأربعة (إيراد مع التسليم)؛ ويُستوفى اشتراك المنصة بالتساوي على اثني عشر شهراً (5,000 ريال شهرياً). وإذا دفع العميل الـ 300,000 كاملة مقدماً، يبقى الرصيد غير المكتسب التزامَ عقدٍ (إيراداً مؤجلاً) يُحرر مع أداء كل التزام. النقد: 300,000 في اليوم الأول. الإيراد في الشهر الأول: 240,000 + 5,000. والفرق بينهما هو الانضباط كله.'),
      ],
    ),
    KBSection(
      heading: Bi('Where judgment concentrates', 'أين يتركز الاجتهاد'),
      paragraphs: [
        Bi('Three areas carry most of the audit attention. Variable consideration: bonuses, penalties, and usage-based fees are estimated into revenue before they are certain, under an explicit constraint. Principal versus agent: an entity that controls the good before transfer recognizes gross revenue; a broker recognizes only its commission, and the difference can be enormous for platforms and resellers. Over-time measurement: percentage-of-completion requires a defensible measure of progress (costs incurred, milestones, time elapsed), and biased progress estimates are the classic route to premature revenue. Readers of financial statements should look for the revenue disaggregation note and the contract balance note; movement in contract liabilities is a preview of future recognized revenue.', 'ثلاثة مواضع تستقطب معظم اهتمام المدققين. العوض المتغير: تُقدَّر المكافآت والغرامات ورسوم الاستخدام داخل الإيراد قبل تيقنها، تحت قيد صريح. الأصيل مقابل الوكيل: المنشأة التي تسيطر على السلعة قبل نقلها تعترف بالإيراد إجمالياً؛ والوسيط لا يعترف إلا بعمولته، والفرق قد يكون هائلاً للمنصات والموزعين. والقياس عبر الزمن: تتطلب نسبة الإنجاز مقياس تقدم يمكن الدفاع عنه (التكاليف المتكبدة، أو المراحل، أو الزمن المنقضي)، وتقديرات التقدم المنحازة هي الطريق الكلاسيكي إلى إيراد سابق لأوانه. وعلى قارئ القوائم أن يقصد إيضاح تفصيل الإيراد وإيضاح أرصدة العقود؛ فحركة التزامات العقود عرضٌ مسبق لإيراد سيُعترف به مستقبلاً.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Equating revenue with invoicing or with cash received. Control transfer is the test; both other events can lead or lag it.', 'مساواة الإيراد بالفوترة أو بالنقد المقبوض. انتقال السيطرة هو الاختبار؛ وكلا الحدثين الآخرين قد يسبقه أو يتأخر عنه.'),
    Bi('Recognizing the full price of a bundle on delivery of its first component instead of allocating to each performance obligation.', 'الاعتراف بسعر الحزمة كاملاً عند تسليم أول مكوناتها بدل توزيعه على كل التزام أداء.'),
    Bi('Reporting gross revenue while acting as an agent. The top line shrinks dramatically when the principal test is applied honestly.', 'عرض الإيراد إجمالياً والمنشأة وكيل. يتقلص السطر الأول تقلصاً كبيراً عندما يطبق اختبار الأصيل بأمانة.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IFRS 15',
      note: Bi('Revenue from Contracts with Customers: the five-step model, contract assets and liabilities, and the disaggregation disclosures.', 'الإيراد من العقود مع العملاء: نموذج الخطوات الخمس، وأصول والتزامات العقود، وإفصاحات التفصيل.'),
      segments: [
        KBStandardSegment('IFRS 15', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ifrs-15-revenue-from-contracts-with-customers/'),
      ],
    ),
    KBStandardRef(
      standard: 'IPSAS 47',
      note: Bi('The public-sector revenue standard, effective 1 January 2026 in place of IPSAS 23: an IFRS 15-style model where a binding arrangement carries performance obligations, and a separate model where it does not.', 'معيار الإيراد للقطاع العام، النافذ في 1 يناير 2026 بديلاً عن IPSAS 23: نموذج على نهج IFRS 15 حيث يحمل الترتيب الملزم التزامات أداء، ونموذج منفصل حيث لا يحملها.'),
      segments: [
        KBStandardSegment('IPSAS 47', href: 'https://www.ipsasb.org/publications/ipsas-47-revenue'),
      ],
    ),
  ],
  relatedTerms: [
    'Revenue Recognition',
    'Deferred Revenue',
  ],
  relatedModules: [
    KBRelatedModule('/education/financial-statements', Bi('Module: Understanding Financial Statements', 'الوحدة: فهم القوائم المالية')),
  ],
  relatedArticles: [
    'accrual-accounting',
    'income-statement',
    'provisions-contingencies',
    'government-grants',
    'earnings-quality',
  ],
  references: [
    'IFRS Foundation. (2014). IFRS 15 Revenue from contracts with customers. IFRS Foundation.',
    'Kieso, D. E., Weygandt, J. J., & Warfield, T. D. (2020). Intermediate accounting: IFRS edition (4th ed.). Wiley.',
    'Palepu, K. G., Healy, P. M., & Peek, E. (2019). Business analysis and valuation: IFRS edition (5th ed.). Cengage.',
  ],
  keywords: [
    'revenue',
    'IFRS 15',
    'five steps',
    'performance obligation',
    'contract liability',
    'principal agent',
    'إيراد',
    'التزام أداء',
    'إيراد مؤجل',
  ],
);
