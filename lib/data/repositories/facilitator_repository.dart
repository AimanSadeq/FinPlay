import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/utils/simulation_access.dart';
import '../models/shock.dart';
<<<<<<< Updated upstream
import 'game_repository.dart';
=======
import '../../features/facilitator/api_once.dart';

/// One team that still owes a decision before the next round may open
/// (server `roundCompletenessGaps`: `{teamId, teamName, missing: [module...]}`).
class RoundGap {
  final String teamId;
  final String teamName;
  final List<String> missing;
  const RoundGap({required this.teamId, required this.teamName, required this.missing});

  factory RoundGap.fromJson(Map<String, dynamic> json) => RoundGap(
        teamId: (json['teamId'] ?? '').toString(),
        teamName: (json['teamName'] ?? json['teamId'] ?? '').toString(),
        missing: (json['missing'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
      );
}

/// POST /facilitator/force-round refused a forward move (400 `ROUND_INCOMPLETE`): some
/// active team has not confirmed one real decision per module in the round before.
/// Resend with `force: true` to override knowingly.
class RoundIncompleteException implements Exception {
  final int round;
  final String message;
  final List<RoundGap> gaps;
  const RoundIncompleteException({required this.round, required this.message, required this.gaps});

  @override
  String toString() => message;
}

/// A facilitator action the server refused; [message] is the server's own text.
class FacilitatorActionException implements Exception {
  final String message;
  const FacilitatorActionException(this.message);

  @override
  String toString() => message;
}

/// The capital-budgeting scenarios whose results the facilitator can reveal (website
/// client/src/data/capitalBudgetingEducationalContent.ts `capitalBudgetingScenarios`).
const List<String> _capitalBudgetingScenarioIds = [
  'restaurant-kitchen-riyadh',
  'coffee-expansion-dubai',
  'delivery-fleet-jeddah',
  'gym-equipment-abudhabi',
  'retail-expansion-muscat',
  'hotel-renovation-doha',
];

// Endpoints used only by this repository and not (yet) in ApiEndpoints. Paths verified
// against the website server (server/routes/*.ts).
const String _vouchersMaster = '/vouchers/master'; // GET {code}; POST {code?}|{clear:true}
const String _insights = '/insights'; // POST {password, round}
const String _shocksForecasts = '/shocks/forecasts'; // GET (public)
const String _shocksForecast = '/shocks/forecast'; // POST publish; /:id/resolve
const String _hedgesForecast = '/hedges/forecast'; // GET /:forecastId -> {count, teamIds}
const String _gameRoundState = '/game/round/state'; // GET -> {roundNum, module}
const String _teamLeaders = '/facilitator/team-leaders'; // GET -> {leaders: {teamId: name}}
const String _clearTeamLeaders = '/facilitator/clear-team-leaders'; // POST
const String _toggleGameMode = '/facilitator/toggle-game-mode'; // POST {mode}
const String _timerOverlay = '/facilitator/timer-overlay'; // GET
const String _educationStatus = '/education/status'; // GET
const String _assessmentStatus = '/assessments/status'; // GET ?kind=pre|post
const String _activityLog = '/facilitator/activity-log'; // POST {password, category, search, limit}
const String _setPlan = '/self-paced/admin/members/set-plan'; // POST {password, email, plan}
const String _financialStatements = '/facilitator/financial-statements'; // GET; POST /delete
const String _caseStudyTemplates = '/case-study/templates'; // GET -> {templates, activeCaseStudyId}
const String _setCaseStudy = '/facilitator/set-case-study'; // POST {caseStudyId|null}
const String _toggleScenarioResults = '/facilitator/toggle-scenario-results'; // POST {scenarioId, unlock}
const String _testEmail = '/facilitator/test-email'; // POST {to}
>>>>>>> Stashed changes

class FacilitatorRepository {
  final ApiClient _api;

  FacilitatorRepository(this._api);

<<<<<<< Updated upstream
  /// For the few routes whose router reads the password from the request BODY
  /// rather than the x-facilitator-password header: reset-game,
  /// /education/admin/reset-all and /shocks/clear-all. Falls back to the
  /// password the ApiClient already carries, so a facilitator who signed in
  /// through the home Admin dialog (authProvider.loginFacilitator) is covered
  /// without a second sign-in here.
  String? _bodyPassword;
  String? get _password => _bodyPassword ?? _api.facilitatorPassword;

  /// Capital-budgeting scenario ids on the website
  /// (client/src/data/capitalBudgetingEducationalContent.ts,
  /// capitalBudgetingScenarios). The "show scenario results" switch unlocks or
  /// locks all of them at once, exactly as the website facilitator panel does.
  static const List<String> capitalBudgetingScenarioIds = [
    'restaurant-kitchen-riyadh',
    'coffee-expansion-dubai',
    'delivery-fleet-jeddah',
    'gym-equipment-abudhabi',
    'retail-expansion-muscat',
    'hotel-renovation-doha',
    'equipment-npv',
    'payback-basic',
    'future-value',
    'present-value',
    'pi-calculation',
    'irr-decision',
  ];
=======
  /// The facilitator password, kept for the routes that verify it from the request body
  /// rather than the `x-facilitator-password` header (/shocks/*, /cache/clear).
  String? _password;

  String? get _facilitatorPassword =>
      _password ?? _api.dio.options.headers['x-facilitator-password']?.toString();
>>>>>>> Stashed changes

  Future<bool> login(String password) async {
    final response = await _api.post(ApiEndpoints.facilitatorAuth, data: {
      'password': password,
    });
    final ok = response['success'] == true;
    // Attach the password to every later facilitator-gated request.
    if (ok) {
<<<<<<< Updated upstream
      _api.setFacilitatorPassword(password);
      _bodyPassword = password;
=======
      _password = password;
      _api.setFacilitatorPassword(password);
>>>>>>> Stashed changes
    }
    return ok;
  }

  /// Throws [FacilitatorActionException] with the server's message when [res] is a refusal.
  /// Every route sent through here answers `success: true` on success; a 4xx/5xx body
  /// (`{error}` or `{message}`, e.g. a 500 `{message:'Internal server error'}`) is a failure.
  Map<String, dynamic> _ensureOk(Map<String, dynamic> res, String fallback) {
    if (res['success'] == false ||
        (res['success'] != true && (res['error'] != null || res['message'] != null))) {
      throw FacilitatorActionException(
          (res['error'] ?? res['message'] ?? fallback).toString());
    }
    return res;
  }

<<<<<<< Updated upstream
  /// GET /facilitator/team-overview: every team's round, module, per-module
  /// decision status and signed-in members in one call. Returns the whole
  /// response ({currentRound, gameState, teams:[...]}); see ApiEndpoints.
  Future<Map<String, dynamic>> getTeamOverview() async {
    final response = await _api.get(ApiEndpoints.facilitatorTeamOverview);
    if (response['success'] == true && response['teams'] is List) {
      return response;
    }
    throw Exception(response['error'] ?? 'Failed to get team overview');
  }

  /// The teams[] array of [getTeamOverview].
  Future<List<Map<String, dynamic>>> getTeamOverviewTeams() async {
    final res = await getTeamOverview();
    return (res['teams'] as List)
        .map((t) => Map<String, dynamic>.from(t as Map))
        .toList();
=======
  /// GET /facilitator/status -> `{success, gameState: {..., corporateModeEnabled,
  /// corporateAccessCode, preAssessmentMandated, postAssessmentMandated, ...}}`.
  /// Returns the `gameState` object (the facilitator-only view, including the code).
  Future<Map<String, dynamic>> getState() async {
    final response = await _api.get(ApiEndpoints.facilitatorStatus);
    final gs = response['gameState'] ?? response['data'];
    if (response['success'] == true && gs is Map) {
      return Map<String, dynamic>.from(gs);
    }
    throw FacilitatorActionException(
        (response['error'] ?? response['message'] ?? 'Failed to get facilitator state').toString());
  }

  /// GET /facilitator/team-overview (what the website's Team Overview reads):
  /// `{success, currentRound, teams: [{teamId, teamName, currentRound, currentModule,
  /// moduleStatus, scenarioDetails, connectedMembers: [{playerName, joinedAt}], ...}]}`.
  Future<List<Map<String, dynamic>>> getTeamOverview() async {
    final res = await _api.get(ApiEndpoints.facilitatorTeamOverview);
    if (res['teams'] is! List) {
      throw FacilitatorActionException(
          (res['error'] ?? res['message'] ?? 'Failed to get team overview').toString());
    }
    return (res['teams'] as List)
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  /// Per-team performance figures keyed by team id ("Team 1"...), from the live
  /// leaderboard: `{score, revenue, netIncome, totalAssets, ...}`.
  Future<Map<String, Map<String, dynamic>>> getTeamPerformance() async {
    final rows = await getLeaderboard();
    return {
      for (final r in rows.whereType<Map>())
        (r['teamId'] ?? '').toString(): Map<String, dynamic>.from(r),
    };
>>>>>>> Stashed changes
  }

  Future<void> lockModule(String module, bool locked) async {
    if (locked) {
      await _api.postOnce(ApiEndpoints.facilitatorLockAdvance, data: {
        'module': module,
      });
    } else {
      await _api.post(ApiEndpoints.facilitatorForceModule, data: {
        'module': module,
      });
    }
  }

  Future<void> setTimer(int seconds, {String? action}) async {
    if (action == 'start') {
      await _api.post(ApiEndpoints.facilitatorStartTimer, data: {
        'seconds': seconds,
      });
    } else if (action == 'pause' || action == 'reset') {
      await _api.post(ApiEndpoints.facilitatorEndTimer);
    }
  }

<<<<<<< Updated upstream
  // ── Game controls ──
  // Each returns true only when the server confirmed the change; a dead route
  // (404 {success:false}) or an auth failure comes back false.
  Future<bool> startGame() async {
    final res = await _api.post(ApiEndpoints.facilitatorStartGame);
    return res['success'] == true;
=======
  Future<void> startGame() async {
    await _api.postOnce(ApiEndpoints.facilitatorStartGame);
>>>>>>> Stashed changes
  }

  Future<bool> pauseGame() async {
    final res = await _api.post(ApiEndpoints.facilitatorPauseGame);
    return res['success'] == true;
  }

  Future<bool> continueGame() async {
    final res = await _api.post(ApiEndpoints.facilitatorContinueGame);
    return res['success'] == true;
  }

  Future<List<Shock>> fetchShocks() async {
    // API returns: {success, shocks: [...], count}
    final response = await _api.get(ApiEndpoints.shocksPredefined);
    final list = response['shocks'] as List<dynamic>? ?? response['data'] as List<dynamic>? ?? [];
    return list.map((e) => Shock.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// POST /shocks/trigger, the body the website's ShockTriggerPanel sends. The server
  /// verifies the password from the body, refuses a round outside 1-3 (400) and the same
  /// shock already active for that round (409); both carry a readable `error`, which is
  /// thrown as a [FacilitatorActionException].
  Future<Map<String, dynamic>> triggerShock(
    String shockId, {
    required int round,
    String target = 'all',
    String? module,
  }) async {
    final res = await _api.postOnce(ApiEndpoints.shocksTrigger, data: {
      'shockId': shockId,
      'triggeredBy': 'Facilitator',
      'target': target,
      'round': round,
      'module': ?module,
      'password': _facilitatorPassword,
    });
    return _ensureOk(res, 'Failed to trigger shock');
  }

  /// POST /shocks/trigger-custom — a facilitator-authored shock, matching the website's
  /// custom shock builder (Arabic fields fall back to the English text, as on the web).
  Future<Map<String, dynamic>> triggerCustomShock({
    required String name,
    required String description,
    required String category,
    required String severity,
    required int round,
    String target = 'all',
    String? module,
    String? suggestedResponse,
  }) async {
    final res = await _api.postOnce(ApiEndpoints.shocksTriggerCustom, data: {
      'name': name,
      'nameAr': name,
      'description': description,
      'descriptionAr': description,
      'category': category,
      'severity': severity,
      'icon': '⚠️',
      'suggestedResponse': ?suggestedResponse,
      'suggestedResponseAr': ?suggestedResponse,
      'triggeredBy': 'Facilitator',
      'target': target,
      'round': round,
      'module': ?module,
      'password': _facilitatorPassword,
    });
    return _ensureOk(res, 'Failed to trigger custom shock');
  }

  /// Currently active shocks (facilitator view).
  Future<List<Map<String, dynamic>>> fetchActiveShocks() async {
    final res = await _api.get(ApiEndpoints.shocksActive);
    final list = res['shocks'] as List<dynamic>? ?? res['data'] as List<dynamic>? ?? [];
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  /// Shock history (what has been fired this session).
  Future<List<Map<String, dynamic>>> fetchShockHistory() async {
    final res = await _api.get(ApiEndpoints.shocksHistory);
    final list = res['history'] as List<dynamic>? ?? res['data'] as List<dynamic>? ?? [];
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  /// Clear every active shock and revert its model impact
  /// (POST /shocks/clear-all; the password goes in the body).
  Future<bool> clearAllShocks() async {
    try {
<<<<<<< Updated upstream
      final res = await _api.post(ApiEndpoints.shocksClearAll, data: {
        'password': _password,
        'revertModel': true,
      });
=======
      final res = await _api.postOnce(ApiEndpoints.shocksClearAll, data: {'password': _facilitatorPassword});
>>>>>>> Stashed changes
      return res['success'] == true;
    } catch (_) {
      return false;
    }
  }

  /// Move every team to the start of [currentRound] + 1 (same contract as [forceRound]).
  Future<void> advanceRound(int currentRound, {bool force = false}) async {
    await forceRound(currentRound + 1, force: force);
  }

  // ── Corporate simulation gate ──
  /// GET /facilitator/simulation-access -> { success, open }. Public: the
  /// website's home page and education hub read it on every learner device
  /// (no facilitator password), and so does this app's simulation screen.
  /// Returns true/false for the facilitator's switch, or null when the route
  /// did not answer with it (dead route, auth error), so the caller can tell
  /// "closed" from "unknown". Network failures propagate.
  Future<bool?> fetchSimulationAccess() async {
    final res = await _api.get(ApiEndpoints.facilitatorSimulationAccess);
    return simulationAccessFromJson(res);
  }

  // ── Team leader ──
  /// Current leader name for a team (null if none set).
  Future<String?> fetchTeamLeader(String teamId) async {
    try {
      final res = await _api.get('${ApiEndpoints.facilitatorTeamLeader}/${Uri.encodeComponent(teamId)}');
      final leader = res['leader'];
      if (leader == null) return null;
      if (leader is String) return leader;
      if (leader is Map) return (leader['name'] ?? leader['playerName'])?.toString();
      return leader.toString();
    } catch (_) {
      return null;
    }
  }

  /// Signed-in members of a team (for the leader self-pick gate).
  /// Returns a list of {playerName, signedInAt?}.
  Future<List<Map<String, dynamic>>> fetchTeamSignins(String teamId) async {
    try {
      final res = await _api.get(
          '${ApiEndpoints.facilitatorTeamSignins}/${Uri.encodeComponent(teamId)}');
      final list = res['data'] as List<dynamic>? ??
          res['signins'] as List<dynamic>? ??
          res['members'] as List<dynamic>? ??
          [];
      return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  /// Team self-picks its leader (any signed-in member can designate one).
  /// Returns true on success. The team-member token rides on the global header.
  Future<bool> selectTeamLeader(String teamId, String playerName) async {
    try {
      final res = await _api.post(ApiEndpoints.teamSelectLeader, data: {
        'teamId': teamId,
        'playerName': playerName,
      });
      return res['success'] != false && res['error'] == null;
    } catch (_) {
      return false;
    }
  }

  Future<void> setTeamLeader(String teamId, String memberName) async {
    await _api.post(ApiEndpoints.facilitatorSetTeamLeader, data: {
      'teamId': teamId,
      'playerName': memberName,
      'memberName': memberName,
    });
  }

  Future<void> removeTeamLeader(String teamId) async {
    await _api.post(ApiEndpoints.facilitatorRemoveTeamLeader, data: {'teamId': teamId});
  }

<<<<<<< Updated upstream
  /// Full game reset (closes the lobby and the game gate, archives decisions).
  Future<bool> resetGame() async {
    final res = await _api.post(ApiEndpoints.facilitatorResetGame, data: {
      'password': _password,
=======
  Future<void> resetGame(String password) async {
    await _api.postOnce(ApiEndpoints.facilitatorResetGame, data: {
      'password': password,
>>>>>>> Stashed changes
    });
    return res['success'] == true;
  }

  Future<void> moveMember(String playerId, String fromTeam, String toTeam) async {
    await _api.post(ApiEndpoints.facilitatorMoveMember, data: {
      'playerId': playerId,
      'fromTeam': fromTeam,
      'toTeam': toTeam,
    });
  }

  Future<void> clearSignins() async {
    await _api.post(ApiEndpoints.facilitatorClearSignins);
  }

<<<<<<< Updated upstream
  /// POST /facilitator/toggle-corporate-mode {enabled}. On success the response
  /// carries corporateModeEnabled and the freshly minted corporateAccessCode
  /// (empty when disabling). Callers must check `success` before updating UI.
  Future<Map<String, dynamic>> toggleCorporateMode(bool enabled) async {
    return await _api.post(ApiEndpoints.facilitatorToggleCorporateMode, data: {
=======
  /// POST /facilitator/toggle-corporate-mode {enabled}. The server mints a fresh
  /// `corporateAccessCode` on enable and clears it on disable.
  Future<Map<String, dynamic>> toggleCorporateMode(bool enabled) async {
    final res = await _api.post(ApiEndpoints.facilitatorToggleCorporateMode, data: {
>>>>>>> Stashed changes
      'enabled': enabled,
    });
    return _ensureOk(res, 'Could not toggle corporate mode');
  }

<<<<<<< Updated upstream
  Future<Map<String, dynamic>> toggleLobby(bool open) async {
    return await _api.post(ApiEndpoints.facilitatorLobbyStatus, data: {
      'open': open,
    });
  }

=======
  /// Play / pause / continue / reset, on the server's per-action routes.
  Future<Map<String, dynamic>> gameControl(String action) async {
    final path = switch (action) {
      'play' => ApiEndpoints.facilitatorStartGame,
      'pause' => ApiEndpoints.facilitatorPauseGame,
      'continue' => ApiEndpoints.facilitatorContinueGame,
      'reset' => ApiEndpoints.facilitatorResetGame,
      _ => throw ArgumentError.value(action, 'action'),
    };
    final res = await _api.postOnce(path, data: {'password': ?_facilitatorPassword});
    return _ensureOk(res, 'Game control failed');
  }

  // ── Corporate simulation gate (website "FinPlay Game Open/Close") ──
  /// GET /facilitator/simulation-access -> `{success, open}` (public).
  Future<bool> fetchSimulationAccess() async {
    final res = await _api.get(ApiEndpoints.facilitatorSimulationAccess);
    return res['open'] == true;
  }

  /// POST /facilitator/simulation-access {open} -> `{success, open}`.
  Future<bool> setSimulationAccess(bool open) async {
    final res = await _api.post(ApiEndpoints.facilitatorSimulationAccess, data: {'open': open});
    _ensureOk(res, 'Could not update game access');
    return res['open'] == true;
  }

  // ── Per-activity timer presets (minutes, 1-120) ──
  /// GET /facilitator/timer-presets -> `{success, presets: {financing, investing, operating,
  /// shock, education, debrief}}`.
  Future<Map<String, int>> fetchTimerPresets() async {
    final res = await _api.get(ApiEndpoints.facilitatorTimerPresets);
    final p = res['presets'];
    if (p is! Map) return {};
    return {
      for (final e in p.entries)
        if (e.value is num) e.key.toString(): (e.value as num).round(),
    };
  }

  Future<Map<String, int>> saveTimerPresets(Map<String, int> presets) async {
    final res = await _api.post(ApiEndpoints.facilitatorTimerPresets, data: {'presets': presets});
    _ensureOk(res, 'Could not save timer presets');
    final p = res['presets'];
    if (p is! Map) return presets;
    return {
      for (final e in p.entries)
        if (e.value is num) e.key.toString(): (e.value as num).round(),
    };
  }

  /// GET /facilitator/lobby-status -> `{lobbyOpen}`. There is no route to set it: the
  /// server opens the lobby when a facilitator signs in and closes it on a game reset.
  Future<bool> fetchLobbyOpen() async {
    final res = await _api.get(ApiEndpoints.facilitatorLobbyStatus);
    return res['lobbyOpen'] == true;
  }

  /// Signed-in members per team, from GET /facilitator/team-overview, shaped as
  /// `{data: {'Team N': {players: [name...], round, module}}}`.
  Future<Map<String, dynamic>> getTeamSignins() async {
    final teams = await getTeamOverview();
    return {
      'data': {
        for (final t in teams)
          (t['teamId'] ?? '').toString(): {
            'players': [
              for (final m in (t['connectedMembers'] as List<dynamic>? ?? []))
                if (m is Map) (m['playerName'] ?? '').toString() else m.toString(),
            ],
            'round': t['currentRound'],
            'module': t['currentModule'],
          },
      },
    };
  }

  /// GET /leaderboard/live -> `{leaderboard: [{teamId, teamName, score, metrics: {netIncome,
  /// revenue, totalAssets, ...}}]}`. The metrics are lifted to the top level of each row.
>>>>>>> Stashed changes
  Future<List<dynamic>> getLeaderboard() async {
    final res = await _api.get(ApiEndpoints.leaderboardLive);
    final list = res['leaderboard'];
    if (list is! List) {
      throw FacilitatorActionException(
          (res['error'] ?? 'Failed to load leaderboard').toString());
    }
    return [
      for (final r in list.whereType<Map>())
        {
          ...Map<String, dynamic>.from(r),
          if (r['metrics'] is Map) ...Map<String, dynamic>.from(r['metrics'] as Map),
        },
    ];
  }

  /// POST /facilitator/qr-show {placeholder}: one of PRE_ASSESSMENT, POST_ASSESSMENT,
  /// COURSE_SURVEY, LINKEDIN, INFO_SHEET. A research cohort refuses the first three (409).
  Future<void> showQr(String placeholder) async {
    final res = await _api.post(ApiEndpoints.facilitatorQrShow, data: {'placeholder': placeholder});
    _ensureOk(res, 'Could not show the QR overlay');
  }

  Future<void> hideQr() async {
    await _api.post(ApiEndpoints.facilitatorQrHide);
  }

<<<<<<< Updated upstream
  static const List<String> decisionModules = ['financing', 'investing', 'operating'];

  /// GET /facilitator/all-decisions: every team's typed amounts by module,
  /// team and round, `{ financing: { 'Team 1': { '1': [ {scenarioId, title,
  /// amount, confirmed} ] } }, investing, operating }`. The server sends the
  /// matrix bare (no success/data wrapper) and answers a failure with 500
  /// {error} or, for a dead route, 404 {success:false}. Throws on either.
  Future<Map<String, dynamic>> getAllDecisions() async {
    final response = await _api.get(ApiEndpoints.facilitatorAllDecisions);
    if (apiFailed(response) || !decisionModules.any(response.containsKey)) {
      throw Exception(response['error'] ?? 'Failed to get decisions');
    }
    return {
      for (final module in decisionModules)
        module: Map<String, dynamic>.from(response[module] as Map? ?? const {}),
    };
  }

  /// Pivots [getAllDecisions] by team for the Round Details cards:
  /// `{ 'Team 1': { financing: { '1': [rows] }, investing: {...} } }`. Teams
  /// with no decisions are absent; a module with none is absent for that team.
  static Map<String, Map<String, Map<String, List<Map<String, dynamic>>>>> decisionsByTeam(
      Map<String, dynamic> byModule) {
    final out = <String, Map<String, Map<String, List<Map<String, dynamic>>>>>{};
    for (final module in decisionModules) {
      final teams = byModule[module];
      if (teams is! Map) continue;
      for (final teamEntry in teams.entries) {
        final rounds = teamEntry.value;
        if (rounds is! Map) continue;
        final perRound = <String, List<Map<String, dynamic>>>{};
        for (final roundEntry in rounds.entries) {
          final rows = roundEntry.value;
          if (rows is! List) continue;
          perRound[roundEntry.key.toString()] = rows
              .whereType<Map>()
              .map((r) => Map<String, dynamic>.from(r))
              .toList();
        }
        if (perRound.isEmpty) continue;
        out.putIfAbsent(teamEntry.key.toString(), () => {})[module] = perRound;
      }
    }
    return out;
=======
  /// GET /facilitator/all-decisions. Unwrapped:
  /// `{financing|investing|operating: {teamId: {round: [{scenarioId, title, amount,
  /// confirmed}]}}}`. `confirmed` is false for an amount typed but never confirmed.
  Future<Map<String, dynamic>> getAllDecisions() async {
    final response = await _api.get(ApiEndpoints.facilitatorAllDecisions);
    if (response['error'] != null && response['financing'] == null) {
      throw FacilitatorActionException(response['error'].toString());
    }
    return response;
>>>>>>> Stashed changes
  }

  /// POST /facilitator/force-round {round, force}: every team to [round] Financing.
  /// Moving forward without [force] throws [RoundIncompleteException] when a team still
  /// owes a decision in the round before.
  Future<void> forceRound(int round, {bool force = false}) async {
    final res = await _api.post(ApiEndpoints.facilitatorForceRound,
        data: {'round': round, 'force': force});
    if (res['code'] == 'ROUND_INCOMPLETE') {
      throw RoundIncompleteException(
        round: (res['round'] as num?)?.toInt() ?? round,
        message: (res['message'] ?? '').toString(),
        gaps: (res['gaps'] as List<dynamic>? ?? [])
            .whereType<Map>()
            .map((g) => RoundGap.fromJson(Map<String, dynamic>.from(g)))
            .toList(),
      );
    }
    _ensureOk(res, 'Could not move teams to round $round');
  }

  /// POST /facilitator/force-module {round, module}: every team to [round] / [module].
  /// [module] is financing, investing, operating, or 'dashboard' (the round's results
  /// screen, with all of that round's decisions locked).
  Future<Map<String, dynamic>> forceModule(String module, {int? round}) async {
    final res = await _api.post(ApiEndpoints.facilitatorForceModule,
        data: {'module': module, 'round': ?round});
    return _ensureOk(res, 'Could not move teams');
  }

<<<<<<< Updated upstream
  /// Let every team "Move to Next Decisions" (unlock:true) or hold them
  /// (unlock:false): POST /facilitator/toggle-next-decisions, the same route the
  /// website's Unlock / Lock control uses. The facilitator password rides on the
  /// x-facilitator-password header set by [login]. Returns the server's
  /// response; callers must check `success` (a 401 or 400 body comes back with
  /// success:false and its status under [httpStatusKey]) and read
  /// `nextDecisionsUnlocked` for the confirmed state.
  Future<Map<String, dynamic>> toggleNextDecisions(bool unlock) async {
    final res = await _api.post(ApiEndpoints.facilitatorToggleNextDecisions, data: {
      'unlock': unlock,
    });
    if (apiFailed(res) && res['success'] == null) {
      // A 4xx preserved without a success flag (e.g. 400 {error}) is a failure too.
      return {...res, 'success': false};
    }
    return res;
=======
  /// POST /facilitator/toggle-next-decisions {unlock}: whether teams may move on to the
  /// next decision module (the unlock is scoped to the module the room is on).
  /// Returns the new `nextDecisionsUnlocked`.
  Future<bool> toggleNextDecisions(bool unlock) async {
    final res = await _api.post(ApiEndpoints.facilitatorToggleNextDecisions, data: {'unlock': unlock});
    _ensureOk(res, 'Could not toggle next decisions');
    return res['nextDecisionsUnlocked'] == true;
>>>>>>> Stashed changes
  }

  /// POST /cache/clear — the server checks the password from the body, not the header.
  Future<void> clearServerCache() async {
    final res = await _api.post(ApiEndpoints.cacheClear, data: {'password': _facilitatorPassword});
    _ensureOk(res, 'Could not clear the data cache');
  }

<<<<<<< Updated upstream
  /// One Game Checks row. Throws when the route answered 4xx or said
  /// success:false, so a dead route is reported as failed, not passed.
  Future<Map<String, dynamic>> runHealthCheck(String endpoint) async {
    final res = await _api.get(endpoint);
    if (apiFailed(res)) {
      throw Exception(res['error'] ?? 'HTTP ${res[httpStatusKey]}');
    }
    return res;
=======
  /// Probe a GET endpoint for the Game Checks tab; throws on any 4xx/5xx.
  Future<void> runHealthCheck(String endpoint) async {
    final res = await _api.get(endpoint);
    final status = res[httpStatusKey];
    if (status != null) throw FacilitatorActionException('HTTP $status');
  }

  /// The website's single system check: GET /health/connection reports `mode: 'online'`
  /// when the Postgres-backed financial engine is reachable.
  Future<bool> checkEngineHealth() async {
    final res = await _api.get(ApiEndpoints.healthConnection);
    return res['mode'] == 'online';
>>>>>>> Stashed changes
  }

  Future<void> removePlayer(String playerName, String teamId) async {
    await _api.post(ApiEndpoints.facilitatorRemoveSignin, data: {
      'playerName': playerName,
      'teamId': teamId,
    });
  }

<<<<<<< Updated upstream
  // ── Timer overlay broadcast ──
  /// Start the live countdown overlay on every participant screen
  /// (POST /facilitator/timer-overlay/start; the server broadcasts
  /// facilitator:timer_start). Returns true when the server confirmed it.
  Future<bool> showTimerOverlay() async {
    try {
      final res = await _api.post(ApiEndpoints.facilitatorTimerOverlayStart);
      return res['success'] == true;
    } catch (_) {
      return false;
    }
  }

  /// Stop the overlay (POST /facilitator/timer-overlay/stop).
  Future<bool> hideTimerOverlay() async {
    try {
      final res = await _api.post(ApiEndpoints.facilitatorTimerOverlayStop);
      return res['success'] == true;
    } catch (_) {
      return false;
    }
=======
  // ── Timer overlay (website TimerOverlayAdmin) ──
  /// Saves the countdown length (POST /facilitator/timer-overlay/settings
  /// {durationSeconds: 1-7200}) then starts it (POST /facilitator/timer-overlay/start).
  Future<void> showTimerOverlay({required int durationSeconds}) async {
    final settings = await _api.post(ApiEndpoints.facilitatorTimerOverlaySettings, data: {
      'durationSeconds': durationSeconds,
      'password': ?_facilitatorPassword,
    });
    _ensureOk(settings, 'Could not save the timer overlay settings');
    final res = await _api.post(ApiEndpoints.facilitatorTimerOverlayStart, data: {'password': ?_facilitatorPassword});
    _ensureOk(res, 'Could not start the timer overlay');
  }

  /// POST /facilitator/timer-overlay/stop.
  Future<void> hideTimerOverlay() async {
    final res = await _api.post(ApiEndpoints.facilitatorTimerOverlayStop, data: {'password': ?_facilitatorPassword});
    _ensureOk(res, 'Could not stop the timer overlay');
>>>>>>> Stashed changes
  }

  // ── Covenant threshold overrides ──
  /// Override the covenant thresholds (max leverage / min coverage).
  /// Returns true on success, false on failure (best-effort).
  Future<bool> setCovenantThresholds({
    required double maxLeverage,
    required double minCoverage,
  }) async {
    try {
      // Server field names: maxDebtToEbitda / minInterestCoverage.
      final res = await _api.post('/facilitator/covenant-thresholds', data: {
        'maxDebtToEbitda': maxLeverage,
        'minInterestCoverage': minCoverage,
      });
      return res['success'] == true;
    } catch (_) {
      return false;
    }
  }

<<<<<<< Updated upstream
  // ── Excel worksheet viewer ──
  /// Fetch the baseline financial statements the Excel tab renders:
  /// `{ incomeStatement, balanceSheet, cashFlow, ratios }`, each a list of
  /// `{ title, value, isHeader, ... }` rows from GET /game/results/round at
  /// round 0 (the same reads as the website's BaselineFinancialStatements).
  /// Throws when the server cannot serve them.
  Future<Map<String, List<Map<String, dynamic>>>> fetchExcelData() async {
    return GameRepository(_api).fetchBaselineStatements();
  }

  // ── Scenario results visibility ──
  /// Show or hide the capital-budgeting scenario results to learners
  /// (POST /facilitator/unlock-all-scenario-results with every scenario id).
  /// Learners read the result from GET /capital-budgeting/status.
  Future<bool> setScenarioResultsVisible(bool visible) async {
    try {
      final res = await _api.post(ApiEndpoints.facilitatorUnlockAllScenarioResults, data: {
        'scenarioIds': capitalBudgetingScenarioIds,
        'unlock': visible,
      });
      return res['success'] == true;
    } catch (_) {
      return false;
    }
  }

  // ── Education progress reset ──
  /// Clear every team's education progress (POST /education/admin/reset-all).
  /// That router authenticates from the body, so the password is sent there.
  Future<bool> clearEducationProgress() async {
    try {
      final res = await _api.post(ApiEndpoints.educationAdminReset, data: {
        'password': _password,
      });
=======
  // ── Case-study constraints (website "Constraints" card) ──
  /// GET /case-study/active -> `{success, active, constraints: {module: {maxBudget?,
  /// maxSelections?}}, facilitatorOverrides, currentRound}`. Returns null when no case
  /// study is active (the overrides then have nothing to apply to).
  Future<Map<String, dynamic>?> fetchActiveCaseStudy() async {
    final res = await _api.get(ApiEndpoints.caseStudyActive);
    if (res['active'] != true) return null;
    return res;
  }

  /// POST /facilitator/set-case-study-overrides {overrides: {financing|investing|operating:
  /// {maxBudget?, maxSelections?}}}.
  Future<void> saveCaseStudyOverrides(Map<String, Map<String, num>> overrides) async {
    final res = await _api.post(ApiEndpoints.facilitatorSetCaseStudyOverrides, data: {'overrides': overrides});
    _ensureOk(res, 'Could not save constraints');
  }

  // ── Scenario results visibility ──
  /// Show or hide every capital-budgeting scenario's results to learners
  /// (POST /facilitator/unlock-all-scenario-results {scenarioIds, unlock}, as the website's
  /// "unlock all" does).
  Future<void> setScenarioResultsVisible(bool visible) async {
    final res = await _api.post(ApiEndpoints.facilitatorUnlockAllScenarioResults,
        data: {'scenarioIds': _capitalBudgetingScenarioIds, 'unlock': visible});
    _ensureOk(res, 'Could not change scenario results visibility');
  }

  // ── Education progress reset ──
  /// POST /education/admin/reset-all {password}: resets every team's education progress and
  /// scores and removes all team members (website EducationAdmin "Reset all").
  Future<bool> clearEducationProgress() async {
    try {
      final res = await _api.postOnce(ApiEndpoints.educationAdminReset, data: {'password': _facilitatorPassword});
>>>>>>> Stashed changes
      return res['success'] == true;
    } catch (_) {
      return false;
    }
  }

  // ── Education unlock controls (parity with website EducationAdmin) ──
  Future<bool> toggleEducation(bool unlock) async {
    final res = await _api.post(ApiEndpoints.facilitatorToggleEducation, data: {'unlock': unlock});
    return res['success'] == true;
  }

  Future<bool> toggleEducationModule(int moduleId, bool unlock) async {
    final res = await _api.post(ApiEndpoints.facilitatorToggleEducationModule,
        data: {'moduleId': moduleId, 'unlock': unlock});
    return res['success'] == true;
  }

  Future<bool> toggleAllEducationModules(bool unlock) async {
    final res = await _api.post(ApiEndpoints.facilitatorToggleAllEducationModules, data: {'unlock': unlock});
    return res['success'] == true;
  }

  Future<bool> toggleEducationRetry(bool unlock) async {
    final res = await _api.post(ApiEndpoints.facilitatorToggleEducationRetry, data: {'unlock': unlock});
    return res['success'] == true;
  }

  // ── Realism toggles ──
  Future<Map<String, dynamic>> fetchRealismStatus() async {
    try {
      return await _api.get(ApiEndpoints.realismStatus);
    } catch (_) {
      return {};
    }
  }

  Future<bool> toggleRealism(String flag, bool enabled) async {
    final res = await _api.post(ApiEndpoints.facilitatorRealismToggle,
        data: {'flag': flag, 'enabled': enabled});
    return res['success'] == true;
  }

  // ── Lock & advance to next module ──
  /// Locks all teams' current module and advances them to the next one.
  /// Returns the response map (may carry success/message).
  Future<Map<String, dynamic>> lockAndAdvanceModule() async {
    return await _api.postOnce(ApiEndpoints.facilitatorLockAdvanceModule);
  }

  // ── Single-shock dismiss ──
  /// Dismiss ONE active shock by its instance id (ActiveShock.id).
  Future<bool> dismissShock(String shockInstanceId, {bool revertModel = true}) async {
    try {
      final res = await _api.post(ApiEndpoints.shocksDismiss, data: {
        'shockInstanceId': shockInstanceId,
        'revertModel': revertModel,
        'password': _facilitatorPassword,
      });
      return res['success'] == true;
    } catch (_) {
      return false;
    }
  }

  // ── Timer: update a running timer's duration ──
  Future<Map<String, dynamic>> updateTimer(int minutes) async {
    return await _api.post(ApiEndpoints.facilitatorUpdateTimer, data: {'minutes': minutes});
  }

  /// Start a fresh timer for [minutes].
  Future<Map<String, dynamic>> startTimerMinutes(int minutes) async {
    return await _api.post(ApiEndpoints.facilitatorStartTimer, data: {'minutes': minutes});
  }

  // ── Model editor: scenarios (read + edit) ──
  Future<List<Map<String, dynamic>>> fetchModelScenarios() async {
    try {
      final res = await _api.get(ApiEndpoints.modelScenarios);
      final list = res['scenarios'] as List<dynamic>? ?? res['data'] as List<dynamic>? ?? [];
      return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<bool> saveModelScenarios(List<Map<String, dynamic>> updates) async {
    final res = await _api.post(ApiEndpoints.modelScenarios, data: {'updates': updates});
    return res['success'] == true;
  }

  // ── Cohorts ──
  Future<List<Map<String, dynamic>>> fetchCohorts() async {
    try {
      final res = await _api.get(ApiEndpoints.facilitatorCohorts);
      final list = res['cohorts'] as List<dynamic>? ?? [];
      return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  /// POST /facilitator/cohorts {subdomain, displayName, research}. [research] enrols the
  /// new group in the DBA study at creation (website CohortsPanel). Returns the raw body:
  /// `{success, cohort: {..., url, research}}` or `{success: false, error}`.
  Future<Map<String, dynamic>> createCohort(String subdomain, String displayName,
      {bool research = false}) async {
    return await _api.postOnce(ApiEndpoints.facilitatorCohorts,
        data: {'subdomain': subdomain, 'displayName': displayName, 'research': research});
  }

  /// GET /facilitator/cohorts -> `{success, baseDomain, cohorts: [{id, subdomain,
  /// displayName, schemaName, isActive, createdAt, url, research, lobbyOpen,
  /// educationModuleNums: int[]|null, certificateProgramName: String|null}]}`.
  /// Throws [FacilitatorActionException] when the list cannot be read.
  Future<({String baseDomain, List<Map<String, dynamic>> cohorts})> fetchCohortRegistry() async {
    final res = await _api.get(ApiEndpoints.facilitatorCohorts);
    if (res['cohorts'] is! List) {
      throw FacilitatorActionException(
          (res['error'] ?? res['message'] ?? 'Failed to load cohorts').toString());
    }
    return (
      baseDomain: (res['baseDomain'] ?? 'finplay.viftraining.com').toString(),
      cohorts: (res['cohorts'] as List)
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList(),
    );
  }

  /// PATCH /facilitator/cohorts/:id with any of `displayName`, `research`,
  /// `educationModuleNums` (int list, or null = whole catalog) and
  /// `certificateProgramName` (null/empty = platform default). Returns the saved cohort.
  Future<Map<String, dynamic>> updateCohort(String id, Map<String, dynamic> changes) async {
    final res = await _send('PATCH', '$_cohortsPath/${Uri.encodeComponent(id)}', changes);
    _ensureOk(res, 'Failed to update cohort');
    final c = res['cohort'];
    return c is Map ? Map<String, dynamic>.from(c) : <String, dynamic>{};
  }

  /// GET /facilitator/cohorts/:id/data-summary -> `{counts: {table: n}, hasParticipantData}`,
  /// shown in the delete confirmation.
  Future<({Map<String, int> counts, bool hasParticipantData})> fetchCohortDataSummary(
      String id) async {
    final res = await _api.get('$_cohortsPath/${Uri.encodeComponent(id)}/data-summary');
    _ensureOk(res, 'Failed to read cohort data');
    final raw = res['counts'];
    return (
      counts: <String, int>{
        if (raw is Map)
          for (final e in raw.entries)
            if (e.value is num) e.key.toString(): (e.value as num).toInt(),
      },
      hasParticipantData: res['hasParticipantData'] == true,
    );
  }

  /// GET /facilitator/cohorts/:id/module-progress -> `{counts: {progressId: teams}}`: how
  /// many teams have work in each module, for the module plan editor's warning.
  Future<Map<String, int>> fetchCohortModuleProgress(String id) async {
    try {
      final res = await _api.get('$_cohortsPath/${Uri.encodeComponent(id)}/module-progress');
      final raw = res['counts'];
      if (raw is! Map) return {};
      return {
        for (final e in raw.entries)
          if (e.value is num) e.key.toString(): (e.value as num).toInt(),
      };
    } catch (_) {
      return {};
    }
  }

  /// DELETE /facilitator/cohorts/:id {confirm: subdomain}: drops the cohort's schema.
  /// Irreversible; the server refuses unless [confirm] is the exact subdomain.
  Future<Map<String, dynamic>> deleteCohort(String id, String confirm) async {
    final res = await _send(
        'DELETE', '$_cohortsPath/${Uri.encodeComponent(id)}', {'confirm': confirm});
    _ensureOk(res, 'Failed to delete cohort');
    final d = res['deleted'];
    return d is Map ? Map<String, dynamic>.from(d) : <String, dynamic>{};
  }

  /// GET /research/config -> `{enabled, audience, collectsHere, cohort: {isCohort,
  /// subdomain?, displayName}}` for the cohort this host serves.
  Future<Map<String, dynamic>> fetchResearchConfig() async {
    try {
      return await _api.get(ApiEndpoints.researchConfig);
    } catch (_) {
      return {};
    }
  }

  /// POST /research/mode {enabled} for the cohort this host serves (the website's
  /// main-environment row sends `enabled` alone). Returns the new state.
  Future<bool> setResearchMode(bool enabled) async {
    final res = await _api.post(ApiEndpoints.researchMode, data: {'enabled': enabled});
    _ensureOk(res, 'Failed to change enrolment');
    return res['enabled'] == true;
  }

  static const String _cohortsPath = ApiEndpoints.facilitatorCohorts;

  // ── Vouchers / access codes ──
  Future<List<Map<String, dynamic>>> fetchVouchers() async {
    try {
      final res = await _api.get(ApiEndpoints.vouchers);
      final list = res['vouchers'] as List<dynamic>? ?? [];
      return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> createVouchers({
    int count = 1,
    int maxUses = 1,
    String? label,
    String? expiresAt,
    int? accessDays,
    String? notes,
  }) async {
    // accessDays: access period (1-3660 days) granted to each account created with the
    // code; omitted = the standard trial.
    final res = await _api.postOnce(ApiEndpoints.vouchers, data: {
      'count': count,
      'maxUses': maxUses,
      'label': ?label,
      'expiresAt': ?expiresAt,
      'accessDays': ?accessDays,
      'notes': ?notes,
    });
    final list = res['created'] as List<dynamic>? ?? [];
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  Future<bool> updateVoucher(String id, Map<String, dynamic> changes) async {
    // Backend exposes PATCH /vouchers/:id (no PUT route).
    final res = await _api.patch('${ApiEndpoints.vouchers}/${Uri.encodeComponent(id)}', data: changes);
    return res['success'] == true;
  }

  /// Pre-validate an access code (used by the self-paced sign-up screen to show
  /// applied/invalid feedback). Returns (valid, reason).
  Future<({bool valid, String? reason})> validateVoucher(String code) async {
    try {
      final res = await _api.post(ApiEndpoints.vouchersValidate, data: {'code': code});
      return (valid: res['valid'] == true, reason: res['reason'] as String?);
    } catch (_) {
      return (valid: false, reason: null);
    }
  }

  Future<bool> deleteVoucher(String id) async {
    final res = await _api.delete('${ApiEndpoints.vouchers}/${Uri.encodeComponent(id)}');
    return res['success'] == true;
  }

  Future<bool> fetchVoucherGating() async {
    try {
      final res = await _api.get(ApiEndpoints.vouchersGating);
      return res['required'] == true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> setVoucherGating(bool required) async {
    final res = await _api.post(ApiEndpoints.vouchersGating, data: {'required': required});
    return res['success'] == true;
  }

  // ── Assessments admin ──
  Future<List<Map<String, dynamic>>> fetchAssessmentAttempts() async {
    try {
      final res = await _api.get(ApiEndpoints.assessmentsAdminList);
      final list = res['attempts'] as List<dynamic>? ?? [];
      return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  /// Throws [FacilitatorActionException] with the server's reason when refused
  /// (409 in a research cohort, where the commercial assessments do not run).
  Future<bool> setAssessmentMandate(String kind, bool mandated) async {
    final res = await _api.post(ApiEndpoints.assessmentsMandate,
        data: {'kind': kind, 'mandated': mandated});
    _ensureOk(res, 'Could not change the mandate');
    return res['success'] == true;
  }

  /// GET /research/config -> `{enabled, audience, collectsHere, cohort}`. `enabled` marks
  /// this cohort as a DBA study site, which suppresses the commercial assessments.
  Future<bool> fetchResearchEnabled() async {
    try {
      final res = await _api.get(ApiEndpoints.researchConfig);
      return res['enabled'] == true;
    } catch (_) {
      return false;
    }
  }

  // ── QR placeholders ──
  Future<Map<String, dynamic>> fetchQrStatus() async {
    try {
      return await _api.get(ApiEndpoints.facilitatorQrStatus);
    } catch (_) {
      return {};
    }
  }

  Future<bool> saveQrPlaceholders(Map<String, dynamic> placeholders) async {
    final res = await _api.post(ApiEndpoints.facilitatorQrPlaceholders,
        data: {'placeholders': placeholders});
    return res['success'] == true;
  }

  /// PATCH/DELETE with a JSON body. [ApiClient.patch]/[ApiClient.delete] throw on 4xx and
  /// the latter takes no body, so these go through Dio directly and hand back the server's
  /// error body (stamped with [httpStatusKey]) instead of throwing.
  Future<Map<String, dynamic>> _send(String method, String path, Map<String, dynamic> body) =>
      _api.sendOnce(method, path, data: body);


  // ── Master voucher (website VouchersAdmin, db0eb0e) ──
  /// GET /vouchers/master -> `{success, code: String|null}`. One standing code that passes
  /// both the self-paced voucher gate and the corporate access-code gate without using a slot.
  Future<String?> fetchMasterVoucher() async {
    final res = await _api.get(_vouchersMaster);
    _ensureOk(res, 'Could not load the master voucher.');
    final code = res['code'];
    return code?.toString();
  }

  /// POST /vouchers/master. [clear] removes it; otherwise [code] (6-64 chars) sets a custom
  /// code, and no code generates a new random one. Returns the stored code (null = cleared).
  Future<String?> setMasterVoucher({String? code, bool clear = false}) async {
    final body = <String, dynamic>{
      if (clear) 'clear': true,
      if (!clear && code != null && code.trim().isNotEmpty) 'code': code.trim(),
    };
    final res = await _api.postOnce(_vouchersMaster, data: body);
    _ensureOk(res, 'Could not update the master voucher.');
    final c = res['code'];
    return c?.toString();
  }

  // ── Facilitator Insights (teachable-moment detector) ──
  /// POST /insights {password, round} -> `{success, round, generatedAt, insights: [{id,
  /// type, severity: critical|notable|info, title, detail, teams, discussionPrompt}]}`.
  Future<Map<String, dynamic>> fetchInsights(int round) async {
    final res = await _api.postOnce(_insights, data: {'password': _facilitatorPassword, 'round': round});
    if (res['success'] != true) {
      throw FacilitatorActionException(
          (res['error'] ?? res['message'] ?? 'Failed to scan for insights').toString());
    }
    return res;
  }

  // ── Market forecasts + shock insurance (website ShockTriggerPanel) ──
  /// GET /shocks/forecasts -> unresolved forecasts on the wire, newest first.
  Future<List<Map<String, dynamic>>> fetchForecasts() async {
    final res = await _api.get(_shocksForecasts);
    final list = res['forecasts'];
    if (list is! List) return [];
    return list.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }

  /// GET /shocks/predefined as raw rows (`{id, name, nameAr, severity, icon,
  /// forecastHeadline?, forecastHeadlineAr?}`), for the forecast publisher's picker.
  Future<List<Map<String, dynamic>>> fetchPredefinedShockRows() async {
    try {
      final res = await _api.get(ApiEndpoints.shocksPredefined);
      final list = res['shocks'] as List<dynamic>? ?? [];
      return list.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (_) {
      return [];
    }
  }

  /// POST /shocks/forecast {password, shockId?, headline?, roundNum, severityHint?}.
  /// Omit [shockId] for a red herring; with a shockId and no headline the server writes one.
  Future<Map<String, dynamic>> publishForecast({
    String? shockId,
    String? headline,
    required int roundNum,
    String? severityHint,
  }) async {
    final res = await _api.postOnce(_shocksForecast, data: {
      'password': _facilitatorPassword,
      'shockId': ?shockId,
      if (headline != null && headline.trim().isNotEmpty) 'headline': headline.trim(),
      'roundNum': roundNum,
      'severityHint': ?severityHint,
    });
    return _ensureOk(res, 'Failed to publish forecast');
  }

  /// POST /shocks/forecast/:id/resolve {password}: pulls it off the ticker.
  Future<void> resolveForecast(String id) async {
    final res = await _api.postOnce('$_shocksForecast/${Uri.encodeComponent(id)}/resolve',
        data: {'password': _facilitatorPassword});
    _ensureOk(res, 'Failed to resolve forecast');
  }

  /// GET /hedges/forecast/:id -> `{count, teamIds}`: which teams insured against it.
  Future<({int count, List<String> teamIds})> fetchForecastInsurance(String forecastId) async {
    try {
      final res = await _api.get('$_hedgesForecast/${Uri.encodeComponent(forecastId)}');
      final ids = (res['teamIds'] as List<dynamic>? ?? []).map((e) => e.toString()).toList();
      return (count: (res['count'] as num?)?.toInt() ?? ids.length, teamIds: ids);
    } catch (_) {
      return (count: 0, teamIds: const <String>[]);
    }
  }

  // ── Session Setup Wizard reads/writes (website /facilitator/setup) ──
  /// GET /health -> `{status, services: {database: {status}}, config: {env}}`.
  Future<Map<String, dynamic>> fetchHealth() => _safeGet(ApiEndpoints.health);

  /// GET /health/connection -> `{mode: online|..., message}`.
  Future<Map<String, dynamic>> fetchConnection() => _safeGet(ApiEndpoints.healthConnection);

  /// POST /facilitator/status -> `{success, cohort: {subdomain, schema, displayName, host,
  /// isMain}, gameState}`. The POST form also names the cohort this host writes to.
  Future<Map<String, dynamic>> fetchStatusWithCohort() async {
    final res = await _api.post(ApiEndpoints.facilitatorStatus, data: {'password': ?_facilitatorPassword});
    _ensureOk(res, 'Failed to get facilitator state');
    return res;
  }

  /// GET /shocks/active -> `{success, shocks, count}` (raw, for the fresh-start check).
  Future<Map<String, dynamic>> fetchActiveShocksRaw() => _safeGet(ApiEndpoints.shocksActive);
  Future<Map<String, dynamic>> fetchRoundState() => _safeGet(_gameRoundState);
  Future<Map<String, dynamic>> fetchTeamLeaders() => _safeGet(_teamLeaders);
  Future<Map<String, dynamic>> fetchModelAssumptions() => _safeGet(ApiEndpoints.modelAssumptions);
  Future<Map<String, dynamic>> fetchBranding() => _safeGet(ApiEndpoints.modelBranding);
  Future<Map<String, dynamic>> fetchEducationStatus() => _safeGet(_educationStatus);
  Future<Map<String, dynamic>> fetchTimerOverlay() => _safeGet(_timerOverlay);
  Future<Map<String, dynamic>> fetchAssessmentStatus(String kind) =>
      _safeGet(_assessmentStatus, params: {'kind': kind});

  Future<Map<String, dynamic>> _safeGet(String path, {Map<String, dynamic>? params}) async {
    try {
      return await _api.get(path, params: params);
    } catch (_) {
      return {};
    }
  }

  /// POST /facilitator/model/branding {titleEn?, titleAr?, clientName?}.
  Future<void> saveBranding(Map<String, String> branding) async {
    final res = await _api.post(ApiEndpoints.modelBranding, data: branding);
    _ensureOk(res, 'Failed to update branding');
  }

  /// POST /facilitator/toggle-game-mode {mode: facilitator|self-paced}.
  Future<void> setGameMode(String mode) async {
    final res = await _api.post(_toggleGameMode, data: {'mode': mode});
    _ensureOk(res, 'Could not change the game mode');
  }

  /// POST /facilitator/clear-team-leaders.
  Future<void> clearTeamLeaders() async {
    final res = await _api.postOnce(_clearTeamLeaders);
    _ensureOk(res, 'Could not clear team leaders');
  }

  /// POST /facilitator/reset-game {password}: the admin-tier reset. Decisions are archived
  /// first; the response carries `archiveBatchId` and `archivedDecisions`.
  Future<Map<String, dynamic>> resetGameArchived(String adminPassword) async {
    final res = await _api.postOnce(ApiEndpoints.facilitatorResetGame, data: {'password': adminPassword});
    return _ensureOk(res, 'Failed to reset game');
  }

  /// POST /shocks/clear-all {password, revertModel: true}.
  Future<void> clearAllShocksReverting() async {
    final res = await _api.postOnce(ApiEndpoints.shocksClearAll,
        data: {'password': _facilitatorPassword, 'revertModel': true});
    _ensureOk(res, 'Could not clear the shocks');
  }

  /// POST /facilitator/start-game {timerMinutes}: Round 1 Financing for every team.
  Future<Map<String, dynamic>> startGameWithTimer(int timerMinutes) async {
    final res = await _api.postOnce(ApiEndpoints.facilitatorStartGame,
        data: {'password': ?_facilitatorPassword, 'timerMinutes': timerMinutes});
    return _ensureOk(res, 'Could not start game');
  }

  /// POST /facilitator/timer-overlay/settings {durationSeconds} (1-7200).
  Future<void> saveTimerOverlaySeconds(int durationSeconds) async {
    final res = await _api.post(ApiEndpoints.facilitatorTimerOverlaySettings,
        data: {'durationSeconds': durationSeconds, 'password': ?_facilitatorPassword});
    _ensureOk(res, 'Could not save the timer overlay settings');
  }

  /// POST /facilitator/covenant-thresholds; throws with the server's reason on refusal.
  Future<void> saveCovenantThresholds(double maxDebtToEbitda, double minInterestCoverage) async {
    final res = await _api.post('/facilitator/covenant-thresholds', data: {
      'maxDebtToEbitda': maxDebtToEbitda,
      'minInterestCoverage': minInterestCoverage,
    });
    _ensureOk(res, 'Failed to set covenant thresholds');
  }

  /// POST /narration/prepare {moduleId, sectionId, language, text}: generates (or confirms
  /// the cache for) one slide's narration. Accepts the facilitator password header.
  /// Returns `cached`; throws [FacilitatorActionException] with the server's message.
  Future<bool> prepareNarration({
    required String moduleId,
    required String sectionId,
    required String language,
    required String text,
  }) async {
    final res = await _api.postOnce(ApiEndpoints.narrationPrepare, data: {
      'moduleId': moduleId,
      'sectionId': sectionId,
      'language': language,
      'text': text,
    });
    if (res['ready'] != true) {
      throw FacilitatorActionException((res['error'] ?? res['message'] ?? 'failed').toString());
    }
    return res['cached'] == true;
  }

  // ── Activity log (website ActivityLogAdmin) ──
  /// POST /facilitator/activity-log {password, category, search, limit} ->
  /// `{success, configured, events: [{id, actorType, actorEmail, actorName, teamId, cohort,
  /// category, action, detail, createdAt}]}`. `configured: false` = table not migrated.
  Future<({bool configured, List<Map<String, dynamic>> events})> fetchActivityLog({
    String category = '',
    String search = '',
    int limit = 300,
  }) async {
    final res = await _api.post(_activityLog, data: {
      'password': _facilitatorPassword,
      'category': category,
      'search': search,
      'limit': limit,
    });
    _ensureOk(res, 'Failed to read activity log');
    return (
      configured: res['configured'] != false,
      events: (res['events'] as List<dynamic>? ?? [])
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList(),
    );
  }

  // ── Self-paced members (website SelfPacedMembersAdmin) ──
  /// POST /self-paced/admin/members {password} -> `{members: [...]}` with `accessState`
  /// (subscription|trial|student|comp|lapsed), `hasEverPaid`, `plan`, dates and progress.
  Future<List<Map<String, dynamic>>> fetchSelfPacedMembers() async {
    final res = await _api.post(ApiEndpoints.selfPacedMembers, data: {'password': _facilitatorPassword});
    if (res['members'] is! List) {
      throw FacilitatorActionException((res['error'] ?? 'Failed to load members').toString());
    }
    return (res['members'] as List).whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }

  /// POST /self-paced/admin/members/set-plan {password, email, plan: trial|demo|comp}.
  Future<void> setMemberPlan(String email, String plan) async {
    final res = await _api.postOnce(_setPlan, data: {'password': _facilitatorPassword, 'email': email, 'plan': plan});
    _ensureOk(res, 'Failed to update plan');
  }

  // ── Annual-report downloads (website FinancialStatementsAdmin) ──
  /// GET /facilitator/financial-statements -> `{annualReport: [{id, label, filename, uploadedAt}]}`.
  Future<List<Map<String, dynamic>>> fetchFinancialStatements() async {
    final res = await _api.get(_financialStatements);
    return (res['annualReport'] as List<dynamic>? ?? [])
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  /// POST /facilitator/financial-statements/delete {password, category, fileId}.
  Future<void> deleteFinancialStatement(String fileId) async {
    final res = await _api.postOnce('$_financialStatements/delete',
        data: {'password': _facilitatorPassword, 'category': 'annualReport', 'fileId': fileId});
    if (res['success'] == false || res['error'] != null) {
      throw FacilitatorActionException((res['error'] ?? 'Delete failed').toString());
    }
  }

  // ── Case-study templates + per-scenario results (website Controls) ──
  /// GET /case-study/templates -> `{templates: [{id, name: {en, ar}, icon, difficulty}],
  /// activeCaseStudyId}`.
  Future<Map<String, dynamic>> fetchCaseStudyTemplates() => _safeGet(_caseStudyTemplates);

  /// POST /facilitator/set-case-study {caseStudyId} (null deactivates).
  Future<Map<String, dynamic>> setCaseStudy(String? caseStudyId) async {
    final res = await _api.post(_setCaseStudy, data: {'caseStudyId': caseStudyId, 'password': ?_facilitatorPassword});
    return _ensureOk(res, 'Could not set case study');
  }

  /// POST /facilitator/toggle-scenario-results {scenarioId, unlock}. Returns the new
  /// `capitalBudgetingResultsUnlocked` list.
  Future<List<String>> toggleScenarioResults(String scenarioId, bool unlock) async {
    final res = await _api.post(_toggleScenarioResults,
        data: {'scenarioId': scenarioId, 'unlock': unlock, 'password': ?_facilitatorPassword});
    _ensureOk(res, 'Could not toggle scenario results');
    return (res['capitalBudgetingResultsUnlocked'] as List<dynamic>? ?? []).map((e) => e.toString()).toList();
  }

  /// POST /facilitator/test-email {to}: checks the Outlook/Graph email configuration.
  Future<String> sendTestEmail(String to) async {
    final res = await _api.postOnce(_testEmail, data: {'to': to, 'password': ?_facilitatorPassword});
    _ensureOk(res, 'Failed to send test email');
    return (res['message'] ?? 'Test email sent to $to').toString();
  }

  // ── Sim Control (website TeamDashboardNavigator) ──
  /// GET /teams -> every team row (id, name, color, currentRound, ...), sorted by number.
  Future<List<Map<String, dynamic>>> fetchTeamsRaw() async {
    final list = await _api.getList(ApiEndpoints.teams);
    final rows = list.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
    int n(Map r) => int.tryParse(r['id'].toString().replaceAll(RegExp(r'\D+'), '')) ?? 0;
    rows.sort((a, b) => n(a).compareTo(n(b)));
    return rows;
  }

  /// GET /dashboard-data?teamId&currentRound&previousRound: a team's statements for a
  /// round. The server treats currentRound 0 as 1, so the baseline is read as the
  /// `previousRound` block of Round 1 ([round] 0 does that).
  Future<Map<String, dynamic>> fetchTeamRoundData(String teamId, int round) async {
    final current = round < 1 ? 1 : round;
    final res = await _api.get(ApiEndpoints.dashboardData, params: {
      'teamId': teamId,
      'currentRound': current,
      'previousRound': round < 1 ? 0 : round - 1,
    });
    if (res['data'] is! Map) {
      throw FacilitatorActionException((res['error'] ?? 'Failed to load the team dashboard').toString());
    }
    final data = Map<String, dynamic>.from(res['data'] as Map);
    final block = round < 1 ? data['previousRound'] : data['currentRound'];
    return block is Map ? Map<String, dynamic>.from(block) : {};
  }
}
