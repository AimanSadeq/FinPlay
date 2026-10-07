import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/module_plan.dart';
import '../data/repositories/education_repository.dart';
import 'repository_providers.dart';

/// The module plan the app follows (see lib/data/module_plan.dart).
///
/// Never blocks a screen: the state is always a usable plan. It starts as
/// [ModulePlan.fallback], is replaced by the plan cached for the current host
/// as soon as that is read from disk, and by the server's answer whenever
/// [refresh] gets one. The education hub calls [refresh] each time it opens.
///
/// A server answer, including `moduleNums: null`, is applied and cached. A
/// failed call (offline, timeout, missing route) changes nothing: the last plan
/// this host sent stays in force, and with none cached the fallback applies.
/// The cache is keyed by the API host, because a cohort is its own subdomain
/// with its own plan.
class ModulePlanNotifier extends StateNotifier<ModulePlan> {
  ModulePlanNotifier(this._repo, this._host, {this.timeout = const Duration(seconds: 8)})
      : super(ModulePlan.fallback) {
    _restored = _restore();
  }

  final EducationRepository _repo;
  final String Function() _host;
  final Duration timeout;

  static const String cacheKey = 'module_plan_cache';

  late final Future<void> _restored;
  bool _answered = false;
  Future<void>? _inFlight;

  /// The host the current state belongs to; null for the fallback.
  String? _planHost;

  static Future<ModulePlan?> _cachedFor(String host) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(cacheKey);
      if (raw == null) return null;
      final cached = jsonDecode(raw);
      if (cached is! Map || cached['host'] != host) return null;
      final plan = cached['plan'];
      return plan is Map ? ModulePlan.fromJson(Map<String, dynamic>.from(plan)) : null;
    } catch (_) {
      return null; // an unreadable cache is no cache
    }
  }

  Future<void> _restore() async {
    final host = _host();
    final cached = await _cachedFor(host);
    if (cached == null || _answered || !mounted) return;
    state = cached;
    _planHost = host;
  }

  /// Fetch the plan for the current host. Concurrent calls share one request.
  Future<void> refresh() => _inFlight ??= _refresh().whenComplete(() => _inFlight = null);

  Future<void> _refresh() async {
    final host = _host();
    ModulePlan plan;
    try {
      plan = await _repo.fetchModulePlan().timeout(timeout);
    } catch (_) {
      // Keep the current plan when it is this host's. After a switch to
      // another host (a different cohort), use that host's cached plan, or
      // the fallback, rather than the previous host's plan.
      await _restored;
      if (mounted && _planHost != null && _planHost != host) {
        final cached = await _cachedFor(host);
        if (!mounted) return;
        state = cached ?? ModulePlan.fallback;
        _planHost = cached == null ? null : host;
      }
      return;
    }
    await _restored;
    _answered = true;
    if (!mounted) return;
    state = plan;
    _planHost = host;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        cacheKey,
        jsonEncode({'host': host, 'plan': plan.toJson()}),
      );
    } catch (_) {
      // Not cached this time; the plan in memory is still current.
    }
  }
}

final modulePlanProvider = StateNotifierProvider<ModulePlanNotifier, ModulePlan>((ref) {
  final api = ref.watch(apiClientProvider);
  return ModulePlanNotifier(ref.watch(educationRepositoryProvider), () => api.baseUrl);
});
