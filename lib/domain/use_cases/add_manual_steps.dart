import 'package:clock/clock.dart';
import 'package:walks/domain/models/models.dart';
import 'package:walks/domain/repositories/repositories.dart';
import 'package:walks/domain/rules/rules.dart';

/// Checks steps added by hand and saves them.
class AddManualSteps {
  /// Creates the use case on the given progress.
  AddManualSteps(this._progress);

  final ProgressRepository _progress;

  /// Sets the steps of [day] added by hand to [steps]; zero removes them.
  ///
  /// An unusually large addition is saved only when [confirmed]; without it
  /// the call saves nothing and returns [ManualEntryCheck.needsConfirmation],
  /// so the caller asks the user and calls again. [lock] is the user's own
  /// lock on manual entry.
  ///
  /// Throws a `ManualEntryFailure` when the entry is refused and a
  /// `StorageFailure` when it cannot be saved.
  Future<ManualEntryCheck> call(
    Day day,
    int steps, {
    required ManualEntryLock lock,
    bool confirmed = false,
  }) async {
    final progress = await _progress.watch().first;
    final check = checkManualEntry(
      day: day,
      steps: steps,
      installDay: progress.installDay,
      today: Day.today(),
      lock: lock,
      now: clock.now(),
    );
    if (check == ManualEntryCheck.needsConfirmation && !confirmed) {
      return check;
    }
    await _progress.saveManualSteps(day, steps);
    return check;
  }
}
