// ignore_for_file: deprecated_member_use

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Lunora';

  @override
  String get navHome => 'Inicio';

  @override
  String get navCycle => 'Ciclo';

  @override
  String get navHistory => 'Historial';

  @override
  String get navInsights => 'Artículos';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get greetingMorning => 'Buenos días';

  @override
  String get greetingAfternoon => 'Buenas tardes';

  @override
  String get greetingEvening => 'Buenas noches';

  @override
  String get todayLabel => 'Hoy';

  @override
  String get dailyLogEyebrow => 'REGISTRO DIARIO';

  @override
  String get loggedToday => 'Ya registraste hoy';

  @override
  String get howFeeling => '¿Cómo te sientes?';

  @override
  String get logSymptoms => 'Registrar síntomas';

  @override
  String get updateLog => 'Actualizar registro';

  @override
  String get medicationEyebrow => 'MEDICACIÓN';

  @override
  String get noMedsYet => 'Sin medicamentos aún';

  @override
  String get addMedication => 'Añadir medicamento';

  @override
  String get manageMedications => 'Gestionar medicamentos';

  @override
  String medsTakenOf(int taken, int total) {
    return '$taken de $total tomados';
  }

  @override
  String get cycleEyebrow => 'CICLO';

  @override
  String get noCycleData => 'Aún sin datos de ciclo';

  @override
  String get cycleInProgress => 'Ciclo en curso';

  @override
  String cycleAverageDays(int days) {
    return 'Promedio de $days días';
  }

  @override
  String cycleRangeDays(int min, int max) {
    return 'Rango $min–$max días';
  }

  @override
  String get irregularityExpected => 'La irregularidad es esperada.';

  @override
  String get logPeriod => 'Registrar período';

  @override
  String get markPeriodStart => 'Marcar inicio del período';

  @override
  String get markPeriodEnd => 'Marcar fin del período';

  @override
  String get removeCycleStart => 'Eliminar este inicio';

  @override
  String get removeCycleEnd => 'Eliminar este fin';

  @override
  String get noCycleAction => 'Sin acción disponible para este día.';

  @override
  String get severityLabel => 'Intensidad general';

  @override
  String get severityVeryMild => 'Muy leve';

  @override
  String get severityMild => 'Leve';

  @override
  String get severityModerate => 'Moderada';

  @override
  String get severitySevere => 'Grave';

  @override
  String get severityVerySevere => 'Muy grave';

  @override
  String get symptomsTitle => 'Síntomas';

  @override
  String get symptomsPrompt => 'Toca todo lo que aplique';

  @override
  String get notesOptional => 'Notas (opcional)';

  @override
  String get notesHint => 'Algo que quieras recordar…';

  @override
  String get saveLog => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get close => 'Cerrar';

  @override
  String get next => 'Siguiente';

  @override
  String get historyTitle => 'Historial';

  @override
  String get logSegment => 'Registro';

  @override
  String get trendsSegment => 'Tendencias';

  @override
  String get noLogsYet => 'Sin registros aún';

  @override
  String get noLogsBody =>
      'Toca \"Registrar síntomas\" en Inicio para empezar.';

  @override
  String get topSymptoms => 'SÍNTOMAS MÁS FRECUENTES';

  @override
  String get trendsTitle => 'Tendencias';

  @override
  String get trendsSubtitle =>
      'Solo descriptivo. Sin predicciones ni interpretaciones.';

  @override
  String get notEnoughData => 'Aún no hay suficientes datos';

  @override
  String get notEnoughDataBody =>
      'Registra algunos días más para ver tendencias aquí.';

  @override
  String get insightsTitle => 'Artículos';

  @override
  String get savedTab => 'Guardados';

  @override
  String get allTab => 'Todos';

  @override
  String get searchHint => 'Buscar';

  @override
  String get readMore => 'Leer más';

  @override
  String minRead(int n) {
    return '$n min de lectura';
  }

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get appearanceSection => 'APARIENCIA';

  @override
  String get themeModeLabel => 'Tema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get colorSchemeLabel => 'Color';

  @override
  String get schemePurple => 'Morado';

  @override
  String get schemePink => 'Rosa';

  @override
  String get schemeBlue => 'Azul';

  @override
  String get schemeRed => 'Rojo';

  @override
  String get languageLabel => 'Idioma';

  @override
  String get languageSystem => 'Sistema';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageArabic => 'العربية';

  @override
  String get doctorReportsSection => 'INFORMES MÉDICOS';

  @override
  String get doctorReportsTitle => 'Resumen para tu próxima cita';

  @override
  String get doctorReportsBody =>
      'Ciclos, síntomas principales, adherencia y registro diario. Solo descriptivo.';

  @override
  String get preview => 'Vista previa';

  @override
  String get exportPdf => 'Exportar PDF';

  @override
  String get working => 'Procesando…';

  @override
  String get dataSection => 'DATOS';

  @override
  String get loadDemoData => 'Cargar datos de prueba';

  @override
  String get loadDemoSubtitle => 'Probar con patrones realistas de SOP';

  @override
  String get rerunOnboarding => 'Repetir introducción';

  @override
  String get rerunSubtitle => 'Conserva tus registros y medicamentos';

  @override
  String get clearAllData => 'Borrar todos los datos';

  @override
  String get clearAllSubtitle => 'Elimina todo. No se puede deshacer.';

  @override
  String get medicalDisclaimer =>
      'Lunora es una herramienta de seguimiento, no un dispositivo médico. No diagnostica ni trata el SOP. Consulta siempre con tu profesional de salud.';

  @override
  String get onboardingWelcomeTitle => 'Bienvenida a Lunora';

  @override
  String get onboardingWelcomeBody =>
      'Una app de bienestar centrada en el SOP. No es un simple registro menstrual.';

  @override
  String get onboardingGoalTitle => '¿Qué te trae aquí?';

  @override
  String get onboardingGoalBody => 'Elige lo que más importa ahora.';

  @override
  String get onboardingConsentTitle => 'Un aviso importante';

  @override
  String get onboardingConsentCheck =>
      'Entiendo que Lunora no es un dispositivo médico.';

  @override
  String get continueButton => 'Continuar';

  @override
  String get continueFree => 'Continuar gratis — siempre';

  @override
  String get skip => 'Saltar';

  @override
  String get startUsing => 'Comenzar con Lunora';

  @override
  String get save => 'Guardar';

  @override
  String get delete => 'Eliminar';

  @override
  String get remove => 'Quitar';

  @override
  String get done => 'Hecho';

  @override
  String get symptomHormonal => 'Hormonal';

  @override
  String get symptomMetabolic => 'Metabólico';

  @override
  String get symptomMental => 'Mental';

  @override
  String get symptomCycle => 'Ciclo';

  @override
  String get symptomAcne => 'Acné';

  @override
  String get symptomHirsutism => 'Vello excesivo';

  @override
  String get symptomHairThinning => 'Caída del cabello';

  @override
  String get symptomSkinDarkening => 'Oscurecimiento de piel';

  @override
  String get symptomCravings => 'Antojos';

  @override
  String get symptomEnergyCrash => 'Bajón de energía';

  @override
  String get symptomBloating => 'Hinchazón';

  @override
  String get symptomWeightChange => 'Cambio de peso';

  @override
  String get symptomAnxiety => 'Ansiedad';

  @override
  String get symptomMoodSwings => 'Cambios de humor';

  @override
  String get symptomBrainFog => 'Niebla mental';

  @override
  String get symptomLowMotivation => 'Poca motivación';

  @override
  String get symptomSpotting => 'Manchado';

  @override
  String get symptomCramping => 'Calambres';

  @override
  String get symptomFlowHeavy => 'Flujo abundante';

  @override
  String get symptomFlowLight => 'Flujo ligero';
}
