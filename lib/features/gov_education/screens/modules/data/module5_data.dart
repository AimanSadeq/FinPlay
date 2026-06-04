import '../gov_module_data.dart';

const module5Data = GovModuleContent(
  id: 5,
  title: 'Elements of Finance',
  gameTitle: 'Classify the Element',
  gameDescription: 'Drag each item into the correct financial element category.',
  gameType: GameType.classification,

  // ── Slides (from module5-content.ts — 10 sections) ──
  slides: [
    // 5.1
    {
      'title': '5.1 Overview of Basic Finance Elements',
      'content':
          'Basic finance elements form the foundation of all financial management.\n\n'
          'These elements include assets, liabilities, equity, revenue, and expenses.\n\n'
          'Understanding these elements is essential for reading and interpreting financial statements.\n\n'
          'Each element plays a specific role in the accounting equation and financial reporting.',
      'keyPoint':
          'Five elements — Assets, Liabilities, Equity, Revenue, Expenses — are the foundation of all financial management.',
    },
    // 5.2
    {
      'title': '5.2 Assets — What the Government Owns',
      'content':
          'Assets are resources controlled by the government with future economic benefits.\n\n'
          'Current assets include cash, receivables, and inventory.\n\n'
          'Non-current assets include property, equipment, and infrastructure.\n\n'
          'In government, assets often provide service potential rather than cash generation.',
      'keyPoint':
          'Assets = resources with future economic benefits or service potential. Current (cash, receivables) vs. Non-current (property, infrastructure).',
    },
    // 5.3
    {
      'title': '5.3 Liabilities — What the Government Owes',
      'content':
          'Liabilities are present obligations from past events requiring future outflows.\n\n'
          'Current liabilities are due within one year — accounts payable, short-term debt.\n\n'
          'Non-current liabilities extend beyond one year — long-term debt, pension obligations.\n\n'
          'Managing liabilities is crucial for fiscal sustainability.',
      'keyPoint':
          'Liabilities = present obligations requiring future outflows. Current (<1 year) vs. Non-current (>1 year). Managing them is crucial for fiscal sustainability.',
    },
    // 5.4
    {
      'title': '5.4 Net Assets — The Residual Interest',
      'content':
          'Net assets represent assets minus liabilities.\n\n'
          'In government, this is not ownership like private sector equity.\n\n'
          'Net assets show accumulated surpluses or deficits over time.\n\n'
          'A positive net asset position indicates financial stability.',
      'keyPoint':
          'Net Assets = Assets − Liabilities. Shows accumulated surpluses or deficits. Positive net assets indicate financial stability.',
    },
    // 5.5
    {
      'title': '5.5 Revenue — Inflows of Resources',
      'content':
          'Revenue increases net assets during the period.\n\n'
          'Government revenue comes from taxes, fees, grants, and natural resources.\n\n'
          'Non-exchange transactions (taxes, grants) are unique to government.\n\n'
          'Exchange transactions (fees for services) are similar to private sector.',
      'keyPoint':
          'Revenue increases net assets. Government revenue: taxes, fees, grants, natural resources. Non-exchange transactions are unique to government.',
    },
    // 5.6
    {
      'title': '5.6 Expenses — Outflows of Resources',
      'content':
          'Expenses decrease net assets during the period.\n\n'
          'Personnel expenses are typically the largest category in government.\n\n'
          'Operating expenses cover day-to-day costs.\n\n'
          'Depreciation reflects the consumption of long-term assets.',
      'keyPoint':
          'Expenses decrease net assets. Personnel expenses are the largest government category. Depreciation reflects consumption of long-term assets.',
    },
    // 5.7
    {
      'title': '5.7 The Accounting Equation',
      'content':
          'Assets = Liabilities + Net Assets\n\n'
          'This equation must always balance.\n\n'
          'Every transaction affects at least two elements.\n\n'
          'Double-entry bookkeeping ensures the equation stays balanced.',
      'keyPoint':
          'Assets = Liabilities + Net Assets. Must always balance. Double-entry bookkeeping ensures every transaction keeps the equation in balance.',
    },
    // 5.8
    {
      'title': '5.8 Relationship Between Elements',
      'content':
          'Revenue increases net assets, expenses decrease them.\n\n'
          'Surplus (revenue > expenses) increases net assets.\n\n'
          'Deficit (expenses > revenue) decreases net assets.\n\n'
          'Balance sheet and income statement are connected through net assets.',
      'keyPoint':
          'Surplus (revenue > expenses) increases net assets; deficit decreases them. Balance sheet and income statement connect through net assets.',
    },
    // 5.9
    {
      'title': '5.9 Applying Elements to Government Context',
      'content':
          'Government financial elements serve accountability purposes.\n\n'
          'Assets may have restrictions on their use.\n\n'
          'Revenue recognition follows specific IPSAS rules.\n\n'
          'Expenses are often controlled by budget appropriations.',
      'keyPoint':
          'Government elements serve accountability. Assets may be restricted. Revenue follows IPSAS rules. Expenses controlled by budget appropriations.',
    },
    // 5.10
    {
      'title': '5.10 Summary of Basic Finance Elements',
      'content':
          'Five main elements: Assets, Liabilities, Net Assets, Revenue, Expenses.\n\n'
          'The accounting equation connects position elements.\n\n'
          'Revenue and expenses drive changes in net assets.\n\n'
          'Understanding these elements is foundational for government finance.',
      'keyPoint':
          'Five elements connected by the accounting equation. Revenue and expenses drive changes in net assets. Foundational for government finance.',
    },
  ],

  // ── Memory Pairs (from module5-terms.ts — 20 pairs) ──
  memoryPairs: [
    {'term': 'Assets', 'definition': 'الأصول'},
    {'term': 'Current Assets', 'definition': 'الأصول المتداولة'},
    {'term': 'Non-Current Assets', 'definition': 'الأصول غير المتداولة'},
    {'term': 'Infrastructure', 'definition': 'البنية التحتية'},
    {'term': 'Liabilities', 'definition': 'الالتزامات'},
    {'term': 'Current Liabilities', 'definition': 'الالتزامات المتداولة'},
    {'term': 'Non-Current Liabilities', 'definition': 'الالتزامات غير المتداولة'},
    {'term': 'Pension Obligations', 'definition': 'التزامات المعاشات'},
    {'term': 'Net Assets', 'definition': 'صافي الأصول'},
    {'term': 'Equity', 'definition': 'حقوق الملكية'},
    {'term': 'Revenue', 'definition': 'الإيرادات'},
    {'term': 'Expenses', 'definition': 'المصروفات'},
    {'term': 'Surplus', 'definition': 'الفائض'},
    {'term': 'Deficit', 'definition': 'العجز'},
    {'term': 'Depreciation', 'definition': 'الاستهلاك'},
    {'term': 'Accounting Equation', 'definition': 'المعادلة المحاسبية'},
    {'term': 'Double-Entry', 'definition': 'القيد المزدوج'},
    {'term': 'Non-Exchange Transaction', 'definition': 'معاملة غير تبادلية'},
    {'term': 'Service Potential', 'definition': 'إمكانية الخدمة'},
    {'term': 'Fiscal Sustainability', 'definition': 'الاستدامة المالية'},
  ],

  // ── Classification (from module5-classification.ts — 5 categories, 25 items) ──
  classificationCategories: [
    'Assets',
    'Liabilities',
    'Revenue',
    'Expenses',
    'Equity',
  ],
  classificationItems: [
    // Assets
    {'name': 'Cash in Treasury', 'category': 'Assets'},
    {'name': 'Government Buildings', 'category': 'Assets'},
    {'name': 'Tax Receivables', 'category': 'Assets'},
    {'name': 'Public Roads', 'category': 'Assets'},
    {'name': 'Office Equipment', 'category': 'Assets'},
    // Liabilities
    {'name': 'Government Bonds Payable', 'category': 'Liabilities'},
    {'name': 'Supplier Invoices Pending', 'category': 'Liabilities'},
    {'name': 'Employee Pension Liability', 'category': 'Liabilities'},
    {'name': 'Bank Loans Outstanding', 'category': 'Liabilities'},
    {'name': 'Accrued Employee Benefits', 'category': 'Liabilities'},
    // Revenue
    {'name': 'Income Tax Collections', 'category': 'Revenue'},
    {'name': 'License Fee Receipts', 'category': 'Revenue'},
    {'name': 'Federal Grant Income', 'category': 'Revenue'},
    {'name': 'Property Tax Revenue', 'category': 'Revenue'},
    {'name': 'Mining Royalty Income', 'category': 'Revenue'},
    // Expenses
    {'name': 'Staff Salary Payments', 'category': 'Expenses'},
    {'name': 'Office Supply Purchases', 'category': 'Expenses'},
    {'name': 'Building Depreciation', 'category': 'Expenses'},
    {'name': 'Utility Bills Paid', 'category': 'Expenses'},
    {'name': 'Interest on Loans', 'category': 'Expenses'},
    // Equity
    {'name': 'Accumulated Surplus', 'category': 'Equity'},
    {'name': 'Capital Reserve Fund', 'category': 'Equity'},
    {'name': 'Restricted Net Assets', 'category': 'Equity'},
    {'name': 'Unrestricted Surplus', 'category': 'Equity'},
    {'name': 'Beginning Net Assets', 'category': 'Equity'},
  ],

  // ── Statement Builder (from module5-statements.ts — 3 categories, 30 items) ──
  statementBuilderCategories: [
    'Balance Sheet',
    'Income Statement',
    'Cash Flow Statement',
  ],
  statementBuilderItems: [
    // Balance Sheet (10)
    {'name': 'Cash and Cash Equivalents', 'category': 'Balance Sheet'},
    {'name': 'Buildings and Land', 'category': 'Balance Sheet'},
    {'name': 'Accounts Payable', 'category': 'Balance Sheet'},
    {'name': 'Long-term Debt', 'category': 'Balance Sheet'},
    {'name': 'Net Assets Balance', 'category': 'Balance Sheet'},
    {'name': 'Inventory', 'category': 'Balance Sheet'},
    {'name': 'Infrastructure Assets', 'category': 'Balance Sheet'},
    {'name': 'Pension Liabilities', 'category': 'Balance Sheet'},
    {'name': 'Restricted Reserves', 'category': 'Balance Sheet'},
    {'name': 'Receivables', 'category': 'Balance Sheet'},
    // Income Statement (10)
    {'name': 'Tax Revenue', 'category': 'Income Statement'},
    {'name': 'Grant Revenue', 'category': 'Income Statement'},
    {'name': 'Personnel Expenses', 'category': 'Income Statement'},
    {'name': 'Operating Expenses', 'category': 'Income Statement'},
    {'name': 'Surplus/Deficit', 'category': 'Income Statement'},
    {'name': 'Fee Revenue', 'category': 'Income Statement'},
    {'name': 'Depreciation Expense', 'category': 'Income Statement'},
    {'name': 'Interest Expense', 'category': 'Income Statement'},
    {'name': 'Investment Income', 'category': 'Income Statement'},
    {'name': 'Maintenance Costs', 'category': 'Income Statement'},
    // Cash Flow Statement (10)
    {'name': 'Cash from Taxes Collected', 'category': 'Cash Flow Statement'},
    {'name': 'Cash Paid to Employees', 'category': 'Cash Flow Statement'},
    {'name': 'Purchase of Equipment', 'category': 'Cash Flow Statement'},
    {'name': 'Bond Proceeds Received', 'category': 'Cash Flow Statement'},
    {'name': 'Loan Repayments', 'category': 'Cash Flow Statement'},
    {'name': 'Cash from Operations', 'category': 'Cash Flow Statement'},
    {'name': 'Sale of Property', 'category': 'Cash Flow Statement'},
    {'name': 'Cash Paid to Suppliers', 'category': 'Cash Flow Statement'},
    {'name': 'Investment Purchases', 'category': 'Cash Flow Statement'},
    {'name': 'Interest Payments', 'category': 'Cash Flow Statement'},
  ],

  // ── Quiz (Quiz 1: 20 questions + Quiz 2: 20 questions = 40 total) ──
  quizQuestions: [
    // ─── Quiz 1 ───
    // Q1 (q5_1) — correctAnswer:1 → index 1 (already 0-based second option? No: 1-indexed means option index 0)
    {
      'question': 'What are the five main elements of finance?',
      'options': [
        'Cash, Credit, Debit, Balance, Ledger',
        'Assets, Liabilities, Net Assets, Revenue, Expenses',
        'Input, Process, Output, Feedback, Control',
        'Planning, Organizing, Staffing, Directing, Controlling',
      ],
      'correctIndex': 1,
      'explanation':
          'The five main elements are Assets, Liabilities, Net Assets (Equity), Revenue, and Expenses — the foundation of all financial statements.',
    },
    // Q2 (q5_2)
    {
      'question': 'Why is understanding basic finance elements essential?',
      'options': [
        'Only for accountants',
        'For reading and interpreting financial statements',
        'It is not important',
        'Only for tax purposes',
      ],
      'correctIndex': 1,
      'explanation':
          'Understanding these elements is essential for reading and interpreting financial statements, which is key to financial management.',
    },
    // Q3 (q5_3)
    {
      'question': 'Each finance element plays a specific role in:',
      'options': [
        'Only the balance sheet',
        'The accounting equation and financial reporting',
        'Tax calculations only',
        'Employee management',
      ],
      'correctIndex': 1,
      'explanation':
          'Each element plays a specific role in the accounting equation and financial reporting, forming the basis of all financial information.',
    },
    // Q4 (q5_4)
    {
      'question': 'The five elements form the foundation of:',
      'options': [
        'Only government organizations',
        'All financial management',
        'Personal budgeting only',
        'None of the above',
      ],
      'correctIndex': 1,
      'explanation':
          'These five elements form the foundation of all financial management, whether in government, private sector, or non-profit organizations.',
    },
    // Q5 (q5_5)
    {
      'question': 'What are assets?',
      'options': [
        'Money owed to suppliers',
        'Resources controlled with future economic benefits',
        'Employee salaries',
        'Tax payments',
      ],
      'correctIndex': 1,
      'explanation':
          'Assets are resources controlled by the entity that have future economic benefits or service potential.',
    },
    // Q6 (q5_6)
    {
      'question': 'Which of the following is a current asset?',
      'options': [
        'Buildings',
        'Cash',
        'Infrastructure',
        'Equipment',
      ],
      'correctIndex': 1,
      'explanation':
          'Cash is a current asset — expected to be converted or used within one year. Buildings, infrastructure, and equipment are non-current assets.',
    },
    // Q7 (q5_7)
    {
      'question': 'In government, assets often provide:',
      'options': [
        'Only cash generation',
        'Service potential rather than cash generation',
        'No value at all',
        'Only resale value',
      ],
      'correctIndex': 1,
      'explanation':
          'Government assets often provide service potential (ability to deliver services) rather than direct cash generation like private sector assets.',
    },
    // Q8 (q5_8)
    {
      'question': 'Infrastructure assets include:',
      'options': [
        'Cash and bank accounts',
        'Roads, bridges, and public facilities',
        'Office supplies',
        'Accounts receivable',
      ],
      'correctIndex': 1,
      'explanation':
          'Infrastructure assets include roads, bridges, and public facilities — long-lived assets that serve the public.',
    },
    // Q9 (q5_9)
    {
      'question': 'What are liabilities?',
      'options': [
        'Money received from taxes',
        'Present obligations requiring future outflows',
        'Employee benefits earned',
        'Investment returns',
      ],
      'correctIndex': 1,
      'explanation':
          'Liabilities are present obligations from past events that will require future outflows of resources.',
    },
    // Q10 (q5_10)
    {
      'question': 'Which is a non-current liability?',
      'options': [
        'Accounts payable due next month',
        'Pension obligations',
        'Short-term loans',
        'Accrued salaries',
      ],
      'correctIndex': 1,
      'explanation':
          'Pension obligations extend beyond one year, making them non-current liabilities. The others are typically due within one year.',
    },
    // Q11 (q5_11)
    {
      'question': 'Why is managing liabilities crucial for government?',
      'options': [
        'To increase spending',
        'For fiscal sustainability',
        'To avoid audits',
        'It is not important',
      ],
      'correctIndex': 1,
      'explanation':
          'Managing liabilities is crucial for fiscal sustainability — ensuring the government can meet its obligations long-term.',
    },
    // Q12 (q5_12)
    {
      'question': 'Current liabilities are typically due within:',
      'options': [
        'One week',
        'One year',
        'Five years',
        'Ten years',
      ],
      'correctIndex': 1,
      'explanation':
          'Current liabilities are obligations due within one year or the operating cycle, whichever is longer.',
    },
    // Q13 (q5_13)
    {
      'question': 'What do net assets represent?',
      'options': [
        'Total assets only',
        'Assets minus liabilities',
        'Total liabilities only',
        'Revenue minus expenses',
      ],
      'correctIndex': 1,
      'explanation':
          'Net assets represent assets minus liabilities — the residual interest in the entity\'s resources.',
    },
    // Q14 (q5_14)
    {
      'question': 'A positive net asset position indicates:',
      'options': [
        'Financial instability',
        'Financial stability',
        'Too much spending',
        'Poor management',
      ],
      'correctIndex': 1,
      'explanation':
          'A positive net asset position indicates financial stability — assets exceed liabilities.',
    },
    // Q15 (q5_15)
    {
      'question': 'Revenue increases:',
      'options': [
        'Liabilities',
        'Net assets',
        'Expenses',
        'Nothing',
      ],
      'correctIndex': 1,
      'explanation':
          'Revenue increases net assets during the period — it represents inflows of resources.',
    },
    // Q16 (q5_16)
    {
      'question': 'What are non-exchange transactions?',
      'options': [
        'Sales of goods',
        'Taxes and grants — unique to government',
        'Fee for services',
        'Investment sales',
      ],
      'correctIndex': 1,
      'explanation':
          'Non-exchange transactions include taxes and grants where one party receives value without giving equal value back — unique to government.',
    },
    // Q17 (q5_17) — correctAnswer:2 → 0-indexed = 2 (third option)
    {
      'question': 'Expenses decrease:',
      'options': [
        'Liabilities',
        'Assets only',
        'Net assets',
        'Revenue',
      ],
      'correctIndex': 2,
      'explanation':
          'Expenses decrease net assets during the period — they represent outflows of resources.',
    },
    // Q18 (q5_18)
    {
      'question':
          'What is typically the largest expense category in government?',
      'options': [
        'Office supplies',
        'Personnel expenses',
        'Travel costs',
        'Advertising',
      ],
      'correctIndex': 1,
      'explanation':
          'Personnel expenses (salaries, benefits) are typically the largest expense category in government operations.',
    },
    // Q19 (q5_19)
    {
      'question': 'What does depreciation reflect?',
      'options': [
        'Increase in asset value',
        'Consumption of long-term assets over time',
        'Cash payments',
        'Revenue recognition',
      ],
      'correctIndex': 1,
      'explanation':
          'Depreciation reflects the consumption of long-term assets over their useful lives — spreading the cost over time.',
    },
    // Q20 (q5_20)
    {
      'question': 'Operating expenses cover:',
      'options': [
        'Only capital purchases',
        'Day-to-day costs',
        'Only debt payments',
        'Investment purchases',
      ],
      'correctIndex': 1,
      'explanation':
          'Operating expenses cover day-to-day costs of running the organization — utilities, supplies, maintenance, etc.',
    },

    // ─── Quiz 2 ───
    // Q21 (q5_21)
    {
      'question': 'What is the accounting equation?',
      'options': [
        'Revenue = Expenses + Profit',
        'Assets = Liabilities + Net Assets',
        'Cash = Bank + Investments',
        'Income = Output - Input',
      ],
      'correctIndex': 1,
      'explanation':
          'The fundamental accounting equation is Assets = Liabilities + Net Assets. This equation must always balance.',
    },
    // Q22 (q5_22)
    {
      'question':
          'What must always be true about the accounting equation?',
      'options': [
        'Assets must be greater than liabilities',
        'It must always balance',
        'Net assets must be positive',
        'Revenue must equal expenses',
      ],
      'correctIndex': 1,
      'explanation':
          'The accounting equation must always balance — the total of the left side must equal the total of the right side.',
    },
    // Q23 (q5_23)
    {
      'question': 'Every transaction affects at least:',
      'options': [
        'One element',
        'Two elements',
        'Three elements',
        'Five elements',
      ],
      'correctIndex': 1,
      'explanation':
          'Every transaction affects at least two elements — this is the basis of double-entry bookkeeping.',
    },
    // Q24 (q5_24)
    {
      'question': 'What ensures the accounting equation stays balanced?',
      'options': [
        'Single-entry bookkeeping',
        'Double-entry bookkeeping',
        'Triple-entry bookkeeping',
        'No entry bookkeeping',
      ],
      'correctIndex': 1,
      'explanation':
          'Double-entry bookkeeping ensures the equation stays balanced — every debit has a corresponding credit.',
    },
    // Q25 (q5_25)
    {
      'question':
          'If assets increase by 100, what could happen to balance the equation?',
      'options': [
        'Only liabilities increase',
        'Liabilities or net assets (or both) increase by 100',
        'Nothing needs to change',
        'Expenses increase',
      ],
      'correctIndex': 1,
      'explanation':
          'If assets increase, liabilities or net assets (or both) must increase by the same amount to keep the equation balanced.',
    },
    // Q26 (q5_26) — correctAnswer:3 → 0-indexed = 3 (fourth option)
    {
      'question': 'The accounting equation can also be written as:',
      'options': [
        'Liabilities = Assets - Net Assets',
        'Net Assets = Assets - Liabilities',
        'Assets = Net Assets - Liabilities',
        'Both A and B are correct',
      ],
      'correctIndex': 3,
      'explanation':
          'The equation can be rearranged: Net Assets = Assets - Liabilities, or Liabilities = Assets - Net Assets.',
    },
    // Q27 (q5_27)
    {
      'question': 'What is a surplus?',
      'options': [
        'When expenses exceed revenue',
        'When revenue exceeds expenses',
        'When assets equal liabilities',
        'When net assets are zero',
      ],
      'correctIndex': 1,
      'explanation':
          'A surplus occurs when revenue exceeds expenses — it increases net assets.',
    },
    // Q28 (q5_28)
    {
      'question': 'What is a deficit?',
      'options': [
        'When revenue exceeds expenses',
        'When expenses exceed revenue',
        'When assets exceed liabilities',
        'When cash is positive',
      ],
      'correctIndex': 1,
      'explanation':
          'A deficit occurs when expenses exceed revenue — it decreases net assets.',
    },
    // Q29 (q5_29)
    {
      'question': 'How does a surplus affect net assets?',
      'options': [
        'Decreases net assets',
        'Increases net assets',
        'No effect',
        'Makes net assets zero',
      ],
      'correctIndex': 1,
      'explanation':
          'A surplus increases net assets — the positive difference between revenue and expenses adds to accumulated net assets.',
    },
    // Q30 (q5_30)
    {
      'question':
          'The balance sheet and income statement are connected through:',
      'options': [
        'Cash',
        'Net assets',
        'Liabilities',
        'Depreciation',
      ],
      'correctIndex': 1,
      'explanation':
          'The balance sheet and income statement are connected through net assets — the surplus/deficit from the income statement flows into net assets on the balance sheet.',
    },
    // Q31 (q5_31)
    {
      'question':
          'If a government has repeated deficits, what happens to net assets?',
      'options': [
        'Increases over time',
        'Decreases over time',
        'Stays the same',
        'Becomes equal to assets',
      ],
      'correctIndex': 1,
      'explanation':
          'Repeated deficits decrease net assets over time, potentially leading to negative net assets (liabilities exceeding assets).',
    },
    // Q32 (q5_32) — correctAnswer:2 → 0-indexed = 2 (third option)
    {
      'question': 'Revenue and expenses directly affect:',
      'options': [
        'Only assets',
        'Only liabilities',
        'Changes in net assets',
        'Nothing',
      ],
      'correctIndex': 2,
      'explanation':
          'Revenue and expenses directly drive changes in net assets — they determine whether there is a surplus or deficit.',
    },
    // Q33 (q5_33)
    {
      'question': 'Government financial elements serve what purpose?',
      'options': [
        'Profit maximization',
        'Accountability purposes',
        'Shareholder returns',
        'Market competition',
      ],
      'correctIndex': 1,
      'explanation':
          'Government financial elements serve accountability purposes — demonstrating responsible use of public resources.',
    },
    // Q34 (q5_34)
    {
      'question': 'Government assets may have:',
      'options': [
        'No restrictions',
        'Restrictions on their use',
        'Only cash restrictions',
        'Always free use',
      ],
      'correctIndex': 1,
      'explanation':
          'Government assets may have restrictions on their use — certain funds or assets can only be used for specific purposes.',
    },
    // Q35 (q5_35)
    {
      'question': 'Government expenses are often controlled by:',
      'options': [
        'Market forces',
        'Budget appropriations',
        'Employee requests',
        'No controls',
      ],
      'correctIndex': 1,
      'explanation':
          'Government expenses are often controlled by budget appropriations — legal authorizations to spend specified amounts.',
    },
    // Q36 (q5_36)
    {
      'question': 'Revenue recognition in government follows:',
      'options': [
        'Any method chosen',
        'Specific IPSAS rules',
        'Private sector rules only',
        'No rules',
      ],
      'correctIndex': 1,
      'explanation':
          'Revenue recognition follows specific IPSAS rules that address unique government transactions like taxes and grants.',
    },
    // Q37 (q5_37) — correctAnswer:2 → 0-indexed = 2 (third option)
    {
      'question': 'How many main elements are there in finance?',
      'options': [
        'Three',
        'Four',
        'Five',
        'Six',
      ],
      'correctIndex': 2,
      'explanation':
          'There are five main elements: Assets, Liabilities, Net Assets, Revenue, and Expenses.',
    },
    // Q38 (q5_38)
    {
      'question': 'The accounting equation connects which elements?',
      'options': [
        'Revenue and Expenses',
        'Assets, Liabilities, and Net Assets',
        'Only Cash and Bank',
        'Income and Profit',
      ],
      'correctIndex': 1,
      'explanation':
          'The accounting equation (Assets = Liabilities + Net Assets) connects the position elements on the balance sheet.',
    },
    // Q39 (q5_39)
    {
      'question':
          'Understanding basic finance elements is foundational for:',
      'options': [
        'Only private sector finance',
        'Government finance',
        'Only personal budgeting',
        'None of the above',
      ],
      'correctIndex': 1,
      'explanation':
          'Understanding these elements is foundational for government finance — enabling proper financial management and reporting.',
    },
    // Q40 (q5_40)
    {
      'question': 'What drives changes in net assets over time?',
      'options': [
        'Cash movements only',
        'Revenue and expenses',
        'Asset purchases only',
        'Liability payments only',
      ],
      'correctIndex': 1,
      'explanation':
          'Revenue and expenses drive changes in net assets — creating surpluses (revenue > expenses) or deficits (expenses > revenue).',
    },
  ],
);
