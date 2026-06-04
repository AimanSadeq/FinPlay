class Decision {
  final String? id;
  final String teamId;
  final int roundNum;
  final String module;
  final Map<String, dynamic> decisionData;
  final DateTime? submittedAt;
  final bool isLocked;

  const Decision({
    this.id,
    required this.teamId,
    required this.roundNum,
    required this.module,
    required this.decisionData,
    this.submittedAt,
    this.isLocked = false,
  });

  factory Decision.fromJson(Map<String, dynamic> json) {
    return Decision(
      id: json['id']?.toString(),
      teamId: json['teamId']?.toString() ?? '',
      roundNum: json['roundNum'] is int
          ? json['roundNum'] as int
          : int.tryParse(json['roundNum']?.toString() ?? '') ?? 1,
      module: json['module']?.toString() ?? '',
      decisionData: json['decisionData'] as Map<String, dynamic>? ?? {},
      submittedAt: json['submittedAt'] != null
          ? DateTime.tryParse(json['submittedAt'].toString()) : null,
      isLocked: json['isLocked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'teamId': teamId,
    'roundNum': roundNum,
    'module': module,
    'decisionData': decisionData,
  };
}

class FinancingDecision {
  final double debtFinancing;
  final double equityFinancing;
  final double shortTermLoan;
  final double longTermDebt;
  final String? strategy;

  const FinancingDecision({
    this.debtFinancing = 0,
    this.equityFinancing = 0,
    this.shortTermLoan = 0,
    this.longTermDebt = 0,
    this.strategy,
  });

  Map<String, dynamic> toJson() => {
    'debtFinancing': debtFinancing,
    'equityFinancing': equityFinancing,
    'shortTermLoan': shortTermLoan,
    'longTermDebt': longTermDebt,
    if (strategy != null) 'strategy': strategy,
  };
}

class InvestingDecision {
  final double capex;
  final double equipment;
  final double rnd;
  final String? strategy;
  final String? riskLevel;

  const InvestingDecision({
    this.capex = 0,
    this.equipment = 0,
    this.rnd = 0,
    this.strategy,
    this.riskLevel,
  });

  Map<String, dynamic> toJson() => {
    'capex': capex,
    'equipment': equipment,
    'rnd': rnd,
    if (strategy != null) 'strategy': strategy,
    if (riskLevel != null) 'riskLevel': riskLevel,
  };
}

class OperatingDecision {
  final double productionVolume;
  final double marketingSpend;
  final double staffingLevel;
  final String? pricingStrategy;
  final double operationalEfficiency;
  final String? qualityLevel;

  const OperatingDecision({
    this.productionVolume = 0,
    this.marketingSpend = 0,
    this.staffingLevel = 0,
    this.pricingStrategy,
    this.operationalEfficiency = 0,
    this.qualityLevel,
  });

  Map<String, dynamic> toJson() => {
    'productionVolume': productionVolume,
    'marketingSpend': marketingSpend,
    'staffingLevel': staffingLevel,
    if (pricingStrategy != null) 'pricingStrategy': pricingStrategy,
    'operationalEfficiency': operationalEfficiency,
    if (qualityLevel != null) 'qualityLevel': qualityLevel,
  };
}
