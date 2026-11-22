import 'package:flutter/material.dart';

import 'core/theme/lunora_components.dart';
import 'core/theme/lunora_schemes.dart';
import 'core/theme/lunora_theme.dart';
import 'core/theme/lunora_tokens.dart';
import 'core/storage/lunora_store.dart';
import 'l10n/app_localizations.dart';
import 'shared/models/lunora_state.dart';
import 'shared/models/theme_preferences.dart';
import 'features/onboarding/onboarding_flow.dart';
import 'features/dashboard/today_screen.dart';
import 'features/cycle/cycle_screen.dart';
import 'features/history/history_screen.dart';
import 'features/insights/insights_screen.dart';
import 'features/settings/settings_screen.dart';

class LunoraApp extends StatefulWidget {
  const LunoraApp({super.key});

  @override
  State<LunoraApp> createState() => _LunoraAppState();
}

class _LunoraAppState extends State<LunoraApp> {
  late LunoraState _state;

  @override
  void initState() {
    super.initState();
    _state = LunoraStore.load();
  }

  Future<void> _update(LunoraState next) async {
    setState(() => _state = next);
    await LunoraStore.save(next);
  }

  Brightness _resolveBrightness(ThemePreferences prefs) {
    switch (prefs.mode) {
      case 'light':
        return Brightness.light;
      case 'dark':
        return Brightness.dark;
      case 'system':
      default:
        return WidgetsBinding.instance.platformDispatcher.platformBrightness;
    }
  }

  Locale? _resolveLocale(ThemePreferences prefs) {
    if (prefs.localeCode == 'system') return null;
    return Locale(prefs.localeCode);
  }

  @override
  Widget build(BuildContext context) {
    final prefs = _state.theme;
    final brightness = _resolveBrightness(prefs);
    final light = LunoraSchemes.byId(prefs.schemeId);
    final dark = LunoraDarkSchemes.byId(prefs.schemeId);
    final active = brightness == Brightness.dark ? dark : light;

    LunoraTokens.apply(active, brightness);

    return MaterialApp(
      onGenerateTitle: (ctx) => LunoraLocalizations.of(ctx).appTitle,
      debugShowCheckedModeBanner: false,
      theme: LunoraTheme.build(
        scheme: light,
        brightness: Brightness.light,
      ),
      darkTheme: LunoraTheme.build(
        scheme: dark,
        brightness: Brightness.dark,
      ),
      themeMode: prefs.mode == 'light'
          ? ThemeMode.light
          : prefs.mode == 'dark'
              ? ThemeMode.dark
              : ThemeMode.system,
      locale: _resolveLocale(prefs),
      localizationsDelegates: LunoraLocalizations.localizationsDelegates,
      supportedLocales: LunoraLocalizations.supportedLocales,
      home: !_state.isOnboarded
          ? OnboardingFlow(
              onDone: (profile) => _update(
                _state.copyWith(onboarding: profile),
              ),
            )
          : _HomeShell(
              state: _state,
              onUpdate: _update,
            ),
    );
  }
}

class _HomeShell extends StatefulWidget {
  const _HomeShell({required this.state, required this.onUpdate});
  final LunoraState state;
  final Future<void> Function(LunoraState) onUpdate;

  @override
  State<_HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<_HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final l = LunoraLocalizations.of(context);

    final pages = [
      TodayScreen(state: widget.state, onUpdate: widget.onUpdate),
      CycleScreen(state: widget.state, onUpdate: widget.onUpdate),
      HistoryScreen(state: widget.state),
      InsightsScreen(state: widget.state, onUpdate: widget.onUpdate),
      SettingsScreen(
        state: widget.state,
        onUpdate: widget.onUpdate,
        onResetOnboarding: () async {
          await widget.onUpdate(LunoraState(
            logs: widget.state.logs,
            meds: widget.state.meds,
            cycles: widget.state.cycles,
            education: widget.state.education,
            theme: widget.state.theme,
          ));
        },
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: LunoraBottomBar(
        index: _index,
        onTap: (i) => setState(() => _index = i),
        items: [
          LunoraBottomBarItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            label: l.navHome,
          ),
          LunoraBottomBarItem(
            icon: Icons.calendar_month_outlined,
            activeIcon: Icons.calendar_month,
            label: l.navCycle,
          ),
          LunoraBottomBarItem(
            icon: Icons.list_alt_outlined,
            activeIcon: Icons.list_alt,
            label: l.navHistory,
          ),
          LunoraBottomBarItem(
            icon: Icons.menu_book_outlined,
            activeIcon: Icons.menu_book,
            label: l.navInsights,
          ),
          LunoraBottomBarItem(
            icon: Icons.settings_outlined,
            activeIcon: Icons.settings,
            label: l.navSettings,
          ),
        ],
      ),
    );
  }
}
