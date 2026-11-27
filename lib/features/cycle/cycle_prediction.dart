import '../../shared/models/cycle.dart';

class CyclePrediction {
  const CyclePrediction({
    required this.nextStart,
    required this.earliest,
    required this.latest,
    required this.cycleLength,
    required this.intervalCount,
    required this.confidence,
  });

  final DateTime nextStart;
  final DateTime earliest;
  final DateTime latest;
  final int cycleLength;
  final int intervalCount;
  final String confidence;

  static CyclePrediction? fromCycles(List<Cycle> cycles, {DateTime? today}) {
    final now = today ?? DateTime.now();
    final dates = cycles
        .map((cycle) => DateTime.tryParse(cycle.startDate))
        .whereType<DateTime>()
        .where((date) => !date.isAfter(DateTime(now.year, now.month, now.day)))
        .toSet()
        .toList()
      ..sort();
    if (dates.length < 2) return null;

    final intervals = <int>[];
    for (var i = 1; i < dates.length; i++) {
      final days = dates[i].difference(dates[i - 1]).inDays;
      if (days >= 15 && days <= 365) intervals.add(days);
    }
    if (intervals.isEmpty) return null;

    final recent = intervals.length > 6
        ? intervals.sublist(intervals.length - 6)
        : intervals;
    final sorted = [...recent]..sort();
    final length = sorted.length.isOdd
        ? sorted[sorted.length ~/ 2]
        : ((sorted[sorted.length ~/ 2 - 1] + sorted[sorted.length ~/ 2]) / 2)
            .round();
    final deviations = recent.map((days) => (days - length).abs()).toList()
      ..sort();
    final spread = recent.length < 2
        ? 7
        : deviations[deviations.length ~/ 2].clamp(2, 14).toInt();
    final next = dates.last.add(Duration(days: length));

    return CyclePrediction(
      nextStart: next,
      earliest: next.subtract(Duration(days: spread)),
      latest: next.add(Duration(days: spread)),
      cycleLength: length,
      intervalCount: recent.length,
      confidence: recent.length < 2
          ? 'early'
          : spread <= 5
              ? 'steadier'
              : 'variable',
    );
  }
}
