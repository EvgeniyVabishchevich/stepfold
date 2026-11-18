import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/kit/kit.dart';
import 'package:walks/ui/pages/home_shell/home_shell.dart';

import '../../../helpers/pump_view.dart';

void main() {
  testWidgets('shows the tab content and the four tabs', (tester) async {
    await tester.pumpView(
      HomeShellView(
        currentIndex: 0,
        onTabSelected: (_) {},
        child: const Text('content'),
      ),
    );

    expect(find.text('content'), findsOneWidget);
    for (final label in ['Сегодня', 'Каталог', 'Мир', 'Альбом']) {
      expect(find.text(label), findsOneWidget);
    }
  });

  testWidgets('marks the open tab', (tester) async {
    await tester.pumpView(
      HomeShellView(
        currentIndex: 2,
        onTabSelected: (_) {},
        child: const SizedBox(),
      ),
    );

    final bar = tester.widget<KitBottomNavigation>(
      find.byType(KitBottomNavigation),
    );
    expect(bar.selectedIndex, 2);
    expect(
      tester.getSemantics(find.bySemanticsLabel('Мир')),
      isSemantics(isSelected: true, isButton: true),
    );
  });

  testWidgets('reports the index of the tapped tab', (tester) async {
    final tapped = <int>[];
    await tester.pumpView(
      HomeShellView(
        currentIndex: 0,
        onTabSelected: tapped.add,
        child: const SizedBox(),
      ),
    );

    await tester.tap(find.text('Альбом'));
    await tester.tap(find.text('Каталог'));

    expect(tapped, [3, 1]);
  });
}
