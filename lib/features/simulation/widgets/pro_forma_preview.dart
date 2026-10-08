import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/i18n/app_strings.dart';
import '../../../data/repositories/decision_repository.dart';
import '../../../providers/repository_providers.dart';
import 'ticker_marquee.dart';

/// Live pro-forma impact ticker for the decision panel (website ProFormaPreview, compact /
/// mobile layout). As the team toggles scenarios and edits amounts (before confirming), it
/// POSTs the pending set to /api/preview/impact (corporate, by teamId) or
/// /api/preview/self-paced-impact (self-paced, by the learner's bearer) and shows projected
/// net income, cash and debt-to-equity with green/red deltas against the persisted position.
/// Requests are debounced 500 ms and stale answers dropped; any failure hides the bar.
/// Not a poll: it only fetches when the pending set changes.
class ProFormaPreview extends ConsumerStatefulWidget {
  /// Corporate mode: "Team 1".."Team 7". Null in self-paced mode.
  final String? teamId;
  final String module;
  final int roundNum;

  /// The panel's pending decision set: scenarioId -> amount.
  final Map<String, double> pending;
  final bool selfPaced;

  const ProFormaPreview({
    super.key,
    this.teamId,
    required this.module,
    required this.roundNum,
    required this.pending,
    this.selfPaced = false,
  });

  /// Stable key for a pending set (sorted by scenarioId), so only real changes refetch.
  static String pendingKey(Map<String, double> pending) {
    final ids = pending.keys.toList()..sort();
    return ids.map((id) => '$id=${pending[id]}').join('|');
  }

  @override
  ConsumerState<ProFormaPreview> createState() => _ProFormaPreviewState();
}

class _MetricSpec {
  final String key;
  final String en;
  final String ar;
  final bool money;
  final bool higherIsBetter;
  final double epsilon; // below this, the delta counts as "no change"
  const _MetricSpec(this.key, this.en, this.ar, this.money, this.higherIsBetter, this.epsilon);
}

const _metrics = [
  _MetricSpec('netIncome', 'Net income', 'صافي الدخل', true, true, 1),
  _MetricSpec('cash', 'Cash', 'النقد', true, true, 1),
  _MetricSpec('debtToEquity', 'D/E', 'الدين/الملكية', false, false, 0.005),
];

/// Website formatMoney: $1.23B / $4.5M / $12K / $950.
String formatPreviewMoney(double value) {
  final sign = value < 0 ? '-' : '';
  final abs = value.abs();
  if (abs >= 1e9) return '$sign\$${(abs / 1e9).toStringAsFixed(2)}B';
  if (abs >= 1e6) return '$sign\$${(abs / 1e6).toStringAsFixed(1)}M';
  if (abs >= 1e3) return '$sign\$${(abs / 1e3).toStringAsFixed(0)}K';
  return '$sign\$${abs.toStringAsFixed(0)}';
}

String _formatDeltaMoney(double v) {
  final prefix = v > 0 ? '+' : v < 0 ? '-' : '';
  return '$prefix${formatPreviewMoney(v.abs())}';
}

String _formatRatio(double v) => v.isFinite ? v.toStringAsFixed(2) : '0.00';

class _ProFormaPreviewState extends ConsumerState<ProFormaPreview> {
  PreviewResult? _data;
  bool _fetching = false;
  bool _error = false;
  Timer? _debounce;
  int _seq = 0;
  String _lastKey = '';

  bool get _canFetch => (widget.selfPaced || (widget.teamId?.isNotEmpty ?? false)) && widget.roundNum > 0;

  @override
  void initState() {
    super.initState();
    _schedule();
  }

  @override
  void didUpdateWidget(covariant ProFormaPreview old) {
    super.didUpdateWidget(old);
    if (old.teamId != widget.teamId ||
        old.module != widget.module ||
        old.roundNum != widget.roundNum ||
        old.selfPaced != widget.selfPaced ||
        ProFormaPreview.pendingKey(widget.pending) != _lastKey) {
      _schedule();
    }
  }

  void _schedule() {
    _lastKey = ProFormaPreview.pendingKey(widget.pending);
    _debounce?.cancel();
    if (!_canFetch) return;
    final seq = ++_seq;
    final pending = Map<String, double>.from(widget.pending);
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (!mounted) return;
      setState(() => _fetching = true);
      final res = await ref.read(decisionRepositoryProvider).previewImpact(
            teamId: widget.teamId,
            module: widget.module,
            roundNum: widget.roundNum,
            pending: pending,
            selfPaced: widget.selfPaced,
          );
      if (!mounted || seq != _seq) return; // a newer request superseded this one
      setState(() {
        _fetching = false;
        if (res == null) {
          _error = true; // silent: hide the bar rather than distract mid-decision
        } else {
          _data = res;
          _error = false;
        }
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_canFetch || _error) return const SizedBox.shrink();
    final s = ref.watch(stringsProvider);
    final data = _data;
    if (data == null) {
      if (!_fetching) return const SizedBox.shrink();
      return Container(
        height: 30,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A).withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(6),
        ),
      );
    }

    final items = <Widget>[
      for (final m in _metrics) _metricItem(s, m, data),
    ];
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: _fetching ? 0.7 : 1,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A), // slate-900
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFF334155)), // slate-700
        ),
        child: Row(
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(color: Color(0xFF34D399), shape: BoxShape.circle),
            ),
            const SizedBox(width: 5),
            Text(
              s.tr('LIVE', 'مباشر'),
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: Color(0xFF34D399),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Semantics(
                label: s.tr('Live impact preview for round ${data.roundNum}',
                    'معاينة الأثر المباشر للجولة ${data.roundNum}'),
                child: TickerMarquee(
                  items: items,
                  loopDuration: const Duration(seconds: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricItem(AppStrings s, _MetricSpec m, PreviewResult data) {
    final delta = data.deltas[m.key];
    final projected = data.projected[m.key];
    final flat = delta.abs() < m.epsilon;
    final good = !flat && (delta > 0 ? m.higherIsBetter : !m.higherIsBetter);
    final deltaText = flat
        ? ''
        : m.money
            ? _formatDeltaMoney(delta)
            : '${delta > 0 ? '+' : ''}${_formatRatio(delta)}';
    final mono = GoogleFonts.jetBrainsMono(fontSize: 12, fontWeight: FontWeight.w600);
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            s.tr(m.en, m.ar).toUpperCase(),
            style: const TextStyle(fontSize: 10, letterSpacing: 0.6, color: Color(0xFF94A3B8)),
          ),
          const SizedBox(width: 5),
          Text(
            m.money ? formatPreviewMoney(projected) : _formatRatio(projected),
            style: mono.copyWith(color: Colors.white),
          ),
          const SizedBox(width: 5),
          Text(
            flat ? '–' : '${delta > 0 ? '▲' : '▼'} $deltaText',
            style: mono.copyWith(
              fontWeight: FontWeight.w500,
              color: flat
                  ? const Color(0xFF64748B)
                  : good
                      ? const Color(0xFF34D399)
                      : const Color(0xFFF87171),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text('·', style: TextStyle(color: Color(0xFF475569))),
          ),
        ],
      ),
    );
  }
}
