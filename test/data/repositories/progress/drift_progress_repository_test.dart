import 'dart:io';

import 'package:drift/isolate.dart' show DriftRemoteException;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:walks/data/repositories/progress/progress.dart';
import 'package:walks/domain/domain.dart';

import '../../../contracts/progress_repository_contract.dart';

void main() {
  progressRepositoryContract(
    (installDay) => DriftProgressRepository.memory(installDay: installDay),
    dispose: (r) => (r as DriftProgressRepository).close(),
  );

  group('DriftProgressRepository on a file', () {
    final installDay = Day(2026, 11, 1);
    late Directory dir;
    late File file;

    setUp(() {
      dir = Directory.systemTemp.createTempSync('progress_test');
      file = File('${dir.path}/progress.sqlite');
    });
    tearDown(() => dir.deleteSync(recursive: true));

    DriftProgressRepository open({
      Day? installedOn,
      bool inBackground = false,
    }) => DriftProgressRepository(
      ProgressDatabase(
        inBackground
            ? NativeDatabase.createInBackground(file)
            : NativeDatabase(file),
        installDay: () => installedOn ?? installDay,
      ),
    );

    test('progress survives a restart, the install day is kept', () async {
      final first = open();
      await first.saveAutoSteps(installDay + 3, 6000);
      await first.close();

      // A later "today" must not become the install day.
      final second = open(installedOn: installDay + 10);
      final progress = await second.watch().first;
      await second.close();

      expect(progress.installDay, installDay);
      expect(progress.stepsOf(installDay + 3).auto, 6000);
    });

    test('in a background isolate a broken constraint is still a '
        'StateError', () async {
      final repository = open(inBackground: true);
      final spending = ChapterOpened(
        progressionId: 'story',
        chapterId: 'c1',
        price: 1000,
        at: DateTime.utc(2026, 11, 12),
      );
      await repository.addSpending(
        (_) => (spending: spending, goalAfter: null),
      );

      await expectLater(
        repository.addSpending((_) => (spending: spending, goalAfter: null)),
        throwsStateError,
      );
      await repository.close();
    });

    test('a file that is not a database gives StorageUnavailable', () async {
      file.writeAsStringSync('not a database, just text ' * 100);
      final repository = open();

      await expectLater(
        repository.watch().first,
        throwsA(isA<StorageUnavailable>()),
      );
      await expectLater(
        repository.saveGoal(null),
        throwsA(isA<StorageUnavailable>()),
      );
      await repository.close();
    });

    test('so does the same file in a background isolate', () async {
      file.writeAsStringSync('not a database, just text ' * 100);
      final repository = open(inBackground: true);

      await expectLater(
        repository.saveGoal(null),
        throwsA(
          isA<StorageUnavailable>().having(
            (f) => f.cause,
            'cause',
            isNot(isA<DriftRemoteException>()),
          ),
        ),
      );
      await repository.close();
    });
  });
}
