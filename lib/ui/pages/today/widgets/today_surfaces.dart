part of '../today_page.dart';

class _Notice extends StatelessWidget {
  const _Notice({
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.primary = false,
  });

  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _Surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Spacing.s8,
        children: [
          Text(title, style: theme.textTheme.titleLarge),
          Text(
            message,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (actionLabel case final label?)
            Padding(
              padding: const EdgeInsets.only(top: Spacing.s4),
              child: KitButton(
                kind: primary ? KitButtonKind.primary : KitButtonKind.secondary,
                label: label,
                onPressed: onAction,
              ),
            ),
        ],
      ),
    );
  }
}

class _Surface extends StatelessWidget {
  const _Surface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(Spacing.s16),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(Radii.card),
    ),
    child: child,
  );
}
