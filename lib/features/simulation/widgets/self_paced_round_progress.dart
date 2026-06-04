import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

/// Shows 3 module boxes per round with status (completed/active/waiting).
/// Matches website's SelfPacedRoundProgress — all-blue gradient boxes with
/// decision details listed inside completed boxes.
class SelfPacedRoundProgress extends StatelessWidget {
  final int currentRound;
  final String currentModule;
  final Map<String, List<Map<String, dynamic>>> decisions;

  static const _modules = ['financing', 'investing', 'operating'];
  static const _moduleLabels = ['Financing', 'Investing', 'Operating'];

  const SelfPacedRoundProgress({
    super.key,
    required this.currentRound,
    required this.currentModule,
    this.decisions = const {},
  });

  _ModuleStatus _getStatus(int index) {
    final currentIndex = _modules.indexOf(currentModule);
    if (currentModule == 'complete' || index < currentIndex) {
      return _ModuleStatus.completed;
    }
    if (index == currentIndex) return _ModuleStatus.active;
    return _ModuleStatus.waiting;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header: "Round X Progress  Year X of 3" (matches website)
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Row(
            children: [
              Text(
                'Round $currentRound Progress',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary(context),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Year $currentRound of 3',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary(context),
                ),
              ),
            ],
          ),
        ),
        // 3 module boxes in a row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(3, (i) {
            final status = _getStatus(i);
            final decisionList = decisions[_modules[i]] ?? [];

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: i == 0 ? 0 : 3,
                  right: i == 2 ? 0 : 3,
                ),
                child: _ModuleBox(
                  label: _moduleLabels[i],
                  status: status,
                  decisions: decisionList,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

enum _ModuleStatus { completed, active, waiting }

class _ModuleBox extends StatelessWidget {
  final String label;
  final _ModuleStatus status;
  final List<Map<String, dynamic>> decisions;

  const _ModuleBox({
    required this.label,
    required this.status,
    required this.decisions,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = status == _ModuleStatus.completed;
    final isActive = status == _ModuleStatus.active;
    final isWaiting = status == _ModuleStatus.waiting;

    // Website uses all-blue gradients with opacity differences
    final List<Color> gradientColors;
    if (isCompleted) {
      gradientColors = [const Color(0xFF2563EB), const Color(0xFF1D4ED8)];
    } else if (isActive) {
      gradientColors = [const Color(0xFF3B82F6), const Color(0xFF2563EB)];
    } else {
      gradientColors = [const Color(0xFF60A5FA), const Color(0xFF3B82F6)];
    }

    // Dynamic height: more decisions = taller box
    final minHeight = isCompleted && decisions.isNotEmpty
        ? 80.0 + (decisions.length * 20.0).clamp(0.0, 60.0)
        : 90.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      constraints: BoxConstraints(minHeight: minHeight),
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Opacity(
        opacity: isWaiting ? 0.6 : 1.0,
        child: Stack(
          children: [
            // Checkmark badge in corner for completed
            if (isCompleted)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Module name
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                // Status content
                if (isCompleted && decisions.isNotEmpty) ...[
                  // Show decision titles with amounts (like website)
                  ...decisions.take(3).map((d) {
                    final title = (d['title'] ?? d['description'] ?? '').toString();
                    final amount = d['amount'];
                    final displayTitle = title.length > 20
                        ? '${title.substring(0, 20)}...'
                        : title;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        amount != null
                            ? '$displayTitle \$${_formatAmount(amount)}'
                            : displayTitle,
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.white.withValues(alpha: 0.9),
                          height: 1.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }),
                  if (decisions.length > 3)
                    Text(
                      '+${decisions.length - 3} more',
                      style: TextStyle(
                        fontSize: 8,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                ] else if (isActive)
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 11,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          'Make your selections',
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )
                else if (isWaiting)
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 11,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Locked',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  )
                else
                  // Completed but no decisions stored
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 12,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Confirmed',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatAmount(dynamic amount) {
    if (amount == null) return '0';
    final num value;
    if (amount is num) {
      value = amount;
    } else {
      value = num.tryParse(amount.toString()) ?? 0;
    }
    if (value >= 1000000) return '\$${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '\$${(value / 1000).toStringAsFixed(0)}K';
    return '\$${value.toStringAsFixed(0)}';
  }
}
