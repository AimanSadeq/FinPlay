import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/i18n/app_strings.dart';
import '../../../app/theme/app_colors.dart';

class ProgramSelectorScreen extends StatelessWidget {
  const ProgramSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [AppColors.darkBg, AppColors.darkSurface]
                : [const Color(0xFFF0F9FF), const Color(0xFFF0FDF4), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Consumer(builder: (context, ref, _) {
          final s = ref.watch(stringsProvider);
          return Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: Row(
                  children: [
                    IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.admin_panel_settings_rounded, color: AppColors.dangerLight),
                      tooltip: s.tr('Facilitator', 'الميسّر'),
                      onPressed: () => context.push('/facilitator'),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms),

              // Title
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                child: Column(
                  children: [
                    Text(
                      s.tr('Choose Your Program', 'اختر برنامجك'),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary(context),
                      ),
                    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),
                    const SizedBox(height: 6),
                    Text(
                      s.tr('Select the learning path that fits your needs', 'اختر مسار التعلّم الذي يناسب احتياجاتك'),
                      style: TextStyle(fontSize: 14, color: AppColors.textTertiary(context)),
                    ).animate().fadeIn(delay: 200.ms),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Program Cards
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // Private Finance
                      _ProgramCard(
                        title: s.tr('Private Finance (IFRS)', 'المالية الخاصة (IFRS)'),
                        subtitle: s.tr('FinPlay Simulation', 'محاكاة FinPlay'),
                        description: s.tr('Team-based strategic finance game with 3 rounds of financing, investing, and operating decisions using real IFRS financial statements.', 'لعبة مالية استراتيجية جماعية من 3 جولات لقرارات التمويل والاستثمار والتشغيل باستخدام قوائم مالية حقيقية وفق معايير IFRS.'),
                        icon: Icons.business_rounded,
                        gradient: const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF2563EB)]),
                        features: [s.tr('3-Round Game', 'لعبة من 3 جولات'), s.tr('IFRS Standards', 'معايير IFRS'), s.tr('Team Competition', 'منافسة جماعية'), s.tr('Real-time Sync', 'مزامنة فورية')],
                        buttonText: s.tr('Enter FinPlay', 'ادخل FinPlay'),
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          context.push('/lobby');
                        },
                        isDark: isDark,
                      ).animate().fadeIn(delay: 300.ms, duration: 500.ms).slideY(begin: 0.1),

                      const SizedBox(height: 18),

                      // Government Finance
                      _ProgramCard(
                        title: s.tr('Government Finance (IPSAS)', 'المالية الحكومية (IPSAS)'),
                        subtitle: s.tr('10-Module Education', 'برنامج تعليمي من 10 وحدات'),
                        description: s.tr('Comprehensive public sector finance education covering IPSAS standards, government budgeting, compliance, and financial auditing.', 'تعليم شامل لمالية القطاع العام يغطي معايير IPSAS وإعداد الموازنة الحكومية والامتثال والتدقيق المالي.'),
                        icon: Icons.account_balance_rounded,
                        gradient: const LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFF6D28D9)]),
                        features: [s.tr('10 Modules', '10 وحدات'), s.tr('IPSAS Standards', 'معايير IPSAS'), s.tr('Quizzes & Games', 'اختبارات وألعاب'), s.tr('Bilingual', 'ثنائي اللغة')],
                        buttonText: s.tr('Start Learning', 'ابدأ التعلّم'),
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          context.push('/gov-education');
                        },
                        isDark: isDark,
                      ).animate().fadeIn(delay: 450.ms, duration: 500.ms).slideY(begin: 0.1),

                      const SizedBox(height: 24),

                      // Stats
                      Row(
                        children: [
                          _StatBox('2', s.tr('Tracks', 'مسارات'), const Color(0xFF3B82F6), isDark),
                          const SizedBox(width: 10),
                          _StatBox('12+', s.tr('Modules', 'وحدات'), const Color(0xFF10B981), isDark),
                          const SizedBox(width: 10),
                          _StatBox('IFRS', s.tr('Standard', 'معيار'), const Color(0xFFF59E0B), isDark),
                          const SizedBox(width: 10),
                          _StatBox('IPSAS', s.tr('Standard', 'معيار'), const Color(0xFF7C3AED), isDark),
                        ],
                      ).animate().fadeIn(delay: 600.ms),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          );
          }),
        ),
      ),
    );
  }
}

class _ProgramCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Gradient gradient;
  final List<String> features;
  final String buttonText;
  final VoidCallback onTap;
  final bool isDark;

  const _ProgramCard({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.gradient,
    required this.features,
    required this.buttonText,
    required this.onTap,
    required this.isDark,
  });

  @override
  State<_ProgramCard> createState() => _ProgramCardState();
}

class _ProgramCardState extends State<_ProgramCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final gradientColors = widget.gradient is LinearGradient
        ? (widget.gradient as LinearGradient).colors
        : [AppColors.primary, AppColors.primaryLight];
    final baseColor = gradientColors.isNotEmpty ? gradientColors.first : AppColors.primary;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          decoration: BoxDecoration(
            color: widget.isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _pressed ? baseColor.withValues(alpha: 0.5) : (widget.isDark ? AppColors.darkBorder.withValues(alpha: 0.3) : const Color(0xFFE2E8F0)),
              width: _pressed ? 2 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: _pressed ? baseColor.withValues(alpha: 0.15) : Colors.black.withValues(alpha: widget.isDark ? 0.15 : 0.05),
                blurRadius: _pressed ? 20 : 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Gradient header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: widget.gradient,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(19),
                    topRight: Radius.circular(19),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(widget.icon, color: Colors.white, size: 32),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 19, fontWeight: FontWeight.w700, color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.subtitle,
                      style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.8)),
                    ),
                  ],
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                child: Column(
                  children: [
                    Text(
                      widget.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, height: 1.5, color: AppColors.textSecondary(context)),
                    ),
                    const SizedBox(height: 14),

                    // Feature chips
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      alignment: WrapAlignment.center,
                      children: widget.features.map((f) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: baseColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: baseColor.withValues(alpha: 0.15)),
                        ),
                        child: Text(f, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: baseColor)),
                      )).toList(),
                    ),

                    const SizedBox(height: 16),

                    // CTA
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        gradient: widget.gradient,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: baseColor.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 3)),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(widget.buttonText, style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
                          const SizedBox(width: 6),
                          const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final bool isDark;

  const _StatBox(this.value, this.label, this.color, this.isDark);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text(value, style: GoogleFonts.jetBrainsMono(fontSize: 16, fontWeight: FontWeight.w700, color: color)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 10, color: AppColors.textTertiary(context))),
          ],
        ),
      ),
    );
  }
}
