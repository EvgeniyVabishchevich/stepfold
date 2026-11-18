import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/kit/kit.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Пусто', type: KitStatePlaceholder)
Widget emptyState(BuildContext context) => Center(
  child: KitStatePlaceholder.empty(
    title: context.knobs.string(
      label: 'Заголовок',
      initialValue: 'Здесь пока пусто',
    ),
    message: context.knobs.string(
      label: 'Текст',
      initialValue: 'Выбери первую главу, и шаги пойдут в неё.',
    ),
    actionLabel: 'Выбрать цель',
    onAction: () {},
  ),
);

@widgetbook.UseCase(name: 'Загрузка', type: KitStatePlaceholder)
Widget loadingState(BuildContext context) =>
    const Center(child: KitStatePlaceholder.loading());

@widgetbook.UseCase(name: 'Ошибка', type: KitStatePlaceholder)
Widget errorState(BuildContext context) => Center(
  child: KitStatePlaceholder.error(
    title: 'Не удалось загрузить',
    message: 'Проверь интернет и попробуй ещё раз.',
    actionLabel: 'Повторить',
    onAction: () {},
  ),
);
