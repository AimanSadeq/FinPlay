import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/i18n/app_strings.dart';
import '../../../providers/repository_providers.dart';

/// Entry point to the Earnings Call for corporate teams: a tappable banner that
/// only appears once the facilitator opens the call (stage prep or live). The
/// website has no in-app link — the facilitator sends teams to the URL — so this
/// is how the app surfaces the event without an extra navigation step.
class EarningsCallBanner extends ConsumerStatefulWidget {
  const EarningsCallBanner({super.key});

  @override
  ConsumerState<EarningsCallBanner> createState() => _EarningsCallBannerState();
}

class _EarningsCallBannerState extends ConsumerState<EarningsCallBanner> {
  String _stage = 'off';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _refresh();
    _timer = Timer.periodic(const Duration(seconds: 20), (_) => _refresh());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _refresh() async {
    try {
      final state = await ref.read(earningsCallRepositoryProvider).status();
      final stage = state['stage']?.toString() ?? 'off';
      if (mounted && stage != _stage) setState(() => _stage = stage);
    } catch (_) {
      // Leave the banner as-is; the call is optional context.
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_stage == 'off') return const SizedBox.shrink();
    final s = ref.watch(stringsProvider);
    final live = _stage == 'live';
    final color = live ? const Color(0xFFDC2626) : const Color(0xFF2563EB);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: InkWell(
        onTap: () => context.push('/earnings-call'),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.35)),
          ),
          child: Row(
            children: [
              Icon(Icons.podcasts_rounded, size: 18, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  live
                      ? s.tr('Earnings Call is LIVE — open your analyst questions',
                          'مكالمة الأرباح مباشرة — افتحوا أسئلة المحلل')
                      : s.tr('Earnings Call prep is open — build your story',
                          'بدأ التحضير لمكالمة الأرباح — جهّزوا عرضكم'),
                  style: TextStyle(
                      fontSize: 12.5, fontWeight: FontWeight.w600, color: color),
                ),
              ),
              Icon(Icons.chevron_right_rounded, size: 20, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
