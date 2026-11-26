import 'package:flutter/material.dart';

import '../../core/theme/lunora_components.dart';
import '../../core/theme/lunora_tokens.dart';
import '../../shared/models/lunora_state.dart';
import '../../shared/models/symptom_catalog.dart';
import 'trends_screen.dart';

import 'package:lunora/l10n/app_localizations.dart';
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key, required this.state});
  final LunoraState state;

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _mode = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('History',
                      style: Theme.of(context).textTheme.headlineLarge),
                  const SizedBox(height: 16),
                  LunoraModeTabs(
                    labels: const ['Log', 'Trends'],
                    index: _mode,
                    onChange: (i) => setState(() => _mode = i),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _mode == 0
                  ? _LogList(state: widget.state)
                  : TrendsScreen(state: widget.state),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogList extends StatelessWidget {
  const _LogList({required this.state});
  final LunoraState state;

  @override
  Widget build(BuildContext context) {
    final l10n = LunoraLocalizations.of(context)!;

    final entries = state.logs.entries.where((e) => !e.value.isEmpty).toList()
      ..sort((a, b) => b.key.compareTo(a.key));

    final counts = <String, int>{};
    for (final e in entries) {
      for (final s in e.value.symptoms) {
        counts[s] = (counts[s] ?? 0) + 1;
      }
    }
    final top = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top3 = top.take(3).toList();

    if (entries.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          LunoraEmptyState(
            icon: Icons.history,
            title: 'No logs yet',
            body: 'Tap "Log symptoms" on Home to start your first entry.',
          ),
        ],
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: [
        if (top3.isNotEmpty) ...[
          LunoraCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LunoraEyebrow('TOP SYMPTOMS'),
                const SizedBox(height: 12),
                ...top3.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            SymptomCatalog.labelOf(e.key, l10n),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: LunoraTokens.ink,
                            ),
                          ),
                        ),
                        Text(
                          '${e.value}×',
                          style: TextStyle(
                            color: LunoraTokens.inkSoft,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
        const LunoraSectionHeader(title: 'Your log'),
        ...entries.map((e) {
          final log = e.value;
          final medCount = log.meds.length;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: LunoraCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.key,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                      letterSpacing: 0.6,
                      color: LunoraTokens.inkSoft,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${log.symptoms.length} symptom'
                    '${log.symptoms.length == 1 ? '' : 's'} · '
                    'severity ${log.severity}'
                    '${log.mood.isNotEmpty ? ' · ${log.mood}' : ''}'
                    '${medCount > 0 ? ' · $medCount med${medCount == 1 ? '' : 's'}' : ''}',
                    style: TextStyle(
                      fontSize: 14,
                      color: LunoraTokens.ink,
                    ),
                  ),
                  if (log.notes.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        '"${log.notes}"',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: LunoraTokens.inkSoft,
                          fontSize: 13,
                          height: 1.45,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
