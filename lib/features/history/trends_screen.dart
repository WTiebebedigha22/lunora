import 'package:flutter/material.dart';

import '../../core/theme/lunora_tokens.dart';
import '../../shared/models/lunora_state.dart';
import 'widgets/symptom_bar_chart.dart';
import 'widgets/severity_line_chart.dart';
import 'widgets/adherence_bars.dart';

class TrendsScreen extends StatefulWidget {
  const TrendsScreen({super.key, required this.state});
  final LunoraState state;

  @override
  State<TrendsScreen> createState() => _TrendsScreenState();
}

class _TrendsScreenState extends State<TrendsScreen> {
  int _window = 30;

  DateTime get _cutoff => DateTime.now().subtract(Duration(days: _window));

  bool _inWindow(String dateKey) {
    final d = DateTime.tryParse(dateKey);
    if (d == null) return false;
    return d.isAfter(_cutoff) || d.isAtSameMomentAs(_cutoff);
  }

  @override
  Widget build(BuildContext context) {
    final windowLogs = widget.state.logs.entries
        .where((e) => _inWindow(e.key) && !e.value.isEmpty)
        .toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    // Count symptoms across window.
    final counts = <String, int>{};
    for (final e in windowLogs) {
      for (final s in e.value.symptoms) {
        counts[s] = (counts[s] ?? 0) + 1;
      }
    }

    return ListView(
      padding: EdgeInsets.all(LunoraTokens.spaceLg),
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Trends',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            _windowPill(30),
            const SizedBox(width: 6),
            _windowPill(90),
            const SizedBox(width: 6),
            _windowPill(180),
          ],
        ),
        SizedBox(height: LunoraTokens.spaceXs),
        Text(
          'Descriptive only. No predictions, no interpretations.',
          style: TextStyle(
            fontSize: 12,
            color: LunoraTokens.inkSoft,
          ),
        ),
        SizedBox(height: LunoraTokens.spaceLg),
        if (windowLogs.length < 3)
          _emptyState()
        else ...[
          SymptomBarChart(counts: counts),
          SizedBox(height: LunoraTokens.spaceMd),
          SeverityLineChart(logs: windowLogs),
          SizedBox(height: LunoraTokens.spaceMd),
          AdherenceBars(
            state: widget.state,
            windowDays: _window,
            windowLogs: windowLogs,
          ),
        ],
      ],
    );
  }

  Widget _windowPill(int days) {
    final active = _window == days;
    return GestureDetector(
      onTap: () => setState(() => _window = days),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: active ? LunoraTokens.lavenderDeep : LunoraTokens.lavender,
          borderRadius: BorderRadius.circular(LunoraTokens.radiusPill),
        ),
        child: Text(
          '${days}d',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: active ? Colors.white : LunoraTokens.ink,
          ),
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Container(
      padding: EdgeInsets.all(LunoraTokens.spaceLg),
      decoration: BoxDecoration(
        color: LunoraTokens.card,
        borderRadius: BorderRadius.circular(LunoraTokens.radiusLg),
        border: Border.all(color: LunoraTokens.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Not enough data yet',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 6),
          Text(
            'Log a few more days to see trends here. '
            'We need at least 3 logged days in the window.',
            style: TextStyle(
              fontSize: 13,
              color: LunoraTokens.inkSoft,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
