import 'package:flutter/foundation.dart';
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
    super.key,
  });

  /// Reports errors during development.
  final CrashReporter crashReporter;

  /// Triggers a test crash in native code.
  final NativeCrasher nativeCrasher;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DevMenuBloc(
        crashReporter: crashReporter,
        nativeCrasher: nativeCrasher,
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
}
