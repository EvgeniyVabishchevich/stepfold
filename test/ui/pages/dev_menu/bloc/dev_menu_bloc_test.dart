import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:walks/data/repositories/crash/crash.dart';
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

  DevMenuBloc build() =>
      DevMenuBloc(crashReporter: reporter, nativeCrasher: crasher);

  setUp(() {
    reporter = FakeCrashReporter();
    crasher = _FakeNativeCrasher();
  });

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
