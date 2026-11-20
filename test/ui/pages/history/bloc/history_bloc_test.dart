import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:walks/data/repositories/repositories.dart';
import 'package:walks/domain/domain.dart';
import 'package:walks/ui/pages/history/bloc/history_bloc.dart';
import 'package:walks/ui/pages/history/bloc/history_state.dart';

void main() {
  late Day today;
  late FakeProgressRepository repository;
  late FakeCrashReporter reporter;

  setUp(() {
    today = Day.today();
    repository = FakeProgressRepository.installedOn(today - 10);
    reporter = FakeCrashReporter();
  });
  tearDown(() => repository.close());

  HistoryBloc create() => HistoryBloc(
    progress: repository,
    catalog: FakeCatalog(),
    addManualSteps: AddManualSteps(repository),
    updateLock: UpdateManualEntryLock(repository),
    crashReporter: reporter,
  );

  Future<void> watch(HistoryBloc bloc) async {
    final ready = bloc.stream.firstWhere((state) => state.progress != null);
    bloc.add(const WatchHistory());
    await ready;
  }

  for (final failure in <StorageFailure>[
    const StorageFull(),
    StorageUnavailable(StateError('database unavailable')),
  ]) {
    blocTest<HistoryBloc, HistoryState>(
      'can retry the history subscription after $failure',
      build: create,
      act: (bloc) async {
        await watch(bloc);
        final failed = bloc.stream.firstWhere((s) => s.readFailure != null);
        repository.failWatch(failure);
        expect((await failed).readFailure, failure);
        await watch(bloc);
      },
      verify: (_) => expect(
        reporter.errors,
        hasLength(failure is StorageUnavailable ? 1 : 0),
      ),
    );

    blocTest<HistoryBloc, HistoryState>(
      'can retry a write after $failure',
      build: create,
      act: (bloc) async {
        final edit = SaveHistoryEdit((day: today, steps: 1200));
        repository.failNext(failure);
        final failed = bloc.stream.firstWhere((s) => s.writeFailure != null);
        bloc.add(edit);
        expect((await failed).writeFailure, failure);
        expect(repository.progress.stepsOf(today).isManual, isFalse);
        await watch(bloc);
        final saved = bloc.stream.firstWhere(
          (s) => s.progress?.stepsOf(today).manual == 1200,
        );
        bloc.add(edit);
        await saved;
      },
      verify: (_) => expect(
        reporter.errors,
        hasLength(failure is StorageUnavailable ? 1 : 0),
      ),
    );
  }

  for (final (error, day, steps) in [
    (const ManualEntryLocked(), 0, 1500),
    (const ManualEntryDayOutOfRange(), -8, 1500),
    (const ManualEntryNegative(), 0, -1),
  ]) {
    blocTest<HistoryBloc, HistoryState>(
      'refuses a manual entry when it gives $error',
      build: create,
      act: (bloc) async {
        if (error is ManualEntryLocked) {
          await UpdateManualEntryLock(repository)(locked: true);
        }
        final failed = bloc.stream.firstWhere((s) => s.writeFailure != null);
        bloc.add(SaveHistoryEdit((day: today + day, steps: steps)));
        expect((await failed).writeFailure.runtimeType, error.runtimeType);
      },
      verify: (_) => expect(repository.progress.days, isEmpty),
    );
  }
}
