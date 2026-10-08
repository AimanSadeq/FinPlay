// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/interim-reporting.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbInterimReporting = KBArticle(
  id: 'interim-reporting',
  title: Bi('Interim Financial Reporting', 'التقرير المالي الأولي'),
  category: 'financial-statements',
  level: KBLevel.intermediate,
  readingMinutes: 8,
  summary: Bi('What a quarterly report must contain, why IAS 34 treats each interim period as discrete but taxes it on an annual estimate, the goodwill impairment that can never be taken back, and how seasonality misleads.', 'ما الذي يجب أن يحويه التقرير الربعي، ولماذا يعامل IAS 34 كل فترة أولية بوصفها مستقلة بينما يفرض ضريبتها على تقدير سنوي، وهبوط الشهرة الذي لا يمكن التراجع عنه أبداً، وكيف تضلل الموسمية.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('An interim report covers a period shorter than a full financial year, most often a quarter or a half. IAS 34 does not decide who must publish one or how often: that is the job of securities regulators and exchanges, which is why listed companies in Saudi Arabia report quarterly to Tadawul while many private companies report only annually. What the standard governs is what an interim report must contain and how the numbers in it are measured. The guiding idea is timeliness bought at the price of estimation. A quarterly report exists to get information to users quickly, so it may be condensed and it leans harder on estimates than an annual report does. The reader’s job is to remember that a quarter is a slice of a year that has not finished, and that some of what it says will be revised before the year closes.', 'التقرير الأولي يغطي فترة أقصر من سنة مالية كاملة، وغالباً ربعاً أو نصفاً. ولا يقرر IAS 34 من يجب أن ينشره ولا كم مرة: فذلك شأن هيئات الأوراق المالية والأسواق، ولهذا تُقرِّر الشركات المدرجة في السعودية ربعياً لتداول بينما تقرر شركات خاصة كثيرة سنوياً فقط. وما يحكمه المعيار هو ما يجب أن يحويه التقرير الأولي وكيف تُقاس أرقامه. والفكرة الحاكمة أن التوقيت السريع يُشترى بثمن التقدير. فالتقرير الربعي وُجد ليوصل المعلومة إلى المستخدمين سريعاً، فيجوز أن يكون مكثفاً ويستند إلى التقديرات أكثر من التقرير السنوي. ومهمة القارئ أن يتذكر أن الربع شريحة من سنة لم تنته، وأن بعض ما يقوله سيُعدَّل قبل إقفال السنة.'),
      ],
    ),
    KBSection(
      heading: Bi('The formal treatment: content, and the measurement rule', 'المعالجة النظرية: المحتوى وقاعدة القياس'),
      paragraphs: [
        Bi('A condensed interim report contains, as a minimum, a condensed statement of financial position, statement of profit or loss and other comprehensive income, statement of changes in equity, statement of cash flows, and selected explanatory notes. The comparative periods are prescribed and are easy to get wrong: the balance sheet compares with the end of the immediately preceding financial year, not with the same date last year, while the income statement compares with the equivalent interim period of the prior year and, in every interim report, the cumulative year-to-date figures for both years. Measurement follows the same accounting policies as the annual statements, applied on a year-to-date basis. That last phrase carries real weight. IAS 34 is broadly discrete, treating each interim period as a reporting period in its own right rather than as a mere instalment of the annual result, so costs are recognized when incurred rather than smoothed across quarters simply because they benefit the whole year. The major exception is income tax, which is measured using the estimated weighted average annual effective tax rate applied to interim pre-tax profit, because the tax charge genuinely depends on the full year’s outcome. Where an estimate made in an earlier interim period changes later in the year, the change is reflected in the later period, and earlier interim periods are not restated.', 'يحوي التقرير الأولي المكثف حداً أدنى: قائمة مركز مالي مكثفة، وقائمة أرباح أو خسائر ودخل شامل آخر، وقائمة تغيرات في حقوق الملكية، وقائمة تدفقات نقدية، وإيضاحات تفسيرية مختارة. وفترات المقارنة محددة ويسهل الخطأ فيها: فالميزانية تُقارن بنهاية السنة المالية السابقة مباشرة لا بالتاريخ نفسه من العام الماضي، بينما تُقارن قائمة الدخل بالفترة الأولية المناظرة من العام السابق، وفي كل تقرير أولي بالأرقام التراكمية منذ بداية السنة للعامين معاً. ويتبع القياس السياسات المحاسبية نفسها المطبقة في القوائم السنوية، على أساس تراكمي منذ بداية السنة. وتحمل تلك العبارة الأخيرة ثقلاً حقيقياً. فـIAS 34 مستقل في جوهره، يعامل كل فترة أولية فترةَ تقرير قائمة بذاتها لا مجرد قسط من النتيجة السنوية، فتُثبت التكاليف عند تكبدها لا مُنعَّمة على الأرباع لمجرد أنها تنفع السنة كلها. والاستثناء الأكبر ضريبة الدخل، إذ تُقاس بالمعدل الضريبي الفعلي السنوي المرجح المقدَّر مطبقاً على الربح الأولي قبل الضريبة، لأن عبء الضريبة يعتمد فعلاً على نتيجة السنة الكاملة. وحيث يتغير تقدير وُضع في فترة أولية سابقة، يُعكس التغير في الفترة اللاحقة ولا يُعاد عرض الفترات الأولية السابقة.'),
      ],
      formulas: [
        KBFormula('Interim tax charge = Estimated weighted average annual effective tax rate × Interim pre-tax profit', caption: Bi('The one significant departure from discrete measurement: tax follows the expected full-year rate.', 'المفارقة الجوهرية الوحيدة عن القياس المستقل: الضريبة تتبع المعدل المتوقع للسنة كاملة.')),
      ],
    ),
    KBSection(
      heading: Bi('Worked example: the tax rate that is not this quarter’s', 'مثال محلول: معدل الضريبة الذي ليس معدل هذا الربع'),
      paragraphs: [
        Bi('A company expects full-year pre-tax profit of SAR 100m and a full-year tax charge of SAR 22m, so its estimated annual effective rate is 22%. In the first quarter it earns pre-tax profit of SAR 30m. The interim tax charge is 22% × 30 = SAR 6.6m, giving after-tax profit of SAR 23.4m. Note what was not done: the quarter was not taxed at the 20% statutory rate a Saudi taxpayer would apply, because permanent differences lift the expected effective rate to 22%, and it was not taxed on its own standalone computation. Now suppose the second quarter brings an unexpected non-deductible fine that lifts the expected annual rate to 25%. The half-year cumulative charge becomes 25% of the cumulative pre-tax profit, and the difference from the SAR 6.6m already recognized lands entirely in the second quarter. The first quarter is not restated. A reader who compares Q2 tax to Q2 profit and concludes the company faces a punitive rate has misread a catch-up as a run rate, which is why interim tax lines deserve the annual estimate note beside them.', 'تتوقع شركة ربحاً سنوياً قبل الضريبة قدره 100 مليون ريال وعبء ضريبة سنوياً قدره 22 مليوناً، فمعدلها الفعلي السنوي المقدَّر 22%. وفي الربع الأول تحقق ربحاً قبل الضريبة قدره 30 مليوناً. فيكون عبء الضريبة الأولي 22% × 30 = 6.6 ملايين ريال، والربح بعد الضريبة 23.4 مليوناً. ولاحظ ما لم يُفعل: لم يُفرض على الربع المعدل النظامي 20% الذي يطبقه المكلف السعودي، إذ ترفع الفروق الدائمة المعدل الفعلي المتوقع إلى 22%، ولم يُحسب على أساس مستقل خاص به. والآن افترض أن الربع الثاني جلب غرامة غير قابلة للخصم رفعت المعدل السنوي المتوقع إلى 25%. فيصير عبء نصف السنة التراكمي 25% من الربح التراكمي قبل الضريبة، ويقع الفرق عن الـ6.6 ملايين المعترف بها كاملاً في الربع الثاني. ولا يُعاد عرض الربع الأول. والقارئ الذي يقارن ضريبة الربع الثاني بربحه فيستنتج أن الشركة تواجه معدلاً عقابياً قد أخطأ فقرأ تسويةً على أنها معدل جارٍ، ولهذا يستحق سطر الضريبة الأولي إيضاحَ التقدير السنوي بجواره.'),
      ],
    ),
    KBSection(
      heading: Bi('Two traps: seasonality and the irreversible impairment', 'فخّان: الموسمية والهبوط الذي لا يُعكس'),
      paragraphs: [
        Bi('The first trap is annualizing a quarter. Revenues received seasonally, cyclically or occasionally are not anticipated or deferred at an interim date if anticipating or deferring them would not be appropriate at year end, so a business that earns most of its profit in Ramadan or in the hajj season will show quarters that look wildly uneven. Multiplying a strong quarter by four is not analysis; comparing it with the same quarter last year is. The second trap is more technical and catches professionals. Under IFRIC 10, an impairment loss recognized on goodwill in an interim period may not be reversed in a later interim period or at year end, even if the conditions that caused it disappear entirely. IAS 36 already forbids reversing goodwill impairments, and IFRIC 10 closes the gap that would otherwise let an interim charge be undone within the same year. The practical consequence is a real incentive problem: an entity that would have avoided the charge on annual figures alone is stuck with it because it reported quarterly, which is precisely why interim impairment testing gets careful audit attention.', 'الفخ الأول تحويلُ ربع إلى سنة. فالإيرادات المتلقاة موسمياً أو دورياً أو عرضاً لا تُستبق ولا تُؤجَّل في تاريخ أولي إن كان استباقها أو تأجيلها غير مناسب في نهاية السنة، فالنشاط الذي يكسب معظم ربحه في رمضان أو موسم الحج ستبدو أرباعه شديدة التفاوت. وضربُ ربع قوي في أربعة ليس تحليلاً؛ بل مقارنته بالربع نفسه من العام الماضي هي التحليل. والفخ الثاني أكثر تقنية ويوقع المهنيين. فبموجب IFRIC 10 لا يجوز عكس خسارة هبوط معترف بها على الشهرة في فترة أولية، لا في فترة أولية لاحقة ولا في نهاية السنة، ولو زالت الظروف التي سببتها كلياً. فـIAS 36 يمنع أصلاً عكس هبوط الشهرة، ويسد IFRIC 10 الثغرة التي كانت ستتيح إلغاء عبء أولي داخل السنة نفسها. والنتيجة العملية مشكلة حوافز حقيقية: فالمنشأة التي كانت ستتجنب العبء لو نظرت إلى الأرقام السنوية وحدها تظل عالقة به لأنها قررت ربعياً، ولهذا بالضبط يحظى اختبار الهبوط الأولي باهتمام تدقيقي دقيق.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Annualizing a quarter in a seasonal business. IAS 34 deliberately does not smooth seasonal revenue, so the uneven pattern you see is the business, not an accounting artefact.', 'تحويل ربع إلى سنة في نشاط موسمي. فـIAS 34 لا ينعّم الإيراد الموسمي عمداً، فالنمط المتفاوت الذي تراه هو النشاط لا أثر محاسبي.'),
    Bi('Comparing the interim balance sheet with the same date last year. The prescribed comparative is the end of the preceding financial year.', 'مقارنة الميزانية الأولية بالتاريخ نفسه من العام الماضي. فالمقارنة المقررة هي نهاية السنة المالية السابقة.'),
    Bi('Reading a jump in the interim tax line as a change in the tax regime. It is usually a revision to the estimated annual rate catching up in one quarter.', 'قراءة قفزة في سطر الضريبة الأولي على أنها تغير في النظام الضريبي. فهي عادةً تعديل للمعدل السنوي المقدَّر يستدرك في ربع واحد.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IAS 34',
      note: Bi('Interim financial reporting: minimum content, prescribed comparatives, year-to-date measurement, and the annual effective tax rate.', 'التقرير المالي الأولي: الحد الأدنى من المحتوى وفترات المقارنة المقررة والقياس التراكمي والمعدل الضريبي الفعلي السنوي.'),
      segments: [
        KBStandardSegment('IAS 34', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-34-interim-financial-reporting/'),
      ],
    ),
    KBStandardRef(
      standard: 'IFRIC 10',
      note: Bi('Interim reporting and impairment: a goodwill impairment recognized in an interim period cannot later be reversed.', 'التقرير الأولي والهبوط: خسارة هبوط الشهرة المعترف بها في فترة أولية لا يجوز عكسها لاحقاً.'),
      segments: [
        KBStandardSegment('IFRIC 10', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ifric-10-interim-financial-reporting-and-impairment/'),
      ],
    ),
    KBStandardRef(
      standard: 'IAS 8 §32–40',
      note: Bi('Changes in estimate are recognized prospectively, which is why earlier interim periods are not restated.', 'تغيرات التقديرات تُثبت مستقبلياً، ولهذا لا يُعاد عرض الفترات الأولية السابقة.'),
      segments: [
        KBStandardSegment('IAS 8', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-8-accounting-policies-changes-in-accounting-estimates-and-errors/'),
        KBStandardSegment(' §32–40'),
      ],
    ),
  ],
  relatedTerms: [
    'Fiscal Year',
    'Income Tax Expense',
    'Impairment',
    'Goodwill',
    'Basic EPS',
    'Revenue',
  ],
  relatedModules: [
    KBRelatedModule('/education/financial-analysis', Bi('Module: Analysis of Financial Statements', 'الوحدة: تحليل القوائم المالية')),
  ],
  relatedArticles: [
    'income-statement',
    'impairment-testing',
    'deferred-tax',
    'earnings-quality',
    'segment-reporting',
  ],
  references: [
    'IFRS Foundation. (1998). IAS 34 Interim Financial Reporting. IFRS Foundation.',
    'IFRS Foundation. (2006). IFRIC 10 Interim Financial Reporting and Impairment. IFRS Foundation.',
    'Kieso, D. E., Weygandt, J. J., & Warfield, T. D. (2020). Intermediate accounting: IFRS edition (4th ed.). Wiley.',
  ],
  keywords: [
    'interim reporting',
    'IAS 34',
    'quarterly',
    'condensed statements',
    'effective tax rate',
    'seasonality',
    'IFRIC 10',
    'التقرير الأولي',
    'ربع سنوي',
    'الموسمية',
  ],
);
