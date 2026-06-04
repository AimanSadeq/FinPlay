/// FinPlay assessment question bank (ported from shared/assessment-bank.ts).
/// 25 questions across the 10 education modules + the simulation. Used for
/// both the pre-course and post-course knowledge tests.
library;

class AssessmentQuestion {
  final String id;
  final String module;
  final String topic;
  final String question;
  final List<String> options;
  final int correctIdx;

  const AssessmentQuestion({
    required this.id,
    required this.module,
    required this.topic,
    required this.question,
    required this.options,
    required this.correctIdx,
  });
}

const int kAssessmentVersion = 1;

const List<AssessmentQuestion> kAssessmentBank = [
  AssessmentQuestion(
    id: 'q01',
    module: 'M1',
    topic: 'Three pillars',
    question:
        'Which three pillars structure every financial decision in FinPlay?',
    options: [
      'Revenue, Cost, Profit',
      'Financing, Investing, Operating',
      'Assets, Liabilities, Equity',
      'Strategy, Operations, Reporting',
    ],
    correctIdx: 1,
  ),
  AssessmentQuestion(
    id: 'q02',
    module: 'M1',
    topic: 'Accounting vs Finance',
    question: 'Which statement best distinguishes accounting from finance?',
    options: [
      'Accounting looks forward; finance looks backward.',
      'Accounting and finance are interchangeable terms.',
      'Accounting records and reports past activity; finance plans future capital allocation.',
      'Accounting only applies to large companies; finance only to small ones.',
    ],
    correctIdx: 2,
  ),
  AssessmentQuestion(
    id: 'q03',
    module: 'M1',
    topic: 'Time value of money',
    question:
        'A dollar today is worth more than a dollar tomorrow primarily because:',
    options: [
      'Inflation reduces purchasing power over time, and the money could earn a return if invested today.',
      'Banks always charge a fee to hold money.',
      'Currencies depreciate every day by a fixed percentage.',
      'Older money is more valuable because it is rarer.',
    ],
    correctIdx: 0,
  ),
  AssessmentQuestion(
    id: 'q04',
    module: 'M1',
    topic: 'WACC',
    question: 'The Weighted Average Cost of Capital (WACC) represents:',
    options: [
      'The minimum return a company must earn to satisfy all its capital providers.',
      'The interest rate charged by the central bank.',
      'The average wage paid to the finance team.',
      'The cost of acquiring a competitor.',
    ],
    correctIdx: 0,
  ),
  AssessmentQuestion(
    id: 'q05',
    module: 'M1',
    topic: 'Debt vs Equity',
    question:
        'A company that finances growth mostly through equity rather than debt typically:',
    options: [
      'Has lower financial risk but dilutes ownership and may have higher cost of capital.',
      'Pays more interest expense and reports lower net income.',
      'Eliminates the need to repay any capital provider.',
      'Always achieves a higher return on equity.',
    ],
    correctIdx: 0,
  ),
  AssessmentQuestion(
    id: 'q06',
    module: 'M2',
    topic: 'Income statement',
    question: 'Net income on the income statement is calculated as:',
    options: [
      'Revenue minus cost of goods sold only.',
      'Cash received minus cash paid during the period.',
      'Total assets minus total liabilities.',
      'Revenue minus all expenses (operating, interest, taxes).',
    ],
    correctIdx: 3,
  ),
  AssessmentQuestion(
    id: 'q07',
    module: 'M2',
    topic: 'Accounting equation',
    question: 'Which equation must always balance on the balance sheet?',
    options: [
      'Revenue = Expenses + Profit',
      'Assets = Liabilities + Equity',
      'Cash In = Cash Out + Reserves',
      'Debt = Equity + Retained Earnings',
    ],
    correctIdx: 1,
  ),
  AssessmentQuestion(
    id: 'q08',
    module: 'M2',
    topic: 'Cash flow categories',
    question:
        'Buying a new factory appears in which section of the cash flow statement?',
    options: [
      'Operating activities',
      'Investing activities',
      'Financing activities',
      'Net change in equity',
    ],
    correctIdx: 1,
  ),
  AssessmentQuestion(
    id: 'q09',
    module: 'M3',
    topic: 'Current ratio',
    question: 'The current ratio measures:',
    options: [
      'The total profitability of the firm.',
      'The percentage of revenue retained as profit.',
      'Whether short-term assets can cover short-term liabilities.',
      'The long-term debt-to-equity mix.',
    ],
    correctIdx: 2,
  ),
  AssessmentQuestion(
    id: 'q10',
    module: 'M3',
    topic: 'DuPont decomposition',
    question:
        'In the DuPont framework, Return on Equity (ROE) is decomposed into:',
    options: [
      'Net profit margin × Asset turnover × Equity multiplier',
      'Revenue × Cost of capital × Tax rate',
      'EBITDA × Working capital × Interest cover',
      'Cash conversion × Days sales × Payables turnover',
    ],
    correctIdx: 0,
  ),
  AssessmentQuestion(
    id: 'q11',
    module: 'M3',
    topic: 'Vertical analysis',
    question:
        'Expressing every line of the income statement as a percentage of revenue is called:',
    options: [
      'Horizontal analysis',
      'Vertical analysis',
      'Ratio analysis',
      'Cross-sectional analysis',
    ],
    correctIdx: 1,
  ),
  AssessmentQuestion(
    id: 'q12',
    module: 'M4',
    topic: 'Break-even formula',
    question: 'Break-even units = Fixed costs ÷ ?',
    options: [
      'Selling price per unit',
      'Variable cost per unit',
      'Contribution margin per unit',
      'Total revenue',
    ],
    correctIdx: 2,
  ),
  AssessmentQuestion(
    id: 'q13',
    module: 'M4',
    topic: 'Contribution margin',
    question: 'Contribution margin per unit equals:',
    options: [
      'Selling price minus variable cost per unit',
      'Selling price minus fixed cost per unit',
      'Revenue divided by units sold',
      'Gross profit divided by units sold',
    ],
    correctIdx: 0,
  ),
  AssessmentQuestion(
    id: 'q14',
    module: 'M5',
    topic: 'NPV decision rule',
    question: 'A project with a positive Net Present Value (NPV) should:',
    options: [
      'Be rejected because it has positive risk.',
      'Be accepted because it adds value to the firm.',
      'Be deferred until interest rates drop.',
      'Be referred to the tax authority for approval.',
    ],
    correctIdx: 1,
  ),
  AssessmentQuestion(
    id: 'q15',
    module: 'M5',
    topic: 'IRR',
    question: 'The Internal Rate of Return (IRR) is:',
    options: [
      "The interest rate charged by the firm's bank.",
      'The discount rate at which NPV equals zero.',
      'The rate of inflation in the project country.',
      'The corporate tax rate.',
    ],
    correctIdx: 1,
  ),
  AssessmentQuestion(
    id: 'q16',
    module: 'M6',
    topic: 'Zero-based budgeting',
    question: 'Zero-Based Budgeting (ZBB) differs from traditional budgeting because:',
    options: [
      'It always produces a balanced budget.',
      'Every line item must be justified from scratch each period, not based on prior-year levels.',
      'It only applies to government entities.',
      'It assumes revenue is zero.',
    ],
    correctIdx: 1,
  ),
  AssessmentQuestion(
    id: 'q17',
    module: 'M6',
    topic: 'Variance analysis',
    question: 'A favorable revenue variance occurs when:',
    options: [
      'Actual revenue is less than budgeted revenue.',
      'Actual revenue equals budgeted revenue exactly.',
      'Actual revenue exceeds budgeted revenue.',
      'The budget is revised downward.',
    ],
    correctIdx: 2,
  ),
  AssessmentQuestion(
    id: 'q18',
    module: 'M6',
    topic: 'Master budget',
    question: 'The master budget brings together:',
    options: [
      'Only the cash flow forecast.',
      'Operating budgets, financial budgets, and capital budgets into one integrated plan.',
      'Only the marketing department spending plan.',
      'Tax returns and audited statements.',
    ],
    correctIdx: 1,
  ),
  AssessmentQuestion(
    id: 'q19',
    module: 'M7',
    topic: 'IFRS vs IPSAS',
    question: 'Which best describes the relationship between IFRS and IPSAS?',
    options: [
      'They are identical standards published by different bodies.',
      'IFRS targets private-sector entities; IPSAS targets public-sector entities, and IPSAS is largely derived from IFRS.',
      'IPSAS replaces IFRS globally as of 2025.',
      'IFRS applies only to listed companies; IPSAS applies only to charities.',
    ],
    correctIdx: 1,
  ),
  AssessmentQuestion(
    id: 'q20',
    module: 'M7',
    topic: 'Accrual basis',
    question: 'The accrual basis of accounting requires that:',
    options: [
      'Revenue is recognized only when cash is received.',
      'Revenue is recognized when earned and expenses when incurred, regardless of cash timing.',
      'All transactions are recorded twice a year.',
      'Only government entities use double-entry bookkeeping.',
    ],
    correctIdx: 1,
  ),
  AssessmentQuestion(
    id: 'q21',
    module: 'M8',
    topic: 'Public vs private objectives',
    question:
        'The primary financial objective of a public-sector entity is typically:',
    options: [
      'Maximizing shareholder value.',
      'Delivering public services efficiently within an approved budget.',
      'Acquiring competitors.',
      'Paying dividends to taxpayers.',
    ],
    correctIdx: 1,
  ),
  AssessmentQuestion(
    id: 'q22',
    module: 'M8',
    topic: 'Revenue source',
    question: "A government entity's main revenue sources are typically:",
    options: [
      'Sales of consumer goods.',
      'Loans from international banks.',
      'Taxes, fees, and intergovernmental transfers.',
      'Dividends from subsidiaries.',
    ],
    correctIdx: 2,
  ),
  AssessmentQuestion(
    id: 'q23',
    module: 'M9',
    topic: 'Internal controls',
    question: 'A "preventive" internal control is designed to:',
    options: [
      'Detect a problem after it has happened.',
      'Stop an error or irregularity from occurring in the first place.',
      'Correct a misstatement once discovered.',
      "Document the auditor's opinion at year-end.",
    ],
    correctIdx: 1,
  ),
  AssessmentQuestion(
    id: 'q24',
    module: 'M10',
    topic: 'Audit opinion',
    question: 'An "unqualified" audit opinion means:',
    options: [
      'The auditor did not have time to complete the audit.',
      'The financial statements present a true and fair view in all material respects.',
      'The company refused to provide records.',
      'The auditor is not certified.',
    ],
    correctIdx: 1,
  ),
  AssessmentQuestion(
    id: 'q25',
    module: 'Sim',
    topic: 'FinPlay rounds',
    question: 'In the FinPlay corporate simulation, each team plays:',
    options: [
      '3 rounds, each with three modules in sequence: Financing → Investing → Operating.',
      '5 rounds, each focused only on financing decisions.',
      '1 round covering all decisions in a single hour.',
      '10 rounds modelled on a fiscal decade.',
    ],
    correctIdx: 0,
  ),
];
