import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:material_ui/material_ui.dart';
import 'package:walks/ui/dev_menu/bloc/dev_menu_cubit.dart';
import 'package:walks/ui/dev_menu/dev_menu_view.dart';

/// The developer menu: takes its cubit from the container and shows
/// [DevMenuView].
class DevMenuPage extends StatelessWidget {
  /// Creates the page.
  const DevMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<DevMenuCubit>(),
      child: const DevMenuView(),
    );
  }
}
