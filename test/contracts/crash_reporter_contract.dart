import 'package:flutter_test/flutter_test.dart';
import 'package:walks/domain/repositories/crash_reporter.dart';

/// The behaviour every [CrashReporter] must share.
///
/// The interface only sends data out, so through it a test can check one
/// promise: no method ever throws. What reaches the service is checked by
/// each implementation's own tests.
void crashReporterContract(CrashReporter Function() create) {
  group('CrashReporter contract', () {
    late CrashReporter reporter;

    setUp(() => reporter = create());

    test('recordError completes for fatal and non-fatal errors', () async {
      await expectLater(
        reporter.recordError(StateError('boom'), StackTrace.current),
        completes,
      );
      await expectLater(
        reporter.recordError(
          Exception('boom'),
          StackTrace.current,
          fatal: true,
          reason: 'unlock chapter',
        ),
        completes,
      );
    });

    test('recordError completes without a stack trace', () async {
      await expectLater(reporter.recordError('boom', null), completes);
    });

    test('log does not throw, even far past any trail limit', () {
      expect(() {
        for (var i = 0; i < 1000; i++) {
          reporter.log('[test] message $i');
        }
      }, returnsNormally);
    });

    test('setUserId completes for an id and for sign-out', () async {
      await expectLater(reporter.setUserId('user-1'), completes);
      await expectLater(reporter.setUserId(null), completes);
    });

    test('setKey completes for String, num and bool values', () async {
      await expectLater(reporter.setKey('screen', 'catalog'), completes);
      await expectLater(reporter.setKey('steps_today', 4200), completes);
      await expectLater(reporter.setKey('pro', true), completes);
    });
  });
}
