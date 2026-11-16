import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/l10n/l10n.dart';

import '../../helpers/pump_view.dart';

void main() {
  late BuildContext context;

  Future<void> pump(WidgetTester tester) => tester.pumpView(
    Builder(
      builder: (c) {
        context = c;
        return const SizedBox();
      },
    ),
  );

  testWidgets('a device in another language gets Russian', (tester) async {
    tester.platformDispatcher.localesTestValue = const [Locale('en', 'US')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);

    await pump(tester);

    expect(context.l10n.localeName, 'ru');
  });

  // Guards appLocalizationsDelegates: with the delegate from
  // flutter_localizations, material_ui widgets would find no Russian strings.
  testWidgets('Material widgets speak Russian', (tester) async {
    await pump(tester);

    expect(MaterialLocalizations.of(context).backButtonTooltip, 'Назад');
  });
}
