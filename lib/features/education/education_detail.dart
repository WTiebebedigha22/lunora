// DEPRECATED — kept for Today screen Learn section.
// The full-page version is education_detail_page.dart.
// Migrate Today to the new page in a future wave.
import 'package:flutter/material.dart';

import '../../content/education.dart';
import '../../core/theme/lunora_tokens.dart';

class EducationDetail extends StatelessWidget {
  const EducationDetail({
    super.key,
    required this.card,
    required this.isRead,
    required this.onRead,
    required this.onDismiss,
  });

  final EducationCard card;
  final bool isRead;
  final VoidCallback onRead;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(LunoraTokens.spaceLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                _categoryPill(card.category),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            SizedBox(height: LunoraTokens.spaceSm),
            Text(
              card.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                height: 1.25,
              ),
            ),
            SizedBox(height: LunoraTokens.spaceSm),
            Text(
              card.summary,
              style: TextStyle(
                fontSize: 14,
                color: LunoraTokens.inkSoft,
                height: 1.45,
              ),
            ),
            SizedBox(height: LunoraTokens.spaceMd),
            Flexible(
              child: SingleChildScrollView(
                child: Text(
                  card.body,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.55,
                  ),
                ),
              ),
            ),
            SizedBox(height: LunoraTokens.spaceMd),
            Container(
              padding: EdgeInsets.all(LunoraTokens.spaceMd),
              decoration: BoxDecoration(
                color: LunoraTokens.lavender,
                borderRadius: BorderRadius.circular(LunoraTokens.radiusMd),
              ),
              child: const Text(
                'Talk to your clinician before making changes to your '
                'care plan.',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.45,
                ),
              ),
            ),
            SizedBox(height: LunoraTokens.spaceMd),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onDismiss,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(46),
                      foregroundColor: LunoraTokens.warn,
                      side: BorderSide(color: LunoraTokens.warn),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(LunoraTokens.radiusMd),
                      ),
                    ),
                    child: const Text('Dismiss'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: isRead ? null : onRead,
                    child: Text(isRead ? 'Read' : 'Mark as read'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryPill(String category) {
    const labels = {
      'hormones': 'Hormones',
      'metabolism': 'Metabolism',
      'mental': 'Mental health',
      'cycle': 'Cycle',
      'care': 'Care',
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: LunoraTokens.pink,
        borderRadius: BorderRadius.circular(LunoraTokens.radiusPill),
      ),
      child: Text(
        labels[category] ?? category,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
