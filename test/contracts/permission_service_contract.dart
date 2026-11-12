import 'package:flutter_test/flutter_test.dart';
import 'package:walks/domain/models/app_permission.dart';
import 'package:walks/domain/repositories/permission_service.dart';

/// The behaviour every [PermissionService] must share, whatever state the
/// device is in.
///
/// A real implementation cannot be put into a chosen state, so each promise
/// is checked against the status found at the start. Run it on several
/// set-ups of the fake to cover every status.
void permissionServiceContract(PermissionService Function() create) {
  group('PermissionService contract', () {
    late PermissionService service;

    setUp(() => service = create());

    for (final permission in AppPermission.values) {
      group(permission.name, () {
        test('status completes with a value', () async {
          await expectLater(service.status(permission), completes);
        });

        test('request returns the status reported right after', () async {
          final answered = await service.request(permission);

          expect(await service.status(permission), answered);
        });

        test('request keeps any status but canRequest unchanged', () async {
          final before = await service.status(permission);
          if (before == PermissionStatus.canRequest) return;

          expect(await service.request(permission), before);
        });
      });
    }

    test('openSettings completes', () async {
      await expectLater(service.openSettings(), completes);
    });
  });
}
