import '../shared/models/cycle.dart';
import '../shared/models/day_log.dart';
import '../shared/models/lunora_state.dart';
import '../shared/models/medication.dart';

/// Demo profiles sourced from real PCOS community experiences.
///
/// Sources:
/// - Clue member story (Brianna): 6-month gaps, tracking as advocacy
/// - r/PCOS: "lean PCOS" dismissal, "told to lose weight for 7 years"
/// - r/endometriosis: 27-day heavy bleeding, ER visits
/// - Pakistan qualitative study: hirsutism + social withdrawal
/// - Research: body image 79%, hirsutism 75%, irregular 65% [citation:10]
///
/// These are synthetic reconstructions, not real people's private data.
/// They represent patterns reported publicly in patient communities.
class DemoProfile {
  const DemoProfile({
    required this.id,
    required this.name,
    required this.description,
    required this.meds,
    required this.cycles,
    required this.logs,
  });

  final String id;
  final String name;
  final String description;
  final List<Medication> meds;
  final List<Cycle> cycles;
  final Map<String, DayLog> logs;
}

/// Build a date string offset from today by [daysAgo].
String _d(int daysAgo) {
  final n = DateTime.now().subtract(Duration(days: daysAgo));
  return '${n.year.toString().padLeft(4, '0')}-'
      '${n.month.toString().padLeft(2, '0')}-'
      '${n.day.toString().padLeft(2, '0')}';
}

/// Build a medication with a stable id.
Medication _m(String id, String name, String dose) => Medication(
      id: id,
      name: name,
      dose: dose,
      createdAt: DateTime.now().millisecondsSinceEpoch - 86400000,
    );

/// Build a cycle.
Cycle _c(String id, int startDaysAgo, int? endDaysAgo, {String? flow}) {
  return Cycle(
    id: id,
    startDate: _d(startDaysAgo),
    endDate: endDaysAgo == null ? null : _d(endDaysAgo),
    flow: flow,
    createdAt: DateTime.now().millisecondsSinceEpoch - startDaysAgo * 86400000,
  );
}

/// Build a log.
DayLog _l({
  List<String> symptoms = const [],
  int severity = 3,
  String notes = '',
  List<String> meds = const [],
  int daysAgo = 0,
}) {
  return DayLog(
    symptoms: symptoms,
    severity: severity,
    notes: notes,
    meds: meds,
    updatedAt: DateTime.now().millisecondsSinceEpoch - daysAgo * 86400000,
  );
}

/// All demo profiles.
final List<DemoProfile> demoProfiles = [
  // ── demo_1: The 6-month cycler ────────────────────────────
  // Source: Clue Brianna story — periods every 6 months or
  // longer, tracking as daily journal, used data for diagnosis
  // advocacy.
  DemoProfile(
    id: 'demo_1',
    name: 'The 6-month cycler',
    description: 'Periods every 5–12 months. Tracks daily mood and energy '
        'because bleeding alone isn\'t enough data.',
    meds: [
      _m('demo_1_m1', 'Metformin', '500mg'),
      _m('demo_1_m2', 'Vitamin D', '2000 IU'),
    ],
    cycles: [
      _c('demo_1_c1', 210, 205, flow: 'medium'),
      _c('demo_1_c2', 390, 384, flow: 'light'),
    ],
    logs: {
      _d(0): _l(
        symptoms: ['bloating', 'brain_fog'],
        severity: 2,
        notes: 'Tired but okay.',
        meds: ['demo_1_m1', 'demo_1_m2'],
        daysAgo: 0,
      ),
      _d(1): _l(
        symptoms: ['cravings', 'low_motivation'],
        severity: 3,
        notes: 'Could not focus at work.',
        meds: ['demo_1_m1'],
        daysAgo: 1,
      ),
      _d(3): _l(
        symptoms: ['bloating', 'acne'],
        severity: 3,
        meds: ['demo_1_m1', 'demo_1_m2'],
        daysAgo: 3,
      ),
      _d(5): _l(
        symptoms: ['anxiety', 'brain_fog'],
        severity: 4,
        notes: 'Presentation day. Felt foggy.',
        meds: ['demo_1_m1'],
        daysAgo: 5,
      ),
      _d(7): _l(
        symptoms: ['bloating'],
        severity: 2,
        meds: ['demo_1_m1', 'demo_1_m2'],
        daysAgo: 7,
      ),
      _d(10): _l(
        symptoms: ['cravings', 'energy_crash'],
        severity: 3,
        notes: 'Needed a nap at 3pm.',
        meds: ['demo_1_m1'],
        daysAgo: 10,
      ),
      _d(14): _l(
        symptoms: ['acne', 'mood_swings'],
        severity: 3,
        meds: ['demo_1_m1', 'demo_1_m2'],
        daysAgo: 14,
      ),
    },
  ),

  // ── demo_2: The lean PCOS skeptic ─────────────────────────
  // Source: r/PCOS "lean PCOS affects 20-30%, systematically
  // underdiagnosed." "I was told to lose weight for 7 years
  // before anyone tested my insulin."
  DemoProfile(
    id: 'demo_2',
    name: 'The lean PCOS skeptic',
    description: 'BMI normal, so dismissed for years. Cycles are 35–45 days '
        '— "regular enough" that doctors didn\'t test further.',
    meds: [
      _m('demo_2_m1', 'Inositol', '2g'),
      _m('demo_2_m2', 'Spironolactone', '50mg'),
    ],
    cycles: [
      _c('demo_2_c1', 40, 34, flow: 'medium'),
      _c('demo_2_c2', 85, 79, flow: 'heavy'),
      _c('demo_2_c3', 130, 125, flow: 'medium'),
      _c('demo_2_c4', 175, 170, flow: 'light'),
    ],
    logs: {
      _d(0): _l(
        symptoms: ['acne', 'hair_thinning'],
        severity: 2,
        notes: 'Chin breakout again.',
        meds: ['demo_2_m1', 'demo_2_m2'],
        daysAgo: 0,
      ),
      _d(2): _l(
        symptoms: ['anxiety', 'hair_thinning'],
        severity: 3,
        meds: ['demo_2_m1', 'demo_2_m2'],
        daysAgo: 2,
      ),
      _d(4): _l(
        symptoms: ['acne', 'mood_swings', 'low_motivation'],
        severity: 4,
        notes: 'Argued with partner. Probably hormonal.',
        meds: ['demo_2_m1'],
        daysAgo: 4,
      ),
      _d(6): _l(
        symptoms: ['hair_thinning'],
        severity: 2,
        notes: 'Shedding more in the shower.',
        meds: ['demo_2_m1', 'demo_2_m2'],
        daysAgo: 6,
      ),
      _d(9): _l(
        symptoms: ['acne', 'anxiety'],
        severity: 3,
        meds: ['demo_2_m1', 'demo_2_m2'],
        daysAgo: 9,
      ),
      _d(12): _l(
        symptoms: ['mood_swings', 'brain_fog'],
        severity: 3,
        meds: ['demo_2_m1'],
        daysAgo: 12,
      ),
      _d(18): _l(
        symptoms: ['acne', 'cravings'],
        severity: 2,
        meds: ['demo_2_m1', 'demo_2_m2'],
        daysAgo: 18,
      ),
      _d(25): _l(
        symptoms: ['anxiety', 'low_motivation'],
        severity: 3,
        notes: 'Hard week.',
        meds: ['demo_2_m1', 'demo_2_m2'],
        daysAgo: 25,
      ),
    },
  ),

  // ── demo_3: The heavy bleeder ─────────────────────────────
  // Source: r/endometriosis — 27 days heavy bleeding, adult
  // diapers, ER visits, pain affecting work.
  DemoProfile(
    id: 'demo_3',
    name: 'The heavy bleeder',
    description: 'Bleeding lasts 10–27 days. Pain is severe enough that '
        'work and daily function are affected.',
    meds: [
      _m('demo_3_m1', 'Birth control', 'daily'),
      _m('demo_3_m2', 'Omega-3', '1000mg'),
    ],
    cycles: [
      _c('demo_3_c1', 55, 35, flow: 'heavy'),
      _c('demo_3_c2', 105, 80, flow: 'heavy'),
      _c('demo_3_c3', 150, 135, flow: 'medium'),
    ],
    logs: {
      _d(0): _l(
        symptoms: ['flow_heavy', 'cramping', 'energy_crash'],
        severity: 5,
        notes: 'Day 12 of bleeding. Exhausted.',
        meds: ['demo_3_m1', 'demo_3_m2'],
        daysAgo: 0,
      ),
      _d(1): _l(
        symptoms: ['flow_heavy', 'cramping', 'brain_fog'],
        severity: 5,
        notes: 'Could not work. Lied down all day.',
        meds: ['demo_3_m1'],
        daysAgo: 1,
      ),
      _d(2): _l(
        symptoms: ['flow_heavy', 'cramping', 'anxiety'],
        severity: 4,
        notes: 'Scared about how long this is lasting.',
        meds: ['demo_3_m1', 'demo_3_m2'],
        daysAgo: 2,
      ),
      _d(4): _l(
        symptoms: ['cramping', 'energy_crash'],
        severity: 4,
        meds: ['demo_3_m1', 'demo_3_m2'],
        daysAgo: 4,
      ),
      _d(6): _l(
        symptoms: ['flow_heavy', 'cramping'],
        severity: 5,
        notes: 'Considering ER again.',
        meds: ['demo_3_m1'],
        daysAgo: 6,
      ),
      _d(9): _l(
        symptoms: ['flow_medium', 'cramping', 'low_motivation'],
        severity: 4,
        meds: ['demo_3_m1', 'demo_3_m2'],
        daysAgo: 9,
      ),
      _d(12): _l(
        symptoms: ['cramping', 'anxiety'],
        severity: 3,
        meds: ['demo_3_m1', 'demo_3_m2'],
        daysAgo: 12,
      ),
      _d(15): _l(
        symptoms: ['flow_light', 'spotting'],
        severity: 2,
        notes: 'Finally slowing down.',
        meds: ['demo_3_m1'],
        daysAgo: 15,
      ),
    },
  ),

  // ── demo_4: The hirsutism + mental health ─────────────────
  // Source: Pakistan qualitative study — "I lost my spark,"
  // social withdrawal, avoiding family gatherings due to
  // fertility questions. Hirsutism 75% prevalence.
  DemoProfile(
    id: 'demo_4',
    name: 'The hirsutism + mental health',
    description: 'Visible symptoms affect social life. Cycles are 60–90 days. '
        'Mood and body image are the hardest part.',
    meds: [
      _m('demo_4_m1', 'Spironolactone', '100mg'),
      _m('demo_4_m2', 'Metformin', '500mg'),
    ],
    cycles: [
      _c('demo_4_c1', 90, 84, flow: 'medium'),
      _c('demo_4_c2', 180, 174, flow: 'light'),
    ],
    logs: {
      _d(0): _l(
        symptoms: ['hirsutism', 'low_motivation', 'anxiety'],
        severity: 4,
        notes: 'Avoided a party. Could not face the questions.',
        meds: ['demo_4_m1', 'demo_4_m2'],
        daysAgo: 0,
      ),
      _d(1): _l(
        symptoms: ['hirsutism', 'mood_swings'],
        severity: 3,
        meds: ['demo_4_m1'],
        daysAgo: 1,
      ),
      _d(3): _l(
        symptoms: ['acne', 'hirsutism', 'anxiety'],
        severity: 4,
        notes: 'Cancelled coffee with a friend.',
        meds: ['demo_4_m1', 'demo_4_m2'],
        daysAgo: 3,
      ),
      _d(5): _l(
        symptoms: ['cravings', 'brain_fog'],
        severity: 3,
        meds: ['demo_4_m1', 'demo_4_m2'],
        daysAgo: 5,
      ),
      _d(7): _l(
        symptoms: ['low_motivation', 'energy_crash'],
        severity: 4,
        notes: 'Stayed in bed until noon.',
        meds: ['demo_4_m1'],
        daysAgo: 7,
      ),
      _d(10): _l(
        symptoms: ['hirsutism', 'acne', 'mood_swings'],
        severity: 3,
        meds: ['demo_4_m1', 'demo_4_m2'],
        daysAgo: 10,
      ),
      _d(14): _l(
        symptoms: ['anxiety', 'brain_fog'],
        severity: 3,
        meds: ['demo_4_m1', 'demo_4_m2'],
        daysAgo: 14,
      ),
    },
  ),

  // ── demo_5: The newly diagnosed ───────────────────────────
  // Source: r/PCOS + research — "no guidance on diet,"
  // confusion, "just maintain healthy habits." 2–12 year
  // diagnostic delay. Cravings + weight change common.
  DemoProfile(
    id: 'demo_5',
    name: 'The newly diagnosed',
    description: 'Diagnosed 3 months ago. Cycles are 40–50 days. Overwhelmed '
        'by conflicting advice, trying to build a routine.',
    meds: [
      _m('demo_5_m1', 'Metformin', '500mg'),
    ],
    cycles: [
      _c('demo_5_c1', 45, 40, flow: 'medium'),
      _c('demo_5_c2', 95, 90, flow: 'light'),
      _c('demo_5_c3', 140, null, flow: null), // ongoing
    ],
    logs: {
      _d(0): _l(
        symptoms: ['cravings', 'bloating'],
        severity: 2,
        notes: 'Started Metformin. Stomach is weird.',
        meds: ['demo_5_m1'],
        daysAgo: 0,
      ),
      _d(2): _l(
        symptoms: ['cravings', 'brain_fog', 'low_motivation'],
        severity: 3,
        notes: 'Read 3 different diet articles. More confused.',
        meds: ['demo_5_m1'],
        daysAgo: 2,
      ),
      _d(4): _l(
        symptoms: ['bloating', 'weight_change'],
        severity: 3,
        meds: ['demo_5_m1'],
        daysAgo: 4,
      ),
      _d(7): _l(
        symptoms: ['anxiety', 'cravings'],
        severity: 4,
        notes: 'Scared about long-term health.',
        meds: ['demo_5_m1'],
        daysAgo: 7,
      ),
      _d(10): _l(
        symptoms: ['bloating', 'energy_crash'],
        severity: 2,
        meds: ['demo_5_m1'],
        daysAgo: 10,
      ),
      _d(14): _l(
        symptoms: ['cravings', 'weight_change', 'anxiety'],
        severity: 3,
        notes: 'Trying to walk 20 min a day.',
        meds: ['demo_5_m1'],
        daysAgo: 14,
      ),
    },
  ),
];

/// Replace the given state with a demo profile.
LunoraState applyDemoProfile(LunoraState current, String profileId) {
  final profile = demoProfiles.firstWhere(
    (p) => p.id == profileId,
    orElse: () => demoProfiles.first,
  );

  return LunoraState(
    onboarding: current.onboarding,
    logs: profile.logs,
    meds: profile.meds,
    cycles: profile.cycles,
    education: current.education,
  );
}

/// Merge demo data into the current state without overwriting
/// existing user data. Useful for "load demo data" in Settings
/// while keeping onboarding progress.
LunoraState mergeDemoData(LunoraState current, String profileId) {
  final profile = demoProfiles.firstWhere(
    (p) => p.id == profileId,
    orElse: () => demoProfiles.first,
  );

  final mergedLogs = Map<String, DayLog>.from(current.logs);
  for (final entry in profile.logs.entries) {
    mergedLogs.putIfAbsent(entry.key, () => entry.value);
  }

  final mergedMeds = [...current.meds];
  for (final m in profile.meds) {
    if (!mergedMeds.any((x) => x.name == m.name)) {
      mergedMeds.add(m);
    }
  }

  final mergedCycles = [...current.cycles];
  for (final c in profile.cycles) {
    if (!mergedCycles.any((x) => x.startDate == c.startDate)) {
      mergedCycles.add(c);
    }
  }

  return current.copyWith(
    logs: mergedLogs,
    meds: mergedMeds,
    cycles: mergedCycles,
  );
}
