import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:walks/app/router.dart';
import 'package:walks/ui/l10n/l10n.dart';
import 'package:walks/ui/theme/stepfold_theme.dart';

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
    // Only Russian for now: any device language falls back to it.
    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appTitle,
      theme: StepfoldTheme.light,
      darkTheme: StepfoldTheme.dark,
      localizationsDelegates: appLocalizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: _router,
    );
  }
}
