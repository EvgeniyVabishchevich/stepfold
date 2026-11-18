import 'package:flutter_test/flutter_test.dart';
import 'package:walks/data/repositories/progress/progress.dart';
import 'package:walks/domain/domain.dart';

import '../../../contracts/progress_repository_contract.dart';

void main() {
  progressRepositoryContract(
    FakeProgressRepository.installedOn,
    dispose: (r) => (r as FakeProgressRepository).close(),
  );

  group('FakeProgressRepository', () {
    final installDay = Day(2026, 11, 1);
    late FakeProgressRepository repository;

    setUp(() => repository = FakeProgressRepository.installedOn(installDay));
    tearDown(() => repository.close());

    test('failNext makes the next writes throw, then they work', () async {
      repository.failNext(const StorageFull(), times: 2);

      await expectLater(
        repository.saveAutoSteps(installDay, 100),
        throwsA(isA<StorageFull>()),
      );
      await expectLater(repository.saveGoal(null), throwsA(isA<StorageFull>()));
      await repository.saveAutoSteps(installDay, 100);

      expect(repository.progress.totalSteps, 100);
    });

    test('a failed write changes nothing', () async {
      repository.failNext(const StorageFull());

      await expectLater(
        repository.saveAutoSteps(installDay, 100),
        throwsA(isA<StorageFull>()),
      );

      expect(repository.progress.days, isEmpty);
    });

    test('failWatch sends the failure to listeners', () {
      final stream = repository.watch();
      final expectation = expectLater(
        stream,
        emitsInOrder([anything, emitsError(isA<StorageUnavailable>())]),
      );

      Future<void>.delayed(
        Duration.zero,
        () => repository.failWatch(StorageUnavailable(Exception('disk'))),
      );
      return expectation;
    });
  });
}
