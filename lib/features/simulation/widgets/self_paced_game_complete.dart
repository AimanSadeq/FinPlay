import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../providers/self_paced_provider.dart';
import '../../../shared/widgets/glass_card.dart';

/// Shown when self-paced game is complete (round >= 3, module == 'complete').
/// Trophy, congratulations, view results, and reset progress.
class SelfPacedGameComplete extends ConsumerStatefulWidget {
  const SelfPacedGameComplete({super.key});

  @override
  ConsumerState<SelfPacedGameComplete> createState() =>
      _SelfPacedGameCompleteState();
}

class _SelfPacedGameCompleteState
    extends ConsumerState<SelfPacedGameComplete> {
  bool _isResetting = false;

  Future<void> _resetProgress() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Progress?'),
        content: const Text(
          'This will erase all your decisions and restart from Round 1. '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isResetting = true);
    await ref.read(selfPacedProvider.notifier).resetProgress();
    if (mounted) setState(() => _isResetting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Trophy
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.emoji_events_rounded,
                size: 44,
                color: Color(0xFFF59E0B),
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'Congratulations!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary(context),
              ),
            ),
            const SizedBox(height: 8),

            Text(
              'You have completed all 3 rounds of the simulation.\n'
              'All 9 modules have been finished successfully.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary(context),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),

            // View Results button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => context.go('/dashboard'),
                icon: const Icon(Icons.bar_chart_rounded, size: 18),
                label: const Text('View Results'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryLight,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Reset Progress button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _isResetting ? null : _resetProgress,
                icon: _isResetting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.restart_alt_rounded, size: 18),
                label: Text(_isResetting ? 'Resetting...' : 'Reset Progress'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.danger,
                  side: const BorderSide(color: AppColors.danger),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
