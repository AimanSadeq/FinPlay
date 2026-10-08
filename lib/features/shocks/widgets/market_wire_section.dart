import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/i18n/app_strings.dart';
import '../../../providers/socket_provider.dart';
import '../../hedges/hedge_desk.dart';
import '../../hedges/hedge_providers.dart';
import '../../hedges/hedge_repository.dart';
import '../../simulation/widgets/ticker_marquee.dart';

bool _routeIsCurrent(BuildContext context) => ModalRoute.of(context)?.isCurrent ?? true;

/// The market wire (website MarketNewsTicker) and the Hedge Desk under it, for corporate
/// teams only (the server leaves shocks out of a self-paced learner's numbers, so the
/// website mounts both only on the corporate simulation page).
///
/// Owns the one poll of each endpoint, shared by the ticker and the desk:
///  * GET /api/shocks/forecasts?round=N every 15 s (website cadence), and at once on the
///    'shock:forecast' / 'shock:forecast_resolved' / 'shock:triggered' pushes;
///  * GET /api/hedges/team/{teamId} every 10 s while there is something to insure or an
///    active policy that may pay off, and at once on 'hedge:purchased' / 'hedge:consumed'.
/// Both stand down while another route covers the simulation. Renders nothing when quiet.
class MarketWireSection extends ConsumerStatefulWidget {
  final String teamId;
  final int? round;
  const MarketWireSection({super.key, required this.teamId, this.round});

  @override
  ConsumerState<MarketWireSection> createState() => _MarketWireSectionState();
}

class _MarketWireSectionState extends ConsumerState<MarketWireSection> {
  Timer? _forecastTimer;
  Timer? _hedgeTimer;
  final _subs = <StreamSubscription<dynamic>>[];
  Set<String>? _knownConsumed; // null until the first hedges load (no replayed payoffs)
  bool _loadingForecasts = false;
  bool _loadingHedges = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _fetchForecasts();
      _fetchHedges();
    });
    _forecastTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      if (mounted && _routeIsCurrent(context)) _fetchForecasts();
    });
    _hedgeTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (!mounted || !_routeIsCurrent(context)) return;
      final hedges = ref.read(teamHedgesProvider(widget.teamId));
      final worthPolling = ref.read(marketForecastsProvider(widget.teamId)).isNotEmpty ||
          hedges == null ||
          hedges.any((h) => h.status == 'active');
      if (worthPolling) _fetchHedges();
    });
    final socket = ref.read(socketManagerProvider);
    for (final e in const ['shock:forecast', 'shock:forecast_resolved', 'shock:triggered']) {
      _subs.add(socket.onEvent(e).listen((_) => _fetchForecasts(), onError: (_) {}));
    }
    for (final e in const ['hedge:purchased', 'hedge:consumed', 'shock:triggered']) {
      _subs.add(socket.onEvent(e).listen((_) => _fetchHedges(), onError: (_) {}));
    }
  }

  @override
  void didUpdateWidget(covariant MarketWireSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Both providers are keyed by team, so a new team starts empty with no reset here (a
    // synchronous provider write during this rebuild would throw); the fetches write later.
    if (oldWidget.round != widget.round || oldWidget.teamId != widget.teamId) _fetchForecasts();
    if (oldWidget.teamId != widget.teamId) {
      _knownConsumed = null;
      _loadingHedges = false;
      _fetchHedges();
    }
  }

  Future<void> _fetchForecasts() async {
    if (_loadingForecasts) return;
    _loadingForecasts = true;
    final teamId = widget.teamId;
    final list = await ref.read(hedgeRepositoryProvider).fetchForecasts(round: widget.round);
    _loadingForecasts = false;
    if (!mounted || list == null || teamId != widget.teamId) return;
    ref.read(marketForecastsProvider(teamId).notifier).state = list;
  }

  Future<void> _fetchHedges() async {
    final teamId = widget.teamId;
    if (teamId.isEmpty || _loadingHedges) return;
    _loadingHedges = true;
    final list = await ref.read(hedgeRepositoryProvider).fetchTeamHedges(teamId);
    _loadingHedges = false;
    if (!mounted || list == null || teamId != widget.teamId) return;
    ref.read(teamHedgesProvider(teamId).notifier).state = list;
    final paid = newlyConsumed(_knownConsumed, list);
    _knownConsumed = {for (final h in list) if (h.status == 'consumed') h.id};
    if (paid.isNotEmpty && _routeIsCurrent(context)) {
      final s = ref.read(stringsProvider);
      for (final h in paid) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 9),
          backgroundColor: const Color(0xFF16A34A),
          content: Text(s.tr(
            '🛡️ Your insurance paid off: ${prettyShockName(h.shockId)} absorbed at pre-shock terms.',
            '🛡️ عوّضك التأمين: امتُصّت صدمة ${prettyShockName(h.shockId)} بشروط ما قبل الصدمة.',
          )),
        ));
      }
    }
  }

  @override
  void dispose() {
    _forecastTimer?.cancel();
    _hedgeTimer?.cancel();
    for (final s in _subs) {
      s.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final forecasts = ref.watch(marketForecastsProvider(widget.teamId));
    // Keep the team's hedges alive while the wire is quiet (payoff detection, poll gating).
    ref.watch(teamHedgesProvider(widget.teamId));
    if (forecasts.isEmpty) return const SizedBox.shrink();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MarketNewsTicker(teamId: widget.teamId, forecasts: forecasts),
        HedgeDeskCard(teamId: widget.teamId),
      ],
    );
  }
}

/// Slim "market wire" bar cycling the facilitator's forward-looking forecasts. Some hint at
/// real upcoming shocks, others are red herrings; insured headlines carry a 🛡️.
class MarketNewsTicker extends ConsumerWidget {
  final String teamId;
  final List<ShockForecast> forecasts;
  const MarketNewsTicker({super.key, required this.teamId, required this.forecasts});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (forecasts.isEmpty) return const SizedBox.shrink();
    final s = ref.watch(stringsProvider);
    final insured = hedgesByForecast(ref.watch(teamHedgesProvider(teamId)));
    final items = [
      for (final f in forecasts) _item(s, f, insured.containsKey(f.id)),
    ];
    final seconds = forecasts.length * 12 < 25 ? 25 : forecasts.length * 12;
    return Container(
      margin: const EdgeInsets.only(top: 6),
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A), // slate-900
        border: Border.symmetric(horizontal: BorderSide(color: Color(0xFF334155))),
      ),
      child: Semantics(
        container: true,
        label: s.tr('Market news wire', 'نشرة أخبار السوق'),
        child: Row(
          children: [
            Container(
              color: const Color(0xFFF59E0B), // amber-500
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              child: Text(
                s.tr('MARKET WIRE', 'نشرة السوق'),
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.4,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: TickerMarquee(items: items, loopDuration: Duration(seconds: seconds)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(AppStrings s, ShockForecast f, bool insured) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: severityDotColor(f.severityHint), shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(f.text(s.ar), style: const TextStyle(fontSize: 13, color: Color(0xFFF1F5F9))),
          if (insured) ...[
            const SizedBox(width: 6),
            Tooltip(
              message: s.tr('Your team is insured against this risk', 'فريقك مؤمَّن ضد هذا الخطر'),
              child: const Text('🛡️', style: TextStyle(fontSize: 12)),
            ),
          ],
          const SizedBox(width: 8),
          Text(
            'Y${f.roundNum}',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(width: 14),
          const Text('•', style: TextStyle(color: Color(0xFF475569))),
        ],
      ),
    );
  }
}
