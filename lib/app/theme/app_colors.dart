import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary - Deep Electric Blue
  static const primary = Color(0xFF1A56DB);
  static const primaryLight = Color(0xFF3B82F6);
  static const primaryDark = Color(0xFF1E40AF);
  static const primarySurface = Color(0xFFDBEAFE);

  // Secondary - Vivid Emerald
  static const secondary = Color(0xFF059669);
  static const secondaryLight = Color(0xFF10B981);
  static const secondaryDark = Color(0xFF047857);
  static const secondarySurface = Color(0xFFD1FAE5);

  // Accent - Amber Gold
  static const accent = Color(0xFFD97706);
  static const accentLight = Color(0xFFF59E0B);
  static const accentDark = Color(0xFFB45309);
  static const accentSurface = Color(0xFFFEF3C7);

  // Danger - Hot Coral
  static const danger = Color(0xFFDC2626);
  static const dangerLight = Color(0xFFEF4444);
  static const dangerSurface = Color(0xFFFEE2E2);

  // Warning
  static const warning = Color(0xFFF97316);
  static const warningSurface = Color(0xFFFFF7ED);

  // Info
  static const info = Color(0xFF0EA5E9);
  static const infoSurface = Color(0xFFE0F2FE);

  // Purple - Gov Education / Self-Paced
  static const purple = Color(0xFF7C3AED);
  static const purpleLight = Color(0xFFA78BFA);
  static const purpleSurface = Color(0xFFF5F3FF);

  // Dark Theme
  static const darkBg = Color(0xFF0F172A);
  static const darkSurface = Color(0xFF1E293B);
  static const darkCard = Color(0xFF334155);
  static const darkBorder = Color(0xFF475569);
  static const darkTextPrimary = Color(0xFFF1F5F9);
  static const darkTextSecondary = Color(0xFF94A3B8);
  static const darkTextTertiary = Color(0xFF64748B);

  // Light Theme
  static const lightBg = Color(0xFFF8FAFC);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightCard = Color(0xFFF1F5F9);
  static const lightBorder = Color(0xFFE2E8F0);
  static const lightTextPrimary = Color(0xFF0F172A);
  static const lightTextSecondary = Color(0xFF475569);
  static const lightTextTertiary = Color(0xFF94A3B8);

  // Team Colors
  static const team1 = Color(0xFF3B82F6); // Blue
  static const team2 = Color(0xFF10B981); // Emerald
  static const team3 = Color(0xFFF59E0B); // Amber
  static const team4 = Color(0xFFEF4444); // Red
  static const team5 = Color(0xFF8B5CF6); // Violet
  static const team6 = Color(0xFFEC4899); // Pink
  static const team7 = Color(0xFF06B6D4); // Cyan

  static Color teamColor(int teamIndex) {
    const colors = [team1, team2, team3, team4, team5, team6, team7];
    return colors[teamIndex % colors.length];
  }

  // Theme-aware background gradient
  static LinearGradient backgroundGradient(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: isDark
          ? const [darkBg, darkSurface]
          : const [lightBg, Color(0xFFFFFFFF)],
    );
  }

  // Theme-aware color helpers
  static Color textPrimary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkTextPrimary : lightTextPrimary;
  static Color textSecondary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkTextSecondary : lightTextSecondary;
  static Color textTertiary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkTextTertiary : lightTextTertiary;
  static Color cardColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkCard : lightCard;
  static Color borderColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkBorder : lightBorder;
  static Color bgColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkBg : lightBg;
  static Color surfaceColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkSurface : lightSurface;

  // Gradients
  static const primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const accentGradient = LinearGradient(
    colors: [accent, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const dangerGradient = LinearGradient(
    colors: [danger, dangerLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const darkMeshGradient = LinearGradient(
    colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF0F172A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const heroGradient = LinearGradient(
    colors: [Color(0xFF1A56DB), Color(0xFF7C3AED), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
