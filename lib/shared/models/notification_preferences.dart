class NotificationPreferences {
  const NotificationPreferences({
    this.periodReminder = false,
    this.dailyLogReminder = false,
    this.medicationReminder = false,
    this.moodCravingReminder = false,
    this.reminderHour = 20,
  });

  final bool periodReminder;
  final bool dailyLogReminder;
  final bool medicationReminder;
  final bool moodCravingReminder;
  final int reminderHour;

  bool get anyEnabled =>
      periodReminder ||
      dailyLogReminder ||
      medicationReminder ||
      moodCravingReminder;

  NotificationPreferences copyWith({
    bool? periodReminder,
    bool? dailyLogReminder,
    bool? medicationReminder,
    bool? moodCravingReminder,
    int? reminderHour,
  }) =>
      NotificationPreferences(
        periodReminder: periodReminder ?? this.periodReminder,
        dailyLogReminder: dailyLogReminder ?? this.dailyLogReminder,
        medicationReminder: medicationReminder ?? this.medicationReminder,
        moodCravingReminder: moodCravingReminder ?? this.moodCravingReminder,
        reminderHour: reminderHour ?? this.reminderHour,
      );

  Map<String, dynamic> toMap() => {
        'periodReminder': periodReminder,
        'dailyLogReminder': dailyLogReminder,
        'medicationReminder': medicationReminder,
        'moodCravingReminder': moodCravingReminder,
        'reminderHour': reminderHour,
      };

  factory NotificationPreferences.fromMap(Map<dynamic, dynamic> map) =>
      NotificationPreferences(
        periodReminder: map['periodReminder'] as bool? ?? false,
        dailyLogReminder: map['dailyLogReminder'] as bool? ?? false,
        medicationReminder: map['medicationReminder'] as bool? ?? false,
        moodCravingReminder: map['moodCravingReminder'] as bool? ?? false,
        reminderHour:
            ((map['reminderHour'] as num?)?.toInt() ?? 20).clamp(0, 23).toInt(),
      );
}
