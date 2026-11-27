// ignore_for_file: deprecated_member_use

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Lunora';

  @override
  String get navHome => 'Home';

  @override
  String get navCycle => 'Cycle';

  @override
  String get navHistory => 'History';

  @override
  String get navInsights => 'Insights';

  @override
  String get navSettings => 'Settings';

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String get todayLabel => 'Today';

  @override
  String get dailyLogEyebrow => 'DAILY LOG';

  @override
  String get loggedToday => 'You logged today';

  @override
  String get howFeeling => 'How are you feeling?';

  @override
  String get logSymptoms => 'Log symptoms';

  @override
  String get updateLog => 'Update log';

  @override
  String get medicationEyebrow => 'MEDICATION';

  @override
  String get noMedsYet => 'No medications yet';

  @override
  String get addMedication => 'Add medication';

  @override
  String get manageMedications => 'Manage medications';

  @override
  String medsTakenOf(int taken, int total) {
    return '$taken of $total taken';
  }

  @override
  String get cycleEyebrow => 'CYCLE';

  @override
  String get noCycleData => 'No cycle data yet';

  @override
  String get cycleInProgress => 'Cycle in progress';

  @override
  String cycleAverageDays(int days) {
    return '$days-day average';
  }

  @override
  String cycleRangeDays(int min, int max) {
    return 'Range $min–$max days';
  }

  @override
  String get irregularityExpected => 'Irregularity is expected.';

  @override
  String get logPeriod => 'Log period';

  @override
  String get markPeriodStart => 'Mark period start';

  @override
  String get markPeriodEnd => 'Mark period end';

  @override
  String get removeCycleStart => 'Remove this cycle start';

  @override
  String get removeCycleEnd => 'Remove this cycle end';

  @override
  String get noCycleAction => 'No cycle action available on this day.';

  @override
  String get severityLabel => 'Overall severity';

  @override
  String get severityVeryMild => 'Very mild';

  @override
  String get severityMild => 'Mild';

  @override
  String get severityModerate => 'Moderate';

  @override
  String get severitySevere => 'Severe';

  @override
  String get severityVerySevere => 'Very severe';

  @override
  String get symptomsTitle => 'Symptoms';

  @override
  String get symptomsPrompt => 'Tap everything that applies';

  @override
  String get notesOptional => 'Notes (optional)';

  @override
  String get notesHint => 'Anything you want to remember…';

  @override
  String get saveLog => 'Save log';

  @override
  String get cancel => 'Cancel';

  @override
  String get close => 'Close';

  @override
  String get next => 'Next';

  @override
  String get historyTitle => 'History';

  @override
  String get logSegment => 'Log';

  @override
  String get trendsSegment => 'Trends';

  @override
  String get noLogsYet => 'No logs yet';

  @override
  String get noLogsBody =>
      'Tap \"Log symptoms\" on Home to start your first entry.';

  @override
  String get topSymptoms => 'TOP SYMPTOMS';

  @override
  String get trendsTitle => 'Trends';

  @override
  String get trendsSubtitle =>
      'Descriptive only. No predictions, no interpretations.';

  @override
  String get notEnoughData => 'Not enough data yet';

  @override
  String get notEnoughDataBody =>
      'Log a few more days to see trends here. We need at least 3 logged days in the window.';

  @override
  String get insightsTitle => 'Insights';

  @override
  String get savedTab => 'Saved';

  @override
  String get allTab => 'All';

  @override
  String get searchHint => 'Search';

  @override
  String get readMore => 'Read more';

  @override
  String minRead(int n) {
    return '$n min read';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get appearanceSection => 'APPEARANCE';

  @override
  String get themeModeLabel => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get colorSchemeLabel => 'Color';

  @override
  String get schemePurple => 'Purple';

  @override
  String get schemePink => 'Pink';

  @override
  String get schemeBlue => 'Blue';

  @override
  String get schemeRed => 'Red';

  @override
  String get languageLabel => 'Language';

  @override
  String get languageSystem => 'System';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageArabic => 'العربية';

  @override
  String get doctorReportsSection => 'DOCTOR REPORTS';

  @override
  String get doctorReportsTitle => 'Summary for your next appointment';

  @override
  String get doctorReportsBody =>
      'Cycles, top symptoms, adherence, and daily log detail. Descriptive only.';

  @override
  String get preview => 'Preview';

  @override
  String get exportPdf => 'Export PDF';

  @override
  String get working => 'Working…';

  @override
  String get dataSection => 'DATA';

  @override
  String get loadDemoData => 'Load demo data';

  @override
  String get loadDemoSubtitle => 'Test with realistic PCOS patterns';

  @override
  String get rerunOnboarding => 'Re-run onboarding';

  @override
  String get rerunSubtitle => 'Keeps your logs and medications';

  @override
  String get clearAllData => 'Clear all data';

  @override
  String get clearAllSubtitle => 'Removes everything. Cannot be undone.';

  @override
  String get medicalDisclaimer =>
      'Lunora is a tracking tool, not a medical device. It does not diagnose or treat PCOS. Always talk to your clinician about medical decisions.';

  @override
  String get onboardingWelcomeTitle => 'Welcome to Lunora';

  @override
  String get onboardingWelcomeBody =>
      'A PCOS-first wellness companion. Not a period tracker with extra screens.';

  @override
  String get onboardingGoalTitle => 'What brings you here?';

  @override
  String get onboardingGoalBody => 'Pick the one that matters most right now.';

  @override
  String get onboardingConsentTitle => 'A gentle heads-up';

  @override
  String get onboardingConsentCheck =>
      'I understand Lunora is not a medical device.';

  @override
  String get continueButton => 'Continue';

  @override
  String get continueFree => 'Continue with free — always';

  @override
  String get skip => 'Skip';

  @override
  String get startUsing => 'Start using Lunora';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get remove => 'Remove';

  @override
  String get done => 'Done';

  @override
  String get symptomHormonal => 'Hormonal';

  @override
  String get symptomMetabolic => 'Metabolic';

  @override
  String get symptomMental => 'Mental';

  @override
  String get symptomCycle => 'Cycle';

  @override
  String get symptomAcne => 'Acne';

  @override
  String get symptomHirsutism => 'Excess hair';

  @override
  String get symptomHairThinning => 'Hair thinning';

  @override
  String get symptomSkinDarkening => 'Skin darkening';

  @override
  String get symptomCravings => 'Cravings';

  @override
  String get symptomEnergyCrash => 'Energy crash';

  @override
  String get symptomBloating => 'Bloating';

  @override
  String get symptomWeightChange => 'Weight change';

  @override
  String get symptomAnxiety => 'Anxiety';

  @override
  String get symptomMoodSwings => 'Mood swings';

  @override
  String get symptomBrainFog => 'Brain fog';

  @override
  String get symptomLowMotivation => 'Low motivation';

  @override
  String get symptomSpotting => 'Spotting';

  @override
  String get symptomCramping => 'Cramping';

  @override
  String get symptomFlowHeavy => 'Heavy flow';

  @override
  String get symptomFlowLight => 'Light flow';
}
