import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:walks/data/repositories/repositories.dart';
import 'package:walks/domain/domain.dart';
import 'package:walks/ui/pages/chapter/bloc/bloc.dart';

class _Progress extends FakeProgressRepository {
  _Progress(super.installDay) : super.installedOn();

  StorageFailure? failure;

  @override
  Stream<Progress> watch() => switch (failure) {
    final StorageFailure failure => Stream.error(failure),
    null => super.watch(),
  };
}

void main() {
  late _Progress progress;
  late FakeCatalog catalog;
  late FakeCrashReporter reporter;

  setUp(() async {
    final day = Day.today();
    progress = _Progress(day);
    catalog = FakeCatalog();
    reporter = FakeCrashReporter();
    final progression = (await catalog.index('ru')).progressions.single;
    await progress.saveAutoSteps(day, 2000);
    await OpenChapter(progress)(progression, 'c1');
  });
  tearDown(() => progress.close());

  ChapterBloc create() => ChapterBloc(
    catalog: catalog,
    progress: progress,
    crashReporter: reporter,
  );

  Future<ChapterState> load(ChapterBloc bloc) {
    final result = bloc.stream.firstWhere((state) => !state.loading);
    bloc.add(const LoadChapter('sample', 'c1', 'ru'));
    return result;
  }

  blocTest<ChapterBloc, ChapterState>(
    'the open reader follows the reserve and the active journey goal',
    build: () {
      const start = (latitude: 56.0, longitude: 38.0);
      const end = (latitude: 57.0, longitude: 39.0);
      const route = Progression(
        id: 'journey',
        kind: 'journey',
        order: ChapterOrder.strict,
        chapters: [
          Chapter(id: 'start', price: 2000),
          Chapter(id: 'next', price: 6000),
        ],
        journeyLegs: [
          [start, end],
        ],
      );
      catalog = FakeCatalog(
        indexes: {
          'ru': const CatalogIndex(
            kinds: [],
            lengthGroups: [],
            progressions: [route],
          ),
        },
        contents: {
          'ru': const [
            ChapterContent(
              progressionId: 'journey',
              chapterId: 'start',
              blocks: [],
            ),
          ],
        },
      );
      return create();
    },
    act: (bloc) async {
      final route = (await catalog.index('ru')).progressions.single;
      final day = progress.progress.installDay;
      await progress.saveGoal(
        const Goal.chapter(progressionId: 'journey', chapterId: 'start'),
      );
      await progress.saveAutoSteps(day, 8000);
      await OpenChapter(progress)(route, 'start');

      final ready = bloc.stream.firstWhere((state) => !state.loading);
      bloc.add(const LoadChapter('journey', 'start', 'ru'));
      expect((await ready).journey?.position, (
        reachedStop: 0,
        previewSteps: 5000,
      ));

      final enough = bloc.stream.firstWhere(
        (state) => state.journey?.position.previewSteps == 6000,
      );
      await progress.saveAutoSteps(day, 12000);
      expect((await enough).journey?.position.reachedStop, 0);

      final debt = bloc.stream.firstWhere(
        (state) => state.journey?.position.previewSteps == 0,
      );
      await progress.saveAutoSteps(day, 1000);
      await debt;

      final goalCleared = bloc.stream.firstWhere(
        (state) => state.journey?.position.previewSteps == null,
      );
      await progress.saveGoal(
        const Goal.chapter(progressionId: 'sample', chapterId: 'c2'),
      );
      expect((await goalCleared).journey?.position.reachedStop, 0);

      const failed = JourneyTilesChanged('journey', unavailable: true);
      final unavailable = bloc.stream.firstWhere(
        (state) => state.journeyTilesUnavailable,
      );
      bloc.add(failed);
      expect((await unavailable).content, isNotNull);
      final recovered = bloc.stream.firstWhere(
        (state) => !state.journeyTilesUnavailable,
      );
      bloc.add(const JourneyTilesChanged('journey', unavailable: false));
      await recovered;

      final finished = bloc.stream.firstWhere(
        (state) => state.journey?.position.reachedStop == 1,
      );
      await progress.saveAutoSteps(day, 9000);
      await OpenChapter(progress)(route, 'next');
      expect((await finished).journey?.position.previewSteps, isNull);

      progress
        ..failWatch(StorageUnavailable(StateError('journey watch')))
        ..failWatch(const StorageFull());
    },
    verify: (bloc) {
      expect(bloc.state.content, isNotNull);
      expect(bloc.state.journey?.position.reachedStop, 1);
      expect(reporter.errors, hasLength(1));
    },
  );

  blocTest<ChapterBloc, ChapterState>(
    'retrying catalog content does not charge again',
    build: create,
    act: (bloc) async {
      catalog.failNext(const CatalogUnavailable());
      await load(bloc);
      expect(bloc.state.retryable, isTrue);
      await load(bloc);
    },
    verify: (bloc) {
      expect(bloc.state.content?.blocks, isNotEmpty);
      expect(progress.progress.reserve, 1000);
    },
  );

  blocTest<ChapterBloc, ChapterState>(
    'a missing chapter is unavailable',
    build: create,
    act: (bloc) {
      catalog.failNext(const ChapterNotFound('sample', 'c1'));
      return load(bloc);
    },
    verify: (bloc) => expect(bloc.state.unavailable, isTrue),
  );

  for (final failure in <StorageFailure>[
    const StorageFull(),
    StorageUnavailable(StateError('test storage error')),
  ]) {
    blocTest<ChapterBloc, ChapterState>(
      'storage error is retryable: $failure',
      build: create,
      act: (bloc) {
        progress.failure = failure;
        return load(bloc);
      },
      verify: (bloc) {
        expect(bloc.state.retryable, isTrue);
        expect(bloc.state.storageFull, failure is StorageFull);
        expect(
          reporter.errors,
          hasLength(failure is StorageUnavailable ? 1 : 0),
        );
        expect(bloc.state.content, isNull);
      },
    );
  }
}
