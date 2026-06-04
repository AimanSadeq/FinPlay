import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Simple in-memory + SharedPreferences caching layer for API responses.
class CacheService {
  static CacheService? _instance;
  factory CacheService() => _instance ??= CacheService._();
  CacheService._();

  final Map<String, _CacheEntry> _memoryCache = {};

  /// Get cached data. Returns null if expired or missing.
  Future<Map<String, dynamic>?> get(String key, {Duration maxAge = const Duration(minutes: 5)}) async {
    // Check memory first
    final memEntry = _memoryCache[key];
    if (memEntry != null && !memEntry.isExpired(maxAge)) {
      return memEntry.data;
    }

    // Check disk
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString('cache_$key');
      if (raw != null) {
        final entry = _CacheEntry.fromJson(jsonDecode(raw) as Map<String, dynamic>);
        if (!entry.isExpired(maxAge)) {
          _memoryCache[key] = entry;
          return entry.data;
        }
        // Expired — remove
        prefs.remove('cache_$key');
      }
    } catch (_) {}

    return null;
  }

  /// Store data in both memory and disk cache.
  Future<void> set(String key, Map<String, dynamic> data) async {
    final entry = _CacheEntry(data: data, timestamp: DateTime.now());
    _memoryCache[key] = entry;

    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('cache_$key', jsonEncode(entry.toJson()));
    } catch (_) {}
  }

  /// Remove a specific cache entry.
  Future<void> remove(String key) async {
    _memoryCache.remove(key);
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('cache_$key');
    } catch (_) {}
  }

  /// Clear all cached data.
  Future<void> clearAll() async {
    _memoryCache.clear();
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((k) => k.startsWith('cache_'));
      for (final key in keys) {
        prefs.remove(key);
      }
    } catch (_) {}
  }
}

class _CacheEntry {
  final Map<String, dynamic> data;
  final DateTime timestamp;

  _CacheEntry({required this.data, required this.timestamp});

  bool isExpired(Duration maxAge) {
    return DateTime.now().difference(timestamp) > maxAge;
  }

  Map<String, dynamic> toJson() => {
    'data': data,
    'timestamp': timestamp.toIso8601String(),
  };

  factory _CacheEntry.fromJson(Map<String, dynamic> json) => _CacheEntry(
    data: json['data'] as Map<String, dynamic>,
    timestamp: DateTime.parse(json['timestamp'] as String),
  );
}
