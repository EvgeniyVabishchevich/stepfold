import 'dart:async';

import 'package:walks/domain/models/day.dart';
import 'package:walks/domain/models/day_count.dart';
import 'package:walks/domain/repositories/progress_repository.dart';
import 'package:walks/domain/repositories/step_source.dart';

/// How many days back are read again on each catch-up: the health store
/// may correct them late, after a watch syncs.
const stepsRecheckDays = 7;

/// Copies the steps from the phone's step source into the progress.
///
/// Screens read steps only from the progress; this is the only way steps
/// of the source get there. The caller checks the permission of the
/// source before using it.
class SyncSteps {
  /// Creates the use case. Steps of today are written at most once per
  /// [writeInterval].
  SyncSteps({
    required this._progress,
    required this._source,
    this.writeInterval = const Duration(seconds: 5),
  });

  final ProgressRepository _progress;
  final StepSource _source;

  /// The shortest time between two writes of today's steps.
  final Duration writeInterval;

  /// Reads the days the progress may lack and saves them.
  ///
  /// Starts at the earlier of the last day with steps from the source and
  /// [stepsRecheckDays] days ago, never before the install day. Days the
  /// source has no data for keep what is saved.
  ///
  /// Throws a `StepSourceFailure` or a `StorageFailure`.
  Future<void> catchUp() async {
    final progress = await _progress.watch().first;
    final today = Day.today();
    final lastAuto = progress.days.values
        .where((d) => d.auto != null)
        .map((d) => d.day)
        .fold<Day?>(
          null,
          (last, d) => last == null || d.isAfter(last) ? d : last,
        );
    var from = today - stepsRecheckDays;
    if (lastAuto != null && lastAuto.isBefore(from)) from = lastAuto;
    if (from.isBefore(progress.installDay)) from = progress.installDay;
    if (from.isAfter(today)) return;
    for (final count in await _source.stepsByDay(from, today)) {
      await _progress.saveAutoSteps(count.day, count.steps);
    }
  }

  /// Follows the count of today and saves it while listened to.
  ///
  /// The first count is saved at once; later ones at most once per
  /// [writeInterval], the latest of them. A count of a new day saves the
  /// pending count of the old day first. Cancelling saves the pending
  /// count. Emits each count after it is saved; errors of the source and
  /// the storage come through the stream.
  Stream<DayCount> followToday() {
    late StreamController<DayCount> controller;
    StreamSubscription<DayCount>? subscription;
    Timer? timer;
    DayCount? pending;
    DayCount? saved;
    var writing = Future<void>.value();

    Future<void> save(DayCount count) {
      // Writes go one after another, so an older count never lands last.
      return writing = writing.then((_) async {
        if (count == saved) return;
        try {
          await _progress.saveAutoSteps(count.day, count.steps);
          saved = count;
          if (!controller.isClosed) controller.add(count);
        } on Object catch (error, stackTrace) {
          if (!controller.isClosed) controller.addError(error, stackTrace);
        }
      });
    }

    void flush() {
      timer?.cancel();
      timer = null;
      final count = pending;
      pending = null;
      if (count != null) unawaited(save(count));
    }

    void onCount(DayCount count) {
      final waiting = pending;
      if (waiting != null && waiting.day != count.day) flush();
      if (timer == null) {
        unawaited(save(count));
        timer = Timer(writeInterval, flush);
      } else {
        pending = count;
      }
    }

    controller = StreamController<DayCount>(
      onListen: () {
        subscription = _source.watchToday().listen(
          onCount,
          onError: controller.addError,
          onDone: () async {
            flush();
            await writing;
            await controller.close();
          },
        );
      },
      onCancel: () async {
        // Save first: waiting for the source to cancel must not delay it.
        flush();
        await subscription?.cancel();
        await writing;
      },
    );
    return controller.stream;
  }
}
