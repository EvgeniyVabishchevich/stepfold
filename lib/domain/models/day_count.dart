import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:walks/domain/models/day.dart';

part 'day_count.freezed.dart';

/// The steps the step source counted on one [day].
///
/// Each count carries its day, so after midnight it is clear which day a
/// number belongs to. Steps added by hand are not here: see `DaySteps`.
@freezed
abstract class DayCount with _$DayCount {
  /// Creates the count of [steps] on [day].
  const factory DayCount({required Day day, required int steps}) = _DayCount;
}
