import 'package:flutter_test/flutter_test.dart';
import 'package:walks/domain/models/day.dart';
import 'package:walks/domain/models/day_steps.dart';

void main() {
  final day = Day(2026, 11, 12);

  group('DaySteps', () {
    test('counts auto plus the steps added by hand', () {
      expect(DaySteps(day: day, auto: 4000, manual: 3000).counted, 7000);
      expect(DaySteps(day: day, manual: 3000).counted, 3000);
      expect(DaySteps(day: day, auto: 4000).counted, 4000);
    });

    test('an empty day counts zero', () {
      expect(DaySteps(day: day).counted, 0);
    });

    test('is manual when steps were added by hand', () {
      expect(DaySteps(day: day, auto: 6000, manual: 500).isManual, isTrue);
      expect(DaySteps(day: day, auto: 6000).isManual, isFalse);
      expect(DaySteps(day: day, auto: 6000, manual: 0).isManual, isFalse);
    });

    test('counts for the streak from the threshold on', () {
      expect(DaySteps(day: day, auto: 999).countsForStreak, isFalse);
      expect(DaySteps(day: day, auto: 1000).countsForStreak, isTrue);
      expect(DaySteps(day: day, manual: 1000).countsForStreak, isTrue);
    });
  });
}
