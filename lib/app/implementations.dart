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

/// Implementations of `Catalog`.
enum CatalogImpl {
  /// In memory, one sample story.
  fake,

  /// JSON files built into the app.
  assets,
}

/// Implementations of `ProgressRepository`.
enum ProgressImpl {
  /// In memory, empty on each start.
  fake,

  /// SQLite on the device, through drift.
  drift,
}

/// One implementation per area.
class Implementations {
  /// Creates a set of implementations.
  const Implementations({
    required this.crashReporter,
    required this.catalog,
    required this.progress,
  });

  /// Every area on its fake: no SDK, no network. Used by tests.
  static const fakes = Implementations(
    crashReporter: CrashReporterImpl.fake,
    catalog: CatalogImpl.fake,
    progress: ProgressImpl.fake,
  );

  /// The `CrashReporter`.
  final CrashReporterImpl crashReporter;

  /// The `Catalog`.
  final CatalogImpl catalog;

  /// The `ProgressRepository`.
  final ProgressImpl progress;

  /// Whether any chosen implementation needs `Firebase.initializeApp`.
  bool get usesFirebase => crashReporter == CrashReporterImpl.crashlytics;

  /// Sent as context keys with every crash report, so a report shows which
  /// implementations it came from.
  Map<String, String> get asReportKeys => {
    'impl_crash_reporter': crashReporter.name,
    'impl_catalog': catalog.name,
    'impl_progress': progress.name,
  };
}

/// The implementations the app is built with.
const chosenImplementations = Implementations(
  crashReporter: CrashReporterImpl.crashlytics,
  catalog: CatalogImpl.assets,
  progress: ProgressImpl.drift,
);
