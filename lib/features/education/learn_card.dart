import 'package:flutter/material.dart';

import '../../content/education.dart';
import '../../core/theme/lunora_tokens.dart';

class LearnCard extends StatelessWidget {
  const LearnCard({
    super.key,
    required this.card,
    required this.isRead,
    required this.onTap,
  });

  final EducationCard card;
  final bool isRead;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 230,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: LunoraTokens.card,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: LunoraTokens.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _categoryPill(card.category),
                const Spacer(),
                if (isRead)
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: LunoraTokens.success,
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              card.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                height: 1.3,
                color: LunoraTokens.ink,
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Text(
                card.summary,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.5,
                  color: LunoraTokens.inkSoft,
                  height: 1.45,
                ),
              ),
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
        color: LunoraTokens.lavender,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        labels[category] ?? category,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
          color: LunoraTokens.ink,
        ),
      ),
    );
  }
}
