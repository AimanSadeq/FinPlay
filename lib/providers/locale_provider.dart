import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/utils/constants.dart';

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en')) {
    _loadLocale();
  }

  bool get isArabic => state.languageCode == 'ar';

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final lang = prefs.getString(AppConstants.localeKey);
    if (lang != null) state = Locale(lang);
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.localeKey, locale.languageCode);
  }

  void toggleLanguage() {
    setLocale(isArabic ? const Locale('en') : const Locale('ar'));
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

final isArabicProvider = Provider<bool>((ref) {
  return ref.watch(localeProvider).languageCode == 'ar';
});
