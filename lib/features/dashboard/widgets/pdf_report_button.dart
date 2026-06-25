import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/utils/constants.dart';
import '../../../shared/widgets/glass_card.dart';

class PdfReportButton extends ConsumerStatefulWidget {
  final String teamId;
  final String teamName;
  final int round;

  const PdfReportButton({
    super.key,
    required this.teamId,
    required this.teamName,
    required this.round,
  });

  @override
  ConsumerState<PdfReportButton> createState() => _PdfReportButtonState();
}

class _PdfReportButtonState extends ConsumerState<PdfReportButton> {
  bool _downloading = false;
  final double _progress = 0;
  String? _error;

  /// Opens the print-ready round report in the browser. The backend serves an
  /// HTML report at /api/reports/round-report/:teamId/:round (the website opens
  /// it in a new tab; the user saves it as PDF via the print dialog).
  Future<void> _downloadReport() async {
    setState(() {
      _downloading = true;
      _error = null;
    });

    // Backend only accepts rounds 1–3.
    final round = widget.round < 1 ? 1 : (widget.round > 3 ? 3 : widget.round);
    final uri = Uri.parse(
      '${AppConstants.baseUrl}${AppConstants.apiPrefix}/reports/round-report/${widget.teamId}/$round',
    );

    try {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (mounted) {
        setState(() {
          _downloading = false;
          if (!ok) _error = 'Could not open report';
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _downloading = false;
          _error = 'Could not open report';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: _downloading ? null : _downloadReport,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: AppColors.danger.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: _downloading
                ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: CircularProgressIndicator(
                      value: _progress > 0 ? _progress : null,
                      strokeWidth: 2,
                      color: AppColors.dangerLight,
                    ),
                  )
                : const Icon(Icons.picture_as_pdf_rounded, color: AppColors.dangerLight, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Download PDF Report', style: Theme.of(context).textTheme.titleSmall),
                Text(
                  _error ?? '${widget.teamName} financial summary',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _error != null ? AppColors.dangerLight : null,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.download_rounded, color: AppColors.textTertiary(context), size: 20),
        ],
      ),
    );
  }
}
