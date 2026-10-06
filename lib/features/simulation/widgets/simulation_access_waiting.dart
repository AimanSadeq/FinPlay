import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/i18n/app_strings.dart';
import '../../../app/theme/app_colors.dart';
import '../../../providers/simulation_access_provider.dart';

/// Shown to a corporate team member in place of the simulation while the
/// facilitator's switch (GET /facilitator/simulation-access) is closed. The
/// website dims the simulation tile with the same meaning; the app shows this
/// screen because its simulation is a full route, not a tile.
///
/// Re-reads the switch every 15 seconds, the website's refetch interval, and
/// the socket push from the facilitator panel lands in the same provider, so
/// the simulation screen rebuilds the moment the gate opens.
class SimulationAccessWaiting extends ConsumerStatefulWidget {
  const SimulationAccessWaiting({super.key});

  /// The website polls the switch at this interval (home.tsx, education-hub.tsx).
  static const Duration pollInterval = Duration(seconds: 15);

  @override
  ConsumerState<SimulationAccessWaiting> createState() =>
      _SimulationAccessWaitingState();
}

class _SimulationAccessWaitingState
    extends ConsumerState<SimulationAccessWaiting> {
  Timer? _poll;

  @override
  void initState() {
    super.initState();
    _poll = Timer.periodic(
      SimulationAccessWaiting.pollInterval,
      (_) => ref.read(simulationAccessProvider.notifier).refresh(),
    );
  }

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient(context)),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.hourglass_top_rounded,
                        size: 40, color: Color(0xFFF59E0B)),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    // The website's locked simulation banner (education-hub.tsx).
                    s.tr('Locked by facilitator', 'مغلق بواسطة المشرف'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    // The website's dimmed simulation tile on /home (home.tsx).
                    s.tr(
                      'Complete the learning modules first',
                      'أكمل وحدات التعلم أولاً',
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary(context),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      // The website sends a learner who taps the dimmed tile to
                      // the modules they still need to finish.
                      onPressed: () => context.push('/education'),
                      icon: const Icon(Icons.school_rounded),
                      label: Text(s.tr('Go to the learning modules', 'الذهاب إلى وحدات التعلّم')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back_rounded, size: 18),
                    label: Text(s.tr('Go Back', 'رجوع')),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
