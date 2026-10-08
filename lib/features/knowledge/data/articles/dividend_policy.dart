// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/dividend-policy.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbDividendPolicy = KBArticle(
  id: 'dividend-policy',
  title: Bi('Dividend Policy and Shareholder Returns', 'سياسة التوزيعات وعوائد المساهمين'),
  category: 'corporate-finance',
  level: KBLevel.intermediate,
  readingMinutes: 8,
  summary: Bi('How a company decides what to pay out and what to keep, why the payout decision is really an investment decision, dividends versus buybacks, and a worked sustainable-payout test.', 'كيف تقرر الشركة ما توزعه وما تحتفظ به، ولماذا قرار التوزيع في حقيقته قرار استثمار، والتوزيعات مقابل إعادة الشراء، واختبار محلول لاستدامة التوزيع.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('Every riyal a company earns has two possible destinations: back to shareholders, or back into the business. Dividend policy is the standing answer to that question. The intuition professionals hold onto is that the payout decision is not primarily about generosity to shareholders; it is the mirror image of the investment decision. A company with projects earning more than its cost of capital should keep the cash, because reinvestment creates more value than the shareholder could earn elsewhere at the same risk. A company without such projects should hand the money back rather than build an empire with it. Seen this way, a rising payout ratio in a mature business is discipline, and a low payout in a business with no growth prospects is a warning.', 'لكل ريال تكسبه الشركة وجهتان محتملتان: العودة إلى المساهمين، أو العودة إلى النشاط. وسياسة التوزيعات هي الجواب الدائم عن ذلك السؤال. والفكرة التي يتمسك بها المهنيون أن قرار التوزيع ليس أساساً مسألة كرم مع المساهمين؛ بل هو الصورة المعاكسة لقرار الاستثمار. فالشركة التي لديها مشاريع تكسب فوق تكلفة رأس مالها ينبغي أن تحتفظ بالنقد، لأن إعادة الاستثمار تخلق قيمة أكبر مما يكسبه المساهم في مكان آخر عند المخاطرة نفسها. والشركة التي لا مشاريع لديها ينبغي أن تعيد المال بدل بناء إمبراطورية به. وبهذا المنظور تكون نسبة التوزيع المرتفعة في نشاط ناضج انضباطاً، وتكون النسبة المنخفضة في نشاط بلا آفاق نمو إنذاراً.'),
      ],
    ),
    KBSection(
      heading: Bi('The formal treatment: payout, sustainable growth and signalling', 'المعالجة النظرية: التوزيع والنمو المستدام والإشارات'),
      paragraphs: [
        Bi('Three relationships carry the theory. The payout ratio is dividends divided by net income, and its complement, the retention ratio, is what funds internal growth. Multiply retention by return on equity and you get the sustainable growth rate: the pace at which a company can grow without issuing new shares or raising leverage. The dividend yield, dividends per share over price, is the shareholder’s cash return and only part of total return, the rest being capital appreciation. Theory says that in a world without taxes, transaction costs or information gaps, policy would be irrelevant: Miller and Modigliani showed a shareholder wanting cash could simply sell shares. Reality breaks all three assumptions, which is why policy matters. Taxes differ between dividends and capital gains in many jurisdictions, though not for individuals in Saudi Arabia. Transaction costs make homemade dividends imperfect. And information gaps make the announcement itself informative: because managers hate cutting dividends, initiating or raising one signals confidence in sustainable earnings, and cutting one is read as distress even when it is prudent.', 'ثلاث علاقات تحمل النظرية. نسبة التوزيع هي التوزيعات مقسومة على صافي الدخل، ومكملتها نسبة الاحتجاز هي ما يمول النمو الداخلي. واضرب الاحتجاز في العائد على حقوق الملكية تحصل على معدل النمو المستدام: أي الوتيرة التي تستطيع الشركة النمو بها دون إصدار أسهم جديدة أو رفع الرافعة. وعائد التوزيع، أي التوزيعات للسهم على السعر، هو العائد النقدي للمساهم وجزءٌ فقط من العائد الكلي، وبقيته ارتفاع رأسمالي. وتقول النظرية إنه في عالم بلا ضرائب ولا تكاليف معاملات ولا فجوات معلومات تكون السياسة غير ذات أثر: فقد بيّن ميلر ومودلياني أن المساهم الراغب في نقد يستطيع ببساطة بيع أسهم. لكن الواقع يكسر الافتراضات الثلاثة، ولهذا تهم السياسة. فالضرائب تختلف بين التوزيعات والمكاسب الرأسمالية في ولايات قضائية كثيرة، وإن لم تختلف للأفراد في السعودية. وتكاليف المعاملات تجعل التوزيعات المصنوعة ذاتياً ناقصة. وفجوات المعلومات تجعل الإعلان نفسه مُخبراً: فلأن المديرين يكرهون خفض التوزيعات، يشير بدؤها أو رفعها إلى ثقة في أرباح مستدامة، ويُقرأ خفضها ضائقةً ولو كان تعقلاً.'),
      ],
      formulas: [
        KBFormula('Payout ratio = Dividends ÷ Net income    ·    Retention ratio = 1 − Payout ratio', caption: Bi('The split of earnings between owners and the business.', 'قسمة الأرباح بين الملاك والنشاط.')),
        KBFormula('Sustainable growth rate = Retention ratio × Return on equity    ·    Dividend yield = Dividend per share ÷ Share price', caption: Bi('How fast a company can grow on retained earnings alone, and what the shareholder receives in cash.', 'كم تستطيع الشركة النمو بالأرباح المبقاة وحدها، وما الذي يقبضه المساهم نقداً.')),
      ],
    ),
    KBSection(
      heading: Bi('Worked example: is the dividend sustainable?', 'مثال محلول: هل التوزيع مستدام؟'),
      paragraphs: [
        Bi('A company earns net income of SAR 120m and pays dividends of SAR 90m, a payout ratio of 75%. Return on equity is 12%, so the sustainable growth rate is 25% × 12% = 3%. That is the ceiling on growth without external funding. Now test it against cash rather than profit: operating cash flow is SAR 140m and capital expenditure needed just to maintain the asset base is SAR 70m, leaving free cash flow of SAR 70m against a SAR 90m dividend. The company is paying out SAR 20m more than it generates, funding the gap from the balance sheet. The dividend is covered by earnings and uncovered by cash, which is the classic profile of a payout about to be cut, or of a business quietly levering up to keep a promise it made in better years. Earnings cover alone would have shown a comfortable 1.33 times; cash cover shows 0.78 times, and cash is what pays dividends.', 'تحقق شركة صافي دخل قدره 120 مليون ريال وتوزع 90 مليوناً، أي نسبة توزيع 75%. والعائد على حقوق الملكية 12%، فيكون معدل النمو المستدام 25% × 12% = 3%. وذلك سقف النمو دون تمويل خارجي. والآن اختبره بالنقد لا بالربح: التدفق النقدي التشغيلي 140 مليوناً، والإنفاق الرأسمالي اللازم لمجرد صيانة قاعدة الأصول 70 مليوناً، فيتبقى تدفق حر قدره 70 مليوناً مقابل توزيع قدره 90 مليوناً. فالشركة توزع عشرين مليوناً فوق ما تولده، وتمول الفجوة من الميزانية. التوزيع مغطى بالأرباح وغير مغطى بالنقد، وتلك السمة الكلاسيكية لتوزيع على وشك الخفض، أو لنشاط يرفع رافعته بهدوء ليفي بوعد قطعه في سنوات أفضل. وتغطية الأرباح وحدها كانت ستُظهر 1.33 مرة مريحة؛ أما التغطية النقدية فتظهر 0.78 مرة، والنقد هو ما يدفع التوزيعات.'),
      ],
    ),
    KBSection(
      heading: Bi('Dividends, buybacks and the Saudi context', 'التوزيعات وإعادة الشراء والسياق السعودي'),
      paragraphs: [
        Bi('A buyback returns cash by purchasing the company’s own shares, raising each remaining holder’s stake. Economically it resembles a dividend, with three differences that matter. Buybacks are flexible, so they can be paused without the signalling damage of a dividend cut, which is exactly why they are used for uncertain surplus cash while dividends carry the committed base. Buybacks mechanically raise earnings per share by shrinking the share count, which flatters per-share metrics without improving the business and can be exploited when management pay is tied to EPS. And buybacks create value only if shares are repurchased below intrinsic value, so a company buying its own stock at a peak is destroying value on behalf of the shareholders who stay. In Saudi Arabia, Tadawul-listed companies commonly pay semi-annual or quarterly dividends and dividend yield is a central part of the local investment case, while buybacks are permitted within regulatory limits and used more selectively. Zakat also interacts with the decision, since the Zakat base is built on net worth-style measures rather than profit alone.', 'إعادة الشراء تعيد النقد بشراء الشركة أسهمها، فترفع حصة كل مالك باقٍ. وهي اقتصادياً شبيهة بالتوزيع، مع ثلاثة فروق مهمة. فإعادة الشراء مرنة، فيمكن إيقافها دون ضرر الإشارة الذي يحدثه خفض التوزيع، ولهذا بالضبط تُستخدم للفائض النقدي غير المؤكد بينما تحمل التوزيعات القاعدة الملتزم بها. وإعادة الشراء ترفع ربحية السهم آلياً بتقليص عدد الأسهم، فتُجمّل مقاييس السهم دون تحسين النشاط، ويمكن استغلالها حين يرتبط أجر الإدارة بربحية السهم. ولا تخلق إعادة الشراء قيمة إلا إذا اشتُريت الأسهم دون القيمة الجوهرية، فالشركة التي تشتري سهمها عند الذروة تدمر قيمة نيابة عن المساهمين الباقين. وفي السعودية توزع الشركات المدرجة في تداول عادةً أرباحاً نصف سنوية أو ربع سنوية، ويشكل عائد التوزيع جزءاً محورياً من قرار الاستثمار المحلي، بينما يُسمح بإعادة الشراء ضمن حدود تنظيمية وتُستخدم بانتقائية أكبر. وتتفاعل الزكاة أيضاً مع القرار، إذ يُبنى وعاؤها على مقاييس أقرب إلى صافي الثروة لا على الربح وحده.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Chasing dividend yield without checking cash cover: the highest yields in a market are often a falling share price pricing in the cut that has not been announced yet.', 'ملاحقة عائد التوزيع دون فحص التغطية النقدية: فأعلى العوائد في السوق غالباً سعرُ سهم هابط يسعّر خفضاً لم يُعلن بعد.'),
    Bi('Reading EPS growth after a buyback as operating improvement. Fewer shares is arithmetic; the business may not have changed at all.', 'قراءة نمو ربحية السهم بعد إعادة الشراء تحسناً تشغيلياً. فقلة الأسهم حساب؛ وقد لا يكون النشاط تغير إطلاقاً.'),
    Bi('Paying a dividend while turning down projects that earn above the cost of capital: that is not shareholder friendliness, it is a transfer of value away from long-term owners.', 'دفع توزيع مع رفض مشاريع تكسب فوق تكلفة رأس المال: ذلك ليس ودّاً للمساهمين، بل نقلٌ للقيمة بعيداً عن الملاك طويلي الأجل.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IAS 1 §107',
      note: Bi('Dividends recognized as distributions to owners, presented in the statement of changes in equity or the notes.', 'التوزيعات المعترف بها توزيعاتٍ للملاك، تُعرض في قائمة التغيرات في حقوق الملكية أو الإيضاحات.'),
      segments: [
        KBStandardSegment('IAS 1', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-1-presentation-of-financial-statements/'),
        KBStandardSegment(' §107'),
      ],
    ),
    KBStandardRef(
      standard: 'IAS 10',
      note: Bi('Events after the reporting period: a dividend declared after the year end is disclosed, not recognized as a liability.', 'الأحداث بعد فترة التقرير: التوزيع المعلن بعد نهاية السنة يُفصح عنه ولا يُعترف به التزاماً.'),
      segments: [
        KBStandardSegment('IAS 10', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-10-events-after-the-reporting-period/'),
      ],
    ),
    KBStandardRef(
      standard: 'IAS 33',
      note: Bi('Earnings per share: the weighted average share count that makes buyback effects visible.', 'ربحية السهم: المتوسط المرجح لعدد الأسهم الذي يُظهر أثر إعادة الشراء.'),
      segments: [
        KBStandardSegment('IAS 33', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ias-33-earnings-per-share/'),
      ],
    ),
  ],
  relatedTerms: [
    'Dividends',
    'Dividends Paid',
    'Dividend Payout Ratio',
    'Dividend Yield',
    'Share Buybacks',
    'Retained Earnings',
    'Return on Equity (ROE)',
  ],
  relatedModules: [
    KBRelatedModule('/education/fundamentals', Bi('Module: Financial Management Primer (Financing pillar)', 'الوحدة: تمهيد الإدارة المالية (ركيزة التمويل)')),
    KBRelatedModule('/education/financial-analysis', Bi('Module: Analysis of Financial Statements', 'الوحدة: تحليل القوائم المالية')),
  ],
  relatedArticles: [
    'capital-structure',
    'equity-and-oci',
    'wacc',
    'cash-flow-statement',
    'valuation-multiples',
    'share-based-payment',
  ],
  references: [
    'Miller, M. H., & Modigliani, F. (1961). Dividend policy, growth, and the valuation of shares. The Journal of Business, 34(4), 411-433.',
    'Brealey, R. A., Myers, S. C., & Allen, F. (2020). Principles of corporate finance (13th ed.). McGraw-Hill.',
    'Damodaran, A. (2012). Investment valuation: Tools and techniques for determining the value of any asset (3rd ed.). Wiley.',
  ],
  keywords: [
    'dividend policy',
    'payout ratio',
    'dividend yield',
    'buyback',
    'share repurchase',
    'sustainable growth',
    'signalling',
    'سياسة التوزيعات',
    'نسبة التوزيع',
    'عائد التوزيع',
    'إعادة شراء الأسهم',
  ],
);
