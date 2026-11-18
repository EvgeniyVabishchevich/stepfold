import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:walks/data/repositories/catalog/fake_catalog.dart';
import 'package:walks/data/repositories/crash/fake_crash_reporter.dart';
import 'package:walks/data/repositories/progress/fake_progress_repository.dart';
import 'package:walks/domain/failures/catalog_failure.dart';
import 'package:walks/domain/failures/progress_failure.dart';
import 'package:walks/domain/failures/storage_failure.dart';
import 'package:walks/domain/models/day.dart';
import 'package:walks/domain/models/goal.dart';
import 'package:walks/domain/models/progress.dart';
import 'package:walks/domain/models/spending.dart';
import 'package:walks/domain/use_cases/buy_medal.dart';
import 'package:walks/domain/use_cases/open_chapter.dart';
import 'package:walks/ui/pages/today/bloc/today_bloc.dart';

class _Progress extends FakeProgressRepository {
  _Progress(super.installDay) : super.installedOn();

  ProgressFailure? refusal;

  @override
  Future<void> addSpending(
    ({Spending spending, Goal? goalAfter}) Function(Progress) decide,
  ) async {
    if (refusal case final failure?) throw failure;
    await super.addSpending(decide);
  }
}

void main() {
  const goal = Goal.chapter(progressionId: 'sample', chapterId: 'c1');
  final day = Day.today();
  late _Progress repository;
  late FakeCatalog catalog;
  late FakeCrashReporter reporter;

  setUp(() async {
    repository = _Progress(day);
    await repository.saveAutoSteps(day, 1200);
    await repository.saveGoal(goal);
    catalog = FakeCatalog();
    reporter = FakeCrashReporter();
  });
  tearDown(() => repository.close());

  TodayBloc create() => TodayBloc(
    progress: repository,
    catalog: catalog,
    openChapter: OpenChapter(repository),
    buyMedal: BuyMedal(repository),
    crashReporter: reporter,
  );

  Future<void> load(TodayBloc bloc) async {
    final ready = bloc.stream.firstWhere((s) => s.target != null);
    bloc.add(const LoadToday('ru'));
    await ready;
  }

  blocTest<TodayBloc, TodayState>(
    'a second tap does not open the chapter twice',
    build: create,
    act: (bloc) async {
      await load(bloc);
      final updated = bloc.stream.firstWhere(
        (s) => s.openedChapter == goal && s.spendingGoal == null,
      );
      bloc
        ..add(const SpendOnTodayGoal(goal))
        ..add(const SpendOnTodayGoal(goal));
      await updated;
    },
    verify: (bloc) {
      expect(repository.progress.spendings, hasLength(1));
      expect(repository.progress.reserve, 200);
      expect((bloc.state.target?.goal as ChapterGoal?)?.chapterId, 'c2');
    },
  );

  for (final failure in <ProgressFailure>[
    const NotEnoughSteps(price: 1000, reserve: 600),
    const ChapterUnavailable('c1'),
    const MedalUnavailable('sample'),
  ]) {
    blocTest<TodayBloc, TodayState>(
      'a refused spend clears the loading state: $failure',
      build: create,
      act: (bloc) async {
        await load(bloc);
        repository.refusal = failure;
        final rejected = bloc.stream.firstWhere(
          (s) => s.spendingFailure != null,
        );
        bloc.add(const SpendOnTodayGoal(goal));
        await rejected;
      },
      verify: (bloc) {
        expect(bloc.state.spendingGoal, isNull);
        expect(bloc.state.spendingFailure, same(failure));
        expect(repository.progress.spendings, isEmpty);
      },
    );
  }

  for (final failure in <StorageFailure>[
    const StorageFull(),
    StorageUnavailable(StateError('test database error')),
  ]) {
    blocTest<TodayBloc, TodayState>(
      'an unsuccessful storage write can be retried: $failure',
      build: create,
      act: (bloc) async {
        await load(bloc);
        repository.failNext(failure);
        final rejected = bloc.stream.firstWhere(
          (s) => s.spendingStorageFailure != null,
        );
        bloc.add(const SpendOnTodayGoal(goal));
        await rejected;
      },
      verify: (bloc) {
        expect(bloc.state.spendingGoal, isNull);
        expect(bloc.state.spendingStorageFailure, same(failure));
        expect(repository.progress.spendings, isEmpty);
        expect(
          reporter.errors,
          hasLength(failure is StorageUnavailable ? 1 : 0),
        );
      },
    );

    blocTest<TodayBloc, TodayState>(
      'a progress stream failure is shown and reported: $failure',
      build: create,
      act: (bloc) async {
        await load(bloc);
        final failed = bloc.stream.firstWhere((s) => s.progressFailure != null);
        repository.failWatch(failure);
        await failed;
      },
      verify: (bloc) {
        expect(bloc.state.progressFailure, same(failure));
        expect(
          reporter.errors,
          hasLength(failure is StorageUnavailable ? 1 : 0),
        );
      },
    );
  }

  blocTest<TodayBloc, TodayState>(
    'catalog failure leaves steps visible and reloads the goal',
    build: create,
    act: (bloc) async {
      catalog.failNext(const CatalogUnavailable());
      final failed = bloc.stream.firstWhere(
        (s) => s.catalogFailure != null && s.progress != null,
      );
      bloc.add(const LoadToday('ru'));
      expect((await failed).progress?.reserve, 1200);
      final recovered = bloc.stream.firstWhere((s) => s.target != null);
      bloc.add(const RetryTodayCatalog());
      await recovered;
    },
    verify: (bloc) => expect(bloc.state.target?.goal, goal),
  );
}
