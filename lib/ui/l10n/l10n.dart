import 'package:cupertino_ui/cupertino_ui.dart'
    show GlobalCupertinoLocalizations;
import 'package:flutter_localizations/flutter_localizations.dart'
    show GlobalWidgetsLocalizations;
import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/l10n/generated/app_localizations.dart';

export 'package:walks/ui/l10n/generated/app_localizations.dart';

/// Delegates for [AppLocalizations] and the built-in widget strings.
///
/// Not `AppLocalizations.localizationsDelegates`: the generated list takes
/// the Material and Cupertino delegates from `flutter_localizations`, which
/// serve the deprecated `package:flutter/material.dart`. Our widgets come
/// from `material_ui` and `cupertino_ui` and look up their own types.
const List<LocalizationsDelegate<Object?>> appLocalizationsDelegates = [
  AppLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
];

/// Short access to the strings of the screen.
extension AppLocalizationsX on BuildContext {
  /// The strings for the current locale.
  AppLocalizations get l10n => AppLocalizations.of(this);
}
