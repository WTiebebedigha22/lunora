# Phase 2B / 2C

## New deps
- fl_chart: ^0.69.0
- pdf: ^3.11.1
- printing: ^5.13.2

## New UI
- History tab: segment control (Log / Trends)
- Trends segment: 30d / 90d / 180d window, symptom bar chart,
  severity line chart, adherence bars
- Settings tab: Doctor reports section, 30/90/180 window, Preview + Export

## PDF export notes
- Uses `printing` package — works on Android/iOS/Windows/macOS/Linux
- On Windows, "Export PDF" opens the system print dialog (choose
  "Microsoft Print to PDF")
- Report excludes the "likely window" band by design — descriptive only
- Every page has a disclaimer footer

## Non-negotiables enforced
- No ovulation / fertile window anywhere
- No single-day period prediction
- No causal language in charts, PDF, or UI copy
