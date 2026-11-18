import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:walks/domain/domain.dart';

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
