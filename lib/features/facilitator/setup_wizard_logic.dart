/// Pure rules behind the Session Setup Wizard (website client/src/pages/facilitator-setup.tsx,
/// e1de68a, af1865b, 6031819, 77a7016). Kept free of Flutter so it can be unit tested.
library;

import 'dart:convert';

enum StepStatus { green, amber, pending }

/// Same storage key and layout version as the website (there it lives in sessionStorage).
const String wizardStorageKey = 'finplay-setup-wizard-v1';
const int wizardLayoutVersion = 3;

/// Manual run-of-show ticks of the Checklist step (kept separate from step confirmations).
const String sessionChecklistKey = 'finplay-session-checklist-v1';

/// Research-archive batch id of the last fresh start run from this device.
const String lastArchiveKey = 'finplay-last-archive-batch';

const int wizardStepCount = 10;

class WizardState {
  final int activeStep;
  final Map<String, bool> confirmed; // steps 2, 3, 6, 7, 8
  final String cohortChoice; // 'main' or a cohort subdomain
  final int timerMinutes;

  const WizardState({
    this.activeStep = 1,
    this.confirmed = const {},
    this.cohortChoice = '',
    this.timerMinutes = 20,
  });

  WizardState copyWith({int? activeStep, Map<String, bool>? confirmed, String? cohortChoice, int? timerMinutes}) =>
      WizardState(
        activeStep: activeStep ?? this.activeStep,
        confirmed: confirmed ?? this.confirmed,
        cohortChoice: cohortChoice ?? this.cohortChoice,
        timerMinutes: timerMinutes ?? this.timerMinutes,
      );

  bool isConfirmed(int step) => confirmed['$step'] == true;

  WizardState withConfirmed(int step, bool value) =>
      copyWith(confirmed: {...confirmed, '$step': value});

  String toJsonString() => jsonEncode({
        'version': wizardLayoutVersion,
        'activeStep': activeStep,
        'confirmed': confirmed,
        'cohortChoice': cohortChoice,
        'timerMinutes': timerMinutes,
      });

  /// Website loadWizardState: state from an older layout keeps only the timer setting.
  static WizardState fromJsonString(String? raw) {
    if (raw == null) return const WizardState();
    try {
      final p = jsonDecode(raw);
      if (p is! Map) return const WizardState();
      final timer = p['timerMinutes'] is num ? (p['timerMinutes'] as num).toInt() : 20;
      if (p['version'] != wizardLayoutVersion) return WizardState(timerMinutes: timer);
      final conf = p['confirmed'];
      return WizardState(
        activeStep: p['activeStep'] is num ? (p['activeStep'] as num).toInt() : 1,
        confirmed: conf is Map ? {for (final e in conf.entries) e.key.toString(): e.value == true} : const {},
        cohortChoice: p['cohortChoice'] is String ? p['cohortChoice'] as String : '',
        timerMinutes: timer,
      );
    } catch (_) {
      return const WizardState();
    }
  }
}

/// Website SUBDOMAIN_RE for the provision form.
final RegExp wizardSubdomainRe = RegExp(r'^[a-z0-9](?:[a-z0-9-]{0,38}[a-z0-9])?$');

/// Step 1: API up, database healthy, financial engine online.
///
/// GET /api/health (server/routes/health.ts) answers `{status: ok|degraded, services:
/// {database: {status}, cache: {status}}}`, with HTTP 503 whenever status is not 'ok'. It
/// reports 'degraded' both for a database outage and for an unhealthy in-memory cache
/// alone; the cache does not block a session, so 'degraded' with a healthy database counts
/// as up. (The 503 body still arrives: ApiClient.get returns error bodies.)
({bool api, bool db, bool engine}) systemChecks(Map<String, dynamic> health, Map<String, dynamic> conn) {
  final services = health['services'];
  final dbStatus = services is Map && services['database'] is Map ? (services['database'] as Map)['status'] : null;
  final dbOk = dbStatus == 'healthy';
  final status = health['status'];
  return (api: status == 'ok' || (status == 'degraded' && dbOk), db: dbOk, engine: conn['mode'] == 'online');
}

/// Step 4 verification: the environment is clean for a new session.
class FreshStartChecks {
  final bool round; // Round 1 · Financing
  final bool decisions; // zero decisions on record
  final bool teamRounds; // every team at Round 1
  final bool shocks; // zero active shocks
  final bool forecasts; // zero open forecasts
  final bool leaders; // zero leaders
  final int teamCount;
  final int decisionCount;
  final int shockCount;
  final int forecastCount;
  final int leaderCount;

  const FreshStartChecks({
    required this.round,
    required this.decisions,
    required this.teamRounds,
    required this.shocks,
    required this.forecasts,
    required this.leaders,
    required this.teamCount,
    required this.decisionCount,
    required this.shockCount,
    required this.forecastCount,
    required this.leaderCount,
  });

  bool get allClean => round && decisions && teamRounds && shocks && forecasts && leaders;

  factory FreshStartChecks.from({
    required Map<String, dynamic> roundState,
    required List<Map<String, dynamic>>? teams,
    required Map<String, dynamic> activeShocks,
    required int? forecastCount,
    required Map<String, dynamic> teamLeaders,
  }) {
    final t = teams ?? const [];
    final decisionCount = t.fold<int>(0, (n, x) => n + ((x['totalDecisions'] as num?)?.toInt() ?? 0));
    final shockCount = (activeShocks['count'] as num?)?.toInt() ??
        ((activeShocks['shocks'] is List) ? (activeShocks['shocks'] as List).length : 0);
    final leaders = teamLeaders['leaders'];
    final leaderCount = leaders is Map ? leaders.length : 0;
    return FreshStartChecks(
      round: roundState['roundNum'] == 1 && roundState['module'] == 'financing',
      decisions: teams != null && decisionCount == 0,
      teamRounds: teams != null && t.every((x) => ((x['currentRound'] as num?)?.toInt() ?? 1) == 1),
      shocks: activeShocks.isNotEmpty && shockCount == 0,
      forecasts: forecastCount != null && forecastCount == 0,
      leaders: teamLeaders.isNotEmpty && leaderCount == 0,
      teamCount: t.length,
      decisionCount: decisionCount,
      shockCount: shockCount,
      forecastCount: forecastCount ?? 0,
      leaderCount: leaderCount,
    );
  }
}

/// Expected base-parameter defaults (model_assumptions provenance rows 2-13).
const List<(String, String, String, double)> expectedModelParams = [
  ('salesGrowth', 'Sales Growth', 'نمو المبيعات', 0.1),
  ('taxRate', 'Tax Rate', 'معدل الضريبة', 0.2),
  ('interestExpenseRate', 'Interest Expense', 'مصروف الفائدة', 0.07),
];

/// Step 5: the base model rows (Round 1, Excel rows 2-13) and whether they look right.
class ModelIntegrity {
  final List<Map<String, dynamic>> baseRows; // sorted by excelRow
  final double? salesGrowth;
  final List<(String, String, String, double)> mismatches;
  const ModelIntegrity(this.baseRows, this.salesGrowth, this.mismatches);

  bool get baseRowsPresent => baseRows.length >= 12;
  bool get nonDegenerate => salesGrowth != null && salesGrowth != 0;
  bool get ok => baseRowsPresent && nonDegenerate && mismatches.isEmpty;

  double? valueOf(String key) {
    for (final r in baseRows) {
      if (r['paramKey'] == key && r['value'] != null) return double.tryParse(r['value'].toString());
    }
    return null;
  }

  factory ModelIntegrity.from(List<dynamic> assumptions) {
    final rows = assumptions
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .where((r) {
          final row = (r['excelRow'] as num?)?.toInt();
          return r['round'] == 1 && row != null && row >= 2 && row <= 13;
        })
        .toList()
      ..sort((a, b) => ((a['excelRow'] as num?) ?? 0).compareTo((b['excelRow'] as num?) ?? 0));
    final probe = ModelIntegrity(rows, null, const []);
    final mismatches = [
      for (final p in expectedModelParams)
        if (probe.valueOf(p.$1) == null || (probe.valueOf(p.$1)! - p.$4).abs() > 1e-9) p,
    ];
    return ModelIntegrity(rows, probe.valueOf('salesGrowth'), mismatches);
  }
}

/// Realism flags on step 6, in the website's order: (flag, title, titleAr, subtitle, subtitleAr).
const List<(String, String, String, String, String)> wizardRealismModules = [
  ('workingCapitalEnabled', 'Working Capital', 'رأس المال العامل', 'DSO · DPO · DIO · CCC', 'DSO · DPO · DIO · CCC'),
  ('duPontEnabled', 'Du Pont Decomposition', 'تحليل دوبونت', 'ROE 3-factor breakdown', 'تفكيك العائد على حقوق الملكية إلى 3 عوامل'),
  ('waccEnabled', 'WACC Tracker', 'متابعة المتوسط المرجّح لتكلفة رأس المال', 'Weighted average cost of capital', 'المتوسط المرجّح لتكلفة رأس المال'),
  ('creditRatingEnabled', 'Credit Rating Engine', 'محرّك التصنيف الائتماني', 'Synthetic AAA → C', 'تصنيف تركيبي من AAA إلى C'),
  ('debtCovenantsEnabled', 'Debt Covenants', 'تعهّدات الدين', 'Maintenance thresholds', 'حدود الالتزام'),
  ('capTableEnabled', 'Cap Table & Dilution', 'جدول الملكية والتخفيف', 'Equity ownership', 'ملكية حقوق المساهمين'),
  ('dividendPolicyEnabled', 'Dividend Policy', 'سياسة التوزيعات', 'Payout vs reinvest', 'التوزيع مقابل إعادة الاستثمار'),
  (
    'memberRecommendationsEnabled',
    'Member recommendations (research)',
    'توصيات الأعضاء (بحث)',
    'Each member commits an amount before the leader decides',
    'يلتزم كل عضو بمبلغ قبل أن يقرّر القائد',
  ),
];

const List<(String, String, String, String, String)> wizardRatioModules = [
  ('ratiosLiquidityEnabled', 'Liquidity Ratios', 'نسب السيولة', 'Current · Quick · Cash', 'المتداولة · السريعة · النقدية'),
  ('ratiosEfficiencyEnabled', 'Efficiency Ratios', 'نسب الكفاءة', 'Inventory · Receivables · Turnover', 'المخزون · الذمم المدينة · الدوران'),
  ('ratiosProfitabilityEnabled', 'Profitability Ratios', 'نسب الربحية', 'Margins · ROA · ROE', 'الهوامش · العائد على الأصول · العائد على حقوق الملكية'),
  ('ratiosSolvencyEnabled', 'Solvency Ratios', 'نسب الملاءة', 'D/E · Coverage', 'الدين إلى حقوق الملكية · التغطية'),
  ('ratiosMarketEnabled', 'Market Ratios', 'نسب السوق', 'EPS · P/E · M/B', 'ربحية السهم · مكرر الربحية · السوقية إلى الدفترية'),
];

/// The lobby link for the session: the chosen cohort's address, else [fallbackOrigin].
String wizardLobbyUrl(String? cohortUrl, String fallbackOrigin) {
  if (cohortUrl == null || cohortUrl.isEmpty) return '${fallbackOrigin.replaceAll(RegExp(r'/+$'), '')}/lobby';
  final withScheme = RegExp(r'^https?://', caseSensitive: false).hasMatch(cohortUrl) ? cohortUrl : 'https://$cohortUrl';
  return '${withScheme.replaceAll(RegExp(r'/+$'), '')}/lobby';
}

/// Delivery run-of-show on the Checklist step: (slug, English, Arabic). Condition-aware,
/// fixed order, as on the website.
List<(String, String, String)> wizardRunOfShow({
  required String lobbyUrl,
  required bool memberRecommendations,
  required bool preAssessmentMandated,
}) =>
    [
      (
        'open-lobby',
        'Open the lobby and share the URL with participants ($lobbyUrl)',
        'افتح الردهة وشارك الرابط مع المشاركين ($lobbyUrl)',
      ),
      ('participants-joined', 'All participants joined and roles claimed', 'انضمّ جميع المشاركين واختاروا أدوارهم'),
      ('leaders-selected', 'Team leaders selected for every team', 'اختير قائد لكل فريق'),
      if (memberRecommendations)
        (
          'member-recommendations',
          'Each member commits recommendations before leaders confirm',
          'يلتزم كل عضو بتوصياته قبل أن يؤكّد القادة',
        ),
      (
        'leaders-confirm-modules',
        'Leaders confirm each module (Financing → Investing → Operating)',
        'يؤكّد القادة كل وحدة (التمويل ← الاستثمار ← التشغيل)',
      ),
      if (preAssessmentMandated)
        ('pre-assessment', 'Pre-assessment completed before play', 'أُكمل التقييم القبلي قبل اللعب'),
      ('publish-forecast', 'Publish market forecast before Round 2', 'انشر توقّع السوق قبل الجولة 2'),
      ('insurance-window', 'Open the insurance decision window', 'افتح نافذة قرار التأمين'),
      ('trigger-shock', 'Trigger the market shock', 'فعّل صدمة السوق'),
      ('round-debriefs', 'Round debriefs and podium after each round', 'نقاش ختامي ومنصّة تتويج بعد كل جولة'),
      ('advance-rounds', 'Advance rounds (1 → 2 → 3)', 'تقدّم في الجولات (1 ← 2 ← 3)'),
      ('post-assessment', 'Post-assessment completed', 'أُكمل التقييم البعدي'),
      ('certificates', 'Certificates claimed by participants', 'استلم المشاركون شهاداتهم'),
      ('research-export', 'Research export downloaded', 'نُزّل تصدير البحث'),
    ];
