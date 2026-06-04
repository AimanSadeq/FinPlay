import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/i18n/app_strings.dart';
import '../../../shared/widgets/glass_card.dart';


class GovLobbyScreen extends ConsumerWidget {
  const GovLobbyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient(context)),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  children: [
                    IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
                    const Spacer(),
                    Text(s.tr('Government Education', 'تعليم القطاع الحكومي'), style: Theme.of(context).textTheme.headlineMedium),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
              ).animate().fadeIn(),

              const SizedBox(height: 8),

              Text(
                s.tr('Select your team to begin', 'اختر فريقك للبدء'),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary(context),
                ),
              ).animate().fadeIn(delay: 200.ms),

              const SizedBox(height: 24),

              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    final color = AppColors.teamColor(index);
                    return GlassCard(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        context.push('/gov-education/hub');
                      },
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: color.withValues(alpha: 0.4), width: 2),
                            ),
                            child: Icon(Icons.account_balance_rounded, color: color, size: 24),
                          ),
                          const SizedBox(height: 12),
                          Text(s.tr('Team ${index + 1}', 'الفريق ${index + 1}'), style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 4),
                          Text(s.tr('0 modules', '0 وحدة'), style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ).animate().fadeIn(delay: (100 * index).ms).scale(begin: const Offset(0.9, 0.9));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
