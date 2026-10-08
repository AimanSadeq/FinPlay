// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: finance-gamification client/src/data/knowledge-base/articles/risk-management-hedging.ts
// Regenerate with tool/generators/gen_knowledge.ts (npx tsx, run from the web repo).
// ignore_for_file: lines_longer_than_80_chars

import '../kb_models.dart';

const kbRiskManagementHedging = KBArticle(
  id: 'risk-management-hedging',
  title: Bi('Financial Risk Management and Hedging', 'إدارة المخاطر المالية والتحوط'),
  category: 'corporate-finance',
  level: KBLevel.advanced,
  readingMinutes: 6,
  summary: Bi('The market risks a company actually carries (currency, interest rate, commodity), the hedge-first hierarchy that starts with natural offsets, the four basic instruments, and the governance line between hedging and speculation.', 'مخاطر السوق التي تحملها الشركة فعلاً (العملة وسعر الفائدة والسلع)، وتراتبية التحوط التي تبدأ بالمقاصّة الطبيعية، والأدوات الأربع الأساسية، وخط الحوكمة الفاصل بين التحوط والمضاربة.'),
  sections: [
    KBSection(
      heading: Bi('Definition and intuition', 'التعريف والفكرة الأساسية'),
      paragraphs: [
        Bi('A company earns its return by taking business risks it understands: products, customers, operations. Along the way it accumulates financial risks it did not choose and has no edge in: exchange rates on imports, interest rates on floating debt, commodity prices in its inputs. Risk management is the discipline of deciding, explicitly, which of these incidental exposures to keep and which to neutralize, so that results reflect the business rather than the markets. Hedging is not profit-seeking; a good hedge is one you are happy to see "lose" money, because the loss means the underlying exposure moved in your favor.', 'تكسب الشركة عائدها بتحمل مخاطر أعمال تفهمها: منتجات وعملاء وعمليات. وفي الطريق تتراكم عليها مخاطر مالية لم تخترها ولا ميزة لها فيها: أسعار الصرف على الواردات، وأسعار الفائدة على الدين المتغير، وأسعار السلع في مدخلاتها. وإدارة المخاطر هي انضباط التقرير صراحةً أيَّ هذه التعرضات العرضية يُحتفظ به وأيها يُحيَّد، لتعكس النتائجُ الأعمالَ لا الأسواق. والتحوط ليس سعياً للربح؛ فالتحوط الجيد هو الذي يسرك أن تراه «يخسر»، لأن خسارته تعني أن التعرض الأصلي تحرك لصالحك.'),
        Bi('The process is a loop: identify exposures, measure them (amounts, currencies, dates, sensitivities), decide the policy (hedge ratio and horizon per risk), execute, and report. The measurement step matters in the Gulf context: with the riyal pegged to the dollar, USD exposure is largely policy-neutralized for a Saudi company, while EUR, GBP, JPY and other non-dollar exposures remain fully live, as does interest rate risk on floating riyal or dollar debt.', 'العملية حلقة: حدد التعرضات، وقسها (مبالغ وعملات وتواريخ وحساسيات)، وقرر السياسة (نسبة التحوط وأفقه لكل خطر)، ونفذ، وقدم التقارير. وخطوة القياس مهمة في السياق الخليجي: فمع ربط الريال بالدولار يكون التعرض الدولاري محيَّداً سياسياً إلى حد بعيد للشركة السعودية، بينما تبقى تعرضات اليورو والجنيه والين وغير الدولارية حيةً تماماً، وكذلك مخاطر الفائدة على الدين المتغير بالريال أو الدولار.'),
      ],
    ),
    KBSection(
      heading: Bi('The hierarchy: natural hedges before instruments', 'التراتبية: التحوط الطبيعي قبل الأدوات'),
      paragraphs: [
        Bi('The cheapest hedge is the one that needs no bank. Natural hedging restructures the exposure itself: matching currency of revenue and cost (price exports in the import currency, or source where you sell), matching the currency and rate basis of debt to the assets it funds, netting intragroup flows so only the group\'s net position is hedged, and building pass-through clauses that share input-price moves with customers. Only the exposure that survives these structural moves should reach the derivative desk, both because instruments cost money (spreads, premiums, collateral) and because every contract adds documentation, valuation, and counterparty questions.', 'أرخص تحوط هو ما لا يحتاج بنكاً. فالتحوط الطبيعي يعيد هيكلة التعرض ذاته: مطابقة عملة الإيراد والتكلفة (سعِّر الصادرات بعملة الواردات، أو اشترِ من حيث تبيع)، ومطابقة عملة الدين وأساس فائدته مع الأصول التي يمولها، ومقاصّة التدفقات بين شركات المجموعة كي لا يُتحوط إلا صافي مركزها، وبناء بنود تمرير تقاسم العملاء تحركات أسعار المدخلات. ولا ينبغي أن يصل إلى مكتب المشتقات إلا التعرض الذي ينجو من هذه الحركات الهيكلية، لأن الأدوات تكلف مالاً (فوارق وعلاوات وضمانات) ولأن كل عقد يضيف أسئلة توثيق وتقييم وطرف مقابل.'),
      ],
    ),
    KBSection(
      heading: Bi('The four basic instruments', 'الأدوات الأربع الأساسية'),
      paragraphs: [
        Bi('Every treasury derivative is a variation on four ideas. A forward locks a price today for a future exchange, tailored and bank-traded; certainty in both directions, no upfront cost, no upside. A future is the same lock standardized on an exchange with daily margining. A swap is a series of forwards: most commonly exchanging floating interest for fixed on a debt profile, or one currency\'s payments for another\'s. An option is the asymmetric one: the right without the obligation, protection when the market moves against you and participation when it moves for you, paid for with a premium. The choice is a certainty-versus-cost decision: forwards and swaps fix the outcome free of premium; options cost cash but keep the favorable tail. Islamic treasuries reach comparable profiles through Sharia-compliant structures (wa\'d-based FX arrangements and profit-rate swaps), governance and documentation differing more than economics.', 'كل مشتقات الخزانة تنويعات على أربع أفكار. العقد الآجل يثبت اليوم سعراً لمبادلة مستقبلية، مفصلاً ويتداول مع البنوك؛ يقين في الاتجاهين، بلا كلفة مقدمة، وبلا نصيب من الصعود. والعقد المستقبلي هو التثبيت نفسه مقيساً في بورصة بهوامش يومية. والمقايضة سلسلة عقود آجلة: أشيعها مبادلة فائدة متغيرة بثابتة على هيكل دين، أو مدفوعات عملة بمدفوعات أخرى. والخيار هو الأداة اللامتناظرة: حق بلا التزام، حماية إذا تحرك السوق ضدك ومشاركة إذا تحرك لك، لقاء علاوة تدفعها. والاختيار قرارُ يقينٍ مقابل كلفة: الآجلة والمقايضات تثبت الناتج بلا علاوة؛ والخيارات تكلف نقداً لكنها تبقي الذيل المواتي. وتبلغ الخزائن الإسلامية ملامح مشابهة عبر هياكل متوافقة مع الشريعة (ترتيبات صرف قائمة على الوعد ومقايضات معدل الربح)، ويختلف فيها التوثيق والحوكمة أكثر مما تختلف الاقتصاديات.'),
      ],
      table: KBTable(
        headers: [
          Bi('Instrument', 'الأداة'),
          Bi('What it does', 'ما تفعله'),
          Bi('Cost profile', 'ملامح الكلفة'),
        ],
        rows: [
          [
            Bi('Forward', 'العقد الآجل'),
            Bi('Locks a future price/rate, tailored', 'يثبت سعراً/معدلاً مستقبلياً، مفصلاً'),
            Bi('No premium; gives up upside', 'بلا علاوة؛ يتنازل عن الصعود'),
          ],
          [
            Bi('Future', 'العقد المستقبلي'),
            Bi('Standardized, exchange-traded lock', 'تثبيت مقيس يتداول في بورصة'),
            Bi('Margin calls; minimal credit risk', 'نداءات هامش؛ مخاطر ائتمان دنيا'),
          ],
          [
            Bi('Swap', 'المقايضة'),
            Bi('Exchanges payment streams (fixed/floating, currencies)', 'تبادل تيارات مدفوعات (ثابت/متغير، عملات)'),
            Bi('No premium; multi-year commitment', 'بلا علاوة؛ التزام متعدد السنوات'),
          ],
          [
            Bi('Option', 'الخيار'),
            Bi('Right without obligation', 'حق بلا التزام'),
            Bi('Premium paid; keeps the upside', 'علاوة تُدفع؛ يحتفظ بالصعود'),
          ],
        ],
      ),
    ),
    KBSection(
      heading: Bi('Governance, and the accounting note', 'الحوكمة وملاحظة المحاسبة'),
      paragraphs: [
        Bi('The corporate graveyard of derivatives is filled not by hedging but by hedging that drifted into speculation: positions larger than the exposure, instruments nobody could value, authority nobody had granted. The governance answer is a board-approved treasury policy stating which risks are hedged, to what ratio and horizon, with which instruments, with whom, and under whose signature; a prohibition on positions without an underlying exposure; and independent reporting of mark-to-market values and counterparty concentrations. The accounting note, for awareness: derivatives sit on the balance sheet at fair value (IFRS 9), which can push hedge gains and losses into profit in different periods from the item being hedged; hedge accounting exists to re-pair the timing (cash flow hedges park the effective portion in equity until the hedged flow occurs), at the price of designation and documentation discipline up front.', 'مقبرة الشركات في المشتقات لم يملأها التحوط بل تحوطٌ انزلق إلى مضاربة: مراكز أكبر من التعرض، وأدوات لا يستطيع أحد تقييمها، وصلاحيات لم يمنحها أحد. وجواب الحوكمة سياسةُ خزانة يقرها المجلس تنص على أي المخاطر يُتحوط لها، وبأي نسبة وأفق، وبأي أدوات، ومع من، وبتوقيع من؛ وحظرُ المراكز بلا تعرض أصلي؛ وتقارير مستقلة بالقيم السوقية وتركزات الأطراف المقابلة. وملاحظة المحاسبة، للإحاطة: تجلس المشتقات في الميزانية بالقيمة العادلة (IFRS 9)، وقد يدفع ذلك أرباح التحوط وخسائره إلى الربح في فترات مختلفة عن البند المتحوط له؛ ووُجدت محاسبة التحوط لإعادة اقتران التوقيت (تحوطات التدفق النقدي تودع الجزء الفعال في حقوق الملكية حتى وقوع التدفق المتحوط له)، لقاء انضباط تعيين وتوثيق مسبقين.'),
      ],
    ),
  ],
  pitfalls: [
    Bi('Judging a hedge by its standalone profit or loss. Measure the hedge and the exposure together or not at all.', 'الحكم على التحوط بربحه أو خسارته منفرداً. قس التحوط والتعرض معاً أو لا تقس أصلاً.'),
    Bi('Hedging more than the exposure, or exposures that may not materialize (forecast sales that slip): the excess is a speculative position.', 'التحوط بأكثر من التعرض، أو لتعرضات قد لا تتحقق (مبيعات متوقعة تنزلق): الفائض مركز مضاربي.'),
    Bi('Ignoring counterparty and margin liquidity risk: a winning hedge with a failing bank, or margin calls arriving in the same storm as the exposure, can turn protection into the crisis.', 'تجاهل مخاطر الطرف المقابل وسيولة الهوامش: تحوط رابح مع بنك متعثر، أو نداءات هامش تصل في العاصفة نفسها مع التعرض، قد يحول الحماية إلى الأزمة ذاتها.'),
  ],
  standards: [
    KBStandardRef(
      standard: 'IFRS 9 (Chapter 6)',
      note: Bi('Hedge accounting: designation, effectiveness, cash flow and fair value hedge mechanics.', 'محاسبة التحوط: التعيين والفعالية وآليات تحوط التدفق النقدي والقيمة العادلة.'),
      segments: [
        KBStandardSegment('IFRS 9', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ifrs-9-financial-instruments/'),
        KBStandardSegment(' (Chapter 6)'),
      ],
    ),
    KBStandardRef(
      standard: 'IFRS 7 §31–42',
      note: Bi('Disclosure of market risk sensitivities and how risks arise and are managed: where readers see a company\'s risk profile.', 'الإفصاح عن حساسيات مخاطر السوق ونشأتها وإدارتها: حيث يرى القراء ملامح مخاطر الشركة.'),
      segments: [
        KBStandardSegment('IFRS 7', href: 'https://www.ifrs.org/issued-standards/list-of-standards/ifrs-7-financial-instruments-disclosures/'),
        KBStandardSegment(' §31–42'),
      ],
    ),
    KBStandardRef(
      standard: 'COSO ERM (2017)',
      note: Bi('The enterprise-wide frame: financial hedging is one treatment inside a broader risk appetite and governance structure.', 'الإطار على مستوى المنشأة: التحوط المالي معالجة واحدة داخل شهية مخاطر وهيكل حوكمة أوسع.'),
      segments: [
        KBStandardSegment('COSO ERM', href: 'https://www.coso.org/erm-framework'),
        KBStandardSegment(' (2017)'),
      ],
    ),
  ],
  relatedTerms: [],
  relatedModules: [
    KBRelatedModule('/education/fundamentals', Bi('Module: Financial Management Primer', 'الوحدة: تمهيد الإدارة المالية')),
  ],
  relatedArticles: [
    'bonds-and-sukuk',
    'capital-structure',
    'cash-flow-forecasting',
    'financial-instruments',
    'foreign-currency',
  ],
  references: [
    'Hull, J. C. (2022). Options, futures, and other derivatives (11th ed.). Pearson.',
    'Brealey, R. A., Myers, S. C., & Allen, F. (2020). Principles of corporate finance (13th ed.). McGraw-Hill.',
    'Committee of Sponsoring Organizations of the Treadway Commission. (2017). Enterprise risk management: Integrating with strategy and performance. COSO.',
    'IFRS Foundation. (2014). IFRS 9 Financial instruments. IFRS Foundation.',
  ],
  keywords: [
    'risk management',
    'hedging',
    'forward',
    'swap',
    'option',
    'FX risk',
    'interest rate risk',
    'إدارة المخاطر',
    'تحوط',
    'مشتقات',
    'مخاطر الصرف',
  ],
);
