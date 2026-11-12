import 'package:flutter_test/flutter_test.dart';
import 'package:walks/domain/failures/manual_entry_failure.dart';
import 'package:walks/domain/models/day.dart';
import 'package:walks/domain/models/manual_entry_lock.dart';
import 'package:walks/domain/rules/manual_entry.dart';

void main() {
  final now = DateTime.utc(2026, 11, 12, 15);
  final today = Day(2026, 11, 12);
  final installDay = Day(2026, 10, 1);

  ManualEntryCheck check(
    Day day, {
    int steps = 5000,
    Day? installedOn,
    ManualEntryLock lock = const ManualEntryLock(),
  }) => checkManualEntry(
    day: day,
    steps: steps,
    installDay: installedOn ?? installDay,
    today: today,
    lock: lock,
    now: now,
  );

  group('checkManualEntry', () {
    test('accepts today and up to 7 days back', () {
      expect(check(today), ManualEntryCheck.ok);
      expect(check(today - 7), ManualEntryCheck.ok);
    });

    test('refuses 8 days back', () {
      expect(() => check(today - 8), throwsA(isA<ManualEntryDayOutOfRange>()));
    });

    test('refuses a future day', () {
      expect(() => check(today + 1), throwsA(isA<ManualEntryDayOutOfRange>()));
    });

    test('refuses a day before the install day', () {
      expect(
        () => check(today - 3, installedOn: today - 2),
        throwsA(isA<ManualEntryDayOutOfRange>()),
      );
    });

    test('refuses negative steps', () {
      expect(
        () => check(today, steps: -1),
        throwsA(isA<ManualEntryNegative>()),
      );
    });

    test('accepts zero, which removes the addition', () {
      expect(check(today, steps: 0), ManualEntryCheck.ok);
    });

    test('asks to confirm an addition above 50 000', () {
      expect(check(today, steps: 50000), ManualEntryCheck.ok);
      expect(check(today, steps: 50001), ManualEntryCheck.needsConfirmation);
    });

    test('refuses while locked', () {
      expect(
        () => check(today, lock: const ManualEntryLock(locked: true)),
        throwsA(isA<ManualEntryLocked>()),
      );
    });
  });
}
