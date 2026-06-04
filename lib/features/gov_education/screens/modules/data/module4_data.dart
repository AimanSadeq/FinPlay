import '../gov_module_data.dart';

const module4Data = GovModuleContent(
  id: 4,
  title: 'Analysis of Financial Statements',
  gameTitle: 'Order the Ratios',
  gameDescription: 'Put the financial analysis steps in the correct order.',
  gameType: GameType.ordering,

  // ───────────────────────────────────────────────
  // SLIDES  (13 sections from module4-content.ts)
  // ───────────────────────────────────────────────
  slides: [
    // 3.1 — Purpose of Financial Statement Analysis
    {
      'title': 'Purpose of Financial Statement Analysis',
      'content':
          'Financial Statement Analysis (FSA) is the process of examining financial data to evaluate a company\'s performance, assess its financial health, and support informed decision-making. It transforms the raw numbers reported in the Income Statement, Balance Sheet, and Cash Flow Statement into meaningful insights that drive action.\n\n'
          'FSA serves three core purposes. First, it allows users to assess current performance and financial health: Is the company profitable? Can it pay its debts? Is it generating cash? Second, it enables users to monitor trends over time: Is performance improving or deteriorating? Are margins expanding or shrinking? Third, it provides the basis for comparison against peers and industry benchmarks: How does this company stack up against competitors of similar size and scope?\n\n'
          'Every stakeholder relies on FSA to convert data into intelligence. Investors use it to decide whether to buy, hold, or sell. Lenders use it to evaluate creditworthiness. Managers use it to identify operational inefficiencies. Regulators use it to monitor compliance and systemic risk.\n\n'
          'Without analysis, financial statements are just organized data. With analysis, they become a powerful tool for understanding the past, diagnosing the present, and forecasting the future. The techniques covered in this module provide the systematic framework for conducting that analysis.',
      'keyPoint':
          'FSA converts raw data into actionable insights. Three purposes: Assess, Monitor, Compare. Analysis bridges the gap between data and decisions.',
    },
    // 3.2 — Users of Financial Statements
    {
      'title': 'Users of Financial Statements',
      'content':
          'Seven primary user groups rely on financial statement analysis, and each group comes to the statements with different questions and priorities. Understanding who uses the statements and why is essential for producing and interpreting analysis effectively.\n\n'
          'Management asks: "Am I running the business efficiently? Where can I cut costs, grow revenue, or improve returns?" Managers have access to internal data beyond the published statements, but FSA provides the framework for benchmarking their results against the market. Investors and Shareholders ask: "Is my investment growing? Is the company worth more or less than what I paid? Should I buy more, hold, or sell?" They focus heavily on profitability ratios, valuation multiples, and growth trends.\n\n'
          'Lenders and Creditors ask: "Can the borrower repay? What is the default risk? Is there enough cash flow to service the debt?" They focus on liquidity ratios, solvency ratios, and cash flow coverage. Regulators ask: "Is the company compliant with reporting standards? Are disclosures adequate? Is there systemic risk?" They focus on completeness, accuracy, and adherence to IFRS or GAAP.\n\n'
          'Employees ask: "Is the company stable enough to protect my job and pay my salary?" They watch revenue trends, profitability, and cash reserves. Suppliers ask: "Will this customer pay on time? Should I extend trade credit or demand cash up front?" They look at liquidity ratios and payment history. Customers ask: "Is this company a reliable long-term partner? Will they be around to honor warranties and service contracts?" They look at solvency and going-concern indicators.\n\n'
          'Despite their different perspectives, all seven groups rely on the same set of published financial statements. This is why financial reporting standards (IFRS, GAAP) exist: to ensure a single, consistent set of statements can serve all users fairly.',
      'keyPoint':
          'Management, Investors, Lenders, Regulators, Employees, Suppliers, Customers — each asks different questions but all rely on the same financial statements.',
    },
    // 3.3 — Why Ratios?
    {
      'title': 'Why Ratios?',
      'content':
          'Raw financial numbers are almost meaningless in isolation. A company reporting \$10 million in net income sounds impressive, but is it? That depends entirely on context. If the company invested \$1 billion to earn that \$10 million, the return is just 1% — far below what a simple savings account might yield. If it invested \$50 million, the return is 20% — exceptional. Ratios provide that context.\n\n'
          'Ratios offer three key benefits. First, they standardise financial data so that companies of different sizes can be compared on equal footing. Expressing performance as ratios or percentages removes the distortion caused by absolute size. A startup with \$500K revenue and \$50K profit has the same 10% net margin as a multinational with \$5B revenue and \$500M profit — the ratio makes the comparison possible.\n\n'
          'Second, ratios enable benchmarking. You can compare a company\'s ratios against industry averages, direct competitors, or internal targets. Is a 35% gross margin good? It depends on the industry: excellent for a grocery chain (where 25% is typical), poor for a software company (where 70%+ is common). Benchmarking provides the reference frame.\n\n'
          'Third, ratios allow you to track performance over time. Monitoring the same ratio across quarters or years reveals whether the business is improving, stable, or deteriorating. A declining current ratio over three consecutive years may signal emerging liquidity stress, even if the absolute number still looks acceptable today.\n\n'
          'The critical insight: a single ratio is a snapshot; a series of ratios tells a story. Always compare ratios against at least one benchmark — the prior year, the industry average, or the strategic plan — before drawing conclusions.',
      'keyPoint':
          'Standardise: compare companies of different sizes. Benchmark: measure against peers and industry. Track: monitor changes over time. A ratio in isolation means little — context is everything.',
    },
    // 3.4 — Horizontal Analysis
    {
      'title': 'Horizontal Analysis',
      'content':
          'Horizontal analysis compares the same line item across two or more periods to identify changes in magnitude and direction. It is the most intuitive form of financial analysis: you simply ask, "How did this number change from one period to the next?"\n\n'
          'Two calculations are performed for each line item. The Dollar Change equals the Current Year amount minus the Base Year amount. The Percentage Change equals the Dollar Change divided by the Base Year amount, multiplied by 100. Both are important: the dollar change shows the absolute impact; the percentage change shows the relative significance.\n\n'
          'Example: Revenue was \$500,000 last year and \$600,000 this year. Dollar change = \$100,000. Percentage change = (\$100,000 / \$500,000) x 100 = 20%. Now consider that Rent Expense went from \$50,000 to \$55,000. Dollar change = \$5,000. Percentage change = 10%. Although the revenue increase is larger in dollar terms, the rent increase may actually warrant more attention if rental contracts were supposed to be fixed.\n\n'
          'Horizontal analysis is the foundation of trend identification. It answers questions like: Is revenue growing faster than expenses? Are assets expanding or contracting? Is debt increasing relative to equity? Analysts typically perform horizontal analysis across at least two years, but three to five years provides a much richer picture.\n\n'
          'Common pitfalls: a very small base-year figure can produce a misleadingly large percentage change (\$1,000 to \$3,000 is a 200% increase but only \$2,000 in absolute terms). Always consider both the dollar and percentage figures together.',
      'keyPoint':
          'Dollar Change = Current Year - Base Year. Percentage Change = (Dollar Change / Base Year) x 100. Always report both dollar and percentage changes.',
    },
    // 3.5 — Trend Analysis
    {
      'title': 'Trend Analysis',
      'content':
          'Trend analysis extends horizontal analysis across multiple periods — typically three to five or more years — by indexing every year to a common base. This technique smooths out one-year anomalies and reveals the underlying direction of a line item over time.\n\n'
          'To perform trend analysis, choose a base year and assign it an index of 100. Then express every subsequent year as a percentage of that base. The formula is: Trend Index = (Current Year Amount / Base Year Amount) x 100. A rising index indicates growth from the base year; a falling index indicates decline.\n\n'
          'Example: Base-year (Year 1) revenue = \$400,000 (index = 100). Year 2 revenue = \$440,000 (index = 110, meaning 10% growth from base). Year 3 revenue = \$520,000 (index = 130, meaning 30% growth from base). Year 4 revenue = \$500,000 (index = 125). The trend shows strong growth through Year 3, followed by a slight pullback in Year 4. This inflection point — where the trend changes direction — is exactly what you are looking for.\n\n'
          'Trend analysis is particularly powerful when applied to related line items simultaneously. If revenue is indexed at 130 but Cost of Goods Sold is indexed at 150, costs are outpacing revenue — a warning that margins are under pressure. If operating expenses are indexed at 110 while revenue is at 130, the company is growing more efficiently.\n\n'
          'The key advantage over simple horizontal analysis is perspective: horizontal analysis tells you what changed between two adjacent years. Trend analysis tells you where the business has been and where it appears to be heading. Look for inflection points, acceleration, deceleration, and divergence between related items.',
      'keyPoint':
          'Trend Index = (Current Year / Base Year) x 100. Base year always = 100. Compare trends of related items to spot divergence. Look for inflection points.',
    },
    // 3.6 — Vertical (Common-Size) Analysis
    {
      'title': 'Vertical (Common-Size) Analysis',
      'content':
          'Vertical analysis — also called common-size analysis — expresses each line item as a percentage of a base figure within the same period. Unlike horizontal analysis, which compares across time, vertical analysis compares within a single period to reveal the structural composition of the financial statements.\n\n'
          'On the Income Statement, the base is Revenue (set to 100%). Every other line — COGS, gross profit, operating expenses, net income — is expressed as a percentage of revenue. This instantly reveals the cost structure: if COGS is 60% of revenue, you know that 60 cents of every dollar earned goes to direct production costs. If SG&A is 25%, another quarter of revenue is consumed by selling and administrative activities. Net margin is whatever remains.\n\n'
          'On the Balance Sheet, the base is Total Assets (set to 100%). Each asset, liability, and equity item is expressed as a percentage of total assets. This reveals the capital structure: what proportion of assets is financed by debt vs equity, how much of the asset base is tied up in fixed assets vs current assets, and how liquid the company\'s position is.\n\n'
          'The greatest strength of vertical analysis is that it eliminates size differences. A \$10 million company and a \$10 billion company can be compared side by side because both are expressed in percentages. You can immediately see that Company A spends 15% of revenue on R&D while Company B spends only 5%, regardless of their absolute size.\n\n'
          'Vertical analysis also tracks structural changes over time. If COGS as a percentage of revenue climbed from 55% to 62% over three years, the company is losing cost efficiency — even if absolute revenue grew. This insight would be invisible in horizontal analysis alone.',
      'keyPoint':
          'Income Statement base = Revenue (100%). Balance Sheet base = Total Assets (100%). Eliminates size differences for cross-company comparison.',
    },
    // 3.7 — Five Categories of Financial Ratios
    {
      'title': 'Five Categories of Financial Ratios',
      'content':
          'Financial ratios are organised into five categories, each answering a fundamentally different question about the business. Together, they provide a comprehensive, multi-dimensional view of financial health. Relying on just one category is like diagnosing a patient by checking only their temperature — you need the full set of vitals.\n\n'
          'Liquidity ratios answer: "Can the company pay its short-term obligations as they come due?" They compare current assets to current liabilities and reveal whether the company has enough liquid resources to meet near-term commitments. A company can be profitable and still fail if it runs out of cash.\n\n'
          'Activity (Efficiency) ratios answer: "How well does the company use its assets to generate revenue?" They measure how quickly inventory sells, how fast customers pay, and how productively total assets are deployed. High efficiency means less capital tied up in idle assets.\n\n'
          'Profitability ratios answer: "How much profit does the company generate relative to its revenue, assets, or equity?" They measure margins, returns, and the overall earning power of the business. Profitability is the ultimate test of management effectiveness.\n\n'
          'Valuation ratios answer: "How does the market price the company relative to its earnings, book value, or cash flow?" They connect internal financial performance to external market perception and are primarily used by investors to assess whether a stock is overvalued or undervalued.\n\n'
          'Solvency (Leverage) ratios answer: "Can the company meet its long-term obligations, and how much does it rely on debt?" They measure the balance between debt and equity financing and the company\'s ability to service its interest payments. Excessive leverage amplifies both gains and losses.',
      'keyPoint':
          'Liquidity: short-term obligations. Activity: asset efficiency. Profitability: earning power. Valuation: market perception. Solvency: long-term obligations.',
    },
    // 3.8 — Liquidity Ratios
    {
      'title': 'Liquidity Ratios',
      'content':
          'Liquidity ratios measure the company\'s ability to meet its short-term obligations — bills, wages, loan payments, and supplier invoices due within the next twelve months. A company that cannot meet these obligations faces operational disruption, credit downgrades, and potentially bankruptcy, regardless of how profitable it appears on paper.\n\n'
          'The Current Ratio is the broadest measure: Current Assets divided by Current Liabilities. A ratio above 1.0 means the company has more current assets than current liabilities. Example: \$800,000 in current assets and \$400,000 in current liabilities gives a current ratio of 2.0 — meaning \$2 of current assets for every \$1 of current liabilities. Generally, 1.5 to 2.0 is considered healthy, though this varies by industry.\n\n'
          'The Quick Ratio (Acid Test) is more conservative: it strips out inventory because inventory may take time to sell and may not fetch full value in a fire sale. The formula is (Current Assets minus Inventory) divided by Current Liabilities. Using the same example, if \$300,000 of the \$800,000 in current assets is inventory, the quick ratio is (\$800,000 - \$300,000) / \$400,000 = 1.25. A quick ratio above 1.0 is generally considered adequate.\n\n'
          'The Cash Ratio is the most conservative of all: Cash and Cash Equivalents divided by Current Liabilities. It answers the question: "If no receivables were collected and no inventory were sold, could the company still pay its bills?" This is the stress-test ratio. Very few companies maintain a cash ratio above 1.0 because holding too much cash is inefficient.\n\n'
          'Interpreting liquidity ratios requires industry context. A grocery retailer with rapid inventory turnover can safely operate with a lower current ratio than a manufacturer with slow-moving inventory. Always compare against industry norms and the company\'s own historical ratios.',
      'keyPoint':
          'Current Ratio = CA / CL (broad). Quick Ratio strips inventory. Cash Ratio is most conservative. Always compare against industry benchmarks.',
    },
    // 3.9 — Activity (Efficiency) Ratios
    {
      'title': 'Activity (Efficiency) Ratios',
      'content':
          'Activity ratios — also called efficiency or turnover ratios — measure how effectively a company converts its assets into revenue and cash. A company with strong activity ratios is squeezing more value out of every dollar invested in assets, which means less capital is tied up and more cash is available for growth or distribution.\n\n'
          'Inventory Turnover equals Cost of Goods Sold divided by Average Inventory. It tells you how many times the company sold and replaced its entire inventory stock during the period. An inventory turnover of 8 means the company cycled through its inventory 8 times in the year. Higher is generally better — it means products are selling quickly and less capital is locked in warehouses. Average Inventory is calculated as (Beginning Inventory + Ending Inventory) / 2.\n\n'
          'Days Sales Outstanding (DSO) equals Accounts Receivable divided by Revenue, multiplied by 365. It measures the average number of days it takes to collect payment from customers after a sale. A DSO of 45 means customers take an average of 45 days to pay. Lower DSO is better — it means cash is coming in faster. Rising DSO can signal that customers are struggling to pay or that credit policies are too loose.\n\n'
          'Days Payable Outstanding (DPO) equals Accounts Payable divided by Cost of Goods Sold, multiplied by 365. It measures the average number of days the company takes to pay its suppliers. A higher DPO means the company holds onto its cash longer, which can be strategic — but pushing DPO too high can damage supplier relationships.\n\n'
          'Asset Turnover equals Revenue divided by Total Assets. It measures how many dollars of revenue the company generates for every dollar invested in assets. An asset turnover of 1.5 means the company generates \$1.50 in revenue for every \$1 of assets. Capital-intensive industries (utilities, manufacturing) tend to have lower asset turnover; asset-light businesses (consulting, software) tend to have higher asset turnover.',
      'keyPoint':
          'Inventory Turnover = COGS / Avg Inventory. DSO = (A/R / Revenue) x 365. DPO = (A/P / COGS) x 365. Asset Turnover = Revenue / Total Assets.',
    },
    // 3.10 — Profitability Ratios
    {
      'title': 'Profitability Ratios',
      'content':
          'Profitability ratios measure how effectively the company converts revenue into profit at various stages of the income statement. They are the ratios that most directly answer the question every stakeholder cares about: "Is this company making money, and how much?"\n\n'
          'Gross Margin equals Gross Profit divided by Revenue, expressed as a percentage. It shows how much of each revenue dollar remains after covering direct production costs (COGS). A gross margin of 40% means \$0.40 of every \$1 of revenue survives COGS. Gross margin reflects pricing power and production efficiency. A declining gross margin may indicate rising input costs, competitive pricing pressure, or an unfavourable shift in product mix.\n\n'
          'Net Margin equals Net Income divided by Revenue, expressed as a percentage. It is the bottom-line measure — the percentage of revenue that ultimately becomes profit after ALL expenses (COGS, operating expenses, interest, taxes). A net margin of 12% means \$0.12 of every revenue dollar reaches the bottom line. Net margin captures everything: operational efficiency, financial structure, and tax management.\n\n'
          'Return on Assets (ROA) equals Net Income divided by Total Assets. It measures how much profit the company generates for every dollar invested in assets, regardless of how those assets are financed (debt or equity). ROA answers: "How productively is the company deploying its asset base?" An ROA of 8% means every \$100 of assets generates \$8 of profit.\n\n'
          'Return on Equity (ROE) equals Net Income divided by Shareholders\' Equity. It measures the return delivered to the owners of the business. ROE is the single most important ratio for shareholders because it directly measures the return on their investment. An ROE of 15% means every \$100 of equity investment generates \$15 of profit. However, ROE can be artificially inflated by high leverage — which is why DuPont analysis decomposes ROE into its underlying drivers.',
      'keyPoint':
          'Gross Margin = Gross Profit / Revenue. Net Margin = Net Income / Revenue. ROA = Net Income / Total Assets. ROE = Net Income / Equity. ROE can be inflated by leverage.',
    },
    // 3.11 — Valuation Ratios
    {
      'title': 'Valuation Ratios',
      'content':
          'Valuation ratios connect a company\'s internal financial performance to its external market price. While the previous ratio categories measure how the business is performing operationally, valuation ratios measure how the market perceives that performance. They are primarily used by investors to decide whether a stock is overvalued, fairly valued, or undervalued.\n\n'
          'The Price-to-Earnings Ratio (P/E) equals Share Price divided by Earnings Per Share (EPS). It tells you how much investors are willing to pay for each dollar of current earnings. A P/E of 20 means investors pay \$20 for every \$1 of annual earnings. A high P/E suggests investors expect strong future growth (they are paying a premium for expected earnings). A low P/E may indicate a value opportunity or a company in trouble — context is essential.\n\n'
          'The Price-to-Book Ratio (P/B) equals Share Price divided by Book Value Per Share. Book value is the accounting value of equity (Total Assets minus Total Liabilities divided by shares outstanding). A P/B of 1.0 means the market values the company exactly at its accounting value. A P/B above 1.0 means the market believes the company is worth more than its book value — often because of intangible assets like brand, talent, or intellectual property that do not fully appear on the balance sheet.\n\n'
          'EV/EBITDA equals Enterprise Value divided by EBITDA. Enterprise Value is Market Capitalisation plus Total Debt minus Cash. EBITDA is Earnings Before Interest, Taxes, Depreciation, and Amortisation. This ratio values the entire firm (not just equity) relative to its operating cash flow proxy. It is widely used in M&A because it is capital-structure-neutral.\n\n'
          'Dividend Yield equals Annual Dividends Per Share divided by Share Price, expressed as a percentage. It measures the income return to shareholders from dividends alone, excluding capital gains. A yield of 4% means the investor earns \$4 in dividends for every \$100 invested. High-yield stocks attract income-focused investors; low-yield or zero-yield stocks attract growth-focused investors who prefer the company reinvest profits.',
      'keyPoint':
          'P/E = Share Price / EPS. P/B = Share Price / Book Value. EV/EBITDA = Enterprise Value / EBITDA. Dividend Yield = DPS / Share Price. Valuation reflects market expectations.',
    },
    // 3.12 — Solvency (Leverage) Ratios
    {
      'title': 'Solvency (Leverage) Ratios',
      'content':
          'Solvency ratios — also called leverage ratios — measure the company\'s ability to meet its long-term obligations and the degree to which it relies on debt financing. While liquidity ratios focus on the next twelve months, solvency ratios take the long view: can this company survive and service its debt over years and decades?\n\n'
          'The Debt-to-Equity Ratio (D/E) equals Total Debt divided by Shareholders\' Equity. It measures how much debt the company uses for every dollar of equity. A D/E of 1.5 means the company has \$1.50 of debt for every \$1.00 of equity. Higher D/E means more financial leverage — which amplifies returns in good times but magnifies losses in bad times. A D/E above 2.0 is generally considered aggressive, though acceptable levels vary dramatically by industry (utilities and real estate routinely carry higher leverage).\n\n'
          'The Debt Ratio equals Total Liabilities divided by Total Assets. It shows what fraction of the company\'s assets is financed by debt (in the broad sense, including all liabilities). A debt ratio of 0.60 means 60% of assets are financed by creditors and 40% by equity holders. The higher the ratio, the greater the financial risk.\n\n'
          'Interest Coverage equals EBIT (Earnings Before Interest and Taxes) divided by Interest Expense. It measures how many times the company\'s operating earnings can cover its interest payments. An interest coverage of 5.0 means the company earns five times its interest obligation — a comfortable margin. An interest coverage below 1.5 is a red flag: the company is struggling to generate enough earnings to service its debt, and any downturn could trigger default.\n\n'
          'The Equity Multiplier equals Total Assets divided by Shareholders\' Equity. It measures financial leverage — how many dollars of assets are supported by each dollar of equity. An equity multiplier of 2.5 means the company has \$2.50 of assets for every \$1.00 of equity, which implies \$1.50 of debt per dollar of equity. The equity multiplier is a key component of DuPont analysis and directly connects leverage to ROE.',
      'keyPoint':
          'D/E = Total Debt / Equity. Debt Ratio = Total Liabilities / Total Assets. Interest Coverage = EBIT / Interest Expense. Interest Coverage < 1.5x is a red flag.',
    },
    // 3.13 — DuPont Analysis
    {
      'title': 'DuPont Analysis',
      'content':
          'DuPont analysis is a powerful framework that decomposes Return on Equity (ROE) into three component ratios, revealing not just WHAT the shareholder return is, but WHY it is at that level. Two companies can have identical ROE figures while achieving them through entirely different — and differently risky — strategies.\n\n'
          'The DuPont formula is: ROE = Net Margin x Asset Turnover x Equity Multiplier. Each component represents a distinct driver. Net Margin (Net Income / Revenue) measures profitability — how much of each revenue dollar becomes profit. Asset Turnover (Revenue / Total Assets) measures efficiency — how many revenue dollars each asset dollar generates. Equity Multiplier (Total Assets / Shareholders\' Equity) measures leverage — how much the company amplifies equity with debt.\n\n'
          'Consider Company A with an ROE of 15%, decomposed as: 5% net margin x 2.0 asset turnover x 1.5 equity multiplier = 15%. This company earns a moderate margin, uses its assets efficiently, and employs conservative leverage. Now consider Company B, also with 15% ROE: 3% net margin x 1.0 asset turnover x 5.0 equity multiplier = 15%. Company B earns a thin margin, uses its assets poorly, and relies heavily on debt to deliver the same ROE. Company B is far riskier.\n\n'
          'DuPont analysis tells managers exactly where to focus improvement efforts. If net margin is low, work on cost control or pricing. If asset turnover is low, reduce idle assets or improve revenue generation. If the equity multiplier is the primary driver, the company is relying on leverage — which works until interest rates rise or earnings decline.\n\n'
          'The framework also reveals trade-offs. Luxury brands typically have high margins but low asset turnover (expensive stores, low volume). Discount retailers have low margins but very high asset turnover (high volume, rapid inventory cycling). Both models can produce strong ROE — DuPont analysis helps you understand which model is at work and whether it is sustainable.',
      'keyPoint':
          'ROE = Net Margin x Asset Turnover x Equity Multiplier. Same ROE can hide very different risk profiles. DuPont reveals whether returns are driven by margins, efficiency, or leverage.',
    },
  ],

  // ───────────────────────────────────────────────
  // MEMORY PAIRS  (20 pairs from module4-terms.ts)
  // ───────────────────────────────────────────────
  memoryPairs: [
    {'term': 'Current Ratio', 'definition': '\u0646\u0633\u0628\u0629 \u0627\u0644\u062a\u062f\u0627\u0648\u0644'},
    {'term': 'Quick Ratio', 'definition': '\u0646\u0633\u0628\u0629 \u0627\u0644\u0633\u064a\u0648\u0644\u0629 \u0627\u0644\u0633\u0631\u064a\u0639\u0629'},
    {'term': 'Return on Equity', 'definition': '\u0627\u0644\u0639\u0627\u0626\u062f \u0639\u0644\u0649 \u062d\u0642\u0648\u0642 \u0627\u0644\u0645\u0644\u0643\u064a\u0629'},
    {'term': 'Return on Assets', 'definition': '\u0627\u0644\u0639\u0627\u0626\u062f \u0639\u0644\u0649 \u0627\u0644\u0623\u0635\u0648\u0644'},
    {'term': 'Gross Margin', 'definition': '\u0647\u0627\u0645\u0634 \u0627\u0644\u0631\u0628\u062d \u0627\u0644\u0625\u062c\u0645\u0627\u0644\u064a'},
    {'term': 'Net Margin', 'definition': '\u0647\u0627\u0645\u0634 \u0635\u0627\u0641\u064a \u0627\u0644\u0631\u0628\u062d'},
    {'term': 'Debt-to-Equity', 'definition': '\u0646\u0633\u0628\u0629 \u0627\u0644\u062f\u064a\u0646 \u0625\u0644\u0649 \u062d\u0642\u0648\u0642 \u0627\u0644\u0645\u0644\u0643\u064a\u0629'},
    {'term': 'Interest Coverage', 'definition': '\u0646\u0633\u0628\u0629 \u062a\u063a\u0637\u064a\u0629 \u0627\u0644\u0641\u0627\u0626\u062f\u0629'},
    {'term': 'Horizontal Analysis', 'definition': '\u0627\u0644\u062a\u062d\u0644\u064a\u0644 \u0627\u0644\u0623\u0641\u0642\u064a'},
    {'term': 'Vertical Analysis', 'definition': '\u0627\u0644\u062a\u062d\u0644\u064a\u0644 \u0627\u0644\u0631\u0623\u0633\u064a'},
    {'term': 'Trend Analysis', 'definition': '\u062a\u062d\u0644\u064a\u0644 \u0627\u0644\u0627\u062a\u062c\u0627\u0647\u0627\u062a'},
    {'term': 'DuPont Analysis', 'definition': '\u062a\u062d\u0644\u064a\u0644 \u062f\u0648\u0628\u0648\u0646\u062a'},
    {'term': 'Inventory Turnover', 'definition': '\u062f\u0648\u0631\u0627\u0646 \u0627\u0644\u0645\u062e\u0632\u0648\u0646'},
    {'term': 'Days Sales Outstanding', 'definition': '\u0623\u064a\u0627\u0645 \u0627\u0644\u0645\u0628\u064a\u0639\u0627\u062a \u0627\u0644\u0645\u0639\u0644\u0642\u0629'},
    {'term': 'Asset Turnover', 'definition': '\u062f\u0648\u0631\u0627\u0646 \u0627\u0644\u0623\u0635\u0648\u0644'},
    {'term': 'Price/Earnings Ratio', 'definition': '\u0646\u0633\u0628\u0629 \u0627\u0644\u0633\u0639\u0631 \u0625\u0644\u0649 \u0627\u0644\u0631\u0628\u062d\u064a\u0629'},
    {'term': 'Equity Multiplier', 'definition': '\u0645\u0636\u0627\u0639\u0641 \u062d\u0642\u0648\u0642 \u0627\u0644\u0645\u0644\u0643\u064a\u0629'},
    {'term': 'Dividend Yield', 'definition': '\u0639\u0627\u0626\u062f \u0627\u0644\u0623\u0631\u0628\u0627\u062d \u0627\u0644\u0645\u0648\u0632\u0639\u0629'},
    {'term': 'Solvency', 'definition': '\u0627\u0644\u0645\u0644\u0627\u0621\u0629 \u0627\u0644\u0645\u0627\u0644\u064a\u0629'},
    {'term': 'Benchmarking', 'definition': '\u0627\u0644\u0645\u0642\u0627\u0631\u0646\u0629 \u0627\u0644\u0645\u0639\u064a\u0627\u0631\u064a\u0629'},
  ],

  // ───────────────────────────────────────────────
  // CLASSIFICATION  (25 items, 5 categories from module4-ratios.ts)
  // ───────────────────────────────────────────────
  classificationCategories: [
    'Liquidity',
    'Activity',
    'Profitability',
    'Valuation',
    'Solvency',
  ],
  classificationItems: [
    // Liquidity (5)
    {'name': 'Current Ratio', 'category': 'Liquidity'},
    {'name': 'Quick Ratio', 'category': 'Liquidity'},
    {'name': 'Cash Ratio', 'category': 'Liquidity'},
    {'name': 'Working Capital', 'category': 'Liquidity'},
    {'name': 'Operating Cash Flow Ratio', 'category': 'Liquidity'},
    // Activity (5)
    {'name': 'Inventory Turnover', 'category': 'Activity'},
    {'name': 'Days Sales Outstanding', 'category': 'Activity'},
    {'name': 'Days Payable Outstanding', 'category': 'Activity'},
    {'name': 'Asset Turnover', 'category': 'Activity'},
    {'name': 'Receivables Turnover', 'category': 'Activity'},
    // Profitability (5)
    {'name': 'Gross Margin', 'category': 'Profitability'},
    {'name': 'Net Profit Margin', 'category': 'Profitability'},
    {'name': 'Return on Assets (ROA)', 'category': 'Profitability'},
    {'name': 'Return on Equity (ROE)', 'category': 'Profitability'},
    {'name': 'Operating Margin', 'category': 'Profitability'},
    // Valuation (5)
    {'name': 'Price/Earnings (P/E)', 'category': 'Valuation'},
    {'name': 'Price/Book (P/B)', 'category': 'Valuation'},
    {'name': 'EV/EBITDA', 'category': 'Valuation'},
    {'name': 'Dividend Yield', 'category': 'Valuation'},
    {'name': 'Earnings Yield', 'category': 'Valuation'},
    // Solvency (5)
    {'name': 'Debt-to-Equity Ratio', 'category': 'Solvency'},
    {'name': 'Debt Ratio', 'category': 'Solvency'},
    {'name': 'Interest Coverage Ratio', 'category': 'Solvency'},
    {'name': 'Equity Multiplier', 'category': 'Solvency'},
    {'name': 'Debt Service Coverage', 'category': 'Solvency'},
  ],

  // ───────────────────────────────────────────────
  // ORDERING  (kept from placeholder — financial analysis steps)
  // ───────────────────────────────────────────────
  orderingInstruction:
      'Arrange the financial analysis steps in the correct order:',
  orderingItems: [
    'Gather financial statements',
    'Calculate relevant ratios',
    'Compare with benchmarks',
    'Identify trends over time',
    'Draw conclusions',
    'Make recommendations',
  ],

  // ───────────────────────────────────────────────
  // QUIZ  (30 questions: 5 quiz1 + 5 quiz2 + 20 quiz3)
  // All correctAnswer values converted from 1-indexed to 0-indexed
  // ───────────────────────────────────────────────
  quizQuestions: [
    // ── Quiz 1: FSA Foundations (5 questions) ──
    {
      'question': 'What is the primary purpose of financial statement analysis (FSA)?',
      'options': [
        'To prepare financial statements for external reporting',
        'To evaluate a company\'s financial health, performance, and future prospects using its financial data',
        'To replace the need for auditing',
        'To calculate the tax liability of an organization',
      ],
      'correctIndex': 1,
      'explanation':
          'FSA evaluates a company\'s financial health, performance, and future prospects by examining its financial statements. It goes beyond preparation to interpretation and decision support.',
    },
    {
      'question':
          'Why are financial ratios more useful than raw financial numbers for comparison?',
      'options': [
        'Ratios are always bigger numbers',
        'Ratios standardize data, allowing comparison between companies of different sizes',
        'Ratios eliminate the need for financial statements',
        'Ratios are only used by auditors',
      ],
      'correctIndex': 1,
      'explanation':
          'Ratios standardize financial data as percentages or multiples, enabling meaningful comparison between companies of vastly different sizes. A \$10M company and a \$10B company can be compared on profitability, efficiency, and leverage.',
    },
    {
      'question': 'What does horizontal analysis measure?',
      'options': [
        'Each line item as a percentage of a base item within the same period',
        'The dollar and percentage change in financial statement items between two or more periods',
        'The relationship between assets and liabilities',
        'The company\'s market share compared to competitors',
      ],
      'correctIndex': 1,
      'explanation':
          'Horizontal analysis compares the same line item across consecutive periods, calculating both the dollar change and the percentage change. It answers: "How much did this item grow or shrink?"',
    },
    {
      'question':
          'In vertical analysis of the income statement, what is the base item (denominator)?',
      'options': [
        'Net income',
        'Total assets',
        'Revenue (net sales)',
        'Operating expenses',
      ],
      'correctIndex': 2,
      'explanation':
          'In vertical analysis of the income statement, every line item is expressed as a percentage of revenue (net sales). For the balance sheet, the base is total assets.',
    },
    {
      'question': 'What are the five categories of financial ratios?',
      'options': [
        'Revenue, Cost, Profit, Cash, Tax',
        'Liquidity, Activity, Profitability, Valuation, Solvency',
        'Short-term, Medium-term, Long-term, Growth, Risk',
        'Assets, Liabilities, Equity, Revenue, Expenses',
      ],
      'correctIndex': 1,
      'explanation':
          'The five categories are: Liquidity (can you pay short-term bills?), Activity (how efficiently do you use assets?), Profitability (how much do you earn?), Valuation (what is the market willing to pay?), and Solvency (can you survive long-term?).',
    },

    // ── Quiz 2: Financial Ratios (5 questions) ──
    {
      'question':
          'A company has current assets of \$500,000 and current liabilities of \$250,000. What is its Current Ratio?',
      'options': ['0.5', '1.0', '2.0', '250,000'],
      'correctIndex': 2,
      'explanation':
          'Current Ratio = Current Assets / Current Liabilities = 500,000 / 250,000 = 2.0. This means the company has \$2 of current assets for every \$1 of current liabilities.',
    },
    {
      'question':
          'Inventory Turnover is calculated as COGS / Average Inventory. If COGS is \$600,000 and average inventory is \$100,000, how many times per year does inventory turn over?',
      'options': [
        '0.17 times',
        '3 times',
        '6 times',
        '60 times',
      ],
      'correctIndex': 2,
      'explanation':
          'Inventory Turnover = COGS / Average Inventory = 600,000 / 100,000 = 6 times. The company sells and replaces its inventory 6 times per year, or roughly every 61 days (365/6).',
    },
    {
      'question':
          'A company has revenue of \$2,000,000, COGS of \$1,200,000, and operating expenses of \$400,000. What is the Gross Margin?',
      'options': ['20%', '40%', '60%', '80%'],
      'correctIndex': 1,
      'explanation':
          'Gross Margin = (Revenue - COGS) / Revenue = (2,000,000 - 1,200,000) / 2,000,000 = 800,000 / 2,000,000 = 40%. For every dollar of revenue, 40 cents remain after covering production costs.',
    },
    {
      'question':
          'A company has total debt of \$800,000 and shareholders\' equity of \$1,200,000. What is the Debt-to-Equity (D/E) ratio?',
      'options': ['1.5', '0.67', '0.40', '2.0'],
      'correctIndex': 1,
      'explanation':
          'D/E = Total Debt / Shareholders\' Equity = 800,000 / 1,200,000 = 0.67. For every \$1 of equity, the company has \$0.67 of debt. Lower D/E generally indicates lower financial risk.',
    },
    {
      'question': 'What is the DuPont formula for Return on Equity?',
      'options': [
        'ROE = Net Income / Revenue',
        'ROE = Net Margin x Asset Turnover x Equity Multiplier',
        'ROE = Total Assets / Total Equity',
        'ROE = EBIT / Interest Expense',
      ],
      'correctIndex': 1,
      'explanation':
          'The DuPont formula decomposes ROE into three drivers: Net Margin (profitability) x Asset Turnover (efficiency) x Equity Multiplier (leverage). This reveals whether ROE is driven by margins, asset utilization, or debt.',
    },

    // ── Quiz 3: Advanced FSA Integration (20 questions) ──
    {
      'question':
          'A company\'s revenue grew 25% year-over-year but net income grew only 5%. Which analysis technique best reveals this divergence, and what does it suggest?',
      'options': [
        'Vertical analysis; it means the company is growing',
        'Horizontal analysis; costs are rising faster than revenue, eroding margins',
        'DuPont analysis; the equity multiplier has decreased',
        'Trend analysis; the base year must be changed',
      ],
      'correctIndex': 1,
      'explanation':
          'Horizontal analysis compares the percentage change in each line item across periods. When revenue grows 25% but net income grows only 5%, it means expenses are consuming most of the additional revenue -- costs grew faster than sales, squeezing net margin.',
    },
    {
      'question':
          'Company Z has a Current Ratio of 3.0, but its DSO is 120 days and inventory turnover is 2x. Should lenders feel confident about its liquidity?',
      'options': [
        'Yes, a Current Ratio of 3.0 guarantees strong liquidity',
        'No, the high Current Ratio is misleading because receivables and inventory are slow to convert to cash',
        'Yes, activity ratios are irrelevant to liquidity',
        'No, because the Current Ratio is too high, indicating wasted resources',
      ],
      'correctIndex': 1,
      'explanation':
          'A high Current Ratio can be misleading. With DSO of 120 days, customers take 4 months to pay. With inventory turnover of 2x, goods sit for 6 months before selling. The current assets exist on paper, but converting them to cash quickly is doubtful. Activity ratios reveal the quality of liquidity.',
    },
    {
      'question':
          'A company\'s vertical analysis shows SG&A as 30% of revenue in Year 1 and 38% in Year 3. What type of analysis revealed this, and what action should management consider?',
      'options': [
        'Horizontal analysis; the company should increase revenue',
        'Vertical analysis over time (common-size comparison); management should investigate why overhead is consuming a larger share of revenue',
        'DuPont analysis; the equity multiplier has changed',
        'Ratio analysis; the current ratio has declined',
      ],
      'correctIndex': 1,
      'explanation':
          'Comparing vertical analysis across years reveals structural changes in cost composition. SG&A growing from 30% to 38% of revenue means operating costs are taking a bigger slice, reducing operating margin. Management should investigate specific cost drivers (headcount, rent, marketing).',
    },
    {
      'question':
          'Company A and Company B both have ROE of 18%. DuPont decomposition shows: Company A (Margin 12%, Turnover 1.0, Multiplier 1.5) and Company B (Margin 3%, Turnover 2.0, Multiplier 3.0). Which company has a more sustainable ROE?',
      'options': [
        'Company B, because it has higher asset turnover',
        'Company A, because it relies on profitability rather than heavy leverage',
        'Both are equally sustainable since ROE is identical',
        'Neither is sustainable at 18%',
      ],
      'correctIndex': 1,
      'explanation':
          'Company A\'s ROE is margin-driven (12% net margin) with low leverage (1.5x). Company B relies on an Equity Multiplier of 3.0 (67% of assets funded by debt) to compensate for thin 3% margins. In a downturn, Company B\'s debt burden remains while margins may shrink further, threatening solvency.',
    },
    {
      'question':
          'A bank evaluating a loan application would focus most heavily on which ratio categories?',
      'options': [
        'Valuation and profitability only',
        'Liquidity and solvency, plus interest coverage',
        'Activity ratios only',
        'P/E ratio and dividend yield',
      ],
      'correctIndex': 1,
      'explanation':
          'Lenders care most about repayment capacity. Liquidity ratios assess short-term payment ability, solvency ratios evaluate long-term debt sustainability, and interest coverage shows whether earnings can service interest payments. Valuation ratios are more relevant to equity investors.',
    },
    {
      'question':
          'A company reports: Current Ratio 1.8, Quick Ratio 0.6, ROE 25%, D/E 3.5. What is the most critical concern?',
      'options': [
        'The ROE is too high and unsustainable',
        'Extremely high leverage (D/E 3.5) is likely inflating ROE while creating significant bankruptcy risk',
        'The Current Ratio of 1.8 is dangerously low',
        'There are no concerns; all ratios look healthy',
      ],
      'correctIndex': 1,
      'explanation':
          'D/E of 3.5 means the company has \$3.50 of debt for every \$1 of equity. The large gap between Current Ratio (1.8) and Quick Ratio (0.6) indicates heavy reliance on inventory. The high ROE (25%) is likely inflated by leverage, not operational excellence. This company faces significant financial risk.',
    },
    {
      'question':
          'You want to compare the cost structure of a \$50M company with a \$5B industry leader. Which analysis technique is most appropriate?',
      'options': [
        'Horizontal analysis',
        'Vertical (common-size) analysis',
        'Trend analysis',
        'DuPont analysis',
      ],
      'correctIndex': 1,
      'explanation':
          'Vertical (common-size) analysis expresses everything as a percentage, removing the size effect. COGS at 55% vs. 60% is directly comparable regardless of whether revenue is \$50M or \$5B. Horizontal and trend analyses compare the same company over time, not across different-sized companies.',
    },
    {
      'question':
          'Over five years, a company\'s trend indices are: Revenue 100, 110, 125, 140, 160 and Net Income 100, 105, 108, 107, 103. What is happening?',
      'options': [
        'The company is performing excellently -- revenue is growing strongly',
        'Revenue growth is strong but profitability is stagnating and declining, indicating rising costs or pricing pressure',
        'Net income will eventually catch up with revenue growth',
        'The data is insufficient for any conclusion',
      ],
      'correctIndex': 1,
      'explanation':
          'Revenue grew 60% while net income grew only 3% and is now declining. This classic divergence means costs are rising disproportionately. The company may be buying revenue growth through discounting, overspending on expansion, or facing input cost inflation. Margins are collapsing.',
    },
    {
      'question':
          'A company with net margin of 2% and interest coverage of 1.2x is considering taking on additional debt. What would you advise?',
      'options': [
        'Proceed, since debt is cheaper than equity',
        'Avoid additional debt -- thin margins and barely adequate interest coverage leave no safety margin for a downturn',
        'Take maximum debt to boost ROE through leverage',
        'Only borrow if the interest rate is below 2%',
      ],
      'correctIndex': 1,
      'explanation':
          'Interest coverage of 1.2x means EBIT barely exceeds interest expense. Any revenue decline could push it below 1.0x, meaning the company cannot cover interest from operations. Combined with a 2% net margin, there is virtually no buffer. Additional debt would be extremely risky.',
    },
    {
      'question':
          'A company has Asset Turnover of 0.5 and Net Margin of 20%. A competitor has Asset Turnover of 2.0 and Net Margin of 5%. Which generates higher ROA?',
      'options': [
        'The first company (ROA = 10%)',
        'The competitor (ROA = 10%)',
        'Both have the same ROA of 10%, achieved through different strategies',
        'It is impossible to calculate ROA from this data',
      ],
      'correctIndex': 2,
      'explanation':
          'ROA = Net Margin x Asset Turnover. Company 1: 20% x 0.5 = 10%. Competitor: 5% x 2.0 = 10%. Both achieve 10% ROA but through opposite strategies: one via high margins (luxury/premium), the other via high volume (mass market). This illustrates how different business models can achieve similar returns.',
    },
    {
      'question':
          'If horizontal analysis shows COGS grew 10% but vertical analysis shows COGS decreased from 62% to 58% of revenue, what happened?',
      'options': [
        'The analysis contains an error -- both cannot be true',
        'Revenue grew faster than COGS, so COGS increased in dollars but shrank as a proportion of revenue',
        'COGS actually decreased in absolute terms',
        'Vertical analysis is unreliable in this case',
      ],
      'correctIndex': 1,
      'explanation':
          'Both analyses are correct and complementary. COGS grew 10% in absolute dollars (horizontal). But if revenue grew even faster (say 18%), then COGS as a percentage of revenue decreased (vertical). This is positive -- the company improved its gross margin despite higher absolute costs.',
    },
    {
      'question':
          'Company A has P/E of 8 with ROE of 22%. Company B has P/E of 35 with ROE of 10%. Which might represent a better value investment?',
      'options': [
        'Company B, because a higher P/E always means a better company',
        'Company A may be undervalued -- strong profitability at a low price multiple could signal a value opportunity',
        'Neither can be evaluated from this data',
        'The company with higher P/E is always the better investment',
      ],
      'correctIndex': 1,
      'explanation':
          'Company A delivers 22% ROE but trades at only 8x earnings -- investors may be overlooking it. However, the low P/E could also reflect concerns (high leverage, cyclicality). A low P/E with strong fundamentals is a classic value signal, but further analysis is needed to understand why the market discounts it.',
    },
    {
      'question':
          'A CEO asks: "Are we getting better or worse compared to last year?" Which analysis approach should the analyst use first?',
      'options': [
        'Vertical analysis to compare cost structure',
        'Horizontal analysis to calculate year-over-year changes in key line items and ratios',
        'DuPont analysis to decompose ROE',
        'Benchmarking against the industry average',
      ],
      'correctIndex': 1,
      'explanation':
          'Horizontal analysis directly answers "better or worse vs. last year" by computing dollar and percentage changes for revenue, expenses, net income, and key ratios between the two years. Vertical and DuPont analyses would be valuable follow-ups, but horizontal analysis directly addresses the CEO\'s question.',
    },
    {
      'question':
          'A company maintains a very high Current Ratio of 5.0 and zero debt (D/E = 0). Is this optimal?',
      'options': [
        'Yes, maximum liquidity and zero debt is always best',
        'Not necessarily -- excess liquidity may signal idle assets not earning returns, and zero debt means missing the tax benefit of interest deductions',
        'The Current Ratio cannot be too high',
        'Zero debt means the company is about to go bankrupt',
      ],
      'correctIndex': 1,
      'explanation':
          'An extremely high Current Ratio (5.0) suggests the company holds too much cash or inventory that could be invested for better returns. Zero debt avoids financial risk but also forgoes the tax shield from interest deductions and the potential to amplify returns through prudent leverage. Balance is key.',
    },
    {
      'question':
          'A company has DSO of 45 days, Days Inventory Outstanding (DIO) of 60 days, and Days Payable Outstanding (DPO) of 30 days. What is the Cash Conversion Cycle (CCC)?',
      'options': [
        '135 days',
        '75 days',
        '15 days',
        '45 days',
      ],
      'correctIndex': 1,
      'explanation':
          'CCC = DSO + DIO - DPO = 45 + 60 - 30 = 75 days. The company takes 75 days from paying for inventory to collecting cash from sales. A shorter CCC is generally better, as it means cash is tied up for less time.',
    },
    {
      'question':
          'A company\'s DuPont components changed from Year 1 to Year 2: Net Margin 8% to 7%, Asset Turnover 1.2 to 1.4, Equity Multiplier 2.0 to 2.5. ROE changed from 19.2% to 24.5%. What is the primary driver of the ROE increase?',
      'options': [
        'Improved profitability (margin expansion)',
        'Better asset utilization (turnover improvement)',
        'Increased leverage (higher Equity Multiplier), which masks declining margins',
        'All three components improved equally',
      ],
      'correctIndex': 2,
      'explanation':
          'Net margin actually declined (8% to 7%), so profitability worsened. Asset turnover improved modestly (1.2 to 1.4). The biggest change was the Equity Multiplier jumping from 2.0 to 2.5 -- a 25% increase in leverage. The company took on more debt to boost ROE while its core profitability deteriorated.',
    },
    {
      'question':
          'When benchmarking ratios, which comparison provides the most meaningful context?',
      'options': [
        'Comparing a bank\'s ratios to a manufacturing company',
        'Comparing against same-industry peers of similar size and business model',
        'Comparing against the S&P 500 average',
        'Only comparing against the company\'s own history',
      ],
      'correctIndex': 1,
      'explanation':
          'Meaningful benchmarking requires same-industry peers of similar size and business model. A bank and a manufacturer have fundamentally different balance sheet structures, cost profiles, and normal ratio ranges. Industry-specific comparisons provide actionable insights.',
    },
    {
      'question':
          'Vertical analysis shows: COGS 55%, Gross Margin 45%, SG&A 25%, EBIT Margin 20%, Interest 5%, Tax 4%, Net Margin 11%. Where is the biggest cost bucket?',
      'options': [
        'SG&A at 25%',
        'COGS at 55% -- it consumes more than half of every revenue dollar',
        'Interest at 5%',
        'Tax at 4%',
      ],
      'correctIndex': 1,
      'explanation':
          'COGS at 55% is by far the largest cost. Vertical analysis makes this immediately visible: for every \$1 of revenue, \$0.55 goes to production costs, \$0.25 to SG&A, \$0.05 to interest, \$0.04 to tax, leaving \$0.11 as net profit. Any improvement in COGS efficiency would have the greatest impact.',
    },
    {
      'question':
          'A company improves its Quick Ratio from 0.8 to 1.5 by issuing new equity and holding the cash. What happens to its DuPont Equity Multiplier?',
      'options': [
        'The Equity Multiplier increases',
        'The Equity Multiplier decreases because equity increased while assets grew by the same amount',
        'The Equity Multiplier is unaffected',
        'The Equity Multiplier becomes negative',
      ],
      'correctIndex': 1,
      'explanation':
          'Equity Multiplier = Total Assets / Equity. Issuing equity increases both cash (asset) and equity by the same dollar amount. But since equity grows proportionally more (new equity added to existing equity), the ratio Assets/Equity decreases. Lower leverage improves liquidity but reduces the leverage amplification of ROE.',
    },
    {
      'question':
          'An analyst needs to present a complete financial health assessment. Which combination of techniques provides the most comprehensive view?',
      'options': [
        'Only DuPont analysis, since it combines three ratios',
        'Horizontal + Vertical + Trend analysis combined with all five ratio categories and DuPont decomposition',
        'Current Ratio and P/E ratio are sufficient',
        'Only vertical analysis for two periods',
      ],
      'correctIndex': 1,
      'explanation':
          'A comprehensive assessment uses all available tools: horizontal analysis for year-over-year changes, vertical analysis for cost structure, trend analysis for long-term patterns, all five ratio categories (liquidity, activity, profitability, valuation, solvency) for specific dimensions, and DuPont for ROE drivers. No single technique captures the full picture.',
    },
  ],
);
