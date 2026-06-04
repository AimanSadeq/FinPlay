import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/theme/app_colors.dart';

/// A compact floating-style pill button that navigates to the education screen.
///
/// When [compact] is true only the book icon is shown (no label).
class LearnButton extends StatelessWidget {
  final bool compact;

  const LearnButton({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => context.push('/education'),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 8 : 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.menu_book_rounded, size: 16, color: AppColors.secondaryLight),
              if (!compact) ...[
                const SizedBox(width: 5),
                Text(
                  'Learn',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondaryLight,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
