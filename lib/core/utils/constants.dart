class AppConstants {
  AppConstants._();

  // API
  static const String baseUrl = 'https://finplay.viftraining.com';
  static const String apiPrefix = '/api';
  static const Duration apiTimeout = Duration(seconds: 60);
  static const Duration socketReconnectDelay = Duration(seconds: 3);

  // Game
  static const int maxTeams = 7;
  static const int maxRounds = 3;
  static const List<String> modules = ['financing', 'investing', 'operating'];
  static const List<String> teamNames = [
    'Team 1', 'Team 2', 'Team 3', 'Team 4',
    'Team 5', 'Team 6', 'Team 7',
  ];

  // Storage Keys
  static const String themeKey = 'theme_mode';
  static const String localeKey = 'locale';
  static const String teamIdKey = 'team_id';
  static const String sessionKey = 'session_token';
  static const String selfPacedTokenKey = 'self_paced_token';
  static const String playerNameKey = 'player_name';
  // Team-member token minted by /facilitator/register-signin; required as a
  // Bearer on decision-write endpoints (confirm/unlock) and select-leader.
  static const String teamMemberTokenKey = 'team_member_token';

  // Animation Durations
  static const Duration quickAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 350);
  static const Duration slowAnimation = Duration(milliseconds: 600);
  static const Duration pageTransition = Duration(milliseconds: 400);

  // Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
}
