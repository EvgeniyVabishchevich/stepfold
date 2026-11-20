import 'dart:async';

import 'package:clock/clock.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:walks/data/repositories/repositories.dart';
import 'package:walks/data/repositories/steps/android_steps.g.dart';
import 'package:walks/domain/domain.dart';

import '../../../contracts/permission_service_contract.dart';
import '../../../contracts/step_source_contract.dart';

void main() {
  for (final status in AndroidStepPermission.values) {
    test(
      'selects the Android source when Health Connect is ${status.name}',
      () async {
        final api = _NativeSteps(AndroidStepProvider.healthConnect, {})
          ..permission = status;
        final selected = await AndroidStepSource.select(api);
        expect(
          selected.requiredPermission,
          status == AndroidStepPermission.unavailable
              ? AppPermission.activityRecognition
              : AppPermission.healthSteps,
        );
      },
    );
  }

  for (final provider in AndroidStepProvider.values) {
    final permission = switch (provider) {
      AndroidStepProvider.healthConnect => AppPermission.healthSteps,
      AndroidStepProvider.sensor => AppPermission.activityRecognition,
    };
    AndroidStepSource create(_NativeSteps api) => switch (provider) {
      AndroidStepProvider.healthConnect => AndroidStepSource.healthConnect(api),
      AndroidStepProvider.sensor => AndroidStepSource.sensor(api),
    };

    group(provider.name, () {
      stepSourceContract((steps) => create(_NativeSteps(provider, steps)));

      for (final status in AndroidStepPermission.values) {
        group(status.name, () {
          permissionServiceContract(
            () => AndroidPermissionService(
              _NativeSteps(provider, {})..permission = status,
              permission,
            ),
          );
        });
      }

      test('opens settings for the selected provider', () async {
        final api = _NativeSteps(provider, {});
        final service = AndroidPermissionService(api, permission);
        expect(create(api).requiredPermission, permission);
        await service.openSettings();
        expect(api.settings, [provider]);
      });

      test('maps native permission and availability errors', () async {
        final today = Day.today();
        final api = _NativeSteps(provider, {});
        final source = create(api);
        api.error = 'step-permission-denied';
        await expectLater(
          source.stepsByDay(today, today),
          throwsA(isA<StepPermissionDenied>()),
        );
        api.error = 'step-source-unavailable';
        await expectLater(
          source.stepsByDay(today, today),
          throwsA(isA<StepSourceUnavailable>()),
        );
      });

      test('emits updates once, follows midnight, and cancels polling', () {
        fakeAsync((async) {
          final start = DateTime(2026, 11, 19, 23, 59);
          final today = Day.fromLocal(start);
          final api = _NativeSteps(provider, {today: 100});
          final source = create(api);
          final received = <DayCount>[];

          final subscription = withClock(
            Clock(() => start.add(async.elapsed)),
            () => source.watchToday().listen(received.add),
          );
          async
            ..flushMicrotasks()
            ..elapse(const Duration(seconds: 10));
          api.steps[today] = 130;
          async.elapse(const Duration(seconds: 50));
          api.steps[today + 1] = 0;
          async.elapse(const Duration(seconds: 30));

          expect(received, [
            DayCount(day: today, steps: 100),
            DayCount(day: today, steps: 130),
            DayCount(day: today + 1, steps: 0),
          ]);
          unawaited(subscription.cancel());
          async.flushMicrotasks();
          final reads = api.reads;
          async.elapse(const Duration(minutes: 1));
          expect(api.reads, reads);
        });
      });
    });
  }
}

final class _NativeSteps extends Fake implements AndroidStepsApi {
  _NativeSteps(this.provider, Map<Day, int> steps) : steps = Map.of(steps);

  final AndroidStepProvider provider;
  final Map<Day, int> steps;
  final settings = <AndroidStepProvider>[];
  AndroidStepPermission permission = AndroidStepPermission.canRequest;
  String? error;
  int reads = 0;

  @override
  Future<AndroidStepPermission> status(AndroidStepProvider provider) async =>
      permission;

  @override
  Future<AndroidStepPermission> request(AndroidStepProvider provider) async {
    if (permission == AndroidStepPermission.canRequest) {
      permission = AndroidStepPermission.granted;
    }
    return permission;
  }

  @override
  Future<void> openSettings(AndroidStepProvider provider) async {
    settings.add(provider);
  }

  @override
  Future<List<AndroidDayCount>> readDays(
    AndroidStepProvider provider,
    int fromDay,
    int toDay,
  ) async {
    expect(provider, this.provider);
    reads++;
    final code = error;
    if (code != null) throw PlatformException(code: code);
    return [
      for (var day = fromDay; day <= toDay; day++)
        if (steps[Day.fromNumber(day)] case final steps?)
          AndroidDayCount(day: day, steps: steps),
    ];
  }
}
