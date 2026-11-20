import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:walks/domain/domain.dart';
import 'package:walks/ui/kit/kit.dart';
import 'package:walks/ui/l10n/l10n.dart';
import 'package:walks/ui/pages/history/bloc/history_state.dart';
import 'package:walks/ui/pages/history/widgets/history_labels.dart';
import 'package:walks/ui/theme/theme.dart';

/// Collects a manual addition or removes an existing one.
class HistoryEditor extends StatefulWidget {
  /// Creates the editor for the eligible days. [editing] fixes the day.
  const HistoryEditor({
    required this.progress,
    required this.today,
    required this.firstDay,
    this.editing,
    super.key,
  });

  /// The saved additions the form may edit.
  final Progress progress;

  /// The newest day offered by the form.
  final Day today;

  /// The oldest day offered by the form.
  final Day firstDay;

  /// The day whose row opened the editor, if any.
  final Day? editing;

  @override
  State<HistoryEditor> createState() => _HistoryEditorState();
}

class _HistoryEditorState extends State<HistoryEditor> {
  final _form = GlobalKey<FormState>();
  late Day _day = widget.editing ?? widget.today;
  late final TextEditingController _steps = TextEditingController(
    text: _amountFor(_day),
  );

  String _amountFor(Day day) => widget.progress.stepsOf(day).isManual
      ? widget.progress.stepsOf(day).manual.toString()
      : '';

  void _save() {
    if (!_form.currentState!.validate()) return;
    Navigator.of(
      context,
    ).pop<HistoryEdit>((day: _day, steps: int.parse(_steps.text)));
  }

  @override
  void dispose() {
    _steps.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final editing = widget.editing;
    final addition = widget.progress.stepsOf(_day);
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          Spacing.s16,
          Spacing.s16,
          Spacing.s16,
          MediaQuery.viewInsetsOf(context).bottom + Spacing.s16,
        ),
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: Spacing.s12,
            children: [
              Text(
                editing != null && addition.isManual
                    ? l10n.historyEditTitle
                    : l10n.historyAddSteps,
                style: theme.textTheme.headlineMedium,
              ),
              if (editing != null)
                Text(historyDayLabel(context, editing, widget.today))
              else
                DropdownButtonFormField<Day>(
                  initialValue: _day,
                  decoration: InputDecoration(labelText: l10n.historyDateField),
                  items: [
                    for (
                      var day = widget.today;
                      !day.isBefore(widget.firstDay);
                      day = day - 1
                    )
                      DropdownMenuItem(
                        value: day,
                        child: Text(
                          historyDayLabel(context, day, widget.today),
                        ),
                      ),
                  ],
                  onChanged: (day) {
                    if (day == null) return;
                    _day = day;
                    _steps.text = _amountFor(day);
                  },
                ),
              TextFormField(
                key: const Key('history-step-amount'),
                controller: _steps,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(labelText: l10n.historyAmount),
                validator: (text) => (int.tryParse(text ?? '') ?? 0) > 0
                    ? null
                    : l10n.historyInvalidAmount,
                onFieldSubmitted: (_) => _save(),
              ),
              KitButton(
                kind: KitButtonKind.primary,
                label: l10n.historySave,
                onPressed: _save,
              ),
              if (editing != null && addition.isManual)
                KitButton(
                  kind: KitButtonKind.secondary,
                  label: l10n.historyRemove,
                  onPressed: () => Navigator.of(
                    context,
                  ).pop<HistoryEdit>((day: editing, steps: 0)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
