// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/financial-ratios.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbFinancialRatios = KBArticle(
  id: 'financial-ratios',
  title: Bi('Financial Ratios and DuPont Analysis', 'النسب المالية وتحليل ديبونت'),
  category: 'financial-analysis',
  level: KBLevel.intermediate,
  readingMinutes: 5,
  summary: Bi('The four ratio families, what each one can and cannot tell you, and the DuPont decomposition that explains WHERE a return on equity comes from: margin, efficiency, or leverage.', 'عائلات النسب الأربع، وما تستطيع كل منها قوله وما لا تستطيع، وتفكيك ديبونت الذي يفسر من أين يأتي العائد على حقوق الملكية: من الهامش أم الكفاءة أم الرافعة.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('A ratio turns two absolute numbers into one comparable relationship. SAR 5m of profit means nothing by itself; profit relative to the revenue that produced it, the assets that were employed, or the equity that was risked means everything. Ratio analysis is organized into four families, each answering a different question. Profitability: how much of each riyal of activity becomes profit? Liquidity: can the company meet obligations due soon? Efficiency (activity): how hard are the assets working? Solvency (leverage): how is the company financed, and can it carry its debt?', 'النسبة تحول رقمين مطلقين إلى علاقة واحدة قابلة للمقارنة. خمسة ملايين ريال ربحاً لا تعني شيئاً وحدها؛ أما الربح منسوباً إلى الإيراد الذي أنتجه، أو الأصول التي شُغِّلت، أو حقوق الملكية التي خاطر بها الملاك، فيعني كل شيء. وينتظم تحليل النسب في أربع عائلات، تجيب كل منها عن سؤال مختلف. الربحية: كم يتحول من كل ريال نشاط إلى ربح؟ والسيولة: هل تستطيع الشركة الوفاء بالالتزامات القريبة؟ والكفاءة (النشاط): كم تجتهد الأصول في العمل؟ والملاءة (الرافعة): كيف تُموَّل الشركة وهل تحتمل دينها؟'),
        Bi('Two disciplines make ratios meaningful. First, comparison: a ratio is judged against the company\'s own history (trend), against peers in the same industry (benchmark), and against an explicit target. Second, context: every ratio inherits every accounting policy inside its inputs, so differences in revaluation, leasing, or depreciation policy can masquerade as performance differences.', 'انضباطان يمنحان النسب معناها. الأول المقارنة: تُحاكم النسبة إلى تاريخ الشركة نفسها (الاتجاه)، وإلى النظائر في الصناعة ذاتها (المعيار المرجعي)، وإلى هدف معلن. والثاني السياق: كل نسبة ترث كل سياسة محاسبية داخل مدخلاتها، فقد تتنكر فروق سياسات إعادة التقييم أو الإيجارات أو الإهلاك في هيئة فروق أداء.'),
      ],
    ),
    KBSection(
      heading: Bi('The formal treatment: the four families', 'المعالجة النظرية: العائلات الأربع'),
      paragraphs: [
        Bi('The most used members of each family, with their standard constructions:', 'أكثر أفراد كل عائلة استخداماً، بصيغها المعيارية:'),
      ],
      table: KBTable(
        headers: [
          Bi('Family', 'العائلة'),
          Bi('Ratio', 'النسبة'),
          Bi('Construction', 'الصيغة'),
        ],
        rows: [
          [
            Bi('Profitability', 'الربحية'),
            Bi('Net margin · ROA · ROE', 'الهامش الصافي · العائد على الأصول · العائد على حقوق الملكية'),
            Bi('Net income ÷ Revenue · Net income ÷ Total assets · Net income ÷ Equity', 'صافي الدخل ÷ الإيراد · صافي الدخل ÷ إجمالي الأصول · صافي الدخل ÷ حقوق الملكية'),
          ],
          [
            Bi('Liquidity', 'السيولة'),
            Bi('Current ratio · Quick ratio', 'نسبة التداول · النسبة السريعة'),
            Bi('Current assets ÷ Current liabilities · (Current assets − Inventory) ÷ Current liabilities', 'الأصول المتداولة ÷ الالتزامات المتداولة · (الأصول المتداولة − المخزون) ÷ الالتزامات المتداولة'),
          ],
          [
            Bi('Efficiency', 'الكفاءة'),
            Bi('Asset turnover · DSO · DIO', 'دوران الأصول · فترة التحصيل · فترة بقاء المخزون'),
            Bi('Revenue ÷ Total assets · Receivables ÷ Revenue × 365 · Inventory ÷ COGS × 365', 'الإيراد ÷ إجمالي الأصول · الذمم المدينة ÷ الإيراد × 365 · المخزون ÷ تكلفة المبيعات × 365'),
          ],
          [
            Bi('Solvency', 'الملاءة'),
            Bi('Debt-to-equity · Interest cover', 'الدين إلى حقوق الملكية · تغطية الفوائد'),
            Bi('Total debt ÷ Equity · Operating profit ÷ Finance costs', 'إجمالي الدين ÷ حقوق الملكية · الربح التشغيلي ÷ تكاليف التمويل'),
          ],
        ],
      ),
    ),
    KBSection(
      heading: Bi('DuPont: decomposing the return on equity', 'ديبونت: تفكيك العائد على حقوق الملكية'),
      paragraphs: [
        Bi('Return on equity is the headline ratio of shareholder performance, and also the easiest to misread, because three completely different engines can produce the same ROE. The DuPont identity separates them: ROE equals net margin (operating profitability) times asset turnover (efficiency of asset use) times the equity multiplier (financial leverage). The identity is exact; multiply the three terms and the revenue and asset figures cancel, leaving net income over equity.', 'العائد على حقوق الملكية هو النسبة الأبرز لأداء المساهمين، وهو أيضاً الأسهل في إساءة القراءة، لأن ثلاثة محركات مختلفة تماماً قد تنتج العائد نفسه. وتفصل متطابقة ديبونت بينها: العائد على حقوق الملكية يساوي الهامش الصافي (الربحية التشغيلية) مضروباً في دوران الأصول (كفاءة استخدام الأصول) مضروباً في مضاعف حقوق الملكية (الرافعة المالية). والمتطابقة دقيقة رياضياً؛ فبضرب الحدود الثلاثة تُختصر أرقام الإيراد والأصول ويبقى صافي الدخل على حقوق الملكية.'),
      ],
      formulas: [
        KBFormula('ROE = (Net income ÷ Revenue) × (Revenue ÷ Assets) × (Assets ÷ Equity)', caption: Bi('DuPont: margin × turnover × leverage. Same ROE, three very different ways to earn it.', 'ديبونت: الهامش × الدوران × الرافعة. العائد نفسه بثلاث طرق مختلفة جداً لكسبه.')),
      ],
    ),
    KBSection(
      heading: Bi('Worked example: two companies, one ROE', 'مثال محلول: شركتان وعائد واحد'),
      paragraphs: [
        Bi('Company A: net margin 10%, asset turnover 0.6, equity multiplier 2.5. ROE = 10% × 0.6 × 2.5 = 15%. Company B: net margin 3%, asset turnover 2.5, equity multiplier 2.0. ROE = 3% × 2.5 × 2.0 = 15%. Identical headline, opposite businesses: A is a high-margin, asset-heavy operator earning a material part of its return from leverage; B is a thin-margin, high-velocity trader whose return is earned operationally. A rate rise threatens A\'s ROE through its leverage; a demand slowdown threatens B\'s through its turnover. The decomposition tells you not just what the return is, but what could take it away.', 'الشركة أ: هامش صافٍ 10%، ودوران أصول 0.6، ومضاعف حقوق ملكية 2.5. العائد = 10% × 0.6 × 2.5 = 15%. والشركة ب: هامش صافٍ 3%، ودوران أصول 2.5، ومضاعف 2.0. العائد = 3% × 2.5 × 2.0 = 15%. العنوان متطابق والعملان متعاكسان: أ مشغِّل مرتفع الهامش ثقيل الأصول يكسب جزءاً مادياً من عائده من الرافعة؛ وب تاجر رقيق الهامش عالي السرعة يكسب عائده تشغيلياً. ارتفاع الفائدة يهدد عائد أ عبر رافعتها؛ وتباطؤ الطلب يهدد عائد ب عبر دورانها. التفكيك لا يخبرك بما هو العائد فحسب، بل بما قد يسلبه.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Celebrating a rising ROE without checking the multiplier: ROE grown by leverage alone is risk, not performance.', 'الاحتفاء بارتفاع العائد على حقوق الملكية دون فحص المضاعف: العائد النامي بالرافعة وحدها مخاطرةٌ لا أداء.'),
    Bi('Comparing ratios across industries. A supermarket\'s asset turnover and a utility\'s will never look alike, and should not.', 'مقارنة النسب عبر الصناعات. دوران أصول سوبرماركت ودوران شركة مرافق لن يتشابها أبداً، ولا ينبغي لهما.'),
    Bi('Using closing balances where averages belong: a year-end acquisition can distort ROA and turnover badly.', 'استخدام أرصدة الإقفال حيث ينبغي المتوسط: استحواذ في نهاية السنة قد يشوه العائد على الأصول والدوران تشويهاً شديداً.'),
    Bi('Forgetting that negative equity makes ROE meaningless, and that one-off gains inside net income flatter every profitability ratio at once.', 'نسيان أن حقوق الملكية السالبة تجعل العائد عليها بلا معنى، وأن المكاسب غير المتكررة داخل صافي الدخل تجمِّل كل نسب الربحية دفعة واحدة.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IAS 1',
      note: Bi('The classification and subtotals that ratio inputs are read from; comparability starts with presentation.', 'التصنيف والمجاميع الفرعية التي تُقرأ منها مدخلات النسب؛ فقابلية المقارنة تبدأ من العرض.'),
      segments: [
        KBStandardSegment('IAS 1', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-1-presentation-of-financial-statements/'),
      ],
    ),
    KBStandardRef(
      standard: 'IFRS 8',
      note: Bi('Segment reporting: for diversified groups, ratios computed on the consolidated totals can hide the segments that matter.', 'تقارير القطاعات: في المجموعات المتنوعة قد تخفي النسبُ المحسوبة على المجاميع الموحدة القطاعاتِ المهمة.'),
      segments: [
        KBStandardSegment('IFRS 8', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ifrs-8-operating-segments/'),
      ],
    ),
  ],
  relatedTerms: [
    'Return on Equity (ROE)',
    'Return on Assets (ROA)',
    'Current Ratio',
    'Asset Turnover',
    'Financial Leverage',
  ],
  relatedModules: [
    KBRelatedModule('/education/financial-analysis', Bi('Module: Analysis of Financial Statements', 'الوحدة: تحليل القوائم المالية')),
  ],
  relatedArticles: [
    'income-statement',
    'balance-sheet',
    'working-capital',
    'statement-analysis-case',
    'leases-ifrs16',
    'valuation-multiples',
    'segment-reporting',
    'dividend-policy',
    'credit-analysis',
  ],
  references: [
    'Penman, S. H. (2013). Financial statement analysis and security valuation (5th ed.). McGraw-Hill.',
    'Palepu, K. G., Healy, P. M., & Peek, E. (2019). Business analysis and valuation: IFRS edition (5th ed.). Cengage.',
    'Brealey, R. A., Myers, S. C., & Allen, F. (2020). Principles of corporate finance (13th ed.). McGraw-Hill.',
  ],
  keywords: [
    'ratios',
    'DuPont',
    'ROE',
    'ROA',
    'liquidity',
    'solvency',
    'leverage',
    'نسب مالية',
    'ديبونت',
    'العائد على حقوق الملكية',
    'رافعة',
  ],
);
