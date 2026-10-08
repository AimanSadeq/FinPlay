import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/i18n/app_strings.dart';
import '../../core/utils/constants.dart';
import '../../providers/repository_providers.dart';
import '../../providers/socket_provider.dart';
import '../../providers/team_provider.dart';

// GET /api/roles/{teamId} -> { success, roles: [{ playerName, role, assignedAt }] } (public).
// Roles are picked in the lobby (POST /api/roles/assign); the server broadcasts
// 'team:roles_updated' { teamId } to the team room on every change.
const String _rolesPath = '/roles';

/// Team member roles (advisory v1, website TeamRoleBadge): CFO / Treasurer / Risk Officer /
/// Analyst. Purely informational; the Risk Officer is highlighted on the Hedge Desk.
class TeamRoleMeta {
  final String id;
  final String icon;
  final String en;
  final String ar;
  final Color fg;
  final Color bg;
  final Color border;
  const TeamRoleMeta(this.id, this.icon, this.en, this.ar, this.fg, this.bg, this.border);

  String label(AppStrings s) => s.tr(en, ar);
}

const Map<String, TeamRoleMeta> kTeamRoles = {
  'cfo': TeamRoleMeta('cfo', '👔', 'CFO', 'المدير المالي', Color(0xFF92400E), Color(0xFFFEF3C7),
      Color(0xFFFCD34D)),
  'treasurer': TeamRoleMeta('treasurer', '💰', 'Treasurer', 'أمين الخزينة', Color(0xFF065F46),
      Color(0xFFD1FAE5), Color(0xFF6EE7B7)),
  'risk_officer': TeamRoleMeta('risk_officer', '🛡️', 'Risk Officer', 'مسؤول المخاطر',
      Color(0xFF991B1B), Color(0xFFFEE2E2), Color(0xFFFCA5A5)),
  'analyst': TeamRoleMeta('analyst', '📊', 'Analyst', 'محلل', Color(0xFF334155), Color(0xFFF1F5F9),
      Color(0xFFCBD5E1)),
};

class TeamRoleAssignment {
  final String playerName;
  final String role;
  const TeamRoleAssignment(this.playerName, this.role);
}

bool _samePlayer(String a, String b) =>
    a.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ') ==
    b.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

/// A team's role assignments; refreshed whenever the team room hears 'team:roles_updated'
/// (no polling: the website polls every 15 s only because its sync context hides the socket).
final teamRolesProvider =
    FutureProvider.autoDispose.family<List<TeamRoleAssignment>, String>((ref, teamId) async {
  final sub = ref.read(socketManagerProvider).onEvent('team:roles_updated').listen(
        (_) => ref.invalidateSelf(),
        onError: (_) {},
      );
  ref.onDispose(sub.cancel);
  if (teamId.isEmpty) return const [];
  try {
    final res = await ref.read(apiClientProvider).get('$_rolesPath/${Uri.encodeComponent(teamId)}');
    final list = res['roles'];
    if (list is! List) return const [];
    return [
      for (final r in list)
        if (r is Map && r['playerName'] != null && kTeamRoles.containsKey(r['role']))
          TeamRoleAssignment(r['playerName'].toString(), r['role'].toString()),
    ];
  } catch (_) {
    return const [];
  }
});

/// This device's player name for the corporate team (stored at lobby sign-in).
final playerNameProvider = FutureProvider.autoDispose<String?>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final name = prefs.getString(AppConstants.playerNameKey);
  return (name == null || name.trim().isEmpty) ? null : name;
});

/// This player's own role on the selected team, or null (none picked / no team).
final myTeamRoleProvider = Provider.autoDispose<String?>((ref) {
  final team = ref.watch(teamProvider).selectedTeam;
  if (team == null) return null;
  final me = ref.watch(playerNameProvider).valueOrNull;
  if (me == null) return null;
  final roles = ref.watch(teamRolesProvider(team.id)).valueOrNull ?? const [];
  for (final r in roles) {
    if (_samePlayer(r.playerName, me)) return r.role;
  }
  return null;
});

/// Tiny inline chip showing a teammate's role. Renders nothing for an unknown role.
class TeamRoleBadge extends ConsumerWidget {
  final String role;
  final bool small;
  const TeamRoleBadge({super.key, required this.role, this.small = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meta = kTeamRoles[role];
    if (meta == null) return const SizedBox.shrink();
    final s = ref.watch(stringsProvider);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: small ? 6 : 8, vertical: small ? 1 : 3),
      decoration: BoxDecoration(
        color: meta.bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: meta.border),
      ),
      child: Text(
        '${meta.icon} ${meta.label(s)}',
        style: TextStyle(fontSize: small ? 10 : 12, fontWeight: FontWeight.w600, color: meta.fg),
      ),
    );
  }
}

/// Bottom sheet listing the team's role assignments (what the website shows in the team
/// sync tooltip next to each teammate's name).
Future<void> showTeamRolesSheet(BuildContext context, String teamId, String teamName) {
  return showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (ctx) => _TeamRolesSheet(teamId: teamId, teamName: teamName),
  );
}

class _TeamRolesSheet extends ConsumerWidget {
  final String teamId;
  final String teamName;
  const _TeamRolesSheet({required this.teamId, required this.teamName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    final roles = ref.watch(teamRolesProvider(teamId));
    final me = ref.watch(playerNameProvider).valueOrNull;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              s.tr('$teamName roles', 'أدوار $teamName'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              s.tr('Roles are advisory: players pick one when they join the team.',
                  'الأدوار استرشادية: يختار كل لاعب دوره عند الانضمام إلى الفريق.'),
              style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor),
            ),
            const SizedBox(height: 12),
            roles.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(12),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (_, _) => const SizedBox.shrink(),
              data: (list) => list.isEmpty
                  ? Text(s.tr('No roles picked yet.', 'لم يختر أحد دورًا بعد.'))
                  : Column(
                      children: [
                        for (final r in list)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    me != null && _samePlayer(me, r.playerName)
                                        ? s.tr('${r.playerName} (you)', '${r.playerName} (أنت)')
                                        : r.playerName,
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                ),
                                TeamRoleBadge(role: r.role, small: false),
                              ],
                            ),
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
