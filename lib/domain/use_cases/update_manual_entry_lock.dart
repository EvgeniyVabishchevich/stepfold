import 'package:clock/clock.dart';
import 'package:walks/domain/repositories/repositories.dart';

/// Locks manual entry or starts the delay before unlocking it.
class UpdateManualEntryLock {
  /// Creates the use case on the given progress repository.
  UpdateManualEntryLock(this._progress);

  final ProgressRepository _progress;

  /// Locking is immediate and cancels a pending unlock. Unlocking uses the
  /// existing deadline if an unlock has already been requested.
  Future<void> call({required bool locked}) => _progress.updateManualEntryLock(
    (current) => locked ? current.lock() : current.requestUnlock(clock.now()),
  );
}
