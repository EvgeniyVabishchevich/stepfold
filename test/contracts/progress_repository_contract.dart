import 'package:flutter_test/flutter_test.dart';
import 'package:walks/domain/models/day.dart';
import 'package:walks/domain/models/day_steps.dart';
import 'package:walks/domain/models/goal.dart';
import 'package:walks/domain/models/medal.dart';
import 'package:walks/domain/models/progress.dart';
import 'package:walks/domain/models/spending.dart';
import 'package:walks/domain/repositories/progress_repository.dart';

/// The behaviour every [ProgressRepository] must share.
///
/// [create] builds an empty repository installed on the given day;
/// [dispose], when given, closes it after each test.
void progressRepositoryContract(
  ProgressRepository Function(Day installDay) create, {
  Future<void> Function(ProgressRepository repository)? dispose,
}) {
  group('ProgressRepository contract', () {
    final installDay = Day(2026, 11, 1);
    // Milliseconds on purpose: a storage must not drop them.
    final morning = DateTime.utc(2026, 11, 12, 9, 30, 15, 120);
    final evening = DateTime.utc(2026, 11, 12, 20, 5, 0, 7);
    late ProgressRepository repository;

    setUp(() => repository = create(installDay));
    tearDown(() => dispose?.call(repository));

    Future<Progress> current() => repository.watch().first;

    ChapterOpened chapter(String id, DateTime at) => ChapterOpened(
      progressionId: 'story',
      chapterId: id,
      price: 1000,
      at: at,
    );

    test('watch emits the empty progress of the install day on listen', () {
      return expectLater(
        current(),
        completion(Progress(installDay: installDay)),
      );
    });

    test('saveAutoSteps replaces the total of the day, even with a smaller '
        'one', () async {
      await repository.saveAutoSteps(installDay + 1, 8000);
      await repository.saveAutoSteps(installDay + 1, 7500);

      expect((await current()).days, {
        installDay + 1: DaySteps(day: installDay + 1, auto: 7500),
      });
    });

    test('auto and manual steps of a day are kept apart', () async {
      await repository.saveAutoSteps(installDay + 2, 4500);
      await repository.saveManualSteps(installDay + 2, 3000);
      await repository.saveAutoSteps(installDay + 2, 4600);

      expect(
        (await current()).stepsOf(installDay + 2),
        DaySteps(day: installDay + 2, auto: 4600, manual: 3000),
      );
    });

    test('saveManualSteps with zero removes the addition', () async {
      await repository.saveManualSteps(installDay, 3000);
      await repository.saveManualSteps(installDay, 0);

      expect((await current()).stepsOf(installDay).isManual, isFalse);
    });

    test('days before the install day are ignored', () async {
      await repository.saveAutoSteps(installDay - 1, 9000);
      await repository.saveManualSteps(installDay - 1, 1000);

      expect((await current()).days, isEmpty);
    });

    test('negative steps throw ArgumentError', () async {
      await expectLater(
        repository.saveAutoSteps(installDay, -1),
        throwsArgumentError,
      );
      await expectLater(
        repository.saveManualSteps(installDay, -1),
        throwsArgumentError,
      );
    });

    test('addSpending keeps the price and the moment, to the '
        'millisecond, in UTC', () async {
      final medal = MedalBought(
        progressionId: 'story',
        medal: Medal.silver,
        price: 700,
        at: evening,
      );

      await repository.addSpending(chapter('c1', morning), goalAfter: null);
      await repository.addSpending(medal, goalAfter: null);

      final spendings = (await current()).spendings;
      expect(spendings, [chapter('c1', morning), medal]);
      expect(spendings.every((s) => s.at.isUtc), isTrue);
    });

    test('spendings come in the order they were made', () async {
      await repository.addSpending(chapter('c2', evening), goalAfter: null);
      await repository.addSpending(chapter('c1', morning), goalAfter: null);

      expect((await current()).spendings, [
        chapter('c1', morning),
        chapter('c2', evening),
      ]);
    });

    test('addSpending sets the goal it is given, null removes it', () async {
      const next = Goal.chapter(progressionId: 'story', chapterId: 'c2');
      await repository.saveGoal(
        const Goal.chapter(progressionId: 'story', chapterId: 'c1'),
      );

      await repository.addSpending(chapter('c1', morning), goalAfter: next);
      expect((await current()).goal, next);

      await repository.addSpending(chapter('c2', evening), goalAfter: null);
      expect((await current()).goal, isNull);
    });

    test('the same chapter twice throws StateError and changes '
        'nothing', () async {
      await repository.addSpending(chapter('c1', morning), goalAfter: null);
      final before = await current();

      await expectLater(
        repository.addSpending(
          chapter('c1', evening),
          goalAfter: const Goal.chapter(progressionId: 'story', chapterId: 'x'),
        ),
        throwsStateError,
      );
      expect(await current(), before);
    });

    test('the same medal twice throws StateError', () async {
      final medal = MedalBought(
        progressionId: 'story',
        medal: Medal.gold,
        price: 2000,
        at: morning,
      );
      await repository.addSpending(medal, goalAfter: null);

      await expectLater(
        repository.addSpending(medal, goalAfter: null),
        throwsStateError,
      );
    });

    test('saveGoal keeps a chapter, a medal and no goal', () async {
      const chapterGoal = Goal.chapter(progressionId: 'story', chapterId: 'c1');
      const medalGoal = Goal.medal(progressionId: 'trip', medal: Medal.silver);

      await repository.saveGoal(chapterGoal);
      expect((await current()).goal, chapterGoal);
      await repository.saveGoal(medalGoal);
      expect((await current()).goal, medalGoal);
      await repository.saveGoal(null);
      expect((await current()).goal, isNull);
    });

    test('watch emits again after each change', () async {
      final emitted = <Progress>[];
      final subscription = repository.watch().listen(emitted.add);
      await pumpUntil(() => emitted.isNotEmpty);

      await repository.saveAutoSteps(installDay, 1200);
      await pumpUntil(() => emitted.last.totalSteps == 1200);
      await repository.addSpending(chapter('c1', morning), goalAfter: null);
      await pumpUntil(() => emitted.last.spendings.isNotEmpty);

      expect(emitted.first, Progress(installDay: installDay));
      expect(emitted.last.reserve, 200);
      await subscription.cancel();
    });

    test('two writes at once do not undo each other', () async {
      await Future.wait([
        repository.saveAutoSteps(installDay, 5000),
        repository.addSpending(chapter('c1', morning), goalAfter: null),
        repository.saveManualSteps(installDay, 500),
        repository.saveGoal(
          const Goal.chapter(progressionId: 'story', chapterId: 'c2'),
        ),
      ]);

      final progress = await current();
      expect(
        progress.stepsOf(installDay),
        DaySteps(day: installDay, auto: 5000, manual: 500),
      );
      expect(progress.spendings, [chapter('c1', morning)]);
      expect(progress.goal, isNotNull);
    });
  });
}

/// Lets the event queue run until [done] holds; fails after a second.
Future<void> pumpUntil(bool Function() done) async {
  final deadline = DateTime.now().add(const Duration(seconds: 1));
  while (!done()) {
    if (DateTime.now().isAfter(deadline)) fail('condition not met in time');
    await Future<void>.delayed(const Duration(milliseconds: 5));
  }
}
