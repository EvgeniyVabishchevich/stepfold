import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:walks/domain/models/models.dart';
import 'package:walks/ui/pages/home_shell/bloc/bloc.dart';
import 'package:walks/ui/pages/today/bloc/bloc.dart';
import 'package:walks/ui/pages/today/today.dart';

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

    expect(find.text('Среда, 18 ноября'), findsNothing);
    await tester.longPress(find.text('Сегодня'));

    expect(opened, 1);
  });

  testWidgets('six-digit values, a long streak and chapter fit at 320', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 800);
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    const title = 'Долгая ночь на дальнем маяке Северного побережья';
    const chapter = Chapter(id: 'storm', price: 327000, title: title);
    const goal = Goal.chapter(progressionId: 'lighthouse', chapterId: 'storm');
    const progression = Progression(
      id: 'lighthouse',
      kind: 'story',
      title: 'Смотритель маяка',
      order: ChapterOrder.strict,
      chapters: [chapter],
    );
    await tester.pumpView(
      TodayView(
        state: TodayState(
          day: day,
          progress: Progress(
            installDay: day - 127,
            days: {
              for (var offset = 1; offset < 128; offset++)
                day - offset: DaySteps(day: day - offset, auto: 1000),
              day: DaySteps(day: day, auto: 100000),
            },
            goal: goal,
          ),
          catalogLoading: false,
          target: (
            goal: goal,
            progression: progression,
            chapterTitle: title,
            price: chapter.price,
            left: 100000,
          ),
        ),
        sync: StepSyncBloc.initialState,
        onOpenCatalog: () {},
        onSpend: (_) {},
        onRetryProgress: () {},
        onRetryCatalog: () {},
        onRequestSteps: () {},
        onOpenStepSettings: () {},
        onRetrySync: () {},
      ),
    );

    expect(find.text('100\u00a0000'), findsOneWidget);
    final steps = tester.getRect(find.text('100\u00a0000'));
    final series = tester.getRect(find.text('128 дней').hitTestable());
    expect(series.top, greaterThanOrEqualTo(steps.bottom));
    expect(series.right, lessThanOrEqualTo(320));
    final chapterTitle = find.text(title);
    await tester.scrollUntilVisible(chapterTitle, 120);
    await Scrollable.ensureVisible(
      tester.element(chapterTitle),
      alignment: 0.2,
    );
    await tester.pump();
    expect(chapterTitle.hitTestable(), findsOneWidget);
    final remainder = find.textContaining('Осталось');
    await tester.scrollUntilVisible(remainder, 120);
    await Scrollable.ensureVisible(tester.element(remainder), alignment: 0.2);
    await tester.pump();
    expect(
      find.textContaining('100\u00a0000 шагов').hitTestable(),
      findsWidgets,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('without a developer menu a long press does nothing', (
    tester,
  ) async {
    await tester.pumpView(view());

    await tester.longPress(find.text('Сегодня'));

    expect(tester.takeException(), isNull);
  });
}
