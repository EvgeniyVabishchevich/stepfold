import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/core/core.dart';
import 'package:walks/ui/l10n/l10n.dart';

/// The Album tab: gives [AlbumView] what it needs.
class AlbumPage extends StatelessWidget {
  /// Creates the page.
  const AlbumPage({super.key});

  @override
  Widget build(BuildContext context) => const AlbumView();
}

/// Layout of the Album tab. A placeholder until its step.
class AlbumView extends StatelessWidget {
  /// Creates the view.
  const AlbumView({super.key});

  @override
  Widget build(BuildContext context) =>
      PlaceholderView(title: context.l10n.tabAlbum);
}
