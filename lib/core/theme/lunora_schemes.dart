import 'package:material_ui/material_ui.dart';

/// A coordinated color palette for one scheme, in both light
/// and dark variants.
///
/// Designed to keep the "warm cream" feel from the Olive reference
/// in light mode, and a soft "warm charcoal" in dark mode.
class LunoraScheme {
  const LunoraScheme({
    required this.id,
    required this.label,
    required this.primary,
    required this.primaryDeep,
    required this.primarySoft,
    required this.primaryPale,
    required this.surface,
    required this.surfaceAlt,
    required this.line,
    required this.ink,
    required this.inkSoft,
    required this.inkPale,
    required this.gradientStart,
    required this.gradientEnd,
  });

  final String id;
  final String label;
  final Color primary;
  final Color primaryDeep;
  final Color primarySoft;
  final Color primaryPale;
  final Color surface;
  final Color surfaceAlt;
  final Color line;
  final Color ink;
  final Color inkSoft;
  final Color inkPale;
  final Color gradientStart;
  final Color gradientEnd;

  LinearGradient get gradient => LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [gradientStart, gradientEnd],
      );
}

class LunoraSchemes {
  LunoraSchemes._();

  // ── Purple (default — matches Olive) ───────────────────────
  static const purple = LunoraScheme(
    id: 'purple',
    label: 'Purple',
    primary: Color(0xFFB481D9),
    primaryDeep: Color(0xFF9B5FC7),
    primarySoft: Color(0xFFE8D5F0),
    primaryPale: Color(0xFFF3E9F8),
    surface: Color(0xFFF7F2EE),
    surfaceAlt: Color(0xFFFFFFFF),
    line: Color(0xFFEDE5DD),
    ink: Color(0xFF1A1A1A),
    inkSoft: Color(0xFF6B6B6B),
    inkPale: Color(0xFFA8A8A8),
    gradientStart: Color(0xFFC99DD9),
    gradientEnd: Color(0xFFB481D9),
  );

  // ── Pink ───────────────────────────────────────────────────
  static const pink = LunoraScheme(
    id: 'pink',
    label: 'Pink',
    primary: Color(0xFFE89AB7),
    primaryDeep: Color(0xFFC96A90),
    primarySoft: Color(0xFFFBE4EC),
    primaryPale: Color(0xFFFDF1F5),
    surface: Color(0xFFFAF3F1),
    surfaceAlt: Color(0xFFFFFFFF),
    line: Color(0xFFEFE0E0),
    ink: Color(0xFF1A1A1A),
    inkSoft: Color(0xFF6B6B6B),
    inkPale: Color(0xFFA8A8A8),
    gradientStart: Color(0xFFF0B5CC),
    gradientEnd: Color(0xFFE89AB7),
  );

  // ── Blue ───────────────────────────────────────────────────
  static const blue = LunoraScheme(
    id: 'blue',
    label: 'Blue',
    primary: Color(0xFF7A9DD9),
    primaryDeep: Color(0xFF4F71B8),
    primarySoft: Color(0xFFDCE6F7),
    primaryPale: Color(0xFFEEF3FA),
    surface: Color(0xFFF2F5FA),
    surfaceAlt: Color(0xFFFFFFFF),
    line: Color(0xFFDDE3EC),
    ink: Color(0xFF1A1A1A),
    inkSoft: Color(0xFF6B6B6B),
    inkPale: Color(0xFFA8A8A8),
    gradientStart: Color(0xFF9DB9E8),
    gradientEnd: Color(0xFF7A9DD9),
  );

  // ── Red ────────────────────────────────────────────────────
  static const red = LunoraScheme(
    id: 'red',
    label: 'Blush',
    primary: Color(0xFFE97870),
    primaryDeep: Color(0xFFC85E58),
    primarySoft: Color(0xFFF9DDD8),
    primaryPale: Color(0xFFFFF0EC),
    surface: Color(0xFFFFF4F0),
    surfaceAlt: Color(0xFFFFFFFF),
    line: Color(0xFFF1E4E0),
    ink: Color(0xFF2A2223),
    inkSoft: Color(0xFF75696A),
    inkPale: Color(0xFFAA9D9D),
    gradientStart: Color(0xFFEF8E84),
    gradientEnd: Color(0xFFE46E68),
  );

  static const List<LunoraScheme> all = [purple, pink, blue, red];

  static LunoraScheme byId(String id) {
    return all.firstWhere(
      (s) => s.id == id,
      orElse: () => purple,
    );
  }
}

/// Dark variants — derived from each scheme's hue.
class LunoraDarkSchemes {
  LunoraDarkSchemes._();

  static const purple = LunoraScheme(
    id: 'purple',
    label: 'Purple',
    primary: Color(0xFFC99DD9),
    primaryDeep: Color(0xFFE8D5F0),
    primarySoft: Color(0xFF3D2E4C),
    primaryPale: Color(0xFF2A1F33),
    surface: Color(0xFF1A1619),
    surfaceAlt: Color(0xFF241F27),
    line: Color(0xFF332B39),
    ink: Color(0xFFF0EAED),
    inkSoft: Color(0xFFB0A6B3),
    inkPale: Color(0xFF6B616E),
    gradientStart: Color(0xFF9B5FC7),
    gradientEnd: Color(0xFFB481D9),
  );

  static const pink = LunoraScheme(
    id: 'pink',
    label: 'Pink',
    primary: Color(0xFFF0B5CC),
    primaryDeep: Color(0xFFFBE4EC),
    primarySoft: Color(0xFF4A2D38),
    primaryPale: Color(0xFF2F1D24),
    surface: Color(0xFF1A1416),
    surfaceAlt: Color(0xFF241B1E),
    line: Color(0xFF3D2A2F),
    ink: Color(0xFFF2EAEC),
    inkSoft: Color(0xFFB3A6AA),
    inkPale: Color(0xFF6E6165),
    gradientStart: Color(0xFFC96A90),
    gradientEnd: Color(0xFFE89AB7),
  );

  static const blue = LunoraScheme(
    id: 'blue',
    label: 'Blue',
    primary: Color(0xFF9DB9E8),
    primaryDeep: Color(0xFFDCE6F7),
    primarySoft: Color(0xFF2E3D54),
    primaryPale: Color(0xFF1F2838),
    surface: Color(0xFF14171D),
    surfaceAlt: Color(0xFF1B1F28),
    line: Color(0xFF2A303D),
    ink: Color(0xFFECEEF2),
    inkSoft: Color(0xFFA6AAB3),
    inkPale: Color(0xFF616570),
    gradientStart: Color(0xFF4F71B8),
    gradientEnd: Color(0xFF7A9DD9),
  );

  static const red = LunoraScheme(
    id: 'red',
    label: 'Red',
    primary: Color(0xFFE89A9A),
    primaryDeep: Color(0xFFF7DCDC),
    primarySoft: Color(0xFF4A2D2D),
    primaryPale: Color(0xFF2F1D1D),
    surface: Color(0xFF1A1414),
    surfaceAlt: Color(0xFF241B1B),
    line: Color(0xFF3D2A2A),
    ink: Color(0xFFF2EAEA),
    inkSoft: Color(0xFFB3A6A6),
    inkPale: Color(0xFF6E6161),
    gradientStart: Color(0xFFB84F4F),
    gradientEnd: Color(0xFFD97A7A),
  );

  static const List<LunoraScheme> all = [purple, pink, blue, red];

  static LunoraScheme byId(String id) {
    return all.firstWhere(
      (s) => s.id == id,
      orElse: () => purple,
    );
  }
}
