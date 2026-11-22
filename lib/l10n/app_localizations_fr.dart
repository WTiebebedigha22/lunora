// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class LunoraLocalizationsFr extends LunoraLocalizations {
  LunoraLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Lunora';

  @override
  String get navHome => 'Accueil';

  @override
  String get navCycle => 'Cycle';

  @override
  String get navHistory => 'Historique';

  @override
  String get navInsights => 'Articles';

  @override
  String get navSettings => 'Réglages';

  @override
  String get greetingMorning => 'Bonjour';

  @override
  String get greetingAfternoon => 'Bon après-midi';

  @override
  String get greetingEvening => 'Bonsoir';

  @override
  String get todayLabel => 'Aujourd\'hui';

  @override
  String get dailyLogEyebrow => 'JOURNAL';

  @override
  String get loggedToday => 'Vous avez noté aujourd\'hui';

  @override
  String get howFeeling => 'Comment vous sentez-vous ?';

  @override
  String get logSymptoms => 'Noter les symptômes';

  @override
  String get updateLog => 'Mettre à jour';

  @override
  String get medicationEyebrow => 'MÉDICAMENTS';

  @override
  String get noMedsYet => 'Aucun médicament';

  @override
  String get addMedication => 'Ajouter';

  @override
  String get manageMedications => 'Gérer';

  @override
  String medsTakenOf(int taken, int total) {
    return '$taken sur $total pris';
  }

  @override
  String get cycleEyebrow => 'CYCLE';

  @override
  String get noCycleData => 'Aucune donnée de cycle';

  @override
  String get cycleInProgress => 'Cycle en cours';

  @override
  String cycleAverageDays(int days) {
    return 'Moyenne de $days jours';
  }

  @override
  String cycleRangeDays(int min, int max) {
    return 'De $min à $max jours';
  }

  @override
  String get irregularityExpected => 'L\'irrégularité est attendue.';

  @override
  String get logPeriod => 'Noter les règles';

  @override
  String get markPeriodStart => 'Marquer le début';

  @override
  String get markPeriodEnd => 'Marquer la fin';

  @override
  String get removeCycleStart => 'Retirer ce début';

  @override
  String get removeCycleEnd => 'Retirer cette fin';

  @override
  String get noCycleAction => 'Aucune action disponible pour ce jour.';

  @override
  String get severityLabel => 'Intensité globale';

  @override
  String get severityVeryMild => 'Très légère';

  @override
  String get severityMild => 'Légère';

  @override
  String get severityModerate => 'Modérée';

  @override
  String get severitySevere => 'Forte';

  @override
  String get severityVerySevere => 'Très forte';

  @override
  String get symptomsTitle => 'Symptômes';

  @override
  String get symptomsPrompt => 'Touchez tout ce qui s\'applique';

  @override
  String get notesOptional => 'Notes (optionnel)';

  @override
  String get notesHint => 'Quelque chose à retenir…';

  @override
  String get saveLog => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get close => 'Fermer';

  @override
  String get next => 'Suivant';

  @override
  String get historyTitle => 'Historique';

  @override
  String get logSegment => 'Journal';

  @override
  String get trendsSegment => 'Tendances';

  @override
  String get noLogsYet => 'Aucun journal';

  @override
  String get noLogsBody => 'Touchez \"Noter les symptômes\" pour commencer.';

  @override
  String get topSymptoms => 'SYMPTÔMES FRÉQUENTS';

  @override
  String get trendsTitle => 'Tendances';

  @override
  String get trendsSubtitle => 'Descriptif uniquement. Aucune prédiction.';

  @override
  String get notEnoughData => 'Pas encore assez de données';

  @override
  String get notEnoughDataBody =>
      'Notez quelques jours de plus pour voir les tendances.';

  @override
  String get insightsTitle => 'Articles';

  @override
  String get savedTab => 'Enregistrés';

  @override
  String get allTab => 'Tous';

  @override
  String get searchHint => 'Rechercher';

  @override
  String get readMore => 'Lire plus';

  @override
  String minRead(int n) {
    return '$n min de lecture';
  }

  @override
  String get settingsTitle => 'Réglages';

  @override
  String get appearanceSection => 'APPARENCE';

  @override
  String get themeModeLabel => 'Thème';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get themeSystem => 'Système';

  @override
  String get colorSchemeLabel => 'Couleur';

  @override
  String get schemePurple => 'Violet';

  @override
  String get schemePink => 'Rose';

  @override
  String get schemeBlue => 'Bleu';

  @override
  String get schemeRed => 'Rouge';

  @override
  String get languageLabel => 'Langue';

  @override
  String get languageSystem => 'Système';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageArabic => 'العربية';

  @override
  String get doctorReportsSection => 'RAPPORTS MÉDICAUX';

  @override
  String get doctorReportsTitle => 'Résumé pour votre prochain rendez-vous';

  @override
  String get doctorReportsBody =>
      'Cycles, symptômes fréquents, observance et journal. Descriptif uniquement.';

  @override
  String get preview => 'Aperçu';

  @override
  String get exportPdf => 'Exporter PDF';

  @override
  String get working => 'En cours…';

  @override
  String get dataSection => 'DONNÉES';

  @override
  String get loadDemoData => 'Charger des données de test';

  @override
  String get loadDemoSubtitle => 'Tester avec des profils réalistes de SOPK';

  @override
  String get rerunOnboarding => 'Refaire l\'introduction';

  @override
  String get rerunSubtitle => 'Conserve vos données et médicaments';

  @override
  String get clearAllData => 'Effacer toutes les données';

  @override
  String get clearAllSubtitle => 'Supprime tout. Irréversible.';

  @override
  String get medicalDisclaimer =>
      'Lunora est un outil de suivi, pas un dispositif médical. Il ne diagnostique ni ne traite le SOPK. Consultez toujours un professionnel de santé.';

  @override
  String get onboardingWelcomeTitle => 'Bienvenue sur Lunora';

  @override
  String get onboardingWelcomeBody =>
      'Une app de bien-être dédiée au SOPK. Pas un simple tracker de règles.';

  @override
  String get onboardingGoalTitle => 'Pourquoi êtes-vous ici ?';

  @override
  String get onboardingGoalBody => 'Choisissez ce qui compte le plus.';

  @override
  String get onboardingConsentTitle => 'Un mot important';

  @override
  String get onboardingConsentCheck =>
      'Je comprends que Lunora n\'est pas un dispositif médical.';

  @override
  String get continueButton => 'Continuer';

  @override
  String get continueFree => 'Continuer gratuitement — toujours';

  @override
  String get skip => 'Passer';

  @override
  String get startUsing => 'Commencer avec Lunora';

  @override
  String get save => 'Enregistrer';

  @override
  String get delete => 'Supprimer';

  @override
  String get remove => 'Retirer';

  @override
  String get done => 'Terminé';

  @override
  String get symptomHormonal => 'Hormonal';

  @override
  String get symptomMetabolic => 'Métabolique';

  @override
  String get symptomMental => 'Mental';

  @override
  String get symptomCycle => 'Cycle';

  @override
  String get symptomAcne => 'Acné';

  @override
  String get symptomHirsutism => 'Pilosité excessive';

  @override
  String get symptomHairThinning => 'Chute de cheveux';

  @override
  String get symptomSkinDarkening => 'Peau plus foncée';

  @override
  String get symptomCravings => 'Envies';

  @override
  String get symptomEnergyCrash => 'Coup de fatigue';

  @override
  String get symptomBloating => 'Ballonnements';

  @override
  String get symptomWeightChange => 'Variation de poids';

  @override
  String get symptomAnxiety => 'Anxiété';

  @override
  String get symptomMoodSwings => 'Sautes d\'humeur';

  @override
  String get symptomBrainFog => 'Brouillard mental';

  @override
  String get symptomLowMotivation => 'Peu de motivation';

  @override
  String get symptomSpotting => 'Saignements légers';

  @override
  String get symptomCramping => 'Crampes';

  @override
  String get symptomFlowHeavy => 'Flux abondant';

  @override
  String get symptomFlowLight => 'Flux léger';
}
