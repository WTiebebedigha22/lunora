import 'package:flutter/material.dart';

import '../../content/education.dart';
import '../../core/theme/lunora_components.dart';
import '../../core/theme/lunora_tokens.dart';
import '../../shared/models/lunora_state.dart';
import '../education/education_detail_page.dart';
import '../education/illustration.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({
    super.key,
    required this.state,
    required this.onUpdate,
  });

  final LunoraState state;
  final Future<void> Function(LunoraState) onUpdate;

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  int _mode = 0;
  String _query = '';

  static const _categoryOrder = [
    'hormones',
    'cycle',
    'metabolism',
    'mental',
    'care',
  ];

  static const _categoryTitles = {
    'hormones': 'PCOS Health',
    'cycle': 'My Menstrual Cycle',
    'metabolism': 'Metabolism & Energy',
    'mental': 'Mental Health',
    'care': 'Care & Clinicians',
  };

  List<EducationCard> _visible() {
    final q = _query.trim().toLowerCase();
    return educationCards.where((c) {
      if (widget.state.education.isDismissed(c.id)) return false;
      if (_mode == 1 && !widget.state.education.isSaved(c.id)) {
        return false;
      }
      if (q.isNotEmpty) {
        final hay = '${c.title} ${c.summary} ${c.body}'.toLowerCase();
        if (!hay.contains(q)) return false;
      }
      return true;
    }).toList();
  }

  Map<String, List<EducationCard>> _byCategory(List<EducationCard> cards) {
    final map = <String, List<EducationCard>>{};
    for (final c in cards) {
      map.putIfAbsent(c.category, () => []).add(c);
    }
    return map;
  }

  /// Choose a hero card based on onboarding priorities and read state.
  ({EducationCard card, String subtitle})? _forYou(
      List<EducationCard> visible) {
    if (visible.isEmpty) return null;

    final priorities = widget.state.onboarding?.priorities ?? const [];

    // 1. If user has priorities, pick the top unread in those categories.
    if (priorities.isNotEmpty) {
      for (final cat in priorities) {
        final match = visible.firstWhere(
          (c) => c.category == cat && !widget.state.education.isRead(c.id),
          orElse: () => visible.first,
        );
        if (!widget.state.education.isRead(match.id)) {
          final label = _categoryTitles[match.category] ?? 'your priorities';
          return (
            card: match,
            subtitle: 'Because you chose $label',
          );
        }
      }
    }

    // 2. Otherwise pick the first unread.
    for (final c in visible) {
      if (!widget.state.education.isRead(c.id)) {
        return (card: c, subtitle: 'Start here');
      }
    }

    // 3. All read — suggest a random one to re-read.
    return (
      card: visible.first,
      subtitle: 'Read again',
    );
  }

  Future<void> _open(EducationCard card) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EducationDetailPage(
          card: card,
          state: widget.state,
          onUpdate: widget.onUpdate,
        ),
      ),
    );
    if (mounted) setState(() {});
  }

  Future<void> _toggleSave(EducationCard card) async {
    final saved = widget.state.education.isSaved(card.id);
    final nextIds = saved
        ? widget.state.education.savedIds.where((id) => id != card.id).toList()
        : [...widget.state.education.savedIds, card.id];
    await widget.onUpdate(widget.state.copyWith(
      education: widget.state.education.copyWith(savedIds: nextIds),
    ));
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visible();
    final grouped = _byCategory(visible);
    final savedCount = widget.state.education.savedIds.length;
    final forYou = _mode == 0 && _query.isEmpty ? _forYou(visible) : null;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            Text(
              'Insights',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 16),

            // Mode tabs
            LunoraModeTabs(
              labels: [
                'All',
                savedCount > 0 ? 'Saved ($savedCount)' : 'Saved',
              ],
              index: _mode,
              onChange: (i) => setState(() => _mode = i),
            ),
            const SizedBox(height: 12),

            // Search
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: LunoraTokens.card,
                borderRadius: BorderRadius.circular(LunoraTokens.radiusPill),
                border: Border.all(color: LunoraTokens.line),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, size: 18, color: LunoraTokens.inkPale),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      onChanged: (v) => setState(() => _query = v),
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        isDense: true,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        filled: false,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // For You hero
            if (forYou != null) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  'For you',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: LunoraTokens.ink,
                  ),
                ),
              ),
              _forYouCard(forYou),
              const SizedBox(height: 24),
            ],

            // Empty
            if (visible.isEmpty)
              LunoraEmptyState(
                icon: _mode == 1 ? Icons.bookmark_outline : Icons.search_off,
                title: _mode == 1 ? 'No saved articles yet' : 'Nothing matches',
                body: _mode == 1
                    ? 'Tap the bookmark on any article to save it for later.'
                    : 'Try a different search term.',
              )
            else
              ..._categoryOrder.expand((cat) {
                final items = grouped[cat];
                if (items == null || items.isEmpty) {
                  return <Widget>[];
                }
                return [
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 12),
                    child: Text(
                      _categoryTitles[cat] ?? cat,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: LunoraTokens.ink,
                      ),
                    ),
                  ),
                  // Horizontal, wraps to next line if needed — no fixed height.
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var i = 0; i < items.length; i++) ...[
                          if (i > 0) const SizedBox(width: 12),
                          _card(items[i]),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ];
              }),
          ],
        ),
      ),
    );
  }

  Widget _forYouCard(({EducationCard card, String subtitle}) f) {
    final card = f.card;
    final saved = widget.state.education.isSaved(card.id);
    return GestureDetector(
      onTap: () => _open(card),
      child: Container(
        decoration: BoxDecoration(
          color: LunoraTokens.card,
          borderRadius: BorderRadius.circular(LunoraTokens.radiusLg),
          border: Border.all(color: LunoraTokens.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                EducationIllustration(
                  category: card.category,
                  size: MediaQuery.of(context).size.width - 40,
                  rounded: false,
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () => _toggleSave(card),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        saved ? Icons.bookmark : Icons.bookmark_border,
                        size: 18,
                        color:
                            saved ? LunoraTokens.purple : LunoraTokens.inkSoft,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    f.subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                      color: LunoraTokens.purple,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    card.title,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: LunoraTokens.ink,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    card.summary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: LunoraTokens.inkSoft,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'Read more',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: LunoraTokens.purple,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward,
                        size: 14,
                        color: LunoraTokens.purple,
                      ),
                      const Spacer(),
                      Text(
                        '${card.readMinutes} min',
                        style: TextStyle(
                          fontSize: 11,
                          color: LunoraTokens.inkSoft,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(EducationCard card) {
    final saved = widget.state.education.isSaved(card.id);
    final read = widget.state.education.isRead(card.id);

    return GestureDetector(
      onTap: () => _open(card),
      child: Container(
        width: 190,
        // No fixed height — card grows with its content.
        decoration: BoxDecoration(
          color: LunoraTokens.card,
          borderRadius: BorderRadius.circular(LunoraTokens.radiusLg),
          border: Border.all(color: LunoraTokens.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                EducationIllustration(
                  category: card.category,
                  size: 190,
                  rounded: false,
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => _toggleSave(card),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.85),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        saved ? Icons.bookmark : Icons.bookmark_border,
                        size: 16,
                        color:
                            saved ? LunoraTokens.purple : LunoraTokens.inkSoft,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    card.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: LunoraTokens.ink,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${card.readMinutes} min',
                        style: TextStyle(
                          fontSize: 11,
                          color: LunoraTokens.inkSoft,
                        ),
                      ),
                      if (read) ...[
                        const SizedBox(width: 6),
                        Icon(Icons.check_circle,
                            size: 12, color: LunoraTokens.success),
                      ],
                    ],
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