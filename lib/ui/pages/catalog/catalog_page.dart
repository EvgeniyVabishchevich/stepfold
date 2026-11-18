import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/core/core.dart';
import 'package:walks/ui/l10n/l10n.dart';

/// The Catalog tab: gives [CatalogView] what it needs.
class CatalogPage extends StatelessWidget {
  /// Creates the page.
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) => const CatalogView();
}

/// Layout of the Catalog tab. A placeholder until its step.
class CatalogView extends StatelessWidget {
  /// Creates the view.
  const CatalogView({super.key});

  @override
  Widget build(BuildContext context) =>
      PlaceholderView(title: context.l10n.tabCatalog);
}
