import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/kit/kit_bottom_navigation.dart';
import 'package:walks/ui/kit/kit_icon.dart';
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
