// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/employee-benefits.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbEmployeeBenefits = KBArticle(
  id: 'employee-benefits',
  title: Bi('Employee Benefits and End-of-Service Obligations', 'منافع الموظفين والتزامات نهاية الخدمة'),
  category: 'accounting-foundations',
  level: KBLevel.advanced,
  readingMinutes: 8,
  summary: Bi('Why a promise made to employees today is a liability today, the difference between defined contribution and defined benefit plans, how the projected unit credit method values an end-of-service obligation, and a worked Saudi example.', 'لماذا يكون الوعد المقطوع للموظفين اليوم التزاماً اليوم، والفرق بين خطط المساهمة المحددة والمنافع المحددة، وكيف تقيس طريقة وحدة الائتمان المتوقعة التزام نهاية الخدمة، ومثال سعودي محلول.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('Employee benefits are every form of consideration given in exchange for service: salaries and wages, paid leave, bonuses, medical cover, and the long-dated promises such as pensions and end-of-service awards. The short-term ones are easy, because the service and the payment sit in the same period. The difficulty is the long-dated promise. When a company tells an employee that after ten years of service it will pay a lump sum, it has taken on an obligation the moment the service begins to accrue, not on the day the employee leaves. IAS 19 exists to put that obligation on the balance sheet as it is earned, so that the cost of employing people appears in the years they actually worked rather than landing as a shock in the year they depart.', 'منافع الموظفين هي كل صور المقابل الممنوح لقاء الخدمة: الرواتب والأجور والإجازات المدفوعة والمكافآت والتغطية الطبية، والوعود بعيدة الأجل كالتقاعد ومكافآت نهاية الخدمة. والقصيرة الأجل منها سهلة، لأن الخدمة والدفع يقعان في الفترة نفسها. والصعوبة في الوعد بعيد الأجل. فحين تخبر شركةٌ موظفاً بأنها ستدفع مبلغاً مقطوعاً بعد عشر سنوات خدمة، فقد تحملت التزاماً لحظة بدء تراكم الخدمة لا يوم مغادرة الموظف. ووُجد IAS 19 ليضع ذلك الالتزام في الميزانية بينما يُكتسب، فتظهر كلفة توظيف الناس في السنوات التي عملوا فيها فعلاً بدل أن تهبط صدمةً في سنة رحيلهم.'),
      ],
    ),
    KBSection(
      heading: Bi('The formal treatment: two plan types, one crucial difference', 'المعالجة النظرية: نوعا خطط وفرق حاسم واحد'),
      paragraphs: [
        Bi('A defined contribution plan is simple: the employer pays a fixed amount into a fund and the obligation ends there. The expense is the contribution, and all investment and longevity risk sits with the employee. Saudi social insurance contributions to GOSI work this way from the employer’s accounting perspective. A defined benefit plan is everything else, meaning any arrangement where the employer has promised an outcome rather than an input. Here the employer carries the risk that people live longer, that salaries rise faster than assumed, or that the discount rate falls, and the accounting becomes an actuarial exercise. The obligation is measured using the projected unit credit method: estimate the ultimate benefit each employee will receive, project the final salary it will be based on, attribute a slice of that benefit to each year of service, and discount the whole stream to present value using a rate drawn from high-quality corporate bonds of matching duration, or, where no deep market in such bonds exists in that currency, from government bonds; there is no deep SAR corporate bond market, so Saudi valuations are built off sovereign yields. The net balance sheet figure is the present value of the obligation less the fair value of any plan assets, and for the many unfunded schemes in the Gulf there are no plan assets at all, so the full obligation is a liability.', 'خطة المساهمة المحددة بسيطة: يدفع صاحب العمل مبلغاً ثابتاً في صندوق وينتهي الالتزام عند ذلك. والمصروف هو المساهمة، وتقع مخاطر الاستثمار وطول العمر كلها على الموظف. وهكذا تعمل اشتراكات التأمينات الاجتماعية السعودية لدى المؤسسة العامة للتأمينات الاجتماعية من منظور محاسبة صاحب العمل. أما خطة المنافع المحددة فهي كل ما عدا ذلك، أي أي ترتيب وعد فيه صاحب العمل بنتيجة لا بمُدخل. وهنا يحمل صاحب العمل مخاطر أن يعيش الناس أطول، أو أن ترتفع الرواتب أسرع من المفترض، أو أن يهبط معدل الخصم، فتصير المحاسبة تمريناً اكتوارياً. ويُقاس الالتزام بطريقة وحدة الائتمان المتوقعة: قدّر المنفعة النهائية التي سيتلقاها كل موظف، وتوقع الراتب الأخير الذي ستُبنى عليه، ونسب شريحة من تلك المنفعة إلى كل سنة خدمة، واخصم التيار كله إلى قيمته الحالية بمعدل مأخوذ من سندات شركات عالية الجودة مطابقة المدة، أو من السندات الحكومية حيث لا يوجد سوق عميق لتلك السندات بتلك العملة؛ ولا يوجد سوق عميق لسندات الشركات بالريال، فتُبنى التقييمات السعودية على عوائد السندات السيادية. والرقم الصافي في الميزانية هو القيمة الحالية للالتزام ناقص القيمة العادلة لأي أصول خطة، وفي الخطط غير الممولة الكثيرة في الخليج لا توجد أصول خطة إطلاقاً، فيكون الالتزام كاملاً مطلوباً.'),
      ],
      formulas: [
        KBFormula('Net defined benefit liability = Present value of obligation − Fair value of plan assets', caption: Bi('The balance sheet figure; unfunded schemes carry the obligation in full.', 'رقم الميزانية؛ والخطط غير الممولة تحمل الالتزام كاملاً.')),
        KBFormula('Profit or loss: Current service cost + Net interest    ·    Other comprehensive income: Actuarial remeasurements', caption: Bi('The split that keeps assumption changes out of earnings, permanently.', 'القسمة التي تُبقي تغيرات الافتراضات خارج الأرباح، بصفة دائمة.')),
      ],
    ),
    KBSection(
      heading: Bi('Worked example: a Saudi end-of-service benefit', 'مثال محلول: مكافأة نهاية الخدمة السعودية'),
      paragraphs: [
        Bi('Saudi labour law grants an end-of-service award based on the final wage: broadly half a month’s wage for each of the first five years of service and a full month’s wage for each year thereafter, with reductions where the employee resigns rather than the contract ending otherwise. Because the benefit depends on final salary and length of service, it is a defined benefit plan under IAS 19, not a simple accrual, and Saudi companies engage actuaries for it. Take an employee currently earning SAR 10,000 a month with five years of service, expected to complete fifteen years before leaving. The projected final wage at 4% annual growth is roughly 10,000 × 1.04¹⁰ = SAR 14,800. The ultimate benefit is (5 × 0.5 + 10 × 1) × 14,800 = 12.5 months = SAR 185,000. Attributing that across fifteen years of service and recognizing the five already served gives an obligation before discounting of about 185,000 × 5 ÷ 15 = SAR 61,700, then discounted back ten years at, say, 5% to roughly SAR 37,900. Change the salary growth assumption to 6% or the discount rate to 4% and that figure moves by double digits in percentage terms, which is precisely why the actuarial assumptions are disclosed and why the sensitivity table beside them is worth reading.', 'يمنح نظام العمل السعودي مكافأة نهاية خدمة مبنية على الأجر الأخير: عموماً نصف شهر عن كل سنة من السنوات الخمس الأولى وشهر كامل عن كل سنة بعدها، مع تخفيضات حين يستقيل الموظف بدل انتهاء العقد بغير ذلك. ولأن المنفعة تعتمد على الراتب الأخير وطول الخدمة، فهي خطة منافع محددة وفق IAS 19 لا استحقاقاً بسيطاً، وتستعين الشركات السعودية بخبراء اكتواريين لها. خذ موظفاً يكسب حالياً عشرة آلاف ريال شهرياً بخدمة خمس سنوات، ويُتوقع أن يكمل خمس عشرة سنة قبل مغادرته. الأجر النهائي المتوقع بنمو سنوي 4% هو نحو 10,000 × 1.04¹⁰ = 14,800 ريال. والمنفعة النهائية (5 × 0.5 + 10 × 1) × 14,800 = 12.5 شهراً = 185,000 ريال. وتوزيع ذلك على خمس عشرة سنة خدمة والاعتراف بالخمس المنقضية يعطي التزاماً قبل الخصم قدره نحو 185,000 × 5 ÷ 15 = 61,700 ريال، ثم يُخصم عشر سنوات بمعدل 5% مثلاً إلى نحو 37,900 ريال. وغيّر افتراض نمو الراتب إلى 6% أو معدل الخصم إلى 4% فيتحرك ذلك الرقم بنسب مئوية من خانتين، ولهذا بالضبط يُفصح عن الافتراضات الاكتوارية ويستحق جدول الحساسية بجوارها القراءة.'),
      ],
    ),
    KBSection(
      heading: Bi('Where the volatility goes', 'إلى أين يذهب التقلب'),
      paragraphs: [
        Bi('IAS 19 splits the annual movement into three parts and sends them to two different places. Current service cost, the extra benefit earned this year, and net interest on the net liability both go to profit or loss, so the income statement carries a stable, predictable charge. Remeasurements, which are actuarial gains and losses from changed assumptions or experience, plus the return on plan assets above the discount rate, go to other comprehensive income and never recycle. That design is deliberate. It keeps earnings from swinging on bond yields, while still forcing the full economic movement onto the balance sheet through equity. The practical reading for an analyst is that the income statement understates how much a defined benefit promise can move, so the obligation table in the notes, not the payroll line, is where the exposure lives. In a fast-growing Saudi group hiring thousands of people, the end-of-service liability compounds quietly for years and then becomes one of the larger non-debt liabilities on the balance sheet.', 'يقسم IAS 19 الحركة السنوية ثلاثة أجزاء ويرسلها إلى موضعين مختلفين. فتكلفة الخدمة الحالية، أي المنفعة الإضافية المكتسبة هذه السنة، وصافي الفائدة على صافي الالتزام، يذهبان إلى الربح أو الخسارة، فتحمل قائمة الدخل عبئاً مستقراً يمكن التنبؤ به. أما إعادات القياس، وهي المكاسب والخسائر الاكتوارية من تغير الافتراضات أو الخبرة، إضافة إلى عائد أصول الخطة فوق معدل الخصم، فتذهب إلى الدخل الشامل الآخر ولا تُعاد أبداً. وذلك التصميم مقصود. فهو يمنع الأرباح من التأرجح مع عوائد السندات، مع إجبار الحركة الاقتصادية الكاملة على الظهور في الميزانية عبر حقوق الملكية. والقراءة العملية للمحلل أن قائمة الدخل تُقلل من مدى قابلية وعد المنافع المحددة للحركة، فجدول الالتزام في الإيضاحات، لا سطر الرواتب، هو موضع التعرض. وفي مجموعة سعودية سريعة النمو توظف الآلاف، يتراكم التزام نهاية الخدمة بهدوء سنوات ثم يصير من أكبر الالتزامات غير الدينية في الميزانية.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Treating end-of-service benefits as a simple accrual of months worked: the obligation depends on projected final salary and expected departure patterns, which is why it needs an actuary.', 'معاملة مكافأة نهاية الخدمة استحقاقاً بسيطاً بعدد الأشهر المخدومة: فالالتزام يعتمد على الراتب النهائي المتوقع وأنماط المغادرة المتوقعة، ولهذا يحتاج خبيراً اكتوارياً.'),
    Bi('Reading a fall in the obligation as good news. A lower balance often just means the discount rate rose, and the same movement reverses when yields fall.', 'قراءة انخفاض الالتزام خبراً ساراً. فالرصيد الأدنى يعني غالباً أن معدل الخصم ارتفع، وتنعكس الحركة نفسها حين تهبط العوائد.'),
    Bi('Ignoring an unfunded obligation because no cash has left. It is a claim on future cash exactly like debt, and rating agencies and lenders treat it that way.', 'تجاهل التزام غير ممول لأن أي نقد لم يخرج. فهو مطالبة على نقد مستقبلي تماماً كالدين، وهكذا تعامله وكالات التصنيف والمقرضون.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IAS 19',
      note: Bi('Employee benefits: defined contribution versus defined benefit, projected unit credit, and the profit/OCI split.', 'منافع الموظفين: المساهمة المحددة مقابل المنافع المحددة، ووحدة الائتمان المتوقعة، والقسمة بين الأرباح والدخل الشامل.'),
      segments: [
        KBStandardSegment('IAS 19', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-19-employee-benefits/'),
      ],
    ),
    KBStandardRef(
      standard: 'IAS 37',
      note: Bi('Provisions: the general obligation framework that termination and restructuring benefits interact with.', 'المخصصات: الإطار العام للالتزامات الذي تتفاعل معه منافع إنهاء الخدمة وإعادة الهيكلة.'),
      segments: [
        KBStandardSegment('IAS 37', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-37-provisions-contingent-liabilities-and-contingent-assets/'),
      ],
    ),
  ],
  relatedTerms: [
    'Pension Obligations',
    'Accrued Expenses',
    'Liabilities',
    'Accumulated Other Comprehensive Income (AOCI)',
    'Operating Expenses (SG&A)',
  ],
  relatedModules: [
    KBRelatedModule('/education/fundamentals', Bi('Module: Financial Management Primer', 'الوحدة: تمهيد الإدارة المالية')),
    KBRelatedModule('/education/financial-analysis', Bi('Module: Analysis of Financial Statements', 'الوحدة: تحليل القوائم المالية')),
  ],
  relatedArticles: [
    'provisions-contingencies',
    'equity-and-oci',
    'time-value-of-money',
    'balance-sheet',
    'accrual-accounting',
  ],
  references: [
    'IFRS Foundation. (1998). IAS 19 Employee Benefits. IFRS Foundation.',
    'Kieso, D. E., Weygandt, J. J., & Warfield, T. D. (2020). Intermediate accounting: IFRS edition (4th ed.). Wiley.',
    'Kingdom of Saudi Arabia. (2005, as amended). Labour law. Ministry of Human Resources and Social Development.',
  ],
  keywords: [
    'employee benefits',
    'IAS 19',
    'end of service',
    'EOSB',
    'defined benefit',
    'defined contribution',
    'projected unit credit',
    'actuarial',
    'GOSI',
    'منافع الموظفين',
    'نهاية الخدمة',
    'المنافع المحددة',
    'اكتواري',
  ],
);
