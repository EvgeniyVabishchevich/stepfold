import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/kit/kit_button.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

Widget _button(BuildContext context, KitButtonKind kind, String label) {
  final enabled = context.knobs.boolean(label: 'Активна', initialValue: true);
  return KitButton(
    kind: kind,
    label: context.knobs.string(label: 'Подпись', initialValue: label),
    loading: context.knobs.boolean(label: 'Загрузка'),
    onPressed: enabled ? () {} : null,
  );
}

@widgetbook.UseCase(name: 'Основная', type: KitButton)
Widget primaryButton(BuildContext context) =>
    _button(context, KitButtonKind.primary, 'Открыть главу');

@widgetbook.UseCase(name: 'Второстепенная', type: KitButton)
Widget secondaryButton(BuildContext context) =>
    _button(context, KitButtonKind.secondary, 'Выбрать цель');

@widgetbook.UseCase(name: 'Текстовая', type: KitButton)
Widget textButton(BuildContext context) =>
    _button(context, KitButtonKind.text, 'Не сейчас');
