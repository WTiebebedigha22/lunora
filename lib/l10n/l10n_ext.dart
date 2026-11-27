import 'package:flutter/widgets.dart';
import 'app_localizations.dart';

extension L10nContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
