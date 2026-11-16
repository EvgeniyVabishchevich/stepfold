import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/album/album_page.dart';
import 'package:walks/ui/catalog/catalog_page.dart';
import 'package:walks/ui/core/routes.dart';
import 'package:walks/ui/dev_menu/dev_menu_page.dart';
import 'package:walks/ui/home/home_shell_view.dart';
import 'package:walks/ui/today/today_page.dart';
import 'package:walks/ui/world/world_page.dart';

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
/// ├─ /chapter/:id           (full screen over the tabs)
/// ├─ /paywall               (modal over the tabs)
/// ├─ /settings              (over the tabs)
/// └─ /dev                   (developer menu, not in release)
/// ```
///
/// A notification opens one of these locations: "chapter ready" opens
/// `/chapter/:id`, a reminder `/today`, the weekly summary the history.
GoRouter createRouter({String initialLocation = Routes.today}) {
  return GoRouter(
    navigatorKey: GlobalKey<NavigatorState>(debugLabel: 'root'),
    initialLocation: initialLocation,
    redirect: (context, state) => state.uri.path == '/' ? Routes.today : null,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => HomeShellView(
          currentIndex: shell.currentIndex,
          // Tapping the open tab again takes it back to its first screen.
          onTabSelected: (index) => shell.goBranch(
            index,
            initialLocation: index == shell.currentIndex,
          ),
          child: shell,
        ),
        branches: [
          _tab(Routes.today, const TodayPage()),
          _tab(Routes.catalog, const CatalogPage()),
          _tab(Routes.world, const WorldPage()),
          _tab(Routes.album, const AlbumPage()),
        ],
      ),
      // Routes outside the shell go on the root navigator, over the tabs.
      if (devMenuEnabled)
        GoRoute(
          path: Routes.devMenu,
          builder: (context, state) => const DevMenuPage(),
        ),
    ],
  );
}

StatefulShellBranch _tab(String path, Widget page) => StatefulShellBranch(
  routes: [GoRoute(path: path, builder: (context, state) => page)],
);
