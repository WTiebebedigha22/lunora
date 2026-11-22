# Lunora

A PCOS-first wellness tracker. Not a period tracker with extra screens.

## What it is

- Log symptoms across hormonal, metabolic, mental, and cycle categories
- Track medications and supplements
- Record cycles as ranges — irregularity is expected, not an error
- See cycle-length trends over time
- Export a doctor-ready PDF summary
- Read clinician-sourced education cards offline

## What it is not

- Not a medical device
- Not a diagnostic tool
- Not a fertility predictor
- Not a weight-loss app

## Status

**v0.3.0 — Phase 1 + 2 complete.** Not yet published.
See [`docs/PUBLISH_PLAN.md`](docs/PUBLISH_PLAN.md) for the path to 1.0.

## Privacy

All data is local-only. No accounts, no cloud, no analytics, no ads.
See [`legal/PRIVACY_POLICY.md`](legal/PRIVACY_POLICY.md).

## Tech stack

- **Flutter** (Dart 3.5+) — single codebase, Android + iOS
- **Hive** — local key-value storage, no backend
- **fl_chart** — cycle and symptom visualizations
- **pdf** + **printing** — doctor-ready PDF export
- **flutter_localizations** — EN / ES / FR / AR

## Project structure

```
lib/
├── core/
│   ├── storage/        # Hive adapters, LunoraStore
│   └── theme/          # Tokens, schemes, shared widgets
├── features/
│   ├── onboarding/     # First-run flow
│   ├── history/        # Cycle and symptom trends
│   ├── symptoms/       # Log sheet
│   ├── cycle/          # Cycle stats
│   └── settings/       # Preferences, reports, data
├── shared/
│   └── models/         # LunoraState, DayLog, Cycle, SymptomCatalog
├── l10n/               # ARB files + generated localizations
└── main.dart
```

## Running locally

### Prerequisites

- Flutter 3.32+ (`flutter --version`)
- Dart 3.5+

### Setup

```bash
git clone <repo-url> lunora
cd lunora
flutter pub get
flutter gen-l10n        # required — generates lib/l10n/app_localizations.dart
flutter run
```

### Localization

If you change anything under `lib/l10n/*.arb`, regenerate before running:

```bash
flutter gen-l10n
```

The generated class is `LunoraLocalizations` (configured in `l10n.yaml`). Never edit files under `lib/l10n/app_localizations*.dart` by hand — they are overwritten.

### Common issues

| Symptom | Fix |
|---|---|
| `Type 'LunoraLocalizations' not found` | Run `flutter gen-l10n`, then `flutter clean && flutter pub get` |
| `AppLocalizations` undefined | Old import — use `import 'package:lunora/l10n/app_localizations.dart';` |
| Gradle build fails after config change | `flutter clean && flutter pub get` |

## Testing

```bash
flutter test                      # unit + widget tests
flutter analyze                   # static analysis
```

## Building

```bash
# Debug APK
flutter build apk --debug

# Release APK (requires signing config)
flutter build apk --release

# iOS (macOS only)
flutter build ios --release
```

## Contributing

This is a personal project in active development. Issues and PRs are welcome — please open an issue first to discuss scope.

1. Fork and branch from `main`
2. Run `flutter analyze && flutter test` before pushing
3. Keep PRs focused — one feature or fix per PR

## License

Not yet chosen. Treat as all-rights-reserved until a `LICENSE` file is added.

## Medical disclaimer

Lunora is a tracking tool, not a medical device. It does not diagnose, treat, or predict any condition. Cycle ranges shown are descriptive statistics of user-logged data. Lunora does not predict ovulation, fertile windows, or future period dates. Always consult a qualified clinician for medical advice.
```
