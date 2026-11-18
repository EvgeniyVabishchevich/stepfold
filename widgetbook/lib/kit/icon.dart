import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/kit/kit.dart';
import 'package:walks/ui/theme/theme.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Все иконки', type: KitIcon)
Widget allIcons(BuildContext context) {
  final scheme = Theme.of(context).colorScheme;
  final colors = StepfoldColors.of(context);
  final selected = context.knobs.boolean(label: 'Выбрана');
  final size = context.knobs.double.slider(
    label: 'Размер',
    initialValue: 24,
    min: 16,
    max: 96,
  );
  return Center(
    child: Wrap(
      spacing: 24,
      runSpacing: 24,
      children: [
        for (final icon in KitIcons.values)
          KitIcon(
            icon,
            size: size,
            color: selected ? scheme.primary : scheme.onSurfaceVariant,
            fillColor: scheme.primary.withValues(
              alpha: selected ? colors.iconFillSelected : colors.iconFillIdle,
            ),
          ),
      ],
    ),
  );
}
