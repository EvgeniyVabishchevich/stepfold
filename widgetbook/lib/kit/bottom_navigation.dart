import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/kit/kit_bottom_navigation.dart';
import 'package:walks/ui/kit/kit_icon.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Вкладки', type: KitBottomNavigation)
Widget bottomNavigation(BuildContext context) => Align(
  alignment: Alignment.bottomCenter,
  child: KitBottomNavigation(
    selectedIndex: context.knobs.int.slider(
      label: 'Открыта',
      max: 3,
      divisions: 3,
    ),
    onSelected: (_) {},
    tabs: const [
      KitTab(icon: KitIcons.footprints, label: 'Сегодня'),
      KitTab(icon: KitIcons.books, label: 'Каталог'),
      KitTab(icon: KitIcons.globeHemisphereWest, label: 'Мир'),
      KitTab(icon: KitIcons.cards, label: 'Альбом'),
    ],
  ),
);
