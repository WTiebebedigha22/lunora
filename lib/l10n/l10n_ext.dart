import 'package:flutter/widgets.dart';
import 'app_localizations.dart';

extension L10nContextX on BuildContext {
  LunoraLocalizations get l10n => LunoraLocalizations.of(this);
}
