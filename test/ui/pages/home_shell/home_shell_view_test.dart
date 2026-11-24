import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/kit/kit.dart';
import 'package:walks/ui/pages/home_shell/home_shell.dart';

import '../../../helpers/pump_view.dart';

void main() {
  testWidgets('shows the tab content and the five tabs', (tester) async {
    await tester.pumpView(
      HomeShellView(
        currentIndex: 0,
        onTabSelected: (_) {},
        child: const Text('content'),
      ),
    );

    expect(find.text('content'), findsOneWidget);
    for (final label in ['Сегодня', 'Каталог', 'Мир', 'Альбом', 'Настройки']) {
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

  testWidgets('tab insets stay even with a long label and large text', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 800);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    for (final scale in [1.0, 2.0]) {
      tester.platformDispatcher.textScaleFactorTestValue = scale;
      await tester.pumpView(
        HomeShellView(
          currentIndex: 4,
          onTabSelected: (_) {},
          child: const SizedBox(),
        ),
      );

      final icons = find.byType(KitIcon);
      final iconTop = tester.getTopLeft(icons.first).dy;
      final labels = ['Сегодня', 'Каталог', 'Мир', 'Альбом', 'Настройки'];
      for (final (index, label) in labels.indexed) {
        final icon = tester.getRect(icons.at(index));
        final text = find.text(label);
        final textRect = tester.getRect(text);
        final tab = tester.getRect(
          find.ancestor(of: text, matching: find.byType(InkWell)).first,
        );

        expect(icon.top, closeTo(iconTop, .01));
        expect(textRect.top - icon.bottom, closeTo(4, .01));
        expect(textRect.left - tab.left, greaterThanOrEqualTo(3.99));
        expect(tab.right - textRect.right, greaterThanOrEqualTo(3.99));
      }
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('the panel keeps the system bottom inset and compact tabs', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(360, 800);
    tester.view.padding = const FakeViewPadding(bottom: 24);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetPadding);
    await tester.pumpView(
      HomeShellView(
        currentIndex: 0,
        onTabSelected: (_) {},
        child: const SizedBox(),
      ),
    );

    final panel = tester.getRect(
      find
          .descendant(
            of: find.byType(KitBottomNavigation),
            matching: find.byType(KitSurface),
          )
          .first,
    );
    final label = tester.getRect(find.text('Каталог'));
    final tab = tester.getRect(
      find.ancestor(of: find.text('Каталог'), matching: find.byType(InkWell)),
    );
    expect(panel.bottom, 776);
    expect(panel.height, 61);
    expect(tab.height, greaterThanOrEqualTo(48));
    expect(panel.bottom - label.bottom, inInclusiveRange(8, 10));
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
    await tester.tap(find.text('Настройки'));

    expect(tapped, [3, 1, 4]);
  });
}
