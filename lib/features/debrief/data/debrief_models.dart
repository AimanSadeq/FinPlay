/// Models for the debrief API (website server/routes/debrief.ts, mounted at /api/debrief).
library;

double _num(Object? v) {
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v) ?? 0;
  return 0;
}

/// One confirmed decision and how much it moved the round's Net Income (counterfactual
/// engine re-run without that decision).
class WaterfallItem {
  final String scenarioId;
  final String module; // financing | investing | operating
  final String title;
  final double amount;
  final double contribution;

  const WaterfallItem({
    required this.scenarioId,
    required this.module,
    required this.title,
    required this.amount,
    required this.contribution,
  });

  factory WaterfallItem.fromJson(Map<String, dynamic> json) => WaterfallItem(
        scenarioId: json['scenarioId']?.toString() ?? '',
        module: json['module']?.toString() ?? '',
        title: json['title']?.toString() ?? '',
        amount: _num(json['amount']),
        contribution: _num(json['contribution']),
      );
}

/// GET /api/debrief/waterfall?teamId=&round= (corporate) or
/// GET /api/debrief/self-paced/waterfall?round= (Bearer):
/// `{success, round, start, end, items:[...], residual}`.
class WaterfallData {
  final int round;
  final double start;
  final double end;
  final List<WaterfallItem> items;
  final double residual;

  const WaterfallData({
    required this.round,
    required this.start,
    required this.end,
    required this.items,
    required this.residual,
  });

  factory WaterfallData.fromJson(Map<String, dynamic> json) => WaterfallData(
        round: (json['round'] as num?)?.toInt() ?? 0,
        start: _num(json['start']),
        end: _num(json['end']),
        items: [
          for (final e in (json['items'] as List? ?? const []))
            if (e is Map) WaterfallItem.fromJson(Map<String, dynamic>.from(e)),
        ],
        residual: _num(json['residual']),
      );
}

/// The coach's three-part debrief.
class DebriefContent {
  final String summary;
  final List<String> drivers;
  final List<String> questions;

  const DebriefContent({required this.summary, required this.drivers, required this.questions});

  factory DebriefContent.fromJson(Map<String, dynamic> json) => DebriefContent(
        summary: json['summary']?.toString() ?? '',
        drivers: [for (final d in (json['drivers'] as List? ?? const [])) d.toString()],
        questions: [for (final q in (json['questions'] as List? ?? const [])) q.toString()],
      );
}

enum CoachStatus { ok, notConfigured, failed }

/// POST /api/debrief/coach {teamId, round, language} or
/// POST /api/debrief/self-paced/coach {round, language} (Bearer):
/// `{success, round, language, cached, debrief:{summary, drivers, questions}}`, or
/// `{success:false, error:'AI provider not configured'}` (HTTP 200) when no AI provider.
class CoachResult {
  final CoachStatus status;
  final DebriefContent? debrief;
  final bool cached;
  final String language;

  const CoachResult({
    required this.status,
    this.debrief,
    this.cached = false,
    this.language = 'en',
  });

  static const notConfiguredError = 'AI provider not configured';

  factory CoachResult.fromJson(Map<String, dynamic> json) {
    if (json['success'] == true && json['debrief'] is Map) {
      return CoachResult(
        status: CoachStatus.ok,
        debrief: DebriefContent.fromJson(Map<String, dynamic>.from(json['debrief'] as Map)),
        cached: json['cached'] == true,
        language: json['language']?.toString() == 'ar' ? 'ar' : 'en',
      );
    }
    if (json['error'] == notConfiguredError) {
      return const CoachResult(status: CoachStatus.notConfigured);
    }
    return const CoachResult(status: CoachStatus.failed);
  }
}
