import 'package:flutter/material.dart';

import '../../core/theme/lunora_tokens.dart';
import '../../shared/models/cycle.dart';

class CycleCalendar extends StatelessWidget {
  const CycleCalendar({
    super.key,
    required this.month,
    required this.cycles,
    required this.likelyWindow,
    required this.hasAnyLog,
    required this.onTapDay,
    required this.onPrevMonth,
    required this.onNextMonth,
  });

  final DateTime month;
  final List<Cycle> cycles;
  final ({DateTime start, DateTime end})? likelyWindow;
  final bool Function(DateTime) hasAnyLog;
  final void Function(DateTime) onTapDay;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;

  static const _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  bool _inCycle(DateTime d) => cycles.any((c) => c.containsDate(d));

  bool _inOngoing(DateTime d) {
    for (final c in cycles) {
      if (c.isOngoing && c.containsDate(d)) return true;
    }
    return false;
  }

  bool _inBand(DateTime d) {
    final w = likelyWindow;
    if (w == null) return false;
    final x = DateTime(d.year, d.month, d.day);
    final s = DateTime(w.start.year, w.start.month, w.start.day);
    final e = DateTime(w.end.year, w.end.month, w.end.day);
    return !x.isBefore(s) && !x.isAfter(e);
  }

  @override
  Widget build(BuildContext context) {
    final first = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final leading = (first.weekday - 1) % 7;
    final today = DateTime.now();

    final cells = <Widget>[];
    for (var i = 0; i < leading; i++) {
      cells.add(const SizedBox.shrink());
    }
    for (var day = 1; day <= daysInMonth; day++) {
      final d = DateTime(month.year, month.month, day);
      final isFuture = d.isAfter(DateTime(today.year, today.month, today.day));
      final inBand = !isFuture && _inBand(d);
      final inCycle = _inCycle(d);
      final ongoing = _inOngoing(d);
      final hasLog = hasAnyLog(d);
      final isToday =
          d.year == today.year && d.month == today.month && d.day == today.day;

      Color? fill;
      if (inCycle) {
        fill = ongoing ? LunoraTokens.purpleSoft : LunoraTokens.pinkDeep;
      } else if (inBand) {
        fill = LunoraTokens.purpleSoft.withValues(alpha: 0.5);
      }

      cells.add(
        GestureDetector(
          onTap: () => onTapDay(d),
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: fill,
              borderRadius: BorderRadius.circular(10),
              border: isToday
                  ? Border.all(color: LunoraTokens.purple, width: 1.5)
                  : null,
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$day',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                    color:
                        inCycle && !ongoing ? Colors.white : LunoraTokens.ink,
                  ),
                ),
                if (hasLog)
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: inCycle && !ongoing
                          ? Colors.white
                          : LunoraTokens.pinkDeep,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LunoraTokens.card,
        borderRadius: BorderRadius.circular(LunoraTokens.radiusLg),
        border: Border.all(color: LunoraTokens.line),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onPrevMonth,
                icon: Icon(Icons.chevron_left, color: LunoraTokens.ink),
              ),
              Expanded(
                child: Text(
                  '${_monthNames[month.month - 1]} ${month.year}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: LunoraTokens.ink,
                  ),
                ),
              ),
              IconButton(
                onPressed: onNextMonth,
                icon: Icon(Icons.chevron_right, color: LunoraTokens.ink),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: const ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                .map((d) => Expanded(
                      child: Center(
                        child: Text(
                          d,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: LunoraTokens.inkSoft,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1,
            children: cells,
          ),
        ],
      ),
    );
  }
}
