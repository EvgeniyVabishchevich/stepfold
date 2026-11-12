import 'package:flutter_test/flutter_test.dart';
import 'package:walks/domain/failures/progress_failure.dart';
import 'package:walks/domain/models/goal.dart';
import 'package:walks/domain/models/progress.dart';
import 'package:walks/domain/models/spending.dart';
import 'package:walks/domain/rules/chapters.dart';
import 'package:walks/domain/rules/goal.dart';

import '../fixtures.dart';

void main() {
  Progress open(Progress progress, String chapterId) => openChapter(
    progress,
    chapterId.startsWith('t') ? free : strict,
    chapterId,
    now: now,
  );

  group('availableChapters', () {
    test('strict order offers only the first closed chapter', () {
      final progress = open(withSteps(1000), 'c1');

      expect(availableChapters(progress, strict).map((c) => c.id), ['c2']);
    });

    test('free order offers every closed chapter', () {
      final progress = open(withSteps(1000), 't1');

      expect(availableChapters(start, free).map((c) => c.id), ['t1', 't2']);
      expect(availableChapters(progress, free).map((c) => c.id), ['t2']);
    });
  });

  group('openChapter', () {
    test('spends the price from the reserve', () {
      final progress = open(withSteps(2500), 'c1');

      expect(progress.reserve, 1500);
      expect(progress.isOpened('story', 'c1'), isTrue);
    });

    test('records the price paid and the moment in UTC', () {
      final progress = open(withSteps(2500), 'c1');

      expect(
        progress.spendings.single,
        Spending.chapter(
          progressionId: 'story',
          chapterId: 'c1',
          price: 1000,
          at: now,
        ),
      );
    });

    test('refuses when the reserve is short', () {
      expect(
        () => open(withSteps(999), 'c1'),
        throwsA(
          isA<NotEnoughSteps>()
              .having((f) => f.price, 'price', 1000)
              .having((f) => f.reserve, 'reserve', 999),
        ),
      );
    });

    test('refuses while in debt', () {
      final inDebt = open(withSteps(1000), 't1').recordAutoSteps(installDay, 0);

      expect(
        () => open(inDebt, 't2'),
        throwsA(
          isA<NotEnoughSteps>().having((f) => f.reserve, 'reserve', -1000),
        ),
      );
    });

    test('refuses a chapter out of strict order', () {
      expect(
        () => open(withSteps(9000), 'c2'),
        throwsA(isA<ChapterUnavailable>()),
      );
    });

    // Free order: only the "already opened" check stops it, not the order.
    test('refuses a chapter opened before, so a double tap pays once', () {
      final progress = open(withSteps(9000), 't1');

      expect(() => open(progress, 't1'), throwsA(isA<ChapterUnavailable>()));
      expect(progress.reserve, 8000);
    });

    test('refuses an unknown chapter', () {
      expect(
        () => open(withSteps(9000), 'nope'),
        throwsA(isA<ChapterUnavailable>()),
      );
    });

    test('strict order: the goal moves to the next chapter', () {
      final withGoal = selectGoal(
        withSteps(9000),
        const Goal.chapter(progressionId: 'story', chapterId: 'c1'),
        strict,
      );

      expect(
        open(withGoal, 'c1').goal,
        const Goal.chapter(progressionId: 'story', chapterId: 'c2'),
      );
    });

    test('strict order: the goal is removed after the last chapter', () {
      final twoOpened = open(open(withSteps(11000), 'c1'), 'c2');
      final withGoal = selectGoal(
        twoOpened,
        const Goal.chapter(progressionId: 'story', chapterId: 'c3'),
        strict,
      );

      expect(open(withGoal, 'c3').goal, isNull);
    });

    test('free order: the goal is removed after opening', () {
      final withGoal = selectGoal(
        withSteps(9000),
        const Goal.chapter(progressionId: 'trip', chapterId: 't2'),
        free,
      );

      expect(open(withGoal, 't2').goal, isNull);
    });

    test('opening another chapter keeps the goal', () {
      const goal = Goal.chapter(progressionId: 'trip', chapterId: 't2');
      final withGoal = selectGoal(withSteps(9000), goal, free);

      expect(open(withGoal, 't1').goal, goal);
    });
  });

  group('isFinished', () {
    test('only when every chapter is opened', () {
      final two = open(open(withSteps(11000), 'c1'), 'c2');

      expect(isFinished(two, strict), isFalse);
      expect(isFinished(open(two, 'c3'), strict), isTrue);
    });
  });
}
