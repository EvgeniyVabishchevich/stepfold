import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:walks/data/repositories/steps/fake_step_source.dart';
import 'package:walks/domain/failures/step_source_failure.dart';
import 'package:walks/domain/models/app_permission.dart';
import 'package:walks/domain/models/day.dart';
import 'package:walks/domain/models/day_count.dart';

import '../../../contracts/step_source_contract.dart';

void main() {
  stepSourceContract((steps) => FakeStepSource(steps: steps));

  group('FakeStepSource', () {
    final today = Day(2026, 11, 12);
    // A clock the test can move, to cross midnight.
    late DateTime now;
    late FakeStepSource source;

    setUp(() {
      now = DateTime(2026, 11, 12, 10);
      source = FakeStepSource();
    });
    tearDown(() => source.close());

    void testOnClock(String description, Future<void> Function() body) =>
        test(description, () => withClock(Clock(() => now), body));

    testOnClock('watchToday emits each new count of today', () async {
      final counts = <DayCount>[];
      final subscription = source.watchToday().listen(counts.add);

      source
        ..setSteps(today, 100)
        ..setSteps(today, 250);
      await pumpEventQueue();

      expect(counts.map((c) => c.steps), [100, 250]);
      await subscription.cancel();
    });

    testOnClock('watchToday emits nothing on listen while today has no '
        'data', () async {
      final counts = <DayCount>[];
      final subscription = source.watchToday().listen(counts.add);
      await pumpEventQueue();

      expect(counts, isEmpty);
      await subscription.cancel();
    });

    testOnClock('late data for a past day is not emitted, but read by '
        'stepsByDay', () async {
      final counts = <DayCount>[];
      final subscription = source.watchToday().listen(counts.add);

      source.setSteps(today - 1, 9000);
      await pumpEventQueue();

      expect(counts, isEmpty);
      expect(await source.stepsByDay(today - 1, today - 1), [
        DayCount(day: today - 1, steps: 9000),
      ]);
      await subscription.cancel();
    });

    testOnClock('after midnight counts carry the new day', () async {
      final counts = <DayCount>[];
      final subscription = source.watchToday().listen(counts.add);

      source.setSteps(today, 9950);
      now = DateTime(2026, 11, 13, 0, 1);
      source.setSteps(today + 1, 20);
      await pumpEventQueue();

      expect(counts, [
        DayCount(day: today, steps: 9950),
        DayCount(day: today + 1, steps: 20),
      ]);
      await subscription.cancel();
    });

    testOnClock('every listener gets the counts', () async {
      final first = <int>[];
      final second = <int>[];
      final a = source.watchToday().listen((c) => first.add(c.steps));
      final b = source.watchToday().listen((c) => second.add(c.steps));

      source.setSteps(today, 500);
      await pumpEventQueue();

      expect(first, [500]);
      expect(second, [500]);
      await a.cancel();
      await b.cancel();
    });

    testOnClock('setSteps replaces the count of a day', () async {
      source
        ..setSteps(today - 1, 9000)
        ..setSteps(today - 1, 7500);

      expect(await source.stepsByDay(today - 1, today - 1), [
        DayCount(day: today - 1, steps: 7500),
      ]);
    });

    test('refuses negative steps', () {
      expect(() => source.setSteps(today, -1), throwsArgumentError);
      expect(() => FakeStepSource(steps: {today: -1}), throwsArgumentError);
    });

    testOnClock('failNext makes only the next stepsByDay throw', () async {
      source.failNext(const StepPermissionDenied());

      await expectLater(
        source.stepsByDay(today, today),
        throwsA(isA<StepPermissionDenied>()),
      );
      await expectLater(source.stepsByDay(today, today), completion([]));
    });

    testOnClock('failNext with times fails that many calls', () async {
      source.failNext(const StepSourceUnavailable(), times: 2);

      for (var i = 0; i < 2; i++) {
        await expectLater(
          source.stepsByDay(today, today),
          throwsA(isA<StepSourceUnavailable>()),
        );
      }
      await expectLater(source.stepsByDay(today, today), completion([]));
    });

    testOnClock('failWatch sends the failure to listeners', () async {
      final errors = <Object>[];
      final subscription = source.watchToday().listen(
        (_) {},
        onError: errors.add,
      );

      source.failWatch(const StepSourceUnavailable());
      await pumpEventQueue();

      expect(errors, [isA<StepSourceUnavailable>()]);
      await subscription.cancel();
    });

    test('names the sensor permission by default', () {
      expect(source.requiredPermission, AppPermission.activityRecognition);
      expect(
        FakeStepSource(
          requiredPermission: AppPermission.healthSteps,
        ).requiredPermission,
        AppPermission.healthSteps,
      );
    });
  });
}
