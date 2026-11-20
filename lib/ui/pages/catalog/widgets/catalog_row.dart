import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/theme/theme.dart';

/// A tappable catalog row, shared by progressions and chapters.
class CatalogRow extends StatelessWidget {
  /// Creates the row.
  const CatalogRow({required this.child, this.color, this.onTap, super.key});

  /// Contents of the row.
  final Widget child;

  /// Overrides the normal surface color for chapter states.
  final Color? color;

  /// The action advertised by the row.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: color ?? Theme.of(context).colorScheme.surface,
    borderRadius: BorderRadius.circular(Radii.card),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.s16,
          vertical: Spacing.s12,
        ),
        child: child,
      ),
    ),
  );
}
