import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/theme/app_colors.dart';
import 'glass_card.dart';

/// A compact multi-period trend line ("Trend — All Periods") used by the
/// education trackers to plot a metric across game rounds, matching the website.
/// Renders a friendly empty state when there is no game data yet, so the
/// standalone calculators degrade gracefully.
class TrendLineChart extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<double?> values; // per round; null = missing
  final List<String> labels;
  final Color color;
  final String Function(double) format;

  const TrendLineChart({
    super.key,
    required this.title,
    required this.values,
    required this.labels,
    required this.color,
    required this.format,
    this.subtitle = '',
  });

  bool get _hasData => values.whereType<double>().length >= 2;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.show_chart_rounded, size: 18, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title,
                    style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
          ],
          const SizedBox(height: 16),
          if (!_hasData)
            _emptyState(context)
          else
            SizedBox(height: 180, child: _chart(context)),
        ],
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Container(
      height: 120,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timeline_rounded, size: 28, color: AppColors.textTertiary(context)),
          const SizedBox(height: 8),
          Text('Trend appears as you complete game rounds',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context))),
        ],
      ),
    );
  }

  Widget _chart(BuildContext context) {
    // Build spots only for non-null rounds, keeping the x-index aligned to round.
    final spots = <FlSpot>[];
    for (var i = 0; i < values.length; i++) {
      final v = values[i];
      if (v != null) spots.add(FlSpot(i.toDouble(), v));
    }
    final ys = spots.map((s) => s.y).toList();
    final minY = ys.reduce((a, b) => a < b ? a : b);
    final maxY = ys.reduce((a, b) => a > b ? a : b);
    final pad = (maxY - minY).abs() < 1e-9 ? (maxY.abs() * 0.1 + 1) : (maxY - minY) * 0.15;

    return LineChart(LineChartData(
      minY: minY - pad,
      maxY: maxY + pad,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (v) =>
            FlLine(color: AppColors.borderColor(context).withValues(alpha: 0.2), strokeWidth: 1),
      ),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 44,
            getTitlesWidget: (v, meta) => Text(
              format(v),
              style: TextStyle(fontSize: 9, color: AppColors.textTertiary(context)),
            ),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (v, meta) {
              final i = v.round();
              if (i < 0 || i >= labels.length) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(labels[i], style: TextStyle(fontSize: 10, color: AppColors.textTertiary(context))),
              );
            },
          ),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: color,
          barWidth: 3,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, pct, bar, idx) =>
                FlDotCirclePainter(radius: 4, color: color, strokeWidth: 2, strokeColor: Colors.white),
          ),
          belowBarData: BarAreaData(show: true, color: color.withValues(alpha: 0.12)),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (spots) => spots
              .map((s) => LineTooltipItem(format(s.y), TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 11)))
              .toList(),
        ),
      ),
    ));
  }
}
