import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:walks/data/repositories/crash/fake_crash_reporter.dart';
import 'package:walks/domain/repositories/native_crasher.dart';
import 'package:walks/ui/dev_menu/bloc/dev_menu_cubit.dart';

class _FakeNativeCrasher implements NativeCrasher {
  int crashes = 0;

  @override
  Future<void> crash() async => crashes++;
}

void main() {
  late FakeCrashReporter reporter;
  late _FakeNativeCrasher crasher;

  DevMenuCubit build() =>
      DevMenuCubit(crashReporter: reporter, nativeCrasher: crasher);

  setUp(() {
    reporter = FakeCrashReporter();
    crasher = _FakeNativeCrasher();
  });

  blocTest<DevMenuCubit, DevMenuAction?>(
    'recordNonFatal sends a non-fatal error with the trail',
    build: build,
    act: (cubit) => cubit.recordNonFatal(),
    expect: () => [DevMenuAction.nonFatal],
    verify: (_) {
      final recorded = reporter.errors.single;
      expect(recorded.fatal, isFalse);
      expect(recorded.reason, 'developer menu');
      expect(recorded.trail, ['[dev_menu] nonFatal']);
    },
  );

  test('throwFrameworkError throws synchronously', () {
    final cubit = build();

    expect(cubit.throwFrameworkError, throwsStateError);
    expect(cubit.state, DevMenuAction.frameworkError);
  });

  test('throwAsyncError leaves an error nobody catches', () async {
    final uncaught = <Object>[];
    await runZonedGuarded(() async {
      build().throwAsyncError();
      await pumpEventQueue();
    }, (error, _) => uncaught.add(error));

    expect(uncaught.single, isStateError);
  });

  blocTest<DevMenuCubit, DevMenuAction?>(
    'crashNative asks the native side to crash',
    build: build,
    act: (cubit) => cubit.crashNative(),
    expect: () => [DevMenuAction.nativeCrash],
    verify: (_) => expect(crasher.crashes, 1),
  );
}
