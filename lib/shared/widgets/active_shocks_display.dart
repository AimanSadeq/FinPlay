import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/theme/app_colors.dart';
import '../../core/network/api_endpoints.dart';
import '../../providers/repository_providers.dart';
import '../../providers/socket_provider.dart';

/// Displays active market shocks pushed by the facilitator as dismissible
/// banners between the round stepper and the tab content.
///
/// Each shock card shows name, description, severity colour coding and an
/// acknowledge button that POSTs to [ApiEndpoints.shocksAcknowledge].
class ActiveShocksDisplay extends ConsumerWidget {
  const ActiveShocksDisplay({super.key});

  static Color _severityColor(String severity) {
    switch (severity) {
      case 'low':
        return AppColors.info; // blue
      case 'medium':
        return AppColors.accentLight; // amber
      case 'high':
        return AppColors.dangerLight; // red
      case 'critical':
        return const Color(0xFF7C3AED); // purple
      default:
        return AppColors.accentLight;
    }
  }

  static String _severityLabel(String severity) {
    switch (severity) {
      case 'low':
        return 'LOW';
      case 'medium':
        return 'MEDIUM';
      case 'high':
        return 'HIGH';
      case 'critical':
        return 'CRITICAL';
      default:
        return severity.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shocks = ref.watch(activeShocksProvider);

    if (shocks.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: shocks.map((shock) {
          final name = shock['name'] as String? ?? 'Market Shock';
          final description = shock['description'] as String? ?? '';
          final severity = shock['severity'] as String? ?? 'medium';
          final shockId = shock['id']?.toString() ?? shock['shockId']?.toString();
          final color = _severityColor(severity);

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Severity icon
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.flash_on_rounded, color: color, size: 18),
                  ),
                  const SizedBox(width: 10),
                  // Text content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                _severityLabel(severity),
                                style: GoogleFonts.inter(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: color,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                name,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary(context),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        if (description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            description,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.textSecondary(context),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Actions
                  Column(
                    children: [
                      // Acknowledge
                      if (shockId != null)
                        _AcknowledgeButton(
                          color: color,
                          onPressed: () => _acknowledge(ref, shockId, shock),
                        ),
                      const SizedBox(height: 4),
                      // Dismiss
                      InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => _dismiss(ref, shock),
                        child: Icon(Icons.close, size: 16, color: AppColors.textTertiary(context)),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.3),
          );
        }).toList(),
      ),
    );
  }

  void _dismiss(WidgetRef ref, Map<String, dynamic> shock) {
    final updated = List<Map<String, dynamic>>.from(ref.read(activeShocksProvider));
    updated.remove(shock);
    ref.read(activeShocksProvider.notifier).state = updated;
  }

  Future<void> _acknowledge(
    WidgetRef ref,
    String shockId,
    Map<String, dynamic> shock,
  ) async {
    try {
      final api = ref.read(apiClientProvider);
      await api.post(ApiEndpoints.shocksAcknowledge, data: {'shockId': shockId});
    } catch (_) {
      // best-effort
    }
    _dismiss(ref, shock);
  }
}

class _AcknowledgeButton extends StatelessWidget {
  final Color color;
  final VoidCallback onPressed;

  const _AcknowledgeButton({required this.color, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Text(
            'ACK',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
