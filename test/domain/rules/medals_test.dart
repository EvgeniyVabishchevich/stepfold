import 'package:flutter_test/flutter_test.dart';
import 'package:walks/domain/failures/progress_failure.dart';
import 'package:walks/domain/models/goal.dart';
import 'package:walks/domain/models/medal.dart';
import 'package:walks/domain/models/progress.dart';
import 'package:walks/domain/rules/chapters.dart';
import 'package:walks/domain/rules/goal.dart';
import 'package:walks/domain/rules/medals.dart';

import '../fixtures.dart';

void main() {
  /// [strict] fully opened with [steps] walked; 11 000 of them spent.
  Progress finished([int steps = 20000]) {
    var progress = withSteps(steps);
    for (final id in ['c1', 'c2', 'c3']) {
      progress = openChapter(progress, strict, id, now: now);
    }
    return progress;
  }

  Progress buy(Progress progress) => buyNextMedal(progress, strict, now: now);

  group('medalOf', () {
    test('no medal until every chapter is opened', () {
      final progress = openChapter(withSteps(9000), strict, 'c1', now: now);

      expect(medalOf(progress, strict), isNull);
    });

    test('finishing gives bronze for free', () {
      final progress = finished();

      expect(medalOf(progress, strict), Medal.bronze);
      expect(progress.reserve, 20000 - 11000);
    });
  });

  group('buyNextMedal', () {
    test('silver costs 10% of the route, gold 30% more', () {
      final silver = buy(finished());
      final gold = buy(silver);

      expect(medalOf(silver, strict), Medal.silver);
      expect(silver.reserve, 9000 - 1100);
      expect(medalOf(gold, strict), Medal.gold);
      expect(gold.reserve, 9000 - 1100 - 3300);
    });

    test('nothing to buy after gold', () {
      final gold = buy(buy(finished()));

      expect(() => buy(gold), throwsA(isA<MedalUnavailable>()));
    });

    test('refuses before the progression is finished', () {
      expect(() => buy(withSteps(9000)), throwsA(isA<MedalUnavailable>()));
    });

    test('refuses when the reserve is short', () {
      expect(() => buy(finished(11000)), throwsA(isA<NotEnoughSteps>()));
    });

    test('the medal goal is removed after buying it', () {
      final withGoal = selectGoal(
        finished(),
        const Goal.medal(progressionId: 'story', medal: Medal.silver),
        strict,
      );

      expect(buy(withGoal).goal, isNull);
    });
  });
}
