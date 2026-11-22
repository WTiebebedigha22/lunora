import 'package:flutter/material.dart';

import 'lunora_tokens.dart';

class LunoraCard extends StatelessWidget {
  const LunoraCard({
    super.key,
    required this.child,
    this.color,
    this.padding = const EdgeInsets.all(20),
    this.onTap,
    this.margin,
  });

  final Widget child;
  final Color? color;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    final bg = color ?? LunoraTokens.card;
    final content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(LunoraTokens.radiusLg),
        border: Border.all(color: LunoraTokens.line),
      ),
      child: child,
    );

    if (onTap == null) {
      return margin == null
          ? content
          : Padding(padding: margin!, child: content);
    }

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(LunoraTokens.radiusLg),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(LunoraTokens.radiusLg),
          child: content,
        ),
      ),
    );
  }
}

class LunoraEyebrow extends StatelessWidget {
  const LunoraEyebrow(this.text, {super.key, this.color});
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
        color: color ?? LunoraTokens.inkSoft,
      ),
    );
  }
}

class LunoraSectionHeader extends StatelessWidget {
  const LunoraSectionHeader({
    super.key,
    required this.title,
    this.action,
    this.padding = const EdgeInsets.only(top: 8, bottom: 12),
  });

  final String title;
  final Widget? action;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: LunoraTokens.ink,
                height: 1.3,
              ),
            ),
          ),
          if (action != null) action!,
        ],
      ),
    );
  }
}

class LunoraGradientButton extends StatelessWidget {
  const LunoraGradientButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.height = 52,
  });

  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LunoraTokens.primaryGradient,
          borderRadius: BorderRadius.circular(LunoraTokens.radiusPill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LunoraPill extends StatelessWidget {
  const LunoraPill({
    super.key,
    required this.label,
    this.icon,
    this.active = false,
    this.onTap,
  });

  final String label;
  final String? icon;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: active ? LunoraTokens.purpleSoft : LunoraTokens.card,
          borderRadius: BorderRadius.circular(LunoraTokens.radiusPill),
          border: Border.all(
            color: active ? LunoraTokens.purple : LunoraTokens.line,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Text(icon!, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: active ? LunoraTokens.purpleDeep : LunoraTokens.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LunoraWeekStrip extends StatelessWidget {
  const LunoraWeekStrip({
    super.key,
    required this.selectedDate,
    this.onSelect,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime>? onSelect;

  @override
  Widget build(BuildContext context) {
    final monday = selectedDate.subtract(
      Duration(days: (selectedDate.weekday - 1)),
    );
    const dayLetters = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (i) {
        final d = monday.add(Duration(days: i));
        final selected = d.year == selectedDate.year &&
            d.month == selectedDate.month &&
            d.day == selectedDate.day;

        return Expanded(
          child: GestureDetector(
            onTap: onSelect == null ? null : () => onSelect!(d),
            child: Column(
              children: [
                Text(
                  dayLetters[i],
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: LunoraTokens.inkSoft,
                  ),
                ),
                const SizedBox(height: 6),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 36,
                  height: 48,
                  decoration: BoxDecoration(
                    color:
                        selected ? LunoraTokens.purpleSoft : LunoraTokens.card,
                    borderRadius:
                        BorderRadius.circular(LunoraTokens.radiusPill),
                    border: Border.all(
                      color: selected ? LunoraTokens.purple : LunoraTokens.line,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${d.day}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color:
                          selected ? LunoraTokens.purpleDeep : LunoraTokens.ink,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 16,
                  height: 2,
                  decoration: BoxDecoration(
                    color: selected ? LunoraTokens.purple : Colors.transparent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class LunoraModeTabs extends StatelessWidget {
  const LunoraModeTabs({
    super.key,
    required this.labels,
    required this.index,
    required this.onChange,
  });

  final List<String> labels;
  final int index;
  final ValueChanged<int> onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: LunoraTokens.subtle,
        borderRadius: BorderRadius.circular(LunoraTokens.radiusPill),
      ),
      child: Row(
        children: List.generate(labels.length, (i) {
          final active = i == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChange(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: active ? LunoraTokens.card : Colors.transparent,
                  borderRadius: BorderRadius.circular(LunoraTokens.radiusPill),
                ),
                child: Center(
                  child: Text(
                    labels[i],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                      color: active ? LunoraTokens.ink : LunoraTokens.inkSoft,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class LunoraEmptyState extends StatelessWidget {
  const LunoraEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return LunoraCard(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: LunoraTokens.purplePale,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: LunoraTokens.purple, size: 26),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: LunoraTokens.ink,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.5,
              color: LunoraTokens.inkSoft,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class LunoraBottomBar extends StatelessWidget {
  const LunoraBottomBar({
    super.key,
    required this.index,
    required this.onTap,
    required this.items,
  });

  final int index;
  final void Function(int) onTap;
  final List<LunoraBottomBarItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      decoration: BoxDecoration(
        color: LunoraTokens.bg,
        border: Border(
          top: BorderSide(color: LunoraTokens.line, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: List.generate(items.length, (i) {
            final item = items[i];
            final active = i == index;
            return Expanded(
              child: GestureDetector(
                onTap: () => onTap(i),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        active ? item.activeIcon : item.icon,
                        size: 22,
                        color:
                            active ? LunoraTokens.purple : LunoraTokens.inkPale,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          color: active
                              ? LunoraTokens.purple
                              : LunoraTokens.inkPale,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class LunoraBottomBarItem {
  const LunoraBottomBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
}

class LunoraHomeHeader extends StatelessWidget {
  const LunoraHomeHeader({
    super.key,
    required this.greeting,
    required this.date,
    this.onProfileTap,
  });

  final String greeting;
  final String date;
  final VoidCallback? onProfileTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: LunoraTokens.ink,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.eco_outlined,
            color: LunoraTokens.bg,
            size: 20,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: LunoraTokens.ink,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                date,
                style: TextStyle(
                  fontSize: 13,
                  color: LunoraTokens.inkSoft,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onProfileTap,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: LunoraTokens.ink.withValues(alpha: 0.7),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              color: LunoraTokens.bg,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }
}
