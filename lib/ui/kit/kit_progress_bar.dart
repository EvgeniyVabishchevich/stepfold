import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/kit/kit_surface.dart';

/// The filled share of a goal. A short leading mark indicates debt.
class KitProgressBar extends StatelessWidget {
  /// Creates a bar filled to [value], from zero to one.
  const KitProgressBar({required this.value, this.debt = false, super.key});

  /// How full the progress is.
  final double value;

  /// Whether the available balance is below zero.
  final bool debt;

  @override
  Widget build(BuildContext context) {
    final colors = KitRelief.of(context);
    final fill = debt ? Theme.of(context).colorScheme.error : colors.accent;
    return SizedBox(
      height: 8,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: colors.track,
          shape: const StadiumBorder(),
        ),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: debt
              ? SizedBox(width: 4, height: 8, child: _Fill(color: fill))
              : FractionallySizedBox(
                  widthFactor: value.clamp(0, 1),
                  heightFactor: 1,
                  child: _Fill(color: fill),
                ),
        ),
      ),
    );
  }
}

class _Fill extends StatelessWidget {
  const _Fill({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: ShapeDecoration(color: color, shape: const StadiumBorder()),
  );
}
