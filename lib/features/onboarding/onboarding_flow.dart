import 'package:flutter/material.dart';

import '../../core/theme/lunora_tokens.dart';
import '../../shared/models/lunora_state.dart';
import '../../shared/models/avatar_catalog.dart';
import '../../shared/models/symptom_catalog.dart';

import 'package:lunora/l10n/app_localizations.dart';
class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key, required this.onDone});
  final ValueChanged<OnboardingProfile> onDone;

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  LunoraLocalizations get l10n => LunoraLocalizations.of(context);

  int _step = 0;
  String? _goal;
  String _lastPeriod = '';
  final Set<String> _priorities = {};
  bool _consent = false;
  int _avatar = 2;

  static const List<String> _goals = [
    'Understand my symptoms',
    'Manage my cycle',
    'Build healthier habits',
    'Track medication',
  ];

  int get _total => 8;

  bool get _canNext {
    switch (_step) {
      case 1:
        return _goal != null;
      case 4:
        return _consent;
      default:
        return true;
    }
  }

  void _next() {
    if (_step < _total - 1) {
      setState(() => _step++);
    } else {
      _finish();
    }
  }

  void _finish() {
    widget.onDone(OnboardingProfile(
      goal: _goalId(_goal ?? _goals.first),
      lastPeriod: _lastPeriod.isEmpty ? null : _lastPeriod,
      priorities: _priorities.toList(),
      avatar: _avatar,
    ));
  }

  String _goalId(String label) {
    switch (label) {
      case 'Understand my symptoms':
        return 'symptoms';
      case 'Manage my cycle':
        return 'cycle';
      case 'Build healthier habits':
        return 'habits';
      case 'Track medication':
        return 'meds';
      default:
        return 'symptoms';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LunoraTokens.bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _buildStep(),
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final h = MediaQuery.of(context).size.height * 0.28;

    return SizedBox(
      height: h + 40,
      child: Stack(
        children: [
          ClipPath(
            clipper: _WaveClipper(),
            child: Container(
              height: h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    LunoraTokens.purpleSoft,
                    LunoraTokens.purple.withValues(alpha: 0.45),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: h * 0.35,
            child: Center(
              child: Text(
                _glyphForStep(),
                style: TextStyle(
                  fontSize: 64,
                  color: LunoraTokens.purpleDeep.withValues(alpha: 0.55),
                  height: 1,
                ),
              ),
            ),
          ),
          if (_step != 4)
            Positioned(
              top: 8,
              right: 16,
              child: TextButton(
                onPressed: _finish,
                style: TextButton.styleFrom(
                  foregroundColor: LunoraTokens.inkSoft,
                ),
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _glyphForStep() {
    switch (_step) {
      case 0:
        return '✿';
      case 1:
        return '❀';
      case 2:
        return '❁';
      case 3:
        return '✤';
      case 4:
        return '❋';
      case 5:
        return '☾';
      case 6:
        return '✧';
      default:
        return '✿';
    }
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_total, (i) {
              final active = i == _step;
              final done = i < _step;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: active ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: active
                      ? LunoraTokens.purple
                      : done
                          ? LunoraTokens.purpleSoft
                          : LunoraTokens.line,
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: _canNext ? _next : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 54,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: _canNext
                    ? LunoraTokens.primaryGradient
                    : LinearGradient(
                        colors: [
                          LunoraTokens.line,
                          LunoraTokens.line,
                        ],
                      ),
                borderRadius: BorderRadius.circular(LunoraTokens.radiusPill),
              ),
              child: Text(
                _step == _total - 1 ? 'Start using Lunora' : 'Continue',
                style: TextStyle(
                  color: _canNext ? Colors.white : LunoraTokens.inkPale,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: _finish,
            style: TextButton.styleFrom(
              foregroundColor: LunoraTokens.inkSoft,
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
            child: const Text(
              'Continue with free — always',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _screen(
          title: 'Welcome to Lunora',
          body: 'A PCOS-first wellness companion. Not a period tracker with '
              'extra screens.',
        );
      case 1:
        return _screen(
          title: 'What brings you here?',
          body: 'Pick the one that matters most right now.',
          content: Column(
            children: _goals.map((g) {
              final selected = _goal == g;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _optionPill(
                  label: g,
                  glyph: _glyphForGoal(g),
                  selected: selected,
                  onTap: () => setState(() => _goal = g),
                ),
              );
            }).toList(),
          ),
        );
      case 2:
        return _screen(
          title: 'When did your last period start?',
          body: 'Approximate is fine. PCOS cycles vary — that is expected '
              'here.',
          content: Column(
            children: [
              TextField(
                onChanged: (v) => setState(() => _lastPeriod = v.trim()),
                decoration: InputDecoration(
                  hintText: 'YYYY-MM-DD',
                  filled: true,
                  fillColor: LunoraTokens.card,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(LunoraTokens.radiusPill),
                    borderSide: BorderSide(color: LunoraTokens.line),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(LunoraTokens.radiusPill),
                    borderSide: BorderSide(color: LunoraTokens.line),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(LunoraTokens.radiusPill),
                    borderSide: BorderSide(
                      color: LunoraTokens.purple,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'You can always skip this and add it later.',
                style: TextStyle(
                  fontSize: 12.5,
                  color: LunoraTokens.inkSoft,
                ),
              ),
            ],
          ),
        );
      case 3:
        return _screen(
          title: 'What do you want to track?',
          body: 'Choose what feels relevant. You can change this later.',
          content: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: SymptomCatalog.groups.map((g) {
              final selected = _priorities.contains(g.id);
              return _optionPill(
                label: g.label(l10n),
                glyph: _glyphForCategory(g.id),
                selected: selected,
                onTap: () => setState(() {
                  if (selected) {
                    _priorities.remove(g.id);
                  } else {
                    _priorities.add(g.id);
                  }
                }),
                compact: true,
              );
            }).toList(),
          ),
        );
      case 4:
        return _screen(
          title: 'A gentle heads-up',
          body: '',
          content: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: LunoraTokens.purplePale,
                  borderRadius: BorderRadius.circular(LunoraTokens.radiusLg),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '❋',
                      style: TextStyle(
                        fontSize: 32,
                        color: LunoraTokens.purple,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Lunora is a tracking tool, not a medical device. '
                      'It does not diagnose or treat PCOS.',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.55,
                        color: LunoraTokens.ink,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Always talk to your clinician about medical '
                      'decisions.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.55,
                        color: LunoraTokens.inkSoft,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => setState(() => _consent = !_consent),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      width: 24,
                      height: 24,
                      margin: const EdgeInsets.only(top: 2, right: 12),
                      decoration: BoxDecoration(
                        color:
                            _consent ? LunoraTokens.purple : LunoraTokens.card,
                        border: Border.all(
                          color: _consent
                              ? LunoraTokens.purple
                              : LunoraTokens.inkPale,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _consent
                          ? const Icon(Icons.check,
                              size: 16, color: Colors.white)
                          : null,
                    ),
                    Expanded(
                      child: Text(
                        'I understand Lunora is not a medical device.',
                        style: TextStyle(
                          fontSize: 14.5,
                          height: 1.5,
                          color: LunoraTokens.ink,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      case 5:
        return _screen(
          title: 'Notifications',
          body: 'We can gently nudge you to log symptoms and take '
              'medications.',
          content: Column(
            children: [
              _optionPill(
                label: 'Remind me',
                glyph: '✓',
                selected: true,
                onTap: () {},
                subtitle: 'Not live yet — saved for later',
              ),
              const SizedBox(height: 10),
              _optionPill(
                label: 'Not right now',
                glyph: '—',
                selected: false,
                onTap: () {},
              ),
            ],
          ),
        );
      case 6:
        return _screen(
          title: 'Choose your avatar',
          body: 'Pick a little portrait that feels like you. You can change it any time.',
          content: _avatarPicker(),
        );
      case 7:
      default:
        return _screen(
          title: 'Ready when you are',
          body: 'You can change everything later in Settings.',
          content: Column(
            children: [
              if (_priorities.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: LunoraTokens.card,
                    borderRadius: BorderRadius.circular(LunoraTokens.radiusLg),
                    border: Border.all(color: LunoraTokens.line),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tracking',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                          color: LunoraTokens.inkSoft,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _priorities.map((id) {
                          final g = SymptomCatalog.groups
                              .firstWhere((g) => g.id == id);
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: LunoraTokens.purpleSoft,
                              borderRadius: BorderRadius.circular(
                                  LunoraTokens.radiusPill),
                            ),
                            child: Text(
                              g.label(l10n),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: LunoraTokens.purpleDeep,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
    }
  }

  Widget _avatarPicker() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: LunoraTokens.card,
        borderRadius: BorderRadius.circular(24),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: AvatarCatalog.options.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          mainAxisSpacing: 10,
          crossAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          final selected = _avatar == index;
          return GestureDetector(
            onTap: () => setState(() => _avatar = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              decoration: BoxDecoration(
                color: selected ? LunoraTokens.purpleSoft : LunoraTokens.bg,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? LunoraTokens.purple : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(AvatarCatalog.glyph(index), style: const TextStyle(fontSize: 27)),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _optionPill({
    required String label,
    required String glyph,
    required bool selected,
    required VoidCallback onTap,
    String? subtitle,
    bool compact = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 14 : 18,
          vertical: compact ? 10 : 16,
        ),
        decoration: BoxDecoration(
          color: selected ? LunoraTokens.purpleSoft : LunoraTokens.card,
          borderRadius: BorderRadius.circular(LunoraTokens.radiusLg),
          border: Border.all(
            color: selected ? LunoraTokens.purple : LunoraTokens.line,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              glyph,
              style: TextStyle(
                fontSize: compact ? 16 : 20,
                color:
                    selected ? LunoraTokens.purpleDeep : LunoraTokens.inkSoft,
                height: 1,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: compact ? 14 : 15,
                      fontWeight: FontWeight.w600,
                      color:
                          selected ? LunoraTokens.purpleDeep : LunoraTokens.ink,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: LunoraTokens.inkSoft,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (selected)
              Icon(
                Icons.check_circle,
                color: LunoraTokens.purple,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  String _glyphForGoal(String label) {
    switch (label) {
      case 'Understand my symptoms':
        return '❋';
      case 'Manage my cycle':
        return '❁';
      case 'Build healthier habits':
        return '✿';
      case 'Track medication':
        return '✤';
      default:
        return '✿';
    }
  }

  String _glyphForCategory(String id) {
    switch (id) {
      case 'hormonal':
        return '❋';
      case 'metabolic':
        return '✧';
      case 'mental':
        return '☾';
      case 'cycle':
        return '❁';
      default:
        return '✿';
    }
  }

  Widget _screen({
    required String title,
    required String body,
    Widget? content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              height: 1.2,
              color: LunoraTokens.ink,
            ),
          ),
          if (body.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              body,
              style: TextStyle(
                fontSize: 15,
                height: 1.55,
                color: LunoraTokens.inkSoft,
              ),
            ),
          ],
          if (content != null) ...[
            const SizedBox(height: 24),
            content,
          ],
        ],
      ),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height + 10,
      size.width * 0.5,
      size.height - 15,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height - 40,
      size.width,
      size.height - 10,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
