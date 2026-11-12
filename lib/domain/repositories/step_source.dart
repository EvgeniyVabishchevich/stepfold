import 'package:walks/domain/models/app_permission.dart';
import 'package:walks/domain/models/day.dart';
import 'package:walks/domain/models/day_count.dart';

/// Steps counted by the phone: its sensor or the health store.
///
/// Days without data are left out, never filled with zero: "no data" and
/// "0 steps" differ.
///
/// Reading fails with a `StepSourceFailure`.
abstract interface class StepSource {
  /// The permission this source needs. The caller checks it with
  /// `PermissionService` before reading.
  AppPermission get requiredPermission;

  /// The counts of the days from [from] to [to], both included, that have
  /// data, earliest first.
  ///
  /// Throws an [ArgumentError] when [from] is after [to].
  Future<List<DayCount>> stepsByDay(Day from, Day to);

  /// The count of the current day, each time it changes.
  ///
  /// On listen emits the current count at once, when the day has data.
  /// After midnight the counts carry the new day.
  Stream<DayCount> watchToday();
}
