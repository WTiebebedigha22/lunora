/// User-selected appearance + language settings.
///
/// `mode`       — 'light' | 'dark' | 'system'
/// `schemeId`   — 'purple' | 'pink' | 'blue' | 'red'
/// `localeCode` — 'system' | 'en' | 'es' | 'fr' | 'ar'
class ThemePreferences {
  ThemePreferences({
    this.mode = 'system',
    this.schemeId = 'red',
    this.localeCode = 'system',
  });

  final String mode;
  final String schemeId;
  final String localeCode;

  ThemePreferences copyWith({
    String? mode,
    String? schemeId,
    String? localeCode,
  }) {
    return ThemePreferences(
      mode: mode ?? this.mode,
      schemeId: schemeId ?? this.schemeId,
      localeCode: localeCode ?? this.localeCode,
    );
  }

  Map<String, dynamic> toMap() => {
        'mode': mode,
        'schemeId': schemeId,
        'localeCode': localeCode,
      };

  factory ThemePreferences.fromMap(Map<dynamic, dynamic> m) {
    return ThemePreferences(
      mode: (m['mode'] as String?) ?? 'system',
      schemeId: (m['schemeId'] as String?) ?? 'red',
      localeCode: (m['localeCode'] as String?) ?? 'system',
    );
  }
}
