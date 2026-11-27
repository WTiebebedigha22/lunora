import 'cycle.dart';
import 'day_log.dart';
import 'medication.dart';
import 'theme_preferences.dart';
import 'notification_preferences.dart';

class EducationProgress {
  EducationProgress({
    List<String>? readIds,
    List<String>? dismissedIds,
    List<String>? savedIds,
  })  : readIds = readIds ?? const [],
        dismissedIds = dismissedIds ?? const [],
        savedIds = savedIds ?? const [];

  final List<String> readIds;
  final List<String> dismissedIds;
  final List<String> savedIds;

  bool isDismissed(String id) => dismissedIds.contains(id);
  bool isRead(String id) => readIds.contains(id);
  bool isSaved(String id) => savedIds.contains(id);

  EducationProgress copyWith({
    List<String>? readIds,
    List<String>? dismissedIds,
    List<String>? savedIds,
  }) {
    return EducationProgress(
      readIds: readIds ?? this.readIds,
      dismissedIds: dismissedIds ?? this.dismissedIds,
      savedIds: savedIds ?? this.savedIds,
    );
  }

  Map<String, dynamic> toMap() => {
        'readIds': readIds,
        'dismissedIds': dismissedIds,
        'savedIds': savedIds,
      };

  factory EducationProgress.fromMap(Map<dynamic, dynamic> m) {
    return EducationProgress(
      readIds: List<String>.from((m['readIds'] as List?) ?? const []),
      dismissedIds: List<String>.from((m['dismissedIds'] as List?) ?? const []),
      savedIds: List<String>.from((m['savedIds'] as List?) ?? const []),
    );
  }
}

class LunoraState {
  LunoraState({
    this.onboarding,
    Map<String, DayLog>? logs,
    List<Medication>? meds,
    List<Cycle>? cycles,
    EducationProgress? education,
    ThemePreferences? theme,
    NotificationPreferences? notifications,
  })  : logs = logs ?? {},
        meds = meds ?? [],
        cycles = cycles ?? [],
        education = education ?? EducationProgress(),
        theme = theme ?? ThemePreferences(),
        notifications = notifications ?? const NotificationPreferences();

  final OnboardingProfile? onboarding;
  final Map<String, DayLog> logs;
  final List<Medication> meds;
  final List<Cycle> cycles;
  final EducationProgress education;
  final ThemePreferences theme;
  final NotificationPreferences notifications;

  static LunoraState empty() => LunoraState();

  bool get isOnboarded => onboarding != null;

  LunoraState copyWith({
    OnboardingProfile? onboarding,
    Map<String, DayLog>? logs,
    List<Medication>? meds,
    List<Cycle>? cycles,
    EducationProgress? education,
    ThemePreferences? theme,
    NotificationPreferences? notifications,
  }) {
    return LunoraState(
      onboarding: onboarding ?? this.onboarding,
      logs: logs ?? this.logs,
      meds: meds ?? this.meds,
      cycles: cycles ?? this.cycles,
      education: education ?? this.education,
      theme: theme ?? this.theme,
      notifications: notifications ?? this.notifications,
    );
  }

  Map<String, dynamic> toMap() => {
        'onboarding': onboarding?.toMap(),
        'logs': logs.map((k, v) => MapEntry(k, v.toMap())),
        'meds': meds.map((m) => m.toMap()).toList(),
        'cycles': cycles.map((c) => c.toMap()).toList(),
        'education': education.toMap(),
        'theme': theme.toMap(),
        'notifications': notifications.toMap(),
      };

  factory LunoraState.fromMap(Map<dynamic, dynamic> m) {
    final rawLogs = (m['logs'] as Map?) ?? {};
    final rawMeds = (m['meds'] as List?) ?? [];
    final rawCycles = (m['cycles'] as List?) ?? [];
    return LunoraState(
      onboarding: m['onboarding'] == null
          ? null
          : OnboardingProfile.fromMap(
              Map<dynamic, dynamic>.from(m['onboarding'] as Map)),
      logs: rawLogs.map(
        (k, v) => MapEntry(
          k as String,
          DayLog.fromMap(Map<dynamic, dynamic>.from(v as Map)),
        ),
      ),
      meds: rawMeds
          .map((e) => Medication.fromMap(Map<dynamic, dynamic>.from(e as Map)))
          .toList(),
      cycles: rawCycles
          .map((e) => Cycle.fromMap(Map<dynamic, dynamic>.from(e as Map)))
          .toList(),
      education: m['education'] == null
          ? EducationProgress()
          : EducationProgress.fromMap(
              Map<dynamic, dynamic>.from(m['education'] as Map)),
      theme: m['theme'] == null
          ? ThemePreferences()
          : ThemePreferences.fromMap(
              Map<dynamic, dynamic>.from(m['theme'] as Map)),
      notifications: m['notifications'] == null
          ? const NotificationPreferences()
          : NotificationPreferences.fromMap(
              Map<dynamic, dynamic>.from(m['notifications'] as Map)),
    );
  }
}

class OnboardingProfile {
  OnboardingProfile({
    required this.goal,
    this.lastPeriod,
    int avatar = 0,
    List<String>? priorities,
    int? onboardedAt,
  })  : _avatar = avatar,
        priorities = priorities ?? const [],
        onboardedAt = onboardedAt ?? DateTime.now().millisecondsSinceEpoch;

  final String goal;
  final String? lastPeriod;
  // Nullable backing storage keeps pre-avatar instances safe across hot reload.
  final int? _avatar;
  int get avatar => _avatar ?? 0;
  final List<String> priorities;
  final int onboardedAt;

  Map<String, dynamic> toMap() => {
        'goal': goal,
        'lastPeriod': lastPeriod,
        'avatar': avatar,
        'priorities': priorities,
        'onboardedAt': onboardedAt,
      };

  factory OnboardingProfile.fromMap(Map<dynamic, dynamic> m) {
    return OnboardingProfile(
      goal: (m['goal'] as String?) ?? 'symptoms',
      lastPeriod: m['lastPeriod'] as String?,
      avatar: (m['avatar'] as num?)?.toInt() ?? 0,
      priorities: List<String>.from((m['priorities'] as List?) ?? const []),
      onboardedAt: (m['onboardedAt'] as num?)?.toInt() ?? 0,
    );
  }
}
