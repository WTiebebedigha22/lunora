# v1.0 ship checklist

Do not ship v1.0 until every item is ✅.

## Legal
- [ ] Privacy policy filled in with real contact email and date
- [ ] Terms of service filled in with real contact email and date
- [ ] Medical disclaimer reviewed by a clinician (see
      CLINICIAN_REVIEW.md)
- [ ] Legal docs published somewhere permanent (website, GitHub Pages,
      or included in-app)

## Privacy
- [ ] PRIVACY_AUDIT.md fully complete
- [ ] Zero third-party SDKs other than what's listed in audit
- [ ] No permissions requested that aren't used

## Accessibility
- [ ] ACCESSIBILITY_AUDIT.md fully complete
- [ ] App usable with TalkBack and VoiceOver
- [ ] All charts readable in greyscale

## Content
- [ ] All education cards reviewed by a clinician
- [ ] No education card contains dosing advice
- [ ] Medical disclaimer appears on onboarding, settings, PDF, and
      education detail

## Technical
- [ ] `flutter analyze` returns zero issues
- [ ] Version bumped to 1.0.0+1 in pubspec.yaml
- [ ] App icon generated (flutter_launcher_icons)
- [ ] Splash screen generated (flutter_native_splash)
- [ ] Signed build produced for both platforms
- [ ] Backup of signing keys in a secure location
- [ ] Test install on a clean device (uninstall + fresh install)
- [ ] Test onboarding → log → export PDF → clear → uninstall →
      reinstall → onboarding again

## Store
- [ ] Store listing copy reviewed by someone outside your head
- [ ] Screenshots taken from the actual app
- [ ] Age rating set appropriately (17+)
- [ ] Category: Health & Fitness

## Beta
- [ ] BETA_PLAN.md fully executed
- [ ] 14+ days of beta data collected
- [ ] 0 critical issues
- [ ] At least 1 tester said they'd keep using it

## Final
- [ ] Someone you trust who has not been involved in building this
      reads the app for 20 minutes and tells you what's confusing
- [ ] You personally would use this app if you had PCOS (be honest)
- [ ] Your loved one says she'd recommend it to a friend with PCOS
