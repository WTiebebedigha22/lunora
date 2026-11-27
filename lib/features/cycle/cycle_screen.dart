import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';

import '../../core/theme/lunora_components.dart';
import '../../core/theme/lunora_tokens.dart';
import '../../shared/models/cycle.dart';
import '../../shared/models/lunora_state.dart';
import 'cycle_calendar.dart';
import 'cycle_stats.dart';
import 'cycle_prediction.dart';

class CycleScreen extends StatefulWidget {
  const CycleScreen({
    super.key,
    required this.state,
    required this.onUpdate,
  });

  final LunoraState state;
  final Future<void> Function(LunoraState) onUpdate;

  @override
  State<CycleScreen> createState() => _CycleScreenState();
}

class _CycleScreenState extends State<CycleScreen> {
  late DateTime _month;

  @override
  void initState() {
    super.initState();
    final n = DateTime.now();
    _month = DateTime(n.year, n.month, 1);
  }

  String _fmt(DateTime d) => '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  bool _hasLog(DateTime d) => widget.state.logs.containsKey(_fmt(d));

  Future<void> _commit(LunoraState next) async {
    await widget.onUpdate(next);
  }

  Cycle? _cycleStartingOn(String date) {
    for (final c in widget.state.cycles) {
      if (c.startDate == date) return c;
    }
    return null;
  }

  Cycle? _cycleEndingOn(String date) {
    for (final c in widget.state.cycles) {
      if (c.endDate == date) return c;
    }
    return null;
  }

  Cycle? _openCycleCovering(String date) {
    for (final c in widget.state.cycles) {
      if (c.startDate.compareTo(date) <= 0 &&
          (c.endDate == null || date.compareTo(c.endDate!) <= 0)) {
        return c;
      }
    }
    return null;
  }

  Future<void> _onTapDay(DateTime d) async {
    final ds = _fmt(d);
    final today = DateTime.now();
    if (d.isAfter(DateTime(today.year, today.month, today.day))) {
      return;
    }

    final canStart =
        _cycleStartingOn(ds) == null && _openCycleCovering(ds) == null;
    final open = _openCycleCovering(ds);
    final canEnd = open != null && open.isOngoing;
    final isStart = _cycleStartingOn(ds) != null;
    final isEnd = _cycleEndingOn(ds) != null;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: LunoraTokens.bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _prettyDate(d),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: LunoraTokens.ink,
                ),
              ),
              const SizedBox(height: 16),
              if (canStart)
                _sheetBtn(
                  label: 'Mark period start',
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _markStart(ds);
                  },
                ),
              if (canEnd)
                _sheetBtn(
                  label: 'Mark period end',
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _markEnd(open, ds);
                  },
                ),
              if (isStart && !canEnd)
                _sheetBtn(
                  label: 'Remove this cycle start',
                  danger: true,
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _removeCycle(_cycleStartingOn(ds)!);
                  },
                ),
              if (isEnd)
                _sheetBtn(
                  label: 'Remove this cycle end',
                  danger: true,
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _clearEnd(_cycleEndingOn(ds)!);
                  },
                ),
              if (!canStart && !canEnd && !isStart && !isEnd)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'No cycle action available on this day.',
                    style: TextStyle(color: LunoraTokens.inkSoft),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _markStart(String date) async {
    final c = Cycle(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      startDate: date,
    );
    await _commit(widget.state.copyWith(
      cycles: [...widget.state.cycles, c],
    ));
  }

  Future<void> _markEnd(Cycle c, String date) async {
    final next = widget.state.cycles
        .map((x) => x.id == c.id ? x.copyWith(endDate: date) : x)
        .toList();
    await _commit(widget.state.copyWith(cycles: next));
  }

  Future<void> _removeCycle(Cycle c) async {
    await _commit(widget.state.copyWith(
      cycles: widget.state.cycles.where((x) => x.id != c.id).toList(),
    ));
  }

  Future<void> _clearEnd(Cycle c) async {
    final next = widget.state.cycles
        .map((x) => x.id == c.id
            ? Cycle(
                id: x.id,
                startDate: x.startDate,
                endDate: null,
                flow: x.flow,
                createdAt: x.createdAt,
                updatedAt: DateTime.now().millisecondsSinceEpoch,
              )
            : x)
        .toList();
    await _commit(widget.state.copyWith(cycles: next));
  }

  Future<void> _openLogPeriod() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final start = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today.subtract(const Duration(days: 400)),
      lastDate: today,
      helpText: 'Pick a period start date',
    );
    if (!mounted) return;
    if (start == null) return;
    final end = await showDatePicker(
      context: context,
      initialDate: start,
      firstDate: start,
      lastDate: today,
      helpText: 'Pick a period end date (optional)',
    );
    final c = Cycle(
      id: now.microsecondsSinceEpoch.toString(),
      startDate: _fmt(start),
      endDate: end == null ? null : _fmt(end),
    );
    await _commit(widget.state.copyWith(
      cycles: [...widget.state.cycles, c],
    ));
  }

  Widget _sheetBtn({
    required String label,
    required VoidCallback onTap,
    bool danger = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
          foregroundColor: danger ? LunoraTokens.warn : LunoraTokens.purple,
          side: BorderSide(
            color: danger ? LunoraTokens.warn : LunoraTokens.purple,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(LunoraTokens.radiusPill),
          ),
        ),
        child: Text(label),
      ),
    );
  }

  String _prettyDate(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final stats = CycleStats.compute(widget.state.cycles);
    final prediction = CyclePrediction.fromCycles(widget.state.cycles);
    final band = prediction == null
        ? stats?.likelyWindow()
        : (start: prediction.earliest, end: prediction.latest);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Cycle',
                          style: Theme.of(context).textTheme.headlineLarge),
                      const SizedBox(height: 4),
                      Text(
                        'Irregularity is expected.',
                        style: TextStyle(
                          color: LunoraTokens.inkSoft,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: _openLogPeriod,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Log period'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (stats != null && stats.completedCount >= 2)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _statsStrip(stats),
              ),
            if (prediction != null) ...[
              _predictionCard(prediction),
              const SizedBox(height: 16),
            ],
            CycleCalendar(
              month: _month,
              cycles: widget.state.cycles,
              likelyWindow: band,
              hasAnyLog: _hasLog,
              onTapDay: _onTapDay,
              onPrevMonth: () => setState(() {
                _month = DateTime(_month.year, _month.month - 1, 1);
              }),
              onNextMonth: () => setState(() {
                _month = DateTime(_month.year, _month.month + 1, 1);
              }),
            ),
            const SizedBox(height: 16),
            _legend(),
            const SizedBox(height: 24),
            _statsCard(stats, band),
          ],
        ),
      ),
    );
  }

  Widget _predictionCard(CyclePrediction prediction) {
    final date = DateFormat('MMM d').format(prediction.nextStart);
    final range = '${DateFormat('MMM d').format(prediction.earliest)}–'
        '${DateFormat('MMM d').format(prediction.latest)}';
    final confidenceText = switch (prediction.confidence) {
      'early' =>
        'Early estimate from your last logged cycle. Another start date will help refine it.',
      'steadier' =>
        'Estimated from your recent cycle starts. Your timing may still vary.',
      _ => 'Your logged cycle lengths vary, so this date range is wider.',
    };

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFFFFE6DF), LunoraTokens.purplePale],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .8),
                shape: BoxShape.circle),
            child:
                Icon(Icons.auto_awesome_outlined, color: LunoraTokens.purple),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Next period estimate',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: LunoraTokens.inkSoft)),
                const SizedBox(height: 3),
                Text(date,
                    style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        color: LunoraTokens.ink)),
                Text('Likely window: $range',
                    style: TextStyle(fontSize: 12, color: LunoraTokens.ink)),
                const SizedBox(height: 6),
                Text(confidenceText,
                    style: TextStyle(
                        fontSize: 11,
                        height: 1.35,
                        color: LunoraTokens.inkSoft)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statsStrip(CycleStats stats) {
    return Row(
      children: [
        _statPill('AVG', '${stats.averageLength}d'),
        const SizedBox(width: 8),
        _statPill('SHORT', '${stats.minLength}d'),
        const SizedBox(width: 8),
        _statPill('LONG', '${stats.maxLength}d'),
      ],
    );
  }

  Widget _statPill(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        decoration: BoxDecoration(
          color: LunoraTokens.card,
          borderRadius: BorderRadius.circular(LunoraTokens.radiusMd),
          border: Border.all(color: LunoraTokens.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                color: LunoraTokens.inkSoft,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: LunoraTokens.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _legend() {
    Widget dot(Color c) => Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: c, shape: BoxShape.circle),
        );
    Widget swatch(Color c) => Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: c,
            borderRadius: BorderRadius.circular(4),
          ),
        );
    Widget item(Widget icon, String label) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: LunoraTokens.inkSoft,
              ),
            ),
          ],
        );

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        item(dot(LunoraTokens.pinkDeep), 'Symptoms logged'),
        item(swatch(LunoraTokens.pinkDeep), 'Cycle day'),
        item(swatch(LunoraTokens.pink), 'Ongoing'),
        item(
          swatch(LunoraTokens.purpleSoft),
          'Likely window',
        ),
      ],
    );
  }

  Widget _statsCard(CycleStats? stats, ({DateTime start, DateTime end})? band) {
    if (stats == null || stats.completedCount < 2) {
      return LunoraCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LunoraEyebrow('CYCLE LENGTH'),
            const SizedBox(height: 10),
            Text(
              "We'll show a range once you've logged a few cycles.",
              style: TextStyle(
                fontSize: 15,
                height: 1.45,
                color: LunoraTokens.ink,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Two completed cycles unlock your average, range, '
              'and likely window.',
              style: TextStyle(
                fontSize: 13,
                color: LunoraTokens.inkSoft,
                height: 1.4,
              ),
            ),
          ],
        ),
      );
    }

    return LunoraCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LunoraEyebrow('YOUR CYCLE RANGE'),
          const SizedBox(height: 14),
          Row(
            children: [
              _stat('AVERAGE', '${stats.averageLength}d'),
              _stat('SHORTEST', '${stats.minLength}d'),
              _stat('LONGEST', '${stats.maxLength}d'),
            ],
          ),
          if (band != null) ...[
            const SizedBox(height: 14),
            Text(
              'Based on ${stats.completedCount} cycle lengths. '
              'Your cycles have ranged from ${stats.minLength} to '
              '${stats.maxLength} days.',
              style: TextStyle(
                fontSize: 13,
                color: LunoraTokens.inkSoft,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _stat(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: LunoraTokens.inkSoft,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: LunoraTokens.ink,
            ),
          ),
        ],
      ),
    );
  }
}
