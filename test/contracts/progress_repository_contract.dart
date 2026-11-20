import 'package:flutter_test/flutter_test.dart';
import 'package:walks/domain/domain.dart';

import '../domain/fixtures.dart' show free, strict;

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

    Future<void> recordSpending(
      Spending spending, {
      required Goal? goalAfter,
    }) => repository.addSpending(
      (_) => (spending: spending, goalAfter: goalAfter),
    );

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

    test('a fallback cannot take over a day owned by another source', () async {
      const health = AutoStepOrigin.healthStore;
      const sensor = AutoStepOrigin.deviceSensor;
      await repository.saveAutoSteps(installDay, 8000, origin: health);
      await repository.saveManualSteps(installDay, 500);
      await repository.saveAutoSteps(installDay, 9000, origin: sensor);
      expect((await current()).stepsOf(installDay).counted, 8500);
      await repository.saveAutoSteps(installDay + 1, 1200, origin: sensor);
      await repository.saveAutoSteps(installDay, 7500, origin: health);

      final progress = await current();
      expect(
        progress.stepsOf(installDay),
        DaySteps(day: installDay, auto: 7500, manual: 500, autoOrigin: health),
      );
      expect(
        progress.stepsOf(installDay + 1),
        DaySteps(day: installDay + 1, auto: 1200, autoOrigin: sensor),
      );
    });

    test(
      'a legacy total is attributed without losing credited steps',
      () async {
        const sensor = AutoStepOrigin.deviceSensor;
        await repository.saveAutoSteps(installDay, 8000);
        await repository.saveAutoSteps(installDay, 2000, origin: sensor);
        expect((await current()).stepsOf(installDay).auto, 8000);
        expect((await current()).stepsOf(installDay).autoOrigin, isNull);

        await repository.saveAutoSteps(installDay, 8000, origin: sensor);
        expect((await current()).stepsOf(installDay).autoOrigin, sensor);
      },
    );

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

      await recordSpending(chapter('c1', morning), goalAfter: null);
      await recordSpending(medal, goalAfter: null);

      final spendings = (await current()).spendings;
      expect(spendings, [chapter('c1', morning), medal]);
      expect(spendings.every((s) => s.at.isUtc), isTrue);
    });

    test('spendings come in the order they were made', () async {
      await recordSpending(chapter('c2', evening), goalAfter: null);
      await recordSpending(chapter('c1', morning), goalAfter: null);

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

      await recordSpending(chapter('c1', morning), goalAfter: next);
      expect((await current()).goal, next);

      await recordSpending(chapter('c2', evening), goalAfter: null);
      expect((await current()).goal, isNull);
    });

    test('the same chapter twice throws StateError and changes '
        'nothing', () async {
      await recordSpending(chapter('c1', morning), goalAfter: null);
      final before = await current();

      await expectLater(
        recordSpending(
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
      await recordSpending(medal, goalAfter: null);

      await expectLater(
        recordSpending(medal, goalAfter: null),
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
      await recordSpending(chapter('c1', morning), goalAfter: null);
      await pumpUntil(() => emitted.last.spendings.isNotEmpty);

      expect(emitted.first, Progress(installDay: installDay));
      expect(emitted.last.reserve, 200);
      await subscription.cancel();
    });

    test(
      'concurrent chapter and medal purchases use the same reserve',
      () async {
        final open = OpenChapter(repository);
        final buy = BuyMedal(repository);
        await repository.saveAutoSteps(installDay, 4000);
        await open(free, 't1');
        await open(free, 't2');

        Future<Object?> outcome(Future<void> spending) => spending
            .then<Object?>((_) => null, onError: (Object error) => error);

        final results = await Future.wait([
          outcome(open(strict, 'c1')),
          outcome(buy(free)),
        ]);

        expect(results, unorderedEquals([null, isA<NotEnoughSteps>()]));
        final progress = await current();
        expect(progress.spendings, hasLength(3));
        expect(progress.reserve, anyOf(0, 700));
      },
    );

    test('two writes at once do not undo each other', () async {
      await Future.wait([
        repository.saveAutoSteps(installDay, 5000),
        recordSpending(chapter('c1', morning), goalAfter: null),
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
