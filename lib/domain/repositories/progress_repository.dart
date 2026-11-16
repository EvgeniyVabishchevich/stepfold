import 'package:walks/domain/models/day.dart';
import 'package:walks/domain/models/goal.dart';
import 'package:walks/domain/models/progress.dart';
import 'package:walks/domain/models/spending.dart';

/// The user's progress, kept on the device.
///
/// Read as one [Progress], written in small changes: each write touches
/// only its own record, so two writes at once do not undo each other.
///
/// The install day is recorded when the storage is created; [watch] always
/// has a progress to give. Days before it are ignored, as
/// `Progress.recordAutoSteps` does.
///
/// Reading and writing fail with a `StorageFailure`.
abstract interface class ProgressRepository {
  /// The progress, now and after each change.
  ///
  /// On listen emits the current progress at once. Spendings come in the
  /// order they were made.
  Stream<Progress> watch();

  /// Sets the total of [day] from the phone's step source, replacing the
  /// earlier one, even with a smaller one.
  ///
  /// Throws an [ArgumentError] when [steps] is negative.
  Future<void> saveAutoSteps(Day day, int steps);

  /// Sets the steps of [day] added by hand, replacing the earlier
  /// addition; zero removes it.
  ///
  /// Throws an [ArgumentError] when [steps] is negative.
  Future<void> saveManualSteps(Day day, int steps);

  /// Records [spending] and sets the goal to [goalAfter] in one step: an
  /// opened chapter or a bought medal may move or remove the goal.
  ///
  /// Throws a [StateError] when the same chapter or medal is recorded
  /// again: that is a bug in the caller.
  Future<void> addSpending(Spending spending, {required Goal? goalAfter});

  /// Sets the goal; `null` removes it.
  Future<void> saveGoal(Goal? goal);
}
