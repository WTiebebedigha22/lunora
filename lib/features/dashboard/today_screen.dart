import 'package:flutter/material.dart';

import '../../content/education.dart';
import '../../core/theme/lunora_components.dart';
import '../../core/theme/lunora_tokens.dart';
import '../../shared/models/day_log.dart';
import '../../shared/models/lunora_state.dart';
import '../../shared/models/symptom_catalog.dart';
import '../cycle/cycle_stats.dart';
import '../education/education_detail.dart';
import '../education/learn_card.dart';
import '../medications/meds_sheet.dart';
import '../symptoms/log_sheet.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({
    super.key,
    required this.state,
    required this.onUpdate,
  });

  final LunoraState state;
  final Future<void> Function(LunoraState) onUpdate;

  static String _todayKey() {
    final n = DateTime.now();
    return '${n.year.toString().padLeft(4, '0')}-'
        '${n.month.toString().padLeft(2, '0')}-'
        '${n.day.toString().padLeft(2, '0')}';
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 18) return 'Good afternoon';
    return 'Good evening';
  }

  String _formattedDate() {
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

  Future<void> _openLog(BuildContext context) async {
    final today = _todayKey();
    final existing = state.logs[today];
    final result = await showModalBottomSheet<DayLog>(
      context: context,
      isScrollControlled: true,
      backgroundColor: LunoraTokens.bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (_) => LogSheet(initial: existing),
    );
    if (result == null) return;
    final nextLogs = Map<String, DayLog>.from(state.logs);
    nextLogs[today] = result;
    await onUpdate(state.copyWith(logs: nextLogs));
  }

  Future<void> _openMeds(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: LunoraTokens.bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (_) => MedsSheet(state: state, onUpdate: onUpdate),
    );
  }

  List<EducationCard> _visibleCards() {
    return educationCards
        .where((c) => !state.education.isDismissed(c.id))
        .toList();
  }

  EducationCard? _articleOfDay(List<EducationCard> visible) {
    if (visible.isEmpty) return null;
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    return visible[dayOfYear % visible.length];
  }

  EducationCard? _nextUp(List<EducationCard> visible, EducationCard? article) {
    for (final c in visible) {
      if (c.id == article?.id) continue;
      if (state.education.isRead(c.id)) continue;
      return c;
    }
    return null;
  }

  Future<void> _openArticle(BuildContext context, EducationCard card) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: LunoraTokens.bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (ctx) => ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(ctx).size.height * 0.9,
        ),
        child: EducationDetail(
          card: card,
          isRead: state.education.isRead(card.id),
          onRead: () async {
            final next = state.education.copyWith(
              readIds: [...state.education.readIds, card.id],
            );
            await onUpdate(state.copyWith(education: next));
            if (ctx.mounted) Navigator.of(ctx).pop();
          },
          onDismiss: () async {
            final next = state.education.copyWith(
              dismissedIds: [
                ...state.education.dismissedIds,
                card.id,
              ],
            );
            await onUpdate(state.copyWith(education: next));
            if (ctx.mounted) Navigator.of(ctx).pop();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final today = _todayKey();
    final todayLog = state.logs[today];
    final hasLogged = todayLog != null && !todayLog.isEmpty;
    final medsTaken = todayLog?.meds.length ?? 0;
    final medsTotal = state.meds.length;
    final stats = CycleStats.compute(state.cycles);

    final visible = _visibleCards();
    final article = _articleOfDay(visible);
    final next = _nextUp(visible, article);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            // ── Header ────────────────────────────────────────
            LunoraHomeHeader(
              greeting: _greeting(),
              date: _formattedDate(),
              onProfileTap: () => _openMeds(context),
            ),
            const SizedBox(height: 20),

            // ── Week strip ────────────────────────────────────
            LunoraWeekStrip(
              selectedDate: DateTime.now(),
            ),
            const SizedBox(height: 24),

            // ── Illustration / state card ─────────────────────
            _heroState(stats),
            const SizedBox(height: 24),

            // ── Log CTA ───────────────────────────────────────
            Center(
              child: SizedBox(
                width: 160,
                child: LunoraGradientButton(
                  label: hasLogged ? '+ UPDATE' : '+ LOG',
                  height: 48,
                  onTap: () => _openLog(context),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // ── My daily insights ────────────────────────────
            const LunoraSectionHeader(title: 'My daily insights'),
            SizedBox(
              height: 158,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _insightCard(
                    icon: Icons.water_drop_outlined,
                    title: 'Cycle status',
                    value: stats?.currentOngoing != null
                        ? 'Day ${_dayOfCurrentCycle(stats!.currentOngoing!.startDate)}'
                        : stats?.completedCount != null &&
                                stats!.completedCount >= 2
                            ? '${stats.averageLength}d avg'
                            : 'Not yet',
                    onTap: () {},
                  ),
                  const SizedBox(width: 12),
                  _insightCard(
                    icon: Icons.medication_outlined,
                    title: 'Meds today',
                    value:
                        medsTotal == 0 ? 'None yet' : '$medsTaken / $medsTotal',
                    onTap: () => _openMeds(context),
                  ),
                  const SizedBox(width: 12),
                  _insightCard(
                    icon: Icons.book_outlined,
                    title: 'Today\'s read',
                    value: article != null ? 'Ready' : 'All done',
                    onTap: article != null
                        ? () => _openArticle(context, article)
                        : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Learn section ─────────────────────────────────
            LunoraSectionHeader(
              title: 'Learn',
              action: Text(
                '${visible.length} of ${educationCards.length}',
                style: TextStyle(
                  fontSize: 12,
                  color: LunoraTokens.inkSoft,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (visible.isEmpty)
              const LunoraEmptyState(
                icon: Icons.auto_stories_outlined,
                title: 'More coming soon',
                body: 'New education cards are on the way.',
              )
            else
              SizedBox(
                height: 168,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    if (article != null)
                      LearnCard(
                        card: article,
                        isRead: state.education.isRead(article.id),
                        onTap: () => _openArticle(context, article),
                      ),
                    if (article != null && next != null)
                      const SizedBox(width: 12),
                    if (next != null)
                      LearnCard(
                        card: next,
                        isRead: false,
                        onTap: () => _openArticle(context, next),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _heroState(CycleStats? stats) {
    String caption;
    String icon;

    if (stats == null || stats.lastStart == null) {
      caption = 'Log your first period to see your cycle here';
      icon = '✿';
    } else if (stats.currentOngoing != null) {
      final day = _dayOfCurrentCycle(stats.currentOngoing!.startDate);
      caption = 'Day $day of your current cycle';
      icon = '❁';
    } else if (stats.completedCount < 2) {
      caption = 'One more cycle and we can show your range';
      icon = '❀';
    } else {
      caption = 'Cycles range ${stats.minLength}–${stats.maxLength} days';
      icon = '❋';
    }

    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: LunoraTokens.purplePale,
        borderRadius: BorderRadius.circular(LunoraTokens.radiusXl),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            icon,
            style: TextStyle(
              fontSize: 72,
              color: LunoraTokens.purple,
              height: 1,
            ),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              caption,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: LunoraTokens.ink,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _insightCard({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 130,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: LunoraTokens.card,
          borderRadius: BorderRadius.circular(LunoraTokens.radiusLg),
          border: Border.all(color: LunoraTokens.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: LunoraTokens.purplePale,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: LunoraTokens.purple, size: 18),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: LunoraTokens.ink,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.5,
                color: LunoraTokens.inkSoft,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _dayOfCurrentCycle(String startDate) {
    final s = DateTime.parse(startDate);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return today.difference(s).inDays + 1;
  }
}
