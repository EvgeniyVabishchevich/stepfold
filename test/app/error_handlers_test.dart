import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:walks/app/error_handlers.dart';
import 'package:walks/data/repositories/crash/fake_crash_reporter.dart';

void main() {
  late FakeCrashReporter reporter;
  late FlutterExceptionHandler? originalFlutterOnError;

  setUp(() {
    reporter = FakeCrashReporter();
    originalFlutterOnError = FlutterError.onError;
    // The test framework's own handler would fail the test on purpose.
    FlutterError.onError = null;
    installErrorHandlers(reporter);
  });

  tearDown(() {
    FlutterError.onError = originalFlutterOnError;
    PlatformDispatcher.instance.onError = null;
  });

  test('errors caught by the framework are recorded as fatal', () {
    final error = StateError('build failed');
    FlutterError.onError!(
      FlutterErrorDetails(exception: error, stack: StackTrace.current),
    );

    final recorded = reporter.errors.single;
    expect(recorded.error, same(error));
    expect(recorded.fatal, isTrue);
  });

  test('uncaught async errors are recorded as non-fatal and handled', () {
    final error = StateError('after await');
    final handled = PlatformDispatcher.instance.onError!(
      error,
      StackTrace.current,
    );

    expect(handled, isTrue);
    final recorded = reporter.errors.single;
    expect(recorded.error, same(error));
    expect(recorded.fatal, isFalse);
  });

  test('the handler that was there before still runs', () {
    final seen = <FlutterErrorDetails>[];
    FlutterError.onError = seen.add;
    installErrorHandlers(reporter);

    final details = FlutterErrorDetails(exception: StateError('x'));
    FlutterError.onError!(details);

    expect(seen, [details]);
  });
}
