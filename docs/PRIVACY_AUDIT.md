# Privacy audit

Complete before 1.0. Every item must be ✅.

## Data flow inventory
- [ ] List every place the app writes data (Hive box name, key names)
- [ ] Confirm zero network calls exist except: (none — Phase 1/2 have
      none). If you added any, list them here.
- [ ] Confirm the PDF export does not upload the PDF anywhere. It uses
      `Printing.sharePdf` which hands the file to the OS share sheet.
      The OS may route it through a cloud provider if the user chooses
      (Gmail, Drive, etc.). This is expected and controlled by the
      user.

## Third-party SDKs
- [ ] `pubspec.yaml` dependencies reviewed — list every one:
      - `hive_flutter` — local storage only, no network
      - `intl` — date formatting only, no network
      - `fl_chart` — rendering only, no network
      - `pdf` — PDF generation only, no network
      - `printing` — OS share/print only, no network
      - `cupertino_icons` — fonts only
- [ ] Confirm no dependency pulls in Firebase, Sentry, Amplitude,
      Mixpanel, Google Analytics, Facebook SDK, or any ad SDK

## Permissions
- [ ] Android `AndroidManifest.xml` lists only permissions actually
      used. Expected: none in Phase 1/2. If `printing` requires any,
      list them.
- [ ] iOS `Info.plist` lists only usage-description strings actually
      needed.
- [ ] No location, no camera, no contacts, no mic, no photo library
      permission unless a user-initiated feature requires it.

## Storage review
- [ ] Hive box is unencrypted (currently). Acceptable for v1.0 because
      data is device-local. **If you add cloud sync in the future, this
      must become encrypted.** Document the upgrade path.
- [ ] Uninstalling the app deletes the Hive box (verify on Android and
      iOS).
- [ ] "Clear all data" in Settings fully clears the box.

## Data deletion
- [ ] Test: log 5 days, hit Clear all data, force-close, reopen —
      confirm onboarding shows and history is empty
- [ ] Test: log 5 days, uninstall, reinstall — confirm onboarding
      shows and history is empty

## Sharing
- [ ] PDF export shares only what the user chose to export
- [ ] No automatic sharing, no "share your progress" prompts in v1.0

## Analytics decision
- [ ] Choose one and write it here:
      [ ] No analytics (recommended for v1.0)
      [ ] Self-hosted, aggregate-only, opt-in (must be added later)
      [ ] Third-party — must be documented in Privacy Policy
