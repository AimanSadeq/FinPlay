import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/utils/constants.dart';
import '../../../providers/repository_providers.dart';
import '../../../shared/widgets/glass_card.dart';

class PdfReportButton extends ConsumerStatefulWidget {
  final String teamId;
  final String teamName;

  const PdfReportButton({super.key, required this.teamId, required this.teamName});

  @override
  ConsumerState<PdfReportButton> createState() => _PdfReportButtonState();
}

class _PdfReportButtonState extends ConsumerState<PdfReportButton> {
  bool _downloading = false;
  double _progress = 0;
  String? _error;

  Future<void> _downloadReport() async {
    setState(() {
      _downloading = true;
      _progress = 0;
      _error = null;
    });

    try {
      final api = ref.read(apiClientProvider);
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/finplay_report_team${widget.teamId}.pdf';

      await api.dio.download(
        '${AppConstants.baseUrl}${AppConstants.apiPrefix}/reports/pdf?teamId=${widget.teamId}',
        filePath,
        onReceiveProgress: (received, total) {
          if (total > 0 && mounted) {
            setState(() => _progress = received / total);
          }
        },
      );

      if (mounted) {
        setState(() => _downloading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Report saved to $filePath'),
            backgroundColor: AppColors.secondary,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(label: 'OK', textColor: Colors.white, onPressed: () {}),
          ),
        );
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() {
          _downloading = false;
          _error = e.response?.statusCode == 404
              ? 'Report not available yet'
              : 'Download failed';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _downloading = false;
          _error = 'Download failed';
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
