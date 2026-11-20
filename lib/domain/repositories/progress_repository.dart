import 'package:walks/domain/models/models.dart';

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

  /// Sets the automatic total of [day] from [origin].
  ///
  /// A different source cannot replace a total already assigned to a source.
  /// A legacy total with no origin can adopt a source at the same or a higher
  /// count. A source can correct its own total in either direction.
  ///
  /// Throws an [ArgumentError] when [steps] is negative.
  Future<void> saveAutoSteps(Day day, int steps, {AutoStepOrigin? origin});

  /// Sets the steps of [day] added by hand, replacing the earlier
  /// addition; zero removes it.
  ///
  /// Throws an [ArgumentError] when [steps] is negative.
  Future<void> saveManualSteps(Day day, int steps);

  /// Runs [decide] on the current progress and records the resulting
  /// spending and goal in the same atomic operation.
  ///
  /// [decide] is a synchronous domain rule. If it throws, nothing is saved
  /// and its error is propagated to the caller.
  ///
  /// Throws a [StateError] when the same chapter or medal is recorded
  /// again: that is a bug in the caller.
  Future<void> addSpending(
    ({Spending spending, Goal? goalAfter}) Function(Progress current) decide,
  );

  /// Sets the goal; `null` removes it.
  Future<void> saveGoal(Goal? goal);
}
