import 'dart:async';

import 'package:walks/domain/failures/storage_failure.dart';
import 'package:walks/domain/models/day.dart';
import 'package:walks/domain/models/goal.dart';
import 'package:walks/domain/models/progress.dart';
import 'package:walks/domain/models/spending.dart';
import 'package:walks/domain/repositories/progress_repository.dart';

/// A [ProgressRepository] in memory, driven by the test.
class FakeProgressRepository implements ProgressRepository {
  /// Creates a repository that holds [progress].
  FakeProgressRepository(Progress progress) : _progress = progress;

  /// Creates a repository right after the install on [installDay].
  FakeProgressRepository.installedOn(Day installDay)
    : this(Progress(installDay: installDay));

  Progress _progress;
  final StreamController<Progress> _changes = StreamController.broadcast();
  StorageFailure? _failure;
  int _failuresLeft = 0;

  /// The progress held now.
  Progress get progress => _progress;

  /// Makes the next [times] writes throw [failure].
  void failNext(StorageFailure failure, {int times = 1}) {
    _failure = failure;
    _failuresLeft = times;
  }

  /// Sends [failure] to every listener of [watch].
  void failWatch(StorageFailure failure) => _changes.addError(failure);

  /// Closes the streams of [watch].
  Future<void> close() => _changes.close();

  @override
  Stream<Progress> watch() => Stream.multi((listener) {
    // Subscribe before sending the current progress, so no change made in
    // between is lost.
    final subscription = _changes.stream.listen(
      listener.add,
      onError: listener.addError,
      onDone: listener.close,
    );
    listener
      ..onCancel = subscription.cancel
      ..add(_progress);
  });

  @override
  Future<void> saveAutoSteps(Day day, int steps) async {
    _checkSteps(steps);
    _write(_progress.recordAutoSteps(day, steps));
  }

  @override
  Future<void> saveManualSteps(Day day, int steps) async {
    _checkSteps(steps);
    _write(_progress.recordManualSteps(day, steps));
  }

  @override
  Future<void> addSpending(
    Spending spending, {
    required Goal? goalAfter,
  }) async {
    if (_progress.spendings.any((s) => _sameItem(s, spending))) {
      throw StateError('already recorded: $spending');
    }
    _write(
      _progress.copyWith(
        spendings: [..._progress.spendings, spending]
          ..sort((a, b) => a.at.compareTo(b.at)),
        goal: goalAfter,
      ),
    );
  }

  @override
  Future<void> saveGoal(Goal? goal) async =>
      _write(_progress.copyWith(goal: goal));

  void _write(Progress next) {
    final failure = _failure;
    if (failure != null && _failuresLeft > 0) {
      _failuresLeft--;
      throw failure;
    }
    _progress = next;
    _changes.add(next);
  }

  static bool _sameItem(Spending a, Spending b) => switch ((a, b)) {
    (final ChapterOpened x, final ChapterOpened y) =>
      x.progressionId == y.progressionId && x.chapterId == y.chapterId,
    (final MedalBought x, final MedalBought y) =>
      x.progressionId == y.progressionId && x.medal == y.medal,
    _ => false,
  };

  static void _checkSteps(int steps) {
    if (steps < 0) throw ArgumentError.value(steps, 'steps', 'is negative');
  }
}
