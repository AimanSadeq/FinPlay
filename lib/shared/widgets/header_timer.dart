import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/socket_provider.dart';
import '../../app/theme/app_colors.dart';

/// Compact countdown timer pill that displays the facilitator-pushed timer.
///
/// Watches [timerSecondsProvider] and renders MM:SS with color coding:
/// - Green (> 60 s), Amber (30-60 s), Red (< 30 s).
/// Hidden when the timer value is null.
class HeaderTimer extends ConsumerWidget {
  const HeaderTimer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seconds = ref.watch(timerSecondsProvider);

    if (seconds == null) return const SizedBox.shrink();

    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    final display = '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';

    final Color timerColor;
    if (seconds > 60) {
      timerColor = AppColors.secondaryLight; // green
    } else if (seconds >= 30) {
      timerColor = AppColors.accentLight; // amber
    } else {
      timerColor = AppColors.dangerLight; // red
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: timerColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: timerColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_rounded, size: 14, color: timerColor),
          const SizedBox(width: 5),
          Text(
            display,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: timerColor,
            ),
          ),
        ],
      ),
    );
  }
}
