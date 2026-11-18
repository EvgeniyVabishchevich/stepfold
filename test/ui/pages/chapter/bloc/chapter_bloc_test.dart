import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:walks/data/repositories/catalog/fake_catalog.dart';
import 'package:walks/data/repositories/crash/fake_crash_reporter.dart';
import 'package:walks/data/repositories/progress/fake_progress_repository.dart';
import 'package:walks/domain/failures/catalog_failure.dart';
import 'package:walks/domain/failures/storage_failure.dart';
import 'package:walks/domain/models/day.dart';
import 'package:walks/domain/models/progress.dart';
import 'package:walks/domain/use_cases/open_chapter.dart';
import 'package:walks/ui/pages/chapter/bloc/chapter_bloc.dart';

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
