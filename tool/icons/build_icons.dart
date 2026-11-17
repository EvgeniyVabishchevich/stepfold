// Builds the icon assets of the kit from the Phosphor sources.
//
// Run from the project root: `fvm dart run tool/icons/build_icons.dart`.
//
// A duotone icon has two layers, a fill (opacity 0.2) and a line, both in
// `currentColor`. The app paints them in different colors, so each icon is
// split into `<name>_fill.svg` and `<name>_line.svg`. Regular icons are
// copied as they are. Sources: `@phosphor-icons/core` 2.1.1, MIT.
import 'dart:io';

const _sources = 'tool/icons/phosphor';
const _out = 'assets/icons';

/// Optical fixes: a narrower viewBox draws the icon larger in its 24 box.
/// `cards` is flat and wide, 16.5 px tall against 19–21 for the others,
/// so it is drawn about 10 % larger (docs/design.md, «Иконки»).
const _viewBoxes = {'cards': '12 12 232 232'};

final _path = RegExp('<path[^>]*/>');

void main() {
  Directory(_out).createSync(recursive: true);
  for (final file in Directory(_sources).listSync().whereType<File>()) {
    final name = file.uri.pathSegments.last;
    if (!name.endsWith('.svg')) continue;
    final svg = file.readAsStringSync();
    if (name.endsWith('-duotone.svg')) {
      _split(name.replaceAll('-duotone.svg', ''), svg);
    } else {
      final icon = name.replaceAll('.svg', '');
      _write('${_snake(icon)}.svg', _withViewBox(icon, svg));
    }
  }
}

void _split(String icon, String svg) {
  final paths = _path.allMatches(svg).map((m) => m[0]!).toList();
  final fill = paths.where((p) => p.contains('opacity="0.2"')).toList();
  final line = paths.where((p) => !p.contains('opacity="0.2"')).toList();
  if (fill.length != 1 || line.isEmpty) {
    throw StateError('$icon: expected one fill path and a line, got $paths');
  }
  final open = svg.substring(0, svg.indexOf('>') + 1);
  String layer(List<String> parts) =>
      _withViewBox(icon, '$open${parts.join()}</svg>');

  _write(
    '${_snake(icon)}_fill.svg',
    layer([fill.single.replaceAll(' opacity="0.2"', '')]),
  );
  _write('${_snake(icon)}_line.svg', layer(line));
}

String _withViewBox(String icon, String svg) {
  final viewBox = _viewBoxes[icon];
  if (viewBox == null) return svg;
  return svg.replaceFirst('viewBox="0 0 256 256"', 'viewBox="$viewBox"');
}

String _snake(String name) => name.replaceAll('-', '_');

void _write(String name, String svg) {
  File('$_out/$name').writeAsStringSync('$svg\n');
  stdout.writeln('$_out/$name');
}
