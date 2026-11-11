import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:walks/app/router.dart';

/// Root widget of the Stepfold app.
///
/// Dependencies are registered before it is built, in `configureDependencies`.
class StepfoldApp extends StatefulWidget {
  /// Creates the root widget.
  const StepfoldApp({super.key});

  @override
  State<StepfoldApp> createState() => _StepfoldAppState();
}

class _StepfoldAppState extends State<StepfoldApp> {
  late final GoRouter _router = createRouter();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(title: 'Stepfold', routerConfig: _router);
  }
}
