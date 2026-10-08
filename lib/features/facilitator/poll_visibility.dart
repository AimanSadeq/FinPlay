import 'package:flutter/widgets.dart';

/// Whether a polling widget is actually on screen: mounted, on the top route (not under a
/// pushed screen such as the Setup Wizard) and not in an offstage/ticker-muted subtree.
/// Pollers skip their tick when this is false, so hidden panels stop hitting the server.
bool isPollVisible(State state) {
  if (!state.mounted) return false;
  final context = state.context;
  final route = ModalRoute.of(context);
  if (route != null && !route.isCurrent) return false;
  return TickerMode.of(context);
}
