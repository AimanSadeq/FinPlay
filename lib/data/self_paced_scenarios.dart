// Hardcoded fallback scenarios for self-paced mode when Excel API is unavailable.
// Matches website's client/src/data/self-paced-scenarios.ts exactly.

class SelfPacedScenarioData {
  final String id;
  final int round;
  final String module;
  final String title;
  final String description;
  final int amount;
  final String riskLevel;

  const SelfPacedScenarioData({
    required this.id,
    required this.round,
    required this.module,
    required this.title,
    required this.description,
    required this.amount,
    required this.riskLevel,
  });

  Map<String, dynamic> toMap() => {
    'scenarioId': id,
    'id': id,
    'round': round,
    'module': module,
    'title': title,
    'description': description,
    'amount': amount,
    'riskLevel': riskLevel,
  };
}

List<Map<String, dynamic>> getFallbackScenarios(int round, String module) {
  return _allScenarios
      .where((s) => s.round == round && s.module == module)
      .map((s) => s.toMap())
      .toList();
}

const _allScenarios = <SelfPacedScenarioData>[
  // ── Financing Round 1 ──
  SelfPacedScenarioData(
    id: 'FIN-R1-01', round: 1, module: 'financing',
    title: 'Bank Term Loan',
    description: 'Secure a 5-year term loan at 6% annual interest. Provides stable funding for operations.',
    amount: 500000, riskLevel: 'Low',
  ),
  SelfPacedScenarioData(
    id: 'FIN-R1-02', round: 1, module: 'financing',
    title: 'Equity Investment',
    description: 'Issue new shares to investors. No repayment required but dilutes ownership.',
    amount: 750000, riskLevel: 'Medium',
  ),
  SelfPacedScenarioData(
    id: 'FIN-R1-03', round: 1, module: 'financing',
    title: 'Corporate Bonds',
    description: 'Issue 10-year bonds at 5.5% coupon rate. Long-term debt financing option.',
    amount: 1000000, riskLevel: 'Medium',
  ),

  // ── Financing Round 2 ──
  SelfPacedScenarioData(
    id: 'FIN-R2-01', round: 2, module: 'financing',
    title: 'Revolving Credit Line',
    description: 'Establish a flexible credit facility for working capital needs.',
    amount: 300000, riskLevel: 'Low',
  ),
  SelfPacedScenarioData(
    id: 'FIN-R2-02', round: 2, module: 'financing',
    title: 'Private Placement',
    description: 'Raise capital from select institutional investors privately.',
    amount: 600000, riskLevel: 'Medium',
  ),
  SelfPacedScenarioData(
    id: 'FIN-R2-03', round: 2, module: 'financing',
    title: 'Asset-Backed Financing',
    description: 'Use company assets as collateral for secured borrowing.',
    amount: 450000, riskLevel: 'High',
  ),

  // ── Financing Round 3 ──
  SelfPacedScenarioData(
    id: 'FIN-R3-01', round: 3, module: 'financing',
    title: 'Subordinated Debt',
    description: 'Issue junior debt with higher interest but flexible terms.',
    amount: 400000, riskLevel: 'High',
  ),
  SelfPacedScenarioData(
    id: 'FIN-R3-02', round: 3, module: 'financing',
    title: 'Convertible Notes',
    description: 'Debt that can convert to equity at a future date.',
    amount: 550000, riskLevel: 'Medium',
  ),
  SelfPacedScenarioData(
    id: 'FIN-R3-03', round: 3, module: 'financing',
    title: 'Retained Earnings',
    description: 'Reinvest profits instead of distributing dividends.',
    amount: 200000, riskLevel: 'Low',
  ),

  // ── Investing Round 1 ──
  SelfPacedScenarioData(
    id: 'INV-R1-01', round: 1, module: 'investing',
    title: 'Equipment Purchase',
    description: 'Acquire new production equipment to increase capacity.',
    amount: 350000, riskLevel: 'Low',
  ),
  SelfPacedScenarioData(
    id: 'INV-R1-02', round: 1, module: 'investing',
    title: 'R&D Investment',
    description: 'Invest in research and development for new products.',
    amount: 200000, riskLevel: 'High',
  ),
  SelfPacedScenarioData(
    id: 'INV-R1-03', round: 1, module: 'investing',
    title: 'Technology Upgrade',
    description: 'Modernize IT systems and infrastructure.',
    amount: 180000, riskLevel: 'Medium',
  ),

  // ── Investing Round 2 ──
  SelfPacedScenarioData(
    id: 'INV-R2-01', round: 2, module: 'investing',
    title: 'Facility Expansion',
    description: 'Expand manufacturing facilities to meet growing demand.',
    amount: 800000, riskLevel: 'Medium',
  ),
  SelfPacedScenarioData(
    id: 'INV-R2-02', round: 2, module: 'investing',
    title: 'Market Research',
    description: 'Conduct comprehensive market analysis for new opportunities.',
    amount: 75000, riskLevel: 'Low',
  ),
  SelfPacedScenarioData(
    id: 'INV-R2-03', round: 2, module: 'investing',
    title: 'Strategic Acquisition',
    description: 'Acquire a smaller competitor to expand market share.',
    amount: 1200000, riskLevel: 'High',
  ),

  // ── Investing Round 3 ──
  SelfPacedScenarioData(
    id: 'INV-R3-01', round: 3, module: 'investing',
    title: 'Automation Project',
    description: 'Implement automation to reduce labor costs.',
    amount: 500000, riskLevel: 'Medium',
  ),
  SelfPacedScenarioData(
    id: 'INV-R3-02', round: 3, module: 'investing',
    title: 'International Expansion',
    description: 'Enter new international markets with local operations.',
    amount: 900000, riskLevel: 'High',
  ),
  SelfPacedScenarioData(
    id: 'INV-R3-03', round: 3, module: 'investing',
    title: 'Intellectual Property',
    description: 'Acquire patents and trademarks for competitive advantage.',
    amount: 250000, riskLevel: 'Medium',
  ),

  // ── Operating Round 1 ──
  SelfPacedScenarioData(
    id: 'OPS-R1-01', round: 1, module: 'operating',
    title: 'Marketing Campaign',
    description: 'Launch comprehensive marketing campaign to boost sales.',
    amount: 150000, riskLevel: 'Medium',
  ),
  SelfPacedScenarioData(
    id: 'OPS-R1-02', round: 1, module: 'operating',
    title: 'Staff Training',
    description: 'Invest in employee development and training programs.',
    amount: 80000, riskLevel: 'Low',
  ),
  SelfPacedScenarioData(
    id: 'OPS-R1-03', round: 1, module: 'operating',
    title: 'Quality Improvement',
    description: 'Implement quality management systems and processes.',
    amount: 100000, riskLevel: 'Low',
  ),

  // ── Operating Round 2 ──
  SelfPacedScenarioData(
    id: 'OPS-R2-01', round: 2, module: 'operating',
    title: 'Supply Chain Optimization',
    description: 'Streamline supply chain for cost efficiency.',
    amount: 120000, riskLevel: 'Medium',
  ),
  SelfPacedScenarioData(
    id: 'OPS-R2-02', round: 2, module: 'operating',
    title: 'Customer Service Enhancement',
    description: 'Upgrade customer support systems and processes.',
    amount: 90000, riskLevel: 'Low',
  ),
  SelfPacedScenarioData(
    id: 'OPS-R2-03', round: 2, module: 'operating',
    title: 'Energy Efficiency',
    description: 'Implement energy-saving initiatives across operations.',
    amount: 60000, riskLevel: 'Low',
  ),

  // ── Operating Round 3 ──
  SelfPacedScenarioData(
    id: 'OPS-R3-01', round: 3, module: 'operating',
    title: 'Digital Transformation',
    description: 'Digitize business processes for improved efficiency.',
    amount: 200000, riskLevel: 'Medium',
  ),
  SelfPacedScenarioData(
    id: 'OPS-R3-02', round: 3, module: 'operating',
    title: 'Inventory Management',
    description: 'Implement advanced inventory tracking systems.',
    amount: 70000, riskLevel: 'Low',
  ),
  SelfPacedScenarioData(
    id: 'OPS-R3-03', round: 3, module: 'operating',
    title: 'Sustainability Initiative',
    description: 'Launch environmental sustainability programs.',
    amount: 110000, riskLevel: 'Medium',
  ),
];
