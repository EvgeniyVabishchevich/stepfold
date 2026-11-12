import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:walks/data/repositories/crash/crashlytics_crash_reporter.dart';

import '../../../contracts/crash_reporter_contract.dart';

class _MockCrashlytics extends Mock implements FirebaseCrashlytics {}

// A working SDK: every call succeeds.
_MockCrashlytics _workingSdk() {
  final sdk = _MockCrashlytics();
  when(
    () => sdk.recordError(
      any<Object>(),
      any(),
      fatal: any(named: 'fatal'),
      reason: any<Object?>(named: 'reason'),
    ),
  ).thenAnswer((_) async {});
  when(() => sdk.log(any())).thenAnswer((_) async {});
  when(() => sdk.setUserIdentifier(any())).thenAnswer((_) async {});
  when(() => sdk.setCustomKey(any(), any())).thenAnswer((_) async {});
  return sdk;
}

// A broken SDK: every call throws, some synchronously, some in the Future.
_MockCrashlytics _brokenSdk() {
  final sdk = _MockCrashlytics();
  when(
    () => sdk.recordError(
      any<Object>(),
      any(),
      fatal: any(named: 'fatal'),
      reason: any<Object?>(named: 'reason'),
    ),
  ).thenThrow(StateError('not initialized'));
  when(() => sdk.log(any())).thenThrow(StateError('not initialized'));
  when(
    () => sdk.setUserIdentifier(any()),
  ).thenAnswer((_) => Future.error(StateError('channel closed')));
  when(
    () => sdk.setCustomKey(any(), any()),
  ).thenAnswer((_) => Future.error(StateError('channel closed')));
  return sdk;
}

void main() {
  group('working SDK', () {
    crashReporterContract(() => CrashlyticsCrashReporter(_workingSdk()));
  });

  group('broken SDK', () {
    crashReporterContract(() => CrashlyticsCrashReporter(_brokenSdk()));
  });

  group('CrashlyticsCrashReporter forwards', () {
    late _MockCrashlytics sdk;
    late CrashlyticsCrashReporter reporter;

    setUp(() {
      sdk = _workingSdk();
      reporter = CrashlyticsCrashReporter(sdk);
    });

    test('recordError with its flags', () async {
      final error = StateError('boom');
      final stack = StackTrace.current;
      await reporter.recordError(
        error,
        stack,
        fatal: true,
        reason: 'unlock chapter',
      );

      verify(
        () => sdk.recordError(
          error,
          stack,
          fatal: true,
          reason: 'unlock chapter',
        ),
      ).called(1);
    });

    test('log', () async {
      reporter.log('[catalog] opened');
      await pumpEventQueue();

      verify(() => sdk.log('[catalog] opened')).called(1);
    });

    test('setUserId, and sign-out as an empty identifier', () async {
      await reporter.setUserId('user-1');
      await reporter.setUserId(null);

      verifyInOrder([
        () => sdk.setUserIdentifier('user-1'),
        () => sdk.setUserIdentifier(''),
      ]);
    });

    test('setKey', () async {
      await reporter.setKey('pro', true);

      verify(() => sdk.setCustomKey('pro', true)).called(1);
    });
  });
}
