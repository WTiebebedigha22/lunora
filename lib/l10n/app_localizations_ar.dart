// ignore_for_file: deprecated_member_use

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'لونورا';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navCycle => 'الدورة';

  @override
  String get navHistory => 'السجل';

  @override
  String get navInsights => 'مقالات';

  @override
  String get navSettings => 'الإعدادات';

  @override
  String get greetingMorning => 'صباح الخير';

  @override
  String get greetingAfternoon => 'مساء الخير';

  @override
  String get greetingEvening => 'مساء الخير';

  @override
  String get todayLabel => 'اليوم';

  @override
  String get dailyLogEyebrow => 'السجل اليومي';

  @override
  String get loggedToday => 'سجلتِ اليوم';

  @override
  String get howFeeling => 'كيف تشعرين؟';

  @override
  String get logSymptoms => 'تسجيل الأعراض';

  @override
  String get updateLog => 'تحديث السجل';

  @override
  String get medicationEyebrow => 'الأدوية';

  @override
  String get noMedsYet => 'لا توجد أدوية بعد';

  @override
  String get addMedication => 'إضافة دواء';

  @override
  String get manageMedications => 'إدارة الأدوية';

  @override
  String medsTakenOf(int taken, int total) {
    return '$taken من $total تم تناولها';
  }

  @override
  String get cycleEyebrow => 'الدورة';

  @override
  String get noCycleData => 'لا توجد بيانات بعد';

  @override
  String get cycleInProgress => 'دورة جارية';

  @override
  String cycleAverageDays(int days) {
    return 'متوسط $days يوم';
  }

  @override
  String cycleRangeDays(int min, int max) {
    return 'النطاق $min–$max يوم';
  }

  @override
  String get irregularityExpected => 'عدم الانتظام أمر متوقع.';

  @override
  String get logPeriod => 'تسجيل الدورة';

  @override
  String get markPeriodStart => 'تحديد بداية الدورة';

  @override
  String get markPeriodEnd => 'تحديد نهاية الدورة';

  @override
  String get removeCycleStart => 'إزالة بداية الدورة';

  @override
  String get removeCycleEnd => 'إزالة نهاية الدورة';

  @override
  String get noCycleAction => 'لا يوجد إجراء متاح في هذا اليوم.';

  @override
  String get severityLabel => 'الشدة العامة';

  @override
  String get severityVeryMild => 'خفيفة جداً';

  @override
  String get severityMild => 'خفيفة';

  @override
  String get severityModerate => 'متوسطة';

  @override
  String get severitySevere => 'شديدة';

  @override
  String get severityVerySevere => 'شديدة جداً';

  @override
  String get symptomsTitle => 'الأعراض';

  @override
  String get symptomsPrompt => 'اختاري كل ما ينطبق';

  @override
  String get notesOptional => 'ملاحظات (اختياري)';

  @override
  String get notesHint => 'أي شيء تريدين تذكره…';

  @override
  String get saveLog => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get close => 'إغلاق';

  @override
  String get next => 'التالي';

  @override
  String get historyTitle => 'السجل';

  @override
  String get logSegment => 'السجل';

  @override
  String get trendsSegment => 'الاتجاهات';

  @override
  String get noLogsYet => 'لا توجد سجلات بعد';

  @override
  String get noLogsBody => 'اضغطي \"تسجيل الأعراض\" في الرئيسية للبدء.';

  @override
  String get topSymptoms => 'الأعراض الأكثر تكراراً';

  @override
  String get trendsTitle => 'الاتجاهات';

  @override
  String get trendsSubtitle => 'وصفي فقط. لا تنبؤات ولا تفسيرات.';

  @override
  String get notEnoughData => 'لا توجد بيانات كافية بعد';

  @override
  String get notEnoughDataBody => 'سجلي أياماً أكثر لعرض الاتجاهات هنا.';

  @override
  String get insightsTitle => 'مقالات';

  @override
  String get savedTab => 'المحفوظات';

  @override
  String get allTab => 'الكل';

  @override
  String get searchHint => 'بحث';

  @override
  String get readMore => 'اقرئي المزيد';

  @override
  String minRead(int n) {
    return 'قراءة $n دقيقة';
  }

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get appearanceSection => 'المظهر';

  @override
  String get themeModeLabel => 'السمة';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get themeSystem => 'النظام';

  @override
  String get colorSchemeLabel => 'اللون';

  @override
  String get schemePurple => 'بنفسجي';

  @override
  String get schemePink => 'وردي';

  @override
  String get schemeBlue => 'أزرق';

  @override
  String get schemeRed => 'أحمر';

  @override
  String get languageLabel => 'اللغة';

  @override
  String get languageSystem => 'النظام';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageArabic => 'العربية';

  @override
  String get doctorReportsSection => 'التقارير الطبية';

  @override
  String get doctorReportsTitle => 'ملخص لموعدك القادم';

  @override
  String get doctorReportsBody =>
      'الدورات والأعراض والالتزام والأدوية. وصفي فقط.';

  @override
  String get preview => 'معاينة';

  @override
  String get exportPdf => 'تصدير PDF';

  @override
  String get working => 'جارٍ العمل…';

  @override
  String get dataSection => 'البيانات';

  @override
  String get loadDemoData => 'تحميل بيانات تجريبية';

  @override
  String get loadDemoSubtitle => 'اختبار بأنماط واقعية';

  @override
  String get rerunOnboarding => 'إعادة التعريف';

  @override
  String get rerunSubtitle => 'يحتفظ بالسجلات والأدوية';

  @override
  String get clearAllData => 'حذف جميع البيانات';

  @override
  String get clearAllSubtitle => 'يمسح كل شيء. لا يمكن التراجع.';

  @override
  String get medicalDisclaimer =>
      'لونورا أداة تتبع وليست جهازاً طبياً. لا تشخص ولا تعالج تكيس المبايض. استشيري طبيبتك دائماً.';

  @override
  String get onboardingWelcomeTitle => 'مرحباً في لونورا';

  @override
  String get onboardingWelcomeBody =>
      'رفيق صحي يركز على تكيس المبايض. ليس مجرد متتبع دورة.';

  @override
  String get onboardingGoalTitle => 'ما الذي أتى بك؟';

  @override
  String get onboardingGoalBody => 'اختاري الأهم الآن.';

  @override
  String get onboardingConsentTitle => 'تنبيه لطيف';

  @override
  String get onboardingConsentCheck => 'أفهم أن لونورا ليست جهازاً طبياً.';

  @override
  String get continueButton => 'متابعة';

  @override
  String get continueFree => 'المتابعة مجاناً — دائماً';

  @override
  String get skip => 'تخطي';

  @override
  String get startUsing => 'ابدئي استخدام لونورا';

  @override
  String get save => 'حفظ';

  @override
  String get delete => 'حذف';

  @override
  String get remove => 'إزالة';

  @override
  String get done => 'تم';

  @override
  String get symptomHormonal => 'هرموني';

  @override
  String get symptomMetabolic => 'أيضي';

  @override
  String get symptomMental => 'نفسي';

  @override
  String get symptomCycle => 'الدورة';

  @override
  String get symptomAcne => 'حب الشباب';

  @override
  String get symptomHirsutism => 'شعر زائد';

  @override
  String get symptomHairThinning => 'تساقط الشعر';

  @override
  String get symptomSkinDarkening => 'اسمرار البشرة';

  @override
  String get symptomCravings => 'شهية';

  @override
  String get symptomEnergyCrash => 'انخفاض الطاقة';

  @override
  String get symptomBloating => 'انتفاخ';

  @override
  String get symptomWeightChange => 'تغير الوزن';

  @override
  String get symptomAnxiety => 'قلق';

  @override
  String get symptomMoodSwings => 'تقلبات المزاج';

  @override
  String get symptomBrainFog => 'ضباب ذهني';

  @override
  String get symptomLowMotivation => 'قلة الحافز';

  @override
  String get symptomSpotting => 'تنقيط';

  @override
  String get symptomCramping => 'تقلصات';

  @override
  String get symptomFlowHeavy => 'نزيف غزير';

  @override
  String get symptomFlowLight => 'نزيف خفيف';
}
