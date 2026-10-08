import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/i18n/app_strings.dart';
import '../../shared/widgets/team_leader_banner.dart' show teamLeaderStatusProvider;
import '../roles/team_roles.dart';
import 'hedge_providers.dart';
import 'hedge_repository.dart';

const _purple = Color(0xFF7C3AED);

Color severityDotColor(String? hint) {
  switch (hint) {
    case 'medium':
      return const Color(0xFFFBBF24); // amber-400
    case 'high':
      return const Color(0xFFEF4444); // red-500
    default:
      return const Color(0xFF9CA3AF); // gray-400
  }
}

/// Hedge Desk - "shock insurance" for corporate teams, under the market wire (website
/// HedgeDesk). While forecasts are live the team can insure against each one for a premium in
/// in-game currency (charged by the engine as an operating expense in the purchase round). If
/// the hinted shock fires, the insured team stays on pre-shock terms; insuring a red herring
/// just spends the premium. One policy per headline per team.
///
/// Compact on the phone: a one-line card that opens the desk in a bottom sheet. Renders
/// nothing when the wire is quiet or there is no team.
class HedgeDeskCard extends ConsumerWidget {
  final String teamId;
  const HedgeDeskCard({super.key, required this.teamId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forecasts = ref.watch(marketForecastsProvider(teamId));
    if (teamId.isEmpty || forecasts.isEmpty) return const SizedBox.shrink();
    final s = ref.watch(stringsProvider);
    final byForecast = hedgesByForecast(ref.watch(teamHedgesProvider(teamId)));
    final insured = forecasts.where((f) => byForecast.containsKey(f.id)).length;
    final isRiskOfficer = ref.watch(myTeamRoleProvider) == 'risk_officer';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
      child: Material(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => showHedgeDeskSheet(context, teamId),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isRiskOfficer ? _purple.withValues(alpha: 0.5) : const Color(0xFFCBD5E1),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.umbrella_rounded, size: 16, color: Color(0xFF475569)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.tr('Hedge Desk - Shock Insurance', 'مكتب التحوط - تأمين الصدمات'),
                        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        s.tr(
                          '$insured of ${forecasts.length} headline${forecasts.length == 1 ? '' : 's'} insured',
                          'مؤمَّن ضد $insured من ${forecasts.length} عناوين',
                        ),
                        style: TextStyle(fontSize: 11, color: Theme.of(context).hintColor),
                      ),
                    ],
                  ),
                ),
                if (isRiskOfficer) ...[
                  _RiskOfficerChip(s: s, highlighted: true),
                  const SizedBox(width: 6),
                ],
                Icon(Icons.chevron_right_rounded, size: 18, color: Theme.of(context).hintColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> showHedgeDeskSheet(BuildContext context, String teamId) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _HedgeDeskSheet(teamId: teamId),
  );
}

class _RiskOfficerChip extends StatelessWidget {
  final AppStrings s;
  final bool highlighted;
  const _RiskOfficerChip({required this.s, required this.highlighted});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: highlighted ? const Color(0xFFF3E8FF) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: highlighted ? const Color(0xFFD8B4FE) : const Color(0xFFCBD5E1)),
      ),
      child: Text(
        s.tr("Risk Officer's call", 'قرار مسؤول المخاطر'),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: highlighted ? const Color(0xFF6B21A8) : const Color(0xFF475569),
        ),
      ),
    );
  }
}

class _HedgeDeskSheet extends ConsumerStatefulWidget {
  final String teamId;
  const _HedgeDeskSheet({required this.teamId});

  @override
  ConsumerState<_HedgeDeskSheet> createState() => _HedgeDeskSheetState();
}

class _HedgeDeskSheetState extends ConsumerState<_HedgeDeskSheet> {
  String? _purchasing; // forecastId being bought

  Future<void> _insure(ShockForecast forecast) async {
    final s = ref.read(stringsProvider);
    final repo = ref.read(hedgeRepositoryProvider);
    final quoteFuture = repo.quote(forecast.id, widget.teamId);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => FutureBuilder<HedgeQuote?>(
        future: quoteFuture,
        builder: (ctx, snap) {
          final loading = snap.connectionState != ConnectionState.done;
          final premium = snap.data?.premium ?? hedgePremiumFor(forecast.severityHint);
          final already = snap.data?.alreadyInsured == true;
          final premiumText = loading ? '...' : formatUsd(premium);
          return AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.umbrella_rounded, color: _purple),
                const SizedBox(width: 8),
                Expanded(child: Text(s.tr('Buy Shock Insurance', 'شراء تأمين ضد الصدمة'))),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.tr(
                    'Insurance against: ${forecast.text(false)} - Premium $premiumText. If this risk materializes, your company is protected at today\'s terms.',
                    'تأمين ضد: ${forecast.text(true)} - القسط $premiumText. إذا تحقق هذا الخطر، تبقى شركتك محمية بشروط اليوم.',
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  s.tr(
                    'The premium is non-refundable - if the risk never materializes, it is simply spent. One policy per headline per team.',
                    'القسط غير قابل للاسترداد - إذا لم يتحقق الخطر فهو ببساطة مُنفَق. وثيقة واحدة لكل عنوان لكل فريق.',
                  ),
                  style: TextStyle(fontSize: 12, color: Theme.of(ctx).hintColor),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(s.tr('Cancel', 'إلغاء')),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: _purple, foregroundColor: Colors.white),
                onPressed: loading || already ? null : () => Navigator.pop(ctx, true),
                icon: const Icon(Icons.verified_user_rounded, size: 18),
                label: Text(already
                    ? s.tr('Already insured', 'مؤمَّن بالفعل')
                    : s.tr('Confirm - $premiumText', 'تأكيد - $premiumText')),
              ),
            ],
          );
        },
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _purchasing = forecast.id);
    final player = await ref.read(playerNameProvider.future);
    final (premium, error) = await repo.purchase(
      teamId: widget.teamId,
      forecastId: forecast.id,
      playerName: player ?? '',
    );
    final hedges = await repo.fetchTeamHedges(widget.teamId);
    if (hedges != null) ref.read(teamHedgesProvider(widget.teamId).notifier).state = hedges;
    if (!mounted) return;
    setState(() => _purchasing = null);
    final messenger = ScaffoldMessenger.of(context);
    if (error == null) {
      messenger.showSnackBar(SnackBar(
        duration: const Duration(seconds: 7),
        backgroundColor: const Color(0xFF16A34A),
        content: Text(s.tr(
          '🛡️ Insured. Premium paid: ${formatUsd(premium ?? 0)}. If this risk materializes, your company is protected at today\'s terms.',
          '🛡️ تم التأمين. القسط المدفوع: ${formatUsd(premium ?? 0)}. إذا تحقق هذا الخطر، تبقى شركتك محمية بشروط اليوم.',
        )),
      ));
    } else {
      messenger.showSnackBar(SnackBar(
        backgroundColor: const Color(0xFFDC2626),
        content: Text('${s.tr('Insurance purchase failed', 'تعذّر شراء التأمين')}: $error'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final forecasts = ref.watch(marketForecastsProvider(widget.teamId));
    final byForecast = hedgesByForecast(ref.watch(teamHedgesProvider(widget.teamId)));
    final isRiskOfficer = ref.watch(myTeamRoleProvider) == 'risk_officer';
    // Purchasing spends team money: leader-only when the team has a leader (server 403s
    // anyone else), the same gate as Confirm Decisions.
    final leader = ref.watch(teamLeaderStatusProvider).valueOrNull;
    final leaderLocked = leader != null && leader.leader != null && !leader.amLeader;

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            Row(
              children: [
                const Icon(Icons.umbrella_rounded, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    s.tr('Hedge Desk - Shock Insurance', 'مكتب التحوط - تأمين الصدمات'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
                _RiskOfficerChip(s: s, highlighted: isRiskOfficer),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              s.tr(
                "Insure against a headline before it materializes. If the risk hits, your company stays on today's terms - if it never does, the premium is spent.",
                'أمّن ضد عنوان قبل أن يتحقق. إذا وقع الخطر تبقى شركتك على شروط اليوم، وإن لم يقع فالقسط مُنفَق.',
              ),
              style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor),
            ),
            if (leaderLocked)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  s.tr('Only the team leader (${leader.leader}) can purchase insurance.',
                      'يمكن لقائد الفريق (${leader.leader}) فقط شراء التأمين.'),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFD97706)),
                ),
              ),
            const SizedBox(height: 10),
            if (forecasts.isEmpty)
              Text(s.tr('The market wire is quiet.', 'لا أخبار على نشرة السوق حاليًا.')),
            for (final f in forecasts)
              _ForecastRow(
                forecast: f,
                hedge: byForecast[f.id],
                arabic: s.ar,
                s: s,
                highlight: isRiskOfficer,
                busy: _purchasing == f.id,
                onInsure: leaderLocked || _purchasing != null ? null : () => _insure(f),
              ),
          ],
        ),
      ),
    );
  }
}

class _ForecastRow extends StatelessWidget {
  final ShockForecast forecast;
  final TeamHedge? hedge;
  final bool arabic;
  final AppStrings s;
  final bool highlight;
  final bool busy;
  final VoidCallback? onInsure;

  const _ForecastRow({
    required this.forecast,
    required this.hedge,
    required this.arabic,
    required this.s,
    required this.highlight,
    required this.busy,
    required this.onInsure,
  });

  @override
  Widget build(BuildContext context) {
    final h = hedge;
    final details = StringBuffer(
        'Y${forecast.roundNum} · ${s.tr('Premium', 'القسط')} ${formatUsd(hedgePremiumFor(forecast.severityHint))}');
    if (h != null) details.write(' · ${s.tr('Premium paid', 'القسط المدفوع')}: ${formatUsd(h.premium)}');
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: severityDotColor(forecast.severityHint), shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(forecast.text(arabic), style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 2),
                Text(details.toString(), style: TextStyle(fontSize: 11, color: Theme.of(context).hintColor)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (h != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFF86EFAC)),
              ),
              child: Text(
                h.status == 'consumed' ? s.tr('🛡️ Paid off', '🛡️ تم التعويض') : s.tr('🛡️ Insured', '🛡️ مؤمَّن'),
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF166534)),
              ),
            )
          else if (busy)
            const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
          else
            highlight
                ? ElevatedButton.icon(
                    onPressed: onInsure,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _purple,
                      foregroundColor: Colors.white,
                      visualDensity: VisualDensity.compact,
                    ),
                    icon: const Icon(Icons.umbrella_rounded, size: 14),
                    label: Text(s.tr('Insure', 'تأمين'), style: const TextStyle(fontSize: 12)),
                  )
                : OutlinedButton.icon(
                    onPressed: onInsure,
                    style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact),
                    icon: const Icon(Icons.umbrella_rounded, size: 14),
                    label: Text(s.tr('Insure', 'تأمين'), style: const TextStyle(fontSize: 12)),
                  ),
        ],
      ),
    );
  }
}
