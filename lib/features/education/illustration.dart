import 'package:flutter/material.dart';

/// Soft colored illustration panel for education cards.
/// Uses a big glyph and soft color; no image assets required.
class EducationIllustration extends StatelessWidget {
  const EducationIllustration({
    super.key,
    required this.category,
    this.size = 100,
    this.glyph,
    this.rounded = true,
  });

  final String category;
  final double size;
  final String? glyph;
  final bool rounded;

  static const Map<String, (Color, Color, String)> _styles = {
    'hormones': (Color(0xFFFDEEF2), Color(0xFFE8A9B8), '❋'),
    'metabolism': (Color(0xFFEEF5F9), Color(0xFF7A93B8), '✿'),
    'mental': (Color(0xFFF3EAF8), Color(0xFFB481D9), '❀'),
    'cycle': (Color(0xFFFBEAEE), Color(0xFFE07A9C), '❁'),
    'care': (Color(0xFFEFF4EC), Color(0xFF7BB89A), '✤'),
  };

  @override
  Widget build(BuildContext context) {
    final s = _styles[category] ?? _styles['hormones']!;
    final bg = s.$1;
    final fg = s.$2;
    final g = glyph ?? s.$3;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg,
        borderRadius:
            rounded ? BorderRadius.circular(size * 0.15) : BorderRadius.zero,
      ),
      alignment: Alignment.center,
      child: Text(
        g,
        style: TextStyle(
          fontSize: size * 0.45,
          color: fg,
          fontWeight: FontWeight.w400,
          height: 1,
        ),
      ),
    );
  }
}
