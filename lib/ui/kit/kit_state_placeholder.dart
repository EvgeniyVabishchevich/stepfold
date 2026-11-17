import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/kit/kit_button.dart';
import 'package:walks/ui/kit/kit_icon.dart';
import 'package:walks/ui/theme/dimens.dart';
import 'package:walks/ui/theme/stepfold_colors.dart';

/// What a screen shows instead of its content: empty, loading or failed.
class KitStatePlaceholder extends StatelessWidget {
  /// Nothing to show yet; the action leads to where content comes from.
  const KitStatePlaceholder.empty({
    required String this.title,
    required String this.message,
    required String this.actionLabel,
    required VoidCallback this.onAction,
    KitIcons this.icon = KitIcons.path,
    super.key,
  }) : _loading = false,
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
    return Padding(
      padding: const EdgeInsets.all(Spacing.s24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          KitIcon(
            icon!,
            size: 64,
            color: scheme.onSurfaceVariant,
            fillColor: scheme.primary.withValues(alpha: colors.iconFillIdle),
          ),
          const SizedBox(height: Spacing.s16),
          Text(
            title!,
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Spacing.s8),
          Text(
            message!,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Spacing.s24),
          KitButton(
            kind: _actionKind,
            label: actionLabel!,
            onPressed: onAction,
          ),
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
      child: Padding(
        padding: const EdgeInsets.all(Spacing.s24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            block(64, 64, Radii.small),
            const SizedBox(height: Spacing.s16),
            block(200, 20, 10),
            const SizedBox(height: Spacing.s12),
            block(280, 14, 7),
            const SizedBox(height: Spacing.s8),
            block(220, 14, 7),
            const SizedBox(height: Spacing.s24),
            block(160, 48, Radii.small),
          ],
        ),
      ),
    );
  }
}
