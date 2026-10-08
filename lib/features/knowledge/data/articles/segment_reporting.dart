// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/segment-reporting.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbSegmentReporting = KBArticle(
  id: 'segment-reporting',
  title: Bi('Segment Reporting: Seeing Inside the Consolidated Total', 'التقارير القطاعية: النظر داخل الإجمالي الموحد'),
  category: 'financial-statements',
  level: KBLevel.intermediate,
  readingMinutes: 6,
  summary: Bi('Why one consolidated number hides more than it shows, how the management approach of IFRS 8 defines segments, a worked read of a two-segment group, and what the disclosure lets an analyst do that the primary statements cannot.', 'لماذا يخفي الرقم الموحد الواحد أكثر مما يظهر، وكيف يحدد نهج الإدارة في IFRS 8 القطاعات، وقراءة محلولة لمجموعة بقطاعين، وما الذي يتيحه الإفصاح للمحلل مما لا تتيحه القوائم الأساسية.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('A consolidated income statement adds up everything the group does and reports one revenue figure and one profit figure. For a group that sells cement in one country and runs a logistics arm in another, that total describes no actual business. Segment reporting breaks the total back apart. The intuition behind IFRS 8 is unusual among accounting standards: rather than prescribing how the pieces should be defined, it says the company must report the pieces the way management already runs the company. If the chief operating decision maker receives a monthly pack split by product line, then product lines are the segments, even if a geographic split would look more comparable to peers. The disclosure is therefore a window into the internal reporting system, not a separately constructed view.', 'قائمة الدخل الموحدة تجمع كل ما تفعله المجموعة وتعرض رقم إيراد واحداً ورقم ربح واحداً. ولمجموعة تبيع الإسمنت في بلد وتدير ذراعاً لوجستية في بلد آخر، لا يصف ذلك الإجمالي أي نشاط حقيقي. والتقارير القطاعية تفكك الإجمالي. والفكرة خلف IFRS 8 غير مألوفة بين المعايير المحاسبية: فبدل أن يفرض كيف تُعرَّف الأجزاء، يقول إن على الشركة أن تعرض الأجزاء كما تدير الإدارةُ الشركةَ فعلاً. فإن كان صانع القرار التشغيلي الرئيس يتلقى حزمة شهرية مقسمة بخطوط المنتجات، فخطوط المنتجات هي القطاعات، ولو بدا التقسيم الجغرافي أقبل للمقارنة مع النظائر. فالإفصاح إذن نافذة على نظام التقارير الداخلي لا عرضٌ مُنشأ على حدة.'),
      ],
    ),
    KBSection(
      heading: Bi('The formal treatment: identification, aggregation and thresholds', 'المعالجة النظرية: التحديد والتجميع والحدود'),
      paragraphs: [
        Bi('An operating segment is a component that earns revenues and incurs expenses, whose results the chief operating decision maker reviews regularly, and for which discrete financial information is available. Segments may be aggregated only when they share similar economic characteristics and are similar across products, production processes, customers, distribution methods and regulatory environment. A segment must be reported separately if it passes any of the 10% thresholds: 10% of combined revenue, 10% of the greater of combined profit or combined loss, or 10% of combined assets. Reported segments must together cover at least 75% of external revenue, with the remainder pooled into an "all other segments" line. Because segment figures come from internal reports, they need not follow IFRS, so the standard requires reconciliations of segment revenue, profit and assets back to the consolidated totals. Entity-wide disclosures then add revenue by product, revenue and non-current assets by country, and the existence of any customer representing 10% or more of revenue.', 'القطاع التشغيلي مكوّنٌ يكسب إيرادات ويتكبد مصروفات، ويراجع صانع القرار التشغيلي الرئيس نتائجه بانتظام، وتتوافر عنه معلومات مالية منفصلة. ولا تُجمَّع القطاعات إلا إذا تشاركت خصائص اقتصادية متشابهة وتشابهت في المنتجات وعمليات الإنتاج والعملاء وطرق التوزيع والبيئة التنظيمية. ويجب عرض القطاع على حدة إن اجتاز أياً من حدود العشرة بالمئة: 10% من الإيراد المجمع، أو 10% من الأكبر بين مجموع الأرباح ومجموع الخسائر، أو 10% من الأصول المجمعة. وعلى القطاعات المعروضة أن تغطي معاً 75% على الأقل من الإيراد الخارجي، ويُجمَّع الباقي في سطر "قطاعات أخرى". ولأن أرقام القطاعات تأتي من تقارير داخلية فلا يلزم أن تتبع IFRS، لذا يوجب المعيار مطابقات لإيراد القطاعات وأرباحها وأصولها مع الإجماليات الموحدة. ثم تضيف إفصاحات المنشأة ككل الإيرادَ حسب المنتج، والإيراد والأصول غير المتداولة حسب الدولة، ووجودَ أي عميل يمثل 10% أو أكثر من الإيراد.'),
      ],
      formulas: [
        KBFormula('Reportable if: Segment revenue ≥ 10% of total  OR  |Segment result| ≥ 10% of the greater of total profits or total losses  OR  Segment assets ≥ 10% of total', caption: Bi('The IFRS 8 quantitative thresholds; passing any one is enough.', 'حدود IFRS 8 الكمية؛ ويكفي اجتياز أي واحد منها.')),
      ],
    ),
    KBSection(
      heading: Bi('Worked example: what the total was hiding', 'مثال محلول: ما الذي كان الإجمالي يخفيه'),
      paragraphs: [
        Bi('A group reports revenue of SAR 900m and operating profit of SAR 72m, an 8% margin, flat against last year. The segment note splits it: manufacturing has revenue of SAR 600m and profit of SAR 96m (16% margin, up from 14%), while a retail arm has revenue of SAR 300m and a loss of SAR 24m (worse than last year’s loss of SAR 10m). The flat consolidated margin was two opposite trends cancelling out. Segment assets tell the second half of the story: manufacturing uses SAR 400m of assets and earns a 24% return on them, while retail consumes SAR 350m to lose money. Now the analytical question is sharp and answerable: what would the group be worth if retail were fixed, sold or closed? That question is invisible in the consolidated statements and obvious in the segment note, which is why experienced analysts read the segment disclosure before the income statement.', 'تعرض مجموعة إيراداً قدره 900 مليون ريال وربحاً تشغيلياً قدره 72 مليوناً، أي هامش 8% ثابت مقارنة بالعام الماضي. ويفصّل إيضاح القطاعات: التصنيع بإيراد 600 مليون وربح 96 مليوناً (هامش 16% صعوداً من 14%)، وذراع تجزئة بإيراد 300 مليون وخسارة 24 مليوناً (أسوأ من خسارة العام الماضي البالغة عشرة ملايين). فالهامش الموحد الثابت كان اتجاهين متعاكسين يلغي أحدهما الآخر. وتروي أصول القطاعات نصف القصة الثاني: التصنيع يستخدم 400 مليون من الأصول ويحقق عليها عائداً 24%، بينما تستهلك التجزئة 350 مليوناً لتخسر. والآن يصير السؤال التحليلي حاداً وقابلاً للإجابة: كم تساوي المجموعة لو أُصلحت التجزئة أو بيعت أو أُغلقت؟ ذلك السؤال غير مرئي في القوائم الموحدة وبديهي في إيضاح القطاعات، ولهذا يقرأ المحللون المتمرسون الإفصاح القطاعي قبل قائمة الدخل.'),
      ],
    ),
    KBSection(
      heading: Bi('The cost of the management approach', 'ثمن نهج الإدارة'),
      paragraphs: [
        Bi('Letting management define the segments buys relevance and pays for it in comparability. Two competitors in the same industry may segment differently, so their disclosures do not line up. A reorganization changes the segments, and although prior periods are restated, the historical series breaks in substance. Management also chooses the profit measure it reports, which is often a non-IFRS figure such as segment EBITDA before allocations, and it decides how central costs are pushed down, so a segment can be made to look better or worse by an allocation policy rather than by trading. None of this makes the disclosure unreliable; it makes it something to interrogate. Read the basis of segmentation and the reconciliation first, then the numbers, and treat any change in segment definitions as a question to ask rather than a formality to skip.', 'ترك تعريف القطاعات للإدارة يشتري الملاءمة ويدفع ثمنها قابلية المقارنة. فقد يقسّم منافسان في الصناعة نفسها تقسيمين مختلفين، فلا تتراصف إفصاحاتهما. وإعادة التنظيم تغير القطاعات، ورغم إعادة عرض الفترات السابقة تنكسر السلسلة التاريخية جوهرياً. وتختار الإدارة كذلك مقياس الربح الذي تعرضه، وهو غالباً رقم خارج IFRS كأرباح القطاع قبل الفوائد والضرائب والاستهلاك وقبل تحميل التكاليف المركزية، وتقرر كيف تُحمَّل التكاليف المركزية، فيمكن أن يبدو القطاع أفضل أو أسوأ بسياسة تحميل لا بأداء تجاري. ولا يجعل ذلك الإفصاح غير موثوق؛ بل يجعله شيئاً يُساءل. اقرأ أساس التقطيع والمطابقة أولاً ثم الأرقام، وعامل أي تغير في تعريفات القطاعات سؤالاً يُطرح لا إجراءً شكلياً يُتجاوز.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Comparing segment margins across companies as if the segments were defined the same way: the management approach guarantees they are not.', 'مقارنة هوامش القطاعات بين الشركات كأن القطاعات مُعرَّفة بالطريقة نفسها: فنهج الإدارة يضمن أنها ليست كذلك.'),
    Bi('Ignoring the reconciliation line: unallocated corporate costs and eliminations can be large enough to change the story the segment table appears to tell.', 'تجاهل سطر المطابقة: فالتكاليف المركزية غير الموزعة والاستبعادات قد تبلغ حجماً يغير القصة التي يبدو أن جدول القطاعات يرويها.'),
    Bi('Overlooking the major-customer disclosure: a single customer at 10% or more of revenue is a concentration risk the ratios will never reveal.', 'إغفال إفصاح العميل الرئيس: فعميل واحد بنسبة 10% أو أكثر من الإيراد خطرُ تركزٍ لن تكشفه النسب أبداً.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IFRS 8',
      note: Bi('Operating segments: the management approach, aggregation criteria, 10% thresholds, and required reconciliations.', 'القطاعات التشغيلية: نهج الإدارة ومعايير التجميع وحدود العشرة بالمئة والمطابقات المطلوبة.'),
      segments: [
        KBStandardSegment('IFRS 8', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ifrs-8-operating-segments/'),
      ],
    ),
    KBStandardRef(
      standard: 'IFRS 15 §114–115',
      note: Bi('Disaggregation of revenue: a second, revenue-focused cut that often complements the segment note.', 'تفصيل الإيراد: تقطيع ثانٍ يركز على الإيراد وغالباً ما يكمل إيضاح القطاعات.'),
      segments: [
        KBStandardSegment('IFRS 15', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ifrs-15-revenue-from-contracts-with-customers/'),
        KBStandardSegment(' §114–115'),
      ],
    ),
  ],
  relatedTerms: [
    'Revenue',
    'Operating Income (EBIT)',
    'Operating Margin',
    'Total Assets',
    'Return on Assets (ROA)',
  ],
  relatedModules: [
    KBRelatedModule('/education/financial-analysis', Bi('Module: Analysis of Financial Statements', 'الوحدة: تحليل القوائم المالية')),
  ],
  relatedArticles: [
    'income-statement',
    'consolidation-goodwill',
    'statement-analysis-case',
    'financial-ratios',
    'transfer-pricing',
    'discontinued-operations',
    'interim-reporting',
    'related-party-disclosures',
  ],
  references: [
    'IFRS Foundation. (2006). IFRS 8 Operating Segments. IFRS Foundation.',
    'Penman, S. H. (2013). Financial statement analysis and security valuation (5th ed.). McGraw-Hill.',
    'Wahlen, J. M., Baginski, S. P., & Bradshaw, M. (2018). Financial reporting, financial statement analysis and valuation (9th ed.). Cengage.',
  ],
  keywords: [
    'segment reporting',
    'IFRS 8',
    'operating segments',
    'management approach',
    'chief operating decision maker',
    'reconciliation',
    'التقارير القطاعية',
    'القطاعات التشغيلية',
    'نهج الإدارة',
  ],
);
