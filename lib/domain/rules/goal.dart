import 'dart:math';

import 'package:walks/domain/failures/progress_failure.dart';
import 'package:walks/domain/models/goal.dart';
import 'package:walks/domain/models/progress.dart';
import 'package:walks/domain/models/progression.dart';
import 'package:walks/domain/rules/chapters.dart';
import 'package:walks/domain/rules/medals.dart';

/// The price of [goal], which belongs to [progression].
int priceOf(Goal goal, Progression progression) => switch (goal) {
  ChapterGoal(:final chapterId) =>
    progression.chapterById(chapterId)?.price ?? 0,
  MedalGoal(:final medal) => medal.price(progression.routePrice),
};

/// Steps still missing for the goal of [progress], which belongs to
/// [progression]. Zero when there is no goal or the reserve is enough;
/// a debt adds to it.
int stepsLeft(Progress progress, Progression progression) {
  final goal = progress.goal;
  if (goal == null) return 0;
  return max(0, priceOf(goal, progression) - progress.reserve);
}

/// Sets [goal], which belongs to [progression]. Spends nothing.
///
/// Throws [ChapterUnavailable] or [MedalUnavailable] if the goal cannot be
/// opened or bought next.
Progress selectGoal(Progress progress, Goal goal, Progression progression) {
  switch (goal) {
    case ChapterGoal(:final chapterId):
      if (!isChapterAvailable(progress, progression, chapterId)) {
        throw ChapterUnavailable(chapterId);
      }
    case MedalGoal(:final medal):
      if (medalOf(progress, progression)?.next != medal) {
        throw MedalUnavailable(progression.id);
      }
  }
  return progress.copyWith(goal: goal);
}
