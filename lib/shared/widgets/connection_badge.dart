import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/theme/app_colors.dart';
import '../../providers/socket_provider.dart';

class ConnectionStatusBadge extends ConsumerWidget {
  const ConnectionStatusBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(connectionStatusProvider);

    return status.when(
      data: (connected) => _Badge(
        connected: connected,
        label: connected ? 'Connected' : 'Disconnected',
      ),
      loading: () => const _Badge(connected: false, label: 'Connecting...'),
      error: (_, _) => const _Badge(connected: false, label: 'Offline'),
    );
  }
}

class _Badge extends StatelessWidget {
  final bool connected;
  final String label;

  const _Badge({required this.connected, required this.label});

  @override
  Widget build(BuildContext context) {
    final color = connected ? AppColors.secondaryLight : AppColors.dangerLight;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 4)],
            ),
          ),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
