import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/kit/kit.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Полоса', type: KitProgressBar)
Widget progressBar(BuildContext context) => Padding(
  padding: const EdgeInsets.all(24),
  child: KitProgressBar(
    value: context.knobs.double.slider(
      label: 'Заполнено',
      initialValue: 0.6,
      max: 1,
    ),
    debt: context.knobs.boolean(label: 'Долг'),
  ),
);
