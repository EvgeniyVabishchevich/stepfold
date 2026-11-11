/// Which implementation of each area the app is built with.
///
/// Change [chosenImplementations] and restart the app to switch.
library;

/// Implementations of `CrashReporter`.
enum CrashReporterImpl {
  /// In memory, printed to the console.
  fake,

  /// Firebase Crashlytics.
  crashlytics,
}

/// One implementation per area.
class Implementations {
  /// Creates a set of implementations.
  const Implementations({required this.crashReporter});

  /// Every area on its fake: no SDK, no network. Used by tests.
  static const fakes = Implementations(crashReporter: CrashReporterImpl.fake);

  /// The `CrashReporter`.
  final CrashReporterImpl crashReporter;

  /// Whether any chosen implementation needs `Firebase.initializeApp`.
  bool get usesFirebase => crashReporter == CrashReporterImpl.crashlytics;

  /// Sent as context keys with every crash report, so a report shows which
  /// implementations it came from.
  Map<String, String> get asReportKeys => {
    'impl_crash_reporter': crashReporter.name,
  };
}

/// The implementations the app is built with.
const chosenImplementations = Implementations(
  crashReporter: CrashReporterImpl.crashlytics,
);
