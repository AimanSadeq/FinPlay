import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finplay/app/theme/app_colors.dart';

void main() {
  group('AppColors', () {
    group('static color constants', () {
      test('primary colors are defined', () {
        expect(AppColors.primary, isNotNull);
        expect(AppColors.primaryLight, isNotNull);
        expect(AppColors.primaryDark, isNotNull);
        expect(AppColors.primarySurface, isNotNull);
      });

      test('secondary colors are defined', () {
        expect(AppColors.secondary, isNotNull);
        expect(AppColors.secondaryLight, isNotNull);
        expect(AppColors.secondaryDark, isNotNull);
        expect(AppColors.secondarySurface, isNotNull);
      });

      test('accent colors are defined', () {
        expect(AppColors.accent, isNotNull);
        expect(AppColors.accentLight, isNotNull);
        expect(AppColors.accentDark, isNotNull);
        expect(AppColors.accentSurface, isNotNull);
      });

      test('danger colors are defined', () {
        expect(AppColors.danger, isNotNull);
        expect(AppColors.dangerLight, isNotNull);
        expect(AppColors.dangerSurface, isNotNull);
      });

      test('purple colors are defined', () {
        expect(AppColors.purple, const Color(0xFF7C3AED));
        expect(AppColors.purpleLight, const Color(0xFFA78BFA));
        expect(AppColors.purpleSurface, const Color(0xFFF5F3FF));
      });

      test('dark theme colors are defined', () {
        expect(AppColors.darkBg, isNotNull);
        expect(AppColors.darkSurface, isNotNull);
        expect(AppColors.darkCard, isNotNull);
        expect(AppColors.darkBorder, isNotNull);
        expect(AppColors.darkTextPrimary, isNotNull);
        expect(AppColors.darkTextSecondary, isNotNull);
        expect(AppColors.darkTextTertiary, isNotNull);
      });

      test('light theme colors are defined', () {
        expect(AppColors.lightBg, isNotNull);
        expect(AppColors.lightSurface, isNotNull);
        expect(AppColors.lightCard, isNotNull);
        expect(AppColors.lightBorder, isNotNull);
        expect(AppColors.lightTextPrimary, isNotNull);
        expect(AppColors.lightTextSecondary, isNotNull);
        expect(AppColors.lightTextTertiary, isNotNull);
      });
    });

    group('teamColor', () {
      test('returns correct colors for indices 0-6', () {
        expect(AppColors.teamColor(0), AppColors.team1);
        expect(AppColors.teamColor(1), AppColors.team2);
        expect(AppColors.teamColor(2), AppColors.team3);
        expect(AppColors.teamColor(3), AppColors.team4);
        expect(AppColors.teamColor(4), AppColors.team5);
        expect(AppColors.teamColor(5), AppColors.team6);
        expect(AppColors.teamColor(6), AppColors.team7);
      });

      test('wraps around for indices >= 7', () {
        expect(AppColors.teamColor(7), AppColors.team1);
        expect(AppColors.teamColor(8), AppColors.team2);
        expect(AppColors.teamColor(14), AppColors.team1);
      });

      test('handles large indices without crash', () {
        expect(() => AppColors.teamColor(100), returnsNormally);
        expect(AppColors.teamColor(100), isNotNull);
      });
    });

    group('predefined gradients', () {
      test('primaryGradient has correct colors', () {
        expect(AppColors.primaryGradient.colors, [AppColors.primary, AppColors.primaryLight]);
      });

      test('secondaryGradient has correct colors', () {
        expect(AppColors.secondaryGradient.colors, [AppColors.secondary, AppColors.secondaryLight]);
      });

      test('accentGradient has correct colors', () {
        expect(AppColors.accentGradient.colors, [AppColors.accent, AppColors.accentLight]);
      });

      test('dangerGradient has correct colors', () {
        expect(AppColors.dangerGradient.colors, [AppColors.danger, AppColors.dangerLight]);
      });

      test('heroGradient has three colors', () {
        expect(AppColors.heroGradient.colors.length, 3);
      });
    });

    group('theme-aware helpers', () {
      testWidgets('textPrimary returns dark variant in dark mode', (tester) async {
        late Color result;
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: Builder(
              builder: (context) {
                result = AppColors.textPrimary(context);
                return const SizedBox();
              },
            ),
          ),
        );
        expect(result, AppColors.darkTextPrimary);
      });

      testWidgets('textPrimary returns light variant in light mode', (tester) async {
        late Color result;
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: Builder(
              builder: (context) {
                result = AppColors.textPrimary(context);
                return const SizedBox();
              },
            ),
          ),
        );
        expect(result, AppColors.lightTextPrimary);
      });

      testWidgets('cardColor returns dark variant in dark mode', (tester) async {
        late Color result;
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: Builder(
              builder: (context) {
                result = AppColors.cardColor(context);
                return const SizedBox();
              },
            ),
          ),
        );
        expect(result, AppColors.darkCard);
      });

      testWidgets('backgroundGradient returns dark gradient in dark mode', (tester) async {
        late LinearGradient result;
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: Builder(
              builder: (context) {
                result = AppColors.backgroundGradient(context);
                return const SizedBox();
              },
            ),
          ),
        );
        expect(result.colors, contains(AppColors.darkBg));
      });

      testWidgets('backgroundGradient returns light gradient in light mode', (tester) async {
        late LinearGradient result;
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: Builder(
              builder: (context) {
                result = AppColors.backgroundGradient(context);
                return const SizedBox();
              },
            ),
          ),
        );
        expect(result.colors, contains(AppColors.lightBg));
      });
    });
  });
}
