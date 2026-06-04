import '../gov_module_data.dart';

const module3Data = GovModuleContent(
  id: 3,
  title: 'Understanding Financial Statements',
  gameTitle: 'Match Statement Components',
  gameDescription: 'Match each item with its correct financial statement.',
  gameType: GameType.memoryMatch,
  slides: [
    // Section A: Foundations (LO #1-6)
    {
      'title': 'The Accounting Cycle',
      'content': 'The accounting cycle is the systematic process that organizations follow to record, classify, and summarize financial transactions. It runs continuously, repeating every reporting period (typically monthly, quarterly, and annually).\n\n'
          'The cycle has ten steps organized in three timing zones: During the Period, you (1) identify and analyze transactions, (2) record journal entries, (3) post to the general ledger, and (4) prepare an unadjusted trial balance. At Period-End, you (5) record adjusting entries, (6) prepare an adjusted trial balance, and (7) prepare the financial statements. After Closing, you (8) record closing entries, (9) prepare a post-closing trial balance, and (10) record reversing entries (optional) to start the next period cleanly.\n\n'
          'The accounting cycle ensures that every transaction is captured, that the books balance at every checkpoint, and that the financial statements produced at the end are accurate and complete. Skipping or mishandling any step introduces errors that cascade through the entire set of financial statements.\n\n'
          'Think of the accounting cycle as an assembly line for financial information. Raw materials (transactions) enter at one end, are processed through a series of quality-control stations (journal entries, ledger postings, trial balances), and emerge at the other end as finished goods (the financial statements that stakeholders rely on).',
      'keyPoint': '10 steps in 3 timing zones: During Period, Period-End, After Closing. Trial balances act as checkpoints to catch errors. Adjusting entries match revenue and expenses to the correct period. Closing entries reset temporary accounts for the new period.',
    },
    {
      'title': '10 Key Accounting Principles',
      'content': 'Accounting is governed by a set of foundational principles that ensure financial statements are consistent, comparable, and trustworthy across organizations and time periods.\n\n'
          'Economic Entity Principle: The business is separate from its owners. Personal and business transactions must never be mixed. Going Concern Principle: We assume the company will continue operating indefinitely; we do not value assets at fire-sale prices unless there is evidence of imminent closure.\n\n'
          'Monetary Unit Principle: Only transactions that can be expressed in monetary terms are recorded. Revenue Recognition Principle: Revenue is recognized when it is earned and the performance obligation is satisfied, regardless of when cash is received. Matching Principle: Expenses are recorded in the same period as the revenue they helped generate.\n\n'
          'Full Disclosure Principle: All information that could influence a user\'s decision must be disclosed. Cost Principle: Assets are initially recorded at their historical cost (though some standards allow fair-value revaluation later). Materiality Principle: Only items significant enough to affect decisions need detailed treatment; trivial amounts can be simplified.\n\n'
          'Conservatism Principle: When in doubt, choose the accounting treatment that is less likely to overstate assets or income. Consistency Principle: Once an accounting method is adopted, it should be used consistently from period to period; changes require disclosure and justification.',
      'keyPoint': 'Economic Entity: business is separate from owners. Going Concern: assume the company continues operating. Matching: match expenses to the period they helped earn revenue. Conservatism: when in doubt, do not overstate assets or income. Consistency: use the same methods from period to period.',
    },
    {
      'title': 'Cash Basis vs Accrual Basis',
      'content': 'There are two fundamental methods of recording transactions, and choosing between them changes everything about how financial results look.\n\n'
          'Cash Basis Accounting records revenue when cash is received and expenses when cash is paid. It is simple and shows you exactly how much cash you have, but it can be misleading. Imagine a company that delivers a \$1 million project in December but gets paid in January. Under cash basis, December shows zero revenue and January shows \$1 million, even though all the work was done in December.\n\n'
          'Accrual Basis Accounting records revenue when it is earned and expenses when they are incurred, regardless of when cash changes hands. It gives a more accurate picture of economic reality because it matches effort with results. That \$1 million project would show as December revenue, matching the period when value was delivered.\n\n'
          'IFRS and GAAP both require accrual basis accounting for financial statements. The cash basis is too easy to manipulate and does not reflect the true economic timing of events. However, the cash flow statement provides the cash-basis view alongside the accrual-basis income statement, giving stakeholders both perspectives.\n\n'
          'The key insight: accrual accounting tells you how the business is performing economically. Cash accounting tells you how much money is in the bank. You need both views to manage effectively.',
      'keyPoint': 'Cash Basis: records when cash moves (simple but can be misleading). Accrual Basis: records when earned/incurred (matches economic reality). IFRS and GAAP require accrual basis for financial statements. The Cash Flow Statement provides the cash-basis perspective.',
    },
    {
      'title': 'The 5+1 Main Account Types',
      'content': 'Every transaction in accounting is recorded using accounts that fall into five main types, plus one special type. Understanding these types is the foundation for reading any financial statement.\n\n'
          'Assets — what the company owns or controls. Cash, inventory, buildings, equipment, patents. Assets have future economic value. Liabilities — what the company owes. Loans, accounts payable, bonds, accrued expenses. Liabilities represent obligations to pay in the future.\n\n'
          'Equity — the owners\' residual claim. Common stock (what owners invested) plus retained earnings (profits kept in the business). Equity = Assets minus Liabilities. Revenue — money earned from business operations. Sales, service fees, interest income, rental income. Revenue increases equity.\n\n'
          'Expenses — costs incurred to generate revenue. Salaries, rent, utilities, depreciation, cost of goods sold. Expenses decrease equity. The "+1" is Dividends — distributions of profits to shareholders. Like expenses, dividends decrease equity, but they are not an operating cost. They represent a return of profits to owners.\n\n'
          'These six account types are the building blocks of the three financial statements: the Balance Sheet uses Assets, Liabilities, and Equity. The Income Statement uses Revenue and Expenses. Dividends appear on the Statement of Changes in Equity.',
      'keyPoint': 'Assets (what you own), Liabilities (what you owe), Equity (the residual). Revenue (money earned), Expenses (costs incurred). Dividends = the "+1" — profit returned to owners. These 6 types are the building blocks of all financial statements.',
    },
    {
      'title': 'Four Financial Statements',
      'content': 'Organizations produce four primary financial statements. Together they tell the complete financial story of a business during a given period.\n\n'
          'The Income Statement (Statement of Financial Performance) answers: "Did we make or lose money this period?" It shows revenues earned minus expenses incurred, arriving at net income or net loss. Think of it as the report card for the period.\n\n'
          'The Balance Sheet (Statement of Financial Position) answers: "What is the company\'s financial health right now?" It shows Assets = Liabilities + Equity at a specific point in time. Think of it as a financial photograph.\n\n'
          'The Statement of Cash Flows answers: "Where did the cash come from and where did it go?" It tracks actual cash movements organized into operating, investing, and financing activities. Think of it as the bank account story.\n\n'
          'The Statement of Changes in Equity answers: "How did the owners\' stake change?" It reconciles opening equity through net income, dividends, and other changes to closing equity. Think of it as the ownership ledger.\n\n'
          'These four statements are interconnected: net income from the Income Statement flows into Retained Earnings on the Balance Sheet via the Statement of Changes in Equity. Cash on the Balance Sheet ties to the ending balance on the Cash Flow Statement.',
      'keyPoint': 'Income Statement: Did we profit or lose? (period). Balance Sheet: What is our financial position? (point in time). Cash Flow Statement: Where did cash come from and go? (period). Statement of Changes in Equity: How did ownership change? (period). All four are interconnected.',
    },
    {
      'title': 'Matching Principle & Revenue Recognition',
      'content': 'Two of the most important accounting principles directly determine how the Income Statement is prepared: the Matching Principle and the Revenue Recognition Principle.\n\n'
          'The Revenue Recognition Principle says: recognize revenue when the performance obligation is satisfied — that is, when the goods are delivered or the service is performed. It does not matter when cash is received. If you build a house and deliver it in June, June gets the revenue, even if the buyer pays in September.\n\n'
          'The Matching Principle says: once you have recognized revenue, record the expenses that helped generate that revenue in the same period. If the house cost \$200,000 to build and was delivered in June, both the revenue and the \$200,000 of costs must appear in June, not spread across the months when individual bills were paid.\n\n'
          'Together, these principles ensure that the Income Statement shows a true picture of profitability for each period. Without them, a company could easily make a loss-making quarter look profitable (by delaying expense recognition) or a profitable quarter look terrible (by recognizing future expenses early).\n\n'
          'Common matching adjustments include depreciation (spreading the cost of a building over 30 years), amortization (spreading the cost of a patent over its useful life), and accrued expenses (recording salaries earned by employees even if payday falls in the next period).',
      'keyPoint': 'Revenue Recognition: record revenue when the performance obligation is satisfied. Matching: record the related expenses in the same period as the revenue. Together they ensure the Income Statement reflects true profitability. Common adjustments: depreciation, amortization, accruals.',
    },
    // Section B: Income Statement (LO #7-10)
    {
      'title': 'Single-Step vs Multi-Step Income Statement',
      'content': 'The Income Statement can be presented in two formats, and understanding both is essential for reading any set of financial statements.\n\n'
          'The Single-Step format is the simplest: Total Revenues minus Total Expenses equals Net Income. All revenues are grouped together, all expenses are grouped together, and there is one subtraction. It is easy to prepare but provides limited analytical insight.\n\n'
          'The Multi-Step format breaks the income statement into meaningful stages: Revenue minus Cost of Goods Sold (COGS) equals Gross Profit. Gross Profit minus Operating Expenses equals Operating Income (EBIT). Operating Income plus/minus Non-Operating Items (interest, gains/losses) equals Income Before Tax. Income Before Tax minus Tax Expense equals Net Income.\n\n'
          'The Multi-Step format is far more useful for analysis because each subtotal reveals something important. Gross Profit shows how efficiently you produce your goods. Operating Income shows how well the core business performs. Income Before Tax isolates operating and financial results from tax effects.\n\n'
          'Most publicly traded companies use the multi-step format because investors and analysts need to distinguish between operational performance and non-operating items. A company might have great operating income but poor net income due to a one-time loss on an asset sale — the multi-step format makes this visible.',
      'keyPoint': 'Single-Step: Total Revenue - Total Expenses = Net Income (simple). Multi-Step: Revenue -> Gross Profit -> Operating Income -> Net Income (analytical). Gross Profit reveals production efficiency. Operating Income isolates core business performance. Most public companies use multi-step format.',
    },
    {
      'title': 'Cost of Goods Sold (COGS)',
      'content': 'Cost of Goods Sold (COGS) represents the direct costs of producing or purchasing the goods that a company sold during the period. It is the single largest expense for most companies and the first deduction on a multi-step income statement.\n\n'
          'For a Merchandiser (a company that buys and resells products), COGS is calculated as: Beginning Inventory + Purchases - Ending Inventory. If you started with \$50,000 of inventory, bought \$200,000 more during the year, and ended with \$30,000, your COGS is \$220,000.\n\n'
          'For a Manufacturer (a company that makes products), COGS is more complex: Beginning Finished Goods + Cost of Goods Manufactured - Ending Finished Goods. Cost of Goods Manufactured includes direct materials, direct labor, and manufacturing overhead (factory rent, equipment depreciation, utilities).\n\n'
          'For a Service Company, there is technically no "cost of goods sold" because no physical goods are produced. Instead, service companies report "Cost of Services" or simply include all costs in operating expenses. A consulting firm\'s "COGS equivalent" would be consultant salaries and travel.\n\n'
          'COGS matters because it directly determines Gross Profit (Revenue minus COGS). A company with rising revenue but even faster rising COGS will see its gross margin shrink — a warning sign that it is losing pricing power or cost control.',
      'keyPoint': 'Merchandiser: Beginning Inventory + Purchases - Ending Inventory. Manufacturer: includes direct materials, direct labor, manufacturing overhead. Service companies report Cost of Services instead. COGS determines Gross Profit — the first measure of profitability.',
    },
    {
      'title': 'Variable vs Fixed Costs',
      'content': 'Understanding cost behavior — how costs change as activity levels change — is critical for planning, budgeting, and decision-making.\n\n'
          'Variable Costs change in direct proportion to activity. If you produce twice as many units, variable costs double. Examples include raw materials, direct labor (per unit), sales commissions, and shipping costs. On a per-unit basis, variable costs stay constant (\$5 of material per widget regardless of volume).\n\n'
          'Fixed Costs stay the same regardless of activity levels (within a relevant range). Rent is \$10,000/month whether you produce 100 or 10,000 units. Other examples: executive salaries, insurance premiums, equipment depreciation, loan interest. On a per-unit basis, fixed costs decrease as volume increases (the "spreading" effect).\n\n'
          'Mixed Costs (Semi-Variable) have both a fixed and a variable component. A phone bill with a fixed monthly charge plus per-minute charges. A salesperson with a base salary plus commissions. Utilities with a base connection fee plus usage charges.\n\n'
          'Why this matters: knowing cost behavior allows you to predict how profits will change with volume. If most costs are fixed, a small increase in revenue produces a large increase in profit (high operating leverage). If most costs are variable, profits increase more steadily but with less dramatic impact.',
      'keyPoint': 'Variable: change proportionally with activity (materials, commissions). Fixed: stay constant regardless of volume (rent, salaries, depreciation). Mixed: combine fixed and variable components (phone bill, utilities). High fixed costs = high operating leverage (amplifies both gains and losses).',
    },
    {
      'title': 'Operating Expenses',
      'content': 'Operating Expenses (OpEx) are the costs of running the business that are not directly tied to producing goods. They appear on the income statement after Gross Profit and are subtracted to arrive at Operating Income.\n\n'
          'Selling Expenses relate to getting products to customers: advertising, marketing, sales salaries and commissions, shipping and delivery, store rent for retail locations. These costs exist because you need to find customers and get the product to them.\n\n'
          'General & Administrative Expenses (G&A) relate to running the organization itself: executive salaries, office rent, legal and accounting fees, insurance, office supplies, IT costs. These costs exist whether you sell one unit or a million.\n\n'
          'Some companies group these together as SG&A (Selling, General & Administrative). Others break them out separately. Either way, the key insight is: Operating Expenses = everything it costs to run the business beyond the direct production costs already captured in COGS.\n\n'
          'Operating Expenses are heavily influenced by management decisions: you can choose to spend more on marketing, hire more staff, or lease nicer offices. This is why Operating Income (Gross Profit minus OpEx) is the best measure of management\'s operational effectiveness — it strips out production costs (COGS) and non-operating items, leaving only the core business result.',
      'keyPoint': 'Selling: advertising, commissions, shipping, store rent. General & Administrative: executive pay, office rent, legal, IT. SG&A = Selling + G&A combined. Operating Income = Gross Profit - OpEx (best measure of management effectiveness).',
    },
    // Section C: Balance Sheet (LO #11-13)
    {
      'title': 'The Fundamental Accounting Equation',
      'content': 'The entire system of double-entry bookkeeping rests on one equation: Assets = Liabilities + Equity. This equation must always balance. Every single transaction in accounting affects at least two accounts, and the equation holds after every transaction.\n\n'
          'Think of it as a balance scale. On the left side sits everything the company owns (Assets). On the right side sits how those assets were funded: by borrowing from others (Liabilities) or from the owners (Equity). Every asset was paid for somehow — either with borrowed money or owner money.\n\n'
          'If a company buys a \$50,000 machine with a bank loan, Assets increase by \$50,000 (the machine) and Liabilities increase by \$50,000 (the loan). The equation stays balanced. If the company pays cash for it, Assets shift: cash goes down by \$50,000 and equipment goes up by \$50,000. Total assets stay the same.\n\n'
          'The expanded equation incorporates the income statement: Assets = Liabilities + (Common Stock + Retained Earnings + Revenue - Expenses - Dividends). Revenue increases equity (and thus assets). Expenses decrease equity. This is how the income statement connects to the balance sheet — every revenue and expense entry affects the equation.\n\n'
          'This equation is not just a theoretical concept. Auditors verify it every time they examine financial statements. If the balance sheet does not balance, something is wrong, and the error must be found before the statements can be published.',
      'keyPoint': 'Assets = Liabilities + Equity — must always balance. Every transaction affects at least two accounts (double entry). Assets = what you own; funded by debt (Liabilities) or owners (Equity). Revenue increases equity; Expenses decrease equity. If the balance sheet does not balance, there is an error.',
    },
    {
      'title': 'Classifying Balance Sheet Items',
      'content': 'The Balance Sheet organizes items by their nature and their time horizon. Proper classification is essential for assessing a company\'s financial health.\n\n'
          'Current Assets are resources expected to be converted to cash or used up within one year: Cash & Cash Equivalents, Accounts Receivable (money owed by customers), Inventory (goods available for sale), Prepaid Expenses (rent or insurance paid in advance). These are listed in order of liquidity (ease of conversion to cash).\n\n'
          'Non-Current Assets (Long-Term) are resources expected to provide value beyond one year: Property, Plant & Equipment (PP&E), Intangible Assets (patents, trademarks, goodwill), Long-Term Investments, Right-of-Use Assets (leases).\n\n'
          'Current Liabilities are obligations due within one year: Accounts Payable (money owed to suppliers), Accrued Expenses (salaries, interest owed but not yet paid), Short-Term Debt, Current Portion of Long-Term Debt, Unearned Revenue (cash received for services not yet delivered).\n\n'
          'Non-Current Liabilities are obligations due beyond one year: Long-Term Loans, Bonds Payable, Pension Obligations, Deferred Tax Liabilities, Long-Term Lease Liabilities.\n\n'
          'Equity represents the owners\' residual interest: Common Stock (capital invested by shareholders), Retained Earnings (accumulated profits not distributed), Additional Paid-In Capital, Treasury Stock (shares bought back, shown as negative).',
      'keyPoint': 'Current = within one year; Non-Current = beyond one year. Assets listed in order of liquidity (cash first). Current Ratio (Current Assets / Current Liabilities) measures short-term health. Equity = Stock + Retained Earnings + APIC - Treasury Stock.',
    },
    {
      'title': 'Key Balance Sheet Terms',
      'content': 'Several balance sheet items have specific meanings that are often confused. Here are the most important ones to master.\n\n'
          'Accounts Receivable (A/R): Money customers owe the company for goods/services already delivered. It is an asset because the company has a right to collect cash. The Allowance for Doubtful Accounts reduces A/R by the estimated amount that will never be collected.\n\n'
          'Accounts Payable (A/P): Money the company owes to its suppliers for goods/services already received. It is a current liability. A/P is the mirror image of A/R — one company\'s receivable is another company\'s payable.\n\n'
          'Depreciation and Net Book Value: When a company buys equipment for \$100,000 with a 10-year life, it does not expense the full amount immediately. Instead, it expenses \$10,000/year as depreciation. The Balance Sheet shows: Equipment \$100,000, less Accumulated Depreciation (\$30,000 after 3 years), equals Net Book Value of \$70,000.\n\n'
          'Goodwill: When a company acquires another company for more than the fair value of its identifiable net assets, the excess is recorded as Goodwill. It represents the value of brand reputation, customer relationships, and other intangible value. Goodwill is tested annually for impairment (a write-down if the acquired business has lost value).\n\n'
          'Retained Earnings: The cumulative total of all net income earned minus all dividends paid since the company began. It represents profits reinvested in the business. A negative balance (accumulated deficit) means the company has lost more money than it has earned over its lifetime.',
      'keyPoint': 'A/R = customers owe us (asset); A/P = we owe suppliers (liability). Accumulated Depreciation reduces asset cost to Net Book Value. Goodwill = purchase price above fair value in an acquisition. Retained Earnings = cumulative profits minus cumulative dividends.',
    },
    // Section D: Cash Flow Statement (LO #14-16)
    {
      'title': 'Purpose of the Cash Flow Statement',
      'content': 'The Cash Flow Statement exists because the Income Statement does not tell you the full truth about cash. A company can report high profits and still run out of cash. This is not a flaw — it is a feature of accrual accounting that the CFS is designed to address.\n\n'
          'Consider three gaps between accrual profit and cash reality: (1) Revenue timing — you recognize \$1M in revenue when you deliver the product, but the customer pays 60 days later. Your income statement shows \$1M; your bank account shows \$0. (2) Non-cash expenses — depreciation reduces profit by \$100K, but no cash was spent. Your income statement shows lower profit; your cash was not affected. (3) Capital spending — you buy a \$500K machine. Your income statement shows only the depreciation portion (\$50K/year); your cash paid the full \$500K.\n\n'
          'The Cash Flow Statement bridges these gaps by converting accrual-basis net income into actual cash generated. It starts with net income and adds back non-cash expenses, adjusts for working capital changes, and reports investing and financing cash flows separately.\n\n'
          'This is why experienced analysts say: "Revenue is vanity, profit is sanity, but cash is reality." The CFS tells you the reality. A company with strong cash generation can survive a temporary downturn. A company with weak cash generation, even if profitable on paper, is at risk.',
      'keyPoint': 'Profit does not equal Cash — the CFS bridges the gap. Revenue timing: earned vs. received can differ by months. Non-cash expenses: depreciation reduces profit but not cash. Capital spending: full cash outflow vs. gradual expense recognition.',
    },
    {
      'title': 'Three Categories of Cash Flow',
      'content': 'The Cash Flow Statement organizes all cash movements into three categories, each telling a different part of the story.\n\n'
          'Operating Activities: Cash generated from the core business operations. This section starts with net income and adjusts for non-cash items (add back depreciation, amortization) and working capital changes (changes in receivables, inventory, payables). Positive operating cash flow means the business generates cash from its core operations — the single most important indicator of financial health.\n\n'
          'Investing Activities: Cash spent on (or received from) long-term assets. Cash outflows: purchasing property, equipment, or other companies. Cash inflows: selling assets or receiving repayment of loans made. Negative investing cash flow is usually a good sign — it means the company is investing in future growth.\n\n'
          'Financing Activities: Cash from (or returned to) capital providers. Cash inflows: issuing shares, borrowing money (new loans, bond issuance). Cash outflows: repaying debt, buying back shares, paying dividends. This section shows how the company funds itself.\n\n'
          'The sum of all three categories plus the opening cash balance equals the closing cash balance, which must match the cash figure on the Balance Sheet. This is a critical reconciliation that auditors always verify.\n\n'
          'Healthy pattern: Strong positive operating cash flow -> funds investing activities and debt repayment -> reduces reliance on external financing.',
      'keyPoint': 'Operating: cash from core business (the most important category). Investing: cash for long-term assets (negative = investing in growth). Financing: cash from/to capital providers (debt & equity). Sum of all three + opening cash = closing cash (must tie to Balance Sheet).',
    },
    {
      'title': 'The Rule of 3: Reading Cash Flow Patterns',
      'content': 'Experienced analysts use the "Rule of 3" — three simple rules that quickly reveal a company\'s financial health from its cash flow pattern.\n\n'
          'Rule 1: Operating Cash Flow should be positive. If the core business does not generate cash, the company is burning through its reserves or borrowing just to keep the lights on. Sustained negative operating cash flow is a red flag, except for very early-stage startups that are investing heavily before revenue kicks in.\n\n'
          'Rule 2: Operating Cash Flow should exceed Net Income. Why? Because net income includes non-cash charges (depreciation) that should be added back. If operating cash flow is consistently lower than net income, it suggests the company is recognizing revenue it cannot collect, building up unsold inventory, or engaging in aggressive accounting. This is one of the most reliable warning signs of accounting manipulation.\n\n'
          'Rule 3: Free Cash Flow should be positive. Free Cash Flow (FCF) = Operating Cash Flow minus Capital Expenditures. It represents the cash available after maintaining and growing the business. FCF is what can be used to pay dividends, repay debt, or make acquisitions. A company with positive FCF has real financial flexibility.\n\n'
          'When all three rules are satisfied (positive operating CF, OCF > Net Income, positive FCF), the company has a healthy cash profile. When any rule is violated, it warrants investigation — not necessarily alarm, but definitely attention.',
      'keyPoint': 'Rule 1: Operating Cash Flow should be positive. Rule 2: Operating Cash Flow should exceed Net Income. Rule 3: Free Cash Flow (OCF - CapEx) should be positive. All three satisfied = healthy cash profile.',
    },
    // Section E: Auditing & Oversight (LO #17-18)
    {
      'title': 'Internal vs External Auditors',
      'content': 'Auditors are the guardians of financial statement integrity. There are two types, and they serve different but complementary purposes.\n\n'
          'Internal Auditors are employees of the organization. Their job is to continuously evaluate whether the company\'s internal controls are working, whether policies are being followed, and whether operations are efficient. They report to the Audit Committee of the Board of Directors (not to management) to maintain independence. Internal auditors act as the company\'s own quality control system.\n\n'
          'External Auditors are independent firms hired to provide an objective opinion on whether the financial statements are fairly presented in accordance with accounting standards (IFRS or GAAP). They are required by law for public companies and must be truly independent — they cannot have a financial interest in the company or provide certain consulting services to it. The Big Four firms (Deloitte, PwC, EY, KPMG) audit most large companies.\n\n'
          'Key differences: Internal auditors focus on processes and controls; external auditors focus on the financial statements themselves. Internal auditors work year-round; external auditors work during the audit season. Internal audit reports are private; the external audit opinion is public and accompanies the published financial statements.\n\n'
          'Both types rely on similar skills: examining evidence, testing transactions, evaluating risks, and exercising professional judgment. Organizations benefit most when internal and external auditors collaborate, sharing insights and reducing duplication of effort.',
      'keyPoint': 'Internal: employees, focus on controls & efficiency, report to Audit Committee. External: independent firm, opine on financial statements, legally required for public companies. Internal = year-round quality control; External = periodic financial verification. Both serve financial integrity but from different angles.',
    },
    {
      'title': 'Four Types of Audit Opinions',
      'content': 'When external auditors complete their work, they issue an audit opinion — a formal statement about the reliability of the financial statements. There are four possible opinions, ranging from best to worst.\n\n'
          'Unqualified Opinion ("Clean Opinion") — This is the best outcome. The auditor states that the financial statements present fairly, in all material respects, the financial position and results in accordance with the applicable accounting framework. This is what every company wants and what investors expect.\n\n'
          'Qualified Opinion — The auditor found one or more specific issues, but the financial statements are otherwise fairly presented. The qualification is described in a separate paragraph: "Except for [specific issue], the financial statements present fairly..." Investors read the qualification carefully to assess its significance.\n\n'
          'Adverse Opinion — The auditor concludes that the financial statements are materially misstated and do NOT present fairly. This is rare and devastating. It means the financial statements cannot be relied upon. Stock prices typically plummet, lenders may call loans, and management faces serious consequences.\n\n'
          'Disclaimer of Opinion — The auditor was unable to obtain sufficient evidence to form any opinion at all. This might happen if the company restricted access to records, if there was a severe scope limitation, or if there were pervasive uncertainties. Like an adverse opinion, a disclaimer destroys confidence in the financial statements.\n\n'
          'For investors and lenders, anything other than an unqualified opinion is a warning sign that requires careful analysis before making financial decisions based on those statements.',
      'keyPoint': 'Unqualified (Clean): statements are fairly presented — the gold standard. Qualified: fairly presented EXCEPT for a specific issue. Adverse: statements are materially misstated — cannot be relied upon. Disclaimer: auditor could not form an opinion — also a red flag.',
    },
  ],
  memoryPairs: [
    // Foundations Terms
    {'term': 'Accounting Cycle', 'definition': 'الدورة المحاسبية'},
    {'term': 'Accrual Basis', 'definition': 'أساس الاستحقاق'},
    {'term': 'Matching Principle', 'definition': 'مبدأ المقابلة'},
    {'term': 'Revenue Recognition', 'definition': 'الاعتراف بالإيراد'},
    {'term': 'Going Concern', 'definition': 'الاستمرارية'},
    // Income Statement Terms
    {'term': 'Gross Profit', 'definition': 'إجمالي الربح'},
    {'term': 'Cost of Goods Sold', 'definition': 'تكلفة البضاعة المباعة'},
    {'term': 'Operating Income', 'definition': 'الدخل التشغيلي'},
    {'term': 'Fixed Costs', 'definition': 'التكاليف الثابتة'},
    {'term': 'Variable Costs', 'definition': 'التكاليف المتغيرة'},
    // Balance Sheet Terms
    {'term': 'Accounts Receivable', 'definition': 'الذمم المدينة'},
    {'term': 'Accounts Payable', 'definition': 'الذمم الدائنة'},
    {'term': 'Retained Earnings', 'definition': 'الأرباح المبقاة'},
    {'term': 'Depreciation', 'definition': 'الاستهلاك'},
    {'term': 'Goodwill', 'definition': 'الشهرة'},
    // Cash Flow Terms
    {'term': 'Operating Cash Flow', 'definition': 'التدفق النقدي التشغيلي'},
    {'term': 'Free Cash Flow', 'definition': 'التدفق النقدي الحر'},
    {'term': 'Capital Expenditure', 'definition': 'الإنفاق الرأسمالي'},
    // Auditing Terms
    {'term': 'Unqualified Opinion', 'definition': 'رأي غير متحفظ'},
    {'term': 'Internal Auditor', 'definition': 'المدقق الداخلي'},
  ],
  quizQuestions: [
    // Quiz 1: Foundations & Income Statement (5 questions)
    {
      'question': 'How many steps does the accounting cycle contain, and how are they organized?',
      'options': [
        '8 steps in 2 timing zones',
        '10 steps in 3 timing zones',
        '12 steps in 4 timing zones',
        '6 steps in 2 timing zones',
      ],
      'correctIndex': 1,
      'explanation': 'The accounting cycle has 10 steps organized in 3 timing zones: During the Period (steps 1-4), At Period-End (steps 5-7), and After Closing (steps 8-10).',
    },
    {
      'question': 'A company delivers a \$500,000 project in December but receives payment in February. Under accrual accounting, when is the revenue recognized?',
      'options': [
        'February, when cash is received',
        'December, when the project is delivered',
        'Split equally between December and February',
        'January, the midpoint between delivery and payment',
      ],
      'correctIndex': 1,
      'explanation': 'Under accrual accounting, revenue is recognized when earned (when the performance obligation is satisfied), not when cash is received. The project was delivered in December, so December gets the revenue.',
    },
    {
      'question': 'Which of the following correctly lists the 5+1 main account types in accounting?',
      'options': [
        'Assets, Liabilities, Equity, Revenue, Expenses, and Dividends',
        'Cash, Receivables, Payables, Income, Costs, and Taxes',
        'Assets, Liabilities, Equity, Profit, Loss, and Reserves',
        'Current, Non-Current, Short-Term, Long-Term, Operating, and Non-Operating',
      ],
      'correctIndex': 0,
      'explanation': 'The 5+1 account types are: Assets (what you own), Liabilities (what you owe), Equity (residual claim), Revenue (money earned), Expenses (costs incurred), plus Dividends (profit returned to owners).',
    },
    {
      'question': 'What is the key advantage of a multi-step income statement over a single-step format?',
      'options': [
        'It is simpler to prepare',
        'It reveals intermediate profitability measures like gross profit and operating income (EBIT)',
        'It requires fewer line items',
        'It eliminates the need for a cash flow statement',
      ],
      'correctIndex': 1,
      'explanation': 'The multi-step format breaks net income into stages: Gross Profit (Revenue - COGS), Operating Income/EBIT (Gross Profit - OpEx), and Net Income. Each subtotal provides analytical insight that the single-step format lacks.',
    },
    {
      'question': 'Which of the following is a characteristic of variable costs?',
      'options': [
        'They stay constant in total regardless of production volume',
        'They change in direct proportion to activity levels but stay constant per unit',
        'They include executive salaries and building rent',
        'They decrease per unit as volume increases',
      ],
      'correctIndex': 1,
      'explanation': 'Variable costs change in total proportionally to activity (double production = double total variable cost), but they stay constant on a per-unit basis (e.g., \$5 of material per widget regardless of volume).',
    },
    // Quiz 2: Balance Sheet, Cash Flow & Auditing (5 questions)
    {
      'question': 'The fundamental accounting equation states that:',
      'options': [
        'Assets = Liabilities + Equity',
        'Assets = Revenue - Expenses',
        'Liabilities = Assets + Equity',
        'Equity = Assets + Liabilities',
      ],
      'correctIndex': 0,
      'explanation': 'The fundamental accounting equation is Assets = Liabilities + Equity. Everything a company owns (assets) is financed either by borrowing (liabilities) or by owners\' investment (equity).',
    },
    {
      'question': 'Which of the following is classified as a current asset?',
      'options': [
        'Land held for long-term use',
        'A 20-year building',
        'Inventory expected to be sold within 12 months',
        'Goodwill from an acquisition',
      ],
      'correctIndex': 2,
      'explanation': 'Current assets are expected to be converted to cash, sold, or consumed within 12 months or the normal operating cycle. Inventory that will be sold within a year is a current asset.',
    },
    {
      'question': 'Why can a profitable company still run out of cash?',
      'options': [
        'It is impossible — profitable companies always have cash',
        'Profit is an accrual concept; revenue can be recorded before cash is collected, and capital expenditures consume cash without reducing profit immediately',
        'Only because of taxes',
        'Profit and cash are always the same number',
      ],
      'correctIndex': 1,
      'explanation': 'Profit is based on accrual accounting, which recognizes revenue when earned, not when cash arrives. A company can show profit while cash is tied up in receivables, inventory, or capital investments. This is the "profit vs. cash gap."',
    },
    {
      'question': 'A company issues new shares for \$5 million and uses \$3 million to purchase a factory. How are these classified in the Cash Flow Statement?',
      'options': [
        'Both are operating activities',
        'Both are financing activities',
        'Issuing shares is a financing activity; purchasing a factory is an investing activity',
        'Issuing shares is an investing activity; purchasing a factory is a financing activity',
      ],
      'correctIndex': 2,
      'explanation': 'Issuing shares raises capital from owners, which is a financing activity. Purchasing a factory is acquiring a long-term asset, which is an investing activity. The three categories (operating, investing, financing) capture different types of cash flows.',
    },
    {
      'question': 'An external auditor issues an "unqualified opinion." What does this mean?',
      'options': [
        'The auditor is not qualified to audit the company',
        'The financial statements are materially misstated',
        'The financial statements present fairly, in all material respects, the financial position of the entity — a clean bill of health',
        'The auditor could not obtain sufficient evidence to form an opinion',
      ],
      'correctIndex': 2,
      'explanation': 'An unqualified (clean) opinion is the best outcome. It means the auditor found the financial statements to be fairly presented in all material respects, in accordance with the applicable reporting framework.',
    },
    // Quiz 3: Integration & Advanced (5 questions)
    {
      'question': 'A company reports net income of \$500K but operating cash flow of only \$200K. What is the most likely explanation?',
      'options': [
        'The company paid \$300K in dividends',
        'Accounts receivable increased significantly, meaning revenue was recognized but cash was not yet collected',
        'The company purchased new equipment for \$300K',
        'The financial statements contain an error',
      ],
      'correctIndex': 1,
      'explanation': 'Under accrual accounting, revenue is recognized when earned, not when cash is received. A large increase in accounts receivable means sales were booked but customers have not yet paid, explaining the gap between net income and operating cash flow. Dividends appear in financing activities, and equipment purchases appear in investing activities.',
    },
    {
      'question': 'A manufacturer buys a machine for \$1,000,000 with a 10-year useful life. In Year 1, it produces 50,000 units. How does this affect the income statement under the matching principle?',
      'options': [
        'The full \$1,000,000 is expensed in Year 1',
        '\$100,000 depreciation is recorded as an expense, spreading the cost over the 10-year useful life',
        'No expense is recorded until the machine is fully worn out',
        'The cost is divided by units produced: \$20 per unit',
      ],
      'correctIndex': 1,
      'explanation': 'The matching principle requires spreading the cost of a long-term asset over its useful life through depreciation. Straight-line depreciation: \$1,000,000 / 10 years = \$100,000/year. This matches the expense to the periods that benefit from using the machine, rather than distorting Year 1 with the entire cost.',
    },
    {
      'question': 'Net income from the Income Statement flows to the Balance Sheet through which path?',
      'options': [
        'It is added directly to total assets',
        'It flows into Retained Earnings within Equity via the Statement of Changes in Equity',
        'It replaces the prior year cash balance',
        'It reduces total liabilities by the same amount',
      ],
      'correctIndex': 1,
      'explanation': 'Net income flows from the Income Statement through the Statement of Changes in Equity into Retained Earnings on the Balance Sheet. Retained Earnings = Opening RE + Net Income - Dividends. This is the key link between the period performance (IS) and the point-in-time position (BS).',
    },
    {
      'question': 'A retailer has: Revenue \$4M, Beginning Inventory \$300K, Purchases \$2.5M, Ending Inventory \$400K, and Operating Expenses \$800K. What is the Gross Profit and Operating Income?',
      'options': [
        'Gross Profit: \$1.6M, Operating Income: \$800K',
        'Gross Profit: \$1.2M, Operating Income: \$400K',
        'Gross Profit: \$1.5M, Operating Income: \$700K',
        'Gross Profit: \$2.4M, Operating Income: \$1.6M',
      ],
      'correctIndex': 0,
      'explanation': 'COGS = Beginning Inventory (\$300K) + Purchases (\$2.5M) - Ending Inventory (\$400K) = \$2.4M. Gross Profit = Revenue (\$4M) - COGS (\$2.4M) = \$1.6M. Operating Income = Gross Profit (\$1.6M) - Operating Expenses (\$800K) = \$800K. This uses the multi-step income statement format.',
    },
    {
      'question': 'Depreciation expense of \$200K appears on the Income Statement. How does this same item affect the Balance Sheet and Cash Flow Statement?',
      'options': [
        'Balance Sheet: cash decreases by \$200K; CFS: investing outflow of \$200K',
        'Balance Sheet: accumulated depreciation increases (reducing net asset value) by \$200K; CFS: added back to net income in operating activities because it is non-cash',
        'No effect on either the Balance Sheet or Cash Flow Statement',
        'Balance Sheet: liabilities increase by \$200K; CFS: financing outflow of \$200K',
      ],
      'correctIndex': 1,
      'explanation': 'Depreciation is a non-cash expense. On the Balance Sheet, it increases Accumulated Depreciation (a contra-asset), reducing the net book value of PP&E. On the Cash Flow Statement, it is added back to net income in the operating section because no cash actually left the company. This is one of the most tested concepts in financial statement analysis.',
    },
  ],
  // Classification game: 4 categories, 25 items
  classificationCategories: [
    'Balance Sheet',
    'Income Statement',
    'Cash Flow Statement',
    'Auditing & Oversight',
  ],
  classificationItems: [
    // Balance Sheet Items (7)
    {'name': 'Cash and Cash Equivalents', 'category': 'Balance Sheet'},
    {'name': 'Accounts Receivable', 'category': 'Balance Sheet'},
    {'name': 'Property, Plant & Equipment', 'category': 'Balance Sheet'},
    {'name': 'Accounts Payable', 'category': 'Balance Sheet'},
    {'name': 'Long-term Bonds Payable', 'category': 'Balance Sheet'},
    {'name': 'Retained Earnings', 'category': 'Balance Sheet'},
    {'name': 'Goodwill', 'category': 'Balance Sheet'},
    // Income Statement Items (6)
    {'name': 'Sales Revenue', 'category': 'Income Statement'},
    {'name': 'Cost of Goods Sold', 'category': 'Income Statement'},
    {'name': 'Depreciation Expense', 'category': 'Income Statement'},
    {'name': 'Selling Expenses', 'category': 'Income Statement'},
    {'name': 'Interest Expense', 'category': 'Income Statement'},
    {'name': 'Net Income', 'category': 'Income Statement'},
    // Cash Flow Statement Items (6)
    {'name': 'Cash Received from Customers', 'category': 'Cash Flow Statement'},
    {'name': 'Cash Paid to Employees', 'category': 'Cash Flow Statement'},
    {'name': 'Purchase of Equipment', 'category': 'Cash Flow Statement'},
    {'name': 'Proceeds from Bank Loan', 'category': 'Cash Flow Statement'},
    {'name': 'Dividends Paid', 'category': 'Cash Flow Statement'},
    {'name': 'Sale of Investment', 'category': 'Cash Flow Statement'},
    // Auditing & Oversight Items (6)
    {'name': 'Unqualified (Clean) Opinion', 'category': 'Auditing & Oversight'},
    {'name': 'Internal Controls Review', 'category': 'Auditing & Oversight'},
    {'name': 'Adverse Audit Opinion', 'category': 'Auditing & Oversight'},
    {'name': 'External Auditor Independence', 'category': 'Auditing & Oversight'},
    {'name': 'Audit Committee Oversight', 'category': 'Auditing & Oversight'},
    {'name': 'Disclaimer of Opinion', 'category': 'Auditing & Oversight'},
  ],
  // Statement builder: 7 categories, 30 items
  statementBuilderCategories: [
    'Assets',
    'Liabilities',
    'Revenue',
    'Expenses',
    'Operating',
    'Investing',
    'Financing',
  ],
  statementBuilderItems: [
    // Balance Sheet - Assets (5)
    {'name': 'Cash in Bank', 'category': 'Assets'},
    {'name': 'Accounts Receivable', 'category': 'Assets'},
    {'name': 'Inventory', 'category': 'Assets'},
    {'name': 'Buildings and Land', 'category': 'Assets'},
    {'name': 'Goodwill from Acquisition', 'category': 'Assets'},
    // Balance Sheet - Liabilities (5)
    {'name': 'Accounts Payable', 'category': 'Liabilities'},
    {'name': 'Accrued Salaries', 'category': 'Liabilities'},
    {'name': 'Long-term Bank Loan', 'category': 'Liabilities'},
    {'name': 'Bonds Payable', 'category': 'Liabilities'},
    {'name': 'Unearned Revenue', 'category': 'Liabilities'},
    // Income Statement - Revenue (4)
    {'name': 'Product Sales', 'category': 'Revenue'},
    {'name': 'Service Fee Income', 'category': 'Revenue'},
    {'name': 'Interest Income', 'category': 'Revenue'},
    {'name': 'Gain on Sale of Equipment', 'category': 'Revenue'},
    // Income Statement - Expenses (4)
    {'name': 'Cost of Goods Sold', 'category': 'Expenses'},
    {'name': 'Advertising Expense', 'category': 'Expenses'},
    {'name': 'Depreciation Expense', 'category': 'Expenses'},
    {'name': 'Interest Expense', 'category': 'Expenses'},
    // Cash Flows - Operating (4)
    {'name': 'Cash Collected from Customers', 'category': 'Operating'},
    {'name': 'Salary Payments Made', 'category': 'Operating'},
    {'name': 'Supplier Payments', 'category': 'Operating'},
    {'name': 'Tax Payments', 'category': 'Operating'},
    // Cash Flows - Investing (4)
    {'name': 'Purchase of Factory Equipment', 'category': 'Investing'},
    {'name': 'Sale of Old Vehicles', 'category': 'Investing'},
    {'name': 'Acquisition of Subsidiary', 'category': 'Investing'},
    {'name': 'Purchase of Investments', 'category': 'Investing'},
    // Cash Flows - Financing (4)
    {'name': 'Proceeds from Share Issuance', 'category': 'Financing'},
    {'name': 'Loan Principal Repaid', 'category': 'Financing'},
    {'name': 'Dividends Paid to Shareholders', 'category': 'Financing'},
    {'name': 'Proceeds from Bond Issuance', 'category': 'Financing'},
  ],
);
