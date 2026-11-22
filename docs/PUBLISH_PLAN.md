# Lunora — publish plan

## Why this exists
Lunora is being built for someone real, with PCOS, who will actually
use it. That changes the priorities. This document is the plan to get
from "working app" to "shipped app that is safe to hand to her."

## Phases

### Now (Week 1–2): Dogfood + her feedback
- Use Lunora yourself for 7 days, logging every day.
- Get her using it for 7 days.
- Collect feedback in `docs/FEEDBACK_ROUND1.md`.
- Do not add features during this phase.

### Week 3–4: Fix what feedback surfaces
- Scope Phase 3 tightly to the top 3 requests.
- No "insights," "streaks," or "correlation" unless a user asks.
- Fix bugs first.

### Week 5–6: Publish readiness
- Complete all docs in this folder.
- Clinician review of education content.
- Store listing, screenshots, signing, version bump.
- Beta with 3–5 users for 2 weeks.

### Week 7+: v1.0 launch
- Only after beta users have used it 14+ days without a critical issue.

## What this app is NOT allowed to do before 1.0
- No account system. Local-only. If you add accounts later, add
  end-to-end encryption *before* the accounts, not after.
- No analytics that identify users. Aggregate + opt-in only, if any.
- No ads.
- No in-app purchases in v1.0. Free tool.
- No AI. Not now, not later without a dedicated safety review.
- No ovulation prediction. Ever.
- No weight-loss claims. Ever.
- No "streak breaking" mechanics. Ever.
