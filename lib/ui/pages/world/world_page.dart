import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/core/core.dart';
import 'package:walks/ui/l10n/l10n.dart';

/// The World tab: gives [WorldView] what it needs.
class WorldPage extends StatelessWidget {
  /// Creates the page.
  const WorldPage({super.key});

  @override
  Widget build(BuildContext context) => const WorldView();
}

/// Layout of the World tab. A placeholder until its step.
class WorldView extends StatelessWidget {
  /// Creates the view.
  const WorldView({super.key});

  @override
  Widget build(BuildContext context) =>
      PlaceholderView(title: context.l10n.tabWorld);
}
