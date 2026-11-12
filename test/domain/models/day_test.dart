import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:walks/domain/models/day.dart';

void main() {
  group('Day', () {
    test('keeps the calendar date', () {
      final day = Day(2026, 11, 12);

      expect((day.year, day.month, day.day), (2026, 11, 12));
      expect(day.toString(), '2026-11-12');
    });

    test('equal dates are equal, whatever way they were made', () {
      expect(Day(2026, 11, 12), Day.fromLocal(DateTime(2026, 11, 12, 23, 59)));
      expect(Day(2026, 11, 12), Day.fromNumber(Day(2026, 11, 12).number));
    });

    test('takes the local date of a moment, not the UTC one', () {
      final lateEvening = DateTime(2026, 11, 12, 23, 30);

      expect(Day.fromLocal(lateEvening.toUtc()), Day(2026, 11, 12));
    });

    test('today comes from clock', () {
      withClock(Clock.fixed(DateTime(2026, 11, 12, 9)), () {
        expect(Day.today(), Day(2026, 11, 12));
      });
    });

    test('adds days across month and year ends', () {
      expect(Day(2026, 12, 31) + 1, Day(2027, 1, 1));
      expect(Day(2026, 3, 1) - 1, Day(2026, 2, 28));
    });

    test('a daylight saving change does not skip or repeat a day', () {
      // In Europe the clocks move on 29.03 and 25.10 2026.
      expect(Day(2026, 3, 29) + 1, Day(2026, 3, 30));
      expect(Day(2026, 10, 25) + 1, Day(2026, 10, 26));
    });

    test('counts and compares days', () {
      final a = Day(2026, 11, 5);
      final b = Day(2026, 11, 12);

      expect(b.difference(a), 7);
      expect(a.isBefore(b), isTrue);
      expect(b.isAfter(a), isTrue);
      expect([b, a]..sort(), [a, b]);
    });
  });
}
