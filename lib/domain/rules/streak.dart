import 'package:walks/domain/models/day.dart';
import 'package:walks/domain/models/progress.dart';

/// Days in a row, up to [today], that reached `streakDayThreshold`.
///
/// Today does not break the streak while it is still under the threshold:
/// the count then starts from yesterday.
int streak(Progress progress, Day today) {
  var day = progress.stepsOf(today).countsForStreak ? today : today - 1;
  var count = 0;
  while (!day.isBefore(progress.installDay) &&
      progress.stepsOf(day).countsForStreak) {
    count++;
    day = day - 1;
  }
  return count;
}
