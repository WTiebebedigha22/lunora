# Phase 2D — Education content

## What ships
- 12 bundled clinician-sourced education cards
- Learn section on Today tab (Article of the day + Next up)
- Detail modal with Read / Dismiss
- Read + dismissed state persisted in LunoraState.education
- Dismissed cards never resurface

## Content rules (enforced in code comments and copy review)
- Plain language, ~8th grade reading
- No dosing advice, no supplement promotions, no product links
- No causal claims ("X fixes Y")
- Every card UI footer: "Talk to your clinician before making changes
  to your care plan."

## Rotation
- Article of the day rotates by day-of-year modulo visible card count
- Next up = first unread visible card that isn't article of the day
- If all cards dismissed: "More coming soon — check back."

## No network
- Entirely bundled. Zero HTTP. Works offline.

## Persistence
- education.readIds[] and education.dismissedIds[] persist across
  launches via the same Hive box.
- Reset-onboarding preserves education progress.

## Version
- Bumped to v0.3.0 in Settings footer
