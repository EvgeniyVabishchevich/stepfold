/// Why steps added by hand were refused.
sealed class ManualEntryFailure implements Exception {
  const ManualEntryFailure();
}

/// The user has locked manual entry for themselves.
final class ManualEntryLocked extends ManualEntryFailure {
  /// Creates the failure.
  const ManualEntryLocked();

  @override
  String toString() => 'ManualEntryLocked()';
}

/// The day is in the future, before the install day, or more than a week
/// back.
final class ManualEntryDayOutOfRange extends ManualEntryFailure {
  /// Creates the failure.
  const ManualEntryDayOutOfRange();

  @override
  String toString() => 'ManualEntryDayOutOfRange()';
}

/// The number of steps is negative.
final class ManualEntryNegative extends ManualEntryFailure {
  /// Creates the failure.
  const ManualEntryNegative();

  @override
  String toString() => 'ManualEntryNegative()';
}
