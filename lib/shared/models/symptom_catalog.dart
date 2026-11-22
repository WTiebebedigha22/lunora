import '../../l10n/app_localizations.dart';

class SymptomItem {
  const SymptomItem({
    required this.id,
    required this.glyph,
  });

  final String id;
  final String glyph;

  /// Localized label lookup.
  String label(LunoraLocalizations l) {
    switch (id) {
      case 'acne':
        return l.symptomAcne;
      case 'hirsutism':
        return l.symptomHirsutism;
      case 'hair_thinning':
        return l.symptomHairThinning;
      case 'skin_darkening':
        return l.symptomSkinDarkening;
      case 'cravings':
        return l.symptomCravings;
      case 'energy_crash':
        return l.symptomEnergyCrash;
      case 'bloating':
        return l.symptomBloating;
      case 'weight_change':
        return l.symptomWeightChange;
      case 'anxiety':
        return l.symptomAnxiety;
      case 'mood_swings':
        return l.symptomMoodSwings;
      case 'brain_fog':
        return l.symptomBrainFog;
      case 'low_motivation':
        return l.symptomLowMotivation;
      case 'spotting':
        return l.symptomSpotting;
      case 'cramping':
        return l.symptomCramping;
      case 'flow_heavy':
        return l.symptomFlowHeavy;
      case 'flow_light':
        return l.symptomFlowLight;
      default:
        return id;
    }
  }
}

class SymptomGroup {
  const SymptomGroup({
    required this.id,
    required this.items,
    required this.glyph,
  });

  final String id;
  final String glyph;
  final List<SymptomItem> items;

  String label(LunoraLocalizations l) {
    switch (id) {
      case 'hormonal':
        return l.symptomHormonal;
      case 'metabolic':
        return l.symptomMetabolic;
      case 'mental':
        return l.symptomMental;
      case 'cycle':
        return l.symptomCycle;
      default:
        return id;
    }
  }
}

class SymptomCatalog {
  SymptomCatalog._();

  static const List<SymptomGroup> groups = [
    SymptomGroup(
      id: 'hormonal',
      glyph: '❋',
      items: [
        SymptomItem(id: 'acne', glyph: '◍'),
        SymptomItem(id: 'hirsutism', glyph: '❋'),
        SymptomItem(id: 'hair_thinning', glyph: '◌'),
        SymptomItem(id: 'skin_darkening', glyph: '◐'),
      ],
    ),
    SymptomGroup(
      id: 'metabolic',
      glyph: '✧',
      items: [
        SymptomItem(id: 'cravings', glyph: '◇'),
        SymptomItem(id: 'energy_crash', glyph: '⚡'),
        SymptomItem(id: 'bloating', glyph: '◉'),
        SymptomItem(id: 'weight_change', glyph: '⚖'),
      ],
    ),
    SymptomGroup(
      id: 'mental',
      glyph: '☾',
      items: [
        SymptomItem(id: 'anxiety', glyph: '≈'),
        SymptomItem(id: 'mood_swings', glyph: '☾'),
        SymptomItem(id: 'brain_fog', glyph: '◈'),
        SymptomItem(id: 'low_motivation', glyph: '▽'),
      ],
    ),
    SymptomGroup(
      id: 'cycle',
      glyph: '❁',
      items: [
        SymptomItem(id: 'spotting', glyph: '·'),
        SymptomItem(id: 'cramping', glyph: '⌇'),
        SymptomItem(id: 'flow_heavy', glyph: '◆'),
        SymptomItem(id: 'flow_light', glyph: '◇'),
      ],
    ),
  ];

  static String labelOf(String id, LunoraLocalizations l) {
    for (final g in groups) {
      for (final item in g.items) {
        if (item.id == id) return item.label(l);
      }
    }
    return id;
  }

  static String groupOf(String id) {
    for (final g in groups) {
      if (g.items.any((item) => item.id == id)) return g.id;
    }
    return '';
  }
}
