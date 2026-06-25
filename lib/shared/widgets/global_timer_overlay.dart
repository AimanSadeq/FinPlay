import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/theme/app_colors.dart';
import '../../providers/socket_provider.dart';
import '../../providers/timer_provider.dart';

class GlobalTimerOverlay extends ConsumerWidget {
  final Widget child;

  const GlobalTimerOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Keep the /timer/status poller alive for the app lifetime (this overlay
    // wraps the whole app). The backend never pushes the timer over a socket.
    ref.watch(timerPollProvider);
    final timerSeconds = ref.watch(timerSecondsProvider);

    return Stack(
      children: [
        child,
        if (timerSeconds != null && timerSeconds > 0)
          Positioned(
            top: MediaQuery.of(context).padding.top + 4,
            right: 8,
            child: _TimerPill(seconds: timerSeconds),
          ),
      ],
    );
  }
}

class _TimerPill extends StatelessWidget {
  final int seconds;

  const _TimerPill({required this.seconds});

  @override
  Widget build(BuildContext context) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    final isUrgent = seconds < 60;
    final color = isUrgent ? AppColors.dangerLight : AppColors.accentLight;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: (isUrgent ? AppColors.danger : AppColors.surfaceColor(context)).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.2), blurRadius: 8),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_rounded, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            '$mins:$secs',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 12, fontWeight: FontWeight.w700, color: color,
            ),
          ),
        ],
      ),
    );
  }
}
