import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:walks/ui/pages/dev_menu/bloc/bloc.dart';
import 'package:walks/ui/pages/dev_menu/dev_menu.dart';

class _MockDevMenuBloc extends MockBloc<DevMenuEvent, DevMenuState>
    implements DevMenuBloc {}

void main() {
  late _MockDevMenuBloc bloc;

  setUpAll(() => registerFallbackValue(const DevAddSteps(1)));

  setUp(() {
    bloc = _MockDevMenuBloc();
    when(() => bloc.state).thenReturn(const DevMenuState());
  });

  Future<void> pump(WidgetTester tester) => tester.pumpWidget(
    MaterialApp(
      home: BlocProvider<DevMenuBloc>.value(
        value: bloc,
        child: const DevMenuView(),
      ),
    ),
  );

  testWidgets('each button calls its action', (tester) async {
    await pump(tester);

    await tester.tap(find.text('Нефатальная ошибка'));
    await tester.tap(find.text('Ошибка фреймворка'));
    await tester.tap(find.text('Асинхронная ошибка'));
    await tester.tap(find.text('Уронить натив'));

    verify(() => bloc.add(DevMenuAction.nonFatal)).called(1);
    verify(() => bloc.add(DevMenuAction.frameworkError)).called(1);
    verify(() => bloc.add(DevMenuAction.asyncError)).called(1);
    verify(() => bloc.add(DevMenuAction.nativeCrash)).called(1);
  });

  testWidgets('shows the last action', (tester) async {
    when(
      () => bloc.state,
    ).thenReturn(const DevMenuState(lastAction: DevMenuAction.asyncError));
    await pump(tester);
    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();

    expect(find.text('Последнее: asyncError'), findsOneWidget);
  });

  testWidgets('the step dialog submits a positive amount', (tester) async {
    await pump(tester);
    await tester.tap(find.text('Добавить шаги за сегодня'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Добавить'));
    await tester.pumpAndSettle();
    expect(find.text('Введи положительное число шагов'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('dev-step-amount')), '3000');
    await tester.tap(find.text('Добавить'));
    await tester.pumpAndSettle();
    final event = verify(() => bloc.add(captureAny())).captured.single;
    expect((event as DevAddSteps).steps, 3000);
  });
}
