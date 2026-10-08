// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/share-based-payment.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbShareBasedPayment = KBArticle(
  id: 'share-based-payment',
  title: Bi('Share-Based Payment and Equity Incentives', 'المدفوعات على أساس الأسهم والحوافز السهمية'),
  category: 'corporate-finance',
  level: KBLevel.advanced,
  readingMinutes: 8,
  summary: Bi('Why paying people in shares is an expense even though no cash moves, how grant-date fair value and vesting conditions drive the charge, the difference between equity-settled and cash-settled awards, and a worked option grant with its dilution.', 'لماذا يكون الدفع للناس بالأسهم مصروفاً وإن لم يتحرك نقد، وكيف تقود القيمة العادلة في تاريخ المنح وشروط الاستحقاق العبءَ، والفرق بين المنح المسددة بأدوات حقوق ملكية والمسددة نقداً، ومثال منح خيارات محلول مع أثر التخفيف.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('A company can pay for services with cash or with claims on itself. Share options, restricted stock units and share appreciation rights are all ways of paying people in ownership rather than salary. For years the accounting pretended this was free, because no cash left the business, and companies granted options generously on that basis. The argument that ended the debate is simple: if the company had issued those shares to investors for cash and used the cash to pay salaries, nobody would question the expense. Routing the same value directly to employees changes the form, not the substance. IFRS 2 therefore requires the value given up to be recognized as an expense over the period the company receives the service, with the credit going to equity for share-settled awards or to a liability for cash-settled ones.', 'تستطيع الشركة أن تدفع مقابل الخدمات نقداً أو بمطالبات على نفسها. فخيارات الأسهم والأسهم المقيدة وحقوق زيادة قيمة الأسهم كلها طرق للدفع للناس ملكيةً بدل راتب. وسنوات طويلة تظاهرت المحاسبة بأن هذا مجاني، لأن لا نقد يغادر النشاط، فمنحت الشركات الخيارات بسخاء على ذلك الأساس. والحجة التي أنهت الجدل بسيطة: لو أصدرت الشركة تلك الأسهم لمستثمرين مقابل نقد واستخدمت النقد لدفع الرواتب، لما شكك أحد في المصروف. وتوجيه القيمة نفسها إلى الموظفين مباشرة يغير الشكل لا الجوهر. لذا يوجب IFRS 2 الاعتراف بالقيمة المتنازل عنها مصروفاً على مدى الفترة التي تتلقى فيها الشركة الخدمة، مع قيد دائن في حقوق الملكية للمنح المسددة بأسهم أو في الالتزامات للمسددة نقداً.'),
      ],
    ),
    KBSection(
      heading: Bi('The formal treatment: grant-date fair value and vesting', 'المعالجة النظرية: القيمة العادلة في تاريخ المنح والاستحقاق'),
      paragraphs: [
        Bi('For an equity-settled award, the expense is fixed at grant-date fair value and is never revisited for later share price movements. An option is valued with a pricing model such as Black-Scholes or a binomial lattice, using the exercise price, the share price, expected volatility, expected life, the risk-free rate and expected dividends. That total is then spread over the vesting period, the time the employee must serve to earn the award. The treatment of conditions is where the rules bite. Service conditions and non-market performance conditions, such as staying three years or hitting a profit target, are not built into the fair value; instead the number of awards expected to vest is estimated and revised each period, so the cumulative expense ends up matching what actually vested. Market conditions, such as a share price target or relative shareholder return, are built into the grant-date fair value and are never trued up, which means a company can carry an expense for options that expired worthless because the share price target was missed. Cash-settled awards work differently again: they create a liability remeasured at fair value at every reporting date until settlement, so the charge swings with the share price.', 'في المنح المسددة بأدوات حقوق ملكية يُثبَّت المصروف عند القيمة العادلة في تاريخ المنح ولا يُعاد النظر فيه أبداً لتحركات سعر السهم اللاحقة. ويُقيَّم الخيار بنموذج تسعير كبلاك-شولز أو شبكة ثنائية الحدين، باستخدام سعر التنفيذ وسعر السهم والتقلب المتوقع والعمر المتوقع والمعدل الخالي من المخاطر والتوزيعات المتوقعة. ثم يُوزع المجموع على فترة الاستحقاق، أي المدة التي يجب أن يخدمها الموظف ليكسب المنحة. وتظهر حدّة القواعد في معالجة الشروط. فشروط الخدمة وشروط الأداء غير السوقية، كالبقاء ثلاث سنوات أو بلوغ هدف ربح، لا تُدرج في القيمة العادلة؛ بل يُقدَّر عدد المنح المتوقع استحقاقها ويُراجع كل فترة، فينتهي المصروف التراكمي مطابقاً لما استُحق فعلاً. أما الشروط السوقية، كهدف لسعر السهم أو عائد نسبي للمساهمين، فتُدرج في القيمة العادلة في تاريخ المنح ولا تُعدَّل أبداً، ما يعني أن شركة قد تحمل مصروفاً عن خيارات انتهت بلا قيمة لأن هدف السعر لم يتحقق. وتعمل المنح المسددة نقداً بطريقة أخرى: فهي تنشئ التزاماً يُعاد قياسه بالقيمة العادلة في كل تاريخ تقرير حتى التسوية، فيتأرجح العبء مع سعر السهم.'),
      ],
      formulas: [
        KBFormula('Cumulative expense = Grant-date fair value per award × Awards expected to vest × (Elapsed vesting period ÷ Total vesting period)', caption: Bi('Equity-settled awards: only the expected number vesting is revised, never the unit fair value.', 'المنح المسددة بأسهم: يُراجَع العدد المتوقع استحقاقه فقط، لا القيمة العادلة للوحدة.')),
        KBFormula('Diluted EPS denominator = Basic shares + (Options − Options × Exercise price ÷ Average share price)', caption: Bi('The treasury stock method: only the in-the-money element adds shares. For unvested awards IAS 33 also adds the unrecognized compensation cost to assumed proceeds.', 'طريقة أسهم الخزينة: العنصر داخل النقد وحده يضيف أسهماً. وللمنح غير المستحقة يضيف IAS 33 أيضاً تكلفة التعويض غير المعترف بها إلى المتحصلات المفترضة.')),
      ],
    ),
    KBSection(
      heading: Bi('Worked example: an option grant and its dilution', 'مثال محلول: منح خيارات وأثر تخفيفه'),
      paragraphs: [
        Bi('A company grants 300,000 options to executives, vesting after three years of service, with a grant-date fair value of SAR 12 each. Management expects 90% to vest. The total expected expense is 300,000 × 90% × 12 = SAR 3,240,000, recognized as SAR 1,080,000 a year for three years, charged to profit with the credit in equity. If turnover proves worse and only 80% vest, the estimate is revised and the cumulative charge is trued up to SAR 2,880,000, with the catch-up landing in the year of the revision. Now the dilution. Suppose the exercise price is SAR 30 and the average share price during the year is SAR 50. Once the options have vested, the treasury stock method adds 300,000 − (300,000 × 30 ÷ 50) = 120,000 shares to the diluted count. During the vesting period the effect is smaller, because IAS 33 adds the compensation cost not yet recognized to the assumed proceeds: at the end of year one that is SAR 2,160,000, so proceeds are 9,000,000 + 2,160,000 = SAR 11,160,000, which buys back 223,200 shares and leaves 76,800 incremental shares. The award becomes progressively more dilutive as that unrecognized cost runs off. So the grant costs the income statement SAR 1,080,000 a year and costs existing shareholders a claim growing from 76,800 shares toward 120,000. Both costs are real, they appear in different places, and only reading basic and diluted EPS together shows the whole of it.', 'تمنح شركة 300,000 خيار للتنفيذيين، تستحق بعد ثلاث سنوات خدمة، بقيمة عادلة في تاريخ المنح قدرها 12 ريالاً للخيار. وتتوقع الإدارة استحقاق 90%. فإجمالي المصروف المتوقع 300,000 × 90% × 12 = 3,240,000 ريال، يُعترف به بمقدار 1,080,000 ريال سنوياً ثلاث سنوات، محمّلاً على الأرباح والقيد الدائن في حقوق الملكية. وإن كان الدوران الوظيفي أسوأ فاستحق 80% فقط، رُوجع التقدير وعُدِّل العبء التراكمي إلى 2,880,000 ريال، وتهبط التسوية في سنة المراجعة. والآن التخفيف. افترض أن سعر التنفيذ 30 ريالاً ومتوسط سعر السهم خلال السنة 50 ريالاً. فمتى استُحقت الخيارات أضافت طريقة أسهم الخزينة 300,000 − (300,000 × 30 ÷ 50) = 120,000 سهم إلى العدد المخفف. أما خلال فترة الاستحقاق فالأثر أصغر، لأن IAS 33 يضيف تكلفة التعويض غير المعترف بها بعدُ إلى المتحصلات المفترضة: وهي في نهاية السنة الأولى 2,160,000 ريال، فتصير المتحصلات 9,000,000 + 2,160,000 = 11,160,000 ريال، تشتري 223,200 سهماً وتترك 76,800 سهم إضافي. وتزداد المنحة تخفيفاً تدريجياً مع تناقص تلك التكلفة غير المعترف بها. فالمنحة تكلف قائمة الدخل 1,080,000 ريال سنوياً وتكلف المساهمين الحاليين مطالبةً تنمو من 76,800 سهم نحو 120,000. والكلفتان حقيقيتان، وتظهران في موضعين مختلفين، ولا يُظهر مجموعهما إلا قراءة ربحية السهم الأساسية والمخففة معاً.'),
      ],
    ),
    KBSection(
      heading: Bi('Incentive design, and what to watch', 'تصميم الحوافز وما ينبغي مراقبته'),
      paragraphs: [
        Bi('The purpose of an equity award is alignment: make the people running the company think like owners. Whether it works depends on the design, and the accounting reveals the design. Options are asymmetric, paying off on the upside and costing nothing personally on the downside, which rewards risk-taking and can encourage it beyond what shareholders want. Restricted stock retains value even when the price falls, so it aligns with holding rather than gambling but rewards mere survival. Performance shares tied to relative measures filter out a rising market that lifted everyone. Two things deserve scrutiny in any disclosure. First, whether the performance conditions are demanding: targets set at the level of a base-case budget are not incentives, they are deferred salary. Second, whether buybacks are being used to mop up the dilution, because a company repurchasing shares to offset employee awards is quietly converting an equity incentive into a cash cost while reporting neither as compensation.', 'الغرض من المنحة السهمية المواءمة: أن يفكر من يديرون الشركة تفكير الملاك. ونجاح ذلك يتوقف على التصميم، والمحاسبة تكشف التصميم. فالخيارات غير متماثلة، تدفع عند الصعود ولا تكلف شيئاً شخصياً عند الهبوط، فتكافئ المخاطرة وقد تشجعها فوق ما يريده المساهمون. والأسهم المقيدة تحتفظ بقيمتها ولو هبط السعر، فتوائم الاحتفاظ لا المقامرة لكنها تكافئ مجرد البقاء. وأسهم الأداء المرتبطة بمقاييس نسبية تُصفّي أثر سوق صاعدة رفعت الجميع. وأمران يستحقان التدقيق في أي إفصاح. أولهما: هل شروط الأداء صعبة؟ فالأهداف الموضوعة عند مستوى موازنة الحالة الأساسية ليست حوافز بل راتباً مؤجلاً. وثانيهما: هل تُستخدم إعادة الشراء لامتصاص التخفيف؟ فالشركة التي تعيد شراء أسهم لتعويض منح الموظفين تحوّل بهدوء حافزاً سهمياً إلى كلفة نقدية دون أن تعرض أياً منهما تعويضاً.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Calling share-based payment non-cash and adding it back as if it were free: it transfers real value from existing shareholders, and the dilution is the cash-equivalent cost.', 'وصف المدفوعات على أساس الأسهم بأنها غير نقدية وإضافتها كأنها مجانية: فهي تنقل قيمة حقيقية من المساهمين الحاليين، والتخفيف هو الكلفة المكافئة نقداً.'),
    Bi('Expecting the expense to disappear when options end up worthless: for market conditions the grant-date fair value stands regardless of outcome.', 'توقع اختفاء المصروف حين تنتهي الخيارات بلا قيمة: ففي الشروط السوقية تبقى القيمة العادلة في تاريخ المنح بصرف النظر عن النتيجة.'),
    Bi('Comparing EPS across companies with very different equity compensation without looking at diluted figures and the outstanding award tables.', 'مقارنة ربحية السهم بين شركات تختلف كثيراً في التعويض السهمي دون النظر إلى الأرقام المخففة وجداول المنح القائمة.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IFRS 2',
      note: Bi('Share-based payment: grant-date fair value, vesting conditions, and equity-settled versus cash-settled treatment.', 'المدفوعات على أساس الأسهم: القيمة العادلة في تاريخ المنح وشروط الاستحقاق والمعالجة بالأسهم مقابل النقد.'),
      segments: [
        KBStandardSegment('IFRS 2', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ifrs-2-share-based-payment/'),
      ],
    ),
    KBStandardRef(
      standard: 'IAS 33',
      note: Bi('Earnings per share: the treasury stock method that turns outstanding options into diluted shares.', 'ربحية السهم: طريقة أسهم الخزينة التي تحول الخيارات القائمة إلى أسهم مخففة.'),
      segments: [
        KBStandardSegment('IAS 33', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-33-earnings-per-share/'),
      ],
    ),
    KBStandardRef(
      standard: 'IAS 24',
      note: Bi('Related party disclosures: key management compensation, including the share-based element.', 'إفصاحات الأطراف ذات العلاقة: تعويضات الإدارة العليا بما فيها العنصر السهمي.'),
      segments: [
        KBStandardSegment('IAS 24', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-24-related-party-disclosures/'),
      ],
    ),
  ],
  relatedTerms: [
    'Stock Options',
    'RSUs (Restricted Stock Units)',
    'Stock-based Compensation',
    'Diluted EPS',
    'Basic EPS',
    'Share Count',
    'Treasury Stock',
  ],
  relatedModules: [
    KBRelatedModule('/education/fundamentals', Bi('Module: Financial Management Primer (Financing pillar)', 'الوحدة: تمهيد الإدارة المالية (ركيزة التمويل)')),
    KBRelatedModule('/education/financial-analysis', Bi('Module: Analysis of Financial Statements', 'الوحدة: تحليل القوائم المالية')),
  ],
  relatedArticles: [
    'equity-and-oci',
    'dividend-policy',
    'income-statement',
    'capital-structure',
    'valuation-multiples',
  ],
  references: [
    'IFRS Foundation. (2004). IFRS 2 Share-based Payment. IFRS Foundation.',
    'Black, F., & Scholes, M. (1973). The pricing of options and corporate liabilities. Journal of Political Economy, 81(3), 637-654.',
    'Brealey, R. A., Myers, S. C., & Allen, F. (2020). Principles of corporate finance (13th ed.). McGraw-Hill.',
  ],
  keywords: [
    'share-based payment',
    'IFRS 2',
    'stock options',
    'RSU',
    'vesting',
    'grant-date fair value',
    'dilution',
    'treasury stock method',
    'المدفوعات على أساس الأسهم',
    'خيارات الأسهم',
    'الاستحقاق',
    'التخفيف',
  ],
);
