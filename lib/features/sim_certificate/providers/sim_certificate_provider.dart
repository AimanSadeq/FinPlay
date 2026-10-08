import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../achievements/providers/achievements_providers.dart';
import '../data/sim_certificate_models.dart';
import '../data/sim_certificate_repository.dart';

final simCertificateRepositoryProvider = Provider<SimCertificateRepository>(
  (ref) => SimCertificateRepository(ref.watch(gamificationHttpProvider)),
);

/// The caller's simulation certificate status (one GET tells everything: issued /
/// eligible / locked / signed out).
final simCertificateStatusProvider =
    FutureProvider.autoDispose<SimCertificateStatus>((ref) async {
  final session = await ref.watch(gamificationSessionProvider.future);
  return ref.watch(simCertificateRepositoryProvider).mine(session);
});
