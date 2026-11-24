import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:walks/domain/domain.dart';
import 'package:walks/ui/pages/dev_menu/bloc/dev_menu_state.dart';

/// Produces test errors to check crash reporting end to end.
class DevMenuBloc extends Bloc<DevMenuEvent, DevMenuState> {
  /// Creates the bloc.
  DevMenuBloc({
    required this._crashReporter,
    required this._nativeCrasher,
    required this._progress,
  }) : super(const DevMenuState()) {
    on<DevMenuAction>(_run);
    on<DevAddSteps>(_addSteps);
  }

  final CrashReporter _crashReporter;
  final NativeCrasher _nativeCrasher;
  final ProgressRepository _progress;

  Future<void> _addSteps(DevAddSteps event, Emitter<DevMenuState> emit) async {
    if (event.steps <= 0 || state.stepAddition == DevStepAddition.saving) {
      return;
    }
    emit(state.copyWith(stepAddition: DevStepAddition.saving));
    try {
      final saved = await _progress.increaseManualSteps(
        Day.today(),
        event.steps,
      );
      emit(
        state.copyWith(
          stepAddition: saved ? DevStepAddition.added : DevStepAddition.failed,
        ),
      );
    } on StorageFailure catch (failure, stack) {
      if (failure case StorageUnavailable(:final cause)) {
        await _crashReporter.recordError(
          cause,
          stack,
          reason: 'developer steps',
        );
      }
      emit(
        state.copyWith(
          stepAddition: switch (failure) {
            StorageFull() => DevStepAddition.storageFull,
            StorageUnavailable() => DevStepAddition.failed,
          },
        ),
      );
    }
  }

  Future<void> _run(DevMenuAction action, Emitter<DevMenuState> emit) async {
    _crashReporter.log('[dev_menu] ${action.name}');
    emit(state.copyWith(lastAction: action));
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
