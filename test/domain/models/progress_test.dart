import 'package:flutter_test/flutter_test.dart';
import 'package:walks/domain/rules/chapters.dart';

import '../fixtures.dart';

void main() {
  group('Progress.reserve', () {
    test('is every counted step when nothing is spent', () {
      final progress = start
          .recordAutoSteps(installDay, 3000)
          .recordAutoSteps(installDay + 1, 4000);

      expect(progress.reserve, 7000);
    });

    test('adds the steps added by hand to the auto ones', () {
      final progress = start
          .recordAutoSteps(installDay, 4000)
          .recordManualSteps(installDay, 3000);

      expect(progress.reserve, 7000);
    });

    test('late auto data still counts after an addition by hand', () {
      final progress = start
          .recordAutoSteps(installDay, 4000)
          .recordManualSteps(installDay, 3000)
          .recordAutoSteps(installDay, 4500);

      expect(progress.reserve, 7500);
    });

    test('a new addition replaces the old one, zero removes it', () {
      final edited = withSteps(4000).recordManualSteps(installDay, 3000);

      expect(edited.recordManualSteps(installDay, 1000).reserve, 5000);
      expect(edited.recordManualSteps(installDay, 0).reserve, 4000);
    });

    test('ignores steps before the install day', () {
      final progress = start.recordAutoSteps(installDay - 1, 9000);

      expect(progress.reserve, 0);
      expect(progress.days, isEmpty);
    });

    test('follows a smaller total from the step source', () {
      final progress = withSteps(4600).recordAutoSteps(installDay, 4300);

      expect(progress.reserve, 4300);
    });

    test('goes into debt when a total shrinks after spending', () {
      final progress = openChapter(
        withSteps(1000),
        strict,
        'c1',
        now: now,
      ).recordAutoSteps(installDay, 600);

      expect(progress.reserve, -400);
      expect(progress.isOpened('story', 'c1'), isTrue);
    });

    test('goes into debt when an addition is removed after spending', () {
      final progress = openChapter(
        start.recordManualSteps(installDay, 1000),
        strict,
        'c1',
        now: now,
      ).recordManualSteps(installDay, 0);

      expect(progress.reserve, -1000);
      expect(progress.isOpened('story', 'c1'), isTrue);
    });

    test('new steps pay the debt first', () {
      final inDebt = openChapter(
        withSteps(1000),
        strict,
        'c1',
        now: now,
      ).recordAutoSteps(installDay, 600);

      expect(inDebt.recordAutoSteps(installDay + 1, 1000).reserve, 600);
    });

    test('a date going back after a flight adds to the existing day', () {
      final progress = start
          .recordAutoSteps(installDay + 1, 2000)
          .recordAutoSteps(installDay, 3000)
          .recordAutoSteps(installDay + 1, 2500);

      expect(progress.reserve, 5500);
    });
  });
}
