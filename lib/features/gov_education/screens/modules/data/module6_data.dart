import '../gov_module_data.dart';

const module6Data = GovModuleContent(
  id: 6,
  title: 'Budgeting & Financial Planning',
  gameTitle: 'Budget Cycle Order',
  gameDescription: 'Arrange the budget cycle steps in the correct sequence.',
  gameType: GameType.ordering,
  slides: [
    // Section 6.1
    {
      'title': '6.1 Purpose of Budgeting & Financial Planning',
      'content':
          'A budget is a financial plan that translates an organization\'s strategic objectives into quantified targets for a specific period, usually one year. Whether in a private corporation or a government ministry, budgeting is the mechanism through which resources are allocated to activities.\n\n'
          'Budgeting serves five core purposes: (1) Allocate scarce resources among competing needs; (2) Set measurable financial targets that guide day-to-day operations; (3) Coordinate different departments or ministries so that individual plans support the overall strategy; (4) Provide a control framework by comparing actual results to planned amounts; and (5) Measure performance and hold managers accountable for results.\n\n'
          'Without a budget, organizations operate reactively, spending money as requests arrive rather than directing funds toward priorities. A well-designed budget process ensures that every dollar or dirham spent moves the organization closer to its goals.\n\n'
          'Financial planning goes beyond a single budget year. It incorporates multi-year forecasts, sensitivity analysis, and contingency reserves so the organization can adapt when conditions change. Together, budgeting and financial planning form the backbone of sound fiscal management.',
      'keyPoint':
          'Five core purposes of budgeting: (1) Allocate resources, (2) Set targets, (3) Coordinate departments, (4) Control spending, (5) Measure performance. Financial planning extends beyond a single year with forecasts and contingency reserves.',
    },
    // Section 6.2
    {
      'title': '6.2 Two Worlds of Budgeting',
      'content':
          'Budgeting differs fundamentally depending on the sector. Private for-profit enterprises budget to maximize shareholder value: revenue growth, cost control, and profitability drive every allocation. Government entities budget to deliver public services within legally authorized spending limits, where success is measured by outcomes for citizens, not profits.\n\n'
          'In the private sector, the board of directors approves the budget, and management has considerable flexibility to reallocate funds during the year. In government, the legislature (parliament or congress) authorizes spending through appropriation laws, and reallocation between categories often requires formal approval.\n\n'
          'Revenue sources also differ. Companies earn revenue from customers; governments collect taxes, fees, and charges. This distinction shapes budget uncertainty: a company can invest in marketing to boost sales, whereas a government cannot "market" taxes to raise more revenue.\n\n'
          'Despite these differences, both worlds share common budgeting principles: linking spending to strategy, monitoring execution through variance analysis, and using feedback loops to improve future budgets. Understanding both perspectives makes financial professionals more versatile and effective.',
      'keyPoint':
          'Private budgets aim to maximize shareholder value; government budgets deliver public services within legal spending limits. Both share common principles: linking spending to strategy, variance analysis, and feedback loops.',
    },
    // Section 6.3
    {
      'title': '6.3 The Private Budgeting Process',
      'content':
          'The private-sector budget cycle is a continuous seven-stage loop: (1) Set Strategic Goals \u2014 leadership defines revenue targets, margin goals, and growth initiatives; (2) Develop Assumptions \u2014 finance builds macroeconomic, market, and operational assumptions; (3) Departmental Budgets \u2014 each department drafts its revenue and expense plan; (4) Consolidation \u2014 finance merges all departmental budgets into a company-wide master budget; (5) Review & Negotiation \u2014 senior management challenges, adjusts, and approves the master budget; (6) Execution \u2014 managers implement the approved plan, committing and spending within authorized limits; (7) Variance Analysis & Feedback \u2014 monthly actuals are compared to budget, variances are explained, and lessons feed into the next cycle.\n\n'
          'The entire process typically starts 3-4 months before the fiscal year begins. Finance issues a "budget calendar" specifying deadlines for each stage. Templates and guidelines ensure consistency across departments.\n\n'
          'Two critical negotiations happen during consolidation: the sales team often pushes for aggressive revenue targets to secure marketing spend, while operations seeks conservative targets to protect margins. The CFO mediates these tensions.\n\n'
          'Modern companies supplement the annual budget with rolling forecasts updated quarterly, giving management a continuously refreshed view of the remainder of the year.',
      'keyPoint':
          'Seven-stage private budget cycle: Set Goals, Develop Assumptions, Departmental Budgets, Consolidation, Review & Negotiation, Execution, Variance Analysis & Feedback. Process starts 3-4 months before fiscal year.',
    },
    // Section 6.4
    {
      'title': '6.4 Key Budget Types in For-Profit',
      'content':
          'A private company\'s master budget is assembled from eight component budgets, each feeding into the next: (1) Sales Budget \u2014 the starting point, projecting units and revenue by product/region; (2) Production / Service Delivery Budget \u2014 calculates the output needed to meet sales plus desired ending inventory; (3) Direct Materials Budget \u2014 determines raw material purchases based on production volumes; (4) Direct Labor Budget \u2014 staffing hours and cost required for production; (5) Manufacturing / Operating Overhead Budget \u2014 indirect costs (depreciation, utilities, supervision); (6) Selling & Administrative Expense Budget \u2014 marketing, distribution, corporate overhead; (7) Capital Expenditure Budget \u2014 planned investments in long-lived assets (equipment, facilities); (8) Cash Budget \u2014 the timing of all inflows and outflows, ensuring liquidity.\n\n'
          'These eight budgets consolidate into three pro-forma financial statements: the Budgeted Income Statement, the Budgeted Balance Sheet, and the Budgeted Cash Flow Statement.\n\n'
          'The sales budget drives all others; an error in the sales forecast cascades through every downstream budget. For this reason, companies invest heavily in demand forecasting, using historical data, market research, and statistical models.\n\n'
          'Service companies adapt the model: they skip production and materials budgets, replacing them with a service delivery budget that focuses on labor capacity and utilization rates.',
      'keyPoint':
          'Eight component budgets: Sales, Production, Direct Materials, Direct Labor, Overhead, SG&A, Capital Expenditure, Cash. They consolidate into three pro-forma statements. Sales budget drives all others.',
    },
    // Section 6.5
    {
      'title': '6.5 The Master Budget',
      'content':
          'The master budget is the comprehensive financial plan that integrates all component budgets into a single, coherent document. It typically consists of two major sections: the Operating Budget (covering revenues and expenses for the period) and the Financial Budget (covering capital expenditures, cash flow, and the projected balance sheet).\n\n'
          'Building the master budget follows a logical sequence. Start with the sales forecast, which flows into the production plan. Production drives materials and labor needs. Add overhead and SG&A to get total expenses. Subtract from revenue to produce the budgeted income statement. Separately, the capital expenditure budget and cash budget combine with the income statement to create the budgeted balance sheet and cash flow statement.\n\n'
          'The master budget serves as the organization\'s official financial target. Department managers are evaluated against it, bonuses may be tied to meeting or exceeding budget, and it guides day-to-day spending decisions throughout the year.\n\n'
          'Effective master budgets are realistic, clearly communicated, and accepted by the people responsible for executing them. A budget imposed top-down without buy-in often fails because managers feel no ownership over targets they did not help set.',
      'keyPoint':
          'Master budget = Operating Budget (income statement) + Financial Budget (cash, capital, balance sheet). It is the organization\'s official financial target. Effective budgets require buy-in from those executing them.',
    },
    // Section 6.6
    {
      'title': '6.6 Budgeting Approaches \u2014 Part 1',
      'content':
          'Organizations choose among many budgeting approaches, each with trade-offs between accuracy, effort, and flexibility. Here are three widely used methods.\n\n'
          'Zero-Based Budgeting (ZBB) requires every expense to be justified from scratch each period. No prior spending is assumed to continue automatically. ZBB forces critical evaluation of every activity, can eliminate waste, but is time-intensive and may be impractical for large organizations every year.\n\n'
          'Incremental Budgeting (Last Year + %) starts from prior-year budget or actual spending and applies a percentage increase for inflation or growth (e.g., "last year + 5%"). It is the simplest and fastest approach but perpetuates historical inefficiencies, assumes past spending patterns are correct, and gives no incentive to find savings.\n\n'
          'Activity-Based Budgeting (ABB) assigns costs to specific activities (e.g., "process one purchase order costs AED 120") and builds the budget based on expected activity volumes. ABB produces highly accurate budgets but requires detailed cost-driver data that many organizations lack.',
      'keyPoint':
          'ZBB: justify every expense from zero (thorough but time-intensive). Incremental: last year + % (fast but perpetuates inefficiencies). ABB: cost per activity x volume (accurate but data-intensive).',
    },
    // Section 6.7
    {
      'title': '6.7 Budgeting Approaches \u2014 Part 2',
      'content':
          'Four more approaches that modern organizations use to complement or replace traditional annual budgets:\n\n'
          'Value Proposition Budgeting asks each department to answer: "What value does your team deliver, and what would happen if your budget were cut by 10-20%?" It aligns spending with the value created and encourages managers to prioritize high-impact activities.\n\n'
          'Rolling Budgets (or Continuous Budgets) maintain a constant planning horizon. As one month or quarter passes, a new one is added to the end. This keeps the budget always looking 12 months ahead and prevents the "stale budget" problem that arises late in the fiscal year.\n\n'
          'Flexible Budgets adjust automatically for changes in activity levels. If sales increase 10%, the flexible budget recalculates variable costs accordingly, providing a fairer benchmark for performance evaluation than a static budget.\n\n'
          'Driver-Based Budgeting identifies the key operational drivers (e.g., number of customers, transactions, headcount) and builds the budget by modeling how changes in those drivers affect revenues and costs. It is faster to update than line-by-line budgeting and highlights the operational levers management can pull.\n\n'
          'No single approach is "best." Many companies combine methods: ZBB every 3-5 years for a deep reset, rolling forecasts quarterly, and driver-based models for rapid scenario planning.',
      'keyPoint':
          'Value Proposition: justify value delivered. Rolling: always 12 months ahead. Flexible: auto-adjusts for activity levels. Driver-Based: built around key operational metrics. Best practice: combine methods.',
    },
    // Section 6.8
    {
      'title': '6.8 Top-Down vs. Bottom-Up Budgeting',
      'content':
          'Top-Down Budgeting: Senior leadership sets an overall budget target and divides it among divisions or departments. Advantages: fast, strategically aligned, limits "budget padding." Disadvantages: may be unrealistic at the operational level, reduces buy-in from middle managers, and can miss critical local needs.\n\n'
          'Bottom-Up Budgeting: Each department builds its own budget based on operational needs, and these roll up into the company or ministry total. Advantages: more accurate, greater ownership, captures ground-level detail. Disadvantages: time-consuming, prone to padding (managers inflate requests expecting cuts), and may exceed the organization\'s resource envelope.\n\n'
          'Participative (Negotiated) Budgeting: The most common approach in practice is a hybrid. Leadership sets macro constraints (e.g., "total headcount growth capped at 3%") while departments propose detailed plans within those constraints. The result is a negotiated budget that balances strategic direction with operational reality.\n\n'
          'Government budgeting typically follows a hybrid model too: the Ministry of Finance issues budget ceilings (top-down), and line ministries prepare detailed requests within those ceilings (bottom-up). Budget hearings resolve the gaps.',
      'keyPoint':
          'Top-Down: fast, strategic, but may be unrealistic. Bottom-Up: accurate, owned, but slow and prone to padding. Participative (hybrid): most common in practice, balancing strategy with operational reality.',
    },
    // Section 6.9
    {
      'title': '6.9 The Government Budgeting Process',
      'content':
          'Government budgeting follows a formal, legally governed six-stage process that spans approximately 18 months from planning to audit:\n\n'
          'Stage 1: Macro-Fiscal Framework \u2014 The Ministry of Finance projects total revenue, sets the fiscal deficit/surplus target, and determines aggregate spending ceilings using economic models and policy priorities.\n\n'
          'Stage 2: Budget Preparation \u2014 The Ministry of Finance issues a budget circular with ceilings and guidelines. Line ministries prepare detailed budget submissions within those ceilings, justifying new programs with cost-benefit analyses.\n\n'
          'Stage 3: Legislative Approval \u2014 The consolidated budget is submitted to parliament or the national assembly for debate, amendment, and formal appropriation. This stage makes the budget legally binding.\n\n'
          'Stage 4: Execution \u2014 Once approved, funds are released according to a cash plan. Ministries commit, obligate, and spend within their appropriations. Commitment controls ensure spending does not exceed authorized amounts.\n\n'
          'Stage 5: Monitoring & Reporting \u2014 Quarterly and mid-year execution reports track actual spending versus budget. Significant variances trigger corrective action, and supplementary budgets address unforeseen needs.\n\n'
          'Stage 6: Audit & Evaluation \u2014 The Supreme Audit Institution (SAI) conducts an independent review of budget execution, verifying compliance with appropriation law and assessing value for money. Findings are reported to parliament.',
      'keyPoint':
          'Six stages: (1) Macro-Fiscal Framework, (2) Budget Preparation, (3) Legislative Approval, (4) Execution, (5) Monitoring & Reporting, (6) Audit & Evaluation. Process spans ~18 months and is legally governed.',
    },
    // Section 6.10
    {
      'title': '6.10 Government Approaches \u2014 Part 1',
      'content':
          'Governments use specialized budgeting approaches designed for public accountability and service delivery:\n\n'
          'Line-Item Budgeting: The oldest and simplest approach. Expenditures are categorized by input type (salaries, travel, supplies, equipment). Control is exercised at the line-item level; managers cannot shift funds between categories without approval. Advantages: easy to control and audit. Disadvantages: no link between spending and outcomes; encourages "use it or lose it" behavior.\n\n'
          'Performance-Based Budgeting (PBB): Links budget allocations to measurable outputs and outcomes. Each program must specify what it will deliver (e.g., "vaccinate 500,000 children") and at what cost. PBB shifts focus from inputs to results but requires sophisticated performance measurement systems.\n\n'
          'Program Budgeting: Organizes spending by program (e.g., "Highway Safety Program") rather than by input category or organizational unit. It enables cross-ministry coordination on shared goals and helps legislators understand what the money accomplishes. However, overhead costs can be difficult to allocate across programs.',
      'keyPoint':
          'Line-Item: control by input category (easy but no link to outcomes). PBB: link funding to measurable outputs/outcomes. Program: organize by policy objective across ministries.',
    },
    // Section 6.11
    {
      'title': '6.11 Government Approaches \u2014 Part 2',
      'content':
          'Three more government budgeting approaches, each designed to improve a specific weakness of traditional methods:\n\n'
          'Zero-Based Budgeting (ZBB) in Government: Requires every ministry to build its budget from zero each year, ranking programs into "decision packages" by priority. Programs that cannot justify their existence are eliminated. ZBB was popularized in the U.S. in the 1970s and has seen renewed interest in cost-cutting environments. The challenge: it is enormously resource-intensive to apply across an entire government.\n\n'
          'Planning-Programming-Budgeting System (PPBS): A strategic approach that connects national planning goals to specific programs and their budgets. PPBS was pioneered by the U.S. Department of Defense and involves three steps: (1) identify long-term objectives, (2) design programs to achieve them, (3) budget the resources. PPBS is rigorous but complex, requiring strong analytical capacity.\n\n'
          'Medium-Term Expenditure Framework (MTEF): Extends the budget horizon to 3-5 years, showing how current-year decisions affect future budgets. MTEF helps governments avoid "fiscal cliffs" by making the multi-year consequences of spending visible. Most advanced economies now use some form of MTEF to anchor their annual budgets in a medium-term fiscal strategy.\n\n'
          'Many governments layer these approaches: line-item budgets for control, performance indicators for accountability, and an MTEF for medium-term discipline.',
      'keyPoint':
          'ZBB in government: justify from zero with decision packages. PPBS: link planning to programming to budgeting. MTEF: 3-5 year horizon showing future cost implications. Many governments layer multiple approaches.',
    },
    // Section 6.12
    {
      'title': '6.12 Private vs. Government Comparison',
      'content':
          'A side-by-side comparison across ten key dimensions reveals both the similarities and differences between private and government budgeting:\n\n'
          '(1) Objective: Private \u2014 Maximize profit and shareholder value. Government \u2014 Deliver public services and social outcomes. (2) Revenue Source: Private \u2014 Customer sales and fees. Government \u2014 Taxes, fees, grants. (3) Legal Authority: Private \u2014 Board approval. Government \u2014 Legislative appropriation (law). (4) Budget Horizon: Private \u2014 Annual with rolling forecasts. Government \u2014 Annual anchored in MTEF (3-5 years). (5) Flexibility: Private \u2014 Management can reallocate within reason. Government \u2014 Reallocation requires formal virement approval.\n\n'
          '(6) Performance Metric: Private \u2014 Profit margin, ROI, EPS. Government \u2014 Service outputs, citizen satisfaction. (7) Surplus/Deficit: Private \u2014 Profit reinvested or distributed. Government \u2014 Surplus returns to reserves; deficit requires borrowing. (8) Stakeholder: Private \u2014 Shareholders, lenders. Government \u2014 Citizens, taxpayers, legislature. (9) Audit: Private \u2014 External auditors (Big 4). Government \u2014 Supreme Audit Institution (SAI). (10) Transparency: Private \u2014 Annual report to shareholders. Government \u2014 Public budget documents, open data portals.\n\n'
          'Understanding these ten dimensions helps professionals who move between sectors (or work with both) recognize which assumptions apply and which need to be adjusted.',
      'keyPoint':
          'Ten comparison dimensions: Objective, Revenue Source, Legal Authority, Budget Horizon, Flexibility, Performance Metric, Surplus/Deficit, Stakeholder, Audit, Transparency. Both sectors share common principles despite structural differences.',
    },
    // Section 6.13
    {
      'title': '6.13 Key Takeaways',
      'content':
          'Private Budgeting Pillar: The private budget process is a continuous cycle that starts with the sales forecast and builds through eight component budgets into a master budget. Companies choose among nine approaches (ZBB, incremental, ABB, rolling, flexible, driver-based, and more), often combining several. The goal is always to align spending with value creation and shareholder return.\n\n'
          'Government Budgeting Pillar: Government budgets follow a six-stage legally governed process from macro-fiscal framework to audit. Six specialized approaches (line-item, PBB, program, ZBB, PPBS, MTEF) each address different control and accountability needs. The goal is to deliver maximum public value within authorized spending limits.\n\n'
          'Common Ground: Both sectors share five universal principles: (1) start with strategy, (2) translate strategy into financial targets, (3) coordinate across units, (4) monitor execution through variance analysis, and (5) learn from the results to improve the next budget. Mastering these principles equips you to succeed in either world.\n\n'
          'As organizations face increasing complexity \u2014 digital transformation, climate change, global disruptions \u2014 the ability to combine private-sector agility with public-sector discipline will define the next generation of financial leaders.',
      'keyPoint':
          'Private: sales-driven cycle, 8 budgets, 9 approaches, shareholder value. Government: 6-stage legal process, 6 approaches, public value. Common ground: 5 universal principles shared by both sectors.',
    },
  ],
  memoryPairs: [
    {'term': 'Master Budget', 'definition': '\u0627\u0644\u0645\u0648\u0627\u0632\u0646\u0629 \u0627\u0644\u0631\u0626\u064a\u0633\u064a\u0629'},
    {'term': 'Sales Budget', 'definition': '\u0645\u0648\u0627\u0632\u0646\u0629 \u0627\u0644\u0645\u0628\u064a\u0639\u0627\u062a'},
    {'term': 'Cash Budget', 'definition': '\u0627\u0644\u0645\u0648\u0627\u0632\u0646\u0629 \u0627\u0644\u0646\u0642\u062f\u064a\u0629'},
    {'term': 'Capital Expenditure Budget', 'definition': '\u0645\u0648\u0627\u0632\u0646\u0629 \u0627\u0644\u0646\u0641\u0642\u0627\u062a \u0627\u0644\u0631\u0623\u0633\u0645\u0627\u0644\u064a\u0629'},
    {'term': 'Rolling Forecast', 'definition': '\u0627\u0644\u062a\u0646\u0628\u0624 \u0627\u0644\u0645\u062a\u062c\u062f\u062f'},
    {'term': 'Flexible Budget', 'definition': '\u0627\u0644\u0645\u0648\u0627\u0632\u0646\u0629 \u0627\u0644\u0645\u0631\u0646\u0629'},
    {'term': 'Driver-Based Budget', 'definition': '\u0627\u0644\u0645\u0648\u0627\u0632\u0646\u0629 \u0627\u0644\u0642\u0627\u0626\u0645\u0629 \u0639\u0644\u0649 \u0627\u0644\u0645\u062d\u0631\u0643\u0627\u062a'},
    {'term': 'Budget Variance', 'definition': '\u0627\u0646\u062d\u0631\u0627\u0641 \u0627\u0644\u0645\u0648\u0627\u0632\u0646\u0629'},
    {'term': 'Zero-Based Budgeting', 'definition': '\u0627\u0644\u0645\u0648\u0627\u0632\u0646\u0629 \u0627\u0644\u0635\u0641\u0631\u064a\u0629'},
    {'term': 'Fiscal Year', 'definition': '\u0627\u0644\u0633\u0646\u0629 \u0627\u0644\u0645\u0627\u0644\u064a\u0629'},
    {'term': 'Appropriation', 'definition': '\u0627\u0644\u0627\u0639\u062a\u0645\u0627\u062f'},
    {'term': 'Virement', 'definition': '\u0627\u0644\u0645\u0646\u0627\u0642\u0644\u0629'},
    {'term': 'MTEF', 'definition': '\u0625\u0637\u0627\u0631 \u0627\u0644\u0625\u0646\u0641\u0627\u0642 \u0645\u062a\u0648\u0633\u0637 \u0627\u0644\u0645\u062f\u0649'},
    {'term': 'Line-Item Budget', 'definition': '\u0645\u0648\u0627\u0632\u0646\u0629 \u0627\u0644\u0628\u0646\u0648\u062f'},
    {'term': 'Performance Budget', 'definition': '\u0645\u0648\u0627\u0632\u0646\u0629 \u0627\u0644\u0623\u062f\u0627\u0621'},
    {'term': 'Encumbrance', 'definition': '\u0627\u0644\u0627\u0631\u062a\u0628\u0627\u0637'},
    {'term': 'Budget Ceiling', 'definition': '\u0633\u0642\u0641 \u0627\u0644\u0645\u0648\u0627\u0632\u0646\u0629'},
    {'term': 'Commitment Control', 'definition': '\u0627\u0644\u0631\u0642\u0627\u0628\u0629 \u0639\u0644\u0649 \u0627\u0644\u0627\u0644\u062a\u0632\u0627\u0645\u0627\u062a'},
    {'term': 'PPBS', 'definition': '\u0646\u0638\u0627\u0645 \u0627\u0644\u062a\u062e\u0637\u064a\u0637 \u0648\u0627\u0644\u0628\u0631\u0645\u062c\u0629 \u0648\u0627\u0644\u0645\u0648\u0627\u0632\u0646\u0629'},
    {'term': 'Supreme Audit Institution', 'definition': '\u0627\u0644\u062c\u0647\u0627\u0632 \u0627\u0644\u0623\u0639\u0644\u0649 \u0644\u0644\u0631\u0642\u0627\u0628\u0629 \u0627\u0644\u0645\u0627\u0644\u064a\u0629'},
  ],
  orderingInstruction:
      'Arrange the six stages of the government budget process in the correct order.',
  orderingItems: [
    'Macro-Fiscal Framework',
    'Budget Preparation',
    'Legislative Approval',
    'Execution',
    'Monitoring & Reporting',
    'Audit & Evaluation',
  ],
  quizQuestions: [
    // === Combined Quiz (module6-quiz.ts) - 20 questions ===
    // Q1
    {
      'question': 'Which of the following is NOT one of the five core purposes of budgeting?',
      'options': [
        'Planning for the future',
        'Coordinating activities across departments',
        'Eliminating all financial risk',
        'Controlling spending against targets',
      ],
      'correctIndex': 2,
      'explanation':
          'The five purposes of budgeting are planning, coordinating, controlling, motivating, and evaluating performance. Budgets help manage risk but cannot eliminate it entirely.',
    },
    // Q2
    {
      'question': 'Which statement correctly distinguishes private and government budgeting?',
      'options': [
        'Private budgets are legally binding; government budgets are optional guidelines',
        'Government budgets require legislative approval and create legal spending authority; private budgets are internal management tools',
        'Both follow identical approval processes but differ only in scale',
        'Private budgets must be published publicly; government budgets are confidential',
      ],
      'correctIndex': 1,
      'explanation':
          'Government budgets have legal force once approved by the legislature, creating binding spending authority (appropriations). Private-sector budgets are internal planning documents that do not require external approval.',
    },
    // Q3
    {
      'question': 'Why is the sales budget considered the "starting point" of the master budget?',
      'options': [
        'Because it is the easiest budget to prepare',
        'Because sales volume determines production needs, staffing, materials, and ultimately cash flow',
        'Because accounting standards require it to be prepared first',
        'Because the CEO always prepares this budget personally',
      ],
      'correctIndex': 1,
      'explanation':
          'The sales budget is the cornerstone because all other budgets flow from it: production depends on units to be sold, direct materials depend on production, labor depends on production hours, and cash collections depend on sales timing.',
    },
    // Q4
    {
      'question': 'A company plans to sell 10,000 units, wants 2,000 units in ending inventory, and has 1,500 units in beginning inventory. How many units must it produce?',
      'options': [
        '10,000 units',
        '10,500 units',
        '12,000 units',
        '8,500 units',
      ],
      'correctIndex': 1,
      'explanation':
          'Production = Sales + Desired Ending Inventory - Beginning Inventory = 10,000 + 2,000 - 1,500 = 10,500 units. This formula ensures the company produces enough to meet sales demand while building the desired inventory buffer.',
    },
    // Q5
    {
      'question': 'The master budget consists of which two major components?',
      'options': [
        'Revenue budget and expense budget',
        'Operating budget (pro-forma income statement) and financial budget (cash budget, capital budget, pro-forma balance sheet)',
        'Current year budget and next year budget',
        'Department budgets and division budgets',
      ],
      'correctIndex': 1,
      'explanation':
          'The master budget integrates all component budgets into two pillars: the Operating Budget (culminating in the pro-forma income statement) and the Financial Budget (cash budget, capital expenditure budget, and pro-forma balance sheet).',
    },
    // Q6
    {
      'question': 'What is the fundamental difference between incremental budgeting and zero-based budgeting (ZBB)?',
      'options': [
        'Incremental budgeting is only for governments; ZBB is only for private companies',
        'Incremental budgeting starts from last year\'s actual spending and adjusts; ZBB requires justifying every dollar from a zero base each period',
        'ZBB is faster to prepare; incremental budgeting is more thorough',
        'There is no meaningful difference between the two approaches',
      ],
      'correctIndex': 1,
      'explanation':
          'Incremental budgeting assumes last year\'s spending was appropriate and adjusts for inflation or growth. ZBB treats each period as new, requiring every expense to be justified from scratch. ZBB eliminates embedded inefficiencies but demands significantly more time and effort.',
    },
    // Q7
    {
      'question': 'Driver-based budgeting focuses on:',
      'options': [
        'Copying last year\'s numbers with minor adjustments',
        'Identifying a small number of key business drivers (e.g., headcount, units sold, square footage) and building the budget around them',
        'Letting each department set its own budget independently',
        'Only budgeting for capital expenditures',
      ],
      'correctIndex': 1,
      'explanation':
          'Driver-based budgeting identifies the 5-10 operational metrics that most influence financial results (e.g., headcount drives payroll, units sold drives COGS, store count drives rent). Changing a driver automatically recalculates all linked budget lines, making scenario planning fast and transparent.',
    },
    // Q8
    {
      'question': 'How many stages are in the typical government budget cycle?',
      'options': [
        'Three: preparation, approval, execution',
        'Six: policy formulation, preparation, legislative review, approval, execution, audit & evaluation',
        'Two: planning and spending',
        'Four: drafting, voting, spending, reporting',
      ],
      'correctIndex': 1,
      'explanation':
          'The government budget cycle has six stages: (1) Policy Formulation and strategic priorities, (2) Budget Preparation by ministries, (3) Legislative Review by parliament, (4) Approval and appropriation, (5) Budget Execution and monitoring, (6) Audit and Evaluation by the Supreme Audit Institution.',
    },
    // Q9
    {
      'question': 'What is an appropriation in government budgeting?',
      'options': [
        'A request for additional funding mid-year',
        'A legal authorization enacted by the legislature that permits a government entity to incur obligations and make payments for specified purposes',
        'An informal spending guideline that agencies may choose to follow',
        'A transfer of funds between departments',
      ],
      'correctIndex': 1,
      'explanation':
          'An appropriation is a law that grants legal authority to spend specific amounts for specific purposes within a defined time period. Spending beyond the appropriated amount or for unauthorized purposes is illegal.',
    },
    // Q10
    {
      'question': 'Line-item budgeting in government focuses on:',
      'options': [
        'Outcomes and service delivery results',
        'Input categories such as personnel costs, materials, utilities, and travel',
        'Return on investment for each program',
        'Customer satisfaction metrics',
      ],
      'correctIndex': 1,
      'explanation':
          'Line-item budgeting organizes spending by categories of inputs (what is purchased) rather than outputs or outcomes. It provides strong expenditure control and is easy to administer, but it tells legislators nothing about what results the spending achieves.',
    },
    // Q11
    {
      'question': 'Performance-Based Budgeting (PBB) in government links funding to:',
      'options': [
        'The number of employees in each agency',
        'Measurable outputs and outcomes, such as students graduated, patients treated, or kilometers of road built',
        'The previous year\'s spending level',
        'The political party of the agency head',
      ],
      'correctIndex': 1,
      'explanation':
          'PBB ties budget allocations to measurable performance indicators. Instead of asking "how much does each line item cost?" it asks "what results are we getting for the money spent?" This shifts the conversation from inputs to outputs and outcomes.',
    },
    // Q12
    {
      'question': 'The Medium-Term Expenditure Framework (MTEF) extends the budget horizon to:',
      'options': [
        'A single fiscal year only',
        'Typically 3-5 years, linking annual budgets to multi-year fiscal strategy and showing the out-year cost implications of current decisions',
        '20-30 years into the future',
        '1-2 months ahead for immediate spending needs',
      ],
      'correctIndex': 1,
      'explanation':
          'MTEF provides a 3-5 year rolling framework that connects annual budgets to medium-term fiscal goals. It forces governments to consider the future cost of today\'s decisions -- for example, a new hospital approved this year will require staffing and maintenance budgets for years to come.',
    },
    // Q13
    {
      'question': 'In terms of the profit motive, how do private and government budgets differ?',
      'options': [
        'Both seek to maximize profit',
        'Private budgets aim to maximize shareholder value; government budgets aim to maximize public service delivery within fiscal constraints',
        'Government budgets focus on profit; private budgets focus on public welfare',
        'Neither private nor government organizations consider financial returns',
      ],
      'correctIndex': 1,
      'explanation':
          'The fundamental difference in objective shapes every aspect of the budget. Private firms budget to generate returns for shareholders. Governments budget to deliver public services (healthcare, education, defense) effectively within available resources -- "surplus" is not the goal.',
    },
    // Q14
    {
      'question': 'In terms of flexibility, why are government budgets generally more rigid than private budgets?',
      'options': [
        'Government managers are less competent at financial planning',
        'Legal restrictions on appropriations, virement rules, and procurement regulations limit the ability to reallocate resources quickly in response to changing conditions',
        'Governments have more money than private companies',
        'Government budgets are updated daily while private budgets are annual',
      ],
      'correctIndex': 1,
      'explanation':
          'Government budget rigidity is by design, not by accident. Appropriation laws, virement limits, procurement regulations, and legislative oversight all restrict spending flexibility. These controls exist to prevent misuse of public funds but can reduce operational agility.',
    },
    // Q15
    {
      'question': 'A government ministry has used incremental budgeting for 15 years. Programs that were important a decade ago continue to receive funding even though citizen needs have shifted. Which budgeting approach would best address this problem?',
      'options': [
        'Increasing the incremental adjustment percentage from 3% to 8%',
        'Zero-based budgeting, forcing every program to justify its existence and funding from scratch',
        'Rolling forecasts updated monthly',
        'Switching from top-down to bottom-up budgeting',
      ],
      'correctIndex': 1,
      'explanation':
          'Incremental budgeting\'s biggest weakness is that it perpetuates the status quo -- legacy programs survive simply because they existed last year. ZBB is the direct remedy: by requiring every program to justify itself from zero, obsolete programs are exposed and resources can be redirected to current priorities.',
    },
    // Q16
    {
      'question': 'A factory budgeted \$500,000 in variable costs for 10,000 units but actually produced 12,000 units and spent \$580,000. Using a flexible budget, was performance favorable or unfavorable?',
      'options': [
        'Unfavorable: actual spending (\$580K) exceeded the original budget (\$500K) by \$80K',
        'Favorable: the flexible budget for 12,000 units is \$600K (= \$50/unit x 12,000), and actual spending of \$580K was \$20K below that',
        'Cannot determine without the sales budget',
        'Unfavorable: the factory should have spent exactly \$500K regardless of volume',
      ],
      'correctIndex': 1,
      'explanation':
          'Static budget comparison (\$580K vs \$500K) would show an \$80K unfavorable variance. But the flexible budget adjusts for volume: \$50/unit x 12,000 = \$600K. Actual \$580K is \$20K below the flex budget, revealing favorable cost control. Flexible budgets separate the volume effect from the spending effect, giving a fair evaluation.',
    },
    // Q17
    {
      'question': 'If a company\'s sales forecast is overstated by 30%, which downstream budgets will be most significantly distorted?',
      'options': [
        'Only the advertising budget',
        'Production, direct materials, direct labor, and the cash budget -- because they all cascade from the sales forecast',
        'Only the capital expenditure budget',
        'None, because each budget is prepared independently',
      ],
      'correctIndex': 1,
      'explanation':
          'The sales budget is the master budget\'s foundation. A 30% overstatement means the production budget overproduces, direct materials and labor budgets overspend, and the cash budget understates the gap between collections and payments. This cascading error is why sales forecasting accuracy is critical.',
    },
    // Q18
    {
      'question': 'A government agency discovers in October that it will exhaust its annual appropriation by November. What are the legally permissible options?',
      'options': [
        'Continue spending and settle the shortfall next year',
        'Request a supplementary appropriation from the legislature, implement spending freezes, or seek virement from underspent programs',
        'Borrow from a commercial bank without legislative approval',
        'Ignore the appropriation limit since it is only a guideline',
      ],
      'correctIndex': 1,
      'explanation':
          'Spending beyond appropriations is illegal. The agency can: (1) request a supplementary or emergency appropriation from the legislature, (2) freeze non-essential spending to stay within limits, or (3) use virement to transfer funds from underspent categories -- all within legal bounds. Simply overspending is not an option.',
    },
    // Q19
    {
      'question': 'In the private sector, a department that underspends its budget is typically praised for cost discipline. In government, the same underspending often leads to a budget cut next year. What explains this paradox?',
      'options': [
        'Government managers are less skilled at budgeting',
        'The incentive structures differ: private firms reward savings (which increase profit), while government "use-it-or-lose-it" rules penalize underspending by reducing future appropriations',
        'Private companies always have larger budgets',
        'Government departments never underspend their budgets',
      ],
      'correctIndex': 1,
      'explanation':
          'This is one of the starkest private-vs-government contrasts. In business, saving money boosts profit and earns praise. In government, unspent appropriations lapse and signal to budget authorities that the agency needs less -- creating a perverse incentive to spend everything. Some governments address this with multi-year appropriations or carry-forward provisions.',
    },
    // Q20
    {
      'question': 'Sales expects to sell 100,000 units, but Production has only budgeted capacity for 70,000 units. Which budgeting purpose has failed, and what is the consequence?',
      'options': [
        'The control purpose has failed; spending will exceed limits',
        'The coordination purpose has failed; without aligning sales and production plans, the company will face stockouts, lost revenue, and customer dissatisfaction',
        'The evaluation purpose has failed; managers cannot be measured',
        'No purpose has failed; departments should operate independently',
      ],
      'correctIndex': 1,
      'explanation':
          'Coordination is one of the five core purposes of budgeting. The master budget process is designed to surface exactly this kind of conflict before the year begins. When sales and production plans are misaligned, the budget review process should trigger either a production capacity expansion or a revised sales target.',
    },
    // === Quiz 1 (module6-quiz1.ts) - 20 questions ===
    // Q1-1
    {
      'question': 'How does a budget serve as a motivational tool?',
      'options': [
        'By punishing departments that overspend',
        'By setting performance targets that give managers clear goals to work toward',
        'By keeping financial information secret from managers',
        'By allocating unlimited resources to high performers',
      ],
      'correctIndex': 1,
      'explanation':
          'Budgets motivate by translating strategy into specific, measurable targets. When managers have clear goals and accountability, they are more likely to align their decisions with organizational objectives.',
    },
    // Q1-2
    {
      'question': 'In the private sector, what primarily drives the budget process?',
      'options': [
        'Legislative appropriation and citizen demands',
        'Revenue forecasts and profit maximization objectives',
        'Constitutional mandates and compliance requirements',
        'Public accountability and transparency laws',
      ],
      'correctIndex': 1,
      'explanation':
          'Private-sector budgets are driven by revenue forecasts and the goal of maximizing shareholder value. Government budgets, by contrast, are driven by legislative authorization and public service delivery.',
    },
    // Q1-3
    {
      'question': 'What is the correct first step in the private-sector budget process?',
      'options': [
        'Prepare departmental expense budgets',
        'Set strategic objectives and planning assumptions (growth targets, inflation, market conditions)',
        'Calculate break-even volume',
        'Submit the budget to the board of directors for approval',
      ],
      'correctIndex': 1,
      'explanation':
          'The private budget process starts with strategic planning: defining objectives, setting assumptions about growth, inflation, and market conditions. These assumptions cascade into every departmental budget that follows.',
    },
    // Q1-4
    {
      'question': 'In the 7-stage private budget cycle, which stage typically comes immediately after the sales budget is prepared?',
      'options': [
        'Cash budget',
        'Production budget and operating expense budgets',
        'Board approval',
        'Variance analysis',
      ],
      'correctIndex': 1,
      'explanation':
          'The sales budget drives everything. Once sales are forecast, the production budget (how much to make) and operating expense budgets (what resources are needed) follow directly, since they depend on expected sales volume.',
    },
    // Q1-5
    {
      'question': 'Which of the following correctly describes the relationship between component budgets?',
      'options': [
        'The cash budget feeds into the sales budget',
        'The production budget determines required direct materials and direct labor budgets',
        'The capital expenditure budget determines the sales forecast',
        'Each component budget is prepared independently with no interdependencies',
      ],
      'correctIndex': 1,
      'explanation':
          'Budget components cascade: Sales drives Production, which drives Direct Materials and Direct Labor. Manufacturing Overhead depends on production volume. All feed into the Cash Budget, which aggregates all inflows and outflows.',
    },
    // Q1-6
    {
      'question': 'What is the purpose of the pro-forma financial statements within the master budget?',
      'options': [
        'To replace the audited financial statements',
        'To project expected financial performance and position, allowing management to evaluate the plan before committing resources',
        'To calculate tax obligations for the current year',
        'To satisfy regulatory filing requirements',
      ],
      'correctIndex': 1,
      'explanation':
          'Pro-forma statements are forward-looking projections that let management see the expected impact of the budget plan on profitability (income statement), liquidity (cash budget), and financial position (balance sheet) before the year begins.',
    },
    // Q1-7
    {
      'question': 'Activity-Based Budgeting (ABB) allocates resources based on:',
      'options': [
        'Last year\'s spending plus a percentage increase',
        'The cost of activities required to produce outputs, linking resources to the work that drives costs',
        'A fixed percentage of revenue assigned to each department',
        'The CEO\'s discretionary allocation decisions',
      ],
      'correctIndex': 1,
      'explanation':
          'ABB extends Activity-Based Costing into planning. It identifies the activities needed to deliver products or services, estimates the cost drivers, and allocates resources based on the volume of activities expected -- creating a direct link between work performed and resources consumed.',
    },
    // Q1-8
    {
      'question': 'A rolling forecast differs from a traditional annual budget because it:',
      'options': [
        'Is prepared only once every five years',
        'Continuously extends the planning horizon by adding a new period as each period ends, always looking 12-18 months ahead',
        'Eliminates the need for variance analysis',
        'Uses only historical data without forward-looking assumptions',
      ],
      'correctIndex': 1,
      'explanation':
          'A rolling forecast always maintains a consistent forward-looking window (e.g., 12 months). When January ends, a new January is added 12 months out. This prevents the "stale budget" problem where by Q4, the original annual budget is outdated.',
    },
    // Q1-9
    {
      'question': 'A flexible budget is useful because it:',
      'options': [
        'Allows managers to spend without limits',
        'Adjusts budgeted amounts for the actual level of activity, enabling fair performance evaluation',
        'Eliminates the need for a static budget',
        'Is always easier to prepare than a fixed budget',
      ],
      'correctIndex': 1,
      'explanation':
          'A flexible budget recalculates expected costs at the actual activity level. If a factory planned for 8,000 units but produced 10,000, comparing actual costs against the 8,000-unit budget is misleading. The flexible budget re-benchmarks to 10,000 units for a fair comparison.',
    },
    // Q1-10
    {
      'question': 'In top-down budgeting, senior management sets overall targets first. What is the primary advantage of this approach?',
      'options': [
        'It ensures every front-line manager\'s input is captured',
        'It ensures strategic alignment and faster completion, since targets flow from corporate objectives',
        'It eliminates the need for departmental budgets entirely',
        'It always produces more accurate forecasts than bottom-up',
      ],
      'correctIndex': 1,
      'explanation':
          'Top-down budgeting ensures the budget aligns with strategic goals and is completed faster. However, it risks being unrealistic because the people closest to operations did not provide input.',
    },
    // Q1-11
    {
      'question': 'What is the main risk of pure bottom-up budgeting?',
      'options': [
        'It takes too little time to complete',
        'Department managers may pad their budgets with slack, leading to inflated cost estimates and sandbagged revenue targets',
        'It ignores operational realities',
        'Senior management has too much control over the process',
      ],
      'correctIndex': 1,
      'explanation':
          'Bottom-up budgeting, while operationally grounded, is prone to budget slack (also called "padding" or "sandbagging"). Managers intentionally understate revenue or overstate costs to create an easier-to-achieve target, which misallocates organizational resources.',
    },
    // Q1-12
    {
      'question': 'A company uses a counter-current (iterative) approach to budgeting. What does this mean?',
      'options': [
        'The budget is prepared by external consultants only',
        'Top-down targets and bottom-up estimates are exchanged iteratively until alignment is reached',
        'The budget flows only in one direction from the CEO downward',
        'Each department prepares its own budget with no corporate oversight',
      ],
      'correctIndex': 1,
      'explanation':
          'The counter-current (or iterative) approach combines the best of both methods: management provides strategic targets (top-down), departments respond with operational estimates (bottom-up), and several rounds of negotiation occur until the budget is both strategically aligned and operationally realistic.',
    },
    // Q1-13
    {
      'question': 'Which budgeting approach would best suit a fast-growing tech company operating in a rapidly changing market?',
      'options': [
        'Incremental budgeting with annual static budgets',
        'A combination of driver-based budgeting with rolling forecasts',
        'Line-item budgeting with top-down targets only',
        'Zero-based budgeting performed once every five years',
      ],
      'correctIndex': 1,
      'explanation':
          'In volatile environments, driver-based budgeting allows rapid re-forecasting when key metrics change, and rolling forecasts keep the planning horizon continuously relevant. Static annual budgets become outdated quickly when market conditions shift frequently.',
    },
    // === Quiz 2 (module6-quiz2.ts) - 20 questions ===
    // Q2-1
    {
      'question': 'During the budget preparation stage, the Ministry of Finance typically issues:',
      'options': [
        'Audit reports on past spending',
        'Budget circulars with ceilings, guidelines, and macroeconomic assumptions',
        'Tax refunds to citizens',
        'Procurement contracts for capital projects',
      ],
      'correctIndex': 1,
      'explanation':
          'The Ministry of Finance issues budget circulars that set spending ceilings, provide macroeconomic assumptions (GDP growth, inflation), and outline the format and timeline for agency submissions. This ensures all agencies prepare budgets within a consistent framework.',
    },
    // Q2-2
    {
      'question': 'What is the primary role of the legislature in the government budget process?',
      'options': [
        'To prepare the detailed budget for each ministry',
        'To review, amend, debate, and ultimately approve or reject the proposed budget, granting legal spending authority',
        'To execute the budget by making payments',
        'To audit government spending after the fiscal year ends',
      ],
      'correctIndex': 1,
      'explanation':
          'The legislature exercises the "power of the purse." It reviews the executive\'s budget proposal, holds hearings, may amend allocations, and grants legal authority to spend through appropriation acts. Without legislative approval, the government cannot legally spend.',
    },
    // Q2-3
    {
      'question': 'What is "virement" in government budgeting?',
      'options': [
        'The creation of new revenue sources',
        'The authorized transfer of funds from one budget line or program to another within defined limits',
        'The cancellation of an entire department\'s budget',
        'An external audit procedure',
      ],
      'correctIndex': 1,
      'explanation':
          'Virement allows limited reallocation of funds between budget categories or programs without returning to the legislature for a new appropriation. Most governments restrict virement to small percentages (e.g., up to 10% of a line item) and prohibit transfers from capital to operating budgets.',
    },
    // Q2-4
    {
      'question': 'Commitment control in government budget execution means:',
      'options': [
        'Allowing unlimited purchase orders throughout the year',
        'Recording and tracking obligations (purchase orders, contracts) against available appropriations before payments are made, preventing overspending',
        'Committing to reduce next year\'s budget by a fixed percentage',
        'Requiring all purchases to be approved by the president',
      ],
      'correctIndex': 1,
      'explanation':
          'Commitment control tracks the budget at three stages: (1) Commitment (when a purchase order is issued), (2) Verification (when goods/services are received), (3) Payment (when cash is disbursed). By recording commitments against appropriations, it prevents agencies from obligating more than their authorized budget.',
    },
    // Q2-5
    {
      'question': 'Program budgeting organizes government spending by:',
      'options': [
        'Individual line items within each department',
        'Programs and their objectives, grouping all costs needed to achieve a specific policy goal regardless of which department incurs them',
        'Alphabetical order of department names',
        'The seniority of the program manager',
      ],
      'correctIndex': 1,
      'explanation':
          'Program budgeting groups all resources (from potentially multiple departments) required to achieve a specific objective, such as "Reduce childhood illiteracy" or "Improve national road network." This cross-departmental view helps evaluate the full cost of achieving policy goals.',
    },
    // Q2-6
    {
      'question': 'When a government applies zero-based budgeting (ZBB), what happens to existing programs?',
      'options': [
        'They automatically receive last year\'s funding plus inflation',
        'Each program must justify its entire budget from zero, as if it were a new proposal, with decision packages ranked by priority',
        'They are immediately canceled and replaced',
        'They receive funding based on the number of years they have existed',
      ],
      'correctIndex': 1,
      'explanation':
          'Government ZBB requires every program to build its budget from scratch each cycle. Managers create "decision packages" showing the minimum, current, and enhanced service levels with costs for each. Decision-makers then rank all packages across the organization to allocate scarce resources.',
    },
    // Q2-7
    {
      'question': 'What is the Planning-Programming-Budgeting System (PPBS)?',
      'options': [
        'A simple spreadsheet template for budget preparation',
        'A systematic approach that links strategic planning to programming (defining activities) to budgeting (allocating resources), using cost-benefit analysis to choose between alternatives',
        'A payroll processing system',
        'An external audit methodology',
      ],
      'correctIndex': 1,
      'explanation':
          'PPBS, first used by the US Department of Defense in the 1960s, creates an explicit chain from strategic objectives to program activities to resource allocation. It requires cost-benefit analysis of alternative ways to achieve each objective, promoting rational resource allocation.',
    },
    // Q2-8
    {
      'question': 'Which comparison dimension explains why government budgets typically take longer to finalize than private budgets?',
      'options': [
        'Government employees work more slowly',
        'Government budgets require legislative debate, public hearings, and formal appropriation processes that add time but ensure democratic accountability',
        'Government budgets have fewer line items',
        'Private companies never prepare budgets at all',
      ],
      'correctIndex': 1,
      'explanation':
          'The approval process dimension differs dramatically. Private budgets typically need only board or CEO approval. Government budgets go through executive preparation, legislative committee review, public hearings, floor debates, and formal voting -- a process designed for transparency and accountability.',
    },
    // Q2-9
    {
      'question': 'What role does the Supreme Audit Institution (SAI) play in government budgeting?',
      'options': [
        'It prepares the government budget each year',
        'It independently audits government spending after execution, reporting to the legislature on whether funds were used legally, efficiently, and as appropriated',
        'It approves all purchase orders before they are issued',
        'It sets tax rates for the coming fiscal year',
      ],
      'correctIndex': 1,
      'explanation':
          'The SAI (e.g., the General Accountability Office in the US, the National Audit Office in the UK) provides independent external audit of government finances. It reports to the legislature -- not the executive -- ensuring accountability and closing the budget cycle loop.',
    },
    // Q2-10
    {
      'question': 'Regarding revenue sources, a key difference between private and government budgets is:',
      'options': [
        'Private firms rely primarily on taxes; governments rely on sales',
        'Private firms earn revenue from customers through voluntary exchange; governments derive revenue primarily from mandatory taxation and fees',
        'Both rely on the same revenue sources',
        'Governments cannot generate any revenue and rely entirely on borrowing',
      ],
      'correctIndex': 1,
      'explanation':
          'Private revenue comes from voluntary market transactions (customers choose to buy). Government revenue comes predominantly from compulsory sources (taxes are not optional). This fundamental difference in revenue generation shapes budget risk, forecasting methods, and accountability structures.',
    },
    // Q2-11
    {
      'question': 'Which statement best describes the accountability dimension of private vs government budgeting?',
      'options': [
        'Private companies face no accountability for their budgets',
        'Private firms are accountable to shareholders and boards; governments are accountable to citizens, legislators, and oversight bodies, with far greater transparency requirements',
        'Government accountability is lower because there are no shareholders',
        'Both sectors have identical accountability structures',
      ],
      'correctIndex': 1,
      'explanation':
          'Government accountability is broader and deeper: budgets are public documents, subject to legislative scrutiny, SAI audit, freedom of information laws, and media/citizen oversight. Private firms answer primarily to shareholders and boards, with less public disclosure required.',
    },
    // Q2-12
    {
      'question': 'What is the "year-end spending spree" problem in government budgeting, and which comparison dimension does it relate to?',
      'options': [
        'It relates to revenue sources; agencies earn bonuses for spending less',
        'It relates to the incentive structure: agencies rush to spend remaining appropriations before year-end to avoid budget cuts in the next cycle, since unspent funds are often "lost"',
        'It relates to profit motive; agencies try to maximize surplus',
        'It relates to audit timing; auditors only visit at year-end',
      ],
      'correctIndex': 1,
      'explanation':
          'Under "use it or lose it" rules, unspent appropriations lapse at year-end and may signal to budget authorities that the agency does not need as much next year. This perverse incentive encourages wasteful end-of-year spending -- a well-documented challenge unique to government budgeting.',
    },
    // Q2-13
    {
      'question': 'Which of the 10 comparison dimensions focuses on how budget success is measured in each sector?',
      'options': [
        'Revenue sources',
        'Performance measurement: private firms use ROI, margins, and EPS; governments use service delivery metrics, efficiency ratios, and outcome indicators',
        'Budget cycle length',
        'Number of employees involved in the process',
      ],
      'correctIndex': 1,
      'explanation':
          'The performance measurement dimension highlights a fundamental difference: private firms measure budget success by financial returns (ROI, profit margin, EPS). Governments measure success by whether public services are delivered effectively, efficiently, and equitably -- metrics like hospital wait times, student achievement, or road condition indices.',
    },
    // === Quiz 3 (module6-quiz3.ts) - 20 questions ===
    // Q3-1
    {
      'question': 'A CFO discovers that department managers consistently overestimate costs by 20% to create "budget cushions." Which combination of approaches would most effectively reduce this gaming behavior?',
      'options': [
        'Pure top-down budgeting with no departmental input',
        'Driver-based budgeting (linking costs to verifiable operational metrics) combined with an iterative negotiation process',
        'Incremental budgeting with larger adjustments each year',
        'Giving departments unlimited budgets so they have no reason to pad',
      ],
      'correctIndex': 1,
      'explanation':
          'Driver-based budgeting ties costs to observable metrics (headcount, units, square footage), making it harder to inflate estimates without visibly manipulating the drivers. Combined with counter-current negotiation, management can challenge bottom-up estimates against driver-implied benchmarks, reducing slack.',
    },
    // Q3-2
    {
      'question': 'A private company can reallocate \$2M from marketing to R&D with a simple CEO approval. Why can\'t a government ministry do the same thing with similar ease?',
      'options': [
        'Government ministries have more money and do not need to reallocate',
        'Appropriation laws legally bind funds to specific purposes, and virement rules restrict cross-category transfers without legislative consent',
        'Government budgets are always smaller than private budgets',
        'The private company CEO has more experience than government officials',
      ],
      'correctIndex': 1,
      'explanation':
          'Government spending authority comes from appropriation laws passed by the legislature. Reallocating funds between categories may require formal virement approval and is often capped at small percentages. This rigidity is the price of democratic spending control -- preventing the executive from unilaterally redirecting public funds.',
    },
    // Q3-3
    {
      'question': 'The Medium-Term Expenditure Framework (MTEF) in government budgeting is conceptually similar to which private-sector approach?',
      'options': [
        'Line-item budgeting',
        'Rolling forecasts, because both extend the planning horizon beyond a single year and show forward implications of current decisions',
        'Zero-based budgeting',
        'Activity-based budgeting',
      ],
      'correctIndex': 1,
      'explanation':
          'Both MTEF and rolling forecasts address the limitation of single-year budgets. MTEF projects government spending 3-5 years out, showing the recurring costs of today\'s decisions. Rolling forecasts in the private sector similarly maintain a continuous forward-looking window. The key difference: MTEF is formalized through legislation; rolling forecasts are internal management tools.',
    },
    // Q3-4
    {
      'question': 'A developing country wants to implement Performance-Based Budgeting (PBB) but lacks reliable data systems to measure service delivery outcomes. What is the most likely result?',
      'options': [
        'PBB will work perfectly because the concept is self-implementing',
        'The system will likely revert to de facto line-item budgeting, with performance targets becoming ceremonial rather than driving actual allocation decisions',
        'The country will automatically develop better data systems once PBB is announced',
        'Line-item budgeting should be completely abandoned regardless of data availability',
      ],
      'correctIndex': 1,
      'explanation':
          'PBB requires robust data infrastructure to measure outputs and outcomes. Without reliable data, performance targets cannot be validated, and budget decisions fall back on the simplest available method: line-item control. Many developing countries have experienced this -- adopting PBB in form but not in substance.',
    },
    // Q3-5
    {
      'question': 'A company sells \$1M in January on 60-day credit terms and pays \$400K for materials in cash on delivery. How does this timing mismatch appear in the cash budget for January?',
      'options': [
        'Cash inflow of \$1M and cash outflow of \$400K, showing a \$600K surplus',
        'Zero cash inflow from January sales (collected in March) but \$400K cash outflow for materials, creating a \$400K cash deficit',
        'Both transactions are ignored until year-end',
        'Cash inflow of \$600K representing the net profit',
      ],
      'correctIndex': 1,
      'explanation':
          'The cash budget tracks actual cash movements, not accrual revenue. With 60-day credit terms, the \$1M sale generates cash in March, not January. But the \$400K material purchase is paid immediately. January shows a \$400K deficit even though the sale was "profitable." This is why the cash budget often reveals a very different picture from the income statement.',
    },
    // Q3-6
    {
      'question': 'What happens if a government uses incremental budgeting for 10 consecutive years without any fundamental review?',
      'options': [
        'The budget becomes more accurate each year through accumulated experience',
        'Historical inefficiencies, redundant programs, and misallocated resources become permanently embedded in the budget base, growing larger each year with incremental adjustments',
        'It produces the same result as zero-based budgeting over time',
        'Budgets naturally optimize themselves without management intervention',
      ],
      'correctIndex': 1,
      'explanation':
          'Incremental budgeting\'s fatal flaw is that it builds on the existing base without questioning it. After 10 years, programs that lost relevance, duplicate efforts, or waste resources still receive funding -- plus annual increases. The base becomes a "fossilized" collection of past decisions, not a reflection of current needs.',
    },
    // Q3-7
    {
      'question': 'A manufacturer plans to sell 50,000 units in Q1. Company policy requires ending inventory equal to 20% of next quarter\'s expected sales (Q2 forecast: 60,000 units). Beginning inventory is 9,000 units. How many units must be produced in Q1?',
      'options': [
        '50,000 units',
        '53,000 units (50,000 + 12,000 - 9,000)',
        '62,000 units',
        '41,000 units',
      ],
      'correctIndex': 1,
      'explanation':
          'Required ending inventory = 20% of Q2 sales = 0.20 x 60,000 = 12,000 units. Production = Sales + Desired Ending Inventory - Beginning Inventory = 50,000 + 12,000 - 9,000 = 53,000 units. This formula ensures the company meets current demand while building the safety stock for next quarter.',
    },
    // Q3-8
    {
      'question': 'An airline faces extreme revenue volatility due to fuel prices, seasonal demand, and geopolitical disruptions. Which budgeting combination is most appropriate?',
      'options': [
        'Annual static budget with top-down targets',
        'Driver-based budgeting (keyed to load factor, fuel cost, and route count) with rolling forecasts and flexible budgets for cost control',
        'Pure ZBB performed once a year with no mid-year adjustments',
        'Incremental budgeting based on last year\'s average fuel price',
      ],
      'correctIndex': 1,
      'explanation':
          'Airlines need three things: (1) driver-based models to quickly re-forecast when key variables change (fuel, load factor), (2) rolling forecasts to keep the planning horizon current, and (3) flexible budgets that adjust cost targets when actual activity differs from plan. Static or incremental approaches cannot keep pace with this level of volatility.',
    },
    // Q3-9
    {
      'question': 'A government agency issues a purchase order for \$100,000 in office furniture. At this point, the agency has:',
      'options': [
        'Already spent \$100,000 from its appropriation',
        'Created an encumbrance (commitment) of \$100,000 that reduces available budget but no cash has been disbursed yet',
        'Transferred \$100,000 to the furniture vendor\'s bank account',
        'No budget impact until the furniture is delivered and paid for',
      ],
      'correctIndex': 1,
      'explanation':
          'Issuing a purchase order creates an encumbrance -- a recorded commitment that reduces the available balance in the appropriation account. Cash has not yet been spent, but the funds are "reserved" so they cannot be committed to other purposes. This three-stage process (commit, verify, pay) is the essence of commitment control.',
    },
    // Q3-10
    {
      'question': 'A hospital uses Activity-Based Budgeting. How would it budget for the radiology department differently from traditional approaches?',
      'options': [
        'It would simply increase last year\'s radiology budget by 5%',
        'It would estimate the number of scans expected, determine the cost per scan (technician time, equipment depreciation, supplies), and budget based on projected scan volume',
        'It would ask the radiology manager to guess total costs',
        'It would eliminate the radiology department to reduce costs',
      ],
      'correctIndex': 1,
      'explanation':
          'ABB identifies the activities (performing scans), estimates cost drivers (number of scans), and calculates resource needs from the activity volume. If 20,000 scans are expected and each costs \$150 in resources, the budget is \$3M. This is more precise than adding 5% to last year\'s spending, which may not reflect changes in patient volume or technology.',
    },
    // Q3-11
    {
      'question': 'Under PPBS, a defense ministry is choosing between two anti-terrorism programs: Program A costs \$500M and is estimated to reduce incidents by 40%; Program B costs \$300M and is estimated to reduce incidents by 30%. Which decision does PPBS support and why?',
      'options': [
        'Always choose the cheapest option (Program B)',
        'PPBS would compare the cost per percentage point of reduction: A costs \$12.5M per point (500/40), B costs \$10M per point (300/30), making B more cost-effective per unit of outcome',
        'Always choose the option with the highest absolute effectiveness (Program A)',
        'PPBS does not involve cost-benefit analysis',
      ],
      'correctIndex': 1,
      'explanation':
          'PPBS explicitly uses cost-benefit (or cost-effectiveness) analysis to compare alternatives. Program A: \$500M / 40% = \$12.5M per percentage point. Program B: \$300M / 30% = \$10M per percentage point. While A achieves more in absolute terms, B delivers each unit of result more efficiently. The decision then depends on the target reduction level and available budget.',
    },
    // Q3-12
    {
      'question': 'A large corporation uses incremental budgeting for routine operating expenses but applies ZBB to its marketing budget every three years. Why might this mixed approach make sense?',
      'options': [
        'It makes no sense -- companies should use only one approach for all budgets',
        'ZBB is too time-consuming to apply to every cost center every year, but periodic ZBB review of discretionary budgets like marketing prevents waste without overwhelming the organization',
        'Marketing budgets are always too small for ZBB to matter',
        'Incremental budgeting is more accurate than ZBB for marketing',
      ],
      'correctIndex': 1,
      'explanation':
          'ZBB is powerful but resource-intensive. A pragmatic approach uses incremental budgeting for stable, low-risk areas (utilities, rent) while applying ZBB periodically to discretionary budgets where waste accumulates (marketing, consulting, T&E). This balances thoroughness with practicality -- an approach used by many Fortune 500 companies.',
    },
    // Q3-13
    {
      'question': 'A government allocates \$50M to "Education" across three ministries: \$30M in the Education Ministry, \$12M in the Labor Ministry (vocational training), and \$8M in the Social Affairs Ministry (adult literacy). Line-item budgeting shows each ministry\'s spending; program budgeting shows:',
      'options': [
        'Only the Education Ministry\'s spending on education',
        'The total \$50M education program cost across all three ministries, enabling evaluation of the full investment in education regardless of organizational boundaries',
        'The salary costs within each ministry separately',
        'The same information as line-item budgeting but in a different format',
      ],
      'correctIndex': 1,
      'explanation':
          'Program budgeting\'s unique value is cross-organizational aggregation. It answers: "How much are we spending on education in total?" rather than "How much is each ministry spending?" This enables the government to evaluate whether \$50M is adequate, compare it to outcomes, and make informed allocation decisions across organizational boundaries.',
    },
    // Q3-14
    {
      'question': 'A newly privatized utility company that was previously government-owned is developing its first private-sector budget. Which of the following changes will it most need to make in its budgeting approach?',
      'options': [
        'Continue using government appropriation-based budgeting since the processes are identical',
        'Shift from compliance-driven budgeting (staying within appropriations) to performance-driven budgeting (maximizing return on invested capital), with revenue forecasts replacing tax allocations as the budget starting point',
        'Eliminate all budgeting since private companies do not need budgets',
        'Only prepare a cash budget and ignore the income statement projection',
      ],
      'correctIndex': 1,
      'explanation':
          'A privatized utility must fundamentally reorient its budgeting: (1) revenue now comes from customer payments, not appropriations, requiring sales forecasting; (2) the goal shifts from compliance to profitability; (3) the budget timeline is set internally, not by legislative cycles; (4) capital investment decisions now require ROI analysis rather than legislative authorization. This question integrates five comparison dimensions.',
    },
  ],
);
