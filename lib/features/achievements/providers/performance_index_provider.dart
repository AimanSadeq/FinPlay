import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/performance_index_models.dart';
import 'achievements_providers.dart';

/// GET /api/leaderboard/live (open endpoint). The server caches the scoring pass for 15s
/// and the website polls every 30s; [PerformanceIndexLeaderboard] does the same.
const String kLeaderboardLivePath = '/leaderboard/live';

final indexLeaderboardProvider = FutureProvider.autoDispose<IndexLeaderboard>((ref) async {
  final body = await ref.watch(gamificationHttpProvider).get(kLeaderboardLivePath);
  if (body['leaderboard'] is! List) {
    throw StateError(body['error']?.toString() ?? 'Failed to load leaderboard');
  }
  return IndexLeaderboard.fromJson(body);
});
