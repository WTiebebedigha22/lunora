import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of LunoraLocalizations
/// returned by `LunoraLocalizations.of(context)`.
///
/// Applications need to include `LunoraLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: LunoraLocalizations.localizationsDelegates,
///   supportedLocales: LunoraLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the LunoraLocalizations.supportedLocales
/// property.
abstract class LunoraLocalizations {
  LunoraLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static LunoraLocalizations of(BuildContext context) {
    return Localizations.of<LunoraLocalizations>(context, LunoraLocalizations)!;
  }

  static const LocalizationsDelegate<LunoraLocalizations> delegate =
      _LunoraLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('es'),
    Locale('fr')
  ];

  /// App name
  ///
  /// In en, this message translates to:
  /// **'Lunora'**
  String get appTitle;

  /// Bottom nav - home tab
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// Bottom nav - cycle tab
  ///
  /// In en, this message translates to:
  /// **'Cycle'**
  String get navCycle;

  /// Bottom nav - history tab
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// Bottom nav - insights tab
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get navInsights;

  /// Bottom nav - settings tab
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// Greeting before noon
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get greetingMorning;

  /// Greeting in afternoon
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get greetingAfternoon;

  /// Greeting in evening
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get greetingEvening;

  /// Label for today
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayLabel;

  /// Eyebrow for daily log card
  ///
  /// In en, this message translates to:
  /// **'DAILY LOG'**
  String get dailyLogEyebrow;

  /// Shown when user has logged
  ///
  /// In en, this message translates to:
  /// **'You logged today'**
  String get loggedToday;

  /// Prompt when nothing logged yet
  ///
  /// In en, this message translates to:
  /// **'How are you feeling?'**
  String get howFeeling;

  /// Button to open symptom log
  ///
  /// In en, this message translates to:
  /// **'Log symptoms'**
  String get logSymptoms;

  /// Button to update existing log
  ///
  /// In en, this message translates to:
  /// **'Update log'**
  String get updateLog;

  /// Eyebrow for medication card
  ///
  /// In en, this message translates to:
  /// **'MEDICATION'**
  String get medicationEyebrow;

  /// Empty state for meds
  ///
  /// In en, this message translates to:
  /// **'No medications yet'**
  String get noMedsYet;

  /// Button to add med
  ///
  /// In en, this message translates to:
  /// **'Add medication'**
  String get addMedication;

  /// Button to manage existing
  ///
  /// In en, this message translates to:
  /// **'Manage medications'**
  String get manageMedications;

  /// Med adherence summary
  ///
  /// In en, this message translates to:
  /// **'{taken} of {total} taken'**
  String medsTakenOf(int taken, int total);

  /// Eyebrow for cycle card
  ///
  /// In en, this message translates to:
  /// **'CYCLE'**
  String get cycleEyebrow;

  /// Empty state for cycle
  ///
  /// In en, this message translates to:
  /// **'No cycle data yet'**
  String get noCycleData;

  /// When a cycle is ongoing
  ///
  /// In en, this message translates to:
  /// **'Cycle in progress'**
  String get cycleInProgress;

  /// Average cycle length
  ///
  /// In en, this message translates to:
  /// **'{days}-day average'**
  String cycleAverageDays(int days);

  /// Cycle length range
  ///
  /// In en, this message translates to:
  /// **'Range {min}–{max} days'**
  String cycleRangeDays(int min, int max);

  /// Cycle tab subtitle
  ///
  /// In en, this message translates to:
  /// **'Irregularity is expected.'**
  String get irregularityExpected;

  /// Button to log a period
  ///
  /// In en, this message translates to:
  /// **'Log period'**
  String get logPeriod;

  /// Cycle action
  ///
  /// In en, this message translates to:
  /// **'Mark period start'**
  String get markPeriodStart;

  /// Cycle action
  ///
  /// In en, this message translates to:
  /// **'Mark period end'**
  String get markPeriodEnd;

  /// Cycle action
  ///
  /// In en, this message translates to:
  /// **'Remove this cycle start'**
  String get removeCycleStart;

  /// Cycle action
  ///
  /// In en, this message translates to:
  /// **'Remove this cycle end'**
  String get removeCycleEnd;

  /// Fallback in cycle sheet
  ///
  /// In en, this message translates to:
  /// **'No cycle action available on this day.'**
  String get noCycleAction;

  /// Symptom log severity title
  ///
  /// In en, this message translates to:
  /// **'Overall severity'**
  String get severityLabel;

  /// Severity 1
  ///
  /// In en, this message translates to:
  /// **'Very mild'**
  String get severityVeryMild;

  /// Severity 2
  ///
  /// In en, this message translates to:
  /// **'Mild'**
  String get severityMild;

  /// Severity 3
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get severityModerate;

  /// Severity 4
  ///
  /// In en, this message translates to:
  /// **'Severe'**
  String get severitySevere;

  /// Severity 5
  ///
  /// In en, this message translates to:
  /// **'Very severe'**
  String get severityVerySevere;

  /// Symptoms section
  ///
  /// In en, this message translates to:
  /// **'Symptoms'**
  String get symptomsTitle;

  /// Symptoms subtitle
  ///
  /// In en, this message translates to:
  /// **'Tap everything that applies'**
  String get symptomsPrompt;

  /// Notes field label
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get notesOptional;

  /// Notes placeholder
  ///
  /// In en, this message translates to:
  /// **'Anything you want to remember…'**
  String get notesHint;

  /// Save button
  ///
  /// In en, this message translates to:
  /// **'Save log'**
  String get saveLog;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Close button
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Next step button
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// History screen title
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// Log segment
  ///
  /// In en, this message translates to:
  /// **'Log'**
  String get logSegment;

  /// Trends segment
  ///
  /// In en, this message translates to:
  /// **'Trends'**
  String get trendsSegment;

  /// Empty history state
  ///
  /// In en, this message translates to:
  /// **'No logs yet'**
  String get noLogsYet;

  /// Empty history explanation
  ///
  /// In en, this message translates to:
  /// **'Tap \"Log symptoms\" on Home to start your first entry.'**
  String get noLogsBody;

  /// Top symptoms card eyebrow
  ///
  /// In en, this message translates to:
  /// **'TOP SYMPTOMS'**
  String get topSymptoms;

  /// Trends title
  ///
  /// In en, this message translates to:
  /// **'Trends'**
  String get trendsTitle;

  /// Trends disclaimer
  ///
  /// In en, this message translates to:
  /// **'Descriptive only. No predictions, no interpretations.'**
  String get trendsSubtitle;

  /// Trends empty state title
  ///
  /// In en, this message translates to:
  /// **'Not enough data yet'**
  String get notEnoughData;

  /// Trends empty state body
  ///
  /// In en, this message translates to:
  /// **'Log a few more days to see trends here. We need at least 3 logged days in the window.'**
  String get notEnoughDataBody;

  /// Insights screen title
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get insightsTitle;

  /// Saved articles tab
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get savedTab;

  /// All articles tab
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allTab;

  /// Search placeholder
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchHint;

  /// Read more link
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get readMore;

  /// Read time
  ///
  /// In en, this message translates to:
  /// **'{n} min read'**
  String minRead(int n);

  /// Settings title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Appearance section header
  ///
  /// In en, this message translates to:
  /// **'APPEARANCE'**
  String get appearanceSection;

  /// Theme mode label
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeModeLabel;

  /// Light theme
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// Dark theme
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// System theme
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// Color scheme label
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get colorSchemeLabel;

  /// Purple scheme
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get schemePurple;

  /// Pink scheme
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get schemePink;

  /// Blue scheme
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get schemeBlue;

  /// Red scheme
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get schemeRed;

  /// Language section label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// Follow device language
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get languageSystem;

  /// English
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// Spanish
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// French
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// Arabic
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// Section header
  ///
  /// In en, this message translates to:
  /// **'DOCTOR REPORTS'**
  String get doctorReportsSection;

  /// Reports card title
  ///
  /// In en, this message translates to:
  /// **'Summary for your next appointment'**
  String get doctorReportsTitle;

  /// Reports card body
  ///
  /// In en, this message translates to:
  /// **'Cycles, top symptoms, adherence, and daily log detail. Descriptive only.'**
  String get doctorReportsBody;

  /// Preview button
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// Export button
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get exportPdf;

  /// Busy state
  ///
  /// In en, this message translates to:
  /// **'Working…'**
  String get working;

  /// Data section header
  ///
  /// In en, this message translates to:
  /// **'DATA'**
  String get dataSection;

  /// Demo data row
  ///
  /// In en, this message translates to:
  /// **'Load demo data'**
  String get loadDemoData;

  /// Demo data subtitle
  ///
  /// In en, this message translates to:
  /// **'Test with realistic PCOS patterns'**
  String get loadDemoSubtitle;

  /// Reset onboarding row
  ///
  /// In en, this message translates to:
  /// **'Re-run onboarding'**
  String get rerunOnboarding;

  /// Reset onboarding subtitle
  ///
  /// In en, this message translates to:
  /// **'Keeps your logs and medications'**
  String get rerunSubtitle;

  /// Clear data row
  ///
  /// In en, this message translates to:
  /// **'Clear all data'**
  String get clearAllData;

  /// Clear data subtitle
  ///
  /// In en, this message translates to:
  /// **'Removes everything. Cannot be undone.'**
  String get clearAllSubtitle;

  /// Canonical disclaimer
  ///
  /// In en, this message translates to:
  /// **'Lunora is a tracking tool, not a medical device. It does not diagnose or treat PCOS. Always talk to your clinician about medical decisions.'**
  String get medicalDisclaimer;

  /// Onboarding step 1 title
  ///
  /// In en, this message translates to:
  /// **'Welcome to Lunora'**
  String get onboardingWelcomeTitle;

  /// Onboarding step 1 body
  ///
  /// In en, this message translates to:
  /// **'A PCOS-first wellness companion. Not a period tracker with extra screens.'**
  String get onboardingWelcomeBody;

  /// Onboarding goal title
  ///
  /// In en, this message translates to:
  /// **'What brings you here?'**
  String get onboardingGoalTitle;

  /// Onboarding goal body
  ///
  /// In en, this message translates to:
  /// **'Pick the one that matters most right now.'**
  String get onboardingGoalBody;

  /// Consent title
  ///
  /// In en, this message translates to:
  /// **'A gentle heads-up'**
  String get onboardingConsentTitle;

  /// Consent checkbox
  ///
  /// In en, this message translates to:
  /// **'I understand Lunora is not a medical device.'**
  String get onboardingConsentCheck;

  /// Continue button
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// Free tier button
  ///
  /// In en, this message translates to:
  /// **'Continue with free — always'**
  String get continueFree;

  /// Skip button
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Final onboarding CTA
  ///
  /// In en, this message translates to:
  /// **'Start using Lunora'**
  String get startUsing;

  /// Generic save
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Generic delete
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Generic remove
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// Generic done
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// Hormonal symptom group
  ///
  /// In en, this message translates to:
  /// **'Hormonal'**
  String get symptomHormonal;

  /// Metabolic symptom group
  ///
  /// In en, this message translates to:
  /// **'Metabolic'**
  String get symptomMetabolic;

  /// Mental symptom group
  ///
  /// In en, this message translates to:
  /// **'Mental'**
  String get symptomMental;

  /// Cycle symptom group
  ///
  /// In en, this message translates to:
  /// **'Cycle'**
  String get symptomCycle;

  /// Acne
  ///
  /// In en, this message translates to:
  /// **'Acne'**
  String get symptomAcne;

  /// Hirsutism
  ///
  /// In en, this message translates to:
  /// **'Excess hair'**
  String get symptomHirsutism;

  /// Hair thinning
  ///
  /// In en, this message translates to:
  /// **'Hair thinning'**
  String get symptomHairThinning;

  /// Skin darkening
  ///
  /// In en, this message translates to:
  /// **'Skin darkening'**
  String get symptomSkinDarkening;

  /// Cravings
  ///
  /// In en, this message translates to:
  /// **'Cravings'**
  String get symptomCravings;

  /// Energy crash
  ///
  /// In en, this message translates to:
  /// **'Energy crash'**
  String get symptomEnergyCrash;

  /// Bloating
  ///
  /// In en, this message translates to:
  /// **'Bloating'**
  String get symptomBloating;

  /// Weight change
  ///
  /// In en, this message translates to:
  /// **'Weight change'**
  String get symptomWeightChange;

  /// Anxiety
  ///
  /// In en, this message translates to:
  /// **'Anxiety'**
  String get symptomAnxiety;

  /// Mood swings
  ///
  /// In en, this message translates to:
  /// **'Mood swings'**
  String get symptomMoodSwings;

  /// Brain fog
  ///
  /// In en, this message translates to:
  /// **'Brain fog'**
  String get symptomBrainFog;

  /// Low motivation
  ///
  /// In en, this message translates to:
  /// **'Low motivation'**
  String get symptomLowMotivation;

  /// Spotting
  ///
  /// In en, this message translates to:
  /// **'Spotting'**
  String get symptomSpotting;

  /// Cramping
  ///
  /// In en, this message translates to:
  /// **'Cramping'**
  String get symptomCramping;

  /// Heavy flow
  ///
  /// In en, this message translates to:
  /// **'Heavy flow'**
  String get symptomFlowHeavy;

  /// Light flow
  ///
  /// In en, this message translates to:
  /// **'Light flow'**
  String get symptomFlowLight;
}

class _LunoraLocalizationsDelegate
    extends LocalizationsDelegate<LunoraLocalizations> {
  const _LunoraLocalizationsDelegate();

  @override
  Future<LunoraLocalizations> load(Locale locale) {
    return SynchronousFuture<LunoraLocalizations>(
        lookupLunoraLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_LunoraLocalizationsDelegate old) => false;
}

LunoraLocalizations lookupLunoraLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return LunoraLocalizationsAr();
    case 'en':
      return LunoraLocalizationsEn();
    case 'es':
      return LunoraLocalizationsEs();
    case 'fr':
      return LunoraLocalizationsFr();
  }

  throw FlutterError(
      'LunoraLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
