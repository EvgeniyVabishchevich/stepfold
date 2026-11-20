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
  /// so the caller asks the user and calls again. Every call checks the
  /// lock held in storage before making any change.
  ///
  /// Throws a `ManualEntryFailure` when the entry is refused and a
  /// `StorageFailure` when it cannot be saved.
  Future<ManualEntryCheck> call(
    Day day,
    int steps, {
    bool confirmed = false,
  }) async {
    final saved = await _progress.saveManualSteps(
      day,
      steps,
      allow: (installDay, lock) {
        final now = clock.now();
        final check = checkManualEntry(
          day: day,
          steps: steps,
          installDay: installDay,
          today: Day.fromLocal(now),
          lock: lock,
          now: now,
        );
        return check == ManualEntryCheck.ok || confirmed;
      },
    );
    return saved ? ManualEntryCheck.ok : ManualEntryCheck.needsConfirmation;
  }
}
