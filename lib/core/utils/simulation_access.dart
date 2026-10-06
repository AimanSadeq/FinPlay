import 'package:shared_preferences/shared_preferences.dart';

import '../../data/education_catalog.dart';

/// What the simulation screen does for the learner who just opened it.
enum SimulationEntry {
  /// Show the simulation.
  enter,

  /// Show the waiting screen until the facilitator opens the simulation.
  waitForFacilitator,
}

/// The corporate simulation gate, as the website decides it on /home and in
/// the education hub (client/src/pages/home.tsx, `corporateSimLocked`):
/// a corporate team member is held back while the facilitator's switch
/// (GET /facilitator/simulation-access) says `open: false`, unless the team
/// already finished every Learn section. Nobody else is gated:
///
///  * a self-paced learner chooses their own order and may play first;
///  * a facilitator's own device is never gated;
///  * a device with no team yet is handled by the screen's own "join a team"
///    message, not by this gate;
///  * [gateOpen] null means the switch could not be read (route missing or
///    network failure). The website leaves the tile enabled in that case and
///    so does the app, so an outage never locks a room out.
SimulationEntry simulationEntryFor({
  required bool hasTeam,
  required bool isSelfPaced,
  required bool isFacilitator,
  required bool? gateOpen,
  required bool learnComplete,
}) {
  if (isSelfPaced || isFacilitator || !hasTeam) return SimulationEntry.enter;
  if (gateOpen != false) return SimulationEntry.enter;
  if (learnComplete) return SimulationEntry.enter;
  return SimulationEntry.waitForFacilitator;
}

/// Parses the GET /facilitator/simulation-access payload `{success, open}`.
/// Returns null when the payload does not carry the switch, so a dead route
/// (404 `{success:false}`) reads as "unknown" rather than "closed".
bool? simulationAccessFromJson(Map<String, dynamic> json) {
  if (json['success'] == false) return null;
  final open = json['open'];
  return open is bool ? open : null;
}

/// The website's learn-complete bypass (`isEducationLearnComplete`): true once
/// every content module a learner works through in this app has its Learn
/// section done for the given progress [scope] (the team id for corporate
/// teams; edu_module_screen writes `edu_module_<scope>_<id>_learn`).
bool learnCompleteForScope(SharedPreferences prefs, String scope) {
  for (final m in inAppContentModules) {
    if (!(prefs.getBool('edu_module_${scope}_${m.num}_learn') ?? false)) {
      return false;
    }
  }
  return true;
}
