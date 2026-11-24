import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/theme/theme.dart';

/// Palette and lighting of the relief components.
enum KitRelief {
  /// The palette for light surfaces.
  light(
    surface: Color(0xFFFAF6F8),
    highlight: Color(0xFFFFFAFC),
    tint: Color(0xFFF6E6EE),
    recess: Color(0xFFEDDAE5),
    progressSurface: Color(0xFFF4E9F0),
    track: Color(0xFFDDC2D2),
    accent: Color(0xFF9B345E),
    action: Color(0xFF943358),
    actionEnd: Color(0xFF772444),
    pressed: Color(0xFF68213E),
    rim: Color(0xFF69203E),
    onAction: Colors.white,
    disabled: Color(0xFFE1D7DF),
    onDisabled: Color(0xFF64596A),
    shadow: Color(0xFF51243A),
  ),

  /// The palette for dark surfaces.
  dark(
    surface: Color(0xFF232B44),
    highlight: Color(0xFF3C3C58),
    tint: Color(0xFF342D47),
    recess: Color(0xFF282139),
    progressSurface: Color(0xFF3C3650),
    track: Color(0xFF5C4663),
    accent: Color(0xFFF2ABC4),
    action: Color(0xFFEEA5BF),
    actionEnd: Color(0xFFD983A6),
    pressed: Color(0xFFD382A3),
    rim: Color(0xFF9E5476),
    onAction: Color(0xFF351829),
    disabled: Color(0xFF433C54),
    onDisabled: Color(0xFFBFB2C6),
    shadow: Color(0xFF070917),
  );

  const KitRelief({
    required this.surface,
    required this.highlight,
    required this.tint,
    required this.recess,
    required this.progressSurface,
    required this.track,
    required this.accent,
    required this.action,
    required this.actionEnd,
    required this.pressed,
    required this.rim,
    required this.onAction,
    required this.disabled,
    required this.onDisabled,
    required this.shadow,
  });

  /// The palette for the current brightness.
  static KitRelief of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? dark : light;

  /// Raised neutral surface.
  final Color surface;

  /// Upper color of the featured surface.
  final Color highlight;

  /// Lower color of the featured surface.
  final Color tint;

  /// Recessed surface.
  final Color recess;

  /// Softer inset behind the remaining steps and progress track.
  final Color progressSurface;

  /// Unfilled progress track and pressed secondary fill.
  final Color track;

  /// Accent for progress, text and selected navigation.
  final Color accent;

  /// Upper color of the primary action.
  final Color action;

  /// Lower color of the primary action.
  final Color actionEnd;

  /// Pressed primary action fill.
  final Color pressed;

  /// Lower edge of the primary action.
  final Color rim;

  /// Foreground of the primary action.
  final Color onAction;

  /// Disabled control fill.
  final Color disabled;

  /// Disabled control foreground.
  final Color onDisabled;

  /// Base of the shadows.
  final Color shadow;

  /// Whether the palette is dark.
  bool get isDark => this == dark;
}

/// Lighting and shape roles used in the kit.
enum KitSurfaceKind {
  /// A neutral panel above the page.
  raised,

  /// The main card, with a stronger tint and separation.
  featured,

  /// A smaller panel inset into another surface.
  recessed,

  /// A softly recessed panel for reading progress.
  progress,
}

/// A reusable surface with padding and lighting for its visual role.
class KitSurface extends StatelessWidget {
  /// Creates a surface.
  const KitSurface({
    required this.child,
    this.kind = KitSurfaceKind.raised,
    this.padding = const EdgeInsets.all(Spacing.s16),
    super.key,
  });

  /// The surface role.
  final KitSurfaceKind kind;

  /// Insets around the contents.
  final EdgeInsetsGeometry padding;

  /// Contents of the surface.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = KitRelief.of(context);
    final featured = kind == KitSurfaceKind.featured;
    final progress = kind == KitSurfaceKind.progress;
    final recessed = progress || kind == KitSurfaceKind.recessed;
    final inset = progress ? colors.progressSurface : colors.recess;
    final insetShadow = progress
        ? (colors.isDark ? .12 : .06)
        : (colors.isDark ? .28 : .12);
    final radius = BorderRadius.circular(
      recessed
          ? 16
          : featured
          ? Radii.sheet
          : Radii.card,
    );
    final decoration = BoxDecoration(
      color: recessed ? inset : colors.surface,
      gradient: featured
          ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colors.highlight, colors.tint],
            )
          : recessed
          ? LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0, 0.20],
              colors: [
                Color.alphaBlend(
                  colors.shadow.withValues(alpha: insetShadow),
                  inset,
                ),
                inset,
              ],
            )
          : null,
      borderRadius: radius,
      border: recessed
          ? null
          : Border.all(
              color: Colors.white.withValues(alpha: colors.isDark ? .12 : .52),
            ),
      boxShadow: recessed
          ? null
          : [
              BoxShadow(
                color: colors.shadow.withValues(
                  alpha: colors.isDark ? .40 : .15,
                ),
                offset: Offset(0, featured ? 8 : 4),
                blurRadius: featured ? 18 : 10,
                spreadRadius: -4,
              ),
              BoxShadow(
                color: colors.shadow.withValues(
                  alpha: colors.isDark ? .26 : .10,
                ),
                offset: const Offset(0, 2),
                blurRadius: 4,
                spreadRadius: -1,
              ),
            ],
    );
    return DecoratedBox(
      decoration: decoration,
      child: Padding(padding: padding, child: child),
    );
  }
}
