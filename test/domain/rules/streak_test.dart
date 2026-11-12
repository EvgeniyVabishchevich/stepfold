import 'package:flutter_test/flutter_test.dart';
import 'package:walks/domain/models/progress.dart';
import 'package:walks/domain/rules/streak.dart';

import '../fixtures.dart';

void main() {
  /// [start] with steps by day offset from the install day.
  Progress walked(Map<int, int> stepsByOffset) {
    var progress = start;
    stepsByOffset.forEach((offset, steps) {
      progress = progress.recordAutoSteps(installDay + offset, steps);
    });
    return progress;
  }

  group('streak', () {
    test('counts days in a row with at least 1 000 steps', () {
      final progress = walked({0: 1200, 1: 3000, 2: 1000});

      expect(streak(progress, installDay + 2), 3);
    });

    test('a day under the threshold breaks it', () {
      final progress = walked({0: 1200, 1: 999, 2: 1500, 3: 2000});

      expect(streak(progress, installDay + 3), 2);
    });

    test('today under the threshold does not break it yet', () {
      final progress = walked({0: 1200, 1: 3000, 2: 400});

      expect(streak(progress, installDay + 2), 2);
    });

    test('steps added by hand count', () {
      final progress = walked({
        0: 1200,
        1: 600,
      }).recordManualSteps(installDay + 1, 400);

      expect(streak(progress, installDay + 1), 2);
    });

    test('is zero after a missed day', () {
      expect(streak(walked({0: 1200}), installDay + 2), 0);
    });
  });
}
