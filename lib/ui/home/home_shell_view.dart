import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/l10n/l10n.dart';

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
    // The standard bar until the UI kit brings its own; icons come with it.
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onTabSelected,
        destinations: [
          NavigationDestination(icon: _noIcon, label: l10n.tabToday),
          NavigationDestination(icon: _noIcon, label: l10n.tabCatalog),
          NavigationDestination(icon: _noIcon, label: l10n.tabWorld),
          NavigationDestination(icon: _noIcon, label: l10n.tabAlbum),
        ],
      ),
    );
  }
}

const Widget _noIcon = SizedBox.shrink();
