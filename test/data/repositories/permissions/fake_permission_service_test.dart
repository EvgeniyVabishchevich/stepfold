import 'package:flutter_test/flutter_test.dart';
import 'package:walks/data/repositories/permissions/fake_permission_service.dart';
import 'package:walks/domain/models/app_permission.dart';

import '../../../contracts/permission_service_contract.dart';

void main() {
  const steps = AppPermission.activityRecognition;
  const health = AppPermission.healthSteps;

  // The contract checks what holds in any state, so it runs from each one.
  group('not asked yet, user allows', () {
    permissionServiceContract(FakePermissionService.new);
  });
  group('not asked yet, user declines for good', () {
    permissionServiceContract(
      () => FakePermissionService(answer: PermissionStatus.blocked),
    );
  });
  for (final status in [
    PermissionStatus.granted,
    PermissionStatus.blocked,
    PermissionStatus.unavailable,
  ]) {
    group('all ${status.name}', () {
      permissionServiceContract(() => FakePermissionService(initial: status));
    });
  }

  group('FakePermissionService', () {
    test('starts every permission as canRequest by default', () async {
      final service = FakePermissionService();

      expect(await service.status(steps), PermissionStatus.canRequest);
      expect(await service.status(health), PermissionStatus.canRequest);
    });

    test('keeps statuses apart per permission', () async {
      final service = FakePermissionService(
        statuses: {health: PermissionStatus.unavailable},
      );

      expect(await service.status(steps), PermissionStatus.canRequest);
      expect(await service.status(health), PermissionStatus.unavailable);
    });

    test('shows the dialog in canRequest and stores the answer', () async {
      final service = FakePermissionService();

      expect(await service.request(steps), PermissionStatus.granted);
      expect(service.dialogs, [steps]);
      expect(await service.status(steps), PermissionStatus.granted);
    });

    test(
      'asks again after a decline, as Android does the first time',
      () async {
        final service = FakePermissionService(
          answer: PermissionStatus.canRequest,
        );

        await service.request(steps);
        await service.request(steps);

        expect(service.dialogs, [steps, steps]);
      },
    );

    test('shows no dialog once declined for good', () async {
      final service = FakePermissionService(answer: PermissionStatus.blocked);

      await service.request(steps);
      final second = await service.request(steps);

      expect(second, PermissionStatus.blocked);
      expect(service.dialogs, [steps]);
    });

    for (final status in [
      PermissionStatus.granted,
      PermissionStatus.blocked,
      PermissionStatus.unavailable,
    ]) {
      test('shows no dialog when ${status.name}', () async {
        final service = FakePermissionService(initial: status);

        expect(await service.request(steps), status);
        expect(service.dialogs, isEmpty);
      });
    }

    test('setStatus works like a change in the settings', () async {
      final service = FakePermissionService(initial: PermissionStatus.blocked)
        ..setStatus(steps, PermissionStatus.granted);

      expect(await service.status(steps), PermissionStatus.granted);
    });

    test('counts openSettings calls', () async {
      final service = FakePermissionService();

      await service.openSettings();
      await service.openSettings();

      expect(service.settingsOpened, 2);
    });
  });
}
