import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:walks/domain/failures/step_source_failure.dart';
import 'package:walks/domain/failures/storage_failure.dart';
import 'package:walks/domain/models/app_permission.dart';

part 'step_sync_state.freezed.dart';

/// What the steps block can display while progress remains available.
@freezed
abstract class StepSyncState with _$StepSyncState {
  /// Creates a synchronization snapshot.
  const factory StepSyncState({
    PermissionStatus? permission,
    @Default(true) bool checking,
    StepSourceFailure? sourceFailure,
    StorageFailure? storageFailure,
  }) = _StepSyncState;
}
