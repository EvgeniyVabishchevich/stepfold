import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:walks/data/repositories/repositories.dart';
import 'package:walks/domain/domain.dart';
import 'package:walks/ui/pages/catalog/bloc/catalog_bloc.dart';
import 'package:walks/ui/pages/catalog/bloc/catalog_state.dart';

void main() {
  late FakeCatalog catalog;
  late FakeProgressRepository repository;
  late FakeCrashReporter reporter;

  const first = ChapterGoal(progressionId: 'sample', chapterId: 'c1');
  const locked = ChapterGoal(progressionId: 'sample', chapterId: 'c2');

  setUp(() {
    catalog = FakeCatalog();
    repository = FakeProgressRepository.installedOn(Day.today());
    reporter = FakeCrashReporter();
  });

  tearDown(() => repository.close());

  CatalogBloc create() => CatalogBloc(
    catalog: catalog,
    progress: repository,
    setGoal: SetGoal(repository),
    crashReporter: reporter,
  );

  Future<void> start(CatalogBloc bloc) async {
    final ready = bloc.stream.firstWhere(
      (state) => state.index != null && state.progress != null,
    );
    bloc
      ..add(const LoadCatalog('ru'))
      ..add(const WatchCatalogProgress());
    await ready;
  }

  blocTest<CatalogBloc, CatalogState>(
    'catalog load failure can be retried',
    build: create,
    act: (bloc) async {
      catalog.failNext(const CatalogUnavailable());
      final failed = bloc.stream.firstWhere((s) => s.catalogFailure != null);
      bloc.add(const LoadCatalog('ru'));
      expect((await failed).catalogFailure, isA<CatalogUnavailable>());
      await start(bloc);
    },
    verify: (bloc) => expect(bloc.state.visibleProgressions, hasLength(1)),
  );

  blocTest<CatalogBloc, CatalogState>(
    'a locked chapter cannot replace the current goal',
    build: create,
    act: (bloc) async {
      await repository.saveGoal(first);
      await start(bloc);
      final failed = bloc.stream.firstWhere((s) => s.chapterUnavailable);
      bloc.add(const ChooseCatalogGoal(locked));
      await failed;
    },
    verify: (bloc) => expect(repository.progress.goal, first),
  );

  for (final failure in <StorageFailure>[
    const StorageFull(),
    StorageUnavailable(StateError('storage unavailable')),
  ]) {
    blocTest<CatalogBloc, CatalogState>(
      'progress read can be retried after $failure',
      build: create,
      act: (bloc) async {
        await start(bloc);
        final failed = bloc.stream.firstWhere((s) => s.readFailure != null);
        repository.failWatch(failure);
        expect((await failed).readFailure, failure);
        final ready = bloc.stream.firstWhere((s) => s.progress != null);
        bloc.add(const WatchCatalogProgress());
        await ready;
      },
      verify: (_) => expect(
        reporter.errors,
        hasLength(failure is StorageUnavailable ? 1 : 0),
      ),
    );

    blocTest<CatalogBloc, CatalogState>(
      'goal save can be retried after $failure',
      build: create,
      act: (bloc) async {
        await start(bloc);
        repository.failNext(failure);
        final failed = bloc.stream.firstWhere((s) => s.saveFailure != null);
        bloc.add(const ChooseCatalogGoal(first));
        expect((await failed).saveFailure, failure);
        expect(repository.progress.goal, isNull);
        final selected = bloc.stream.firstWhere(
          (s) => s.progress?.goal == first && !s.saving,
        );
        bloc.add(const ChooseCatalogGoal(first));
        await selected;
      },
      verify: (bloc) {
        expect(repository.progress.spendings, isEmpty);
        expect(bloc.state.saveFailure, isNull);
        expect(
          reporter.errors,
          hasLength(failure is StorageUnavailable ? 1 : 0),
        );
      },
    );
  }

  blocTest<CatalogBloc, CatalogState>(
    'a hidden progression appears after its first chapter is opened',
    build: () {
      const progression = Progression(
        id: 'sample',
        kind: 'story',
        hidden: true,
        order: ChapterOrder.free,
        chapters: [
          Chapter(id: 'c1', price: 1000),
          Chapter(id: 'c2', price: 500),
        ],
      );
      catalog = FakeCatalog(
        indexes: const {
          'ru': CatalogIndex(
            kinds: [],
            lengthGroups: [],
            progressions: [progression],
          ),
        },
      );
      return create();
    },
    act: (bloc) async {
      await start(bloc);
      expect(bloc.state.visibleProgressions, isEmpty);
      final visible = bloc.stream.firstWhere(
        (s) => s.visibleProgressions.isNotEmpty,
      );
      await repository.saveAutoSteps(Day.today(), 1000);
      await OpenChapter(repository)(
        bloc.state.index!.progressions.single,
        'c1',
      );
      await visible;
      final selected = bloc.stream.firstWhere(
        (s) => s.progress?.goal == locked && !s.saving,
      );
      bloc.add(const ChooseCatalogGoal(locked));
      await selected;
    },
    verify: (bloc) => expect(bloc.state.visibleProgressions, hasLength(1)),
  );
}
