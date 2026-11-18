import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/kit/kit.dart';
import 'package:walks/ui/theme/theme.dart';

/// The whole kit, as the showcase in Penpot draws it.
class _Showcase extends StatelessWidget {
  const _Showcase();

  static const _tabs = [
    KitTab(icon: KitIcons.footprints, label: 'Сегодня'),
    KitTab(icon: KitIcons.books, label: 'Каталог'),
    KitTab(icon: KitIcons.globeHemisphereWest, label: 'Мир'),
    KitTab(icon: KitIcons.cards, label: 'Альбом'),
  ];

  @override
  Widget build(BuildContext context) {
    void tap() {}
    Widget buttons(KitButtonKind kind, String label) => Row(
      spacing: 12,
      children: [
        KitButton(kind: kind, label: label, onPressed: tap),
        KitButton(kind: kind, label: label, onPressed: null),
        KitButton(kind: kind, label: label, onPressed: tap, loading: true),
      ],
    );
    return ColoredBox(
      color: StepfoldColors.of(context).background,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buttons(KitButtonKind.primary, 'Открыть главу'),
            buttons(KitButtonKind.secondary, 'Выбрать цель'),
            buttons(KitButtonKind.text, 'Не сейчас'),
            const KitProgressBar(value: 0.6),
            const KitProgressBar(value: 1),
            const KitProgressBar(value: 0.4, debt: true),
            KitTopBar(
              title: 'Выбор цели',
              onBack: tap,
              backLabel: 'Назад',
              action: KitTopBarAction(
                icon: KitIcons.gearSix,
                label: 'Настройки',
                onPressed: tap,
              ),
            ),
            const KitTopBar(title: 'Сегодня'),
            for (final selected in [0, 3])
              KitBottomNavigation(
                tabs: _tabs,
                selectedIndex: selected,
                onSelected: (_) {},
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: KitStatePlaceholder.empty(
                    title: 'Здесь пока пусто',
                    message: 'Выбери первую главу, и шаги пойдут в неё.',
                    actionLabel: 'Выбрать цель',
                    onAction: tap,
                  ),
                ),
                const Expanded(child: KitStatePlaceholder.loading()),
                Expanded(
                  child: KitStatePlaceholder.error(
                    title: 'Не удалось загрузить',
                    message: 'Проверь интернет и попробуй ещё раз.',
                    actionLabel: 'Повторить',
                    onAction: tap,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  testWidgets('the kit in both themes', tags: 'golden', (tester) async {
    await tester.binding.setSurfaceSize(const Size(2 * 1000, 1100));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Row(
          children: [
            for (final theme in [StepfoldTheme.light, StepfoldTheme.dark])
              Expanded(
                child: Theme(
                  data: theme,
                  child: const Material(child: _Showcase()),
                ),
              ),
          ],
        ),
      ),
    );
    // SVG assets load asynchronously, outside the fake test clock.
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    // Lets the spinners of the loading buttons draw an arc.
    await tester.pump(const Duration(milliseconds: 400));

    await expectLater(
      find.byType(Row).first,
      matchesGoldenFile('goldens/kit_showcase.png'),
    );
  });
}
