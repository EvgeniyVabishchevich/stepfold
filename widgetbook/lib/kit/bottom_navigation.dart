import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/kit/kit.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Вкладки', type: KitBottomNavigation)
Widget bottomNavigation(BuildContext context) => Align(
  alignment: Alignment.bottomCenter,
  child: KitBottomNavigation(
    selectedIndex: context.knobs.int.slider(
      label: 'Открыта',
      max: 4,
      divisions: 4,
    ),
    onSelected: (_) {},
    tabs: const [
      KitTab(icon: KitIcons.navWalk, label: 'Сегодня'),
      KitTab(icon: KitIcons.navCatalog, label: 'Каталог'),
      KitTab(icon: KitIcons.navWorld, label: 'Мир'),
      KitTab(icon: KitIcons.navAlbum, label: 'Альбом'),
      KitTab(icon: KitIcons.navSettings, label: 'Настройки'),
    ],
  ),
);
