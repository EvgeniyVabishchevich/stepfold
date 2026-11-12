import 'dart:async';

import 'package:walks/domain/failures/step_source_failure.dart';
import 'package:walks/domain/models/app_permission.dart';
import 'package:walks/domain/models/day.dart';
import 'package:walks/domain/models/day_count.dart';
import 'package:walks/domain/repositories/step_source.dart';

/// A [StepSource] in memory, driven by the test or the developer menu.
///
/// "Today" is read from `clock`, so a test moves past midnight with
/// `withClock`.
class FakeStepSource implements StepSource {
  /// Creates a source that has counted [steps] by day.
  FakeStepSource({
    Map<Day, int> steps = const {},
    this.requiredPermission = AppPermission.activityRecognition,
  }) : _steps = {...steps} {
    steps.values.forEach(_checkSteps);
  }

  @override
  final AppPermission requiredPermission;

  final Map<Day, int> _steps;
  final StreamController<DayCount> _updates = StreamController.broadcast();
  StepSourceFailure? _failure;
  int _failuresLeft = 0;

  /// Sets the count of [day], as late data from the source does. When [day]
  /// is today, [watchToday] emits it.
  void setSteps(Day day, int steps) {
    _checkSteps(steps);
    _steps[day] = steps;
    if (day == Day.today()) _updates.add(DayCount(day: day, steps: steps));
  }

  /// Makes the next [times] calls of [stepsByDay] throw [failure].
  void failNext(StepSourceFailure failure, {int times = 1}) {
    _failure = failure;
    _failuresLeft = times;
  }

  /// Sends [failure] to every listener of [watchToday].
  void failWatch(StepSourceFailure failure) => _updates.addError(failure);

  /// Closes the streams of [watchToday].
  Future<void> close() => _updates.close();

  @override
  Future<List<DayCount>> stepsByDay(Day from, Day to) async {
    if (from.isAfter(to)) {
      throw ArgumentError('from ($from) is after to ($to)');
    }
    final failure = _failure;
    if (failure != null && _failuresLeft > 0) {
      _failuresLeft--;
      throw failure;
    }
    final days =
        _steps.keys.where((d) => !d.isBefore(from) && !d.isAfter(to)).toList()
          ..sort();
    return List.unmodifiable([
      for (final day in days) DayCount(day: day, steps: _steps[day]!),
    ]);
  }

  @override
  Stream<DayCount> watchToday() => Stream.multi((listener) {
    // Subscribe before sending the current count, so nothing set in
    // between is lost.
    final subscription = _updates.stream.listen(
      listener.add,
      onError: listener.addError,
      onDone: listener.close,
    );
    listener.onCancel = subscription.cancel;
    final today = Day.today();
    final steps = _steps[today];
    if (steps != null) listener.add(DayCount(day: today, steps: steps));
  });

  static void _checkSteps(int steps) {
    if (steps < 0) throw ArgumentError.value(steps, 'steps', 'is negative');
  }
}
