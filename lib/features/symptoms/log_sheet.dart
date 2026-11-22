import 'package:flutter/material.dart';

import '../../core/theme/lunora_components.dart';
import '../../core/theme/lunora_tokens.dart';
import '../../shared/models/day_log.dart';
import '../../shared/models/symptom_catalog.dart';

import 'package:lunora/l10n/app_localizations.dart';

class LogSheet extends StatefulWidget {
  const LogSheet({super.key, this.initial});
  final DayLog? initial;

  @override
  State<LogSheet> createState() => _LogSheetState();
}

class _LogSheetState extends State<LogSheet> {
  LunoraLocalizations get l10n => LunoraLocalizations.of(context);

  late final Set<String> _selected;
  late int _severity;
  late final TextEditingController _notes;
  int _page = 0; // 0 = severity, 1 = symptoms, 2 = notes

  @override
  void initState() {
    super.initState();
    _selected = {...(widget.initial?.symptoms ?? const [])};
    _severity = widget.initial?.severity ?? 3;
    _notes = TextEditingController(text: widget.initial?.notes ?? '');
  }

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  void _save() {
    final base = widget.initial ?? DayLog();
    Navigator.of(context).pop(
      base.copyWith(
        symptoms: _selected.toList(),
        severity: _severity,
        notes: _notes.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height * 0.92;

    return Container(
      height: h,
      decoration: BoxDecoration(
        color: LunoraTokens.bg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Top bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(Icons.close, color: LunoraTokens.ink, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  'Log',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: LunoraTokens.ink,
                  ),
                ),
              ],
            ),
          ),

          // Week strip
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: LunoraWeekStrip(selectedDate: DateTime.now()),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),

          // Date label
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Text(
              _todayLabel(),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: LunoraTokens.ink,
              ),
            ),
          ),

          // Stepper
          _stepper(),

          // Page content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _pageContent(),
            ),
          ),

          // Next / Log button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: SizedBox(
              width: double.infinity,
              child: LunoraGradientButton(
                label: _page < 2 ? 'Next' : 'Log',
                onTap: _page < 2 ? () => setState(() => _page++) : _save,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepper() {
    const labels = ['Flow', 'Symptoms', 'Mood'];
    const icons = [
      Icons.water_drop_outlined,
      Icons.local_florist_outlined,
      Icons.emoji_emotions_outlined,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: List.generate(labels.length, (i) {
          final active = i == _page;
          final done = i < _page;
          final color = active
              ? LunoraTokens.purple
              : done
                  ? LunoraTokens.purpleSoft
                  : LunoraTokens.line;

          return Expanded(
            child: Row(
              children: [
                // left connector
                Expanded(
                  child: Container(
                    height: 2,
                    color: i == 0 ? Colors.transparent : color,
                  ),
                ),
                // node
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: active
                        ? LunoraTokens.purple
                        : done
                            ? LunoraTokens.purpleSoft
                            : LunoraTokens.card,
                    shape: BoxShape.circle,
                    border: Border.all(color: color, width: 1.5),
                  ),
                  child: Icon(
                    icons[i],
                    size: 20,
                    color: active
                        ? Colors.white
                        : done
                            ? LunoraTokens.purpleDeep
                            : LunoraTokens.inkPale,
                  ),
                ),
                // right connector
                Expanded(
                  child: Container(
                    height: 2,
                    color: i == labels.length - 1
                        ? Colors.transparent
                        : (done ? LunoraTokens.purpleSoft : color),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _pageContent() {
    switch (_page) {
      case 0:
        return _severityPage();
      case 1:
        return _symptomsPage();
      case 2:
      default:
        return _notesPage();
    }
  }

  Widget _severityPage() {
    return ListView(
      children: [
        const SizedBox(height: 8),
        Center(
          child: Text(
            'Overall severity',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: 6),
        Center(
          child: Text(
            'How intense are your symptoms today?',
            style: TextStyle(
              color: LunoraTokens.inkSoft,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Column(
          children: List.generate(5, (i) {
            final n = i + 1;
            final active = _severity == n;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: () => setState(() => _severity = n),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: active ? LunoraTokens.purpleSoft : LunoraTokens.card,
                    borderRadius:
                        BorderRadius.circular(LunoraTokens.radiusPill),
                    border: Border.all(
                      color: active ? LunoraTokens.purple : LunoraTokens.line,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _severityLabel(n),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: active
                                ? LunoraTokens.purpleDeep
                                : LunoraTokens.ink,
                          ),
                        ),
                      ),
                      Text(
                        '$n',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: active
                              ? LunoraTokens.purpleDeep
                              : LunoraTokens.inkSoft,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _symptomsPage() {
    return ListView(
      children: [
        const SizedBox(height: 4),
        Center(
          child: Text(
            'Symptoms',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: 6),
        Center(
          child: Text(
            'Tap everything that applies',
            style: TextStyle(
              color: LunoraTokens.inkSoft,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...SymptomCatalog.groups.map(_symptomGroup),
      ],
    );
  }

  Widget _symptomGroup(SymptomGroup group) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            group.label(l10n),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: LunoraTokens.inkSoft,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 8),
          ...group.items.map((item) {
            final active = _selected.contains(item.id);
            return _symptomRow(
              item: item,
              active: active,
              onTap: () => setState(() {
                if (active) {
                  _selected.remove(item.id);
                } else {
                  _selected.add(item.id);
                }
              }),
            );
          }),
        ],
      ),
    );
  }

  Widget _symptomRow({
    required SymptomItem item,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: LunoraTokens.line, width: 1),
          ),
        ),
        child: Row(
          children: [
            Icon(
              active ? Icons.circle : Icons.circle_outlined,
              size: 14,
              color: active ? LunoraTokens.purple : LunoraTokens.inkPale,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.label(l10n),
                style: TextStyle(
                  fontSize: 15,
                  color: active ? LunoraTokens.ink : LunoraTokens.inkSoft,
                  fontWeight: active ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: active ? LunoraTokens.purple : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: active ? LunoraTokens.purple : LunoraTokens.line,
                  width: 1.5,
                ),
              ),
              child: active
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _notesPage() {
    return ListView(
      children: [
        const SizedBox(height: 4),
        Center(
          child: Text(
            'Anything else?',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: 6),
        Center(
          child: Text(
            'Notes are optional',
            style: TextStyle(
              color: LunoraTokens.inkSoft,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _notes,
          minLines: 5,
          maxLines: 8,
          decoration: const InputDecoration(
            hintText: 'Anything you want to remember…',
          ),
        ),
      ],
    );
  }

  String _severityLabel(int n) {
    switch (n) {
      case 1:
        return 'Very mild';
      case 2:
        return 'Mild';
      case 3:
        return 'Moderate';
      case 4:
        return 'Severe';
      case 5:
        return 'Very severe';
      default:
        return '';
    }
  }

  String _todayLabel() {
    final n = DateTime.now();
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const months = [
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
    return 'Today, ${days[n.weekday - 1]}, ${n.day} '
        '${months[n.month - 1]}';
  }
}