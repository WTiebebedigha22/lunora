import 'package:material_ui/material_ui.dart';

import '../../core/storage/lunora_store.dart';
import '../../core/theme/lunora_schemes.dart';
import '../../core/theme/lunora_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/models/lunora_state.dart';
import '../../shared/models/avatar_catalog.dart';
import 'demo_data_screen.dart';
import 'report_generator.dart';
import 'notification_settings_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.state,
    required this.onUpdate,
    required this.onResetOnboarding,
  });

  final LunoraState state;
  final Future<void> Function(LunoraState) onUpdate;
  final Future<void> Function() onResetOnboarding;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _reportWindow = 30;
  bool _busy = false;

  Future<void> _updateTheme({
    String? mode,
    String? schemeId,
    String? localeCode,
  }) async {
    final next = widget.state.theme.copyWith(
      mode: mode,
      schemeId: schemeId,
      localeCode: localeCode,
    );
    await widget.onUpdate(widget.state.copyWith(theme: next));
  }

  Future<void> _clearAll() async {
    final l = AppLocalizations.of(context)!;
    final confirmed = await _confirmDialog(
      title: l.clearAllData,
      body: l.clearAllSubtitle,
      confirmLabel: l.clearAllData,
    );
    if (confirmed != true) return;
    await LunoraStore.clear();
    await widget.onUpdate(LunoraState.empty());
  }

  Future<void> _resetOnboarding() async {
    final l = AppLocalizations.of(context)!;
    final ok = await _confirmDialog(
      title: l.rerunOnboarding,
      body: l.rerunSubtitle,
      confirmLabel: l.continueButton,
    );
    if (ok != true) return;
    await widget.onResetOnboarding();
  }

  Future<void> _previewReport() async {
    setState(() => _busy = true);
    try {
      await ReportGenerator.preview(
        state: widget.state,
        windowDays: _reportWindow,
        l10n: AppLocalizations.of(context)!,
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _shareReport() async {
    setState(() => _busy = true);
    try {
      await ReportGenerator.generateAndShare(
        state: widget.state,
        windowDays: _reportWindow,
        l10n: AppLocalizations.of(context)!,
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<bool?> _confirmDialog({
    required String title,
    required String body,
    required String confirmLabel,
  }) {
    final l = AppLocalizations.of(context)!;
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            Text(l.settingsTitle,
                style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 24),
            if (widget.state.onboarding != null) ...[
              _avatarCard(),
              const SizedBox(height: 24),
            ],

            // ── Appearance ────────────────────────────
            _sectionLabel(l.appearanceSection),
            _themeModeCard(l),
            const SizedBox(height: 10),
            _colorSchemeCard(l),
            const SizedBox(height: 10),
            _languageCard(l),

            const SizedBox(height: 28),
            _sectionLabel('Reminders & support'),
            NotificationSettingsCard(
              preferences: widget.state.notifications,
              onChanged: (preferences) => widget.onUpdate(
                widget.state.copyWith(notifications: preferences),
              ),
            ),

            const SizedBox(height: 28),

            // ── Doctor reports ────────────────────────
            _sectionLabel(l.doctorReportsSection),
            _reportsCard(l),

            const SizedBox(height: 28),

            // ── Data ──────────────────────────────────
            _sectionLabel(l.dataSection),
            _settingsRow(
              title: l.loadDemoData,
              subtitle: l.loadDemoSubtitle,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => DemoDataScreen(
                    state: widget.state,
                    onUpdate: widget.onUpdate,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            _settingsRow(
              title: l.rerunOnboarding,
              subtitle: l.rerunSubtitle,
              onTap: _resetOnboarding,
            ),
            const SizedBox(height: 8),
            _settingsRow(
              title: l.clearAllData,
              subtitle: l.clearAllSubtitle,
              onTap: _clearAll,
              danger: true,
            ),

            const SizedBox(height: 28),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: LunoraTokens.purplePale,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                l.medicalDisclaimer,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: LunoraTokens.ink,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Lunora v0.5.0',
                style: TextStyle(
                  color: LunoraTokens.inkPale,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatarCard() {
    final profile = widget.state.onboarding!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LunoraTokens.card,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: LunoraTokens.purplePale,
                child: Text(AvatarCatalog.glyph(profile.avatar),
                    style: const TextStyle(fontSize: 29)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your avatar',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: LunoraTokens.ink)),
                    const SizedBox(height: 2),
                    Text('Choose a portrait that feels like you',
                        style: TextStyle(
                            fontSize: 12, color: LunoraTokens.inkSoft)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(AvatarCatalog.options.length, (index) {
              final selected = profile.avatar == index;
              return GestureDetector(
                onTap: () async {
                  final updatedProfile = OnboardingProfile(
                    goal: profile.goal,
                    lastPeriod: profile.lastPeriod,
                    priorities: profile.priorities,
                    avatar: index,
                    onboardedAt: profile.onboardedAt,
                  );
                  await widget.onUpdate(
                      widget.state.copyWith(onboarding: updatedProfile));
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 43,
                  height: 43,
                  decoration: BoxDecoration(
                    color: selected ? LunoraTokens.purpleSoft : LunoraTokens.bg,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color:
                            selected ? LunoraTokens.purple : LunoraTokens.line,
                        width: selected ? 2 : 1),
                  ),
                  child: Center(
                      child: Text(AvatarCatalog.glyph(index),
                          style: const TextStyle(fontSize: 24))),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
          color: LunoraTokens.inkSoft,
        ),
      ),
    );
  }

  Widget _themeModeCard(AppLocalizations l) {
    final modes = ['light', 'dark', 'system'];
    final labels = [l.themeLight, l.themeDark, l.themeSystem];
    final icons = [
      Icons.light_mode_outlined,
      Icons.dark_mode_outlined,
      Icons.brightness_auto_outlined,
    ];
    final active = widget.state.theme.mode;

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: LunoraTokens.subtle,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: List.generate(3, (i) {
          final on = active == modes[i];
          return Expanded(
            child: GestureDetector(
              onTap: () => _updateTheme(mode: modes[i]),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: on ? LunoraTokens.card : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icons[i],
                      size: 16,
                      color: on ? LunoraTokens.purple : LunoraTokens.inkSoft,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        labels[i],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: on ? FontWeight.w600 : FontWeight.w500,
                          color: on ? LunoraTokens.ink : LunoraTokens.inkSoft,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _colorSchemeCard(AppLocalizations l) {
    final active = widget.state.theme.schemeId;
    final labels = [
      l.schemePurple,
      l.schemePink,
      l.schemeBlue,
      l.schemeRed,
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LunoraTokens.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: LunoraTokens.line),
      ),
      child: Row(
        children: List.generate(LunoraSchemes.all.length, (i) {
          final s = LunoraSchemes.all[i];
          final on = s.id == active;
          return Expanded(
            child: GestureDetector(
              onTap: () => _updateTheme(schemeId: s.id),
              child: Padding(
                padding: EdgeInsets.only(right: i == 3 ? 0 : 8),
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 44,
                      decoration: BoxDecoration(
                        color: s.primary,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: on ? s.primaryDeep : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: on
                          ? const Icon(Icons.check,
                              color: Colors.white, size: 20)
                          : null,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      labels[i],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: on ? FontWeight.w600 : FontWeight.w500,
                        color: on ? LunoraTokens.ink : LunoraTokens.inkSoft,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _languageCard(AppLocalizations l) {
    final active = widget.state.theme.localeCode;
    final options = [
      ('system', l.languageSystem, '🌐'),
      ('en', l.languageEnglish, 'EN'),
      ('es', l.languageSpanish, 'ES'),
      ('fr', l.languageFrench, 'FR'),
      ('ar', l.languageArabic, 'AR'),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LunoraTokens.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: LunoraTokens.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.languageLabel,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: LunoraTokens.inkSoft,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((o) {
              final on = active == o.$1;
              return GestureDetector(
                onTap: () => _updateTheme(localeCode: o.$1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: on ? LunoraTokens.purpleSoft : LunoraTokens.card,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: on ? LunoraTokens.purple : LunoraTokens.line,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        o.$3,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: on
                              ? LunoraTokens.purpleDeep
                              : LunoraTokens.inkSoft,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        o.$2,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: on ? FontWeight.w600 : FontWeight.w500,
                          color:
                              on ? LunoraTokens.purpleDeep : LunoraTokens.ink,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _reportsCard(AppLocalizations l) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LunoraTokens.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: LunoraTokens.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.doctorReportsTitle,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: LunoraTokens.ink,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l.doctorReportsBody,
            style: TextStyle(
              fontSize: 12,
              color: LunoraTokens.inkSoft,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [30, 90, 180].map((d) {
              final on = _reportWindow == d;
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: GestureDetector(
                  onTap: () => setState(() => _reportWindow = d),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: on ? LunoraTokens.purpleSoft : LunoraTokens.card,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: on ? LunoraTokens.purple : LunoraTokens.line,
                      ),
                    ),
                    child: Text(
                      '${d}d',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color:
                            on ? LunoraTokens.purpleDeep : LunoraTokens.inkSoft,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _busy ? null : _previewReport,
                  child: Text(l.preview),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: _busy ? null : _shareReport,
                  child: Text(_busy ? l.working : l.exportPdf),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _settingsRow({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool danger = false,
  }) {
    return Material(
      color: LunoraTokens.card,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: danger ? LunoraTokens.warn : LunoraTokens.line,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: danger ? LunoraTokens.warn : LunoraTokens.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: LunoraTokens.inkSoft,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: LunoraTokens.inkPale,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
