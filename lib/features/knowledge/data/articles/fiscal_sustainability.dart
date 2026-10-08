// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/fiscal-sustainability.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbFiscalSustainability = KBArticle(
  id: 'fiscal-sustainability',
  title: Bi('Fiscal Rules and Debt Sustainability', 'القواعد المالية واستدامة الدين'),
  category: 'public-sector',
  level: KBLevel.advanced,
  readingMinutes: 8,
  summary: Bi('What makes government debt sustainable, the primary balance and the growth-adjusted interest rate that decide it, the fiscal rules governments adopt to bind themselves, and a worked debt-path calculation with the oil-revenue twist.', 'ما الذي يجعل الدين الحكومي مستداماً، والرصيد الأولي ومعدل الفائدة المعدل بالنمو اللذان يقرران ذلك، والقواعد المالية التي تتبناها الحكومات لتقييد نفسها، وحساب محلول لمسار الدين مع خصوصية الإيراد النفطي.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('A government is not a household and does not have to repay its debt, because it can refinance indefinitely as long as lenders keep lending. What it cannot do is let debt grow faster than the economy forever, because at some point the interest bill crowds out everything else the budget is meant to fund. Debt sustainability is therefore not a question of level but of trajectory: is the ratio of debt to GDP heading somewhere the state can live with, under assumptions that are honest? A country with debt at 90% of GDP and a credible downward path is in better shape than one at 40% and rising fast on borrowed optimism. The whole analysis reduces to a race between two numbers: the interest rate the government pays and the growth rate of the economy that services it.', 'الحكومة ليست أسرة ولا يلزمها سداد دينها، لأنها تستطيع إعادة التمويل بلا نهاية ما دام المقرضون يقرضون. لكن ما لا تستطيعه أن تدع الدين ينمو أسرع من الاقتصاد إلى الأبد، لأن فاتورة الفائدة تزاحم عند حد ما كل ما يفترض أن تموله الموازنة. فاستدامة الدين إذن ليست مسألة مستوى بل مسار: هل تتجه نسبة الدين إلى الناتج المحلي وجهةً تحتملها الدولة، بافتراضات أمينة؟ فبلدٌ دينه 90% من الناتج ومساره الهابط موثوق أفضل حالاً من بلد عند 40% ويرتفع سريعاً على تفاؤل مقترض. ويختزل التحليل كله في سباق بين رقمين: معدل الفائدة الذي تدفعه الحكومة ومعدل نمو الاقتصاد الذي يخدمه.'),
      ],
    ),
    KBSection(
      heading: Bi('The formal treatment: the debt dynamics equation', 'المعالجة النظرية: معادلة ديناميكيات الدين'),
      paragraphs: [
        Bi('Start with the primary balance, which is revenue minus expenditure excluding interest. It measures what the budget does before the cost of past borrowing, and it is the only part current policy controls. Debt as a share of GDP then moves according to a simple relationship: it rises by the interest paid on existing debt, falls by the growth of the denominator, and moves by the primary balance. When the nominal interest rate exceeds nominal growth, the ratio climbs on its own and a primary surplus is needed just to hold it steady; when growth exceeds the interest rate, an economy can run modest primary deficits and still see the ratio fall. That single comparison, often written as r minus g, explains most of what happens to public debt over decades. Governments that want to bind themselves adopt fiscal rules of four broad kinds: debt rules capping the stock, deficit or balanced-budget rules capping the flow, expenditure rules capping spending growth, and revenue rules governing windfalls. Rules work when they carry escape clauses for genuine shocks and an independent body to verify compliance, and fail when they are either so rigid that they are abandoned in the first recession or so loose that they bind nothing.', 'ابدأ بالرصيد الأولي، وهو الإيراد ناقص الإنفاق باستثناء الفائدة. فهو يقيس ما تفعله الموازنة قبل كلفة الاقتراض الماضي، وهو الجزء الوحيد الذي تتحكم فيه السياسة الحالية. ثم يتحرك الدين كنسبة من الناتج وفق علاقة بسيطة: يرتفع بالفائدة المدفوعة على الدين القائم، وينخفض بنمو المقام، ويتحرك بالرصيد الأولي. فحين يتجاوز معدل الفائدة الاسمي النموَّ الاسمي تتسلق النسبة من تلقاء نفسها ويلزم فائض أولي لمجرد تثبيتها؛ وحين يتجاوز النمو معدلَ الفائدة يستطيع اقتصادٌ إدارة عجوزات أولية متواضعة وتظل النسبة تهبط. وتلك المقارنة الواحدة، وتُكتب غالباً r ناقص g، تفسر معظم ما يجري للدين العام عبر العقود. والحكومات الراغبة في تقييد نفسها تتبنى قواعد مالية من أربعة أنواع عامة: قواعد دين تحد الرصيد، وقواعد عجز أو توازن تحد التدفق، وقواعد إنفاق تحد نمو الصرف، وقواعد إيراد تحكم المكاسب المفاجئة. وتنجح القواعد حين تحمل بنود خروج للصدمات الحقيقية وجهةً مستقلة تتحقق من الالتزام، وتفشل حين تكون إما جامدة فتُهجر في أول ركود، وإما فضفاضة فلا تقيّد شيئاً.'),
      ],
      formulas: [
        KBFormula('Δ(Debt ÷ GDP) = [(r − g) ÷ (1 + g)] × (Debt ÷ GDP)ₜ₋₁ − Primary balance ÷ GDP', caption: Bi('The debt dynamics equation: r is the nominal effective interest rate, g nominal GDP growth.', 'معادلة ديناميكيات الدين: r معدل الفائدة الفعلي الاسمي، وg نمو الناتج المحلي الاسمي.')),
        KBFormula('Debt-stabilizing primary balance ÷ GDP = [(r − g) ÷ (1 + g)] × (Debt ÷ GDP)', caption: Bi('The primary surplus required simply to hold the ratio where it is.', 'الفائض الأولي المطلوب لمجرد إبقاء النسبة حيث هي.')),
      ],
    ),
    KBSection(
      heading: Bi('Worked example: a debt path over five years', 'مثال محلول: مسار دين على خمس سنوات'),
      paragraphs: [
        Bi('A government carries debt at 30% of GDP, pays an effective nominal interest rate of 5%, and expects nominal GDP growth of 7%. Because growth exceeds the interest rate, the ratio falls on its own: the automatic change is [(0.05 − 0.07) ÷ 1.07] × 30% = −0.56 percentage points a year. The debt-stabilizing primary balance is therefore negative, about −0.56% of GDP, meaning the state can run a small primary deficit and still hold debt at 30%. Now stress it. Suppose growth slows to 2% while the interest rate rises to 6% as global rates climb: the automatic change becomes [(0.06 − 0.02) ÷ 1.02] × 30% = +1.18 points a year, and holding the ratio flat now requires a primary surplus of 1.2% of GDP rather than a deficit. That is a swing of nearly two percentage points of GDP in required fiscal effort, caused by nothing the government did. Five years of the weak scenario with a 2% primary deficit each year takes debt from 30% to roughly 47% of GDP, because the automatic change compounds on a rising stock rather than staying at 1.18 points. The lesson is that a comfortable ratio is a statement about assumptions, and the sensitivity of the path matters more than its starting point.', 'حكومةٌ دينها 30% من الناتج، وتدفع معدل فائدة اسمياً فعلياً قدره 5%، وتتوقع نمواً اسمياً للناتج قدره 7%. ولأن النمو يفوق معدل الفائدة تهبط النسبة من تلقاء نفسها: فالتغير التلقائي [(0.05 − 0.07) ÷ 1.07] × 30% = −0.56 نقطة مئوية سنوياً. فالرصيد الأولي المثبِّت للدين سالب إذن، نحو −0.56% من الناتج، أي أن الدولة تستطيع إدارة عجز أولي صغير ويظل الدين عند 30%. والآن ضع ضغطاً. افترض تباطؤ النمو إلى 2% مع ارتفاع معدل الفائدة إلى 6% مع صعود المعدلات العالمية: يصير التغير التلقائي [(0.06 − 0.02) ÷ 1.02] × 30% = +1.18 نقطة سنوياً، ويتطلب تثبيت النسبة الآن فائضاً أولياً قدره 1.2% من الناتج بدل عجز. وذلك تأرجح يقارب نقطتين مئويتين من الناتج في الجهد المالي المطلوب، لم تسببه أي خطوة حكومية. وخمس سنوات من السيناريو الضعيف بعجز أولي 2% سنوياً ترفع الدين من 30% إلى نحو 47% من الناتج، لأن التغير التلقائي يتراكم على رصيد متصاعد ولا يبقى عند 1.18 نقطة. والدرس أن النسبة المريحة قولٌ عن الافتراضات، وأن حساسية المسار أهم من نقطة انطلاقه.'),
      ],
    ),
    KBSection(
      heading: Bi('The resource-exporter problem', 'مشكلة الدولة المصدرة للموارد'),
      paragraphs: [
        Bi('For an oil exporter the standard analysis needs a second layer, because a large share of revenue comes from selling a finite asset rather than from taxing income. Two adjustments follow. The first is the non-oil primary balance, measured against non-oil GDP, which strips out the commodity cycle and shows what the underlying fiscal position looks like if the price assumption is wrong; it is usually a far less comfortable number than the headline balance. The second is intergenerational: extracting oil converts an asset under the ground into revenue above it, so a budget financed from depletion is consuming capital, not earning income, unless part of the proceeds is saved in a sovereign fund. This is the analytical backbone of the Saudi fiscal debate, where the Fiscal Sustainability Program (formerly the Fiscal Balance Program, concluded in February 2025 with its mandate absorbed into the Ministry of Finance and related entities), the Public Investment Fund and the National Debt Management Center each addressed a different piece: the flow, the savings, and the liability side. A public finance professional reading a Gulf budget should look first at the non-oil balance and the assumed oil price, because those two numbers determine whether the published deficit means anything at all.', 'في الدولة المصدرة للنفط يحتاج التحليل المعياري طبقة ثانية، لأن حصة كبيرة من الإيراد تأتي من بيع أصل ناضب لا من فرض ضريبة على الدخل. ويتبع ذلك تعديلان. الأول الرصيد الأولي غير النفطي، مقيساً إلى الناتج غير النفطي، وهو يجرد دورة السلعة ويظهر ما يبدو عليه الوضع المالي الأساسي إن كان افتراض السعر خاطئاً؛ وهو رقم أقل راحة بكثير من الرصيد المعلن عادةً. والثاني بين الأجيال: فاستخراج النفط يحول أصلاً تحت الأرض إلى إيراد فوقها، فالموازنة الممولة من النضوب تستهلك رأس مال لا تكسب دخلاً، ما لم يُدَّخر جزء من المتحصلات في صندوق سيادي. وهذا هو العمود الفقري التحليلي للنقاش المالي السعودي، حيث عالج كلٌّ من برنامج الاستدامة المالية (وكان يسمى برنامج تحقيق التوازن المالي، واختُتم في فبراير 2025 وانتقلت مهامه إلى وزارة المالية والجهات ذات العلاقة) وصندوق الاستثمارات العامة والمركز الوطني لإدارة الدين قطعةً مختلفة: التدفق والادخار وجانب الالتزامات. وعلى مهني المالية العامة الذي يقرأ موازنة خليجية أن ينظر أولاً إلى الرصيد غير النفطي وسعر النفط المفترض، فهذان الرقمان يحددان هل للعجز المنشور أي معنى أصلاً.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Judging sustainability by the debt level alone. The trajectory, the maturity profile and the currency of the debt matter more than the headline percentage.', 'الحكم على الاستدامة بمستوى الدين وحده. فالمسار وهيكل الآجال وعملة الدين أهم من النسبة المعلنة.'),
    Bi('Reading a headline deficit in an oil economy without the non-oil balance: a high oil price can hide a structural gap entirely.', 'قراءة عجز معلن في اقتصاد نفطي دون الرصيد غير النفطي: فسعر نفط مرتفع قد يخفي فجوة هيكلية كاملة.'),
    Bi('Forgetting off-budget obligations. Guarantees, public-private partnership commitments and state-enterprise debt are claims on the same taxpayer as the recorded debt.', 'نسيان الالتزامات خارج الموازنة. فالضمانات وتعهدات الشراكات مع القطاع الخاص وديون الشركات الحكومية مطالبات على دافع الضرائب نفسه الذي يتحمل الدين المسجل.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IPSAS 1 · IPSAS 22',
      note: Bi('Presentation and disclosure of general government sector information: the reporting boundary a debt analysis depends on.', 'العرض والإفصاح عن معلومات قطاع الحكومة العامة: حدود التقرير التي يعتمد عليها تحليل الدين.'),
      segments: [
        KBStandardSegment('IPSAS 1', href: 'https://www.ipsasb.org/standards-pronouncements', viaIndex: true),
        KBStandardSegment(' · '),
        KBStandardSegment('IPSAS 22', href: 'https://www.ipsasb.org/standards-pronouncements', viaIndex: true),
      ],
    ),
    KBStandardRef(
      standard: 'PEFA framework',
      note: Bi('Public expenditure and financial accountability: the assessment framework covering fiscal strategy, debt management and reporting.', 'الإنفاق العام والمساءلة المالية: إطار التقييم الذي يغطي الاستراتيجية المالية وإدارة الدين والتقرير.'),
      segments: [
        KBStandardSegment('PEFA', href: 'https://www.pefa.org/resources/pefa-2016-framework'),
        KBStandardSegment(' framework'),
      ],
    ),
  ],
  relatedTerms: [
    'Long-term Debt',
    'Debt Ratio',
    'Interest Expense',
    'Liquidity',
    'Free Cash Flow',
  ],
  relatedModules: [
    KBRelatedModule('/government-education/budgeting', Bi('Module: Government Budgeting', 'الوحدة: الموازنة الحكومية')),
    KBRelatedModule('/government-education/financial-decisions', Bi('Module: Government Financial Decisions', 'الوحدة: القرارات المالية الحكومية')),
  ],
  relatedArticles: [
    'government-budget-cycle',
    'public-private-partnerships',
    'ifrs-vs-ipsas',
    'bonds-and-sukuk',
    'zakat-and-tax',
    'government-cash-management',
    'public-debt-management',
  ],
  references: [
    'International Monetary Fund. (2022). Staff guidance note on the sovereign risk and debt sustainability framework for market access countries. IMF.',
    'Eyraud, L., Debrun, X., Hodge, A., Lledó, V., & Pattillo, C. (2018). Second-generation fiscal rules: Balancing simplicity, flexibility and enforceability (IMF Staff Discussion Note 18/04). IMF.',
    'International Monetary Fund. (2015). The commodity price cycle and fiscal policy in resource-rich countries. IMF.',
    'World Bank. (2021). Debt transparency and management in developing economies. World Bank Group.',
  ],
  keywords: [
    'fiscal sustainability',
    'debt to GDP',
    'primary balance',
    'fiscal rules',
    'debt dynamics',
    'non-oil balance',
    'sovereign debt',
    'استدامة الدين',
    'الرصيد الأولي',
    'القواعد المالية',
    'الرصيد غير النفطي',
  ],
);
