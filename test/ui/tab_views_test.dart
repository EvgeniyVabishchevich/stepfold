import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/pages/pages.dart';

import '../helpers/pump_view.dart';

void main() {
  // Placeholders for now: each shows its name from the localized strings.
  const views = <String, Widget>{
    'Каталог': CatalogView(),
    'Мир': WorldView(),
    'Альбом': AlbumView(),
  };

  for (final MapEntry(key: title, value: view) in views.entries) {
    testWidgets('${view.runtimeType} shows "$title"', (tester) async {
      await tester.pumpView(view);

      expect(find.text(title), findsOneWidget);
    });
  }
}
