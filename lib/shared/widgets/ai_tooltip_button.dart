import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/theme/app_colors.dart';
import '../../providers/repository_providers.dart';

/// A small button that fetches an AI-powered explanation for a financial term.
///
/// Two modes:
///  * Term mode (default) — a single plain-language explanation string.
///  * Ratio mode — pass [value] and [type] to fetch the website's rich,
///    structured ratio tooltip (definition, formula, interpretation,
///    benchmarks, business impact, actionable insights, advantages,
///    disadvantages, risk level), cached client-side.
class AiTooltipButton extends ConsumerStatefulWidget {
  final String term;
  final Color? color;

  /// When provided alongside [type], the rich structured ratio tooltip is used.
  final String? value;
  final String? type;

  const AiTooltipButton({
    super.key,
    required this.term,
    this.color,
    this.value,
    this.type,
  });

  @override
  ConsumerState<AiTooltipButton> createState() => _AiTooltipButtonState();
}

class _AiTooltipButtonState extends ConsumerState<AiTooltipButton> {
  bool _loading = false;
  String? _explanation;
  Map<String, dynamic>? _structured;
  String? _error;

  bool get _isRatioMode => widget.type != null;

  Future<void> _fetchTooltip() async {
    if (_explanation != null || _structured != null) {
      _showTooltipDialog();
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final repo = ref.read(educationRepositoryProvider);
      if (_isRatioMode) {
        final result = await repo.fetchRatioTooltip(
          title: widget.term,
          value: widget.value,
          type: widget.type,
        );
        if (!mounted) return;
        setState(() {
          _structured = result;
          _loading = false;
        });
      } else {
        final result = await repo.fetchAiTooltip(term: widget.term);
        if (!mounted) return;
        setState(() {
          _explanation = result['explanation'] as String? ??
              result['tooltip'] as String? ??
              'No explanation available.';
          _loading = false;
        });
      }
      _showTooltipDialog();
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Could not load explanation';
          _loading = false;
        });
        _showTooltipDialog();
      }
    }
  }

  void _showTooltipDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF1E293B)
          : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: _structured != null ? 0.7 : 0.4,
        minChildSize: 0.3,
        maxChildSize: 0.92,
        builder: (context, controller) => SingleChildScrollView(
          controller: controller,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const SizedBox(height: 16),
              if (_error != null)
                _errorBox(_error!)
              else if (_structured != null)
                ..._structuredBody(_structured!)
              else
                Text(
                  _explanation ?? '',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6),
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    final risk = _structured?['riskLevel']?.toString();
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.auto_awesome, color: AppColors.primaryLight, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('AI EXPLANATION',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryLight,
                      letterSpacing: 1)),
              Text(widget.term, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
        if (risk != null) _riskBadge(risk),
      ],
    );
  }

  Widget _riskBadge(String risk) {
    final c = switch (risk.toLowerCase()) {
      'low' => AppColors.secondaryLight,
      'high' || 'critical' => AppColors.dangerLight,
      _ => AppColors.accentLight,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text('$risk risk',
          style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }

  List<Widget> _structuredBody(Map<String, dynamic> d) {
    final widgets = <Widget>[];

    void section(String label, String? body) {
      if (body == null || body.isEmpty) return;
      widgets.add(_sectionTitle(label));
      widgets.add(Text(body, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.55)));
      widgets.add(const SizedBox(height: 14));
    }

    section('Definition', d['definition'] as String?);

    if (d['formula'] is String && (d['formula'] as String).isNotEmpty) {
      widgets.add(_sectionTitle('Formula'));
      widgets.add(Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(d['formula'] as String,
            style: GoogleFonts.jetBrainsMono(fontSize: 13, color: AppColors.primaryLight)),
      ));
      widgets.add(const SizedBox(height: 14));
    }

    section('Interpretation', d['interpretation'] as String?);

    final bench = d['benchmarks'];
    if (bench is Map) {
      widgets.add(_sectionTitle('Industry Benchmarks'));
      void row(String k, Color c) {
        final v = bench[k];
        if (v == null) return;
        widgets.add(Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: 8, height: 8, margin: const EdgeInsets.only(top: 6, right: 8),
                  decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.4),
                    children: [
                      TextSpan(text: '${k[0].toUpperCase()}${k.substring(1)}: ',
                          style: TextStyle(fontWeight: FontWeight.w700, color: c)),
                      TextSpan(text: v.toString()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
      }
      row('excellent', AppColors.secondaryLight);
      row('good', AppColors.info);
      row('concerning', AppColors.dangerLight);
      widgets.add(const SizedBox(height: 14));
    }

    section('Business Impact', d['businessImpact'] as String?);
    section('Industry Context', d['industryContext'] as String?);

    _bulletSection(widgets, 'Actionable Insights', d['actionableInsights'], Icons.bolt_rounded, AppColors.accentLight);
    _bulletSection(widgets, 'Advantages', d['advantages'], Icons.add_circle_outline_rounded, AppColors.secondaryLight);
    _bulletSection(widgets, 'Watch Out For', d['disadvantages'], Icons.remove_circle_outline_rounded, AppColors.dangerLight);

    final related = d['relatedRatios'];
    if (related is List && related.isNotEmpty) {
      widgets.add(_sectionTitle('Related Ratios'));
      widgets.add(Wrap(
        spacing: 8,
        runSpacing: 8,
        children: related.map((r) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(r.toString(), style: Theme.of(context).textTheme.bodySmall),
        )).toList(),
      ));
    }

    return widgets;
  }

  void _bulletSection(List<Widget> out, String label, dynamic items, IconData icon, Color color) {
    if (items is! List || items.isEmpty) return;
    out.add(_sectionTitle(label));
    for (final it in items) {
      out.add(Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 8),
            Expanded(child: Text(it.toString(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.4))),
          ],
        ),
      ));
    }
    out.add(const SizedBox(height: 14));
  }

  Widget _sectionTitle(String label) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(label.toUpperCase(),
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: AppColors.textSecondary(context))),
      );

  Widget _errorBox(String msg) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.danger.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(msg, style: const TextStyle(color: AppColors.dangerLight, fontSize: 13)),
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _loading ? null : _fetchTooltip,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: (widget.color ?? AppColors.primaryLight).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: _loading
            ? SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: widget.color ?? AppColors.primaryLight,
                ),
              )
            : Icon(Icons.auto_awesome, size: 14, color: widget.color ?? AppColors.primaryLight),
      ),
    );
  }
}
