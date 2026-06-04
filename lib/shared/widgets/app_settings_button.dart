import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/theme/app_colors.dart';
import '../../providers/theme_provider.dart';
import '../../providers/locale_provider.dart';

/// Compact header control exposing the two app-wide settings the website also
/// surfaces: a language switch (EN / العربية) and a light/dark theme toggle.
///
/// Both providers were wired into [MaterialApp] but had no UI entry point, so
/// dark mode and Arabic were effectively unreachable. Drop this into any screen
/// header (commonly top-right).
class AppSettingsButton extends ConsumerWidget {
  /// When true, renders on a translucent light chip suitable for dark/coloured
  /// headers. When false, adapts to the current theme surface.
  final bool onColoredHeader;

  const AppSettingsButton({super.key, this.onColoredHeader = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isArabic = ref.watch(isArabicProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = onColoredHeader
        ? Colors.white
        : (isDark ? Colors.white : const Color(0xFF243C76));
    final chipBg = onColoredHeader
        ? Colors.white.withValues(alpha: 0.18)
        : (isDark ? Colors.white.withValues(alpha: 0.12) : Colors.white.withValues(alpha: 0.85));

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Language toggle — shows the language you'll switch TO (matches web).
        _Pill(
          background: chipBg,
          onTap: () => ref.read(localeProvider.notifier).toggleLanguage(),
          child: Text(
            isArabic ? 'EN' : 'العربية',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Theme toggle.
        _Pill(
          background: chipBg,
          onTap: () => ref.read(themeProvider.notifier).toggle(),
          child: Icon(
            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            size: 16,
            color: fg,
          ),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final Widget child;
  final Color background;
  final VoidCallback onTap;
  const _Pill({required this.child, required this.background, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minWidth: 36, minHeight: 32),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.borderColor(context).withValues(alpha: 0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
