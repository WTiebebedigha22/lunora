import 'package:material_ui/material_ui.dart';

import '../../../core/theme/lunora_tokens.dart';
import '../../../shared/models/day_log.dart';
import '../../../shared/models/lunora_state.dart';

class AdherenceBars extends StatelessWidget {
  const AdherenceBars({
    super.key,
    required this.state,
    required this.windowDays,
    required this.windowLogs,
  });

  final LunoraState state;
  final int windowDays;
  final List<MapEntry<String, DayLog>> windowLogs;

  @override
  Widget build(BuildContext context) {
    if (state.meds.isEmpty) {
      return _card(
        title: 'MEDICATION ADHERENCE',
        child: Text(
          'No medications tracked yet.',
          style: TextStyle(color: LunoraTokens.inkSoft, fontSize: 13),
        ),
      );
    }

    final rows = state.meds.map((m) {
      var taken = 0;
      for (final e in windowLogs) {
        if (e.value.meds.contains(m.id)) taken++;
      }
      final pct = windowDays == 0 ? 0.0 : (taken / windowDays).clamp(0.0, 1.0);
      return (med: m, taken: taken, pct: pct);
    }).toList();

    return _card(
      title: 'MEDICATION ADHERENCE',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Days taken / days in window. No interpretation.',
            style: TextStyle(
              fontSize: 11,
              color: LunoraTokens.inkSoft,
            ),
          ),
          SizedBox(height: LunoraTokens.spaceMd),
          ...rows.map((r) => Padding(
                padding: EdgeInsets.only(bottom: LunoraTokens.spaceMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            r.med.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Text(
                          '${r.taken}/$windowDays',
                          style: TextStyle(
                            fontSize: 12,
                            color: LunoraTokens.inkSoft,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: r.pct,
                        minHeight: 8,
                        backgroundColor: LunoraTokens.line,
                        valueColor: AlwaysStoppedAnimation(
                          LunoraTokens.success,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
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
