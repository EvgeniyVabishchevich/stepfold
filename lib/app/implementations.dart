/// Which implementation of each area the app is built with.
///
/// Change a constant here and restart the app to switch.
library;

/// Implementations of `CrashReporter`.
enum CrashReporterImpl {
  /// In memory, printed to the console.
  fake,
}

/// The `CrashReporter` the app is built with.
const CrashReporterImpl crashReporterImpl = CrashReporterImpl.fake;

/// The chosen implementations, sent as context keys with every crash report.
Map<String, String> get chosenImplementations => {
  'impl_crash_reporter': crashReporterImpl.name,
};
