import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/i18n/app_strings.dart';
import '../../../providers/team_provider.dart';
import '../../../providers/game_state_provider.dart';

class GameMapScreen extends ConsumerWidget {
  const GameMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    final team = ref.watch(teamProvider).selectedTeam;
    final gameState = ref.watch(gameStateProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final currentRound = gameState.whenData((gs) => gs.currentRound).value ?? team?.currentRound ?? 1;
    final currentModule = gameState.whenData((gs) => gs.currentModule).value ?? team?.currentModule ?? 'financing';

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [AppColors.darkBg, AppColors.darkSurface]
                : [const Color(0xFFF0F9FF), Colors.white],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  child: Row(
                    children: [
                      IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
                      const Spacer(),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.map_rounded, color: AppColors.primaryLight, size: 18),
                          ),
                          const SizedBox(width: 8),
                          Text(s.tr('Game Map', 'خريطة اللعبة'), style: Theme.of(context).textTheme.headlineMedium),
                        ],
                      ),
                      const Spacer(),
                      const SizedBox(width: 48),
                    ],
                  ),
                ).animate().fadeIn(duration: 300.ms),
              ),

              // Game Overview Stats
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      _OverviewChip(s.tr('3 Days', '3 أيام'), Icons.calendar_today_rounded, const Color(0xFF3B82F6), isDark),
                      const SizedBox(width: 8),
                      _OverviewChip(s.tr('3 Rounds', '3 جولات'), Icons.flag_rounded, const Color(0xFF10B981), isDark),
                      const SizedBox(width: 8),
                      _OverviewChip(s.tr('7 Teams', '7 فرق'), Icons.groups_rounded, const Color(0xFFF59E0B), isDark),
                      const SizedBox(width: 8),
                      _OverviewChip(s.tr('3 Modules', '3 وحدات'), Icons.view_module_rounded, const Color(0xFF7C3AED), isDark),
                    ],
                  ).animate().fadeIn(delay: 150.ms),
                ),
              ),

              // Team info
              if (team != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.teamColor(team.teamNumber - 1).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36, height: 36,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                AppColors.teamColor(team.teamNumber - 1),
                                AppColors.teamColor(team.teamNumber - 1).withValues(alpha: 0.7),
                              ]),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(child: Text(
                              '${team.teamNumber}',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                            )),
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(team.name, style: Theme.of(context).textTheme.titleSmall),
                              Text(
                                s.tr('Round $currentRound  \u2022  ${_moduleLabel(currentModule, s)}',
                                    '\u0627\u0644\u062c\u0648\u0644\u0629 $currentRound  \u2022  ${_moduleLabel(currentModule, s)}'),
                                style: TextStyle(fontSize: 12, color: AppColors.textTertiary(context)),
                              ),
                            ],
                          )),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              s.tr('ACTIVE', 'نشط'),
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primaryLight, letterSpacing: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 200.ms),
                  ),
                ),

              // Game Flow - Start node
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _FlowNode(
                    label: s.tr('Lobby', 'الردهة'),
                    subtitle: s.tr('Join your team', 'انضم إلى فريقك'),
                    icon: Icons.groups_rounded,
                    color: AppColors.secondaryLight,
                    isCompleted: true,
                    isDark: isDark,
                  ).animate().fadeIn(delay: 250.ms),
                ),
              ),

              // Connector
              SliverToBoxAdapter(child: _Connector(isDark: isDark)),

              // Rounds
              ...List.generate(3, (roundIndex) {
                final roundNum = roundIndex + 1;
                final isRoundDone = roundNum < currentRound;
                final isCurrentRound = roundNum == currentRound;
                final isFuture = roundNum > currentRound;

                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        // Round header
                        _RoundHeader(
                          roundNum: roundNum,
                          isCompleted: isRoundDone,
                          isCurrent: isCurrentRound,
                          isDark: isDark,
                        ).animate().fadeIn(delay: (300 + 120 * roundIndex).ms),

                        const SizedBox(height: 10),

                        // 3 Module cards inside round
                        ...['financing', 'investing', 'operating'].asMap().entries.map((entry) {
                          final moduleIndex = entry.key;
                          final moduleName = entry.value;
                          final isModuleDone = isRoundDone ||
                              (isCurrentRound && _moduleOrder(moduleName) < _moduleOrder(currentModule));
                          final isCurrentModule = isCurrentRound && moduleName == currentModule;

                          final icons = [
                            Icons.account_balance_wallet_rounded,
                            Icons.trending_up_rounded,
                            Icons.settings_rounded,
                          ];
                          final colors = [
                            const Color(0xFF3B82F6),
                            const Color(0xFF10B981),
                            const Color(0xFFF59E0B),
                          ];
                          final durations = [s.tr('20 min', '20 دقيقة'), s.tr('15 min', '15 دقيقة'), s.tr('25 min', '25 دقيقة')];
                          final scenarioCounts = [s.tr('8 scenarios', '8 سيناريوهات'), s.tr('6 scenarios', '6 سيناريوهات'), s.tr('9 scenarios', '9 سيناريوهات')];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: _ModuleRow(
                              label: _moduleLabel(moduleName, s),
                              icon: icons[moduleIndex],
                              color: colors[moduleIndex],
                              duration: durations[moduleIndex],
                              scenarioCount: scenarioCounts[moduleIndex],
                              isCompleted: isModuleDone,
                              isCurrent: isCurrentModule,
                              isLocked: isFuture || (!isModuleDone && !isCurrentModule),
                              isDark: isDark,
                            ),
                          ).animate().fadeIn(delay: (350 + 120 * roundIndex + 60 * moduleIndex).ms);
                        }),

                        if (roundIndex < 2) _Connector(isDark: isDark),
                      ],
                    ),
                  ),
                );
              }),

              // Final connector + Results
              SliverToBoxAdapter(child: _Connector(isDark: isDark)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _FlowNode(
                    label: s.tr('Results & Dashboard', 'النتائج ولوحة المعلومات'),
                    subtitle: s.tr('View performance & leaderboard', 'عرض الأداء ولوحة المتصدّرين'),
                    icon: Icons.emoji_events_rounded,
                    color: AppColors.accentLight,
                    isCompleted: currentRound > 3,
                    isDark: isDark,
                  ).animate().fadeIn(delay: 800.ms),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        ),
      ),
    );
  }

  String _moduleLabel(String module, AppStrings s) {
    switch (module) {
      case 'financing': return s.tr('Financing', 'التمويل');
      case 'investing': return s.tr('Investing', 'الاستثمار');
      case 'operating': return s.tr('Operating', 'التشغيل');
      default: return module;
    }
  }

  int _moduleOrder(String module) {
    switch (module) {
      case 'financing': return 0;
      case 'investing': return 1;
      case 'operating': return 2;
      default: return 0;
    }
  }
}

// ──────────────────────────────────────
// Flow diagram widgets
// ──────────────────────────────────────

class _OverviewChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isDark;

  const _OverviewChip(this.label, this.icon, this.color, this.isDark);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
      ),
    );
  }
}

class _FlowNode extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isCompleted;
  final bool isDark;

  const _FlowNode({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.isCompleted,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0.8)],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.25), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: GoogleFonts.plusJakartaSans(
                  fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white,
                )),
                Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.8))),
              ],
            ),
          ),
          if (isCompleted)
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 22),
        ],
      ),
    );
  }
}

class _Connector extends StatelessWidget {
  final bool isDark;
  const _Connector({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Center(
        child: Column(
          children: List.generate(3, (i) => Container(
            width: 2,
            height: 5,
            margin: const EdgeInsets.symmetric(vertical: 1),
            decoration: BoxDecoration(
              color: (isDark ? AppColors.darkBorder : AppColors.lightBorder).withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(1),
            ),
          )),
        ),
      ),
    );
  }
}

class _RoundHeader extends ConsumerWidget {
  final int roundNum;
  final bool isCompleted;
  final bool isCurrent;
  final bool isDark;

  const _RoundHeader({
    required this.roundNum,
    required this.isCompleted,
    required this.isCurrent,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    final color = isCompleted
        ? AppColors.secondaryLight
        : isCurrent
            ? AppColors.primaryLight
            : AppColors.textTertiary(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurface
            : (isCurrent ? const Color(0xFFEFF6FF) : Colors.white),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrent ? AppColors.primaryLight.withValues(alpha: 0.4) : (isDark ? AppColors.darkBorder.withValues(alpha: 0.3) : const Color(0xFFE2E8F0)),
          width: isCurrent ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isCompleted
                  ? AppColors.secondaryGradient
                  : isCurrent
                      ? AppColors.primaryGradient
                      : null,
              color: isCompleted || isCurrent ? null : (isDark ? AppColors.darkCard : const Color(0xFFF1F5F9)),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                  : Text(
                      '$roundNum',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: isCurrent ? Colors.white : color,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            s.tr('Round $roundNum \u2014 Year $roundNum', '\u0627\u0644\u062c\u0648\u0644\u0629 $roundNum \u2014 \u0627\u0644\u0633\u0646\u0629 $roundNum'),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16, fontWeight: FontWeight.w600, color: color,
            ),
          ),
          const Spacer(),
          if (isCompleted)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.secondaryLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(s.tr('Done', 'مكتمل'), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.secondaryLight)),
            )
          else if (isCurrent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(s.tr('Active', 'نشط'), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.primaryLight)),
            ),
        ],
      ),
    );
  }
}

class _ModuleRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final String duration;
  final String scenarioCount;
  final bool isCompleted;
  final bool isCurrent;
  final bool isLocked;
  final bool isDark;

  const _ModuleRow({
    required this.label,
    required this.icon,
    required this.color,
    required this.duration,
    required this.scenarioCount,
    required this.isCompleted,
    required this.isCurrent,
    required this.isLocked,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isLocked ? 0.45 : 1.0,
      child: Container(
        margin: const EdgeInsets.only(left: 16),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isCurrent
              ? color.withValues(alpha: isDark ? 0.08 : 0.04)
              : (isDark ? AppColors.darkSurface.withValues(alpha: 0.5) : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isCurrent ? color.withValues(alpha: 0.4) : (isDark ? AppColors.darkBorder.withValues(alpha: 0.2) : const Color(0xFFE2E8F0)),
            width: isCurrent ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                color: isCompleted
                    ? color.withValues(alpha: 0.15)
                    : isCurrent
                        ? color.withValues(alpha: 0.12)
                        : (isDark ? AppColors.darkCard : const Color(0xFFF8FAFC)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: isCompleted || isCurrent ? color : AppColors.textTertiary(context)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary(context))),
                  Text('$duration \u2022 $scenarioCount', style: TextStyle(fontSize: 11, color: AppColors.textTertiary(context))),
                ],
              ),
            ),
            if (isCompleted)
              const Icon(Icons.check_circle_rounded, color: AppColors.secondaryLight, size: 18)
            else if (isCurrent)
              Container(
                width: 8, height: 8,
                decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              )
            else
              Icon(Icons.lock_outline_rounded, size: 16, color: AppColors.textTertiary(context)),
          ],
        ),
      ),
    );
  }
}
