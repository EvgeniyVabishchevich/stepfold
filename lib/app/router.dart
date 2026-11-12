import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/dev_menu/dev_menu_page.dart';

/// Whether the build has the developer menu.
const bool devMenuEnabled = !kReleaseMode;

/// Location of the home screen.
const homeLocation = '/';

/// Location of the developer menu.
const devMenuLocation = '/dev';

/// Creates the router of the app.
GoRouter createRouter() {
  return GoRouter(
    initialLocation: homeLocation,
    routes: [
      GoRoute(
        path: homeLocation,
        builder: (context, state) => const _PlaceholderHome(),
        routes: [
          if (devMenuEnabled)
            GoRoute(
              path: devMenuLocation.substring(1),
              builder: (context, state) => const DevMenuPage(),
            ),
        ],
      ),
    ],
  );
}

// Stands in for the first real screen. A long press on the name opens the
// developer menu, as the version label in settings will.
class _PlaceholderHome extends StatelessWidget {
  const _PlaceholderHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onLongPress: devMenuEnabled
              ? () => context.go(devMenuLocation)
              : null,
          child: const Text('Stepfold'),
        ),
      ),
    );
  }
}
