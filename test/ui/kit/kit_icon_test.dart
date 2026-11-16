import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/kit/kit_icon.dart';
import 'package:walks/ui/theme/stepfold_colors.dart';
import 'package:walks/ui/theme/stepfold_theme.dart';

void main() {
  testWidgets('a duotone icon draws its fill under its line', (tester) async {
    await tester.pumpWidget(
      const KitIcon(
        KitIcons.cards,
        color: Color(0xFF000001),
        fillColor: Color(0x33000002),
      ),
    );

    final layers = tester
        .widgetList<SvgPicture>(find.byType(SvgPicture))
        .map((p) => p.colorFilter)
        .toList();
    expect(layers, [
      const ColorFilter.mode(Color(0x33000002), BlendMode.srcIn),
      const ColorFilter.mode(Color(0xFF000001), BlendMode.srcIn),
    ]);
  });

  testWidgets('without a fill color only the line is drawn', (tester) async {
    await tester.pumpWidget(
      const KitIcon(KitIcons.books, color: Color(0xFF000001)),
    );

    expect(find.byType(SvgPicture), findsOneWidget);
  });

  testWidgets('a plain icon has no fill layer', (tester) async {
    expect(KitIcons.arrowLeft.fillAsset, isNull);
    expect(KitIcons.arrowLeft.lineAsset, 'assets/icons/arrow_left.svg');
    expect(
      KitIcons.globeHemisphereWest.lineAsset,
      'assets/icons/globe_hemisphere_west_line.svg',
    );
  });

  testWidgets('tab icons in both themes', tags: 'golden', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 120));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    Widget row(ThemeData theme, {required int selected}) => Theme(
      data: theme,
      child: Builder(
        builder: (context) {
          final scheme = Theme.of(context).colorScheme;
          final colors = StepfoldColors.of(context);
          final tabs = [
            KitIcons.footprints,
            KitIcons.books,
            KitIcons.globeHemisphereWest,
            KitIcons.cards,
          ];
          return ColoredBox(
            color: scheme.surface,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (final (i, icon) in tabs.indexed)
                  KitIcon(
                    icon,
                    size: 48,
                    color: i == selected
                        ? scheme.primary
                        : scheme.onSurfaceVariant,
                    fillColor: scheme.primary.withValues(
                      alpha: i == selected
                          ? colors.iconFillSelected
                          : colors.iconFillIdle,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          children: [
            Expanded(child: row(StepfoldTheme.light, selected: 0)),
            Expanded(child: row(StepfoldTheme.dark, selected: 3)),
          ],
        ),
      ),
    );
    // SVG assets load asynchronously, outside the fake test clock.
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(Column),
      matchesGoldenFile('goldens/tab_icons.png'),
    );
  });
}
