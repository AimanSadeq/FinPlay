import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../models/shock.dart';

class FacilitatorRepository {
  final ApiClient _api;

  FacilitatorRepository(this._api);

  Future<bool> login(String password) async {
    final response = await _api.post(ApiEndpoints.facilitatorAuth, data: {
      'password': password,
    });
    return response['success'] == true;
  }

  Future<Map<String, dynamic>> getState() async {
    final response = await _api.get(ApiEndpoints.facilitatorStatus);
    if (response['success'] == true) {
      return response['data'] as Map<String, dynamic>;
    }
    throw Exception(response['error'] ?? 'Failed to get facilitator state');
  }

  Future<Map<String, dynamic>> getTeamsStatus() async {
    final response = await _api.get(ApiEndpoints.facilitatorTeamsStatus);
    if (response['success'] == true) {
      return response['data'] as Map<String, dynamic>;
    }
    throw Exception(response['error'] ?? 'Failed to get teams status');
  }

  Future<void> lockModule(String module, bool locked) async {
    if (locked) {
      await _api.post(ApiEndpoints.facilitatorLockAdvance, data: {
        'module': module,
      });
    } else {
      await _api.post(ApiEndpoints.facilitatorForceModule, data: {
        'module': module,
      });
    }
  }

  Future<void> unlockEducation(String feature, bool unlocked) async {
    await _api.post(ApiEndpoints.facilitatorToggleGovModule, data: {
      'feature': feature,
      'enabled': unlocked,
    });
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

  Future<void> startGame() async {
    await _api.post(ApiEndpoints.facilitatorStartGame);
  }

  Future<void> pauseGame() async {
    await _api.post(ApiEndpoints.facilitatorPauseGame);
  }

  Future<void> continueGame() async {
    await _api.post(ApiEndpoints.facilitatorContinueGame);
  }

  Future<List<Shock>> fetchShocks() async {
    // API returns: {success, shocks: [...], count}
    final response = await _api.get(ApiEndpoints.shocksPredefined);
    final list = response['shocks'] as List<dynamic>? ?? response['data'] as List<dynamic>? ?? [];
    return list.map((e) => Shock.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> triggerShock(String shockId, {List<int>? teamIds, int? round}) async {
    await _api.post(ApiEndpoints.shocksTrigger, data: {
      'shockId': shockId,
      'teamIds': ?teamIds,
      'round': ?round,
    });
  }

  /// Trigger a facilitator-authored custom shock (matches the website's custom
  /// shock builder). The backend receives the full shock definition.
  Future<void> triggerCustomShock({
    required String name,
    required String description,
    required String category,
    required String severity,
    int? durationMinutes,
    String? hint,
  }) async {
    await _api.post(ApiEndpoints.shocksTrigger, data: {
      'custom': true,
      'name': name,
      'description': description,
      'category': category,
      'severity': severity,
      'durationMinutes': ?durationMinutes,
      'hint': ?hint,
    });
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

  /// Best-effort "clear all shocks" (deactivate + restore parameters).
  Future<bool> clearAllShocks() async {
    try {
      final res = await _api.post(ApiEndpoints.shocksClear);
      return res['success'] == true;
    } catch (_) {
      return false;
    }
  }

  Future<void> advanceRound() async {
    await _api.post(ApiEndpoints.facilitatorForceRound);
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

  Future<void> resetGame(String password) async {
    await _api.post(ApiEndpoints.facilitatorResetGame, data: {
      'password': password,
    });
  }

  Future<void> toggleGovEducation(bool enabled) async {
    await _api.post(ApiEndpoints.facilitatorToggleGovEd, data: {
      'enabled': enabled,
    });
  }

  Future<void> toggleGovModule(int moduleId, bool enabled) async {
    await _api.post(ApiEndpoints.facilitatorToggleGovModule, data: {
      'moduleId': moduleId,
      'enabled': enabled,
    });
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

  Future<Map<String, dynamic>> toggleSiteAccess(bool enabled) async {
    return await _api.post(ApiEndpoints.facilitatorSiteAccess, data: {
      'enabled': enabled,
    });
  }

  Future<Map<String, dynamic>> toggleCorporateMode(bool enabled) async {
    return await _api.post(ApiEndpoints.facilitatorCorporateMode, data: {
      'enabled': enabled,
    });
  }

  Future<Map<String, dynamic>> gameControl(String action) async {
    return await _api.post(ApiEndpoints.facilitatorGameControl, data: {
      'action': action,
    });
  }

  Future<Map<String, dynamic>> toggleLobby(bool open) async {
    return await _api.post(ApiEndpoints.facilitatorLobbyStatus, data: {
      'open': open,
    });
  }

  Future<Map<String, dynamic>> getTeamSignins() async {
    try {
      final response = await _api.get(ApiEndpoints.facilitatorTeamSignin);
      return response;
    } catch (_) {
      // Fallback to teams-status if team-signin endpoint doesn't exist
      return await _api.get(ApiEndpoints.facilitatorTeamsStatus);
    }
  }

  Future<List<dynamic>> getLeaderboard() async {
    return await _api.getList(ApiEndpoints.sheetsLeaderboard);
  }

  Future<void> showQr() async {
    await _api.post(ApiEndpoints.facilitatorQrShow);
  }

  Future<void> hideQr() async {
    await _api.post(ApiEndpoints.facilitatorQrHide);
  }

  Future<Map<String, dynamic>> getAllDecisions() async {
    final response = await _api.get(ApiEndpoints.facilitatorAllDecisions);
    if (response['success'] == true) {
      return response['data'] as Map<String, dynamic>;
    }
    throw Exception(response['error'] ?? 'Failed to get decisions');
  }

  Future<void> forceRound(int round) async {
    await _api.post(ApiEndpoints.facilitatorForceRound, data: {'round': round});
  }

  Future<void> forceModule(String module) async {
    await _api.post(ApiEndpoints.facilitatorForceModule, data: {'module': module});
  }

  Future<void> unlockDecisions() async {
    await _api.post(ApiEndpoints.decisionsUnlock);
  }

  Future<void> refreshExcelCache() async {
    await _api.post(ApiEndpoints.cacheClear);
  }

  Future<Map<String, dynamic>> runHealthCheck(String endpoint) async {
    return await _api.get(endpoint);
  }

  Future<void> removePlayer(String playerName, String teamId) async {
    await _api.post(ApiEndpoints.facilitatorRemoveSignin, data: {
      'playerName': playerName,
      'teamId': teamId,
    });
  }

  // ── Timer overlay broadcast (best-effort) ──
  /// Show the live timer overlay on every participant screen.
  Future<void> showTimerOverlay() async {
    try {
      await _api.post('/facilitator/timer-show');
    } catch (_) {/* best-effort */}
  }

  /// Hide the live timer overlay on every participant screen.
  Future<void> hideTimerOverlay() async {
    try {
      await _api.post('/facilitator/timer-hide');
    } catch (_) {/* best-effort */}
  }

  // ── Covenant threshold overrides ──
  /// Override the covenant thresholds (max leverage / min coverage).
  /// Returns true on success, false on failure (best-effort).
  Future<bool> setCovenantThresholds({
    required double maxLeverage,
    required double minCoverage,
  }) async {
    try {
      final res = await _api.post('/facilitator/covenant-thresholds', data: {
        'maxLeverage': maxLeverage,
        'minCoverage': minCoverage,
      });
      return res['success'] != false;
    } catch (_) {
      return false;
    }
  }

  // ── Budget / team constraints ──
  /// Set the budget constraint for a difficulty level (best-effort).
  Future<bool> setTeamConstraints({
    required String level,
    required double budget,
  }) async {
    try {
      final res = await _api.post('/facilitator/constraints', data: {
        'level': level,
        'budget': budget,
      });
      return res['success'] != false;
    } catch (_) {
      return false;
    }
  }

  // ── Excel worksheet viewer ──
  /// Fetch the raw Excel workbook data (direct read).
  Future<Map<String, dynamic>> fetchExcelData() async {
    return await _api.get('/excel/direct');
  }

  // ── Scenario results visibility ──
  /// Toggle whether scenario results are shown to learners (best-effort).
  Future<void> setScenarioResultsVisible(bool visible) async {
    try {
      await _api.post('/facilitator/scenario-results', data: {'visible': visible});
    } catch (_) {/* best-effort */}
  }

  // ── Education progress reset ──
  /// Clear all education progress for all teams. Returns true on success
  /// (best-effort).
  Future<bool> clearEducationProgress() async {
    try {
      final res = await _api.post('/facilitator/clear-education-progress');
      return res['success'] != false;
    } catch (_) {
      return false;
    }
  }
}
