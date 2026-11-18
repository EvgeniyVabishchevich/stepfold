import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:walks/domain/domain.dart';
import 'package:walks/ui/core/core.dart';
import 'package:walks/ui/kit/kit.dart';
import 'package:walks/ui/l10n/l10n.dart';
import 'package:walks/ui/pages/home_shell/bloc/bloc.dart';

/// Gives the tab shell one step sync bloc for its entire lifetime.
class HomeShellPage extends StatelessWidget {
  /// Creates the shell.
  const HomeShellPage({
    required this.currentIndex,
    required this.onTabSelected,
    required this.child,
    required this.permissions,
    required this.stepSource,
    required this.syncSteps,
    required this.crashReporter,
    super.key,
  });

  /// Index of the visible tab.
  final int currentIndex;

  /// Changes the selected tab.
  final ValueChanged<int> onTabSelected;

  /// The active tab's navigator.
  final Widget child;

  /// Provides access to the step source.
  final PermissionService permissions;

  /// Describes the permission required by the source.
  final StepSource stepSource;

  /// Copies steps into progress.
  final SyncSteps syncSteps;

  /// Reports unexpected storage failures.
  final CrashReporter crashReporter;

  @override
  Widget build(BuildContext context) => BlocProvider(
    // Sync also starts if the app opens directly on a tab other than Today.
    lazy: false,
    create: (_) => StepSyncBloc(
      permissions: permissions,
      source: stepSource,
      sync: syncSteps,
      crashReporter: crashReporter,
    )..add(const CheckStepSync()),
    child: AppResumeListener(
      onResume: (context) =>
          context.read<StepSyncBloc>().add(const CheckStepSync()),
      child: HomeShellView(
        currentIndex: currentIndex,
        onTabSelected: onTabSelected,
        child: child,
      ),
    ),
  );
}

/// The frame around the four tabs: the open tab and the bottom bar.
///
/// Knows nothing of the router: the router hands it the tab content and
/// says which tab is open.
class HomeShellView extends StatelessWidget {
  /// Creates the frame.
  const HomeShellView({
    required this.currentIndex,
    required this.onTabSelected,
    required this.child,
    super.key,
  });

  /// Index of the open tab: Today, Catalog, World, Album.
  final int currentIndex;

  /// Called with the index of the tab the user tapped.
  final ValueChanged<int> onTabSelected;

  /// Content of the open tab.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: child,
      bottomNavigationBar: KitBottomNavigation(
        selectedIndex: currentIndex,
        onSelected: onTabSelected,
        tabs: [
          KitTab(icon: KitIcons.footprints, label: l10n.tabToday),
          KitTab(icon: KitIcons.books, label: l10n.tabCatalog),
          KitTab(icon: KitIcons.globeHemisphereWest, label: l10n.tabWorld),
          KitTab(icon: KitIcons.cards, label: l10n.tabAlbum),
        ],
      ),
    );
  }
}
