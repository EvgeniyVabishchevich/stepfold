import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:walks/domain/models/day.dart';

part 'day_steps.freezed.dart';

/// Steps a day needs to count for the streak.
const streakDayThreshold = 1000;

/// Where an automatic daily total came from.
enum AutoStepOrigin {
  /// A system health data store.
  healthStore,

  /// The phone's hardware step counter.
  deviceSensor,
}

/// Steps of one day: from the phone's step source plus steps added by hand.
///
/// [manual] is an addition, not a day total: steps walked without the phone.
@freezed
abstract class DaySteps with _$DaySteps {
  /// Creates the steps of [day].
  const factory DaySteps({
    required Day day,
    int? auto,
    int? manual,
    AutoStepOrigin? autoOrigin,
  }) = _DaySteps;

  const DaySteps._();

  /// Whether [origin] can update the automatic total with [steps].
  ///
  /// Once a source has supplied the total, only it can correct that day.
  /// A legacy total with unknown origin can adopt a source without losing
  /// steps already credited.
  bool acceptsAutoTotal(int steps, AutoStepOrigin? origin) {
    if (autoOrigin != null) return autoOrigin == origin;
    return origin == null || steps >= (auto ?? 0);
  }

  /// The steps that count: [auto] plus [manual].
  ///
  /// A sum, not the larger of the two: steps added by hand are never lost
  /// when late data comes from the step source. If they were the same
  /// steps, the user sees the addition in the history and removes it.
  int get counted => (auto ?? 0) + (manual ?? 0);

  /// Whether steps were added by hand.
  bool get isManual => (manual ?? 0) > 0;

  /// Whether the day counts for the streak.
  bool get countsForStreak => counted >= streakDayThreshold;
}
