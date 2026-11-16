import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/world/world_view.dart';

/// The World tab: gives [WorldView] what it needs.
class WorldPage extends StatelessWidget {
  /// Creates the page.
  const WorldPage({super.key});

  @override
  Widget build(BuildContext context) => const WorldView();
}
