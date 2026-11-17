import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_ui/material_ui.dart';

/// Icons of the kit: Phosphor, built by `tool/icons/build_icons.dart`.
enum KitIcons {
  /// Today tab.
  footprints(duotone: true),

  /// Catalog tab.
  books(duotone: true),

  /// World tab.
  globeHemisphereWest(duotone: true),

  /// Album tab.
  cards(duotone: true),

  /// Empty state.
  path(duotone: true),

  /// Loading failed.
  cloudSlash(duotone: true),

  /// Back in the top bar.
  arrowLeft(duotone: false),

  /// Settings.
  gearSix(duotone: false);

  const KitIcons({required this.duotone});

  /// Whether the icon has a fill layer under its line.
  final bool duotone;

  String get _file =>
      name.replaceAllMapped(RegExp('[A-Z]'), (m) => '_${m[0]!.toLowerCase()}');

  /// Asset of the line, or of the whole icon when it is not duotone.
  String get lineAsset =>
      duotone ? 'assets/icons/${_file}_line.svg' : 'assets/icons/$_file.svg';

  /// Asset of the fill layer, or null when the icon has none.
  String? get fillAsset => duotone ? 'assets/icons/${_file}_fill.svg' : null;
}

/// An icon of the kit: a line in [color] over a fill in [fillColor].
///
/// The fill is drawn only for duotone icons and only when [fillColor] is
/// set; its opacity comes with the color, from the theme.
class KitIcon extends StatelessWidget {
  /// Creates the icon.
  const KitIcon(
    this.icon, {
    required this.color,
    this.fillColor,
    this.size = 24,
    this.semanticLabel,
    super.key,
  });

  /// Which icon.
  final KitIcons icon;

  /// Color of the line.
  final Color color;

  /// Color of the fill layer, with its opacity.
  final Color? fillColor;

  /// Width and height.
  final double size;

  /// What a screen reader says; null hides the icon from it.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final fill = icon.fillAsset;
    final fillColor = this.fillColor;
    final picture = SizedBox.square(
      dimension: size,
      child: Stack(
        // Not directional: an icon looks the same in either reading order.
        alignment: Alignment.center,
        children: [
          if (fill != null && fillColor != null) _layer(fill, fillColor),
          _layer(icon.lineAsset, color),
        ],
      ),
    );
    final label = semanticLabel;
    if (label == null) return ExcludeSemantics(child: picture);
    return Semantics(label: label, image: true, child: picture);
  }

  Widget _layer(String asset, Color color) => SvgPicture.asset(
    asset,
    width: size,
    height: size,
    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
  );
}
