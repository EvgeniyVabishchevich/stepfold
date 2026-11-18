import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/l10n/l10n.dart';

/// Displays a catalog image using the provider for its URI scheme.
class CatalogImage extends StatelessWidget {
  /// Creates an image with a fallback when it cannot be displayed.
  const CatalogImage({required this.source, super.key});

  /// The image address from the catalog.
  final Uri source;

  ImageProvider<Object>? get _provider => switch (source.scheme) {
    'asset' => AssetImage(source.path),
    'https' => NetworkImage(source.toString()),
    'file' when !kIsWeb => FileImage(File.fromUri(source)),
    _ => null,
  };

  @override
  Widget build(BuildContext context) {
    final provider = _provider;
    Widget fallback() => Text(context.l10n.chapterImageError);
    if (provider == null) return fallback();
    return Image(
      image: provider,
      fit: BoxFit.contain,
      width: double.infinity,
      errorBuilder: (_, _, _) => fallback(),
    );
  }
}
