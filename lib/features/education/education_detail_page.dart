import 'package:flutter/material.dart';

import '../../content/education.dart';
import '../../core/theme/lunora_components.dart';
import '../../core/theme/lunora_tokens.dart';
import '../../shared/models/lunora_state.dart';
import 'illustration.dart';

class EducationDetailPage extends StatefulWidget {
  const EducationDetailPage({
    super.key,
    required this.card,
    required this.state,
    required this.onUpdate,
  });

  final EducationCard card;
  final LunoraState state;
  final Future<void> Function(LunoraState) onUpdate;

  @override
  State<EducationDetailPage> createState() => _EducationDetailPageState();
}

class _EducationDetailPageState extends State<EducationDetailPage> {
  bool _saved = false;
  bool _read = false;

  @override
  void initState() {
    super.initState();
    _saved = widget.state.education.isSaved(widget.card.id);
    _read = widget.state.education.isRead(widget.card.id);

    // Mark as read on open.
    if (!_read) {
      _markRead();
    }
  }

  Future<void> _markRead() async {
    if (widget.state.education.isRead(widget.card.id)) return;
    final next = widget.state.education.copyWith(
      readIds: [...widget.state.education.readIds, widget.card.id],
    );
    await widget.onUpdate(widget.state.copyWith(education: next));
    if (mounted) setState(() => _read = true);
  }

  Future<void> _toggleSave() async {
    final next = _saved
        ? widget.state.education.savedIds
            .where((id) => id != widget.card.id)
            .toList()
        : [...widget.state.education.savedIds, widget.card.id];
    await widget.onUpdate(widget.state.copyWith(
      education: widget.state.education.copyWith(savedIds: next),
    ));
    if (mounted) setState(() => _saved = !_saved);
  }

  @override
  Widget build(BuildContext context) {
    final card = widget.card;
    final s = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.arrow_back_ios_new,
                        size: 20, color: LunoraTokens.ink),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: _toggleSave,
                    icon: Icon(
                      _saved ? Icons.bookmark : Icons.bookmark_border,
                      color: _saved ? LunoraTokens.purple : LunoraTokens.ink,
                    ),
                  ),
                ],
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                card.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                  color: LunoraTokens.ink,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Author line
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: LunoraTokens.purplePale,
                      shape: BoxShape.circle,
                    ),
                    child:
                        Icon(Icons.eco, size: 14, color: LunoraTokens.purple),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'by Lunora Editorial  ·  ${card.readMinutes} min read',
                      style: TextStyle(
                        fontSize: 12,
                        color: LunoraTokens.inkSoft,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Big illustration
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: EducationIllustration(
                category: card.category,
                size: s.width - 40,
              ),
            ),
            const SizedBox(height: 24),

            // Top things to know
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: LunoraTokens.purplePale,
                  borderRadius: BorderRadius.circular(LunoraTokens.radiusLg),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Top things to know',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: LunoraTokens.ink,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...card.keyPoints.map(
                      (p) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Icon(Icons.circle,
                                  size: 5, color: LunoraTokens.purple),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                p,
                                style: TextStyle(
                                  fontSize: 13.5,
                                  height: 1.5,
                                  color: LunoraTokens.ink,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Body
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                card.body,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.65,
                  color: LunoraTokens.ink,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Footer disclaimer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: LunoraTokens.subtle,
                  borderRadius: BorderRadius.circular(LunoraTokens.radiusMd),
                ),
                child: Text(
                  'Talk to your clinician before making changes to your '
                  'care plan. Lunora is a tracking tool, not a medical '
                  'device.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.5,
                    color: LunoraTokens.inkSoft,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
