import '../../shared/models/cycle.dart';
import '../../shared/models/day_log.dart';
import 'cycle_prediction.dart';

/// Personal pattern summaries from logs recorded at comparable cycle days.
/// Predictions are withheld until the same window is represented in at least
/// two previous cycles.
class PersonalizedOutlook {
  PersonalizedOutlook({required this.prediction, required this.days});

  final CyclePrediction? prediction;
  final List<OutlookDay> days;

  factory PersonalizedOutlook.fromHistory({
    required List<Cycle> cycles,
    required Map<String, DayLog> logs,
    DateTime? today,
  }) {
    final now = today ?? DateTime.now();
    final todayDate = DateTime(now.year, now.month, now.day);
    final starts = cycles
        .map((cycle) => DateTime.tryParse(cycle.startDate))
        .whereType<DateTime>()
        .where((date) => !date.isAfter(todayDate))
        .toSet()
        .toList()
      ..sort();
    final prediction = CyclePrediction.fromCycles(cycles, today: todayDate);
    if (starts.isEmpty) {
      return PersonalizedOutlook(prediction: prediction, days: const []);
    }

    final currentStart = starts.last;
    final days = <OutlookDay>[];
    for (var offset = 0; offset < 7; offset++) {
      final date = todayDate.add(Duration(days: offset));
      final cycleDay = date.difference(currentStart).inDays + 1;
      final matchingCycles = <String, List<DayLog>>{};
      for (var i = 0; i < starts.length - 1; i++) {
        final priorStart = starts[i];
        final nextStart = starts[i + 1];
        final target = priorStart.add(Duration(days: cycleDay - 1));
        if (!target.isBefore(nextStart)) continue;
        final window = <DayLog>[];
        for (var delta = -1; delta <= 1; delta++) {
          final key = _format(target.add(Duration(days: delta)));
          final log = logs[key];
          if (log != null && !log.isEmpty) window.add(log);
        }
        if (window.isNotEmpty) matchingCycles[_format(priorStart)] = window;
      }

      final counts = <String, int>{};
      final moodCounts = <String, int>{};
      for (final entry in matchingCycles.entries) {
        final symptoms = entry.value.expand((log) => log.symptoms).toSet();
        for (final symptom in symptoms) {
          counts.update(symptom, (value) => value + 1, ifAbsent: () => 1);
        }
        final moods = entry.value
            .map((log) => log.mood)
            .where((mood) => mood.isNotEmpty)
            .toSet();
        for (final mood in moods) {
          moodCounts.update(mood, (value) => value + 1, ifAbsent: () => 1);
        }
      }
      final signals = <String>[];
      if (matchingCycles.length >= 2) {
        for (final item in counts.entries) {
          if (item.value >= 2) signals.add(item.key.replaceAll('_', ' '));
        }
        for (final item in moodCounts.entries) {
          if (item.value >= 2) signals.add('${item.key} mood');
        }
      }
      days.add(OutlookDay(
        date: date,
        cycleDay: cycleDay,
        comparableCycles: matchingCycles.length,
        patterns: signals,
      ));
    }
    return PersonalizedOutlook(prediction: prediction, days: days);
  }

  static String _format(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}

class OutlookDay {
  const OutlookDay({
    required this.date,
    required this.cycleDay,
    required this.comparableCycles,
    required this.patterns,
  });

  final DateTime date;
  final int cycleDay;
  final int comparableCycles;
  final List<String> patterns;
}
