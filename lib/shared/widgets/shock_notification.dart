import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/theme/app_colors.dart';
import '../../providers/socket_provider.dart';
import 'glass_card.dart';

class ShockNotificationOverlay extends ConsumerWidget {
  final Widget child;

  const ShockNotificationOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shocks = ref.watch(activeShocksProvider);

    return Stack(
      children: [
        child,
        if (shocks.isNotEmpty)
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            right: 16,
            child: Column(
              children: shocks.take(3).map((shock) {
                final name = shock['name'] as String? ?? 'Market Shock';
                final severity = shock['severity'] as String? ?? 'medium';
                final severityColor = severity == 'critical'
                    ? const Color(0xFF7C3AED)
                    : severity == 'high'
                        ? AppColors.dangerLight
                        : AppColors.accentLight;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: GlassCard(
                    backgroundColor: AppColors.danger.withValues(alpha: 0.15),
                    borderColor: AppColors.danger.withValues(alpha: 0.4),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: severityColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.flash_on_rounded, color: severityColor, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'MARKET SHOCK',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: severityColor,
                                  letterSpacing: 1,
                                ),
                              ),
                              Text(name, style: Theme.of(context).textTheme.titleSmall),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, size: 18, color: AppColors.textTertiary(context)),
                          onPressed: () {
                            final updated = List<Map<String, dynamic>>.from(shocks);
                            updated.remove(shock);
                            ref.read(activeShocksProvider.notifier).state = updated;
                          },
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.5),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
