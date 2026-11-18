import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:walks/app/di.dart';
import 'package:walks/ui/core/routes.dart';
import 'package:walks/ui/pages/album/album_page.dart';
import 'package:walks/ui/pages/catalog/catalog_page.dart';
import 'package:walks/ui/pages/chapter/chapter_page.dart';
import 'package:walks/ui/pages/dev_menu/dev_menu_page.dart';
import 'package:walks/ui/pages/home_shell/home_shell_page.dart';
import 'package:walks/ui/pages/today/today_page.dart';
import 'package:walks/ui/pages/world/world_page.dart';

/// Creates the router of the app.
///
/// The tree, with what comes later in comments:
///
/// ```text
/// root navigator
/// ├─ tabs: StatefulShellRoute, one navigator and history per tab
/// │  ├─ /today
/// │  │  └─ history          (C5г: pushed inside the tab, bar stays)
/// │  ├─ /catalog
/// │  ├─ /world
/// │  └─ /album
/// ├─ /chapter/:progressionId/:chapterId (full screen over the tabs)
/// ├─ /paywall               (modal over the tabs)
/// ├─ /settings              (over the tabs)
/// └─ /dev                   (developer menu, not in release)
/// ```
///
/// A reminder opens `/today`, and the weekly summary opens the history.
/// The reader opens a chapter that has already been unlocked.
GoRouter createRouter({String initialLocation = Routes.today}) {
  return GoRouter(
    navigatorKey: GlobalKey<NavigatorState>(debugLabel: 'root'),
    initialLocation: initialLocation,
    redirect: (context, state) => state.uri.path == '/' ? Routes.today : null,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => HomeShellPage(
          currentIndex: shell.currentIndex,
          // Tapping the open tab again takes it back to its first screen.
          onTabSelected: (index) => shell.goBranch(
            index,
            initialLocation: index == shell.currentIndex,
          ),
          permissions: getIt(),
          stepSource: getIt(),
          syncSteps: getIt(),
          crashReporter: getIt(),
          child: shell,
        ),
        branches: [
          _tab(
            Routes.today,
            (context, state) => TodayPage(
              progress: getIt(),
              catalog: getIt(),
              openChapter: getIt(),
              buyMedal: getIt(),
              crashReporter: getIt(),
              canOpenDevMenu: devMenuEnabled,
            ),
          ),
          _tab(Routes.catalog, (context, state) => const CatalogPage()),
          _tab(Routes.world, (context, state) => const WorldPage()),
          _tab(Routes.album, (context, state) => const AlbumPage()),
        ],
      ),
      // Routes outside the shell go on the root navigator, over the tabs.
      GoRoute(
        path: Routes.chapter,
        builder: (context, state) => ChapterPage(
          progressionId: state.pathParameters['progressionId']!,
          chapterId: state.pathParameters['chapterId']!,
          catalog: getIt(),
          progress: getIt(),
          crashReporter: getIt(),
        ),
      ),
      if (devMenuEnabled)
        GoRoute(
          path: Routes.devMenu,
          builder: (context, state) =>
              DevMenuPage(crashReporter: getIt(), nativeCrasher: getIt()),
        ),
    ],
  );
}

StatefulShellBranch _tab(String path, GoRouterWidgetBuilder builder) =>
    StatefulShellBranch(
      routes: [GoRoute(path: path, builder: builder)],
    );
