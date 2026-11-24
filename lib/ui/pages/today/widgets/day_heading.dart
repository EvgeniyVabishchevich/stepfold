import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/kit/kit.dart';
import 'package:walks/ui/l10n/l10n.dart';
import 'package:walks/ui/theme/theme.dart';

/// Displays the title and history shortcut of the Today screen.
class TodayHeading extends StatelessWidget {
  /// Creates the heading.
  const TodayHeading({
    required this.onLongPress,
    this.onOpenHistory,
    super.key,
  });

  /// Opens the developer menu when available.
  final VoidCallback? onLongPress;

  /// Opens step history.
  final VoidCallback? onOpenHistory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: Spacing.s4),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onLongPress: onLongPress,
              child: Semantics(
                header: true,
                child: Text(
                  l10n.tabToday,
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontSize: 32,
                    height: 1.2,
                    letterSpacing: -0.6,
                  ),
                ),
              ),
            ),
          ),
          if (onOpenHistory case final openHistory?) ...[
            const SizedBox(width: Spacing.s8),
            KitIconAction(
              icon: KitIcons.historyClock,
              label: l10n.historyTitle,
              onPressed: openHistory,
            ),
          ],
        ],
      ),
    );
  }
}
