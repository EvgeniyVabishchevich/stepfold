import 'dart:ui' show lerpDouble;

import 'package:material_ui/material_ui.dart';

/// Colors and opacities of the Stepfold kit that `ColorScheme` has no role
/// for.
///
/// Read with `StepfoldColors.of(context)`. Values come from the design tokens
/// in Penpot (see docs/design.md).
@immutable
class StepfoldColors extends ThemeExtension<StepfoldColors> {
  /// Creates the set; [light] and [dark] are the two the app uses.
  const StepfoldColors({
    required this.background,
    required this.primaryText,
    required this.surfaceDisabled,
    required this.onSurfaceDisabled,
    required this.debt,
    required this.medalBronze,
    required this.medalSilver,
    required this.medalGold,
    required this.iconFillSelected,
    required this.iconFillIdle,
  });

  /// The light theme.
  static const light = StepfoldColors(
    background: Color(0xFFF1EAEE),
    primaryText: Color(0xFFA5416B),
    surfaceDisabled: Color(0xFFE6DFE3),
    onSurfaceDisabled: Color(0xFF9C97A6),
    debt: Color(0xFFA5640E),
    medalBronze: Color(0xFF9A6842),
    medalSilver: Color(0xFF858899),
    medalGold: Color(0xFFA88530),
    iconFillSelected: 0.4,
    iconFillIdle: 0.15,
  );

  /// The dark theme.
  static const dark = StepfoldColors(
    background: Color(0xFF1A2138),
    primaryText: Color(0xFFEE9FB8),
    surfaceDisabled: Color(0xFF2E3652),
    onSurfaceDisabled: Color(0xFF6C7290),
    debt: Color(0xFFE3A64F),
    medalBronze: Color(0xFFC99A78),
    medalSilver: Color(0xFFA9ADBF),
    medalGold: Color(0xFFD2B56A),
    iconFillSelected: 0.5,
    iconFillIdle: 0.3,
  );

  /// Page background under the surfaces.
  final Color background;

  /// Accent for text: a darker `primary` that keeps 4.5:1 on the background.
  final Color primaryText;

  /// Fill of a disabled control.
  final Color surfaceDisabled;

  /// Text and icons of a disabled control.
  final Color onSurfaceDisabled;

  /// Steps owed after spending: calm amber, not an error.
  final Color debt;

  /// Bronze medal.
  final Color medalBronze;

  /// Silver medal.
  final Color medalSilver;

  /// Gold medal.
  final Color medalGold;

  /// Opacity of the duotone fill of the selected tab icon.
  final double iconFillSelected;

  /// Opacity of the duotone fill of the other tab icons.
  final double iconFillIdle;

  /// The set of the nearest theme.
  static StepfoldColors of(BuildContext context) =>
      Theme.of(context).extension<StepfoldColors>()!;

  @override
  StepfoldColors copyWith({
    Color? background,
    Color? primaryText,
    Color? surfaceDisabled,
    Color? onSurfaceDisabled,
    Color? debt,
    Color? medalBronze,
    Color? medalSilver,
    Color? medalGold,
    double? iconFillSelected,
    double? iconFillIdle,
  }) {
    return StepfoldColors(
      background: background ?? this.background,
      primaryText: primaryText ?? this.primaryText,
      surfaceDisabled: surfaceDisabled ?? this.surfaceDisabled,
      onSurfaceDisabled: onSurfaceDisabled ?? this.onSurfaceDisabled,
      debt: debt ?? this.debt,
      medalBronze: medalBronze ?? this.medalBronze,
      medalSilver: medalSilver ?? this.medalSilver,
      medalGold: medalGold ?? this.medalGold,
      iconFillSelected: iconFillSelected ?? this.iconFillSelected,
      iconFillIdle: iconFillIdle ?? this.iconFillIdle,
    );
  }

  @override
  StepfoldColors lerp(StepfoldColors? other, double t) {
    if (other == null) return this;
    return StepfoldColors(
      background: Color.lerp(background, other.background, t)!,
      primaryText: Color.lerp(primaryText, other.primaryText, t)!,
      surfaceDisabled: Color.lerp(surfaceDisabled, other.surfaceDisabled, t)!,
      onSurfaceDisabled: Color.lerp(
        onSurfaceDisabled,
        other.onSurfaceDisabled,
        t,
      )!,
      debt: Color.lerp(debt, other.debt, t)!,
      medalBronze: Color.lerp(medalBronze, other.medalBronze, t)!,
      medalSilver: Color.lerp(medalSilver, other.medalSilver, t)!,
      medalGold: Color.lerp(medalGold, other.medalGold, t)!,
      iconFillSelected: lerpDouble(
        iconFillSelected,
        other.iconFillSelected,
        t,
      )!,
      iconFillIdle: lerpDouble(iconFillIdle, other.iconFillIdle, t)!,
    );
  }
}
