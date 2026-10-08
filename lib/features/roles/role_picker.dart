import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/i18n/app_strings.dart';
import '../../providers/repository_providers.dart';
import 'team_roles.dart';

// POST /api/roles/assign { teamId, playerName, role } -> { success, data } | 409
// { success:false, error:'Role already taken by X' }. Public (the website sends no token).
const String _assignPath = '/roles/assign';
const String _rolesPath = '/roles';

/// The four roles in the order the website's lobby offers them, with its descriptions.
const List<(String, String, String)> kRoleOptions = [
  ('cfo', 'Leads the team and confirms decisions', 'يقود الفريق ويؤكد القرارات'),
  ('treasurer', 'Watches cash and ratios', 'يراقب النقد والنسب'),
  ('risk_officer', 'Leads shock response', 'يقود الاستجابة للصدمات'),
  ('analyst', 'Evaluates scenarios', 'يقيّم السيناريوهات'),
];

/// Name of the OTHER player holding a unique role (null if free, held by me, or analyst).
String? roleTakenBy(String role, List<TeamRoleAssignment> roles, String me) {
  if (role == 'analyst') return null; // analyst is unlimited
  for (final r in roles) {
    if (r.role == role && r.playerName.trim().toLowerCase() != me.trim().toLowerCase()) {
      return r.playerName;
    }
  }
  return null;
}

/// "Pick Your Role" (website lobby, shown right after a first-time team join). Picking saves
/// the role; Skip or dismissing joins as Analyst in the background (roles are advisory and
/// never block entry). Completes when the player has picked or skipped.
Future<void> showRolePickerDialog(
  BuildContext context, {
  required String teamId,
  required String playerName,
}) async {
  final picked = await showDialog<bool>(
    context: context,
    builder: (_) => _RolePickerDialog(teamId: teamId, playerName: playerName),
  );
  if (picked != true && context.mounted) {
    // Skip / dismiss = Analyst, fire-and-forget (website handleSkipRole).
    final api = ProviderScope.containerOf(context, listen: false).read(apiClientProvider);
    unawaited(api
        .post(_assignPath, data: {'teamId': teamId, 'playerName': playerName, 'role': 'analyst'})
        .then((_) {}, onError: (_) {}));
  }
}

class _RolePickerDialog extends ConsumerStatefulWidget {
  final String teamId;
  final String playerName;
  const _RolePickerDialog({required this.teamId, required this.playerName});

  @override
  ConsumerState<_RolePickerDialog> createState() => _RolePickerDialogState();
}

class _RolePickerDialogState extends ConsumerState<_RolePickerDialog> {
  List<TeamRoleAssignment> _roles = const [];
  String? _assigning;
  Timer? _poll;

  @override
  void initState() {
    super.initState();
    _load();
    // Taken roles stay current while the picker is open (website refetches every 5 s).
    _poll = Timer.periodic(const Duration(seconds: 5), (_) => _load());
  }

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final res = await ref
          .read(apiClientProvider)
          .get('$_rolesPath/${Uri.encodeComponent(widget.teamId)}');
      final list = res['roles'];
      if (!mounted || list is! List) return;
      setState(() {
        _roles = [
          for (final r in list)
            if (r is Map && r['playerName'] != null && r['role'] != null)
              TeamRoleAssignment('${r['playerName']}', '${r['role']}'),
        ];
      });
    } catch (_) {/* keep what is shown */}
  }

  Future<void> _pick(String role) async {
    if (_assigning != null) return;
    final s = ref.read(stringsProvider);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _assigning = role);
    Map<String, dynamic>? res;
    try {
      res = await ref.read(apiClientProvider).post(_assignPath, data: {
        'teamId': widget.teamId,
        'playerName': widget.playerName,
        'role': role,
      });
    } catch (_) {
      res = null;
    }
    if (!mounted) return;
    setState(() => _assigning = null);
    final meta = kTeamRoles[role]!;
    if (res != null && res['success'] == true) {
      ref.invalidate(teamRolesProvider(widget.teamId));
      messenger.showSnackBar(SnackBar(
        content: Text(s.tr('Role Selected: you are the ${meta.en} for your team.',
            'تم اختيار الدور: أنت ${meta.ar} في فريقك.')),
      ));
      Navigator.pop(context, true);
    } else if (res == null) {
      messenger.showSnackBar(SnackBar(
        backgroundColor: const Color(0xFFDC2626),
        content: Text(s.tr('Connection Problem: could not save your role. Please try again.',
            'مشكلة في الاتصال: تعذّر حفظ دورك. حاول مرة أخرى.')),
      ));
    } else {
      // Most likely a conflict: someone grabbed the role first (409 "Role already taken by X").
      final err = res['error'];
      messenger.showSnackBar(SnackBar(
        backgroundColor: const Color(0xFFDC2626),
        content: Text(
          '${s.tr('Role Not Available', 'الدور غير متاح')}: ${err is String && err.isNotEmpty ? err : s.tr('That role was just taken. Please pick another.', 'أُخذ هذا الدور للتو. اختر دورًا آخر.')}',
        ),
      ));
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    return AlertDialog(
      title: Text(s.tr('Pick Your Role', 'اختر دورك'), textAlign: TextAlign.center),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              s.tr(
                'Roles help your team split responsibilities. You can still do everything - this just shows teammates who owns what.',
                'تساعد الأدوار فريقك على توزيع المسؤوليات. ما زال بإمكانك فعل كل شيء، فهي تُظهر لزملائك من يتولى ماذا فقط.',
              ),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Theme.of(context).hintColor),
            ),
            const SizedBox(height: 12),
            for (final (role, en, ar) in kRoleOptions) _option(s, role, en, ar),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _assigning != null ? null : () => Navigator.pop(context, false),
          child: Text(s.tr('Skip - continue as Analyst', 'تخطَّ - تابع بدور المحلل')),
        ),
      ],
    );
  }

  Widget _option(AppStrings s, String role, String en, String ar) {
    final meta = kTeamRoles[role]!;
    final takenBy = roleTakenBy(role, _roles, widget.playerName);
    final assigning = _assigning == role;
    final enabled = takenBy == null && _assigning == null;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Opacity(
        opacity: takenBy != null ? 0.6 : 1,
        child: Material(
          color: assigning ? const Color(0xFFEFF6FF) : Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: assigning ? const Color(0xFF60A5FA) : const Color(0xFFE5E7EB),
              width: 2,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: enabled ? () => _pick(role) : null,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(meta.icon, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(meta.label(s), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        Text(s.tr(en, ar), style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                        if (takenBy != null)
                          Text(s.tr('Taken by $takenBy', 'اختاره $takenBy'),
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFFD97706))),
                        if (assigning)
                          Text(s.tr('Saving...', 'جارٍ الحفظ...'),
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF2563EB))),
                      ],
                    ),
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
