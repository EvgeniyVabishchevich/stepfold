import 'package:flutter/services.dart' show PlatformException;
import 'package:walks/data/repositories/steps/android_steps.g.dart';
import 'package:walks/domain/domain.dart';

/// Exposes the system permissions for Android step providers.
final class AndroidPermissionService implements PermissionService {
  /// Creates the service for the selected step source's settings screen.
  const AndroidPermissionService(this._api, this._stepsPermission);

  final AndroidStepsApi _api;
  final AppPermission _stepsPermission;

  @override
  Future<PermissionStatus> status(AppPermission permission) =>
      _status(() => _api.status(_provider(permission)));

  @override
  Future<PermissionStatus> request(AppPermission permission) =>
      _status(() => _api.request(_provider(permission)));

  @override
  Future<void> openSettings() => _api.openSettings(_provider(_stepsPermission));

  Future<PermissionStatus> _status(
    Future<AndroidStepPermission> Function() read,
  ) async {
    try {
      return switch (await read()) {
        AndroidStepPermission.granted => PermissionStatus.granted,
        AndroidStepPermission.canRequest => PermissionStatus.canRequest,
        AndroidStepPermission.blocked => PermissionStatus.blocked,
        AndroidStepPermission.unavailable => PermissionStatus.unavailable,
      };
    } on PlatformException catch (error, stack) {
      if (error.code == 'step-permission-denied') {
        return PermissionStatus.blocked;
      }
      if (error.code == 'step-source-unavailable') {
        Error.throwWithStackTrace(const StepSourceUnavailable(), stack);
      }
      rethrow;
    }
  }

  AndroidStepProvider _provider(AppPermission permission) =>
      switch (permission) {
        AppPermission.healthSteps => AndroidStepProvider.healthConnect,
        AppPermission.activityRecognition => AndroidStepProvider.sensor,
      };
}
