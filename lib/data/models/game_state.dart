class GameState {
  final int currentRound;
  final String currentModule;
  final bool isActive;
  final int? timeRemaining;
  final bool lockFinancing;
  final bool lockInvesting;
  final bool lockOperating;
  final bool nextDecisionsUnlocked;
  final bool breakEvenUnlocked;
  final bool capitalBudgetingUnlocked;
  final bool govEducationUnlocked;
  final List<int> govEducationModulesUnlocked;
  final bool educationUnlocked; // master education gate
  final List<int> educationModulesUnlocked; // per-module unlock ids
  final bool educationRetryUnlocked;
  final bool preAssessmentMandated;
  final bool postAssessmentMandated;
  final bool siteAccessEnabled;
  final String? activeQrPlaceholder;
  final String? activeCaseStudyId;
  final String gameMode;
  final bool corporateModeEnabled;

  const GameState({
    this.currentRound = 1,
    this.currentModule = 'financing',
    this.isActive = false,
    this.timeRemaining,
    this.lockFinancing = false,
    this.lockInvesting = false,
    this.lockOperating = false,
    this.nextDecisionsUnlocked = false,
    this.breakEvenUnlocked = false,
    this.capitalBudgetingUnlocked = false,
    this.govEducationUnlocked = false,
    this.govEducationModulesUnlocked = const [],
    this.educationUnlocked = false,
    this.educationModulesUnlocked = const [],
    this.educationRetryUnlocked = false,
    this.preAssessmentMandated = false,
    this.postAssessmentMandated = false,
    this.siteAccessEnabled = false,
    this.activeQrPlaceholder,
    this.activeCaseStudyId,
    this.gameMode = 'facilitator',
    this.corporateModeEnabled = false,
  });

  factory GameState.fromJson(Map<String, dynamic> json) {
    // Handle both formats: {roundNum, module, locks: {}} and flat format
    final locks = json['locks'] as Map<String, dynamic>?;

    return GameState(
      currentRound: json['roundNum'] as int? ?? json['currentRound'] as int? ?? 1,
      currentModule: json['module'] as String? ?? json['currentModule'] as String? ?? 'financing',
      isActive: json['isActive'] as bool? ?? true,
      timeRemaining: json['timeRemaining'] as int?,
      lockFinancing: locks?['financing'] as bool? ?? json['lockFinancing'] as bool? ?? false,
      lockInvesting: locks?['investing'] as bool? ?? json['lockInvesting'] as bool? ?? false,
      lockOperating: locks?['operating'] as bool? ?? json['lockOperating'] as bool? ?? false,
      nextDecisionsUnlocked: json['nextDecisionsUnlocked'] as bool? ?? false,
      breakEvenUnlocked: json['breakEvenUnlocked'] as bool? ?? false,
      capitalBudgetingUnlocked: json['capitalBudgetingUnlocked'] as bool? ?? false,
      govEducationUnlocked: json['govEducationUnlocked'] as bool? ?? false,
      govEducationModulesUnlocked: (json['govEducationModulesUnlocked'] as List<dynamic>?)
          ?.map((e) => e as int).toList() ?? [],
      educationUnlocked: json['educationUnlocked'] as bool? ?? false,
      educationModulesUnlocked: (json['educationModulesUnlocked'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt()).toList() ?? [],
      educationRetryUnlocked: json['educationRetryUnlocked'] as bool? ?? false,
      preAssessmentMandated: json['preAssessmentMandated'] as bool? ?? false,
      postAssessmentMandated: json['postAssessmentMandated'] as bool? ?? false,
      siteAccessEnabled: json['siteAccessEnabled'] as bool? ?? false,
      activeQrPlaceholder: json['activeQrPlaceholder'] as String?,
      activeCaseStudyId: json['activeCaseStudyId'] as String?,
      gameMode: json['gameMode'] as String? ?? 'facilitator',
      corporateModeEnabled: json['corporateModeEnabled'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'currentRound': currentRound,
    'currentModule': currentModule,
    'isActive': isActive,
    'timeRemaining': timeRemaining,
    'lockFinancing': lockFinancing,
    'lockInvesting': lockInvesting,
    'lockOperating': lockOperating,
  };

  bool get isModuleLocked {
    switch (currentModule) {
      case 'financing': return lockFinancing;
      case 'investing': return lockInvesting;
      case 'operating': return lockOperating;
      default: return false;
    }
  }
}
