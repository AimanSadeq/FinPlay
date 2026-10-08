import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/i18n/app_strings.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/glass_card.dart';
import '../data/debrief_repository.dart';
import '../logic/waterfall_rows.dart';

// Colors as on the website: green raised Net Income, red lowered it, gray for the
// unattributed residual, slate for the start and end anchors.
const _kColors = {
  WaterfallKind.start: Color(0xFF64748B),
  WaterfallKind.end: Color(0xFF64748B),
  WaterfallKind.pos: Color(0xFF008300),
  WaterfallKind.neg: Color(0xFFE34948),
  WaterfallKind.residual: Color(0xFF9CA3AF),
};

/// Decision Impact Waterfall: attributes the round's Net Income change to each confirmed
/// decision (website DecisionWaterfall.tsx). Each bar carries a signed label so the chart
/// never relies on color alone; tap a bar for its details.
class DecisionWaterfallCard extends ConsumerStatefulWidget {
  final String teamId;
  final int round;
  final bool selfPaced;

  const DecisionWaterfallCard({
    super.key,
    required this.teamId,
    required this.round,
    this.selfPaced = false,
  });

  @override
  ConsumerState<DecisionWaterfallCard> createState() => _DecisionWaterfallCardState();
}

class _DecisionWaterfallCardState extends ConsumerState<DecisionWaterfallCard> {
  int? _selected;

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final round = widget.round;
    final enabled = round >= 1 && round <= 3 && (widget.selfPaced || widget.teamId.isNotEmpty);
    final async = enabled
        ? ref.watch(decisionWaterfallProvider(
            (selfPaced: widget.selfPaced, teamId: widget.teamId, round: round)))
        : null;

    Widget message(String text) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Text(text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary(context))),
        );

    Widget body;
    if (async == null) {
      body = message(s.tr(
          'No confirmed decisions found for Round $round yet. Complete your modules to see how each decision moved your Net Income.',
          'لا توجد قرارات مؤكدة للجولة $round بعد. أكمل وحداتك لترى كيف حرّك كل قرار صافي دخلك.'));
    } else {
      body = async.when(
        loading: () => Padding(
          padding: const EdgeInsets.symmetric(vertical: 28),
          child: Column(
            children: [
              const SizedBox(
                  width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2)),
              const SizedBox(height: 10),
              Text(
                s.tr('Analyzing decision impacts (running counterfactuals)...',
                    'جارٍ تحليل أثر القرارات (تشغيل سيناريوهات بديلة)...'),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary(context)),
              ),
            ],
          ),
        ),
        error: (_, _) => message(s.tr(
            'Could not load the decision impact analysis. Please try again later.',
            'تعذّر تحميل تحليل أثر القرارات. يُرجى المحاولة لاحقًا.')),
        data: (data) {
          if (data.items.isEmpty) {
            return message(s.tr(
                'No confirmed decisions found for Round $round yet. Complete your modules to see how each decision moved your Net Income.',
                'لا توجد قرارات مؤكدة للجولة $round بعد. أكمل وحداتك لترى كيف حرّك كل قرار صافي دخلك.'));
          }
          final bars = buildWaterfallBars(
            data,
            startName: s.tr('Start', 'البداية'),
            startTitle: s.tr('Net Income before this round’s decisions',
                'صافي الدخل قبل قرارات هذه الجولة'),
            otherName: s.tr('Other effects', 'آثار أخرى'),
            otherTitle: s.tr('Decision interactions and market effects (unattributed)',
                'تفاعلات القرارات وآثار السوق (غير منسوبة)'),
            endName: s.tr('End R${data.round}', 'نهاية ج${data.round}'),
            endTitle: s.tr('Round ${data.round} Net Income (actual)',
                'صافي دخل الجولة ${data.round} (الفعلي)'),
          );
          final sel = _selected != null && _selected! < bars.length ? bars[_selected!] : null;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _WaterfallChart(
                bars: bars,
                selected: _selected,
                onTap: (i) => setState(() => _selected = _selected == i ? null : i),
              ),
              if (sel != null) _details(context, s, sel),
              const SizedBox(height: 8),
              Wrap(
                spacing: 14,
                runSpacing: 6,
                children: [
                  _legend(context, _kColors[WaterfallKind.pos]!, s.tr('Raised Net Income', 'رفع صافي الدخل')),
                  _legend(context, _kColors[WaterfallKind.neg]!, s.tr('Lowered Net Income', 'خفّض صافي الدخل')),
                  _legend(context, _kColors[WaterfallKind.residual]!, s.tr('Other effects', 'آثار أخرى')),
                  _legend(context, _kColors[WaterfallKind.start]!, s.tr('Start / End', 'البداية / النهاية')),
                ],
              ),
            ],
          );
        },
      );
    }

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bar_chart_rounded, size: 20, color: Color(0xFF64748B)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  s.tr('Decision Impact on Net Income - Round $round',
                      'أثر القرارات على صافي الدخل - الجولة $round'),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            s.tr(
                'Each bar shows how one confirmed decision moved this round\'s Net Income, measured by re-running the financial engine without that decision.',
                'يُظهر كل عمود كيف حرّك قرار مؤكد واحد صافي دخل هذه الجولة، ويُقاس ذلك بإعادة تشغيل النموذج المالي دون ذلك القرار.'),
            style: TextStyle(fontSize: 11, color: AppColors.textTertiary(context)),
          ),
          const SizedBox(height: 8),
          body,
        ],
      ),
    );
  }

  Widget _details(BuildContext context, AppStrings s, WaterfallBar bar) {
    String module(String m) => switch (m) {
          'financing' => s.tr('Financing', 'التمويل'),
          'investing' => s.tr('Investing', 'الاستثمار'),
          'operating' => s.tr('Operating', 'التشغيل'),
          _ => m,
        };
    final valueText = bar.isAnchor
        ? formatExact(bar.signed)
        : '${bar.signed >= 0 ? '+' : ''}${formatExact(bar.signed)}';
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.cardColor(context).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderColor(context).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(bar.fullTitle, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          if (bar.module != null && bar.module!.isNotEmpty)
            Text('${s.tr('Module', 'الوحدة')}: ${module(bar.module!)}',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary(context))),
          if (bar.amount != null)
            Text('${s.tr('Decision amount', 'مبلغ القرار')}: ${formatExact(bar.amount!)}',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary(context))),
          const SizedBox(height: 2),
          Text.rich(TextSpan(children: [
            TextSpan(
                text: bar.isAnchor
                    ? '${s.tr('Net Income', 'صافي الدخل')}: '
                    : '${s.tr('Net Income impact', 'الأثر على صافي الدخل')}: ',
                style: const TextStyle(fontSize: 12)),
            TextSpan(
                text: valueText,
                style: GoogleFonts.jetBrainsMono(fontSize: 12, fontWeight: FontWeight.w700)),
          ])),
        ],
      ),
    );
  }

  Widget _legend(BuildContext context, Color color, String label) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 11,
              height: 11,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 5),
          Text(label, style: TextStyle(fontSize: 11, color: AppColors.textSecondary(context))),
        ],
      );
}

class _WaterfallChart extends StatelessWidget {
  final List<WaterfallBar> bars;
  final int? selected;
  final ValueChanged<int> onTap;

  const _WaterfallChart({required this.bars, required this.selected, required this.onTap});

  static const double _band = 64;
  static const double _height = 280;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = math.max(constraints.maxWidth, bars.length * _band + 56);
      final painter = _WaterfallPainter(
        bars: bars,
        selected: selected,
        textColor: AppColors.textSecondary(context),
        gridColor: AppColors.borderColor(context).withValues(alpha: 0.25),
      );
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: GestureDetector(
          onTapUp: (d) {
            final i = painter.indexAt(d.localPosition, Size(width, _height));
            if (i != null) onTap(i);
          },
          child: Semantics(
            label: bars
                .map((b) => '${b.fullTitle}: ${b.isAnchor ? formatCompact(b.signed) : formatSignedCompact(b.signed)}')
                .join('; '),
            child: CustomPaint(size: Size(width, _height), painter: painter),
          ),
        ),
      );
    });
  }
}

class _WaterfallPainter extends CustomPainter {
  final List<WaterfallBar> bars;
  final int? selected;
  final Color textColor;
  final Color gridColor;

  _WaterfallPainter({
    required this.bars,
    required this.selected,
    required this.textColor,
    required this.gridColor,
  });

  static const double _axisWidth = 52;
  static const double _top = 22;
  static const double _bottomLabels = 40;

  double get _minV => bars.fold<double>(0, (m, b) => math.min(m, b.base));
  double get _maxV => bars.fold<double>(0, (m, b) => math.max(m, b.top));

  double _bandWidth(Size size) => (size.width - _axisWidth) / bars.length;

  int? indexAt(Offset p, Size size) {
    if (p.dx < _axisWidth) return null;
    final i = ((p.dx - _axisWidth) / _bandWidth(size)).floor();
    return i >= 0 && i < bars.length ? i : null;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var lo = _minV;
    var hi = _maxV;
    if (hi == lo) hi = lo + 1;
    final pad = (hi - lo) * 0.06;
    hi += pad;
    if (lo < 0) lo -= pad;
    final plotTop = _top;
    final plotBottom = size.height - _bottomLabels;
    double y(double v) => plotBottom - (v - lo) / (hi - lo) * (plotBottom - plotTop);

    // Grid + y-axis labels (4 steps).
    final grid = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    for (var i = 0; i <= 4; i++) {
      final v = lo + (hi - lo) * i / 4;
      final yy = y(v);
      canvas.drawLine(Offset(_axisWidth, yy), Offset(size.width, yy), grid);
      _text(canvas, formatCompact(v), Offset(_axisWidth - 4, yy), 10, align: TextAlign.right, anchorRight: true, centerY: true);
    }
    // Zero line.
    canvas.drawLine(Offset(_axisWidth, y(0)), Offset(size.width, y(0)),
        Paint()
          ..color = gridColor.withValues(alpha: 0.9)
          ..strokeWidth = 1.2);

    final band = _bandWidth(size);
    final barW = band * 0.6;
    final dash = Paint()
      ..color = const Color(0xFF9CA3AF)
      ..strokeWidth = 1;
    double? prevRight;
    double? runningLevel;
    for (var i = 0; i < bars.length; i++) {
      final b = bars[i];
      final left = _axisWidth + band * i + (band - barW) / 2;
      final top = y(b.top);
      final bottom = y(b.base);
      final h = math.max(bottom - top, 1.0);
      final paint = Paint()..color = _kColors[b.kind]!;
      if (selected != null && selected != i) paint.color = paint.color.withValues(alpha: 0.45);
      canvas.drawRRect(
          RRect.fromRectAndRadius(Rect.fromLTWH(left, top, barW, h), const Radius.circular(2)),
          paint);

      // Dashed connector from the previous bar at the running Net Income level.
      if (prevRight != null && runningLevel != null) {
        final cy = y(runningLevel);
        var x = prevRight;
        while (x < left) {
          canvas.drawLine(Offset(x, cy), Offset(math.min(x + 3, left), cy), dash);
          x += 5;
        }
      }
      prevRight = left + barW;
      runningLevel = b.kind == WaterfallKind.start || b.kind == WaterfallKind.end
          ? b.signed
          : (b.signed >= 0 ? b.top : b.base);

      // Signed value label above the bar.
      final label = b.isAnchor ? formatCompact(b.signed) : formatSignedCompact(b.signed);
      _text(canvas, label, Offset(left + barW / 2, top - 14), 10.5, align: TextAlign.center, center: true, width: band);

      // Axis label below the plot.
      _text(canvas, b.name, Offset(left + barW / 2, plotBottom + 4), 10,
          align: TextAlign.center, center: true, width: band - 4, maxLines: 2);
    }
  }

  void _text(Canvas canvas, String text, Offset at, double size,
      {TextAlign align = TextAlign.left,
      bool center = false,
      bool anchorRight = false,
      bool centerY = false,
      double? width,
      int maxLines = 1}) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(fontSize: size, color: textColor)),
      textAlign: align,
      textDirection: TextDirection.ltr,
      maxLines: maxLines,
      ellipsis: '…',
    )..layout(maxWidth: width ?? 200);
    var dx = at.dx;
    if (center) dx -= tp.width / 2;
    if (anchorRight) dx -= tp.width;
    var dy = at.dy;
    if (centerY) dy -= tp.height / 2;
    tp.paint(canvas, Offset(dx, dy));
  }

  @override
  bool shouldRepaint(covariant _WaterfallPainter old) =>
      old.bars != bars || old.selected != selected || old.textColor != textColor;
}
