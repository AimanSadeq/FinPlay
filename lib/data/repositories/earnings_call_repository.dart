import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';

/// Earnings Call — the post-Round-2 event where each team's "CFO" presents its
/// results to the room (website parity with server/routes/earnings-call.ts).
///
/// Stages are facilitator-driven: off → prep → live. Teams poll [status]; during
/// prep they build their story from [teamPayload]; during live they answer the
/// released analyst questions and rate the other teams' presentations.
class EarningsCallRepository {
  EarningsCallRepository(this._api);

  final ApiClient _api;

  /// Teams that take part in the call — the server rejects anything else.
  static const List<String> teams = [
    'Team 1',
    'Team 2',
    'Team 3',
    'Team 4',
    'Team 5',
    'Team 6',
    'Team 7',
  ];

  /// { stage: off|prep|live, round, prepMinutes, prepEndsAt, startedAt }
  Future<Map<String, dynamic>> status() async {
    return _api.get(ApiEndpoints.earningsCallStatus);
  }

  /// The presentation payload: R1-vs-R2 statements, ratios, decisions, shocks and
  /// rule-based talking points — the same data the AI analyst was prompted with.
  Future<Map<String, dynamic>?> teamPayload(String teamId) async {
    final res = await _api.get(
      '${ApiEndpoints.earningsCallTeam}/${Uri.encodeComponent(teamId)}',
    );
    if (res['success'] != true) return null;
    final data = res['data'];
    return data is Map ? Map<String, dynamic>.from(data) : null;
  }

  /// Released analyst questions for a team, flattened across question sets. Each
  /// item carries the team's typed answer and the AI critique of it when present.
  Future<List<Map<String, dynamic>>> releasedQuestions(String teamId) async {
    final res = await _api.get(
      '${ApiEndpoints.earningsCallQuestions}/${Uri.encodeComponent(teamId)}',
    );
    if (res['success'] != true) return [];
    final sets = res['data'];
    if (sets is! List) return [];
    return sets
        .whereType<Map>()
        .expand((s) => (s['questions'] as List? ?? const []))
        .whereType<Map>()
        .map((q) => Map<String, dynamic>.from(q))
        .toList();
  }

  /// Save the team's typed official response to one released question.
  /// Returns null on success, or the server's error message.
  Future<String?> submitAnswer({
    required String teamId,
    required int questionIndex,
    required String answerText,
  }) async {
    final res = await _api.post(ApiEndpoints.earningsCallAnswer, data: {
      'teamId': teamId,
      'questionIndex': questionIndex,
      'answerText': answerText,
    });
    if (res['success'] == true) return null;
    return res['error']?.toString() ?? 'Failed to save answer';
  }

  /// Ask the AI analyst to critique the answer just submitted. Returns
  /// { en, ar } feedback, or throws with the server's reason.
  Future<({String en, String ar})> answerFeedback({
    required String teamId,
    required int questionIndex,
  }) async {
    final res = await _api.post(
      '${ApiEndpoints.earningsCallAnswer}/${Uri.encodeComponent(teamId)}/$questionIndex/feedback',
    );
    if (res['success'] != true) {
      throw Exception(res['error']?.toString() ?? 'Feedback unavailable');
    }
    final data = Map<String, dynamic>.from(res['data'] as Map? ?? {});
    return (
      en: data['aiFeedbackEn']?.toString() ?? '',
      ar: data['aiFeedbackAr']?.toString() ?? '',
    );
  }

  /// Rate another team's presentation (1–5 each). Upserted per round + presenter
  /// + rater, so re-submitting updates the same row. Live stage only.
  Future<String?> ratePresentation({
    required String presenterTeamId,
    required String raterTeamId,
    required int clarity,
    required int insight,
    required int confidence,
    String? raterPlayerName,
    String? comment,
  }) async {
    final res = await _api.post(ApiEndpoints.earningsCallFeedback, data: {
      'presenterTeamId': presenterTeamId,
      'raterTeamId': raterTeamId,
      'clarity': clarity,
      'insight': insight,
      'confidence': confidence,
      if (raterPlayerName != null && raterPlayerName.isNotEmpty)
        'raterPlayerName': raterPlayerName,
      if (comment != null && comment.isNotEmpty) 'comment': comment,
    });
    if (res['success'] == true) return null;
    return res['error']?.toString() ?? 'Failed to save rating';
  }

  /// Average peer scores per presenting team (highest overall first).
  Future<List<Map<String, dynamic>>> feedbackSummary() async {
    final res = await _api.get(ApiEndpoints.earningsCallFeedbackSummary);
    final data = res['data'];
    if (data is! List) return [];
    return data.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }

  // ── Facilitator ───────────────────────────────────────────────────────────

  /// Move the call through off → prep → live. Entering prep starts the countdown.
  Future<Map<String, dynamic>> setStage({
    required String stage,
    int prepMinutes = 30,
    int round = 2,
  }) async {
    return _api.post(ApiEndpoints.earningsCallStage, data: {
      'stage': stage,
      'prepMinutes': prepMinutes,
      'round': round,
    });
  }

  /// Generate three analyst questions for a team — saved as a DRAFT for review.
  Future<Map<String, dynamic>> generateQuestions(String teamId) async {
    return _api.post(
      '${ApiEndpoints.earningsCallQuestions}/${Uri.encodeComponent(teamId)}/generate',
    );
  }

  /// Every question set (drafts + released) for the facilitator panel.
  Future<List<Map<String, dynamic>>> allQuestions() async {
    final res = await _api.get(ApiEndpoints.earningsCallQuestions);
    final data = res['data'];
    if (data is! List) return [];
    return data.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }

  /// Release a draft set to the team (or pull it back with released: false).
  Future<Map<String, dynamic>> releaseQuestions(String setId, {bool released = true}) async {
    return _api.post(
      '${ApiEndpoints.earningsCallQuestions}/${Uri.encodeComponent(setId)}/release',
      data: {'released': released},
    );
  }

  /// The facilitator rubric — the human evaluation of record for live answers.
  Future<String?> saveFacilitatorScore({
    required String teamId,
    required int explainsWhy,
    required int usesNumbers,
    required int guidance,
    String? comment,
  }) async {
    final res = await _api.post(ApiEndpoints.earningsCallFacilitatorScore, data: {
      'teamId': teamId,
      'explainsWhy': explainsWhy,
      'usesNumbers': usesNumbers,
      'guidance': guidance,
      if (comment != null && comment.isNotEmpty) 'comment': comment,
    });
    if (res['success'] == true) return null;
    return res['error']?.toString() ?? 'Failed to save score';
  }

  Future<List<Map<String, dynamic>>> facilitatorScores() async {
    final res = await _api.get(ApiEndpoints.earningsCallFacilitatorScores);
    final data = res['data'];
    if (data is! List) return [];
    return data.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }
}
