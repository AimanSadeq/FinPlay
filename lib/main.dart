import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/network/api_client.dart';
import 'app/router/app_router.dart';
import 'app/theme/app_theme.dart';
import 'providers/theme_provider.dart';
import 'providers/locale_provider.dart';
import 'shared/widgets/shock_notification.dart';
import 'shared/widgets/global_timer_overlay.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Restore a previously selected cohort host (each cohort is its own subdomain).
  try {
    final prefs = await SharedPreferences.getInstance();
    final cohortHost = prefs.getString('cohort_base_url');
    if (cohortHost != null && cohortHost.isNotEmpty) {
      ApiClient().setBaseHost(cohortHost);
    }
  } catch (_) {/* non-critical */}

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  FlutterNativeSplash.remove();

  runApp(
    const ProviderScope(
      child: FinPlayApp(),
    ),
  );
}

class FinPlayApp extends ConsumerWidget {
  const FinPlayApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'FinPlay',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      routerConfig: AppRouter.router,
      builder: (context, child) => ShockNotificationOverlay(
        child: GlobalTimerOverlay(child: child ?? const SizedBox.shrink()),
      ),
    );
  }
}
