import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/theme/stepfold_colors.dart';

/// A thin bar of progress toward a goal, 8 tall, fully rounded.
///
/// In [debt] it turns calm amber: steps are owed, nothing is broken.
class KitProgressBar extends StatelessWidget {
  /// Creates the bar filled to [value], from 0 to 1.
  const KitProgressBar({required this.value, this.debt = false, super.key});

  /// How full, from 0 to 1; values outside are clamped.
  final double value;

  /// Whether the reserve is below zero.
  final bool debt;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fill = debt ? StepfoldColors.of(context).debt : scheme.primary;
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(4)),
      child: SizedBox(
        height: 8,
        child: ColoredBox(
          color: scheme.surfaceContainerHighest,
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: FractionallySizedBox(
              widthFactor: value.clamp(0, 1),
              heightFactor: 1,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: fill,
                  shape: const StadiumBorder(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
