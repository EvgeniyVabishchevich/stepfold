/// A permission the app asks the user for.
///
/// Each area adds the values it needs. How a permission is asked for is up
/// to the implementation of `PermissionService`.
enum AppPermission {
  /// Physical activity: the phone's step sensor. `ACTIVITY_RECOGNITION` on
  /// Android, Motion & Fitness on iOS.
  activityRecognition,

  /// Reading steps from the health store: Health Connect on Android,
  /// HealthKit on iOS.
  healthSteps,
}

/// What the screen can do about a permission.
///
/// Statuses follow the screen's action, not the platform: the implementation
/// folds the platform's states (Android "denied for good", iOS
/// `notDetermined`, `restricted`, `limited`) into these four.
enum PermissionStatus {
  /// Granted: the feature works.
  ///
  /// HealthKit never says whether reading was denied, so after a request a
  /// health permission is reported as granted; a denial shows as no steps.
  granted,

  /// The system dialog can be shown: a "Allow" button.
  canRequest,

  /// The dialog will not be shown again: only the system settings help.
  blocked,

  /// Not on this device, or forbidden by parental controls or a work
  /// profile. Settings do not help.
  unavailable,
}
