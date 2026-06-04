import '../gov_module_data.dart';

const module7Data = GovModuleContent(
  id: 7,
  title: 'IFRS vs IPSAS Standards',
  gameTitle: 'Match IPSAS Standards',
  gameDescription: 'Match each IPSAS standard with its topic.',
  gameType: GameType.memoryMatch,
  slides: [
    // Slide 7.1 - IFRS vs IPSAS: An Overview
    {
      'title': '7.1 IFRS vs IPSAS: An Overview',
      'content':
          'IFRS (International Financial Reporting Standards) and IPSAS (International Public Sector Accounting Standards) are the two dominant global accounting frameworks. IFRS is developed by the International Accounting Standards Board (IASB) and serves private-sector companies listed on capital markets. IPSAS is developed by the International Public Sector Accounting Standards Board (IPSASB) and serves government entities and public-sector organizations.\n\n'
          'IPSAS was deliberately built on the foundation of IFRS. Where a private-sector standard can be applied to the public sector without modification, IPSAS adopts the same treatment and references the equivalent IFRS. This "IFRS convergence" approach ensures that the two frameworks share a common technical language and measurement philosophy wherever possible.\n\n'
          'However, the public sector has transactions and accountability requirements that simply do not exist in the private sector. Governments collect taxes, distribute social benefits, manage heritage assets, and are accountable to citizens rather than shareholders. These realities demand standards that go beyond what IFRS provides.\n\n'
          'This module is organized into two parts. Part 1 examines the similarities \u2014 areas where IPSAS mirrors IFRS in measurement, recognition, presentation, and group accounting. Part 2 explores the differences \u2014 areas where IPSAS deliberately diverges to address public-sector realities. Understanding both is essential for anyone working at the intersection of public and private finance.',
      'keyPoint':
          'IFRS serves private sector; IPSAS serves public sector \u2022 IPSAS is built on IFRS \u2014 convergence by design \u2022 Public sector realities require standards beyond IFRS \u2022 This module covers both similarities and differences',
    },
    // Slide 7.2 - Similarities: Measurement & Valuation
    {
      'title': '7.2 Similarities: Measurement & Valuation',
      'content':
          'When it comes to measuring and valuing assets, IFRS and IPSAS adopt the same approaches across four major categories. This alignment is intentional \u2014 if a measurement technique works for private-sector assets, it generally works for public-sector assets too.\n\n'
          'Property, Plant & Equipment (PP&E): Both IAS 16 and IPSAS 17 allow entities to choose between the cost model (carry at cost minus accumulated depreciation) and the revaluation model (carry at fair value with periodic revaluations). The recognition criteria, component depreciation, and derecognition rules are virtually identical.\n\n'
          'Investment Property: IAS 40 and IPSAS 16 both permit the cost model or the fair value model for property held for rental income or capital appreciation. Changes in fair value flow through surplus/profit or loss under both frameworks.\n\n'
          'Financial Instruments: IFRS 9 and IPSAS 41 share the same three-bucket classification \u2014 Amortized Cost, Fair Value through Other Comprehensive Income (FVOCI), and Fair Value through Profit or Loss (FVTPL). Both use the Expected Credit Loss (ECL) impairment model, which recognizes credit losses before they actually occur.\n\n'
          'Biological Assets: IAS 41 and IPSAS 27 both require measurement at fair value less costs to sell, with changes recognized in surplus or profit or loss. This covers agricultural assets such as livestock, crops, and forestry.',
      'keyPoint':
          'PP&E: Cost model or revaluation model (IAS 16 / IPSAS 17) \u2022 Investment Property: Cost or fair value model (IAS 40 / IPSAS 16) \u2022 Financial Instruments: Same classification + ECL model (IFRS 9 / IPSAS 41) \u2022 Biological Assets: Fair value less costs to sell (IAS 41 / IPSAS 27)',
    },
    // Slide 7.3 - Similarities: Recognition
    {
      'title': '7.3 Similarities: Recognition',
      'content':
          'Recognition \u2014 deciding when to record a transaction in the financial statements \u2014 follows the same principles under both IFRS and IPSAS across five key areas.\n\n'
          'Accrual Basis: Both frameworks require accrual-basis accounting. Transactions are recognized when they occur, not when cash changes hands. This is the foundational principle that makes both frameworks comparable and complete.\n\n'
          'Leases: Under IFRS 16 and IPSAS 43, lessees recognize a right-of-use (ROU) asset and a corresponding lease liability for nearly all leases. This eliminates off-balance-sheet financing and gives a truer picture of obligations. The measurement of the ROU asset and liability follows the same present-value approach.\n\n'
          'Employee Benefits: IAS 19 and IPSAS 39 both use the projected unit credit method for defined benefit pension plans. Remeasurements (actuarial gains and losses) are recognized through Other Comprehensive Income (OCI) or net assets, not through surplus/profit or loss. This prevents pension volatility from distorting operating performance.\n\n'
          'Provisions: Under IAS 37 and IPSAS 19, a provision is recognized when three conditions are met: (1) a present obligation exists from a past event, (2) an outflow of resources is probable, and (3) a reliable estimate can be made. The conditions are identical in both frameworks.\n\n'
          'Foreign Currency: IAS 21 and IPSAS 4 share the functional currency concept. Transactions are initially recorded at the exchange rate on the transaction date, and monetary items are retranslated at the closing rate, with exchange differences recognized in surplus or profit or loss.',
      'keyPoint':
          'Accrual basis is foundational to both frameworks \u2022 Leases: ROU asset + lease liability (IFRS 16 / IPSAS 43) \u2022 Provisions: Same 3-condition test (IAS 37 / IPSAS 19) \u2022 Employee benefits: Same actuarial method (IAS 19 / IPSAS 39) \u2022 Foreign currency: Same functional currency approach (IAS 21 / IPSAS 4)',
    },
    // Slide 7.4 - Similarities: Presentation, Disclosure & Groups
    {
      'title': '7.4 Similarities: Presentation, Disclosure & Groups',
      'content':
          'Beyond measurement and recognition, IFRS and IPSAS also align on how financial information is presented, how changes and errors are handled, and how group entities are accounted for.\n\n'
          'Cash Flow Statement: IAS 7 and IPSAS 2 both require the same three categories \u2014 operating, investing, and financing activities. The direct and indirect methods are both permitted. This consistency allows cross-sector comparison of how entities generate and use cash.\n\n'
          'Accounting Policy Changes & Errors: Under IAS 8 and IPSAS 3, voluntary policy changes and correction of prior-period errors are applied retrospectively \u2014 meaning prior-period comparatives are restated as if the new policy (or correct treatment) had always been applied. This maintains comparability over time.\n\n'
          'Events After the Reporting Date: IAS 10 and IPSAS 14 make the same distinction between adjusting events (conditions existed at reporting date \u2014 adjust the statements) and non-adjusting events (arose after reporting date \u2014 disclose only). This ensures statements reflect information available at the reporting date.\n\n'
          'Joint Arrangements: IFRS 11 and IPSAS 37 distinguish joint operations (account for assets, liabilities, revenues, expenses directly) from joint ventures (equity method). Associates: IAS 28 and IPSAS 36 both use the equity method to account for entities where the investor has significant influence but not control.\n\n'
          'These shared presentation and group accounting rules mean that the structure and logic of financial statements are recognizable across both sectors \u2014 a powerful benefit for professionals who work in both worlds.',
      'keyPoint':
          'Cash flow: Same 3 categories (IAS 7 / IPSAS 2) \u2022 Policy changes & errors: Retrospective application (IAS 8 / IPSAS 3) \u2022 Post-reporting events: Adjusting vs non-adjusting (IAS 10 / IPSAS 14) \u2022 Joint arrangements: Same classification (IFRS 11 / IPSAS 37) \u2022 Associates: Equity method (IAS 28 / IPSAS 36)',
    },
    // Slide 7.5 - Why IPSAS Diverges: The Public Sector Context
    {
      'title': '7.5 Why IPSAS Diverges: The Public Sector Context',
      'content':
          'Before examining the specific differences, it is essential to understand why IPSAS needs to diverge from IFRS at all. The answer lies in three fundamental distinctions between the public and private sectors.\n\n'
          'Different Users, Different Needs: IFRS is designed for investors, lenders, and creditors who make capital allocation decisions. IPSAS is designed for citizens, legislators, donors, and oversight bodies who evaluate whether public resources are being used responsibly. An investor asks "Will I get a return?" A citizen asks "Are my taxes being used well?"\n\n'
          'Service Potential vs Economic Benefits: Under IFRS, an asset must generate future economic benefits \u2014 cash inflows \u2014 to be recognized. But many government assets (roads, parks, hospitals, military equipment) do not generate cash. They generate service potential \u2014 the ability to deliver public services. IPSAS recognizes this broader concept.\n\n'
          'Accountability vs Profitability: The private sector measures success through profit. The public sector measures success through stewardship \u2014 the responsible management and accountability for resources entrusted by citizens. This shifts the entire orientation of financial reporting from "How much did we earn?" to "How well did we manage public resources?"\n\n'
          'These three differences \u2014 different users, service potential, and stewardship focus \u2014 are the root cause of every technical difference you will see in the following slides. When you encounter a difference between IFRS and IPSAS, trace it back to one of these three drivers.',
      'keyPoint':
          'IFRS users: investors and creditors; IPSAS users: citizens and legislators \u2022 IFRS: future economic benefits; IPSAS: also service potential \u2022 Private sector: profitability focus; Public sector: stewardship focus \u2022 These 3 drivers explain every IFRS/IPSAS difference',
    },
    // Slide 7.6 - Differences: Conceptual & Framework
    {
      'title': '7.6 Differences: Conceptual & Framework',
      'content':
          'The most fundamental differences between IFRS and IPSAS sit at the conceptual framework level. These are not minor technical tweaks \u2014 they reflect entirely different purposes for financial reporting.\n\n'
          'Primary Users: Under the IFRS Conceptual Framework, the primary users are existing and potential investors, lenders, and other creditors. Under the IPSAS Conceptual Framework, the primary users are citizens, their elected representatives (legislators), donors, lenders, and oversight bodies. This difference drives what information gets priority in the statements.\n\n'
          'Performance Measure: IFRS uses "Profit or Loss" as the bottom-line performance measure (IAS 1). IPSAS uses "Surplus or Deficit" (IPSAS 1). While the calculation is similar, the terminology reflects the fact that governments do not exist to make a profit \u2014 a surplus means resources exceeded spending, not that the entity was "profitable."\n\n'
          'Asset Recognition Concept: Under IFRS, an asset is recognized when it is expected to generate future economic benefits \u2014 essentially future cash inflows. Under IPSAS 17, an asset can also be recognized if it has service potential \u2014 the capacity to provide services that contribute to the entity\'s objectives, even if it never generates cash. This is why roads, parks, and military assets qualify as assets under IPSAS but would face challenges under a strict IFRS interpretation.',
      'keyPoint':
          'Users: Investors & creditors (IFRS) vs Citizens & legislators (IPSAS) \u2022 Bottom line: Profit or Loss (IFRS) vs Surplus or Deficit (IPSAS) \u2022 Assets: Economic benefits only (IFRS) vs Also service potential (IPSAS) \u2022 These framework differences drive all specific technical differences',
    },
    // Slide 7.7 - Differences: Revenue & Income
    {
      'title': '7.7 Differences: Revenue & Income',
      'content':
          'Revenue recognition is where IFRS and IPSAS diverge most visibly. The private sector earns revenue from selling goods and services. The public sector receives much of its income without providing something of equal value in return \u2014 taxes, grants, fines, and donations.\n\n'
          'Exchange Revenue: Under IFRS 15, revenue from contracts with customers follows a five-step model based on performance obligations. Under IPSAS 9, exchange revenue (fees for services, sales) uses a simpler model \u2014 revenue is recognized when it is probable that economic benefits or service potential will flow to the entity and the amount can be reliably measured.\n\n'
          'Non-Exchange Revenue: This is the single biggest gap. IFRS has no equivalent \u2014 all transactions are assumed to be exchange-based. IPSAS 23 is a dedicated standard for non-exchange revenue: taxes, grants, fines, bequests, and donations. Revenue is recognized when conditions are met and the entity has control over the asset. The standard distinguishes between conditions (must be returned if not met) and restrictions (limit use but do not affect recognition).\n\n'
          'Grants: Under IAS 20, government grants are recognized systematically to match related costs. Under IPSAS 23, grants with conditions create a liability until the conditions are fulfilled. Grants with restrictions only (no return obligation) are recognized as revenue immediately upon receipt.\n\n'
          'Social Benefits: IFRS does not address social benefits at all \u2014 they are outside scope. IPSAS 42 specifically addresses welfare payments, public pensions, and healthcare obligations, recognizing them when eligibility criteria are met by the beneficiary. This is one of the most significant public-sector-only standards.',
      'keyPoint':
          'Exchange revenue: IFRS 15 five-step model vs IPSAS 9 simpler model \u2022 Non-exchange revenue: IPSAS 23 (no IFRS equivalent) \u2022 Grants: Conditions \u2192 liability (IPSAS 23) vs matching costs (IAS 20) \u2022 Social benefits: IPSAS 42 (outside IFRS scope entirely)',
    },
    // Slide 7.8 - Differences: Assets & Impairment
    {
      'title': '7.8 Differences: Assets & Impairment',
      'content':
          'Governments hold assets that the private sector rarely encounters \u2014 heritage buildings, national monuments, military equipment, and inventories meant for free distribution. These unique assets require unique accounting treatment.\n\n'
          'Heritage Assets: Under IFRS, there is no specific guidance \u2014 heritage assets default to general PP&E rules (IAS 16). Under IPSAS 17, heritage assets are explicitly addressed. Recognition is encouraged but not required when reliable measurement is impossible (how do you value the Pyramids?). However, disclosure is always required, ensuring transparency even when recognition is not feasible.\n\n'
          'Inventories for Free Distribution: Under IAS 2, all inventories are measured at the lower of cost and net realizable value (NRV). Under IPSAS 12, inventories held for free distribution or for a nominal charge are measured at the lower of cost and current replacement cost. NRV is irrelevant because the entity does not intend to sell the items.\n\n'
          'Impairment: IFRS has a single impairment standard \u2014 IAS 36 \u2014 which measures recoverable amount based on expected cash flows. IPSAS has two standards: IPSAS 26 for cash-generating assets (similar to IAS 36) and IPSAS 21 for non-cash-generating assets, where impairment is measured by the decline in remaining service potential rather than cash flows.\n\n'
          'Assets Held for Sale: IFRS 5 provides a separate classification for non-current assets held for sale \u2014 depreciation stops and the asset is measured at fair value less costs to sell. IPSAS has no direct equivalent. General measurement principles continue to apply.',
      'keyPoint':
          'Heritage assets: IPSAS explicitly addresses; IFRS has no specific guidance \u2022 Inventories for distribution: Replacement cost (IPSAS 12) vs NRV (IAS 2) \u2022 Impairment: Two IPSAS standards (cash + non-cash) vs one IFRS (IAS 36) \u2022 Assets held for sale: IFRS 5 separate class; no IPSAS equivalent',
    },
    // Slide 7.9 - Differences: Liabilities & Costs
    {
      'title': '7.9 Differences: Liabilities & Costs',
      'content':
          'Governments often engage in transactions that have no private-sector equivalent \u2014 lending money at below-market rates to support social objectives, or leasing property for a nominal amount to promote community use. These transactions create unique accounting challenges.\n\n'
          'Borrowing Costs: Under IAS 23, entities must capitalize borrowing costs directly attributable to the acquisition, construction, or production of a qualifying asset. There is no choice \u2014 capitalization is mandatory. Under IPSAS 5, entities have a policy choice: they can capitalize borrowing costs or expense them immediately. This flexibility acknowledges that public-sector infrastructure projects may have different financing structures.\n\n'
          'Concessionary Loans: These are loans made at below-market rates (e.g., a government lending to a social housing organization at 1% when the market rate is 5%). Under IFRS 9, there is no specific guidance for below-market loans. Under IPSAS 41, the day-one difference between the loan proceeds and its fair value is recognized as an expense reflecting the subsidy element. This makes the true cost of the concessionary policy transparent.\n\n'
          'Peppercorn / Nominal Leases: Governments sometimes lease property at a token amount (e.g., SAR 1 per year) to support community organizations. Under IFRS 16, there is no specific guidance for such arrangements. Under IPSAS 43, the right-of-use asset is measured at fair value, and the difference between the fair value and the nominal payment is recognized as a day-one gain, reflecting the concessionary element received.',
      'keyPoint':
          'Borrowing costs: Must capitalize (IAS 23) vs Policy choice (IPSAS 5) \u2022 Concessionary loans: No specific IFRS guidance vs Day-one expense (IPSAS 41) \u2022 Peppercorn leases: No specific IFRS guidance vs Fair value ROU (IPSAS 43) \u2022 All three reflect unique public-sector financing arrangements',
    },
    // Slide 7.10 - Differences: Presentation & Disclosure
    {
      'title': '7.10 Differences: Presentation & Disclosure',
      'content':
          'While the underlying structure of financial statements is similar, IFRS and IPSAS differ significantly in what must be presented and disclosed \u2014 reflecting different accountability requirements.\n\n'
          'Budget Reporting: This is perhaps the most distinctive IPSAS requirement. Under IPSAS 24, entities must present a comparison of budget versus actual amounts, with explanations for material variances. IFRS has no equivalent. Budgets are central to public-sector governance \u2014 legislatures approve spending through budgets, so reporting against them is fundamental to accountability.\n\n'
          'Related Party Disclosures: Under IAS 24, related parties include key management personnel and their close family. Under IPSAS 20, the scope is much broader \u2014 it includes ministers, elected officials, senior political appointees, and their close family members. This broader scope reflects the unique concentration of power in the public sector.\n\n'
          'Segment Reporting: Under IFRS 8, operating segments are based on how internal management reports to the chief operating decision maker. Under IPSAS 18, segments are defined by service type (education, health, defense) or geographic area, reflecting public accountability rather than internal management structure.\n\n'
          'Interim Reporting: IAS 34 sets minimum content requirements for interim financial reports. IPSAS has no direct equivalent standard for interim reporting.\n\n'
          'Earnings Per Share: IAS 33 requires disclosure of EPS for public companies. Under IPSAS, this concept is not applicable \u2014 governments do not have shareholders or traded shares.',
      'keyPoint':
          'Budget reporting: Mandatory under IPSAS 24; not required under IFRS \u2022 Related parties: Much broader scope under IPSAS 20 than IAS 24 \u2022 Segments: Service/geographic (IPSAS 18) vs management-based (IFRS 8) \u2022 No IPSAS equivalent for interim reporting (IAS 34) or EPS (IAS 33)',
    },
    // Slide 7.11 - Differences: Group Accounting & Combinations
    {
      'title': '7.11 Differences: Group Accounting & Combinations',
      'content':
          'Governments often control entities not through ownership of shares, but through legislation, regulation, or executive authority. This creates a fundamentally different concept of "control" that affects consolidation, combinations, and public-private partnerships.\n\n'
          'Consolidation \u2014 Control Concept: Under IFRS 10, an investor controls an investee when it has power over the investee, exposure to variable returns, and the ability to use its power to affect those returns. Under IPSAS 35, control is broader \u2014 it includes control obtained through legislation, regulation, or binding administrative agreements. A ministry that sets the policy for an agency and can appoint its leadership has control, even without a single share.\n\n'
          'Business Combinations: Under IFRS 3, acquisitions use the acquisition method and typically result in goodwill (the excess of purchase price over net assets). Under IPSAS 40, the standard covers amalgamations and restructurings that are common in government \u2014 merging two ministries or creating a new entity from parts of others. Goodwill is rare because these transactions often occur under common control without a purchase price.\n\n'
          'Service Concessions / PPPs: IFRIC 12 addresses service concession arrangements from the operator\'s perspective \u2014 the private company that builds and operates the infrastructure. IPSAS 32 addresses the same arrangements from the government\'s (grantor\'s) perspective \u2014 recognizing the asset and the related liability or revenue. This is critical for public-private partnerships like toll roads and hospital management contracts.',
      'keyPoint':
          'Control: Power + returns (IFRS 10) vs Also legislation/regulation (IPSAS 35) \u2022 Combinations: Acquisition method + goodwill (IFRS 3) vs Amalgamations (IPSAS 40) \u2022 PPPs: Operator view (IFRIC 12) vs Grantor view (IPSAS 32) \u2022 Government control often comes from authority, not share ownership',
    },
    // Slide 7.12 - Differences: Transition & Adoption
    {
      'title': '7.12 Differences: Transition & Adoption',
      'content':
          'The path to adopting IFRS and IPSAS for the first time is different \u2014 reflecting the reality that many governments are transitioning from cash-basis accounting, a challenge that rarely exists in the private sector.\n\n'
          'First-Time Adoption: Under IFRS 1, first-time adoption provides a set of mandatory exceptions and optional exemptions to ease the transition to IFRS. The expectation is that the entity was already using some form of accrual accounting under a national framework. Under IPSAS 33, first-time adoption provides a generous 3-year transitional relief period for entities moving from cash basis to accrual basis. During this period, entities are exempt from certain recognition and measurement requirements as they build systems and capacity.\n\n'
          'Cash Basis Accounting: Under IFRS, cash-basis accounting is simply not permitted. All entities must use accrual accounting. IPSAS takes a more pragmatic approach \u2014 it provides a standalone Cash Basis IPSAS standard specifically for governments that are not yet ready for full accrual. This standard establishes minimum reporting requirements under the cash basis and serves as a stepping stone toward eventual accrual adoption.\n\n'
          'This dual-track approach is one of the most practical differences between the frameworks. IPSAS acknowledges that many governments, especially in developing countries, need a gradual transition path. The journey typically follows three stages: (1) Cash Basis IPSAS \u2192 (2) Modified Accrual during transition \u2192 (3) Full Accrual IPSAS within the 3-year relief window of IPSAS 33.',
      'keyPoint':
          'IFRS 1: Mandatory exceptions + optional exemptions for first-time adopters \u2022 IPSAS 33: 3-year transitional relief from cash to accrual \u2022 Cash basis: Not permitted under IFRS; standalone standard under IPSAS \u2022 Transition path: Cash Basis \u2192 Modified Accrual \u2192 Full Accrual IPSAS',
    },
    // Slide 7.13 - Key Takeaways
    {
      'title': '7.13 Key Takeaways',
      'content':
          'IPSAS is largely derived from IFRS \u2014 the similarities are by design. Wherever a private-sector standard can apply to the public sector, IPSAS adopts the same treatment. This is true for PP&E measurement, financial instruments, leases, provisions, cash flow presentation, and many other areas.\n\n'
          'The key differences stem from public sector realities that IFRS was never designed to address. Non-exchange revenue (taxes, grants), heritage assets, budget accountability, social benefits, concessionary loans, and broader definitions of control all require standards that go beyond what IFRS provides.\n\n'
          'IFRS focuses on investor decision-making \u2014 helping capital markets allocate resources efficiently. IPSAS focuses on public accountability and stewardship \u2014 helping citizens evaluate whether their government is using public resources responsibly. The bottom line shifts from "profit" to "surplus/deficit," and the asset test shifts from "cash generation" to "service potential."\n\n'
          'Both frameworks promote transparency, consistency, and comparability in financial reporting. A professional who understands IFRS has a strong foundation for understanding IPSAS, and vice versa. The differences are driven by purpose, not by arbitrary preference.\n\n'
          'For governments transitioning from cash-basis accounting, IPSAS provides a practical path through Cash Basis IPSAS and the 3-year transitional relief of IPSAS 33. The destination is the same: high-quality, accrual-based financial reporting that serves the needs of all stakeholders.',
      'keyPoint':
          'Similarities are by design \u2014 IPSAS builds on IFRS wherever possible \u2022 Differences stem from public-sector realities, not arbitrary choices \u2022 IFRS = investor focus; IPSAS = public accountability focus \u2022 Both promote transparency, consistency, and comparability \u2022 Cash Basis IPSAS provides a transition path for developing governments',
    },
  ],
  quizQuestions: [
    // ── Combined Practice Quiz (20 questions from module7-quiz.ts) ──
    // Q1 - from Quiz 1
    {
      'question': 'What does IFRS stand for?',
      'options': [
        'International Finance Regulatory System',
        'International Financial Reporting Standards',
        'Internal Fiscal Review Standards',
        'Integrated Financial Record System',
      ],
      'correctIndex': 1,
      'explanation':
          'IFRS stands for International Financial Reporting Standards, developed by the IASB for private sector financial reporting.',
    },
    // Q2 - from Quiz 1
    {
      'question':
          'Under both IFRS and IPSAS, PP&E can be measured using which models?',
      'options': [
        'Only fair value model',
        'Cost model or revaluation model',
        'Only historical cost model',
        'Replacement cost model only',
      ],
      'correctIndex': 1,
      'explanation':
          'Both IAS 16 (IFRS) and IPSAS 17 allow PP&E to be measured using the cost model or the revaluation model after initial recognition.',
    },
    // Q3 - from Quiz 1
    {
      'question': 'Both frameworks use which accounting basis?',
      'options': [
        'Cash basis',
        'Modified cash basis',
        'Tax basis',
        'Accrual basis',
      ],
      'correctIndex': 3,
      'explanation':
          'Both IFRS and IPSAS (accrual-basis standards) use accrual accounting, recognizing transactions when they occur rather than when cash changes hands.',
    },
    // Q4 - from Quiz 1
    {
      'question': 'Under IFRS 16 and IPSAS 43, lessees recognize:',
      'options': [
        'Only rental expense on a straight-line basis',
        'A right-of-use asset and a lease liability',
        'Only a lease liability with no asset',
        'An operating lease disclosure only',
      ],
      'correctIndex': 1,
      'explanation':
          'Both IFRS 16 and IPSAS 43 require lessees to recognize a right-of-use asset and a corresponding lease liability on the balance sheet.',
    },
    // Q5 - from Quiz 1
    {
      'question': 'IFRS primarily serves which stakeholders?',
      'options': [
        'Government budget offices',
        'Investors, creditors, and capital markets',
        'Citizens and taxpayers',
        'International aid agencies',
      ],
      'correctIndex': 1,
      'explanation':
          'IFRS is designed for capital market participants -- investors, lenders, and creditors who need information for economic decisions.',
    },
    // Q6 - from Quiz 1
    {
      'question': 'The concept of "service potential" is unique to:',
      'options': [
        'IFRS',
        'US GAAP',
        'IPSAS',
        'Both IFRS and IPSAS equally',
      ],
      'correctIndex': 2,
      'explanation':
          'Service potential is a concept unique to IPSAS, recognizing that many public sector assets exist to deliver services rather than generate cash flows.',
    },
    // Q7 - from Quiz 1
    {
      'question': 'Why was IPSAS created separately from IFRS?',
      'options': [
        'Because IFRS had too many standards',
        'Because public sector has unique transactions like taxes, grants, and non-exchange revenue not covered by IFRS',
        'Because IFRS was only available in English',
        'Because governments wanted cheaper standards',
      ],
      'correctIndex': 1,
      'explanation':
          'IPSAS was created because public sector entities have unique transactions (non-exchange revenue, social benefits, heritage assets) that IFRS does not address.',
    },
    // Q8 - from Quiz 2
    {
      'question':
          'Under IFRS, the primary performance measure is profit or loss. Under IPSAS, it is:',
      'options': [
        'Earnings per share',
        'Revenue growth',
        'Surplus or deficit',
        'Net asset value',
      ],
      'correctIndex': 2,
      'explanation':
          'IPSAS uses "surplus or deficit" instead of "profit or loss" because public sector entities do not operate for profit.',
    },
    // Q9 - from Quiz 2
    {
      'question':
          'IPSAS distinguishes between exchange and non-exchange revenue. Which is an example of non-exchange revenue?',
      'options': [
        'Consulting fees charged by a government agency',
        'Sale of government surplus equipment',
        'Tax revenue collected from citizens',
        'Rent charged for government-owned buildings',
      ],
      'correctIndex': 2,
      'explanation':
          'Tax revenue is a non-exchange transaction because the government receives value (taxes) without providing equivalent direct value in return to the individual taxpayer.',
    },
    // Q10 - from Quiz 2
    {
      'question':
          'Heritage assets (e.g., national monuments, artworks) are specifically addressed by:',
      'options': [
        'IFRS only',
        'Neither IFRS nor IPSAS',
        'IPSAS 17 (with special guidance)',
        'IAS 16 exclusively',
      ],
      'correctIndex': 2,
      'explanation':
          'IPSAS 17 provides specific guidance for heritage assets, which governments may not need to depreciate. IFRS has no specific heritage asset guidance.',
    },
    // Q11 - from Quiz 2
    {
      'question':
          'IPSAS has two impairment standards (IPSAS 21 and IPSAS 26) instead of one. The split is based on:',
      'options': [
        'Size of the asset',
        'Whether the asset is cash-generating or non-cash-generating',
        'Age of the asset',
        'Location of the asset',
      ],
      'correctIndex': 1,
      'explanation':
          'IPSAS 21 covers non-cash-generating assets (held for service delivery) and IPSAS 26 covers cash-generating assets. IFRS has only IAS 36 for all impairment.',
    },
    // Q12 - from Quiz 2
    {
      'question':
          'IPSAS 24 requires budget-to-actual comparison reporting. Why does IFRS have no equivalent?',
      'options': [
        'Private companies do not prepare budgets',
        'IFRS considers budgets irrelevant',
        'Budget comparisons are too complex to disclose',
        'Budgets are not publicly approved documents in the private sector',
      ],
      'correctIndex': 3,
      'explanation':
          'Government budgets are publicly approved and legally binding documents. Budget-to-actual reporting is essential for public accountability. Private sector budgets are internal and not subject to public disclosure.',
    },
    // Q13 - from Quiz 2
    {
      'question':
          'IPSAS defines "control" for consolidation purposes differently from IFRS 10. In the public sector, control often comes from:',
      'options': [
        'Majority share ownership',
        'Contractual agreements only',
        'Market share dominance',
        'Legislation, regulation, or executive authority rather than equity ownership',
      ],
      'correctIndex': 3,
      'explanation':
          'In the public sector, control often arises from legislation, regulations, or executive orders rather than equity ownership, which is the typical control basis under IFRS 10.',
    },
    // Q14 - from Quiz 2
    {
      'question':
          'IPSAS 33 (First-Time Adoption) provides transitional relief not found in IFRS 1, such as:',
      'options': [
        'Exemption from all disclosure requirements permanently',
        'Permission to use any accounting framework',
        'No comparative information ever required',
        'A three-year transitional exemption period for recognizing certain assets and liabilities',
      ],
      'correctIndex': 3,
      'explanation':
          'IPSAS 33 provides a three-year transitional exemption period, recognizing that governments transitioning from cash to accrual accounting need more time to identify and measure all assets and liabilities.',
    },
    // Q15 - from Quiz 3
    {
      'question':
          'A municipality receives SAR 10 million in property tax payments. Which standard applies for recognition?',
      'options': [
        'IFRS 15 (Revenue from Contracts with Customers)',
        'IAS 20 (Government Grants)',
        'IPSAS 23 (Revenue from Non-Exchange Transactions)',
        'IPSAS 9 (Revenue from Exchange Transactions)',
      ],
      'correctIndex': 2,
      'explanation':
          'Tax revenue is a non-exchange transaction because citizens do not receive individually proportionate services in return. IPSAS 23 governs this recognition.',
    },
    // Q16 - from Quiz 3
    {
      'question':
          'A government gives a SAR 5 million loan to a university at 1% interest when the market rate is 5%. How does IPSAS treat the difference?',
      'options': [
        'The full SAR 5 million is recognized as a financial asset at face value',
        'The interest difference is ignored under both frameworks',
        'Only the interest income is recorded',
        'The loan is measured at fair value; the difference between proceeds and fair value is recognized as a grant expense',
      ],
      'correctIndex': 3,
      'explanation':
          'Under IPSAS, concessionary loans are initially measured at fair value. The difference between the loan proceeds and the present value at market rates represents a subsidy/grant expense to be recognized.',
    },
    // Q17 - from Quiz 3
    {
      'question':
          'A ministry builds a road costing SAR 200 million with a 30-year useful life. Under IPSAS, the asset is impaired when:',
      'options': [
        'Its market value drops below book value (IAS 36 approach)',
        'Annual depreciation is missed',
        'Its service potential declines significantly, since roads are non-cash-generating assets (IPSAS 21)',
        'The budget for maintenance is cut',
      ],
      'correctIndex': 2,
      'explanation':
          'Roads are non-cash-generating assets. Under IPSAS 21, impairment is assessed based on decline in service potential (e.g., damage, obsolescence), not market value as under IAS 36.',
    },
    // Q18 - from Quiz 3
    {
      'question':
          'A government budget shows planned spending of SAR 500 million but actual spending was SAR 480 million. Under which standard must this comparison be disclosed?',
      'options': [
        'IAS 1',
        'IFRS 8',
        'IPSAS 24 (Presentation of Budget Information)',
        'IAS 34',
      ],
      'correctIndex': 2,
      'explanation':
          'IPSAS 24 requires entities that make their budgets publicly available to present a comparison of budget and actual amounts in their financial statements. There is no IFRS equivalent.',
    },
    // Q19 - from Quiz 3
    {
      'question':
          'A company reports "profit" of SAR 2 million under IFRS. If the same entity were a government body using IPSAS, what terminology would change?',
      'options': [
        'Nothing -- both use "profit"',
        '"Profit" would become "surplus" and "loss" would become "deficit"',
        '"Profit" would become "revenue"',
        '"Profit" would become "net assets"',
      ],
      'correctIndex': 1,
      'explanation':
          'IPSAS uses "surplus" instead of "profit" and "deficit" instead of "loss" to reflect that governments operate for public service, not for profit.',
    },
    // Q20 - from Quiz 3
    {
      'question':
          'A newly independent country with no existing accounting framework seeks international credibility. What should it adopt for its government accounts?',
      'options': [
        'IFRS, because it is more widely known',
        'No standards -- create custom local rules',
        'IPSAS, starting with Cash Basis IPSAS and transitioning to accrual IPSAS over time',
        'US GAAP for governments',
      ],
      'correctIndex': 2,
      'explanation':
          'For government accounts, IPSAS is the appropriate framework. Starting with Cash Basis IPSAS provides an achievable first step, with IPSAS 33 providing a pathway to full accrual adoption.',
    },
    // ── Quiz 1: Similarities (20 questions from module7-quiz1.ts) ──
    // Q1_1
    {
      'question': 'Who develops IPSAS?',
      'options': [
        'The World Bank',
        'The United Nations',
        'The International Public Sector Accounting Standards Board (IPSASB)',
        'The International Monetary Fund',
      ],
      'correctIndex': 2,
      'explanation':
          'IPSAS is developed by the IPSASB, which operates under the International Federation of Accountants (IFAC).',
    },
    // Q1_2
    {
      'question': 'Which framework serves public sector entities?',
      'options': [
        'IFRS',
        'US GAAP',
        'UK GAAP',
        'IPSAS',
      ],
      'correctIndex': 3,
      'explanation':
          'IPSAS (International Public Sector Accounting Standards) was specifically created for government and public sector entities.',
    },
    // Q1_3
    {
      'question':
          'Which IPSAS standard mirrors IAS 16 for Property, Plant, and Equipment?',
      'options': [
        'IPSAS 1',
        'IPSAS 23',
        'IPSAS 17',
        'IPSAS 39',
      ],
      'correctIndex': 2,
      'explanation':
          'IPSAS 17 mirrors IAS 16 and covers the recognition, measurement, and disclosure of Property, Plant, and Equipment in the public sector.',
    },
    // Q1_4
    {
      'question':
          'Financial instruments classification (AC, FVOCI, FVTPL) is similar under:',
      'options': [
        'IFRS 9 and IPSAS 41',
        'IFRS 15 and IPSAS 23',
        'IFRS 16 and IPSAS 43',
        'IAS 1 and IPSAS 1',
      ],
      'correctIndex': 0,
      'explanation':
          'IFRS 9 (Financial Instruments) and IPSAS 41 share the same three-category classification model: amortized cost, FVOCI, and FVTPL.',
    },
    // Q1_5
    {
      'question':
          'Provisions are recognized when there is a present obligation and:',
      'options': [
        'The entity wants to set aside funds',
        'Management approves them quarterly',
        'A reliable estimate can be made and an outflow is probable',
        'The auditor recommends it',
      ],
      'correctIndex': 2,
      'explanation':
          'Under both IAS 37 and IPSAS 19, provisions are recognized when there is a present obligation, an outflow is probable, and a reliable estimate can be made.',
    },
    // Q1_6
    {
      'question':
          'Cash flow categories are the same under IAS 7 and IPSAS 2: operating, investing, and:',
      'options': [
        'Administrative',
        'Financing',
        'Regulatory',
        'Budgetary',
      ],
      'correctIndex': 1,
      'explanation':
          'Both IAS 7 and IPSAS 2 classify cash flows into three categories: operating, investing, and financing activities.',
    },
    // Q1_7
    {
      'question':
          'Retrospective application applies to accounting policy changes under both:',
      'options': [
        'IAS 2 and IPSAS 12',
        'IAS 16 and IPSAS 17',
        'IFRS 15 and IPSAS 9',
        'IAS 8 and IPSAS 3',
      ],
      'correctIndex': 3,
      'explanation':
          'IAS 8 (Accounting Policies, Changes in Estimates and Errors) and IPSAS 3 both require retrospective application when changing accounting policies.',
    },
    // Q1_8
    {
      'question':
          'Joint arrangements are handled similarly under IFRS 11 and:',
      'options': [
        'IPSAS 17',
        'IPSAS 37',
        'IPSAS 1',
        'IPSAS 23',
      ],
      'correctIndex': 1,
      'explanation':
          'IPSAS 37 mirrors IFRS 11, covering joint arrangements including joint operations and joint ventures in the public sector.',
    },
    // Q1_9
    {
      'question': 'IPSAS focuses on accountability to:',
      'options': [
        'Shareholders only',
        'Bank regulators',
        'Citizens, taxpayers, and resource providers',
        'Corporate boards',
      ],
      'correctIndex': 2,
      'explanation':
          'IPSAS emphasizes accountability to citizens, taxpayers, donors, and other resource providers who fund public services.',
    },
    // Q1_10
    {
      'question':
          'IAS 41 and IPSAS 27 both address which type of assets?',
      'options': [
        'Financial instruments',
        'Intangible assets',
        'Investment property',
        'Biological assets (agriculture)',
      ],
      'correctIndex': 3,
      'explanation':
          'Both IAS 41 and IPSAS 27 deal with agriculture and biological assets, requiring fair value measurement for living plants and animals.',
    },
    // Q1_11
    {
      'question':
          'Employee benefits under IAS 19 and IPSAS 39 use which actuarial method?',
      'options': [
        'Aggregate cost method',
        'Entry age normal method',
        'Projected unit credit method',
        'Individual level premium method',
      ],
      'correctIndex': 2,
      'explanation':
          'Both IAS 19 and IPSAS 39 require the Projected Unit Credit method for measuring defined benefit obligations.',
    },
    // Q1_12
    {
      'question':
          'The equity method for associates is shared between IAS 28 and:',
      'options': [
        'IPSAS 36',
        'IPSAS 17',
        'IPSAS 1',
        'IPSAS 23',
      ],
      'correctIndex': 0,
      'explanation':
          'IPSAS 36 mirrors IAS 28 and requires the equity method for investments in associates and joint ventures.',
    },
    // Q1_13
    {
      'question':
          'Which of the following is NOT a similarity between IFRS and IPSAS?',
      'options': [
        'Both use accrual accounting',
        'Both require a complete set of financial statements',
        'Both address non-exchange revenue from taxation',
        'Both classify cash flows into operating, investing, and financing',
      ],
      'correctIndex': 2,
      'explanation':
          'Non-exchange revenue from taxation is addressed only by IPSAS (IPSAS 23). IFRS does not have a specific standard for tax revenue because private sector entities do not collect taxes.',
    },
    // ── Quiz 2: Differences (20 questions from module7-quiz2.ts) ──
    // Q2_1
    {
      'question':
          'IFRS defines an asset based on expected future economic benefits. IPSAS adds which additional concept?',
      'options': [
        'Market liquidity',
        'Service potential',
        'Dividend yield',
        'Credit rating',
      ],
      'correctIndex': 1,
      'explanation':
          'IPSAS recognizes that public sector assets may have "service potential" -- the capacity to deliver services -- even if they do not generate economic benefits.',
    },
    // Q2_2
    {
      'question':
          'The primary users of IFRS financial statements are capital market participants. Who are the primary users under IPSAS?',
      'options': [
        'Shareholders and analysts',
        'Bond traders and hedge funds',
        'Insurance companies',
        'Service recipients, taxpayers, and oversight bodies',
      ],
      'correctIndex': 3,
      'explanation':
          'IPSAS identifies service recipients, taxpayers, donors, legislators, and oversight bodies as primary users of public sector financial reports.',
    },
    // Q2_3
    {
      'question':
          'Under IFRS 15, revenue is recognized based on performance obligations. IPSAS uses a different model for non-exchange revenue because:',
      'options': [
        'IPSAS does not recognize revenue at all',
        'There is no contract with a customer in taxation',
        'IFRS 15 is too old',
        'IPSAS only uses cash accounting',
      ],
      'correctIndex': 1,
      'explanation':
          'IFRS 15 is built on a five-step customer contract model. Non-exchange transactions like taxes have no customer contract, so IPSAS 23 uses a different recognition approach.',
    },
    // Q2_4
    {
      'question':
          'Government grants received with conditions attached are recognized under IPSAS 23 as:',
      'options': [
        'Immediate revenue',
        'An expense',
        'Equity contribution',
        'A liability until conditions are met',
      ],
      'correctIndex': 3,
      'explanation':
          'When a grant has conditions (e.g., return if not used for the specified purpose), the recipient recognizes a liability until the conditions are satisfied.',
    },
    // Q2_5
    {
      'question':
          'Social benefits (e.g., pensions, welfare) are addressed by IPSAS but have no equivalent in IFRS because:',
      'options': [
        'Private sector companies do not provide social welfare programs to the public',
        'IFRS does not cover any liabilities',
        'Social benefits are always immaterial',
        'IFRS already covers them under IAS 19',
      ],
      'correctIndex': 0,
      'explanation':
          'Social benefits like state pensions, unemployment benefits, and public healthcare are uniquely governmental. IFRS has no equivalent standard because private companies do not provide these societal programs.',
    },
    // Q2_6
    {
      'question':
          'Under IPSAS, government inventories may include items not found in private sector inventories, such as:',
      'options': [
        'Finished goods for retail',
        'Raw materials for manufacturing',
        'Work in progress',
        'Strategic reserves and emergency supplies',
      ],
      'correctIndex': 3,
      'explanation':
          'Government inventories under IPSAS 12 can include strategic reserves (oil, food, medical supplies) and emergency stockpiles not typically found in the private sector.',
    },
    // Q2_7
    {
      'question':
          'Concessionary loans (below-market-rate loans) receive special treatment under IPSAS because:',
      'options': [
        'Governments never borrow money',
        'All government loans are interest-free',
        'The below-market element represents a subsidy or social benefit component',
        'IFRS already covers them adequately',
      ],
      'correctIndex': 2,
      'explanation':
          'Concessionary loans have a below-market interest component that represents a subsidy. IPSAS requires the difference between fair value and proceeds to be recognized separately.',
    },
    // Q2_8
    {
      'question':
          'Peppercorn (nominal-rent) leases are uniquely addressed in IPSAS 43 because:',
      'options': [
        'Governments often receive or grant leases at below-market rates for policy objectives',
        'They do not exist in the private sector',
        'IFRS 16 prohibits below-market leases',
        'They only involve agricultural land',
      ],
      'correctIndex': 0,
      'explanation':
          'Public sector entities commonly enter leases at below-market rates to support social objectives. IPSAS 43 provides specific guidance for measuring and disclosing these arrangements.',
    },
    // Q2_9
    {
      'question':
          'Under IFRS, borrowing costs for qualifying assets must be capitalized (IAS 23). Under IPSAS 5, entities:',
      'options': [
        'Must always capitalize borrowing costs',
        'Must always expense borrowing costs',
        'Have a choice to capitalize or expense borrowing costs',
        'Cannot incur borrowing costs',
      ],
      'correctIndex': 2,
      'explanation':
          'IPSAS 5 allows a choice: entities can either capitalize borrowing costs (like IFRS) or expense them immediately. IFRS mandates capitalization for qualifying assets.',
    },
    // Q2_10
    {
      'question':
          'IPSAS 20 defines related parties more broadly than IAS 24. In the public sector, related parties can include:',
      'options': [
        'Only subsidiaries',
        'Only commercial suppliers',
        'Ministers, senior officials, and their close family members',
        'Only foreign governments',
      ],
      'correctIndex': 2,
      'explanation':
          'IPSAS 20 includes ministers, key management personnel, and their close family members as related parties, reflecting the public sector governance structure.',
    },
    // Q2_11
    {
      'question':
          'Earnings per share (EPS) is required under IFRS (IAS 33). Under IPSAS, EPS:',
      'options': [
        'Is equally required',
        'Is optional',
        'Does not exist because public sector entities do not issue shares to public markets',
        'Is calculated differently',
      ],
      'correctIndex': 2,
      'explanation':
          'There is no IPSAS equivalent to IAS 33 (EPS) because government entities do not issue traded equity shares and therefore have no earnings per share to report.',
    },
    // Q2_12
    {
      'question':
          'Public-Private Partnerships (PPPs) are addressed specifically in IPSAS 32. Under IFRS, they are covered by:',
      'options': [
        'A dedicated PPP standard',
        'IFRIC 12, which addresses only the private sector operator side',
        'IFRS 16 only',
        'PPPs are not covered by any framework',
      ],
      'correctIndex': 1,
      'explanation':
          'IFRIC 12 covers PPPs only from the private operator perspective. IPSAS 32 provides guidance from the government grantor side, filling a gap in public sector accounting.',
    },
    // Q2_13
    {
      'question':
          'The Cash Basis IPSAS is a standard that has no IFRS equivalent because:',
      'options': [
        'IFRS never mentions cash',
        'All IFRS entities already use accrual basis; the Cash Basis IPSAS serves as a stepping stone for developing countries transitioning to accrual',
        'Cash basis is superior to accrual basis',
        'Only three countries use IFRS',
      ],
      'correctIndex': 1,
      'explanation':
          'The Cash Basis IPSAS exists as a transitional standard for governments that have not yet moved to accrual accounting. IFRS does not need this because all IFRS entities already use accrual basis.',
    },
    // ── Quiz 3: Integration (20 questions from module7-quiz3.ts) ──
    // Q3_1
    {
      'question':
          'A government acquires a collection of heritage artwork valued at SAR 50 million. Under IFRS, this would be treated as PP&E. Under IPSAS, how does the treatment differ?',
      'options': [
        'It is expensed immediately under IPSAS',
        'IPSAS does not permit recognition of artwork',
        'Treatment is identical under both frameworks',
        'IPSAS 17 allows recognition as a heritage asset with optional depreciation and special disclosure',
      ],
      'correctIndex': 3,
      'explanation':
          'IPSAS 17 provides specific heritage asset guidance allowing optional depreciation (heritage assets may have indefinite useful lives) and requiring additional disclosures about preservation and significance.',
    },
    // Q3_2
    {
      'question':
          'An entity transitions from cash basis to accrual IPSAS. What relief does IPSAS 33 provide that IFRS 1 does not?',
      'options': [
        'Permanent exemption from financial statement preparation',
        'Permission to skip external audits',
        'A three-year transitional period to recognize and measure assets, liabilities, and revenue',
        'Automatic adoption without any adjustments',
      ],
      'correctIndex': 2,
      'explanation':
          'IPSAS 33 uniquely provides a three-year grace period for first-time adopters to progressively recognize assets and liabilities, acknowledging the massive data gaps governments face when moving from cash to accrual.',
    },
    // Q3_3
    {
      'question':
          'A state-owned enterprise (SOE) listed on the stock exchange should report using:',
      'options': [
        'IPSAS only, because it is government-owned',
        'IFRS, because it is a listed entity with public investors',
        'Neither -- it is exempt from all standards',
        'Any local standard it chooses',
      ],
      'correctIndex': 1,
      'explanation':
          'Listed SOEs typically use IFRS because they have public market investors. IPSAS is designed for public sector entities that are not publicly traded.',
    },
    // Q3_4
    {
      'question':
          'A public hospital charges patients SAR 50 per visit while the actual cost is SAR 300. This is an example of:',
      'options': [
        'A peppercorn/subsidized service delivery with non-exchange revenue elements',
        'An exchange transaction at market rates',
        'A loss-making transaction that should not be recognized',
        'A capital transaction',
      ],
      'correctIndex': 0,
      'explanation':
          'When public entities provide services at below cost, the fee is not an exchange transaction at market rates. The subsidy element is a unique public sector characteristic addressed by IPSAS.',
    },
    // Q3_5
    {
      'question':
          'Under IFRS, consolidation is based on equity ownership and IFRS 10. A government consolidates a regulatory body that it controls through legislation. This is possible under IPSAS because:',
      'options': [
        'IPSAS ignores the concept of control',
        'All government bodies are automatically consolidated',
        'Consolidation is optional in the public sector',
        'IPSAS 35 defines control more broadly to include power from legislation, regulation, or binding agreements',
      ],
      'correctIndex': 3,
      'explanation':
          'IPSAS 35 broadens the concept of control beyond equity ownership to include legislative power, regulatory authority, and binding administrative arrangements.',
    },
    // Q3_6
    {
      'question':
          'A developing country uses cash-basis accounting and wants to adopt IPSAS. What is the recommended transition path?',
      'options': [
        'Immediately adopt full accrual IPSAS without any transitional steps',
        'Skip IPSAS and adopt IFRS instead',
        'Continue with cash basis indefinitely',
        'Start with Cash Basis IPSAS, then progressively move to accrual IPSAS using IPSAS 33 transitional provisions',
      ],
      'correctIndex': 3,
      'explanation':
          'The recommended path is to start with Cash Basis IPSAS to establish basic financial reporting discipline, then use IPSAS 33 transitional provisions to progressively adopt accrual-basis IPSAS.',
    },
    // Q3_7
    {
      'question':
          'Both IAS 16 and IPSAS 17 allow the revaluation model. However, applying revaluation to government infrastructure differs because:',
      'options': [
        'Government assets always increase in value',
        'IPSAS prohibits revaluation for infrastructure',
        'Many government assets have no active market, making fair value determination challenging and requiring depreciated replacement cost approaches',
        'The revaluation model is identical in practice',
      ],
      'correctIndex': 2,
      'explanation':
          'Government infrastructure (dams, highways, pipelines) often has no comparable market transactions. IPSAS guidance permits depreciated replacement cost as a valuation technique when no active market exists.',
    },
    // Q3_8
    {
      'question':
          'A government minister awards a contract to a company owned by her spouse. Under which IPSAS standard must this be disclosed?',
      'options': [
        'IPSAS 1 (Presentation)',
        'IPSAS 20 (Related Party Disclosures)',
        'IPSAS 24 (Budget Information)',
        'IPSAS 14 (Events After Reporting Date)',
      ],
      'correctIndex': 1,
      'explanation':
          'IPSAS 20 requires disclosure of related party transactions. Ministers and their close family members are defined as related parties, making this contract a required disclosure.',
    },
    // Q3_9
    {
      'question':
          'A government signs a 25-year PPP contract for a toll road where a private company builds and operates the road. Under IPSAS 32, the government:',
      'options': [
        'Does not recognize any asset because the private operator manages it',
        'Records only rental income',
        'Recognizes the road as an asset because it controls the service and retains residual interest',
        'Uses IFRS 16 for the arrangement',
      ],
      'correctIndex': 2,
      'explanation':
          'Under IPSAS 32, if the grantor (government) controls the services and residual interest in the asset, it recognizes the PPP asset even though the private operator built and operates it.',
    },
    // Q3_10
    {
      'question':
          'Employee defined-benefit pension obligations are measured using the Projected Unit Credit method under both IAS 19 and IPSAS 39. What additional challenge exists for governments?',
      'options': [
        'Government pension schemes are typically much larger, unfunded, and involve multi-employer plans across the entire civil service',
        'Governments do not offer pensions',
        'The actuarial method is different for governments',
        'IPSAS does not require pension disclosures',
      ],
      'correctIndex': 0,
      'explanation':
          'Government pension obligations are often massive, partially or fully unfunded, and span the entire civil service, creating unique measurement and disclosure challenges beyond typical private sector plans.',
    },
    // Q3_11
    {
      'question':
          'A government entity operates a public bus service at subsidized fares. When classifying revenue, which approach is most correct?',
      'options': [
        'All fare revenue is non-exchange because fares are below cost',
        'Fare revenue is exchange (IPSAS 9) and any government subsidy received is non-exchange (IPSAS 23)',
        'No revenue should be recognized',
        'All revenue is classified as exchange only',
      ],
      'correctIndex': 1,
      'explanation':
          'Fares paid by passengers are exchange transactions (IPSAS 9) because value is exchanged. Government subsidies to cover the deficit are non-exchange transactions (IPSAS 23). Both streams are recognized separately.',
    },
    // Q3_12
    {
      'question':
          'IFRS 5 requires "held for sale" classification and measurement. IPSAS does not have an equivalent because:',
      'options': [
        'Government assets are never sold',
        'IPSAS covers it under a different number',
        'Assets held for sale do not need disclosure',
        'Government asset disposals follow different political and legal processes, and assets are rarely held primarily for resale',
      ],
      'correctIndex': 3,
      'explanation':
          'IPSAS has no equivalent to IFRS 5 because public sector assets are rarely held for sale. Government disposals involve lengthy legislative and administrative processes unlike private sector asset sales.',
    },
    // Q3_13
    {
      'question':
          'Which statement accurately compares segment reporting under IFRS 8 and IPSAS 18?',
      'options': [
        'IFRS 8 uses the management approach; IPSAS 18 uses service segments and geographical segments relevant to public accountability',
        'Both use identical approaches',
        'Neither framework requires segment reporting',
        'IPSAS uses the management approach and IFRS uses service segments',
      ],
      'correctIndex': 0,
      'explanation':
          'IFRS 8 uses the "management approach" based on internal reporting. IPSAS 18 defines segments by service type (e.g., health, education) and geography, which better serves public accountability needs.',
    },
    // Q3_14
    {
      'question':
          'A government entity and a private company both have a lease for office space. Under IFRS 16 and IPSAS 43, what is the key common treatment?',
      'options': [
        'Both expense the lease payments as operating costs',
        'Only the private company recognizes a right-of-use asset',
        'Both recognize a right-of-use asset and lease liability on the balance sheet',
        'Neither recognizes any asset or liability',
      ],
      'correctIndex': 2,
      'explanation':
          'Both IFRS 16 and IPSAS 43 require lessees to recognize a right-of-use asset and lease liability. This is a key similarity -- the single-model lessee accounting applies across both frameworks.',
    },
  ],
  memoryPairs: [
    {'term': 'IPSAS', 'definition': '\u0627\u0644\u0645\u0639\u0627\u064a\u064a\u0631 \u0627\u0644\u0645\u062d\u0627\u0633\u0628\u064a\u0629 \u0627\u0644\u062f\u0648\u0644\u064a\u0629 \u0644\u0644\u0642\u0637\u0627\u0639 \u0627\u0644\u0639\u0627\u0645'},
    {'term': 'IFRS', 'definition': '\u0627\u0644\u0645\u0639\u0627\u064a\u064a\u0631 \u0627\u0644\u062f\u0648\u0644\u064a\u0629 \u0644\u0625\u0639\u062f\u0627\u062f \u0627\u0644\u062a\u0642\u0627\u0631\u064a\u0631 \u0627\u0644\u0645\u0627\u0644\u064a\u0629'},
    {'term': 'Accrual Basis', 'definition': '\u0623\u0633\u0627\u0633 \u0627\u0644\u0627\u0633\u062a\u062d\u0642\u0627\u0642'},
    {'term': 'Service Potential', 'definition': '\u0627\u0644\u0642\u062f\u0631\u0629 \u0627\u0644\u062e\u062f\u0645\u064a\u0629'},
    {'term': 'Non-Exchange Revenue', 'definition': '\u0625\u064a\u0631\u0627\u062f\u0627\u062a \u063a\u064a\u0631 \u062a\u0628\u0627\u062f\u0644\u064a\u0629'},
    {'term': 'Heritage Assets', 'definition': '\u0627\u0644\u0623\u0635\u0648\u0644 \u0627\u0644\u062a\u0631\u0627\u062b\u064a\u0629'},
    {'term': 'Surplus/Deficit', 'definition': '\u0627\u0644\u0641\u0627\u0626\u0636/\u0627\u0644\u0639\u062c\u0632'},
    {'term': 'Concessionary Loan', 'definition': '\u0642\u0631\u0636 \u0645\u064a\u0633\u0651\u0631'},
    {'term': 'Budget Reporting', 'definition': '\u0627\u0644\u062a\u0642\u0627\u0631\u064a\u0631 \u0627\u0644\u0645\u0648\u0627\u0632\u0646\u064a\u0629'},
    {'term': 'Consolidation', 'definition': '\u0627\u0644\u062a\u0648\u062d\u064a\u062f'},
    {'term': 'Fair Value', 'definition': '\u0627\u0644\u0642\u064a\u0645\u0629 \u0627\u0644\u0639\u0627\u062f\u0644\u0629'},
    {'term': 'Impairment', 'definition': '\u0627\u0646\u062e\u0641\u0627\u0636 \u0627\u0644\u0642\u064a\u0645\u0629'},
    {'term': 'Related Party', 'definition': '\u0637\u0631\u0641 \u0630\u0648 \u0639\u0644\u0627\u0642\u0629'},
    {'term': 'Segment Reporting', 'definition': '\u062a\u0642\u0627\u0631\u064a\u0631 \u0627\u0644\u0642\u0637\u0627\u0639\u0627\u062a'},
    {'term': 'Social Benefits', 'definition': '\u0627\u0644\u0645\u0646\u0627\u0641\u0639 \u0627\u0644\u0627\u062c\u062a\u0645\u0627\u0639\u064a\u0629'},
    {'term': 'Exchange Transaction', 'definition': '\u0645\u0639\u0627\u0645\u0644\u0629 \u062a\u0628\u0627\u062f\u0644\u064a\u0629'},
    {'term': 'Provisions', 'definition': '\u0627\u0644\u0645\u062e\u0635\u0635\u0627\u062a'},
    {'term': 'Right-of-Use Asset', 'definition': '\u0623\u0635\u0644 \u062d\u0642 \u0627\u0644\u0627\u0633\u062a\u062e\u062f\u0627\u0645'},
    {'term': 'Cash Basis IPSAS', 'definition': '\u0645\u0639\u064a\u0627\u0631 IPSAS \u0639\u0644\u0649 \u0627\u0644\u0623\u0633\u0627\u0633 \u0627\u0644\u0646\u0642\u062f\u064a'},
    {'term': 'Public Accountability', 'definition': '\u0627\u0644\u0645\u0633\u0627\u0621\u0644\u0629 \u0627\u0644\u0639\u0627\u0645\u0629'},
  ],
  classificationCategories: ['Similar Treatment', 'Different Treatment'],
  classificationItems: [
    // Similar Treatment (12)
    {'name': 'PP&E measurement (cost or revaluation)', 'category': 'Similar Treatment'},
    {'name': 'Accrual basis accounting', 'category': 'Similar Treatment'},
    {'name': 'Lease recognition (right-of-use asset)', 'category': 'Similar Treatment'},
    {'name': 'Provisions recognition criteria', 'category': 'Similar Treatment'},
    {'name': 'Cash flow statement categories', 'category': 'Similar Treatment'},
    {'name': 'Employee benefit measurement', 'category': 'Similar Treatment'},
    {'name': 'Foreign currency translation', 'category': 'Similar Treatment'},
    {'name': 'Investment property models', 'category': 'Similar Treatment'},
    {'name': 'Financial instruments classification', 'category': 'Similar Treatment'},
    {'name': 'Equity method for associates', 'category': 'Similar Treatment'},
    {'name': 'Retrospective accounting policy changes', 'category': 'Similar Treatment'},
    {'name': 'Events after reporting date', 'category': 'Similar Treatment'},
    // Different Treatment (13)
    {'name': 'Non-exchange revenue (taxes, grants)', 'category': 'Different Treatment'},
    {'name': 'Heritage assets treatment', 'category': 'Different Treatment'},
    {'name': 'Budget vs actual reporting', 'category': 'Different Treatment'},
    {'name': 'Social benefits recognition', 'category': 'Different Treatment'},
    {'name': 'Borrowing costs capitalization', 'category': 'Different Treatment'},
    {'name': 'Concessionary loans treatment', 'category': 'Different Treatment'},
    {'name': 'Primary users of financial statements', 'category': 'Different Treatment'},
    {'name': 'Performance measure naming (Profit vs Surplus)', 'category': 'Different Treatment'},
    {'name': 'Asset recognition concept', 'category': 'Different Treatment'},
    {'name': 'Consolidation control concept', 'category': 'Different Treatment'},
    {'name': 'Earnings per share reporting', 'category': 'Different Treatment'},
    {'name': 'First-time adoption transitional relief', 'category': 'Different Treatment'},
    {'name': 'Peppercorn (nominal) leases', 'category': 'Different Treatment'},
  ],
);
