import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:walks/domain/repositories/crash_reporter.dart';
import 'package:walks/domain/repositories/native_crasher.dart';
import 'package:walks/ui/pages/dev_menu/bloc/dev_menu_state.dart';

export 'package:walks/ui/pages/dev_menu/bloc/dev_menu_state.dart';

/// Produces test errors to check crash reporting end to end.
class DevMenuBloc extends Bloc<DevMenuAction, DevMenuState> {
  /// Creates the bloc.
  DevMenuBloc({required this._crashReporter, required this._nativeCrasher})
    : super(const DevMenuState()) {
    on<DevMenuAction>(_run);
  }

  final CrashReporter _crashReporter;
  final NativeCrasher _nativeCrasher;

  Future<void> _run(DevMenuAction action, Emitter<DevMenuState> emit) async {
    _crashReporter.log('[dev_menu] ${action.name}');
    emit(DevMenuState(lastAction: action));
    switch (action) {
      case DevMenuAction.nonFatal:
        await _crashReporter.recordError(
          StateError('Test non-fatal error from the developer menu'),
          StackTrace.current,
          reason: 'developer menu',
        );
      case DevMenuAction.frameworkError:
        // Bloc events are asynchronous. Report through the same Flutter
        // callback that used to receive the exception from the gesture.
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: StateError(
              'Test framework error from the developer menu',
            ),
            stack: StackTrace.current,
          ),
        );
      case DevMenuAction.asyncError:
        unawaited(
          Future<void>(
            () => throw StateError('Test async error from the developer menu'),
          ),
        );
      case DevMenuAction.nativeCrash:
        await _nativeCrasher.crash();
    }
  }
}
