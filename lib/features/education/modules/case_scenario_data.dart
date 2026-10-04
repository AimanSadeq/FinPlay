/// Data model + content for the Case Scenario Simulator — multi-step branching
/// role-play decision cases used by several government-education modules on the
/// website (modules 4, 6, 7, 9, 10). Each scenario walks the learner through a
/// sequence of typed steps (analysis / decision / recommendation / stakeholder);
/// every step offers options carrying correctness, feedback and a consequence,
/// and the run is scored out of 100.
///
/// Bilingual: every user-facing English field has an optional Arabic counterpart
/// (`…Ar`) plus a `…For(bool ar)` getter that returns Arabic when active and
/// falls back to English when no translation is supplied.
library;

enum CaseStepType { analysis, decision, recommendation, stakeholder }

class CaseOption {
  final String text;
  final String? textAr;
  final bool isCorrect;
  final String feedback;
  final String? feedbackAr;
  final String? consequence;
  final String? consequenceAr;
  const CaseOption(
    this.text, {
    this.textAr,
    this.isCorrect = false,
    required this.feedback,
    this.feedbackAr,
    this.consequence,
    this.consequenceAr,
  });

  String textFor(bool ar) => ar && textAr != null ? textAr! : text;
  String feedbackFor(bool ar) => ar && feedbackAr != null ? feedbackAr! : feedback;
  String? consequenceFor(bool ar) =>
      ar && consequenceAr != null ? consequenceAr! : consequence;
}

class CaseStep {
  final CaseStepType type;
  final String prompt;
  final String? promptAr;
  final List<CaseOption> options;
  const CaseStep({
    required this.type,
    required this.prompt,
    this.promptAr,
    required this.options,
  });

  String promptFor(bool ar) => ar && promptAr != null ? promptAr! : prompt;
}

class CaseScenario {
  final String id;
  final String title;
  final String? titleAr;
  final String role;
  final String? roleAr;
  final String overview;
  final String? overviewAr;
  final List<CaseStep> steps;
  const CaseScenario({
    required this.id,
    required this.title,
    this.titleAr,
    required this.role,
    this.roleAr,
    required this.overview,
    this.overviewAr,
    required this.steps,
  });

  String titleFor(bool ar) => ar && titleAr != null ? titleAr! : title;
  String roleFor(bool ar) => ar && roleAr != null ? roleAr! : role;
  String overviewFor(bool ar) => ar && overviewAr != null ? overviewAr! : overview;
}

/// Scenarios keyed by Flutter module id. Modules without an entry fall back to
/// the Statement Builder activity on their "Sim" tab.
const Map<int, List<CaseScenario>> caseScenariosByModule = {
  // ── Module 4 — Analysis of Financial Statements ────────────────────────────
  4: [
    CaseScenario(
      id: 'liquidity-crisis',
      title: 'Liquidity Crisis Assessment',
      titleAr: 'تقييم أزمة السيولة',
      role: 'You are the financial analyst reviewing a struggling entity.',
      roleAr: 'أنت المحلل المالي الذي يراجع جهة تواجه صعوبات.',
      overview:
          'A public entity reports rising revenue but its current ratio fell '
          'from 1.8 to 0.9 in one year, and suppliers are demanding cash up front.',
      overviewAr:
          'تُسجّل جهة عامة ارتفاعًا في الإيرادات، لكن نسبة التداول لديها انخفضت '
          'من 1.8 إلى 0.9 خلال عام واحد، والموردون يطالبون بالدفع نقدًا مقدمًا.',
      steps: [
        CaseStep(
          type: CaseStepType.analysis,
          prompt: 'Which ratio best confirms the short-term solvency problem?',
          promptAr: 'أي نسبة تؤكد على أفضل وجه مشكلة الملاءة قصيرة الأجل؟',
          options: [
            CaseOption('Current ratio and quick ratio',
                textAr: 'نسبة التداول ونسبة السيولة السريعة',
                isCorrect: true,
                feedback: 'Correct — liquidity ratios directly measure ability to meet short-term obligations.',
                feedbackAr: 'صحيح — تقيس نسب السيولة مباشرةً القدرة على الوفاء بالالتزامات قصيرة الأجل.',
                consequence: 'A quick ratio of 0.5 confirms a severe cash squeeze.',
                consequenceAr: 'نسبة سيولة سريعة قدرها 0.5 تؤكد ضائقة نقدية حادة.'),
            CaseOption('Gross profit margin',
                textAr: 'هامش الربح الإجمالي',
                feedback: 'Profitability is healthy here; the problem is liquidity, not margin.',
                feedbackAr: 'الربحية سليمة هنا؛ فالمشكلة في السيولة وليست في الهامش.'),
            CaseOption('Return on equity',
                textAr: 'العائد على حقوق الملكية',
                feedback: 'ROE measures profitability for owners, not short-term solvency.',
                feedbackAr: 'يقيس العائد على حقوق الملكية الربحية للملاك، وليس الملاءة قصيرة الأجل.'),
          ],
        ),
        CaseStep(
          type: CaseStepType.analysis,
          prompt: 'Revenue is up but cash is down. What likely explains it?',
          promptAr: 'الإيرادات مرتفعة لكن النقد منخفض. ما التفسير الأرجح لذلك؟',
          options: [
            CaseOption('Receivables and inventory are ballooning (poor working-capital management)',
                textAr: 'تضخّم الذمم المدينة والمخزون (سوء إدارة رأس المال العامل)',
                isCorrect: true,
                feedback: 'Right — growth funded by uncollected receivables drains cash despite higher revenue.',
                feedbackAr: 'صحيح — النمو الممول بذمم مدينة غير محصّلة يستنزف النقد رغم ارتفاع الإيرادات.',
                consequence: 'DSO has risen from 35 to 78 days.',
                consequenceAr: 'ارتفع متوسط فترة التحصيل من 35 إلى 78 يومًا.'),
            CaseOption('The entity is too profitable',
                textAr: 'الجهة مربحة أكثر من اللازم',
                feedback: 'Profit does not equal cash; this misreads the symptom.',
                feedbackAr: 'الربح لا يعادل النقد؛ هذه قراءة خاطئة للعَرَض.'),
          ],
        ),
        CaseStep(
          type: CaseStepType.recommendation,
          prompt: 'What is your primary recommendation?',
          promptAr: 'ما توصيتك الأساسية؟',
          options: [
            CaseOption('Tighten collections and inventory, and arrange short-term financing',
                textAr: 'إحكام التحصيل وإدارة المخزون، وترتيب تمويل قصير الأجل',
                isCorrect: true,
                feedback: 'Exactly — fix the working-capital cycle and bridge the gap.',
                feedbackAr: 'تمامًا — أصلِح دورة رأس المال العامل وسُدّ الفجوة.'),
            CaseOption('Increase sales further on credit',
                textAr: 'زيادة المبيعات بالأجل أكثر',
                feedback: 'That deepens the receivables problem and worsens cash.',
                feedbackAr: 'هذا يعمّق مشكلة الذمم المدينة ويزيد وضع النقد سوءًا.'),
          ],
        ),
      ],
    ),
  ],

  // ── Module 7 — IFRS vs IPSAS Standards ─────────────────────────────────────
  7: [
    CaseScenario(
      id: 'revenue-recognition',
      title: 'Revenue Recognition: IFRS 15 vs IPSAS 23',
      titleAr: 'الاعتراف بالإيراد: IFRS 15 مقابل IPSAS 23',
      role: 'You advise a government body on accounting treatment.',
      roleAr: 'أنت تقدّم المشورة لجهة حكومية بشأن المعالجة المحاسبية.',
      overview:
          'The entity receives a SAR 10m grant with conditions, and separately '
          'earns SAR 4m selling services to the public. How should each be recognised?',
      overviewAr:
          'تتلقى الجهة منحة بقيمة 10 ملايين ريال مشروطة، وتحقّق بشكل منفصل '
          '4 ملايين ريال من بيع خدمات للجمهور. كيف يُعترف بكلٍّ منهما؟',
      steps: [
        CaseStep(
          type: CaseStepType.analysis,
          prompt: 'The SAR 4m service revenue is an exchange transaction. Which standard governs it?',
          promptAr: 'إيراد الخدمات البالغ 4 ملايين ريال هو معاملة تبادلية. أي معيار يحكمه؟',
          options: [
            CaseOption('IFRS 15 — revenue from contracts with customers',
                textAr: 'IFRS 15 — الإيراد من العقود مع العملاء',
                isCorrect: true,
                feedback: 'Correct — exchange transactions follow the IFRS 15 five-step model.',
                feedbackAr: 'صحيح — تتبع المعاملات التبادلية نموذج الخطوات الخمس في IFRS 15.',
                consequence: 'Revenue is recognised as performance obligations are satisfied.',
                consequenceAr: 'يُعترف بالإيراد عند الوفاء بالتزامات الأداء.'),
            CaseOption('IPSAS 23 — non-exchange revenue',
                textAr: 'IPSAS 23 — الإيراد غير التبادلي',
                feedback: 'IPSAS 23 covers non-exchange (taxes, grants), not service sales.',
                feedbackAr: 'يغطي IPSAS 23 المعاملات غير التبادلية (الضرائب والمنح)، لا بيع الخدمات.'),
          ],
        ),
        CaseStep(
          type: CaseStepType.decision,
          prompt: 'The SAR 10m conditional grant is a non-exchange transaction. When is it recognised as revenue?',
          promptAr: 'المنحة المشروطة البالغة 10 ملايين ريال هي معاملة غير تبادلية. متى يُعترف بها كإيراد؟',
          options: [
            CaseOption('As the conditions are satisfied (a liability until then)',
                textAr: 'عند استيفاء الشروط (وتُعد التزامًا حتى ذلك الحين)',
                isCorrect: true,
                feedback: 'Right — under IPSAS 23 a condition creates a present obligation; revenue follows fulfilment.',
                feedbackAr: 'صحيح — بموجب IPSAS 23 ينشئ الشرط التزامًا حاليًا؛ ويتبع الاعتراف بالإيراد الوفاءَ به.',
                consequence: 'Initially recorded as deferred revenue (liability).',
                consequenceAr: 'يُسجَّل مبدئيًا كإيراد مؤجل (التزام).'),
            CaseOption('Immediately in full on receipt',
                textAr: 'بالكامل وفور الاستلام',
                feedback: 'Conditions mean it cannot all be recognised up front.',
                feedbackAr: 'وجود الشروط يعني تعذّر الاعتراف به بالكامل مقدمًا.'),
            CaseOption('Never — grants are equity',
                textAr: 'لا يُعترف به أبدًا — فالمنح تُعد حقوق ملكية',
                feedback: 'Conditional grants are revenue once conditions are met, not equity.',
                feedbackAr: 'المنح المشروطة تُعد إيرادًا عند استيفاء الشروط، وليست حقوق ملكية.'),
          ],
        ),
        CaseStep(
          type: CaseStepType.recommendation,
          prompt: 'How do you summarise the treatment to the finance committee?',
          promptAr: 'كيف تلخّص المعالجة للجنة المالية؟',
          options: [
            CaseOption('Service sales under IFRS 15 as earned; grant under IPSAS 23 as conditions are met',
                textAr: 'بيع الخدمات وفق IFRS 15 عند تحققه؛ والمنحة وفق IPSAS 23 عند استيفاء الشروط',
                isCorrect: true,
                feedback: 'Exactly — applying the right standard to each transaction type is the key takeaway.',
                feedbackAr: 'تمامًا — تطبيق المعيار الصحيح على كل نوع من المعاملات هو الخلاصة الأساسية.'),
            CaseOption('Recognise everything on a cash basis',
                textAr: 'الاعتراف بكل شيء على الأساس النقدي',
                feedback: 'Cash-basis ignores the accrual principles both standards require.',
                feedbackAr: 'الأساس النقدي يتجاهل مبادئ الاستحقاق التي يتطلبها المعياران.'),
          ],
        ),
      ],
    ),
  ],

  // ── Module 6 — Budgeting & Financial Planning ──────────────────────────────
  6: [
    CaseScenario(
      id: 'budget-variance',
      title: 'The Q3 Budget Overrun',
      titleAr: 'تجاوز الموازنة في الربع الثالث',
      role: 'You are the finance manager of a municipal department.',
      roleAr: 'أنت المدير المالي لإدارة بلدية.',
      overview:
          'Three months into the fiscal year, actual spending is running 18% '
          'above the approved budget while service output is unchanged. The '
          'council wants answers before the next quarter is funded.',
      overviewAr:
          'بعد ثلاثة أشهر من بداية السنة المالية، يتجاوز الإنفاق الفعلي الموازنة '
          'المعتمدة بنسبة 18% بينما مستوى الخدمات لم يتغير. ويريد المجلس إجابات '
          'قبل تمويل الربع التالي.',
      steps: [
        CaseStep(
          type: CaseStepType.analysis,
          prompt: 'The overrun is concentrated in one line. What do you examine first?',
          promptAr: 'يتركّز التجاوز في بند واحد. ماذا تفحص أولًا؟',
          options: [
            CaseOption('Compare actuals vs budget line-by-line (variance analysis)',
                textAr: 'مقارنة الفعلي بالموازنة بندًا بندًا (تحليل الانحرافات)',
                isCorrect: true,
                feedback: 'Correct — variance analysis isolates where and why the gap arose before you act.',
                feedbackAr: 'صحيح — يحدد تحليل الانحرافات أين ولماذا نشأت الفجوة قبل أن تتصرّف.',
                consequence: 'You discover overtime in operations is the main driver.',
                consequenceAr: 'تكتشف أن العمل الإضافي في التشغيل هو المحرّك الرئيسي.'),
            CaseOption('Cut every line proportionally by 18%',
                textAr: 'خفض كل بند بنسبة 18% بالتناسب',
                feedback: 'Across-the-board cuts ignore the root cause and can damage essential services.',
                feedbackAr: 'التخفيضات الشاملة تتجاهل السبب الجذري وقد تضرّ بالخدمات الأساسية.'),
            CaseOption('Request more budget immediately',
                textAr: 'طلب موازنة إضافية على الفور',
                feedback: 'Asking for funds before understanding the cause undermines credibility.',
                feedbackAr: 'طلب الأموال قبل فهم السبب يقوّض المصداقية.'),
          ],
        ),
        CaseStep(
          type: CaseStepType.decision,
          prompt: 'Overtime is up because two vacancies were never filled. What is the disciplined response?',
          promptAr: 'ارتفع العمل الإضافي لعدم شغل وظيفتين شاغرتين. ما الاستجابة المنضبطة؟',
          options: [
            CaseOption('Reforecast the year and fast-track recruitment to cut overtime',
                textAr: 'إعادة توقّع نتائج العام وتسريع التوظيف لخفض العمل الإضافي',
                isCorrect: true,
                feedback: 'Right — a reforecast plus addressing the structural cause restores control.',
                feedbackAr: 'صحيح — إعادة التوقّع مع معالجة السبب الهيكلي يعيدان السيطرة.',
                consequence: 'Projected full-year overrun falls from 18% to 4%.',
                consequenceAr: 'ينخفض التجاوز المتوقّع للعام كاملًا من 18% إلى 4%.'),
            CaseOption('Keep paying overtime — it is cheaper than salaries',
                textAr: 'الاستمرار في دفع العمل الإضافي — فهو أرخص من الرواتب',
                feedback: 'Sustained overtime usually costs more and risks burnout and errors.',
                feedbackAr: 'العمل الإضافي المستمر يكلّف عادةً أكثر ويزيد مخاطر الإنهاك والأخطاء.'),
            CaseOption('Freeze all spending including safety-critical items',
                textAr: 'تجميد كل الإنفاق بما فيه البنود الحرجة للسلامة',
                feedback: 'Blanket freezes create new risks and rarely survive scrutiny.',
                feedbackAr: 'التجميد الشامل ينشئ مخاطر جديدة ونادرًا ما يصمد أمام التدقيق.'),
          ],
        ),
        CaseStep(
          type: CaseStepType.recommendation,
          prompt: 'What do you recommend to the council?',
          promptAr: 'بماذا توصي المجلس؟',
          options: [
            CaseOption('A revised forecast, the variance explanation, and a corrective plan',
                textAr: 'توقّع منقّح، وتفسير الانحراف، وخطة تصحيحية',
                isCorrect: true,
                feedback: 'Exactly — transparency plus a credible plan is what governance bodies need.',
                feedbackAr: 'تمامًا — الشفافية مع خطة ذات مصداقية هو ما تحتاجه أجهزة الحوكمة.'),
            CaseOption('Assure them everything is fine',
                textAr: 'طمأنتهم بأن كل شيء على ما يرام',
                feedback: 'Downplaying a real variance erodes trust when results come in.',
                feedbackAr: 'التهوين من انحراف حقيقي يُضعِف الثقة عند ظهور النتائج.'),
          ],
        ),
      ],
    ),
  ],

  // ── Module 9 — Compliance & Internal Controls ──────────────────────────────
  9: [
    CaseScenario(
      id: 'segregation-of-duties',
      title: 'One Person, Every Key',
      titleAr: 'شخص واحد بكل الصلاحيات',
      role: 'You are the new internal controls lead.',
      roleAr: 'أنت المسؤول الجديد عن الرقابة الداخلية.',
      overview:
          'You find that a single accounts-payable clerk can create a vendor, '
          'approve an invoice, and release the payment — with no second review. '
          'No fraud has been detected yet.',
      overviewAr:
          'تكتشف أن موظف حسابات دائنة واحدًا يمكنه إنشاء مورّد واعتماد فاتورة '
          'وإصدار الدفعة — دون مراجعة ثانية. ولم يُكتشف أي احتيال حتى الآن.',
      steps: [
        CaseStep(
          type: CaseStepType.analysis,
          prompt: 'Which control principle is being violated?',
          promptAr: 'أي مبدأ رقابي يجري انتهاكه؟',
          options: [
            CaseOption('Segregation of duties',
                textAr: 'الفصل بين المهام',
                isCorrect: true,
                feedback: 'Correct — no one person should control a whole transaction end-to-end.',
                feedbackAr: 'صحيح — لا ينبغي لشخص واحد أن يتحكم في معاملة كاملة من بدايتها إلى نهايتها.',
                consequence: 'You map every step the clerk can perform alone.',
                consequenceAr: 'تقوم بحصر كل خطوة يستطيع الموظف تنفيذها بمفرده.'),
            CaseOption('Mandatory vacation',
                textAr: 'الإجازة الإلزامية',
                feedback: 'A useful detective control, but not the core issue here.',
                feedbackAr: 'ضابط كشفي مفيد، لكنه ليس جوهر المشكلة هنا.'),
            CaseOption('Physical security',
                textAr: 'الأمن المادي',
                feedback: 'Not the gap — the risk is process authority, not physical access.',
                feedbackAr: 'ليست هذه الثغرة — فالمخاطرة في صلاحية الإجراءات وليست في الوصول المادي.'),
          ],
        ),
        CaseStep(
          type: CaseStepType.decision,
          prompt: 'How do you remediate without halting payments?',
          promptAr: 'كيف تعالج الوضع دون إيقاف المدفوعات؟',
          options: [
            CaseOption('Split the duties so approval and payment release sit with different staff',
                textAr: 'فصل المهام بحيث يكون الاعتماد وإصدار الدفع لدى موظفين مختلفين',
                isCorrect: true,
                feedback: 'Right — separating authorisation, recording and custody is the fix.',
                feedbackAr: 'صحيح — الفصل بين التفويض والتسجيل والعهدة هو الحل.',
                consequence: 'A second approver is added to the payment workflow.',
                consequenceAr: 'يُضاف معتمِد ثانٍ إلى مسار اعتماد المدفوعات.'),
            CaseOption('Trust the clerk — they have a clean record',
                textAr: 'الوثوق بالموظف — فسجلّه نظيف',
                feedback: 'Controls protect good people too; trust is not a control.',
                feedbackAr: 'الضوابط تحمي النزهاء أيضًا؛ والثقة ليست ضابطًا رقابيًا.'),
            CaseOption('Audit every past payment before changing anything',
                textAr: 'تدقيق كل المدفوعات السابقة قبل تغيير أي شيء',
                feedback: 'Worthwhile later, but it leaves the open exposure in place now.',
                feedbackAr: 'مفيد لاحقًا، لكنه يُبقي التعرّض القائم على حاله الآن.'),
          ],
        ),
        CaseStep(
          type: CaseStepType.stakeholder,
          prompt: 'The clerk feels accused. How do you frame the change?',
          promptAr: 'يشعر الموظف بأنه متهم. كيف تطرح التغيير؟',
          options: [
            CaseOption('Explain it is a standard control that protects staff and the organisation',
                textAr: 'توضيح أنه ضابط رقابي معياري يحمي الموظفين والمنشأة',
                isCorrect: true,
                feedback: 'Well handled — framing controls as protection, not blame, sustains buy-in.',
                feedbackAr: 'تعامل سليم — تقديم الضوابط كحماية لا كاتهام يحافظ على القبول.'),
            CaseOption('Tell them it is none of their concern',
                textAr: 'إخباره بأن الأمر لا يعنيه',
                feedback: 'Dismissiveness breeds resistance to the very controls you need.',
                feedbackAr: 'الاستخفاف يولّد مقاومة للضوابط ذاتها التي تحتاجها.'),
          ],
        ),
      ],
    ),
  ],

  // ── Module 10 — Financial Auditing & Review ────────────────────────────────
  10: [
    CaseScenario(
      id: 'audit-evidence',
      title: 'The Unsupported Balance',
      titleAr: 'الرصيد غير المؤيَّد بأدلة',
      role: 'You are leading the annual financial-statement audit.',
      roleAr: 'أنت تقود التدقيق السنوي للقوائم المالية.',
      overview:
          'A SAR 2.4m "other receivables" balance has no supporting schedule, '
          'and management asks you to "just rely on last year".',
      overviewAr:
          'رصيد "ذمم مدينة أخرى" بقيمة 2.4 مليون ريال لا يوجد له جدول مؤيِّد، '
          'وتطلب منك الإدارة "الاكتفاء بالاعتماد على العام الماضي".',
      steps: [
        CaseStep(
          type: CaseStepType.analysis,
          prompt: 'What is the audit issue?',
          promptAr: 'ما المشكلة التدقيقية هنا؟',
          options: [
            CaseOption('Insufficient appropriate audit evidence for the assertion',
                textAr: 'عدم كفاية أدلة التدقيق المناسبة لدعم الإقرار',
                isCorrect: true,
                feedback: 'Correct — an unsupported material balance fails the evidence test.',
                feedbackAr: 'صحيح — الرصيد الجوهري غير المؤيَّد لا يجتاز اختبار الأدلة.',
                consequence: 'You flag it as a potential scope limitation.',
                consequenceAr: 'تُحدّده كقيد محتمل على نطاق التدقيق.'),
            CaseOption('Nothing — prior-year reliance is always fine',
                textAr: 'لا شيء — الاعتماد على العام السابق مقبول دائمًا',
                feedback: 'Each period needs current evidence; prior reliance is not a substitute.',
                feedbackAr: 'كل فترة تتطلب أدلة حالية؛ والاعتماد على السابق ليس بديلًا.'),
            CaseOption('A presentation/disclosure formatting issue',
                textAr: 'مسألة شكلية في العرض/الإفصاح',
                feedback: 'The problem is substance (evidence), not formatting.',
                feedbackAr: 'المشكلة في الجوهر (الأدلة) وليست في الشكل.'),
          ],
        ),
        CaseStep(
          type: CaseStepType.decision,
          prompt: 'Management will not produce a breakdown. What do you do?',
          promptAr: 'ترفض الإدارة تقديم تفصيل للرصيد. ماذا تفعل؟',
          options: [
            CaseOption('Perform alternative procedures; if still unsupported, consider a qualified opinion',
                textAr: 'تنفيذ إجراءات بديلة؛ وإن بقي غير مؤيَّد، النظر في إبداء رأي متحفظ',
                isCorrect: true,
                feedback: 'Right — exhaust procedures, then let the evidence drive the opinion.',
                feedbackAr: 'صحيح — استنفِد الإجراءات، ثم دع الأدلة تحدّد الرأي.',
                consequence: 'Alternative testing recovers SAR 1.1m; SAR 1.3m remains unsupported.',
                consequenceAr: 'تستردّ الإجراءات البديلة 1.1 مليون ريال؛ ويبقى 1.3 مليون ريال غير مؤيَّد.'),
            CaseOption('Sign an unqualified opinion to keep the client happy',
                textAr: 'التوقيع على رأي غير متحفظ لإرضاء العميل',
                feedback: 'That sacrifices independence and integrity — never acceptable.',
                feedbackAr: 'هذا يضحّي بالاستقلالية والنزاهة — وغير مقبول إطلاقًا.'),
            CaseOption('Resign immediately',
                textAr: 'الانسحاب فورًا',
                feedback: 'Premature — procedures and communication come first.',
                feedbackAr: 'سابق لأوانه — الإجراءات والتواصل تأتي أولًا.'),
          ],
        ),
        CaseStep(
          type: CaseStepType.recommendation,
          prompt: 'What do you communicate to those charged with governance?',
          promptAr: 'بماذا تبلّغ المكلّفين بالحوكمة؟',
          options: [
            CaseOption('The evidence gap, its effect on the opinion, and the required adjustment',
                textAr: 'فجوة الأدلة، وأثرها على الرأي، والتسوية المطلوبة',
                isCorrect: true,
                feedback: 'Exactly — clear, evidence-based communication is the auditor\'s duty.',
                feedbackAr: 'تمامًا — التواصل الواضح المستند إلى الأدلة هو واجب المدقّق.'),
            CaseOption('Nothing until the report is issued',
                textAr: 'لا شيء حتى صدور التقرير',
                feedback: 'Governance must be informed of significant findings during the audit.',
                feedbackAr: 'يجب إبلاغ الحوكمة بالملاحظات الجوهرية أثناء التدقيق.'),
          ],
        ),
      ],
    ),
  ],
};
