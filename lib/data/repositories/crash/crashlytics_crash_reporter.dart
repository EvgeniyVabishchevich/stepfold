import 'dart:async';
import 'dart:developer' as developer;

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:walks/domain/repositories/crash_reporter.dart';

/// A [CrashReporter] backed by Firebase Crashlytics.
///
/// Firebase must be initialized before this is created. Every call is
/// guarded: a failure inside the SDK is printed and swallowed, as the
/// interface promises.
class CrashlyticsCrashReporter implements CrashReporter {
  /// Creates a reporter that sends to the given SDK instance.
  CrashlyticsCrashReporter(this._crashlytics);

  final FirebaseCrashlytics _crashlytics;

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stack, {
    bool fatal = false,
    String? reason,
  }) => _guard(
    'recordError',
    () => _crashlytics.recordError(error, stack, fatal: fatal, reason: reason),
  );

  @override
  void log(String message) {
    unawaited(_guard('log', () => _crashlytics.log(message)));
  }

  // Crashlytics has no "clear": an empty identifier is how a user is removed.
  @override
  Future<void> setUserId(String? id) =>
      _guard('setUserId', () => _crashlytics.setUserIdentifier(id ?? ''));

  @override
  Future<void> setKey(String key, Object value) =>
      _guard('setKey', () => _crashlytics.setCustomKey(key, value));

  // Catches both a synchronous throw and a failed Future.
  Future<void> _guard(String method, Future<void> Function() call) async {
    try {
      await call();
    } on Object catch (error, stack) {
      developer.log(
        'Crashlytics $method failed',
        name: 'crash',
        error: error,
        stackTrace: stack,
      );
    }
  }
}
