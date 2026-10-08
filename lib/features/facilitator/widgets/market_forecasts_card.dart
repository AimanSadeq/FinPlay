import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/i18n/app_strings.dart';
import '../../../app/theme/app_colors.dart';
import '../../../data/repositories/facilitator_repository.dart';
import '../../../shared/widgets/glass_card.dart';
import '../poll_visibility.dart';

/// The headline the website pre-fills when a real shock is hinted. Always English: it is
/// sent as `headline`, and the server fills `headlineAr` from its own map for a known shock.
String defaultForecastHeadline(Map<String, dynamic> shock) {
  final fh = shock['forecastHeadline'];
  if (fh is String && fh.trim().isNotEmpty) return fh;
  return 'Market watchers see early signs pointing toward: ${shock['name'] ?? ''}';
}

/// Severity hint the website picks for a hinted shock: its own, but critical maps to high.
String forecastSeverityFor(String? shockSeverity) =>
    const {'low', 'medium', 'high'}.contains(shockSeverity) ? shockSeverity! : 'high';

String _timeAgo(AppStrings s, String? iso) {
  final t = DateTime.tryParse(iso ?? '');
  if (t == null) return '';
  final secs = DateTime.now().difference(t).inSeconds;
  if (secs < 60) return s.tr('just now', 'الآن');
  final mins = secs ~/ 60;
  if (mins < 60) return s.tr('${mins}m ago', 'قبل $mins د');
  final hours = mins ~/ 60;
  if (hours < 24) return s.tr('${hours}h ago', 'قبل $hours س');
  return s.tr('${hours ~/ 24}d ago', 'قبل ${hours ~/ 24} يوم');
}

/// Market Forecasts (website ShockTriggerPanel "news ticker publisher"): publish a
/// forward-looking headline that hints at a real shock (auto-resolves when it triggers) or
/// plants a red herring, see how many teams insured against each (GET
/// /hedges/forecast/:id), and resolve forecasts by hand.
class MarketForecastsCard extends ConsumerStatefulWidget {
  final FacilitatorRepository repo;
  final int currentRound;
  const MarketForecastsCard({super.key, required this.repo, required this.currentRound});

  @override
  ConsumerState<MarketForecastsCard> createState() => _MarketForecastsCardState();
}

class _MarketForecastsCardState extends ConsumerState<MarketForecastsCard> {
  List<Map<String, dynamic>> _shocks = [];
  List<Map<String, dynamic>> _forecasts = [];
  final Map<String, ({int count, List<String> teamIds})> _insured = {};
  String _shockId = 'custom';
  String _severity = 'none';
  late int _round = widget.currentRound.clamp(1, 3);
  final _headline = TextEditingController();
  bool _busy = false;
  Timer? _poll;

  @override
  void initState() {
    super.initState();
    _headline.addListener(() => setState(() {}));
    widget.repo.fetchPredefinedShockRows().then((rows) {
      if (mounted) setState(() => _shocks = rows);
    });
    _refresh();
    // The website refetches the insured counts every 15 s.
    _poll = Timer.periodic(const Duration(seconds: 15), (_) {
      if (isPollVisible(this)) _refresh();
    });
  }

  @override
  void dispose() {
    _poll?.cancel();
    _headline.dispose();
    super.dispose();
  }

  bool _refreshing = false;

  Future<void> _refresh() async {
    if (_refreshing) return;
    _refreshing = true;
    try {
      final list = await widget.repo.fetchForecasts();
      if (!mounted) return;
      setState(() => _forecasts = list);
      for (final f in list) {
        final id = f['id']?.toString();
        if (id == null) continue;
        final ins = await widget.repo.fetchForecastInsurance(id);
        if (mounted) setState(() => _insured[id] = ins);
      }
    } catch (_) {
    } finally {
      _refreshing = false;
    }
  }

  void _pickShock(AppStrings s, String value) {
    setState(() {
      _shockId = value;
      if (value == 'custom') {
        _headline.clear();
        return;
      }
      final shock = _shocks.firstWhere((x) => x['id'] == value, orElse: () => {});
      if (shock.isEmpty) return;
      _headline.text = defaultForecastHeadline(shock);
      _severity = forecastSeverityFor(shock['severity']?.toString());
    });
  }

  void _toast(String msg, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: error ? AppColors.danger : AppColors.secondary));
  }

  Future<void> _publish(AppStrings s) async {
    setState(() => _busy = true);
    try {
      final res = await widget.repo.publishForecast(
        shockId: _shockId == 'custom' ? null : _shockId,
        headline: _headline.text,
        roundNum: _round,
        severityHint: _severity == 'none' ? null : _severity,
      );
      if (!mounted) return;
      _toast('📰 ${s.tr('Forecast Published', 'نُشر التوقّع')}: ${(res['forecast'] as Map?)?['headline'] ?? ''}');
      setState(() {
        _headline.clear();
        _shockId = 'custom';
        _severity = 'none';
      });
      await _refresh();
    } catch (e) {
      _toast(e is FacilitatorActionException ? e.message : s.tr('Failed to publish forecast', 'تعذّر نشر التوقّع'),
          error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _resolve(AppStrings s, String id) async {
    setState(() => _busy = true);
    try {
      await widget.repo.resolveForecast(id);
      _toast(s.tr('Forecast Resolved', 'تمت تسوية التوقّع'));
      await _refresh();
    } catch (e) {
      _toast(e is FacilitatorActionException ? e.message : s.tr('Failed to resolve forecast', 'تعذّرت تسوية التوقّع'),
          error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Color _dot(String? sev) => switch (sev) {
        'low' => Colors.grey,
        'medium' => AppColors.accentLight,
        'high' => AppColors.dangerLight,
        _ => Colors.grey,
      };

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final small = TextStyle(fontSize: 11, color: AppColors.textTertiary(context));
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.newspaper_rounded, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(s.tr('Market Forecasts', 'توقّعات السوق'), style: Theme.of(context).textTheme.titleMedium)),
          if (_forecasts.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.accentLight.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(s.tr('${_forecasts.length} on the wire', '${_forecasts.length} على الشريط'),
                  style: const TextStyle(fontSize: 11, color: AppColors.accentLight)),
            ),
        ]),
        const SizedBox(height: 4),
        Text(
          s.tr(
            'Publish forward-looking headlines to the teams\' news ticker. Hint at a real upcoming shock (its forecasts auto-resolve when you trigger it) or plant a red herring.',
            'انشر عناوين استشرافية على شريط أخبار الفرق. لمّح إلى صدمة حقيقية قادمة (تُسوّى توقّعاتها تلقائيًا عند تفعيلها) أو ازرع إشارة مضلّلة.',
          ),
          style: small,
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          initialValue: _shockId,
          isExpanded: true,
          decoration: InputDecoration(isDense: true, labelText: s.tr('Hinted Shock', 'الصدمة المُلمَّح إليها')),
          items: [
            DropdownMenuItem(
                value: 'custom',
                child: Text(s.tr('Custom / red herring (no real shock)', 'مخصّص / إشارة مضلّلة (بلا صدمة حقيقية)'),
                    overflow: TextOverflow.ellipsis)),
            for (final sh in _shocks)
              DropdownMenuItem(
                value: sh['id'].toString(),
                child: Text(
                  '${sh['icon'] ?? ''} ${s.ar ? (sh['nameAr'] ?? sh['name']) : sh['name']}',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
          onChanged: (v) => _pickShock(s, v ?? 'custom'),
        ),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              key: ValueKey('sev-$_severity'),
              initialValue: _severity,
              decoration: InputDecoration(isDense: true, labelText: s.tr('Severity Hint', 'مؤشّر الشدّة')),
              items: [
                DropdownMenuItem(value: 'none', child: Text(s.tr('None', 'بلا'))),
                DropdownMenuItem(value: 'low', child: Text(s.tr('Low', 'منخفضة'))),
                DropdownMenuItem(value: 'medium', child: Text(s.tr('Medium', 'متوسطة'))),
                DropdownMenuItem(value: 'high', child: Text(s.tr('High', 'مرتفعة'))),
              ],
              onChanged: (v) => setState(() => _severity = v ?? 'none'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonFormField<int>(
              initialValue: _round,
              decoration: InputDecoration(isDense: true, labelText: s.tr('Round', 'الجولة')),
              items: [
                for (final r in [1, 2, 3])
                  DropdownMenuItem(value: r, child: Text(s.tr('Round $r', 'الجولة $r'))),
              ],
              onChanged: (v) => setState(() => _round = v ?? _round),
            ),
          ),
        ]),
        const SizedBox(height: 8),
        TextField(
          controller: _headline,
          minLines: 1,
          maxLines: 3,
          decoration: InputDecoration(
            isDense: true,
            labelText: s.tr('Headline', 'العنوان'),
            hintText: s.tr('e.g., Analysts expect the Central Bank to raise rates at its emergency meeting...',
                'مثال: يتوقّع المحلّلون أن يرفع البنك المركزي أسعار الفائدة في اجتماعه الطارئ...'),
            helperText: _shockId != 'custom'
                ? s.tr('Auto-generated from the selected shock - edit freely before publishing.',
                    'مُنشأ تلقائيًا من الصدمة المختارة - عدّله كما تشاء قبل النشر.')
                : null,
            helperMaxLines: 2,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: (_busy || (_shockId == 'custom' && _headline.text.trim().isEmpty)) ? null : () => _publish(s),
            icon: const Icon(Icons.send_rounded, size: 16),
            label: Text(_busy ? s.tr('Publishing...', 'جارٍ النشر...') : s.tr('Publish', 'نشر')),
          ),
        ),
        const SizedBox(height: 12),
        if (_forecasts.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderColor(context)),
            ),
            child: Text(s.tr('No forecasts on the wire', 'لا توجد توقّعات على الشريط'), style: small),
          )
        else
          ..._forecasts.map((f) {
            final id = f['id'].toString();
            final ins = _insured[id];
            final count = ins?.count ?? 0;
            final headline = s.ar ? (f['headlineAr'] ?? f['headline']) : f['headline'];
            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderColor(context)),
              ),
              child: Row(children: [
                Container(
                    width: 8, height: 8,
                    decoration: BoxDecoration(color: _dot(f['severityHint']?.toString()), shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('${headline ?? ''}', maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
                    Text(
                      '${s.tr('Round ${f['roundNum']}', 'الجولة ${f['roundNum']}')} · ${_timeAgo(s, f['publishedAt']?.toString())} · '
                      '${f['shockId'] != null ? s.tr('hints: ${f['shockId']}', 'تلمّح إلى: ${f['shockId']}') : s.tr('red herring', 'إشارة مضلّلة')}',
                      style: const TextStyle(fontSize: 10),
                    ),
                    Tooltip(
                      message: count > 0
                          ? s.tr('Insured: ${ins!.teamIds.join(', ')}', 'مؤمَّنة: ${ins.teamIds.join('، ')}')
                          : s.tr('No teams insured', 'لا فرق مؤمَّنة'),
                      child: Text(
                        '🛡️ ${s.tr('$count team${count == 1 ? '' : 's'} insured', '$count من الفرق مؤمَّنة')}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: count > 0 ? FontWeight.w600 : FontWeight.normal,
                          color: count > 0 ? AppColors.secondaryLight : AppColors.textTertiary(context),
                        ),
                      ),
                    ),
                  ]),
                ),
                OutlinedButton.icon(
                  onPressed: _busy ? null : () => _resolve(s, id),
                  icon: const Icon(Icons.check_rounded, size: 14),
                  label: Text(s.tr('Resolve', 'تسوية'), style: const TextStyle(fontSize: 11)),
                ),
              ]),
            );
          }),
      ]),
    );
  }
}
