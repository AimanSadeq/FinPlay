import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/facilitator_repository.dart';
import 'repository_providers.dart';

/// The facilitator's corporate simulation switch (GET
/// /facilitator/simulation-access), the same read the website's home page and
/// education hub make every 15 seconds. The value is:
///
///  * loading until the first read answers;
///  * data(true/false) for the switch;
///  * data(null) when the route did not carry it, and error when the request
///    failed. Both leave the simulation open (website parity: the tile stays
///    enabled while the setting cannot be read).
///
/// Screens that depend on it call [refresh] on their own poll, and the socket
/// manager pushes `facilitator:simulation_access` into [applyOpen].
class SimulationAccessNotifier extends StateNotifier<AsyncValue<bool?>> {
  final FacilitatorRepository _repo;

  SimulationAccessNotifier(this._repo) : super(const AsyncValue.loading());

  Future<void> refresh() async {
    try {
      final open = await _repo.fetchSimulationAccess();
      if (mounted) state = AsyncValue.data(open);
    } catch (e, st) {
      if (mounted) state = AsyncValue.error(e, st);
    }
  }

  /// A socket push `{ open }` from the facilitator's switch.
  void applySocket(Map<String, dynamic> data) {
    final open = data['open'];
    if (open is bool) applyOpen(open);
  }

  void applyOpen(bool open) {
    if (mounted) state = AsyncValue.data(open);
  }
}

final simulationAccessProvider =
    StateNotifierProvider<SimulationAccessNotifier, AsyncValue<bool?>>((ref) {
  return SimulationAccessNotifier(ref.watch(facilitatorRepositoryProvider));
});
