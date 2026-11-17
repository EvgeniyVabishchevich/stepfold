import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:walks/app/di.dart';
import 'package:walks/app/implementations.dart';
import 'package:walks/app/router.dart';
import 'package:walks/ui/catalog/catalog_view.dart';
import 'package:walks/ui/core/routes.dart';
import 'package:walks/ui/dev_menu/dev_menu_view.dart';
import 'package:walks/ui/kit/kit_bottom_navigation.dart';
import 'package:walks/ui/l10n/l10n.dart';
import 'package:walks/ui/theme/stepfold_theme.dart';
import 'package:walks/ui/today/today_view.dart';

void main() {
  late GoRouter router;

  Future<void> pumpRouter(
    WidgetTester tester, {
    String initialLocation = Routes.today,
  }) async {
    router = createRouter(initialLocation: initialLocation);
    addTearDown(router.dispose);
    await tester.pumpWidget(
      MaterialApp.router(
        theme: StepfoldTheme.light,
        localizationsDelegates: appLocalizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    );
    await tester.pumpAndSettle();
  }

  int selectedTab(WidgetTester tester) => tester
      .widget<KitBottomNavigation>(find.byType(KitBottomNavigation))
      .selectedIndex;

  String location() => router.routerDelegate.currentConfiguration.uri.path;

  testWidgets('starts on Today', (tester) async {
    await pumpRouter(tester);

    expect(find.byType(TodayView), findsOneWidget);
    expect(selectedTab(tester), 0);
  });

  testWidgets('the root location leads to Today', (tester) async {
    await pumpRouter(tester, initialLocation: '/');

    expect(location(), Routes.today);
  });

  testWidgets('a link to a tab opens that tab', (tester) async {
    await pumpRouter(tester, initialLocation: Routes.world);

    expect(location(), Routes.world);
    expect(selectedTab(tester), 2);
  });

  testWidgets('tapping a tab opens it', (tester) async {
    await pumpRouter(tester);

    await tester.tap(find.text('Каталог'));
    await tester.pumpAndSettle();

    expect(location(), Routes.catalog);
    expect(find.byType(CatalogView), findsOneWidget);
    expect(selectedTab(tester), 1);
  });

  // The tab history lives in the tab's navigator: if it stays mounted while
  // hidden, so does the history.
  testWidgets('a tab left for another stays alive', (tester) async {
    await pumpRouter(tester);
    final todayNavigator = tester.state(
      find
          .ancestor(
            of: find.byType(TodayView),
            matching: find.byType(Navigator),
          )
          .first,
    );

    await tester.tap(find.text('Каталог'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Сегодня'));
    await tester.pumpAndSettle();

    final todayNavigatorAfter = tester.state(
      find
          .ancestor(
            of: find.byType(TodayView),
            matching: find.byType(Navigator),
          )
          .first,
    );
    expect(todayNavigatorAfter, same(todayNavigator));
    expect(find.byType(CatalogView, skipOffstage: false), findsOneWidget);
  });

  group('developer menu', () {
    setUp(() => configureDependencies(Implementations.fakes));
    tearDown(getIt.reset);

    testWidgets('opens over the tabs and goes back to Today', (tester) async {
      await pumpRouter(tester);

      await tester.longPress(find.text('Сегодня').first);
      await tester.pumpAndSettle();

      expect(find.byType(DevMenuView), findsOneWidget);
      expect(find.byType(KitBottomNavigation), findsNothing);

      // Not pageBack: it looks for the back button of the old
      // package:flutter/material.dart, ours comes from material_ui.
      await tester.tap(find.byTooltip('Назад'));
      await tester.pumpAndSettle();

      expect(find.byType(TodayView), findsOneWidget);
      expect(find.byType(KitBottomNavigation), findsOneWidget);
    });
  });
}
