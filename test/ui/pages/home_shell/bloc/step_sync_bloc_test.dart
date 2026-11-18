import 'package:flutter_test/flutter_test.dart';
import 'package:walks/data/repositories/crash/fake_crash_reporter.dart';
import 'package:walks/data/repositories/permissions/fake_permission_service.dart';
import 'package:walks/data/repositories/progress/fake_progress_repository.dart';
import 'package:walks/data/repositories/steps/fake_step_source.dart';
import 'package:walks/domain/failures/step_source_failure.dart';
import 'package:walks/domain/failures/storage_failure.dart';
import 'package:walks/domain/models/app_permission.dart';
import 'package:walks/domain/models/day.dart';
import 'package:walks/domain/use_cases/sync_steps.dart';
import 'package:walks/ui/pages/home_shell/bloc/step_sync_bloc.dart';

void main() {
  late FakePermissionService permission;
  late FakeProgressRepository progress;
  late FakeStepSource source;
  late FakeCrashReporter reporter;
  late StepSyncBloc bloc;
  final today = Day.today();

  setUp(() {
    permission = FakePermissionService();
    progress = FakeProgressRepository.installedOn(today);
    source = FakeStepSource(steps: {today: 1500});
    reporter = FakeCrashReporter();
    bloc = StepSyncBloc(
      permissions: permission,
      source: source,
      sync: SyncSteps(progress: progress, source: source),
      crashReporter: reporter,
    );
  });

  tearDown(() async {
    await bloc.close();
    await source.close();
    await progress.close();
  });

  Future<StepSyncState> run(StepSyncEvent event) {
    final result = bloc.stream.firstWhere((state) => !state.checking);
    bloc.add(event);
    return result;
  }

  void grant() =>
      permission.setStatus(source.requiredPermission, PermissionStatus.granted);

  test('asks only after the user acts and saves steps when granted', () async {
    expect(
      (await run(const CheckStepSync())).permission,
      PermissionStatus.canRequest,
    );
    expect(permission.dialogs, isEmpty);
    expect(progress.progress.days, isEmpty);

    expect(
      (await run(const RequestStepPermission())).permission,
      PermissionStatus.granted,
    );
    expect(permission.dialogs, [source.requiredPermission]);
    expect(progress.progress.reserve, 1500);
  });

  test(
    'a revoked permission stops the live stream and refreshes status',
    () async {
      grant();
      await run(const CheckStepSync());

      permission.setStatus(source.requiredPermission, PermissionStatus.blocked);
      final failure = bloc.stream.firstWhere((s) => s.sourceFailure != null);
      source.failWatch(const StepPermissionDenied());
      expect((await failure).permission, PermissionStatus.blocked);
      source.setSteps(today, 2000);
      await Future<void>.delayed(Duration.zero);
      expect(progress.progress.reserve, 1500);
    },
  );

  test(
    'a missing source keeps the saved progress and can be retried',
    () async {
      grant();
      await progress.saveAutoSteps(today, 400);
      source.failNext(const StepSourceUnavailable());

      expect(
        (await run(const CheckStepSync())).sourceFailure,
        isA<StepSourceUnavailable>(),
      );
      expect(progress.progress.reserve, 400);
      expect((await run(const CheckStepSync())).sourceFailure, isNull);
      expect(progress.progress.reserve, 1500);
    },
  );

  test('full storage can be retried without a crash report', () async {
    grant();
    progress.failNext(const StorageFull());
    expect(
      (await run(const CheckStepSync())).storageFailure,
      isA<StorageFull>(),
    );
    expect(reporter.errors, isEmpty);
    expect((await run(const CheckStepSync())).storageFailure, isNull);
  });

  test('unavailable storage sends its cause to crash reporting', () async {
    grant();
    final cause = StateError('test storage failure');
    progress.failNext(StorageUnavailable(cause));
    expect(
      (await run(const CheckStepSync())).storageFailure,
      isA<StorageUnavailable>(),
    );
    expect(reporter.errors.single.error, same(cause));
  });
}
