import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/i18n/app_strings.dart';
import '../data/badge_models.dart';
import '../providers/achievements_providers.dart';

enum BadgeShelfSize { sm, md, lg }

/// Compact strip of earned badge emojis (website components/BadgeShelf.tsx). Tap a badge
/// for its name, round and description. Renders nothing when there are no badges.
///
///   BadgeShelf.team('Team 3', size: BadgeShelfSize.sm, maxVisible: 5) // leaderboard row
///   const BadgeShelf.mine(size: BadgeShelfSize.lg)                     // the current player
class BadgeShelf extends ConsumerWidget {
  final String? teamId;
  final BadgeShelfSize size;
  final int? maxVisible;

  const BadgeShelf.team(String this.teamId, {super.key, this.size = BadgeShelfSize.md, this.maxVisible});
  const BadgeShelf.mine({super.key, this.size = BadgeShelfSize.md, this.maxVisible}) : teamId = null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = teamId != null ? ref.watch(teamBadgesProvider(teamId!)) : ref.watch(myBadgesProvider);
    final badges = async.valueOrNull ?? const <EarnedBadge>[];
    return BadgeShelfStrip(badges: badges, size: size, maxVisible: maxVisible);
  }
}

/// Presentational strip, for callers that already hold the badge list.
class BadgeShelfStrip extends ConsumerWidget {
  final List<EarnedBadge> badges;
  final BadgeShelfSize size;
  final int? maxVisible;

  const BadgeShelfStrip({super.key, required this.badges, this.size = BadgeShelfSize.md, this.maxVisible});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (badges.isEmpty) return const SizedBox.shrink();
    final s = ref.watch(stringsProvider);
    final unique = uniqueEarliest(badges);
    final visible = maxVisible != null ? unique.take(maxVisible!).toList() : unique;
    final hidden = unique.length - visible.length;
    final (double box, double font) = switch (size) {
      BadgeShelfSize.sm => (22.0, 12.0),
      BadgeShelfSize.md => (32.0, 17.0),
      BadgeShelfSize.lg => (44.0, 24.0),
    };

    return Wrap(
      spacing: 3,
      runSpacing: 3,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final b in visible)
          Tooltip(
            triggerMode: TooltipTriggerMode.tap,
            showDuration: const Duration(seconds: 4),
            message: '${b.icon} ${b.localizedName(s.ar)}'
                '${b.roundNum != null && b.roundNum! > 0 ? ' · ${s.tr('Round', 'الجولة')} ${b.roundNum}' : ''}'
                '\n${b.localizedDescription(s.ar)}',
            child: Semantics(
              label: b.localizedName(s.ar),
              child: Container(
                width: box,
                height: box,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFFBEB),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: Text(b.icon, style: TextStyle(fontSize: font, height: 1)),
              ),
            ),
          ),
        if (hidden > 0)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 2),
            child: Text('+$hidden',
                style: TextStyle(fontSize: font * 0.6 + 4, fontWeight: FontWeight.w600, color: Colors.grey.shade600)),
          ),
      ],
    );
  }
}
