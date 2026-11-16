import 'package:flutter_test/flutter_test.dart';
import 'package:walks/ui/today/today_view.dart';

import '../../helpers/pump_view.dart';

void main() {
  testWidgets('a long press on the title opens the developer menu', (
    tester,
  ) async {
    var opened = 0;
    await tester.pumpView(TodayView(onOpenDevMenu: () => opened++));

    await tester.longPress(find.text('Сегодня'));

    expect(opened, 1);
  });

  testWidgets('without a developer menu a long press does nothing', (
    tester,
  ) async {
    await tester.pumpView(const TodayView());

    await tester.longPress(find.text('Сегодня'));

    expect(tester.takeException(), isNull);
  });
}
