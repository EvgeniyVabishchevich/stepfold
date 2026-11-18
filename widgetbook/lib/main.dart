import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart' as m;
import 'package:walks/ui/l10n/l10n.dart';
import 'package:walks/ui/theme/theme.dart';
import 'package:walks_widgetbook/main.directories.g.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

Future<void> main() async {
  m.WidgetsFlutterBinding.ensureInitialized();
  await _loadInter();
  m.runApp(const StepfoldWidgetbook());
}

/// The app's fonts and icons live in the `walks` package, so here they sit
/// under `packages/walks/`, while the kit asks for `assets/...` and `Inter`.
Future<void> _loadInter() async {
  final inter = FontLoader('Inter');
  for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
    inter.addFont(
      rootBundle.load('$_walks/assets/fonts/inter/Inter-$weight.ttf'),
    );
  }
  await inter.load();
}

const _walks = 'packages/walks';

/// Sends the kit's `assets/...` to the copies of the `walks` package.
class _WalksAssets extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) =>
      rootBundle.load(key.startsWith('assets/') ? '$_walks/$key' : key);
}

final _walksAssets = _WalksAssets();

/// The catalog of the kit. Use cases are found by the generator:
/// `fvm dart run build_runner build` in this folder after adding one.
@widgetbook.App()
class StepfoldWidgetbook extends m.StatelessWidget {
  const StepfoldWidgetbook({super.key});

  @override
  m.Widget build(m.BuildContext context) {
    return Widgetbook(
      directories: directories,
      // The app is on material_ui, whose ThemeData is not Flutter's, so the
      // ready Material addons do not fit: the app and the theme are ours.
      appBuilder: (context, child) => m.DefaultAssetBundle(
        bundle: _walksAssets,
        child: m.MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: appLocalizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: m.Material(child: child),
        ),
      ),
      addons: [
        ThemeAddon<m.ThemeData>(
          themes: [
            WidgetbookTheme(name: 'Светлая', data: StepfoldTheme.light),
            WidgetbookTheme(name: 'Тёмная', data: StepfoldTheme.dark),
          ],
          themeBuilder: (context, theme, child) => m.Theme(
            data: theme,
            child: m.ColoredBox(
              color: theme.scaffoldBackgroundColor,
              child: m.DefaultTextStyle(
                style: theme.textTheme.bodyLarge!,
                child: child,
              ),
            ),
          ),
        ),
        ViewportAddon([
          Viewports.none,
          IosViewports.iPhone13,
          AndroidViewports.samsungGalaxyS20,
        ]),
        TextScaleAddon(min: 1, max: 2, divisions: 4),
        AlignmentAddon(),
      ],
    );
  }
}
