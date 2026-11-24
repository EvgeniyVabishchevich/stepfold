import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:walks/data/repositories/crash/crash.dart';
import 'package:walks/data/repositories/progress/progress.dart';
import 'package:walks/domain/failures/failures.dart';
import 'package:walks/domain/models/models.dart';
import 'package:walks/domain/repositories/repositories.dart';
import 'package:walks/ui/pages/dev_menu/bloc/bloc.dart';

class _FakeNativeCrasher implements NativeCrasher {
  int crashes = 0;

  @override
  Future<void> crash() async => crashes++;
}

void main() {
  late FakeCrashReporter reporter;
  late _FakeNativeCrasher crasher;
  late FakeProgressRepository progress;

  DevMenuBloc build() => DevMenuBloc(
    crashReporter: reporter,
    nativeCrasher: crasher,
    progress: progress,
  );

  setUp(() {
    reporter = FakeCrashReporter();
    crasher = _FakeNativeCrasher();
    progress = FakeProgressRepository.installedOn(Day.today());
  });
  tearDown(() => progress.close());

  blocTest<DevMenuBloc, DevMenuState>(
    'credits today even if manual entry in History is locked',
    build: build,
    act: (bloc) async {
      await progress.updateManualEntryLock(
        (_) => const ManualEntryLock(locked: true),
      );
      bloc.add(const DevAddSteps(3000));
    },
    expect: () => [
      const DevMenuState(stepAddition: DevStepAddition.saving),
      const DevMenuState(stepAddition: DevStepAddition.added),
    ],
    verify: (_) => expect(progress.progress.stepsOf(Day.today()).manual, 3000),
  );

  for (final failure in [
    const StorageFull(),
    StorageUnavailable(StateError('broken storage')),
  ]) {
    blocTest<DevMenuBloc, DevMenuState>(
      'shows a step write failure for $failure',
      build: build,
      act: (bloc) {
        progress.failNext(failure);
        bloc.add(const DevAddSteps(3000));
      },
      expect: () => [
        const DevMenuState(stepAddition: DevStepAddition.saving),
        DevMenuState(
          stepAddition: failure is StorageFull
              ? DevStepAddition.storageFull
              : DevStepAddition.failed,
        ),
      ],
      verify: (_) =>
          expect(progress.progress.stepsOf(Day.today()).manual, isNull),
    );
  }

  blocTest<DevMenuBloc, DevMenuState>(
    'nonFatal sends a non-fatal error with the trail',
    build: build,
    act: (bloc) => bloc.add(DevMenuAction.nonFatal),
    expect: () => [const DevMenuState(lastAction: DevMenuAction.nonFatal)],
    verify: (_) {
      final recorded = reporter.errors.single;
      expect(recorded.fatal, isFalse);
      expect(recorded.reason, 'developer menu');
      expect(recorded.trail, ['[dev_menu] nonFatal']);
    },
  );

  test('frameworkError reaches the Flutter error handler', () async {
    final bloc = build();
    addTearDown(bloc.close);
    final previous = FlutterError.onError;
    final report = Completer<FlutterErrorDetails>();
    FlutterError.onError = report.complete;
    try {
      bloc.add(DevMenuAction.frameworkError);
      expect((await report.future).exception, isStateError);
      expect(bloc.state.lastAction, DevMenuAction.frameworkError);
    } finally {
      FlutterError.onError = previous;
    }
  });

  test('asyncError leaves an error nobody catches', () async {
    final uncaught = <Object>[];
    await runZonedGuarded(() async {
      final bloc = build()..add(DevMenuAction.asyncError);
      await pumpEventQueue();
      await bloc.close();
    }, (error, _) => uncaught.add(error));

    expect(uncaught.single, isStateError);
  });

  blocTest<DevMenuBloc, DevMenuState>(
    'nativeCrash asks the native side to crash',
    build: build,
    act: (bloc) => bloc.add(DevMenuAction.nativeCrash),
    expect: () => [const DevMenuState(lastAction: DevMenuAction.nativeCrash)],
    verify: (_) => expect(crasher.crashes, 1),
  );
}
