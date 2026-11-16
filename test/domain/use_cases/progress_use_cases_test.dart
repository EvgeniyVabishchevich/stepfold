import 'package:clock/clock.dart' show Clock, withClock;
import 'package:flutter_test/flutter_test.dart';
import 'package:walks/data/repositories/progress/fake_progress_repository.dart';
import 'package:walks/domain/failures/manual_entry_failure.dart';
import 'package:walks/domain/failures/progress_failure.dart';
import 'package:walks/domain/failures/storage_failure.dart';
import 'package:walks/domain/models/goal.dart';
import 'package:walks/domain/models/manual_entry_lock.dart';
import 'package:walks/domain/models/medal.dart';
import 'package:walks/domain/models/spending.dart';
import 'package:walks/domain/rules/manual_entry.dart';
import 'package:walks/domain/use_cases/add_manual_steps.dart';
import 'package:walks/domain/use_cases/buy_medal.dart';
import 'package:walks/domain/use_cases/open_chapter.dart';
import 'package:walks/domain/use_cases/set_goal.dart';

import '../fixtures.dart';

void main() {
  late FakeProgressRepository repository;

  setUp(() => repository = FakeProgressRepository(withSteps(20000)));
  tearDown(() => repository.close());

  void testNow(String description, Future<void> Function() body) =>
      test(description, () => withClock(Clock.fixed(now), body));

  group('OpenChapter', () {
    testNow('saves the chapter with its price and the moment', () async {
      await OpenChapter(repository)(strict, 'c1');

      expect(repository.progress.spendings, [
        Spending.chapter(
          progressionId: 'story',
          chapterId: 'c1',
          price: 1000,
          at: now,
        ),
      ]);
    });

    testNow('saves the goal moved to the next chapter', () async {
      await repository.saveGoal(
        const Goal.chapter(progressionId: 'story', chapterId: 'c1'),
      );

      await OpenChapter(repository)(strict, 'c1');

      expect(
        repository.progress.goal,
        const Goal.chapter(progressionId: 'story', chapterId: 'c2'),
      );
    });

    testNow('a refusal of the rules saves nothing', () async {
      await expectLater(
        OpenChapter(repository)(strict, 'c2'),
        throwsA(isA<ChapterUnavailable>()),
      );

      expect(repository.progress.spendings, isEmpty);
    });

    testNow('a full storage comes to the caller', () async {
      repository.failNext(const StorageFull());

      await expectLater(
        OpenChapter(repository)(strict, 'c1'),
        throwsA(isA<StorageFull>()),
      );
    });
  });

  group('BuyMedal', () {
    testNow('saves the next medal once the progression is finished', () async {
      final open = OpenChapter(repository);
      await open(free, 't1');
      await open(free, 't2');

      await BuyMedal(repository)(free);

      expect(
        repository.progress.spendings.last,
        isA<MedalBought>().having((m) => m.medal, 'medal', Medal.silver),
      );
    });

    testNow('an unfinished progression is refused', () {
      return expectLater(
        BuyMedal(repository)(free),
        throwsA(isA<MedalUnavailable>()),
      );
    });
  });

  group('SetGoal', () {
    testNow('saves a goal the rules allow, clear removes it', () async {
      const goal = Goal.chapter(progressionId: 'trip', chapterId: 't2');
      final setGoal = SetGoal(repository);

      await setGoal(goal, free);
      expect(repository.progress.goal, goal);

      await setGoal.clear();
      expect(repository.progress.goal, isNull);
    });

    testNow('a goal the rules refuse is not saved', () async {
      await expectLater(
        SetGoal(repository)(
          const Goal.chapter(progressionId: 'story', chapterId: 'c3'),
          strict,
        ),
        throwsA(isA<ChapterUnavailable>()),
      );

      expect(repository.progress.goal, isNull);
    });
  });

  group('AddManualSteps', () {
    const unlocked = ManualEntryLock();
    // `now` is 12.11, 11 days after the install day.
    final yesterday = installDay + 10;

    testNow('saves an addition that passed the checks', () async {
      final check = await AddManualSteps(repository)(
        yesterday,
        3000,
        lock: unlocked,
      );

      expect(check, ManualEntryCheck.ok);
      expect(repository.progress.stepsOf(yesterday).manual, 3000);
    });

    testNow('a large addition waits for the confirmation', () async {
      final add = AddManualSteps(repository);

      final check = await add(yesterday, 60000, lock: unlocked);
      expect(check, ManualEntryCheck.needsConfirmation);
      expect(repository.progress.stepsOf(yesterday).manual, isNull);

      await add(yesterday, 60000, lock: unlocked, confirmed: true);
      expect(repository.progress.stepsOf(yesterday).manual, 60000);
    });

    testNow('a locked entry is refused and not saved', () async {
      await expectLater(
        AddManualSteps(repository)(
          yesterday,
          3000,
          lock: const ManualEntryLock(locked: true),
        ),
        throwsA(isA<ManualEntryLocked>()),
      );

      expect(repository.progress.stepsOf(yesterday).manual, isNull);
    });

    testNow('a day more than a week back is refused', () {
      return expectLater(
        AddManualSteps(repository)(installDay, 3000, lock: unlocked),
        throwsA(isA<ManualEntryDayOutOfRange>()),
      );
    });
  });
}
