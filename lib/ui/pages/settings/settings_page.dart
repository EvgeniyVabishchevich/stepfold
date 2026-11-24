import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/core/core.dart';
import 'package:walks/ui/l10n/l10n.dart';

/// The Settings tab.
class SettingsPage extends StatelessWidget {
  /// Creates the page.
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) => const SettingsView();
}

/// Placeholder for the future Settings layout.
class SettingsView extends StatelessWidget {
  /// Creates the view.
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) =>
      PlaceholderView(title: context.l10n.tabSettings);
}
