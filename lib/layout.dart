import 'dart:ui' show Size;

/// The width from which a landscape screen is laid out in two panes.
const kWideWidth = 720.0;

/// The widest the app grows in the two-pane layout; a wider window shows its
/// background on both sides.
const maxWideAppWidth = 1180.0;

/// The longest side from which a phone may be turned to landscape; smaller
/// phones have no room for two panes and stay in portrait.
const kLandscapeLongestSide = 850.0;

/// Whether a window of [size] is laid out in two panes: wide, and wider
/// than it is tall.
bool isWideLayout(Size size) => size.width >= kWideWidth && size.width > size.height;

/// Whether a screen of [size] is big enough to be turned to landscape.
bool canTurnToLandscape(Size size) => size.longestSide >= kLandscapeLongestSide;
