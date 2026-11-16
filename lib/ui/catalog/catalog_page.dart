import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/catalog/catalog_view.dart';

/// The Catalog tab: gives [CatalogView] what it needs.
class CatalogPage extends StatelessWidget {
  /// Creates the page.
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) => const CatalogView();
}
