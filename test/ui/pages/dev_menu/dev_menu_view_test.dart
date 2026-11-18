import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:walks/ui/pages/dev_menu/bloc/dev_menu_bloc.dart';
import 'package:walks/ui/pages/dev_menu/dev_menu_page.dart';

class _MockDevMenuBloc extends MockBloc<DevMenuAction, DevMenuState>
    implements DevMenuBloc {}

void main() {
  late _MockDevMenuBloc bloc;

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

    expect(find.text('Последнее: asyncError'), findsOneWidget);
  });
}
