/// A single line item in a financial statement (from Excel)
class StatementRow {
  final String title;
  final double value;
  final bool isHeader;
  final bool isMajor;
  final bool isCalculation;
  final String? type; // For ratios: "Liquidity", "Efficiency", etc.

  const StatementRow({
    required this.title,
    this.value = 0,
    this.isHeader = false,
    this.isMajor = false,
    this.isCalculation = false,
    this.type,
  });

  factory StatementRow.fromJson(Map<String, dynamic> json) {
    return StatementRow(
      title: json['title']?.toString() ?? '',
      value: _parseNum(json['value']),
      isHeader: json['isHeader'] as bool? ?? false,
      isMajor: json['isMajor'] as bool? ?? false,
      isCalculation: json['isCalculation'] as bool? ?? false,
      type: json['type'] as String?,
    );
  }

  static double _parseNum(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    if (v is String) {
      if (v == 'NaN' || v.isEmpty) return 0;
      return double.tryParse(v) ?? 0;
    }
    return 0;
  }
}

class FinancialData {
  final String teamId;
  final int roundNum;
  final List<StatementRow> incomeRows;
  final List<StatementRow> balanceRows;
  final List<StatementRow> cashFlowRows;
  final List<StatementRow> ratioRows;
  final double revenue;
  final double netIncome;
  final double totalAssets;
  final double totalLiabilities;
  final double totalEquity;
  final double operatingCashFlow;
  final double totalScore;
  final String? source;

  const FinancialData({
    required this.teamId,
    required this.roundNum,
    this.incomeRows = const [],
    this.balanceRows = const [],
    this.cashFlowRows = const [],
    this.ratioRows = const [],
    this.revenue = 0,
    this.netIncome = 0,
    this.totalAssets = 0,
    this.totalLiabilities = 0,
    this.totalEquity = 0,
    this.operatingCashFlow = 0,
    this.totalScore = 0,
    this.source,
  });

  // Backward-compatible getters (used by KPI chips)
  Map<String, dynamic>? get incomeStatement => incomeRows.isEmpty
      ? null
      : {for (final r in incomeRows) r.title.trim(): r.value};
  Map<String, dynamic>? get balanceSheet => balanceRows.isEmpty
      ? null
      : {for (final r in balanceRows) r.title.trim(): r.value};
  Map<String, dynamic>? get cashFlow => cashFlowRows.isEmpty
      ? null
      : {for (final r in cashFlowRows) r.title.trim(): r.value};
  Map<String, dynamic>? get ratios => ratioRows.isEmpty
      ? null
      : {for (final r in ratioRows) r.title.trim(): r.value};

  /// Parse a single statement response from /api/sheets/results/round
  static FinancialData fromSheetResponse(
    Map<String, dynamic> json, {
    String statementType = 'income',
  }) {
    final financials = json['financials'] as Map<String, dynamic>? ?? {};
    final kpis = json['kpis'] as Map<String, dynamic>? ?? {};
    final rawValues = kpis['_rawValues'] as Map<String, dynamic>? ?? {};

    List<StatementRow> parseRows(dynamic list) {
      if (list is! List) return [];
      return list
          .map((e) => StatementRow.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    final incomeRows = parseRows(financials['incomeStatement']);
    final balanceRows = parseRows(financials['balanceSheet']);
    final cashFlowRows = parseRows(financials['cashFlow']);
    final ratioRows = parseRows(financials['ratios']);

    // Extract KPIs from kpis._rawValues first, then fall back to row titles
    double kpi(String key) => StatementRow._parseNum(rawValues[key] ?? kpis[key]);

    double revenue = kpi('revenue');
    double netIncome = kpi('netIncome');
    double totalAssets = kpi('totalAssets');
    double totalLiabilities = kpi('totalLiabilities');
    double totalEquity = kpi('totalEquity');
    double operatingCashFlow = StatementRow._parseNum(kpis['operatingCashFlowRatio']);

    // When kpis not present, extract values from statement rows by title
    if (revenue == 0 && incomeRows.isNotEmpty) {
      revenue = _findRowValue(incomeRows, ['Sales', 'Revenue', 'Total Revenue']);
    }
    if (netIncome == 0 && incomeRows.isNotEmpty) {
      netIncome = _findRowValue(incomeRows, ['Net Income', 'Net Profit']);
    }
    if (totalAssets == 0 && balanceRows.isNotEmpty) {
      totalAssets = _findRowValue(balanceRows, ['Total Assets']);
    }
    if (totalLiabilities == 0 && balanceRows.isNotEmpty) {
      totalLiabilities = _findRowValue(balanceRows, ['Total Liabilities']);
    }
    if (totalEquity == 0 && balanceRows.isNotEmpty) {
      totalEquity = _findRowValue(balanceRows, ['Total Equity', "Total Shareholders' Equity", 'Total Shareholder Equity']);
    }
    if (operatingCashFlow == 0 && cashFlowRows.isNotEmpty) {
      operatingCashFlow = _findRowValue(cashFlowRows, ['Operating Cash Flow', 'Cash from Operations', 'Net Cash from Operating']);
    }

    return FinancialData(
      teamId: json['team']?.toString() ?? '',
      roundNum: json['round'] as int? ?? 1,
      incomeRows: incomeRows,
      balanceRows: balanceRows,
      cashFlowRows: cashFlowRows,
      ratioRows: ratioRows,
      revenue: revenue,
      netIncome: netIncome,
      totalAssets: totalAssets,
      totalLiabilities: totalLiabilities,
      totalEquity: totalEquity,
      operatingCashFlow: operatingCashFlow,
      source: json['source']?.toString(),
    );
  }

  /// Find a row value by matching title (case-insensitive contains)
  static double _findRowValue(List<StatementRow> rows, List<String> titleMatches) {
    for (final match in titleMatches) {
      final lower = match.toLowerCase();
      for (final row in rows) {
        if (row.title.toLowerCase().contains(lower)) return row.value;
      }
    }
    return 0;
  }

  /// Merge multiple statement responses into one
  FinancialData mergeWith(FinancialData other) {
    return FinancialData(
      teamId: teamId.isNotEmpty ? teamId : other.teamId,
      roundNum: roundNum > 0 ? roundNum : other.roundNum,
      incomeRows: incomeRows.isNotEmpty ? incomeRows : other.incomeRows,
      balanceRows: balanceRows.isNotEmpty ? balanceRows : other.balanceRows,
      cashFlowRows: cashFlowRows.isNotEmpty ? cashFlowRows : other.cashFlowRows,
      ratioRows: ratioRows.isNotEmpty ? ratioRows : other.ratioRows,
      revenue: revenue != 0 ? revenue : other.revenue,
      netIncome: netIncome != 0 ? netIncome : other.netIncome,
      totalAssets: totalAssets != 0 ? totalAssets : other.totalAssets,
      totalLiabilities: totalLiabilities != 0 ? totalLiabilities : other.totalLiabilities,
      totalEquity: totalEquity != 0 ? totalEquity : other.totalEquity,
      operatingCashFlow: operatingCashFlow != 0 ? operatingCashFlow : other.operatingCashFlow,
      totalScore: totalScore != 0 ? totalScore : other.totalScore,
    );
  }

  /// Legacy fromJson for backward compatibility
  factory FinancialData.fromJson(Map<String, dynamic> json) {
    // Check if this is the new sheets format
    if (json.containsKey('financials') || json.containsKey('kpis')) {
      return FinancialData.fromSheetResponse(json);
    }
    // Legacy format
    return FinancialData(
      teamId: json['teamId']?.toString() ?? '',
      roundNum: json['roundNum'] as int? ?? 1,
      totalScore: (json['totalScore'] as num?)?.toDouble() ?? 0,
    );
  }
}

class LeaderboardEntry {
  final String teamId;
  final String teamName;
  final String displayName;
  final int roundNum;
  final double score;
  final int rank;
  final double netIncome;
  final double revenue;
  final double totalAssets;
  final double totalEquity;
  final double roeValue;
  final bool isCashRich;
  final double operatingCF;
  final double investingCF;
  final double financingCF;
  final List<String> badges;

  const LeaderboardEntry({
    required this.teamId,
    required this.teamName,
    this.displayName = '',
    this.roundNum = 1,
    required this.score,
    this.rank = 0,
    this.netIncome = 0,
    this.revenue = 0,
    this.totalAssets = 0,
    this.totalEquity = 0,
    this.roeValue = 0,
    this.isCashRich = false,
    this.operatingCF = 0,
    this.investingCF = 0,
    this.financingCF = 0,
    this.badges = const [],
  });

  double get cashFlowValue => operatingCF + investingCF + financingCF;
  double get roe => roeValue;
  double get profitMargin => revenue > 0 ? (netIncome / revenue) * 100 : 0;
  double get assetTurnover => totalAssets > 0 ? revenue / totalAssets : 0;

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    // Handle both old format (flat) and new /leaderboard/live format (nested metrics)
    final metrics = json['metrics'] as Map<String, dynamic>? ?? {};
    final cashFlow = json['cashFlow'] as Map<String, dynamic>?;

    return LeaderboardEntry(
      teamId: json['teamId']?.toString() ?? '',
      teamName: json['teamName']?.toString() ?? 'Team ${json['teamId']}',
      displayName: json['displayName']?.toString() ?? '',
      roundNum: json['round'] as int? ?? json['roundNum'] as int? ?? 1,
      score: _parseDouble(json['score']),
      rank: json['rank'] as int? ?? 0,
      netIncome: _parseDouble(metrics['netIncome'] ?? json['netIncome']),
      revenue: _parseDouble(metrics['revenue'] ?? json['revenue']),
      totalAssets: _parseDouble(metrics['totalAssets'] ?? json['totalAssets']),
      totalEquity: _parseDouble(metrics['totalEquity']),
      roeValue: _parseDouble(metrics['roe']),
      isCashRich: cashFlow?['isCashRich'] as bool? ?? false,
      operatingCF: _parseDouble(cashFlow?['operating']),
      investingCF: _parseDouble(cashFlow?['investing']),
      financingCF: _parseDouble(cashFlow?['financing']),
      badges: (json['badges'] as List<dynamic>?)
          ?.map((e) => e as String).toList() ?? [],
    );
  }

  /// Parse a value that could be int, double, String, or "NaN"
  static double _parseDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    if (value is String) {
      if (value == 'NaN' || value.isEmpty) return 0;
      return double.tryParse(value) ?? 0;
    }
    return 0;
  }
}
