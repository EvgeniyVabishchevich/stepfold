import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/kit/kit_icon.dart';
import 'package:walks/ui/kit/kit_top_bar.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Панель', type: KitTopBar)
Widget topBar(BuildContext context) {
  final back = context.knobs.boolean(label: 'Назад', initialValue: true);
  final action = context.knobs.boolean(label: 'Действие справа');
  return KitTopBar(
    title: context.knobs.string(label: 'Заголовок', initialValue: 'Выбор цели'),
    onBack: back ? () {} : null,
    backLabel: 'Назад',
    action: action
        ? KitTopBarAction(
            icon: KitIcons.gearSix,
            label: 'Настройки',
            onPressed: () {},
          )
        : null,
  );
}
