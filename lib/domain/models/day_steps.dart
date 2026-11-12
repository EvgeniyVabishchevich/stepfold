import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:walks/domain/models/day.dart';

part 'day_steps.freezed.dart';

/// Steps a day needs to count for the streak.
const streakDayThreshold = 1000;

/// Steps of one day: from the phone's step source plus steps added by hand.
///
/// [manual] is an addition, not a day total: steps walked without the phone.
@freezed
abstract class DaySteps with _$DaySteps {
  /// Creates the steps of [day].
  const factory DaySteps({required Day day, int? auto, int? manual}) =
      _DaySteps;

  const DaySteps._();

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
