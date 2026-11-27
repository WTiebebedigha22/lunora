import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../../features/cycle/cycle_prediction.dart';
import '../../shared/models/lunora_state.dart';

class LunoraNotifications {
  LunoraNotifications._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static const _periodId = 3101;
  static const _dailyId = 3102;
  static const _medicationId = 3103;

  static bool get supported =>
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  static Future<void> initialize() async {
    if (_initialized || !supported) return;
    tz_data.initializeTimeZones();
    final localZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localZone.identifier));

    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );
    await _plugin.initialize(settings);
    _initialized = true;
  }

  static Future<bool> requestPermission() async {
    await initialize();
    if (!supported) return false;
    if (defaultTargetPlatform == TargetPlatform.android) {
      return await _plugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.requestNotificationsPermission() ??
          false;
    }
    return await _plugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(alert: true, badge: false, sound: true) ??
        false;
  }

  static Future<void> refresh(LunoraState state) async {
    await initialize();
    if (!supported || !_initialized) return;

    final prefs = state.notifications;
    await _plugin.cancel(_periodId);
    await _plugin.cancel(_dailyId);
    await _plugin.cancel(_medicationId);
    if (!prefs.anyEnabled) return;

    const androidDetails = AndroidNotificationDetails(
      'lunora_reminders',
      'Lunora reminders',
      channelDescription:
          'Optional cycle, medication and daily check-in reminders.',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );
    const details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(presentAlert: true, presentSound: true),
    );

    if (prefs.periodReminder) {
      final prediction = CyclePrediction.fromCycles(state.cycles);
      if (prediction != null) {
        final reminderDate = DateTime(
          prediction.nextStart.year,
          prediction.nextStart.month,
          prediction.nextStart.day,
        ).subtract(const Duration(days: 2));
        final scheduled = tz.TZDateTime(
          tz.local,
          reminderDate.year,
          reminderDate.month,
          reminderDate.day,
          9,
        );
        if (scheduled.isAfter(tz.TZDateTime.now(tz.local))) {
          await _plugin.zonedSchedule(
            _periodId,
            'A cycle heads-up',
            'Your period may be approaching. Timing can vary; update your tracker when it starts.',
            scheduled,
            details,
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          );
        }
      }
    }

    if (prefs.dailyLogReminder || prefs.moodCravingReminder) {
      final body = _checkInBody(state, prefs.moodCravingReminder);
      await _plugin.zonedSchedule(
        _dailyId,
        'A gentle check-in',
        body,
        _nextTime(prefs.reminderHour),
        details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }

    if (prefs.medicationReminder && state.meds.isNotEmpty) {
      await _plugin.zonedSchedule(
        _medicationId,
        'Medication check-in',
        'If you have a dose scheduled today, you can record it in Lunora.',
        _nextTime(9),
        details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  static tz.TZDateTime _nextTime(int hour) {
    final now = tz.TZDateTime.now(tz.local);
    var next = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour);
    if (!next.isAfter(now)) next = next.add(const Duration(days: 1));
    return next;
  }

  static String _checkInBody(LunoraState state, bool mentionPatterns) {
    if (mentionPatterns) {
      final recentLogs = state.logs.entries.toList()
        ..sort((a, b) => b.key.compareTo(a.key));
      final recent = recentLogs.take(7).map((entry) => entry.value);
      final cravingLogs =
          recent.where((log) => log.symptoms.contains('cravings')).length;
      final difficultMoodLogs = recent
          .where(
              (log) => const {'low', 'anxious', 'stressed'}.contains(log.mood))
          .length;
      if (cravingLogs >= 2) {
        return 'You have logged cravings more than once lately. If useful, check in with how you are feeling today.';
      }
      if (difficultMoodLogs >= 2) {
        return 'You have logged a few difficult-feeling days lately. Consider a gentle check-in or reaching out to someone you trust.';
      }
    }
    return 'Take a moment to log symptoms, mood or anything you want to remember.';
  }
}
