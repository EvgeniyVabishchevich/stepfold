import 'package:flutter_test/flutter_test.dart';
import 'package:walks/domain/failures/progress_failure.dart';
import 'package:walks/domain/models/goal.dart';
import 'package:walks/domain/models/medal.dart';
import 'package:walks/domain/rules/chapters.dart';
import 'package:walks/domain/rules/goal.dart';

import '../fixtures.dart';

void main() {
  const c1 = Goal.chapter(progressionId: 'story', chapterId: 'c1');
  const t1 = Goal.chapter(progressionId: 'trip', chapterId: 't1');
  const t2 = Goal.chapter(progressionId: 'trip', chapterId: 't2');

  group('selectGoal', () {
    test('spends nothing', () {
      expect(selectGoal(withSteps(3000), c1, strict).reserve, 3000);
    });

    test('strict order allows only the first closed chapter', () {
      expect(
        () => selectGoal(
          start,
          const Goal.chapter(progressionId: 'story', chapterId: 'c2'),
          strict,
        ),
        throwsA(isA<ChapterUnavailable>()),
      );
    });

    test('free order allows any closed chapter', () {
      expect(selectGoal(start, t2, free).goal, t2);
    });

    test('an opened chapter cannot be a goal', () {
      final progress = openChapter(withSteps(1000), free, 't1', now: now);

      expect(
        () => selectGoal(progress, t1, free),
        throwsA(isA<ChapterUnavailable>()),
      );
    });

    test('changing the goal keeps the reserve', () {
      final progress = selectGoal(
        selectGoal(withSteps(1500), t2, free),
        t1,
        free,
      );

      expect(progress.goal, t1);
      expect(progress.reserve, 1500);
    });

    test('only the next medal can be a goal', () {
      var finished = withSteps(20000);
      for (final id in ['c1', 'c2', 'c3']) {
        finished = openChapter(finished, strict, id, now: now);
      }

      expect(
        () => selectGoal(
          finished,
          const Goal.medal(progressionId: 'story', medal: Medal.gold),
          strict,
        ),
        throwsA(isA<MedalUnavailable>()),
      );
    });
  });

  group('stepsLeft', () {
    test('is zero without a goal', () {
      expect(stepsLeft(withSteps(3000), strict), 0);
    });

    test('is zero when the reserve covers the price', () {
      expect(stepsLeft(selectGoal(withSteps(3000), c1, strict), strict), 0);
    });

    test('is the price minus the reserve', () {
      final progress = selectGoal(withSteps(600), t2, free);

      expect(stepsLeft(progress, free), 1400);
    });

    test('a debt adds to it', () {
      final inDebt = openChapter(
        withSteps(1000),
        free,
        't1',
        now: now,
      ).recordAutoSteps(installDay, 500);

      expect(stepsLeft(selectGoal(inDebt, t2, free), free), 2500);
    });

    test('a medal goal costs its share of the route', () {
      var finished = withSteps(11000);
      for (final id in ['c1', 'c2', 'c3']) {
        finished = openChapter(finished, strict, id, now: now);
      }
      final progress = selectGoal(
        finished,
        const Goal.medal(progressionId: 'story', medal: Medal.silver),
        strict,
      );

      expect(stepsLeft(progress, strict), 1100);
    });
  });

  test('clearing the goal keeps the reserve', () {
    final progress = selectGoal(withSteps(1500), t1, free).copyWith(goal: null);

    expect(progress.goal, isNull);
    expect(progress.reserve, 1500);
  });
}
