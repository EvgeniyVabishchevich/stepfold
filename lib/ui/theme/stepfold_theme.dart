import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/theme/dimens.dart';
import 'package:walks/ui/theme/stepfold_colors.dart';

/// The two themes of the app, built from the design tokens in Penpot.
///
/// Roles `ColorScheme` knows go there; the rest lives in [StepfoldColors].
/// The palette and its reasons are in docs/design.md.
abstract final class StepfoldTheme {
  /// Font family of the whole app, bundled in `assets/fonts/inter/`.
  static const fontFamily = 'Inter';

  /// The light theme.
  static final ThemeData light = _build(
    const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFFB34D78),
      onPrimary: Color(0xFFFFFFFF),
      secondary: Color(0xFFB34D78),
      onSecondary: Color(0xFFFFFFFF),
      error: Color(0xFFB3261E),
      onError: Color(0xFFFFFFFF),
      surface: Color(0xFFFAF6F8),
      onSurface: Color(0xFF1E2540),
      onSurfaceVariant: Color(0xFF5E6078),
      surfaceContainerHighest: Color(0xFFE0D6DD),
      outline: Color(0xFF7D7488),
      outlineVariant: Color(0xFFDACFD6),
    ),
    StepfoldColors.light,
  );

  /// The dark theme.
  static final ThemeData dark = _build(
    const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFEE9FB8),
      onPrimary: Color(0xFF1A2138),
      secondary: Color(0xFFEE9FB8),
      onSecondary: Color(0xFF1A2138),
      error: Color(0xFFF2B8B5),
      onError: Color(0xFF601410),
      surface: Color(0xFF27304B),
      onSurface: Color(0xFFEDE6EC),
      onSurfaceVariant: Color(0xFFB4B2C6),
      surfaceContainerHighest: Color(0xFF383F5E),
      outline: Color(0xFF8E92AE),
      outlineVariant: Color(0xFF3A4262),
    ),
    StepfoldColors.dark,
  );

  static ThemeData _build(ColorScheme scheme, StepfoldColors colors) {
    final base = ThemeData(
      colorScheme: scheme,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: colors.background,
      extensions: [colors],
    );
    final textTheme = _textTheme(base.textTheme);
    final label = textTheme.titleMedium;
    return base.copyWith(
      textTheme: textTheme,
      filledButtonTheme: FilledButtonThemeData(
        style: _button(
          label: label,
          foreground: scheme.onPrimary,
          background: scheme.primary,
          colors: colors,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: _button(
          label: label,
          foreground: colors.primaryText,
          colors: colors,
          border: scheme.outline,
          disabledBorder: scheme.outlineVariant,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: _button(
          label: label,
          foreground: colors.primaryText,
          colors: colors,
        ),
      ),
    );
  }

  /// One look for the three buttons of the kit: 48 tall, radius `small`,
  /// a pressed layer of the label color at 12 %, as in Material 3.
  static ButtonStyle _button({
    required TextStyle? label,
    required Color foreground,
    required StepfoldColors colors,
    Color? background,
    Color? border,
    Color? disabledBorder,
  }) {
    return ButtonStyle(
      textStyle: WidgetStatePropertyAll(label),
      minimumSize: const WidgetStatePropertyAll(Size(64, 48)),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: Spacing.s24),
      ),
      shape: const WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(Radii.small)),
        ),
      ),
      foregroundColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.disabled)
            ? colors.onSurfaceDisabled
            : foreground,
      ),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (background == null) return Colors.transparent;
        return states.contains(WidgetState.disabled)
            ? colors.surfaceDisabled
            : background;
      }),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return foreground.withValues(alpha: 0.12);
        }
        if (states.contains(WidgetState.focused) ||
            states.contains(WidgetState.hovered)) {
          return foreground.withValues(alpha: 0.08);
        }
        return null;
      }),
      side: border == null
          ? null
          : WidgetStateProperty.resolveWith(
              (states) => BorderSide(
                color: states.contains(WidgetState.disabled)
                    ? disabledBorder ?? border
                    : border,
              ),
            ),
      elevation: const WidgetStatePropertyAll(0),
    );
  }

  /// The styles of the kit, put on the closest Material 3 roles.
  ///
  /// The other roles keep Material sizes and the Inter family from
  /// `fontFamily` above.
  static TextTheme _textTheme(TextTheme base) {
    return base.copyWith(
      // ScreenTitle: the Today heading.
      displayLarge: _style(
        base.displayLarge,
        44,
        49.28,
        FontWeight.w700,
      )?.copyWith(letterSpacing: -1.5),
      // Headline: the one main phrase of a screen.
      headlineMedium: _style(base.headlineMedium, 28, 36, FontWeight.w600),
      // Title: section and app bar titles.
      titleLarge: _style(base.titleLarge, 22, 28, FontWeight.w600),
      // Subtitle: button labels and subheads.
      titleMedium: _style(base.titleMedium, 16, 24, FontWeight.w500),
      // Body.
      bodyLarge: _style(base.bodyLarge, 16, 24, FontWeight.w400),
      // Caption: tab labels and small notes.
      labelMedium: _style(base.labelMedium, 13, 18, FontWeight.w500),
      // Number: a big step count. Equal-width digits, so it does not jump.
      displayMedium: _style(
        base.displayMedium,
        48,
        56,
        FontWeight.w700,
      )!.copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
    );
  }

  static TextStyle? _style(
    TextStyle? base,
    double size,
    double lineHeight,
    FontWeight weight,
  ) {
    return base?.copyWith(
      fontFamily: fontFamily,
      fontSize: size,
      height: lineHeight / size,
      fontWeight: weight,
      letterSpacing: 0,
    );
  }
}
