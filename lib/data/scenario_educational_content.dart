// Auto-generated from scenarioEducationalContent.ts
// DO NOT EDIT MANUALLY

// ============================================================================
// MODEL CLASSES
// ============================================================================

class ScenarioEducationalContent {
  final CoreFramework coreFramework;
  final MechanicsProcess mechanicsProcess;
  final FinancialAnalysis financialAnalysis;
  final AccountingTreatment accountingTreatment;
  final StrategicConsiderations strategicConsiderations;
  final PracticalApplication practicalApplication;

  const ScenarioEducationalContent({
    required this.coreFramework,
    required this.mechanicsProcess,
    required this.financialAnalysis,
    required this.accountingTreatment,
    required this.strategicConsiderations,
    required this.practicalApplication,
  });
}

class CoreFramework {
  final String definitionOverview;
  final List<String> keyCharacteristics;
  final List<String> typesClassifications;
  final List<String> advantages;
  final List<String> disadvantages;
  final List<String> whenToUse;
  final List<KeyTerminology> keyTerminology;

  const CoreFramework({
    required this.definitionOverview,
    required this.keyCharacteristics,
    required this.typesClassifications,
    required this.advantages,
    required this.disadvantages,
    required this.whenToUse,
    required this.keyTerminology,
  });
}

class KeyTerminology {
  final String term;
  final String definition;

  const KeyTerminology({required this.term, required this.definition});
}

class MechanicsProcess {
  final String howItWorks;
  final List<String> stepByStepProcess;
  final List<String> keyPartiesInvolved;
  final List<String> documentationRequired;
  final List<String> timelineMilestones;

  const MechanicsProcess({
    required this.howItWorks,
    required this.stepByStepProcess,
    required this.keyPartiesInvolved,
    required this.documentationRequired,
    required this.timelineMilestones,
  });
}

class FinancialAnalysis {
  final String valuationPricing;
  final String costCalculation;
  final List<String> riskFactors;
  final List<String> returnMetrics;
  final List<KeyRatio> keyRatios;
  final String breakEvenAnalysis;

  const FinancialAnalysis({
    required this.valuationPricing,
    required this.costCalculation,
    required this.riskFactors,
    required this.returnMetrics,
    required this.keyRatios,
    required this.breakEvenAnalysis,
  });
}

class KeyRatio {
  final String ratio;
  final String formula;
  final String interpretation;

  const KeyRatio({required this.ratio, required this.formula, required this.interpretation});
}

class AccountingTreatment {
  final String recognitionMeasurement;
  final List<JournalEntry> journalEntries;
  final FinancialStatementImpact financialStatementImpact;
  final List<String> disclosureRequirements;
  final String ifrsVsGaap;

  const AccountingTreatment({
    required this.recognitionMeasurement,
    required this.journalEntries,
    required this.financialStatementImpact,
    required this.disclosureRequirements,
    required this.ifrsVsGaap,
  });
}

class JournalEntry {
  final String debit;
  final String credit;
  final String description;

  const JournalEntry({required this.debit, required this.credit, required this.description});
}

class FinancialStatementImpact {
  final String balanceSheet;
  final String incomeStatement;
  final String cashFlowStatement;

  const FinancialStatementImpact({
    required this.balanceSheet,
    required this.incomeStatement,
    required this.cashFlowStatement,
  });
}

class StrategicConsiderations {
  final List<String> decisionCriteria;
  final String comparisonWithAlternatives;
  final String impactOnFinancialPosition;
  final List<String> commonMistakes;
  final List<String> bestPractices;

  const StrategicConsiderations({
    required this.decisionCriteria,
    required this.comparisonWithAlternatives,
    required this.impactOnFinancialPosition,
    required this.commonMistakes,
    required this.bestPractices,
  });
}

class PracticalApplication {
  final String realWorldExample;
  final String calculationExample;
  final String caseStudy;
  final List<String> industryVariations;
  final List<String> regulatoryConsiderations;

  const PracticalApplication({
    required this.realWorldExample,
    required this.calculationExample,
    required this.caseStudy,
    required this.industryVariations,
    required this.regulatoryConsiderations,
  });
}

// ============================================================================
// FINANCING DECISIONS
// ============================================================================

const ipoContent = ScenarioEducationalContent(
  coreFramework: CoreFramework(
    definitionOverview: 'An Initial Public Offering (IPO) is the process by which a private company offers shares to the public for the first time, transitioning from private to public ownership. This process allows the company to raise equity capital from public investors while providing liquidity for existing shareholders.',
    keyCharacteristics: ['First-time sale of company shares to public investors', 'Requires registration with securities regulators (SEC in US, FCA in UK)', 'Results in company shares being traded on a public stock exchange', 'Subject to ongoing disclosure and compliance requirements', 'Typically involves underwriters who help price and distribute shares'],
    typesClassifications: ['Traditional IPO: Full underwriting with roadshow and book-building', 'Direct Listing: Shares sold directly without underwriters (e.g., Spotify, Slack)', 'SPAC Merger: Going public via Special Purpose Acquisition Company', 'Dutch Auction IPO: Price determined through bidding process (e.g., Google)', 'Best Efforts IPO: Underwriters sell shares on best-efforts basis without guarantee'],
    advantages: ['Access to substantial capital for growth and expansion', 'Enhanced company profile and brand recognition', 'Liquidity for existing shareholders and employee stock options', 'Stock can be used as currency for acquisitions', 'Ability to attract and retain talent through equity compensation', 'Establishes market valuation benchmark'],
    disadvantages: ['Significant costs: underwriting fees (5-7%), legal, accounting, compliance', 'Loss of privacy: extensive disclosure requirements', 'Pressure for short-term results from quarterly reporting', 'Dilution of existing shareholders\' ownership', 'Management time diverted to investor relations', 'Vulnerability to hostile takeovers', 'Lock-up periods restrict insider sales (typically 180 days)'],
    whenToUse: ['Company has achieved sustainable profitability or clear path to profitability', 'Market conditions are favorable (bull market, sector interest)', 'Need for significant capital that exceeds debt capacity', 'Existing shareholders seeking liquidity', 'Company wants to enhance credibility with customers and partners', 'Planning acquisitions using stock as consideration'],
    keyTerminology: [
      KeyTerminology(term: 'Prospectus', definition: 'Legal document filed with regulators containing detailed company information, risks, financials, and use of proceeds'),
      KeyTerminology(term: 'Underwriter', definition: 'Investment bank that helps price, market, and distribute IPO shares, often providing a price guarantee'),
      KeyTerminology(term: 'Book Building', definition: 'Process of generating investor demand and determining IPO price through investor indications of interest'),
      KeyTerminology(term: 'Lock-up Period', definition: 'Contractual restriction preventing insiders from selling shares for a specified period post-IPO (typically 180 days)'),
      KeyTerminology(term: 'Green Shoe Option', definition: 'Over-allotment option allowing underwriters to sell additional shares (typically 15%) to stabilize price'),
      KeyTerminology(term: 'Quiet Period', definition: 'SEC-mandated period restricting company communications before and after IPO'),
    ],
  ),
  mechanicsProcess: MechanicsProcess(
    howItWorks: 'The IPO process involves selecting underwriters, conducting due diligence, filing registration documents with securities regulators, marketing the offering through a roadshow, pricing the shares based on investor demand, and finally allocating and distributing shares to investors on the listing date.',
    stepByStepProcess: ['1. Pre-IPO Preparation (6-12 months): Audit financials, strengthen corporate governance, hire advisors', '2. Underwriter Selection: Issue RFP to investment banks, select lead underwriter(s) based on experience and distribution capability', '3. Due Diligence (2-3 months): Underwriters verify all company information, identify risks', '4. Registration Filing: Submit S-1 (US) or prospectus to regulators, respond to comments', '5. Roadshow (2-3 weeks): Management presents to institutional investors in major financial centers', '6. Book Building: Collect investor indications of interest, gauge demand at various price points', '7. Pricing: Set final IPO price based on demand, typically evening before listing', '8. Allocation: Distribute shares to investors based on order quality and relationship', '9. Listing Day: Shares begin trading on exchange, underwriters may stabilize price', '10. Post-IPO: Analyst coverage begins after quiet period, ongoing compliance'],
    keyPartiesInvolved: ['Issuing Company: The company going public', 'Lead Underwriter(s): Investment banks managing the offering', 'Legal Counsel: Securities lawyers for company and underwriters', 'Auditors: Independent accountants certifying financial statements', 'Securities Regulators: SEC (US), FCA (UK), or equivalent', 'Stock Exchange: NYSE, NASDAQ, LSE, etc.', 'Transfer Agent: Manages share registry and ownership records', 'Institutional Investors: Mutual funds, pension funds, hedge funds', 'Retail Investors: Individual investors'],
    documentationRequired: ['Registration Statement (Form S-1 in US): Complete company disclosure', 'Prospectus: Summary document for investors', 'Audited Financial Statements: 2-3 years of audited financials', 'Underwriting Agreement: Contract between company and underwriters', 'Lock-up Agreements: Insider selling restrictions', 'Legal Opinions: Counsel opinions on securities law compliance', 'Comfort Letters: Auditor letters confirming financial accuracy', 'Corporate Governance Documents: Board charters, bylaws, policies'],
    timelineMilestones: ['T-12 to T-6 months: IPO readiness assessment and preparation', 'T-6 months: Engage underwriters and legal counsel', 'T-4 months: Begin drafting registration statement', 'T-3 months: File confidential registration (if applicable)', 'T-6 weeks: File public registration statement', 'T-3 weeks: Receive SEC comments, file amendments', 'T-2 weeks: Begin roadshow', 'T-1 day: Price IPO after market close', 'T-Day: Shares begin trading', 'T+180 days: Lock-up period expires'],
  ),
  financialAnalysis: FinancialAnalysis(
    valuationPricing: 'IPO valuation uses multiple methodologies: (1) Comparable Company Analysis comparing to similar public companies using EV/Revenue, EV/EBITDA, P/E multiples; (2) Precedent Transaction Analysis reviewing recent IPOs in the sector; (3) Discounted Cash Flow for intrinsic value. A typical IPO discount of 10-20% below fair value is applied to ensure successful first-day trading.',
    costCalculation: 'Total IPO costs typically range from 7-15% of gross proceeds. Underwriting fees: 5-7% (spread between public price and price paid to company). Legal fees: \$1-5 million. Accounting fees: \$1-3 million. SEC registration fees: ~0.01%. Exchange listing fees: \$150,000-500,000. Printing/roadshow: \$500,000-1 million. D&O insurance increase: significant premium.',
    riskFactors: ['Market Risk: Adverse market conditions can delay or cancel IPO', 'Pricing Risk: Setting price too high leads to poor aftermarket performance', 'Execution Risk: Operational issues discovered during due diligence', 'Regulatory Risk: SEC comments or delays in registration', 'Reputation Risk: Failed IPO damages company credibility', 'Lockup Expiration Risk: Share price pressure when insiders can sell'],
    returnMetrics: ['First-Day Return (Pop): Price change from IPO price to first-day close', 'Long-term Returns: Performance vs. market over 1, 3, 5 years', 'Money Left on Table: First-day gains that went to IPO investors instead of company', 'Effective Cost of Capital: Including underpricing and all fees'],
    keyRatios: [
      KeyRatio(ratio: 'Price-to-Earnings (P/E)', formula: 'Market Price / Earnings Per Share', interpretation: 'Higher P/E indicates growth expectations; compare to industry peers'),
      KeyRatio(ratio: 'EV/Revenue', formula: 'Enterprise Value / Annual Revenue', interpretation: 'Used for high-growth companies; typical tech IPOs: 5-15x'),
      KeyRatio(ratio: 'EV/EBITDA', formula: 'Enterprise Value / EBITDA', interpretation: 'Measures value relative to operating cash flow; typical range: 8-15x'),
      KeyRatio(ratio: 'Price-to-Book', formula: 'Market Price / Book Value per Share', interpretation: 'Compares market value to accounting value of equity'),
    ],
    breakEvenAnalysis: 'For the company, break-even on IPO costs occurs when the strategic benefits (lower cost of capital, acquisition currency, employee retention) exceed the ongoing compliance costs and management distraction. Typically, companies should target raising at least \$100 million to justify the fixed costs of going public.',
  ),
  accountingTreatment: AccountingTreatment(
    recognitionMeasurement: 'IPO proceeds are recorded at the actual cash received (gross proceeds less underwriting discounts). Share capital is recorded at par value, with the excess over par recorded as Additional Paid-in Capital (APIC). IPO costs are typically recorded as a reduction to APIC, not expensed.',
    journalEntries: [
      JournalEntry(debit: 'Cash (Net Proceeds)', credit: 'Common Stock (Par Value)', description: 'Record par value of shares issued'),
      JournalEntry(debit: 'Cash (Net Proceeds)', credit: 'Additional Paid-in Capital', description: 'Record excess over par value'),
      JournalEntry(debit: 'Additional Paid-in Capital', credit: 'Cash/Accrued Expenses', description: 'Record direct IPO costs (legal, accounting, underwriting)'),
    ],
    financialStatementImpact: FinancialStatementImpact(
      balanceSheet: 'Assets increase by net cash proceeds. Shareholders\' equity increases by gross proceeds. If costs charged to APIC, total equity increase equals net proceeds. No liability impact unless using convertible securities.',
      incomeStatement: 'Direct IPO costs reduce APIC, not earnings. However, ongoing public company costs (SOX compliance, investor relations, D&O insurance) increase operating expenses going forward.',
      cashFlowStatement: 'Net proceeds shown as \'Proceeds from issuance of common stock\' in Financing Activities. IPO costs may be shown as financing or operating outflows depending on accounting policy.',
    ),
    disclosureRequirements: ['Description of equity transactions in notes to financial statements', 'Pro forma earnings per share reflecting all shares issued', 'Use of proceeds disclosure in prospectus', 'Related party transactions involving IPO', 'Subsequent events related to IPO pricing and closing'],
    ifrsVsGaap: 'Both IFRS (IAS 32) and US GAAP treat direct IPO costs similarly - as a reduction to equity rather than expense. However, IFRS requires more detailed disclosure about the nature and terms of equity instruments. US GAAP (ASC 505) specifically addresses costs of equity transactions. Key difference: IFRS may require bifurcation of complex instruments more frequently than US GAAP.',
  ),
  strategicConsiderations: StrategicConsiderations(
    decisionCriteria: ['Capital Requirements: Do funding needs exceed what private markets can provide?', 'Market Timing: Are equity markets receptive to your sector and story?', 'Company Readiness: Are systems, controls, and management team IPO-ready?', 'Valuation: Will public markets value company appropriately?', 'Alternative Options: Have private equity, strategic sale, or debt been considered?', 'Shareholder Objectives: Do existing shareholders want liquidity?'],
    comparisonWithAlternatives: 'vs. Private Equity: PE provides capital without public scrutiny but may require board control. vs. Strategic Sale: Full liquidity but loss of independence. vs. Direct Listing: Lower cost but no capital raise and no underwriter price support. vs. SPAC: Faster timeline but may result in lower valuation and higher dilution. vs. Debt: No dilution but requires cash flow for repayment.',
    impactOnFinancialPosition: 'Equity increases by net proceeds, improving book value and reducing leverage ratios. Cost of capital may decrease due to improved liquidity and diversified investor base. However, ongoing compliance costs and management distraction can impact operating efficiency. Market volatility adds earnings pressure from stock-based compensation accounting.',
    commonMistakes: ['Going public too early before achieving sustainable metrics', 'Overpricing the IPO, leading to poor aftermarket performance', 'Underestimating ongoing public company costs and time requirements', 'Inadequate internal controls and systems preparation', 'Poor communication with analysts and investors post-IPO', 'Failing to retain key employees through transition', 'Not planning for lock-up expiration selling pressure'],
    bestPractices: ['Begin IPO preparation 12-18 months before target date', 'Implement public company-grade financial reporting and controls early', 'Build relationships with potential investors before IPO process', 'Price conservatively to ensure positive aftermarket performance', 'Develop compelling equity story with clear growth drivers', 'Establish strong investor relations function', 'Maintain regular communication cadence with analysts and investors'],
  ),
  practicalApplication: PracticalApplication(
    realWorldExample: 'Airbnb IPO (December 2020): Priced at \$68/share, opened at \$146 (115% first-day pop). Raised \$3.5 billion at \$47 billion valuation. Unique timing during COVID recovery. Used traditional IPO despite direct listing trend in tech. Strong demand despite unprofitable operations, demonstrating investor appetite for growth stories.',
    calculationExample: 'Company targets \$200M IPO at \$20/share (10M shares). Underwriting fee: 6% = \$12M. Other costs: \$5M. Net proceeds: \$183M. If first-day close is \$25, money left on table = 10M × (\$25-\$20) = \$50M. Effective dilution: 10M new shares / (100M existing + 10M new) = 9.1%. Post-money valuation: 110M × \$25 = \$2.75B.',
    caseStudy: 'Facebook IPO (2012): Largest tech IPO at \$16B raised. Priced at \$38, closed flat day 1, fell 50% in months. Lessons: (1) Valuation stretched at 100x earnings; (2) Mobile transition concerns not addressed; (3) Technical glitches damaged confidence. Eventually recovered, demonstrating long-term value can overcome poor IPO execution.',
    industryVariations: ['Technology: Higher multiples, focus on revenue growth, often unprofitable at IPO', 'Biotech: May IPO pre-revenue based on pipeline value, high risk/reward', 'Financial Services: Requires regulatory approvals, focus on book value', 'REITs: Must meet specific IRS requirements, focus on FFO and dividend yield', 'Consumer/Retail: Emphasis on same-store sales and brand value'],
    regulatoryConsiderations: ['SEC Registration: Form S-1 filing and review process (US)', 'Sarbanes-Oxley Compliance: Internal control requirements for US public companies', 'Exchange Listing Standards: Minimum requirements for share price, shareholders, market cap', 'Blue Sky Laws: State securities law compliance', 'International: FCA (UK), AMF (France), BaFin (Germany) requirements vary', 'JOBS Act: Emerging Growth Company exemptions for smaller IPOs'],
  ),
);

const retainedEarningsContent = ScenarioEducationalContent(
  coreFramework: CoreFramework(
    definitionOverview: 'Retained earnings represent the cumulative net income of a company that has been reinvested in the business rather than distributed to shareholders as dividends. This internal financing source is the most common and often least expensive form of equity financing, as it avoids flotation costs and does not dilute existing ownership.',
    keyCharacteristics: ['Internal source of funding from accumulated profits', 'No flotation costs or transaction expenses', 'No dilution of existing shareholder ownership', 'Controlled by board of directors through dividend policy', 'Limited by company\'s profitability and dividend commitments', 'Represents shareholders\' residual claim on company assets'],
    typesClassifications: ['Appropriated Retained Earnings: Restricted for specific purposes (e.g., plant expansion)', 'Unappropriated Retained Earnings: Available for general corporate purposes', 'Statutory Reserves: Required by law in some jurisdictions', 'Treasury Stock Transactions: Can affect retained earnings balance'],
    advantages: ['Zero flotation or issuance costs', 'No dilution of ownership or voting control', 'No fixed repayment obligations', 'Signals management confidence in future projects', 'Maintains financial flexibility', 'No disclosure requirements for use of funds', 'Available immediately without external approval'],
    disadvantages: ['Limited by current profitability', 'Opportunity cost: shareholders may prefer dividends', 'May indicate lack of profitable investment opportunities if too high', 'Subject to \'free cash flow\' agency problems', 'Tax disadvantage in some jurisdictions vs. debt', 'Reduces dividend payout, potentially affecting stock price'],
    whenToUse: ['Company has profitable investment opportunities exceeding cost of capital', 'External financing costs are high relative to internal funds', 'Maintaining low leverage is strategically important', 'Company wants to preserve financial flexibility', 'Shareholders prefer capital gains over dividend income', 'Market conditions make external equity unattractive'],
    keyTerminology: [
      KeyTerminology(term: 'Plowback Ratio', definition: 'Proportion of earnings retained (1 - Dividend Payout Ratio), also called retention ratio'),
      KeyTerminology(term: 'Dividend Payout Ratio', definition: 'Percentage of net income distributed as dividends (Dividends / Net Income)'),
      KeyTerminology(term: 'Sustainable Growth Rate', definition: 'Maximum growth rate achievable without external financing = ROE × Retention Ratio'),
      KeyTerminology(term: 'Free Cash Flow', definition: 'Cash available after operating expenses and capital expenditures'),
      KeyTerminology(term: 'Accumulated Deficit', definition: 'Negative retained earnings when cumulative losses exceed cumulative profits'),
    ],
  ),
  mechanicsProcess: MechanicsProcess(
    howItWorks: 'After calculating net income, the board of directors decides what portion to distribute as dividends and what portion to retain. The retained portion automatically increases shareholders\' equity on the balance sheet and is available for reinvestment in operations, capital expenditures, debt repayment, or other corporate purposes.',
    stepByStepProcess: ['1. Calculate Net Income: Revenue less all expenses, taxes, and interest', '2. Board Review: Evaluate investment opportunities and capital needs', '3. Dividend Decision: Board declares dividend based on policy and cash needs', '4. Retention: Remaining profit after dividends is retained', '5. Allocation: Management deploys retained funds to approved projects', '6. Reporting: Update retained earnings in financial statements', '7. Disclosure: Report changes in statement of shareholders\' equity'],
    keyPartiesInvolved: ['Board of Directors: Sets dividend policy and approves retention', 'Management: Proposes dividend and identifies investment opportunities', 'Shareholders: Ultimate beneficiaries of retained earnings', 'CFO/Finance Team: Manages capital allocation decisions', 'Auditors: Verify retained earnings calculations and presentation'],
    documentationRequired: ['Board Resolution: Approving dividend declaration or retention', 'Financial Statements: Audited income statement and balance sheet', 'Capital Budget: Planned use of retained funds', 'Dividend Policy: Formal statement of dividend approach', 'Statement of Changes in Equity: Showing retained earnings movement'],
    timelineMilestones: ['Quarter/Year End: Calculate net income', 'Board Meeting: Review financials and declare dividend (typically within 30-45 days)', 'Record Date: Determine shareholders eligible for dividend', 'Payment Date: Distribute dividend (typically 2-4 weeks after record date)', 'Financial Reporting: File quarterly/annual statements showing retained earnings'],
  ),
  financialAnalysis: FinancialAnalysis(
    valuationPricing: 'The implicit cost of retained earnings equals the cost of common equity, as shareholders forgo dividends that could be reinvested elsewhere. Using CAPM: Cost of Retained Earnings = Risk-Free Rate + Beta × Market Risk Premium. Unlike new equity, no flotation cost adjustment is needed. Typical range: 8-15% depending on company risk profile.',
    costCalculation: 'Cost of Retained Earnings (re) = rf + β(rm - rf), where rf = risk-free rate, β = company beta, rm = expected market return. Example: If rf = 3%, β = 1.2, market risk premium = 6%, then re = 3% + 1.2(6%) = 10.2%. No direct costs, but opportunity cost to shareholders is significant.',
    riskFactors: ['Profitability Risk: Retained earnings depend on continued profitability', 'Agency Risk: Management may invest in suboptimal projects', 'Opportunity Cost: Shareholders may prefer direct returns', 'Dividend Expectation Risk: Cutting dividends to retain more causes negative signal', 'Reinvestment Risk: Projects may not achieve hurdle rate returns'],
    returnMetrics: ['Return on Retained Earnings: Incremental profit / Retained earnings invested', 'Sustainable Growth Rate: ROE × Retention Ratio', 'Plowback Ratio: 1 - Dividend Payout Ratio', 'Earnings Retention Rate: Retained Earnings / Net Income'],
    keyRatios: [
      KeyRatio(ratio: 'Return on Equity (ROE)', formula: 'Net Income / Shareholders\' Equity', interpretation: 'Measures return on all equity including retained earnings; benchmark against cost of equity'),
      KeyRatio(ratio: 'Retention Ratio', formula: '1 - (Dividends / Net Income)', interpretation: 'Higher ratio = more internal funding; typical range 30-70%'),
      KeyRatio(ratio: 'Sustainable Growth Rate', formula: 'ROE × Retention Ratio', interpretation: 'Maximum growth without external financing; higher is better if ROE > cost of equity'),
      KeyRatio(ratio: 'Dividend Payout Ratio', formula: 'Dividends / Net Income', interpretation: 'Complement of retention ratio; mature companies typically 40-60%'),
    ],
    breakEvenAnalysis: 'Retained earnings create value when reinvested at returns exceeding the cost of equity. Break-even: Project IRR = Cost of Equity. If ROE > Cost of Equity, retention creates value. If ROE < Cost of Equity, shareholders would be better served by receiving dividends.',
  ),
  accountingTreatment: AccountingTreatment(
    recognitionMeasurement: 'Retained earnings increase automatically by net income and decrease by dividends declared. No separate recognition event for retention. Carried at historical accumulated amount on balance sheet. Prior period adjustments and accounting changes may directly affect retained earnings.',
    journalEntries: [
      JournalEntry(debit: 'Income Summary (Net Income)', credit: 'Retained Earnings', description: 'Close net income to retained earnings at period end'),
      JournalEntry(debit: 'Retained Earnings', credit: 'Dividends Payable', description: 'Record dividend declaration'),
      JournalEntry(debit: 'Retained Earnings', credit: 'Prior Period Adjustment', description: 'Record material error corrections'),
    ],
    financialStatementImpact: FinancialStatementImpact(
      balanceSheet: 'Retained earnings appears in shareholders\' equity section. Increases with net income, decreases with dividends and some equity transactions. Accumulated deficit shown if negative.',
      incomeStatement: 'No direct impact. Net income flows to retained earnings at period close.',
      cashFlowStatement: 'No direct impact on financing activities unless dividends paid. Net income starts operating activities section.',
    ),
    disclosureRequirements: ['Statement of Changes in Equity showing movement in retained earnings', 'Beginning balance, net income, dividends, other adjustments, ending balance', 'Any restrictions or appropriations of retained earnings', 'Nature of prior period adjustments affecting retained earnings', 'Dividend per share information'],
    ifrsVsGaap: 'Treatment is substantially similar under both frameworks. IFRS uses \'Retained Earnings\' or \'Accumulated Profits\' terminology. Both require Statement of Changes in Equity. GAAP allows Statement of Retained Earnings as alternative. IFRS has more extensive guidance on other comprehensive income items that bypass income statement.',
  ),
  strategicConsiderations: StrategicConsiderations(
    decisionCriteria: ['Investment Opportunity Set: Are there projects with IRR > cost of capital?', 'Shareholder Preferences: Do investors prefer dividends or capital gains?', 'Tax Environment: Capital gains vs. dividend tax rates', 'Company Life Cycle: Growth companies retain more; mature companies pay out', 'Financial Flexibility: Need for reserves and future opportunities', 'Signaling: What does dividend level communicate to market?'],
    comparisonWithAlternatives: 'vs. New Equity: Retained earnings avoids flotation costs (5-7% saved) and dilution. vs. Debt: No tax shield but no fixed obligations. vs. Hybrid Securities: Simpler but less flexibility. Retained earnings is preferred when company has good investment opportunities and shareholders are in high tax brackets favoring capital gains.',
    impactOnFinancialPosition: 'Increases shareholders\' equity and book value. Improves debt-to-equity ratio if retained rather than borrowing. Provides buffer against financial distress. May lower cost of capital over time. Demonstrates self-funding capability to credit markets.',
    commonMistakes: ['Retaining earnings without profitable investment opportunities (empire building)', 'Ignoring shareholder preference for dividends in mature industries', 'Failing to communicate retention strategy to investors', 'Using retained earnings for acquisitions at excessive valuations', 'Not considering tax efficiency of retention vs. payout', 'Maintaining excessive cash reserves earning below cost of capital'],
    bestPractices: ['Establish clear dividend policy linked to business cycle and investment needs', 'Communicate capital allocation framework to shareholders', 'Ensure reinvestment returns exceed cost of equity', 'Balance retention with shareholder liquidity needs', 'Regularly review and adjust policy as company matures', 'Consider share buybacks as alternative return mechanism'],
  ),
  practicalApplication: PracticalApplication(
    realWorldExample: 'Berkshire Hathaway has never paid a dividend, retaining all earnings for reinvestment. Warren Buffett argues that as long as he can generate returns above the cost of capital, shareholders are better served by retention. The stock\'s long-term performance validates this approach for skilled capital allocators.',
    calculationExample: 'Company has net income of \$10M, existing retained earnings of \$50M. Board declares \$3M dividend. New Retained Earnings = \$50M + \$10M - \$3M = \$57M. Retention Ratio = \$7M / \$10M = 70%. If ROE = 15%, Sustainable Growth Rate = 15% × 70% = 10.5%.',
    caseStudy: 'Apple\'s Dividend Initiation (2012): After years of retaining earnings and accumulating \$100B+ cash, Apple initiated dividends under pressure from shareholders like Carl Icahn. The decision reflected: (1) Massive cash exceeding investment needs; (2) Low interest rate environment; (3) Shareholder preference for returns. Balance between retention for innovation and shareholder returns.',
    industryVariations: ['Technology: High retention (60-100%) for R&D and growth', 'Utilities: Low retention (30-40%) due to regulated returns and stable cash flows', 'Financial Services: Moderate retention subject to regulatory capital requirements', 'Consumer Staples: Moderate retention with consistent dividend tradition', 'Startups: 100% retention typical until profitability established'],
    regulatoryConsiderations: ['Corporate Law: Many jurisdictions restrict dividends to retained earnings/profits', 'Bank Capital: Retained earnings contribute to Tier 1 capital requirements', 'Insurance: Solvency requirements may restrict dividend distributions', 'Tax Law: Accumulated earnings tax in US penalizes excessive retention', 'Securities Law: Disclosure of dividend policy in prospectus and annual reports'],
  ),
);

const newSharesContent = ScenarioEducationalContent(
  coreFramework: CoreFramework(
    definitionOverview: 'Issuing new shares (also called a seasoned equity offering or follow-on offering) is the process by which a publicly traded company sells additional shares to raise capital. Unlike an IPO, this involves a company that already has shares trading in the public market.',
    keyCharacteristics: ['Sold by companies already publicly traded', 'Can be sold to existing shareholders (rights issue) or general public', 'Typically priced at a discount to current market price', 'Dilutes existing shareholders\' ownership percentage', 'Subject to securities regulations but simpler than IPO process', 'May include primary shares (new capital to company) and/or secondary shares (existing shareholder sales)'],
    typesClassifications: ['Follow-on Public Offering (FPO): Marketed offering to institutional and retail investors', 'Rights Issue: Existing shareholders given right to buy new shares pro-rata', 'Private Placement (PIPE): Sold directly to qualified institutional investors', 'At-the-Market (ATM) Offering: Sold gradually at prevailing market prices', 'Bought Deal: Underwriter commits to buy entire offering upfront', 'Accelerated Book Build: Rapid overnight book-building process'],
    advantages: ['Access to significant capital for growth or restructuring', 'Faster and less expensive than IPO process', 'Improves balance sheet and reduces leverage', 'Can be used to fund acquisitions', 'Existing market price provides valuation benchmark', 'Multiple structures available to match company needs'],
    disadvantages: ['Dilutes existing shareholders\' ownership and EPS', 'Often signals that management believes stock is overvalued', 'Stock price typically drops on announcement (2-3% average)', 'Underwriting fees (2-5% of proceeds)', 'May face shareholder resistance or activist opposition', 'Requires disclosure of intended use of proceeds'],
    whenToUse: ['Stock price at or near historical highs', 'Acquisition opportunity requiring equity financing', 'Debt levels too high and deleveraging needed', 'Significant growth opportunity requiring capital', 'Strong investor demand for company shares', 'To strengthen balance sheet before economic uncertainty'],
    keyTerminology: [
      KeyTerminology(term: 'Dilution', definition: 'Reduction in existing shareholders\' ownership percentage due to new share issuance'),
      KeyTerminology(term: 'Shelf Registration', definition: 'Pre-approved SEC registration allowing rapid issuance when market conditions favorable'),
      KeyTerminology(term: 'Greenshoe Option', definition: 'Underwriter option to sell additional shares (typically 15%) for price stabilization'),
      KeyTerminology(term: 'Rights Issue', definition: 'Offering where existing shareholders have preferential right to buy new shares'),
      KeyTerminology(term: 'PIPE', definition: 'Private Investment in Public Equity - sale to accredited investors at negotiated price'),
    ],
  ),
  mechanicsProcess: MechanicsProcess(
    howItWorks: 'The company works with underwriters to structure, price, and market the offering. For a traditional follow-on, a prospectus supplement is filed with regulators, shares are marketed to institutional investors, priced at a discount to market, and settled through the existing share infrastructure.',
    stepByStepProcess: ['1. Board Approval: Authorize share issuance within existing or new authorization', '2. Underwriter Selection: Engage investment banks based on expertise and distribution', '3. Due Diligence: Update disclosure documents, verify material information', '4. Filing: Submit prospectus supplement to SEC (if shelf-registered) or full registration', '5. Marketing: Conduct investor calls or roadshow to generate demand', '6. Book Building: Collect investor orders at various price points', '7. Pricing: Set offer price (typically after market close, at discount to closing price)', '8. Allocation: Distribute shares to investors based on order quality', '9. Settlement: Shares delivered and funds received (T+2 typically)', '10. Stabilization: Underwriters may support price in aftermarket'],
    keyPartiesInvolved: ['Issuing Company: Determines offering size, timing, and use of proceeds', 'Lead Underwriter(s): Structure, price, and distribute the offering', 'Legal Counsel: Prepare disclosure documents and ensure compliance', 'Auditors: Provide comfort letter on financial statements', 'Institutional Investors: Primary buyers of new shares', 'Existing Shareholders: May participate to prevent dilution'],
    documentationRequired: ['Prospectus Supplement: Updates to base shelf prospectus', 'Underwriting Agreement: Terms between company and banks', 'Legal Opinions: Counsel opinions on securities compliance', 'Comfort Letters: Auditor verification of financials', 'Officer Certificates: Management representations', 'Board Resolutions: Authorization of share issuance'],
    timelineMilestones: ['Day -14: Engage underwriters, begin due diligence', 'Day -7: Draft prospectus supplement', 'Day -3: File prospectus with SEC', 'Day -2 to -1: Marketing and book building', 'Day 0 (after market close): Price offering', 'Day +1: Announce pricing, begin trading of new shares', 'Day +2: Settlement (T+2)'],
  ),
  financialAnalysis: FinancialAnalysis(
    valuationPricing: 'Pricing considers: (1) Current market price as anchor; (2) Typical discount of 3-7% for marketed deals, more for accelerated offerings; (3) Comparable offering discounts; (4) Investor demand during book building. Example: Stock at \$50, offering priced at \$47 (6% discount).',
    costCalculation: 'Total cost includes: Underwriting spread (2-5% of gross proceeds), legal fees (\$500K-\$2M), accounting fees (\$200K-\$500K), printing/filing fees (\$100K-\$300K). Example: \$500M offering with 4% spread = \$20M underwriting fee + \$2M other costs = \$22M total (4.4% of gross).',
    riskFactors: ['Market Risk: Stock price decline before pricing', 'Execution Risk: Insufficient investor demand', 'Dilution Risk: Larger than expected EPS impact', 'Signaling Risk: Market interprets as stock overvalued', 'Timing Risk: Market conditions deteriorate during process', 'Regulatory Risk: SEC review delays'],
    returnMetrics: ['Dilution: New Shares / (Existing + New Shares)', 'Pro Forma EPS Impact: Old EPS × (Old Shares / New Total Shares)', 'Accretion/Dilution Analysis: If proceeds earn more than pro forma EPS decline', 'Cost of Equity: Required return on new shares issued'],
    keyRatios: [
      KeyRatio(ratio: 'Dilution Percentage', formula: 'New Shares / Total Shares Post-Offering', interpretation: '10% dilution means existing shareholders now own 90% of larger company'),
      KeyRatio(ratio: 'Price-to-Offering Price', formula: 'Current Price / Offering Price', interpretation: 'Measures if offering was well-priced; >1 means successful'),
      KeyRatio(ratio: 'Gross Spread', formula: 'Gross Proceeds - Net Proceeds', interpretation: 'Underwriter compensation; typically 2-5% for follow-ons'),
    ],
    breakEvenAnalysis: 'Equity offering creates value if the return on invested proceeds exceeds the cost of equity. Break-even: Project Returns = Cost of Equity (typically 8-15%). If company invests at 15% return with 10% cost of equity, offering is value-accretive despite dilution.',
  ),
  accountingTreatment: AccountingTreatment(
    recognitionMeasurement: 'Record new shares at actual proceeds received. Par value to Common Stock account, excess to Additional Paid-in Capital. Direct offering costs reduce APIC, not expensed through income statement. No impact on retained earnings.',
    journalEntries: [
      JournalEntry(debit: 'Cash (Net Proceeds)', credit: 'Common Stock (Par Value)', description: 'Record par value of new shares'),
      JournalEntry(debit: 'Cash (Net Proceeds)', credit: 'Additional Paid-in Capital', description: 'Record amount above par'),
      JournalEntry(debit: 'Additional Paid-in Capital', credit: 'Cash/Payables', description: 'Record direct issuance costs'),
    ],
    financialStatementImpact: FinancialStatementImpact(
      balanceSheet: 'Cash increases by net proceeds. Shareholders\' equity increases. Share count increases. No change to liabilities. Book value per share may increase or decrease depending on offer price vs. current book value.',
      incomeStatement: 'No direct impact. EPS diluted due to higher share count. Ongoing interest savings if proceeds used to repay debt.',
      cashFlowStatement: 'Net proceeds shown as \'Proceeds from issuance of common stock\' in Financing Activities.',
    ),
    disclosureRequirements: ['Number of shares issued and proceeds received', 'Use of proceeds (actual vs. planned)', 'Pro forma financial statements showing offering impact', 'Dilution analysis for existing shareholders', 'Related party participation in offering'],
    ifrsVsGaap: 'Treatment largely consistent. Both require direct costs to reduce equity (APIC). IFRS (IAS 32) and US GAAP (ASC 505) align on basic accounting. Key considerations: classification of complex instruments, and whether any hybrid features require separate accounting.',
  ),
  strategicConsiderations: StrategicConsiderations(
    decisionCriteria: ['Current Valuation: Is stock at attractive level for issuance?', 'Use of Proceeds: Clear value-creating purpose identified?', 'Alternative Funding: Are debt or other options more efficient?', 'Shareholder Base: Will existing shareholders support?', 'Market Conditions: Is equity market receptive?', 'Competitive Position: Will dilution weaken vs. competitors?'],
    comparisonWithAlternatives: 'vs. Debt: No fixed payments but dilutes ownership and may signal overvaluation. vs. Convertibles: Lower initial dilution but eventual conversion. vs. Asset Sales: No dilution but reduces asset base. vs. Retained Earnings: No external costs but limited by profitability. Equity best when leverage is high and growth opportunities strong.',
    impactOnFinancialPosition: 'Immediately strengthens balance sheet. Reduces leverage ratios. May lower cost of capital. Dilutes EPS in short term but can be accretive if proceeds well-invested. Increases financial flexibility for future opportunities or downturns.',
    commonMistakes: ['Issuing during market downturns at depressed prices', 'Unclear or unconvincing use of proceeds', 'Excessive dilution alienating existing shareholders', 'Poor communication leading to negative market reaction', 'Mispricing relative to market conditions', 'Not considering rights issue as less dilutive alternative'],
    bestPractices: ['Issue when stock price is strong relative to history', 'Clearly articulate compelling use of proceeds', 'Consider rights issue to protect existing shareholders', 'Time execution for favorable market windows', 'Maintain strong investor relations before and after', 'Consider shelf registration for future flexibility'],
  ),
  practicalApplication: PracticalApplication(
    realWorldExample: 'Tesla (2020): Raised \$12B through three at-the-market offerings as stock soared 700%. Used proceeds for general corporate purposes and capacity expansion. Well-timed issuance at peak valuations, demonstrating opportunistic capital raising when market provides favorable terms.',
    calculationExample: 'Company with 100M shares at \$50 (\$5B market cap) issues 10M new shares at \$47 (6% discount). Gross proceeds: \$470M. Net (after 3.5% spread): \$453.5M. Post-offering: 110M shares. Dilution: 10M/110M = 9.1%. If current EPS = \$2.00, pro forma EPS = \$2.00 × (100/110) = \$1.82 (9% dilution to EPS).',
    caseStudy: 'General Electric (2018): \$4B equity offering at \$11.67 during turnaround. Stock had fallen from \$30. Offering necessary to strengthen balance sheet but signaled distress. Shares continued declining post-offering. Lessons: (1) Forced offerings during weakness destroy value; (2) Strong companies issue from position of strength; (3) Use of proceeds messaging critical.',
    industryVariations: ['Technology: Frequent issuers, often ATM programs for flexibility', 'Biotech: Fund clinical trials, often multiple offerings before profitability', 'REITs: Regular issuers to fund property acquisitions, strict regulations', 'Airlines: Pandemic forced massive dilutive offerings (2020)', 'Banks: Regulatory capital requirements drive issuance decisions'],
    regulatoryConsiderations: ['Shelf Registration (Form S-3): Allows pre-approved rapid issuance', 'Regulation S: International offerings outside US', 'Rule 144A: Private placements to qualified institutional buyers', 'Stock Exchange Rules: Shareholder approval may be required for large offerings', 'Insider Trading: Restrictions during offering period', 'Material Non-Public Information: Cannot issue while in possession of MNPI'],
  ),
);

const shortTermLoanContent = ScenarioEducationalContent(
  coreFramework: CoreFramework(
    definitionOverview: 'A short-term loan is debt financing with a maturity of one year or less, used to finance working capital needs, seasonal inventory buildups, or bridge temporary cash flow gaps. These loans provide operational flexibility without long-term commitment and are typically less expensive than long-term debt due to lower duration risk.',
    keyCharacteristics: ['Maturity of one year or less (typically 30-365 days)', 'Generally lower interest rates than long-term debt', 'May be secured (collateralized) or unsecured', 'Often tied to specific working capital needs', 'Requires more frequent refinancing/rollover', 'Usually from commercial banks or money markets'],
    typesClassifications: ['Revolving Credit Line: Committed facility with flexible drawdowns', 'Term Loan (Short-term): Fixed amount for specific period', 'Bridge Loan: Temporary financing until permanent funding arranged', 'Accounts Receivable Financing: Borrowing against receivables', 'Inventory Financing: Loans secured by inventory', 'Commercial Paper: Unsecured notes sold in money markets (large companies)'],
    advantages: ['Lower interest rates than long-term debt', 'Flexibility to match financing with need duration', 'Easier to obtain than long-term commitments', 'No prepayment penalties typically', 'Preserves long-term borrowing capacity', 'Can be adjusted as business needs change'],
    disadvantages: ['Refinancing risk: may not be able to renew', 'Interest rate risk on floating-rate facilities', 'More frequent administrative burden', 'May require more collateral/covenants', 'Not suitable for long-term investments', 'Credit availability depends on market conditions'],
    whenToUse: ['Seasonal working capital needs (inventory buildup)', 'Bridge financing for pending long-term financing', 'Temporary cash flow timing mismatches', 'Short-term investment opportunities', 'Managing accounts receivable collection gaps', 'When interest rate environment favors short-term borrowing'],
    keyTerminology: [
      KeyTerminology(term: 'Working Capital', definition: 'Current assets minus current liabilities; short-term loans often finance working capital needs'),
      KeyTerminology(term: 'Revolving Credit Facility', definition: 'Credit line that can be drawn, repaid, and redrawn up to commitment amount'),
      KeyTerminology(term: 'SOFR', definition: 'Secured Overnight Financing Rate - benchmark rate replacing LIBOR for floating-rate loans'),
      KeyTerminology(term: 'Commitment Fee', definition: 'Fee paid on undrawn portion of credit facility (typically 0.25-0.50%)'),
      KeyTerminology(term: 'Line of Credit', definition: 'Pre-approved borrowing limit; draws and repayments flexible within limit'),
    ],
  ),
  mechanicsProcess: MechanicsProcess(
    howItWorks: 'The borrower applies to a lender (typically a commercial bank) for credit. After credit analysis, the lender offers terms including interest rate, fees, covenants, and collateral requirements. Once documented, the borrower can draw funds as needed (revolving) or receive a lump sum (term). Interest accrues on outstanding balance and principal is repaid at maturity or per amortization schedule.',
    stepByStepProcess: ['1. Identify Need: Quantify short-term financing requirement', '2. Lender Selection: Approach relationship bank(s) or shop competitive terms', '3. Application: Submit financial statements, projections, purpose description', '4. Credit Analysis: Lender evaluates creditworthiness and collateral', '5. Term Sheet: Lender proposes key terms and conditions', '6. Negotiation: Discuss rate, fees, covenants, security package', '7. Documentation: Execute loan agreement and security documents', '8. Funding: Draw funds as per facility terms', '9. Compliance: Meet reporting and covenant requirements', '10. Repayment: Repay principal and interest at maturity'],
    keyPartiesInvolved: ['Borrower: Company seeking short-term financing', 'Lender: Commercial bank, credit union, or finance company', 'Legal Counsel: Document loan agreement and security interests', 'Auditors: May provide comfort on financial statements', 'Collateral Agent: Manages security interests if syndicated'],
    documentationRequired: ['Loan Application: Basic company and financing request information', 'Financial Statements: 2-3 years historical, current interim, projections', 'Loan Agreement: Master terms governing the facility', 'Promissory Note: Evidence of debt obligation', 'Security Agreement: Collateral pledge documents (if secured)', 'Corporate Resolutions: Board authorization to borrow', 'Compliance Certificate: Periodic attestation of covenant compliance'],
    timelineMilestones: ['Week 1: Initial application and information gathering', 'Week 2-3: Credit analysis and term sheet', 'Week 3-4: Documentation negotiation', 'Week 4-5: Execution and funding', 'Ongoing: Quarterly compliance reporting', 'Maturity: Repayment or refinancing'],
  ),
  financialAnalysis: FinancialAnalysis(
    valuationPricing: 'Interest rate typically based on benchmark (SOFR, Prime) plus spread reflecting credit risk. Investment grade: SOFR + 100-200 bps. Non-investment grade: SOFR + 300-500+ bps. All-in cost includes commitment fees, arrangement fees, and any required compensating balances.',
    costCalculation: 'All-in Cost = (Interest Rate × Average Balance) + Commitment Fee × Undrawn Amount + Upfront Fees amortized. Example: \$10M facility at SOFR+200bps, 50% average utilization, 0.25% commitment fee, \$50K upfront fee. If SOFR=5%: Interest = 7% × \$5M = \$350K. Commitment = 0.25% × \$5M = \$12.5K. Upfront amortized = \$50K. Total ≈ \$412.5K or 8.25% effective rate on drawn amount.',
    riskFactors: ['Refinancing Risk: Inability to renew or replace maturing facility', 'Interest Rate Risk: Floating rates may increase', 'Covenant Risk: Violation triggering default or acceleration', 'Liquidity Risk: Credit markets may tighten', 'Collateral Risk: Asset values may decline below loan balance', 'Currency Risk: If borrowing in foreign currency'],
    returnMetrics: ['Interest Coverage Ratio: EBIT / Interest Expense', 'Cost of Debt (pre-tax): Interest Rate + Fees', 'Cost of Debt (after-tax): Pre-tax Cost × (1 - Tax Rate)', 'Debt Yield: NOI / Total Debt (real estate)'],
    keyRatios: [
      KeyRatio(ratio: 'Current Ratio', formula: 'Current Assets / Current Liabilities', interpretation: 'Measures short-term liquidity; banks typically require >1.2x'),
      KeyRatio(ratio: 'Quick Ratio', formula: '(Current Assets - Inventory) / Current Liabilities', interpretation: 'More conservative liquidity measure; >1.0x preferred'),
      KeyRatio(ratio: 'Debt Service Coverage', formula: '(EBITDA - CapEx) / (Interest + Principal)', interpretation: 'Ability to service debt; banks want >1.25x'),
      KeyRatio(ratio: 'Working Capital Turnover', formula: 'Revenue / Average Working Capital', interpretation: 'Efficiency of working capital usage'),
    ],
    breakEvenAnalysis: 'Short-term loan is value-creating if the return on assets financed exceeds the after-tax cost of debt. For working capital: if inventory financed generates gross margin exceeding interest cost, loan is profitable. Example: 20% gross margin on inventory, 7% loan cost, 25% tax rate = 7% × (1-0.25) = 5.25% after-tax cost vs. 20% gross margin = highly accretive.',
  ),
  accountingTreatment: AccountingTreatment(
    recognitionMeasurement: 'Initially recorded at proceeds received (net of fees, if material). Carried at amortized cost. Interest expense recognized over loan term using effective interest method. Loan fees may be expensed immediately if immaterial or amortized over facility term.',
    journalEntries: [
      JournalEntry(debit: 'Cash', credit: 'Short-term Debt / Notes Payable', description: 'Record loan proceeds received'),
      JournalEntry(debit: 'Interest Expense', credit: 'Interest Payable / Cash', description: 'Accrue or pay periodic interest'),
      JournalEntry(debit: 'Short-term Debt', credit: 'Cash', description: 'Record principal repayment'),
      JournalEntry(debit: 'Loan Origination Costs (Asset)', credit: 'Cash', description: 'Record upfront fees paid (if amortized)'),
    ],
    financialStatementImpact: FinancialStatementImpact(
      balanceSheet: 'Cash increases, Current Liabilities increase by loan principal. If fees capitalized, prepaid asset created. Working capital unchanged if proceeds fund current assets. Current ratio may decline.',
      incomeStatement: 'Interest expense increases operating expenses (or reported separately). Fee amortization included in interest expense. Tax shield created by interest deduction.',
      cashFlowStatement: 'Proceeds shown as \'Proceeds from short-term borrowings\' in Financing Activities. Interest payments in Operating Activities (US GAAP) or Operating/Financing (IFRS choice). Principal repayments in Financing Activities.',
    ),
    disclosureRequirements: ['Loan terms: interest rate, maturity, covenants', 'Outstanding balance at period end', 'Average balance during period (if material)', 'Covenant compliance status', 'Pledged collateral and its carrying value', 'Future minimum principal payments by year'],
    ifrsVsGaap: 'Both frameworks classify obligations due within 12 months as current liabilities. Interest classification: US GAAP requires operating cash flow; IFRS allows operating or financing choice. Loan fee treatment similar - amortize using effective interest method. Both require disclosure of significant terms and covenant compliance.',
  ),
  strategicConsiderations: StrategicConsiderations(
    decisionCriteria: ['Duration of Need: Match loan term to financing need', 'Interest Rate Environment: Short vs. long-term rate differential', 'Refinancing Risk Tolerance: Can company handle maturity risk?', 'Collateral Availability: Assets available to secure borrowing', 'Relationship Banking: Strength of lender relationships', 'Covenant Flexibility: Operating room within restrictions'],
    comparisonWithAlternatives: 'vs. Long-term Debt: Lower rate but higher refinancing risk. vs. Equity: No dilution but creates repayment obligation. vs. Trade Credit: May be cheaper but limited availability. vs. Factoring: More expensive but provides immediate cash. vs. Commercial Paper: Lower cost for large, highly-rated companies only.',
    impactOnFinancialPosition: 'Increases current liabilities and total debt. May reduce current ratio. Increases financial leverage ratios. Interest expense reduces net income. Provides cash for operations but creates repayment obligation.',
    commonMistakes: ['Using short-term loans for long-term investments (maturity mismatch)', 'Over-reliance on single lender or facility', 'Ignoring commitment fees on undrawn balances', 'Failing to plan for refinancing well before maturity', 'Violating covenants due to poor monitoring', 'Not negotiating covenants during strong performance periods'],
    bestPractices: ['Match loan maturity to asset life (working capital = short-term)', 'Maintain committed backup facilities for liquidity', 'Monitor covenant compliance monthly internally', 'Diversify funding sources across multiple banks', 'Refinance 3-6 months before maturity to avoid pressure', 'Maintain strong bank relationships through regular communication'],
  ),
  practicalApplication: PracticalApplication(
    realWorldExample: 'Walmart maintains \$5B revolving credit facility for seasonal working capital needs. Drawn during holiday inventory buildup (Q4), repaid from January collections. Facility priced at SOFR + 100bps reflecting strong credit. Provides certainty of funding at low cost for predictable seasonal needs.',
    calculationExample: 'Company needs \$2M for 90-day inventory purchase. Bank offers Prime + 1% (Prime = 8.5%, so 9.5% rate). Interest = \$2M × 9.5% × (90/365) = \$46,849. If inventory generates 25% gross margin: Gross profit = \$2M × 25% = \$500K. Net benefit = \$500K - \$46,849 = \$453,151. Highly profitable use of short-term debt.',
    caseStudy: 'Toys \'R\' Us Bankruptcy (2017): Company relied heavily on seasonal short-term borrowing for holiday inventory. When sales declined and debt increased, lenders tightened terms. Unable to refinance approaching maturities, company filed bankruptcy. Lesson: Over-reliance on short-term debt with declining operations creates existential risk.',
    industryVariations: ['Retail: Heavy seasonal borrowing for inventory (Q3-Q4)', 'Agriculture: Planting/harvest cycle financing', 'Construction: Project-based bridge financing', 'Manufacturing: Accounts receivable financing common', 'Technology: Typically less need due to low inventory/receivables'],
    regulatoryConsiderations: ['Regulation O: Limits on insider lending (banks)', 'Bank Secrecy Act: Anti-money laundering compliance', 'Truth in Lending: Disclosure requirements for business loans', 'UCC Filing: Perfection of security interest in collateral', 'State Usury Laws: Maximum interest rate limits vary by state', 'Basel III: Bank capital requirements affect credit availability'],
  ),
);

const sukukContent = ScenarioEducationalContent(
  coreFramework: CoreFramework(
    definitionOverview: 'Sukuk (plural of Sakk) are Islamic financial certificates similar to bonds but structured to comply with Sharia law, which prohibits interest (riba). Instead of representing debt, sukuk represent ownership in tangible assets, usufruct, or services, with returns derived from the underlying asset\'s performance rather than interest payments.',
    keyCharacteristics: ['Asset-backed or asset-based Islamic financial instruments', 'Returns derived from underlying asset ownership, not interest', 'Compliant with Sharia principles (no riba, gharar, or haram activities)', 'Structured through Special Purpose Vehicles (SPVs)', 'Approved by Sharia supervisory boards', 'Tradeable on secondary markets (most structures)'],
    typesClassifications: ['Sukuk al-Ijara: Based on lease agreements; most common type', 'Sukuk al-Murabaha: Based on cost-plus financing arrangement', 'Sukuk al-Musharaka: Based on partnership/equity participation', 'Sukuk al-Mudaraba: Based on profit-sharing investment management', 'Sukuk al-Istisna: Based on manufacturing/construction contracts', 'Sukuk al-Salam: Based on forward sale agreements'],
    advantages: ['Access to Islamic investors (estimated \$3+ trillion market)', 'Diversifies investor base beyond conventional markets', 'Often competitive pricing with conventional bonds', 'Asset-backing provides additional security structure', 'Ethical/ESG appeal to broader investor community', 'Growing global market with strong demand'],
    disadvantages: ['More complex structuring than conventional bonds', 'Higher issuance costs due to Sharia compliance', 'Requires identifiable underlying assets', 'Less standardization than conventional bonds', 'Sharia interpretation differences across jurisdictions', 'Limited secondary market liquidity in some markets'],
    whenToUse: ['Company operates in or serves Islamic markets', 'Diversifying funding sources beyond conventional debt', 'Has tangible assets suitable for sukuk structure', 'Seeking ethical/Sharia-compliant financing', 'Targeting Middle East, Southeast Asia, or Islamic investors', 'Government or quasi-government entity (sovereign sukuk)'],
    keyTerminology: [
      KeyTerminology(term: 'Sharia', definition: 'Islamic law governing permissible financial activities'),
      KeyTerminology(term: 'Riba', definition: 'Interest/usury prohibited in Islamic finance'),
      KeyTerminology(term: 'SPV', definition: 'Special Purpose Vehicle holding sukuk assets'),
      KeyTerminology(term: 'Ijara', definition: 'Islamic lease structure underlying many sukuk'),
      KeyTerminology(term: 'Wakeel', definition: 'Agent managing sukuk assets on behalf of holders'),
      KeyTerminology(term: 'Sharia Board', definition: 'Scholars certifying sukuk compliance with Islamic law'),
    ],
  ),
  mechanicsProcess: MechanicsProcess(
    howItWorks: 'The issuer transfers assets to an SPV, which issues sukuk certificates to investors. Investors receive periodic payments derived from the asset (rent, profit share) rather than interest. At maturity, the issuer repurchases the assets, returning principal to sukuk holders. Structure must be approved by Sharia scholars.',
    stepByStepProcess: ['1. Asset Identification: Identify Sharia-compliant assets for sukuk structure', '2. Structure Selection: Choose appropriate sukuk type (ijara, musharaka, etc.)', '3. Sharia Review: Obtain approval from qualified Sharia scholars', '4. SPV Formation: Establish Special Purpose Vehicle to hold assets', '5. Documentation: Prepare offering memorandum and legal documentation', '6. Credit Rating: Obtain rating from agencies familiar with sukuk', '7. Marketing: Roadshow to Islamic and conventional investors', '8. Pricing & Allocation: Set profit rate and allocate to investors', '9. Settlement: Transfer assets to SPV, issue certificates', '10. Ongoing Management: Make periodic payments, maintain compliance'],
    keyPartiesInvolved: ['Issuer/Obligor: Company or government raising funds', 'SPV: Holds assets and issues certificates', 'Sukuk Holders: Investors receiving ownership certificates', 'Sharia Supervisory Board: Scholars certifying compliance', 'Trustee: Safeguards sukuk holder interests', 'Lead Arrangers: Investment banks structuring and placing sukuk', 'Legal Counsel: Sharia-compliant documentation'],
    documentationRequired: ['Offering Circular/Prospectus: Terms and structure details', 'Trust Deed: Establishes sukuk holder rights', 'Purchase/Sale Agreements: Asset transfer documentation', 'Service/Lease Agreements: For ijara sukuk', 'Sharia Pronouncement (Fatwa): Scholar approval', 'Rating Agency Report: Credit assessment'],
    timelineMilestones: ['Week 1-4: Structure design and Sharia review', 'Week 4-8: Documentation preparation', 'Week 8-10: Rating agency process', 'Week 10-12: Marketing and roadshow', 'Week 12-14: Pricing, allocation, and settlement', 'Ongoing: Periodic payments and compliance monitoring'],
  ),
  financialAnalysis: FinancialAnalysis(
    valuationPricing: 'Sukuk pricing based on expected returns from underlying assets, benchmarked against conventional yields. Spread = Base Rate (SOFR/LIBOR) + Credit Spread + Complexity Premium. Typically trades 10-50 bps above equivalent conventional bonds due to structure complexity and investor demand dynamics.',
    costCalculation: 'Total Cost = Profit Rate + Structuring Fees + Sharia Advisory + Legal Fees + Rating Fees. Example: \$500M sukuk at 5.5% profit rate + 1% structuring + 0.1% Sharia + 0.3% legal = ~6.9% all-in first year cost. Ongoing: profit distributions to certificate holders.',
    riskFactors: ['Sharia Compliance Risk: Structure may be challenged', 'Asset Risk: Underlying assets may depreciate or become unavailable', 'Dissolution Risk: Early termination triggers and consequences', 'Cross-border Risk: Different Sharia interpretations by jurisdiction', 'Liquidity Risk: Secondary market less developed than bonds', 'Recourse Risk: Asset-based vs. asset-backed structures differ'],
    returnMetrics: ['Profit Rate: Periodic return to sukuk holders', 'Yield to Maturity: Total return including principal', 'Spread to Benchmark: Premium over risk-free rate', 'All-in Cost: Total financing cost to issuer'],
    keyRatios: [
      KeyRatio(ratio: 'Asset Coverage', formula: 'Underlying Asset Value / Sukuk Principal', interpretation: 'Higher coverage indicates stronger security'),
      KeyRatio(ratio: 'Profit Coverage', formula: 'Asset Income / Periodic Payments', interpretation: 'Ability to meet periodic distributions'),
      KeyRatio(ratio: 'Sukuk-to-Equity', formula: 'Outstanding Sukuk / Total Equity', interpretation: 'Leverage measure; treat similar to debt'),
      KeyRatio(ratio: 'Spread vs. Bonds', formula: 'Sukuk Yield - Equivalent Bond Yield', interpretation: 'Premium/discount to conventional financing'),
    ],
    breakEvenAnalysis: 'Sukuk issuance worthwhile when: (1) Total cost competitive with conventional bonds after structuring costs; (2) Investor diversification value exceeds complexity cost; (3) Asset-backing requirements align with business assets. Break-even typically at \$250M+ issuance size to justify structuring costs.',
  ),
  accountingTreatment: AccountingTreatment(
    recognitionMeasurement: 'AAOIFI (Islamic accounting standards) and IFRS treatment may differ. Under IFRS, most sukuk treated as financial liabilities similar to bonds, measured at amortized cost. Underlying assets may remain on issuer balance sheet for asset-based structures. Periodic payments treated similar to interest.',
    journalEntries: [
      JournalEntry(debit: 'Cash (Proceeds)', credit: 'Sukuk Liability', description: 'Record sukuk issuance proceeds'),
      JournalEntry(debit: 'Profit Distribution Expense', credit: 'Cash/Payable', description: 'Record periodic profit payments'),
      JournalEntry(debit: 'Sukuk Liability', credit: 'Cash', description: 'Record sukuk redemption at maturity'),
    ],
    financialStatementImpact: FinancialStatementImpact(
      balanceSheet: 'Sukuk liability shown similar to bonds payable. Underlying assets may or may not be derecognized depending on structure (asset-based vs. asset-backed). SPV may be consolidated.',
      incomeStatement: 'Profit distributions similar to interest expense. No technical \'interest\' but economically equivalent charge against income.',
      cashFlowStatement: 'Proceeds in Financing Activities. Periodic payments may be Operating or Financing depending on classification. Principal repayment in Financing.',
    ),
    disclosureRequirements: ['Sukuk structure and underlying assets', 'Sharia compliance basis and supervisory board', 'Key terms (profit rate, maturity, redemption rights)', 'SPV consolidation basis', 'Risks specific to sukuk structure'],
    ifrsVsGaap: 'IFRS more commonly applied globally for sukuk. AAOIFI provides Islamic-specific standards. Key issues: (1) Substance over form - most sukuk accounted as debt despite ownership language; (2) SPV consolidation under IFRS 10; (3) Revenue recognition for underlying asset income. US GAAP treatment similar to debt if substance is borrowing.',
  ),
  strategicConsiderations: StrategicConsiderations(
    decisionCriteria: ['Investor Base: Do we want to access Islamic capital markets?', 'Asset Availability: Do we have suitable assets to structure sukuk?', 'Cost Comparison: Is all-in cost competitive with conventional bonds?', 'Market Timing: Is there strong sukuk market demand currently?', 'Reputation: Does Sharia-compliant financing enhance our image?', 'Complexity Tolerance: Can we manage structural requirements?'],
    comparisonWithAlternatives: 'vs. Conventional Bonds: Sukuk may cost slightly more but access different investors. vs. Bank Loans: Sukuk provides capital markets access, longer tenors. vs. Equity: No dilution, fixed obligation. Consider sukuk when targeting Islamic investors or markets.',
    impactOnFinancialPosition: 'Similar to conventional bonds - increases liabilities and leverage. Underlying assets may have transfer restrictions. Provides cash without dilution. Demonstrates commitment to Islamic finance principles.',
    commonMistakes: ['Underestimating structuring time and costs', 'Choosing wrong sukuk structure for asset base', 'Not engaging qualified Sharia scholars early', 'Assuming identical treatment to conventional bonds', 'Insufficient investor education for first-time issuers', 'Not planning for ongoing compliance requirements'],
    bestPractices: ['Engage experienced Islamic finance advisors', 'Select sukuk type matching available assets', 'Obtain Sharia approval early in process', 'Build relationships with Islamic investors', 'Consider hybrid conventional/sukuk programs', 'Plan for repeat issuance to build market presence'],
  ),
  practicalApplication: PracticalApplication(
    realWorldExample: 'Saudi Aramco Sukuk (2017-present): World\'s largest company has issued billions in sukuk to diversify funding and demonstrate commitment to Islamic finance. Uses hybrid sukuk structure combining ijara (lease) and murabaha (cost-plus). Achieved tight pricing comparable to conventional bonds due to strong credit and investor demand.',
    calculationExample: 'Company issues \$300M 5-year sukuk ijara. Underlying: office building worth \$350M. Profit rate: 4.5% annually. Annual profit distribution: \$13.5M. At maturity, issuer repurchases asset for \$300M. Total paid: \$67.5M profit + \$300M principal. Investor IRR ≈ 4.5% (similar to bond yield). Structuring adds \$3M to issuance cost.',
    caseStudy: 'Malaysia Government Sukuk Program: Malaysia pioneered sovereign sukuk, now with over \$200B outstanding. Uses government assets (land, buildings) for ijara structure. Established benchmark yield curve for corporate sukuk. Success factors: (1) Regulatory support; (2) Deep Islamic investor base; (3) Standardized documentation; (4) Active secondary market.',
    industryVariations: ['Sovereign: Government sukuk using public assets (most common)', 'Corporate: Industrial assets, equipment, real estate', 'Project Finance: Infrastructure using specific project assets', 'Financial Institutions: Often use commodity murabaha structure', 'Real Estate: Property sukuk for development financing'],
    regulatoryConsiderations: ['AAOIFI Standards: Accounting and Auditing Organization for Islamic Financial Institutions', 'Securities Regulations: SEC, local capital markets authority approval', 'Sharia Governance: Board certification requirements vary by jurisdiction', 'Tax Treatment: Many jurisdictions provide tax neutrality vs. conventional bonds', 'Basel III: Treatment of sukuk in bank capital requirements', 'Cross-border: Recognition of sukuk structures across jurisdictions'],
  ),
);

const useReservesContent = ScenarioEducationalContent(
  coreFramework: CoreFramework(
    definitionOverview: 'Using reserves refers to deploying accumulated retained earnings, statutory reserves, or other equity reserves to fund business activities, investments, or distributions. Reserves represent past profits that shareholders have left in the company rather than receiving as dividends, and their use represents a key capital allocation decision.',
    keyCharacteristics: ['Internal source of funding from accumulated past profits', 'No external financing required - already on balance sheet', 'Reduces equity reserves when deployed', 'No dilution, interest, or repayment obligations', 'Subject to legal restrictions in some jurisdictions', 'Represents shareholders\' historical reinvestment in company'],
    typesClassifications: ['Retained Earnings: Accumulated undistributed profits', 'General Reserve: Appropriated from retained earnings for general purposes', 'Capital Reserve: From share premium, asset revaluation, or merger surplus', 'Statutory Reserve: Legally required reserves (banking, insurance)', 'Revenue Reserve: Available for dividend distribution', 'Contingency Reserve: Set aside for unexpected events'],
    advantages: ['No cost of capital (interest or dividend requirements)', 'No dilution of ownership', 'Immediate availability without external approval', 'No transaction costs or fees', 'Demonstrates financial strength and self-sufficiency', 'Full control without lender covenants'],
    disadvantages: ['Uses shareholders\' accumulated capital', 'Opportunity cost - funds could earn returns elsewhere', 'May signal lack of growth opportunities', 'Reduces financial cushion for future uncertainties', 'Some reserves have legal restrictions on use', 'Depletes equity base, affecting leverage ratios'],
    whenToUse: ['Strong reserve position relative to needs', 'Attractive investment opportunities with good returns', 'Cheaper than external financing alternatives', 'Market conditions unfavorable for external financing', 'Quick access needed without external delays', 'Small funding needs not justifying external issuance'],
    keyTerminology: [
      KeyTerminology(term: 'Retained Earnings', definition: 'Cumulative profits less dividends paid since company formation'),
      KeyTerminology(term: 'Appropriated Reserves', definition: 'Retained earnings restricted for specific purposes'),
      KeyTerminology(term: 'Distributable Reserves', definition: 'Reserves legally available for dividends'),
      KeyTerminology(term: 'Capital Maintenance', definition: 'Legal principle protecting creditors by preserving capital'),
      KeyTerminology(term: 'Reserve Transfer', definition: 'Moving amounts between different reserve categories'),
    ],
  ),
  mechanicsProcess: MechanicsProcess(
    howItWorks: 'The company identifies a funding need and evaluates whether internal reserves are the optimal source. Board approves the use of reserves for the intended purpose. Accounting transfers may be made between reserve categories. The cash (already held) is deployed for the approved purpose, and reserve balances are adjusted accordingly.',
    stepByStepProcess: ['1. Need Identification: Define funding requirement and purpose', '2. Reserve Analysis: Review available reserves and restrictions', '3. Alternative Evaluation: Compare to external financing options', '4. Legal Review: Confirm permissible use under company law', '5. Board Approval: Present proposal for board decision', '6. Documentation: Record board resolution and rationale', '7. Accounting Entries: Adjust reserve balances as needed', '8. Cash Deployment: Use funds for approved purpose', '9. Disclosure: Report in financial statements and MD&A'],
    keyPartiesInvolved: ['Board of Directors: Approval authority for reserve use', 'CFO/Finance Team: Analysis and recommendation', 'Legal Counsel: Advise on legal restrictions', 'External Auditors: Review accounting treatment', 'Shareholders: Ultimate owners of reserves'],
    documentationRequired: ['Board Resolution: Formal approval of reserve use', 'Financial Analysis: Evaluation of alternatives', 'Legal Opinion: Confirmation of permissible use', 'Shareholder Communication: If material or required', 'Accounting Memo: Recording of transactions'],
    timelineMilestones: ['Week 1: Analysis and recommendation preparation', 'Week 2: Legal review and board paper preparation', 'Week 3: Board meeting and approval', 'Week 3-4: Documentation and accounting', 'Immediately: Cash deployment available', 'Quarter-end: Financial statement disclosure'],
  ),
  financialAnalysis: FinancialAnalysis(
    valuationPricing: 'Reserves have implicit cost = shareholders\' required return on equity. Using reserves is effectively using shareholder capital. Should earn at least cost of equity (typically 8-15%) to create value. Compare return on use vs. alternative returns from investing reserves elsewhere.',
    costCalculation: 'Effective Cost = Cost of Equity × Amount Used. Example: Using \$10M reserves at 12% cost of equity = \$1.2M annual opportunity cost. Compare to: Debt at 6% after tax = \$600K cost. Reserves \'cost\' more than debt due to higher equity returns required, but have no cash outflow.',
    riskFactors: ['Depletion Risk: Reduces cushion for future needs', 'Opportunity Cost: Foregone returns on alternative uses', 'Covenant Impact: May affect debt covenants based on equity', 'Shareholder Expectations: May conflict with dividend desires', 'Legal Restrictions: Some reserves cannot be used freely', 'Signaling Risk: Market may interpret negatively'],
    returnMetrics: ['Return on Deployed Reserves: Project/Investment Return', 'Cost of Equity: Minimum required return', 'EVA Impact: Economic Value Added from use', 'Reserve Coverage: Remaining reserves vs. obligations'],
    keyRatios: [
      KeyRatio(ratio: 'Reserve-to-Assets', formula: 'Total Reserves / Total Assets', interpretation: 'Financial cushion; higher is more conservative'),
      KeyRatio(ratio: 'Return vs. Cost of Equity', formula: 'Project IRR - Cost of Equity', interpretation: 'Positive spread creates shareholder value'),
      KeyRatio(ratio: 'Dividend Coverage', formula: 'Distributable Reserves / Annual Dividend', interpretation: 'Years of dividends supportable from reserves'),
      KeyRatio(ratio: 'Leverage Impact', formula: '(Pre-use D/E) vs. (Post-use D/E)', interpretation: 'How reserve use affects capital structure'),
    ],
    breakEvenAnalysis: 'Use of reserves creates value when: Expected Return on Use > Cost of Equity. If reserves would otherwise be held in low-yield investments (e.g., 3% cash), break-even is lower. Consider: (1) Best alternative use of reserves; (2) Risk-adjusted returns; (3) Timing of cash needs.',
  ),
  accountingTreatment: AccountingTreatment(
    recognitionMeasurement: 'Reserves are equity components. Using reserves typically involves: (1) Transferring between reserve categories; (2) No P&L impact from transfer itself; (3) Cash deployment follows normal accounting for use (capex, investment, etc.). Dividend payments reduce retained earnings.',
    journalEntries: [
      JournalEntry(debit: 'General Reserve', credit: 'Retained Earnings', description: 'Transfer from general reserve to retained earnings (if needed)'),
      JournalEntry(debit: 'Fixed Assets / Investments / etc.', credit: 'Cash', description: 'Deploy cash for approved purpose'),
      JournalEntry(debit: 'Retained Earnings', credit: 'Dividends Payable', description: 'If reserves used for dividend'),
    ],
    financialStatementImpact: FinancialStatementImpact(
      balanceSheet: 'Total equity unchanged by reserve transfers between categories. Cash decreases when deployed. Assets increase if used for investments. Net equity decreases if used for dividends.',
      incomeStatement: 'Reserve transfers have no P&L impact. Returns from investments flow through income. No expense from using reserves (unlike interest).',
      cashFlowStatement: 'Cash deployment in appropriate section (Investing for capex, Financing for dividends). Reserve transfers are non-cash movements within equity.',
    ),
    disclosureRequirements: ['Movement in reserves schedule', 'Nature and purpose of each reserve category', 'Restrictions on reserve distributions', 'Significant reserve utilization', 'Dividend policy and distributable reserves'],
    ifrsVsGaap: 'Both frameworks present reserves within equity. IFRS Statement of Changes in Equity shows all reserve movements. Key differences: (1) Some jurisdictions require statutory reserves (not US); (2) Revaluation reserves have specific rules; (3) Legal capital maintenance rules vary by country.',
  ),
  strategicConsiderations: StrategicConsiderations(
    decisionCriteria: ['Return Comparison: Will use generate returns above cost of equity?', 'Alternative Sources: Is external financing cheaper or better?', 'Reserve Adequacy: Will remaining reserves be sufficient?', 'Strategic Importance: Is the use critical for strategy?', 'Shareholder Impact: How do shareholders view reserve use?', 'Timing: Are market conditions right for this decision?'],
    comparisonWithAlternatives: 'vs. Debt: Reserves have higher implicit cost (equity) but no cash interest. vs. New Equity: No dilution from using reserves. vs. Asset Sales: Reserves are simpler, no transaction execution risk. Use reserves when: quick access needed, external costs high, strong reserve position.',
    impactOnFinancialPosition: 'Reduces equity reserve buffer. No change to total equity for transfers. Increases leverage ratio as equity base shrinks (if reserves are used and not replaced by profits). May affect dividend capacity.',
    commonMistakes: ['Using reserves for projects with returns below cost of equity', 'Depleting reserves without considering future needs', 'Ignoring legal restrictions on reserve use', 'Not communicating rationale to shareholders', 'Using reserves when cheaper debt is available', 'Treating reserves as \'free money\' without opportunity cost'],
    bestPractices: ['Maintain target reserve levels for contingencies', 'Evaluate opportunity cost rigorously', 'Compare all financing alternatives', 'Document rationale for reserve use decisions', 'Communicate strategy to shareholders', 'Monitor reserve rebuild from future earnings'],
  ),
  practicalApplication: PracticalApplication(
    realWorldExample: 'Berkshire Hathaway Reserve Management: Warren Buffett famously retains all earnings (no dividends since 1967), building \$150B+ in reserves/cash. Deploys reserves for major acquisitions when opportunities arise (Burlington Northern \$34B, Precision Castparts \$37B). Demonstrates patient reserve accumulation and strategic deployment.',
    calculationExample: 'Company has \$50M general reserves, cost of equity 10%. Option A: Hold reserves, earn 3% (\$1.5M). Option B: Deploy into project with 15% expected return (\$7.5M). Value created by using reserves: \$7.5M - \$5M (required return at 10%) = \$2.5M. Option B creates shareholder value.',
    caseStudy: 'Apple Cash/Reserve Deployment: Apple accumulated \$200B+ in cash and reserves by 2012. Faced pressure to return capital to shareholders. Initiated dividend (2012) and buybacks (ongoing). Demonstrates that excessive reserves can attract activist pressure - balance between strategic flexibility and capital efficiency.',
    industryVariations: ['Banks: Strict statutory reserve requirements (capital ratios)', 'Insurance: Policyholder reserves legally restricted', 'Manufacturing: Reserves often used for cyclical needs', 'Utilities: Regulated return on equity affects reserve strategy', 'Tech: Often accumulate large reserves; pressure to return or deploy'],
    regulatoryConsiderations: ['Capital Maintenance: Legal restrictions on reducing capital', 'Distributable Profits: Rules on what can be paid as dividends', 'Statutory Reserves: Required reserves in banking, insurance', 'Tax Implications: Accumulated earnings tax in some jurisdictions', 'Disclosure Requirements: Reserve movements must be reported', 'Fiduciary Duty: Board must act in shareholder interest'],
  ),
);

const dividendPaymentContent = ScenarioEducationalContent(
  coreFramework: CoreFramework(
    definitionOverview: 'A dividend is a distribution of a portion of a company\'s earnings to its shareholders, typically in the form of cash or additional shares. Dividend policy represents one of the most important financial decisions a company makes, balancing the need to reward shareholders with the requirement to retain earnings for growth and operations.',
    keyCharacteristics: ['Distribution from retained earnings to shareholders', 'Can be paid as cash, stock, or property dividends', 'Board of Directors declares; shareholders of record receive', 'Regular dividends paid quarterly; special dividends for one-time events', 'Reduces retained earnings and cash (or shares outstanding for stock dividends)', 'Subject to dividend policy and legal restrictions'],
    typesClassifications: ['Cash Dividend: Most common; direct cash payment to shareholders', 'Stock Dividend: Additional shares distributed proportionally', 'Property Dividend: Distribution of assets other than cash', 'Special Dividend: One-time payment, often from asset sale or excess cash', 'Liquidating Dividend: Return of capital, not from earnings', 'Scrip Dividend: Promise to pay later (rarely used)'],
    advantages: ['Signals financial health and management confidence', 'Attracts income-seeking investors', 'Provides return to shareholders without selling shares', 'Disciplines management to generate cash', 'May support stock price through regular income stream', 'Reduces agency costs by limiting free cash flow'],
    disadvantages: ['Reduces cash available for investment and growth', 'Creates expectation - cuts are negatively received', 'Double taxation (corporate then personal) in many jurisdictions', 'May signal lack of profitable investment opportunities', 'Reduces financial flexibility', 'Cannot be easily reversed once established'],
    whenToUse: ['Mature company with stable cash flows', 'Limited high-return investment opportunities', 'Strong balance sheet with excess cash', 'Shareholder base expects income (institutional, retirees)', 'Industry norm includes dividends', 'Alternative to share buybacks for returning capital'],
    keyTerminology: [
      KeyTerminology(term: 'Declaration Date', definition: 'Date board announces dividend; creates legal obligation'),
      KeyTerminology(term: 'Record Date', definition: 'Cutoff date to determine eligible shareholders'),
      KeyTerminology(term: 'Ex-Dividend Date', definition: 'First trading day when buyer won\'t receive dividend; stock typically drops by dividend amount'),
      KeyTerminology(term: 'Payment Date', definition: 'Date dividend is actually paid to shareholders'),
      KeyTerminology(term: 'Dividend Yield', definition: 'Annual dividend per share divided by stock price'),
      KeyTerminology(term: 'Payout Ratio', definition: 'Percentage of earnings paid as dividends'),
    ],
  ),
  mechanicsProcess: MechanicsProcess(
    howItWorks: 'The board of directors evaluates available cash, earnings, investment needs, and shareholder expectations to determine dividend amount. Upon declaration, the company becomes legally obligated to pay. Shareholders on the record date receive payment on the payment date. Stock price typically adjusts down by dividend amount on ex-dividend date.',
    stepByStepProcess: ['1. Financial Analysis: Evaluate cash position, earnings, and future needs', '2. Policy Review: Consider established dividend policy and investor expectations', '3. Board Discussion: Management presents recommendation to board', '4. Declaration: Board formally declares dividend amount and dates', '5. Public Announcement: Press release and regulatory filing (8-K in US)', '6. Record Date: Shareholder list frozen to determine recipients', '7. Ex-Dividend Date: Stock trades without dividend right (T-1 before record)', '8. Payment Processing: Transfer agent prepares payments', '9. Payment Date: Cash distributed to shareholders', '10. Accounting: Record reduction in retained earnings and cash'],
    keyPartiesInvolved: ['Board of Directors: Declares dividend and sets policy', 'Management/CFO: Recommends dividend based on analysis', 'Transfer Agent: Maintains shareholder records and distributes payments', 'Shareholders: Recipients of dividend payments', 'Custodian Banks: Hold shares and receive dividends for clients', 'Tax Authorities: Collect applicable dividend taxes'],
    documentationRequired: ['Board Resolution: Formal declaration of dividend', 'Press Release: Public announcement', 'Form 8-K: SEC filing for material event', 'Shareholder List: Record date ownership', 'Tax Forms: 1099-DIV for US shareholders', 'Payment Instructions: Wire/check details for distribution'],
    timelineMilestones: ['Declaration Date: Board announces dividend', 'Ex-Dividend Date: 1 business day before record date', 'Record Date: Ownership cutoff (typically 2-3 weeks after declaration)', 'Payment Date: Actual distribution (typically 2-4 weeks after record)', 'Quarterly: Most US companies pay quarterly dividends', 'Annual: Many international companies pay annually or semi-annually'],
  ),
  financialAnalysis: FinancialAnalysis(
    valuationPricing: 'Dividend value to shareholders: Present value of expected future dividends (Gordon Growth Model: P = D1/(r-g)). Dividend yield = Annual Dividend / Stock Price. Higher yields attract income investors but may signal limited growth. Dividend cuts typically cause 5-10% stock price decline.',
    costCalculation: 'Cost of Dividend = Cash Paid + Opportunity Cost of Foregone Investment. Example: \$10M dividend with 15% investment return opportunity = \$10M cash + \$1.5M foregone return = \$11.5M total cost. Tax consideration: Corporate tax already paid; shareholder pays additional tax (qualified dividend rate 15-20% in US).',
    riskFactors: ['Earnings Volatility: Fluctuating earnings make stable dividends difficult', 'Cash Flow Timing: Earnings don\'t equal cash; may lack funds for dividend', 'Growth Investment Needs: Dividend competes with reinvestment', 'Debt Covenants: May restrict dividend payments', 'Economic Downturns: May force dividend cuts', 'Regulatory Restrictions: Banks and insurers face dividend limitations'],
    returnMetrics: ['Dividend Yield: Annual Dividend / Stock Price', 'Payout Ratio: Dividends / Net Income', 'Dividend Coverage: Net Income / Dividends', 'Cash Dividend Coverage: Operating Cash Flow / Dividends', 'Dividend Growth Rate: Annual % increase in dividend'],
    keyRatios: [
      KeyRatio(ratio: 'Dividend Yield', formula: 'Annual Dividend per Share / Stock Price', interpretation: 'Higher yield attractive for income; compare to industry and bonds'),
      KeyRatio(ratio: 'Payout Ratio', formula: 'Total Dividends / Net Income', interpretation: 'Sustainable range 30-60% for most companies; >100% uses reserves'),
      KeyRatio(ratio: 'Dividend Coverage', formula: 'Net Income / Total Dividends', interpretation: 'Higher is safer; <1x means paying from reserves'),
      KeyRatio(ratio: 'Free Cash Flow Payout', formula: 'Dividends / Free Cash Flow', interpretation: 'More conservative than earnings-based; should be <100%'),
    ],
    breakEvenAnalysis: 'Dividend decision compares: (1) Value created by reinvesting vs. (2) Value to shareholders of receiving cash. If company ROE > shareholder\'s opportunity cost, retain earnings. If ROE < shareholder opportunity cost, pay dividend. Efficient market assumes shareholders indifferent (Modigliani-Miller), but taxes and signaling create real differences.',
  ),
  accountingTreatment: AccountingTreatment(
    recognitionMeasurement: 'On declaration date, record liability for dividend payable equal to declared amount. On payment date, reduce cash and eliminate liability. Stock dividends transfer amount from retained earnings to paid-in capital (at market value for small stock dividends <20-25%, par value for large).',
    journalEntries: [
      JournalEntry(debit: 'Retained Earnings', credit: 'Dividends Payable', description: 'Record dividend declaration (creates liability)'),
      JournalEntry(debit: 'Dividends Payable', credit: 'Cash', description: 'Record dividend payment'),
      JournalEntry(debit: 'Retained Earnings', credit: 'Common Stock / APIC', description: 'Record stock dividend (small: market value)'),
      JournalEntry(debit: 'Retained Earnings', credit: 'Common Stock', description: 'Record large stock dividend or stock split (par value)'),
    ],
    financialStatementImpact: FinancialStatementImpact(
      balanceSheet: 'Cash decreases by dividend amount. Retained earnings decrease. Current liabilities increase temporarily (dividends payable). Stock dividends: no change in total equity, just transfer between accounts.',
      incomeStatement: 'No impact - dividends are not an expense. Dividends come from retained earnings, not current period income.',
      cashFlowStatement: 'Cash dividends shown as cash outflow in Financing Activities. Stock dividends are non-cash and shown in supplementary disclosure only.',
    ),
    disclosureRequirements: ['Dividend declared per share and in total', 'Dividend policy description', 'Restrictions on dividend payments (covenants)', 'Dividends in arrears (preferred stock)', 'Subsequent event disclosure if declared after balance sheet date'],
    ifrsVsGaap: 'Treatment substantially similar. Key points: (1) Both require liability on declaration date. (2) Both expense interest but not dividends. (3) Small stock dividend accounting differs slightly - GAAP specifies market value threshold. (4) Presentation in statement of changes in equity similar under both.',
  ),
  strategicConsiderations: StrategicConsiderations(
    decisionCriteria: ['Cash Availability: Sufficient cash after operational needs?', 'Investment Opportunities: High-return projects available?', 'Shareholder Expectations: What do investors expect?', 'Signaling Effect: What message does dividend send?', 'Tax Efficiency: Dividend vs. buyback tax implications', 'Policy Consistency: Maintain stable or growing dividend?'],
    comparisonWithAlternatives: 'vs. Share Buybacks: Buybacks more flexible, tax-advantaged for many shareholders, but dividends provide regular income. vs. Debt Reduction: Paying debt improves balance sheet but foregoes shareholder return. vs. Reinvestment: Growth potential but uncertain returns. vs. Special Dividend: One-time return without ongoing commitment.',
    impactOnFinancialPosition: 'Reduces cash and retained earnings. Increases dividend yield (if price stable). Signals management confidence in future cash flows. May attract different investor base. Creates ongoing expectation and pressure to maintain.',
    commonMistakes: ['Paying dividends while taking on debt for operations', 'Setting dividend too high initially (hard to cut)', 'Ignoring tax implications for shareholder base', 'Cutting dividend without clear communication', 'Paying dividend with borrowed money', 'Not considering investment opportunity cost'],
    bestPractices: ['Establish clear, consistent dividend policy', 'Target sustainable payout ratio with room for growth', 'Consider share buybacks as complement/alternative', 'Communicate policy and changes transparently', 'Maintain dividend through normal business cycles', 'Build cash reserves to support dividend in downturns'],
  ),
  practicalApplication: PracticalApplication(
    realWorldExample: 'Apple Dividend Initiation (2012): After years of no dividends, Apple initiated quarterly dividend at \$2.65/share (2.4% yield). Rationale: (1) \$100B+ cash pile; (2) Limited acquisition targets at Apple\'s scale; (3) Activist pressure from Einhorn. Combined with buybacks, returned \$100B+ to shareholders. Demonstrated even growth companies eventually return cash.',
    calculationExample: 'Company with 100M shares, \$500M net income, stock at \$50. Option A: Pay \$1/share dividend. Total: \$100M. Payout ratio: 20%. Yield: 2%. Option B: Pay \$2/share. Total: \$200M. Payout ratio: 40%. Yield: 4%. Retained for growth: Option A retains \$400M, Option B retains \$300M. If ROE is 20%, Option A foregoes \$20M less growth but provides \$100M less to shareholders.',
    caseStudy: 'General Electric Dividend Cuts (2017-2018): GE maintained \$0.24/quarter dividend despite deteriorating fundamentals. Forced to cut to \$0.12 (Nov 2017), then \$0.01 (Dec 2018). Stock fell 45% over period. Lessons: (1) Unsustainable dividends eventually fail; (2) Dividend cuts destroy shareholder value; (3) Better to have conservative policy than cut; (4) Cash flow matters more than earnings for dividend support.',
    industryVariations: ['Utilities: High yields (3-5%), stable cash flows support dividends', 'REITs: Required to distribute 90% of taxable income', 'Banks: Regulated dividend payments, stress test approvals', 'Technology: Historically low/no dividends; changing as sector matures', 'Consumer Staples: Moderate yields, long dividend growth histories'],
    regulatoryConsiderations: ['Legal Capital Rules: Cannot pay dividends that impair capital', 'Bank Regulations: Federal Reserve approval for bank holding company dividends', 'REIT Requirements: Must distribute 90%+ of taxable income', 'Tax Treaties: Withholding rates for international shareholders', 'Solvency Tests: Some states require solvency after dividend', 'Debt Covenants: Often restrict dividends to protect creditors'],
  ),
);

const longTermLoanContent = ScenarioEducationalContent(
  coreFramework: CoreFramework(
    definitionOverview: 'A long-term loan is debt financing with a maturity exceeding one year (typically 3-10+ years), used to fund capital expenditures, acquisitions, or permanent working capital. These loans provide stable, predictable financing for major investments, with repayment matched to the asset\'s useful life or project cash flows.',
    keyCharacteristics: ['Maturity greater than one year (typically 3-10 years)', 'May have fixed or floating interest rates', 'Usually secured by assets (collateral) or company guarantees', 'Amortizing (periodic principal payments) or bullet (single maturity payment)', 'Subject to financial covenants monitoring company performance', 'Provided by banks, insurance companies, or institutional lenders'],
    typesClassifications: ['Term Loan A (TLA): Fully amortizing, typically held by banks', 'Term Loan B (TLB): Back-end loaded amortization, often sold to institutional investors', 'Delayed Draw Term Loan: Commitment to fund over time as needed', 'Equipment Loan: Secured by specific equipment being financed', 'Real Estate Loan (Mortgage): Secured by property with long amortization', 'Mezzanine Loan: Subordinated, higher risk/return, often with equity features'],
    advantages: ['Matched maturity to long-term investment needs', 'Fixed rate options provide cost certainty', 'No dilution of ownership unlike equity', 'Interest payments are tax-deductible', 'Builds banking relationship for future needs', 'More flexible terms than public bonds', 'Can be prepaid (subject to fees)'],
    disadvantages: ['Fixed repayment obligations regardless of business performance', 'Requires collateral or guarantees typically', 'Restrictive covenants limit operational flexibility', 'Prepayment penalties if refinancing early', 'Variable rate loans expose to interest rate risk', 'Default can trigger acceleration and asset seizure'],
    whenToUse: ['Financing long-lived assets (equipment, property, facilities)', 'Funding acquisitions with predictable synergies', 'Refinancing existing debt at better terms', 'When bond market access is not available or efficient', 'Building banking relationships important for future', 'Need customized terms not available in public markets'],
    keyTerminology: [
      KeyTerminology(term: 'Amortization', definition: 'Gradual repayment of principal over loan term through scheduled payments'),
      KeyTerminology(term: 'Covenant', definition: 'Contractual requirement to maintain certain financial ratios or restrict activities'),
      KeyTerminology(term: 'Security/Collateral', definition: 'Assets pledged to lender that can be seized upon default'),
      KeyTerminology(term: 'DSCR', definition: 'Debt Service Coverage Ratio - cash flow available to pay debt service'),
      KeyTerminology(term: 'Prepayment Penalty', definition: 'Fee charged for early repayment, compensating lender for lost interest'),
      KeyTerminology(term: 'Syndicated Loan', definition: 'Large loan provided by group of lenders sharing risk'),
    ],
  ),
  mechanicsProcess: MechanicsProcess(
    howItWorks: 'The borrower applies to lenders with financial projections and purpose description. After credit analysis, lenders propose terms including rate, fees, covenants, and collateral. Documentation is negotiated and executed, funds are disbursed, and the borrower makes periodic payments of interest and principal while maintaining covenant compliance.',
    stepByStepProcess: ['1. Project Planning: Define funding need, amount, and repayment capacity', '2. Lender Identification: Approach relationship banks or conduct competitive process', '3. Information Package: Prepare business plan, financials, and projections', '4. Credit Analysis: Lender evaluates creditworthiness, cash flow, and collateral', '5. Term Sheet: Receive and negotiate key terms (rate, amortization, covenants)', '6. Commitment Letter: Lender commits to fund subject to documentation', '7. Due Diligence: Legal, financial, and environmental reviews', '8. Documentation: Execute loan agreement, security documents, and opinions', '9. Funding/Closing: Satisfy conditions precedent, receive funds', '10. Servicing: Make payments, deliver compliance certificates, maintain covenants'],
    keyPartiesInvolved: ['Borrower: Company seeking financing', 'Lead Arranger: Bank structuring and syndicating the loan', 'Participating Lenders: Other banks/investors in syndicate', 'Administrative Agent: Bank managing loan administration post-closing', 'Security Agent: Holds collateral on behalf of lender group', 'Legal Counsel: For borrower and lenders', 'Appraisers: Value collateral assets'],
    documentationRequired: ['Credit Agreement: Master document governing loan terms', 'Promissory Note: Evidence of debt obligation', 'Security Agreement: Grants lender security interest in collateral', 'Mortgage/Deed of Trust: Real property collateral', 'Guaranty: Personal or parent company guarantee', 'Financial Covenants Certificate: Quarterly compliance attestation', 'Intercreditor Agreement: If multiple layers of debt'],
    timelineMilestones: ['Week 1-2: Initial discussions and information gathering', 'Week 3-4: Credit committee approval at lender', 'Week 4-5: Term sheet negotiation and signing', 'Week 5-8: Due diligence and documentation', 'Week 8-10: Closing conditions and funding', 'Ongoing: Quarterly covenant compliance and annual reviews'],
  ),
  financialAnalysis: FinancialAnalysis(
    valuationPricing: 'Interest rate = Base Rate (SOFR, Prime) + Credit Spread. Spread reflects credit risk, typically: Investment grade 150-300 bps, BB 300-500 bps, B 500-700+ bps. All-in cost includes upfront fees (1-2%), ongoing commitment fees on undrawn amounts, and any agency fees.',
    costCalculation: 'Total Cost = (Interest Rate × Principal Outstanding) + Amortization of Upfront Fees + Commitment Fees. Example: \$50M term loan at SOFR+350bps (8.5% all-in), 1.5% upfront fee. Annual interest: \$4.25M. Amortized fee: \$750K/5yr = \$150K/year. Effective annual cost: \$4.4M or 8.8% year 1. After-tax cost at 25%: 6.6%.',
    riskFactors: ['Interest Rate Risk: Floating rate loans subject to rate increases', 'Refinancing Risk: May not be able to refinance at maturity', 'Covenant Risk: Financial performance deterioration triggers default', 'Collateral Risk: Asset values may decline below loan balance', 'Business Risk: Cash flow insufficient to service debt', 'Currency Risk: If loan in foreign currency'],
    returnMetrics: ['Interest Coverage Ratio: EBIT / Interest Expense', 'Debt Service Coverage Ratio: (EBITDA - CapEx) / (Interest + Principal)', 'After-tax Cost of Debt: Interest Rate × (1 - Tax Rate)', 'Weighted Average Cost of Capital (WACC): Impact on overall cost of capital'],
    keyRatios: [
      KeyRatio(ratio: 'Debt/EBITDA (Leverage)', formula: 'Total Debt / EBITDA', interpretation: 'Primary measure of leverage capacity; typically covenant at 3-5x'),
      KeyRatio(ratio: 'Interest Coverage', formula: 'EBITDA / Interest Expense', interpretation: 'Ability to pay interest; covenant typically >2-3x'),
      KeyRatio(ratio: 'Fixed Charge Coverage', formula: '(EBITDA - CapEx) / (Interest + Principal + Rent)', interpretation: 'Comprehensive debt service capacity'),
      KeyRatio(ratio: 'Loan-to-Value', formula: 'Loan Balance / Collateral Value', interpretation: 'Collateral cushion; typically max 60-80% LTV'),
    ],
    breakEvenAnalysis: 'Long-term loan creates value when project returns exceed after-tax cost of debt. Break-even IRR = After-tax cost of debt. Example: 8% loan, 25% tax rate = 6% after-tax cost. If project returns 12%, each \$1 borrowed creates \$0.06 annual value. Also consider whether debt/EBITDA stays within covenant limits.',
  ),
  accountingTreatment: AccountingTreatment(
    recognitionMeasurement: 'Initially recorded at net proceeds (face value less issuance costs if material). Subsequently measured at amortized cost. Current portion (due within 12 months) classified as current liability; remainder as long-term. Effective interest method for amortizing fees and discounts.',
    journalEntries: [
      JournalEntry(debit: 'Cash (Net Proceeds)', credit: 'Long-term Debt', description: 'Record loan proceeds received'),
      JournalEntry(debit: 'Deferred Financing Costs', credit: 'Cash', description: 'Record upfront fees paid (if material)'),
      JournalEntry(debit: 'Interest Expense', credit: 'Interest Payable/Cash', description: 'Accrue or pay periodic interest'),
      JournalEntry(debit: 'Long-term Debt', credit: 'Cash', description: 'Record principal repayment'),
      JournalEntry(debit: 'Interest Expense', credit: 'Deferred Financing Costs', description: 'Amortize loan fees over term'),
    ],
    financialStatementImpact: FinancialStatementImpact(
      balanceSheet: 'Cash increases by net proceeds. Long-term liabilities increase. Deferred financing costs shown as contra-liability (current rules) or asset (old rules). Current portion of long-term debt shown in current liabilities.',
      incomeStatement: 'Interest expense increases. Fee amortization included in interest. Tax shield from interest deductibility reduces tax expense.',
      cashFlowStatement: 'Proceeds shown in Financing Activities. Interest payments typically in Operating (US GAAP). Principal repayments in Financing Activities.',
    ),
    disclosureRequirements: ['Principal amount, interest rate, and maturity', 'Current and long-term portions', 'Collateral pledged and its carrying value', 'Future minimum principal payments by year', 'Key covenant terms and compliance status', 'Fair value of debt (Level 2 measurement typically)'],
    ifrsVsGaap: 'Treatment substantially similar. Key differences: (1) US GAAP historically allowed loan fees as asset; now both treat as contra-liability. (2) Interest payment classification differs - US GAAP requires operating; IFRS allows choice. (3) Both require effective interest method for amortization. (4) Modification accounting rules can differ.',
  ),
  strategicConsiderations: StrategicConsiderations(
    decisionCriteria: ['Asset Life Match: Loan term should approximate asset useful life', 'Cash Flow Predictability: Stable cash flows support debt service', 'Collateral Availability: Assets available to secure borrowing', 'Current Leverage: Existing debt levels and covenant capacity', 'Interest Rate View: Fixed vs. floating based on rate outlook', 'Flexibility Need: Prepayment rights and covenant headroom'],
    comparisonWithAlternatives: 'vs. Bonds: Loans offer more flexibility, faster execution, but may cost more. vs. Equity: No dilution but fixed obligations. vs. Leasing: Off-balance sheet benefits (operating), but often more expensive. vs. Short-term Debt: Better matches long-term assets but commits to payments longer.',
    impactOnFinancialPosition: 'Increases total debt and leverage ratios. Long-term liability with current portion. Reduces equity returns if return on assets below cost of debt. Tax shield creates value. Must monitor covenant compliance continuously.',
    commonMistakes: ['Financing long-term assets with short-term debt (maturity mismatch)', 'Accepting overly restrictive covenants during good times', 'Not shopping competitive terms among multiple lenders', 'Underestimating total borrowing costs including fees', 'Failing to model downside scenarios for covenant compliance', 'Over-leveraging based on peak earnings projections'],
    bestPractices: ['Match loan maturity to asset life/project payback', 'Negotiate covenant cushion (EBITDA at least 20% above covenant)', 'Consider fixed vs. floating rate based on risk tolerance', 'Maintain multiple bank relationships for future flexibility', 'Model stress scenarios to ensure debt sustainability', 'Review and refinance when market terms improve'],
  ),
  practicalApplication: PracticalApplication(
    realWorldExample: 'Delta Air Lines 2020 Secured Financing: Amid COVID crisis, Delta raised \$9B in secured loans using aircraft, routes, and loyalty program as collateral. Despite severe revenue decline, secured assets enabled financing. Demonstrates: (1) Collateral value critical in stress; (2) Asset-backed lending available when unsecured isn\'t; (3) Creative collateral packages possible.',
    calculationExample: 'Company borrows \$20M at SOFR+300bps (8% total) for 5 years, quarterly amortization. Quarterly payment: \$20M amortized over 5 years = \$1M principal + interest. Year 1 interest: ~\$1.4M (declining as principal repays). Total interest over 5 years: ~\$4.4M. After-tax cost at 25%: \$3.3M. If investment returns 15% annually: NPV of investment = positive value creation.',
    caseStudy: 'Hertz Bankruptcy (2020): Car rental company had \$19B debt, mostly secured by vehicles. When vehicle values collapsed with demand, loan-to-value covenants triggered defaults. Emerged from bankruptcy in 2021 with reduced debt and new equity. Lessons: (1) Cyclical businesses need conservative leverage; (2) Asset-backed loans have value decline risk; (3) Covenant flexibility matters in downturns.',
    industryVariations: ['Manufacturing: Equipment loans with 5-7 year terms matching asset life', 'Real Estate: Long-term mortgages (15-30 years) with high LTV', 'Healthcare: Revenue-based lending against patient receivables', 'Technology: Often difficult to secure; relies on cash flow lending', 'Utilities: Infrastructure financing with 15-30+ year terms'],
    regulatoryConsiderations: ['Leveraged Lending Guidance: US regulators limit bank exposure to highly leveraged loans', 'Risk Retention: Regulations require arrangers retain economic interest', 'UCC Filings: Perfection of security interests required', 'Fraudulent Transfer Laws: Loans must provide fair consideration', 'Cross-Border: Tax treaties, withholding, and security jurisdiction issues', 'Environmental: Lender liability for contaminated collateral'],
  ),
);


// ============================================================================
// INVESTING DECISIONS
// ============================================================================

const equipmentInvestmentContent = ScenarioEducationalContent(
  coreFramework: CoreFramework(
    definitionOverview: 'Equipment investment refers to capital expenditure on machinery, technology, vehicles, and other tangible assets used in business operations. These investments are evaluated based on their ability to improve productivity, reduce costs, expand capacity, or enable new capabilities, with returns compared against the cost of capital.',
    keyCharacteristics: ['Tangible, long-lived assets with determinable useful life', 'Depreciable for tax and accounting purposes', 'Usually requires significant upfront capital outlay', 'Generates returns over multiple years through operations', 'May become obsolete due to technology changes', 'Can be financed through purchase, lease, or rental'],
    typesClassifications: ['Production Equipment: Manufacturing machinery, assembly lines', 'Technology Equipment: Servers, computers, software systems', 'Transportation Equipment: Vehicles, trucks, aircraft', 'Office Equipment: Furniture, fixtures, communication systems', 'Specialized Equipment: Medical devices, laboratory instruments', 'Heavy Equipment: Construction, mining, agricultural machinery'],
    advantages: ['Increases production capacity and efficiency', 'Reduces labor costs through automation', 'Improves product quality and consistency', 'Tax benefits through depreciation deductions', 'May provide competitive advantage', 'Asset can serve as collateral for financing'],
    disadvantages: ['Large upfront capital requirement', 'Risk of technological obsolescence', 'Maintenance and operating costs', 'Fixed cost structure reduces flexibility', 'May require workforce retraining', 'Resale value uncertainty'],
    whenToUse: ['Current equipment at end of useful life', 'Demand growth requires expanded capacity', 'New technology offers significant cost savings', 'Quality improvements needed to meet standards', 'Labor costs rising faster than equipment costs', 'Competitive pressure requires modernization'],
    keyTerminology: [
      KeyTerminology(term: 'CapEx', definition: 'Capital Expenditure - spending on long-term assets that benefit multiple periods'),
      KeyTerminology(term: 'Useful Life', definition: 'Estimated period over which asset will provide economic benefits'),
      KeyTerminology(term: 'Salvage Value', definition: 'Estimated residual value at end of useful life'),
      KeyTerminology(term: 'Depreciation', definition: 'Systematic allocation of asset cost over useful life'),
      KeyTerminology(term: 'Payback Period', definition: 'Time required to recover initial investment from cash flows'),
      KeyTerminology(term: 'Throughput', definition: 'Volume of production or processing capacity'),
    ],
  ),
  mechanicsProcess: MechanicsProcess(
    howItWorks: 'The investment process begins with identifying operational needs, evaluating alternatives, projecting cash flows, and applying capital budgeting techniques. Once approved, equipment is procured, installed, and commissioned. Performance is monitored against projections, and maintenance programs ensure optimal utilization over the asset\'s life.',
    stepByStepProcess: ['1. Need Identification: Define operational requirement driving investment', '2. Alternatives Analysis: Compare equipment options (make/model/supplier)', '3. Financial Analysis: Project cash flows and calculate NPV, IRR, payback', '4. Financing Decision: Purchase vs. lease analysis', '5. Budget Approval: Present to management/board for capital approval', '6. Procurement: Vendor selection, negotiation, contracting', '7. Installation: Physical installation and integration', '8. Commissioning: Testing and validation', '9. Training: Workforce preparation for new equipment', '10. Operations: Ongoing monitoring and maintenance'],
    keyPartiesInvolved: ['Operations Management: Identifies need and defines requirements', 'Engineering: Technical specifications and installation', 'Finance: Financial analysis and budget approval', 'Procurement: Vendor management and purchasing', 'Equipment Vendors: Supply and installation', 'IT Department: System integration', 'Maintenance: Ongoing support and repairs'],
    documentationRequired: ['Capital Expenditure Request (CER): Formal investment proposal', 'Technical Specifications: Equipment requirements', 'Financial Analysis: NPV, IRR, payback calculations', 'Vendor Quotes: Competitive pricing information', 'Purchase Order/Contract: Legal purchasing agreement', 'Installation Plan: Project timeline and milestones', 'Asset Record: Fixed asset register entry'],
    timelineMilestones: ['Month 1: Need identification and initial analysis', 'Month 2: Request for proposals and vendor evaluation', 'Month 3: Financial analysis and budget approval', 'Month 4: Contract negotiation and execution', 'Month 4-6: Manufacturing/delivery lead time', 'Month 6-8: Installation and commissioning', 'Month 8+: Production ramp-up and performance monitoring'],
  ),
  financialAnalysis: FinancialAnalysis(
    valuationPricing: 'Equipment value based on: (1) Present value of expected cost savings/revenue generation; (2) Comparable market prices; (3) Replacement cost. Capital budgeting evaluates NPV of incremental cash flows at company\'s cost of capital. Equipment typically depreciates 15-25% per year in market value.',
    costCalculation: 'Total Cost of Ownership (TCO) = Purchase Price + Installation + Training + Annual Operating Costs × Years + Maintenance - Salvage Value. Example: \$1M equipment, \$50K installation, \$20K training, \$80K annual ops/maintenance over 5 years, \$100K salvage. TCO = \$1M + \$50K + \$20K + (\$80K × 5) - \$100K = \$1.37M over 5 years.',
    riskFactors: ['Technology Risk: Equipment becomes obsolete before end of useful life', 'Demand Risk: Production capacity not fully utilized', 'Operating Risk: Higher maintenance costs than projected', 'Implementation Risk: Installation delays or cost overruns', 'Vendor Risk: Supplier failure or lack of support', 'Regulatory Risk: New regulations require modification'],
    returnMetrics: ['Net Present Value (NPV): Present value of cash flows minus initial investment', 'Internal Rate of Return (IRR): Discount rate that makes NPV = 0', 'Payback Period: Years to recover initial investment', 'Profitability Index: NPV / Initial Investment', 'Return on Assets: Operating Income / Average Assets'],
    keyRatios: [
      KeyRatio(ratio: 'Net Present Value', formula: 'Σ(Cash Flow_t / (1+r)^t) - Initial Investment', interpretation: 'Positive NPV = value-creating investment'),
      KeyRatio(ratio: 'Internal Rate of Return', formula: 'Rate where NPV = 0', interpretation: 'Should exceed cost of capital (hurdle rate)'),
      KeyRatio(ratio: 'Payback Period', formula: 'Initial Investment / Annual Cash Flow', interpretation: 'Shorter is better; typical hurdle 3-5 years'),
      KeyRatio(ratio: 'Asset Turnover', formula: 'Revenue / Average Total Assets', interpretation: 'Measures productivity of equipment investment'),
    ],
    breakEvenAnalysis: 'Break-even volume = Fixed Costs / (Price - Variable Cost per unit). For equipment investment: Annual fixed costs (depreciation, maintenance) must be covered by contribution from additional production. Equipment pays for itself when cumulative cash flows equal initial investment.',
  ),
  accountingTreatment: AccountingTreatment(
    recognitionMeasurement: 'Capitalize all costs necessary to bring asset to working condition (purchase price, freight, installation, testing). Depreciate over useful life using appropriate method. Test for impairment if indicators exist. De-recognize upon sale or disposal.',
    journalEntries: [
      JournalEntry(debit: 'Equipment (Fixed Asset)', credit: 'Cash/Accounts Payable', description: 'Record equipment purchase'),
      JournalEntry(debit: 'Equipment', credit: 'Cash', description: 'Capitalize installation costs'),
      JournalEntry(debit: 'Depreciation Expense', credit: 'Accumulated Depreciation', description: 'Record periodic depreciation'),
      JournalEntry(debit: 'Cash', credit: 'Equipment, Accumulated Depreciation', description: 'Record sale/disposal (may have gain/loss)'),
    ],
    financialStatementImpact: FinancialStatementImpact(
      balanceSheet: 'Fixed assets increase by capitalized cost. Accumulated depreciation reduces net book value over time. Working capital reduced by cash outflow.',
      incomeStatement: 'Depreciation expense reduces operating income. May have operating cost savings. Gain/loss on disposal affects income in disposal year.',
      cashFlowStatement: 'Initial purchase shown as \'Capital expenditures\' in Investing Activities. Depreciation added back in Operating Activities (non-cash). Proceeds from sale in Investing Activities.',
    ),
    disclosureRequirements: ['Depreciation method and useful life assumptions', 'Gross amount and accumulated depreciation by category', 'Additions, disposals, and impairments during period', 'Future capital commitments', 'Assets pledged as collateral'],
    ifrsVsGaap: 'Both capitalize costs to bring asset to working condition. Differences: (1) IFRS allows revaluation model; GAAP requires cost model. (2) Component depreciation more emphasized under IFRS. (3) Impairment testing and reversal rules differ. (4) Both require consistency in depreciation method.',
  ),
  strategicConsiderations: StrategicConsiderations(
    decisionCriteria: ['Strategic Fit: Does investment support business strategy?', 'Economic Viability: Does NPV/IRR meet hurdle rates?', 'Capacity Need: Is additional capacity required?', 'Technology: Is investment state-of-the-art or soon obsolete?', 'Alternative Uses: What else could capital fund?', 'Risk Profile: Downside scenarios acceptable?'],
    comparisonWithAlternatives: 'vs. Leasing: Ownership benefits vs. flexibility; tax/accounting implications. vs. Outsourcing: Make vs. buy decision; control vs. cost. vs. Refurbishment: Extend existing equipment life vs. new. vs. Alternative Technology: Compare competing solutions.',
    impactOnFinancialPosition: 'Increases fixed assets and total assets. Reduces cash initially. Depreciation affects profitability. May require financing (debt/equity). Increases operating leverage (fixed vs. variable costs). Improves asset turnover if productive.',
    commonMistakes: ['Underestimating total cost of ownership', 'Overly optimistic utilization assumptions', 'Ignoring technological obsolescence risk', 'Not considering installation and training time', 'Failing to account for working capital impact', 'Using inappropriate discount rate'],
    bestPractices: ['Conduct thorough total cost of ownership analysis', 'Include realistic downside scenarios', 'Consider flexibility value (options to expand/abandon)', 'Engage operations team in requirements definition', 'Negotiate service/warranty terms carefully', 'Post-investment review to improve future decisions'],
  ),
  practicalApplication: PracticalApplication(
    realWorldExample: 'Amazon\'s Robotics Investment: Amazon has deployed over 750,000 robots in fulfillment centers, investing billions in automation. Each robot costs \$30K-50K but processes orders 4x faster than manual methods. ROI driven by: labor cost savings, increased throughput, reduced errors, and 24/7 operation capability.',
    calculationExample: 'New machine costs \$500K, saves \$150K annually in labor/efficiency for 5 years, salvage \$50K. WACC = 10%. NPV = -\$500K + \$150K/1.1 + \$150K/1.21 + \$150K/1.331 + \$150K/1.464 + (\$150K+\$50K)/1.611 = -\$500K + \$136K + \$124K + \$113K + \$102K + \$124K = \$99K (positive NPV). IRR ≈ 17%. Payback ≈ 3.3 years. Investment approved.',
    caseStudy: 'Tesla Gigafactory: \$5B investment in battery manufacturing with goal of reducing costs 30% through scale and automation. Required: (1) Massive upfront capital; (2) Technology risk in unproven manufacturing methods; (3) Demand assumptions for electric vehicles. Result: Achieved cost reductions, created competitive advantage, though took longer and cost more than planned.',
    industryVariations: ['Manufacturing: Heavy focus on automation and robotics ROI', 'Healthcare: Regulatory approval adds time and cost', 'Retail: Technology equipment for omnichannel capabilities', 'Agriculture: Precision farming equipment with measurable yield improvements', 'Transportation: Fleet economics drive vehicle replacement cycles'],
    regulatoryConsiderations: ['Safety Regulations: OSHA requirements for equipment operation', 'Environmental: Emissions standards for certain equipment', 'Tax Incentives: Bonus depreciation, Section 179, investment credits', 'Import/Tariffs: Trade policy affects equipment costs', 'Industry-Specific: FDA approval for medical devices, FAA for aviation'],
  ),
);

const rdInvestmentContent = ScenarioEducationalContent(
  coreFramework: CoreFramework(
    definitionOverview: 'Research and Development (R&D) investment encompasses expenditures on activities aimed at developing new products, processes, or services, or significantly improving existing ones. R&D is critical for innovation, competitive advantage, and long-term growth, though it carries inherent uncertainty in outcomes.',
    keyCharacteristics: ['High uncertainty of success and timing of returns', 'Often significant before any revenue generation', 'Creates intangible assets (intellectual property)', 'May be eligible for tax credits in many jurisdictions', 'Generally expensed under GAAP, capitalized under IFRS (development)', 'Essential for innovation-driven competitive advantage'],
    typesClassifications: ['Basic Research: Fundamental scientific knowledge without specific application', 'Applied Research: Directed toward specific practical objectives', 'Development: Translating research into products/processes', 'Process R&D: Improving manufacturing or operational efficiency', 'Product R&D: New or improved products/services', 'Platform R&D: Foundation technologies enabling multiple products'],
    advantages: ['Creates proprietary technology and intellectual property', 'Enables new products and revenue streams', 'Improves competitive positioning', 'May generate tax credits (15-20% in many jurisdictions)', 'Attracts and retains technical talent', 'Can create high barriers to entry'],
    disadvantages: ['High failure rate - most projects don\'t succeed commercially', 'Long payback periods before revenue generation', 'Significant upfront investment with uncertain returns', 'Difficult to value and forecast', 'Competitor breakthroughs can obsolete research', 'Key personnel dependency'],
    whenToUse: ['Industry requires continuous innovation to compete', 'Current products approaching end of life cycle', 'Technology shift creates opportunity to leapfrog', 'Customer needs not met by existing solutions', 'Regulatory changes require new approaches', 'Strategic priority to establish technology leadership'],
    keyTerminology: [
      KeyTerminology(term: 'R&D Intensity', definition: 'R&D spending as percentage of revenue; measure of innovation investment'),
      KeyTerminology(term: 'Patent', definition: 'Legal protection for inventions providing exclusivity for 20 years'),
      KeyTerminology(term: 'Prototype', definition: 'Working model demonstrating feasibility before full production'),
      KeyTerminology(term: 'Technology Readiness Level (TRL)', definition: 'Scale measuring maturity of technology development'),
      KeyTerminology(term: 'Pipeline', definition: 'Portfolio of R&D projects at various stages of development'),
      KeyTerminology(term: 'Time-to-Market', definition: 'Duration from concept to commercial launch'),
    ],
  ),
  mechanicsProcess: MechanicsProcess(
    howItWorks: 'R&D follows a stage-gate process: ideation, feasibility assessment, development, testing, and commercialization. Projects are evaluated at each stage with go/no-go decisions based on technical progress, market potential, and resource requirements. Portfolio management balances risk across early-stage and mature projects.',
    stepByStepProcess: ['1. Ideation: Generate and screen ideas from multiple sources', '2. Feasibility: Assess technical and commercial viability', '3. Concept Development: Define product specifications and business case', '4. Prototype Development: Build and test working models', '5. Testing & Validation: Verify performance meets requirements', '6. Pilot Production: Small-scale manufacturing trial', '7. Launch Preparation: Scale-up, marketing, distribution planning', '8. Commercialization: Full market launch', '9. Post-Launch: Monitor, iterate, plan next generation'],
    keyPartiesInvolved: ['R&D Team: Scientists, engineers, technicians conducting research', 'Product Management: Defines market requirements', 'Finance: Budgeting and project economics', 'Legal/IP: Patent filing and protection', 'Manufacturing: Production feasibility input', 'Marketing: Commercial viability assessment', 'External Partners: Universities, contractors, collaborators'],
    documentationRequired: ['Project Charter: Objectives, scope, resources, timeline', 'Business Case: Market analysis, financial projections', 'Technical Specifications: Product/process requirements', 'Stage-Gate Reviews: Progress assessment documents', 'Patent Applications: Intellectual property filings', 'R&D Tax Credit Documentation: Qualifying expenses records', 'Lab Notebooks: Research records (important for IP disputes)'],
    timelineMilestones: ['Year 1-2: Basic research and concept exploration', 'Year 2-3: Applied research and prototype development', 'Year 3-4: Development and testing', 'Year 4-5: Pilot production and validation', 'Year 5+: Commercialization and market launch', 'Note: Timelines vary dramatically by industry (pharma: 10-15 years; software: 6-18 months)'],
  ),
  financialAnalysis: FinancialAnalysis(
    valuationPricing: 'R&D value is challenging to assess: (1) Option pricing models value flexibility to continue/abandon; (2) Probability-adjusted NPV weights success scenarios; (3) Comparable transaction analysis for acquired R&D. Mature pipelines often valued at 2-5x annual R&D spend.',
    costCalculation: 'Total R&D investment includes: Personnel (60-70% typically), Materials and supplies, Equipment and facilities, External collaborations, Overhead allocation. R&D intensity (R&D/Revenue) varies: Pharma 15-25%, Tech 10-20%, Industrial 2-5%. Example: \$100M revenue company with 15% intensity = \$15M annual R&D.',
    riskFactors: ['Technical Risk: May not achieve desired performance', 'Market Risk: Customer needs may change during development', 'Competitive Risk: Competitor launches first or better solution', 'Regulatory Risk: Approval not obtained or delayed', 'Resource Risk: Key personnel departure', 'Commercial Risk: Market adoption slower than expected'],
    returnMetrics: ['R&D ROI: Incremental Profit from R&D / R&D Investment', 'Patent Value: Revenue generated by patented innovations', 'New Product Revenue %: Sales from products launched in last N years', 'Development Cycle Time: Ideation to launch duration', 'Success Rate: % of projects reaching commercialization'],
    keyRatios: [
      KeyRatio(ratio: 'R&D Intensity', formula: 'R&D Expense / Revenue', interpretation: 'Investment level; compare to industry peers'),
      KeyRatio(ratio: 'R&D-to-Patent Ratio', formula: 'R&D Expense / Patents Filed', interpretation: 'Efficiency of innovation output'),
      KeyRatio(ratio: 'New Product Vitality', formula: 'Revenue from New Products / Total Revenue', interpretation: 'Higher = successful innovation; target varies by industry'),
      KeyRatio(ratio: 'R&D Productivity', formula: 'Revenue Growth / R&D Investment', interpretation: 'Measures effectiveness of R&D spending'),
    ],
    breakEvenAnalysis: 'R&D project break-even: Point where cumulative cash flows from commercialized product equal total R&D investment plus cost of capital. With high failure rates, successful projects must generate returns covering failed projects. Example: 10% success rate means winners must return 10x+ investment.',
  ),
  accountingTreatment: AccountingTreatment(
    recognitionMeasurement: 'US GAAP: All R&D costs expensed as incurred (ASC 730). IFRS: Research expensed; Development capitalized when criteria met (technical feasibility, intention to complete, ability to use/sell, probable future economic benefits). Software development has specific guidance under both frameworks.',
    journalEntries: [
      JournalEntry(debit: 'R&D Expense', credit: 'Cash/Payables/Salaries', description: 'Record R&D costs (US GAAP)'),
      JournalEntry(debit: 'Intangible Asset - Development', credit: 'Cash/Payables', description: 'Capitalize development costs (IFRS if criteria met)'),
      JournalEntry(debit: 'Amortization Expense', credit: 'Intangible Asset', description: 'Amortize capitalized development over useful life (IFRS)'),
    ],
    financialStatementImpact: FinancialStatementImpact(
      balanceSheet: 'Under GAAP: No asset (expensed). Under IFRS: Intangible asset for capitalized development. Acquired R&D in business combinations capitalized under both.',
      incomeStatement: 'GAAP: Full expense in period incurred. IFRS: Research expensed, development capitalized and amortized. Affects comparability between GAAP and IFRS reporters.',
      cashFlowStatement: 'R&D spending shown in Operating Activities (as expense or working capital). Capitalized development under IFRS may be in Investing Activities.',
    ),
    disclosureRequirements: ['Total R&D expense for period', 'R&D acquired in business combinations', 'Capitalization policy (IFRS)', 'Amortization method and useful life for capitalized costs', 'Government grants or tax credits received', 'Contingencies related to R&D collaborations'],
    ifrsVsGaap: 'Major difference: GAAP expenses all R&D; IFRS capitalizes development costs meeting criteria. This affects: (1) Reported earnings - IFRS typically higher during development; (2) Asset base - IFRS shows intangible assets; (3) Comparability challenges for analysts. Software development has specific rules under both frameworks with some convergence.',
  ),
  strategicConsiderations: StrategicConsiderations(
    decisionCriteria: ['Strategic Importance: Alignment with long-term business strategy', 'Market Potential: Size of addressable market opportunity', 'Technical Feasibility: Realistic assessment of success probability', 'Competitive Position: Freedom to operate, defensibility', 'Resource Availability: Funding, talent, infrastructure', 'Risk/Return: Expected value considering failure probability'],
    comparisonWithAlternatives: 'vs. Acquisition: Buy innovation vs. build internally; speed vs. cost. vs. Licensing: Access technology without full development; royalties vs. ownership. vs. Joint Venture: Share risk/reward; coordination complexity. vs. Outsourcing: External development capabilities; IP concerns.',
    impactOnFinancialPosition: 'Reduces current earnings (expense vs. capitalize). No immediate asset creation under GAAP. Creates long-term value through IP and competitive position. May increase valuation multiples if market values innovation. Tax credits provide partial offset.',
    commonMistakes: ['Spreading resources too thin across too many projects', 'Continuing failed projects too long (escalation of commitment)', 'Not involving customers in development process', 'Underestimating time-to-market and development costs', 'Insufficient intellectual property protection', 'Disconnection between R&D and commercial strategy'],
    bestPractices: ['Use stage-gate process with clear decision criteria', 'Balance portfolio across risk levels and time horizons', 'Integrate customer feedback early and continuously', 'Protect intellectual property proactively', 'Benchmark R&D productivity against industry peers', 'Link R&D incentives to commercial outcomes'],
  ),
  practicalApplication: PracticalApplication(
    realWorldExample: 'Pfizer COVID-19 Vaccine Development: \$2B+ invested in mRNA vaccine development, completed in 11 months vs. typical 10+ years. Success factors: (1) Prior mRNA research foundation; (2) Massive parallel investment vs. sequential stages; (3) Government risk-sharing through advance purchases. Generated \$37B revenue in 2021, demonstrating potential R&D returns.',
    calculationExample: 'Biotech developing new drug: \$200M total development cost over 8 years. 10% probability of FDA approval. If approved: \$500M peak annual sales for 10 years, 20% margin. NPV analysis at 12% discount: Success scenario NPV = \$600M. Probability-adjusted NPV = \$600M × 10% = \$60M. Less \$200M investment = (\$140M) expected NPV. Need higher success rate or larger market to justify investment.',
    caseStudy: 'Kodak and Digital Photography: Despite inventing digital camera in 1975, Kodak failed to commercialize to protect film business. R&D investment without commercialization strategy. Lessons: (1) Innovation requires willingness to disrupt yourself; (2) Technology must connect to business model; (3) Timing of commercialization critical.',
    industryVariations: ['Pharmaceuticals: Longest cycles (10-15 years), highest R&D intensity (15-25%)', 'Technology: Rapid cycles (1-3 years), moderate intensity (10-20%)', 'Automotive: Medium cycles (3-5 years), moderate intensity (4-6%)', 'Consumer Products: Short cycles (<2 years), lower intensity (2-4%)', 'Aerospace/Defense: Long cycles (5-10+ years), customer-funded R&D common'],
    regulatoryConsiderations: ['R&D Tax Credits: US, UK, many countries provide 15-25% credits', 'Patent Law: 20-year protection from filing date', 'FDA/Regulatory Approval: Extensive requirements for drugs, devices', 'Export Controls: Restrictions on sharing certain technologies', 'Data Privacy: Research involving personal data has compliance requirements', 'Accounting Standards: GAAP/IFRS capitalization rules'],
  ),
);

const expansionInvestmentContent = ScenarioEducationalContent(
  coreFramework: CoreFramework(
    definitionOverview: 'Expansion investment refers to capital expenditure aimed at increasing business capacity, geographic reach, or market presence. This includes building new facilities, entering new markets, adding production capacity, or acquiring capabilities. Expansion investments are typically larger and riskier than replacement investments but offer growth potential.',
    keyCharacteristics: ['Significant capital commitment for growth initiatives', 'Returns dependent on market demand projections', 'Often involves entering new markets or segments', 'May require organizational capabilities development', 'Higher risk profile than maintenance/replacement CapEx', 'Typically evaluated using NPV, IRR, and strategic fit criteria'],
    typesClassifications: ['Capacity Expansion: Adding production capability in existing markets', 'Geographic Expansion: Entering new regional or international markets', 'Vertical Integration: Moving up or down the value chain', 'Horizontal Expansion: Entering adjacent product/service markets', 'Greenfield Investment: Building new facilities from scratch', 'Brownfield Investment: Expanding or repurposing existing facilities'],
    advantages: ['Captures growth opportunities and market share', 'Achieves economies of scale', 'Diversifies revenue streams and markets', 'Strengthens competitive position', 'Creates shareholder value through growth', 'May preempt competitor expansion'],
    disadvantages: ['Large capital requirement with uncertain returns', 'Execution risk in new markets/capabilities', 'May dilute focus on core business', 'Integration challenges if acquisition involved', 'Fixed costs increase operating leverage', 'Exit costs high if expansion fails'],
    whenToUse: ['Strong demand growth exceeds current capacity', 'Attractive new market with favorable economics', 'Competitive window to establish position', 'Core business mature; need growth engines', 'Strategic imperative (customer follows, supply chain)', 'Favorable financing conditions'],
    keyTerminology: [
      KeyTerminology(term: 'Greenfield', definition: 'New facility built from ground up on undeveloped site'),
      KeyTerminology(term: 'Brownfield', definition: 'Investment in existing facilities, often with renovation/expansion'),
      KeyTerminology(term: 'Market Entry', definition: 'Strategies to enter new geographic or product markets'),
      KeyTerminology(term: 'Scale Economics', definition: 'Cost advantages from increased production volume'),
      KeyTerminology(term: 'Hurdle Rate', definition: 'Minimum required return for investment approval'),
      KeyTerminology(term: 'Ramp-up Period', definition: 'Time to reach full operational capacity'),
    ],
  ),
  mechanicsProcess: MechanicsProcess(
    howItWorks: 'Expansion decisions begin with strategic planning identifying growth opportunities. Detailed feasibility analysis evaluates market potential, competitive dynamics, and required investment. Financial modeling projects cash flows and returns. Upon approval, execution involves site selection, construction/acquisition, and operational ramp-up.',
    stepByStepProcess: ['1. Strategic Assessment: Identify expansion opportunities aligned with strategy', '2. Market Analysis: Evaluate demand, competition, and market entry barriers', '3. Site Selection: For physical expansion, identify optimal locations', '4. Feasibility Study: Detailed technical and operational planning', '5. Financial Modeling: Project capital requirements, revenues, costs, returns', '6. Risk Assessment: Identify and quantify key risks', '7. Board Approval: Present business case for capital allocation', '8. Execution Planning: Detailed project plan and timeline', '9. Construction/Development: Physical build-out or acquisition closing', '10. Ramp-up: Gradual increase to full operational capacity'],
    keyPartiesInvolved: ['Executive Team: Strategic direction and approval', 'Business Development: Market opportunity identification', 'Finance: Financial analysis and funding', 'Operations: Execution and operational planning', 'Legal: Regulatory, permits, contracts', 'HR: Organizational capabilities and staffing', 'External Advisors: Market research, engineering, consultants'],
    documentationRequired: ['Strategic Plan: Business rationale and fit', 'Market Study: Demand analysis and competitive assessment', 'Feasibility Study: Technical and operational requirements', 'Financial Model: Detailed cash flow projections', 'Risk Analysis: Sensitivity and scenario analysis', 'Project Plan: Timeline, milestones, responsibilities', 'Board Presentation: Summary for approval decision'],
    timelineMilestones: ['Month 1-3: Strategic assessment and opportunity screening', 'Month 3-6: Detailed feasibility and market analysis', 'Month 6-9: Site selection and business case development', 'Month 9-12: Approval process and financing', 'Month 12-24: Construction/development (varies by project)', 'Month 24-36: Ramp-up to full capacity'],
  ),
  financialAnalysis: FinancialAnalysis(
    valuationPricing: 'Expansion value = NPV of incremental cash flows from new capacity/market. Key variables: (1) Revenue growth rate and market penetration; (2) Operating margins vs. existing business; (3) Capital intensity and working capital; (4) Terminal value assumptions; (5) Risk-adjusted discount rate (often higher than core business).',
    costCalculation: 'Total Expansion Investment = Land + Construction + Equipment + Working Capital + Pre-opening Costs + Contingency. Example: New manufacturing plant: Land \$10M, Construction \$50M, Equipment \$30M, Working Capital \$15M, Pre-opening \$5M, Contingency 10% = \$121M total. Annual operating costs drive ongoing cash requirements.',
    riskFactors: ['Demand Risk: Market growth slower than projected', 'Execution Risk: Construction delays, cost overruns', 'Competition Risk: Competitive response erodes returns', 'Operational Risk: Performance below expectations', 'Currency Risk: For international expansion', 'Political/Regulatory Risk: Policy changes in new markets'],
    returnMetrics: ['NPV: Net Present Value of expansion cash flows', 'IRR: Internal Rate of Return compared to hurdle rate', 'Payback: Years to recover initial investment', 'ROIC: Return on Invested Capital vs. WACC', 'Market Share: Captured position in target market'],
    keyRatios: [
      KeyRatio(ratio: 'NPV/Investment', formula: 'Net Present Value / Initial Investment', interpretation: 'Higher is better; measures value created per dollar invested'),
      KeyRatio(ratio: 'IRR vs. Hurdle Rate', formula: 'Project IRR - Corporate Hurdle Rate', interpretation: 'Positive spread indicates value creation'),
      KeyRatio(ratio: 'Investment/Revenue', formula: 'Total Investment / Year 5 Revenue', interpretation: 'Capital intensity; lower is more efficient'),
      KeyRatio(ratio: 'Break-even Utilization', formula: 'Fixed Costs / Contribution Margin per Unit', interpretation: 'Minimum capacity utilization needed'),
    ],
    breakEvenAnalysis: 'Expansion break-even has two dimensions: (1) Accounting: Revenue level where project achieves positive operating income; (2) Financial: NPV=0 point where project returns equal cost of capital. Higher fixed costs require higher utilization for break-even. Sensitivity analysis identifies key break-even drivers.',
  ),
  accountingTreatment: AccountingTreatment(
    recognitionMeasurement: 'Capitalize all costs necessary to prepare asset for intended use. Land not depreciated. Buildings/improvements over useful life (15-40 years). Equipment per category (5-15 years). Interest during construction may be capitalized. Pre-opening costs generally expensed.',
    journalEntries: [
      JournalEntry(debit: 'Construction in Progress', credit: 'Cash/Payables', description: 'Accumulate construction costs'),
      JournalEntry(debit: 'Land', credit: 'Cash', description: 'Record land purchase'),
      JournalEntry(debit: 'Building / Equipment', credit: 'Construction in Progress', description: 'Transfer to fixed assets when complete'),
      JournalEntry(debit: 'Depreciation Expense', credit: 'Accumulated Depreciation', description: 'Depreciate over useful life'),
    ],
    financialStatementImpact: FinancialStatementImpact(
      balanceSheet: 'Fixed assets increase by capitalized costs. Cash decreases or debt increases from financing. Working capital invested in new operations.',
      incomeStatement: 'Depreciation begins when asset placed in service. Pre-opening costs expensed. Initial periods may show losses during ramp-up.',
      cashFlowStatement: 'Construction payments in Investing Activities. Financing proceeds in Financing Activities. Subsequent depreciation added back in Operating section.',
    ),
    disclosureRequirements: ['Capital commitments for projects in progress', 'Capitalized interest during construction', 'Depreciation method and useful life by category', 'Impairment testing for long-lived assets', 'Geographic segment information for international expansion'],
    ifrsVsGaap: 'Generally similar treatment for expansion assets. Differences: (1) IFRS allows revaluation model; GAAP cost only. (2) IFRS requires component depreciation more strictly. (3) Impairment reversal allowed under IFRS, not GAAP. (4) Borrowing costs capitalization rules slightly different.',
  ),
  strategicConsiderations: StrategicConsiderations(
    decisionCriteria: ['Strategic Fit: Alignment with corporate strategy and capabilities', 'Market Attractiveness: Size, growth, competitive intensity', 'Competitive Advantage: Ability to win in target market', 'Financial Returns: NPV, IRR exceed hurdle rates', 'Risk Profile: Acceptable downside scenarios', 'Timing: Right competitive window'],
    comparisonWithAlternatives: 'vs. Acquisition: Build slower but controlled vs. buy faster with integration risk. vs. Joint Venture: Share risk/reward; less control. vs. Franchising/Licensing: Asset-light but limited upside. vs. Organic Growth: Maximize existing capacity first.',
    impactOnFinancialPosition: 'Significant increase in fixed assets and potentially debt. Higher depreciation reduces earnings initially. Increases operating leverage (risk). Creates growth optionality. May temporarily reduce ROIC before payback.',
    commonMistakes: ['Overestimating market demand and growth', 'Underestimating competitive response', 'Insufficient due diligence on new markets', 'Execution capabilities overconfidence', 'Not planning for ramp-up period losses', 'Ignoring exit costs if expansion fails'],
    bestPractices: ['Start with smaller pilot before full commitment', 'Build conservative demand scenarios', 'Develop local partnerships and knowledge', 'Plan for execution challenges and delays', 'Stage investments with decision points', 'Ensure organizational capabilities match ambition'],
  ),
  practicalApplication: PracticalApplication(
    realWorldExample: 'Starbucks China Expansion: From 1 store in 1999 to 6,000+ stores by 2022. Invested billions in new stores, local supply chain, and digital capabilities. Strategy: (1) Premium positioning; (2) Local adaptation (tea drinks); (3) Digital leadership (mobile app); (4) Real estate strategy (urban locations). Now China is largest market outside US.',
    calculationExample: 'Manufacturing plant expansion: \$80M investment, 5-year ramp to \$50M annual revenue, 20% operating margin, 10% WACC. Year 1-5 cash flows: (\$80M), \$2M, \$4M, \$6M, \$8M, \$10M + terminal value. NPV = (\$80M) + \$2M/1.1 + \$4M/1.21 + ... + TV = positive if terminal value supports. IRR ≈ 12% vs. 10% hurdle = proceed.',
    caseStudy: 'Target Canada Failure (2013-2015): \$4.4B investment to enter Canada, acquired 220 Zellers stores. Failures: (1) Supply chain problems caused empty shelves; (2) Price perception worse than US; (3) Store locations suboptimal; (4) IT systems not ready. Closed all stores in 2 years, wrote off entire investment. Lessons: Thorough preparation and realistic timelines essential.',
    industryVariations: ['Retail: Store expansion economics; sales per square foot focus', 'Manufacturing: Capacity expansion; utilization and scale economies', 'Technology: Data centers; rapidly evolving scale requirements', 'Healthcare: Facility expansion; regulatory and certificate of need', 'Hospitality: Hotel/restaurant expansion; market penetration strategy'],
    regulatoryConsiderations: ['Zoning and Permits: Land use, building, environmental permits', 'Foreign Investment: CFIUS (US), similar bodies internationally', 'Antitrust: Market concentration issues in some expansions', 'Environmental: Impact assessments, emissions permits', 'Labor Laws: Jurisdictional requirements in new markets', 'Tax Incentives: Economic development incentives often available'],
  ),
);

const costManagementContent = ScenarioEducationalContent(
  coreFramework: CoreFramework(
    definitionOverview: 'Cost management is the process of planning, controlling, and reducing business expenses to improve profitability without sacrificing quality or operational effectiveness. It encompasses budgeting, variance analysis, cost allocation, and continuous improvement initiatives aimed at optimizing the cost structure.',
    keyCharacteristics: ['Ongoing process of planning, monitoring, and controlling costs', 'Balances cost reduction with quality and performance', 'Encompasses all cost categories: variable, fixed, direct, indirect', 'Requires accurate cost allocation and measurement', 'Links to strategic objectives and competitive positioning', 'Uses various techniques: ABC, target costing, kaizen'],
    typesClassifications: ['Cost Reduction: Eliminating or reducing existing costs', 'Cost Avoidance: Preventing future cost increases', 'Cost Control: Managing costs within budget', 'Activity-Based Costing: Allocating costs to activities driving them', 'Target Costing: Designing products to meet cost targets', 'Kaizen Costing: Continuous incremental cost improvement'],
    advantages: ['Improves profit margins and competitiveness', 'Releases resources for strategic investments', 'Enhances operational efficiency', 'Provides better cost visibility for decisions', 'Supports pricing strategy development', 'Improves cash flow and financial flexibility'],
    disadvantages: ['Excessive cuts can damage quality or service', 'May harm employee morale if poorly executed', 'Short-term focus can sacrifice long-term capabilities', 'Implementation requires significant management attention', 'Cost cutting has diminishing returns', 'May trigger competitive response'],
    whenToUse: ['Margins below industry benchmarks', 'Competitive pressure on pricing', 'Cost structure higher than competitors', 'Economic downturn requiring survival mode', 'Preparing for major investment or M&A', 'Post-acquisition integration synergies'],
    keyTerminology: [
      KeyTerminology(term: 'Variable Cost', definition: 'Costs that change proportionally with production/sales volume'),
      KeyTerminology(term: 'Fixed Cost', definition: 'Costs that remain constant regardless of activity level'),
      KeyTerminology(term: 'Contribution Margin', definition: 'Revenue minus variable costs; amount contributing to fixed costs and profit'),
      KeyTerminology(term: 'Operating Leverage', definition: 'Ratio of fixed to variable costs; higher leverage amplifies profit changes'),
      KeyTerminology(term: 'Break-even Point', definition: 'Volume where total revenue equals total costs'),
      KeyTerminology(term: 'Cost Driver', definition: 'Factor causing a cost to be incurred; basis for cost allocation'),
    ],
  ),
  mechanicsProcess: MechanicsProcess(
    howItWorks: 'Cost management begins with understanding the cost structure through analysis and benchmarking. Opportunities are identified through variance analysis, activity-based costing, and best practice comparison. Initiatives are prioritized, implemented, and monitored. Continuous improvement embeds cost consciousness into organizational culture.',
    stepByStepProcess: ['1. Cost Structure Analysis: Map all costs by category, behavior, and driver', '2. Benchmarking: Compare costs to industry peers and best practices', '3. Opportunity Identification: Find gaps and improvement potential', '4. Root Cause Analysis: Understand why costs exist', '5. Initiative Development: Design specific cost reduction actions', '6. Prioritization: Rank by impact, feasibility, risk', '7. Implementation: Execute initiatives with clear accountability', '8. Monitoring: Track progress against targets', '9. Continuous Improvement: Institutionalize cost consciousness'],
    keyPartiesInvolved: ['Finance: Cost analysis, budgeting, tracking', 'Operations: Process improvement and execution', 'Procurement: Supplier negotiations and sourcing', 'HR: Workforce optimization and training', 'Business Unit Leaders: Accountability for results', 'Executive Sponsor: Strategic direction and commitment'],
    documentationRequired: ['Cost Structure Analysis: Detailed cost breakdown', 'Benchmark Study: Comparison to peers/best practices', 'Initiative Plans: Specific actions with owners and targets', 'Business Case: Expected savings and implementation cost', 'Progress Reports: Tracking against milestones', 'Budget Variance Analysis: Actual vs. planned performance'],
    timelineMilestones: ['Month 1: Cost structure analysis and benchmarking', 'Month 2: Opportunity identification and prioritization', 'Month 3: Initiative planning and approval', 'Month 3-6: Quick wins implementation', 'Month 6-12: Major initiatives implementation', 'Ongoing: Continuous monitoring and improvement'],
  ),
  financialAnalysis: FinancialAnalysis(
    valuationPricing: 'Cost reduction value = Present value of ongoing savings. One-time cost reduction of \$1M annually at 10% discount rate = \$10M perpetuity value. Consider: (1) Sustainability of savings; (2) Implementation costs; (3) Risk of negative consequences. Margin improvement directly increases company valuation.',
    costCalculation: 'Total Cost of Ownership approach: Direct costs + Indirect costs + Hidden costs (quality, flexibility, opportunity). Cost reduction ROI = Annual Savings / Implementation Investment. Example: \$500K implementation cost, \$200K annual savings = 2.5 year payback, 40% annual ROI.',
    riskFactors: ['Quality Risk: Cost cuts may degrade product/service quality', 'Capacity Risk: Cutting too deep may impair growth ability', 'Employee Risk: Morale and retention issues from workforce reductions', 'Supplier Risk: Squeezing suppliers may harm long-term relationships', 'Customer Risk: Service level reductions may lose customers', 'Sustainability Risk: One-time cuts may not persist'],
    returnMetrics: ['Gross Margin Improvement: Change in gross profit %', 'Operating Margin Improvement: Change in EBIT %', 'Cost-to-Revenue Ratio: Operating costs / Revenue', 'Productivity Metrics: Revenue per employee, units per labor hour', 'Working Capital Improvement: Days Sales Outstanding, Inventory Turns'],
    keyRatios: [
      KeyRatio(ratio: 'Operating Margin', formula: 'Operating Income / Revenue', interpretation: 'Higher is better; compare to industry peers'),
      KeyRatio(ratio: 'SG&A Ratio', formula: 'SG&A Expenses / Revenue', interpretation: 'Lower indicates efficiency; varies by industry'),
      KeyRatio(ratio: 'Cost per Unit', formula: 'Total Costs / Units Produced', interpretation: 'Measure of production efficiency'),
      KeyRatio(ratio: 'Labor Productivity', formula: 'Revenue / Number of Employees', interpretation: 'Higher indicates workforce efficiency'),
    ],
    breakEvenAnalysis: 'Lower costs reduce break-even point. Break-even = Fixed Costs / Contribution Margin. If fixed costs reduced from \$1M to \$800K and contribution margin is \$20/unit, break-even drops from 50,000 to 40,000 units. Every unit above break-even generates higher profit.',
  ),
  accountingTreatment: AccountingTreatment(
    recognitionMeasurement: 'Costs recognized when incurred based on matching principle. Cost reduction initiatives may have upfront implementation costs (restructuring charges) followed by ongoing savings. Restructuring charges include severance, asset impairments, contract terminations.',
    journalEntries: [
      JournalEntry(debit: 'Restructuring Expense', credit: 'Restructuring Liability', description: 'Record restructuring charge (severance, etc.)'),
      JournalEntry(debit: 'Restructuring Liability', credit: 'Cash', description: 'Pay restructuring costs'),
      JournalEntry(debit: 'Cost of Goods Sold (Reduction)', credit: 'Various Expense Accounts', description: 'Lower production costs flow through COGS'),
    ],
    financialStatementImpact: FinancialStatementImpact(
      balanceSheet: 'Restructuring liability may appear temporarily. Working capital may improve from efficiency gains. Asset impairments reduce asset values.',
      incomeStatement: 'Restructuring charges as one-time expense. Ongoing savings improve margins. May be shown as special items or operating depending on materiality.',
      cashFlowStatement: 'Restructuring payments in Operating Activities. Ongoing cash savings improve operating cash flow.',
    ),
    disclosureRequirements: ['Restructuring charges and nature of actions', 'Expected completion timeline and remaining accrual', 'Cost savings expected from restructuring', 'Segment reporting of costs where applicable', 'Changes in significant accounting estimates'],
    ifrsVsGaap: 'Generally similar treatment. Restructuring provisions: IFRS requires constructive obligation evidence; GAAP requires detailed plan communicated to employees. Both require expenses when criteria met. Presentation may differ - GAAP often separates from operating; IFRS may include in operating costs.',
  ),
  strategicConsiderations: StrategicConsiderations(
    decisionCriteria: ['Strategic Alignment: Do cost cuts support or harm strategy?', 'Sustainability: Will savings persist over time?', 'Competitive Impact: Does this improve competitive position?', 'Customer Impact: Will customers notice quality/service changes?', 'Employee Impact: Effect on morale and retention?', 'Implementation Risk: Can we execute successfully?'],
    comparisonWithAlternatives: 'vs. Revenue Growth: Both improve margins; cost cutting faster but limited. vs. Pricing Increase: May lose volume; test elasticity first. vs. Product Mix Shift: Move to higher-margin products. vs. Outsourcing: Transfer costs to specialists; loss of control.',
    impactOnFinancialPosition: 'Immediate profit improvement from cost reduction. May have one-time charges before benefits. Improved margins increase valuation multiples. Better cash flow enables investment or debt reduction. Sustainable cost leadership provides competitive advantage.',
    commonMistakes: ['Across-the-board cuts without strategic prioritization', 'Cutting investments that drive future growth', 'Ignoring hidden costs of quality or service decline', 'Underestimating implementation difficulty', 'Not communicating rationale to employees', 'Declaring victory before savings are sustainable'],
    bestPractices: ['Link cost management to strategy, not just crisis response', 'Benchmark against best-in-class, not just competitors', 'Engage employees in identifying improvements', 'Protect strategic capabilities and investments', 'Track savings rigorously with clear accountability', 'Build cost consciousness into culture'],
  ),
  practicalApplication: PracticalApplication(
    realWorldExample: '3G Capital/AB InBev Cost Management: Known for zero-based budgeting (ZBB), requiring all expenses justified each year. Post Anheuser-Busch acquisition, cut \$2.5B costs through: headcount reduction, eliminating perks, supplier renegotiation, marketing efficiency. Controversial but effective - margins improved significantly.',
    calculationExample: 'Manufacturing company analysis: Current COGS \$50M, Operating expenses \$20M, Revenue \$100M. Operating margin = 30%. Identify: \$3M raw material savings (6%), \$2M labor efficiency (4%), \$1.5M overhead reduction (7.5%). Total savings \$6.5M. New margin = (\$30M + \$6.5M)/\$100M = 36.5%, improvement of 650 basis points.',
    caseStudy: 'Circuit City vs. Best Buy: Circuit City cut costs including experienced sales staff to improve margins. Best Buy invested in knowledgeable staff and customer experience. Circuit City\'s cost cuts damaged customer service, leading to market share loss and eventually bankruptcy (2009). Best Buy survived and thrived. Lesson: Cost cuts must preserve customer value proposition.',
    industryVariations: ['Manufacturing: Focus on production efficiency, lean operations', 'Retail: Store labor optimization, supply chain efficiency', 'Technology: Automate manual processes, cloud optimization', 'Healthcare: Supply chain, administrative efficiency', 'Financial Services: Process automation, real estate optimization'],
    regulatoryConsiderations: ['WARN Act: 60-day notice required for mass layoffs in US', 'Severance Regulations: Vary by jurisdiction', 'Union Agreements: May restrict cost-cutting actions', 'Quality Regulations: Cannot cut costs below safety/quality standards', 'Tax Implications: Restructuring charges may affect tax position'],
  ),
);

const inventoryManagementContent = ScenarioEducationalContent(
  coreFramework: CoreFramework(
    definitionOverview: 'Inventory management is the process of ordering, storing, using, and selling a company\'s inventory, including raw materials, work-in-progress, and finished goods. Effective inventory management balances having enough stock to meet demand while minimizing carrying costs and avoiding obsolescence.',
    keyCharacteristics: ['Balances service level (availability) vs. cost (carrying, obsolescence)', 'Encompasses entire supply chain from raw materials to finished goods', 'Requires demand forecasting and supply planning', 'Significant working capital investment tied up in inventory', 'Key performance metrics: turnover, days inventory, fill rate', 'Technology-enabled through ERP, WMS, demand planning systems'],
    typesClassifications: ['Raw Materials: Inputs awaiting production', 'Work-in-Progress (WIP): Partially completed goods in production', 'Finished Goods: Completed products ready for sale', 'Safety Stock: Buffer inventory for demand/supply uncertainty', 'Cycle Stock: Regular inventory to meet normal demand', 'Pipeline Inventory: In-transit inventory'],
    advantages: ['Ensures product availability to meet customer demand', 'Enables production smoothing and efficiency', 'Provides buffer against supply disruptions', 'Allows bulk purchasing discounts', 'Supports seasonal business patterns', 'Hedge against price increases'],
    disadvantages: ['Ties up significant working capital', 'Carrying costs (storage, insurance, handling)', 'Risk of obsolescence or spoilage', 'Hides operational problems (excess masks inefficiency)', 'Opportunity cost of capital invested', 'Complexity of managing multiple SKUs'],
    whenToUse: ['Customer demand variable or seasonal', 'Supply lead times long or uncertain', 'Production economies require batch sizes', 'Supplier quantity discounts significant', 'Product life cycles create obsolescence risk', 'Service level requirements demanding (e.g., 99% fill rate)'],
    keyTerminology: [
      KeyTerminology(term: 'SKU', definition: 'Stock Keeping Unit - unique identifier for each distinct product'),
      KeyTerminology(term: 'Safety Stock', definition: 'Extra inventory held to prevent stockouts from demand/supply variability'),
      KeyTerminology(term: 'Lead Time', definition: 'Time from order placement to receipt of inventory'),
      KeyTerminology(term: 'Reorder Point', definition: 'Inventory level triggering new order placement'),
      KeyTerminology(term: 'Economic Order Quantity (EOQ)', definition: 'Optimal order size minimizing total ordering and carrying costs'),
      KeyTerminology(term: 'Fill Rate', definition: 'Percentage of customer orders fulfilled from available inventory'),
    ],
  ),
  mechanicsProcess: MechanicsProcess(
    howItWorks: 'Inventory management involves forecasting demand, determining appropriate stock levels, placing orders, receiving and storing goods, and managing the flow to production or customers. Systems track inventory levels and trigger replenishment. Performance is measured through turnover, fill rates, and carrying costs.',
    stepByStepProcess: ['1. Demand Forecasting: Project customer demand by SKU and time period', '2. Inventory Planning: Set target levels based on service requirements', '3. Supply Planning: Determine order quantities and timing', '4. Procurement: Place orders with suppliers', '5. Receiving: Verify and receive incoming inventory', '6. Storage: Organize and store inventory appropriately', '7. Picking/Fulfillment: Retrieve inventory for orders', '8. Cycle Counting: Regular verification of inventory accuracy', '9. Analysis: Review performance metrics and adjust'],
    keyPartiesInvolved: ['Supply Chain/Planning: Forecasting and inventory optimization', 'Procurement: Supplier management and ordering', 'Warehouse Operations: Storage and handling', 'Finance: Working capital and cost management', 'Sales/Marketing: Demand input and service requirements', 'IT: System implementation and data management'],
    documentationRequired: ['Demand Forecast: Projected sales by SKU', 'Inventory Policy: Service levels, safety stock rules', 'Purchase Orders: Orders to suppliers', 'Receiving Documents: Verification of receipts', 'Inventory Reports: Stock levels, movement, aging', 'Physical Count Records: Cycle count and annual inventory'],
    timelineMilestones: ['Daily: Monitor stock levels and exceptions', 'Weekly: Review replenishment and expedites', 'Monthly: Analyze turnover and aging', 'Quarterly: Review slow-moving and obsolete', 'Annually: Strategic inventory policy review', 'Continuous: Improve forecast accuracy'],
  ),
  financialAnalysis: FinancialAnalysis(
    valuationPricing: 'Inventory valued at lower of cost or net realizable value. Carrying cost typically 20-30% of inventory value annually (capital cost, storage, handling, insurance, obsolescence). Inventory optimization can release significant working capital and improve return on assets.',
    costCalculation: 'Total Inventory Cost = Purchase Cost + Ordering Cost + Carrying Cost + Stockout Cost. Carrying Cost = Inventory Value × Carrying Rate (typically 20-30%). Example: \$10M average inventory × 25% carrying rate = \$2.5M annual carrying cost. EOQ minimizes sum of ordering and carrying costs.',
    riskFactors: ['Demand Risk: Forecast error leads to excess or shortage', 'Supply Risk: Supplier delays or disruptions', 'Obsolescence Risk: Products become unsellable', 'Price Risk: Commodity price changes affect value', 'Quality Risk: Damage or deterioration in storage', 'Shrinkage Risk: Theft, loss, or miscounts'],
    returnMetrics: ['Inventory Turnover: COGS / Average Inventory', 'Days Inventory Outstanding: 365 / Inventory Turnover', 'Gross Margin Return on Inventory (GMROI): Gross Margin / Average Inventory', 'Fill Rate: % orders filled from stock', 'Perfect Order Rate: % orders complete, on-time, undamaged'],
    keyRatios: [
      KeyRatio(ratio: 'Inventory Turnover', formula: 'Cost of Goods Sold / Average Inventory', interpretation: 'Higher is better; indicates efficiency. Retail: 4-6x; Manufacturing: 6-12x'),
      KeyRatio(ratio: 'Days Inventory', formula: '365 / Inventory Turnover', interpretation: 'Lower is better; measures how long inventory sits'),
      KeyRatio(ratio: 'GMROI', formula: 'Gross Margin \$ / Average Inventory', interpretation: 'Return generated per \$ invested in inventory'),
      KeyRatio(ratio: 'Fill Rate', formula: 'Units Filled / Units Ordered', interpretation: 'Target typically 95-99% depending on industry'),
    ],
    breakEvenAnalysis: 'Inventory investment justified when service level benefits exceed carrying costs. Example: Increasing safety stock by \$100K improves fill rate from 95% to 98%, preventing \$150K in lost sales annually. ROI = (\$150K benefit - \$25K carrying cost) / \$100K investment = 125%.',
  ),
  accountingTreatment: AccountingTreatment(
    recognitionMeasurement: 'Inventory recorded at lower of cost or net realizable value (IFRS) / market (GAAP). Cost includes purchase price, conversion costs, and costs to bring inventory to current condition/location. Methods: FIFO, weighted average, specific identification. LIFO allowed under GAAP only.',
    journalEntries: [
      JournalEntry(debit: 'Inventory', credit: 'Accounts Payable/Cash', description: 'Record inventory purchase'),
      JournalEntry(debit: 'Cost of Goods Sold', credit: 'Inventory', description: 'Record cost of inventory sold'),
      JournalEntry(debit: 'Inventory Write-down Expense', credit: 'Inventory', description: 'Write down to net realizable value'),
      JournalEntry(debit: 'Inventory', credit: 'Manufacturing Costs', description: 'Transfer completed production to inventory'),
    ],
    financialStatementImpact: FinancialStatementImpact(
      balanceSheet: 'Inventory shown as current asset. Represents significant working capital. Inventory reserve reduces carrying value. LIFO reserve disclosed (if using LIFO).',
      incomeStatement: 'COGS affected by inventory flow assumption (FIFO vs. LIFO). Write-downs reduce gross margin. Inventory cost method affects reported profit.',
      cashFlowStatement: 'Inventory change affects Operating Activities (increase = cash outflow). Purchase payments in Operating. Write-downs non-cash but affect net income.',
    ),
    disclosureRequirements: ['Inventory by category (raw materials, WIP, finished goods)', 'Accounting policy for inventory costing', 'Amount of inventory written down', 'Inventory pledged as collateral', 'LIFO reserve (if applicable)'],
    ifrsVsGaap: 'Key difference: GAAP allows LIFO; IFRS prohibits LIFO. Both use lower of cost or NRV/market. Both allow FIFO and weighted average. IFRS requires reversal of previous write-downs if value recovers; GAAP prohibits. Disclosure requirements similar but LIFO reserve is GAAP-specific.',
  ),
  strategicConsiderations: StrategicConsiderations(
    decisionCriteria: ['Service Level Requirements: What fill rate do customers require?', 'Cost Trade-offs: Carrying cost vs. stockout cost', 'Supply Chain Design: Centralized vs. decentralized inventory', 'Product Characteristics: Shelf life, obsolescence risk, value', 'Demand Pattern: Stable vs. variable, seasonal factors', 'Supplier Reliability: Lead time variability'],
    comparisonWithAlternatives: 'vs. Just-in-Time: Lower inventory but requires reliable suppliers. vs. Vendor Managed Inventory: Transfer responsibility to suppliers. vs. Consignment: Supplier owns inventory until sale. vs. Drop Shipping: No inventory; supplier ships direct.',
    impactOnFinancialPosition: 'Higher inventory increases current assets and working capital need. Reduces cash available for other uses. Affects current ratio and quick ratio. Inventory turnover impacts Return on Assets. Efficient inventory management improves cash conversion cycle.',
    commonMistakes: ['Carrying too much safety stock \'just in case\'', 'Poor demand forecasting leading to excess or shortage', 'Not segmenting inventory by ABC analysis', 'Ignoring obsolescence risk', 'Focusing on purchase price over total cost', 'Inaccurate inventory records'],
    bestPractices: ['Implement ABC analysis for inventory segmentation', 'Use statistical safety stock calculation', 'Improve forecast accuracy through collaboration', 'Regular obsolescence review and action', 'Integrate supply chain planning systems', 'Measure and improve inventory accuracy'],
  ),
  practicalApplication: PracticalApplication(
    realWorldExample: 'Toyota Production System (Just-in-Time): Revolutionary approach minimizing inventory by producing only what\'s needed, when needed. Parts arrive at assembly line right when needed. Benefits: (1) Dramatic working capital reduction; (2) Problems immediately visible; (3) Flexibility to change. Requires: reliable suppliers, stable demand, quality at source.',
    calculationExample: 'Economic Order Quantity (EOQ): Annual demand = 10,000 units. Ordering cost = \$50/order. Annual carrying cost = \$2/unit. EOQ = √(2 × 10,000 × \$50 / \$2) = 707 units per order. Number of orders = 10,000/707 = 14/year. Total annual cost = \$1,414 carrying + \$707 ordering = \$2,121.',
    caseStudy: 'Zara Fast Fashion Inventory Model: Produces in small batches with 2-week design-to-store cycle vs. industry 6 months. Lower inventory, reduced markdowns, fresher products. Accepts higher production costs for better inventory efficiency. Result: Higher inventory turnover (4x industry average) and stronger margins despite premium manufacturing.',
    industryVariations: ['Retail: High SKU count, seasonal, markdown optimization', 'Manufacturing: Raw materials, WIP, finished goods balancing', 'Grocery: Perishability, cold chain, high turnover', 'Pharmaceutical: Expiration dates, regulatory, cold storage', 'Automotive: JIT systems, dealer inventory'],
    regulatoryConsiderations: ['Tax Implications: LIFO conformity rule in US', 'Industry Regulations: FDA for pharma/food, EPA for chemicals', 'Customs: Import/export documentation and duties', 'Financial Reporting: Inventory disclosures required', 'Insurance: Coverage requirements for stored inventory'],
  ),
);

const pricingStrategyContent = ScenarioEducationalContent(
  coreFramework: CoreFramework(
    definitionOverview: 'Pricing strategy encompasses the methods and approaches companies use to set prices for their products and services. It involves analyzing costs, competition, customer value perception, and market conditions to determine prices that maximize profitability while achieving volume and market share objectives.',
    keyCharacteristics: ['Balances profitability, volume, and market position objectives', 'Considers costs, competition, and customer value', 'Dynamic - must adapt to market conditions', 'Affects brand perception and positioning', 'Directly impacts revenue and profitability', 'Requires understanding of price elasticity'],
    typesClassifications: ['Cost-Plus Pricing: Cost + markup percentage', 'Value-Based Pricing: Price reflects customer perceived value', 'Competitive Pricing: Price relative to competitors', 'Penetration Pricing: Low initial price to gain share', 'Skimming Pricing: High initial price, lower over time', 'Dynamic Pricing: Real-time price adjustment based on demand'],
    advantages: ['Direct lever for profitability improvement', 'Signals quality and brand positioning', 'Can be adjusted quickly unlike cost structure', 'Captures customer willingness to pay', 'Enables market segmentation', 'Supports strategic objectives'],
    disadvantages: ['Wrong pricing damages volumes and share', 'Price wars erode industry profitability', 'Customer perception changes difficult to reverse', 'Complex with multiple products/segments', 'Legal constraints (price fixing, discrimination)', 'Channel conflict potential'],
    whenToUse: ['Product launch requiring positioning decision', 'Market conditions changing (costs, competition, demand)', 'Profitability improvement needed', 'Market share objectives shifting', 'New customer segments being targeted', 'Competitor pricing actions requiring response'],
    keyTerminology: [
      KeyTerminology(term: 'Price Elasticity', definition: 'Measure of demand sensitivity to price changes; % change in quantity / % change in price'),
      KeyTerminology(term: 'Contribution Margin', definition: 'Price minus variable cost; amount contributing to fixed costs and profit'),
      KeyTerminology(term: 'Price Point', definition: 'Specific price at which product is offered to market'),
      KeyTerminology(term: 'Price Discrimination', definition: 'Charging different prices to different customer segments'),
      KeyTerminology(term: 'Reference Price', definition: 'Price customers use as comparison benchmark'),
      KeyTerminology(term: 'Price Architecture', definition: 'Structure of prices across product line and segments'),
    ],
  ),
  mechanicsProcess: MechanicsProcess(
    howItWorks: 'Pricing decisions involve analyzing cost structure, understanding customer value perception, monitoring competitive prices, and setting prices to achieve business objectives. Pricing is tested, monitored, and adjusted based on market response. Different pricing strategies apply to different products, customers, and market conditions.',
    stepByStepProcess: ['1. Objective Setting: Define pricing goals (profit, share, positioning)', '2. Cost Analysis: Understand full cost structure and margins', '3. Customer Analysis: Research willingness to pay and value drivers', '4. Competitive Analysis: Monitor competitor pricing and positioning', '5. Strategy Selection: Choose pricing approach aligned with objectives', '6. Price Setting: Determine specific price points', '7. Testing: Test prices with customer research or market tests', '8. Implementation: Roll out pricing to market', '9. Monitoring: Track performance metrics', '10. Adjustment: Refine based on results'],
    keyPartiesInvolved: ['Marketing: Brand positioning and customer insights', 'Finance: Cost analysis and profitability targets', 'Sales: Market feedback and competitive intelligence', 'Product Management: Value proposition definition', 'Analytics: Pricing research and optimization', 'Legal: Regulatory compliance'],
    documentationRequired: ['Cost Analysis: Full product costing', 'Market Research: Customer value and willingness to pay', 'Competitive Analysis: Competitor pricing monitor', 'Pricing Strategy: Document rationale and approach', 'Price List: Official prices and discount policies', 'Performance Reports: Volume, revenue, margin tracking'],
    timelineMilestones: ['Month 1: Market research and analysis', 'Month 2: Strategy development', 'Month 3: Price testing and refinement', 'Month 4: Implementation planning', 'Month 5: Market launch', 'Ongoing: Monitoring and optimization'],
  ),
  financialAnalysis: FinancialAnalysis(
    valuationPricing: 'Price × Volume = Revenue. Optimal price maximizes profit = (Price - Variable Cost) × Volume - Fixed Costs. Price elasticity determines volume response: Elastic (>1) means price increase loses more volume than gains revenue. Inelastic (<1) means price increase gains revenue despite volume loss.',
    costCalculation: 'Pricing impact analysis: Current: 10,000 units × \$100 = \$1M revenue, 40% margin = \$400K profit. 5% price increase: If elasticity = 1.5, volume drops 7.5% to 9,250 units. New revenue = 9,250 × \$105 = \$971K. New margin = 42% (higher price, same cost) = \$408K profit. Price increase improves profit despite volume loss.',
    riskFactors: ['Elasticity Uncertainty: Customer response may differ from expected', 'Competitive Response: Competitors may match or undercut', 'Customer Attrition: Price increases may lose customers', 'Brand Damage: Wrong pricing harms brand perception', 'Channel Conflict: Different pricing to different channels', 'Economic Sensitivity: Demand patterns change in downturn'],
    returnMetrics: ['Gross Margin: (Price - COGS) / Price', 'Contribution Margin: (Price - Variable Cost) / Price', 'Price Realization: Actual price / List price', 'Revenue per Unit: Total revenue / Units sold', 'Price Premium: Company price / Competitor price - 1'],
    keyRatios: [
      KeyRatio(ratio: 'Gross Margin %', formula: '(Revenue - COGS) / Revenue', interpretation: 'Higher indicates pricing power; varies by industry'),
      KeyRatio(ratio: 'Price Elasticity', formula: '% Change in Quantity / % Change in Price', interpretation: '<1 inelastic (can raise price); >1 elastic (price sensitive)'),
      KeyRatio(ratio: 'Market Price Index', formula: 'Company Price / Market Average Price', interpretation: '>1 indicates premium positioning'),
      KeyRatio(ratio: 'Discount Depth', formula: '(List Price - Actual Price) / List Price', interpretation: 'Lower is better; measures pricing discipline'),
    ],
    breakEvenAnalysis: 'For price changes: Break-even volume change = -Price Change % / (Contribution Margin % + Price Change %). Example: 10% price increase with 40% contribution margin: Break-even = -10% / (40% + 10%) = -20%. Volume can drop 20% before profit declines. If expected drop is only 5%, price increase is profitable.',
  ),
  accountingTreatment: AccountingTreatment(
    recognitionMeasurement: 'Revenue recognized when control transfers to customer at transaction price. Discounts and allowances reduce revenue. Volume rebates estimated and recorded. Variable consideration requires estimation under IFRS 15/ASC 606.',
    journalEntries: [
      JournalEntry(debit: 'Accounts Receivable', credit: 'Revenue', description: 'Record sale at transaction price'),
      JournalEntry(debit: 'Sales Discounts', credit: 'Accounts Receivable', description: 'Record trade/cash discounts'),
      JournalEntry(debit: 'Revenue (Contra)', credit: 'Rebate Accrual', description: 'Accrue expected volume rebates'),
    ],
    financialStatementImpact: FinancialStatementImpact(
      balanceSheet: 'Accounts receivable at net amount. Rebate accruals as liability. Deferred revenue if payment before delivery.',
      incomeStatement: 'Revenue net of discounts, rebates, returns. Gross margin directly affected by pricing. Volume and mix affect total revenue.',
      cashFlowStatement: 'Cash collections may differ from revenue recognition. Timing of rebate payments affects cash.',
    ),
    disclosureRequirements: ['Revenue recognition policy', 'Significant judgments in variable consideration', 'Disaggregation of revenue by product/segment/geography', 'Contract assets and liabilities', 'Performance obligations and timing'],
    ifrsVsGaap: 'IFRS 15 and ASC 606 largely converged on revenue recognition. Both require transaction price allocation, variable consideration estimation, and constraint application. Minor differences in specific application guidance. Both require extensive disclosure.',
  ),
  strategicConsiderations: StrategicConsiderations(
    decisionCriteria: ['Value Delivered: Does price reflect customer value received?', 'Competitive Position: How does price compare to alternatives?', 'Cost Recovery: Does price cover costs and required return?', 'Volume Implications: What volume is expected at price?', 'Strategic Fit: Does price support brand and strategy?', 'Market Acceptance: Will customers accept this price?'],
    comparisonWithAlternatives: 'Pricing levers: (1) List price changes; (2) Discount policy changes; (3) Bundling/unbundling; (4) Payment terms; (5) Added value services. Each affects customer perception differently. Often combination of approaches most effective.',
    impactOnFinancialPosition: 'Pricing directly drives revenue and margin. Strong pricing power creates competitive advantage. Ability to raise prices indicates customer value. Price leadership in market signals strength. Pricing discipline protects profitability.',
    commonMistakes: ['Cost-plus pricing ignoring customer value', 'Matching every competitor price cut', 'Inconsistent pricing across channels', 'Over-reliance on discounting to drive volume', 'Not segmenting customers by value/willingness to pay', 'Ignoring price elasticity in decisions'],
    bestPractices: ['Base pricing on customer value, not just cost', 'Segment customers and price accordingly', 'Maintain pricing discipline and discount governance', 'Monitor competitive pricing systematically', 'Test price changes before full implementation', 'Train sales team on value-based selling'],
  ),
  practicalApplication: PracticalApplication(
    realWorldExample: 'Apple iPhone Pricing: Premium pricing strategy maintaining \$999+ flagship prices while competitors race to bottom. Supports: (1) Brand perception of quality/innovation; (2) Higher margins enabling R&D investment; (3) Customer willingness to pay for ecosystem. Despite high prices, maintains dominant profit share in smartphone industry.',
    calculationExample: 'Optimal pricing: Current price \$50, volume 100,000, variable cost \$30. Contribution = \$20 × 100,000 = \$2M. Research shows elasticity = 1.2. Test \$55 price (+10%): Volume impact = -10% × 1.2 = -12% = 88,000 units. New contribution = \$25 × 88,000 = \$2.2M. Price increase improves profit by \$200K despite volume loss.',
    caseStudy: 'Netflix Price Increases: Multiple price increases since 2011 (\$7.99 to \$15.49+ standard). Each increase faced customer backlash but retention remained high due to: (1) Unique content value; (2) Low price relative to cable; (3) Habit/switching costs. Demonstrates pricing power from differentiation and customer lock-in.',
    industryVariations: ['SaaS: Subscription pricing, tiered plans, usage-based options', 'Retail: Promotional pricing, markdown optimization, price matching', 'Airlines: Dynamic pricing, yield management, ancillary pricing', 'Pharmaceuticals: Value-based pricing, payer negotiations', 'Luxury: Premium pricing as brand differentiator'],
    regulatoryConsiderations: ['Price Fixing: Illegal coordination of prices with competitors', 'Price Discrimination: Robinson-Patman Act restrictions (B2B)', 'Predatory Pricing: Below-cost pricing to eliminate competition', 'Price Gouging: Emergency/disaster pricing restrictions', 'Deceptive Pricing: Truth in advertising requirements', 'International: Transfer pricing for tax purposes'],
  ),
);

const technologyInvestmentContent = ScenarioEducationalContent(
  coreFramework: CoreFramework(
    definitionOverview: 'Technology investment refers to capital allocation for acquiring, developing, or upgrading information technology infrastructure, software systems, and digital capabilities. This includes enterprise resource planning (ERP) systems, cybersecurity infrastructure, cloud computing platforms, data analytics tools, and automation technologies. Technology investments are increasingly critical for operational efficiency, competitive advantage, and digital transformation.',
    keyCharacteristics: ['High initial capital outlay with ongoing maintenance costs', 'Rapid obsolescence requiring regular upgrade cycles (3-7 years)', 'Network effects create value across the organization', 'Integration complexity with existing systems', 'Scalability enables growth without proportional cost increases', 'Data and security requirements drive ongoing investment'],
    typesClassifications: ['Infrastructure: Servers, networks, data centers, cloud services', 'Enterprise Applications: ERP, CRM, HCM, SCM systems', 'Productivity Tools: Office suites, collaboration platforms', 'Analytics & BI: Data warehouses, reporting tools, AI/ML platforms', 'Security: Firewalls, encryption, identity management, SIEM', 'Industry-Specific: CAD, laboratory systems, trading platforms'],
    advantages: ['Operational efficiency through automation and process improvement', 'Better decision-making with real-time data and analytics', 'Enhanced customer experience and engagement capabilities', 'Scalability without proportional headcount increases', 'Competitive advantage through digital capabilities', 'Regulatory compliance through better controls and audit trails'],
    disadvantages: ['High upfront costs and uncertain ROI timelines', 'Implementation risk and organizational disruption', 'Ongoing maintenance, licensing, and support costs', 'Technology obsolescence and vendor lock-in risks', 'Cybersecurity vulnerabilities and data privacy concerns', 'Change management challenges and training requirements'],
    whenToUse: ['Current systems cannot support business growth or requirements', 'Significant operational inefficiencies exist in manual processes', 'Competitive pressure requires digital transformation', 'Regulatory requirements mandate system upgrades', 'Customer expectations demand enhanced digital experiences', 'Data-driven decision making is strategic priority'],
    keyTerminology: [
      KeyTerminology(term: 'Total Cost of Ownership (TCO)', definition: 'Complete cost including acquisition, implementation, maintenance, training, and disposal over system lifecycle'),
      KeyTerminology(term: 'Cloud Computing', definition: 'On-demand delivery of IT resources via internet with pay-as-you-go pricing (IaaS, PaaS, SaaS)'),
      KeyTerminology(term: 'ERP System', definition: 'Enterprise Resource Planning - integrated software managing core business processes'),
      KeyTerminology(term: 'Digital Transformation', definition: 'Fundamental change in how organization uses technology to deliver value'),
      KeyTerminology(term: 'Legacy System', definition: 'Older technology still in use, often with integration or maintenance challenges'),
      KeyTerminology(term: 'Technical Debt', definition: 'Future cost of rework caused by choosing quick solutions over better approaches'),
    ],
  ),
  mechanicsProcess: MechanicsProcess(
    howItWorks: 'Technology investment follows a structured process: needs assessment identifies gaps and opportunities, vendor evaluation selects solutions, business case justifies investment, implementation deploys technology, and adoption ensures value realization. Modern approaches favor agile methodologies with iterative deployment over big-bang implementations.',
    stepByStepProcess: ['Step 1: Conduct needs assessment and current state analysis', 'Step 2: Define requirements and develop technology roadmap', 'Step 3: Evaluate build vs. buy vs. cloud options', 'Step 4: Select vendors and negotiate contracts', 'Step 5: Develop business case with ROI analysis', 'Step 6: Secure funding and executive sponsorship', 'Step 7: Plan implementation with phased rollout approach', 'Step 8: Execute implementation with change management', 'Step 9: Train users and support adoption', 'Step 10: Monitor performance and realize benefits'],
    keyPartiesInvolved: ['CIO/CTO: Technology strategy and architecture decisions', 'Business Sponsors: Define requirements and champion adoption', 'IT Project Managers: Lead implementation execution', 'System Integrators: Configure and deploy solutions', 'Vendors: Provide software, hardware, and support', 'End Users: Adopt and provide feedback on systems'],
    documentationRequired: ['Business Requirements Document (BRD)', 'Technical Architecture Document', 'Request for Proposal (RFP) for vendor selection', 'Vendor contracts and Service Level Agreements (SLAs)', 'Project plan with timeline and milestones', 'Change management and training plans'],
    timelineMilestones: ['Month 1-2: Needs assessment and requirements gathering', 'Month 2-3: Vendor evaluation and selection', 'Month 3-4: Business case and funding approval', 'Month 4-6: Contract negotiation and project planning', 'Month 6-12: Implementation and testing', 'Month 12-18: Rollout and adoption optimization'],
  ),
  financialAnalysis: FinancialAnalysis(
    valuationPricing: 'Technology investments are evaluated using ROI, NPV, and payback period. Benefits include cost savings (labor, efficiency), revenue enablement, and risk reduction. Cloud solutions shift from CapEx to OpEx with subscription pricing. Enterprise software typically costs \$100-500+ per user annually, with implementation costs 1-3x software cost.',
    costCalculation: 'TCO includes: Software licenses/subscriptions (20-30% of TCO), implementation services (25-35%), hardware/infrastructure (15-25%), training and change management (10-15%), and ongoing support/maintenance (15-20%). Example: \$1M ERP implementation may have \$3-4M 5-year TCO.',
    riskFactors: ['Implementation failure or significant delays and cost overruns', 'Low user adoption reducing expected benefits', 'Integration challenges with existing systems', 'Vendor viability and support continuity', 'Technology obsolescence before ROI realized', 'Security breaches and data loss'],
    returnMetrics: ['Return on Investment (ROI): (Benefits - Costs) / Costs', 'Net Present Value (NPV): PV of benefits minus PV of costs', 'Internal Rate of Return (IRR): Discount rate where NPV = 0', 'Payback Period: Time to recover initial investment', 'Productivity Improvement: Output per employee or transaction'],
    keyRatios: [
      KeyRatio(ratio: 'IT Spending / Revenue', formula: 'Annual IT Budget / Annual Revenue', interpretation: 'Industry benchmark 3-7% depending on sector; higher for tech-dependent industries'),
      KeyRatio(ratio: 'Project Cost Variance', formula: '(Actual - Budgeted) / Budgeted', interpretation: 'Measures implementation cost control; >20% indicates problems'),
      KeyRatio(ratio: 'Adoption Rate', formula: 'Active Users / Licensed Users', interpretation: 'Target >80%; lower indicates wasted investment'),
      KeyRatio(ratio: 'System Availability', formula: 'Uptime / Total Time', interpretation: 'Target 99.9%+; downtime has significant business impact'),
    ],
    breakEvenAnalysis: 'Break-even occurs when cumulative benefits equal TCO. Example: \$2M investment generating \$600K annual savings breaks even in 3.3 years. Consider both hard savings (headcount, infrastructure) and soft benefits (productivity, quality).',
  ),
  accountingTreatment: AccountingTreatment(
    recognitionMeasurement: 'Purchased software is capitalized as intangible asset at cost plus implementation costs directly attributable to bringing asset to use. Cloud subscriptions are expensed as incurred. Internally developed software is capitalized during application development stage under ASC 350-40.',
    journalEntries: [
      JournalEntry(debit: 'Software Asset (Intangible)', credit: 'Cash/Accounts Payable', description: 'Record purchased software license'),
      JournalEntry(debit: 'Software Asset', credit: 'Cash', description: 'Capitalize implementation costs'),
      JournalEntry(debit: 'Amortization Expense', credit: 'Accumulated Amortization', description: 'Periodic amortization (typically 3-7 years)'),
      JournalEntry(debit: 'Cloud Subscription Expense', credit: 'Cash/Prepaid', description: 'Record SaaS subscription costs'),
      JournalEntry(debit: 'Prepaid Expenses', credit: 'Cash', description: 'Record multi-year subscription prepayments'),
    ],
    financialStatementImpact: FinancialStatementImpact(
      balanceSheet: 'Capitalized software increases intangible assets. Cloud subscriptions may create prepaid assets for advance payments. Implementation reduces cash. Hardware increases PP&E.',
      incomeStatement: 'Capitalized software amortized over useful life (3-7 years). Cloud subscriptions expensed immediately. Implementation costs capitalized or expensed depending on nature. Training typically expensed.',
      cashFlowStatement: 'Capitalized software in Investing Activities. Cloud subscriptions and maintenance in Operating Activities. Lease payments may split between operating and financing.',
    ),
    disclosureRequirements: ['Accounting policy for software capitalization', 'Amortization method and useful lives', 'Impairment testing and any write-downs', 'Significant software commitments and obligations', 'Cloud computing arrangements classification'],
    ifrsVsGaap: 'Both frameworks allow capitalization of directly attributable implementation costs. Key differences: (1) IFRS allows revaluation of intangibles in some cases; US GAAP requires cost model. (2) Cloud computing hosting arrangements have evolving guidance under both frameworks. (3) Research vs. development phase distinction more defined under IFRS.',
  ),
  strategicConsiderations: StrategicConsiderations(
    decisionCriteria: ['Strategic alignment with business objectives and digital strategy', 'Total cost of ownership over 5-7 year horizon', 'Integration capabilities with existing technology ecosystem', 'Vendor stability, market position, and support quality', 'Scalability to support growth and changing needs', 'Security and compliance capabilities'],
    comparisonWithAlternatives: 'Build vs. Buy vs. Cloud: Building provides customization but requires expertise and ongoing maintenance. Buying provides proven solutions with faster implementation. Cloud offers flexibility and lower upfront costs but ongoing subscription fees and less control. Hybrid approaches common for complex environments.',
    impactOnFinancialPosition: 'Large technology investments significantly impact capital allocation. Successful implementations improve operating efficiency and margins. Failed projects result in write-offs and disruption. Cloud shifts spending from CapEx to OpEx, improving asset efficiency ratios but creating ongoing obligations.',
    commonMistakes: ['Underestimating implementation complexity and timeline', 'Insufficient change management and user training', 'Selecting technology without adequate requirements definition', 'Ignoring total cost of ownership including ongoing costs', 'Over-customization creating upgrade and support challenges', 'Inadequate executive sponsorship and governance'],
    bestPractices: ['Develop comprehensive requirements before vendor selection', 'Use phased implementation to reduce risk and learn', 'Invest adequately in change management (15-20% of budget)', 'Establish clear governance and decision-making structures', 'Plan for integration with existing systems from start', 'Define success metrics and measure benefits realization'],
  ),
  practicalApplication: PracticalApplication(
    realWorldExample: 'Nike\'s Digital Transformation (2017-2020): Invested \$1B+ in technology including ERP consolidation, direct-to-consumer e-commerce, mobile apps, and supply chain systems. Result: Digital revenue grew from 15% to 35% of total, improved inventory management, and enhanced customer engagement. Technology investment drove strategic shift from wholesale to DTC.',
    calculationExample: 'ERP Investment Analysis: \$2M software, \$3M implementation, \$500K annual maintenance = \$5.5M 5-year TCO. Benefits: \$1.5M annual labor savings, \$500K inventory reduction, \$300K error reduction = \$2.3M annual benefit. NPV at 10%: \$2.3M × 3.79 - \$5M initial = \$3.7M. Payback: 2.4 years.',
    caseStudy: 'Hershey\'s ERP Implementation (1999): Attempted simultaneous deployment of SAP, CRM, and supply chain systems before Halloween peak season. System problems caused \$150M revenue loss and 19% stock decline. Lessons: (1) Avoid big-bang implementations, use phased approach; (2) Don\'t deploy during peak business periods; (3) Ensure adequate testing and user training; (4) Maintain fallback capabilities.',
    industryVariations: ['Financial Services: Heavy investment in trading, risk, and regulatory systems', 'Healthcare: EHR systems, telemedicine, diagnostic AI', 'Manufacturing: IoT, automation, supply chain optimization', 'Retail: E-commerce, POS, inventory, customer analytics', 'Professional Services: Collaboration, project management, billing systems'],
    regulatoryConsiderations: ['Data Privacy: GDPR, CCPA, industry-specific requirements', 'Financial Systems: SOX compliance for public companies', 'Healthcare: HIPAA for protected health information', 'Industry Standards: PCI DSS for payment data, ISO 27001', 'Data Residency: Requirements for data location by jurisdiction'],
  ),
);

const portfolioInvestmentContent = ScenarioEducationalContent(
  coreFramework: CoreFramework(
    definitionOverview: 'Portfolio investment involves purchasing financial securities (stocks, bonds) of other companies for investment purposes rather than operational control. Unlike strategic acquisitions, portfolio investments are held for financial returns (dividends, interest, capital appreciation) without significant influence over the investee. Investments under 20% ownership are typically classified as portfolio investments.',
    keyCharacteristics: ['Ownership stake typically under 20% without significant influence', 'Primary purpose is financial return, not operational control', 'Marketable securities provide liquidity through trading', 'Diversification across multiple securities reduces risk', 'Professional management often through treasury or investment function', 'Mark-to-market accounting creates earnings volatility'],
    typesClassifications: ['Trading Securities: Held for short-term price appreciation, frequent buying/selling', 'Available-for-Sale (AFS): Neither trading nor held-to-maturity, flexibility retained', 'Held-to-Maturity (HTM): Debt securities with intent and ability to hold until maturity', 'Equity Securities: Common and preferred stock investments', 'Debt Securities: Corporate bonds, government securities, commercial paper', 'Alternative Investments: Private equity funds, hedge funds, real assets'],
    advantages: ['Diversification of corporate investment portfolio', 'Liquidity from marketable securities for future needs', 'Potential returns higher than cash or money market', 'Strategic optionality for future acquisitions', 'Hedging capabilities for business risks', 'Tax advantages in certain jurisdictions or structures'],
    disadvantages: ['Market risk and potential for capital losses', 'Earnings volatility from fair value changes', 'Opportunity cost versus operating investments', 'Management attention and expertise requirements', 'Concentration risk if portfolio not diversified', 'Liquidity risk in stressed market conditions'],
    whenToUse: ['Excess cash beyond operating and strategic investment needs', 'Building stake before potential acquisition', 'Diversifying business risk across industries', 'Generating returns on pension or insurance reserves', 'Creating strategic relationships without full acquisition', 'Managing currency or commodity exposures'],
    keyTerminology: [
      KeyTerminology(term: 'Fair Value', definition: 'Price received to sell asset in orderly transaction between market participants'),
      KeyTerminology(term: 'Unrealized Gain/Loss', definition: 'Change in fair value of securities not yet sold, may affect OCI or earnings'),
      KeyTerminology(term: 'Other Comprehensive Income (OCI)', definition: 'Equity component for gains/losses not in net income, includes AFS securities'),
      KeyTerminology(term: 'Impairment', definition: 'Recognition of loss when fair value declines below cost and is other-than-temporary'),
      KeyTerminology(term: 'Dividend Income', definition: 'Cash payments received from equity investments, recognized when declared'),
      KeyTerminology(term: 'Interest Income', definition: 'Earnings from debt securities based on coupon and amortization of discount/premium'),
    ],
  ),
  mechanicsProcess: MechanicsProcess(
    howItWorks: 'Corporate portfolio investment typically managed by treasury function following investment policy approved by board. Policy defines risk tolerance, asset allocation, credit quality requirements, and liquidity constraints. Investments executed through brokers or asset managers. Performance monitored against benchmarks with regular reporting to management and board.',
    stepByStepProcess: ['Step 1: Develop investment policy statement (IPS) with board approval', 'Step 2: Determine investable cash considering operating needs', 'Step 3: Define asset allocation based on risk/return objectives', 'Step 4: Select investment managers or direct investment approach', 'Step 5: Execute trades through authorized brokers', 'Step 6: Monitor positions and market conditions', 'Step 7: Rebalance portfolio per policy parameters', 'Step 8: Report performance and compliance to management', 'Step 9: Record accounting entries and disclosures'],
    keyPartiesInvolved: ['Board of Directors: Approve investment policy and risk parameters', 'Treasury: Execute policy, manage portfolio, ensure compliance', 'CFO: Oversee treasury function and risk management', 'Investment Managers: Discretionary management if outsourced', 'Custodian Bank: Hold securities, process transactions, provide reporting', 'External Auditors: Verify fair values and accounting treatment'],
    documentationRequired: ['Investment Policy Statement approved by board', 'Asset allocation and rebalancing guidelines', 'Trade confirmations and settlement documents', 'Custodial statements and reconciliations', 'Fair value documentation and pricing sources', 'Performance reports and benchmark comparisons'],
    timelineMilestones: ['Initial: Develop and approve investment policy', 'Quarterly: Review portfolio performance and rebalance', 'Annually: Review and update investment policy', 'Ongoing: Monitor credit quality and market developments', 'As needed: Execute trades per policy parameters'],
  ),
  financialAnalysis: FinancialAnalysis(
    valuationPricing: 'Securities valued at fair value using market prices (Level 1), observable inputs (Level 2), or unobservable inputs (Level 3). Quoted prices in active markets preferred. For less liquid securities, valuation techniques include discounted cash flow, comparable transactions, and option pricing models.',
    costCalculation: 'Investment costs include: Purchase price, brokerage commissions, investment management fees (0.1-2% annually), custodian fees, and internal management costs. For actively managed portfolios, total costs typically 0.5-1.5% of assets annually.',
    riskFactors: ['Market Risk: Systematic risk affecting all securities', 'Credit Risk: Default or downgrade of debt issuers', 'Liquidity Risk: Inability to sell at fair prices', 'Concentration Risk: Overexposure to single issuer or sector', 'Currency Risk: For foreign currency denominated investments', 'Interest Rate Risk: Bond price sensitivity to rate changes'],
    returnMetrics: ['Total Return: Capital appreciation plus income yield', 'Sharpe Ratio: Risk-adjusted return vs. risk-free rate', 'Yield: Income (dividends/interest) as percentage of value', 'Alpha: Excess return vs. benchmark after risk adjustment', 'Tracking Error: Volatility of returns vs. benchmark'],
    keyRatios: [
      KeyRatio(ratio: 'Current Yield', formula: 'Annual Income / Current Price', interpretation: 'Running income return; compare to cost of capital'),
      KeyRatio(ratio: 'Price/Earnings (P/E)', formula: 'Stock Price / Earnings Per Share', interpretation: 'Valuation multiple; higher indicates growth expectations'),
      KeyRatio(ratio: 'Credit Spread', formula: 'Corporate Yield - Treasury Yield', interpretation: 'Risk premium; wider spread indicates higher risk'),
      KeyRatio(ratio: 'Duration', formula: 'Weighted average time to receive cash flows', interpretation: 'Interest rate sensitivity; longer duration = more risk'),
    ],
    breakEvenAnalysis: 'Investment break-even considers holding period return vs. alternative uses of cash. If corporate cost of capital is 10%, investments should target returns exceeding this hurdle rate. Factor in tax implications, as investment income may have different tax treatment than operating income.',
  ),
  accountingTreatment: AccountingTreatment(
    recognitionMeasurement: 'Initial recognition at fair value plus transaction costs (except trading securities). Subsequent measurement depends on classification: Trading securities at fair value through profit/loss (FVTPL); AFS at fair value through OCI (under old guidance) or FVTPL (under ASU 2016-01 for equity); HTM at amortized cost.',
    journalEntries: [
      JournalEntry(debit: 'Investment in Securities', credit: 'Cash', description: 'Initial purchase of securities'),
      JournalEntry(debit: 'Investment in Securities', credit: 'Unrealized Gain (P&L or OCI)', description: 'Fair value increase'),
      JournalEntry(debit: 'Unrealized Loss (P&L or OCI)', credit: 'Investment in Securities', description: 'Fair value decrease'),
      JournalEntry(debit: 'Cash', credit: 'Dividend Income', description: 'Receive dividend on equity investment'),
      JournalEntry(debit: 'Cash', credit: 'Interest Income', description: 'Receive interest on debt investment'),
      JournalEntry(debit: 'Cash', credit: 'Investment in Securities / Gain on Sale', description: 'Sale of securities at gain'),
    ],
    financialStatementImpact: FinancialStatementImpact(
      balanceSheet: 'Investments classified as current (trading, short-term) or non-current (strategic holdings). Fair value changes affect equity through OCI or retained earnings depending on classification. HTM shown at amortized cost.',
      incomeStatement: 'Trading securities: fair value changes in earnings. Equity securities (post ASU 2016-01): fair value changes in earnings. Dividends and interest recognized as income. Realized gains/losses on sale in earnings.',
      cashFlowStatement: 'Purchase and sale of trading securities typically in Operating Activities. Available-for-sale and other investments in Investing Activities. Dividends and interest received in Operating Activities.',
    ),
    disclosureRequirements: ['Fair value hierarchy (Level 1, 2, 3) for all investments', 'Unrealized gains and losses by category', 'Maturity analysis for debt securities', 'Credit quality information for debt holdings', 'Impairment methodology and amounts', 'Concentration of credit risk'],
    ifrsVsGaap: 'IFRS 9 uses business model approach: FVTPL, FVOCI, or amortized cost. US GAAP requires equity securities at FVTPL (ASU 2016-01) eliminating AFS for equities. Key differences: (1) OCI recycling eliminated for equities under US GAAP; (2) Impairment models differ (expected loss under IFRS, credit loss under GAAP); (3) IFRS allows more OCI options for debt.',
  ),
  strategicConsiderations: StrategicConsiderations(
    decisionCriteria: ['Expected returns relative to corporate cost of capital', 'Liquidity needs and investment time horizon', 'Risk tolerance and earnings volatility acceptance', 'Strategic value beyond financial returns', 'Tax efficiency of investment structure', 'Management expertise and oversight capacity'],
    comparisonWithAlternatives: 'vs. Cash: Higher returns but market risk and volatility. vs. Operating Investment: Portfolio investments provide liquidity but typically lower strategic value. vs. Acquisitions: Less control but more liquidity and diversification. vs. Share Buybacks: Investments retain capital in company vs. returning to shareholders.',
    impactOnFinancialPosition: 'Portfolio investments affect balance sheet (asset values), income statement (investment income, fair value changes), and financial ratios. Mark-to-market creates earnings volatility. Large unrealized losses may require disclosure or trigger covenants. Successful investing improves returns on excess capital.',
    commonMistakes: ['Exceeding risk tolerance with inappropriate investments', 'Inadequate diversification creating concentration risk', 'Chasing yield without understanding credit risk', 'Holding illiquid investments without adequate reserves', 'Insufficient monitoring of credit quality deterioration', 'Poor accounting classification causing unintended volatility'],
    bestPractices: ['Establish clear investment policy with board oversight', 'Maintain diversification across issuers and sectors', 'Match investment maturity to liquidity needs', 'Use appropriate benchmarks for performance evaluation', 'Conduct regular credit review of holdings', 'Ensure adequate internal controls and segregation'],
  ),
  practicalApplication: PracticalApplication(
    realWorldExample: 'Berkshire Hathaway Investment Portfolio: Warren Buffett manages \$300B+ equity portfolio with concentrated positions in Apple (40%+), Bank of America, Coca-Cola, and others. Strategy: Long-term holdings in businesses with durable competitive advantages, purchased at reasonable valuations. Demonstrates portfolio investment can create enormous value when aligned with investment expertise.',
    calculationExample: 'Corporate Bond Investment: Purchase \$10M corporate bond at 98 (2% discount), 5% coupon, 10-year maturity. Annual interest: \$500K. Discount amortization: \$20K/year. Total annual income: \$520K. Yield to maturity: approximately 5.3%. If sold after 3 years at 101: Gain = \$10.1M - \$9.86M book value = \$240K.',
    caseStudy: 'General Electric Capital (2008-2015): GE Capital\'s large investment portfolio including mortgage-backed securities suffered massive losses in 2008 financial crisis, requiring \$139B government guarantee. Led to multi-year restructuring and eventual sale of GE Capital businesses. Lessons: (1) Concentration in credit-sensitive investments creates systemic risk; (2) Leverage amplifies losses; (3) Investment activities should align with core competencies.',
    industryVariations: ['Insurance Companies: Large portfolios to match policy liabilities', 'Banks: Securities portfolios for liquidity and yield management', 'Technology: Often hold large cash positions in short-term investments', 'Pension Funds: Diversified portfolios matching long-term obligations', 'Manufacturing: Typically smaller portfolios focused on liquidity'],
    regulatoryConsiderations: ['Investment Company Act: May apply if securities >40% of assets', 'Banking Regulations: Capital requirements for securities holdings', 'Insurance Regulations: Investment restrictions and capital charges', 'Tax Regulations: Dividend treatment, capital gains timing, international', 'Securities Laws: Insider trading restrictions, beneficial ownership reporting'],
  ),
);

const jointVentureContent = ScenarioEducationalContent(
  coreFramework: CoreFramework(
    definitionOverview: 'A joint venture (JV) is a business arrangement where two or more parties agree to pool resources for a specific project or business activity while maintaining their separate identities. Unlike mergers, JVs create a new entity or contractual arrangement with shared ownership, control, risks, and returns. JVs enable access to markets, technologies, or capabilities that would be difficult or costly to develop independently.',
    keyCharacteristics: ['Shared ownership and control between partners (typically 50/50 or strategic splits)', 'Separate legal entity or contractual arrangement', 'Defined scope, duration, and governance structure', 'Shared risks, investments, and returns per agreement', 'Partners maintain independent operations outside JV scope', 'Complex governance requiring consensus on major decisions'],
    typesClassifications: ['Equity Joint Venture: Partners form new company with shared ownership', 'Contractual/Cooperative JV: Agreement without separate entity creation', 'Consortium: Multiple parties for large projects (infrastructure, defense)', 'Strategic Alliance: Looser collaboration without equity investment', 'Production JV: Share manufacturing facilities or capacity', 'Distribution JV: Access partner\'s sales channels or markets'],
    advantages: ['Risk sharing on large or uncertain investments', 'Access to partner\'s markets, technology, or expertise', 'Lower capital requirements than full acquisition', 'Faster market entry than organic development', 'Local partner knowledge for foreign market entry', 'Regulatory advantages in restricted industries'],
    disadvantages: ['Shared control limits decision-making flexibility', 'Potential conflicts between partner objectives', 'Complex governance and management challenges', 'Technology or knowledge transfer to potential competitor', 'Profit sharing reduces individual partner returns', 'Exit and dissolution can be difficult and costly'],
    whenToUse: ['Entering new geographic markets (especially with local partner requirements)', 'Developing new technology requiring complementary capabilities', 'Large projects requiring shared investment and risk', 'Industries with regulatory requirements for local ownership', 'Combining complementary capabilities (technology + distribution)', 'Testing strategic fit before full acquisition'],
    keyTerminology: [
      KeyTerminology(term: 'Joint Control', definition: 'Contractually agreed sharing of control requiring unanimous consent on relevant activities'),
      KeyTerminology(term: 'Equity Method', definition: 'Accounting method recognizing investor\'s share of JV earnings in income statement'),
      KeyTerminology(term: 'JV Agreement', definition: 'Contract defining ownership, governance, contributions, and exit provisions'),
      KeyTerminology(term: 'Deadlock', definition: 'Situation where partners cannot agree on decisions, triggering resolution mechanisms'),
      KeyTerminology(term: 'Put/Call Options', definition: 'Rights to sell or buy partner\'s interest at predetermined terms'),
      KeyTerminology(term: 'Non-compete Clause', definition: 'Restriction on partners from competing with JV in defined scope'),
    ],
  ),
  mechanicsProcess: MechanicsProcess(
    howItWorks: 'JV formation begins with partner identification and strategic fit assessment. Partners negotiate terms including ownership, contributions, governance, and exit rights. Due diligence evaluates partner capabilities and risks. Legal documentation establishes structure, and regulatory approvals obtained. JV launches with defined governance and management structure.',
    stepByStepProcess: ['Step 1: Identify strategic need and potential partners', 'Step 2: Conduct preliminary discussions and assess fit', 'Step 3: Sign confidentiality and exclusivity agreements', 'Step 4: Conduct due diligence on partner and market', 'Step 5: Negotiate key terms (ownership, contributions, governance)', 'Step 6: Draft and finalize JV agreement and related documents', 'Step 7: Obtain regulatory and internal approvals', 'Step 8: Close transaction and fund initial contributions', 'Step 9: Establish governance structure and management team', 'Step 10: Launch operations and monitor performance'],
    keyPartiesInvolved: ['JV Partners: Contribute capital, technology, or capabilities', 'JV Board: Governs major decisions per agreement', 'JV Management: Day-to-day operations (often seconded from partners)', 'Legal Counsel: Structure and document the arrangement', 'Financial Advisors: Valuation and deal structuring', 'Regulatory Authorities: Approve formation in regulated industries'],
    documentationRequired: ['Joint Venture Agreement: Master document governing relationship', 'Shareholders Agreement: Rights and obligations of equity holders', 'Operating/Management Agreement: Day-to-day operational matters', 'Technology License Agreements: IP contributed to JV', 'Service Level Agreements: Support provided by partners', 'Exit and Dissolution Provisions: Buyout, deadlock resolution'],
    timelineMilestones: ['Month 1-2: Partner identification and preliminary discussions', 'Month 2-3: Due diligence and term sheet negotiation', 'Month 3-5: Detailed negotiations and documentation', 'Month 5-6: Regulatory approvals and closing conditions', 'Month 6: Close transaction and fund contributions', 'Month 6+: Launch operations'],
  ),
  financialAnalysis: FinancialAnalysis(
    valuationPricing: 'JV valuation considers projected cash flows, partner contributions, and comparable transactions. Partner contributions valued at fair value (cash, assets, IP). Ownership typically reflects relative contribution values. Success fees or earnouts may link ownership to performance milestones.',
    costCalculation: 'JV costs include: Initial capital contribution, transaction costs (legal, advisory: 2-5% of deal value), ongoing funding commitments, management resources seconded to JV, and exit costs if JV is dissolved. Partners should model returns under various scenarios.',
    riskFactors: ['Partner conflict and governance deadlocks', 'Unequal commitment or resource contribution', 'Market or technology changes affecting JV viability', 'Regulatory changes impacting JV operations', 'Cultural misalignment between partner organizations', 'Competitive dynamics if partners are also competitors'],
    returnMetrics: ['Return on Investment: JV returns vs. capital contributed', 'IRR on JV Investment: Time-weighted return on contributions', 'Equity Method Income: Share of JV profits in parent\'s P&L', 'Strategic Value: Non-financial benefits (market access, learning)', 'Option Value: Potential to acquire remaining stake'],
    keyRatios: [
      KeyRatio(ratio: 'Investment/Total Assets', formula: 'JV Investment / Investor Total Assets', interpretation: 'Materiality of JV to investor; guides governance attention'),
      KeyRatio(ratio: 'JV Revenue/Total Revenue', formula: 'Investor\'s Share of JV Revenue / Investor Revenue', interpretation: 'Revenue contribution from JV'),
      KeyRatio(ratio: 'ROI on JV', formula: 'Cumulative Distributions / Cumulative Contributions', interpretation: 'Cash return on JV investment'),
      KeyRatio(ratio: 'Leverage in JV', formula: 'JV Debt / JV Equity', interpretation: 'Financial risk in JV structure'),
    ],
    breakEvenAnalysis: 'JV break-even considers both financial returns (dividends, capital appreciation) and strategic benefits (market access, technology). Financial break-even: when cumulative distributions equal contributions. Strategic break-even: when JV achieves intended strategic objectives.',
  ),
  accountingTreatment: AccountingTreatment(
    recognitionMeasurement: 'Joint ventures where investor has joint control are accounted for using equity method under both US GAAP and IFRS. Initial recognition at cost. Subsequently adjusted for investor\'s share of JV profits/losses, dividends received, and impairment if applicable.',
    journalEntries: [
      JournalEntry(debit: 'Investment in Joint Venture', credit: 'Cash', description: 'Initial capital contribution to JV'),
      JournalEntry(debit: 'Investment in Joint Venture', credit: 'Equity in JV Earnings', description: 'Record share of JV profits'),
      JournalEntry(debit: 'Equity in JV Losses', credit: 'Investment in Joint Venture', description: 'Record share of JV losses'),
      JournalEntry(debit: 'Cash', credit: 'Investment in Joint Venture', description: 'Receive dividend from JV'),
      JournalEntry(debit: 'Impairment Loss', credit: 'Investment in Joint Venture', description: 'Write down if impaired'),
    ],
    financialStatementImpact: FinancialStatementImpact(
      balanceSheet: 'Investment in JV shown as single line item in non-current assets. Carrying value = initial cost + share of earnings - dividends - impairment. Does not consolidate JV assets and liabilities.',
      incomeStatement: 'Share of JV net income (or loss) shown as single line, typically below operating income. Represents investor\'s proportionate share of JV profit after tax.',
      cashFlowStatement: 'Equity in JV earnings added back to operating cash flow (non-cash). Dividends received from JV shown in operating activities. Initial investment in investing activities.',
    ),
    disclosureRequirements: ['Name, nature, and principal place of business of each material JV', 'Proportion of ownership interest and voting rights', 'Summarized financial information of material JVs', 'Nature and extent of restrictions on JV assets or ability to distribute', 'Contingent liabilities and commitments related to JV', 'Reconciliation of summarized financial information to carrying amount'],
    ifrsVsGaap: 'Both require equity method for joint ventures (IFRS 11/IAS 28, ASC 323). Key differences: (1) IFRS eliminated proportionate consolidation for JVs; US GAAP never allowed it. (2) IFRS requires assessment of joint control vs. significant influence; US GAAP provides more guidance on variable interest entities. (3) Impairment guidance differs slightly.',
  ),
  strategicConsiderations: StrategicConsiderations(
    decisionCriteria: ['Strategic fit: Does JV achieve objectives neither partner could alone?', 'Partner quality: Reputation, capabilities, financial strength', 'Governance: Can partners work together effectively?', 'Exit options: Clear paths if JV doesn\'t work', 'Risk allocation: Fair sharing of risks and rewards', 'Competitive dynamics: Impact on competitive position'],
    comparisonWithAlternatives: 'vs. Acquisition: JV requires less capital and shares risk but gives up control. vs. Organic Development: JV provides faster access but adds partner complexity. vs. Licensing: JV provides more control than licensing but requires more commitment. vs. Alliance: JV creates stronger commitment but less flexibility.',
    impactOnFinancialPosition: 'JV investment shown on balance sheet at equity method value. Income statement includes share of JV earnings. Returns may lag other investments during startup. Successful JVs can generate attractive returns with limited capital at risk.',
    commonMistakes: ['Inadequate partner due diligence', 'Unclear or unworkable governance structures', 'Insufficient exit provisions for deadlock or failure', 'Unrealistic expectations for speed and returns', 'Inadequate attention to cultural fit', 'Competing with the JV in adjacent areas'],
    bestPractices: ['Define clear strategic objectives and success metrics', 'Conduct thorough partner due diligence', 'Negotiate comprehensive governance and exit provisions', 'Establish deadlock resolution mechanisms', 'Assign experienced JV management team', 'Plan for integration and knowledge sharing'],
  ),
  practicalApplication: PracticalApplication(
    realWorldExample: 'Sony-Ericsson Mobile (2001-2012): Joint venture between Sony and Ericsson to combine phone design (Sony) with telecom technology (Ericsson). Initially successful with iconic phones, but struggled against smartphones. Sony bought Ericsson\'s 50% stake for €1.05B in 2012. Demonstrates JV lifecycle from formation through strategic exit.',
    calculationExample: 'JV Investment Accounting: Company A invests \$50M for 50% of JV. Year 1: JV earns \$20M net income. A\'s share: \$10M. JV distributes \$8M dividend. A\'s share: \$4M. Year 1 journal entries: Dr. Investment \$10M, Cr. Equity Income \$10M (share of earnings); Dr. Cash \$4M, Cr. Investment \$4M (dividend). Year-end carrying value: \$50M + \$10M - \$4M = \$56M.',
    caseStudy: 'Fuji Xerox (1962-2021): One of the longest-running JVs, between Fuji Photo Film and Xerox. Successful for decades in Asian markets. However, 2017 accounting scandal exposed \$285M in improper accounting. Ultimately led to restructuring and Fujifilm acquiring Xerox\'s stake. Lessons: (1) Long-term JV success requires ongoing governance attention; (2) Minority partners may lack visibility into problems; (3) Exit provisions become critical when relationships deteriorate.',
    industryVariations: ['Automotive: Common for market entry (e.g., China JV requirements)', 'Pharmaceuticals: R&D collaborations and commercialization JVs', 'Oil & Gas: Consortium JVs for large capital projects', 'Technology: Standards development and platform JVs', 'Real Estate: Project-specific JVs with developers and investors'],
    regulatoryConsiderations: ['Antitrust: Competition authority review for significant JVs', 'Foreign Investment: Local ownership requirements in some countries', 'Industry-Specific: Banking, defense, media ownership restrictions', 'Tax: Transfer pricing for related party transactions', 'Accounting: Joint control assessment for accounting treatment'],
  ),
);

const intangibleAssetsContent = ScenarioEducationalContent(
  coreFramework: CoreFramework(
    definitionOverview: 'Intangible assets are non-physical assets that provide economic benefits over multiple periods. They include patents, trademarks, copyrights, software, customer relationships, brand names, and goodwill. Intangibles often represent the most valuable assets of modern knowledge-based companies, sometimes comprising 80%+ of enterprise value for technology and consumer brands firms.',
    keyCharacteristics: ['Lack physical substance but provide future economic benefits', 'Identifiable (can be separated) or unidentifiable (goodwill)', 'Finite useful life (patents, customer relationships) or indefinite (trademarks)', 'Value often difficult to measure, especially if internally developed', 'Subject to impairment testing rather than depreciation (indefinite life)', 'Critical driver of competitive advantage in knowledge economy'],
    typesClassifications: ['Marketing-Related: Trademarks, trade names, brand names, domain names', 'Customer-Related: Customer lists, relationships, contracts, backlog', 'Artistic-Related: Copyrights on books, music, films, photographs', 'Contract-Based: Licensing agreements, franchises, broadcast rights', 'Technology-Based: Patents, software, databases, trade secrets', 'Goodwill: Excess purchase price over fair value of net assets acquired'],
    advantages: ['Can provide sustainable competitive advantage', 'Often scalable with minimal incremental cost', 'May create entry barriers through IP protection', 'Network effects can increase value over time', 'Tax benefits through amortization (for acquired intangibles)', 'Collateral potential for IP-based lending'],
    disadvantages: ['Difficult to value, especially internally developed', 'Protection requires ongoing legal effort and expense', 'Technology intangibles face rapid obsolescence risk', 'Limited ability to use as collateral for traditional financing', 'Impairment testing complexity and potential write-downs', 'Internally developed intangibles often not recognized on balance sheet'],
    whenToUse: ['Building competitive moat through proprietary technology or brands', 'Acquiring customer relationships or distribution rights', 'Protecting innovation through patent portfolio development', 'Developing software or content for commercial exploitation', 'Acquiring companies where value is primarily in intangibles', 'Licensing IP as alternative to full market entry'],
    keyTerminology: [
      KeyTerminology(term: 'Goodwill', definition: 'Excess of acquisition price over fair value of identifiable net assets, representing synergies and unidentifiable intangibles'),
      KeyTerminology(term: 'Amortization', definition: 'Systematic allocation of intangible asset cost over its useful life'),
      KeyTerminology(term: 'Impairment', definition: 'Write-down when carrying value exceeds recoverable amount (fair value less cost to sell or value in use)'),
      KeyTerminology(term: 'Useful Life', definition: 'Period over which asset is expected to contribute to cash flows; can be finite or indefinite'),
      KeyTerminology(term: 'Identifiable Intangible', definition: 'Intangible that is separable or arises from contractual/legal rights'),
      KeyTerminology(term: 'Purchase Price Allocation (PPA)', definition: 'Process of assigning acquisition price to identified assets and liabilities including intangibles'),
    ],
  ),
  mechanicsProcess: MechanicsProcess(
    howItWorks: 'Intangible assets are acquired through purchase (business combinations, asset acquisitions) or developed internally. Purchased intangibles are recognized at fair value. Internally developed intangibles are expensed as incurred except for software development (ASC 350-40) and certain IFRS development costs. After acquisition, intangibles are amortized (finite life) or tested for impairment (indefinite life).',
    stepByStepProcess: ['Step 1: Identify the intangible asset (separable or contractual/legal)', 'Step 2: Determine acquisition method (purchase vs. internal development)', 'Step 3: Measure fair value at acquisition (or cost for internal)', 'Step 4: Classify as finite or indefinite useful life', 'Step 5: Recognize on balance sheet (if purchased or qualifying development)', 'Step 6: Determine amortization period and method (finite life)', 'Step 7: Test for impairment annually (indefinite) or when indicators exist', 'Step 8: Review useful life and impairment indicators each period'],
    keyPartiesInvolved: ['Management: Strategy decisions on intangible investments', 'Valuation Specialists: Fair value determination for acquisitions', 'Legal/IP Counsel: Protection and enforcement of IP rights', 'R&D Teams: Internal development of technology intangibles', 'External Auditors: Review valuation and impairment testing', 'Tax Advisors: Optimize tax treatment of intangible transactions'],
    documentationRequired: ['Acquisition agreements and purchase price allocation', 'Valuation reports from specialists', 'IP registration documents (patents, trademarks)', 'License agreements and contracts', 'Impairment testing documentation and assumptions', 'Useful life determination support'],
    timelineMilestones: ['At Acquisition: Identify and value intangibles in PPA', 'Initial Period: Finalize PPA within measurement period (1 year)', 'Quarterly: Review for impairment indicators', 'Annually: Impairment test for goodwill and indefinite-life intangibles', 'Ongoing: Amortize finite-life intangibles over useful life'],
  ),
  financialAnalysis: FinancialAnalysis(
    valuationPricing: 'Intangible valuation methods include: Income Approach (discounted cash flows from the asset), Market Approach (comparable transactions), and Cost Approach (replacement cost). Income approach most common for customer relationships and technology. Relief-from-royalty method common for trademarks. Multi-period excess earnings for customer relationships.',
    costCalculation: 'Acquisition cost includes purchase price, transaction costs (for asset acquisitions), and directly attributable costs to prepare for use. For business combinations, intangibles recorded at fair value. Internally developed intangibles: Development costs capitalized only if specific criteria met (IFRS) or for qualifying software (US GAAP).',
    riskFactors: ['Obsolescence: Technology intangibles can become worthless rapidly', 'Competition: New entrants may erode customer relationships', 'Legal: Patent challenges, trademark disputes, copyright infringement', 'Regulatory: Changes affecting intangible value (e.g., licensing rules)', 'Integration: Synergy assumptions in goodwill may not materialize', 'Economic: Downturns trigger impairment of customer-related intangibles'],
    returnMetrics: ['Return on Intangible Assets: Operating income / Intangible assets', 'Amortization Expense Ratio: Amortization / Revenue', 'R&D Yield: Revenue from new products / Cumulative R&D spend', 'Patent Value: Licensed revenue or litigation awards', 'Brand Value: Premium pricing power or customer preference metrics'],
    keyRatios: [
      KeyRatio(ratio: 'Intangibles / Total Assets', formula: 'Intangible Assets / Total Assets', interpretation: 'Asset intensity in intangibles; high for knowledge companies'),
      KeyRatio(ratio: 'Goodwill / Equity', formula: 'Goodwill / Total Equity', interpretation: 'Acquisition intensity; high ratio indicates impairment risk'),
      KeyRatio(ratio: 'Amortization / Intangibles', formula: 'Annual Amortization / Gross Intangibles', interpretation: 'Implied average life; accelerated if high'),
      KeyRatio(ratio: 'Price / Book with Intangibles', formula: 'Market Cap / Book Value including Intangibles', interpretation: 'Market premium for unrecognized intangibles if high'),
    ],
    breakEvenAnalysis: 'Intangible investment break-even: when cumulative cash flows attributable to intangible equal investment. For acquired customer relationships, break-even when present value of customer profits exceeds allocated value. For R&D, when commercialized products generate returns exceeding development costs.',
  ),
  accountingTreatment: AccountingTreatment(
    recognitionMeasurement: 'Acquired intangibles recognized at fair value in business combinations. Internally developed intangibles generally expensed (US GAAP) except qualifying software development and website costs. IFRS allows capitalization of development costs meeting specific criteria. Goodwill not amortized; tested for impairment annually.',
    journalEntries: [
      JournalEntry(debit: 'Patent (Intangible Asset)', credit: 'Cash', description: 'Purchase of patent'),
      JournalEntry(debit: 'Customer Relationships', credit: 'Goodwill', description: 'Allocate acquisition price to identified intangible'),
      JournalEntry(debit: 'Amortization Expense', credit: 'Accumulated Amortization - Intangibles', description: 'Periodic amortization of finite-life intangible'),
      JournalEntry(debit: 'Impairment Loss', credit: 'Goodwill', description: 'Write down goodwill for impairment'),
      JournalEntry(debit: 'R&D Expense', credit: 'Cash', description: 'Expense internal R&D costs (US GAAP)'),
    ],
    financialStatementImpact: FinancialStatementImpact(
      balanceSheet: 'Intangibles shown as separate line in non-current assets. Goodwill shown separately from other intangibles. Accumulated amortization reduces carrying value. Impairment reduces asset value permanently.',
      incomeStatement: 'Amortization expense typically in operating expenses. Impairment losses shown separately or in operating expenses. R&D costs expensed when incurred. Acquired in-process R&D expensed in period of acquisition.',
      cashFlowStatement: 'Amortization and impairment added back to operating cash flow (non-cash). Cash paid for intangible acquisitions in investing activities. Internal development costs in operating activities.',
    ),
    disclosureRequirements: ['Gross carrying amount and accumulated amortization by major class', 'Amortization expense and impairment losses for period', 'Estimated amortization expense for next five years', 'Description of goodwill by reportable segment', 'Methodology for impairment testing and key assumptions', 'Changes in carrying amount of goodwill during period'],
    ifrsVsGaap: 'Key differences: (1) IFRS allows development cost capitalization; US GAAP requires expense (except software). (2) Goodwill impairment: US GAAP simplified one-step test; IFRS uses cash-generating unit approach. (3) IFRS allows intangible revaluation (rare); US GAAP cost model only. (4) In-process R&D treatment aligned post-ASC 805.',
  ),
  strategicConsiderations: StrategicConsiderations(
    decisionCriteria: ['Strategic importance of intangible to competitive position', 'Build vs. buy: Internal development vs. acquisition trade-offs', 'Protection strategy: Patents, trade secrets, or speed to market', 'Useful life and obsolescence risk assessment', 'Synergies with existing capabilities and assets', 'Integration complexity for acquired intangibles'],
    comparisonWithAlternatives: 'Build vs. Buy: Internal development avoids premium but takes time and carries execution risk. Acquisition provides immediate access but at premium prices. Licensing offers middle ground but limits control. Strategic partnerships can share development costs and risks.',
    impactOnFinancialPosition: 'Acquired intangibles increase assets and may increase liabilities (earn-outs). Amortization creates ongoing expense reducing earnings. Impairment risk creates earnings volatility. High goodwill makes company vulnerable to write-downs in downturns.',
    commonMistakes: ['Overpaying for acquisitions leading to goodwill impairment', 'Underinvesting in maintaining and protecting IP', 'Assuming technology intangibles have long useful lives', 'Ignoring customer relationship attrition in valuations', 'Not aligning intangible investments with strategy', 'Insufficient integration of acquired intangibles'],
    bestPractices: ['Develop clear IP strategy aligned with business strategy', 'Rigorously evaluate acquisition prices against standalone value', 'Use realistic assumptions in intangible valuations', 'Monitor impairment indicators continuously', 'Invest in maintaining brand and customer relationships', 'Document valuation methodology and assumptions thoroughly'],
  ),
  practicalApplication: PracticalApplication(
    realWorldExample: 'Microsoft\'s LinkedIn Acquisition (2016): Paid \$26.2B, with \$16B allocated to goodwill and \$5B to intangibles (customer relationships, technology, brand). LinkedIn\'s tangible net assets were minimal. Illustrates how modern acquisitions are primarily about intangible value. Integration focused on leveraging LinkedIn data and network.',
    calculationExample: 'Customer Relationship Valuation: 100,000 customers, \$1,000 average annual revenue, 80% retention rate, 25% margin, 10% discount rate. Year 1 customers: 100K × \$1K × 25% = \$25M contribution. Year 2: 80K × \$1K × 25% = \$20M. Present value of 10-year customer stream ≈ \$85M. This becomes basis for intangible asset recognition.',
    caseStudy: 'Kraft Heinz Goodwill Impairment (2019): Wrote down \$15.4B in goodwill and intangibles, largest ever by food company. Contributing factors: (1) Changing consumer preferences reduced brand value; (2) Aggressive cost-cutting undermined brand investment; (3) Private label competition eroded pricing power. Lessons: Brand intangibles require ongoing investment; acquisition premiums may not hold through changing markets.',
    industryVariations: ['Technology: Patents, software, customer platforms dominant', 'Pharmaceuticals: Drug patents, regulatory approvals, pipelines', 'Consumer Goods: Brands, trademarks, customer relationships', 'Media: Copyrights, content libraries, broadcast rights', 'Financial Services: Customer relationships, technology platforms'],
    regulatoryConsiderations: ['Patent Law: 20-year protection from filing, prosecution process', 'Trademark: Registration, maintenance, enforcement requirements', 'Copyright: Automatic protection, registration benefits, fair use', 'Trade Secrets: Protection requirements and misappropriation claims', 'International: IP protection varies by jurisdiction; treaties provide some harmonization'],
  ),
);


// ============================================================================
// OPERATING DECISIONS
// ============================================================================

const marketingAdvertisingContent = ScenarioEducationalContent(
  coreFramework: CoreFramework(
    definitionOverview: 'Marketing and advertising expenditures are investments in brand building, customer acquisition, and revenue growth through promotional activities. These include traditional advertising (TV, print, radio), digital marketing (search, social, display), content marketing, sponsorships, trade shows, and sales promotions. While expensed immediately for accounting, marketing spending has long-term effects on brand value and customer relationships.',
    keyCharacteristics: ['Expensed as incurred under GAAP (not capitalized despite long-term effects)', 'Effects on sales often lagged and difficult to measure precisely', 'Mix shifting from traditional to digital channels', 'Increasing use of data and analytics for targeting and measurement', 'Both brand building (long-term) and performance marketing (short-term)', 'Significant variance in effectiveness across channels and creative'],
    typesClassifications: ['Brand Advertising: TV, print, outdoor - builds awareness and preference', 'Digital Performance: Search, social, display - trackable direct response', 'Content Marketing: Blogs, videos, podcasts - educational engagement', 'Trade Marketing: Promotions, displays, allowances - retailer support', 'Event Marketing: Sponsorships, trade shows, experiences', 'Direct Marketing: Email, direct mail, telemarketing'],
    advantages: ['Drives awareness, consideration, and customer acquisition', 'Builds brand equity that supports premium pricing', 'Enables scale through reach to mass audiences', 'Digital channels provide targeting and measurement capabilities', 'Creates competitive barriers through brand preference', 'Flexible spending can be adjusted based on results and conditions'],
    disadvantages: ['Difficult to measure ROI with precision', 'Effects can be slow to materialize', 'Easy to waste money on ineffective campaigns', 'Competitor activity can offset investments', 'Consumer skepticism and ad blocking reduce effectiveness', 'Expense treatment understates true investment value'],
    whenToUse: ['Launching new products or entering new markets', 'Building brand awareness in underserved segments', 'Defending market share against competitive threats', 'Supporting pricing power through brand preference', 'Driving short-term sales during key selling periods', 'Repositioning brand image or perceptions'],
    keyTerminology: [
      KeyTerminology(term: 'Customer Acquisition Cost (CAC)', definition: 'Total sales and marketing expense divided by new customers acquired'),
      KeyTerminology(term: 'Return on Ad Spend (ROAS)', definition: 'Revenue generated divided by advertising spend'),
      KeyTerminology(term: 'Brand Equity', definition: 'Value premium attributable to brand name versus unbranded equivalent'),
      KeyTerminology(term: 'Share of Voice (SOV)', definition: 'Brand\'s advertising volume as percentage of total category advertising'),
      KeyTerminology(term: 'Conversion Rate', definition: 'Percentage of marketing interactions that result in desired action (purchase, sign-up)'),
      KeyTerminology(term: 'Marketing Mix', definition: 'Allocation of marketing spending across channels, media, and tactics'),
    ],
  ),
  mechanicsProcess: MechanicsProcess(
    howItWorks: 'Marketing planning begins with setting objectives (awareness, sales, share) and budget allocation. Creative development produces campaign assets. Media planning determines channel mix and timing. Execution launches campaigns across channels. Performance monitoring tracks metrics against goals. Optimization adjusts spending and creative based on results.',
    stepByStepProcess: ['Step 1: Set marketing objectives aligned with business goals', 'Step 2: Develop marketing strategy and positioning', 'Step 3: Determine budget based on objectives and competitive context', 'Step 4: Allocate budget across channels and campaigns', 'Step 5: Develop creative concepts and assets', 'Step 6: Plan media placement and timing', 'Step 7: Execute campaigns across channels', 'Step 8: Monitor performance metrics in real-time', 'Step 9: Optimize based on performance data', 'Step 10: Report results and calculate ROI'],
    keyPartiesInvolved: ['CMO/Marketing Leadership: Strategy and budget decisions', 'Brand Managers: Campaign planning and execution', 'Creative Agency: Develop advertising concepts and assets', 'Media Agency: Plan and buy advertising placements', 'Digital Teams: Execute and optimize digital campaigns', 'Analytics/Insights: Measure performance and provide insights'],
    documentationRequired: ['Marketing plan with objectives, strategy, and budget', 'Creative briefs and approved assets', 'Media plans with placements and schedules', 'Vendor contracts and insertion orders', 'Performance reports and dashboards', 'ROI analysis and attribution models'],
    timelineMilestones: ['Q4 Prior Year: Annual planning and budget setting', '8-12 Weeks Pre-Campaign: Creative development', '4-6 Weeks Pre-Campaign: Media planning and buying', 'Campaign Launch: Execute across channels', 'During Campaign: Monitor and optimize', 'Post-Campaign: Measure results and document learnings'],
  ),
  financialAnalysis: FinancialAnalysis(
    valuationPricing: 'Marketing budgets typically set as percentage of revenue (5-15% for consumer goods), competitive parity, or objective-and-task method. Digital CPMs range from \$2-50 depending on targeting. TV CPMs \$10-40. Customer acquisition costs vary widely by industry (\$10-500+ for B2B SaaS).',
    costCalculation: 'Total marketing cost includes: Media spend (40-60% of budget), creative production (10-20%), agency fees (10-15%), technology/analytics (5-10%), and personnel (15-25%). Digital campaigns allow precise cost tracking; brand campaigns require marketing mix modeling.',
    riskFactors: ['Wasted spend on ineffective creative or targeting', 'Attribution challenges in multi-channel environment', 'Competitive response negating investment impact', 'Brand safety issues with programmatic advertising', 'Ad fraud in digital channels', 'Changing consumer media consumption patterns'],
    returnMetrics: ['Return on Ad Spend (ROAS): Revenue / Ad Spend', 'Customer Acquisition Cost (CAC): Marketing Spend / New Customers', 'Customer Lifetime Value / CAC Ratio: Target 3:1 or higher', 'Brand Awareness and Consideration Lift: Survey-based measurement', 'Market Share Change: Volume share before/after campaigns'],
    keyRatios: [
      KeyRatio(ratio: 'Marketing / Revenue', formula: 'Total Marketing Expense / Revenue', interpretation: 'Marketing intensity; varies by industry (consumer goods 10-15%, B2B 3-5%)'),
      KeyRatio(ratio: 'CAC Payback Period', formula: 'CAC / Monthly Gross Margin per Customer', interpretation: 'Months to recover acquisition cost; target <12-18 months'),
      KeyRatio(ratio: 'LTV/CAC', formula: 'Customer Lifetime Value / Customer Acquisition Cost', interpretation: 'Unit economics; healthy business typically 3x or higher'),
      KeyRatio(ratio: 'Advertising / Gross Profit', formula: 'Advertising Expense / Gross Profit', interpretation: 'Ad spending relative to margin; sustainability indicator'),
    ],
    breakEvenAnalysis: 'Campaign break-even: when incremental gross profit equals campaign cost. Example: \$1M campaign, 25% gross margin, \$50 average order. Need \$4M incremental revenue = 80,000 orders to break even. For customer acquisition: break-even when cumulative customer profit equals CAC.',
  ),
  accountingTreatment: AccountingTreatment(
    recognitionMeasurement: 'Marketing and advertising costs are expensed as incurred under both US GAAP and IFRS. This includes creative development, media placement, agency fees, and promotional costs. Direct response advertising may be capitalized if certain criteria met (ASC 340-20) but this is rare.',
    journalEntries: [
      JournalEntry(debit: 'Advertising Expense', credit: 'Cash/Accounts Payable', description: 'Record advertising costs'),
      JournalEntry(debit: 'Marketing Expense', credit: 'Accrued Liabilities', description: 'Accrue agency fees and media costs'),
      JournalEntry(debit: 'Sales Promotion Expense', credit: 'Cash', description: 'Record promotional costs (coupons, samples)'),
      JournalEntry(debit: 'Prepaid Advertising', credit: 'Cash', description: 'Advance payment for future media'),
      JournalEntry(debit: 'Advertising Expense', credit: 'Prepaid Advertising', description: 'Recognize prepaid as ads run'),
    ],
    financialStatementImpact: FinancialStatementImpact(
      balanceSheet: 'Prepaid advertising if paid in advance of placement. Generally no assets created from marketing spending. Co-op advertising receivables if earned from vendors.',
      incomeStatement: 'Marketing costs shown as operating expense. May be combined with selling expense or shown separately. Significant line item for consumer-facing companies.',
      cashFlowStatement: 'Marketing costs in operating activities. Timing differences between cash payment and expense recognition may affect working capital.',
    ),
    disclosureRequirements: ['Advertising costs expensed during period', 'Accounting policy for advertising costs', 'Deferred advertising costs if applicable', 'Cooperative advertising arrangements', 'Related party transactions with advertising agencies'],
    ifrsVsGaap: 'Both frameworks require immediate expense for most advertising costs. US GAAP (ASC 720-35) has specific guidance on advertising; IFRS uses general expense recognition principles. Key difference: Direct response advertising capitalization is more common under US GAAP historical practice, though restrictive.',
  ),
  strategicConsiderations: StrategicConsiderations(
    decisionCriteria: ['Marketing objectives and expected impact on KPIs', 'Historical ROI by channel and campaign type', 'Competitive spending and share of voice', 'Brand health metrics and gaps to address', 'Capacity to execute and optimize campaigns', 'Economic conditions and consumer sentiment'],
    comparisonWithAlternatives: 'Marketing vs. Price Promotion: Marketing builds brand but takes time; promotions drive immediate sales but may hurt long-term brand value. vs. Product Investment: Strong products may need less marketing; weak products can\'t be saved by marketing alone. vs. Distribution: Sometimes distribution investment more efficient than advertising.',
    impactOnFinancialPosition: 'Marketing expense reduces operating income and margins. Effective marketing drives revenue growth and may improve gross margin through brand premium. Ineffective marketing wastes resources without benefit. Balance between short-term profit and long-term brand building required.',
    commonMistakes: ['Cutting brand marketing in downturns (often counterproductive)', 'Over-investing in awareness without clear path to conversion', 'Ignoring creative quality in pursuit of media efficiency', 'Assuming digital is always more efficient than traditional', 'Insufficient testing before scaling campaigns', 'Not aligning marketing with product and pricing strategy'],
    bestPractices: ['Balance brand building and performance marketing', 'Establish clear KPIs and measurement frameworks', 'Test creative and channels before major investments', 'Maintain consistent brand presence through business cycles', 'Integrate marketing data with business performance data', 'Continuously optimize based on performance data'],
  ),
  practicalApplication: PracticalApplication(
    realWorldExample: 'Procter & Gamble Marketing Strategy: P&G spends \$7-8B annually on advertising (10% of sales), making it one of world\'s largest advertisers. Recently shifted toward digital while maintaining TV presence. Uses sophisticated marketing mix modeling. Reduced agency and production costs 40% through digital efficiency. Demonstrates scale and sophistication in consumer goods marketing.',
    calculationExample: 'Digital Campaign ROI: \$100K campaign generates 500K impressions, 5K clicks (1% CTR), 250 conversions (5% conversion rate), \$100 average order = \$25K revenue. ROAS = 0.25x (loss). But if customers have \$500 LTV and 20% margin: 250 customers × \$100 profit = \$25K first-year profit. LTV/CAC = \$100/\$400 = 0.25x (needs improvement).',
    caseStudy: 'Old Spice \'The Man Your Man Could Smell Like\' (2010): P&G invested in viral video campaign that became cultural phenomenon. Results: 107% sales increase, 2,700% increase in Twitter followers, 300M video views. Campaign cost fraction of typical TV spend. Lessons: (1) Creative quality drives earned media multiplier; (2) Social/digital enables viral effects; (3) Bold creative can transform brand perception.',
    industryVariations: ['Consumer Packaged Goods: Heavy traditional advertising, brand building focus', 'E-commerce/DTC: Performance marketing dominant, data-driven optimization', 'B2B: Content marketing, events, account-based marketing', 'Automotive: Large traditional budgets, dealer co-op programs', 'Financial Services: Mix of brand and direct response, heavy regulation'],
    regulatoryConsiderations: ['Truth in Advertising: FTC Act prohibits deceptive practices', 'Industry-Specific: FDA for pharma/food, FTC for finance disclosures', 'Privacy: GDPR, CCPA affect targeting and data use', 'Children\'s Advertising: COPPA and self-regulatory guidelines', 'Comparative Advertising: Substantiation requirements', 'Endorsements: FTC guidelines for influencer and testimonial disclosures'],
  ),
);

const workforceManagementContent = ScenarioEducationalContent(
  coreFramework: CoreFramework(
    definitionOverview: 'Workforce management encompasses decisions about hiring, laying off, and managing employee headcount to align labor capacity with business needs. It includes strategic workforce planning, talent acquisition, restructuring, and right-sizing. Labor is typically the largest expense for service businesses (50-70% of costs), making workforce decisions critical for financial performance and operational capability.',
    keyCharacteristics: ['Labor is largest controllable cost for most organizations', 'Hiring decisions have long-term cost implications (benefits, development)', 'Layoffs create short-term costs (severance) for long-term savings', 'Skills and culture difficult to rebuild once lost', 'Regulatory requirements vary significantly by jurisdiction', 'Employee experience affects retention, productivity, and reputation'],
    typesClassifications: ['Strategic Hiring: Adding capabilities for growth or new initiatives', 'Replacement Hiring: Backfilling turnover to maintain capacity', 'Workforce Expansion: Scaling headcount with business growth', 'Restructuring: Reorganizing for efficiency or strategic change', 'Reduction in Force (RIF): Layoffs to reduce costs or respond to decline', 'Contingent Workforce: Contractors, temps, gig workers for flexibility'],
    advantages: ['Variable cost structure when using flexible workforce', 'Right-sizing improves efficiency and margins', 'Strategic hiring builds capabilities for growth', 'Restructuring enables transformation and renewal', 'Talent quality drives innovation and customer value', 'Engaged workforce improves productivity and retention'],
    disadvantages: ['Hiring wrong people is expensive (recruiting, training, severance)', 'Layoffs damage morale and employer brand', 'Restructuring distracts from operations', 'Skills shortages constrain growth in tight labor markets', 'Labor regulations add complexity and cost', 'Turnover disrupts operations and loses institutional knowledge'],
    whenToUse: ['Business growth requires additional capacity', 'New initiatives need skills not available internally', 'Turnover creates gaps that must be filled', 'Business decline or restructuring requires downsizing', 'M&A creates redundancy requiring rationalization', 'Cost pressures require workforce optimization'],
    keyTerminology: [
      KeyTerminology(term: 'Full-Time Equivalent (FTE)', definition: 'Standardized measure of workforce counting full-time employees as 1.0, part-time proportionally'),
      KeyTerminology(term: 'Cost per Hire', definition: 'Total recruiting costs divided by number of hires, typically \$4,000-\$15,000'),
      KeyTerminology(term: 'Severance', definition: 'Payment to terminated employees, typically 1-4 weeks per year of service'),
      KeyTerminology(term: 'WARN Act', definition: 'US law requiring 60-day notice for large layoffs (100+ employees)'),
      KeyTerminology(term: 'Restructuring Charge', definition: 'One-time expense for severance and related costs in workforce reduction'),
      KeyTerminology(term: 'Employee Turnover', definition: 'Rate at which employees leave and are replaced, typically 10-20% annually'),
    ],
  ),
  mechanicsProcess: MechanicsProcess(
    howItWorks: 'Workforce planning aligns staffing with strategic and operational needs. For hiring, process includes requisition approval, recruiting, selection, offer, and onboarding. For reductions, process includes business case, selection methodology, legal review, notification, separation, and support (severance, outplacement). Both require careful planning to manage costs and maintain capability.',
    stepByStepProcess: ['Step 1: Analyze current workforce (skills, capacity, costs)', 'Step 2: Forecast business needs and required capabilities', 'Step 3: Identify gaps between current state and future needs', 'Step 4: Develop workforce plan (hiring, development, or reduction)', 'Step 5: Obtain approvals and budget', 'Step 6: Execute plan (recruiting or notification process)', 'Step 7: Manage transition (onboarding or separation)', 'Step 8: Monitor results and adjust as needed'],
    keyPartiesInvolved: ['Business Leaders: Define needs and approve decisions', 'Human Resources: Execute processes, ensure compliance', 'Finance: Budget and financial analysis', 'Legal: Review for compliance and risk', 'Recruiting: Source and attract talent', 'Employees: Affected by and participants in process'],
    documentationRequired: ['Workforce plan and business justification', 'Job descriptions and requirements', 'Recruiting materials and candidate records', 'Selection criteria and documentation', 'Offer letters and employment agreements', 'Separation agreements and WARN notices (if applicable)'],
    timelineMilestones: ['Hiring: 4-12 weeks from requisition to start date', 'Layoffs: 2-4 weeks planning, 60+ days if WARN applies', 'Restructuring: 3-6 months for significant reorganization', 'Annual: Workforce planning as part of budget cycle', 'Ongoing: Performance management and development'],
  ),
  financialAnalysis: FinancialAnalysis(
    valuationPricing: 'Labor cost = Base salary + Benefits (20-40% of salary) + Payroll taxes (7.65% FICA) + Other costs (space, equipment, training). Total cost typically 1.25-1.5x base salary. Senior/specialized roles may have higher multipliers with equity and other benefits.',
    costCalculation: 'Hiring costs: Recruiting (\$4K-15K), relocation, signing bonus, training (3-6 months to productivity). Layoff costs: Severance (1-4 weeks per year), benefits continuation (COBRA), outplacement, legal, and productivity loss. Ongoing: Salary, benefits, development, management overhead.',
    riskFactors: ['Hiring wrong fit requiring termination and re-hire', 'Layoffs triggering litigation or regulatory issues', 'Morale decline affecting productivity after layoffs', 'Key person departure creating capability gaps', 'Labor market tightness preventing hiring', 'Regulatory changes increasing labor costs'],
    returnMetrics: ['Revenue per Employee: Total Revenue / FTE count', 'Cost per Hire: Total Recruiting Cost / Hires', 'Turnover Rate: Separations / Average Headcount', 'Time to Fill: Days from requisition to acceptance', 'Restructuring Payback: Severance Cost / Annual Savings'],
    keyRatios: [
      KeyRatio(ratio: 'Labor Cost / Revenue', formula: 'Total Compensation / Revenue', interpretation: 'Labor intensity; service firms 50-70%, manufacturing 20-40%'),
      KeyRatio(ratio: 'Revenue per FTE', formula: 'Annual Revenue / Average FTEs', interpretation: 'Productivity measure; higher indicates more efficient workforce'),
      KeyRatio(ratio: 'Restructuring Payback', formula: 'Restructuring Charge / Annual Savings', interpretation: 'Years to recover severance costs; typically target <1 year'),
      KeyRatio(ratio: 'Turnover Rate', formula: 'Annual Separations / Average Headcount', interpretation: 'Retention indicator; 10-15% often considered healthy'),
    ],
    breakEvenAnalysis: 'Layoff break-even: Severance cost / Monthly savings. Example: \$50K severance, \$8K monthly savings = 6.25 months to break even. Hiring break-even: Total hiring and ramp cost / Monthly contribution. Factor in probability of success and retention risk.',
  ),
  accountingTreatment: AccountingTreatment(
    recognitionMeasurement: 'Compensation expenses recognized as incurred. Severance recognized when probable and estimable (restructuring charges). Signing bonuses and relocation typically expensed immediately or amortized over service period. Stock compensation expensed over vesting period at grant date fair value.',
    journalEntries: [
      JournalEntry(debit: 'Salary Expense', credit: 'Salaries Payable', description: 'Record regular compensation'),
      JournalEntry(debit: 'Benefits Expense', credit: 'Benefits Payable', description: 'Record health insurance, 401k match'),
      JournalEntry(debit: 'Restructuring Charge', credit: 'Restructuring Reserve', description: 'Accrue severance when plan committed'),
      JournalEntry(debit: 'Restructuring Reserve', credit: 'Cash', description: 'Pay severance to departing employees'),
      JournalEntry(debit: 'Stock Compensation Expense', credit: 'Additional Paid-in Capital', description: 'Recognize stock-based comp'),
    ],
    financialStatementImpact: FinancialStatementImpact(
      balanceSheet: 'Accrued compensation in current liabilities. Restructuring reserves for announced layoffs. Prepaid expenses for advance payments. No asset for workforce value.',
      incomeStatement: 'Compensation in operating expenses. Restructuring charges may be shown separately or in operating expenses. Stock compensation often added back for adjusted metrics.',
      cashFlowStatement: 'Compensation in operating activities. Severance payments in operating activities. Stock compensation added back (non-cash).',
    ),
    disclosureRequirements: ['Total compensation expense by category', 'Restructuring charges and reserve rollforward', 'Stock compensation expense and assumptions', 'Employee benefit plan disclosures', 'Executive compensation (proxy statement for public companies)'],
    ifrsVsGaap: 'Similar treatment under both frameworks. Key differences: (1) IAS 19 vs. ASC 710/712 for benefits - some timing and measurement differences. (2) Restructuring: IAS 37 vs. ASC 420/ASC 712 - IFRS requires \'constructive obligation\' while US GAAP allows earlier recognition. (3) Share-based payments: IFRS 2 vs. ASC 718 - generally aligned but some differences in forfeitures and modifications.',
  ),
  strategicConsiderations: StrategicConsiderations(
    decisionCriteria: ['Strategic alignment with business direction', 'Financial impact (cost vs. capability value)', 'Labor market conditions and availability', 'Legal and regulatory requirements', 'Cultural and morale implications', 'Alternative solutions (contractors, automation, outsourcing)'],
    comparisonWithAlternatives: 'Hiring vs. Contractors: Employees provide loyalty and culture fit but fixed costs; contractors offer flexibility but higher hourly rates and less commitment. vs. Automation: Technology replaces routine work but requires investment and different skills. vs. Outsourcing: Third parties may be more efficient but lose control and institutional knowledge.',
    impactOnFinancialPosition: 'Workforce changes directly affect operating expenses and margins. Layoffs create one-time restructuring charges but improve ongoing expense base. Hiring increases costs but enables revenue growth. Right-sizing improves efficiency ratios.',
    commonMistakes: ['Hiring too fast during growth without sustainable needs', 'Cutting too deep in downturns, losing key capabilities', 'Not investing in employee development and retention', 'Ignoring cultural fit in hiring decisions', 'Underestimating hidden costs of turnover', 'Poor communication during restructuring damaging morale'],
    bestPractices: ['Maintain workforce planning as continuous process', 'Balance fixed and flexible workforce for agility', 'Invest in retention to reduce costly turnover', 'Ensure hiring process assesses culture fit and capability', 'Handle layoffs with respect and generous support', 'Communicate openly about workforce changes'],
  ),
  practicalApplication: PracticalApplication(
    realWorldExample: 'Google\'s Workforce Management: Known for rigorous hiring (\'only hire people smarter than yourself\'), extensive employee benefits, and data-driven people analytics. During 2023 tech downturn, announced 12,000 layoffs (6% of workforce) with 16+ weeks severance plus 6 months healthcare. Demonstrates both investment in talent and willingness to restructure when needed.',
    calculationExample: 'Restructuring Analysis: Plan to lay off 100 employees, average salary \$80K, benefits 30% = \$104K total cost each. Severance: 8 weeks = \$16K each. Total severance: \$1.6M. Annual savings: \$10.4M. Payback: 1.8 months. But factor in: Recruiting and training for rehires if recovery, morale impact, knowledge loss.',
    caseStudy: 'IBM\'s Workforce Transformation (2014-2020): Shifted from hardware to cloud/AI, requiring massive retraining and restructuring. Laid off estimated 100,000+ while hiring different skills. Challenged by age discrimination lawsuits. Lessons: (1) Major transformations require workforce changes; (2) Selection criteria must be defensible; (3) Retraining existing employees often preferred to replacing.',
    industryVariations: ['Technology: Expensive talent, competitive retention, frequent restructuring', 'Manufacturing: Union considerations, shift work, automation impact', 'Retail: High turnover, seasonal hiring, minimum wage sensitivity', 'Healthcare: Licensing requirements, staffing ratios, specialized roles', 'Financial Services: Expensive talent, regulatory requirements, bonus-driven'],
    regulatoryConsiderations: ['WARN Act: 60-day notice for large layoffs in US', 'Anti-discrimination: Age, race, gender protections in selection', 'ERISA: Employee benefit plan requirements', 'International: Strong employment protections in Europe, Asia', 'Union: Collective bargaining agreements may restrict actions', 'Immigration: Visa sponsorship and compliance requirements'],
  ),
);

const trainingDevelopmentContent = ScenarioEducationalContent(
  coreFramework: CoreFramework(
    definitionOverview: 'Training and development investments build employee capabilities through formal learning programs, on-the-job development, coaching, and educational support. Organizations invest \$1,000-\$1,500 per employee annually on average, with leading firms spending significantly more. Effective training improves productivity, reduces errors, supports retention, and builds capabilities for future needs.',
    keyCharacteristics: ['Expensed immediately despite long-term human capital benefits', 'ROI difficult to measure directly but well-established indirectly', 'Blend of formal training, on-the-job development, and self-directed learning', 'Shifting to digital/virtual delivery for scale and cost efficiency', 'Leadership development particularly important for succession', 'Technical training increasingly important as technology evolves'],
    typesClassifications: ['Onboarding: New employee orientation and initial skill building', 'Technical Skills: Job-specific capabilities and certifications', 'Soft Skills: Communication, leadership, teamwork', 'Compliance: Required training for regulatory requirements', 'Leadership Development: Preparing future leaders', 'Professional Development: Degree programs, certifications, conferences'],
    advantages: ['Improves employee productivity and work quality', 'Reduces errors and rework costs', 'Supports employee engagement and retention', 'Builds capabilities for future needs', 'Enables promotion from within reducing recruiting costs', 'Improves safety and compliance'],
    disadvantages: ['Costs money with returns that are difficult to measure', 'Takes employees away from productive work', 'Training may not transfer effectively to job performance', 'Trained employees may leave for competitors', 'Content quickly becomes outdated, especially technical', 'Not all employees respond equally to training'],
    whenToUse: ['New employees need onboarding and initial training', 'New systems or processes require capability building', 'Skills gaps identified through performance management', 'Regulatory requirements mandate specific training', 'Preparing high-potential employees for advancement', 'Business transformation requires new capabilities'],
    keyTerminology: [
      KeyTerminology(term: 'Learning Management System (LMS)', definition: 'Software platform to deliver, track, and manage training content and completion'),
      KeyTerminology(term: 'Instructor-Led Training (ILT)', definition: 'Traditional classroom training with live instructor, in-person or virtual'),
      KeyTerminology(term: 'E-Learning', definition: 'Self-paced online training modules and courses'),
      KeyTerminology(term: '70-20-10 Model', definition: 'Learning framework: 70% on-the-job, 20% social/coaching, 10% formal training'),
      KeyTerminology(term: 'Training Needs Assessment', definition: 'Analysis identifying gaps between current and required capabilities'),
      KeyTerminology(term: 'Kirkpatrick Model', definition: 'Training evaluation framework: Reaction, Learning, Behavior, Results'),
    ],
  ),
  mechanicsProcess: MechanicsProcess(
    howItWorks: 'Training process begins with needs assessment identifying skill gaps. Program design develops content and delivery methods. Implementation delivers training to target audience. Evaluation measures effectiveness at multiple levels. Continuous improvement refines programs based on feedback and results.',
    stepByStepProcess: ['Step 1: Conduct training needs assessment', 'Step 2: Define learning objectives and success metrics', 'Step 3: Design curriculum and select delivery methods', 'Step 4: Develop or source content (build vs. buy)', 'Step 5: Pilot program with test group', 'Step 6: Refine based on pilot feedback', 'Step 7: Roll out to target population', 'Step 8: Track completion and gather feedback', 'Step 9: Evaluate impact on performance', 'Step 10: Update content and improve program'],
    keyPartiesInvolved: ['Learning & Development: Design and deliver programs', 'Business Leaders: Define needs and sponsor programs', 'Subject Matter Experts: Provide content expertise', 'Managers: Support application and reinforcement', 'External Vendors: Provide content and platforms', 'Employees: Participate in and apply learning'],
    documentationRequired: ['Training needs assessment and gap analysis', 'Program design documents and curricula', 'Training materials and content', 'Completion records and certifications', 'Evaluation data and feedback', 'Compliance training documentation'],
    timelineMilestones: ['New Hire: Onboarding in first 30-90 days', 'Ongoing: Annual required training completion', 'Project-Based: Training before major implementations', 'Development: Multi-year leadership programs', 'Annual: Training plan and budget cycle'],
  ),
  financialAnalysis: FinancialAnalysis(
    valuationPricing: 'Average training spend: \$1,000-\$1,500 per employee annually. Leadership programs: \$5,000-\$50,000 per participant. E-learning development: \$10,000-\$50,000 per hour of content. LMS platforms: \$5-\$15 per user per month. External programs: \$500-\$5,000 per person per course.',
    costCalculation: 'Training costs include: Content development or licensing (20-30%), delivery (facilities, instructors, travel: 30-40%), technology (LMS, tools: 10-20%), employee time (opportunity cost: 20-30%), administration (10-15%). Total cost often underestimated when time cost excluded.',
    riskFactors: ['Training doesn\'t transfer to job performance', 'Trained employees leave for competitors', 'Content becomes outdated quickly', 'Programs don\'t address actual skill gaps', 'Insufficient manager support for application', 'Compliance training failures create regulatory risk'],
    returnMetrics: ['Training Hours per Employee: Total hours / Headcount', 'Cost per Training Hour: Total spend / Hours delivered', 'Completion Rate: Completed / Enrolled', 'Satisfaction Score: Participant ratings (typically 4-5 scale)', 'Performance Impact: Pre/post performance metrics'],
    keyRatios: [
      KeyRatio(ratio: 'Training Spend / Revenue', formula: 'Total Training Cost / Revenue', interpretation: 'Training investment intensity; typically 1-3% of payroll'),
      KeyRatio(ratio: 'Training Spend per FTE', formula: 'Total Training Cost / FTEs', interpretation: 'Per-person investment; benchmark \$1,000-\$1,500'),
      KeyRatio(ratio: 'Training Hours per Employee', formula: 'Total Training Hours / FTEs', interpretation: 'Time investment; average 30-40 hours annually'),
      KeyRatio(ratio: 'E-Learning Completion Rate', formula: 'Completions / Enrollments', interpretation: 'Engagement metric; target >80% for required training'),
    ],
    breakEvenAnalysis: 'Training ROI calculation: (Performance improvement value - Training cost) / Training cost. Example: \$1,000 training cost, 5% productivity improvement for \$50K employee = \$2,500 annual value. ROI = 150%. Retention impact often larger: Replacing employee costs 50-200% of salary.',
  ),
  accountingTreatment: AccountingTreatment(
    recognitionMeasurement: 'Training costs are expensed as incurred under both US GAAP and IFRS. This includes external training fees, internal development costs, employee time, and materials. Tuition reimbursement expensed when earned. No capitalization of human capital investment.',
    journalEntries: [
      JournalEntry(debit: 'Training Expense', credit: 'Cash/Accounts Payable', description: 'External training program fees'),
      JournalEntry(debit: 'Training Expense', credit: 'Accrued Expenses', description: 'Internal training costs accrual'),
      JournalEntry(debit: 'Employee Education Expense', credit: 'Cash', description: 'Tuition reimbursement payment'),
      JournalEntry(debit: 'Conference Expense', credit: 'Cash', description: 'Professional conference registration and travel'),
    ],
    financialStatementImpact: FinancialStatementImpact(
      balanceSheet: 'Prepaid training if paid in advance for future sessions. Generally no assets recognized for training investment. Accrued liabilities for approved but unpaid education benefits.',
      incomeStatement: 'Training expense typically in SG&A or allocated to functions. May be separately disclosed for significant programs. Full period expense recognition.',
      cashFlowStatement: 'Training costs in operating activities. No investing activity treatment despite investment nature.',
    ),
    disclosureRequirements: ['Training costs not typically separately disclosed', 'May be mentioned in human capital disclosures (SEC rules)', 'Compliance training mentioned if material risk factor', 'Executive development programs in proxy for named executives'],
    ifrsVsGaap: 'Both frameworks require immediate expense for training costs. No capitalization permitted for human capital investments. IAS 38 specifically prohibits capitalization of training costs. US GAAP has no specific guidance but expense treatment standard practice.',
  ),
  strategicConsiderations: StrategicConsiderations(
    decisionCriteria: ['Alignment with strategic capability needs', 'Business case and expected performance impact', 'Build vs. buy content decisions', 'Delivery method appropriate for content and audience', 'Manager and organizational support for application', 'Measurement approach to evaluate effectiveness'],
    comparisonWithAlternatives: 'Training vs. Hiring: Training develops existing employees who know culture; hiring brings external perspectives but cultural risk. vs. Automation: Technology may eliminate need for certain skills. vs. Outsourcing: External experts may be more efficient than building internal capability.',
    impactOnFinancialPosition: 'Training expense reduces operating income. Effective training improves productivity, quality, and retention, improving long-term financial performance. Returns difficult to measure directly but correlation with employee and business outcomes well-established.',
    commonMistakes: ['Training without clear needs assessment or objectives', 'One-time events without reinforcement', 'Classroom-only without application support', 'Ignoring manager\'s role in learning transfer', 'Measuring only completion, not impact', 'Cutting training first during cost reduction'],
    bestPractices: ['Align training investments with strategic priorities', 'Use blended approach (digital + live + on-the-job)', 'Engage managers in reinforcement and application', 'Measure impact at multiple levels (Kirkpatrick)', 'Create continuous learning culture', 'Leverage technology for scale and accessibility'],
  ),
  practicalApplication: PracticalApplication(
    realWorldExample: 'AT&T Future Ready Initiative (2013-2020): Faced skills obsolescence as telecom shifted to software and data. Invested \$1B+ to retrain 140,000 employees through online courses, degrees, and nanodegrees. Partnership with Udacity created technology curriculum. Demonstrates large-scale reskilling as alternative to replacing workforce.',
    calculationExample: 'Training ROI Calculation: Leadership program: 20 participants × \$10,000 = \$200,000 investment. If 50% of participants promoted (vs. 30% baseline), and promotion improves retention by 2 years at \$150K replacement cost: 10 × 20% × \$150K = \$300K retention value. ROI = (\$300K - \$200K) / \$200K = 50%. Plus productivity gains from better leadership.',
    caseStudy: 'Toyota Production System Training: Toyota\'s success built on rigorous training in TPS principles and problem-solving methods. New employees undergo months of training before assignment. Managers developed through progressive responsibilities. Result: Superior quality, efficiency, and continuous improvement culture. Demonstrates long-term competitive advantage through training investment.',
    industryVariations: ['Healthcare: Clinical certifications, continuing education requirements', 'Financial Services: Licensing, compliance, regulatory training', 'Technology: Rapidly evolving technical skills, certifications', 'Manufacturing: Safety, quality, equipment-specific training', 'Retail/Service: Customer service, product knowledge, soft skills'],
    regulatoryConsiderations: ['OSHA: Safety training requirements', 'Industry Licensing: Professional certifications (CPA, nursing, etc.)', 'Financial Services: FINRA, insurance licensing requirements', 'Healthcare: Continuing education for licensure', 'Privacy: Data protection training requirements (GDPR)', 'Anti-harassment: Many jurisdictions require workplace training'],
  ),
);

const bondIssuanceContent = ScenarioEducationalContent(
  coreFramework: CoreFramework(
    definitionOverview: 'A bond is a fixed-income debt instrument representing a loan made by investors to a borrower (corporation or government). Corporate bonds are long-term debt securities that obligate the issuer to pay periodic interest (coupon) and return principal at maturity. They provide access to capital markets for amounts and terms often unavailable from banks.',
    keyCharacteristics: ['Fixed maturity date (typically 5-30 years for corporate bonds)', 'Stated interest rate (coupon) paid semi-annually', 'Face/par value (typically \$1,000) returned at maturity', 'Traded in secondary markets providing liquidity', 'Credit ratings from agencies (Moody\'s, S&P, Fitch) influence pricing', 'May include call provisions, sinking funds, or conversion features'],
    typesClassifications: ['Senior Secured Bonds: Backed by specific collateral, highest recovery priority', 'Senior Unsecured Bonds: No collateral but senior in capital structure', 'Subordinated/Junior Bonds: Lower priority, higher yield', 'Convertible Bonds: Can convert to equity at holder\'s option', 'Callable Bonds: Issuer can redeem before maturity', 'High-Yield (Junk) Bonds: Below investment grade, higher risk/return', 'Green/Sustainable Bonds: Proceeds for environmental projects'],
    advantages: ['Access to large amounts of capital (\$100M to billions)', 'Fixed interest rate provides cost certainty', 'No dilution of equity ownership', 'Interest payments are tax-deductible', 'Fewer restrictive covenants than bank loans typically', 'Diversified investor base reduces concentration risk', 'Long maturities match long-term investments'],
    disadvantages: ['Fixed obligations regardless of business performance', 'Significant issuance costs (2-3% of proceeds)', 'Ongoing disclosure and compliance requirements', 'May include restrictive covenants limiting flexibility', 'Credit rating downgrades increase borrowing costs', 'Refinancing risk at maturity', 'Call provisions may require premium if rates fall'],
    whenToUse: ['Funding large, long-term capital projects', 'Refinancing existing debt at lower rates', 'When bank credit markets are constrained', 'Achieving more favorable terms than bank lending', 'Diversifying funding sources away from banks', 'Establishing presence in capital markets'],
    keyTerminology: [
      KeyTerminology(term: 'Coupon Rate', definition: 'Annual interest rate stated on bond, expressed as percentage of face value'),
      KeyTerminology(term: 'Yield to Maturity (YTM)', definition: 'Total return if bond held to maturity, including coupon and price gain/loss'),
      KeyTerminology(term: 'Credit Spread', definition: 'Yield premium over risk-free Treasury bonds reflecting credit risk'),
      KeyTerminology(term: 'Indenture', definition: 'Legal contract between issuer and bondholders specifying terms and covenants'),
      KeyTerminology(term: 'Trustee', definition: 'Third party (usually bank) protecting bondholder interests'),
      KeyTerminology(term: 'Call Provision', definition: 'Issuer\'s right to redeem bonds before maturity at specified price'),
    ],
  ),
  mechanicsProcess: MechanicsProcess(
    howItWorks: 'The company works with investment banks to structure, rate, and market the bond issue. After filing required documentation with securities regulators, the bonds are marketed to institutional investors, priced based on demand and comparable bonds, and issued through a syndicate of banks. Interest is paid semi-annually and principal returned at maturity.',
    stepByStepProcess: ['1. Internal Approval: Board authorizes bond issuance', '2. Underwriter Selection: Engage investment bank(s) as lead manager', '3. Structure Design: Determine amount, maturity, covenants, features', '4. Credit Rating: Engage rating agencies for credit assessment', '5. Documentation: Prepare indenture, prospectus, offering circular', '6. SEC Registration: File registration statement (Rule 144A for private)', '7. Marketing: Roadshow to institutional investors', '8. Book Building: Collect investor orders to determine demand curve', '9. Pricing: Set coupon and price based on demand and market conditions', '10. Closing: Execute documents, receive proceeds, issue bonds'],
    keyPartiesInvolved: ['Issuer: Company borrowing funds', 'Lead Underwriter: Investment bank managing the offering', 'Syndicate Members: Other banks helping distribute', 'Rating Agencies: Moody\'s, S&P, Fitch assess credit risk', 'Trustee: Bank representing bondholder interests', 'Legal Counsel: For issuer, underwriters, and trustee', 'Institutional Investors: Insurance companies, pension funds, asset managers'],
    documentationRequired: ['Indenture: Master contract governing bond terms', 'Prospectus/Offering Circular: Disclosure document for investors', 'Underwriting Agreement: Terms with investment banks', 'Trustee Agreement: Appointment of bondholder representative', 'Legal Opinions: Counsel opinions on validity and enforceability', 'Comfort Letters: Auditor letters on financial statements', 'Rating Letters: Credit rating assignments'],
    timelineMilestones: ['Week 1-2: Mandate underwriters, begin due diligence', 'Week 2-4: Structure bond and prepare documentation', 'Week 4-6: Obtain credit ratings', 'Week 6-8: Marketing and investor education', 'Week 8: Announce transaction, begin book building', 'Week 8-9: Price and close transaction'],
  ),
  financialAnalysis: FinancialAnalysis(
    valuationPricing: 'Bond price = Present value of future cash flows (coupons + principal) discounted at yield to maturity. Yield = Comparable Treasury yield + Credit Spread. Credit spread determined by rating, industry, market conditions. Investment grade spreads: 75-300 bps. High yield: 300-800+ bps.',
    costCalculation: 'All-in cost includes: Coupon rate (ongoing), Underwriting fees (1.5-3% upfront), Legal/rating fees (\$1-3M), Ongoing trustee/compliance costs. Example: \$500M 10-year bond at 6% coupon, 2% underwriting = \$10M upfront fees, \$30M annual interest, total 10-year cost ≈ \$310M.',
    riskFactors: ['Interest Rate Risk: Rising rates reduce bond value and increase refinancing costs', 'Credit Risk: Rating downgrade increases spread and reduces value', 'Refinancing Risk: May not be able to refinance at acceptable rates', 'Call Risk: If rates fall, investors face reinvestment risk', 'Covenant Risk: Restrictions may limit operational flexibility', 'Event Risk: M&A or restructuring may trigger puts or downgrades'],
    returnMetrics: ['Yield to Maturity (YTM): Total return if held to maturity', 'Current Yield: Annual coupon / Current price', 'Yield to Call: Return if called at first call date', 'Spread to Treasury: Risk premium over government bonds'],
    keyRatios: [
      KeyRatio(ratio: 'Interest Coverage Ratio', formula: 'EBIT / Interest Expense', interpretation: 'Ability to pay interest; investment grade typically >3x'),
      KeyRatio(ratio: 'Debt/EBITDA', formula: 'Total Debt / EBITDA', interpretation: 'Leverage measure; investment grade typically <3x'),
      KeyRatio(ratio: 'FFO/Debt', formula: 'Funds From Operations / Total Debt', interpretation: 'Cash generation relative to debt; higher is better'),
      KeyRatio(ratio: 'Debt/Capitalization', formula: 'Debt / (Debt + Equity)', interpretation: 'Capital structure leverage; typically 30-60% for investment grade'),
    ],
    breakEvenAnalysis: 'Bond financing creates value when the after-tax cost of debt is less than the return on invested capital. Break-even: ROIC = After-tax cost of debt. Example: 6% coupon, 25% tax rate = 4.5% after-tax cost. If projects earn 10% ROIC, each \$1 borrowed creates \$0.055 value annually.',
  ),
  accountingTreatment: AccountingTreatment(
    recognitionMeasurement: 'Initially recorded at net proceeds (face value plus premium or minus discount and issuance costs). Subsequently measured at amortized cost using effective interest method. Premium/discount amortized over bond term.',
    journalEntries: [
      JournalEntry(debit: 'Cash (Net Proceeds)', credit: 'Bonds Payable (Face Value)', description: 'Record bond issuance at par'),
      JournalEntry(debit: 'Cash', credit: 'Premium on Bonds Payable', description: 'If issued above par'),
      JournalEntry(debit: 'Discount on Bonds Payable', credit: 'Bonds Payable', description: 'If issued below par (contra-liability)'),
      JournalEntry(debit: 'Interest Expense', credit: 'Cash / Interest Payable', description: 'Record periodic interest payment'),
      JournalEntry(debit: 'Premium on Bonds', credit: 'Interest Expense', description: 'Amortize premium (reduces interest expense)'),
    ],
    financialStatementImpact: FinancialStatementImpact(
      balanceSheet: 'Long-term liabilities increase by face value (adjusted for premium/discount). Cash increases by net proceeds. Deferred financing costs may appear as asset (under old rules) or contra-liability (current rules).',
      incomeStatement: 'Interest expense recognized using effective interest method. Premium amortization reduces interest expense; discount amortization increases it. Tax benefit from interest deductibility.',
      cashFlowStatement: 'Proceeds shown in Financing Activities. Interest payments in Operating Activities (US GAAP). Principal repayment at maturity in Financing Activities.',
    ),
    disclosureRequirements: ['Face amount, coupon rate, maturity date', 'Fair value of outstanding bonds', 'Future principal payments by year', 'Description of significant covenants', 'Collateral pledged, if any', 'Credit facility availability and terms'],
    ifrsVsGaap: 'Both use amortized cost for bonds not designated at fair value. Key differences: (1) IFRS requires issuance costs as deduction from liability; US GAAP historically allowed asset treatment (now converged). (2) IFRS allows interest in operating or financing cash flow; US GAAP requires operating. (3) Fair value option available under both but with different election mechanics.',
  ),
  strategicConsiderations: StrategicConsiderations(
    decisionCriteria: ['Funding Amount: Bonds efficient for large amounts (\$100M+)', 'Maturity: Match bond term to asset/project life', 'Rate Environment: Fixed rate attractive when rates expected to rise', 'Credit Profile: Strong credits access better terms', 'Market Conditions: Bond market receptivity varies', 'Flexibility: Consider call provisions if rates may fall'],
    comparisonWithAlternatives: 'vs. Bank Loans: Bonds offer larger amounts, longer terms, but less flexibility and higher fixed costs. vs. Equity: Bonds avoid dilution but create fixed obligations. vs. Private Placement: Faster execution but potentially higher rates. vs. Convertibles: Lower coupon but eventual dilution.',
    impactOnFinancialPosition: 'Increases long-term debt and leverage ratios. Cash increases from proceeds. Interest expense reduces net income. Tax shield creates value. Credit metrics (coverage, leverage) affected. May limit future borrowing capacity.',
    commonMistakes: ['Issuing fixed-rate bonds when rates are near cycle peaks', 'Excessive leverage leading to rating downgrade', 'Covenant structures that become restrictive during downturns', 'Not including call provisions when advantageous', 'Mismatched maturities between assets and liabilities', 'Underestimating ongoing compliance costs'],
    bestPractices: ['Maintain investment grade rating if possible (lower cost)', 'Ladder maturities to avoid concentration of refinancing risk', 'Include appropriate call provisions for flexibility', 'Build relationships with bond investors before issuance', 'Monitor covenant compliance continuously', 'Maintain diversified funding sources'],
  ),
  practicalApplication: PracticalApplication(
    realWorldExample: 'Apple\'s Bond Program: Despite \$200B+ cash, Apple issues bonds regularly due to tax efficiency (repatriating foreign cash triggered taxes pre-2017). 2013-2020 issued \$100B+ bonds at rates from 1-4%. Demonstrates that even cash-rich companies use debt strategically.',
    calculationExample: 'Company issues \$100M 10-year bond at 5.5% coupon, sold at 98 (2% discount). Proceeds = \$98M. Annual interest = \$5.5M. Effective rate (simplified): (\$5.5M + \$0.2M discount amortization) / \$98M ≈ 5.82%. After-tax cost at 25% rate = 5.82% × 0.75 = 4.37%.',
    caseStudy: 'Pacific Gas & Electric Bankruptcy (2019): Despite investment grade ratings, wildfires created massive liabilities. Bond prices collapsed as default risk spiked. Emerged from bankruptcy in 2020 with restructured debt. Lessons: (1) Event risk can overwhelm credit metrics; (2) Utility bonds thought safe can face catastrophic risk; (3) ESG risks increasingly material.',
    industryVariations: ['Utilities: Heavy bond users with regulated, stable cash flows', 'REITs: Frequent issuers to match long-term property investments', 'Technology: Less reliant on bonds historically, now major issuers', 'Airlines: High yield often due to cyclicality and leverage', 'Healthcare: Investment grade typical for large systems'],
    regulatoryConsiderations: ['SEC Registration: Required for public offerings (Form S-3 common)', 'Rule 144A: Private placements to qualified institutional buyers', 'Trust Indenture Act: Requirements for public bond indentures', 'Rating Agency Regulation: Dodd-Frank requirements for NRSROs', 'Blue Sky Laws: State securities compliance', 'Tax Regulations: Interest deductibility limitations (Section 163(j))'],
  ),
);

const qualityControlContent = ScenarioEducationalContent(
  coreFramework: CoreFramework(
    definitionOverview: 'Quality control (QC) and quality management systems involve systematic processes to ensure products or services meet specified requirements and standards. This encompasses quality assurance (QA), quality control, continuous improvement, and compliance with industry standards like ISO 9001, Six Sigma, or industry-specific certifications.',
    keyCharacteristics: ['Systematic approach to preventing and detecting defects', 'Standards-based framework (ISO 9001, AS9100, IATF 16949)', 'Statistical process control and measurement', 'Documentation and traceability requirements', 'Continuous improvement philosophy (PDCA cycle)', 'Customer focus and satisfaction measurement'],
    typesClassifications: ['ISO 9001: General quality management system standard', 'ISO 14001: Environmental management systems', 'Six Sigma: Data-driven defect reduction methodology', 'Lean Manufacturing: Waste elimination and efficiency', 'Total Quality Management (TQM): Organization-wide quality culture', 'Industry-Specific: AS9100 (aerospace), IATF 16949 (automotive), GMP (pharmaceuticals)'],
    advantages: ['Reduced defect rates and rework costs', 'Improved customer satisfaction and loyalty', 'Access to quality-conscious customers and contracts', 'Reduced warranty and liability costs', 'Operational efficiency through process standardization', 'Competitive advantage and market differentiation', 'Employee engagement through clear standards'],
    disadvantages: ['Significant implementation and certification costs', 'Ongoing audit and maintenance expenses', 'Administrative burden of documentation', 'Potential rigidity in processes', 'Training time and productivity loss during implementation', 'Risk of \'checkbox compliance\' vs. true quality culture'],
    whenToUse: ['Entering markets requiring quality certifications', 'Bidding on government or large corporate contracts', 'High defect rates impacting profitability', 'Customer complaints affecting reputation', 'Scaling operations while maintaining consistency', 'Regulatory requirements mandate quality systems'],
    keyTerminology: [
      KeyTerminology(term: 'Conformance', definition: 'Meeting specified requirements and standards'),
      KeyTerminology(term: 'Nonconformance', definition: 'Failure to meet requirements; triggers corrective action'),
      KeyTerminology(term: 'CAPA', definition: 'Corrective and Preventive Action - systematic problem resolution'),
      KeyTerminology(term: 'Audit', definition: 'Systematic examination of quality system effectiveness'),
      KeyTerminology(term: 'Process Capability (Cp/Cpk)', definition: 'Statistical measure of process ability to meet specifications'),
      KeyTerminology(term: 'Control Chart', definition: 'Statistical tool monitoring process variation over time'),
    ],
  ),
  mechanicsProcess: MechanicsProcess(
    howItWorks: 'Quality management systems establish documented procedures for all key processes, define quality metrics and acceptance criteria, implement inspection and testing protocols, track nonconformances and corrective actions, and require periodic internal and external audits to verify compliance and drive continuous improvement.',
    stepByStepProcess: ['1. Gap Analysis: Assess current state vs. standard requirements', '2. Management Commitment: Secure leadership support and resources', '3. Quality Policy: Define quality objectives and policy', '4. Process Mapping: Document all key processes and procedures', '5. Training: Educate workforce on quality requirements', '6. Implementation: Deploy quality management system', '7. Internal Audits: Verify compliance and identify gaps', '8. Corrective Actions: Address nonconformances', '9. Management Review: Leadership assessment of QMS effectiveness', '10. Certification Audit: Third-party assessment for certification'],
    keyPartiesInvolved: ['Quality Manager: Overall QMS responsibility', 'Process Owners: Responsible for process compliance', 'Internal Auditors: Conduct compliance verification', 'Certification Body: Third-party auditors (ISO registrar)', 'Top Management: Resource allocation and review', 'All Employees: Quality execution in daily work'],
    documentationRequired: ['Quality Manual: Overarching QMS description', 'Procedures: Detailed process instructions', 'Work Instructions: Step-by-step task guidance', 'Quality Records: Evidence of conformance', 'Audit Reports: Internal and external findings', 'CAPA Records: Problem resolution documentation', 'Training Records: Competency verification'],
    timelineMilestones: ['Month 1-2: Gap analysis and planning', 'Month 3-6: Documentation development', 'Month 7-9: Implementation and training', 'Month 10-11: Internal audits and corrections', 'Month 12: Certification audit', 'Ongoing: Surveillance audits (annually)'],
  ),
  financialAnalysis: FinancialAnalysis(
    valuationPricing: 'Quality investments valued through Cost of Quality (COQ) analysis: Prevention costs (training, planning) + Appraisal costs (inspection, testing) + Internal failure costs (scrap, rework) + External failure costs (warranty, returns, reputation). Optimal quality investment minimizes total COQ.',
    costCalculation: 'Implementation: ISO 9001 certification typically \$15,000-\$50,000 for SMEs including consulting, training, and audit fees. Annual maintenance: \$5,000-\$15,000 for surveillance audits. Internal costs: Quality staff salaries, testing equipment, documentation systems.',
    riskFactors: ['Implementation fails to achieve cultural change', 'Certification achieved but quality not improved', 'Excessive documentation burden impacts productivity', 'Customer expectations exceed certified standard', 'Loss of certification due to audit failures', 'Competitive pressure requires higher standards'],
    returnMetrics: ['Cost of Quality (COQ) as % of revenue', 'Defects per million opportunities (DPMO)', 'First Pass Yield (FPY)', 'Customer satisfaction scores', 'Warranty costs as % of sales', 'Audit findings per audit'],
    keyRatios: [
      KeyRatio(ratio: 'Cost of Quality Ratio', formula: 'Total COQ / Revenue × 100', interpretation: 'Best-in-class: <2%; average: 5-15%; poor: >20%'),
      KeyRatio(ratio: 'First Pass Yield', formula: 'Good Units / Total Units × 100', interpretation: 'Higher is better; world-class >99%'),
      KeyRatio(ratio: 'Defect Rate', formula: 'Defective Units / Total Units × 1,000,000', interpretation: 'Six Sigma target: 3.4 DPMO'),
      KeyRatio(ratio: 'Customer Complaint Rate', formula: 'Complaints / Units Sold × 1,000', interpretation: 'Lower is better; track trends'),
    ],
    breakEvenAnalysis: 'Quality investment breaks even when reduction in failure costs exceeds prevention and appraisal investment. Example: \$100K quality program reduces warranty costs by \$150K and rework by \$80K = \$130K net benefit. ROI = 130%.',
  ),
  accountingTreatment: AccountingTreatment(
    recognitionMeasurement: 'Quality system implementation costs typically expensed as incurred. Certification fees expensed. Quality-related equipment capitalized and depreciated. Training costs expensed. Warranty provisions based on historical defect rates and estimated repair costs.',
    journalEntries: [
      JournalEntry(debit: 'Quality System Expense', credit: 'Cash/Accounts Payable', description: 'Certification and consulting fees'),
      JournalEntry(debit: 'Training Expense', credit: 'Cash', description: 'Quality training program costs'),
      JournalEntry(debit: 'Quality Equipment (Asset)', credit: 'Cash', description: 'Testing and inspection equipment'),
      JournalEntry(debit: 'Warranty Expense', credit: 'Warranty Liability', description: 'Provision for estimated warranty claims'),
      JournalEntry(debit: 'Warranty Liability', credit: 'Cash/Inventory', description: 'Actual warranty claim settlement'),
    ],
    financialStatementImpact: FinancialStatementImpact(
      balanceSheet: 'Quality equipment added to PP&E. Warranty liability increases current liabilities. Working capital may decrease during implementation phase.',
      incomeStatement: 'Implementation costs reduce operating income initially. Reduced defect and warranty costs improve margins over time. Quality labor costs in operating expenses.',
      cashFlowStatement: 'Implementation costs in operating activities. Equipment purchases in investing activities. Expected cash flow improvement from reduced defect costs.',
    ),
    disclosureRequirements: ['Warranty policies and provisions', 'Product quality-related contingent liabilities', 'Research and development related to quality', 'Environmental compliance costs (if ISO 14001)', 'Regulatory compliance status'],
    ifrsVsGaap: 'Generally consistent treatment. Warranty provisions: Both require provisions based on best estimates. Development costs: IFRS may allow capitalization of certain quality system development; US GAAP typically expenses. Contingent liabilities: Similar recognition thresholds.',
  ),
  strategicConsiderations: StrategicConsiderations(
    decisionCriteria: ['Customer Requirements: Do key customers require certification?', 'Market Access: Does certification open new markets?', 'Defect Costs: Are quality problems causing significant losses?', 'Competitive Position: Are competitors certified?', 'Regulatory: Are quality systems mandated?', 'Culture: Is organization ready for quality discipline?'],
    comparisonWithAlternatives: 'ISO 9001 provides general framework; Six Sigma focuses on defect reduction with statistical rigor; Lean emphasizes waste elimination; TQM is cultural/philosophical. Many organizations combine approaches. Industry-specific standards (AS9100, IATF) build on ISO 9001 with additional requirements.',
    impactOnFinancialPosition: 'Short-term: Increased operating costs for implementation. Long-term: Improved margins from reduced defects, warranty savings, and premium pricing. Working capital improvement from reduced rework and scrap.',
    commonMistakes: ['Treating certification as end goal vs. continuous improvement', 'Excessive documentation without practical value', 'Failing to engage frontline employees', 'Quality as quality department\'s job vs. everyone\'s responsibility', 'Ignoring cost of quality metrics', 'Not integrating quality into strategic planning'],
    bestPractices: ['Start with leadership commitment and quality culture', 'Use cost of quality to prioritize improvements', 'Engage employees through quality circles and suggestions', 'Integrate quality metrics into performance management', 'Benchmark against best-in-class competitors', 'Balance documentation with practical utility'],
  ),
  practicalApplication: PracticalApplication(
    realWorldExample: 'Toyota Production System: Pioneered quality at source, stopping the production line (andon) when defects detected. Result: Industry-leading quality and efficiency. Concepts like kaizen (continuous improvement) and jidoka (automation with human touch) became global manufacturing standards.',
    calculationExample: 'Manufacturing plant analysis: Revenue \$10M, Current COQ: Prevention \$50K, Appraisal \$100K, Internal Failure \$200K, External Failure \$150K = Total COQ \$500K (5%). After ISO implementation: Prevention \$100K (+\$50K), Appraisal \$120K (+\$20K), Internal Failure \$80K (-\$120K), External Failure \$50K (-\$100K) = New COQ \$350K (3.5%). Net savings: \$150K annually.',
    caseStudy: 'Motorola Six Sigma (1986): Facing Japanese competition, Motorola invented Six Sigma methodology targeting 3.4 defects per million. Saved \$16 billion over 15 years. Methodology spread to GE, Allied Signal, and became standard corporate practice. Demonstrates transformative impact of systematic quality improvement.',
    industryVariations: ['Automotive: IATF 16949 mandatory for OEM suppliers', 'Aerospace: AS9100 required for aviation supply chain', 'Medical Devices: ISO 13485 and FDA requirements', 'Pharmaceuticals: GMP (Good Manufacturing Practice)', 'Food: HACCP, ISO 22000, FSSC 22000', 'Construction: ISO 9001 increasingly required for contracts'],
    regulatoryConsiderations: ['FDA: Quality System Regulation (21 CFR Part 820) for medical devices', 'FAA: Quality requirements for aviation products', 'EU: CE marking requires quality management', 'Auto Industry: OEM-mandated quality standards', 'Government Contracts: Often require ISO certification', 'Export Markets: Some countries require quality certification'],
  ),
);

const customerServiceContent = ScenarioEducationalContent(
  coreFramework: CoreFramework(
    definitionOverview: 'Customer service encompasses all interactions and support provided to customers before, during, and after purchase. This includes complaint handling, technical support, account management, and service recovery. Effective customer service builds loyalty, reduces churn, and generates positive word-of-mouth.',
    keyCharacteristics: ['Multi-channel accessibility (phone, email, chat, social media)', 'Timeliness and responsiveness to customer needs', 'First-contact resolution emphasis', 'Empowerment of service representatives', 'Systematic complaint tracking and resolution', 'Integration with CRM and business processes'],
    typesClassifications: ['Reactive Support: Responding to customer-initiated contacts', 'Proactive Support: Reaching out before problems occur', 'Self-Service: Knowledge bases, FAQs, chatbots', 'Technical Support: Product troubleshooting and assistance', 'Account Management: Dedicated support for key accounts', 'Service Recovery: Systematic approach to handling failures'],
    advantages: ['Increased customer retention and lifetime value', 'Positive word-of-mouth and referrals', 'Competitive differentiation through service excellence', 'Valuable feedback for product/service improvement', 'Reduced negative reviews and reputation damage', 'Cross-selling and upselling opportunities'],
    disadvantages: ['Significant labor costs for quality service', 'Training and turnover challenges', 'Difficult to scale personalized service', 'Customer expectations continuously rising', 'Negative interactions have outsized impact', '24/7 coverage requirements for global customers'],
    whenToUse: ['Customer complaints affecting retention', 'Competitive differentiation needed beyond product', 'Complex products requiring support', 'High customer lifetime value justifies investment', 'Brand reputation requires protection', 'Service recovery can prevent churn'],
    keyTerminology: [
      KeyTerminology(term: 'CSAT', definition: 'Customer Satisfaction Score - direct measure of satisfaction'),
      KeyTerminology(term: 'NPS', definition: 'Net Promoter Score - likelihood to recommend'),
      KeyTerminology(term: 'FCR', definition: 'First Contact Resolution - issues resolved in single interaction'),
      KeyTerminology(term: 'AHT', definition: 'Average Handle Time - duration of customer interactions'),
      KeyTerminology(term: 'SLA', definition: 'Service Level Agreement - committed response/resolution times'),
      KeyTerminology(term: 'Churn Rate', definition: 'Percentage of customers lost over time period'),
    ],
  ),
  mechanicsProcess: MechanicsProcess(
    howItWorks: 'Customer service operations receive customer contacts through multiple channels, route them to appropriate agents, track interactions in CRM systems, resolve issues following defined procedures, escalate complex cases, and measure performance against service standards.',
    stepByStepProcess: ['1. Contact Receipt: Customer reaches out via channel of choice', '2. Identification: Verify customer and retrieve account information', '3. Issue Classification: Categorize problem type and severity', '4. Resolution Attempt: Agent works to resolve on first contact', '5. Escalation: Route to specialized team if needed', '6. Resolution: Implement solution and verify satisfaction', '7. Documentation: Record interaction and resolution in CRM', '8. Follow-up: Confirm satisfaction and close ticket', '9. Analysis: Review trends and identify improvements', '10. Process Improvement: Update procedures based on learnings'],
    keyPartiesInvolved: ['Customer Service Representatives: Front-line agents', 'Team Leaders/Supervisors: Escalation and coaching', 'Quality Assurance: Monitor and score interactions', 'Training Team: Develop agent capabilities', 'Workforce Management: Schedule and capacity planning', 'IT/Systems: Maintain CRM and telephony infrastructure'],
    documentationRequired: ['Service Standards and SLAs: Performance targets', 'Knowledge Base: Solutions and procedures', 'Call Scripts/Guidelines: Interaction frameworks', 'Escalation Procedures: When and how to escalate', 'Quality Scorecards: Evaluation criteria', 'Training Materials: Agent development resources'],
    timelineMilestones: ['Initial Response: Per SLA (often <1 hour for urgent)', 'Issue Resolution: Per complexity tier (hours to days)', 'Escalation Review: Within 4-24 hours', 'Quality Review: Within 48 hours of interaction', 'Customer Survey: 1-3 days post-resolution', 'Trend Analysis: Weekly/monthly reviews'],
  ),
  financialAnalysis: FinancialAnalysis(
    valuationPricing: 'Customer service value = Retention improvement × Customer Lifetime Value + Word-of-mouth value + Cross-sell/upsell revenue - Service costs. Calculate cost per contact and compare to customer value at risk from poor service.',
    costCalculation: 'Cost per contact varies by channel: Phone \$6-12, Email \$5-8, Chat \$3-5, Self-service \$0.10-0.50. Fully-loaded agent cost: \$40,000-\$60,000/year including benefits, training, technology. Contact center overhead: 25-40% of direct labor.',
    riskFactors: ['High turnover increasing training costs', 'Channel shift to expensive channels', 'Rising customer expectations', 'Social media amplification of failures', 'Regulatory requirements (GDPR, accessibility)', 'Technology disruption requiring investment'],
    returnMetrics: ['Customer Lifetime Value impact', 'Retention rate improvement', 'Cost per resolution', 'Revenue from service interactions', 'Net Promoter Score change', 'Complaint-to-compliment ratio'],
    keyRatios: [
      KeyRatio(ratio: 'Cost per Contact', formula: 'Total Service Costs / Number of Contacts', interpretation: 'Lower is better; benchmark against industry'),
      KeyRatio(ratio: 'First Contact Resolution', formula: 'Issues Resolved First Contact / Total Issues × 100', interpretation: 'Target: 70-80%; world-class: >85%'),
      KeyRatio(ratio: 'Customer Effort Score', formula: 'Survey-based (1-5 scale)', interpretation: 'Lower effort = higher satisfaction'),
      KeyRatio(ratio: 'Service Cost Ratio', formula: 'Service Costs / Revenue × 100', interpretation: 'Varies by industry; typically 2-10%'),
    ],
    breakEvenAnalysis: 'Service investment justified when: Cost of service < (Churn reduction × CLV) + (Referral value). Example: \$500K annual service investment prevents 100 churns with \$10K CLV each = \$1M value preserved. ROI = 100%.',
  ),
  accountingTreatment: AccountingTreatment(
    recognitionMeasurement: 'Customer service costs expensed as incurred. Service contract revenue recognized over contract term. Warranty service costs matched to related product revenue. Customer support technology may be capitalized if meeting asset criteria.',
    journalEntries: [
      JournalEntry(debit: 'Customer Service Expense', credit: 'Salaries Payable', description: 'Agent salaries and benefits'),
      JournalEntry(debit: 'Technology Expense', credit: 'Cash/Accounts Payable', description: 'CRM and telephony costs'),
      JournalEntry(debit: 'Warranty Expense', credit: 'Warranty Liability', description: 'Provision for warranty service'),
      JournalEntry(debit: 'Deferred Revenue', credit: 'Service Revenue', description: 'Recognize support contract revenue'),
      JournalEntry(debit: 'Customer Goodwill Expense', credit: 'Inventory/Cash', description: 'Service recovery gestures'),
    ],
    financialStatementImpact: FinancialStatementImpact(
      balanceSheet: 'Support contracts create deferred revenue liability. Warranty provisions in current liabilities. CRM systems may be capitalized assets.',
      incomeStatement: 'Service costs in operating expenses. Support contract revenue recognized over time. Warranty costs matched to product revenue.',
      cashFlowStatement: 'Service costs in operating activities. Technology investments in investing activities. Support contract cash receipts may precede revenue recognition.',
    ),
    disclosureRequirements: ['Warranty policies and provisions', 'Deferred revenue from support contracts', 'Service-related contingent liabilities', 'Revenue recognition policies for service', 'Customer concentration risks'],
    ifrsVsGaap: 'Largely consistent treatment. Revenue recognition: Both require allocation of transaction price to performance obligations (IFRS 15/ASC 606). Warranty: Both distinguish between assurance-type (accrued) and service-type (deferred revenue). Minor differences in presentation.',
  ),
  strategicConsiderations: StrategicConsiderations(
    decisionCriteria: ['Customer Value: High CLV justifies premium service', 'Competitive Position: Is service a differentiator?', 'Product Complexity: Complex products need more support', 'Channel Preferences: Match customer communication preferences', 'Cost Structure: Balance service quality with efficiency', 'Brand Promise: Service must align with brand positioning'],
    comparisonWithAlternatives: 'In-house vs. Outsourced: In-house offers more control and brand consistency; outsourcing reduces costs and provides scalability. Channels: Phone is personal but expensive; digital is efficient but less personal. AI/chatbots handle routine queries at low cost but frustrate complex issues.',
    impactOnFinancialPosition: 'Service excellence improves retention and lifetime value. High service costs reduce short-term margins. Brand value and goodwill enhanced by service reputation. Competitive position strengthened through service differentiation.',
    commonMistakes: ['Measuring efficiency over effectiveness (AHT over satisfaction)', 'Underinvesting in agent training and empowerment', 'Ignoring digital/self-service channel development', 'Failing to close the loop on customer feedback', 'Treating service as cost center vs. value creator', 'Not integrating service data with product development'],
    bestPractices: ['Empower agents to resolve issues without excessive escalation', 'Invest in knowledge management and self-service', 'Balance efficiency metrics with quality/satisfaction', 'Use customer feedback to improve products/processes', 'Recognize and reward service excellence', 'Design service recovery processes for inevitable failures'],
  ),
  practicalApplication: PracticalApplication(
    realWorldExample: 'Zappos Customer Service: Famous for empowering agents (no call time limits, surprise upgrades, handwritten notes). Built reputation enabling premium pricing and customer loyalty. Acquired by Amazon for \$1.2B, with customer service as key asset. Demonstrates service as competitive advantage.',
    calculationExample: 'Service investment analysis: Current state: 5,000 customers, 10% annual churn (500 lost), CLV \$2,000 = \$1M annual lost value. After service improvement: \$200K investment, churn reduced to 7% (350 lost), \$700K lost value. Net benefit: \$300K - \$200K = \$100K plus improved NPS and referrals.',
    caseStudy: 'United Airlines Guitar Incident (2009): Passenger\'s guitar damaged, poor service response led to viral video \'United Breaks Guitars\' with 20M+ views. Stock dropped 10% (\$180M). Demonstrates asymmetric risk of service failures in social media age. United subsequently invested heavily in service improvement.',
    industryVariations: ['Airlines: Service recovery critical for loyalty; operational complexity', 'Banking: Regulatory requirements; high trust/security needs', 'Technology: Technical complexity; self-service emphasis', 'Retail: Returns processing; omnichannel consistency', 'Healthcare: Privacy requirements; empathetic communication', 'Telecom: High volume; retention focus'],
    regulatoryConsiderations: ['Consumer Protection: Fair treatment and disclosure requirements', 'Privacy: GDPR, CCPA requirements for handling customer data', 'Accessibility: ADA requirements for service channels', 'Financial Services: Specific complaint handling requirements', 'Recording Consent: Laws vary by jurisdiction for call recording', 'Language Requirements: Multi-language requirements in some markets'],
  ),
);

const facilityConstructionContent = ScenarioEducationalContent(
  coreFramework: CoreFramework(
    definitionOverview: 'Facility construction involves building new factories, offices, warehouses, or other operational buildings. This represents major capital investment with long-term implications for operational capacity, efficiency, and strategic positioning. Projects require significant planning, financing, and project management expertise.',
    keyCharacteristics: ['Large capital outlay with multi-year payback', 'Long construction timeline (12-36 months typical)', 'Location decision is critical and difficult to reverse', 'Requires coordination of multiple stakeholders', 'Subject to zoning, permits, and regulatory approvals', 'Often financed through project-specific debt or leases'],
    typesClassifications: ['Manufacturing Facility: Production plants and factories', 'Distribution Center: Warehouses and logistics hubs', 'Office Building: Corporate and administrative space', 'Data Center: IT infrastructure facilities', 'Research Facility: R&D and laboratory buildings', 'Mixed-Use: Combined manufacturing, office, warehouse'],
    advantages: ['Customized facility design for operational needs', 'Increased production/operational capacity', 'Strategic location choice (near customers, suppliers, talent)', 'Long-term cost efficiency vs. leasing', 'Asset appreciation potential', 'Tax benefits through depreciation', 'Operational control and flexibility'],
    disadvantages: ['Large upfront capital requirement', 'Long payback period and cash flow impact', 'Risk of over/under capacity', 'Location lock-in reduces flexibility', 'Construction risks (delays, cost overruns)', 'Market changes may alter facility requirements', 'Ongoing maintenance and property tax obligations'],
    whenToUse: ['Current facility capacity constraining growth', 'Lease costs significantly exceed ownership costs', 'Strategic location offers competitive advantage', 'Long-term demand visibility supports investment', 'Government incentives make economics attractive', 'Customization needs exceed available properties'],
    keyTerminology: [
      KeyTerminology(term: 'Greenfield', definition: 'New construction on undeveloped land'),
      KeyTerminology(term: 'Brownfield', definition: 'Redevelopment of previously used industrial site'),
      KeyTerminology(term: 'GC (General Contractor)', definition: 'Primary contractor managing construction'),
      KeyTerminology(term: 'Change Order', definition: 'Modification to original construction contract'),
      KeyTerminology(term: 'Certificate of Occupancy', definition: 'Government approval to use completed building'),
      KeyTerminology(term: 'Turn-key', definition: 'Completed facility ready for immediate operation'),
    ],
  ),
  mechanicsProcess: MechanicsProcess(
    howItWorks: 'The company identifies capacity needs, evaluates location options, acquires land or site, engages architects and engineers for design, secures permits, selects contractors, and manages construction through completion. Financing is arranged through capital budget, debt, or build-to-suit arrangements.',
    stepByStepProcess: ['1. Needs Assessment: Define space, capacity, and location requirements', '2. Site Selection: Evaluate locations considering costs, incentives, logistics', '3. Land Acquisition: Purchase or lease land; conduct due diligence', '4. Design Phase: Engage architects/engineers; develop building plans', '5. Permitting: Obtain zoning approvals, building permits, environmental clearances', '6. Contractor Selection: Bid process and contract negotiation', '7. Construction: Ground-breaking through building completion', '8. Commissioning: Equipment installation, testing, systems verification', '9. Occupancy: Certificate of occupancy and move-in', '10. Project Close-out: Final payments, warranty establishment'],
    keyPartiesInvolved: ['Project Sponsor: Executive accountable for project', 'Project Manager: Day-to-day project coordination', 'Architect: Building design and plans', 'General Contractor: Construction management', 'Subcontractors: Specialized trades (electrical, mechanical, etc.)', 'Engineers: Structural, MEP (mechanical, electrical, plumbing)', 'Government: Zoning, permits, inspections'],
    documentationRequired: ['Feasibility Study: Business case and financial projections', 'Architectural Drawings: Detailed building plans', 'Construction Contracts: GC and subcontractor agreements', 'Permits: Building, environmental, occupancy', 'Financing Documents: Loan agreements, leases', 'Insurance Certificates: Builder\'s risk, liability coverage'],
    timelineMilestones: ['Month 1-3: Site selection and acquisition', 'Month 4-9: Design and permitting', 'Month 10-24: Construction phase', 'Month 25-27: Commissioning and occupancy', 'Month 28+: Post-construction warranty period'],
  ),
  financialAnalysis: FinancialAnalysis(
    valuationPricing: 'Project valuation uses NPV of cash flows: Capacity utilization × contribution margin - operating costs - financing costs. Compare to alternative of leasing or outsourcing. Include terminal value of facility.',
    costCalculation: 'Total project cost = Land + Hard costs (construction) + Soft costs (design, permits, fees). Industrial: \$100-\$300/sq ft; Office: \$200-\$400/sq ft; Data center: \$800-\$1,500/sq ft. Soft costs typically 15-25% of hard costs.',
    riskFactors: ['Construction cost overruns (average 20% for complex projects)', 'Schedule delays impacting revenue plans', 'Site conditions requiring remediation', 'Regulatory/permit delays', 'Labor and material price volatility', 'Demand forecast errors leading to over/under capacity'],
    returnMetrics: ['Project NPV and IRR', 'Payback period', 'Cost per square foot vs. market', 'Capacity utilization projections', 'Cash-on-cash return', 'ROIC on project investment'],
    keyRatios: [
      KeyRatio(ratio: 'Construction Cost Index', formula: 'Actual Cost / Budgeted Cost', interpretation: 'Track vs. 1.0; typical projects exceed budget'),
      KeyRatio(ratio: 'Schedule Performance Index', formula: 'Actual Progress / Planned Progress', interpretation: '<1.0 indicates delays'),
      KeyRatio(ratio: 'Cost per Unit Capacity', formula: 'Total Investment / Production Capacity', interpretation: 'Compare to industry benchmarks'),
      KeyRatio(ratio: 'Occupancy Cost Ratio', formula: 'Total Facility Cost / Revenue', interpretation: 'Benchmark: 5-15% depending on industry'),
    ],
    breakEvenAnalysis: 'Break-even = Fixed facility costs / Contribution margin per unit. Example: \$50M facility, \$10M annual operating costs, \$5M financing costs. If products contribute \$100/unit margin, need 150,000 units (\$15M contribution) to cover operating+financing. Full ROI requires additional volume.',
  ),
  accountingTreatment: AccountingTreatment(
    recognitionMeasurement: 'Construction costs capitalized as assets when incurred. Include directly attributable costs (materials, labor, permits, architect fees). Capitalize interest during construction period. Depreciate over useful life (20-40 years for buildings).',
    journalEntries: [
      JournalEntry(debit: 'Construction in Progress', credit: 'Cash/Accounts Payable', description: 'Construction costs during building'),
      JournalEntry(debit: 'Construction in Progress', credit: 'Interest Payable', description: 'Capitalize interest during construction'),
      JournalEntry(debit: 'Building (PP&E)', credit: 'Construction in Progress', description: 'Transfer completed building to fixed assets'),
      JournalEntry(debit: 'Depreciation Expense', credit: 'Accumulated Depreciation', description: 'Annual depreciation over useful life'),
      JournalEntry(debit: 'Land', credit: 'Cash', description: 'Land purchase (not depreciated)'),
    ],
    financialStatementImpact: FinancialStatementImpact(
      balanceSheet: 'PP&E increases by capitalized costs. Construction in progress until completion. Land recorded separately at cost. Debt increases if project-financed.',
      incomeStatement: 'No expense during construction (capitalized). Depreciation begins when placed in service. Interest expensed after construction (unless continued capitalization allowed).',
      cashFlowStatement: 'Construction payments in investing activities. Financing proceeds in financing activities. Depreciation adds back to operating cash flow.',
    ),
    disclosureRequirements: ['Construction commitments and obligations', 'Capitalized interest amounts', 'Depreciation methods and useful lives', 'Property values and accumulated depreciation', 'Impairment assessments if indicators present'],
    ifrsVsGaap: 'Generally similar treatment. Interest capitalization: Both allow/require for qualifying assets but calculation details differ. Component depreciation: IFRS requires, US GAAP allows. Fair value model: IFRS allows for investment property; US GAAP requires cost model. Land: Neither allows depreciation.',
  ),
  strategicConsiderations: StrategicConsiderations(
    decisionCriteria: ['Capacity: Is additional capacity needed and for how long?', 'Location: Strategic advantages of potential sites', 'Make vs. Buy: Build new vs. acquire existing vs. outsource', 'Timing: Market conditions for construction and financing', 'Flexibility: Future expansion or repurposing potential', 'Incentives: Government grants, tax abatements available'],
    comparisonWithAlternatives: 'Build new vs. Lease: Building provides customization and long-term economics but requires capital and commitment. vs. Acquire existing: Faster but may require modifications. vs. Outsource: Lowest capital but highest per-unit cost and less control.',
    impactOnFinancialPosition: 'Major increase in PP&E and potentially debt. Depreciation reduces taxable income. Cash flow negative during construction, improves with operations. Asset-heavy balance sheet may affect credit metrics.',
    commonMistakes: ['Underestimating total project costs', 'Overly optimistic demand forecasts', 'Insufficient contingency budget', 'Poor contractor selection and management', 'Inadequate site due diligence', 'Ignoring regulatory/permit timeline risks'],
    bestPractices: ['Include 15-20% contingency for unforeseen costs', 'Use experienced project managers', 'Secure fixed-price contracts where possible', 'Phase construction to match demand growth', 'Engage community stakeholders early', 'Design for flexibility and future expansion'],
  ),
  practicalApplication: PracticalApplication(
    realWorldExample: 'Tesla Gigafactory Nevada: Announced 2014, construction began 2014, initial production 2016. Total investment >\$5B for 5.5M sq ft facility. Partnership with Panasonic for battery production. Demonstrates scale of modern manufacturing facility investment.',
    calculationExample: 'Factory project: 100,000 sq ft at \$200/sq ft = \$20M hard costs. Soft costs at 20% = \$4M. Land: \$2M. Total: \$26M. 25-year depreciation = \$960K/year (excluding land). If facility enables \$5M additional annual profit, simple payback = 5.2 years.',
    caseStudy: 'Boeing South Carolina (2009-2011): Built new 787 Dreamliner factory in SC for \$750M. Decision driven by labor relations and costs. Despite initial quality issues, facility now produces majority of 787s. Demonstrates role of labor costs and state incentives in location decisions.',
    industryVariations: ['Semiconductor: Clean room requirements; \$10B+ fab facilities', 'Automotive: Large footprint; significant robotics investment', 'Pharmaceutical: GMP compliance; extensive validation', 'Distribution: Location near transportation; automation focus', 'Data Centers: Power and cooling critical; redundancy required', 'Food Processing: USDA/FDA compliance; cold chain capability'],
    regulatoryConsiderations: ['Zoning: Industrial vs. commercial vs. mixed-use designations', 'Environmental: Impact assessments, permits, remediation', 'Building Codes: Fire, safety, accessibility requirements', 'Labor: Prevailing wage requirements for some projects', 'Tax: Opportunity zones, enterprise zones, TIF districts', 'Utility: Capacity agreements for power, water, sewer'],
  ),
);

const acquisitionContent = ScenarioEducationalContent(
  coreFramework: CoreFramework(
    definitionOverview: 'An acquisition is the purchase of one company (target) by another (acquirer). This includes mergers, stock purchases, and asset purchases. Acquisitions can expand market share, enter new markets, acquire technology or talent, achieve synergies, or eliminate competition. M&A is a key corporate growth strategy.',
    keyCharacteristics: ['Transfer of ownership and control', 'Premium paid over market value (control premium)', 'Extensive due diligence process', 'Regulatory review and approval often required', 'Integration planning critical to success', 'Various structures (stock, asset, merger) with different implications'],
    typesClassifications: ['Horizontal: Acquiring competitor in same industry', 'Vertical: Acquiring supplier or customer', 'Conglomerate: Acquiring unrelated business', 'Stock Purchase: Buy target\'s shares from shareholders', 'Asset Purchase: Buy specific assets, not entire company', 'Merger: Combine two companies into one entity', 'Reverse Merger: Private company merges with public shell'],
    advantages: ['Rapid growth and market share gains', 'Access to new markets, technologies, or capabilities', 'Economies of scale and cost synergies', 'Revenue synergies through cross-selling', 'Eliminate competitor', 'Acquire talent and intellectual property', 'Potentially faster/cheaper than organic development'],
    disadvantages: ['High transaction and integration costs', 'Integration challenges and culture clashes', 'Overpayment risk (winner\'s curse)', 'Execution risk during transition', 'Regulatory approval uncertainty', 'Distraction from core business', 'High failure rate (50-70% fail to create value)'],
    whenToUse: ['Attractive target available at reasonable price', 'Organic growth too slow for strategic needs', 'Clear synergy opportunities exist', 'Competitive threat requires response', 'Technology acquisition faster than internal development', 'Market consolidation opportunity'],
    keyTerminology: [
      KeyTerminology(term: 'Control Premium', definition: 'Premium paid over market price for control (typically 20-40%)'),
      KeyTerminology(term: 'Due Diligence', definition: 'Investigation of target\'s business, financials, legal, operations'),
      KeyTerminology(term: 'Synergies', definition: 'Value created by combining companies (cost savings, revenue enhancement)'),
      KeyTerminology(term: 'Earnout', definition: 'Contingent payment based on post-acquisition performance'),
      KeyTerminology(term: 'Material Adverse Change (MAC)', definition: 'Contract clause allowing deal termination for significant negative events'),
      KeyTerminology(term: 'Break-up Fee', definition: 'Payment if deal fails for specified reasons'),
    ],
  ),
  mechanicsProcess: MechanicsProcess(
    howItWorks: 'The acquirer identifies targets, conducts preliminary valuation, approaches target, negotiates terms, performs due diligence, finalizes documentation, obtains approvals (board, shareholders, regulators), and closes transaction. Post-closing, integration is executed.',
    stepByStepProcess: ['1. Strategy: Define acquisition criteria and strategic rationale', '2. Target Identification: Screen and evaluate potential targets', '3. Initial Valuation: Estimate target value and synergies', '4. Approach: Make initial contact; sign confidentiality agreement', '5. Letter of Intent: Agree on preliminary terms and exclusivity', '6. Due Diligence: Comprehensive investigation of target', '7. Definitive Agreement: Negotiate and execute purchase agreement', '8. Regulatory Filings: HSR (antitrust), SEC, industry-specific', '9. Shareholder Approvals: If required by size or structure', '10. Closing: Transfer of funds and control', '11. Integration: Combine operations and realize synergies'],
    keyPartiesInvolved: ['Acquirer Management: Strategy and decisions', 'Target Management: Negotiation and cooperation', 'Investment Banks: Valuation, deal structuring, fairness opinions', 'Legal Counsel: Transaction documentation and regulatory', 'Accountants: Financial due diligence and accounting', 'Regulators: Antitrust, industry-specific approvals', 'Shareholders: Approval for significant transactions'],
    documentationRequired: ['Confidentiality Agreement: Protects information shared', 'Letter of Intent: Non-binding preliminary terms', 'Purchase Agreement: Definitive transaction terms', 'Disclosure Schedules: Target\'s representations and warranties', 'Financing Commitments: Bank commitment letters', 'Regulatory Filings: HSR, SEC filings as applicable', 'Employment/Non-compete Agreements: Key employee retention'],
    timelineMilestones: ['Month 1-2: Target identification and approach', 'Month 2-3: Letter of intent and exclusivity', 'Month 3-5: Due diligence', 'Month 5-6: Negotiate and sign definitive agreement', 'Month 6-9: Regulatory review and approvals', 'Month 9+: Closing and integration (12-24 months)'],
  ),
  financialAnalysis: FinancialAnalysis(
    valuationPricing: 'Target valued using DCF (intrinsic value), comparable companies (market multiples), and precedent transactions. Acquirer determines maximum price based on standalone value + synergies - integration costs - required return. Control premium added to market price.',
    costCalculation: 'Total acquisition cost = Purchase price + Transaction costs (advisory fees 1-2%, legal 0.5-1%, financing fees, regulatory filings) + Integration costs (typically 5-10% of deal value) + Opportunity cost of management time.',
    riskFactors: ['Valuation risk: Overpaying for target', 'Integration risk: Failure to achieve synergies', 'Culture clash: Employee departure and productivity loss', 'Regulatory risk: Approval delays or conditions', 'Financing risk: Market conditions change', 'Hidden liabilities: Undisclosed problems discovered post-close'],
    returnMetrics: ['Accretion/Dilution: EPS impact of transaction', 'NPV of Synergies vs. Premium Paid', 'ROIC on acquisition investment', 'Synergy capture rate (actual vs. projected)', 'Revenue retention post-acquisition'],
    keyRatios: [
      KeyRatio(ratio: 'EV/EBITDA Multiple', formula: 'Enterprise Value / EBITDA', interpretation: 'Common valuation multiple; industry-specific ranges'),
      KeyRatio(ratio: 'Premium to Unaffected Price', formula: '(Offer Price - Pre-announcement Price) / Pre-announcement Price', interpretation: 'Typical 20-40%; higher for contested deals'),
      KeyRatio(ratio: 'Pro Forma Leverage', formula: 'Combined Debt / Combined EBITDA', interpretation: 'Post-deal leverage; affects credit and flexibility'),
      KeyRatio(ratio: 'Synergy Multiple', formula: 'Synergies / Premium Paid', interpretation: '>1.0 suggests value creation'),
    ],
    breakEvenAnalysis: 'Acquisition creates value when NPV of synergies > Premium paid. Example: \$100M premium for control. If synergies = \$20M/year and discount rate = 10%, synergy NPV = \$200M. Value creation = \$200M - \$100M = \$100M.',
  ),
  accountingTreatment: AccountingTreatment(
    recognitionMeasurement: 'Under acquisition method (ASC 805/IFRS 3): Record identifiable assets acquired and liabilities assumed at fair value. Excess of purchase price over fair value of net assets = Goodwill. Goodwill tested annually for impairment (not amortized).',
    journalEntries: [
      JournalEntry(debit: 'Identifiable Assets (FV)', credit: 'Cash/Stock Consideration', description: 'Record assets acquired at fair value'),
      JournalEntry(debit: 'Goodwill', credit: 'Cash/Stock Consideration', description: 'Excess of price over identifiable net assets'),
      JournalEntry(debit: 'Cash/Stock Consideration', credit: 'Liabilities Assumed (FV)', description: 'Record liabilities assumed at fair value'),
      JournalEntry(debit: 'Acquisition Expense', credit: 'Cash', description: 'Transaction costs expensed (not capitalized)'),
      JournalEntry(debit: 'Impairment Loss', credit: 'Goodwill', description: 'If goodwill subsequently impaired'),
    ],
    financialStatementImpact: FinancialStatementImpact(
      balanceSheet: 'Assets increase by fair value acquired. Goodwill recognized for premium. Liabilities increase by obligations assumed. Equity or cash decreases by consideration paid.',
      incomeStatement: 'Transaction costs expensed immediately. Amortization of intangibles (except goodwill). Potential goodwill impairment if overpaid. Combined operations reflected post-close.',
      cashFlowStatement: 'Cash paid shown in Investing Activities. Stock consideration doesn\'t affect cash. Subsequent operations in Operating Activities. Contingent consideration changes in Financing.',
    ),
    disclosureRequirements: ['Business acquired and acquisition date', 'Purchase price allocation to assets and liabilities', 'Goodwill: Amount and factors contributing', 'Acquisition-related costs incurred', 'Pro forma combined results', 'Contingent consideration arrangements'],
    ifrsVsGaap: 'Generally similar acquisition method. Key differences: (1) Contingent consideration: Both remeasure to fair value, but classification may differ. (2) Transaction costs: Both expense, but slightly different treatment. (3) Non-controlling interests: IFRS allows fair value or proportionate; US GAAP requires fair value. (4) Bargain purchases: Both recognize gain but different presentations.',
  ),
  strategicConsiderations: StrategicConsiderations(
    decisionCriteria: ['Strategic Fit: Does target align with corporate strategy?', 'Synergy Potential: Quantifiable cost and revenue synergies', 'Valuation: Is price justified by value creation?', 'Integration: Can operations be effectively combined?', 'Culture: Are cultures compatible?', 'Risk: What could go wrong and probability?'],
    comparisonWithAlternatives: 'vs. Organic Growth: Acquisition faster but riskier and more expensive. vs. Joint Venture: JV preserves independence but limits integration. vs. Licensing: License acquires technology without operational complexity. Decision depends on speed, control, and risk tolerance.',
    impactOnFinancialPosition: 'Major balance sheet expansion with assets and goodwill. Leverage may increase significantly. EPS impact depends on price and financing. Cash flow initially negative from payments, then combined operations.',
    commonMistakes: ['Overestimating synergies and underestimating costs', 'Insufficient due diligence', 'Cultural integration neglected', 'Overpaying in competitive auctions', 'Inadequate integration planning', 'Losing key talent post-acquisition'],
    bestPractices: ['Conservative synergy estimates (achieve 60-70% of projected)', 'Thorough due diligence including culture assessment', 'Integration planning before close', 'Clear leadership and decision rights post-close', 'Retain key talent with incentives', 'Track synergy realization rigorously'],
  ),
  practicalApplication: PracticalApplication(
    realWorldExample: 'Microsoft-LinkedIn (2016): \$26.2B acquisition at 50% premium. Strategic rationale: Combine LinkedIn\'s professional network with Microsoft\'s productivity tools (Office, Dynamics). Synergies: Enhanced recruiting features, integrated profiles, ad targeting. Executed over 5 years with LinkedIn maintaining brand and culture.',
    calculationExample: 'Target: \$500M revenue, \$75M EBITDA, stock trading at 8x EBITDA = \$600M. With 30% premium = \$780M offer. Expected synergies: \$30M/year cost, \$10M revenue = \$40M. At 10% discount rate, synergy NPV = \$400M. Premium paid = \$180M. Net value creation = \$220M.',
    caseStudy: 'AOL-Time Warner (2000): \$164B \'merger of equals.\' Intended to combine old media and new internet. Reality: Culture clash, strategy disagreement, dot-com bust destroyed value. By 2009, companies separated. \$99B goodwill write-off. Demonstrates risks of mega-mergers and integration failure.',
    industryVariations: ['Technology: High multiples; talent and IP focus; cultural sensitivity', 'Healthcare: Regulatory complexity; long approval timelines', 'Financial Services: Capital adequacy; regulatory approval', 'Consumer: Brand and distribution synergies; portfolio fit', 'Industrial: Operational synergies; manufacturing integration', 'Energy: Asset-based; reserve replacement; environmental liability'],
    regulatoryConsiderations: ['Antitrust: Hart-Scott-Rodino filing; FTC/DOJ review in US; EC in Europe', 'CFIUS: National security review for foreign acquisitions', 'Industry-Specific: Banking, insurance, telecom, media require approvals', 'SEC: Disclosure requirements for public companies', 'State Laws: May affect timing and shareholder rights', 'International: Local approval required in many jurisdictions'],
  ),
);

const assetSaleContent = ScenarioEducationalContent(
  coreFramework: CoreFramework(
    definitionOverview: 'Asset sale or divestiture involves selling business units, divisions, subsidiaries, or specific assets. Companies divest to raise capital, focus on core business, improve returns, satisfy regulatory requirements, or exit underperforming operations. Divestitures are the reverse of acquisitions and require similar rigor.',
    keyCharacteristics: ['Transfer of assets or business units to buyers', 'Generates cash proceeds (or debt relief)', 'May result in gain or loss on sale', 'Requires carve-out of divested operations', 'Transition services often needed post-sale', 'Tax implications vary by structure'],
    typesClassifications: ['Asset Sale: Sell specific assets; buyer chooses what to acquire', 'Stock/Share Sale: Sell entire subsidiary entity', 'Spin-off: Distribute subsidiary shares to existing shareholders', 'Carve-out (Equity Carve-out): IPO portion of subsidiary', 'Split-off: Exchange parent shares for subsidiary shares', 'Liquidation: Wind down and sell assets piecemeal'],
    advantages: ['Raises cash for debt reduction, investment, or return to shareholders', 'Improves focus on core business', 'Exits underperforming or non-strategic operations', 'May improve overall company valuation (sum-of-parts)', 'Satisfies regulatory requirements (e.g., antitrust)', 'Removes management distraction', 'Can improve ROIC by shedding low-return assets'],
    disadvantages: ['Loss of revenue and potentially profitable operations', 'Transaction costs and complexity', 'Stranded costs if overhead not reduced proportionally', 'Employee impact and morale issues', 'Loss of diversification', 'May signal strategic failure', 'Potential tax liability on gains'],
    whenToUse: ['Business unit not core to strategy', 'Better owner exists who will pay premium', 'Performance not meeting expectations', 'Regulatory requirement to divest', 'Need to raise capital', 'Sum-of-parts exceeds current valuation'],
    keyTerminology: [
      KeyTerminology(term: 'Carve-out', definition: 'Separating divested operations from parent for sale'),
      KeyTerminology(term: 'Stranded Costs', definition: 'Overhead that remains after divestiture without corresponding revenue'),
      KeyTerminology(term: 'Transition Services Agreement (TSA)', definition: 'Contract for seller to provide services to buyer during transition'),
      KeyTerminology(term: 'Seller\'s Note', definition: 'Debt instrument from buyer to seller as part of consideration'),
      KeyTerminology(term: 'Indemnification', definition: 'Seller\'s obligation to compensate buyer for breaches or specified liabilities'),
      KeyTerminology(term: 'Escrow', definition: 'Funds held by third party pending satisfaction of conditions'),
    ],
  ),
  mechanicsProcess: MechanicsProcess(
    howItWorks: 'Company identifies divestiture candidate, prepares business for sale (carve-out), markets to potential buyers, negotiates terms, signs definitive agreement, obtains necessary approvals, and closes transaction. Transition services support buyer until fully independent.',
    stepByStepProcess: ['1. Strategic Review: Decide to divest based on portfolio analysis', '2. Carve-out Planning: Separate financials, operations, systems', '3. Valuation: Determine expected value and sale process', '4. Advisor Selection: Engage investment bank, legal, accounting', '5. Marketing: Contact potential buyers; distribute teaser/CIM', '6. Buyer Due Diligence: Provide data room access to bidders', '7. Bid Process: Receive and evaluate offers', '8. Negotiation: Finalize terms with preferred buyer', '9. Definitive Agreement: Execute purchase/sale agreement', '10. Closing: Transfer assets/shares, receive proceeds', '11. Transition: Provide TSA services; complete separation'],
    keyPartiesInvolved: ['Seller Management: Divestiture decision and execution', 'Buyer: Acquirer of divested business', 'Investment Bank: Marketing, valuation, negotiations', 'Legal Counsel: Transaction structure and documentation', 'Accountants: Carve-out financials, tax structuring', 'Operations: Separation and transition execution', 'HR: Employee communication and transition'],
    documentationRequired: ['Confidential Information Memorandum (CIM): Marketing document', 'Carve-out Financial Statements: Historical financials of divested unit', 'Purchase/Sale Agreement: Definitive transaction terms', 'Transition Services Agreement: Post-close service arrangements', 'Employee Matters Agreement: Transfer/retention of employees', 'Intellectual Property Agreements: Licensing/transfer of IP', 'Regulatory Filings: HSR, industry-specific as required'],
    timelineMilestones: ['Month 1-2: Strategic decision and advisor selection', 'Month 3-4: Carve-out and marketing preparation', 'Month 5-6: Marketing to buyers and due diligence', 'Month 7-8: Bid process and negotiation', 'Month 9-10: Signing and regulatory approvals', 'Month 11-12: Closing', 'Year 2: TSA wind-down and full separation'],
  ),
  financialAnalysis: FinancialAnalysis(
    valuationPricing: 'Divested unit valued similar to acquisition: DCF, comparable companies, precedent transactions. Seller seeks to maximize value while buyer seeks discount. Strategic buyers may pay premium; financial buyers focus on returns.',
    costCalculation: 'Net proceeds = Sale price - Transaction costs (typically 2-4%) - Taxes on gain - Stranded costs capitalized value. Consider value of debt paydown or strategic use of proceeds.',
    riskFactors: ['Buyer fails to close (financing contingency)', 'Lower than expected proceeds', 'Stranded costs exceed estimates', 'Key employee departure', 'Customer/supplier disruption', 'Unexpected liabilities or indemnification claims'],
    returnMetrics: ['Gain/Loss on sale', 'Multiple received vs. comparable transactions', 'Proceeds as % of carrying value', 'Impact on parent company ROIC', 'Use of proceeds return'],
    keyRatios: [
      KeyRatio(ratio: 'Sale Multiple', formula: 'Enterprise Value / EBITDA', interpretation: 'Compare to acquisition multiples; sellers want higher'),
      KeyRatio(ratio: 'Proceeds to Book Value', formula: 'Net Proceeds / Book Value of Assets', interpretation: '>1.0 indicates gain on sale'),
      KeyRatio(ratio: 'Stranded Cost Ratio', formula: 'Stranded Costs / Allocated Overhead', interpretation: 'Lower is better; <30% typical target'),
      KeyRatio(ratio: 'TSA Cost Recovery', formula: 'TSA Fees / TSA Costs', interpretation: 'Should be ≥1.0 to avoid subsidy'),
    ],
    breakEvenAnalysis: 'Divestiture creates value when: Proceeds × Reinvestment return > Lost earnings + Stranded costs. Example: \$500M proceeds at 15% ROIC = \$75M return. If lost EBITDA was \$40M and stranded costs \$10M, net benefit = \$75M - \$50M = \$25M annually.',
  ),
  accountingTreatment: AccountingTreatment(
    recognitionMeasurement: 'Gain/loss = Proceeds - Carrying value of assets sold. If disposal group meets held-for-sale criteria, measure at lower of carrying value or fair value less costs to sell. Discontinued operations presentation if meets criteria.',
    journalEntries: [
      JournalEntry(debit: 'Cash (Proceeds)', credit: 'Assets Sold (Carrying Value)', description: 'Record sale of assets'),
      JournalEntry(debit: 'Cash', credit: 'Gain on Sale', description: 'If proceeds > carrying value'),
      JournalEntry(debit: 'Loss on Sale', credit: 'Assets Sold', description: 'If proceeds < carrying value'),
      JournalEntry(debit: 'Liabilities Assumed by Buyer', credit: 'Cash', description: 'Net proceeds reduced by liabilities transferred'),
      JournalEntry(debit: 'Goodwill Impairment', credit: 'Goodwill', description: 'Allocate goodwill to disposal group'),
    ],
    financialStatementImpact: FinancialStatementImpact(
      balanceSheet: 'Assets decrease by carrying value sold. Cash increases by proceeds. Liabilities decrease if transferred. Retained earnings affected by gain/loss.',
      incomeStatement: 'Gain/loss on sale in period of transaction. Discontinued operations presentation if qualifying. Results separated from continuing operations.',
      cashFlowStatement: 'Proceeds from sale in Investing Activities. Operating results of discontinued operations may be separated. Non-cash adjustments for gain/loss.',
    ),
    disclosureRequirements: ['Description of facts and circumstances of disposal', 'Gain or loss recognized and line item', 'Reportable segment affected', 'Assets and liabilities of discontinued operations', 'Major classes of operating and investing cash flows for discontinued operations', 'Continuing involvement with divested business'],
    ifrsVsGaap: 'Generally similar treatment. Held-for-sale: Both require same criteria but slightly different application. Discontinued operations: Similar criteria; IFRS uses \'major line of business\' concept. Measurement: Both use lower of carrying value or fair value less costs to sell.',
  ),
  strategicConsiderations: StrategicConsiderations(
    decisionCriteria: ['Strategic Fit: Is business core to long-term strategy?', 'Performance: Is unit meeting return expectations?', 'Value: Is sum-of-parts > current value?', 'Buyer Universe: Who would pay premium?', 'Timing: Market conditions favorable for sale?', 'Alternatives: Can unit be fixed vs. sold?'],
    comparisonWithAlternatives: 'vs. Spin-off: Spin-off distributes value to shareholders without cash; sale generates cash but shareholders don\'t participate in upside. vs. Wind-down: Liquidation may recover less than sale but simpler. vs. Fix: Turnaround preserves optionality but requires investment and time.',
    impactOnFinancialPosition: 'Cash increase from proceeds. Debt reduction improves leverage. Revenue and profit decrease. ROIC may improve if low-return assets sold. May create dis-synergies and stranded costs.',
    commonMistakes: ['Underestimating complexity of carve-out', 'Inadequate stranded cost planning', 'Poor communication causing talent loss', 'Inflated valuation expectations', 'Insufficient transition planning', 'Signing TSA at below-cost rates'],
    bestPractices: ['Early and thorough carve-out planning', 'Realistic valuation with multiple perspectives', 'Proactive communication with employees and customers', 'Address stranded costs before signing', 'Negotiate TSA terms carefully', 'Plan reinvestment of proceeds'],
  ),
  practicalApplication: PracticalApplication(
    realWorldExample: 'GE Portfolio Transformation (2018-2021): Divested transportation, lighting, healthcare IT, BioPharma units for \$30B+ in proceeds. Used to pay down debt and refocus on aviation, power, renewable energy. Demonstrates strategic reshaping through divestiture.',
    calculationExample: 'Division sale: \$400M revenue, \$60M EBITDA, sold for 8x = \$480M. Carrying value of assets: \$300M. Goodwill allocated: \$80M. Gain = \$480M - \$300M - \$80M = \$100M. After 21% tax = \$79M after-tax gain. Cash proceeds for reinvestment at 15% return = \$72M annual value.',
    caseStudy: 'eBay-PayPal Split (2015): Under activist pressure, eBay spun off PayPal. Rationale: Different growth profiles and strategies; sum-of-parts greater than combined. Post-split: PayPal market cap exceeded combined pre-split value. PayPal able to pursue own strategy. Classic case of unlocking value through divestiture.',
    industryVariations: ['Private Equity: Serial buyers of corporate divestitures', 'Conglomerates: Periodic portfolio pruning', 'Banking: Regulatory-driven divestitures common', 'Technology: Divest non-core to focus on growth areas', 'Healthcare: Portfolio optimization and regulatory compliance', 'Energy: Asset sales to manage portfolio and capital needs'],
    regulatoryConsiderations: ['Antitrust: May be required condition of merger approval', 'Tax: Structure (asset vs. stock) affects tax treatment', 'SEC: Disclosure of discontinued operations, material sales', 'Employment: WARN Act, transfer regulations', 'Environmental: Liability allocation for contaminated sites', 'Industry-Specific: Banking, insurance may require approval'],
  ),
);

// ============================================================================
// CONTENT MAP
// ============================================================================

const Map<String, ScenarioEducationalContent> scenarioContentMap = {
  'ipo': ipoContent,
  'initial_public_offering': ipoContent,
  'public_offering': ipoContent,
  'retained': retainedEarningsContent,
  'retained_earnings': retainedEarningsContent,
  'plowback': retainedEarningsContent,
  'reinvest': retainedEarningsContent,
  'newshares': newSharesContent,
  'new_shares': newSharesContent,
  'share_issue': newSharesContent,
  'equity_offering': newSharesContent,
  'follow_on': newSharesContent,
  'secondary_offering': newSharesContent,
  'shortloan': shortTermLoanContent,
  'short_loan': shortTermLoanContent,
  'short_term_loan': shortTermLoanContent,
  'working_capital_loan': shortTermLoanContent,
  'revolving_credit': shortTermLoanContent,
  'line_of_credit': shortTermLoanContent,
  'longloan': longTermLoanContent,
  'long_loan': longTermLoanContent,
  'long_term_loan': longTermLoanContent,
  'term_loan': longTermLoanContent,
  'bank_loan': longTermLoanContent,
  'mortgage': longTermLoanContent,
  'bonds': bondIssuanceContent,
  'bond': bondIssuanceContent,
  'corporate_bond': bondIssuanceContent,
  'debt_issuance': bondIssuanceContent,
  'debenture': bondIssuanceContent,
  'sukuk': sukukContent,
  'islamic_bond': sukukContent,
  'islamic_bonds': sukukContent,
  'islamic_financing': sukukContent,
  'shariah_compliant': sukukContent,
  'mudarabah': sukukContent,
  'musharakah': sukukContent,
  'ijarah': sukukContent,
  'reserves': useReservesContent,
  'use_reserves': useReservesContent,
  'capital_reserves': useReservesContent,
  'reserve_fund': useReservesContent,
  'statutory_reserve': useReservesContent,
  'general_reserve': useReservesContent,
  'dividend': dividendPaymentContent,
  'dividends': dividendPaymentContent,
  'paying_dividend': dividendPaymentContent,
  'pay_dividend': dividendPaymentContent,
  'dividend_payment': dividendPaymentContent,
  'cash_dividend': dividendPaymentContent,
  'stock_dividend': dividendPaymentContent,
  'payout': dividendPaymentContent,
  'distribution': dividendPaymentContent,
  'shareholder_return': dividendPaymentContent,
  'equipment': equipmentInvestmentContent,
  'equipment_investment': equipmentInvestmentContent,
  'machinery': equipmentInvestmentContent,
  'capex': equipmentInvestmentContent,
  'capital_expenditure': equipmentInvestmentContent,
  'fixed_asset': equipmentInvestmentContent,
  'rd': rdInvestmentContent,
  'r_d': rdInvestmentContent,
  'research': rdInvestmentContent,
  'research_development': rdInvestmentContent,
  'innovation': rdInvestmentContent,
  'product_development': rdInvestmentContent,
  'expansion': expansionInvestmentContent,
  'expand': expansionInvestmentContent,
  'growth': expansionInvestmentContent,
  'new_market': expansionInvestmentContent,
  'capacity': expansionInvestmentContent,
  'geographic': expansionInvestmentContent,
  'technology': technologyInvestmentContent,
  'technology_investment': technologyInvestmentContent,
  'it_investment': technologyInvestmentContent,
  'infrastructure': technologyInvestmentContent,
  'digital': technologyInvestmentContent,
  'software': technologyInvestmentContent,
  'erp': technologyInvestmentContent,
  'upgrade': technologyInvestmentContent,
  'upgrading': technologyInvestmentContent,
  'portfolio': portfolioInvestmentContent,
  'portfolio_investment': portfolioInvestmentContent,
  'securities': portfolioInvestmentContent,
  'stocks': portfolioInvestmentContent,
  'financial_investment': portfolioInvestmentContent,
  'joint_venture': jointVentureContent,
  'jv': jointVentureContent,
  'partnership': jointVentureContent,
  'alliance': jointVentureContent,
  'intangible': intangibleAssetsContent,
  'intangible_assets': intangibleAssetsContent,
  'patent': intangibleAssetsContent,
  'trademark': intangibleAssetsContent,
  'intellectual_property': intangibleAssetsContent,
  'goodwill': intangibleAssetsContent,
  'brand': intangibleAssetsContent,
  'cost': costManagementContent,
  'cost_management': costManagementContent,
  'cost_reduction': costManagementContent,
  'cost_cutting': costManagementContent,
  'efficiency': costManagementContent,
  'restructuring': costManagementContent,
  'inventory': inventoryManagementContent,
  'inventory_management': inventoryManagementContent,
  'stock_management': inventoryManagementContent,
  'working_capital': inventoryManagementContent,
  'supply_chain': inventoryManagementContent,
  'jit': inventoryManagementContent,
  'pricing': pricingStrategyContent,
  'price': pricingStrategyContent,
  'pricing_strategy': pricingStrategyContent,
  'price_increase': pricingStrategyContent,
  'price_optimization': pricingStrategyContent,
  'revenue_management': pricingStrategyContent,
  'marketing': marketingAdvertisingContent,
  'advertising': marketingAdvertisingContent,
  'promotion': marketingAdvertisingContent,
  'promotional': marketingAdvertisingContent,
  'campaign': marketingAdvertisingContent,
  'ad': marketingAdvertisingContent,
  'ads': marketingAdvertisingContent,
  'branding': marketingAdvertisingContent,
  'workforce': workforceManagementContent,
  'hiring': workforceManagementContent,
  'layoff': workforceManagementContent,
  'staff': workforceManagementContent,
  'staffing': workforceManagementContent,
  'headcount': workforceManagementContent,
  'employee': workforceManagementContent,
  'hr': workforceManagementContent,
  'technical_staff': workforceManagementContent,
  'training': trainingDevelopmentContent,
  'development': trainingDevelopmentContent,
  'learning': trainingDevelopmentContent,
  'education': trainingDevelopmentContent,
  'skill': trainingDevelopmentContent,
  'coaching': trainingDevelopmentContent,
  'schedule': trainingDevelopmentContent,
  'quality': qualityControlContent,
  'quality_control': qualityControlContent,
  'qc': qualityControlContent,
  'qa': qualityControlContent,
  'quality_assurance': qualityControlContent,
  'iso': qualityControlContent,
  'six_sigma': qualityControlContent,
  'certification': qualityControlContent,
  'standards': qualityControlContent,
  'compliance': qualityControlContent,
  'audit': qualityControlContent,
  'customer_service': customerServiceContent,
  'customer_support': customerServiceContent,
  'service': customerServiceContent,
  'complaint': customerServiceContent,
  'complaints': customerServiceContent,
  'support': customerServiceContent,
  'helpdesk': customerServiceContent,
  'call_center': customerServiceContent,
  'satisfaction': customerServiceContent,
  'nps': customerServiceContent,
  'factory': facilityConstructionContent,
  'building': facilityConstructionContent,
  'construction': facilityConstructionContent,
  'warehouse': facilityConstructionContent,
  'facility': facilityConstructionContent,
  'plant': facilityConstructionContent,
  'office': facilityConstructionContent,
  'data_center': facilityConstructionContent,
  'greenfield': facilityConstructionContent,
  'acquisition': acquisitionContent,
  'acquire': acquisitionContent,
  'merger': acquisitionContent,
  'ma': acquisitionContent,
  'm_a': acquisitionContent,
  'takeover': acquisitionContent,
  'buyout': acquisitionContent,
  'consolidation': acquisitionContent,
  'competitor': acquisitionContent,
  'divestiture': assetSaleContent,
  'divest': assetSaleContent,
  'asset_sale': assetSaleContent,
  'sell_business': assetSaleContent,
  'spinoff': assetSaleContent,
  'spin_off': assetSaleContent,
  'carveout': assetSaleContent,
  'carve_out': assetSaleContent,
  'disposal': assetSaleContent,
  'exit': assetSaleContent,
};

// ============================================================================
// CONTENT LOOKUP FUNCTION
// ============================================================================

ScenarioEducationalContent? getScenarioContent(String scenarioId, String scenarioTitle) {
  final normalizedId = scenarioId.toLowerCase().replaceAll(RegExp(r'[_-]'), '').replaceAll(RegExp(r'\s+'), '');
  final normalizedTitle = scenarioTitle.toLowerCase().replaceAll(RegExp(r'[_-]'), ' ').replaceAll(RegExp(r'\s+'), ' ');

  // Debug log to help identify matching issues
// Try direct ID match first
  for (final entry in scenarioContentMap.entries) {
    final normalizedKey = entry.key.replaceAll(RegExp(r'[_-]'), '');
    if (normalizedId.contains(normalizedKey) || normalizedId == normalizedKey) {
return entry.value;
    }
  }

  // Try title match
  for (final entry in scenarioContentMap.entries) {
    final normalizedKey = entry.key.replaceAll(RegExp(r'[_-]'), ' ');
    if (normalizedTitle.contains(normalizedKey)) {
return entry.value;
    }
  }

  // ===================================================
  // FINANCING SCENARIOS - Extended keyword matching
  // ===================================================

  // IPO / Initial Public Offering
  if (
    normalizedTitle.contains('ipo') ||
    normalizedTitle.contains('initial public') ||
    normalizedTitle.contains('go public') ||
    normalizedTitle.contains('public offering') ||
    normalizedTitle.contains('stock market') ||
    (normalizedTitle.contains('list') && normalizedTitle.contains('stock'))
  ) {
return ipoContent;
  }

  // Retained Earnings
  if (
    normalizedTitle.contains('retain') ||
    normalizedTitle.contains('plowback') ||
    normalizedTitle.contains('reinvest') ||
    normalizedTitle.contains('undistributed') ||
    normalizedTitle.contains('internal fund') ||
    normalizedTitle.contains('self financ')
  ) {
return retainedEarningsContent;
  }

  // New Shares / Equity Offering
  if (
    normalizedTitle.contains('new share') ||
    normalizedTitle.contains('equity') ||
    normalizedTitle.contains('share issue') ||
    normalizedTitle.contains('follow on') ||
    normalizedTitle.contains('secondary offering') ||
    normalizedTitle.contains('rights issue') ||
    normalizedTitle.contains('stock issue') ||
    normalizedTitle.contains('capital increase') ||
    (normalizedTitle.contains('issue') && normalizedTitle.contains('share'))
  ) {
return newSharesContent;
  }

  // Short-term Loan
  if (
    (normalizedTitle.contains('short') &&
      (normalizedTitle.contains('loan') ||
        normalizedTitle.contains('term') ||
        normalizedTitle.contains('credit') ||
        normalizedTitle.contains('debt'))) ||
    normalizedTitle.contains('working capital') ||
    normalizedTitle.contains('revolving') ||
    normalizedTitle.contains('line of credit') ||
    normalizedTitle.contains('overdraft') ||
    normalizedTitle.contains('commercial paper') ||
    normalizedTitle.contains('trade credit')
  ) {
return shortTermLoanContent;
  }

  // Long-term Loan (check BEFORE generic "loan" to avoid conflicts)
  if (
    (normalizedTitle.contains('long') &&
      (normalizedTitle.contains('loan') ||
        normalizedTitle.contains('term') ||
        normalizedTitle.contains('debt'))) ||
    normalizedTitle.contains('bank loan') ||
    normalizedTitle.contains('term loan') ||
    normalizedTitle.contains('mortgage') ||
    normalizedTitle.contains('secured loan') ||
    normalizedTitle.contains('syndicated') ||
    normalizedTitle.contains('project financ') ||
    normalizedTitle.contains('asset backed')
  ) {
return longTermLoanContent;
  }

  // Generic Loan (fallback - if just "loan" without short/long)
  if (
    normalizedTitle.contains('loan') &&
    !normalizedTitle.contains('short') &&
    !normalizedTitle.contains('long')
  ) {
return longTermLoanContent;
  }

  // Bond Issuance
  if (
    normalizedTitle.contains('bond') ||
    normalizedTitle.contains('debenture') ||
    normalizedTitle.contains('debt issue') ||
    normalizedTitle.contains('fixed income') ||
    normalizedTitle.contains('corporate debt') ||
    (normalizedTitle.contains('note') && normalizedTitle.contains('issue'))
  ) {
return bondIssuanceContent;
  }

  // Dividend Payment
  if (
    normalizedTitle.contains('dividend') ||
    normalizedTitle.contains('payout') ||
    (normalizedTitle.contains('distribution') && normalizedTitle.contains('shareholder')) ||
    (normalizedTitle.contains('paying') &&
      (normalizedTitle.contains('shareholder') || normalizedTitle.contains('owner'))) ||
    normalizedTitle.contains('cash return') ||
    normalizedTitle.contains('shareholder return') ||
    (normalizedTitle.contains('yield') && normalizedTitle.contains('share'))
  ) {
return dividendPaymentContent;
  }

  // Sukuk (Islamic Bonds) - check BEFORE generic bond to capture "islamic bonds"
  if (
    normalizedTitle.contains('sukuk') ||
    (normalizedTitle.contains('islamic') &&
      (normalizedTitle.contains('bond') || normalizedTitle.contains('financ'))) ||
    normalizedTitle.contains('shariah') ||
    normalizedTitle.contains('sharia') ||
    normalizedTitle.contains('mudarabah') ||
    normalizedTitle.contains('musharakah') ||
    normalizedTitle.contains('ijarah') ||
    normalizedTitle.contains('murabaha') ||
    normalizedTitle.contains('istisna')
  ) {
return sukukContent;
  }

  // Use Reserves
  if (
    normalizedTitle.contains('reserve') ||
    (normalizedTitle.contains('statutory') && normalizedTitle.contains('fund')) ||
    normalizedTitle.contains('capital reserve') ||
    normalizedTitle.contains('general reserve') ||
    normalizedTitle.contains('contingency fund') ||
    normalizedTitle.contains('buffer fund')
  ) {
return useReservesContent;
  }

  // ===================================================
  // INVESTMENT SCENARIOS - Extended keyword matching
  // ===================================================

  // Equipment Investment
  if (
    normalizedTitle.contains('equipment') ||
    normalizedTitle.contains('machinery') ||
    normalizedTitle.contains('capex') ||
    normalizedTitle.contains('fixed asset') ||
    normalizedTitle.contains('capital expenditure') ||
    normalizedTitle.contains('plant') ||
    normalizedTitle.contains('vehicle') ||
    normalizedTitle.contains('computer') ||
    (normalizedTitle.contains('technology') && normalizedTitle.contains('invest')) ||
    normalizedTitle.contains('automat') ||
    normalizedTitle.contains('robot') ||
    normalizedTitle.contains('production line') ||
    normalizedTitle.contains('manufacturing')
  ) {
return equipmentInvestmentContent;
  }

  // R&D Investment
  if (
    normalizedTitle.contains('r&d') ||
    normalizedTitle.contains('r & d') ||
    normalizedTitle.contains('research') ||
    (normalizedTitle.contains('development') &&
      (normalizedTitle.contains('product') || normalizedTitle.contains('new'))) ||
    normalizedTitle.contains('innovation') ||
    normalizedTitle.contains('patent') ||
    normalizedTitle.contains('intellectual property') ||
    normalizedTitle.contains('prototype') ||
    normalizedTitle.contains('lab') ||
    normalizedTitle.contains('scientific')
  ) {
return rdInvestmentContent;
  }

  // Expansion Investment
  if (
    normalizedTitle.contains('expan') ||
    (normalizedTitle.contains('growth') && normalizedTitle.contains('invest')) ||
    normalizedTitle.contains('new market') ||
    normalizedTitle.contains('capacity') ||
    normalizedTitle.contains('greenfield') ||
    normalizedTitle.contains('brownfield') ||
    normalizedTitle.contains('new facilit') ||
    normalizedTitle.contains('new plant') ||
    normalizedTitle.contains('geographic') ||
    (normalizedTitle.contains('international') && normalizedTitle.contains('invest')) ||
    normalizedTitle.contains('acquisition') ||
    normalizedTitle.contains('merger') ||
    normalizedTitle.contains('scale up') ||
    normalizedTitle.contains('new location') ||
    normalizedTitle.contains('branch')
  ) {
return expansionInvestmentContent;
  }

  // Technology Investment
  if (
    (normalizedTitle.contains('technology') && normalizedTitle.contains('infrastructure')) ||
    (normalizedTitle.contains('upgrading') && normalizedTitle.contains('technology')) ||
    (normalizedTitle.contains('it ') && normalizedTitle.contains('invest')) ||
    (normalizedTitle.contains('digital') && normalizedTitle.contains('transform')) ||
    normalizedTitle.contains('erp') ||
    (normalizedTitle.contains('software') && normalizedTitle.contains('implement')) ||
    (normalizedTitle.contains('system') && normalizedTitle.contains('upgrade')) ||
    (normalizedTitle.contains('cloud') && normalizedTitle.contains('migrat'))
  ) {
return technologyInvestmentContent;
  }

  // Portfolio Investment
  if (
    ((normalizedTitle.contains('purchasing') || normalizedTitle.contains('selling')) &&
      (normalizedTitle.contains('stocks') || normalizedTitle.contains('bonds')) &&
      normalizedTitle.contains('other compan')) ||
    (normalizedTitle.contains('portfolio') && normalizedTitle.contains('invest')) ||
    (normalizedTitle.contains('securities') && normalizedTitle.contains('invest')) ||
    (normalizedTitle.contains('financial') && normalizedTitle.contains('investment')) ||
    normalizedTitle.contains('minority stake')
  ) {
return portfolioInvestmentContent;
  }

  // Joint Venture
  if (
    normalizedTitle.contains('joint venture') ||
    (normalizedTitle.contains('partnership') && normalizedTitle.contains('invest')) ||
    normalizedTitle.contains('divestiture') ||
    normalizedTitle.contains('strategic alliance') ||
    (normalizedTitle.contains('jv') &&
      (normalizedTitle.contains('invest') || normalizedTitle.contains('partner')))
  ) {
return jointVentureContent;
  }

  // Intangible Assets
  if (
    normalizedTitle.contains('intangible') ||
    (normalizedTitle.contains('patent') && normalizedTitle.contains('purchas')) ||
    normalizedTitle.contains('trademark') ||
    normalizedTitle.contains('intellectual property') ||
    normalizedTitle.contains('goodwill') ||
    (normalizedTitle.contains('brand') && normalizedTitle.contains('acqui')) ||
    normalizedTitle.contains('copyright') ||
    (normalizedTitle.contains('license') && normalizedTitle.contains('purchas'))
  ) {
return intangibleAssetsContent;
  }

  // ===================================================
  // OPERATING SCENARIOS - Extended keyword matching
  // ===================================================

  // Cost Management
  if (
    (normalizedTitle.contains('cost') &&
      (normalizedTitle.contains('manage') ||
        normalizedTitle.contains('reduc') ||
        normalizedTitle.contains('cut') ||
        normalizedTitle.contains('control') ||
        normalizedTitle.contains('saving'))) ||
    normalizedTitle.contains('restructur') ||
    normalizedTitle.contains('efficiency') ||
    normalizedTitle.contains('lean') ||
    normalizedTitle.contains('optimiz') ||
    normalizedTitle.contains('downsiz') ||
    normalizedTitle.contains('outsourc') ||
    normalizedTitle.contains('streamlin') ||
    normalizedTitle.contains('overhead') ||
    (normalizedTitle.contains('expense') && normalizedTitle.contains('reduc')) ||
    normalizedTitle.contains('zero based budget') ||
    normalizedTitle.contains('operational improve')
  ) {
return costManagementContent;
  }

  // Inventory Management
  if (
    normalizedTitle.contains('inventory') ||
    (normalizedTitle.contains('stock') &&
      !normalizedTitle.contains('stock market') &&
      !normalizedTitle.contains('stock issue')) ||
    normalizedTitle.contains('warehouse') ||
    normalizedTitle.contains('jit') ||
    normalizedTitle.contains('just in time') ||
    normalizedTitle.contains('supply chain') ||
    normalizedTitle.contains('storage') ||
    normalizedTitle.contains('raw material') ||
    normalizedTitle.contains('finished good') ||
    normalizedTitle.contains('work in progress') ||
    normalizedTitle.contains('wip') ||
    normalizedTitle.contains('stockout') ||
    normalizedTitle.contains('safety stock') ||
    normalizedTitle.contains('reorder')
  ) {
return inventoryManagementContent;
  }

  // Pricing Strategy
  if (
    normalizedTitle.contains('pric') ||
    normalizedTitle.contains('revenue manage') ||
    normalizedTitle.contains('markup') ||
    normalizedTitle.contains('discount') ||
    (normalizedTitle.contains('margin') && normalizedTitle.contains('improve')) ||
    normalizedTitle.contains('value based') ||
    (normalizedTitle.contains('penetration') && !normalizedTitle.contains('market penetration')) ||
    normalizedTitle.contains('skimming') ||
    normalizedTitle.contains('dynamic pric') ||
    normalizedTitle.contains('competitive pric') ||
    (normalizedTitle.contains('premium') && normalizedTitle.contains('strateg'))
  ) {
return pricingStrategyContent;
  }

  // Marketing/Advertising
  if (
    normalizedTitle.contains('marketing') ||
    normalizedTitle.contains('advertising') ||
    (normalizedTitle.contains('promotional') && normalizedTitle.contains('campaign')) ||
    (normalizedTitle.contains('launching') && normalizedTitle.contains('campaign')) ||
    (normalizedTitle.contains('ad ') && normalizedTitle.contains('campaign')) ||
    normalizedTitle.contains('branding') ||
    (normalizedTitle.contains('promotion') && !normalizedTitle.contains('employee'))
  ) {
return marketingAdvertisingContent;
  }

  // Workforce Management
  if (
    normalizedTitle.contains('hiring') ||
    normalizedTitle.contains('laying off') ||
    normalizedTitle.contains('layoff') ||
    normalizedTitle.contains('technical staff') ||
    normalizedTitle.contains('sales professional') ||
    normalizedTitle.contains('workforce') ||
    normalizedTitle.contains('headcount') ||
    normalizedTitle.contains('staffing') ||
    normalizedTitle.contains('recruitment') ||
    (normalizedTitle.contains('staff') && !normalizedTitle.contains('training'))
  ) {
return workforceManagementContent;
  }

  // Training & Development
  if (
    normalizedTitle.contains('training') ||
    (normalizedTitle.contains('development') && normalizedTitle.contains('employee')) ||
    (normalizedTitle.contains('schedule') &&
      (normalizedTitle.contains('increas') || normalizedTitle.contains('reduc'))) ||
    (normalizedTitle.contains('learning') && normalizedTitle.contains('program')) ||
    (normalizedTitle.contains('skill') && normalizedTitle.contains('develop')) ||
    normalizedTitle.contains('coaching') ||
    (normalizedTitle.contains('education') && normalizedTitle.contains('program'))
  ) {
return trainingDevelopmentContent;
  }

  // ===================================================
  // QUALITY, CUSTOMER SERVICE, CONSTRUCTION, M&A, DIVESTITURE SCENARIOS
  // ===================================================

  // Quality Control & Standards
  if (
    normalizedTitle.contains('quality') ||
    (normalizedTitle.contains('iso') && normalizedTitle.contains('certif')) ||
    normalizedTitle.contains('six sigma') ||
    normalizedTitle.contains('defect') ||
    normalizedTitle.contains('inspection') ||
    normalizedTitle.contains('quality control') ||
    normalizedTitle.contains('quality assurance') ||
    (normalizedTitle.contains('qc') &&
      (normalizedTitle.contains('program') || normalizedTitle.contains('implement'))) ||
    (normalizedTitle.contains('standards') && normalizedTitle.contains('implement')) ||
    (normalizedTitle.contains('certification') && !normalizedTitle.contains('train'))
  ) {
return qualityControlContent;
  }

  // Customer Service & Support
  if (
    (normalizedTitle.contains('customer') &&
      (normalizedTitle.contains('service') || normalizedTitle.contains('support'))) ||
    normalizedTitle.contains('complaint') ||
    (normalizedTitle.contains('handling') && normalizedTitle.contains('customer')) ||
    normalizedTitle.contains('call center') ||
    normalizedTitle.contains('helpdesk') ||
    normalizedTitle.contains('customer satisfaction') ||
    normalizedTitle.contains('nps') ||
    normalizedTitle.contains('service recovery') ||
    normalizedTitle.contains('support team')
  ) {
return customerServiceContent;
  }

  // Facility Construction (Factory/Building/Warehouse)
  if (
    normalizedTitle.contains('factory') ||
    (normalizedTitle.contains('building') &&
      (normalizedTitle.contains('new') || normalizedTitle.contains('construct'))) ||
    normalizedTitle.contains('warehouse') ||
    normalizedTitle.contains('construction') ||
    (normalizedTitle.contains('facility') &&
      (normalizedTitle.contains('build') || normalizedTitle.contains('new'))) ||
    (normalizedTitle.contains('plant') && normalizedTitle.contains('new')) ||
    (normalizedTitle.contains('office') && normalizedTitle.contains('building')) ||
    normalizedTitle.contains('data center') ||
    normalizedTitle.contains('greenfield') ||
    (normalizedTitle.contains('manufacturing') && normalizedTitle.contains('facility'))
  ) {
return facilityConstructionContent;
  }

  // Acquisition & Mergers
  if (
    normalizedTitle.contains('acquisition') ||
    normalizedTitle.contains('acquire') ||
    normalizedTitle.contains('acquiring') ||
    normalizedTitle.contains('merger') ||
    normalizedTitle.contains('m&a') ||
    normalizedTitle.contains('takeover') ||
    normalizedTitle.contains('buyout') ||
    normalizedTitle.contains('buy out') ||
    (normalizedTitle.contains('competitor') &&
      (normalizedTitle.contains('buy') || normalizedTitle.contains('acquire'))) ||
    (normalizedTitle.contains('market share') && normalizedTitle.contains('increas')) ||
    normalizedTitle.contains('consolidation') ||
    (normalizedTitle.contains('purchase') && normalizedTitle.contains('company'))
  ) {
return acquisitionContent;
  }

  // Asset Sale & Divestiture
  if (
    normalizedTitle.contains('divestiture') ||
    normalizedTitle.contains('divest') ||
    (normalizedTitle.contains('sell') &&
      (normalizedTitle.contains('business') ||
        normalizedTitle.contains('division') ||
        normalizedTitle.contains('unit'))) ||
    normalizedTitle.contains('spin off') ||
    normalizedTitle.contains('spinoff') ||
    normalizedTitle.contains('carve out') ||
    normalizedTitle.contains('carveout') ||
    normalizedTitle.contains('disposal') ||
    (normalizedTitle.contains('exit') && normalizedTitle.contains('business')) ||
    normalizedTitle.contains('asset sale') ||
    (normalizedTitle.contains('selling') && normalizedTitle.contains('subsidiary'))
  ) {
return assetSaleContent;
  }

  // ===================================================
  // FALLBACK: Try to match by module/category context
  // ===================================================

  // If ID contains common financing keywords
  if (
    normalizedId.contains('fin') &&
    (normalizedId.contains('debt') ||
      normalizedId.contains('equity') ||
      normalizedId.contains('fund'))
  ) {
    // Default to long-term loan for generic debt
    if (normalizedId.contains('debt')) {
return longTermLoanContent;
    }
    // Default to new shares for generic equity
    if (normalizedId.contains('equity')) {
return newSharesContent;
    }
  }

  // If ID contains common investing keywords
  if (
    normalizedId.contains('inv') &&
    (normalizedId.contains('asset') || normalizedId.contains('capital'))
  ) {
return equipmentInvestmentContent;
  }

  // If ID contains common operating keywords
  if (normalizedId.contains('ops') || normalizedId.contains('oper')) {
return costManagementContent;
  }
return null;
}
