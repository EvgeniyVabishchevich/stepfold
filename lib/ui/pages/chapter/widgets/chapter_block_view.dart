part of '../chapter_page.dart';

class _ChapterBlockView extends StatelessWidget {
  const _ChapterBlockView({required this.block});

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
