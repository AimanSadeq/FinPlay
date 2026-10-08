// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/break-even-analysis.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbBreakEvenAnalysis = KBArticle(
  id: 'break-even-analysis',
  title: Bi('Break-Even and Cost-Volume-Profit Analysis', 'تحليل التعادل والعلاقة بين التكلفة والحجم والربح'),
  category: 'financial-analysis',
  level: KBLevel.foundation,
  readingMinutes: 6,
  summary: Bi('Contribution margin as the engine of profit, the break-even point in units and revenue, margin of safety, operating leverage, and the assumptions that limit the model.', 'هامش المساهمة محركاً للربح، ونقطة التعادل بالوحدات وبالإيراد، وهامش الأمان، والرافعة التشغيلية، والافتراضات التي تحد النموذج.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('Cost-volume-profit analysis starts from one classification: costs that vary with activity (materials, sales commissions, per-delegate catering) versus costs that are fixed within the relevant range (rent, salaries, platform licenses). Each unit sold contributes its price minus its variable cost toward covering the fixed costs; that difference is the contribution margin. Profit is born at the moment cumulative contribution covers the fixed block, and that moment is the break-even point.', 'يبدأ تحليل التكلفة والحجم والربح من تصنيف واحد: تكاليف تتغير مع النشاط (المواد، وعمولات البيع، والضيافة لكل متدرب) مقابل تكاليف ثابتة ضمن المدى الملائم (الإيجار، والرواتب، وتراخيص المنصات). كل وحدة تباع تسهم بسعرها ناقص تكلفتها المتغيرة في تغطية التكاليف الثابتة؛ وهذا الفرق هو هامش المساهمة. ويولد الربح لحظة تغطي المساهمةُ المتراكمة الكتلةَ الثابتة، وتلك اللحظة هي نقطة التعادل.'),
        Bi('The model answers practical questions fast: how many units must we sell to justify this fixed investment? What happens to profit if volume falls 15%? Should we swap a fixed salary for a variable commission? Its speed is exactly why professionals must also know its assumptions, which the last section states plainly.', 'يجيب النموذج عن أسئلة عملية بسرعة: كم وحدة يجب أن نبيع لتبرير هذا الاستثمار الثابت؟ وماذا يحدث للربح إذا هبط الحجم 15%؟ وهل نستبدل عمولة متغيرة براتب ثابت؟ وسرعته هي بالضبط ما يوجب على المهنيين معرفة افتراضاته أيضاً، والتي يذكرها القسم الأخير بصراحة.'),
      ],
      formulas: [
        KBFormula('Break-even (units) = Fixed costs ÷ (Price − Variable cost per unit)', caption: Bi('The denominator is the unit contribution margin.', 'المقام هو هامش المساهمة للوحدة.')),
        KBFormula('Break-even (revenue) = Fixed costs ÷ Contribution margin ratio', caption: Bi('CM ratio = contribution margin ÷ price; use this form for multi-product or service businesses.', 'نسبة هامش المساهمة = هامش المساهمة ÷ السعر؛ وتستخدم هذه الصيغة للأعمال متعددة المنتجات أو الخدمية.')),
      ],
    ),
    KBSection(
      heading: Bi('Worked example', 'مثال محلول'),
      paragraphs: [
        Bi('A training provider prices a public course seat at SAR 2,500. Variable cost per delegate (materials, catering, platform fee) is SAR 700, so unit contribution is SAR 1,800 and the CM ratio is 72%. Fixed costs of the program (trainer fees, venue, marketing) are SAR 54,000. Break-even = 54,000 ÷ 1,800 = 30 delegates. A target profit of SAR 27,000 needs (54,000 + 27,000) ÷ 1,800 = 45 delegates. If enrollment is running at 40, the margin of safety is (40 − 30) ÷ 40 = 25%: sales can fall a quarter before losses begin. Each delegate above 30 drops SAR 1,800 straight to profit, which is why late marginal enrollments are so valuable.', 'مزود تدريب يسعر مقعد الدورة العامة بـ 2,500 ريال. التكلفة المتغيرة للمتدرب (مواد وضيافة ورسوم منصة) 700 ريال، فمساهمة الوحدة 1,800 ريال ونسبة هامش المساهمة 72%. والتكاليف الثابتة للبرنامج (أتعاب المدرب والقاعة والتسويق) 54,000 ريال. التعادل = 54,000 ÷ 1,800 = 30 متدرباً. وربح مستهدف قدره 27,000 ريال يتطلب (54,000 + 27,000) ÷ 1,800 = 45 متدرباً. وإذا كان التسجيل عند 40 فهامش الأمان = (40 − 30) ÷ 40 = 25%: يمكن أن تهبط المبيعات ربعها قبل بدء الخسائر. وكل متدرب فوق الثلاثين ينزل بـ 1,800 ريال مباشرة إلى الربح، ولهذا فإن التسجيلات الحدية المتأخرة ثمينة إلى هذا الحد.'),
      ],
    ),
    KBSection(
      heading: Bi('Operating leverage: the structure of risk', 'الرافعة التشغيلية: بنية المخاطر'),
      paragraphs: [
        Bi('Two businesses with the same profit can carry very different volume risk. A cost structure heavy in fixed costs has high operating leverage: past break-even, profit grows fast, but below it, losses deepen just as fast. The degree of operating leverage (contribution margin divided by operating profit) measures the multiplier: DOL of 3 means a 10% change in volume moves operating profit about 30%, in either direction. Decisions that convert variable costs into fixed ones (buying instead of renting, hiring instead of outsourcing, building a platform instead of licensing one) are leverage decisions, not just cost decisions, and deserve a volume-risk discussion every time.', 'قد يحمل عملان بالربح نفسه مخاطر حجم مختلفة جداً. فهيكل التكاليف الثقيل بالثابت ذو رافعة تشغيلية عالية: بعد التعادل ينمو الربح سريعاً، ودونه تتعمق الخسائر بالسرعة نفسها. ودرجة الرافعة التشغيلية (هامش المساهمة مقسوماً على الربح التشغيلي) تقيس المضاعف: درجة 3 تعني أن تغيراً 10% في الحجم يحرك الربح التشغيلي نحو 30%، في الاتجاهين. والقرارات التي تحول تكاليف متغيرة إلى ثابتة (الشراء بدل الاستئجار، والتوظيف بدل الإسناد الخارجي، وبناء منصة بدل ترخيصها) قرارات رافعة لا قرارات تكلفة فحسب، وتستحق نقاش مخاطر الحجم في كل مرة.'),
      ],
      formulas: [
        KBFormula('DOL = Contribution margin ÷ Operating profit', caption: Bi('Degree of operating leverage at the current volume.', 'درجة الرافعة التشغيلية عند الحجم الحالي.')),
      ],
    ),
    KBSection(
      heading: Bi('The assumptions, stated honestly', 'الافتراضات بصراحة'),
      paragraphs: [
        Bi('The textbook model assumes a constant price, a constant variable cost per unit, fixed costs genuinely fixed within the relevant range, a constant sales mix in multi-product settings, and volume as the only cost driver. Every assumption bends in practice: prices move with discounts, unit costs move with scale, "fixed" costs step upward when capacity is added, and mix shifts constantly. The professional response is not to abandon the model but to use it within the range where the assumptions roughly hold, and to re-run it whenever a step change (new venue, new hire, new pricing) moves the structure. The Break-Even tool in this platform exists precisely to make that re-running effortless.', 'يفترض النموذج المدرسي سعراً ثابتاً، وتكلفة متغيرة ثابتة للوحدة، وتكاليف ثابتة ثابتة فعلاً ضمن المدى الملائم، ومزيج مبيعات ثابتاً في تعدد المنتجات، والحجم محركاً وحيداً للتكلفة. وكل افتراض ينحني عملياً: فالأسعار تتحرك بالخصومات، وتكاليف الوحدة تتحرك بالحجم، والتكاليف «الثابتة» تقفز درجات عند إضافة طاقة، والمزيج يتبدل باستمرار. والاستجابة المهنية ليست هجر النموذج بل استخدامه داخل المدى الذي تصمد فيه الافتراضات تقريباً، وإعادة تشغيله كلما حرك تغيرٌ درجيٌّ (قاعة جديدة، تعيين جديد، تسعير جديد) البنيةَ. وأداة التعادل في هذه المنصة وُجدت بالضبط لجعل إعادة التشغيل تلك بلا عناء.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Classifying costs by name instead of behavior: "salaries" can be fixed (permanent staff) or variable (per-day trainers) in the same organization.', 'تصنيف التكاليف بالاسم لا بالسلوك: فقد تكون «الرواتب» ثابتة (موظفون دائمون) أو متغيرة (مدربون باليوم) في المنظمة نفسها.'),
    Bi('Using average total cost per unit in decisions. Only the variable cost is incremental; averaging the fixed block into unit cost causes bad pricing and bad drop/keep decisions.', 'استخدام متوسط التكلفة الكلية للوحدة في القرارات. المتغيرة وحدها إضافية؛ وتحميل الكتلة الثابتة على الوحدة يفسد التسعير وقرارات الإبقاء أو الإلغاء.'),
    Bi('Reading the break-even point as a target. It is a floor; businesses that plan "around break-even" have planned to earn nothing for their risk.', 'قراءة نقطة التعادل هدفاً. إنها أرضية؛ ومن يخطط «حول التعادل» فقد خطط ألا يكسب شيئاً لقاء مخاطرته.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IAS 2 §12–14',
      note: Bi('The fixed/variable distinction appears in IFRS itself: production overheads are allocated to inventory as fixed or variable, with fixed overheads absorbed at normal capacity.', 'يظهر تمييز الثابت والمتغير في المعايير ذاتها: تُحمَّل تكاليف الإنتاج غير المباشرة على المخزون ثابتةً أو متغيرة، وتُستوعب الثابتة عند الطاقة العادية.'),
      segments: [
        KBStandardSegment('IAS 2', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-2-inventories/'),
        KBStandardSegment(' §12–14'),
      ],
    ),
  ],
  relatedTerms: [
    'Break-Even Point',
    'Contribution Margin',
    'Fixed Costs',
    'Variable Costs',
  ],
  relatedModules: [
    KBRelatedModule('/education/break-even', Bi('Tool: Break-Even Analysis (interactive calculators)', 'الأداة: تحليل التعادل (حاسبات تفاعلية)')),
  ],
  relatedArticles: [
    'income-statement',
    'budgeting-variance',
    'cost-accounting',
  ],
  references: [
    'Drury, C. (2021). Management and cost accounting (11th ed.). Cengage.',
    'Horngren, C. T., Datar, S. M., & Rajan, M. V. (2021). Cost accounting: A managerial emphasis (17th ed.). Pearson.',
    'IFRS Foundation. (2003). IAS 2 Inventories. IFRS Foundation.',
  ],
  keywords: [
    'break-even',
    'CVP',
    'contribution margin',
    'fixed costs',
    'variable costs',
    'operating leverage',
    'تعادل',
    'هامش المساهمة',
    'تكاليف ثابتة',
    'رافعة تشغيلية',
  ],
);
