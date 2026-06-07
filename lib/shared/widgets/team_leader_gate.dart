import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/i18n/app_strings.dart';
import '../../app/theme/app_colors.dart';
import '../../core/utils/constants.dart';
import '../../providers/repository_providers.dart';
import '../../providers/team_provider.dart';

/// Corporate-mode team-leader gate (parity with the website's `TeamLeaderGate`).
///
/// In corporate mode a team must designate ONE leader before it can begin. This
/// shows a blocking self-pick modal whenever a corporate team has no leader yet —
/// any signed-in member designates the leader, then everyone proceeds.
///
/// Returns `true` when the team has a leader (already assigned, or just picked) so
/// the caller can proceed; `false` if the user backed out.
///
/// No-ops (returns `true`) when there is no team context (e.g. self-paced).
Future<bool> showTeamLeaderGate(BuildContext context, WidgetRef ref) async {
  final team = ref.read(teamProvider).selectedTeam;
  if (team == null) return true; // no corporate team — nothing to gate

  // If a leader is already assigned, proceed without prompting.
  final existing = await ref.read(facilitatorRepositoryProvider).fetchTeamLeader(team.id);
  if (existing != null && existing.isNotEmpty) return true;

  if (!context.mounted) return false;
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    builder: (_) => _TeamLeaderGateSheet(teamId: team.id),
  );
  return result ?? false;
}

class _TeamLeaderGateSheet extends ConsumerStatefulWidget {
  final String teamId;
  const _TeamLeaderGateSheet({required this.teamId});

  @override
  ConsumerState<_TeamLeaderGateSheet> createState() => _TeamLeaderGateSheetState();
}

class _TeamLeaderGateSheetState extends ConsumerState<_TeamLeaderGateSheet> {
  List<Map<String, dynamic>> _members = [];
  String? _me;
  String? _picking;
  String? _error;
  bool _loading = true;
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _bootstrap();
    // The leader can change (another member picks) and members can sign in — poll.
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) => _refresh());
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    final prefs = await SharedPreferences.getInstance();
    _me = prefs.getString(AppConstants.playerNameKey);
    await _refresh();
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _refresh() async {
    final repo = ref.read(facilitatorRepositoryProvider);
    // If a leader appeared (this member or another picked one), proceed.
    final leader = await repo.fetchTeamLeader(widget.teamId);
    if (leader != null && leader.isNotEmpty) {
      if (mounted && Navigator.canPop(context)) Navigator.pop(context, true);
      return;
    }
    final members = await repo.fetchTeamSignins(widget.teamId);
    if (mounted) setState(() => _members = members);
  }

  Future<void> _pick(String name) async {
    setState(() { _picking = name; _error = null; });
    final ok = await ref.read(facilitatorRepositoryProvider).selectTeamLeader(widget.teamId, name);
    if (!mounted) return;
    if (ok) {
      if (Navigator.canPop(context)) Navigator.pop(context, true);
      return;
    }
    final s = ref.read(stringsProvider);
    setState(() {
      _picking = null;
      _error = s.tr('Could not set the leader — another member may have just chosen one.',
          'تعذّر التعيين — ربما اختار عضو آخر قائدًا للتو.');
    });
    // Re-check in case someone else won the race.
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 56, height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.workspace_premium_rounded, size: 28, color: Color(0xFFD97706)),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              s.tr('Choose your team leader', 'اختر قائد الفريق'),
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.textPrimary(context),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              s.tr(
                'Before your team can begin, designate one leader. Only the leader makes and confirms decisions — everyone else can explore.',
                'قبل أن يبدأ فريقك، يجب تعيين قائد واحد. القائد فقط يتّخذ القرارات ويؤكّدها؛ بقية الأعضاء يستكشفون فقط.',
              ),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, height: 1.5, color: AppColors.textSecondary(context)),
            ),
            const SizedBox(height: 18),
            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_members.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 22),
                child: Column(
                  children: [
                    Icon(Icons.group_rounded, size: 28, color: AppColors.textTertiary(context)),
                    const SizedBox(height: 8),
                    Text(
                      s.tr('Waiting for team members to sign in…', 'بانتظار تسجيل دخول أعضاء الفريق…'),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: AppColors.textTertiary(context)),
                    ),
                  ],
                ),
              )
            else
              ..._members.map((m) {
                final name = (m['playerName'] ?? m['name'] ?? '').toString();
                if (name.isEmpty) return const SizedBox.shrink();
                final isMe = _me != null && _me!.toLowerCase() == name.toLowerCase();
                final isPicking = _picking == name;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _picking != null ? null : () => _pick(name),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? Colors.white.withValues(alpha: 0.1) : const Color(0xFFE5E7EB),
                          ),
                          color: isDark ? Colors.white.withValues(alpha: 0.03) : const Color(0xFFFAFAFA),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                isMe ? '$name ${s.tr('(you)', '(أنت)')}' : name,
                                style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary(context),
                                ),
                              ),
                            ),
                            if (isPicking)
                              const SizedBox(
                                width: 18, height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFD97706)),
                              )
                            else
                              Icon(Icons.workspace_premium_outlined, size: 18, color: AppColors.textTertiary(context)),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Color(0xFFDC2626))),
            ],
            const SizedBox(height: 12),
            Text(
              s.tr('Your facilitator can re-assign the leader later.',
                  'يمكن للميسّر تغيير القائد لاحقًا.'),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: AppColors.textTertiary(context)),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _picking != null ? null : () => Navigator.pop(context, false),
              child: Text(s.tr('Not now', 'ليس الآن'),
                  style: TextStyle(color: AppColors.textSecondary(context))),
            ),
          ],
        ),
      ),
    );
  }
}
