import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/network/api_client.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/decision_repository.dart';
import '../data/repositories/education_repository.dart';
import '../data/repositories/facilitator_repository.dart';
import '../data/repositories/game_repository.dart';
import '../data/repositories/self_paced_repository.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final gameRepositoryProvider = Provider<GameRepository>((ref) {
  return GameRepository(ref.watch(apiClientProvider));
});

final decisionRepositoryProvider = Provider<DecisionRepository>((ref) {
  return DecisionRepository(ref.watch(apiClientProvider));
});

final facilitatorRepositoryProvider = Provider<FacilitatorRepository>((ref) {
  return FacilitatorRepository(ref.watch(apiClientProvider));
});

final educationRepositoryProvider = Provider<EducationRepository>((ref) {
  return EducationRepository(ref.watch(apiClientProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(apiClientProvider));
});

final selfPacedRepositoryProvider = Provider<SelfPacedRepository>((ref) {
  return SelfPacedRepository(ref.watch(apiClientProvider));
});
