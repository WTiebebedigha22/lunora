import 'package:flutter/material.dart';

import 'lunora_schemes.dart';

/// Dynamic tokens — reads from the currently active scheme.
/// Set once per build in `lunora_app.dart` before any screen renders.
class LunoraTokens {
  LunoraTokens._();

  static LunoraScheme _active = LunoraSchemes.purple;
  static Brightness _brightness = Brightness.light;

  /// Called on every theme change.
  static void apply(LunoraScheme scheme, Brightness brightness) {
    _active = scheme;
    _brightness = brightness;
  }

  static LunoraScheme get scheme => _active;
  static Brightness get brightness => _brightness;
  static bool get isDark => _brightness == Brightness.dark;

  // Surface
  static Color get bg => _active.surface;
  static Color get card => _active.surfaceAlt;
  static Color get line => _active.line;
  static Color get subtle => _active.primaryPale;

  // Accent
  static Color get purple => _active.primary;
  static Color get purpleDeep => _active.primaryDeep;
  static Color get purpleSoft => _active.primarySoft;
  static Color get purplePale => _active.primaryPale;

  // Legacy aliases (used by older screens) — map to primary accent
  static Color get lavender => _active.primarySoft;
  static Color get lavenderDeep => _active.primary;
  static Color get pink => _active.primaryPale;
  static Color get pinkDeep => _active.primary;
  static Color get blue => _active.primarySoft;
  static Color get blueDeep => _active.primaryDeep;

  // Text
  static Color get ink => _active.ink;
  static Color get inkSoft => _active.inkSoft;
  static Color get inkPale => _active.inkPale;

  // Status (fixed — not scheme-dependent for medical UI consistency)
  static const Color success = Color(0xFF7BB89A);
  static const Color warn = Color(0xFFE0A458);

  // Spacing
  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double spaceMd = 16;
  static const double spaceLg = 24;
  static const double spaceXl = 32;

  // Radius
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;
  static const double radiusPill = 999;

  // Gradient
  static LinearGradient get primaryGradient => _active.gradient;
}
