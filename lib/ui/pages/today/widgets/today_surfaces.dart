import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/kit/kit.dart';
import 'package:walks/ui/theme/theme.dart';

/// Displays a message with an optional action on the Today screen.
class TodayNotice extends StatelessWidget {
  /// Creates a notice.
  const TodayNotice({
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.primary = false,
    super.key,
  });

  /// The notice heading.
  final String title;

  /// The text below the heading.
  final String message;

  /// The button label, if the notice has a button.
  final String? actionLabel;

  /// Called when the button is pressed.
  final VoidCallback? onAction;

  /// Whether the button uses the primary style.
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return KitSurface(
      kind: primary ? KitSurfaceKind.featured : KitSurfaceKind.raised,
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
