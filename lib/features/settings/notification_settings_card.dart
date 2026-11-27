import 'package:material_ui/material_ui.dart';

import '../../core/notifications/lunora_notifications.dart';
import '../../core/theme/lunora_tokens.dart';
import '../../shared/models/notification_preferences.dart';

class NotificationSettingsCard extends StatefulWidget {
  const NotificationSettingsCard({
    super.key,
    required this.preferences,
    required this.onChanged,
  });

  final NotificationPreferences preferences;
  final Future<void> Function(NotificationPreferences) onChanged;

  @override
  State<NotificationSettingsCard> createState() =>
      _NotificationSettingsCardState();
}

class _NotificationSettingsCardState extends State<NotificationSettingsCard> {
  Future<void> _setPreference(NotificationPreferences next) async {
    if (!widget.preferences.anyEnabled && next.anyEnabled) {
      final allowed = await LunoraNotifications.requestPermission();
      if (!allowed) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Allow notifications in your device settings to turn on reminders.'),
            ),
          );
        }
        return;
      }
    }
    await widget.onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    if (!LunoraNotifications.supported) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: LunoraTokens.card,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          'Scheduled reminders are available on Android and iPhone.',
          style: TextStyle(color: LunoraTokens.inkSoft, height: 1.4),
        ),
      );
    }

    final prefs = widget.preferences;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: LunoraTokens.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: LunoraTokens.line),
      ),
      child: Column(
        children: [
          _toggle(
            title: 'Period heads-up',
            subtitle:
                'A reminder two days before your estimated date, when enough cycle history is logged.',
            value: prefs.periodReminder,
            onChanged: (value) =>
                _setPreference(prefs.copyWith(periodReminder: value)),
          ),
          _divider(),
          _toggle(
            title: 'Daily check-in',
            subtitle: 'A gentle reminder to log how you feel.',
            value: prefs.dailyLogReminder,
            onChanged: (value) =>
                _setPreference(prefs.copyWith(dailyLogReminder: value)),
          ),
          _divider(),
          _toggle(
            title: 'Medication check-in',
            subtitle:
                'A reminder to check your own medication plan. It does not give dosing advice.',
            value: prefs.medicationReminder,
            onChanged: (value) =>
                _setPreference(prefs.copyWith(medicationReminder: value)),
          ),
          _divider(),
          _toggle(
            title: 'Mood and cravings support',
            subtitle:
                'Optional gentle check-ins, with wording based on patterns you have logged.',
            value: prefs.moodCravingReminder,
            onChanged: (value) =>
                _setPreference(prefs.copyWith(moodCravingReminder: value)),
          ),
          if (prefs.dailyLogReminder || prefs.moodCravingReminder) ...[
            _divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text('Check-in time',
                        style:
                            TextStyle(fontSize: 14, color: LunoraTokens.ink)),
                  ),
                  DropdownButton<int>(
                    value: prefs.reminderHour,
                    underline: const SizedBox.shrink(),
                    borderRadius: BorderRadius.circular(14),
                    items: const [7, 9, 12, 18, 20, 21]
                        .map((hour) => DropdownMenuItem(
                              value: hour,
                              child: Text(_hourLabel(hour)),
                            ))
                        .toList(),
                    onChanged: (hour) {
                      if (hour != null) {
                        _setPreference(prefs.copyWith(reminderHour: hour));
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _toggle({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile.adaptive(
      value: value,
      onChanged: onChanged,
      activeTrackColor: LunoraTokens.purple,
      title: Text(title,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: LunoraTokens.ink)),
      subtitle: Text(subtitle,
          style: TextStyle(
              fontSize: 11.5, height: 1.35, color: LunoraTokens.inkSoft)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
    );
  }

  Widget _divider() =>
      Divider(height: 1, indent: 16, endIndent: 16, color: LunoraTokens.line);

  static String _hourLabel(int hour) {
    final suffix = hour < 12 ? 'AM' : 'PM';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;
    return '$displayHour:00 $suffix';
  }
}
