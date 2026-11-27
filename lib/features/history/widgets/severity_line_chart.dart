import 'package:fl_chart/fl_chart.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/theme/lunora_tokens.dart';
import '../../../shared/models/day_log.dart';

class SeverityLineChart extends StatelessWidget {
  const SeverityLineChart({super.key, required this.logs});
  final List<MapEntry<String, DayLog>> logs;

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return _card(
        title: 'SEVERITY',
        child: Text(
          'No logs in this window.',
          style: TextStyle(color: LunoraTokens.inkSoft, fontSize: 13),
        ),
      );
    }

    final spots = <FlSpot>[];
    for (var i = 0; i < logs.length; i++) {
      final log = logs[i].value;
      final hasMeaningfulLog =
          log.symptoms.isNotEmpty || log.notes.trim().isNotEmpty;
      if (!hasMeaningfulLog) continue;
      spots.add(FlSpot(i.toDouble(), log.severity.toDouble()));
    }

    if (spots.isEmpty) {
      return _card(
        title: 'SEVERITY',
        child: Text(
          'No severity recorded in this window.',
          style: TextStyle(color: LunoraTokens.inkSoft, fontSize: 13),
        ),
      );
    }

    return _card(
      title: 'SEVERITY OVER TIME',
      child: SizedBox(
        height: 160,
        child: LineChart(
          LineChartData(
            minY: 0,
            maxY: 5,
            minX: 0,
            maxX: (logs.length - 1).toDouble().clamp(1, 999),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 1,
              getDrawingHorizontalLine: (_) => FlLine(
                color: LunoraTokens.line,
                strokeWidth: 1,
              ),
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 22,
                  interval: 1,
                  getTitlesWidget: (value, meta) => Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Text(
                      value.toInt().toString(),
                      style: TextStyle(
                        fontSize: 10,
                        color: LunoraTokens.inkSoft,
                      ),
                    ),
                  ),
                ),
              ),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: LunoraTokens.blueDeep,
                barWidth: 2,
                dotData: const FlDotData(show: true),
                belowBarData: BarAreaData(
                  show: true,
                  color: LunoraTokens.blue.withValues(alpha: 0.2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card({required String title, required Widget child}) {
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
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
              color: LunoraTokens.inkSoft,
            ),
          ),
          SizedBox(height: LunoraTokens.spaceMd),
          child,
        ],
      ),
    );
  }
}
