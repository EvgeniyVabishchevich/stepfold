import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:walks/domain/failures/step_source_failure.dart';
import 'package:walks/domain/failures/storage_failure.dart';
import 'package:walks/domain/models/app_permission.dart';
import 'package:walks/domain/models/day_count.dart';
import 'package:walks/domain/repositories/crash_reporter.dart';
import 'package:walks/domain/repositories/permission_service.dart';
import 'package:walks/domain/repositories/step_source.dart';
import 'package:walks/domain/use_cases/sync_steps.dart';
import 'package:walks/ui/pages/home_shell/bloc/step_sync_state.dart';

export 'package:walks/ui/pages/home_shell/bloc/step_sync_state.dart';

/// A command from the shell lifecycle or the steps controls.
sealed class StepSyncEvent {
  const StepSyncEvent();
}

/// Checks permission and catches up on steps when possible.
final class CheckStepSync extends StepSyncEvent {
  /// Creates the event.
  const CheckStepSync();
}

/// The user asked for access to the counter.
final class RequestStepPermission extends StepSyncEvent {
  /// Creates the event.
  const RequestStepPermission();
}

/// The user asked to open the system settings.
final class OpenStepSettings extends StepSyncEvent {
  /// Creates the event.
  const OpenStepSettings();
}

final class _FollowFailed extends StepSyncEvent {
  const _FollowFailed(this.session, this.error, this.stack);
  final Object session;
  final Object error;
  final StackTrace stack;
}

/// Owns the single shared subscription to the device's steps.
class StepSyncBloc extends Bloc<StepSyncEvent, StepSyncState> {
  /// Creates the bloc. The shell requests the initial check.
  StepSyncBloc({
    required this._permissions,
    required StepSource source,
    required this._sync,
    required this._crashReporter,
  }) : _permission = source.requiredPermission,
       super(initialState) {
    on<StepSyncEvent>(
      _onEvent,
      transformer: (events, handle) => events.asyncExpand(handle),
    );
  }

  /// The state before the first permission check.
  static const initialState = StepSyncState();

  final PermissionService _permissions;
  final AppPermission _permission;
  final SyncSteps _sync;
  final CrashReporter _crashReporter;
  StreamSubscription<DayCount>? _subscription;
  Object? _session;
  var _closing = false;

  Future<void> _onEvent(
    StepSyncEvent event,
    Emitter<StepSyncState> emit,
  ) async {
    switch (event) {
      case CheckStepSync():
        await _refresh(emit, request: false);
      case RequestStepPermission():
        if (state.permission == PermissionStatus.canRequest) {
          await _refresh(emit, request: true);
        }
      case OpenStepSettings():
        if (state.permission == PermissionStatus.blocked) {
          await _permissions.openSettings();
        }
      case _FollowFailed(:final session, :final error, :final stack):
        if (_session == session) {
          await _stopFollowing();
          await _handleFailure(error, stack, emit);
        }
    }
  }

  Future<void> _refresh(
    Emitter<StepSyncState> emit, {
    required bool request,
  }) async {
    emit(StepSyncState(permission: state.permission));
    try {
      // Flush pending writes from the old stream before reading the source.
      await _stopFollowing();
      final permission = request
          ? await _permissions.request(_permission)
          : await _permissions.status(_permission);
      if (emit.isDone || _closing) return;
      emit(
        StepSyncState(
          permission: permission,
          checking: permission == PermissionStatus.granted,
        ),
      );
      if (permission != PermissionStatus.granted) return;
      await _sync.catchUp();
      if (emit.isDone || _closing) return;
      final session = _session = Object();
      _subscription = _sync.followToday().listen(
        (_) {},
        onError: (Object error, StackTrace stack) {
          if (!_closing) add(_FollowFailed(session, error, stack));
        },
      );
      emit(StepSyncState(permission: permission, checking: false));
    } on StepSourceFailure catch (failure, stack) {
      await _handleFailure(failure, stack, emit);
    } on StorageFailure catch (failure, stack) {
      await _handleFailure(failure, stack, emit);
    }
  }

  Future<void> _handleFailure(
    Object failure,
    StackTrace stack,
    Emitter<StepSyncState> emit,
  ) async {
    var permission = state.permission;
    switch (failure) {
      case StepPermissionDenied():
        permission = await _permissions.status(_permission);
      case StepSourceUnavailable() || StorageFull():
        break;
      case StorageUnavailable(:final cause):
        await _crashReporter.recordError(cause, stack, reason: 'sync steps');
      default:
        Error.throwWithStackTrace(failure, stack);
    }
    if (emit.isDone || _closing) return;
    emit(
      StepSyncState(
        permission: permission,
        checking: false,
        sourceFailure: failure is StepSourceFailure ? failure : null,
        storageFailure: failure is StorageFailure ? failure : null,
      ),
    );
  }

  Future<void> _stopFollowing() async {
    _session = null;
    final subscription = _subscription;
    _subscription = null;
    await subscription?.cancel();
  }

  @override
  Future<void> close() async {
    _closing = true;
    await _subscription?.cancel();
    _subscription = null;
    await super.close();
  }
}
