import 'package:material_ui/material_ui.dart';

/// The three buttons of the kit.
enum KitButtonKind {
  /// The one main action of a screen: filled.
  primary,

  /// A second action: outlined.
  secondary,

  /// A quiet action: text only.
  text,
}

/// A button of the kit; its look comes from the theme.
///
/// Disabled when [onPressed] is null. While [loading], a spinner replaces
/// the label, the button keeps its width and ignores taps, so a second tap
/// cannot start the action twice.
class KitButton extends StatelessWidget {
  /// Creates a button of [kind].
  const KitButton({
    required this.kind,
    required this.label,
    required this.onPressed,
    this.loading = false,
    super.key,
  });

  /// Filled, outlined or text.
  final KitButtonKind kind;

  /// What the button does, as the user reads it.
  final String label;

  /// The action; null disables the button.
  final VoidCallback? onPressed;

  /// Whether the action is running.
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final child = _Label(label: label, loading: loading);
    // Retain the loading appearance from the kit while blocking activation.
    final onPressed = loading ? _ignore : this.onPressed;
    final button = switch (kind) {
      KitButtonKind.primary => FilledButton(onPressed: onPressed, child: child),
      KitButtonKind.secondary => OutlinedButton(
        onPressed: onPressed,
        child: child,
      ),
      KitButtonKind.text => TextButton(onPressed: onPressed, child: child),
    };
    if (!loading) return button;

    return Semantics(
      label: label,
      button: true,
      enabled: false,
      excludeSemantics: true,
      child: AbsorbPointer(child: ExcludeFocus(child: button)),
    );
  }
}

void _ignore() {}

class _Label extends StatelessWidget {
  const _Label({required this.label, required this.loading});

  final String label;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    if (!loading) return Text(label);
    // The hidden label keeps the width, so the layout does not jump.
    return Stack(
      alignment: Alignment.center,
      children: [
        Visibility.maintain(visible: false, child: Text(label)),
        SizedBox.square(
          dimension: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: DefaultTextStyle.of(context).style.color,
          ),
        ),
      ],
    );
  }
}
