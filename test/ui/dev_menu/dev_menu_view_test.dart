import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:walks/ui/dev_menu/bloc/dev_menu_cubit.dart';
import 'package:walks/ui/dev_menu/dev_menu_view.dart';

class _MockDevMenuCubit extends MockCubit<DevMenuAction?>
    implements DevMenuCubit {}

void main() {
  late _MockDevMenuCubit cubit;

  setUp(() {
    cubit = _MockDevMenuCubit();
    when(() => cubit.state).thenReturn(null);
    when(() => cubit.recordNonFatal()).thenAnswer((_) async {});
    when(() => cubit.crashNative()).thenAnswer((_) async {});
  });

  Future<void> pump(WidgetTester tester) => tester.pumpWidget(
    MaterialApp(
      home: BlocProvider<DevMenuCubit>.value(
        value: cubit,
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

    verify(() => cubit.recordNonFatal()).called(1);
    verify(() => cubit.throwFrameworkError()).called(1);
    verify(() => cubit.throwAsyncError()).called(1);
    verify(() => cubit.crashNative()).called(1);
  });

  testWidgets('shows the last action', (tester) async {
    when(() => cubit.state).thenReturn(DevMenuAction.asyncError);
    await pump(tester);

    expect(find.text('Последнее: asyncError'), findsOneWidget);
  });
}
