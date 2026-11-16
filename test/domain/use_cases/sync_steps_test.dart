import 'dart:async';

import 'package:clock/clock.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:walks/data/repositories/progress/fake_progress_repository.dart';
import 'package:walks/data/repositories/steps/fake_step_source.dart';
import 'package:walks/domain/failures/step_source_failure.dart';
import 'package:walks/domain/failures/storage_failure.dart';
import 'package:walks/domain/models/day.dart';
import 'package:walks/domain/models/day_count.dart';
import 'package:walks/domain/models/progress.dart';
import 'package:walks/domain/use_cases/sync_steps.dart';

void main() {
  final today = Day(2026, 11, 12);
  final morning = DateTime(2026, 11, 12, 10);

  group('SyncSteps.catchUp', () {
    late FakeProgressRepository repository;
    late FakeStepSource source;

    tearDown(() async {
      await repository.close();
      await source.close();
    });

    Future<void> catchUp() => withClock(
      Clock.fixed(morning),
      () => SyncSteps(progress: repository, source: source).catchUp(),
    );

    test('right after install reads from the install day', () async {
      repository = FakeProgressRepository.installedOn(today - 2);
      source = FakeStepSource(
        steps: {today - 3: 9000, today - 2: 4000, today: 300},
      );

      await catchUp();

      expect(repository.progress.days.keys, [today - 2, today]);
    });

    test('after a long break fills every day since the last one', () async {
      repository = FakeProgressRepository(
        Progress(installDay: today - 60).recordAutoSteps(today - 20, 5000),
      );
      source = FakeStepSource(steps: {today - 20: 5100, today - 15: 7000});

      await catchUp();

      expect(repository.progress.stepsOf(today - 20).auto, 5100);
      expect(repository.progress.stepsOf(today - 15).auto, 7000);
    });

    test('reads the last week again for late corrections', () async {
      repository = FakeProgressRepository(
        Progress(
          installDay: today - 60,
        ).recordAutoSteps(today - 3, 4000).recordAutoSteps(today - 1, 6000),
      );
      // The watch synced late: three days ago gained steps.
      source = FakeStepSource(steps: {today - 3: 9000, today - 1: 6000});

      await catchUp();

      expect(repository.progress.stepsOf(today - 3).auto, 9000);
    });

    test('a day without data keeps what is saved', () async {
      repository = FakeProgressRepository(
        Progress(installDay: today - 60).recordAutoSteps(today - 2, 4000),
      );
      source = FakeStepSource();

      await catchUp();

      expect(repository.progress.stepsOf(today - 2).auto, 4000);
    });

    test('a failure of the source comes to the caller', () async {
      repository = FakeProgressRepository.installedOn(today - 2);
      source = FakeStepSource()..failNext(const StepPermissionDenied());

      await expectLater(catchUp(), throwsA(isA<StepPermissionDenied>()));
    });
  });

  group('SyncSteps.followToday', () {
    const interval = Duration(seconds: 5);

    // Runs [body] in fake time that starts at 10:00 on 12.11.2026; the
    // clock follows the fake time.
    void testInFakeTime(
      String description,
      void Function(
        FakeAsync async,
        FakeProgressRepository repository,
        FakeStepSource source,
        List<DayCount> saved,
        StreamSubscription<DayCount> subscription,
      )
      body,
    ) => test(description, () {
      fakeAsync((async) {
        withClock(async.getClock(morning), () {
          final repository = FakeProgressRepository.installedOn(today - 5);
          final source = FakeStepSource();
          final saved = <DayCount>[];
          final subscription = SyncSteps(
            progress: repository,
            source: source,
          ).followToday().listen(saved.add, onError: (_) {});
          async.flushMicrotasks();
          body(async, repository, source, saved, subscription);
          unawaited(subscription.cancel());
          async.flushMicrotasks();
        });
      });
    });

    testInFakeTime('saves the first count at once', (
      async,
      repository,
      source,
      saved,
      _,
    ) {
      source.setSteps(today, 100);
      async.flushMicrotasks();

      expect(repository.progress.stepsOf(today).auto, 100);
    });

    testInFakeTime('within the interval saves only the latest count', (
      async,
      repository,
      source,
      saved,
      _,
    ) {
      source.setSteps(today, 100);
      async.elapse(const Duration(seconds: 1));
      source.setSteps(today, 150);
      async.elapse(const Duration(seconds: 1));
      source.setSteps(today, 220);
      async.elapse(interval);

      expect(saved.map((c) => c.steps), [100, 220]);
      expect(repository.progress.stepsOf(today).auto, 220);
    });

    testInFakeTime('a count of a new day saves the old day first', (
      async,
      repository,
      source,
      saved,
      _,
    ) {
      source.setSteps(today, 9000);
      async.elapse(const Duration(seconds: 1));
      source.setSteps(today, 9950);
      // Midnight passes inside the interval.
      async.elapse(const Duration(hours: 14));
      source.setSteps(today + 1, 20);
      async.flushMicrotasks();

      expect(repository.progress.stepsOf(today).auto, 9950);
      expect(repository.progress.stepsOf(today + 1).auto, 20);
    });

    testInFakeTime('cancelling saves the pending count', (
      async,
      repository,
      source,
      saved,
      subscription,
    ) {
      source.setSteps(today, 100);
      async.elapse(const Duration(seconds: 1));
      source.setSteps(today, 180);
      async.flushMicrotasks();
      unawaited(subscription.cancel());
      async.flushMicrotasks();

      expect(repository.progress.stepsOf(today).auto, 180);
    });

    test('a failure of the storage comes through the stream', () {
      fakeAsync((async) {
        withClock(async.getClock(morning), () {
          final repository = FakeProgressRepository.installedOn(today - 5)
            ..failNext(const StorageFull());
          final source = FakeStepSource();
          final errors = <Object>[];
          final subscription = SyncSteps(
            progress: repository,
            source: source,
          ).followToday().listen((_) {}, onError: errors.add);
          async.flushMicrotasks();

          source.setSteps(today, 100);
          async.flushMicrotasks();

          expect(errors, [isA<StorageFull>()]);
          unawaited(subscription.cancel());
          async.flushMicrotasks();
        });
      });
    });
  });
}
