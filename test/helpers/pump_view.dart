import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/l10n/l10n.dart';
import 'package:walks/ui/theme/theme.dart';

/// Pumps a view the way the app shows it: Material and the app's strings.
extension PumpView on WidgetTester {
  /// Shows [view] as the home screen of a localized [MaterialApp], in the
  /// light theme unless [theme] is given.
  Future<void> pumpView(Widget view, {ThemeData? theme}) => pumpWidget(
    MaterialApp(
      theme: theme ?? StepfoldTheme.light,
      localizationsDelegates: appLocalizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: view,
    ),
  );
}
