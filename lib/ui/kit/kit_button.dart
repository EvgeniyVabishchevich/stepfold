import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/kit/kit_surface.dart';
import 'package:walks/ui/theme/theme.dart';

/// The three emphasis levels of a kit button.
enum KitButtonKind {
  /// The filled, raised action.
  primary,

  /// The tonal action.
  secondary,

  /// A quiet text action.
  text,
}

/// An action with relief and a stable size while it is loading.
class KitButton extends StatefulWidget {
  /// Creates a button of [kind].
  const KitButton({
    required this.kind,
    required this.label,
    required this.onPressed,
    this.loading = false,
    super.key,
  });

  /// The emphasis level.
  final KitButtonKind kind;

  /// The readable action label.
  final String label;

  /// The action, or null when the control is disabled.
  final VoidCallback? onPressed;

  /// Whether the action is in progress.
  final bool loading;

  @override
  State<KitButton> createState() => _KitButtonState();
}

class _KitButtonState extends State<KitButton> {
  final _states = WidgetStatesController();

  @override
  void dispose() {
    _states.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = KitRelief.of(context);
    final primary = widget.kind == KitButtonKind.primary;
    final tonal = widget.kind == KitButtonKind.secondary;
    final disabled = widget.onPressed == null && !widget.loading;
    final foreground = disabled
        ? colors.onDisabled
        : primary
        ? colors.onAction
        : tonal
        ? Theme.of(context).colorScheme.onSurface
        : colors.accent;
    final style = ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(Size(48, 52)),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: Spacing.s24, vertical: Spacing.s12),
      ),
      shape: const WidgetStatePropertyAll(StadiumBorder()),
      side: const WidgetStatePropertyAll(BorderSide.none),
      backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
      foregroundColor: WidgetStatePropertyAll(foreground),
      overlayColor: WidgetStatePropertyAll(foreground.withValues(alpha: .10)),
      elevation: const WidgetStatePropertyAll(0),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      textStyle: WidgetStatePropertyAll(
        Theme.of(context).textTheme.titleMedium?.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
    final label = Text(widget.label, textAlign: TextAlign.center);
    final child = widget.loading
        ? Stack(
            alignment: Alignment.center,
            children: [
              Visibility.maintain(visible: false, child: label),
              SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: foreground,
                ),
              ),
            ],
          )
        : label;
    final action = widget.loading ? () {} : widget.onPressed;
    final button = switch (widget.kind) {
      KitButtonKind.primary => FilledButton(
        onPressed: action,
        style: style,
        statesController: _states,
        child: child,
      ),
      KitButtonKind.secondary => OutlinedButton(
        onPressed: action,
        style: style,
        statesController: _states,
        child: child,
      ),
      KitButtonKind.text => TextButton(
        onPressed: action,
        style: style,
        statesController: _states,
        child: child,
      ),
    };
    final raised = primary && !disabled;
    final control = Stack(
      fit: StackFit.passthrough,
      children: [
        Positioned.fill(
          child: ValueListenableBuilder(
            valueListenable: _states,
            builder: (context, states, _) {
              final pressed = states.contains(WidgetState.pressed);
              final color = disabled
                  ? tonal || primary
                        ? colors.disabled
                        : Colors.transparent
                  : primary
                  ? colors.pressed
                  : tonal
                  ? pressed
                        ? colors.track
                        : colors.recess
                  : pressed
                  ? colors.recess
                  : Colors.transparent;
              return Stack(
                fit: StackFit.expand,
                children: [
                  if (raised && !pressed)
                    DecoratedBox(
                      decoration: ShapeDecoration(
                        color: colors.rim,
                        shape: const StadiumBorder(),
                      ),
                    ),
                  Positioned.fill(
                    top: raised && pressed ? 3 : 0,
                    bottom: raised && !pressed ? 4 : 0,
                    child: DecoratedBox(
                      decoration: ShapeDecoration(
                        color: raised && !pressed ? null : color,
                        gradient: raised && !pressed
                            ? LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [colors.action, colors.actionEnd],
                              )
                            : null,
                        shape: const StadiumBorder(),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: primary ? 4 : 0),
          child: button,
        ),
      ],
    );
    if (!widget.loading) return control;
    return Semantics(
      label: widget.label,
      button: true,
      enabled: false,
      excludeSemantics: true,
      child: AbsorbPointer(child: ExcludeFocus(child: control)),
    );
  }
}
