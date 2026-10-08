import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/i18n/app_strings.dart';
import '../../../app/theme/app_colors.dart';
import '../../../data/repositories/facilitator_repository.dart';
import '../../../shared/widgets/glass_card.dart';

/// One teachable moment from POST /insights.
class FacilitatorInsight {
  final String id;
  final String type;
  final String severity; // critical | notable | info
  final String title;
  final String detail;
  final List<String> teams;
  final String discussionPrompt;

  const FacilitatorInsight({
    required this.id,
    required this.type,
    required this.severity,
    required this.title,
    required this.detail,
    required this.teams,
    required this.discussionPrompt,
  });

  factory FacilitatorInsight.fromJson(Map<String, dynamic> j) => FacilitatorInsight(
        id: (j['id'] ?? '').toString(),
        type: (j['type'] ?? '').toString(),
        severity: const {'critical', 'notable', 'info'}.contains(j['severity']) ? j['severity'] as String : 'info',
        title: (j['title'] ?? '').toString(),
        detail: (j['detail'] ?? '').toString(),
        teams: (j['teams'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
        discussionPrompt: (j['discussionPrompt'] ?? '').toString(),
      );
}

const List<String> insightSeverityOrder = ['critical', 'notable', 'info'];

/// Groups insights by severity in the website's order, dropping empty groups.
List<(String, List<FacilitatorInsight>)> groupInsights(List<FacilitatorInsight> all) => [
      for (final sev in insightSeverityOrder)
        if (all.any((i) => i.severity == sev)) (sev, all.where((i) => i.severity == sev).toList()),
    ];

/// The website's clampRound: a round outside 1-3 scans Round 1.
int clampInsightRound(int? r) => (r != null && r >= 1 && r <= 3) ? r : 1;

/// Facilitator Insights - "Teachable Moments" (website InsightsPanel.tsx): scans every
/// team's decisions and engine figures for a round (POST /insights) and surfaces
/// discussion-ready contrasts. The server writes the insight text in English.
class InsightsPanel extends ConsumerStatefulWidget {
  final FacilitatorRepository repo;
  final int? currentRound;
  const InsightsPanel({super.key, required this.repo, this.currentRound});

  @override
  ConsumerState<InsightsPanel> createState() => _InsightsPanelState();
}

class _InsightsPanelState extends ConsumerState<InsightsPanel> {
  late int _round = clampInsightRound(widget.currentRound);
  bool _roundTouched = false;
  bool _loading = false;
  String? _error;
  List<FacilitatorInsight> _insights = [];
  DateTime? _generatedAt;
  int? _scannedRound;
  String? _copiedId;

  @override
  void initState() {
    super.initState();
    _scan();
  }

  @override
  void didUpdateWidget(covariant InsightsPanel old) {
    super.didUpdateWidget(old);
    // Follow the live round until the facilitator picks one.
    final live = clampInsightRound(widget.currentRound);
    if (!_roundTouched && live != _round && widget.currentRound != old.currentRound) {
      _round = live;
      _scan();
    }
  }

  Future<void> _scan() async {
    setState(() { _loading = true; _error = null; });
    try {
      final res = await widget.repo.fetchInsights(_round);
      if (!mounted) return;
      setState(() {
        _insights = (res['insights'] as List<dynamic>? ?? [])
            .whereType<Map>()
            .map((e) => FacilitatorInsight.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        _generatedAt = DateTime.tryParse(res['generatedAt']?.toString() ?? '');
        _scannedRound = (res['round'] as num?)?.toInt() ?? _round;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _error = e is FacilitatorActionException
            ? e.message
            : ref.read(stringsProvider).tr('Failed to scan for insights', 'تعذّر البحث عن الملاحظات'));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  (Color, IconData, String) _style(AppStrings s, String sev) => switch (sev) {
        'critical' => (AppColors.dangerLight, Icons.warning_rounded, s.tr('Critical', 'حرجة')),
        'notable' => (AppColors.accentLight, Icons.error_outline_rounded, s.tr('Notable', 'لافتة')),
        _ => (AppColors.primaryLight, Icons.info_outline_rounded, s.tr('Info', 'معلومة')),
      };

  Future<void> _copy(FacilitatorInsight i) async {
    await Clipboard.setData(ClipboardData(text: i.discussionPrompt));
    if (!mounted) return;
    setState(() => _copiedId = i.id);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && _copiedId == i.id) setState(() => _copiedId = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final small = TextStyle(fontSize: 11, color: AppColors.textTertiary(context));
    final groups = groupInsights(_insights);
    return RefreshIndicator(
      onRefresh: _scan,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GlassCard(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.lightbulb_rounded, color: AppColors.accentLight),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(s.tr('Teachable Moments', 'لحظات تعليمية'),
                      style: Theme.of(context).textTheme.titleMedium),
                ),
              ]),
              const SizedBox(height: 10),
              Wrap(spacing: 8, runSpacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: [
                SegmentedButton<int>(
                  segments: [
                    for (final r in [1, 2, 3]) ButtonSegment(value: r, label: Text(s.tr('R$r', 'ج$r'))),
                  ],
                  selected: {_round},
                  showSelectedIcon: false,
                  onSelectionChanged: (sel) {
                    setState(() { _round = sel.first; _roundTouched = true; });
                    _scan();
                  },
                ),
                OutlinedButton.icon(
                  onPressed: _loading ? null : _scan,
                  icon: _loading
                      ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.refresh_rounded, size: 16),
                  label: Text(_loading ? s.tr('Scanning…', 'جارٍ البحث…') : s.tr('Scan for insights', 'ابحث عن ملاحظات')),
                ),
              ]),
              if (_generatedAt != null) ...[
                const SizedBox(height: 6),
                Text(
                  s.tr(
                    'Round ${_scannedRound ?? _round} · generated ${TimeOfDay.fromDateTime(_generatedAt!.toLocal()).format(context)}',
                    'الجولة ${_scannedRound ?? _round} · أُنشئت ${TimeOfDay.fromDateTime(_generatedAt!.toLocal()).format(context)}',
                  ),
                  style: small,
                ),
              ],
              if (s.ar) ...[
                const SizedBox(height: 4),
                Text('نص الملاحظات يصدر عن الخادم بالإنجليزية.', style: small),
              ],
            ]),
          ),
          const SizedBox(height: 12),
          if (_error != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.danger.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.dangerLight.withValues(alpha: 0.4)),
              ),
              child: Text(_error!, style: const TextStyle(color: AppColors.dangerLight, fontSize: 13)),
            ),
          if (_error == null && !_loading && _insights.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(children: [
                Icon(Icons.lightbulb_outline_rounded, size: 36, color: AppColors.textTertiary(context)),
                const SizedBox(height: 8),
                Text(
                  s.tr('No teachable moments detected yet — let teams make some decisions.',
                      'لم تُرصد لحظات تعليمية بعد — دع الفرق تتخذ بعض القرارات.'),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textTertiary(context)),
                ),
              ]),
            ),
          for (final (sev, items) in groups) ...[
            Builder(builder: (context) {
              final (color, icon, label) = _style(s, sev);
              return Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 8),
                child: Row(children: [
                  Icon(icon, size: 16, color: color),
                  const SizedBox(width: 6),
                  Text('${label.toUpperCase()} (${items.length})',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color)),
                ]),
              );
            }),
            ...items.map((i) => _insightCard(s, i)),
          ],
        ],
      ),
    );
  }

  Widget _insightCard(AppStrings s, FacilitatorInsight i) {
    final (color, icon, _) = _style(s, i.severity);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardColor(context),
          borderRadius: BorderRadius.circular(10),
          border: Border(
            left: BorderSide(color: color, width: 4),
            top: BorderSide(color: AppColors.borderColor(context)),
            right: BorderSide(color: AppColors.borderColor(context)),
            bottom: BorderSide(color: AppColors.borderColor(context)),
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(i.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 4),
              Text(i.detail, style: TextStyle(fontSize: 13, color: AppColors.textSecondary(context))),
              if (i.teams.isNotEmpty) ...[
                const SizedBox(height: 6),
                Wrap(spacing: 6, runSpacing: 4, children: [
                  for (final t in i.teams)
                    Chip(label: Text(t, style: const TextStyle(fontSize: 11)), visualDensity: VisualDensity.compact),
                ]),
              ],
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 8, 4, 8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: color.withValues(alpha: 0.3)),
                ),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('💡 ${s.tr('Discussion prompt', 'سؤال للنقاش')}',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textTertiary(context))),
                      const SizedBox(height: 2),
                      Text(i.discussionPrompt, style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic)),
                    ]),
                  ),
                  IconButton(
                    tooltip: s.tr('Copy prompt', 'نسخ السؤال'),
                    visualDensity: VisualDensity.compact,
                    onPressed: () => _copy(i),
                    icon: Icon(_copiedId == i.id ? Icons.check_rounded : Icons.copy_rounded,
                        size: 16, color: _copiedId == i.id ? AppColors.secondaryLight : null),
                  ),
                ]),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
