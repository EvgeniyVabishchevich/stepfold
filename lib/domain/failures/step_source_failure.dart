/// Why the step source could not give steps.
///
/// The caller checks the permission before reading, so these are the cases
/// that happen while the app works.
sealed class StepSourceFailure implements Exception {
  const StepSourceFailure();
}

/// The permission was taken away while the app was running.
final class StepPermissionDenied extends StepSourceFailure {
  /// Creates the failure.
  const StepPermissionDenied();

  @override
  String toString() => 'StepPermissionDenied';
}

/// The source is gone: the health store was removed or needs an update,
/// or the phone has no step sensor.
final class StepSourceUnavailable extends StepSourceFailure {
  /// Creates the failure.
  const StepSourceUnavailable();

  @override
  String toString() => 'StepSourceUnavailable';
}
