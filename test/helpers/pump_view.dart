import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/l10n/l10n.dart';

/// Pumps a view the way the app shows it: Material and the app's strings.
extension PumpView on WidgetTester {
  /// Shows [view] as the home screen of a localized [MaterialApp].
  Future<void> pumpView(Widget view) => pumpWidget(
    MaterialApp(
      localizationsDelegates: appLocalizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: view,
    ),
  );
}
