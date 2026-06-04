import '../gov_module_data.dart';

const module2Data = GovModuleContent(
  id: 2,
  title: 'Sector Finance Comparison',
  gameTitle: 'Classify the Feature',
  gameDescription: 'Drag each feature to its correct sector.',
  gameType: GameType.classification,

  // ── 13 Slides (from module2-content.ts) ──
  slides: [
    // Slide 1 — Overview: Government vs Private Sector
    {
      'title': 'Overview: Government vs Private Sector',
      'content':
          'The government and private sectors represent two fundamentally different approaches to organizing economic activity and delivering value to stakeholders. While both manage financial resources and produce financial statements, the similarities end there. The objectives, incentives, constraints, and accountability mechanisms are profoundly different.\n\n'
          'The government sector exists to serve the public interest, providing essential services, maintaining social welfare, and managing public resources for current and future generations. Success is measured not by financial returns but by service delivery, citizen satisfaction, and social outcomes.\n\n'
          'The private sector exists to generate returns for owners and shareholders. Success is measured primarily through financial performance metrics: profitability, return on investment, market share, and shareholder value.\n\n'
          'Understanding these fundamental differences is crucial for government finance professionals. Many concepts from private sector finance can be adapted for the public sector, but direct application without adaptation often fails.',
      'keyPoint':
          'Government measures success by service delivery and citizen welfare. Private sector measures success by profitability and shareholder returns.',
    },
    // Slide 2 — Primary Objectives Comparison
    {
      'title': 'Primary Objectives Comparison',
      'content':
          'The primary objectives of government and private sectors diverge sharply. Government entities are established to maximize public welfare and deliver essential services efficiently and equitably. Success is measured by service quality, coverage rates, citizen satisfaction surveys, and long-term social outcomes such as education levels, health indicators, and infrastructure quality.\n\n'
          'Private sector objectives center on maximizing shareholder value through profitability and growth. Success is measured by financial ratios (ROI, ROE, profit margins), market metrics (revenue growth, market share), and stock price performance.\n\n'
          'Time horizons differ dramatically. Government planning often spans decades or generations. Infrastructure projects like highways, ports, and water systems are designed to serve the public for 30 to 100 years. Conversely, private companies typically focus on quarterly earnings reports and annual performance targets, with strategic planning extending 3 to 5 years at most.\n\n'
          'Risk tolerance and failure consequences also differ. In the private sector, failed ventures are expected and accepted as part of entrepreneurial risk. In government, failures carry political consequences, erode public trust, and often become national news.',
      'keyPoint':
          'Government invests for generations. Private sector invests for quarterly returns.',
    },
    // Slide 3 — Revenue Sources & Funding
    {
      'title': 'Revenue Sources & Funding',
      'content':
          'The sources of revenue and funding reveal one of the starkest differences between sectors. Government revenue is largely involuntary and legally mandated. Tax revenue (personal income tax, corporate tax, VAT, customs duties) forms the primary funding base. Citizens and businesses have no choice but to pay taxes as prescribed by law.\n\n'
          'Non-tax revenue includes fees for specific services (passport fees, business licenses, court fees), grants from other government entities or international organizations, natural resource revenues (oil, gas, mining royalties), and debt issuance (government bonds, sukuk).\n\n'
          'In contrast, private sector revenue is entirely voluntary and exchange-based. Companies earn revenue only by convincing customers to buy their products or services in competitive markets. Additional funding comes from equity investors and lenders.\n\n'
          'In Saudi Arabia, oil revenues managed through the Public Investment Fund (PIF) and the Ministry of Finance form the backbone of government funding, supporting Vision 2030 initiatives.',
      'keyPoint':
          'Government revenue is collected by law (taxes). Private revenue is earned by persuasion (sales).',
    },
    // Slide 4 — Accountability & Stakeholders
    {
      'title': 'Accountability & Stakeholders',
      'content':
          'Accountability structures differ fundamentally between the two sectors. Government stakeholders include citizens and taxpayers, elected officials and legislators, oversight bodies (supreme audit institutions, anti-corruption agencies), international organizations, and future generations.\n\n'
          'Private sector stakeholders include shareholders and investors, the board of directors, employees, customers, creditors, and regulators.\n\n'
          'Accountability mechanisms reflect these different stakeholders. Government entities face legislative oversight, supreme audit institution reviews, freedom of information laws, and electoral accountability.\n\n'
          'Private companies face shareholder votes, market discipline (poor performance leads to falling stock prices), regulatory compliance, and board oversight with fiduciary duties to shareholders.',
      'keyPoint':
          'Government failures damage public trust and have political consequences. Private failures primarily hurt shareholders.',
    },
    // Slide 5 — IPSAS vs IFRS Standards
    {
      'title': 'IPSAS vs IFRS Standards',
      'content':
          'Financial reporting standards diverge sharply between the two sectors. IPSAS (International Public Sector Accounting Standards) are designed specifically for government and public sector entities. Developed by the IPSASB, IPSAS are based on IFRS but heavily adapted to address the unique characteristics of the public sector: non-exchange transactions, service delivery mandates, budget accountability, and stewardship of public resources.\n\n'
          'IFRS (International Financial Reporting Standards) are designed for private sector entities, particularly publicly traded companies. Developed by the IASB, IFRS assume profit motivation, voluntary market transactions, and investor decision-making as the primary purpose of financial reporting.\n\n'
          'Key terminology differences reveal the underlying philosophy. IPSAS uses "net assets/equity" instead of "shareholders\' equity" because governments have no shareholders. IPSAS uses "surplus/deficit" instead of "profit/loss" because government is not designed to profit.\n\n'
          'Saudi Arabia adopted IPSAS for government entities as part of the National Transformation Program under Vision 2030. Meanwhile, private companies listed on Tadawul use IFRS.',
      'keyPoint':
          'IPSAS = Public accountability + Stewardship | IFRS = Investor decisions + Profitability',
    },
    // Slide 6 — Budget Process Differences
    {
      'title': 'Budget Process Differences',
      'content':
          'In government, the budget is a legal instrument that requires legislative approval. The executive branch prepares the budget. The legislative branch debates, amends, and approves it. Once approved, the budget becomes law. Spending beyond approved appropriations is illegal and can result in penalties, audits, and political consequences.\n\n'
          'The government budget process follows a rigid annual cycle. In Saudi Arabia, ministries submit budget requests by June, the Ministry of Finance consolidates them by September, the cabinet approves the draft by November, and the Shura Council reviews it by December. The final budget takes effect on January 1.\n\n'
          'Private sector budgets are internal management tools. The finance team prepares the budget, the executive team reviews it, and the board of directors approves it. No external legislative approval is required. Management can reallocate resources and revise budgets throughout the year.\n\n'
          'Budget execution differs sharply. Government entities must track spending against appropriations line by line. Overspending on a line item (even if total spending is within budget) can violate appropriation law.',
      'keyPoint':
          'Government overspending is illegal and audited. Private overspending is a management problem, not a legal one.',
    },
    // Slide 7 — Performance Measurement
    {
      'title': 'Performance Measurement',
      'content':
          'Government entities use multi-dimensional performance frameworks that blend financial and non-financial indicators. Key Performance Indicators include service delivery metrics, efficiency measures, effectiveness indicators, citizen satisfaction surveys, and budget execution rates.\n\n'
          'The concept of "Value for Money" is central to government performance. It has three components: Economy (spending less), Efficiency (spending wisely), and Effectiveness (spending well). A program can be economical and efficient but still fail if it does not achieve its policy objectives.\n\n'
          'Private sector performance is heavily financial. Core metrics include profitability ratios (gross margin, net margin, EBITDA margin, ROI, ROE), market metrics (revenue growth rate, market share), operational efficiency (asset turnover, inventory turnover), and shareholder return (earnings per share, dividends, total shareholder return).\n\n'
          'Saudi Vision 2030 introduced performance-based budgeting for government entities, linking budget allocations to KPIs and strategic objectives.',
      'keyPoint':
          'Government: "Are we delivering better services?" Private: "Are we delivering higher returns?"',
    },
    // Slide 8 — Risk Tolerance & Management
    {
      'title': 'Risk Tolerance & Management',
      'content':
          'Government entities are stewards of public funds — taxpayer money collected involuntarily by law. This creates a fiduciary responsibility to protect those funds and avoid unnecessary risk. Political accountability amplifies risk aversion: a government project that fails becomes a public scandal, media story, and electoral liability.\n\n'
          'Private sector risk tolerance varies by industry, strategy, and ownership structure. Entrepreneurial ventures embrace high risk in pursuit of high returns. Shareholders knowingly accept risk in exchange for potential gains. Importantly, private failures primarily hurt shareholders and creditors who voluntarily accepted the risk.\n\n'
          'Government entities use formal risk assessment frameworks mandated by law, require multiple layers of approval for high-risk projects, and emphasize prevention over mitigation.\n\n'
          'Private companies use cost-benefit analysis to weigh risk against potential return, portfolio diversification, risk-adjusted performance metrics, and insurance and hedging strategies to transfer specific risks.',
      'keyPoint':
          'Government must protect public funds conservatively. Private sector can embrace risk if returns justify it.',
    },
    // Slide 9 — Transparency Requirements
    {
      'title': 'Transparency Requirements',
      'content':
          'Transparency requirements are far more stringent for government entities. Legally mandated transparency includes publication of the annual budget, audited financial statements, supreme audit institution reports, and performance reports.\n\n'
          'Freedom of Information (FOI) laws give citizens the right to request government documents and data. In Saudi Arabia, the National Anti-Corruption Commission and the General Auditing Bureau publish reports on government financial management.\n\n'
          'Private sector transparency requirements are more limited and focused on protecting investors. Public companies must publish quarterly financial statements, annual reports with audited financials, and material disclosures. However, privately held companies face minimal disclosure requirements.\n\n'
          'Government audits are conducted by supreme audit institutions and are often made fully public. Private company audits are conducted by external audit firms hired by the board; results are shared with shareholders and regulators but not necessarily the general public.',
      'keyPoint':
          'Government transparency is a legal requirement for democratic accountability. Private transparency protects investors.',
    },
    // Slide 10 — Financial Reporting Differences
    {
      'title': 'Financial Reporting Differences',
      'content':
          'Government financial reports under IPSAS include the Statement of Financial Position, Statement of Financial Performance, Cash Flow Statement, Statement of Changes in Net Assets, Budget Execution Report, and Notes to the Financial Statements.\n\n'
          'The Budget Execution Report is unique to government. It compares original budget to revised budget to actual results, with variance explanations. Private companies have no equivalent because their budgets are internal tools, not legal instruments.\n\n'
          'Private sector financial reports under IFRS include the Statement of Financial Position (with shareholders\' equity), Statement of Comprehensive Income, Cash Flow Statement, Statement of Changes in Equity, and Notes. Management Discussion and Analysis (MD&A) sections provide narrative context.\n\n'
          'Segment reporting is mandatory for public companies. Government entities produce departmental or program-based reports, but the emphasis is on whole-of-government consolidated financial statements.',
      'keyPoint':
          'Government = Budget compliance + Service delivery | Private = Profitability + Investor returns',
    },
    // Slide 11 — Human Resource Management
    {
      'title': 'Human Resource Management',
      'content':
          'Government employment is governed by civil service laws and regulations that emphasize equity, fairness, and protection of employee rights. Recruitment follows merit-based systems with standardized exams, transparency requirements, and equal opportunity mandates. Salaries are set by centralized pay scales.\n\n'
          'Job security is a hallmark of government employment. Civil servants often enjoy permanent contracts, pension guarantees, and protection from arbitrary dismissal. Career advancement is typically structured and seniority-based.\n\n'
          'Private sector human resource management prioritizes flexibility and performance alignment. Recruitment is market-driven, with companies competing for talent based on compensation, culture, and growth opportunities. Performance-based bonuses, stock options, and commissions are common.\n\n'
          'Job security in the private sector is lower and contingent on performance and market conditions. Employment contracts are often at-will or fixed-term. Career advancement is merit-based and can be rapid for high performers.',
      'keyPoint':
          'Government HR: Stability and equity. Private HR: Flexibility and performance.',
    },
    // Slide 12 — Real-World Examples: Saudi Arabia
    {
      'title': 'Real-World Examples: Saudi Arabia',
      'content':
          'Ministry of Finance (Pure Government): Uses IPSAS, operates under the annual budget approved by the Shura Council, accountable to the King, the Council of Ministers, and the General Auditing Bureau. Success is measured by fiscal sustainability and supporting Vision 2030 objectives.\n\n'
          'Saudi Aramco (Hybrid): 98.5% owned by the government but operates as a commercial entity listed on Tadawul. Uses IFRS, focuses on profitability and shareholder returns. Aramco exemplifies how a state-owned entity can adopt private sector financial management while serving strategic national interests.\n\n'
          'Public Investment Fund (PIF) (Hybrid): A sovereign wealth fund with a dual mandate — generate financial returns AND drive economic diversification under Vision 2030. Invests globally while funding domestic mega-projects (NEOM, Red Sea Development, Qiddiya).\n\n'
          'GOSI (Pure Government): Manages social security, unemployment insurance, and pensions. Collects mandatory contributions, pays benefits based on eligibility — not profitability.\n\n'
          'STC (Hybrid): 70% government-owned but publicly traded on Tadawul and managed as a commercial entity.',
      'keyPoint':
          'Saudi Arabia demonstrates the full spectrum: pure government, hybrid models, and pure private — each with distinct financial management approaches.',
    },
    // Slide 13 — Key Takeaways
    {
      'title': 'Key Takeaways',
      'content':
          'Government exists to serve the public interest, deliver essential services, and steward public resources across generations. Success is measured by service quality, citizen satisfaction, and social outcomes — not by profit. IPSAS provides the accounting framework.\n\n'
          'Private sector exists to generate returns for owners and shareholders. Success is measured by profitability, market share, and shareholder value. IFRS provides the accounting framework.\n\n'
          'The two sectors are increasingly learning from each other. Governments are adopting performance-based budgeting, accrual accounting, cost-benefit analysis, and efficiency metrics from the private sector. Private companies are adopting sustainability reporting and stakeholder accountability.\n\n'
          'Saudi Vision 2030 exemplifies this convergence, pushing government entities toward commercial discipline while requiring private sector participation in national development.\n\n'
          'For finance professionals, the key insight is adaptability. Private sector tools can be adapted for government use, but not copied blindly. Profitability is not the goal, but efficiency matters. Shareholder value is irrelevant, but citizen value is paramount.',
      'keyPoint':
          'The best government finance professionals borrow from the private sector but adapt for public purpose. The best private finance professionals understand government constraints when working with the public sector.',
    },
  ],

  // ── 20 Memory Pairs (from module2-terms.ts) ──
  memoryPairs: [
    {'term': 'Public Service', 'definition': 'الخدمة العامة'},
    {'term': 'Profit Maximization', 'definition': 'تعظيم الأرباح'},
    {'term': 'Public Accountability', 'definition': 'المساءلة العامة'},
    {'term': 'Shareholder Value', 'definition': 'قيمة المساهمين'},
    {'term': 'Taxation', 'definition': 'الضرائب'},
    {'term': 'Equity Financing', 'definition': 'التمويل بالأسهم'},
    {'term': 'Government Bonds', 'definition': 'السندات الحكومية'},
    {'term': 'Sovereign Fund', 'definition': 'صندوق الثروة السيادي'},
    {'term': 'IPSAS', 'definition': 'معايير المحاسبة الدولية للقطاع العام'},
    {'term': 'IFRS', 'definition': 'معايير التقارير المالية الدولية'},
    {'term': 'Budget Appropriation', 'definition': 'اعتماد الميزانية'},
    {'term': 'Performance Audit', 'definition': 'تدقيق الأداء'},
    {'term': 'Civil Service', 'definition': 'الخدمة المدنية'},
    {'term': 'Market Competition', 'definition': 'المنافسة السوقية'},
    {'term': 'Fiscal Policy', 'definition': 'السياسة المالية'},
    {'term': 'Procurement', 'definition': 'المشتريات'},
    {'term': 'Transparency', 'definition': 'الشفافية'},
    {'term': 'Risk Appetite', 'definition': 'الرغبة في المخاطرة'},
    {'term': 'Regulatory Compliance', 'definition': 'الامتثال التنظيمي'},
    {'term': 'Privatization', 'definition': 'الخصخصة'},
  ],

  // ── 80 Quiz Questions (combined from quiz.ts, quiz1.ts, quiz2.ts, quiz3.ts) ──
  quizQuestions: [
    // ═══════════════════════════════════════════
    // Quiz 1: Sector Fundamentals (20 questions)
    // ═══════════════════════════════════════════
    // Q1 (easy)
    {'question': 'What is the primary purpose of government sector organizations?', 'options': ['Maximize profits for shareholders', 'Serve public interest and provide essential services', 'Compete with private businesses', 'Generate returns for investors'], 'correctIndex': 1, 'explanation': 'Government exists to serve the public interest, providing essential services like healthcare, education, infrastructure, and security regardless of profitability.'},
    // Q2 (easy)
    {'question': 'What is the primary focus of private sector organizations?', 'options': ['Public welfare and social equity', 'Profit maximization and shareholder value', 'Compliance with legislative budgets', 'Universal service delivery'], 'correctIndex': 1, 'explanation': 'Private sector organizations exist primarily to generate profits and create value for shareholders through competitive market activities.'},
    // Q3 (easy)
    {'question': 'To whom is government primarily accountable?', 'options': ['Shareholders and investors', 'Board of directors', 'Citizens and taxpayers', 'International creditors'], 'correctIndex': 2, 'explanation': 'Government is accountable to citizens and taxpayers who provide public funds and expect responsible stewardship of resources.'},
    // Q4 (easy)
    {'question': 'Which type of transactions are unique to government revenue?', 'options': ['Product sales to customers', 'Non-exchange transactions like taxes and grants', 'Service fees at market rates', 'Stock dividends'], 'correctIndex': 1, 'explanation': 'Non-exchange transactions (where no direct service is received in return) like taxes and grants are unique to government and require special accounting treatment.'},
    // Q5 (easy)
    {'question': 'How do government and private sector differ in their time horizons?', 'options': ['Both focus equally on quarterly results', 'Government focuses on long-term societal benefits; private sector on shorter financial cycles', 'Private sector plans for generations; government for quarters', 'There is no difference in time horizons'], 'correctIndex': 1, 'explanation': 'Government often focuses on long-term societal benefits (infrastructure, education) spanning generations, while private sector typically focuses on quarterly/annual financial performance.'},
    // Q6 (medium)
    {'question': 'How is success typically measured in the government sector?', 'options': ['Profit margins and earnings per share', 'Service quality, citizen satisfaction, and social outcomes', 'Stock price performance', 'Return on equity'], 'correctIndex': 1, 'explanation': 'Government success is measured by outcomes like service quality, citizen satisfaction, health indicators, education levels, and achievement of social objectives rather than financial profits.'},
    // Q7 (medium)
    {'question': 'Which financial metrics are commonly used in private sector performance measurement?', 'options': ['Citizen satisfaction scores and service coverage', 'ROI, ROE, EBITDA, and earnings per share', 'Budget execution rates and compliance', 'Public health outcomes'], 'correctIndex': 1, 'explanation': 'Private sector uses financial metrics like ROI (Return on Investment), ROE (Return on Equity), EBITDA, and earnings per share to measure profitability and shareholder value creation.'},
    // Q8 (medium)
    {'question': 'What is the key difference between government and private sector revenue sources?', 'options': ['Government revenues are always larger', 'Government relies on non-voluntary sources (taxes); private sector on voluntary market transactions', 'Private sector only uses equity financing', 'No significant difference exists'], 'correctIndex': 1, 'explanation': 'Government revenues are largely non-voluntary (taxes, fees mandated by law) while private sector revenues come from voluntary market transactions where customers choose to buy products/services.'},
    // Q9 (medium)
    {'question': 'How does the private sector typically raise capital?', 'options': ['Taxes and legislative appropriations', 'Equity issuance, bank loans, and corporate bonds', 'Government grants only', 'Mandatory citizen contributions'], 'correctIndex': 1, 'explanation': 'Private sector raises capital through equity issuance (selling shares), bank loans, corporate bonds, and investor funding based on expected returns and creditworthiness.'},
    // Q10 (medium)
    {'question': 'Which accountability mechanism is unique to government?', 'options': ['Shareholder voting at annual meetings', 'Legislative oversight and public audits', 'Stock market performance monitoring', 'Board of directors approval'], 'correctIndex': 1, 'explanation': 'Government faces legislative oversight (parliament/congress), public audits by independent auditors, freedom of information requirements, and electoral accountability - mechanisms unique to the public sector.'},
    // Q11 (medium)
    {'question': 'How do government transparency requirements compare to private sector?', 'options': ['Identical requirements for both', 'Government must publicly disclose budgets and reports; private sector has limited disclosure', 'Private sector has higher transparency requirements', 'No transparency requirements exist for either'], 'correctIndex': 1, 'explanation': 'Government must publicly disclose comprehensive budgets, financial reports, and performance data. Private companies only disclose limited information (mainly if publicly traded), protecting competitive information.'},
    // Q12 (medium)
    {'question': 'In Saudi Arabia, which fund manages oil revenues to support Vision 2030 diversification?', 'options': ['Saudi Central Bank (SAMA)', 'Public Investment Fund (PIF)', 'Ministry of Finance General Reserve', 'Tadawul Stock Exchange'], 'correctIndex': 1, 'explanation': 'The Public Investment Fund (PIF) is Saudi Arabia\'s sovereign wealth fund that manages oil revenues and invests in strategic projects to support Vision 2030 economic diversification goals.'},
    // Q13 (hard)
    {'question': 'What does IPSAS stand for and what is its purpose?', 'options': ['International Private Sector Accounting Standards - for corporations', 'International Public Sector Accounting Standards - for government entities', 'Internal Planning and Strategic Systems - for budgeting', 'Integrated Performance and Service Standards - for quality'], 'correctIndex': 1, 'explanation': 'IPSAS (International Public Sector Accounting Standards) are designed specifically for government and public sector entities to ensure accountability, transparency, and comparability in financial reporting.'},
    // Q14 (hard)
    {'question': 'What does IFRS stand for and who uses it?', 'options': ['International Fiscal Regulation Standards - used by tax authorities', 'International Financial Reporting Standards - used by private sector entities', 'Integrated Finance and Risk Systems - used by banks', 'Internal Financial Review Standards - used by auditors'], 'correctIndex': 1, 'explanation': 'IFRS (International Financial Reporting Standards) are designed for private sector entities to provide investors and stakeholders with comparable, high-quality financial information for decision-making.'},
    // Q15 (hard)
    {'question': 'Why does IPSAS use "net assets/equity" instead of "shareholder equity"?', 'options': ['To make calculations easier', 'Because government entities have no owners in the traditional sense', 'IPSAS and IFRS use identical terminology', 'To comply with tax regulations'], 'correctIndex': 1, 'explanation': 'Government entities are owned by citizens collectively, not shareholders. IPSAS uses "net assets/equity" to reflect this fundamental difference - the government is a steward of public resources, not owned by investors.'},
    // Q16 (hard)
    {'question': 'What unique reporting requirement exists in IPSAS but not IFRS?', 'options': ['Earnings per share calculations', 'Budget vs actual comparison reporting', 'Dividend distribution schedules', 'Market capitalization disclosure'], 'correctIndex': 1, 'explanation': 'IPSAS requires budget vs actual comparison reporting because governments operate under legislative budget approval. This shows accountability in using public funds as authorized. IFRS has no such requirement.'},
    // Q17 (hard)
    {'question': 'How are non-exchange transactions defined in IPSAS?', 'options': ['Any transaction involving foreign currency', 'Transactions where government receives value without directly giving equal value in return', 'Stock market transactions', 'Barter transactions between companies'], 'correctIndex': 1, 'explanation': 'Non-exchange transactions occur when government receives value (like tax payments or grants) without providing directly equivalent value in return. Examples: taxes, fines, donations. This is unique to public sector and requires special recognition rules.'},
    // Q18 (hard)
    {'question': 'Why is IPSAS based on IFRS but requires modifications?', 'options': ['To make accounting more complicated', 'Because public sector has unique transactions like taxes and no profit motive', 'IPSAS is completely different from IFRS', 'To reduce government transparency'], 'correctIndex': 1, 'explanation': 'IPSAS is based on IFRS for consistency but modified because government has unique characteristics: no profit motive, non-exchange transactions (taxes), service delivery focus, budget-based operations, and accountability to citizens rather than investors.'},
    // Q19 (hard)
    {'question': 'In the Saudi context, which entities use IFRS vs IPSAS?', 'options': ['All entities use IFRS only', 'Listed companies on Tadawul use IFRS; government ministries and agencies use IPSAS', 'All entities use IPSAS only', 'Saudi Arabia does not follow international standards'], 'correctIndex': 1, 'explanation': 'Saudi Arabia adopted IFRS for private companies listed on Tadawul stock exchange and IPSAS for government entities as part of Vision 2030 financial reforms to improve transparency and comparability.'},
    // Q20 (hard)
    {'question': 'What is the fundamental stakeholder focus difference between IPSAS and IFRS?', 'options': ['Both serve only internal management', 'IPSAS serves citizens and public accountability; IFRS serves investors and creditors', 'IFRS serves citizens; IPSAS serves investors', 'No stakeholder focus difference exists'], 'correctIndex': 1, 'explanation': 'IPSAS financial statements serve citizens, taxpayers, legislators, and public accountability - focusing on stewardship of public resources. IFRS serves investors and creditors - focusing on investment returns and creditworthiness.'},

    // ═══════════════════════════════════════════
    // Quiz 2: Processes & Operations (20 questions)
    // ═══════════════════════════════════════════
    // Q21 (easy)
    {'question': 'How does government budgeting differ from private sector budgeting?', 'options': ['No significant difference exists', 'Government budgets require legislative approval; private budgets are internal management tools', 'Private sector budgets are legally binding; government budgets are flexible', 'Both types of budgets are identical'], 'correctIndex': 1, 'explanation': 'Government budgets must be approved by legislature (parliament/congress) and are legally binding appropriations. Private sector budgets are internal management tools that can be modified by executives without external approval.'},
    // Q22 (easy)
    {'question': 'What is an "appropriation" in government finance?', 'options': ['A private sector dividend payment', 'Legislative authorization to spend specific amounts for specific purposes', 'An internal budget adjustment', 'A tax collection method'], 'correctIndex': 1, 'explanation': 'An appropriation is a legislative authorization that allows government agencies to spend specific amounts for designated purposes. Spending without proper appropriation is illegal.'},
    // Q23 (easy)
    {'question': 'Can government agencies typically reallocate budget between programs without approval?', 'options': ['Yes, agencies have complete flexibility', 'No, budget reallocations typically require legislative approval', 'Only during election years', 'Only for small amounts under \$100'], 'correctIndex': 1, 'explanation': 'Government budgets are legally binding appropriations. Reallocating funds between programs typically requires legislative approval or specific delegation authority to ensure accountability.'},
    // Q24 (easy)
    {'question': 'How does private sector budgeting flexibility compare to government?', 'options': ['Private sector has less flexibility', 'Private sector has greater flexibility to adjust budgets based on market conditions', 'Both have identical flexibility', 'Private budgets cannot be changed once approved'], 'correctIndex': 1, 'explanation': 'Private sector management can adjust budgets in response to market opportunities or challenges without external approval. This flexibility allows faster response to changing business conditions.'},
    // Q25 (easy)
    {'question': 'What is "value for money" in government performance measurement?', 'options': ['Achieving maximum profits', 'Achieving best outcomes with efficient use of public resources', 'Spending the entire budget allocation', 'Maximizing tax collections'], 'correctIndex': 1, 'explanation': 'Value for money measures whether government achieves the best outcomes (effectiveness) with efficient use of resources (efficiency) - getting maximum public benefit per dollar spent.'},
    // Q26 (medium)
    {'question': 'Which performance indicators are commonly used in government?', 'options': ['Stock price and market capitalization', 'Service delivery outcomes, citizen satisfaction, and program effectiveness', 'Earnings per share and profit margins', 'Dividend yields and return on equity'], 'correctIndex': 1, 'explanation': 'Government uses non-financial indicators like service delivery outcomes (health, education), citizen satisfaction scores, program effectiveness, and achievement of social objectives rather than profit-based metrics.'},
    // Q27 (medium)
    {'question': 'What financial ratios are commonly used in private sector performance analysis?', 'options': ['Budget execution rates and appropriation compliance', 'ROI, ROE, profit margins, and earnings per share', 'Citizen satisfaction and service quality scores', 'Legislative approval ratings'], 'correctIndex': 1, 'explanation': 'Private sector uses financial ratios like ROI (Return on Investment), ROE (Return on Equity), profit margins, P/E ratio, and earnings per share to measure profitability and shareholder value creation.'},
    // Q28 (medium)
    {'question': 'How does government measure efficiency versus effectiveness?', 'options': ['Efficiency = cost per output; Effectiveness = achievement of desired outcomes', 'Both measure the same thing', 'Efficiency = profit; Effectiveness = revenue', 'Only efficiency matters in government'], 'correctIndex': 0, 'explanation': 'Efficiency measures cost per output (e.g., cost per student educated). Effectiveness measures whether desired outcomes were achieved (e.g., improved literacy rates). Government needs both metrics.'},
    // Q29 (medium)
    {'question': 'Why is government risk tolerance generally more conservative?', 'options': ['Government has unlimited resources', 'Government is steward of public funds and failures damage public trust', 'Government cannot borrow money', 'Private sector has zero risk tolerance'], 'correctIndex': 1, 'explanation': 'Government manages taxpayer money and must be conservative because failures can damage public trust, have political consequences, and affect essential services. Private sector can take higher risks with investor capital.'},
    // Q30 (medium)
    {'question': 'How does private sector approach risk differently than government?', 'options': ['Private sector avoids all risks', 'Private sector accepts higher risk for higher returns; investors understand risk-return tradeoff', 'Both sectors have identical risk approaches', 'Government takes more risks than private sector'], 'correctIndex': 1, 'explanation': 'Private sector investors understand that higher risk can yield higher returns. Companies can pursue aggressive strategies if shareholders accept the risk-return tradeoff, with market discipline through stock prices.'},
    // Q31 (medium)
    {'question': 'What are typical government risk management approaches?', 'options': ['High-risk, high-reward investment strategies', 'Formal risk assessments, multiple approvals, emphasis on prevention', 'Accepting failures as learning opportunities', 'No formal risk management needed'], 'correctIndex': 1, 'explanation': 'Government uses formal risk assessment frameworks, requires multiple approval levels for risky projects, emphasizes prevention, conducts extensive due diligence, and faces public scrutiny for failures.'},
    // Q32 (medium)
    {'question': 'Why does government face greater transparency requirements?', 'options': ['Government operations are funded by taxpayers who have a right to information', 'Government has no transparency requirements', 'Private sector has higher transparency requirements', 'Transparency only applies to defense spending'], 'correctIndex': 0, 'explanation': 'Government is funded by taxpayer money, creating a fundamental right to information. Citizens must be able to monitor how public funds are used, driving requirements for budget disclosure, financial reporting, and public audits.'},
    // Q33 (hard)
    {'question': 'A government agency spent 95% of its budget but achieved only 60% of service targets. How should this be evaluated?', 'options': ['Excellent performance - high budget execution', 'Poor performance - low effectiveness despite spending', 'Average performance - some money left over', 'Cannot evaluate without profit data'], 'correctIndex': 1, 'explanation': 'This shows poor effectiveness - high spending but low achievement of service targets. Government performance should focus on outcomes achieved, not just budget execution. This indicates inefficiency or poor program design.'},
    // Q34 (hard)
    {'question': 'Why might a private company deliberately underspend its budget while a government agency would not?', 'options': ['Private companies maximize profit by controlling costs; government agencies may lose unspent appropriations', 'Government agencies always have surplus funds', 'Private companies cannot control spending', 'There is no difference in behavior'], 'correctIndex': 0, 'explanation': 'Private companies benefit from saving money (higher profits). Government agencies often face "use it or lose it" appropriations - unspent funds may be lost and future budgets reduced, creating perverse incentive to spend entire allocation.'},
    // Q35 (hard)
    {'question': 'What is "performance budgeting" in government context?', 'options': ['Budgeting based on employee performance reviews', 'Linking budget allocations to measurable outcomes and performance targets', 'Setting budgets based on profit targets', 'Performance bonuses for budget officers'], 'correctIndex': 1, 'explanation': 'Performance budgeting links funding to measurable outcomes and targets. Instead of just funding inputs (staff, equipment), agencies must demonstrate what outcomes will be achieved, improving accountability and value for money.'},
    // Q36 (hard)
    {'question': 'How do quarterly earnings pressures affect private sector versus government?', 'options': ['Both sectors face identical quarterly pressures', 'Private sector faces pressure to meet quarterly targets; government focuses on annual/multi-year outcomes', 'Government faces more quarterly pressure', 'Neither sector has performance pressures'], 'correctIndex': 1, 'explanation': 'Public companies face intense pressure to meet quarterly earnings expectations from stock markets. Government focuses on annual budget cycles and multi-year outcomes (infrastructure, education), though may face political pressures.'},
    // Q37 (hard)
    {'question': 'What are "freedom of information" laws and how do they differ by sector?', 'options': ['Laws apply equally to both sectors', 'Laws give citizens right to access government records; private companies have limited disclosure requirements', 'Laws only apply to private companies', 'No such laws exist'], 'correctIndex': 1, 'explanation': 'Freedom of information laws give citizens right to request and access government documents and data. Private companies are only required to disclose limited information (especially if publicly traded), protecting trade secrets and competitive information.'},
    // Q38 (hard)
    {'question': 'Why might government deliberately provide unprofitable services that private sector would not?', 'options': ['Government makes poor business decisions', 'Government has a mandate to serve public interest and ensure universal access, not maximize profit', 'Private sector provides all unprofitable services', 'Unprofitable services are always wasteful'], 'correctIndex': 1, 'explanation': 'Government provides unprofitable services (rural healthcare, postal service to remote areas) because its mandate is public welfare and universal access, not profit. Private sector serves profitable markets only.'},
    // Q39 (hard)
    {'question': 'How does political accountability differ from market accountability?', 'options': ['They are identical forms of accountability', 'Political accountability through elections and oversight; market accountability through stock prices and profits', 'Only government faces accountability', 'Only private sector faces accountability'], 'correctIndex': 1, 'explanation': 'Government faces political accountability through elections, legislative oversight, public scrutiny, and media. Private sector faces market accountability through stock prices, profit performance, and potential takeover if underperforming.'},
    // Q40 (hard)
    {'question': 'In Saudi Vision 2030 context, how does PIF balance government mission with commercial returns?', 'options': ['PIF only focuses on maximum profit like private funds', 'PIF pursues strategic national goals (diversification, job creation) while seeking commercial returns', 'PIF ignores financial returns completely', 'PIF operates identically to private equity funds'], 'correctIndex': 1, 'explanation': 'PIF is a sovereign wealth fund balancing dual objectives: achieving Vision 2030 strategic goals (economic diversification, job creation, technology development) while generating commercial returns to sustain Saudi Arabia\'s future prosperity.'},

    // ═══════════════════════════════════════════
    // Quiz 3: Cross-cutting Integration (20 questions)
    // ═══════════════════════════════════════════
    // Q41 (medium)
    {'question': 'How do government financial reporting cycles differ from private sector?', 'options': ['Government reports annually; private sector reports quarterly', 'Government reports align with fiscal year and legislative cycles; private sector with calendar year and earnings seasons', 'Both use identical reporting cycles', 'No reporting requirements exist for either'], 'correctIndex': 1, 'explanation': 'Government reporting aligns with fiscal year (which may differ from calendar year) and legislative budget cycles. Private sector typically reports quarterly earnings and annual reports aligned with calendar or fiscal year.'},
    // Q42 (medium)
    {'question': 'What type of audit is unique to government entities?', 'options': ['Financial statement audit only', 'Performance audit examining efficiency and effectiveness of programs', 'Inventory count audits', 'Marketing effectiveness audits'], 'correctIndex': 1, 'explanation': 'Government undergoes performance audits examining whether programs achieve objectives efficiently and effectively. Private sector focuses mainly on financial statement audits to verify accuracy of financial reporting.'},
    // Q43 (medium)
    {'question': 'How does government HR management differ from private sector?', 'options': ['No significant differences exist', 'Government follows civil service rules with greater job security; private sector has more flexibility', 'Private sector offers more job security', 'Government can hire and fire at will'], 'correctIndex': 1, 'explanation': 'Government employees typically work under civil service systems with standardized pay scales, greater job security, defined benefit pensions, but less flexibility in hiring/firing. Private sector has more flexibility in compensation and employment decisions.'},
    // Q44 (medium)
    {'question': 'What compensation model is typical in government versus private sector?', 'options': ['Government uses standardized pay grades; private sector uses performance-based and market-driven pay', 'Both use identical pay systems', 'Government pays higher salaries', 'Private sector uses standardized grades only'], 'correctIndex': 0, 'explanation': 'Government typically uses standardized pay grades based on position and seniority, ensuring equity. Private sector uses market-driven compensation with performance bonuses, stock options, and variable pay to attract talent and reward results.'},
    // Q45 (medium)
    {'question': 'Why does government typically offer defined benefit pension plans while private sector shifts to defined contribution?', 'options': ['Government wants to spend more money', 'Government provides long-term security to offset lower salaries; private sector reduces long-term liabilities', 'Private sector always provides better benefits', 'No difference in pension approaches exists'], 'correctIndex': 1, 'explanation': 'Government offers defined benefit pensions (guaranteed retirement income) as compensation for lower salaries and to retain experienced staff. Private sector shifts to defined contribution (401k-style) to reduce long-term liabilities and financial risk.'},
    // Q46 (hard)
    {'question': 'How does Saudi Vision 2030 exemplify government-private sector partnership?', 'options': ['Government eliminates all private sector involvement', 'Government sets strategic direction while enabling private sector growth and foreign investment', 'Private sector controls all government decisions', 'No partnership exists'], 'correctIndex': 1, 'explanation': 'Vision 2030 demonstrates government setting strategic national priorities (economic diversification, non-oil revenue, tourism, technology) while creating enabling environment for private sector investment, entrepreneurship, and foreign participation.'},
    // Q47 (hard)
    {'question': 'What role does Saudi Aramco play in bridging government and commercial objectives?', 'options': ['Aramco operates purely as private company ignoring national interests', 'Aramco is government-controlled but listed on Tadawul, balancing national energy security with shareholder returns', 'Aramco has no connection to government', 'Aramco only focuses on profit maximization'], 'correctIndex': 1, 'explanation': 'Saudi Aramco is unique: government-controlled (national oil company) but partially listed on Tadawul stock exchange. It must balance national objectives (energy security, economic development) with commercial performance and shareholder returns - exemplifying hybrid model.'},
    // Q48 (hard)
    {'question': 'How does Saudi Arabia\'s adoption of IPSAS support Vision 2030 transparency goals?', 'options': ['IPSAS reduces transparency', 'IPSAS provides international standard for government financial reporting, improving investor confidence and accountability', 'IPSAS has no relevance to Vision 2030', 'IPSAS only applies to private companies'], 'correctIndex': 1, 'explanation': 'Adopting IPSAS demonstrates Saudi Arabia\'s commitment to international best practices in government financial reporting. This enhances transparency, improves investor confidence for sovereign bonds, supports foreign investment, and strengthens public accountability - all Vision 2030 objectives.'},
    // Q49 (hard)
    {'question': 'What is the purpose of Saudi Arabia\'s privatization program under Vision 2030?', 'options': ['To eliminate all government services', 'To improve efficiency, attract private investment, and reduce government fiscal burden while maintaining service quality', 'To increase government employment', 'To reduce transparency'], 'correctIndex': 1, 'explanation': 'Vision 2030 privatization aims to: improve service efficiency through private sector management, attract local/foreign investment, reduce government fiscal burden, create private sector jobs, while government maintains regulatory oversight to ensure service quality and accessibility.'},
    // Q50 (hard)
    {'question': 'How do Public-Private Partnerships (PPPs) combine both sector strengths?', 'options': ['PPPs eliminate government involvement completely', 'Government provides regulatory framework and public interest focus; private sector provides capital and operational efficiency', 'Private sector sets all regulations', 'PPPs only work in healthcare'], 'correctIndex': 1, 'explanation': 'PPPs leverage government\'s regulatory authority, public service mandate, and land/resources with private sector\'s capital, management expertise, innovation, and efficiency. Examples: toll roads, hospitals, airports, utilities.'},
    // Q51 (hard)
    {'question': 'A hospital provides free emergency care but charges for elective procedures. Is this government or private sector approach?', 'options': ['Purely private sector approach', 'Government approach ensuring essential access while recovering costs for non-essential services', 'This model cannot exist', 'Purely charitable approach'], 'correctIndex': 1, 'explanation': 'This exemplifies government approach: ensuring universal access to essential services (free emergency care) while using cost recovery for non-essential services (elective procedures) - balancing public service mandate with fiscal sustainability.'},
    // Q52 (hard)
    {'question': 'Why might government intentionally maintain excess capacity (hospitals, schools) that private sector would not?', 'options': ['Government makes inefficient decisions', 'To ensure capacity for emergencies and universal access, even if underutilized during normal times', 'Private sector always maintains more capacity', 'Excess capacity is never justified'], 'correctIndex': 1, 'explanation': 'Government maintains strategic excess capacity (extra hospital beds, school seats in rural areas) to ensure service availability during crises and universal access. Private sector optimizes capacity utilization for profit, potentially leaving gaps during surges or in low-profit areas.'},
    // Q53 (hard)
    {'question': 'How does government procurement differ from private sector purchasing?', 'options': ['No meaningful difference exists', 'Government uses competitive bidding with transparency requirements; private sector has flexibility to negotiate', 'Private sector always uses public bidding', 'Government can buy from anyone without process'], 'correctIndex': 1, 'explanation': 'Government procurement requires competitive bidding, public transparency, equal opportunity, documented justifications, and anti-corruption measures. Private sector has flexibility to negotiate, build vendor relationships, and make faster purchasing decisions.'},
    // Q54 (hard)
    {'question': 'What is "intergenerational equity" and why does it matter more to government?', 'options': ['Equal pay across all age groups', 'Ensuring future generations are not burdened by current decisions on debt, environment, and resources', 'Corporate succession planning', 'Hiring practices for young workers'], 'correctIndex': 1, 'explanation': 'Intergenerational equity means current government decisions (debt levels, environmental policies, resource depletion, infrastructure investment) should not unfairly burden future generations. Government has responsibility across generations; private sector focuses on current shareholders.'},
    // Q55 (hard)
    {'question': 'How do government and private sector differ in their approach to innovation risk?', 'options': ['Government takes more innovation risks', 'Government is risk-averse on unproven innovations; private sector can experiment with "fail fast" approach', 'Both have identical innovation approaches', 'Innovation never involves risk'], 'correctIndex': 1, 'explanation': 'Government is typically risk-averse on unproven innovations because failures affect public services and trust. Private sector can adopt "fail fast, learn quickly" approach - testing innovations, accepting some failures as learning, pivoting rapidly based on market feedback.'},
    // Q56 (hard)
    {'question': 'Why might government continue funding a loss-making rural postal service while private courier companies would not?', 'options': ['Government is financially irresponsible', 'Universal service obligation - government ensures access regardless of profitability', 'Private companies always serve rural areas', 'Loss-making services should always be eliminated'], 'correctIndex': 1, 'explanation': 'Government has universal service obligation - ensuring all citizens have access to essential services regardless of location or profitability. Private companies serve profitable markets only. This rural postal service may be essential for isolated communities even if loss-making.'},
    // Q57 (hard)
    {'question': 'How does "regulatory capture" risk differ between sectors?', 'options': ['Only private sector faces this risk', 'Government regulators may be influenced by industries they regulate; private sector has no regulatory authority', 'Both have identical regulatory risks', 'Regulatory capture is always beneficial'], 'correctIndex': 1, 'explanation': 'Regulatory capture occurs when government regulators become too aligned with industries they regulate, potentially prioritizing industry interests over public welfare. This is unique government risk. Private sector doesn\'t have regulatory authority but may attempt to influence regulations.'},
    // Q58 (hard)
    {'question': 'In Saudi Arabia, how does the National Transformation Program (NTP) coordinate sector reforms?', 'options': ['NTP only focuses on private sector', 'NTP sets targets for government agencies to improve efficiency, service delivery, and enable private sector growth', 'NTP eliminates all government services', 'NTP has no connection to Vision 2030'], 'correctIndex': 1, 'explanation': 'National Transformation Program is Vision 2030\'s implementation roadmap for government sector. It sets performance targets for ministries and agencies to: improve efficiency, enhance service quality, reduce bureaucracy, adopt technology, enable private sector, and achieve fiscal sustainability.'},
    // Q59 (hard)
    {'question': 'How do government financial sustainability challenges differ from private sector?', 'options': ['Government faces aging populations and rising healthcare costs with limited revenue flexibility; private can adjust business models', 'Both have identical sustainability challenges', 'Government has unlimited revenue sources', 'Private sector cannot adapt to changes'], 'correctIndex': 0, 'explanation': 'Government faces structural sustainability challenges: aging populations (rising pension/healthcare costs), cannot easily cut services, limited ability to raise taxes. Private sector can adapt business models, enter new markets, restructure, or exit unprofitable lines.'},
    // Q60 (hard)
    {'question': 'What is the fundamental philosophical difference between government and private sector in resource allocation?', 'options': ['No philosophical difference exists', 'Government prioritizes equity and social welfare; private sector prioritizes efficiency and profit', 'Both prioritize profit equally', 'Government only focuses on efficiency'], 'correctIndex': 1, 'explanation': 'Fundamental difference: Government allocates resources based on social welfare, equity, and need (even if inefficient) - everyone deserves healthcare, education. Private sector allocates based on profitability and efficiency - resources go where they generate best returns.'},

    // ═══════════════════════════════════════════
    // Combined Practice Quiz (20 questions — unique selection from quiz1-3)
    // Note: These overlap with quiz1/2/3 above. Including only non-duplicate questions.
    // The combined quiz file re-selects 20 from the same pool. All unique questions
    // are already included above so no additional entries needed.
    // ═══════════════════════════════════════════
  ],

  // ── Classification: 25 items in 2 categories (from module2-classification.ts) ──
  classificationCategories: ['Government Sector', 'Private Sector'],
  classificationItems: [
    // Government Items (13)
    {'name': 'Tax Revenue', 'category': 'Government Sector'},
    {'name': 'IPSAS Standards', 'category': 'Government Sector'},
    {'name': 'Legislative Budget Approval', 'category': 'Government Sector'},
    {'name': 'Citizen Accountability', 'category': 'Government Sector'},
    {'name': 'Public Service Delivery', 'category': 'Government Sector'},
    {'name': 'Net Assets (Equity Term)', 'category': 'Government Sector'},
    {'name': 'Budget Compliance Reporting', 'category': 'Government Sector'},
    {'name': 'Non-Exchange Transactions', 'category': 'Government Sector'},
    {'name': 'Public Audit Reports', 'category': 'Government Sector'},
    {'name': 'Freedom of Information', 'category': 'Government Sector'},
    {'name': 'Low Risk Tolerance', 'category': 'Government Sector'},
    {'name': 'Long-term Societal Focus', 'category': 'Government Sector'},
    {'name': 'Value for Money Principle', 'category': 'Government Sector'},
    // Private Sector Items (12)
    {'name': 'Shareholder Returns', 'category': 'Private Sector'},
    {'name': 'IFRS Standards', 'category': 'Private Sector'},
    {'name': 'Board Approval for Budget', 'category': 'Private Sector'},
    {'name': 'Investor Accountability', 'category': 'Private Sector'},
    {'name': 'Profit Maximization', 'category': 'Private Sector'},
    {'name': 'Equity (Ownership)', 'category': 'Private Sector'},
    {'name': 'ROI and ROE Metrics', 'category': 'Private Sector'},
    {'name': 'Market Transactions', 'category': 'Private Sector'},
    {'name': 'Confidential Trade Secrets', 'category': 'Private Sector'},
    {'name': 'Earnings Per Share', 'category': 'Private Sector'},
    {'name': 'Higher Risk for Higher Returns', 'category': 'Private Sector'},
    {'name': 'Quarterly Financial Focus', 'category': 'Private Sector'},
  ],

  // ── Statement Builder: 30 items in 3 categories (from module2-statements.ts) ──
  statementBuilderCategories: [
    'Government Approach',
    'Private Approach',
    'Both Sectors',
  ],
  statementBuilderItems: [
    // Government-Only Approaches (10)
    {'name': 'Mandatory public budget disclosure', 'category': 'Government Approach'},
    {'name': 'Legislative appropriation process', 'category': 'Government Approach'},
    {'name': 'Citizen satisfaction surveys', 'category': 'Government Approach'},
    {'name': 'Tax collection authority', 'category': 'Government Approach'},
    {'name': 'IPSAS financial statements', 'category': 'Government Approach'},
    {'name': 'Budget execution rate monitoring', 'category': 'Government Approach'},
    {'name': 'Non-exchange transaction accounting', 'category': 'Government Approach'},
    {'name': 'Public audit bureau oversight', 'category': 'Government Approach'},
    {'name': 'Intergenerational equity consideration', 'category': 'Government Approach'},
    {'name': 'Electoral accountability', 'category': 'Government Approach'},
    // Private-Only Approaches (10)
    {'name': 'Shareholder dividend distribution', 'category': 'Private Approach'},
    {'name': 'Board-approved internal budget', 'category': 'Private Approach'},
    {'name': 'Market share growth strategy', 'category': 'Private Approach'},
    {'name': 'Product pricing for profit', 'category': 'Private Approach'},
    {'name': 'IFRS compliant reporting', 'category': 'Private Approach'},
    {'name': 'ROI-based investment decisions', 'category': 'Private Approach'},
    {'name': 'Earnings per share reporting', 'category': 'Private Approach'},
    {'name': 'Confidential business plans', 'category': 'Private Approach'},
    {'name': 'Stock option compensation', 'category': 'Private Approach'},
    {'name': 'Quarterly earnings calls', 'category': 'Private Approach'},
    // Both Sectors (10)
    {'name': 'Annual financial statements', 'category': 'Both Sectors'},
    {'name': 'Internal control systems', 'category': 'Both Sectors'},
    {'name': 'External audits', 'category': 'Both Sectors'},
    {'name': 'Risk management policies', 'category': 'Both Sectors'},
    {'name': 'Cash flow management', 'category': 'Both Sectors'},
    {'name': 'Cost control measures', 'category': 'Both Sectors'},
    {'name': 'Employee payroll processing', 'category': 'Both Sectors'},
    {'name': 'Procurement procedures', 'category': 'Both Sectors'},
    {'name': 'Asset depreciation tracking', 'category': 'Both Sectors'},
    {'name': 'Budget variance analysis', 'category': 'Both Sectors'},
  ],
);
