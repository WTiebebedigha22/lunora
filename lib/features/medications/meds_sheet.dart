import 'package:flutter/material.dart';

import '../../core/theme/lunora_tokens.dart';
import '../../shared/models/day_log.dart';
import '../../shared/models/lunora_state.dart';
import '../../shared/models/medication.dart';

class MedsSheet extends StatefulWidget {
  const MedsSheet({
    super.key,
    required this.state,
    required this.onUpdate,
  });

  final LunoraState state;
  final Future<void> Function(LunoraState) onUpdate;

  @override
  State<MedsSheet> createState() => _MedsSheetState();
}

class _MedsSheetState extends State<MedsSheet> {
  late LunoraState _state;
  final _name = TextEditingController();
  final _dose = TextEditingController();

  static const List<Map<String, String>> _presets = [
    {'name': 'Metformin', 'dose': '500mg'},
    {'name': 'Inositol', 'dose': '2g'},
    {'name': 'Spironolactone', 'dose': '50mg'},
    {'name': 'Birth control', 'dose': 'daily'},
    {'name': 'Vitamin D', 'dose': '2000 IU'},
    {'name': 'Omega-3', 'dose': '1000mg'},
  ];

  @override
  void initState() {
    super.initState();
    _state = widget.state;
  }

  @override
  void dispose() {
    _name.dispose();
    _dose.dispose();
    super.dispose();
  }

  String _todayKey() {
    final n = DateTime.now();
    return '${n.year.toString().padLeft(4, '0')}-'
        '${n.month.toString().padLeft(2, '0')}-'
        '${n.day.toString().padLeft(2, '0')}';
  }

  Future<void> _commit(LunoraState next) async {
    setState(() => _state = next);
    await widget.onUpdate(next);
  }

  Future<void> _addMed(String name, String dose) async {
    if (name.trim().isEmpty) return;
    final med = Medication(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name.trim(),
      dose: dose.trim(),
    );
    await _commit(_state.copyWith(meds: [..._state.meds, med]));
  }

  Future<void> _toggleTaken(String medId) async {
    final today = _todayKey();
    final existing = _state.logs[today] ?? DayLog();
    final meds = existing.meds.contains(medId)
        ? existing.meds.where((id) => id != medId).toList()
        : [...existing.meds, medId];
    final nextLogs = Map<String, DayLog>.from(_state.logs);
    nextLogs[today] = existing.copyWith(meds: meds);
    await _commit(_state.copyWith(logs: nextLogs));
  }

  Future<void> _deleteMed(Medication med) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Remove medication?'),
        content: Text(
          'This removes ${med.name} from your list. Past logs that '
          'recorded it are kept.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await _commit(_state.copyWith(
      meds: _state.meds.where((m) => m.id != med.id).toList(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final taken = _state.logs[_todayKey()]?.meds ?? const <String>[];
    final inset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: inset),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        padding: EdgeInsets.all(LunoraTokens.spaceLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Medications',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  if (_state.meds.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Add what you take. Tap a row to mark it taken today.',
                        style: TextStyle(color: LunoraTokens.inkSoft),
                      ),
                    ),
                  ..._state.meds.map((m) {
                    final isTaken = taken.contains(m.id);
                    return GestureDetector(
                      onLongPress: () => _deleteMed(m),
                      onTap: () => _toggleTaken(m.id),
                      child: Container(
                        margin: EdgeInsets.only(bottom: LunoraTokens.spaceSm),
                        padding: EdgeInsets.all(LunoraTokens.spaceMd),
                        decoration: BoxDecoration(
                          color: isTaken
                              ? const Color(0xFFEDF7F1)
                              : LunoraTokens.card,
                          borderRadius:
                              BorderRadius.circular(LunoraTokens.radiusMd),
                          border: Border.all(
                            color: isTaken
                                ? LunoraTokens.success
                                : LunoraTokens.line,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    m.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  if (m.dose.isNotEmpty)
                                    Text(
                                      m.dose,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: LunoraTokens.inkSoft,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Text(
                              isTaken ? '\u2713 taken' : 'tap to take',
                              style: TextStyle(
                                color: isTaken
                                    ? LunoraTokens.success
                                    : LunoraTokens.inkSoft,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  SizedBox(height: LunoraTokens.spaceLg),
                  const Text(
                    'Add new',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: LunoraTokens.spaceSm),
                  TextField(
                    controller: _name,
                    decoration: const InputDecoration(
                      hintText: 'Name (e.g. Metformin)',
                    ),
                  ),
                  SizedBox(height: LunoraTokens.spaceSm),
                  TextField(
                    controller: _dose,
                    decoration: const InputDecoration(
                      hintText: 'Dose (optional)',
                    ),
                  ),
                  SizedBox(height: LunoraTokens.spaceSm),
                  OutlinedButton(
                    onPressed: () {
                      _addMed(_name.text, _dose.text);
                      _name.clear();
                      _dose.clear();
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      side: BorderSide(color: LunoraTokens.lavenderDeep),
                      foregroundColor: LunoraTokens.lavenderDeep,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(LunoraTokens.radiusMd),
                      ),
                    ),
                    child: const Text('Add'),
                  ),
                  SizedBox(height: LunoraTokens.spaceLg),
                  const Text(
                    'Suggestions',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: LunoraTokens.spaceSm),
                  Wrap(
                    spacing: LunoraTokens.spaceSm,
                    runSpacing: LunoraTokens.spaceSm,
                    children: _presets.map((p) {
                      return GestureDetector(
                        onTap: () => _addMed(p['name']!, p['dose'] ?? ''),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: LunoraTokens.spaceMd,
                            vertical: LunoraTokens.spaceSm,
                          ),
                          decoration: BoxDecoration(
                            color: LunoraTokens.lavender,
                            borderRadius:
                                BorderRadius.circular(LunoraTokens.radiusPill),
                          ),
                          child: Text(
                            '+ ${p['name']}',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
