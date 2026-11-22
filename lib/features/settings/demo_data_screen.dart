import 'package:flutter/material.dart';

import '../../core/theme/lunora_tokens.dart';
import '../../dev/demo_data.dart';
import '../../shared/models/lunora_state.dart';

class DemoDataScreen extends StatelessWidget {
  const DemoDataScreen({
    super.key,
    required this.state,
    required this.onUpdate,
  });

  final LunoraState state;
  final Future<void> Function(LunoraState) onUpdate;

  Future<void> _apply(BuildContext context, DemoProfile profile) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Load "${profile.name}"?'),
        content: const Text(
          'This will replace your current logs, medications, and cycles '
          'with demo data. Education progress is kept. '
          'Onboarding status is kept.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Load demo'),
          ),
        ],
      ),
    );
    if (ok != true) return;

    final next = applyDemoProfile(state, profile.id);
    await onUpdate(next);
    if (context.mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Demo data')),
      body: ListView(
        padding: EdgeInsets.all(LunoraTokens.spaceLg),
        children: [
          Container(
            padding: EdgeInsets.all(LunoraTokens.spaceMd),
            decoration: BoxDecoration(
              color: LunoraTokens.pink,
              borderRadius: BorderRadius.circular(LunoraTokens.radiusMd),
            ),
            child: const Text(
              'These profiles are based on real PCOS experiences '
              'shared publicly on Reddit, Clue, and in research '
              'studies. They are synthetic reconstructions, not '
              'real people\'s data.\n\n'
              'Use them to test charts, calendar behavior, and the '
              'PDF report with realistic patterns.',
              style: TextStyle(fontSize: 12, height: 1.5),
            ),
          ),
          SizedBox(height: LunoraTokens.spaceLg),
          ...demoProfiles.map((p) => Padding(
                padding: EdgeInsets.only(bottom: LunoraTokens.spaceSm),
                child: Material(
                  color: LunoraTokens.card,
                  borderRadius: BorderRadius.circular(LunoraTokens.radiusMd),
                  child: InkWell(
                    onTap: () => _apply(context, p),
                    borderRadius: BorderRadius.circular(LunoraTokens.radiusMd),
                    child: Container(
                      padding: EdgeInsets.all(LunoraTokens.spaceMd),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(LunoraTokens.radiusMd),
                        border: Border.all(color: LunoraTokens.line),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  p.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Text(
                                '${p.logs.length}d · '
                                '${p.cycles.length}c',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: LunoraTokens.inkSoft,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            p.description,
                            style: TextStyle(
                              fontSize: 12,
                              color: LunoraTokens.inkSoft,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )),
          SizedBox(height: LunoraTokens.spaceLg),
          Text(
            'After loading, go to Cycle to see the calendar, '
            'History → Trends to see charts, and Settings → '
            'Doctor Reports to see the PDF with real data.',
            style: TextStyle(
              fontSize: 12,
              color: LunoraTokens.inkSoft,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
