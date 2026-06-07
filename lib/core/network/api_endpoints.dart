class ApiEndpoints {
  ApiEndpoints._();

  // Health
  static const String health = '/health';

  // Teams
  static const String teams = '/teams';
  static const String teamById = '/teams/{id}';
  static const String sessionInit = '/session/init';

  // Game State
  static const String roundState = '/sheets/round/state';
  static const String teamProgression = '/team-progression/status';
  static const String advanceRound = '/advance-round';
  static const String gameChecks = '/game-checks';

  // Decisions
  static const String decisions = '/decisions';
  static const String decisionConfirm = '/decisions/confirm';
  static const String decisionValidate = '/decisions/repair';
  static const String decisionFinancing = '/decision/financing';
  static const String decisionInvesting = '/decision/investing';
  static const String decisionOperating = '/decision/operating';

  // Decisions unlock
  static const String decisionsUnlock = '/decisions/unlock';

  // Scenarios
  static const String scenarios = '/scenarios';

  // Financial Data & Results
  static const String resultsRound = '/sheets/results/round';
  static const String sheetsKpis = '/sheets/kpis';
  static const String sheetsLeaderboard = '/sheets/leaderboard';
  static const String leaderboardDay = '/leaderboard/live';
  static const String sheetsBaseline = '/sheets/baseline/direct';
  static const String balanceValidation = '/sheets/balance-validation';
  static const String dashboardData = '/dashboard-data';

  // Facilitator
  static const String facilitatorLobbyStatus = '/facilitator/lobby-status';
  static const String facilitatorRegisterSignin = '/facilitator/register-signin';
  static const String facilitatorResetEpoch = '/facilitator/reset-epoch';
  static const String facilitatorAuth = '/facilitator/authenticate';
  static const String facilitatorAdminAuth = '/facilitator/admin-authenticate';
  static const String facilitatorStatus = '/facilitator/status';
  static const String facilitatorTeamsStatus = '/facilitator/teams-status';
  static const String facilitatorAllDecisions = '/facilitator/all-decisions';
  static const String facilitatorStartGame = '/facilitator/start-game';
  static const String facilitatorPauseGame = '/facilitator/pause-game';
  static const String facilitatorContinueGame = '/facilitator/continue-game';
  static const String facilitatorResetGame = '/facilitator/reset-game';
  static const String facilitatorForceRound = '/facilitator/force-round';
  static const String facilitatorForceModule = '/facilitator/force-module';
  static const String facilitatorLockAdvance = '/facilitator/lock-and-advance-module';
  static const String facilitatorStartTimer = '/facilitator/start-timer';
  static const String facilitatorEndTimer = '/facilitator/end-timer';
  static const String facilitatorUpdateTimer = '/facilitator/update-timer';
  static const String facilitatorMoveMember = '/facilitator/move-member';
  static const String facilitatorRemoveSignin = '/facilitator/remove-signin';
  static const String facilitatorClearSignins = '/facilitator/clear-signins';
  static const String facilitatorQrShow = '/facilitator/qr-show';
  static const String facilitatorQrHide = '/facilitator/qr-hide';
  static const String facilitatorToggleGovEd = '/facilitator/toggle-gov-education';
  static const String facilitatorToggleGovModule = '/facilitator/toggle-gov-education-module';
  static const String facilitatorGameMode = '/facilitator/game-mode';
  static const String facilitatorSetTeamLeader = '/facilitator/set-team-leader';
  static const String facilitatorRemoveTeamLeader = '/facilitator/remove-team-leader';
  // GET /facilitator/team-leader/{teamId} -> { success, teamId, leader }
  static const String facilitatorTeamLeader = '/facilitator/team-leader';
  // GET /facilitator/team-signins/{teamId} -> { data: [{playerName, signedInAt}] }
  static const String facilitatorTeamSignins = '/facilitator/team-signins';
  // POST /team/select-leader { teamId, playerName } — team self-picks its leader.
  static const String teamSelectLeader = '/team/select-leader';

  // Shocks
  static const String shocksPredefined = '/shocks/predefined';
  static const String shocksTrigger = '/shocks/trigger';
  static const String shocksActive = '/shocks/active';
  static const String shocksAcknowledge = '/shocks/acknowledge';
  static const String shocksHistory = '/shocks/history';
  static const String shocksUnacknowledged = '/shocks/unacknowledged';
  static const String shocksClear = '/shocks/clear';

  // Education
  static const String education = '/education';
  static const String educationModulesStatus = '/education-modules/status';
  static const String breakEvenScenarios = '/education/break-even/scenarios';
  static const String capitalBudgetingStatus = '/capital-budgeting/status';
  static const String aiTooltip = '/education/tooltip';
  // Public "Request a Demo" lead capture (absolute — different host/ops API).
  static const String demoRequest = 'https://ops.viftraining.com/api/public/demo-request';
  // Structured AI ratio tooltip (definition/formula/benchmarks/impact/risk...).
  static const String ratiosTooltip = '/ratios/tooltip';
  static const String scenarioTooltip = '/scenarios/tooltip';

  // Government Education
  static const String govEducationStatus = '/gov-education/status';
  static const String govEducationTeams = '/gov-education/teams';
  static const String govEducationProgress = '/gov-education/progress';
  static const String govEducationQuiz = '/gov-education/quiz';
  static const String govEducationLeaderboard = '/gov-education/leaderboard';

  // Cache
  static const String cacheClear = '/cache/clear';

  // Excel
  static const String excelConnectionStatus = '/excel/connection-status';
  static const String excelAdvanceStage = '/excel/advance-stage';
  static const String excelScenarioMetrics = '/excel/scenarios/keymetrics';
  static const String excelScenarioAmount = '/excel/scenarios/amount';

  // Self-Paced Auth (backend mounts at /api/self-paced)
  static const String selfPacedRegister = '/self-paced/register';
  static const String selfPacedLogin = '/self-paced/login';
  static const String selfPacedLogout = '/self-paced/logout';
  static const String selfPacedProfile = '/self-paced/profile';
  static const String selfPacedPasswordReset = '/self-paced/password-reset';
  static const String selfPacedForgotPassword = '/self-paced/forgot-password';
  static const String selfPacedResetPassword = '/self-paced/reset-password';

  // Assessment (pre/post knowledge tests)
  static const String assessmentQuestions = '/assessments/questions';
  static const String assessmentStatus = '/assessments/status';
  static const String assessmentSubmit = '/assessments/submit';

  // Research / DBA data collection
  static const String researchConfig = '/research/config';
  static const String researchConsent = '/research/consent';
  static const String researchDescriptors = '/research/descriptors';
  static const String researchResponse = '/research/response';

  // Facilitator model editor (admin)
  static const String modelAssumptions = '/facilitator/model/assumptions';
  static const String modelScenarios = '/facilitator/model/scenarios';
  static const String modelBaseline = '/facilitator/model/baseline';
  static const String modelBranding = '/facilitator/model/branding';

  // Education unlock controls
  static const String facilitatorToggleEducation = '/facilitator/toggle-education';
  static const String facilitatorToggleEducationModule = '/facilitator/toggle-education-module';
  static const String facilitatorToggleAllEducationModules = '/facilitator/toggle-all-education-modules';
  static const String facilitatorToggleEducationRetry = '/facilitator/toggle-education-retry';

  // Realism toggles
  static const String realismStatus = '/realism/status';
  static const String facilitatorRealismToggle = '/facilitator/realism-toggle';

  // Lock & advance module
  static const String facilitatorLockAdvanceModule = '/facilitator/lock-and-advance-module';

  // Single-shock dismiss
  static const String shocksDismiss = '/shocks/dismiss';

  // Cohorts
  static const String facilitatorCohorts = '/facilitator/cohorts';

  // Vouchers / access codes
  static const String vouchers = '/vouchers';
  static const String vouchersGating = '/vouchers/gating';
  static const String vouchersRedemptions = '/vouchers/redemptions';

  // Assessments admin
  static const String assessmentsAdminList = '/assessments/admin/list';
  static const String assessmentsMandate = '/assessments/mandate';

  // QR placeholders + status
  static const String facilitatorQrPlaceholders = '/facilitator/qr-placeholders';
  static const String facilitatorQrStatus = '/facilitator/qr-status';

  // Self-Paced Progress
  static const String selfPacedProgress = '/self-paced/progress';
  static const String selfPacedProgressDecisions = '/self-paced/progress/decisions';
  static const String selfPacedCompleteModule = '/self-paced/progress/complete-module';
  static const String selfPacedMe = '/self-paced/me';
  static const String selfPacedProgressScenarios = '/self-paced/progress/scenarios';
  static const String selfPacedProgressDecision = '/self-paced/progress/decision';
  static const String selfPacedProgressReset = '/self-paced/progress/reset';
  static const String selfPacedProgressEducation = '/self-paced/progress/education';
  static const String selfPacedProgressEducationComplete = '/self-paced/progress/education/complete';

  // Gamification
  static const String gamificationStart = '/sheets/gamification/start';

  // Leaderboard
  static const String leaderboardLive = '/leaderboard/live';

  // Site Access
  // Backend exposes status at /site-access/status (returns {"enabled": bool}).
  static const String siteAccessCheck = '/site-access/status';
  static const String siteAccessVerify = '/site-access/verify';
  static const String facilitatorSiteAccess = '/facilitator/site-access';
  static const String facilitatorCorporateMode = '/facilitator/corporate-mode';
  static const String facilitatorGameControl = '/facilitator/game-control';
  static const String facilitatorTeamSignin = '/facilitator/team-signin';

  // Timer
  static const String timerStatus = '/timer/status';

  // Reports
  static const String reportExport = '/report/export';

  // Case Study
  static const String caseStudyActive = '/case-study/active';

  // Team Fresh Start
  static const String facilitatorTeamFreshStart = '/facilitator/team-fresh-start';

  // Self-Paced Admin
  static const String selfPacedMembers = '/self-paced/admin/members';

  // Education Admin
  static const String govEducationAdminReset = '/gov-education/admin/reset-all';

  // Round state direct
  static const String roundStateDirect = '/round-state';
}
