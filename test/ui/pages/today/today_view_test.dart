import 'package:flutter_test/flutter_test.dart';
import 'package:walks/domain/models/day.dart';
import 'package:walks/domain/models/progress.dart';
import 'package:walks/ui/pages/home_shell/bloc/step_sync_bloc.dart';
import 'package:walks/ui/pages/today/bloc/today_bloc.dart';
import 'package:walks/ui/pages/today/today_page.dart';

import '../../../helpers/pump_view.dart';

void main() {
  final day = Day(2026, 11, 18);
  TodayView view({void Function()? onOpenDevMenu}) => TodayView(
    state: TodayState(
      day: day,
      progress: Progress(installDay: day),
      catalogLoading: false,
    ),
    sync: StepSyncBloc.initialState,
    onOpenCatalog: () {},
    onSpend: (_) {},
    onRetryProgress: () {},
    onRetryCatalog: () {},
    onRequestSteps: () {},
    onOpenStepSettings: () {},
    onRetrySync: () {},
    onOpenDevMenu: onOpenDevMenu,
  );

  testWidgets('a long press on the title opens the developer menu', (
    tester,
  ) async {
    var opened = 0;
    await tester.pumpView(view(onOpenDevMenu: () => opened++));

    await tester.longPress(find.text('Сегодня'));

    expect(opened, 1);
  });

  testWidgets('without a developer menu a long press does nothing', (
    tester,
  ) async {
    await tester.pumpView(view());

    await tester.longPress(find.text('Сегодня'));

    expect(tester.takeException(), isNull);
  });
}
