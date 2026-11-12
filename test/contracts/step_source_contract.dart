import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:walks/domain/models/day.dart';
import 'package:walks/domain/models/day_count.dart';
import 'package:walks/domain/repositories/step_source.dart';

/// The behaviour every [StepSource] must share.
///
/// [create] builds a source that has counted the given steps by day. Each
/// test runs on 12.11.2026 at 10:00 local time.
void stepSourceContract(StepSource Function(Map<Day, int> steps) create) {
  group('StepSource contract', () {
    final today = Day(2026, 11, 12);

    void testOnDay(String description, Future<void> Function() body) => test(
      description,
      () => withClock(Clock.fixed(DateTime(2026, 11, 12, 10)), body),
    );

    testOnDay('stepsByDay returns days in range, both ends included, '
        'earliest first', () async {
      final source = create({
        today - 6: 7000,
        today - 9: 1000,
        today: 300,
        today - 3: 5000,
      });

      expect(await source.stepsByDay(today - 6, today), [
        DayCount(day: today - 6, steps: 7000),
        DayCount(day: today - 3, steps: 5000),
        DayCount(day: today, steps: 300),
      ]);
    });

    testOnDay('stepsByDay leaves out days without data, not zero', () async {
      final source = create({today - 2: 4000});

      final counts = await source.stepsByDay(today - 4, today);

      expect(counts.map((c) => c.day), [today - 2]);
    });

    testOnDay('stepsByDay returns one day when from equals to', () async {
      final source = create({today - 1: 8000, today: 300});

      expect(await source.stepsByDay(today - 1, today - 1), [
        DayCount(day: today - 1, steps: 8000),
      ]);
    });

    testOnDay('stepsByDay returns an empty list when nothing was counted', () {
      final source = create({});

      return expectLater(source.stepsByDay(today - 7, today), completion([]));
    });

    testOnDay('stepsByDay throws ArgumentError when from is after to', () {
      final source = create({today: 300});

      return expectLater(
        source.stepsByDay(today, today - 1),
        throwsArgumentError,
      );
    });

    testOnDay('watchToday emits the current count on listen', () async {
      final source = create({today - 1: 8000, today: 300});

      expect(await source.watchToday().first, DayCount(day: today, steps: 300));
    });
  });
}
