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
  // Cohort access code (facilitator status only — never on public reads). Set
  // when corporate mode is live; participants must present it to sign in.
  final String? corporateAccessCode;

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
    this.corporateAccessCode,
  });

  /// Parses either payload the app reads:
  ///
  /// * GET /sheets/round/state (public): {roundNum, module, timeRemaining,
  ///   timerActive, locks:{financing,investing,operating}, nextDecisionsUnlocked,
  ///   excelMode}. It carries no isActive, education or corporate fields.
  /// * GET /facilitator/status `gameState` (facilitator): the flat format with
  ///   currentRound, currentModule, isActive, lockFinancing/Investing/Operating,
  ///   nextDecisionsUnlocked, educationUnlocked, educationModulesUnlocked,
  ///   educationRetryUnlocked, preAssessmentMandated, postAssessmentMandated,
  ///   activeQrPlaceholder, activeCaseStudyId, gameMode, corporateModeEnabled
  ///   and corporateAccessCode.
  ///
  /// With [base], a key the payload lacks keeps the value [base] holds instead
  /// of resetting to the default, so a partial update (a socket push, a
  /// round-state read on a facilitator device) cannot wipe the facilitator
  /// fields a status read filled in.
  factory GameState.fromJson(Map<String, dynamic> json, {GameState? base}) {
    // Handle both formats: {roundNum, module, locks: {}} and flat format
    final locks = json['locks'] as Map<String, dynamic>?;

    return GameState(
      currentRound: json['roundNum'] as int? ?? json['currentRound'] as int? ?? base?.currentRound ?? 1,
      currentModule: json['module'] as String? ?? json['currentModule'] as String? ?? base?.currentModule ?? 'financing',
      isActive: json['isActive'] as bool? ?? base?.isActive ?? true,
      timeRemaining: json['timeRemaining'] as int? ?? base?.timeRemaining,
      lockFinancing: locks?['financing'] as bool? ?? json['lockFinancing'] as bool? ?? base?.lockFinancing ?? false,
      lockInvesting: locks?['investing'] as bool? ?? json['lockInvesting'] as bool? ?? base?.lockInvesting ?? false,
      lockOperating: locks?['operating'] as bool? ?? json['lockOperating'] as bool? ?? base?.lockOperating ?? false,
      nextDecisionsUnlocked: json['nextDecisionsUnlocked'] as bool? ?? base?.nextDecisionsUnlocked ?? false,
      breakEvenUnlocked: json['breakEvenUnlocked'] as bool? ?? base?.breakEvenUnlocked ?? false,
      capitalBudgetingUnlocked: json['capitalBudgetingUnlocked'] as bool? ?? base?.capitalBudgetingUnlocked ?? false,
      educationUnlocked: json['educationUnlocked'] as bool? ?? base?.educationUnlocked ?? false,
      educationModulesUnlocked: (json['educationModulesUnlocked'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt()).toList() ?? base?.educationModulesUnlocked ?? [],
      educationRetryUnlocked: json['educationRetryUnlocked'] as bool? ?? base?.educationRetryUnlocked ?? false,
      preAssessmentMandated: json['preAssessmentMandated'] as bool? ?? base?.preAssessmentMandated ?? false,
      postAssessmentMandated: json['postAssessmentMandated'] as bool? ?? base?.postAssessmentMandated ?? false,
      siteAccessEnabled: json['siteAccessEnabled'] as bool? ?? base?.siteAccessEnabled ?? false,
      activeQrPlaceholder: json['activeQrPlaceholder'] as String? ?? base?.activeQrPlaceholder,
      activeCaseStudyId: json['activeCaseStudyId'] as String? ?? base?.activeCaseStudyId,
      gameMode: json['gameMode'] as String? ?? base?.gameMode ?? 'facilitator',
      corporateModeEnabled: json['corporateModeEnabled'] as bool? ?? base?.corporateModeEnabled ?? false,
      corporateAccessCode: json.containsKey('corporateAccessCode')
          ? json['corporateAccessCode'] as String?
          : base?.corporateAccessCode,
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
