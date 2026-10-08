/// The facilitator Delivery Checklist content (website DeliveryChecklist.tsx, e39465e,
/// 39840d9, c3aac4a): the corporate run-of-show and the DBA research-cohort variant.
///
/// The English is copied verbatim from the website. The website is English-only; the
/// Arabic here was written for the app and should be reviewed by a native speaker.
/// Item ids are the website's, so ticks mean the same item on both.
library;

class ChecklistItem {
  final String id;
  final String titleEn;
  final String titleAr;
  final String detailEn;
  final String detailAr;
  const ChecklistItem(this.id, this.titleEn, this.titleAr, this.detailEn, this.detailAr);
}

class ChecklistSection {
  final String headingEn;
  final String headingAr;
  final String timingEn;
  final String timingAr;
  final List<ChecklistItem> items;
  const ChecklistSection(this.headingEn, this.headingAr, this.timingEn, this.timingAr, this.items);
}

enum ChecklistVariant { corporate, dba }

/// Separate stored ticks per variant, as on the website (same key names).
const Map<ChecklistVariant, String> checklistStorageKey = {
  ChecklistVariant.corporate: 'facilitatorDeliveryChecklist.v1',
  ChecklistVariant.dba: 'facilitatorDeliveryChecklist.dba.v1',
};

List<ChecklistSection> checklistSections(ChecklistVariant v) =>
    v == ChecklistVariant.dba ? dbaSections : corporateSections;

List<(String, String)> checklistRules(ChecklistVariant v) =>
    v == ChecklistVariant.dba ? dbaRules : corporateRules;

int checklistItemCount(ChecklistVariant v) =>
    checklistSections(v).fold(0, (n, s) => n + s.items.length);

const List<ChecklistSection> corporateSections = [
  ChecklistSection('0 · The day before', '0 · اليوم السابق', '15 min, from your desk', '15 دقيقة، من مكتبك', [
    ChecklistItem(
      'd1',
      'Open the Session Setup Wizard',
      'افتح معالج إعداد الجلسة',
      'Facilitator panel → purple Session Setup Wizard button (or /facilitator/setup). Nine-step pre-flight; every step verifies against the live system, so green means actually ready.',
      'لوحة الميسّر ← زر معالج إعداد الجلسة (أو ‎/facilitator/setup‎). فحص مسبق من تسع خطوات؛ كل خطوة تتحقّق من النظام الحي، فاللون الأخضر يعني الجاهزية فعلًا.',
    ),
    ChecklistItem(
      'd2',
      'Provision a cohort for this group',
      'أنشئ مجموعة لهذه الفئة',
      'Create a cohort with a short subdomain (client name + date). The subdomain is permanent - the group name can be renamed later, the address cannot. Set the DBA study switch on the create form: OFF for a commercial delivery, ON only for a research site. Copy the cohort URL - that URL is what you and the participants use all day. One cohort per client group, always.',
      'أنشئ مجموعة بنطاق فرعي قصير (اسم العميل + التاريخ). النطاق الفرعي دائم - يمكن تغيير اسم المجموعة لاحقًا أما العنوان فلا. اضبط مفتاح دراسة الدكتوراه في نموذج الإنشاء: متوقّف للتقديم التجاري، ومفعّل لموقع البحث فقط. انسخ رابط المجموعة - هذا الرابط هو ما تستخدمه أنت والمشاركون طوال اليوم. مجموعة واحدة لكل فئة عميل، دائمًا.',
    ),
    ChecklistItem(
      'd3',
      'Run Fresh Start',
      'شغّل البداية الجديدة',
      'Full reset on the Fresh Start step, with the facilitator password. Decisions are archived, never destroyed. Verify after: Round 1 · Financing, zero decisions, zero shocks, zero leaders - all green. Note a reset is not an empty cohort: financial statements, the leaderboard and round saves survive it. For a genuinely clean start - a rehearsal, or a cohort created by mistake - delete the cohort and provision a new one.',
      'إعادة ضبط كاملة في خطوة البداية الجديدة بكلمة مرور الميسّر. تُؤرشف القرارات ولا تُتلف أبدًا. تحقّق بعدها: الجولة 1 · التمويل، صفر قرارات، صفر صدمات، صفر قادة - كلها خضراء. لاحظ أن إعادة الضبط لا تعني مجموعة فارغة: القوائم المالية ولوحة المتصدّرين وحفظ الجولات تبقى. لبداية نظيفة حقًا - بروفة أو مجموعة أُنشئت بالخطأ - احذف المجموعة وأنشئ أخرى جديدة.',
    ),
    ChecklistItem(
      'd4',
      'Model integrity, modules, assessments, timer',
      'سلامة النموذج والوحدات والتقييمات والمؤقّت',
      'Model step: Sales Growth 0.10 in green (if not, stop and escalate). Keep Member recommendations ON. Module timer 15-20 minutes. Mandate the pre-assessment - commercial cohorts only; in a research cohort that control is disabled and says why.',
      'خطوة النموذج: نمو المبيعات 0.10 باللون الأخضر (وإلا فتوقّف وصعّد الأمر). أبقِ توصيات الأعضاء مفعّلة. مؤقّت الوحدة 15-20 دقيقة. اجعل التقييم القبلي إلزاميًا - في المجموعات التجارية فقط؛ ففي مجموعة البحث يكون هذا الخيار معطّلًا ويوضّح السبب.',
    ),
    ChecklistItem(
      'd5',
      'Stop at the Ready step',
      'توقّف عند خطوة الجاهزية',
      'Do NOT press Start Game - that happens live in the room. The wizard remembers everything overnight.',
      'لا تضغط "بدء اللعبة" - فهذا يحدث مباشرة في القاعة. يتذكّر المعالج كل شيء حتى اليوم التالي.',
    ),
  ]),
  ChecklistSection('1 · Opening the room', '1 · افتتاح القاعة', '30 min', '30 دقيقة', [
    ChecklistItem(
      'o1',
      'Welcome & framing (10 min)',
      'الترحيب والتمهيد (10 دقائق)',
      'Three business years; financing, investing, operating each year; a real financial engine turns choices into IFRS statements live. No scripted outcomes - challenge the numbers.',
      'ثلاث سنوات عمل؛ تمويل واستثمار وتشغيل في كل سنة؛ ومحرّك مالي حقيقي يحوّل الخيارات إلى قوائم وفق IFRS مباشرة. لا نتائج معدّة مسبقًا - ناقشوا الأرقام.',
    ),
    ChecklistItem(
      'o2',
      'Pre-assessment, OR research consent (10 min)',
      'التقييم القبلي، أو موافقة البحث (10 دقائق)',
      'One or the other, never both - the cohort is either a commercial delivery or a research site. COMMERCIAL: pre-assessment, 25 MCQs, ~10 min, the "before" photo; the platform holds participants until done if mandated. RESEARCH: the ethics-approved consent screen, and the course assessments do not run at all. Consent is voluntary and separate from the training; never tell a room to complete it.',
      'أحدهما فقط وليس كليهما - فالمجموعة إمّا تقديم تجاري أو موقع بحث. التجاري: التقييم القبلي، 25 سؤال اختيار من متعدد، نحو 10 دقائق، وهو صورة "ما قبل"؛ وتُبقي المنصة المشاركين حتى ينتهوا إن كان إلزاميًا. البحثي: شاشة الموافقة المعتمدة أخلاقيًا، ولا تُجرى تقييمات الدورة إطلاقًا. الموافقة طوعية ومنفصلة عن التدريب؛ لا تطلب من القاعة إكمالها أبدًا.',
    ),
    ChecklistItem(
      'o3',
      'Teams join the lobby (10 min)',
      'انضمام الفرق إلى الردهة (10 دقائق)',
      'Project the cohort URL + /lobby. Roles: CFO, Treasurer, Risk Officer, Analyst (extras join as Analysts). Each team picks its leader in the app. Teams of 3-5; with 25 people run 6-7 teams.',
      'اعرض رابط المجموعة مع ‎/lobby‎. الأدوار: المدير المالي، أمين الخزينة، مسؤول المخاطر، المحلّل (ينضمّ الأعضاء الإضافيون كمحلّلين). يختار كل فريق قائده في التطبيق. الفرق من 3 إلى 5؛ ومع 25 شخصًا شغّل 6-7 فرق.',
    ),
    ChecklistItem(
      'o4',
      'Press Start Game',
      'اضغط "بدء اللعبة"',
      'From the Ready step or the panel. Timer starts; teams land in Round 1 · Financing.',
      'من خطوة الجاهزية أو من اللوحة. يبدأ المؤقّت؛ وتنتقل الفرق إلى الجولة 1 · التمويل.',
    ),
  ]),
  ChecklistSection('2 · Round 1 - the teaching round', '2 · الجولة 1 - جولة التعليم', '60-75 min', '60-75 دقيقة', [
    ChecklistItem(
      'r1',
      'Beat 1: everyone recommends, privately',
      'المرحلة 1: الجميع يوصي، بشكل منفرد',
      'Each member commits their own amount before seeing anyone else’s. Non-leaders’ decision buttons are locked by design - only the recommendation box is active for them.',
      'يلتزم كل عضو بالمبلغ الذي يراه قبل أن يرى مبالغ الآخرين. أزرار القرار لغير القادة مقفلة عمدًا - ولا يعمل لديهم إلا مربع التوصية.',
    ),
    ChecklistItem(
      'r2',
      'Beat 2: the leader synthesizes',
      'المرحلة 2: القائد يجمع الآراء',
      'Leader’s cards show the Team Input panel: count, median, range, each member’s amount and rationale. Sign convention: negative = cash out, positive = cash in.',
      'تعرض بطاقات القائد لوحة مدخلات الفريق: العدد، والوسيط، والمدى، ومبلغ كل عضو ومبرّره. اصطلاح الإشارة: السالب = تدفق نقدي خارج، والموجب = تدفق نقدي داخل.',
    ),
    ChecklistItem(
      'r3',
      'Beat 3: preview, then commit',
      'المرحلة 3: المعاينة ثم الالتزام',
      'Live Impact Preview reacts instantly (watch debt-to-equity on loan vs equity - the capital-structure lecture in one number). Leader presses Confirm; decisions lock.',
      'تتفاعل معاينة الأثر المباشر فورًا (راقب نسبة الدين إلى حقوق الملكية بين القرض والأسهم - محاضرة هيكل رأس المال في رقم واحد). يضغط القائد "تأكيد" فتُقفل القرارات.',
    ),
    ChecklistItem(
      'r4',
      'Beat 4: monitor and nudge',
      'المرحلة 4: المتابعة والحثّ',
      'Team overview shows who confirmed. Nudge slow teams; the timer creates healthy pressure. Repeat the four beats for Investing and Operating.',
      'تُظهر نظرة الفرق العامة من أكّد. حثّ الفرق المتأخرة؛ فالمؤقّت يخلق ضغطًا صحيًا. كرّر المراحل الأربع للاستثمار والتشغيل.',
    ),
    ChecklistItem(
      'r5',
      'Beat 5: unlock the move',
      'المرحلة 5: افتح الانتقال',
      'Move to Next Decisions stays dimmed for teams until YOU unlock it (panel → 🔓 Unlock next decisions). Debrief the module, unlock, let teams advance, then re-lock for the next module. Forgetting the unlock stalls the whole room.',
      'يبقى زر "الانتقال إلى القرارات التالية" باهتًا لدى الفرق حتى تفتحه أنت (اللوحة ← 🔓 فتح القرارات التالية). ناقش الوحدة، ثم افتح، ودع الفرق تتقدّم، ثم أعد القفل للوحدة التالية. نسيان الفتح يوقف القاعة كلها.',
    ),
  ]),
  ChecklistSection('3 · The market moment - shock & insurance', '3 · لحظة السوق - الصدمة والتأمين',
      '15 min, during Round 2 financing', '15 دقيقة، أثناء تمويل الجولة 2', [
    ChecklistItem(
      'm1',
      'Publish a market forecast',
      'انشر توقّعًا للسوق',
      'Panel → Market Shocks → Market Forecasts → publish (e.g. Interest Rate Hike). MARKET WIRE appears on every screen; the Hedge Desk quotes an insurance premium.',
      'اللوحة ← صدمات السوق ← توقّعات السوق ← نشر (مثل: رفع أسعار الفائدة). يظهر شريط أخبار السوق على كل شاشة؛ ويعرض مكتب التحوّط قسط التأمين.',
    ),
    ChecklistItem(
      'm2',
      'Let them sweat, then trigger',
      'دعهم يترقّبون، ثم فعّل الصدمة',
      '~5 minutes to buy or refuse insurance, then trigger the shock. Insured teams keep pre-shock terms; the premium hits their P&L either way. Occasionally publish a forecast and never trigger it.',
      'نحو 5 دقائق لشراء التأمين أو رفضه، ثم فعّل الصدمة. تحتفظ الفرق المؤمَّنة بشروط ما قبل الصدمة؛ ويؤثّر القسط في قائمة الدخل في الحالتين. انشر أحيانًا توقّعًا ولا تفعّله أبدًا.',
    ),
    ChecklistItem(
      'm3',
      'Show the difference',
      'اعرض الفرق',
      'Two dashboards side by side - one insured, one not. That difference is the price and payoff of hedging, computed, not asserted.',
      'لوحتان جنبًا إلى جنب - إحداهما مؤمَّنة والأخرى لا. هذا الفرق هو ثمن التحوّط وعائده، محسوبًا لا مُدّعى.',
    ),
  ]),
  ChecklistSection('4 · Debrief after each round', '4 · النقاش الختامي بعد كل جولة', '15 min per round', '15 دقيقة لكل جولة', [
    ChecklistItem(
      'b1',
      'Dashboards & the waterfall',
      'اللوحات ومخطط الشلال',
      'Four statements, the 28-ratio CFA-grouped panel, and the Round Analysis waterfall attributing net income to each decision. Generate AI Debrief if the key is configured.',
      'أربع قوائم، ولوحة النسب الـ28 المجمّعة وفق CFA، ومخطط الشلال في تحليل الجولة الذي ينسب صافي الدخل إلى كل قرار. أنشئ النقاش بالذكاء الاصطناعي إن كان المفتاح مُعدًّا.',
    ),
    ChecklistItem(
      'b2',
      'Facilitate the comparison',
      'أدِر المقارنة',
      'Panel → Insights surfaces teachable contrasts with ready discussion prompts. Show the podium (Profitability, Resilience; Most Improved from Round 2).',
      'اللوحة ← الملاحظات تُبرز تباينات تعليمية مع أسئلة نقاش جاهزة. اعرض منصّة التتويج (الربحية، الصمود؛ والأكثر تحسّنًا من الجولة 2).',
    ),
    ChecklistItem(
      'b3',
      'Advance the round',
      'انتقل إلى الجولة التالية',
      'Rounds 2 and 3 run the same beats faster - budget 40-45 min per round including debrief.',
      'تسير الجولتان 2 و3 بالمراحل نفسها وبوتيرة أسرع - خصّص 40-45 دقيقة لكل جولة بما فيها النقاش.',
    ),
  ]),
  ChecklistSection('5 · Closing the day', '5 · ختام اليوم', '40 min', '40 دقيقة', [
    ChecklistItem(
      'c1',
      'Post-assessment & programme evaluation (20 min)',
      'التقييم البعدي وتقييم البرنامج (20 دقيقة)',
      'Commercial cohort: the "after" photo plus the short evaluation. Research cohort: neither runs here - the study collects its own evaluation anonymously on the separate instrument platform, so display that link instead.',
      'المجموعة التجارية: صورة "ما بعد" مع التقييم القصير. مجموعة البحث: لا يُجرى أيٌّ منهما هنا - فالدراسة تجمع تقييمها الخاص دون أسماء على منصة الأدوات المنفصلة، فاعرض رابطها بدلًا من ذلك.',
    ),
    ChecklistItem(
      'c2',
      'Certificates (10 min)',
      'الشهادات (10 دقائق)',
      'Participants claim personal certificates from the Achievements page - named, verifiable, one-click Add to LinkedIn. Do it in the room; strong closing note.',
      'يستلم المشاركون شهاداتهم الشخصية من صفحة الإنجازات - بالاسم، وقابلة للتحقّق، وتُضاف إلى LinkedIn بنقرة واحدة. افعلوا ذلك في القاعة؛ فهي خاتمة قوية.',
    ),
    ChecklistItem(
      'c3',
      'Final leaderboard & wrap (10 min)',
      'لوحة المتصدّرين النهائية والختام (10 دقائق)',
      'Project the leaderboard and podium. Close on the arc: three years, their own numbers, the frameworks behind them.',
      'اعرض لوحة المتصدّرين ومنصّة التتويج. اختم بالمسار كله: ثلاث سنوات، وأرقامهم هم، والأطر التي تقف خلفها.',
    ),
    ChecklistItem(
      'c4',
      'After the room empties',
      'بعد مغادرة القاعة',
      'Assessments admin → research export (15-sheet workbook), which covers the FinPlay strand only; the anonymous instrument responses are exported separately from that platform. Do NOT reset anything - the cohort keeps the data permanently; the next group gets its own cohort.',
      'إدارة التقييمات ← تصدير البحث (مصنّف من 15 ورقة)، ويغطّي جانب FinPlay فقط؛ أما إجابات الأدوات المجهولة فتُصدَّر منفصلة من تلك المنصة. لا تُعِد ضبط أي شيء - تحتفظ المجموعة بالبيانات بشكل دائم؛ والفئة التالية تحصل على مجموعتها الخاصة.',
    ),
  ]),
];

const List<(String, String)> corporateRules = [
  (
    'Never run Fresh Start or Reset once participants have played - those are between-cohorts operations.',
    'لا تشغّل البداية الجديدة أو إعادة الضبط أبدًا بعد أن يلعب المشاركون - فهذه عمليات تُجرى بين المجموعات.',
  ),
  ('Run each client group in its own cohort.', 'شغّل كل فئة عميل في مجموعتها الخاصة.'),
  (
    'When in doubt, the Setup Wizard’s step statuses tell you the truth about the system.',
    'عند الشك، تخبرك حالات خطوات معالج الإعداد بحقيقة وضع النظام.',
  ),
];

const List<ChecklistSection> dbaSections = [
  ChecklistSection('0 · The week before', '0 · الأسبوع السابق', '1 hour, and not the night before',
      'ساعة واحدة، وليس في الليلة السابقة', [
    ChecklistItem(
      'x1',
      'Ethics approval in hand, consent wording loaded',
      'الموافقة الأخلاقية في يدك، ونص الموافقة محمّل',
      'Assessments tab → the approved consent document, pasted verbatim from the approved PDF and made active. Until it is, consent cannot be collected and nobody is enrolled: the cohort would run with no research at all. This is one document for the whole study, not one per cohort.',
      'تبويب التقييمات ← وثيقة الموافقة المعتمدة، ملصقة حرفيًا من ملف PDF المعتمد ومفعّلة. وإلى أن يتم ذلك لا يمكن جمع الموافقة ولا يُسجَّل أحد: أي ستعمل المجموعة دون أي بحث. هذه وثيقة واحدة للدراسة كلها، وليست واحدة لكل مجموعة.',
    ),
    ChecklistItem(
      'x2',
      'Enrol the cohort',
      'سجّل المجموعة',
      'Cohorts panel → the DBA study switch ON for this group. Confirm the purple badge on its row. This is what turns a commercial delivery into a research site.',
      'لوحة المجموعات ← مفتاح دراسة الدكتوراه مفعّل لهذه المجموعة. تأكّد من الشارة البنفسجية في صفّها. هذا ما يحوّل التقديم التجاري إلى موقع بحث.',
    ),
    ChecklistItem(
      'x3',
      'Confirm the course assessments are off',
      'تأكّد من إيقاف تقييمات الدورة',
      'Assessments tab should now show both mandate switches disabled with a purple note, and the Pre-Assessment, Post-Assessment and Course Survey QR cards unavailable. That is correct and deliberate: an attributed score sitting beside an anonymous instrument response is the linkage the information sheet rules out. If they are still available, the cohort is not enrolled.',
      'يجب أن يُظهر تبويب التقييمات الآن مفتاحي الإلزام معطّلين مع ملاحظة بنفسجية، وبطاقات رموز QR للتقييم القبلي والبعدي واستبيان الدورة غير متاحة. هذا صحيح ومقصود: فوجود درجة منسوبة إلى صاحبها بجانب إجابة مجهولة على أداة البحث هو الربط الذي تستبعده ورقة المعلومات. إن كانت لا تزال متاحة فالمجموعة غير مسجّلة.',
    ),
    ChecklistItem(
      'x4',
      'Instrument platform service, for THIS cohort',
      'خدمة منصة الأدوات، لهذه المجموعة تحديدًا',
      'Its own service, its own COHORT label and PROGRAMME_DAYS. Open its admin page and read the header: it states the cohort, the programme length, and which day carries the cross-programme question. Counts must be zero. A red banner there means the label already holds rows from an earlier day - stop and fix it before anyone opens a link.',
      'خدمة مستقلة، بتسمية COHORT وPROGRAMME_DAYS خاصة بها. افتح صفحة الإدارة واقرأ الترويسة: تذكر المجموعة ومدة البرنامج واليوم الذي يحمل السؤال الشامل للبرنامج. يجب أن تكون الأعداد صفرًا. الشريط الأحمر هناك يعني أن التسمية تحوي صفوفًا من يوم سابق - توقّف وأصلح ذلك قبل أن يفتح أحد أي رابط.',
    ),
    ChecklistItem(
      'x5',
      'Run the post-deploy check',
      'شغّل فحص ما بعد النشر',
      'db/checks/post_deploy_check.sql with the cohort at the top edited to this cohort. All nine checks must read pass. Check 9 asks whether this cohort has rows yet; its detail column lists every cohort in the database, so a live cohort next door reads as information rather than as a failure.',
      'الملف db/checks/post_deploy_check.sql بعد تعديل المجموعة في أعلاه إلى هذه المجموعة. يجب أن تنجح الفحوص التسعة كلها. الفحص 9 يسأل هل لدى هذه المجموعة صفوف بعد؛ ويسرد عمود التفاصيل كل مجموعة في قاعدة البيانات، فتظهر مجموعة نشطة مجاورة كمعلومة لا كإخفاق.',
    ),
    ChecklistItem(
      'x6',
      'Information sheet QR, and the paper fallback',
      'رمز QR لورقة المعلومات، والبديل الورقي',
      'QR Codes tab → set the Info Sheet slot to the study information sheet. Then print the paper pack: if the venue network fails there is no second chance at a day of collection.',
      'تبويب رموز QR ← اضبط خانة ورقة المعلومات على ورقة معلومات الدراسة. ثم اطبع الحزمة الورقية: فإن تعطّلت شبكة المكان فلا فرصة ثانية ليوم جمع البيانات.',
    ),
  ]),
  ChecklistSection('1 · The day before', '1 · اليوم السابق', '15 min, from your desk', '15 دقيقة، من مكتبك', [
    ChecklistItem(
      'x7',
      'Setup wizard, model, timer',
      'معالج الإعداد والنموذج والمؤقّت',
      'Exactly as the corporate list: wizard to the Ready step, Sales Growth 0.10 in green, Member recommendations ON, module timer 15-20 minutes. Do not press Start Game.',
      'تمامًا كقائمة الشركات: المعالج حتى خطوة الجاهزية، ونمو المبيعات 0.10 باللون الأخضر، وتوصيات الأعضاء مفعّلة، ومؤقّت الوحدة 15-20 دقيقة. لا تضغط "بدء اللعبة".',
    ),
    ChecklistItem(
      'x8',
      'Read the Day 1 briefing aloud, once',
      'اقرأ إحاطة اليوم الأول بصوت عالٍ، مرة واحدة',
      'Not for practice at speaking. Saying it once is different from having read it, and you will be on your own in the morning. If you are delivering on the candidate’s behalf, rehearse the substitution: it is his doctoral research, not yours.',
      'ليس للتدرّب على الإلقاء. قولها مرة يختلف عن مجرد قراءتها، وستكون وحدك في الصباح. إن كنت تقدّم نيابة عن الباحث، فتدرّب على هذا الاستبدال: إنه بحث الدكتوراه الخاص به، لا بحثك.',
    ),
  ]),
  ChecklistSection('2 · Opening the room', '2 · افتتاح القاعة', '40 min', '40 دقيقة', [
    ChecklistItem(
      'x9',
      'Welcome and framing (10 min)',
      'الترحيب والتمهيد (10 دقائق)',
      'The training framing, as in the corporate list. Three business years, a real engine, no scripted outcomes.',
      'تمهيد التدريب كما في قائمة الشركات. ثلاث سنوات عمل، ومحرّك حقيقي، ولا نتائج معدّة مسبقًا.',
    ),
    ChecklistItem(
      'x10',
      'The research read-out - as written, both languages',
      'إعلان البحث - كما هو مكتوب، باللغتين',
      'Read the Day 1 script rather than improvising it. Two people briefing two rooms in their own words are running two different studies. Say plainly whose research it is.',
      'اقرأ نص اليوم الأول بدل الارتجال. شخصان يحيطان قاعتين بكلماتهما الخاصة يُجريان دراستين مختلفتين. قل بوضوح لمن هذا البحث.',
    ),
    ChecklistItem(
      'x11',
      'Say nothing about how good the materials are',
      'لا تقل شيئًا عن جودة المواد',
      'Not advanced, not ahead of the market, not anything of that kind before the consent screen. They are about to spend the programme telling you whether the materials are any good; answering it for them first makes the answers worth less. The script has the honest version.',
      'لا "متقدّمة" ولا "سابقة للسوق" ولا أي شيء من هذا القبيل قبل شاشة الموافقة. سيمضون البرنامج في إخبارك هل المواد جيدة؛ والإجابة عنهم مسبقًا تُضعف قيمة إجاباتهم. النص يحوي الصيغة الصادقة.',
    ),
    ChecklistItem(
      'x12',
      'Consent and information sheet, then step back (10 min)',
      'الموافقة وورقة المعلومات، ثم تراجع (10 دقائق)',
      'Display the link and the QR. Then stop talking and move away from the screens. Participation is each person’s own choice and declining has to be procedurally invisible.',
      'اعرض الرابط ورمز QR. ثم توقّف عن الكلام وابتعد عن الشاشات. المشاركة خيار كل شخص، ويجب أن يكون الرفض غير مرئي إجرائيًا.',
    ),
    ChecklistItem(
      'x13',
      'If anyone instructs the room, stop it there and then',
      'إن وجّه أحدٌ القاعةَ، فأوقف ذلك فورًا',
      'A manager telling the room to fill it in is the likeliest thing to happen and the likeliest to be waved through by someone trying to help. If the room is instructed, the consent is not consent and no data from that cohort can be used.',
      'أن يطلب مدير من القاعة تعبئتها هو أرجح ما قد يحدث، وأرجح ما قد يمرّره شخص يحاول المساعدة. إن وُجّهت القاعة فالموافقة ليست موافقة، ولا يمكن استخدام أي بيانات من تلك المجموعة.',
    ),
    ChecklistItem(
      'x14',
      'Pre-training questionnaire (10 min)',
      'استبيان ما قبل التدريب (10 دقائق)',
      'On the instrument platform, after the briefing. Not the FinPlay pre-assessment - that does not run here.',
      'على منصة الأدوات، بعد الإحاطة. ليس التقييم القبلي في FinPlay - فهو لا يُجرى هنا.',
    ),
    ChecklistItem(
      'x15',
      'Teams join the lobby, then Start Game (10 min)',
      'انضمام الفرق إلى الردهة، ثم بدء اللعبة (10 دقائق)',
      'As the corporate list. Project the cohort URL and /lobby, roles assigned, leaders chosen, then Start Game.',
      'كما في قائمة الشركات. اعرض رابط المجموعة و‎/lobby‎، ووزّع الأدوار، واختر القادة، ثم ابدأ اللعبة.',
    ),
  ]),
  ChecklistSection('3 · Through the programme', '3 · طوال البرنامج', 'every day', 'كل يوم', [
    ChecklistItem(
      'x16',
      'Run the simulation exactly as the corporate list',
      'شغّل المحاكاة تمامًا كقائمة الشركات',
      'Rounds, shocks, debriefs, unlocks. The training is the training; switch to the Corporate view of this checklist for the run-of-show and back again.',
      'الجولات والصدمات والنقاشات والفتح. التدريب هو التدريب؛ انتقل إلى عرض الشركات في هذه القائمة لتسلسل الجلسة ثم عُد.',
    ),
    ChecklistItem(
      'x17',
      'Daily reflection at the end of each day (5 min)',
      'تأمّل يومي في نهاية كل يوم (5 دقائق)',
      'Display the link and QR, then step back. Two minutes of their time, and the most perishable data in the study: it cannot be recovered the next morning.',
      'اعرض الرابط ورمز QR ثم تراجع. دقيقتان من وقتهم، وهي أسرع بيانات الدراسة تلفًا: لا يمكن استعادتها في صباح اليوم التالي.',
    ),
    ChecklistItem(
      'x18',
      'Never help anyone complete a form',
      'لا تساعد أحدًا أبدًا في تعبئة نموذج',
      'Answer what a question means if asked. Never what to write. Do not look at anyone’s screen and do not walk the room while they are completing.',
      'أجب عن معنى السؤال إن سُئلت، ولا تقل أبدًا ماذا يُكتب. لا تنظر إلى شاشة أحد ولا تتجوّل في القاعة أثناء التعبئة.',
    ),
    ChecklistItem(
      'x19',
      'Counts only, never contents',
      'الأعداد فقط، وليس المحتوى أبدًا',
      'The admin page shows counts, and the secret you hold has no route to the contents. That is not a setting anyone can change for you, and it is the point.',
      'تعرض صفحة الإدارة الأعداد، والسرّ الذي تحمله لا يتيح الوصول إلى المحتوى. هذا ليس إعدادًا يمكن لأحد تغييره لك، وهذا هو المقصود.',
    ),
    ChecklistItem(
      'x20',
      'Log every departure from the materials, the same day',
      'سجّل كل خروج عن المواد، في اليوم نفسه',
      'One line is plenty. "Skipped the icebreaker, group too senior." "Round 1 took 35 minutes not 20." This is the most valuable thing in the exercise: the research question is what a human expert changes when AI-designed materials meet a real room. Three days of scribbles beat an hour of recall two weeks later.',
      'سطر واحد يكفي. "تخطّيت نشاط كسر الجليد، المجموعة من كبار المسؤولين." "استغرقت الجولة 1 خمسًا وثلاثين دقيقة لا عشرين." هذا أثمن ما في التمرين: فسؤال البحث هو ما يغيّره الخبير البشري حين تلتقي مواد صمّمها الذكاء الاصطناعي بقاعة حقيقية. ملاحظات ثلاثة أيام أفضل من ساعة استرجاع بعد أسبوعين.',
    ),
  ]),
  ChecklistSection('4 · Closing the final day', '4 · ختام اليوم الأخير', '40 min', '40 دقيقة', [
    ChecklistItem(
      'x21',
      'Final evaluation on the instrument platform (10 min)',
      'التقييم النهائي على منصة الأدوات (10 دقائق)',
      'The study’s own evaluation, anonymous. There is no FinPlay post-assessment and no course survey in a research cohort.',
      'تقييم الدراسة الخاص، دون أسماء. لا يوجد تقييم بعدي في FinPlay ولا استبيان دورة في مجموعة البحث.',
    ),
    ChecklistItem(
      'x22',
      'Certificates and the final leaderboard (20 min)',
      'الشهادات ولوحة المتصدّرين النهائية (20 دقيقة)',
      'Exactly as the corporate list. The training closes the way it would for any client.',
      'تمامًا كقائمة الشركات. يُختتم التدريب كما يُختتم لأي عميل.',
    ),
    ChecklistItem(
      'x23',
      'Before you leave the room',
      'قبل مغادرة القاعة',
      'Check the counts on the instrument admin page against the number of people present. A gap you notice today is a question you can still ask; tomorrow it is a footnote about attrition.',
      'قارن الأعداد في صفحة إدارة الأدوات بعدد الحاضرين. الفجوة التي تلاحظها اليوم سؤال لا يزال بإمكانك طرحه؛ وغدًا تصبح حاشية عن التسرّب.',
    ),
  ]),
  ChecklistSection('5 · After the cohort', '5 · بعد انتهاء المجموعة', 'same week', 'في الأسبوع نفسه', [
    ChecklistItem(
      'x24',
      'Export both formats, and check the counts',
      'صدّر بالصيغتين، وتحقّق من الأعداد',
      'From the instrument platform, with the researcher secret rather than the facilitator one. Verify the row counts against the admin counts before you treat the export as complete.',
      'من منصة الأدوات، بسرّ الباحث لا بسرّ الميسّر. طابق أعداد الصفوف مع أعداد صفحة الإدارة قبل اعتبار التصدير مكتملًا.',
    ),
    ChecklistItem(
      'x25',
      'Store it where the data management plan says',
      'احفظه حيث تنصّ خطة إدارة البيانات',
      'Not in a mailbox, not on a laptop desktop. The plan names the location; follow it.',
      'لا في صندوق بريد، ولا على سطح مكتب حاسوب محمول. الخطة تحدّد المكان؛ فالتزم بها.',
    ),
    ChecklistItem(
      'x26',
      'Delete the source records',
      'احذف السجلات المصدرية',
      'Through the admin page, once the export is verified. The confirmation phrase is DELETE followed by the cohort label, which is why the labels differ from each other.',
      'عبر صفحة الإدارة، بعد التحقّق من التصدير. عبارة التأكيد هي DELETE متبوعة بتسمية المجموعة، ولهذا تختلف التسميات عن بعضها.',
    ),
    ChecklistItem(
      'x27',
      'If another cohort follows on the same service',
      'إن تلتها مجموعة أخرى على الخدمة نفسها',
      'Change COHORT, and PROGRAMME_DAYS if the length differs, then redeploy. This cannot be repaired afterwards: the label is read once at start-up, so a second cohort begun under the old label writes into the same dataset with nothing to separate the two. Confirm the admin header reads the new label and the counts are zero before anyone opens a link.',
      'غيّر COHORT، وPROGRAMME_DAYS إن اختلفت المدة، ثم أعد النشر. لا يمكن إصلاح هذا لاحقًا: تُقرأ التسمية مرة واحدة عند التشغيل، فالمجموعة الثانية التي تبدأ تحت التسمية القديمة تكتب في مجموعة البيانات نفسها دون ما يفصل بينهما. تأكّد أن ترويسة الإدارة تعرض التسمية الجديدة وأن الأعداد صفر قبل أن يفتح أحد أي رابط.',
    ),
    ChecklistItem(
      'x28',
      'Leave FinPlay alone',
      'لا تلمس FinPlay',
      'Do not reset the cohort. It keeps its data permanently; the next group gets its own cohort.',
      'لا تُعِد ضبط المجموعة. فهي تحتفظ ببياناتها بشكل دائم؛ والفئة التالية تحصل على مجموعتها الخاصة.',
    ),
  ]),
];

const List<(String, String)> dbaRules = [
  (
    'Never help anyone complete a form. What a question means, yes. What to write, never.',
    'لا تساعد أحدًا أبدًا في تعبئة نموذج. معنى السؤال، نعم. ماذا يُكتب، أبدًا.',
  ),
  (
    'Never look at a participant’s screen, and do not walk the room while they are completing.',
    'لا تنظر أبدًا إلى شاشة مشارك، ولا تتجوّل في القاعة أثناء التعبئة.',
  ),
  (
    'If anyone instructs the room to take part, stop it politely, there and then. Instructed consent is not consent, and it costs the whole cohort.',
    'إن وجّه أحد القاعة إلى المشاركة، فأوقف ذلك بلطف وفورًا. الموافقة الموجَّهة ليست موافقة، وثمنها المجموعة كلها.',
  ),
  ('Counts only during the programme, never contents.', 'الأعداد فقط أثناء البرنامج، وليس المحتوى أبدًا.'),
  (
    'These four are commitments in writing to the university, not house style.',
    'هذه الأربعة التزامات مكتوبة تجاه الجامعة، وليست مجرد أسلوب عمل.',
  ),
];
