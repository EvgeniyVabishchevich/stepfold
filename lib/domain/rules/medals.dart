import 'package:walks/domain/failures/progress_failure.dart';
import 'package:walks/domain/models/goal.dart';
import 'package:walks/domain/models/medal.dart';
import 'package:walks/domain/models/progress.dart';
import 'package:walks/domain/models/progression.dart';
import 'package:walks/domain/models/spending.dart';
import 'package:walks/domain/rules/chapters.dart';

/// The best medal of [progression], or `null` while it is not finished.
///
/// Bronze is not stored: it comes with the last opened chapter.
Medal? medalOf(Progress progress, Progression progression) {
  if (!isFinished(progress, progression)) return null;
  var best = Medal.bronze;
  for (final s in progress.spendings) {
    if (s is MedalBought &&
        s.progressionId == progression.id &&
        s.medal.index > best.index) {
      best = s.medal;
    }
  }
  return best;
}

/// Buys the next medal of the finished [progression] at [now], paying from
/// the reserve.
///
/// Removes the goal if it was this medal. Throws [MedalUnavailable] if the
/// progression is not finished or already has gold, and [NotEnoughSteps]
/// if the reserve is short.
Progress buyNextMedal(
  Progress progress,
  Progression progression, {
  required DateTime now,
}) {
  final next = medalOf(progress, progression)?.next;
  if (next == null) throw MedalUnavailable(progression.id);
  final price = next.price(progression.routePrice);
  if (progress.reserve < price) {
    throw NotEnoughSteps(price: price, reserve: progress.reserve);
  }

  final wasGoal =
      progress.goal == Goal.medal(progressionId: progression.id, medal: next);
  return progress.copyWith(
    spendings: [
      ...progress.spendings,
      Spending.medal(
        progressionId: progression.id,
        medal: next,
        price: price,
        at: now.toUtc(),
      ),
    ],
    goal: wasGoal ? null : progress.goal,
  );
}
