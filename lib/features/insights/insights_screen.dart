import 'package:flutter/material.dart';

import '../../content/education.dart';
import '../../content/insights_feed.dart';
import '../../core/theme/lunora_components.dart';
import '../../core/theme/lunora_tokens.dart';
import '../../shared/models/lunora_state.dart';
import 'package:url_launcher/url_launcher.dart';
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

            if (_mode == 0 && _query.trim().isEmpty) ...[
              _personalPatterns(),
              const SizedBox(height: 24),
              _resourceSection(
                'Latest articles',
                latestArticles,
                Icons.newspaper_outlined,
                LunoraTokens.purple,
              ),
              const SizedBox(height: 20),
              _resourceSection(
                'Real stories',
                realStories,
                Icons.favorite_border,
                const Color(0xFFE36D67),
              ),
              const SizedBox(height: 24),
              Text(
                'More to explore',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: LunoraTokens.ink),
              ),
              const SizedBox(height: 10),
            ],

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

  Widget _personalPatterns() {
    final recentLogs = widget.state.logs.entries
        .where((entry) => !entry.value.isEmpty)
        .toList()
      ..sort((a, b) => b.key.compareTo(a.key));
    final recent = recentLogs.take(7).toList();
    final titleStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: LunoraTokens.ink,
    );

    if (recent.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your patterns', style: titleStyle),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: LunoraTokens.purplePale, borderRadius: BorderRadius.circular(22)),
            child: Text(
              'Your personal insights will appear as you log symptoms and moods. They’re based on your entries on this device.',
              style: TextStyle(color: LunoraTokens.inkSoft, height: 1.45),
            ),
          ),
        ],
      );
    }

    final symptomCounts = <String, int>{};
    for (final entry in recent) {
      for (final symptom in entry.value.symptoms) {
        symptomCounts.update(symptom, (count) => count + 1, ifAbsent: () => 1);
      }
    }
    final topSymptom = symptomCounts.entries.isEmpty
        ? null
        : (symptomCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value))).first;
    final averageSeverity = recent
            .where((entry) => entry.value.symptoms.isNotEmpty)
            .map((entry) => entry.value.severity)
            .fold<int>(0, (sum, value) => sum + value) /
        (recent.where((entry) => entry.value.symptoms.isNotEmpty).length.clamp(1, 7));
    final moodCounts = <String, int>{};
    for (final entry in recent) {
      if (entry.value.mood.isNotEmpty) {
        moodCounts.update(entry.value.mood, (count) => count + 1, ifAbsent: () => 1);
      }
    }
    final topMood = moodCounts.entries.isEmpty
        ? null
        : (moodCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value))).first;
    final cards = <Widget>[
      _patternCard(
        icon: Icons.calendar_today_outlined,
        value: '${recent.length} day${recent.length == 1 ? '' : 's'}',
        caption: 'logged recently',
      ),
      if (topSymptom != null)
        _patternCard(
          icon: Icons.spa_outlined,
          value: topSymptom.key.replaceAll('_', ' '),
          caption: 'most logged symptom',
        ),
      if (recent.any((entry) => entry.value.symptoms.isNotEmpty))
        _patternCard(
          icon: Icons.monitor_heart_outlined,
          value: averageSeverity.toStringAsFixed(1),
          caption: 'average intensity · 1–5',
        ),
      if (topMood != null)
        _patternCard(
          icon: Icons.mood_outlined,
          value: topMood.key,
          caption: 'most logged mood',
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Your patterns', style: titleStyle),
        const SizedBox(height: 4),
        Text('From your 7 most recent logged days', style: TextStyle(fontSize: 12, color: LunoraTokens.inkSoft)),
        const SizedBox(height: 12),
        SizedBox(
          height: 125,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: cards.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, index) => cards[index],
          ),
        ),
      ],
    );
  }

  Widget _patternCard({required IconData icon, required String value, required String caption}) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: LunoraTokens.card, borderRadius: BorderRadius.circular(18), border: Border.all(color: LunoraTokens.line)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: LunoraTokens.purple, size: 20),
          const Spacer(),
          Text(value, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: LunoraTokens.ink)),
          const SizedBox(height: 3),
          Text(caption, maxLines: 2, style: TextStyle(fontSize: 11, color: LunoraTokens.inkSoft)),
        ],
      ),
    );
  }

  Widget _resourceSection(String title, List<InsightsEntry> entries, IconData icon, Color accent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: LunoraTokens.ink)),
        const SizedBox(height: 10),
        ...entries.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Material(
                color: LunoraTokens.card,
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => _openSource(entry),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: LunoraTokens.line)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(color: accent.withValues(alpha: .12), borderRadius: BorderRadius.circular(13)),
                          child: Icon(icon, color: accent, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(entry.title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: LunoraTokens.ink, height: 1.3)),
                              const SizedBox(height: 5),
                              Text(entry.summary, style: TextStyle(fontSize: 12, color: LunoraTokens.inkSoft, height: 1.4)),
                              const SizedBox(height: 8),
                              Text('${entry.publisher} · ${entry.date}', style: TextStyle(fontSize: 10.5, color: accent, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.open_in_new, color: LunoraTokens.inkPale, size: 17),
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Future<void> _openSource(InsightsEntry entry) async {
    final uri = Uri.parse(entry.url);
    if (await launchUrl(uri, mode: LaunchMode.externalApplication)) return;
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Could not open this source.')),
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
                        const Icon(Icons.check_circle,
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
