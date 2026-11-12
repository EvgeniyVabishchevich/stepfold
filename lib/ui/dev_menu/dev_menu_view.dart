import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/dev_menu/bloc/dev_menu_cubit.dart';

/// Buttons that produce test errors, and what was done last.
class DevMenuView extends StatelessWidget {
  /// Creates the view; reads [DevMenuCubit] from the context.
  const DevMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DevMenuCubit>();
    return Scaffold(
      appBar: AppBar(title: const Text('Меню разработчика')),
      body: ListView(
        children: [
          const _SectionTitle('Отчёты о падениях'),
          ListTile(
            leading: const Icon(Icons.report_outlined),
            title: const Text('Нефатальная ошибка'),
            subtitle: const Text('recordError вручную, приложение работает'),
            onTap: () => unawaited(cubit.recordNonFatal()),
          ),
          ListTile(
            leading: const Icon(Icons.web_asset_off_outlined),
            title: const Text('Ошибка фреймворка'),
            subtitle: const Text('FlutterError.onError, фатальная'),
            onTap: cubit.throwFrameworkError,
          ),
          ListTile(
            leading: const Icon(Icons.schedule_outlined),
            title: const Text('Асинхронная ошибка'),
            subtitle: const Text('PlatformDispatcher.onError, нефатальная'),
            onTap: cubit.throwAsyncError,
          ),
          ListTile(
            leading: const Icon(Icons.dangerous_outlined),
            title: const Text('Уронить натив'),
            subtitle: const Text(
              'Приложение закроется, отчёт уйдёт при следующем запуске',
            ),
            onTap: () => unawaited(cubit.crashNative()),
          ),
          const Divider(),
          BlocBuilder<DevMenuCubit, DevMenuAction?>(
            builder: (context, action) => ListTile(
              title: Text(
                action == null
                    ? 'Ещё ничего не отправлено'
                    : 'Последнее: ${action.name}',
              ),
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(text, style: Theme.of(context).textTheme.titleSmall),
    );
  }
}
