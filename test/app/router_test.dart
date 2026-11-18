import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:walks/app/di.dart';
import 'package:walks/app/implementations.dart';
import 'package:walks/app/router.dart';
import 'package:walks/data/repositories/repositories.dart';
import 'package:walks/domain/domain.dart';
import 'package:walks/ui/pages/home_shell/bloc/bloc.dart';
import 'package:walks/ui/pages/today/bloc/bloc.dart';
import 'package:walks/ui/ui.dart';

void main() {
  late GoRouter router;
  setUp(() => configureDependencies(Implementations.fakes));
  tearDown(getIt.reset);

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

  testWidgets('the shell provider syncs on direct entry and owns its bloc', (
    tester,
  ) async {
    final source = (getIt<StepSource>() as FakeStepSource)
      ..setSteps(Day.today(), 1200);
    (getIt<PermissionService>() as FakePermissionService).setStatus(
      source.requiredPermission,
      PermissionStatus.granted,
    );

    await pumpRouter(tester, initialLocation: Routes.catalog);

    final shellBloc = tester
        .element(find.byType(CatalogView))
        .read<StepSyncBloc>();
    final progress =
        (getIt<ProgressRepository>() as FakeProgressRepository).progress;
    expect(progress.reserve, 1200);
    expect(find.byType(TodayView, skipOffstage: false), findsNothing);

    await tester.tap(find.text('Сегодня'));
    await tester.pumpAndSettle();
    final todayContext = tester.element(find.byType(TodayView));
    final todayBloc = todayContext.read<TodayBloc>();
    expect(todayContext.read<StepSyncBloc>(), same(shellBloc));

    await tester.pumpWidget(const SizedBox.shrink());
    // Cancellation of the step stream can finish outside the frame queue.
    await tester.runAsync(() => Future<void>(() {}));
    await tester.pumpAndSettle();

    expect(shellBloc.isClosed, isTrue);
    expect(todayBloc.isClosed, isTrue);
  });

  testWidgets('steps fund a chapter and the reader returns to the next goal', (
    tester,
  ) async {
    final repository = getIt<ProgressRepository>();
    await repository.saveGoal(
      const Goal.chapter(progressionId: 'sample', chapterId: 'c1'),
    );
    (getIt<StepSource>() as FakeStepSource).setSteps(Day.today(), 1200);
    await pumpRouter(tester, initialLocation: Routes.catalog);
    await tester.tap(find.text('Сегодня').first);
    await tester.pumpAndSettle();

    final allow = find.text('Разрешить');
    final scrollable = find.descendant(
      of: find.byType(TodayView),
      matching: find.byType(Scrollable),
    );
    await tester.scrollUntilVisible(
      allow.hitTestable(),
      100,
      scrollable: scrollable,
    );
    await tester.pumpAndSettle();
    await tester.tap(allow);
    await tester.pumpAndSettle();

    final open = find.text('Открыть главу');
    await tester.scrollUntilVisible(
      open.hitTestable(),
      100,
      scrollable: scrollable,
    );
    await tester.pumpAndSettle();
    await tester.tap(open);
    await tester.pumpAndSettle();

    expect(find.byType(ChapterView), findsOneWidget);
    expect(find.text('Первая глава.'), findsOneWidget);
    expect(find.byType(KitBottomNavigation), findsNothing);
    await tester.tap(find.byTooltip('Назад'));
    await tester.pumpAndSettle();

    expect(find.byType(ChapterView), findsNothing);
    expect(find.text('Конец'), findsOneWidget);
    expect(find.text('В запасе 200 шагов'), findsOneWidget);
    expect(
      (repository as FakeProgressRepository).progress.spendings,
      hasLength(1),
    );
  });

  testWidgets('a link cannot reveal a locked chapter or spend steps', (
    tester,
  ) async {
    await pumpRouter(
      tester,
      initialLocation: Routes.chapterLocation('sample', 'c1'),
    );

    expect(location(), '/chapter/sample/c1');
    await tester.pumpAndSettle();
    expect(find.text('Глава недоступна'), findsOneWidget);
    expect(find.text('Первая глава.'), findsNothing);
    final progress =
        (getIt<ProgressRepository>() as FakeProgressRepository).progress;
    expect(progress.spendings, isEmpty);
  });

  testWidgets('the goal remains readable at double text size', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(360, 760);
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final repository = getIt<ProgressRepository>();
    await repository.saveAutoSteps(Day.today(), 1200);
    await repository.saveGoal(
      const Goal.chapter(progressionId: 'sample', chapterId: 'c1'),
    );
    await pumpRouter(tester);

    final open = find.text('Открыть главу').hitTestable();
    await tester.scrollUntilVisible(
      open,
      120,
      scrollable: find.descendant(
        of: find.byType(TodayView),
        matching: find.byType(Scrollable),
      ),
    );
    expect(open, findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  group('developer menu', () {
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
