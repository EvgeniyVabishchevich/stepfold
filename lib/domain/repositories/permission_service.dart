import 'package:walks/domain/models/app_permission.dart';

/// Checks and asks for the permissions of the whole app.
///
/// The caller decides when to ask: first its own explanation, then
/// [request]. On iOS the system dialog is shown once per install, on
/// Android twice.
///
/// There is no stream of changes: platforms send no event when the user
/// changes a permission in the settings. The caller checks [status] again
/// when the app comes back to the screen.
abstract interface class PermissionService {
  /// The current status of [permission]. Shows no dialog.
  Future<PermissionStatus> status(AppPermission permission);

  /// Shows the system dialog when the status is
  /// [PermissionStatus.canRequest], and returns the status after the
  /// user's answer. In any other status returns it without a dialog.
  Future<PermissionStatus> request(AppPermission permission);

  /// Opens the app's page in the system settings, for
  /// [PermissionStatus.blocked].
  Future<void> openSettings();
}
