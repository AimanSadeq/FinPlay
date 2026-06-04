import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/theme/app_colors.dart';
import '../../providers/repository_providers.dart';
import '../../providers/team_provider.dart';

/// Resolves the current team-leader state: who the leader is (if any) and
/// whether the current user (stored 'player_name') is that leader.
///
/// Returns `leader == null` when no leader is set or there is no team context,
/// in which case callers should NOT lock anything (open behavior).
final teamLeaderStatusProvider =
    FutureProvider.autoDispose<({String? leader, bool amLeader})>((ref) async {
  final team = ref.watch(teamProvider).selectedTeam;
  if (team == null) return (leader: null, amLeader: false);
  final prefs = await SharedPreferences.getInstance();
  final me = prefs.getString('player_name');
  final leader = await ref.read(facilitatorRepositoryProvider).fetchTeamLeader(team.id);
  if (leader == null || leader.isEmpty) return (leader: null, amLeader: false);
  final amLeader = me != null && me.toLowerCase() == leader.toLowerCase();
  return (leader: leader, amLeader: amLeader);
});

/// Participant-facing team-leader gate (matches the website's TeamLeaderGate):
/// when a facilitator has assigned a leader, the leader sees a "you lead" badge
/// and everyone else sees a "view-only" notice. Renders nothing when no leader
/// is set or there is no team context.
class TeamLeaderBanner extends ConsumerStatefulWidget {
  const TeamLeaderBanner({super.key});

  @override
  ConsumerState<TeamLeaderBanner> createState() => _TeamLeaderBannerState();
}

class _TeamLeaderBannerState extends ConsumerState<TeamLeaderBanner> {
  String? _leader;
  String? _me;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final team = ref.read(teamProvider).selectedTeam;
    if (team == null) {
      if (mounted) setState(() => _loaded = true);
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    final me = prefs.getString('player_name');
    final leader = await ref.read(facilitatorRepositoryProvider).fetchTeamLeader(team.id);
    if (mounted) setState(() { _leader = leader; _me = me; _loaded = true; });
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded || _leader == null) return const SizedBox.shrink();
    final amLeader = _me != null && _me!.toLowerCase() == _leader!.toLowerCase();
    final color = amLeader ? AppColors.secondaryLight : AppColors.accentLight;
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(amLeader ? Icons.workspace_premium_rounded : Icons.visibility_rounded, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              amLeader
                  ? 'You are the team leader — you act on behalf of your team.'
                  : 'View-only — $_leader is your team leader and submits decisions.',
              style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
