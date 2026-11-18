import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/kit/kit_button.dart';

import '../../helpers/pump_view.dart';

void main() {
  testWidgets('loading shows a spinner and blocks the button', (tester) async {
    var activations = 0;

    Widget button({required bool loading}) => Center(
      child: KitButton(
        kind: KitButtonKind.primary,
        label: 'Открыть главу',
        onPressed: () => activations++,
        loading: loading,
      ),
    );

    await tester.pumpView(button(loading: true));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(FilledButton).hitTestable(), findsNothing);
    await tester.tapAt(tester.getCenter(find.byType(FilledButton)));
    expect(activations, 0);

    await tester.pumpView(button(loading: false));

    expect(find.byType(CircularProgressIndicator), findsNothing);
    await tester.tap(find.byType(FilledButton));
    expect(activations, 1);
  });
}
