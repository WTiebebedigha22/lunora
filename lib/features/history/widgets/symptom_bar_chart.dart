import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/lunora_tokens.dart';
import '../../../shared/models/symptom_catalog.dart';

import 'package:lunora/l10n/app_localizations.dart';
class SymptomBarChart extends StatelessWidget {
  const SymptomBarChart({super.key, required this.counts});
  final Map<String, int> counts;

  @override
  Widget build(BuildContext context) {
    final l10n = LunoraLocalizations.of(context)!;

    final top = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final shown = top.take(5).toList();

    if (shown.isEmpty) {
      return _card(
        title: 'TOP SYMPTOMS',
        child: Text(
          'No symptoms logged in this window.',
          style: TextStyle(color: LunoraTokens.inkSoft, fontSize: 13),
        ),
      );
    }

    final maxY = shown.first.value.toDouble() * 1.2;

    return _card(
      title: 'TOP SYMPTOMS',
      child: SizedBox(
        height: shown.length * 44.0 + 20,
        child: BarChart(
          BarChartData(
            maxY: maxY,
            minY: 0,
            alignment: BarChartAlignment.spaceAround,
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              leftTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 90,
                  getTitlesWidget: (value, meta) {
                    final i = value.toInt();
                    if (i < 0 || i >= shown.length) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        SymptomCatalog.labelOf(shown[i].key, l10n),
                        style: TextStyle(
                          fontSize: 11,
                          color: LunoraTokens.inkSoft,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  },
                ),
              ),
            ),
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, _, rod, __) {
                  final label =
                      SymptomCatalog.labelOf(shown[group.x].key, l10n);
                  return BarTooltipItem(
                    '$label\n${rod.toY.toInt()} days',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  );
                },
              ),
            ),
            barGroups: [
              for (var i = 0; i < shown.length; i++)
                BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: shown[i].value.toDouble(),
                      color: LunoraTokens.pinkDeep,
                      width: 20,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
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
