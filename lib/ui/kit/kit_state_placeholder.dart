import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/kit/kit_button.dart';
import 'package:walks/ui/kit/kit_icon.dart';
import 'package:walks/ui/kit/kit_surface.dart';
import 'package:walks/ui/theme/theme.dart';

/// What a screen shows instead of its content: empty, loading or failed.
class KitStatePlaceholder extends StatelessWidget {
  /// Nothing to show yet; the action leads to where content comes from.
  const KitStatePlaceholder.empty({
    required String this.title,
    required String this.message,
    this.actionLabel,
    this.onAction,
    KitIcons this.icon = KitIcons.path,
    super.key,
  }) : assert((actionLabel == null) == (onAction == null), 'Incomplete action'),
       _loading = false,
       _actionKind = KitButtonKind.primary;

  /// Content is on its way: a skeleton in the shape of the empty state.
  const KitStatePlaceholder.loading({super.key})
    : _loading = true,
      icon = null,
      title = null,
      message = null,
      actionLabel = null,
      onAction = null,
      _actionKind = KitButtonKind.primary;

  /// Loading failed; the action tries again.
  const KitStatePlaceholder.error({
    required String this.title,
    required String this.message,
    required String this.actionLabel,
    required VoidCallback this.onAction,
    KitIcons this.icon = KitIcons.cloudSlash,
    super.key,
  }) : _loading = false,
       _actionKind = KitButtonKind.secondary;

  /// The icon on top.
  final KitIcons? icon;

  /// What happened, in a few words.
  final String? title;

  /// What it means or what to do.
  final String? message;

  /// Label of the action.
  final String? actionLabel;

  /// The action.
  final VoidCallback? onAction;

  final bool _loading;
  final KitButtonKind _actionKind;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final colors = StepfoldColors.of(context);
    if (_loading) return const _Skeleton();
    return KitSurface(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Spacing.s8,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: Spacing.s8,
            children: [
              KitIcon(
                icon!,
                size: 22,
                color: _actionKind == KitButtonKind.secondary
                    ? scheme.error
                    : scheme.onSurfaceVariant,
                fillColor: scheme.primary.withValues(
                  alpha: colors.iconFillIdle,
                ),
              ),
              Expanded(child: Text(title!, style: theme.textTheme.titleMedium)),
            ],
          ),
          Text(
            message!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          if (actionLabel case final label?)
            KitButton(kind: _actionKind, label: label, onPressed: onAction),
        ],
      ),
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHighest;
    Widget block(double width, double height, double radius) => Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
    return Semantics(
      label: MaterialLocalizations.of(context).refreshIndicatorSemanticLabel,
      child: KitSurface(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: Spacing.s12,
          children: [block(120, 10, 5), block(216, 10, 5), block(260, 10, 5)],
        ),
      ),
    );
  }
}
