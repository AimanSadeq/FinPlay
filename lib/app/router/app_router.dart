import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/onboarding/screens/splash_screen.dart';
import '../../features/onboarding/screens/mode_selector_screen.dart';
import '../../features/onboarding/screens/home_screen.dart';
import '../../features/auth/screens/self_paced_login_screen.dart';
import '../../features/auth/screens/self_paced_progress_screen.dart';
import '../../features/auth/screens/site_access_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/reset_password_screen.dart';
import '../../features/billing/screens/pricing_screen.dart';
import '../../features/billing/screens/checkout_screen.dart';
import '../../features/lobby/screens/lobby_screen.dart';
import '../../features/simulation/screens/simulation_screen.dart';
import '../../features/facilitator/screens/facilitator_screen.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/dashboard/screens/team_comparison_screen.dart';
import '../../features/dashboard/screens/game_map_screen.dart';
import '../../features/dashboard/screens/multi_round_dashboard_screen.dart';
import '../../features/education/screens/education_hub_screen.dart';
import '../../features/education/screens/break_even_screen.dart';
import '../../features/education/screens/capital_budgeting_screen.dart';
import '../../features/education/screens/excel_view_screen.dart';
import '../../features/education/screens/financial_glossary_screen.dart';
import '../../features/education/screens/certificate_screen.dart';
import '../../features/education/screens/wacc_screen.dart';
import '../../features/education/screens/dupont_screen.dart';
import '../../features/education/screens/working_capital_screen.dart';
import '../../features/education/screens/credit_rating_screen.dart';
import '../../features/education/screens/covenants_screen.dart';
import '../../features/education/screens/cap_table_screen.dart';
import '../../features/education/screens/dividends_screen.dart';
import '../../features/education/screens/ratios_category_screen.dart';
import '../../features/assessment/screens/assessment_screen.dart';
import '../../features/research/screens/research_screen.dart';
import '../../features/earnings_call/screens/earnings_call_screen.dart';
import '../../features/facilitator/screens/admin_model_screen.dart';
import '../../features/education/screens/web_module_screen.dart';
import '../../features/education/modules/education_module_screen.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      // Splash
      GoRoute(
        path: '/',
        name: 'splash',
        pageBuilder: (context, state) => _buildPage(
          const SplashScreen(),
          state,
        ),
      ),

      // Onboarding
      GoRoute(
        path: '/mode-selector',
        name: 'mode-selector',
        pageBuilder: (context, state) => _buildPage(
          const ModeSelectorScreen(),
          state,
        ),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        pageBuilder: (context, state) => _buildPage(
          const HomeScreen(),
          state,
        ),
      ),

      // Auth
      GoRoute(
        path: '/site-access',
        name: 'site-access',
        pageBuilder: (context, state) => _buildPage(
          const SiteAccessScreen(),
          state,
        ),
      ),
      GoRoute(
        path: '/self-paced-login',
        name: 'self-paced-login',
        pageBuilder: (context, state) => _buildPage(
          const SelfPacedLoginScreen(),
          state,
        ),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        pageBuilder: (context, state) => _buildPage(
          const ForgotPasswordScreen(),
          state,
        ),
      ),
      GoRoute(
        path: '/self-paced-progress',
        name: 'self-paced-progress',
        pageBuilder: (context, state) => _buildPage(
          const SelfPacedProgressScreen(),
          state,
        ),
      ),

      // Self-paced subscription (MamoPay hosted checkout)
      GoRoute(
        path: '/pricing',
        name: 'pricing',
        pageBuilder: (context, state) => _buildPage(const PricingScreen(), state),
      ),
      GoRoute(
        path: '/billing-checkout',
        name: 'billing-checkout',
        pageBuilder: (context, state) => _buildPage(
          CheckoutScreen(planId: state.uri.queryParameters['plan'] ?? ''),
          state,
        ),
      ),

      // Game
      GoRoute(
        path: '/lobby',
        name: 'lobby',
        pageBuilder: (context, state) => _buildPage(
          const LobbyScreen(),
          state,
        ),
      ),
      GoRoute(
        path: '/simulation',
        name: 'simulation',
        pageBuilder: (context, state) => _buildPage(
          const SimulationScreen(),
          state,
        ),
      ),
      // Earnings Call — the post-Round-2 analyst event (facilitator-driven stages).
      GoRoute(
        path: '/earnings-call',
        name: 'earnings-call',
        pageBuilder: (context, state) => _buildPage(
          const EarningsCallScreen(),
          state,
        ),
      ),
      GoRoute(
        path: '/facilitator',
        name: 'facilitator',
        pageBuilder: (context, state) => _buildPage(
          const FacilitatorScreen(),
          state,
        ),
      ),

      // Dashboard
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        pageBuilder: (context, state) => _buildPage(
          const DashboardScreen(),
          state,
        ),
      ),
      GoRoute(
        path: '/team-comparison',
        name: 'team-comparison',
        pageBuilder: (context, state) => _buildPage(
          const TeamComparisonScreen(),
          state,
        ),
      ),
      GoRoute(
        path: '/game-map',
        name: 'game-map',
        pageBuilder: (context, state) => _buildPage(
          const GameMapScreen(),
          state,
        ),
      ),
      GoRoute(
        path: '/multi-round-dashboard',
        name: 'multi-round-dashboard',
        pageBuilder: (context, state) => _buildPage(
          const MultiRoundDashboardScreen(),
          state,
        ),
      ),

      // Education
      GoRoute(
        path: '/education',
        name: 'education',
        pageBuilder: (context, state) => _buildPage(
          const EducationHubScreen(),
          state,
        ),
      ),
      GoRoute(
        path: '/education/break-even',
        name: 'break-even',
        pageBuilder: (context, state) => _buildPage(
          const BreakEvenScreen(),
          state,
        ),
      ),
      GoRoute(
        path: '/education/capital-budgeting',
        name: 'capital-budgeting',
        pageBuilder: (context, state) => _buildPage(
          const CapitalBudgetingScreen(),
          state,
        ),
      ),
      GoRoute(
        path: '/education/glossary',
        name: 'glossary',
        pageBuilder: (context, state) => _buildPage(
          const FinancialGlossaryScreen(),
          state,
        ),
      ),
      GoRoute(
        path: '/education/certificate',
        name: 'certificate',
        pageBuilder: (context, state) => _buildPage(
          const CertificateScreen(),
          state,
        ),
      ),
      GoRoute(
        path: '/education/excel',
        name: 'excel-view',
        pageBuilder: (context, state) => _buildPage(
          const ExcelViewScreen(),
          state,
        ),
      ),

      // Advanced finance tools
      GoRoute(
        path: '/education/wacc',
        name: 'wacc',
        pageBuilder: (context, state) => _buildPage(const WaccScreen(), state),
      ),
      GoRoute(
        path: '/education/dupont',
        name: 'dupont',
        pageBuilder: (context, state) =>
            _buildPage(const DuPontScreen(), state),
      ),
      GoRoute(
        path: '/education/working-capital',
        name: 'working-capital',
        pageBuilder: (context, state) =>
            _buildPage(const WorkingCapitalScreen(), state),
      ),
      GoRoute(
        path: '/education/credit-rating',
        name: 'credit-rating',
        pageBuilder: (context, state) =>
            _buildPage(const CreditRatingScreen(), state),
      ),
      GoRoute(
        path: '/education/covenants',
        name: 'covenants',
        pageBuilder: (context, state) =>
            _buildPage(const CovenantsScreen(), state),
      ),
      GoRoute(
        path: '/education/cap-table',
        name: 'cap-table',
        pageBuilder: (context, state) =>
            _buildPage(const CapTableScreen(), state),
      ),
      GoRoute(
        path: '/education/dividends',
        name: 'dividends',
        pageBuilder: (context, state) =>
            _buildPage(const DividendsScreen(), state),
      ),
      GoRoute(
        path: '/education/ratios',
        name: 'ratios',
        pageBuilder: (context, state) => _buildPage(
          RatiosCategoryScreen(category: state.uri.queryParameters['category']),
          state,
        ),
      ),
      GoRoute(
        path: '/ratios/:category',
        name: 'ratios-category',
        pageBuilder: (context, state) => _buildPage(
          RatiosCategoryScreen(category: state.pathParameters['category']),
          state,
        ),
      ),

      // Assessment (pre/post knowledge test)
      GoRoute(
        path: '/assessment/:kind',
        name: 'assessment',
        pageBuilder: (context, state) => _buildPage(
          AssessmentScreen(
            key: ValueKey('assessment-${state.pathParameters['kind']}'),
            kind: state.pathParameters['kind'] == 'post' ? 'post' : 'pre',
          ),
          state,
        ),
      ),

      // Research / DBA data collection
      GoRoute(
        path: '/research',
        name: 'research',
        pageBuilder: (context, state) =>
            _buildPage(const ResearchScreen(), state),
      ),

      // Auth — reset password (token from email link)
      GoRoute(
        path: '/reset-password',
        name: 'reset-password',
        pageBuilder: (context, state) => _buildPage(
          ResetPasswordScreen(token: state.uri.queryParameters['token']),
          state,
        ),
      ),

      // Facilitator — model editor
      GoRoute(
        path: '/admin/model',
        name: 'admin-model',
        pageBuilder: (context, state) =>
            _buildPage(const AdminModelScreen(), state),
      ),

      // Education module screens. The path segment is legacy; `:id` is the
      // module's permanent catalog id (lib/data/education_catalog.dart), never
      // its position among the hub cards.
      GoRoute(
        path: '/education/module/:id',
        name: 'education-module',
        pageBuilder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 1;
          return _buildPage(EducationModuleScreen(key: ValueKey('education-module-$id'), moduleId: id), state);
        },
      ),
      // A catalog module whose content is only on the website so far.
      GoRoute(
        path: '/education/web/:num',
        name: 'education-web-module',
        pageBuilder: (context, state) {
          final num = int.tryParse(state.pathParameters['num'] ?? '') ?? 0;
          return _buildPage(WebModuleScreen(key: ValueKey('web-module-$num'), moduleNum: num), state);
        },
      ),
    ],
    errorPageBuilder: (context, state) => _buildPage(
      Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Page Not Found',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(state.uri.toString()),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/mode-selector'),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
      state,
    ),
  );

  static CustomTransitionPage _buildPage(Widget child, GoRouterState state) {
    return CustomTransitionPage(
      // Use ValueKey with full URI to avoid duplicate GlobalKey conflicts
      // during rapid navigation (known GoRouter issue with state.pageKey)
      key: ValueKey(state.uri.toString()),
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
