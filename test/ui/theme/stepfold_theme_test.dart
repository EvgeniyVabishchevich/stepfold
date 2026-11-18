import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/theme/theme.dart';

/// WCAG contrast ratio of two opaque colors, from 1 to 21.
double contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final (hi, lo) = la > lb ? (la, lb) : (lb, la);
  return (hi + 0.05) / (lo + 0.05);
}

void main() {
  final themes = {'light': StepfoldTheme.light, 'dark': StepfoldTheme.dark};

  for (final MapEntry(key: name, value: theme) in themes.entries) {
    group('$name theme', () {
      final scheme = theme.colorScheme;
      final colors = theme.extension<StepfoldColors>()!;

      test('carries the kit colors', () {
        expect(theme.extension<StepfoldColors>(), isNotNull);
        expect(theme.scaffoldBackgroundColor, colors.background);
      });

      // Text needs 4.5:1 (WCAG AA). Pairs the kit actually draws.
      final textPairs = {
        'onSurface on background': (scheme.onSurface, colors.background),
        'onSurface on surface': (scheme.onSurface, scheme.surface),
        'onSurfaceVariant on background': (
          scheme.onSurfaceVariant,
          colors.background,
        ),
        'onSurfaceVariant on surface': (
          scheme.onSurfaceVariant,
          scheme.surface,
        ),
        'onPrimary on primary': (scheme.onPrimary, scheme.primary),
        'primaryText on background': (colors.primaryText, colors.background),
        'primaryText on surface': (colors.primaryText, scheme.surface),
        'onError on error': (scheme.onError, scheme.error),
      };
      for (final MapEntry(key: pair, value: (fg, bg)) in textPairs.entries) {
        test('text contrast: $pair', () {
          expect(contrast(fg, bg), greaterThanOrEqualTo(4.5));
        });
      }

      // Bars and icons are graphics: 3:1 is enough.
      test('debt bar stands out from its track', () {
        expect(
          contrast(colors.debt, scheme.surfaceContainerHighest),
          greaterThanOrEqualTo(3),
        );
      });

      test('text is Inter, and the big number has equal-width digits', () {
        final text = theme.textTheme;
        for (final style in [
          text.headlineMedium,
          text.titleLarge,
          text.titleMedium,
          text.bodyLarge,
          text.labelMedium,
          text.displayMedium,
        ]) {
          expect(style?.fontFamily, StepfoldTheme.fontFamily);
        }
        expect(
          text.displayMedium?.fontFeatures,
          contains(const FontFeature.tabularFigures()),
        );
      });
    });
  }
}
