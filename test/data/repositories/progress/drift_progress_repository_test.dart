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

  test(
    'developer seed opens a separate history of one thousand days',
    () async {
      final today = Day(2026, 11, 20);
      final first = today - 999;
      final demo = DriftProgressRepository.memory(
        installDay: first,
        initialDays: [
          for (var i = 0; i < 1000; i++)
            DayCount(day: first + i, steps: 1500 + i),
        ],
      );
      addTearDown(demo.close);
      final normal = DriftProgressRepository.memory(installDay: today);
      addTearDown(normal.close);

      final preview = await demo.watch().first;
      expect(preview.days, hasLength(1000));
      expect(preview.stepsOf(today).auto, 2499);
      expect((await normal.watch().first).days, isEmpty);
    },
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
      final unlockAt = DateTime.utc(2026, 11, 4, 21, 5, 13, 420);
      await first.saveAutoSteps(
        installDay + 3,
        6000,
        origin: AutoStepOrigin.deviceSensor,
      );
      await first.updateManualEntryLock(
        (_) => ManualEntryLock(locked: true, unlockAt: unlockAt),
      );
      await first.close();

      // A later "today" must not become the install day.
      final second = open(installedOn: installDay + 10);
      final progress = await second.watch().first;
      await second.close();

      expect(progress.installDay, installDay);
      expect(progress.stepsOf(installDay + 3).auto, 6000);
      expect(
        progress.stepsOf(installDay + 3).autoOrigin,
        AutoStepOrigin.deviceSensor,
      );
      expect(
        progress.manualEntryLock,
        ManualEntryLock(locked: true, unlockAt: unlockAt),
      );
      expect(progress.manualEntryLock.unlockAt?.isUtc, isTrue);
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
