// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/consolidation-goodwill.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbConsolidationGoodwill = KBArticle(
  id: 'consolidation-goodwill',
  title: Bi('Consolidation, Group Accounts and Goodwill', 'التوحيد وحسابات المجموعة والشهرة'),
  category: 'financial-statements',
  level: KBLevel.advanced,
  readingMinutes: 6,
  summary: Bi('Why groups publish one set of statements, how control decides what gets consolidated, where goodwill and non-controlling interest come from, and what the equity method does instead.', 'لماذا تنشر المجموعات قوائم واحدة، وكيف تحدد السيطرة ما يُوحَّد، ومن أين تأتي الشهرة والحصة غير المسيطرة، وماذا تفعل طريقة حقوق الملكية بدلاً من ذلك.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('A parent company that controls other companies is legally many entities but economically one business. Consolidation presents that economic unit: the group balance sheet adds every subsidiary’s assets and liabilities line by line, the group income statement adds every subsidiary’s revenues and expenses, and everything the group did with itself (intercompany sales, loans, dividends) is eliminated. The test for consolidation is control, not ownership percentage. Control under IFRS 10 means power over the investee, exposure to variable returns, and the ability to use that power to affect those returns. Owning 60% of a subsidiary means consolidating 100% of its assets and revenue, because the parent controls all of them, and then showing the outside shareholders’ slice separately as non-controlling interest.', 'الشركة الأم التي تسيطر على شركات أخرى كيانات كثيرة قانوناً لكنها عملٌ واحد اقتصادياً. والتوحيد يعرض تلك الوحدة الاقتصادية: فميزانية المجموعة تجمع أصول كل شركة تابعة والتزاماتها بنداً بنداً، وقائمة دخل المجموعة تجمع إيرادات كل تابعة ومصروفاتها، ويُستبعد كل ما فعلته المجموعة مع نفسها (مبيعات بينية وقروض وتوزيعات). ومعيار التوحيد هو السيطرة لا نسبة الملكية. والسيطرة وفق IFRS 10 تعني القدرة على توجيه الشركة المستثمَر فيها، والتعرض لعوائد متغيرة، والقدرة على استخدام تلك السلطة للتأثير في تلك العوائد. وامتلاك 60% من تابعة يعني توحيد 100% من أصولها وإيرادها، لأن الأم تسيطر عليها كلها، ثم عرضُ حصة المساهمين الخارجيين على حدة بوصفها حصة غير مسيطرة.'),
      ],
    ),
    KBSection(
      heading: Bi('The formal treatment: acquisition accounting and goodwill', 'المعالجة النظرية: محاسبة الاستحواذ والشهرة'),
      paragraphs: [
        Bi('When one company buys another, IFRS 3 requires the acquisition method. The acquirer measures the identifiable assets and liabilities of the target at fair value on the acquisition date, including intangibles the target never showed on its own books (brands, customer relationships, technology). Whatever the buyer paid above that fair value of net assets is goodwill: the price of things that cannot be separately identified, such as the assembled workforce, expected synergies, and the premium paid to win control. Goodwill sits on the group balance sheet as an asset, is never amortized under IFRS, and is instead tested for impairment at least annually. If the buyer paid less than fair value of net assets, the difference is a bargain purchase gain recognized immediately in profit, after management re-checks its measurements, because genuine bargains are rare and measurement errors are not.', 'عندما تشتري شركةٌ شركةً أخرى، يوجب IFRS 3 طريقة الاستحواذ. يقيس المستحوذ الأصول والالتزامات القابلة للتحديد لدى الشركة المستهدفة بالقيمة العادلة في تاريخ الاستحواذ، بما فيها أصول غير ملموسة لم تظهر قط في دفاتر المستهدفة نفسها (علامات تجارية وعلاقات عملاء وتقنية). وما دفعه المشتري فوق تلك القيمة العادلة لصافي الأصول هو الشهرة: ثمن ما لا يمكن تحديده على حدة، كفريق العمل المكتمل والتآزرات المتوقعة وعلاوة الفوز بالسيطرة. تجلس الشهرة في ميزانية المجموعة أصلاً، ولا تُطفأ أبداً وفق IFRS، بل تُختبر للهبوط سنوياً على الأقل. وإن دفع المشتري أقل من القيمة العادلة لصافي الأصول، فالفرق مكسبُ شراءٍ مُجزٍ يُعترف به فوراً في الربح بعد أن تعيد الإدارة فحص قياساتها، لأن الصفقات المجزية حقاً نادرة وأخطاء القياس ليست كذلك.'),
      ],
      formulas: [
        KBFormula('Goodwill = Consideration transferred + Non-controlling interest + Fair value of any previously held equity interest − Fair value of identifiable net assets acquired', caption: Bi('The IFRS 3 goodwill equation at the acquisition date.', 'معادلة الشهرة وفق IFRS 3 في تاريخ الاستحواذ.')),
      ],
    ),
    KBSection(
      heading: Bi('Worked example: buying 80% of a target', 'مثال محلول: شراء 80% من شركة مستهدفة'),
      paragraphs: [
        Bi('A parent pays SAR 96m for 80% of a company whose identifiable net assets have a fair value of SAR 100m (book value SAR 85m; the fair-value exercise added SAR 10m to property and recognized a SAR 5m customer-relationship intangible). Non-controlling interest may be measured either at its proportionate share of identifiable net assets or at acquisition-date fair value, an election made deal by deal; taking the proportionate share here gives 20% × 100m = SAR 20m. Goodwill = 96 + 20 − 100 = SAR 16m. The group balance sheet now carries 100% of the target’s assets at fair value, SAR 16m of goodwill, and SAR 20m of non-controlling interest inside equity. Notice what did not happen: the parent’s 80% did not put 80% of the assets on the balance sheet. Control brought all of them, and the outside 20% appears as a claim, not as an exclusion.', 'تدفع شركة أم 96 مليون ريال مقابل 80% من شركة قيمةُ صافي أصولها القابلة للتحديد العادلة 100 مليون ريال (القيمة الدفترية 85 مليوناً؛ إذ أضاف قياس القيمة العادلة 10 ملايين إلى العقارات واعترف بأصل غير ملموس لعلاقات العملاء قدره 5 ملايين). ويجوز قياس الحصة غير المسيطرة إما بنصيبها النسبي من صافي الأصول القابلة للتحديد وإما بالقيمة العادلة في تاريخ الاستحواذ، وهو خيار يُتخذ لكل صفقة على حدة؛ وبأخذ النصيب النسبي هنا تكون 20% × 100 = 20 مليون ريال. الشهرة = 96 + 20 − 100 = 16 مليون ريال. تحمل ميزانية المجموعة الآن 100% من أصول المستهدفة بالقيمة العادلة، و16 مليوناً شهرةً، و20 مليوناً حصةً غير مسيطرة داخل حقوق الملكية. ولاحظ ما لم يحدث: لم تضع نسبة 80% التي تملكها الأم 80% من الأصول في الميزانية. فالسيطرة جلبت الأصول كلها، وتظهر نسبة 20% الخارجية مطالبةً لا استبعاداً.'),
      ],
    ),
    KBSection(
      heading: Bi('Below control: the equity method', 'دون السيطرة: طريقة حقوق الملكية'),
      paragraphs: [
        Bi('Significant influence without control (typically 20% to 50% of the votes) makes the investee an associate, accounted for under the equity method of IAS 28. The investment appears as a single line at cost plus the investor’s share of post-acquisition profits, minus dividends received. Nothing is added line by line: an associate’s debt does not appear on the investor’s balance sheet, and its revenue does not appear in the investor’s revenue. Analysts should treat this as a flag, not a footnote. A company can place heavily indebted operations in 50/50 ventures and show a clean consolidated balance sheet while the leverage lives next door. Reading the associates and joint-ventures note is how you find it.', 'التأثير الجوهري دون سيطرة (عادةً 20% إلى 50% من الأصوات) يجعل الشركة المستثمَر فيها شركة زميلة تُحتسب بطريقة حقوق الملكية وفق IAS 28. يظهر الاستثمار سطراً واحداً بالتكلفة مضافاً إليها نصيب المستثمر من أرباح ما بعد الاستحواذ، مطروحاً منها التوزيعات المقبوضة. ولا يُجمع شيء بنداً بنداً: فدين الزميلة لا يظهر في ميزانية المستثمر، وإيرادها لا يظهر في إيراده. وعلى المحللين معاملة ذلك علامةَ تنبيه لا حاشية. فبوسع شركة أن تضع عمليات مثقلة بالديون في مشاريع مناصفة وتعرض ميزانية موحدة نظيفة بينما تقيم الرافعة في البيت المجاور. وقراءة إيضاح الشركات الزميلة والمشاريع المشتركة هي الطريق إلى كشف ذلك.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Reading consolidated revenue as the parent’s revenue: the group total includes subsidiaries the parent may own only 51% of, so profit attributable to owners of the parent is the line that belongs to shareholders.', 'قراءة الإيراد الموحد إيراداً للأم: إجمالي المجموعة يشمل شركات تابعة قد لا تملك الأم منها سوى 51%، فالربح العائد إلى ملاك الأم هو السطر الذي يخص المساهمين.'),
    Bi('Forgetting the eliminations: intercompany sales inflate both revenue and costs if not removed, and unrealized profit in inventory sold within the group is not profit at all.', 'نسيان الاستبعادات: المبيعات البينية تضخم الإيراد والتكاليف معاً إن لم تُحذف، والربح غير المحقق في مخزون بيع داخل المجموعة ليس ربحاً أصلاً.'),
    Bi('Treating goodwill as a normal asset: it cannot be sold separately, it is never amortized, and a goodwill impairment usually confirms the market’s verdict on an overpriced deal years after the cash left.', 'معاملة الشهرة أصلاً عادياً: فهي لا تُباع على حدة ولا تُطفأ أبداً، وهبوطها عادةً يؤكد حكم السوق على صفقة مبالغ في ثمنها بعد سنوات من خروج النقد.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IFRS 10',
      note: Bi('Consolidated financial statements: the control model that decides which entities enter the group accounts.', 'القوائم المالية الموحدة: نموذج السيطرة الذي يحدد أي الكيانات تدخل حسابات المجموعة.'),
      segments: [
        KBStandardSegment('IFRS 10', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ifrs-10-consolidated-financial-statements/'),
      ],
    ),
    KBStandardRef(
      standard: 'IFRS 3',
      note: Bi('Business combinations: the acquisition method, fair-value measurement of acquired net assets, and goodwill.', 'اندماجات الأعمال: طريقة الاستحواذ وقياس صافي الأصول المستحوذ عليها بالقيمة العادلة والشهرة.'),
      segments: [
        KBStandardSegment('IFRS 3', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ifrs-3-business-combinations/'),
      ],
    ),
    KBStandardRef(
      standard: 'IAS 28',
      note: Bi('Investments in associates and joint ventures: the equity method for significant influence without control.', 'الاستثمارات في الشركات الزميلة والمشاريع المشتركة: طريقة حقوق الملكية للتأثير الجوهري دون سيطرة.'),
      segments: [
        KBStandardSegment('IAS 28', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-28-investments-in-associates-and-joint-ventures/'),
      ],
    ),
  ],
  relatedTerms: [
    'Consolidated Financial Statements',
    'Subsidiary',
    'Goodwill',
    'Non-controlling Interest',
    'Equity Method',
    'Intangible Assets',
    'Fair Value',
  ],
  relatedModules: [
    KBRelatedModule('/education/financial-analysis', Bi('Module: Analysis of Financial Statements', 'الوحدة: تحليل القوائم المالية')),
    KBRelatedModule('/education/fundamentals', Bi('Module: Financial Management Primer', 'الوحدة: تمهيد الإدارة المالية')),
  ],
  relatedArticles: [
    'balance-sheet',
    'income-statement',
    'impairment-testing',
    'transfer-pricing',
    'statement-analysis-case',
    'segment-reporting',
    'equity-and-oci',
    'foreign-currency',
    'discontinued-operations',
    'related-party-disclosures',
    'intangible-assets',
    'mergers-acquisitions',
  ],
  references: [
    'IFRS Foundation. (2011). IFRS 10 Consolidated Financial Statements. IFRS Foundation.',
    'IFRS Foundation. (2008). IFRS 3 Business Combinations. IFRS Foundation.',
    'Picker, R., Clark, K., Dunn, J., Kolitz, D., Livne, G., Loftus, J., & van der Tas, L. (2019). Applying IFRS standards (4th ed.). Wiley.',
    'Penman, S. H. (2013). Financial statement analysis and security valuation (5th ed.). McGraw-Hill.',
  ],
  keywords: [
    'consolidation',
    'group accounts',
    'goodwill',
    'business combination',
    'non-controlling interest',
    'equity method',
    'subsidiary',
    'IFRS 3',
    'IFRS 10',
    'التوحيد',
    'الشهرة',
    'الحصة غير المسيطرة',
    'شركة تابعة',
  ],
);
