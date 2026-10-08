import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/i18n/app_strings.dart';
import '../../app/theme/app_colors.dart';
import '../../providers/auth_provider.dart';

/// Header account menu for a signed-in self-paced learner: Logout and Delete
/// account (Apple 5.1.1(v): account deletion must be easy to find in the app).
/// Callers show it only for self-paced learners (not corporate teams or the
/// facilitator).
class AccountMenuButton extends ConsumerWidget {
  const AccountMenuButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    return PopupMenuButton<String>(
      icon: Icon(Icons.account_circle_outlined,
          size: 20, color: AppColors.textSecondary(context)),
      tooltip: s.tr('Account', 'الحساب'),
      onSelected: (value) async {
        switch (value) {
          case 'logout':
            await ref.read(authProvider.notifier).logout();
            if (context.mounted) context.go('/mode-selector');
          case 'delete':
            context.push('/delete-account');
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          value: 'logout',
          child: Row(children: [
            const Icon(Icons.logout_rounded, size: 18),
            const SizedBox(width: 10),
            Text(s.tr('Logout', 'تسجيل الخروج')),
          ]),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(children: [
            const Icon(Icons.delete_forever_rounded,
                size: 18, color: AppColors.danger),
            const SizedBox(width: 10),
            Text(
              s.tr('Delete account', 'حذف الحساب'),
              style: const TextStyle(color: AppColors.danger),
            ),
          ]),
        ),
      ],
    );
  }
}
