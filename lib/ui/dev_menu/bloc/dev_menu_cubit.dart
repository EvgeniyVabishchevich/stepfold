import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:walks/domain/repositories/crash_reporter.dart';
import 'package:walks/domain/repositories/native_crasher.dart';

/// A test error the developer menu can produce.
enum DevMenuAction {
  /// Sent by hand with `recordError`, the app keeps running.
  nonFatal,

  /// Thrown where the framework catches it: `FlutterError.onError`, fatal.
  frameworkError,

  /// Thrown in a Future nobody awaits: `PlatformDispatcher.onError`,
  /// non-fatal.
  asyncError,

  /// A real crash of the native side.
  nativeCrash,
}

/// Produces test errors to check crash reporting end to end.
///
/// The state is the last action, or `null` before the first one.
class DevMenuCubit extends Cubit<DevMenuAction?> {
  /// Creates the cubit.
  DevMenuCubit({required this._crashReporter, required this._nativeCrasher})
    : super(null);

  final CrashReporter _crashReporter;
  final NativeCrasher _nativeCrasher;

  /// Sends a non-fatal error by hand.
  Future<void> recordNonFatal() async {
    _start(DevMenuAction.nonFatal);
    await _crashReporter.recordError(
      StateError('Test non-fatal error from the developer menu'),
      StackTrace.current,
      reason: 'developer menu',
    );
  }

  /// Throws synchronously.
  ///
  /// Called from a button callback, the error is caught by the gesture code
  /// of the framework and passed to `FlutterError.onError`.
  void throwFrameworkError() {
    _start(DevMenuAction.frameworkError);
    throw StateError('Test framework error from the developer menu');
  }

  /// Throws inside a Future nobody awaits, so nothing catches it and it
  /// reaches `PlatformDispatcher.onError`.
  void throwAsyncError() {
    _start(DevMenuAction.asyncError);
    unawaited(
      Future<void>(
        () => throw StateError('Test async error from the developer menu'),
      ),
    );
  }

  /// Crashes the native side. Crashlytics sends the report on the next
  /// launch.
  Future<void> crashNative() async {
    _start(DevMenuAction.nativeCrash);
    await _nativeCrasher.crash();
  }

  void _start(DevMenuAction action) {
    _crashReporter.log('[dev_menu] ${action.name}');
    emit(action);
  }
}
