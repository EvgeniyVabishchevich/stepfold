import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:walks/app/dev_history_preview.dart';
import 'package:walks/app/di.dart';
import 'package:walks/ui/core/core.dart';
import 'package:walks/ui/pages/pages.dart';

/// Creates the router of the app.
///
/// The tree, with what comes later in comments:
///
/// ```text
/// root navigator
/// ├─ tabs: StatefulShellRoute, one navigator and history per tab
/// │  ├─ /today
/// │  │  └─ history          (inside the tab, bar stays)
/// │  ├─ /catalog
/// │  │  └─ :progressionId (chapters, bar stays)
/// │  ├─ /world
/// │  ├─ /album
/// │  └─ /settings
/// ├─ /chapter/:progressionId/:chapterId (full screen over the tabs)
/// ├─ /paywall               (modal over the tabs)
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
            routes: [
              GoRoute(
                path: Routes.historySegment,
                builder: (context, state) => HistoryPage(
                  progress: getIt(),
                  catalog: getIt(),
                  addManualSteps: getIt(),
                  updateLock: getIt(),
                  crashReporter: getIt(),
                ),
              ),
            ],
          ),
          _tab(
            Routes.catalog,
            (context, state) => _catalogPage(),
            routes: [
              GoRoute(
                path: Routes.progression,
                builder: (context, state) =>
                    _catalogPage(state.pathParameters['progressionId']),
              ),
            ],
          ),
          _tab(Routes.world, (context, state) => const WorldPage()),
          _tab(Routes.album, (context, state) => const AlbumPage()),
          _tab(Routes.settings, (context, state) => const SettingsPage()),
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
          builder: (context, state) => DevMenuPage(
            crashReporter: getIt(),
            nativeCrasher: getIt(),
            progress: getIt(),
          ),
          routes: [
            GoRoute(
              path: Routes.historySegment,
              builder: (context, state) =>
                  DevHistoryPreview(crashReporter: getIt(), catalog: getIt()),
            ),
          ],
        ),
    ],
  );
}

CatalogPage _catalogPage([String? progressionId]) => CatalogPage(
  catalog: getIt(),
  progress: getIt(),
  setGoal: getIt(),
  crashReporter: getIt(),
  progressionId: progressionId,
);

StatefulShellBranch _tab(
  String path,
  GoRouterWidgetBuilder builder, {
  List<RouteBase> routes = const [],
}) => StatefulShellBranch(
  routes: [GoRoute(path: path, builder: builder, routes: routes)],
);
