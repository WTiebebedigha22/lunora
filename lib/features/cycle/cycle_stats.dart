import '../../shared/models/cycle.dart';

/// Descriptive statistics from COMPLETED cycles only.
/// Completed = has both a start and an end.
/// A "cycle length" is days between two consecutive start dates.
class CycleStats {
  CycleStats({
    required this.averageLength,
    required this.minLength,
    required this.maxLength,
    required this.completedCount,
    required this.lastStart,
    required this.currentOngoing,
  });

  final int averageLength;
  final int minLength;
  final int maxLength;
  final int completedCount;
  final DateTime? lastStart;
  final Cycle? currentOngoing;

  /// Compute stats from all cycles. Returns null if we do not have
  /// enough data to describe a range honestly.
  static CycleStats? compute(List<Cycle> cycles) {
    // Sort by startDate ascending.
    final sorted = [...cycles]
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    // Ongoing cycle = the latest one without an end.
    Cycle? ongoing;
    for (final c in sorted.reversed) {
      if (c.isOngoing) {
        ongoing = c;
        break;
      }
    }

    // Lengths = differences between consecutive start dates.
    final lengths = <int>[];
    for (var i = 1; i < sorted.length; i++) {
      final prev = DateTime.parse(sorted[i - 1].startDate);
      final cur = DateTime.parse(sorted[i].startDate);
      final days = cur.difference(prev).inDays;
      if (days > 0 && days < 365) lengths.add(days);
    }

    final lastStart =
        sorted.isNotEmpty ? DateTime.parse(sorted.last.startDate) : null;

    if (lengths.isEmpty) {
      // Not enough for a range. We still return a stub so the UI
      // can show lastStart + ongoing info without a band.
      return CycleStats(
        averageLength: 0,
        minLength: 0,
        maxLength: 0,
        completedCount: 0,
        lastStart: lastStart,
        currentOngoing: ongoing,
      );
    }

    final avg = (lengths.reduce((a, b) => a + b) / lengths.length).round();
    final min = lengths.reduce((a, b) => a < b ? a : b);
    final max = lengths.reduce((a, b) => a > b ? a : b);

    return CycleStats(
      averageLength: avg,
      minLength: min,
      maxLength: max,
      completedCount: lengths.length,
      lastStart: lastStart,
      currentOngoing: ongoing,
    );
  }

  /// Confidence band requires at least 2 completed cycle lengths.
  /// Returns null when we can't honestly show a range.
  ({DateTime start, DateTime end})? likelyWindow() {
    if (completedCount < 2) return null;
    if (lastStart == null) return null;

    final variance = ((maxLength - minLength) / 2).ceil().clamp(2, 5);
    final start = lastStart!.add(Duration(days: averageLength - variance));
    final end = lastStart!.add(Duration(days: averageLength + variance));
    return (start: start, end: end);
  }
}
