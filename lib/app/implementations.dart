/// Which implementation of each area the app is built with.
///
/// Change [chosenImplementations] and restart the app to switch.
library;

import 'package:flutter/foundation.dart';

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

/// Implementations of the step source and its permissions.
enum StepsImpl {
  /// In memory, controlled by the developer menu.
  fake,

  /// Prefer Health Connect and use the hardware if it is unavailable.
  androidAutomatic,

  /// Health Connect on Android.
  androidHealthConnect,

  /// Hardware step counter on Android.
  androidSensor,
}

/// One implementation per area.
class Implementations {
  /// Creates a set of implementations.
  const Implementations({
    required this.crashReporter,
    required this.catalog,
    required this.progress,
    required this.steps,
  });

  /// Every area on its fake: no SDK, no network. Used by tests.
  static const fakes = Implementations(
    crashReporter: CrashReporterImpl.fake,
    catalog: CatalogImpl.fake,
    progress: ProgressImpl.fake,
    steps: StepsImpl.fake,
  );

  /// The `CrashReporter`.
  final CrashReporterImpl crashReporter;

  /// The `Catalog`.
  final CatalogImpl catalog;

  /// The `ProgressRepository`.
  final ProgressImpl progress;

  /// The requested step source. Non-Android builds use the fake for now.
  final StepsImpl steps;

  /// The source available on the current platform.
  StepsImpl get activeSteps =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android
      ? steps
      : StepsImpl.fake;

  /// Whether any chosen implementation needs `Firebase.initializeApp`.
  bool get usesFirebase => crashReporter == CrashReporterImpl.crashlytics;

  /// Sent as context keys with every crash report, so a report shows which
  /// implementations it came from.
  Map<String, String> get asReportKeys => {
    'impl_crash_reporter': crashReporter.name,
    'impl_catalog': catalog.name,
    'impl_progress': progress.name,
    'impl_steps': activeSteps.name,
  };
}

/// The implementations the app is built with.
const chosenImplementations = Implementations(
  crashReporter: CrashReporterImpl.crashlytics,
  catalog: CatalogImpl.assets,
  progress: ProgressImpl.drift,
  steps: StepsImpl.androidAutomatic,
);
