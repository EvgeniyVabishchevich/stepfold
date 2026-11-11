import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Location of the home screen.
const homeLocation = '/';

/// Creates the router of the app.
GoRouter createRouter() {
  return GoRouter(
    initialLocation: homeLocation,
    routes: [
      GoRoute(
        path: homeLocation,
        builder: (context, state) => const _PlaceholderHome(),
      ),
    ],
  );
}

// Stands in for the first real screen.
class _PlaceholderHome extends StatelessWidget {
  const _PlaceholderHome();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Stepfold')));
  }
}
