import 'package:material_ui/material_ui.dart';
import 'package:walks/domain/models/models.dart';
import 'package:walks/ui/core/core.dart';
import 'package:walks/ui/theme/theme.dart';

/// Renders one block in the chapter reader.
class ChapterBlockView extends StatelessWidget {
  /// Creates a view for the given [block].
  const ChapterBlockView({required this.block, super.key});

  /// The catalog content to display.
  final ContentBlock block;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return switch (block) {
      Paragraph(:final text) => Text(text, style: theme.textTheme.bodyLarge),
      ImageBlock(:final source, :final caption) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Spacing.s12,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Radii.small),
            child: CatalogImage(source: source),
          ),
          if (caption.isNotEmpty)
            Text(
              caption,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
      MapPoint(:final label) => Text(label, style: theme.textTheme.bodyLarge),
    };
  }
}
