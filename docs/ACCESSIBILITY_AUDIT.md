# Accessibility audit

Run through this before 1.0. Every row must be ✅ or have a written
justification for why it's deferred.

## Screen reader (TalkBack / VoiceOver)
- [ ] Onboarding: every screen announces title + body + buttons
- [ ] Today screen: all cards have semantic labels
- [ ] Cycle calendar: each day announces date + state (logged / in
      cycle / likely window / empty)
- [ ] Calendar month navigation buttons announce "Previous month" and
      "Next month"
- [ ] Symptom log sheet: each symptom pill announces "symptom name,
      selected / not selected"
- [ ] Severity 1–5 buttons announce "severity N"
- [ ] Medication rows announce name + taken state
- [ ] Charts (Trends): bars have accessible labels for values
- [ ] Bottom nav: 4 tabs each announce their label

## Text / contrast
- [ ] All body text passes WCAG AA (4.5:1)
- [ ] Placeholder text passes AA (or is clearly placeholders)
- [ ] The "likely window" band remains visible to color-blind users
      (currently uses lavender on white — verify ratio)
- [ ] Charts are readable in greyscale (print the PDF and check)

## Touch targets
- [ ] Every tappable element ≥ 44×44 dp
- [ ] Calendar day cells ≥ 40×40 dp
- [ ] Pills and chips have padding beyond text bounds

## Motion
- [ ] No animations that cannot be disabled (respect system motion
      settings)
- [ ] No flashing or strobing content

## Forms
- [ ] Text fields have labels, not just placeholders
- [ ] Error messages are announced to screen readers
- [ ] Date fields accept typed input, not only date picker

## How to test
- Android: Settings → Accessibility → TalkBack. Navigate the entire
  app using only voice + swipe gestures.
- iOS: Settings → Accessibility → VoiceOver. Same drill.
- Contrast: use `flutter analyze` plus a contrast checker extension
  (e.g. Stark) on any screenshot.
- Greyscale: enable "Color correction: Monochromacy" on Android or
  "Color Filters: Grayscale" on iOS, then look at each chart.

Record issues and fixes here as you go.
