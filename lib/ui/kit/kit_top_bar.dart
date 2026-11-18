import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/kit/kit_icon.dart';
import 'package:walks/ui/theme/theme.dart';

/// An action on the right of [KitTopBar].
class KitTopBarAction {
  /// Creates the action.
  const KitTopBarAction({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  /// Its icon.
  final KitIcons icon;

  /// What it does, for screen readers and the long-press tooltip.
  final String label;

  /// The action.
  final VoidCallback onPressed;
}

/// The bar on top of a screen: back, title, one action.
class KitTopBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates the bar; no [onBack] — no back button.
  const KitTopBar({
    required this.title,
    this.onBack,
    this.backLabel,
    this.action,
    super.key,
  });

  /// Name of the screen.
  final String title;

  /// Goes back; null hides the button.
  final VoidCallback? onBack;

  /// What the back button says to screen readers.
  final String? backLabel;

  /// The action on the right, if any.
  final KitTopBarAction? action;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onBack = this.onBack;
    final action = this.action;
    return Material(
      color: theme.colorScheme.surface,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: preferredSize.height,
          child: Padding(
            padding: EdgeInsetsDirectional.only(
              start: onBack == null ? Spacing.s16 : Spacing.s4,
              end: Spacing.s4,
            ),
            child: Row(
              children: [
                if (onBack != null)
                  _IconAction(
                    icon: KitIcons.arrowLeft,
                    label: backLabel ?? '',
                    onPressed: onBack,
                  ),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (action != null)
                  _IconAction(
                    icon: action.icon,
                    label: action.label,
                    onPressed: action.onPressed,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final KitIcons icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: label,
      constraints: const BoxConstraints.tightFor(width: 48, height: 48),
      icon: KitIcon(icon, color: Theme.of(context).colorScheme.onSurface),
    );
  }
}
