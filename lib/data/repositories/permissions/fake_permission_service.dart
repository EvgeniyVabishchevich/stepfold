import 'package:walks/domain/models/app_permission.dart';
import 'package:walks/domain/repositories/permission_service.dart';

/// A [PermissionService] in memory, set up by the test or the developer
/// menu.
///
/// Like the platforms, it shows "the dialog" only in
/// [PermissionStatus.canRequest]; the user's answer is [answer].
class FakePermissionService implements PermissionService {
  /// Creates a service where every permission starts as [initial], except
  /// those set in [statuses].
  FakePermissionService({
    Map<AppPermission, PermissionStatus> statuses = const {},
    this.initial = PermissionStatus.canRequest,
    this.answer = PermissionStatus.granted,
  }) : _statuses = {...statuses};

  /// The status of a permission not set in the constructor or by
  /// [setStatus].
  final PermissionStatus initial;

  /// What the user answers in the dialog: [PermissionStatus.granted],
  /// [PermissionStatus.canRequest] (declined, may be asked again) or
  /// [PermissionStatus.blocked] (declined for good).
  PermissionStatus answer;

  final Map<AppPermission, PermissionStatus> _statuses;
  final List<AppPermission> _dialogs = [];
  int _settingsOpened = 0;

  /// The permissions a dialog was shown for, in order.
  List<AppPermission> get dialogs => List.unmodifiable(_dialogs);

  /// How many times [openSettings] was called.
  int get settingsOpened => _settingsOpened;

  /// Changes the status of [permission], as the user does in the settings.
  void setStatus(AppPermission permission, PermissionStatus status) =>
      _statuses[permission] = status;

  @override
  Future<PermissionStatus> status(AppPermission permission) async =>
      _statuses[permission] ?? initial;

  @override
  Future<PermissionStatus> request(AppPermission permission) async {
    final current = await status(permission);
    if (current != PermissionStatus.canRequest) return current;
    _dialogs.add(permission);
    return _statuses[permission] = answer;
  }

  @override
  Future<void> openSettings() async => _settingsOpened++;
}
