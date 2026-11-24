import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:walks/domain/repositories/repositories.dart';
import 'package:walks/ui/core/core.dart';
import 'package:walks/ui/pages/dev_menu/bloc/bloc.dart';
import 'package:walks/ui/pages/dev_menu/widgets/widgets.dart';

/// Whether the build has the developer menu.
const bool devMenuEnabled = !kReleaseMode;

/// Owns the developer menu bloc and shows [DevMenuView].
class DevMenuPage extends StatelessWidget {
  /// Creates the page.
  const DevMenuPage({
    required this.crashReporter,
    required this.nativeCrasher,
    required this.progress,
    super.key,
  });

  /// Reports errors during development.
  final CrashReporter crashReporter;

  /// Triggers a test crash in native code.
  final NativeCrasher nativeCrasher;

  /// Stores the steps credited from the developer menu.
  final ProgressRepository progress;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DevMenuBloc(
        crashReporter: crashReporter,
        nativeCrasher: nativeCrasher,
        progress: progress,
      ),
      child: const DevMenuView(),
    );
  }
}

/// Buttons that produce test errors, and what was done last.
class DevMenuView extends StatelessWidget {
  /// Creates the view; reads [DevMenuBloc] from the context.
  const DevMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DevMenuBloc>();
    return Scaffold(
      appBar: AppBar(title: const Text('Меню разработчика')),
      body: ListView(
        children: [
          const DevMenuSectionTitle('История шагов'),
          BlocBuilder<DevMenuBloc, DevMenuState>(
            builder: (context, state) => ListTile(
              leading: const Icon(Icons.add_circle_outline),
              title: const Text('Добавить шаги за сегодня'),
              subtitle: Text(switch (state.stepAddition) {
                DevStepAddition.idle => 'Прибавить к ручным шагам за сегодня',
                DevStepAddition.saving => 'Сохраняем шаги…',
                DevStepAddition.added => 'Шаги добавлены',
                DevStepAddition.failed => 'Не удалось добавить шаги',
                DevStepAddition.storageFull => 'В хранилище нет места',
              }),
              onTap: state.stepAddition == DevStepAddition.saving
                  ? null
                  : () => _promptForSteps(context, bloc),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Сгенерировать 1 000 дней'),
            subtitle: const Text('Открыть историю на тестовых данных'),
            onTap: () => context.push(Routes.devHistory),
          ),
          const DevMenuSectionTitle('Отчёты о падениях'),
          ListTile(
            leading: const Icon(Icons.report_outlined),
            title: const Text('Нефатальная ошибка'),
            subtitle: const Text('recordError вручную, приложение работает'),
            onTap: () => bloc.add(DevMenuAction.nonFatal),
          ),
          ListTile(
            leading: const Icon(Icons.web_asset_off_outlined),
            title: const Text('Ошибка фреймворка'),
            subtitle: const Text('FlutterError.onError, фатальная'),
            onTap: () => bloc.add(DevMenuAction.frameworkError),
          ),
          ListTile(
            leading: const Icon(Icons.schedule_outlined),
            title: const Text('Асинхронная ошибка'),
            subtitle: const Text('PlatformDispatcher.onError, нефатальная'),
            onTap: () => bloc.add(DevMenuAction.asyncError),
          ),
          ListTile(
            leading: const Icon(Icons.dangerous_outlined),
            title: const Text('Уронить натив'),
            subtitle: const Text(
              'Приложение закроется, отчёт уйдёт при следующем запуске',
            ),
            onTap: () => bloc.add(DevMenuAction.nativeCrash),
          ),
          const Divider(),
          BlocBuilder<DevMenuBloc, DevMenuState>(
            builder: (context, state) => ListTile(
              title: Text(switch (state.lastAction) {
                final action? => 'Последнее: ${action.name}',
                null => 'Ещё ничего не отправлено',
              }),
              subtitle: const Text(
                'В консоли Firebase отчёт появляется через несколько минут',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _promptForSteps(BuildContext context, DevMenuBloc bloc) async {
    final form = GlobalKey<FormState>();
    late int amount;
    final steps = await showDialog<int>(
      context: context,
      builder: (context) {
        void submit() {
          final fields = form.currentState!;
          if (!fields.validate()) return;
          fields.save();
          Navigator.of(context).pop(amount);
        }

        return AlertDialog(
          title: const Text('Добавить шаги за сегодня'),
          content: Form(
            key: form,
            child: TextFormField(
              key: const Key('dev-step-amount'),
              autofocus: true,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              maxLength: 9,
              decoration: const InputDecoration(labelText: 'Количество шагов'),
              validator: (text) => (int.tryParse(text ?? '') ?? 0) <= 0
                  ? 'Введи положительное число шагов'
                  : null,
              onSaved: (text) => amount = int.parse(text!),
              onFieldSubmitted: (_) => submit(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            FilledButton(onPressed: submit, child: const Text('Добавить')),
          ],
        );
      },
    );
    if (context.mounted && steps != null) bloc.add(DevAddSteps(steps));
  }
}
