class ApiEndpoints {
  ApiEndpoints._();

  // Health
  static const String health = '/health';
  // GET -> { database:{available}, engine:{available, mode}, mode:'online'|'offline', message }
  static const String healthConnection = '/health/connection';

  // Teams
  static const String teams = '/teams';
  static const String teamById = '/teams/{id}';
  static const String sessionInit = '/session/init';

  // Game State
  static const String roundState = '/sheets/round/state';
  static const String teamProgression = '/team-progression/status';
  // POST /team-progression/advance/{teamId} (no body): moves ONE team to its
  // next module once its decisions are confirmed and the facilitator has
  // unlocked "Move to Next Decisions". 200 { success, action, nextModule:
  // 'investing'|'operating'|'dashboard', previousModule }; 403 { error:
  // 'Advancement locked', message }; 400 { error: 'Decisions not confirmed' }.
  // Broadcasts team:module_advanced to the team's other members.
  static const String teamProgressionAdvance = '/team-progression/advance';

  // Decisions
  static const String decisions = '/decisions';
  static const String decisionConfirm = '/decisions/confirm';
  static const String decisionFinancing = '/decision/financing';
  static const String decisionInvesting = '/decision/investing';
  static const String decisionOperating = '/decision/operating';

  // Decisions unlock (TEAM-MEMBER route, requireTeamMember): a team re-opens
  // its own confirmed decisions. A facilitator token gets 401 here; the
  // facilitator's pacing control is facilitatorToggleNextDecisions.
  static const String decisionsUnlock = '/decisions/unlock';

  // Scenarios
  static const String scenarios = '/scenarios';

  // Financial Data & Results
  // GET /game/results/round?teamId&round&statement=income|balance|cashflow|ratios
  // -> { round, team, financials:{ incomeStatement, balanceSheet, cashFlow, ratios }, kpis }.
  // Round 0 is the baseline (opening position). The server still rewrites the
  // retired /sheets/results/round path to this handler, but that alias is
  // deprecated, so the app calls the canonical path the website uses.
  static const String resultsRound = '/game/results/round';
  static const String sheetsLeaderboard = '/sheets/leaderboard';
  static const String leaderboardDay = '/leaderboard/live';
  static const String balanceValidation = '/sheets/balance-validation';
  static const String dashboardData = '/dashboard-data';

  // Facilitator
  static const String facilitatorLobbyStatus = '/facilitator/lobby-status';
  static const String facilitatorRegisterSignin = '/facilitator/register-signin';
  // Public: verify a corporate cohort access code (rate-limited, never returns
  // the code). POST {code} -> { success, valid }. Gates corporate team sign-in
  // while a training is live.
  static const String facilitatorVerifyCorporateCode = '/facilitator/verify-corporate-code';
  static const String facilitatorResetEpoch = '/facilitator/reset-epoch';
  static const String facilitatorAuth = '/facilitator/authenticate';
  static const String facilitatorAdminAuth = '/facilitator/admin-authenticate';
  static const String facilitatorStatus = '/facilitator/status';
  // GET (facilitator) -> { success, currentRound, gameState:{lockFinancing,
  // lockInvesting, lockOperating, nextDecisionsUnlocked}, teams:[{teamId,
  // teamName, currentRound, currentModule, moduleStatus:{financing|investing|
  // operating:{status, scenarios, isLocked}}, scenarioDetails, totalDecisions,
  // connectedMembers:[{playerName, joinedAt}], onlineCount}] }
  static const String facilitatorTeamOverview = '/facilitator/team-overview';
  // GET -> { financing: { [teamId]: { [round]: [ {scenarioId, title, amount,
  // confirmed} ] } }, investing: {...}, operating: {...} } with NO success/data
  // wrapper (server/routes.ts); a failure is 500 {error}.
  static const String facilitatorAllDecisions = '/facilitator/all-decisions';
  static const String facilitatorStartGame = '/facilitator/start-game';
  static const String facilitatorPauseGame = '/facilitator/pause-game';
  static const String facilitatorContinueGame = '/facilitator/continue-game';
  static const String facilitatorResetGame = '/facilitator/reset-game';
  static const String facilitatorForceRound = '/facilitator/force-round';
  static const String facilitatorForceModule = '/facilitator/force-module';
  static const String facilitatorLockAdvance = '/facilitator/lock-and-advance-module';
  // POST {unlock:boolean} (facilitator) -> { success, message,
  // nextDecisionsUnlocked, nextDecisionsUnlockedFor }. The website's "Unlock /
  // Lock" next-decisions control: the server checks nextDecisionsUnlocked in
  // POST /team-progression/advance/{teamId} (403 'Advancement locked'
  // otherwise). The unlock is scoped to the module the room is on. The current
  // value is read from GET /facilitator/status gameState.nextDecisionsUnlocked.
  static const String facilitatorToggleNextDecisions = '/facilitator/toggle-next-decisions';
  static const String facilitatorStartTimer = '/facilitator/start-timer';
  static const String facilitatorEndTimer = '/facilitator/end-timer';
  static const String facilitatorUpdateTimer = '/facilitator/update-timer';
  static const String facilitatorMoveMember = '/facilitator/move-member';
  static const String facilitatorRemoveSignin = '/facilitator/remove-signin';
  static const String facilitatorClearSignins = '/facilitator/clear-signins';
  static const String facilitatorQrShow = '/facilitator/qr-show';
  static const String facilitatorQrHide = '/facilitator/qr-hide';
  static const String facilitatorGameMode = '/facilitator/game-mode';
  // POST {enabled} -> { success, corporateModeEnabled, corporateAccessCode }.
  // A fresh cohort access code is minted on every OFF->ON toggle.
  static const String facilitatorToggleCorporateMode = '/facilitator/toggle-corporate-mode';
  // Corporate game gate: GET -> { success, open }; POST {open} (facilitator).
  static const String facilitatorSimulationAccess = '/facilitator/simulation-access';
  // Live countdown on every participant screen: POST (facilitator) -> { success }.
  static const String facilitatorTimerOverlayStart = '/facilitator/timer-overlay/start';
  static const String facilitatorTimerOverlayStop = '/facilitator/timer-overlay/stop';
  // POST {scenarioIds:[...], unlock} -> { success, capitalBudgetingResultsUnlocked }.
  static const String facilitatorUnlockAllScenarioResults = '/facilitator/unlock-all-scenario-results';
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
  // GET ?teamId= -> { success, shocks:[{id, shockId, definition:{name, nameAr,
  // description, descriptionAr, category, severity, ...}, triggeredAt, target,
  // round, module, isActive, acknowledgedBy}], count }.
  static const String shocksActive = '/shocks/active';
  static const String shocksAcknowledge = '/shocks/acknowledge';
  static const String shocksHistory = '/shocks/history';
  // GET /shocks/unacknowledged/{teamId} -> { success, teamId, shocks, count }
  // (same rows as shocksActive). The bare path answers 404.
  static const String shocksUnacknowledged = '/shocks/unacknowledged';
  // POST {password, revertModel?, round?}: the password travels in the BODY
  // (this router does not read the x-facilitator-password header).
  static const String shocksClearAll = '/shocks/clear-all';

  // Certificate — awarded once every learning module is complete.
  // /me is authenticated AND entitlement-gated (a lapsed learner gets 402), because issuing a
  // certificate is a paid outcome. The public view/verify pages are deliberately NOT gated: an
  // already-issued certificate must stay verifiable by an employer forever.
  static const String certificateMe = '/certificate/me';

  // Education
  static const String educationModulesStatus = '/education-modules/status';
  static const String breakEvenScenarios = '/education/break-even/scenarios';
  static const String capitalBudgetingStatus = '/capital-budgeting/status';
  // Public "Request a Demo" lead capture (absolute — different host/ops API).
  static const String demoRequest = 'https://ops.viftraining.com/api/public/demo-request';
  // Structured AI ratio tooltip (definition/formula/benchmarks/impact/risk...).
  static const String ratiosTooltip = '/ratios/tooltip';
  // GET /scenarios/tooltip/{scenarioId}?title= -> bilingual { title:{en,ar},
  // definition:{en,ar}, whyItMatters:{en,ar}, pros, cons, ... } (no envelope).
  static const String scenarioTooltip = '/scenarios/tooltip';

  // Education modules (served under /api/education).
  static const String educationStatus = '/education/status';
  // GET (unauthenticated; resolved from the host) -> { success, moduleNums:
  // number[] | null (ordered), optionalModuleNums: number[], course: {slug,
  // title:{en,ar}} | null, catalog, addons }. moduleNums null means no plan is
  // set, and is also what the server answers when its lookup fails.
  static const String educationModulePlan = '/education/module-plan';

  // Earnings Call (post-Round-2 analyst event). Stage machine off -> prep -> live,
  // driven by the facilitator and polled by teams.
  static const String earningsCallStatus = '/earnings-call/status';
  static const String earningsCallStage = '/earnings-call/stage'; // facilitator
  // GET /earnings-call/team/{teamId} -> the same payload the AI analyst is prompted
  // with: R1-vs-R2 statements, ratios, decisions, shocks, talking points.
  static const String earningsCallTeam = '/earnings-call/team';
  // GET /earnings-call/questions/{teamId} -> released question sets only.
  static const String earningsCallQuestions = '/earnings-call/questions';
  // POST /earnings-call/answer { teamId, questionIndex, answerText }
  static const String earningsCallAnswer = '/earnings-call/answer';
  // POST /earnings-call/feedback { presenterTeamId, raterTeamId, clarity, insight, confidence }
  static const String earningsCallFeedback = '/earnings-call/feedback';
  static const String earningsCallFeedbackSummary = '/earnings-call/feedback/summary';
  static const String earningsCallFacilitatorScore = '/earnings-call/facilitator-score';
  static const String earningsCallFacilitatorScores = '/earnings-call/facilitator-scores';

  // Cross-device education progress (website parity: hydrateProgressFromServer /
  // syncProgressToDatabase). {teamName} is the self-paced learner's email or a
  // corporate team name ("Team 1"); self-paced calls need the bearer token.
  static const String educationProgressSaved = '/education/progress/{teamName}/saved';
  static const String educationProgressSync = '/education/progress/{teamName}/sync';

  // Narration (AI audio for Learn slides)
  // POST /narration/prepare {moduleId,sectionId,language,text} -> {audioUrl,...}
  static const String narrationPrepare = '/narration/prepare';
  static const String narrationAudio = '/narration/audio';

  // Cache
  static const String cacheClear = '/cache/clear';

  // Self-Paced Auth (backend mounts at /api/self-paced)
  static const String selfPacedRegister = '/self-paced/register';
  // Step 1 of verified sign-up: emails a 6-digit code. POST {email} ->
  // { success, message }. 15-min expiry, 60s resend cooldown, 5-attempt cap.
  static const String selfPacedRequestVerification = '/self-paced/request-verification';
  static const String selfPacedLogin = '/self-paced/login';
  // "Try Demo": POST with no body -> { success, token, user:{id, email,
  // displayName, firstName, lastName, currentRound, currentModule},
  // entitlement }. The server provisions demo-player@vifm.com on first use
  // with an unguessable password, so no password login can reach the demo.
  static const String selfPacedDemoLogin = '/self-paced/demo-login';
  static const String selfPacedLogout = '/self-paced/logout';
  static const String selfPacedForgotPassword = '/self-paced/forgot-password';
  static const String selfPacedResetPassword = '/self-paced/reset-password';

  // Assessment (pre/post knowledge tests)
  static const String assessmentQuestions = '/assessments/questions';
  static const String assessmentStatus = '/assessments/status';
  static const String assessmentSubmit = '/assessments/submit';

  // Research (DBA study) mode. FinPlay does not collect the study's data: the
  // website removed the consent and instrument endpoints, and GET /config
  // carries collectsHere:false. Only the flag and the facilitator toggle remain.
  static const String researchConfig = '/research/config';
  static const String researchMode = '/research/mode'; // facilitator toggle

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
  // Pre-validate an access code at sign-up: POST {code} -> { valid, reason }.
  static const String vouchersValidate = '/vouchers/validate';

  // Assessments admin
  static const String assessmentsAdminList = '/assessments/admin/list';
  static const String assessmentsMandate = '/assessments/mandate';

  // QR placeholders + status
  static const String facilitatorQrPlaceholders = '/facilitator/qr-placeholders';
  static const String facilitatorQrStatus = '/facilitator/qr-status';

  // Self-Paced Progress
  static const String selfPacedProgressDecisions = '/self-paced/progress/decisions';
  static const String selfPacedCompleteModule = '/self-paced/progress/complete-module';
  static const String selfPacedMe = '/self-paced/me';
  static const String selfPacedProgressScenarios = '/self-paced/progress/scenarios';
  static const String selfPacedProgressDecision = '/self-paced/progress/decision';
  static const String selfPacedProgressReset = '/self-paced/progress/reset';

  // Billing (self-paced subscription — MamoPay). Auth via the self-paced bearer token.
  static const String billingPlans = '/billing/plans';
  static const String billingCheckout = '/billing/checkout';
  static const String billingVerify = '/billing/verify';
  static const String billingStatus = '/billing/status';
  static const String billingStudentVerify = '/billing/student/verify';
  // Per-learner dashboard (same shape as /dashboard-data, scoped to the
  // learner's own decisions + shock-isolated).
  static const String selfPacedProgressDashboardData = '/self-paced/progress/dashboard-data';

  // Gamification
  static const String gamificationStart = '/sheets/gamification/start';

  // Leaderboard
  static const String leaderboardLive = '/leaderboard/live';

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

  // Education Admin. POST {password}: this router reads the password from the
  // body only, not the x-facilitator-password header.
  static const String educationAdminReset = '/education/admin/reset-all';
}
